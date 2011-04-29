/* SS - 081211.1 By: Bill Jiang */

DEFINE NEW SHARED VARIABLE domain_dom LIKE dom_domain.
DEFINE NEW SHARED VARIABLE userid_usr LIKE usr_userid.
DEFINE NEW SHARED VARIABLE lang_usr LIKE usr_lang.

{xsbcFrame.i}

define variable TempFileName as character.
define variable LicenseReg as character. /* �Ѿ�ע��Ŀ��õ�License */
define variable LicenseNow  as integer. /* ��ֹĿǰ���õ�License */
define variable passwd_usr like usr_passwd.
define variable canrun_mnd  like mnd_canrun.
DEFINE VARIABLE SoftspeedBarcode_OSUserID AS CHARACTER.
DEFINE VARIABLE CommandLine AS CHARACTER.
define variable Character01 as character.
DEFINE VARIABLE Integer01 AS INTEGER.

/* ��ǰ��Ͳ���ϵͳ�û� */
RUN xsbcDomain.p.
HIDE ALL NO-PAUSE.

IF domain_dom = "" THEN QUIT.

/* ע���ļ� */
{xsbcLic.i "SoftspeedBarcode.lic" "SoftspeedBarcode"}

/* ��ǰ���ݿ���Ȩ�û��� */
for each dom_mstr NO-LOCK
   WHERE dom_type <> "SYSTEM"
   AND dom_active = YES
   ,EACH code_mstr no-lock 
   where code_domain = dom_domain
   AND code_fldname = "SoftspeedBarcode_OSUserID" 
   :
   IF SoftspeedBarcode_OSUserID = "" THEN DO:
      SoftspeedBarcode_OSUserID = trim ( code_value ).
   END.
   ELSE DO:
      SoftspeedBarcode_OSUserID = SoftspeedBarcode_OSUserID + "|" + trim ( code_value ).
   END.
end.

/* �����ʱ�ļ����� */
RUN xsbcNow.p (OUTPUT TempFileName).
TempFileName = "TMPSSBC" + TempFileName.
RUN xsbcFileN.p (INPUT '', INPUT-OUTPUT TempFileName).

CommandLine  = "who -u |egrep -si " + """" + trim ( SoftspeedBarcode_OSUserID ) + """" + " > " + TempFileName + ".who".
unix silent value (CommandLine).

/* �����ֹĿǰ���õ�License */
LicenseNow = 0.
PROCEDURE getLicenseNow.
   INPUT FROM VALUE (TempFileName + ".who").
   DO WHILE TRUE:
      IMPORT UNFORMATTED Character01.
      LicenseNow = LicenseNow + 1.
   END.
   INPUT CLOSE.
END PROCEDURE.
RUN getLicenseNow.

/* �����Ѿ�ע��Ŀ��õ�License,�˳�  */
if LicenseNow > integer ( LicenseReg ) then do:     
   OS-DELETE VALUE(TempFileName + ".who").
   /* Exceeded the number of licensed users */
   {xsbcMsgB.i 2695}

   PAUSE 5.
   quit.
end.

/* �������ϵͳר�õ�QAD�û� */
FIND FIRST mfc_ctrl 
   WHERE mfc_domain = domain_dom 
   AND mfc_field = "SoftspeedBarcode_UserID"
   NO-LOCK
   NO-ERROR
   .
IF NOT AVAILABLE mfc_ctr THEN DO:
   /* No control table record found for */
   {xsbcMsgB.i 291}

   PAUSE 5.
   QUIT.
END.
find first usr_mstr 
   where usr_userid = mfc_char
   no-lock 
   no-error
   .
/* �Ҳ�������ϵͳר�õ�QAD�û�,�˳� */
if NOT available usr_mstr then do:
   /* End user not found */
   {xsbcMsgB.i 3612}

   PAUSE 5.
   quit.
end.

FIND FIRST udd_det 
   WHERE udd_userid = mfc_char 
   AND udd_domain = domain_dom 
   NO-LOCK NO-ERROR.
IF NOT AVAILABLE udd_det THEN DO:
   /* Domain is not assigned to the user */
   {xsbcMsgB.i 6170}

   PAUSE 5.
   quit.
END.

do transaction on error undo:
   ASSIGN
      titleLine = "Barcode System [xxbcmf.p] V081211.1"
      displayLine[1] = "Copyright 2008"
      displayLine[2] = "Softspeed Information Technology Ltd."
      displayLine[3] = "All rights reserved"
      displayLine[4] = STRING(LicenseNow) + " / " + TRIM(LicenseReg) + " User(s)"
      displayLine[5] = ""
      displayLine[6] = "Press any key to continue"
      updateLine = ""
      statusLine = ""
      .

   display 
      titleLine
      displayLine[1]
      displayLine[2]
      displayLine[3]
      displayLine[4]
      displayLine[5]
      displayLine[6]
      updateLine
      statusLine
      with frame a.
   
   pause 5 before-hide.

   for each usr_mstr EXCLUSIVE-LOCK where usr_userid = mfc_char:
      passwd_usr = usr_passwd .
      usr_passwd = encode (substring( ENCODE(usr_userid + "99" ),1,8)).
   end.
   
   for each mnd_det EXCLUSIVE-LOCK
      where mnd_nbr ="" 
      and mnd_select = 1 
      :
      canrun_mnd = mnd_canrun.
      mnd_canrun = mnd_canrun + "," + trim ( mfc_char ) .
   end.

   output to value(TempFileName + ".i") .
   PUT UNFORMATTED """" + trim(mfc_char) + """"  + " " + """" + substring(ENCODE(mfc_char + "99") ,1,8) + """" SKIP.
   /* ���� */
   FOR FIRST udd_det NO-LOCK
      WHERE udd_userid = mfc_char 
      AND udd_domain <> domain_dom 
      ,EACH dom_mstr NO-LOCK
      WHERE dom_domain = udd_domain
      AND dom_active = YES
      :
      EXPORT domain_dom.
   END.
   PUT UNFORMATTED "-" skip.
   PUT UNFORMATTED "P" SKIP.
   output close.

   input from value ( TempFileName + ".i") .
   output to  value ( TempFileName + ".o") . 
   run mf.p. 
   input close.
   output close.
   
   OS-DELETE VALUE(TempFileName + ".i").
   OS-DELETE VALUE(TempFileName + ".o").

   for each mnd_det EXCLUSIVE-LOCK
      where mnd_nbr ="" 
      and mnd_select = 1 
      :
      mnd_canrun = canrun_mnd.
   end.

   for each usr_mstr EXCLUSIVE-LOCK
      where usr_userid = mfc_char
      :
      usr_passwd = passwd_usr. 
   end.
end. /* do transaction on error undo: */

run xsbcmfa.p.

QUIT.
