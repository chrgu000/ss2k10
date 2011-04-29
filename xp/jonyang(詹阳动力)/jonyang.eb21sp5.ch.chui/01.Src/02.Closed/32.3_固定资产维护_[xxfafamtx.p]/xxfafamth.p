/* fafamth.p - FIXED ASSET MAINTENANCE - User Field Maintenance             */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.13.1.11 $                                                         */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99   BY: *N021* Pat Pigatti      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 05/17/00   BY: *M0LJ* Vihang Talwalkar */
/* REVISION: 9.1      LAST MODIFIED: 07/28/00   BY: *N0BX* Arul Victoria   */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder    */
/* Revision: 1.13.1.10  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00C* */
/* $Revision: 1.13.1.11 $    BY: Vandna Rohira         DATE: 12/17/04  ECO: *P2Z5*  */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100419.1  By: Roger Xiao */  /*add validate logic in fafamth.p */


/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* --------------------  Define Query  ------------------- */
define query q_fa_mstr for
   fa_mstr
   fields( fa_domain
   fa__chr01
   fa__chr02
   fa__chr03
   fa__chr04
   fa__dec01
   fa__dec02
   fa__dte01
   fa__dte02
   fa__dte03
   fa__dte04
   fa__int01
   fa__int02
   fa__int03
   fa__int04)
   scrolling.

/* -----------------  Standard Variables  ---------------- */
define variable p-status as character no-undo.
define variable perform-status as character format "x(25)"
   initial "first" no-undo.
define variable p-skip-update like mfc_logical no-undo.
define variable l-rowid as rowid no-undo.
define variable l-delete-it like mfc_logical no-undo.
define variable l-del-rowid as rowid no-undo.
define variable l-top-rowid as rowid no-undo.
define variable lines as integer initial 10 no-undo.
define variable l-found like mfc_logical no-undo.
define variable pos as integer no-undo.
define variable l-first like mfc_logical no-undo.
define variable l-error like mfc_logical no-undo.
define variable l-title as character no-undo.

/* ------------------  Button Variables  ----------------- */
define button b-update label "Update".
define button b-end label "End".

/* -------------  Standard Widget Variables  ------------- */
define variable l-focus as widget-handle no-undo.
define variable w-frame as widget-handle no-undo.

/* ------------------  Screen Variables  ----------------- */
define shared variable l-key as character format "x(12)" no-undo.

/* ------------------  Frame Definition  ----------------- */
/* Added side-labels phrase to frame statement              */

define frame f-button
   b-update at 1
   b-end at 10
with no-box overlay three-d side-labels width 19.

/* CLEAR FRAME REGISTRATION TO TRANSLATE THE FRAME EVERYTIME*/
clearFrameRegistration(frame f-button:handle).

/* SET EXTERNAL LABELS */
setFrameLabels(frame f-button:handle).

assign
   l-focus = b-update:handle in frame f-button
   b-update:width = 8
   b-update:private-data = "update"
   b-end:width = 8
   b-end:private-data = "end".

define frame f-1
   skip(.4)
   fa__chr01 label "Char 1" colon 13
   fa__dte01 label "Date 1" colon 34
   fa__int01 label "Integer 1" colon 58
   skip
   fa__chr02 label "Char 2" colon 13
   fa__dte02 label "Date 2" colon 34
   fa__int02 label "Integer 2" colon 58
   skip
   fa__chr03 label "Char 3" colon 13
   fa__dte03 label "Date 3" colon 34
   fa__int03 label "Integer 3" colon 58
   skip
   fa__chr04 label "Char 4" colon 13
   fa__dte04 label "Date 4" colon 34
   fa__int04 label "Integer 4" colon 58
   skip(1)
   fa__dec01 label "Decimal 1" colon 13
   fa__dec02 label "Decimal 2" colon 58
with three-d overlay side-labels width 80.

/* CLEAR FRAME REGISTRATION TO TRANSLATE THE FRAME EVERYTIME*/
clearFrameRegistration(frame f-1:handle).

/* SET EXTERNAL LABELS */
setFrameLabels(frame f-1:handle).

run ip-framesetup.

