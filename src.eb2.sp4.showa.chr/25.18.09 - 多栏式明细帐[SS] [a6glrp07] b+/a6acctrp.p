/* mgrnrp.p - REASON CODE REFERENCE REPORT                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* web convert mgrnrp.p (converter v1.00) Fri Oct 10 13:57:13 1997 */
/* web tag in mgrnrp.p (converter v1.00) Mon Oct 06 14:17:35 1997 */
/*F0PN*/ /*K1D1*/ /*                                                    */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 2.0     LAST MODIFIED: 03/04/88   BY: EMB */
/* REVISION: 4.0     LAST EDIT: 12/30/87       BY: WUG *A137* */
/* Revision: 7.3    Last edit: 11/19/92       By: jcd *G348* */
/* Revision: 8.6    Last edit: 12/10/97       By: bvm *K1D1* */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KR* myb              */

/*K1D1*/ /* DISPLAY TITLE */
/*K1D1*/  {mfdtitle.i "b+ "}

define variable acct like xxac_acctfrom LABEL "帐户" .
define variable acct1 like xxac_acctto.
define variable CODE1 like xxac_code LABEL "对应代码".
define variable code2 like xxac_code.
DEFINE VARIABLE flag LIKE xxac_drcr .
DEFINE VARIABLE flag1 LIKE xxac_drcr .
DEFINE VARIABLE name1 LIKE xxac_name.
DEFINE VARIABLE name2 LIKE xxac_name.
DEFINE VARIABLE sub LIKE xxac_subfrom.
DEFINE VARIABLE sub1 LIKE xxac_subto .

/*K1D1* /* DISPLAY TITLE */
 * {mfdtitle.i "b+ "} */

FORM
   code1          colon 25 LABEL "对应代码"
   code2          label {t001.i}
   flag           colon 25 LABEL "借方/贷方"
   flag1          LABEL {t001.i}
   name1          colon 25 LABEL "自定义帐户"
   name2          LABEL {t001.i}  
   acct           colon 25 LABEL "帐户"
   acct1          label {t001.i}
   sub            colon 25 LABEL "分帐户"
   sub1           LABEL {t001.i}          
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*K1D1*/ {wbrp01.i}

repeat:

   if acct1 = hi_char then acct1 = "".
   if code2 = hi_char then code2 = "".
   IF flag1 = hi_char THEN flag1 = "" .
   IF name2 = hi_char THEN name2 = "" .
   IF sub1 = hi_char  THEN sub1 = "" .

/*K1D1*/ if c-application-mode <> 'web' then
   UPDATE code1 code2 flag flag1 name1 name2 acct acct1 sub sub1 with frame a.

/*K1D1*/ {wbrp06.i &command = update &fields = " code1 code2 flag flag1 name1 name2 acct acct1 sub sub1 "
          &frm = "a"}

/*K1D1*/ if (c-application-mode <> 'web') or
/*K1D1*/ (c-application-mode = 'web' and
/*K1D1*/ (c-web-request begins 'data')) then do:

   if acct1 = "" then acct1 = hi_char.
   if code2 = "" then code2 = hi_char.
   IF flag1 = "" THEN flag1 = hi_char.
   IF name2 = "" THEN name2 = hi_char .
   IF sub1 = ""  THEN sub1 = hi_char .
/*K1D1*/ end.

   /* SELECT PRINTER */
   {mfselprt.i "printer" 80}
   {mfphead2.i}

   FOR EACH xxac_det WHERE xxac_code >= code1
                       AND xxac_code <= code2
                       AND xxac_drcr >= flag
                       AND xxac_drcr <= flag1
                       AND xxac_name >= name1
                       AND xxac_name <= name2
                       AND xxac_acctfrom >= acct
                       AND xxac_acctto  <= acct1
                       AND xxac_subfrom >= sub
                       AND xxac_subto   <= sub1
                       NO-LOCK WITH FRAME b WIDTH 80 NO-ATTR-SPACE:
        /* SET EXTERNAL LABELS */
        setFrameLabels(frame b:handle).
        {mfrpchk.i}         /*G348*/

        DISP 
           xxac_code      LABEL "对应代码"    FORMAT "x(10)"  
           xxac_code_desc LABEL "描述"        FORMAT "x(26)"  
           xxac_drcr      LABEL "借方/贷方"   FORMAT "x(10)"  
           xxac_name      LABEL "自定义帐户"  FORMAT "x(10)"  
           xxac_name_desc LABEL "描述"        FORMAT "x(26)"  
           xxac_acctfrom  LABEL "开始帐户"       FORMAT "x(10)"  
           xxac_acctto    LABEL "结束帐户"       FORMAT "x(10)"  
           xxac_subfrom   LABEL "开始分帐户" FORMAT "x(10)"  
           xxac_subto     LABEL "结束分帐户" FORMAT "x(10)"  
           .
   END.

   {mftrl080.i}
end.

/*K1D1*/ {wbrp04.i &frame-spec = a}
