/* fafamtb.p Menu-Entry (Option)                                            */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.13.1.15 $                                                   */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99   BY: *N021* Pat Pigatti      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 05/17/00   BY: *M0LJ* Vihang Talwalkar */
/* REVISION: 9.1      LAST MODIFIED: 07/28/00   BY: *N0BX* Arul Victoria   */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder    */
/* Revision: 1.13.1.9  BY: Kirti Desai DATE: 07/16/02 ECO: *N1MJ* */
/* Revision: 1.13.1.11  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00C* */
/* Revision: 1.13.1.13  BY: Dorota Hohol       DATE: 10/20/03 ECO: *P138* */
/* Revision: 1.13.1.14  BY: Robert Jensen      DATE: 09/02/04 ECO: *N2XK* */
/* $Revision: 1.13.1.15 $  BY: Vandna Rohira      DATE: 12/17/04 ECO: *P2Z5*     */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100419.1  By: Roger Xiao */  /*add validate logic in fafamth.p */
/* SS - 100521.1  By: Roger Xiao */  /*资产转移标准程式bug修复:无效的账户组合,new sub = old sub ,new cc = new loc cc */
/* SS - 100609.1  By: Roger Xiao */  /*暂时取消限制fa_custodian*/
/* SS - 100810.1  By: Roger Xiao */  /* add xxfabklog01.p 记录定期费用faba_acctype = "3" 账户和成本中心的更改情况*/

/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}
{cxcustom.i "FAFAMTB.P"}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

/* --------------------  Define Query  ------------------- */
define query q_fa_mstr for
   fa_mstr
   fields( fa_domain fa_code fa_custodian fa_desc1 fa_parent fa_po fa_receiver
          fa_split_date fa_split_from fa_vendsrc fa_wardt)
   scrolling.

/* -----------------  Standard Variables  ---------------- */
define output parameter l-flag like mfc_logical no-undo.

define new shared variable cmtindx like cmt_indx.

define variable p-status       as   character          no-undo.
define variable perform-status as   character format "x(25)"
   initial "first" no-undo.
define variable p-skip-update  like mfc_logical        no-undo.
define variable l-rowid        as   rowid              no-undo.
define variable l-delete-it    like mfc_logical        no-undo.
define variable l-del-rowid    as   rowid              no-undo.
define variable l-top-rowid    as   rowid              no-undo.
define variable lines          as   integer initial 10 no-undo.
define variable l-found        like mfc_logical        no-undo.
define variable pos            as   integer no-undo.
define variable l-first        like mfc_logical        no-undo.
define variable l-error        like mfc_logical        no-undo.
define variable l-title        as   character          no-undo.

/* ------------------  Button Variables  ----------------- */
define button b-update label "Update".
define button b-accts  label "Accts".
define button b-retire label "Retire".
define button b-tran   label "Tran".
define button b-cmmts  label "Cmmts".
define button b-user   label "User".
define button b-insur  label "Insur".
define button b-end    label "End".

/* -------------  Standard Widget Variables  ------------- */
define variable l-focus as widget-handle no-undo.
define variable w-frame as widget-handle no-undo.

/* ------------------  Screen Variables  ----------------- */
define shared variable l-key as character format "x(12)" no-undo.

define variable l-desc    as   character format "x(45)" no-undo.
define variable l-bk      like mfc_logical              no-undo.
define variable l-int     as   integer format "-99999"  no-undo.
define variable l-tx      like mfc_logical              no-undo.
define variable l-dispose like mfc_logical              no-undo.
define variable l-period  as   character format "x(6)"  no-undo.
{&FAFAMTB-P-TAG1}

/* ------------------  Frame Definition  ----------------- */
/* Added side-labels phrase to frame statement              */

define frame f-button
   b-update at 1
   b-accts at 10
   b-retire at 19
   b-tran at 28
   b-cmmts at 37
   b-user at 46
   b-insur at 55
   b-end at 64
with no-box overlay three-d side-labels width 73.

/* CLEAR FRAME REGISTRATION TO TRANSLATE THE FRAME EVERYTIME*/
clearFrameRegistration(frame f-button:handle).

/* SET EXTERNAL LABELS */
setFrameLabels(frame f-button:handle).

