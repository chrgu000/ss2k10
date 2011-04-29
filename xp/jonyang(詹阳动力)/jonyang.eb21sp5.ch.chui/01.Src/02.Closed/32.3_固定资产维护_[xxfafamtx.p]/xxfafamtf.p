/* fafamtf.p FIXED ASSET MAINTENANCE - Asset Account Maintenance            */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.16.1.16 $                                                         */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99   BY: *N021* Pat Pigatti      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 06/20/00   BY: *M0NB* Vihang Talwalkar */
/* REVISION: 9.1      LAST MODIFIED: 07/28/00   BY: *N0BX* Arul Victoria    */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder    */
/* Revision: 1.16.1.12  BY: Paul Donnelly (SB)  DATE: 06/26/03  ECO: *Q00C* */
/* Revision: 1.16.1.13  BY: Katie Hilbert       DATE: 10/07/03  ECO: *Q03W* */
/* Revision: 1.16.1.15  BY: Robert Jensen       DATE: 09/07/04  ECO: *N2XK* */
/* $Revision: 1.16.1.16 $    BY: Vandna Rohira         DATE: 12/17/04  ECO: *P2Z5*  */

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100810.1  By: Roger Xiao */  /* add xxfabklog01.p 记录定期费用faba_acctype = "3" 账户和成本中心的更改情况*/




/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* NEEDED SINCE 1ST CALL TO gprunp.i IS IN AN INTERNAL PROCEDURE */
{gprunpdf.i "gpglvpl" "p"}

/* --------------------  Define Query  ------------------- */
define query q_faba_det for
   faba_det
   fields( faba_domain
   faba_acct
   faba_acctype
   faba_cc
   faba_mod_date
   faba_mod_userid
   faba_proj
   faba_sub)
   scrolling.

/* -----------------  Standard Variables  ---------------- */
define variable p-status       as character no-undo.
define variable perform-status as character format "x(25)"
   initial "first" no-undo.
define variable p-skip-update  like mfc_logical no-undo.
define variable l-rowid        as rowid no-undo.
define variable l-delete-it    like mfc_logical no-undo.
define variable l-del-rowid    as rowid no-undo.
define variable l-top-rowid    as rowid no-undo.
define variable lines          as integer initial 10 no-undo.
define variable l-found        like mfc_logical no-undo.
define variable pos            as integer no-undo.
define variable l-first        like mfc_logical no-undo.
define variable l-error        like mfc_logical no-undo.
define variable l-title        as character no-undo.

/* ------------------  Button Variables  ----------------- */
define button b-update label "Update".
define button b-end    label "End".
/* SS - 100810.1 - B */
define button b-log    label "Log".
/* SS - 100810.1 - E */

/* -------------  Standard Widget Variables  ------------- */
define variable l-focus as widget-handle no-undo.
define variable w-frame as widget-handle no-undo.

/* ------------------  Screen Variables  ----------------- */
define shared variable l-type as character format "x(10)" no-undo.
define shared variable l-key  as character format "x(12)" no-undo.
define variable l-code        as character format "x(20)" no-undo.
define variable l-desc        as character format "x(24)" no-undo.
define variable l-fa-entity   as character format "x(4)"  no-undo.
define variable l-fac-id      as character format "x(8)"  no-undo.
define variable valid_acct    like mfc_logical no-undo.
define variable l-acct-seq    as integer format "999999999"
   initial 0 no-undo.

/* ------------------  Frame Definition  ----------------- */
/* Added side-labels phrase to frame statement              */

define frame f-button
   b-update at 1
   b-end    at 10
/* SS - 100810.1 - B */
   b-log    at 20
/* SS - 100810.1 - E */
with no-box overlay three-d side-labels width 40.

/* CLEAR FRAME REGISTRATION TO TRANSLATE THE FRAME EVERYTIME*/
clearFrameRegistration(frame f-button:handle).

/* SET EXTERNAL LABELS */
setFrameLabels(frame f-button:handle).

assign
   l-focus = b-update:handle in frame f-button
   b-update:width = 8
   b-update:private-data = "update"
/* SS - 100810.1 - B */
   b-log:width = 8
   b-log:private-data = "log"
/* SS - 100810.1 - E */
   b-end:width = 8
   b-end:private-data = "end".

define frame f-1
   skip(.4)
   l-code column-label "Type"
   faba_acct
   faba_sub
   faba_cc
   faba_proj
   l-desc column-label "Account Description"
with three-d overlay 8 down scroll 1 width 80.

/* CLEAR FRAME REGISTRATION TO TRANSLATE THE FRAME EVERYTIME*/
clearFrameRegistration(frame f-1:handle).