assign
   w-frame = frame f-1:handle.
{gprun.i ""fafmtut.p""
   "(w-frame)"}

open query q_fa_mstr for each fa_mstr
   where fa_mstr.fa_domain = global_domain and  fa_id = l-key
no-lock.

get first q_fa_mstr no-lock.

main-loop:
do while perform-status <> "end" on error undo:

   run ip-query
      (input-output perform-status,
      input-output l-rowid).

   /* ----------------------  Display  ---------------------- */
   run ip-predisplay.

   if (perform-status = "update" or
      perform-status = "add")
   then do:
      run ip-prompt.
      if global-beam-me-up
      then
         undo, leave.
      if perform-status = "undo"
      then do:
         assign
            perform-status = "first".
         next main-loop.
      end.  /* IF perform-status = "undo"  */
      run ip-displayedits.
   end.  /* IF (perform-status = "update" OR ... */

   /* -----------------------  End  ----------------------- */
   if perform-status = "end"
   then do:
      hide frame f-1 no-pause.
      delete PROCEDURE this-procedure no-error.
      leave.
   end.  /* IF perform-status = "end"  */

   /* ----------------  Selection Buttons  ---------------- */
   if perform-status <> "first"
   then
      run ip-button
         (input-output perform-status).

end.  /* MAIN-LOOP */

/* -------------  Add / Update / Field Edits  ------------ */
PROCEDURE ip-prompt:
   if perform-status = "add"
   then
      clear frame f-1 all no-pause.
   assign
      l-first = yes.
   CASE perform-status:
      when ("add")
      then
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}       /* ADDING NEW RECORD */
      when ("update")
      then
         {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1}      /* MODIFYING EXISTING RECORD */
      otherwise
         hide message no-pause.
   END CASE.
   assign
      ststatus = stline[3].
   status input ststatus.
   prompt-for-it:
   repeat:
      assign
         l-first = no.
      repeat:
         prompt-for
            fa_mstr.fa__chr01
            fa_mstr.fa__dte01
            fa_mstr.fa__int01
            fa_mstr.fa__chr02
            fa_mstr.fa__dte02
            fa_mstr.fa__int02
            fa_mstr.fa__chr03
            fa_mstr.fa__dte03
            fa_mstr.fa__int03
            fa_mstr.fa__chr04
            fa_mstr.fa__dte04
            fa_mstr.fa__int04
            fa_mstr.fa__dec01
            fa_mstr.fa__dec02
         with frame f-1.

/* SS - 100419.1 - B */
         if not {xxgpcode.v fa__chr01}
         then do:
            {pxmsg.i &MSGNUM=716 &ERRORLEVEL=4 }
            next-prompt fa__chr01 .
            undo, retry .
         end.

         if not {xxgpcode.v fa__chr02}
         then do:
            {pxmsg.i &MSGNUM=716 &ERRORLEVEL=4 }
            next-prompt fa__chr02 .
            undo, retry .
         end.

         if not {xxgpcode.v fa__chr03}
         then do:
            {pxmsg.i &MSGNUM=716 &ERRORLEVEL=4 }
            next-prompt fa__chr03 .
            undo, retry .
         end.

         if not {xxgpcode.v fa__chr04}
         then do:
            {pxmsg.i &MSGNUM=716 &ERRORLEVEL=4 }
            next-prompt fa__chr04 .
            undo, retry .
         end.
/* SS - 100419.1 - E */


         leave.
      end.  /* REPEAT */
      if global-beam-me-up
      then
         undo, leave.
      if keyfunction(lastkey) = "end-error"
      then do:
         assign
            perform-status = "undo".
         return no-apply.
      end.  /* IF keyfunction(lastkey) = "end-error"  */
      leave.
   end. /* PROMPT-FOR-IT */
   if global-beam-me-up
   then
      undo, leave.
   if keyfunction(lastkey) = "end-error"
   then do:
      if perform-status = "add"
      then do:
         {pxmsg.i &MSGNUM=1304 &ERRORLEVEL=1}     /* RECORD NOT ADDED */
      end.  /* IF perform-status = "add"  */
      assign
         perform-status = "first".
      clear frame f-1.
      get current q_fa_mstr no-lock.
      run ip-displayedits.
      return.
   end.  /* IF keyfunction(lastkey) = "end-error"  */
   run ip-lock
      (input-output perform-status).
