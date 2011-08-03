/* mgmerp01.p - Menu Report Subprogram                                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.2.12 $                                                      */
/*V8:ConvertMode=Report                                                       */
/* REVISION 4.0       LAST MODIFIED:  12/27/88   BY: MLB  *A570*/
/* REVISION 5.0       LAST MODIFIED:  03/20/89   BY: MLB  *B073*/
/*                                    03/27/89   BY: WUG  *B075*/
/*                                    05/09/89   BY: WUG  *B109*/
/* REVISION 6.0       LAST MODIFIED:  08/28/90   BY: WUG  *D054*/
/*                                    10/18/90   BY: WUG  *D114*/
/*                                    06/27/91   BY: emb  *D730*/
/*                                    06/09/94   BY: rmh  *FO64*/
/*                                    09/05/94   BY: rmh  *FQ81*/
/* REVISION 8.5       LAST MODIFIED: 11/22/95   BY: *J094* Tom Vogten         */
/* REVISION 8.5       LAST MODIFIED: 01/08/97   BY: *G2K0* Cynthia Terry      */
/* REVISION 8.6       LAST MODIFIED: 12/09/97   BY: bvm  *K1CT*/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/27/00   BY: *N0DM* Rajinder Kamra     */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *N0W9* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7.2.6       BY: Jean Miller       DATE: 12/10/01  ECO: *P03H*  */
/* Revision: 1.7.2.7       BY: Jean Miller       DATE: 06/24/02  ECO: *P09H*  */
/* Revision: 1.7.2.11      BY: Deepak Rao        DATE: 12/31/02  ECO: *N237*  */
/* $Revision: 1.7.2.12 $   BY: Jean Miller       DATE: 09/02/04  ECO: *Q0CP*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* 以下为版本历史 */
/* SS - 090414.1 By: Bill Jiang */
/* SS - 090120.1 By: Bill Jiang */