/* SET EXTERNAL LABELS */
setFrameLabels(frame f-1:handle).

run ip-framesetup.

assign
   w-frame = frame f-1:handle.
{gprun.i ""fafmtut.p""
   "(w-frame)"}

assign
   lines = 8.

for first fa_mstr no-lock
   where fa_domain = global_domain
   and fa_id = l-key:
assign
   l-fac-id    = fa_facls_id
   l-fa-entity = fa_entity.
end.  /* FOR FIRST fa_mstr no-lock */

for last faba_det no-lock
   where faba_domain = global_domain
   and  faba_fa_id = l-key
   use-index faba_fa_id:
l-acct-seq = faba_glseq.
end.  /* FOR LAST faba_det */
/* -------------  END Pre Processing Include  ------------ */

open query q_faba_det for each faba_det
   where faba_domain = global_domain
   and   faba_fa_id  = l-key
   and   faba_glseq  = l-acct-seq
   use-index faba_fa_id no-lock.

get first q_faba_det no-lock.

main-loop:
do while perform-status <> "end" on error undo:

   run ip-query
      (input-output perform-status,
      input-output l-rowid).

   /* ----------------------  Display  ---------------------- */
   run ip-predisplay.

   /* THIS BLOCK WILL GET EXECUTED ONLY IN CASE OF CIM UPLOAD  */
   /* AND ONLY WHEN VALUE OF PERFORM-STATUS IS BETWEEN 1 AND 7 */
   if batchrun
   then
     if asc(perform-status) >= 49 and
        asc(perform-status) <= 55
     then do:
        for last faba_det
           fields (faba_domain faba_fa_id faba_acctype)
           where faba_domain  = global_domain
           and  faba_fa_id   = l-key
           and  faba_acctype = perform-status
        no-lock:
        assign
           l-rowid = rowid (faba_det).
        reposition q_faba_det to rowid l-rowid no-error.
        get next q_faba_det no-lock.
        end. /* FOR LAST FABA_DET */
     end. /* IF asc(perform-status) ... */

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
      end.  /* IF perform-status = "undo" */
      run ip-displayedits.
   end.  /* IF (perform-status = "update" OR ... */

/* SS - 100810.1 - B */
   if perform-status = "log"
   then do:
      {gprun.i ""xxfabklog01.p"" "(input l-key)"}
   end.  /* IF perform-status = "end" */
/* SS - 100810.1 - E */

   /* -----------------------  End  ----------------------- */
   if perform-status = "end"
   then do:
      hide frame f-1 no-pause.
      delete PROCEDURE this-procedure no-error.
      leave.
   end.  /* IF perform-status = "end" */

   /* ----------------  Selection Buttons  ---------------- */
   if perform-status <> "first"
   then
      run ip-button (input-output perform-status).

   /* -------------  After Strip Menu Include  ------------ */
   if perform-status = "end" and
      can-find(first faba_det no-lock
      where faba_domain = global_domain and
      faba_fa_id  = l-key         and
      faba_glseq  = l-acct-seq    and
      faba_acct   = "")
   then do:
      /* VALID NON-BLANK ACCOUNT NUMBER REQUIRED */
      {pxmsg.i &MSGNUM=5227 &ERRORLEVEL=2}
   end.  /* IF perform-status = "end" AND ... */
   /* -----------  END After Strip Menu Include  ---------- */

end.  /* MAIN-LOOP */