END PROCEDURE. /* ip-prompt */

/* -----------------------  Locking  ----------------------- */
PROCEDURE ip-lock:
   define input-output parameter perform-status as character no-undo.

   if perform-status = "add" or
      perform-status = "update" or
      perform-status = "delete"
   then
      ip-lock:
      do transaction on error undo:
         assign
            pos = 0
            l-delete-it = yes.

         if available fa_mstr
         then
            get current q_fa_mstr no-lock.
         if available fa_mstr and
            current-changed fa_mstr
         then do:
            assign
               l-delete-it = yes.
            /* RECORD HAS BEEN MODIFIED SINCED YOU EDITED IT
            SAVE ANYWAY */
            {pxmsg.i &MSGNUM=2042 &ERRORLEVEL=1 &CONFIRM=l-delete-it}
            if l-delete-it = no
            then do:
               hide message no-pause.
               run ip-displayedits.
               return.
            end.  /* IF l-delete-it = no  */
            hide message no-pause.
         end.  /* IF AVAILABLE fa_mstr AND ... */
         if available fa_mstr
         then
            tran-lock:
            do while perform-status <> "":
               get current q_fa_mstr exclusive-lock no-wait.
               if locked fa_mstr
               then do:
                  if pos < 3
                  then do:
                     assign pos = pos + 1.
                     pause 1 no-message.
                     next tran-lock.
                  end.  /* IF pos < 3  */
                  assign
                     perform-status = "error".
               end.  /* IF LOCKED fa_mstr  */
               leave.
            end. /*WHILE*/

         if (perform-status = "update" or
            p-status = "update") and
            l-delete-it = yes
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
      end.  /* IP-LOCK */
      if perform-status = "add"
      then
         run ip-add.
END PROCEDURE. /* ip-lock */

PROCEDURE ip-update:
   define input-output parameter perform-status as character no-undo.

   if p-status = "update"
   then
      assign
         p-status = "".
   run ip-assign
      (input-output perform-status).
   assign
      perform-status = "open".
   run ip-query
      (input-output perform-status,
      input-output l-rowid).
END PROCEDURE. /* ip-update */

PROCEDURE ip-add:
   define input-output parameter perform-status as character no-undo.

   create fa_mstr.
   fa_mstr.fa_domain = global_domain.
   run ip-assign
      (input-output perform-status).
   assign
      perform-status = "open".
   run ip-query
      (input-output perform-status,
      input-output l-rowid).
   assign
      perform-status = "first".
   return.
END PROCEDURE. /* ip-add */

PROCEDURE ip-delete:
   define input-output parameter perform-status as character no-undo.
   assign
      l-delete-it = no.
   {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=l-delete-it}
   /* PLEASE CONFIRM DELETE */
   CASE l-delete-it:
      when yes
      then do:
         hide message no-pause.
         delete fa_mstr.
         clear frame f-1 no-pause.
         get next q_fa_mstr no-lock.
         if available fa_mstr
         then do:
            assign
               perform-status = "first"
               l-rowid = rowid(fa_mstr).
         end.  /* IF AVAILABLE fa_mstr  */
         else do:
            get prev q_fa_mstr no-lock.
            if available fa_mstr
            then do:
               assign
                  perform-status = "first"
                  l-rowid = rowid(fa_mstr).
            end.  /* IF AVAILABLE fa_mstr  */
            else
               assign
                  perform-status = "first"
                  l-rowid = rowid(fa_mstr).
         end.  /* IF NOT AVAILABLE fa_mstr  */
         {pxmsg.i &MSGNUM=22 &ERRORLEVEL=1}      /* RECORD DELETED */
         return.
      end.  /* WHEN YES */
      otherwise
         run ip-displayedits.
   END CASE.
END PROCEDURE. /* ip-delete */