assign
   l-focus               = b-update:handle in frame f-button
   b-update:width        = 8
   b-update:private-data = "update"
   b-accts:width         = 8
   b-accts:private-data  = "accts"
   b-retire:width        = 8
   b-retire:private-data = "retire"
   b-tran:width          = 8
   b-tran:private-data   = "tran"
   b-cmmts:width         = 8
   b-cmmts:private-data  = "cmmts"
   b-user:width          = 8
   b-user:private-data   = "user"
   b-insur:width         = 8
   b-insur:private-data  = "insur"
   b-end:width           = 8
   b-end:private-data    = "end".

define frame f-1
   skip(.4)
   fa_code       colon 14  l-desc no-labels at 28
   fa_wardt      colon 14
   fa_parent     colon 14
   fa_vendsrc    colon 14  fa_receiver   colon 40  fa_po colon 61
   fa_custodian  colon 14
   fa_split_from colon 14  fa_split_date colon 40
with three-d overlay side-labels width 80.

/* CLEAR FRAME REGISTRATION TO TRANSLATE THE FRAME EVERYTIME*/
clearFrameRegistration(frame f-1:handle).

/* SET EXTERNAL LABELS */
setFrameLabels(frame f-1:handle).

run ip-framesetup.

w-frame = frame f-1:handle.
{gprun.i ""fafmtut.p""
   "(w-frame)"}

open query q_fa_mstr for each fa_mstr
    where fa_mstr.fa_domain = global_domain and  fa_id = l-key no-lock.

get first q_fa_mstr no-lock.

{&FAFAMTB-P-TAG2}

main-loop:
do while perform-status <> "end" on error undo:

   if {gpiswrap.i} then frame f-1:visible = yes.

   run ip-query
      (input-output perform-status,
       input-output l-rowid).

   if {gpiswrap.i} then hide frame f-1 no-pause.

   /* ----------------------  Accts  ---------------------- */
   if perform-status = "accts"
   then do:

      p-status = "display".
      if session:display-type = "gui"
      then
         assign
            fa_mstr.fa_code:bgcolor = 8
            fa_mstr.fa_code:fgcolor = 0.

/* SS - 100810.1 - B 
      {gprun.i ""fafamtf.p""}
   SS - 100810.1 - E */
/* SS - 100810.1 - B */
      {gprun.i ""xxfafamtf.p""}
/* SS - 100810.1 - E */

      if global-beam-me-up
      then
         undo, leave.

      assign
         p-status       = ""
         perform-status = "first".
      run ip-displayedits.
   end. /* IF perform-status = "accts" */
   /* --------------------  End Accts  -------------------- */

   /* ----------------------  Retire  --------------------- */
   if perform-status = "retire"
   then do:

      p-status = "display".
      if session:display-type = "gui"
      then
         assign
            fa_mstr.fa_code:bgcolor = 8
            fa_mstr.fa_code:fgcolor = 0.

      {gprun.i ""fafamti.p""}

      if global-beam-me-up
      then
         undo, leave.

      {&FAFAMTB-P-TAG3}

      assign
         p-status       = ""
         perform-status = "first".
      run ip-displayedits.
   end. /* IF perform-status = "retire" */

   /* --------------------  End Retire  ------------------- */

   /* -----------------------  Tran  ---------------------- */
   if perform-status = "tran"
   then do:

      p-status = "display".
      if session:display-type = "gui"
      then
         assign
            fa_mstr.fa_code:bgcolor = 8
            fa_mstr.fa_code:fgcolor = 0.

/* SS - 100521.1 - B 
      {gprun.i ""fafamto.p""
         "(output l-flag)"}
   SS - 100521.1 - E */
/* SS - 100521.1 - B */
      {gprun.i ""xxfafamto.p""
         "(output l-flag)"}