{mfdeclre.i}
{cxcustom.i "MGMERP01.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{wbrp02.i}

define shared variable lang like lng_lang.
define shared variable menunbr as character.
define shared variable nbr as integer format ">9".
define shared variable nbr1 as integer format ">9".
define shared variable sel_password as character.

define variable install   like mfc_logical format "/no" no-undo.
define variable thismenu  as character no-undo.
define variable run_file  as character no-undo.
define variable i         as integer no-undo.
define variable j         as integer no-undo.
define variable apassword as character no-undo.
define variable passwords as character no-undo.
define variable cando_passwords as character no-undo.
define variable last_execname like execname no-undo.

define buffer mnddet for mnd_det.

/* SS - 090414.1 - B */
DEFINE SHARED VARIABLE exec LIKE mnd_exec.
DEFINE SHARED VARIABLE exec1 LIKE mnd_exec.

define buffer mnddet2 for mnd_det.
FOR EACH mnd_det NO-LOCK
   WHERE mnd_nbr = "0"
   BY mnd_nbr
   BY mnd_select
   :
   FIND FIRST mnddet
      WHERE mnddet.mnd_nbr = mnd_det.mnd_exec
      NO-LOCK NO-ERROR.
   IF NOT AVAILABLE mnddet THEN DO:
      IF mnd_det.mnd_exec >= exec AND  mnd_det.mnd_exec <= exec1 THEN DO:
         RUN GetVer (INPUT mnd_det.mnd_exec).
      END.
   END.
   ELSE DO:
      RUN ExportMenu (INPUT mnd_det.mnd_exec).
   END.
END.

PROCEDURE ExportMenu:
   DEFINE INPUT PARAMETER nbr_mnd LIKE mnd_nbr.

   FOR EACH mnddet NO-LOCK
      WHERE mnddet.mnd_nbr = nbr_mnd
      BY mnd_nbr
      BY mnd_select
      :
      FIND FIRST mnddet2
         WHERE mnddet2.mnd_nbr = mnddet.mnd_exec
         NO-LOCK NO-ERROR.
      IF NOT AVAILABLE mnddet2 THEN DO:
         IF mnddet.mnd_exec >= exec AND mnddet.mnd_exec <= exec1 THEN DO:
            RUN GetVer (INPUT mnddet.mnd_exec).
         END.
      END.
      ELSE DO:
         RUN ExportMenu (INPUT mnddet.mnd_exec).
      END.
   END.
END PROCEDURE.

PROCEDURE GetVer:
   DEFINE INPUT PARAMETER exec_mnd LIKE mnd_exec.

   DEFINE VARIABLE c1 AS CHARACTER.

   c1 = global_user_lang_dir + substring(exec_mnd,1,2) + '/' + exec_mnd.
   IF SEARCH(c1) = ? THEN do:
      IF SEARCH(REPLACE(c1, ".p", ".r")) = ? THEN do:
         RETURN.
      END.
   END.

   OUTPUT TO VALUE("TMP" + execname + ".i").
   PUT "." SKIP.
   OUTPUT CLOSE.

   INPUT FROM VALUE("TMP" + execname + ".i").
   OUTPUT TO VALUE("TMP" + execname + ".o").
   {gprun.i "exec_mnd"}
   INPUT CLOSE.
   OUTPUT CLOSE.

   INPUT FROM VALUE("TMP" + execname + ".o").
   IMPORT UNFORMATTED c1 NO-ERROR.
   INPUT CLOSE.

   c1 = ENTRY(2, c1, " ").
   IF INDEX(c1, ".") > 0 THEN DO:
      c1 = ENTRY(1, c1, ".") + "." + ENTRY(2, c1, ".").
   END.
   EXPORT DELIMITER "~011" exec_mnd c1.

   OS-DELETE VALUE("TMP" + execname + ".i").
   OS-DELETE VALUE("TMP" + execname + ".o").
END PROCEDURE.
/* SS - 090414.1 - E */

/* SS - 090414.1 - B
last_execname = execname.
{&MGMERP01-P-TAG1}

if integer(substring(menunbr, 1, 2)) >= nbr and
   integer(substring(menunbr, 1, 2)) <= nbr1
then do:

   if page-size - line-counter < 6 then page.

   find first mnd_det where mnd_exec = menunbr no-lock no-error.

   if available mnd_det then do:

      find mnt_det where mnt_nbr = mnd_nbr
                     and mnt_select = mnd_select
                     and mnt_lang = lang
      no-lock no-error.

      if available mnt_det then
         put
            skip(1)
            {gplblfmt.i &FUNC=getTermLabel(""MENU_NUMBER"",20) &CONCAT="': '"}
            menunbr
            mnt_label
            skip.
      else
         put
            skip(1)
            {gplblfmt.i &FUNC=getTermLabel(""MENU_NUMBER"",20) &CONCAT="': '"}
            menunbr
            skip.
   end.

end.

for each mnd_det no-lock where
   integer(substring(mnd_nbr, 1, 2)) >= nbr  and
   integer(substring(mnd_nbr, 1, 2)) <= nbr1 and
   mnd_nbr = menunbr
use-index mnd_nbr with frame b:

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame b:handle).

   install = yes.

   /* Replaced mfmenu1.i */
   if mnd_exec > "9999" then do:

      thismenu = mnd_nbr.
      execname = mnd_exec.

      if thismenu <> "" then do:

         run_file = thismenu.

         i = index(run_file,".").
         do while i > 0:
            if opsys = "unix" then do:
               run_file = substring(run_file,1,i - 1) + "/" +
                          substring(run_file,i + 1,length (run_file)).
            end.
            else if opsys = "msdos" or opsys = "win32" then do:
               run_file = substring(run_file,1,i - 1) + "~\" +
                          substring(run_file,i + 1,length (run_file)).
            end.
            i = index(run_file,".").
         end.

         /* Build directory name */
         if opsys = "unix" then
            run_file = run_file + "/" + execname.
         else if opsys = "msdos" or opsys = "win32" then
            run_file = run_file + "~\" + execname.
      end.
      else
         run_file = execname.

      run_file = execname.

      if index(run_file,".p") > 0 then
         run_file = substring(run_file,1,index(run_file,".p") - 1).
      if index(run_file,".w") > 0 then
         run_file = substring(run_file,1,index(run_file,".w") - 1).

      run_file = substring(run_file,1,2) + "/" + run_file.

      if search(run_file + ".r") = ?
         and search(run_file + ".p") = ?
         and search(run_file + ".w") = ?
      then do:
         /* NOW LOOK IN THE MAIN DIRECTORY */
         run_file = substring(run_file,4,50).
         if search(run_file + ".r") = ?
            and search(run_file + ".p") = ?
            and search(run_file + ".w") = ?
         then do:
            install = no.
         end.
      end.

   end.

   if sel_password = ""
   or can-do(mnd_canrun + ",!*",sel_password)
   then do:

      if no then
         display
            mnd_select
            mnt_label
            mnd_name
            mnd_exec
            mnd_help
            install label "Installed"
         with frame b down width 132.

      display
         mnd_select
         mnd_name
         mnd_exec
         mnd_help
         install label "Installed"
      with frame b.

      find mnt_det where mnt_nbr = mnd_nbr
                     and mnt_select = mnd_select
                     and mnt_lang = lang
      no-lock no-error.

      if available mnt_det then
         display
            mnt_label
         with frame b.
      else
         display
            "" @ mnt_label
         with frame b.

   end.

   if sel_password = "" or
      can-do(mnd_canrun + ",!*",sel_password)
   then do:

      passwords = mnd_canrun.
      cando_passwords = "".
      j = 0.

      do while index(passwords,",") > 0:
         apassword = substring(passwords,1,index(passwords,",") - 1).
         if can-do(apassword,sel_password)
         or sel_password = ""
         then do:

            j = j + 1.
            if j > 1 then cando_passwords = cando_passwords + ",".
            cando_passwords = cando_passwords + apassword.
         end.
         passwords = substring(passwords,index(passwords,",") + 1,1000).
      end.

      if passwords <> "" then do:
         if sel_password = ""
         or can-do(passwords,sel_password)
         then do:
            j = j + 1.
            if j > 1 then cando_passwords = cando_passwords + ",".
            cando_passwords = cando_passwords + passwords.
         end.
      end.

      display
         cando_passwords format "x(24)" label "User IDs/Groups"
      with frame b.

   end.

   {&MGMERP01-P-TAG2}

   {mfrpchk.i}

end.

for each mnd_det no-lock where
   mnd_nbr = menunbr and
   mnd_exec <> "" and
   (sel_password = "" or can-do(mnd_canrun + ",!*",sel_password))
use-index mnd_nbr:

   find first mnddet where mnddet.mnd_nbr = mnd_det.mnd_exec
   no-lock no-error.

   {mfrpchk.i}

   if available mnddet then do:
      menunbr = mnd_det.mnd_exec.
      {gprun.i ""mgmerp01.p""}
   end.

end.

execname = last_execname.
SS - 090414.1 - E */

{wbrp04.i}