PROCEDURE ip-assign:
   define input-output parameter perform-status as character no-undo.
   do with frame f-1:
      assign
         fa_mstr.fa__chr03
         fa_mstr.fa__int02
         fa_mstr.fa__dte02
         fa_mstr.fa__chr02
         fa_mstr.fa__int01
         fa_mstr.fa__dte01
         fa_mstr.fa__chr01
         fa_mstr.fa__dte03
         fa_mstr.fa__int03
         fa_mstr.fa__chr04
         fa_mstr.fa__dte04
         fa_mstr.fa__int04
         fa_mstr.fa__dec01
         fa_mstr.fa__dec02
         l-rowid = rowid(fa_mstr).

   end.  /* DO WITH FRAME f-1: */
END PROCEDURE. /* ip-assign */

PROCEDURE ip-predisplay:
   if perform-status = "" and
      available fa_mstr
   then
      display-loop:
      do:
         clear frame f-1 all no-pause.
         run ip-displayedits.
         run ip-postdisplay.
      end.  /* DISPLAY-LOOP */
END PROCEDURE. /* ip-predisplay */

PROCEDURE ip-displayedits:
   if available fa_mstr
   then do:
      run ip-display.
   end.  /* IF AVAILABLE fa_mstr  */
END PROCEDURE. /* ip-displayedits */

PROCEDURE ip-display:
   display
      fa_mstr.fa__chr03
      fa_mstr.fa__int02
      fa_mstr.fa__dte02
      fa_mstr.fa__chr02
      fa_mstr.fa__int01
      fa_mstr.fa__dte01
      fa_mstr.fa__chr01
      fa_mstr.fa__dte03
      fa_mstr.fa__int03
      fa_mstr.fa__chr04
      fa_mstr.fa__dte04
      fa_mstr.fa__int04
      fa_mstr.fa__dec01
      fa_mstr.fa__dec02
   with frame f-1.
END PROCEDURE. /* ip-display */

PROCEDURE ip-postdisplay:
   color display message fa__chr01
   with frame f-1.

END PROCEDURE. /* ip-postdisplay */

PROCEDURE ip-query:
   define input-output parameter perform-status as character
      no-undo.
   define input-output parameter l-rowid as rowid no-undo.

   if perform-status = "first"
   then do:
      if l-rowid <> ?
      then do:
         reposition q_fa_mstr to rowid l-rowid no-error.
         get next q_fa_mstr no-lock.
      end.  /* IF l-rowid <> ?  */
      if not available fa_mstr
      then
         get first q_fa_mstr no-lock.
      if available fa_mstr
      then
         assign
            perform-status = ""
            l-rowid = rowid(fa_mstr).
      else do:
         assign
            perform-status = ""
            l-rowid = ?.
         assign
            frame f-1:visible = true.
         return.
      end.  /* IF NOT AVAILABLE fa_mstr  */
   end.  /* IF perform-status = "first"  */
   if perform-status = "open"
   then do:
      open query q_fa_mstr for each fa_mstr
         where fa_mstr.fa_domain = global_domain and  fa_id = l-key
      no-lock.

      reposition q_fa_mstr to rowid l-rowid no-error.
      get next q_fa_mstr no-lock.
      if available fa_mstr
      then
         assign
            perform-status = ""
            l-rowid = rowid(fa_mstr).
      else do:
         get first q_fa_mstr no-lock.
         if not available fa_mstr
         then do:
            assign
               perform-status = ""
               frame f-1:visible = true.
            return.
         end.  /* IF NOT AVAILABLE fa_mstr  */
         else
            assign
               perform-status = ""
               l-rowid = rowid(fa_mstr).
      end.  /* IF NOT AVAILABLE fa_mstr  */
   end.  /* IF perform-status = "open"  */
   if perform-status = "next"
   then do:
      get next q_fa_mstr no-lock.
      if available fa_mstr
      then do:
         assign
            l-rowid = rowid(fa_mstr)
            perform-status = "first".
         hide message no-pause.
         run ip-displayedits.
      end.  /* IF AVAILABLE fa_mstr  */
      else do:
         assign
            perform-status = "".
         {pxmsg.i &MSGNUM=20 &ERRORLEVEL=2}     /* END OF FILE */
         get prev q_fa_mstr no-lock.
      end.  /* IF NOT AVAILABLE fa_mstr  */
   end.  /* IF perform-status = "next"  */
   if perform-status = "prev"
   then do:
      get prev q_fa_mstr no-lock.
      if available fa_mstr
      then do:
         assign
            l-rowid = rowid(fa_mstr)
            perform-status = "first".
         hide message no-pause.
         run ip-displayedits.
      end.  /* IF AVAILABLE fa_mstr  */
      else do:
         assign
            perform-status = "".
         {pxmsg.i &MSGNUM=21 &ERRORLEVEL=2}    /* BEGINNING OF FILE */
         get next q_fa_mstr no-lock.
      end.  /* IF AVAILABLE fa_mstr  */
   end.  /* IF perform-status = "prev"  */
   if perform-status = "update" or
      perform-status = "delete"
   then do:
      get current q_fa_mstr no-lock.
      if not available fa_mstr
      then do:
         hide message no-pause.
         {pxmsg.i &MSGNUM=1310 &ERRORLEVEL=3}        /* RECORD NOT FOUND */
         assign
            perform-status = "".
      end.  /* IF NOT AVAILABLE fa_mstr  */
   end.  /* IF perform-status = "update" or */