/* SS - 100521.1 - E */


      /* l-flag IS SET TO yes IN BATCH MODE IN PROGRAM fafamto.p */
      /* FOR AN ERROR ENCOUNTERED.                               */
      if l-flag
      then
         return.

      if global-beam-me-up
      then
         undo, leave.

      {&FAFAMTB-P-TAG4}
      assign
         p-status       = ""
         perform-status = "first".
      run ip-displayedits.
   end. /* IF perform-status = "tran" */
   /* ---------------------  End Tran  -------------------- */

   /* ----------------------  Cmmts  ---------------------- */
   if perform-status = "cmmts"
   then do:

      for first fa_mstr
         fields( fa_domain fa_cmtindx fa_code fa_custodian fa_desc1 fa_disp_dt
         fa_id
                fa_parent fa_po fa_post fa_receiver fa_split_date fa_split_from
                fa_vendsrc fa_wardt)
          where fa_mstr.fa_domain = global_domain and  fa_id = l-key
         no-lock:
      end. /* FOR FIRST fa_mstr */

      if not available fa_mstr
      then do:
         hide message no-pause.
         /* RECORD NOT FOUND */
         {pxmsg.i &MSGNUM=1310 &ERRORLEVEL=3}
         next main-loop.
      end. /* IF NOT AVAILABLE fa_mstr */
      else do:
         assign
            cmtindx        = fa_cmtindx
            perform-status = "first".

         {gprun.i ""gpcmmt03.p"" "(input ""fa_mstr"")"}

         if global-beam-me-up
         then
            undo, leave.

         get current q_fa_mstr exclusive-lock.

         if available fa_mstr
         then
            assign
               fa_mstr.fa_cmtindx = cmtindx
               perform-status     = "first".

         get current q_fa_mstr no-lock.
         next main-loop.
      end.  /* ELSE DO */
   end.  /* FOR FIRST fa_mstr */
   /* --------------------  END Cmmts  -------------------- */

   /* -----------------------  User  ---------------------- */
   if perform-status = "user"
   then do:
      p-status = "display".
      if session:display-type = "gui"
      then
         assign
            fa_mstr.fa_code:bgcolor = 8
            fa_mstr.fa_code:fgcolor = 0.

/* SS - 100419.1 - B 
      {gprun.i ""fafamth.p""}
   SS - 100419.1 - E */
/* SS - 100419.1 - B */
      {gprun.i ""xxfafamth.p""}
/* SS - 100419.1 - E */

      if global-beam-me-up
      then
         undo, leave.

      assign
         p-status       = ""
         perform-status = "first".

      run ip-displayedits.
   end. /* IF perform-status = "user" */
   /* ---------------------  End User  -------------------- */

   /* ----------------------  Insur  ---------------------- */
   if perform-status = "insur"
   then do:

      p-status = "display".
      if session:display-type = "gui"
      then
         assign
            fa_mstr.fa_code:bgcolor = 8
            fa_mstr.fa_code:fgcolor = 0.

      {gprun.i ""fafamtl.p""}

      if global-beam-me-up
      then
         undo, leave.

      assign
         p-status       = ""
         perform-status = "first".

      run ip-displayedits.
   end. /* IF perform-status = "insur" */
   /* --------------------  End Insur  -------------------- */

   /* ----------------------  Display  ---------------------- */
   run ip-predisplay.

   if (perform-status = "update"
   or perform-status = "add")
   then do:

      run ip-prompt.

      if global-beam-me-up
      then
         undo, leave.

      if perform-status = "undo"
      then do:
         perform-status = "first".
         next main-loop.
      end. /* IF perform-status = "undo" */

      run ip-displayedits.
   end. /* IF (perform-status = "update"  ... */

   /* -----------------------  End  ----------------------- */
   if perform-status = "end"
   then do:
      hide frame f-1 no-pause.
      delete PROCEDURE this-procedure no-error.
      leave.
   end. /* IF perform-status = "end" */

   /* ----------------  Selection Buttons  ---------------- */
   if perform-status <> "first"
   then
      run ip-button
         (input-output perform-status).

   /* -------------  After Strip Menu Include  ------------ */
   if perform-status = "retire"
   and fa_post = no
   then do:
      /* RETIRE NOT ALLOWED - ASSET HAS NOT BEEN POSTED */
      {pxmsg.i &MSGNUM=3203 &ERRORLEVEL=4}
      perform-status = "".
      next main-loop.
   end. /* IF perform-status = "retire" ... */

   if perform-status = "tran"
   and not fa_post
   then do:
      /* TRANSFER NOT ALLOWED - ASSET HAS NOT BEEN POSTED */
      {pxmsg.i &MSGNUM=3204 &ERRORLEVEL=4}
      perform-status = "".
      next main-loop.
   end. /* IF perform-status = "tran" ... */

   if perform-status = "tran"
   and fa_disp_dt <> ?
   then do:

      /* TRANSFER NOT ALLOWED - ASSET HAS BEEN RETIRED */
      {pxmsg.i &MSGNUM=3205 &ERRORLEVEL=4}
      perform-status = "".
      next main-loop.
   end. /* IF perform-status = "tran" ... */

   /* -----------  END After Strip Menu Include  ---------- */