/* -------------  Add / Update / Field Edits  ------------ */
PROCEDURE ip-prompt:
   if perform-status = "add"
   then do:
      scroll from-current down with frame f-1.
      assign
         l-rowid = ?.
   end.  /* IF perform-status = "add"  */

   assign
      l-first = yes.
   CASE perform-status:
      when ("add")
      then
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} /* ADDING NEW RECORD */
      when ("update")
      then
         {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1} /* MODIFYING EXISTING RECORD */
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
            faba_det.faba_acct
            faba_det.faba_sub
            faba_det.faba_cc
            faba_det.faba_proj
         with frame f-1.

         /* FIELD EDIT FOR faba_acct */
         assign
            l-error = no.

         /* INITIALIZE SETTINGS */
         {gprunp.i "gpglvpl" "p" "initialize"}

         /* ACCT/SUB/CC/PROJ VALIDATION */
         {gprunp.i "gpglvpl" "p" "validate_fullcode"
            "(input frame f-1 faba_acct,
              input frame f-1 faba_sub,
              input frame f-1 faba_cc,
              input frame f-1 faba_proj,
              output valid_acct)"}

         if global-beam-me-up
         then
            undo, leave.
         if valid_acct = no
         then
            l-error = yes.

         if l-error
         then do:

            if batchrun
            then do:
               assign
                  perform-status = "undo".
               return.
            end. /* IF BATCHRUN */

            next-prompt faba_acct with frame f-1.
            next.
         end.  /* IF l-error  */
         /* END FIELD EDIT FOR faba_acct */

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

      /* AFTER-UPDATE-EDITS */
      if perform-status = "update"
      then do:
         if frame f-1 faba_acct entered or
            frame f-1 faba_sub entered  or
            frame f-1 faba_cc entered   or
            frame f-1 faba_proj entered
         then do:
            {gprun.i ""fafabld.p""
               "(faba_acct:screen-value,
                 faba_sub:screen-value,
                 faba_cc:screen-value,
                 faba_proj:screen-value,
                 buffer faba_det,
                 output l-acct-seq)"}
            if global-beam-me-up
            then
               undo, leave.
            assign
               perform-status = "open".
            run ip-query
               (input-output perform-status,
               input-output l-rowid).
            run ip-predisplay.
            return.
         end.  /* IF frame f-1 faba_acct ENTERED OR ... */
      end.  /* IF perform-status = "update"  */
      /* AFTER-UPDATE-EDITS */

      leave.
   end. /* PROMPT-FOR-IT */
   if global-beam-me-up
   then
      undo, leave.
   if keyfunction(lastkey) = "end-error"
   then do:
      if perform-status = "add"
      then do:
         {pxmsg.i &MSGNUM=1304 &ERRORLEVEL=1} /* RECORD NOT ADDED */
         get first q_faba_det no-lock.
         if available faba_det
         then
            assign
               perform-status = "first"
               l-rowid = rowid(faba_det).
         else
            assign
               perform-status = ""
               l-rowid = ?.
         clear frame f-1 no-pause.
      end.  /* IF perform-status = "add"  */
      else
         if available faba_det
         then
            assign
               perform-status = ""
               l-rowid = rowid(faba_det).
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

         if available faba_det
         then
            get current q_faba_det no-lock.
         if available faba_det and
            current-changed faba_det
         then do:
            assign
               l-delete-it = yes.
            /* RECORD HAS BEEN MODIFIED SINCE YOU EDIT IT */
            {pxmsg.i &MSGNUM=2042 &ERRORLEVEL=1 &CONFIRM=l-delete-it}
            if l-delete-it = no
            then do:
               hide message no-pause.
               run ip-displayedits.
               return.
            end.  /* IF l-delete-it = no  */
            hide message no-pause.
         end.  /* IF AVAILABLE faba_det AND ... */
         if available faba_det
         then
            tran-lock:
         do while perform-status <> "":
            get current q_faba_det exclusive-lock no-wait.
            if locked faba_det
            then do:
               if pos < 3
               then do:
                  assign pos = pos + 1.
                  pause 1 no-message.
                  next tran-lock.
               end.  /* IF pos < 3  */
               assign
                  perform-status = "error".
            end.  /* IF LOCKED faba_det  */
            leave.
         end. /*WHILE*/

         if (perform-status = "update" or
            p-status = "update") and
            l-delete-it = yes
         then
            run ip-update (input-output perform-status).
         if perform-status = "delete"
         then
            run ip-delete (input-output perform-status).

         if available faba_det
         then
            get current q_faba_det no-lock.
      end.  /* IP-LOCK */
   if perform-status = "add"
   then
      run ip-add (input-output perform-status).
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
   reposition q_faba_det to rowid l-rowid no-error.
   get next q_faba_det no-lock.
   assign
      perform-status = "first"
      l-rowid = rowid(faba_det).
   return.
END PROCEDURE. /* ip-update */

PROCEDURE ip-add:
   define input-output parameter perform-status as character no-undo.

   create faba_det.
   faba_det.faba_domain = global_domain.
   run ip-assign
      (input-output perform-status).
   assign
      perform-status = "open".
   run ip-query
      (input-output perform-status,
      input-output l-rowid).
   reposition q_faba_det to rowid l-rowid no-error.
   get next q_faba_det no-lock.
   assign
      perform-status = "first"
      l-rowid = rowid(faba_det).
   return.
END PROCEDURE. /* ip-add */

