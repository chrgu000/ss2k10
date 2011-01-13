/* xxme2cim.p - MENU to cimfile                                              */
/* Copyright 1986-2007 QAD Inc., GuangZhou, GD, CHA.                         */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*V8:ConvertMode=Maintenance                                                 */
/* $Revision:11Y1   BY:zhangyun        DATE: 11/01/13            ECO: *11Y1* */
/* $Revision End                                                             */

/* DISPLAY TITLE */
{mfdtitle.i "11Y1"}
{cxcustom.i "MGMEMT.P"}

define variable del-yn like mfc_logical initial no.
define variable newrec like mfc_logical.

define buffer mnddet for mnd_det.
define variable mndnbr like mnd_nbr.
define variable mntLabel      like mnt_det.mnt_label no-undo.
define variable execProcedure like mnd_det.mnd_uri no-undo.
DEFINE VARIABLE fname   AS CHARACTER FORMAT "x(40)".

{&MGMEMT-P-TAG1}

form
   lng_lang colon 15
   lng_desc at 35 NO-LABEL
   mndnbr   colon 15
   mntLabel at 35 no-label format "x(40)"
   skip(1)
   fname  colon 15
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{&MGMEMT-P-TAG2}

display
   global_user_lang @ lng_lang
with frame a.

repeat:
   view frame a.
   prompt-for lng_lang with frame a
   editing:
      {mfnp05.i lng_mstr lng_lang yes lng_lang "input lng_lang"}
      if recno <> ? then do:
         display lng_lang lng_desc with frame a.
      end.
   end.

   find lng_mstr using lng_lang no-lock.
   display lng_lang lng_desc with frame a.


   do on error undo, retry:
      if mndnbr <> "" then
         find first mnd_det where mnd_exec = mndnbr no-lock no-error.
      prompt-for mndnbr with frame a
      EDITING:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i mnd_det mnd_exec yes mnd_exec "input mndnbr"}

         if recno <> ? then do:
            display mnd_exec @ mndnbr with frame a.

            find mnt_det where mnt_nbr = mndnbr and mnt_select = mnd_select
               and mnt_lang = lng_lang no-lock no-error.

            if available mnt_det then do:
               mntLabel = mnt_label.
               display mntLabel with frame a.
            end.
            else
               display "" @ mntLabel with frame a.
         end.
       END. /*EDITING:*/
       assign mndnbr.
       if mndnbr = "" then do:
          {mfmsg.i 288 3}
          undo,retry.
       end.
     end. /*    do on error undo, retry: */

    do on error undo, retry:
      UPDATE fname with frame a.
      IF fname = "" THEN DO:
          {mfmsg.i 7772 3}
          UNDO,RETRY.
      END.
    end.
    if index(fname,".") = 0 then assign fname = fname + ".cim".
    output to value(fname).

    if index(substring(mndnbr,2),".") = 0 then do:
       for each mnd_det no-lock where (mnd_nbr = "0" /* or mnd_nbr = "A" */)
            and mnd_select = int(mndnbr),
           EACH mnt_det NO-LOCK WHERE mnt_lang = lng_lang
            AND mnt_nbr = mnd_nbr AND mnd_select = mnt_select:
           put unformat "@@batchload mgmemt.p" skip.
           put unformat lng_lang skip.
           put unformat mnd_nbr skip.
           put unformat mnd_select skip.
           put unformat '"' mnt_label '" "' mnd_name '" "'.
           put unformat mnd_exec '" "' mnd_help '"' skip.
           put unformat "." skip.
           put unformat "@@end" skip.
       end.
    end.

    put unformat "@@batchload mgmemt.p" skip.
    put unformat lng_lang skip.
    FOR EACH mnt_det NO-LOCK WHERE mnt_lang = lng_lang
                               AND mnt_nbr BEGINS mndnbr,
        EACH mnd_det NO-LOCK WHERE mnd_nbr = mnt_nbr
                               AND mnd_select = mnt_select:
            put unformat '"' mnt_nbr '"' skip.
            put unformat mnt_select skip.
            put unformat '"' mnt_label '" - "' mnd_exec '"' skip.
    END.
    PUT UNFORMAT "." SKIP.
    PUT UNFORMAT "." SKIP.
    put unformat "@@end" skip.

    output close.
END.

status input.