end. /* MAIN-LOOP */

/* -------------  Add / Update / Field Edits  ------------ */
PROCEDURE ip-prompt:

   if perform-status = "add"
   then
      clear frame f-1 all no-pause.

   l-first = yes.
   CASE perform-status:
      when ("add")
      then
         /* ADDING NEW RECORD */
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      when ("update")
      then
         /* MODIFYING EXISTING RECORD */
         {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1}
      otherwise
         hide message no-pause.
   END CASE.

   ststatus = stline[3].
   status input ststatus.

   prompt-for-it:
   repeat:

      l-first = no.
      repeat:

         prompt-for
            fa_mstr.fa_code
            fa_mstr.fa_wardt
            fa_mstr.fa_parent
            fa_mstr.fa_vendsrc
            fa_mstr.fa_receiver
         with frame f-1.

/* SS - 100419.1 - B */
         if not {xxgpcode.v fa_code}
         then do:
            {pxmsg.i &MSGNUM=716 &ERRORLEVEL=4 }
            next-prompt fa_code .
            undo, retry .
         end.
/* SS - 100419.1 - E */

         /* FIELD EDIT FOR fa_parent */
         l-error = no.
         if input frame f-1 fa_parent <> ""
            and not can-find(first fa_mstr
             where fa_mstr.fa_domain = global_domain and  fa_id = input frame
             f-1 fa_parent)
         then do:
            /* INVALID ASSET ID */
            {pxmsg.i &MSGNUM=3206 &ERRORLEVEL=3}
            l-error = yes.
         end. /* IF INPUT FRAME f-1 fa_parent <> "" */
         else
         if can-find(first fa_mstr
             where fa_mstr.fa_domain = global_domain and  fa_id = input frame
             f-1 fa_parent
            and fa_parent = l-key)
         then do:
            /* PARENT ASSET CANNOT BE THE CHILD OF THIS ASSET */
            {pxmsg.i &MSGNUM=3202 &ERRORLEVEL=3}
            l-error = yes.
         end. /* IF CAN-FIND(FIRST fa_mstr */

         if l-error
         then do:
            next-prompt
               fa_parent
            with frame f-1.
            next.
         end. /* IF l-error */

         /* END FIELD EDIT FOR fa_parent */

         /* FIELD EDIT FOR fa_vendsrc */
         l-error = no.
         if input frame f-1 fa_vendsrc <> ""
         then do:

            for first ls_mstr
               fields( ls_domain ls_type ls_addr)
                where ls_mstr.ls_domain = global_domain and  ls_addr = input
                frame f-1 fa_vendsrc
               and ls_type = "supplier"
               no-lock:
            end. /* FOR FIRST ls_mstr */

            if not available ls_mstr
            then do:
               /* NOT A VALID SUPPLIER */
               {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}
               l-error = yes.
            end. /* IF NOT AVAILABLE ls_mstr */

         end. /* IF INPUT FRAME f-1 fa_vendsrc <> "" */

         if l-error
         then do:
            next-prompt
               fa_vendsrc
            with frame f-1.
            next.
         end. /* IF l-error */
         /* END FIELD EDIT FOR fa_vendsrc */

         /* FIELD EDIT FOR fa_receiver */
         l-error = no.
         if input frame f-1 fa_receiver <> ""
         then do:

            for first prh_hist
               fields( prh_domain prh_nbr prh_receiver prh_vend)
                where prh_hist.prh_domain = global_domain and  prh_receiver =
                input frame f-1 fa_receiver
               no-lock:
            end. /* FOR FIRST prh_hist */

            if available prh_hist
            then do:

               fa_po:screen-value = prh_nbr.
               if prh_vend <> input frame f-1 fa_vendsrc
               then do:
                  /* RECEIVER IS NOT FOR THIS SUPPLIER */
                  {pxmsg.i &MSGNUM=3232 &ERRORLEVEL=2}
               end. /* IF prh_vend <> input frame f-1 fa_vendsrc */

            end. /* IF AVAILABLE prh_hist */

            else do:
               /* INVALID RECEIVER */
               {pxmsg.i &MSGNUM=2205 &ERRORLEVEL=2}
            end. /* ELSE DO */

         end.  /* IF fa_receiver <> "" */

         if l-error
         then do:
            next-prompt
               fa_receiver
            with frame f-1.
            next.
         end. /* IF l-error */

         /* END FIELD EDIT FOR fa_receiver */

         leave.
      end. /* REPEAT */

      if global-beam-me-up
      then
         undo, leave.

      if keyfunction(lastkey) = "end-error"
      then do:

         perform-status = "undo".
         return no-apply.
      end. /* IF keyfunction(lastkey) = "end-error" */

      repeat:

         prompt-for
            fa_mstr.fa_po
            fa_mstr.fa_custodian
         with frame f-1.

         /* FIELD EDIT FOR fa_po */
         l-error = no.
         if input frame f-1 fa_po <> ""
         then do:

            for first po_mstr
               fields( po_domain po_nbr po_vend)
                where po_mstr.po_domain = global_domain and  po_nbr = input
                frame f-1 fa_po
               no-lock:
            end. /* FOR FIRST po_mstr */

            if not available po_mstr
            then do:
               /* NOT A VALID PURCHASE ORDER */
               {pxmsg.i &MSGNUM=343 &ERRORLEVEL=2}
            end. /* IF NOT AVAILABLE po_mstr */
            else
            if available po_mstr
               and po_vend <> input frame f-1 fa_vendsrc
            then do:
               /* PURCHASE ORDER IS NOT FOR THIS SUPPLIER */
               {pxmsg.i &MSGNUM=8410 &ERRORLEVEL=2}
            end. /* IF AVAILABLE po_mstr ... */

            for first prh_hist
               fields( prh_domain prh_nbr prh_receiver prh_vend)
                where prh_hist.prh_domain = global_domain and  prh_receiver =
                input frame f-1 fa_receiver
               no-lock:
            end. /* FOR FIRST prh_hist */

            if available prh_hist
               and prh_nbr <> input frame f-1 fa_po
            then do:
               /* PURCHASE ORDER IS NOT FOR THIS RECEIVER */
               {pxmsg.i &MSGNUM=8411 &ERRORLEVEL=2}
            end. /* IF AVAILABLE prh_hist */

         end. /* IF INPUT FRAME f-1 fa_po <> "" */

         if l-error
         then do:
            next-prompt
               fa_po
            with frame f-1.
            next.
         end. /* IF l-error */

         /* END FIELD EDIT FOR fa_po */