END PROCEDURE. /* ip-query */

PROCEDURE ip-framesetup:

   if session:display-type = "gui"
   then
      assign
         frame f-1:row = 4.5.
   else
      assign
         frame f-1:row = 4.

   assign
      frame f-1:box = true
      frame f-1:centered = true
      frame f-1:title = (getFrameTitle("USER_FIELD_MAINTENANCE",32))
      frame f-button:centered = true
      frame f-button:row = 20.

END PROCEDURE. /* ip-framesetup */

PROCEDURE ip-button:
   define input-output parameter perform-status as character
      format "x(25)" no-undo.

   if not batchrun
   then do:

      enable all with frame f-button.
      assign
         ststatus = stline[1].
      status input ststatus.

      on choose of b-update
      do:
         assign
            perform-status = self:private-data
            l-focus = self:handle.
         hide frame f-button no-pause.
      end.  /* ON CHOOSE OF b-update */

      on choose of b-end
      do:
         assign
            perform-status = self:private-data
            l-focus = self:handle.
         hide frame f-1 no-pause.
         hide frame f-button no-pause.
      end.  /* ON CHOOSE OF b-end */

      on cursor-up, f9 anywhere
      do:
         assign
            perform-status = "prev"
            l-focus = focus:handle.
         apply "go" to frame f-button.
      end.  /* ON CURSOR-UP, F9 ANYWHERE */

      on cursor-down, f10 anywhere
      do:
         assign
            perform-status = "next"
            l-focus = focus:handle.
         apply "go" to frame f-button.
      end.  /* ON CURSOR-DOWN, F10 ANYWHERE */

      on cursor-right anywhere
      do:
         assign
            l-focus = self:handle.
         apply "tab" to l-focus.
      end.  /* ON CURSOR-RIGHT ANYWHERE */

      on cursor-left anywhere
      do:
         assign
            l-focus = self:handle.
         if session:display-type = "gui"
         then
            apply "shift-tab" to l-focus.
         else
            apply "ctrl-u" to l-focus.
      end.  /* ON CURSOR-LEFT ANYWHERE */

      on esc anywhere
      do:
         if session:display-type = "gui"
         then
            apply "choose" to b-end in frame f-button.
      end.  /* ON ESC ANYWHERE */

      on end-error anywhere
         apply "choose" to b-end in frame f-button.

      on window-close of current-window
         apply "choose" to b-end in frame f-button.

      on go anywhere
      do:
         if (lastkey = keycode("cursor-down") or
            lastkey = keycode("cursor-up") or
            lastkey = keycode("f9") or
            lastkey = keycode("f10"))
         then
            return.
         else
            assign
               l-focus = focus:handle.
         apply "choose" to l-focus.
      end.  /* ON GO ANYWHERE */

      wait-for
         go of frame f-button or
         window-close of current-window or
         choose of
         b-update,
         b-end
         focus
         l-focus.

   end. /* IF NOT BATCHRUN */
   else
      set perform-status.

   hide message no-pause.
END PROCEDURE. /* ip-button */