PROCEDURE ip-delete:
   define input-output parameter perform-status as character no-undo.
   assign
      l-delete-it = no.
   /* PLEASE CONFIRM DELETE */
   {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=l-delete-it}

   CASE l-delete-it:
      when yes
      then do:
         hide message no-pause.
         delete faba_det.
         clear frame f-1 no-pause.
         get next q_faba_det no-lock.
         if available faba_det
         then
            assign
               perform-status = "first"
               l-rowid = rowid(faba_det).
         else do:
            get prev q_faba_det no-lock.
            if available faba_det
            then
               assign
                  perform-status = "first"
                  l-rowid = rowid(faba_det).
            else
               assign
                  perform-status = "first"
                  l-rowid = rowid(faba_det).
         end.  /* IF NOT AVAILABLE faba_det  */
         {pxmsg.i &MSGNUM=22 &ERRORLEVEL=1} /* RECORD DELETED */
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
         faba_det.faba_acct
         faba_det.faba_sub
         faba_det.faba_cc
         faba_det.faba_proj
         faba_det.faba_mod_userid = global_userid
         faba_det.faba_mod_date = today
         l-rowid = rowid(faba_det).

   end.  /* DO WITH FRAME f-1 */
END PROCEDURE. /* ip-assign */

PROCEDURE ip-predisplay:
   if (perform-status = "" or
      perform-status = "update") and
      available faba_det
   then
      display-loop:
      do:
         if perform-status = ""
         then do:
            clear frame f-1 all no-pause.
            l-top-rowid = rowid(faba_det).
         end.  /* IF perform-status = ""  */
         read-loop:
         do pos = 1 to lines:
            if perform-status = ""
            then do:
               if session:display-type = "gui"
               then
                  assign
                     l-code:bgcolor = 8
                  l-code:fgcolor = 0.
               else
                  color display normal l-code
                  with frame f-1.
            end.  /* IF perform-status = ""  */
            run ip-displayedits.
            if perform-status = "update"
               then
                  leave display-loop.
            if pos < lines
            then
               down with frame f-1.
               get next q_faba_det no-lock.
            if not available faba_det
            then
               leave.
         end.  /* DO pos = 1 TO LINES */
         run ip-postdisplay.
      end. /* DISPLAY-LOOP */
END PROCEDURE. /* ip-predisplay */

PROCEDURE ip-displayedits:
   if available faba_det
   then do:
      /* DISPLAY-EDITS */
      {gplngn2a.i
         &file = ""facd_det""
         &field = ""facd_acctype""
         &code = faba_det.faba_acctype
         &mnemonic = l-code
         &label = l-code}
      for first ac_mstr no-lock
         where ac_domain = global_domain and
         ac_code = faba_det.faba_acct:
      end.  /* FOR FIRST ac_mstr */
      if available ac_mstr
      then
         l-desc = ac_desc.
      else
         l-desc = "".
      /* DISPLAY-EDITS */

      run ip-display.
   end.  /* IF AVAILABLE faba_det  */
END PROCEDURE. /* ip-displayedits */

PROCEDURE ip-display:
   display
      faba_det.faba_acct
      faba_det.faba_sub
      faba_det.faba_cc
      faba_det.faba_proj
      l-desc
      l-code
   with frame f-1.
END PROCEDURE. /* ip-display */

PROCEDURE ip-postdisplay:
   do pos = 1 to lines:
      if frame-line(f-1) <= 1
      then
         leave.
      up 1 with frame f-1.
   end.  /* DO pos = 1 TO LINES */
   if perform-status = ""
   then do:
      reposition q_faba_det to rowid l-top-rowid no-error.
      get next q_faba_det no-lock.
      assign
         l-rowid = l-top-rowid.
      color display message l-code
      with frame f-1.
   end.  /* IF perform-status = ""  */
END PROCEDURE. /* ip-postdisplay */