/* SS - 100419.1 - B */
/*暂时取消限制*/
/* SS - 100609.1 - B 
         find first emp_mstr where emp_domain = global_domain and emp_addr = (input fa_custodian) no-lock no-error.
         if not avail emp_mstr then do:
            {pxmsg.i &MSGNUM=520 &ERRORLEVEL=4 }
            next-prompt fa_custodian .
            undo, retry .
         end.
   SS - 100609.1 - E */
/* SS - 100419.1 - E */


         leave.
      end. /* REPEAT */

      if global-beam-me-up
      then
         undo, leave.

      if keyfunction(lastkey) = "end-error"
      then
         next prompt-for-it.

      leave.
   end. /* prompt-for-it */

   if global-beam-me-up
   then
      undo, leave.

   if keyfunction(lastkey) = "end-error"
   then do:

      if perform-status = "add"
      then do:
         /* RECORD NOT ADDED */
         {pxmsg.i &MSGNUM=1304 &ERRORLEVEL=1}
      end. /* IF perform-status = "add" */

      perform-status = "first".
      clear frame f-1.

      get current q_fa_mstr no-lock.
      run ip-displayedits.

      return.
   end. /* IF keyfunction(lastkey) = "end-error" */

   run ip-lock
      (input-output perform-status).

END PROCEDURE. /* ip-prompt */

/* -----------------------  Locking  ----------------------- */
PROCEDURE ip-lock:

   define input-output parameter perform-status as character no-undo.

   if perform-status = "add"
   or perform-status = "update"
   or perform-status = "delete"
   then
      ip-lock:
      do transaction on error undo:

         assign
            pos         = 0
            l-delete-it = yes.

      if available fa_mstr
      then
         get current q_fa_mstr no-lock.

      if available fa_mstr
      and current-changed fa_mstr
      then do:

         l-delete-it = yes.
         /* RECORD HAS BEEN MODIFIED SINCED YOU EDITED IT SAVE ANYWAY */
         {pxmsg.i &MSGNUM=2042 &ERRORLEVEL=1 &CONFIRM=l-delete-it
                  &CONFIRM-TYPE='LOGICAL'}

         if l-delete-it = no
         then do:
            hide message no-pause.
            run ip-displayedits.
            return.
         end. /* IF l-delete-it = no */

         hide message no-pause.
      end. /* iF AVAILABLE fa_mstr */

      if available fa_mstr
      then
         tran-lock:
         do while perform-status <> "":

            get current q_fa_mstr exclusive-lock no-wait.
            if locked fa_mstr
            then do:

               if pos < 3
               then do:
                  pos = pos + 1.
                  pause 1 no-message.
                  next tran-lock.
               end. /* IF pos < 3 */
               perform-status = "error".
            end. /* IF LOCKED fa_mstr */

         leave.
      end. /* DO WHILE perform-status <> "" */

      if (perform-status = "update"
      or p-status = "update")
      and l-delete-it = yes
      then
         run ip-update
            (input-output perform-status).

      if perform-status = "delete"
      then
         run ip-delete
            (input-output perform-status).

      if available fa_mstr
      then
         get current q_fa_mstr no-lock.

   end. /* IF perform-status = "add" */

   if perform-status = "add"
   then
      run ip-add
         (input-output perform-status).

END PROCEDURE. /* ip-lock */

PROCEDURE ip-update:

   define input-output parameter perform-status as character no-undo.

   if p-status = "update"
   then
      p-status = "".

   run ip-assign
      (input-output perform-status).
   {&FAFAMTB-P-TAG5}
   perform-status = "open".

   run ip-query
      (input-output perform-status,
      input-output l-rowid).

END PROCEDURE. /* ip-update */

PROCEDURE ip-add:

   define input-output parameter perform-status as character no-undo.

   create fa_mstr. fa_mstr.fa_domain = global_domain.

   run ip-assign
      (input-output perform-status).

   if recid(fa_mstr) = -1 then .

   perform-status = "open".

   run ip-query
      (input-output perform-status,
      input-output l-rowid).

   perform-status = "first".
   return.

END PROCEDURE. /* ip-add */

PROCEDURE ip-delete:

   define input-output parameter perform-status as character no-undo.

   l-delete-it = no.

   /* PLEASE CONFIRM DELETE */
   {mfmsg01.i 11 1 l-delete-it}
   {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=l-delete-it
            &CONFIRM-TYPE='LOGICAL'}

   CASE l-delete-it:
      when yes
      then do:

         hide message no-pause.
         delete fa_mstr.
         clear frame f-1 no-pause.
         get next q_fa_mstr no-lock.

         if available fa_mstr
         then
            assign
               perform-status = "first"
               l-rowid        = rowid(fa_mstr).
         else do:
            get prev q_fa_mstr no-lock.
            if available fa_mstr
            then
               assign
                  perform-status = "first"
                  l-rowid        = rowid(fa_mstr).
            else
               assign
                  perform-status = "first"
                  l-rowid        = rowid(fa_mstr).
         end. /* ELSE DO */

         /* RECORD DELETED */
         {pxmsg.i &MSGNUM=22 &ERRORLEVEL=1}
         return.

      end. /* WHEN yes */
      otherwise
         run ip-displayedits.

   END CASE.

END PROCEDURE. /* ip-delete */

PROCEDURE ip-assign:

   define input-output parameter perform-status as character no-undo.

   do with frame f-1:
      assign
         fa_mstr.fa_wardt
         fa_mstr.fa_parent
         fa_mstr.fa_vendsrc
         fa_mstr.fa_po
         fa_mstr.fa_custodian
         fa_mstr.fa_receiver
         fa_mstr.fa_code
         l-rowid = rowid(fa_mstr).

   end. /* DO WITH FRAME f-1 */

END PROCEDURE. /* ip-assign */

PROCEDURE ip-predisplay:

   if perform-status = ""
   and available fa_mstr
   then
      display-loop:
      do:
         clear frame f-1 all no-pause.
         run ip-displayedits.
         run ip-postdisplay.
      end. /* DO */