PROCEDURE ip-query:
   define input-output parameter perform-status as character no-undo.
   define input-output parameter l-rowid        as rowid     no-undo.

   if perform-status = "first"
   then do:
      if l-rowid <> ?
      then do:
         reposition q_faba_det to rowid l-rowid no-error.
         get next q_faba_det no-lock.
      end.  /* IF l-rowid <> ?  */
      if not available faba_det
      then
         get first q_faba_det no-lock.
      if available faba_det
      then
         assign
            perform-status = ""
            l-rowid = rowid(faba_det).
      else do:
         assign
            perform-status = ""
            l-rowid = ?.
         assign
            frame f-1:visible = true.
         return.
      end.  /* IF NOT AVAILABLE faba_det  */
   end.  /* IF perform-status = "first"  */
   if perform-status = "open"
   then do:
      open query q_faba_det for each faba_det
         where faba_domain = global_domain
         and   faba_fa_id = l-key
         and   faba_glseq = l-acct-seq
         use-index faba_fa_id no-lock.

      reposition q_faba_det to rowid l-rowid no-error.
      get next q_faba_det no-lock.
      if available faba_det
      then
         assign
            perform-status = ""
            l-rowid = rowid(faba_det).
      else do:
         get first q_faba_det no-lock.
         if not available faba_det
         then do:
            assign
               perform-status = ""
               frame f-1:visible = true.
            return.
         end.  /* IF NOT AVAILABLE faba_det  */
         else
            assign
               perform-status = ""
               l-rowid = rowid(faba_det).
      end.  /* IF NOT AVAILABLE faba_det  */
   end.  /* IF perform-status = "open" */
   if perform-status = "next"
   then do:
      get next q_faba_det no-lock.
      if available faba_det
      then do:
         hide message no-pause.
         assign
            l-rowid = rowid(faba_det)
            perform-status = "next".
         if session:display-type = "gui"
         then
            assign
               l-code:bgcolor = 8
               l-code:fgcolor = 0.
         else
            color display normal l-code
            with frame f-1.
         pause 0. /* MAKES SCROLLING WORK - DON'T REMOVE */
         down 1 with frame f-1.
         run ip-displayedits.
         color display message l-code
         with frame f-1.
      end.  /* IF AVAILABLE faba_det  */
      else do:
         assign
            perform-status = "next".
         {pxmsg.i &MSGNUM=20 &ERRORLEVEL=2} /* END OF FILE */
         get last q_faba_det no-lock.
      end.  /* IF NOT AVAILABLE faba_det  */
   end.  /* IF perform-status = "next" */
   if perform-status = "prev"
   then do:
      get prev q_faba_det no-lock.
      if not available faba_det
      then do:
         {pxmsg.i &MSGNUM=21 &ERRORLEVEL=2} /* BEGINNING OF FILE */
         get first q_faba_det no-lock.
         return.
      end.  /* IF NOT AVAILABLE faba_det  */
      hide message no-pause.
      l-rowid = rowid(faba_det).
      if session:display-type = "gui"
      then
         assign
            l-code:bgcolor = 8
            l-code:fgcolor = 0.
      else
         color display normal l-code
         with frame f-1.
      pause 0.  /* MAKES SCROLLING WORK - DON'T REMOVE */
      up 1 with frame f-1.
      run ip-displayedits.
      color display message l-code
      with frame f-1.
   end.  /* IF perform-status = "prev"  */
   if perform-status = "update" or
      perform-status = "delete"
   then do:
      get current q_faba_det no-lock.
      if not available faba_det
      then do:
         hide message no-pause.
         {pxmsg.i &MSGNUM=1310 &ERRORLEVEL=3} /* RECORD NOT FOUND */
         assign
            perform-status = "".
      end.  /* IF NOT AVAILABLE faba_det  */
   end.  /* IF perform-status = "update" OR ... */
END PROCEDURE. /* ip-query */

PROCEDURE ip-framesetup:
   if session:display-type = "gui"
   then
      assign
         frame f-1:row = 4.5.
   else
      assign
         frame f-1:row = 4.

   if {gpiswrap.i}
   then
      assign frame f-1:overlay = no.

   assign
      frame f-1:box = true
      frame f-1:centered = true
      frame f-1:title = (getFrameTitle("ASSET_ACCOUNT_MAINTENANCE",36))
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

/* SS - 100810.1 - B */
      on choose of b-log
      do:
         assign
            perform-status = self:private-data
            l-focus = self:handle.
         hide frame f-button no-pause.
      end. 
/* SS - 100810.1 - E */

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
            lastkey = keycode("cursor-up")   or
            lastkey = keycode("f9")          or
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
/* SS - 100810.1 - B */
         b-log,
/* SS - 100810.1 - E */
         b-end
         focus
         l-focus.

   end. /* IF NOT BATCHRUN */

   else do:
      set perform-status.

      /* IN CIM FILE IF INVALID TYPE IS ENTERED THEN CONSUME NEXT TWO */
      /* LINES FROM THE FILE, SO THAT ACCOUNTS FOR NEXT VALID TYPE    */
      /* ARE UPDATED                                                  */

      if perform-status <> "update"   and
         perform-status <> "end"      and
/* SS - 100810.1 - B */
         perform-status <> "log"      and
/* SS - 100810.1 - E */
         not (asc(perform-status) >= 49 and
         asc(perform-status) <= 55)
      then do:
         import ^ .
         import ^ .
      end. /* IF PERFORM-STATUS ... */
   end. /* ELSE */

   hide message no-pause.
END PROCEDURE. /* ip-button */