END PROCEDURE. /* ip-predisplay */

PROCEDURE ip-displayedits:

   if available fa_mstr
   then do:

      /* DISPLAY-EDITS */
      for first code_mstr
         fields( code_domain code_cmmt code_fldname code_value)
         no-lock
          where code_mstr.code_domain = global_domain and  code_fldname =
          "fa_code"
         and code_value = fa_mstr.fa_code:
      end. /* FOR FIRST code_mstr */

      l-desc = if available code_mstr
               then
                  code_cmmt
               else
                  "".
      /* DISPLAY-EDITS */

      run ip-display.
   end. /* IF AVAILABLE fa_mstr */

END PROCEDURE. /* ip-displayedits */

PROCEDURE ip-display:

   display
      l-desc
      fa_mstr.fa_wardt
      fa_mstr.fa_parent
      fa_mstr.fa_vendsrc
      fa_mstr.fa_po
      fa_mstr.fa_custodian
      fa_mstr.fa_receiver
      fa_mstr.fa_split_date
      fa_mstr.fa_split_from
      fa_mstr.fa_code
   with frame f-1.

END PROCEDURE. /* ip-display */

PROCEDURE ip-postdisplay:

   color display message fa_mstr.fa_code
   with frame f-1.

END PROCEDURE. /* ip-postdisplay */

PROCEDURE ip-query:

   define input-output parameter perform-status as character no-undo.
   define input-output parameter l-rowid        as rowid     no-undo.

   if perform-status = "first"
   then do:

      if l-rowid <> ?
      then do:
         reposition q_fa_mstr to rowid l-rowid no-error.
         get next q_fa_mstr no-lock.
      end. /* IF l-rowid <> ? */

      if not available fa_mstr
      then
         get first q_fa_mstr no-lock.

      if available fa_mstr
      then
         assign
            perform-status = ""
            l-rowid        = rowid(fa_mstr).
      else do:
         assign
            perform-status    = ""
            l-rowid           = ?
            frame f-1:visible = true.
         return.
      end. /* ELSE DO */
   end. /* IF perform-status = "first" */

   if perform-status = "open"
   then do:

      open query q_fa_mstr for each fa_mstr
          where fa_mstr.fa_domain = global_domain and  fa_id = l-key no-lock.

      reposition q_fa_mstr to rowid l-rowid no-error.
      get next q_fa_mstr no-lock.

      if available fa_mstr
      then
         assign
            perform-status = ""
            l-rowid        = rowid(fa_mstr).
      else do:
         get first q_fa_mstr no-lock.
         if not available fa_mstr
         then do:
            assign
               perform-status = ""
               frame f-1:visible = true.
            return.
         end. /* IF NOT AVAILABLE fa_mstr */
         else
            assign
               perform-status = ""
               l-rowid        = rowid(fa_mstr).
      end. /* ELSE DO */
   end. /* IF perform-status = "open" ... */

   if perform-status = "next"
   then do:

      get next q_fa_mstr no-lock.
      if available fa_mstr
      then do:
         assign
            l-rowid        = rowid(fa_mstr)
            perform-status = "first".
         hide message no-pause.
         run ip-displayedits.
      end. /* IF AVAILABLE fa_mstr */
      else do:
         perform-status = "".
         /* END OF FILE */
         {pxmsg.i &MSGNUM=20 &ERRORLEVEL=2}
         get prev q_fa_mstr no-lock.
      end. /* ELSE DO */

   end. /* IF perform-status = "next" */

   if perform-status = "prev"
   then do:

      get prev q_fa_mstr no-lock.
      if available fa_mstr
      then do:
         assign
            l-rowid        = rowid(fa_mstr)
            perform-status = "first".
         hide message no-pause.
         run ip-displayedits.
      end. /* IF AVAILABLE fa_mstr */
      else do:
         perform-status = "".
         /* BEGINNING OF FILE */
         {pxmsg.i &MSGNUM=21 &ERRORLEVEL=2}
         get next q_fa_mstr no-lock.
      end. /* ELSE DO */

   end. /* IF perform-status = "prev" */

   if perform-status = "update"
   or perform-status = "delete"
   then do:

      get current q_fa_mstr no-lock.
      if not available fa_mstr
      then do:
         hide message no-pause.
         /* RECORD NOT FOUND */
         {pxmsg.i &MSGNUM=1310 &ERRORLEVEL=3}
         perform-status = "".
      end. /* IF NOT AVAILABLE fa_mstr*/

   end. /* IF perform-status = "update" ... */

END PROCEDURE. /* ip-query */

PROCEDURE ip-framesetup:

   if session:display-type = "gui"
   then
      frame f-1:row = 4.5.
   else
      frame f-1:row = 4.

   assign
      frame f-1:box           = true
      frame f-1:centered      = true
      frame f-1:title         = (getFrameTitle("OPTION",16))
      frame f-button:centered = true
      frame f-button:row      = 20.

END PROCEDURE. /* ip-framesetup */

PROCEDURE ip-button:

   define input-output parameter perform-status as character
      format "x(25)" no-undo.

   if not batchrun
   then do:

      enable all with frame f-button.
      ststatus = stline[1].
      status input ststatus.

      on choose of b-update
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle.
         hide frame f-button no-pause.
      end. /* ON CHOOSE OF b-update */

      on choose of b-accts
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle
            l-title        = current-window:title + " - " + self:label.
         hide frame f-button no-pause.
      end. /* ON CHOOSE OF b-accts */

      on choose of b-retire
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle
            l-title        = current-window:title + " - " + self:label.
         hide frame f-button no-pause.
      end. /* ON CHOOSE OF b-retire */

      on choose of b-tran
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle
            l-title        = current-window:title + " - " + self:label.
         hide frame f-button no-pause.
      end. /* ON CHOOSE OF b-tran */

      on choose of b-cmmts
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle
            l-title        = current-window:title + " - " + self:label.
         hide frame f-button no-pause.
      end. /* ON CHOOSE OF b-cmmts */

      on choose of b-user
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle
            l-title        = current-window:title + " - " + self:label.
         hide frame f-button no-pause.
      end. /* ON CHOOSE OF b-user */

      on choose of b-insur
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle
            l-title        = current-window:title + " - " + self:label.
         hide frame f-button no-pause.
      end. /* ON CHOOSE OF b-insur */

      on choose of b-end
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle.
         hide frame f-1 no-pause.
         hide frame f-button no-pause.
      end. /* ON CHOOSE OF b-end */

      on cursor-up, f9 anywhere
      do:
         assign
            perform-status = "prev"
            l-focus        = focus:handle.
         apply "go" to frame f-button.
      end. /* ON CURSOR-UP,F9 ANYWHERE */

      on cursor-down, f10 anywhere
      do:
         assign
            perform-status = "next"
            l-focus        = focus:handle.
         apply "go" to frame f-button.
      end. /* ON CURSOR-DOWN, F10 ANYWHERE */

      on cursor-right anywhere
      do:
         l-focus = self:handle.
         apply "tab" to l-focus.
      end. /* ON CURSOR-RIGHT ANYWHERE */

      on cursor-left anywhere
      do:
         l-focus = self:handle.
         if session:display-type = "gui"
         then
            apply "shift-tab" to l-focus.
         else
            apply "ctrl-u" to l-focus.
      end. /* ON CURSOR-LEFT ANYWHERE */

      on esc anywhere
      do:
         if session:display-type = "gui"
         then
            apply "choose" to b-end in frame f-button.
      end. /* ON ESC ANYWHERE */

      on end-error anywhere
         apply "choose" to b-end in frame f-button.

      on window-close of current-window
         apply "choose" to b-end in frame f-button.

      on go anywhere
      do:
         if (lastkey = keycode("cursor-down")
         or lastkey = keycode("cursor-up")
         or lastkey = keycode("f9")
         or lastkey = keycode("f10"))
         then
            return.
         else
            l-focus = focus:handle.

         apply "choose" to l-focus.
      end. /* ON GO ANYWHERE */

      wait-for
         go of frame f-button or
         window-close of current-window or
         choose of
         b-update,
         b-accts,
         b-retire,
         b-tran,
         b-cmmts,
         b-user,
         b-insur,
         b-end
         focus
         l-focus.

   end. /* IF NOT BATCHRUN */
   else
      set perform-status.

   hide message no-pause.

END PROCEDURE. /* ip-button */
