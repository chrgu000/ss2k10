/* fafamtg.p - FIXED ASSETS MAINTENANCE - Depreciation Adjustments          */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.20.1.22 $                                                   */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99   BY: *N021* Pat Pigatti      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 05/12/00   BY: *M0MN* Shilpa Athalye   */
/* REVISION: 9.1      LAST MODIFIED: 05/15/00   BY: *M0MR* Veena Lad        */
/* REVISION: 9.1      LAST MODIFIED: 05/17/00   BY: *M0LJ* Vihang Talwalkar */
/* REVISION: 9.1      LAST MODIFIED: 07/28/00   BY: *N0BX* Arul Victoria    */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder    */
/* REVISION: 9.1      LAST MODIFIED: 08/18/00   BY: *M0NL* Abbas Hirkani    */
/* Revision: 1.20.1.13  BY: Kirti Desai  DATE: 05/03/02  ECO: *N1GN*        */
/* Revision: 1.20.1.14  BY: Rajaneesh S. DATE: 05/22/02  ECO: *M1Y9*        */
/* Revision: 1.20.1.15  BY: Mercy Chittilapilly DATE: 03/26/03  ECO: *N26Y* */
/* Revision: 1.20.1.16  BY: Rajesh Lokre DATE: 04/03/03 ECO: *M1RX* */
/* Revision: 1.20.1.18  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00C* */
/* Revision: 1.20.1.20  BY: Dorota Hohol       DATE: 09/01/03 ECO: *P0YS* */
/* Revision: 1.20.1.21  BY: Vandna Rohira      DATE: 12/17/04 ECO: *P2Z5* */
/* $Revision: 1.20.1.22 $  BY: Sachin Deshmukh    DATE: 04/05/04 ECO: *P3FJ* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* 以下为版本历史 */                                                             
/* SS - 090507.1 By: Bill Jiang */

{mfdeclre.i}
{cxcustom.i "FAFAMTG.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definition ********* */

&SCOPED-DEFINE fafamtg_p_1 "Type"
/* MaxLen: 8 Comment: */

&SCOPED-DEFINE fafamtg_p_2 "Add"
/* MaxLen: 6 Comment: Button label - Add*/

&SCOPED-DEFINE fafamtg_p_3 "Undo"
/* MaxLen: 6 Comment: Button label - Undo*/

&SCOPED-DEFINE fafamtg_p_4 "End"
/* MaxLen: 6 Comment: Button label - End*/

/* ********** End Translatable Strings Definition ********* */

define input-output parameter l_astpost like mfc_logical no-undo.
define input-output parameter l_cost    like fa_puramt   no-undo.

/* --------------------  Define Query  ------------------- */
define query q_faadj_mstr
   for faadj_mstr
   fields( faadj_domain  faadj_amt faadj_fabk_id faadj_famt_id faadj_fa_id
   faadj_life
           faadj_mod_date faadj_mod_userid faadj_resrv faadj_type faadj_migrate
           faadj_yrper)
   scrolling.

/* -----------------  Standard Variables  ---------------- */
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
define variable pos            as   integer            no-undo.
define variable l-first        like mfc_logical        no-undo.
define variable l-error        like mfc_logical        no-undo.
define variable l-title        as   character          no-undo.
define variable l-error-number like msg_nbr            no-undo.

/* ------------------  Button Variables  ----------------- */
define button b-add  label {&fafamtg_p_2}.
define button b-undo label {&fafamtg_p_3}.
define button b-end  label {&fafamtg_p_4}.

/* -------------  Standard Widget Variables  ------------- */
define variable l-focus as widget-handle no-undo.
define variable w-frame as widget-handle no-undo.

/* ------------------  Screen Variables  ----------------- */
define shared variable l-fabk-id   as character format "x(4)"        no-undo.
define shared variable l-fa-id     as character format "x(8)"        no-undo.
define variable l-famt-meth        as character format "x(8)"
   initial """" no-undo.
define variable l-resrv            as integer format ">>9" initial 0 no-undo.
define variable l-type             as character format "x(8)"        no-undo.
define variable l-err-nbr          as integer format "->,>>>,>>9"    no-undo.
define variable l-last-type        as character format "x(8)"
   initial """" no-undo.
define variable faadj_amt_fmt      as character format "x(30)"       no-undo.
define variable l-adj-date         as date format "99/99/9999"       no-undo.
define variable l-type-desc        as character format "x(8)"        no-undo.
define variable l-remain-total     as decimal format "->>>,>>>,>>>,>>9.999"
   no-undo.
define variable l-beg-accdep       like fabd_accamt                  no-undo.
define variable l-end-accdep       like fabd_accamt                  no-undo.
define variable l-type-translation as character format "x(24)"       no-undo.
define variable l-valid            like mfc_logical                  no-undo.
define variable l-suspend          like mfc_logical                  no-undo.
define variable l-post             like mfc_logical                  no-undo.

/* ------------------  Frame Definition  ----------------- */
/* Added side-labels phrase to frame statement              */

define frame f-button
   b-add at 1
   b-undo at 10
   b-end at 19
with no-box overlay three-d side-labels width 28.

/* CLEAR FRAME REGISTRATION TO TRANSLATE THE FRAME EVERYTIME*/
clearFrameRegistration(frame f-button:handle).

/* SET EXTERNAL LABELS */
setFrameLabels(frame f-button:handle).

assign
   l-focus             = b-add:handle in frame f-button
   b-add:width         = 8
   b-add:private-data  = "add"
   b-undo:width        = 8
   b-undo:private-data = "undo"
   b-end:width         = 8
   b-end:private-data = "end".

define frame f-1
   skip(.4)
   space(2)
   l-type-desc column-label {&fafamtg_p_1}
   faadj_famt_id
   faadj_life
   faadj_amt
   faadj_yrper
with three-d overlay  3 down scroll 1 width 80.

/* CLEAR FRAME REGISTRATION TO TRANSLATE THE FRAME EVERYTIME*/
clearFrameRegistration(frame f-1:handle).

/* SET EXTERNAL LABELS */
setFrameLabels(frame f-1:handle).

run ip-framesetup.

w-frame = frame f-1:handle.

{gprun.i ""fafmtut.p""
   "(w-frame)"}

lines = 03.

/* ---------------  Pre Processing Include  -------------- */
{falffx.i}  /* FUNCTION TO VALIDATE ESTIMATED LIFE */
{gpglefv.i} /* VARIABLES FOR GPGLEF1.P */
{gprunpdf.i "fapl" "p"}  /* VARIABLES FOR FA PERSISTENT PROCEDURES */

define buffer last-faadj for faadj_mstr.

for first fa_mstr
   fields( fa_domain fa_disp_dt fa_entity fa_id fa_facls_id)
    where fa_mstr.fa_domain = global_domain and  fa_id = l-fa-id
   no-lock:
end. /* FOR FIRST fa_mstr */

if not available fa_mstr
then
   return.

/* REMOVE FIELD LIST SINCE BUFFER COPY IS BEING DONE IN faajblb.p */
for last fab_det
    where fab_det.fab_domain = global_domain and  fab_fa_id   = l-fa-id
   and   fab_fabk_id = l-fabk-id
   no-lock
   use-index fab_resrv:
end. /* FOR LAST fab_det */

for first famt_mstr
   fields( famt_domain famt_id famt_active famt_elife famt_type)
    where famt_mstr.famt_domain = global_domain and  famt_id = fab_famt_id
   no-lock:
   l-famt-meth = famt_type.
end. /* FOR FIRST famt_mstr */

for first fabk_mstr
   fields( fabk_domain fabk_id fabk_post fabk_calendar)
   no-lock
    where fabk_mstr.fabk_domain = global_domain and  fabk_id = fab_fabk_id:
end. /* FOR FIRST fabk_mstr */

if not available fabk_mstr
then do:
   /* INVALID BOOK CODE */
   {pxmsg.i &MSGNUM=4214 &ERRORLEVEL=4}
   return.
end. /* IF NOT AVAILABLE fabk_mstr */

for last last-faadj
   fields( faadj_domain faadj_fa_id faadj_fabk_id faadj_resrv faadj_type)
    where last-faadj.faadj_domain = global_domain and  faadj_fa_id   = l-fa-id
   and   faadj_fabk_id = l-fabk-id
   no-lock
   use-index faadj_fa_id:

   assign
      l-resrv = faadj_resrv
      l-last-type = faadj_type.
end. /* FOR LAST last-faadj */

/* SET CURRENCY DEPENDENT ROUNDING FORMATS */
for first gl_ctrl
   fields( gl_domain gl_rnd_mthd)
    where gl_ctrl.gl_domain = global_domain no-lock:
end. /* FOR FIRST gl_ctrl */

faadj_amt_fmt = faadj_mstr.faadj_amt:format.

{gprun.i ""gpcurfmt.p""
   "(input-output faadj_amt_fmt,
     input        gl_rnd_mthd)"}

if global-beam-me-up
then
   undo, leave.

faadj_mstr.faadj_amt:format = faadj_amt_fmt.

/* -------------  END Pre Processing Include  ------------ */

open query q_faadj_mstr
   for each faadj_mstr
       where faadj_mstr.faadj_domain = global_domain and  faadj_fa_id   =
       l-fa-id
      and   faadj_fabk_id = l-fabk-id
      and   faadj_type < "90"
      use-index faadj_fa_id no-lock.

get first q_faadj_mstr no-lock.

main-loop:
do while perform-status <> "end" on error undo:

   run ip-query
      (input-output perform-status,
       input-output l-rowid).

   /* -----------------------  Undo  ---------------------- */
   if perform-status = "undo"
   then do:

      perform-status = "delete".
      run ip-lock
         (input-output perform-status).

      perform-status = "first".
      run ip-predisplay.
      clear frame f-1 no-pause.
   end. /* IF perform-status = "undo" */

   /* ---------------------  END Undo  -------------------- */

   /* ----------------------  Display  ---------------------- */
   run ip-predisplay.

   /* ----------------------  Add  ------------------------ */
   if (perform-status = "update"
   or  perform-status = "add")
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
   end. /* IF (perform-status = "update" */

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
   if (perform-status = "add"
   or perform-status = "undo")
   and fa_mstr.fa_disp_dt <> ?
   then do:
      /* CANNOT ADJUST- ASSET RETIRED */
      {pxmsg.i &MSGNUM=3201 &ERRORLEVEL=4}
      perform-status = "first".
   end. /* IF (perform-status = "add" ... */
   else
   if perform-status = "undo"
   then do:

      if l-famt-meth = "2"
      then do:
         /* CANNOT UNDO UOP ADJUSTMENTS */
         {pxmsg.i &MSGNUM=2972 &ERRORLEVEL=4}
         perform-status = "first".
      end. /* IF l-famt-meth = "2" */
      else
      if not available faadj_mstr
      then do:
         {pxmsg.i &MSGNUM=3224 &ERRORLEVEL=4}
         perform-status = "first".
      end. /* IF NOT AVAILABLE faadj_mstr */
      else
      if can-find(first last-faadj
       where last-faadj.faadj_domain = global_domain and
       last-faadj.faadj_fa_id = l-fa-id
      and last-faadj.faadj_fabk_id = l-fabk-id
      and last-faadj.faadj_resrv > faadj_mstr.faadj_resrv
      and last-faadj.faadj_type = "92")
      then do:  /* SPLIT */
         /* CANNOT UNDO - ASSET SPLIT */
         {pxmsg.i &MSGNUM=3309 &ERRORLEVEL=4}
         perform-status = "first".
      end. /* IF CAN-FIND(FIRST last-faadj ... */
      else
      if can-find(first last-faadj
       where last-faadj.faadj_domain = global_domain and
       last-faadj.faadj_fa_id = l-fa-id
      and last-faadj.faadj_fabk_id = l-fabk-id
      and last-faadj.faadj_resrv > faadj_mstr.faadj_resrv)
      then do:
         /* ONLY THE MOST RECENT ADJUSTMENT CAN BE UNDONE */
         {pxmsg.i &MSGNUM=3310 &ERRORLEVEL=4}
         perform-status = "first".
      end. /* IF CAN-FIND(FIRST last-faadj */
      else
      if faadj_migrate = yes
      then do:
         /* CANNOT UNDO - MIGRATED ADJUSTMENT */
         {pxmsg.i &MSGNUM=3063 &ERRORLEVEL=4}
         perform-status = "first".
      end. /* IF faadj_migrate = YES */
      else
      if can-find(first fabd_det
       where fabd_det.fabd_domain = global_domain and  fabd_fa_id = l-fa-id
      and fabd_fabk_id = l-fabk-id
      and fabd_resrv = faadj_resrv
      and fabd_post = yes)
      then do:
         /* CANNOT UNDO - ADJUSTMENT POSTED */
         {pxmsg.i &MSGNUM=3223 &ERRORLEVEL=4}
         perform-status = "first".
      end. /* IF CAN-FIND(FIRST fabd_det */
      else
      if faadj_type = "7"
      then do:
         /* CANNOT UNDO - PERIOD ADJUSTMENT CREATED THROUGH UTILITY */
         {pxmsg.i &MSGNUM=3638 &ERRORLEVEL=4}
         perform-status = "first".
      end. /* IF faadj_type = "7" */
   end.  /* ELSE IF perform-status = "undo" */

end. /* DO WHILE perform-status <> "end" */

PROCEDURE ip-prompt:

   define variable l-cnt as integer initial 0 no-undo.
   define buffer fabd-det for fabd_det.

   if perform-status = "add"
   then do:
      scroll from-current down with frame f-1.
      l-rowid = ?.
   end. /* IF perform-status = "add" */

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
   END CASE. /* perform-status */
   ststatus = stline[2].
   status input ststatus.

   /* BEFORE-ADD-EDIT */
   if l-first
   and perform-status = "add"
   then
      assign
         faadj_famt_id:screen-value = fab_det.fab_famt_id
         faadj_life:screen-value    = string(fab_det.fab_life)
         faadj_amt:screen-value     = "0".
   /* BEFORE-ADD-EDIT */

   prompt-for-it:
   repeat:
      l-first = no.
      repeat:
         prompt-for
            l-type-desc
         with frame f-1.

         assign
            l-type-desc
            /* FIELD EDIT FOR l-type-desc */
            l-error = no.

         {gplngv.i
            &file = ""faadj_mstr""
            &field = ""faadj_type""
            &mnemonic = "input frame f-1 l-type-desc"
            &isvalid = l-valid}

         if l-valid = no
         then do:
            /* INVALID TYPE */
            {pxmsg.i &MSGNUM=4211 &ERRORLEVEL=3}
            l-error = yes.
         end.
         else do:
            {gplnga2n.i
               &file = ""faadj_mstr""
               &field = ""faadj_type""
               &mnemonic = "input frame f-1 l-type-desc"
               &code = l-type
               &label = l-type-desc}

            if (l-type < "1")
            or (l-type > "89")
            {&FAFAMTG-P-TAG10}
            or (l-type = "7" )
            {&FAFAMTG-P-TAG11}
            then do:
               /* Invalid type */
               {pxmsg.i &MSGNUM=4211 &ERRORLEVEL=3}
               l-error = yes.
            end. /* IF (l-type < "1") */
         end. /* ELSE DO */

         if l-error = no
         /* Non basis adjustment is not allowed for UOP */
         {&FAFAMTG-P-TAG1}
         and (l-famt-meth = "2"
         and l-type <> "2")
         {&FAFAMTG-P-TAG2}
         then do:
            /* Invalid type */
            {pxmsg.i &MSGNUM=4211 &ERRORLEVEL=3}
            l-error = yes.
         end. /* IF l-error */

         if  l-error = no
         and l-famt-meth <> "2"
         then do:

            if l-error = no
            then do:

               if l-last-type = "5"
               and l-type <> "6"
               then do:
                  /* Cannot adjust - depreciation suspended */
                  {pxmsg.i &MSGNUM=3226 &ERRORLEVEL=3}
                  l-error = yes.
               end. /* IF l-last-type = "5" ... */

            end. /* IF l-error = NO */

            if l-error = no
            and l-type <> "6"
            then do:

               /* Validate against open period */
               for each fabd-det
                  fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper
                  fabd_suspend
                          fabd_resrv fabd_post)
                   where fabd-det.fabd_domain = global_domain and  fabd_fa_id =
                   l-fa-id
                  and fabd_fabk_id = l-fabk-id
                  no-lock
                  break by fabd_yrper:

                  if first-of(fabd_yrper)
                  then do:

                     if fabd_post = no
                     then do:

                        l-cnt = l-cnt + 1.
                        if l-cnt > 1
                        then
                           leave.
                     end. /* IF fabd_post = NO */
                  end.  /* IF FIRST-OF ... */
               end.  /* FOR EACH fabd-det ... */

               if l-cnt = 0
               then do:
                  /* Cannot adjust - asset fully depreciated */
                  {pxmsg.i &MSGNUM=3214 &ERRORLEVEL=3}
                  l-error = yes.
               end. /* IF l-cnt = 0 */
               else
               /* Invalid if not life or suspend adjustment */
               {&FAFAMTG-P-TAG3}
               if l-cnt = 1
               and l-type < "4"
               then do:
               {&FAFAMTG-P-TAG4}
                  /* Cannot adjust - final period */
                  {pxmsg.i &MSGNUM=3227 &ERRORLEVEL=3}
                  l-error = yes.
               end. /* IF l-cnt = 1 */
            end.  /* IF l-error = no */
         end.  /* IF non UOP method */
         if l-error
         then do:
            next-prompt l-type-desc with frame f-1.
            next.
         end. /* IF l-error */
         /* END FIELD EDIT FOR l-type-desc */

         leave.
      end. /* REPEAT */

      if global-beam-me-up
      then
         undo, leave.

      if keyfunction(lastkey) = "end-error"
      then do:
         perform-status = "undo".
         return no-apply.
      end. /* IF KEYFUNCTION(LASTKEY) */

      repeat:
         prompt-for
            faadj_mstr.faadj_famt_id
            when (l-type = "3")
         with frame f-1.

         /* FIELD EDIT FOR faadj_famt_id */
         l-error = no.
         if l-type = "3"
         then do:

            for first famt_mstr
               fields( famt_domain famt_id famt_active famt_type famt_elife)
                where famt_mstr.famt_domain = global_domain and  famt_id =
                input frame f-1 faadj_famt_id:
            end. /* FOR FIRST famt_mstr */

            if not available famt_mstr
            then do:
               /* Invalid depreciation method */
               {pxmsg.i &MSGNUM=4200 &ERRORLEVEL=3}
               l-error = yes.
            end. /* IF NOT AVAILABLE famt_mstr */
            else
            if famt_active = no
            then do:
               {pxmsg.i &MSGNUM=3220 &ERRORLEVEL=3}
               /* Depreciation Method Inactive */
               l-error = yes.
            end. /* IF famt_active = NO */
            else
            if input frame f-1 faadj_famt_id = fab_det.fab_famt_id
            then do:
               {pxmsg.i &MSGNUM=3229 &ERRORLEVEL=3}
               /* Cannot adjust - method is the same */
               l-error = yes.
            end. /* IF INPUT FRAME f-1 ... */
            else
            if famt_type = "6"
            then
               faadj_life:screen-value = string(famt_elife).
         end. /* IF l-type = "3" */
         if l-error
         then do:
            next-prompt faadj_famt_id with frame f-1.
            next.
         end. /* IF l-error */
         /* END FIELD EDIT FOR faadj_famt_id */

         leave.
      end. /* REPEAT */

      if global-beam-me-up
      then
         undo, leave.

      if keyfunction(lastkey) = "end-error"
      then
          next prompt-for-it.

      repeat:
         prompt-for
            faadj_mstr.faadj_life
            when (l-type = "4")
         with frame f-1.

         /* FIELD EDIT FOR faadj_life */
         l-error = no.
         /* IF TYPE IS CHANGE OF LIFE THEN VALIDATE NEW LIFE */
         if l-type = "4"
         then do:

            if input frame f-1 faadj_life = fab_det.fab_life
            then do:
               /* CANNOT ADJUST - LIFE IS THE SAME */
               {pxmsg.i &MSGNUM=3228 &ERRORLEVEL=3}
               l-error = yes.
            end. /* IF INPUT FRAME f-1 */
            else do:
               assign
                  l-err-nbr = f-validate-life(fab_famt_id,
                                              input frame f-1 faadj_life)
                  l-error   = l-err-nbr > 0.

               if l-err-nbr > 0
               then do:
                  {pxmsg.i &MSGNUM=l-err-nbr &ERRORLEVEL=3}
               end. /* IF l-err-nbr > 0 */
            end. /* ELSE DO */
         end.  /* IF INPUT FRAME f-1 faadj_type = "4" */

         if l-error
         then do:
            next-prompt faadj_life with frame f-1.
            next.
         end. /* IF l-error */

         /* END FIELD EDIT FOR faadj_life */

         leave.
      end. /* REPEAT */

      if global-beam-me-up
      then
         undo, leave.

      if keyfunction(lastkey) = "end-error"
      then
         next prompt-for-it.

      repeat:
         prompt-for
            faadj_mstr.faadj_amt
            {&FAFAMTG-P-TAG5}
            when (l-type   = "1"
                 or l-type = "2")
            faadj_mstr.faadj_yrper
            when (l-type = "1" or l-type = "5" or l-type = "6")
         with frame f-1.

         /* FIELD EDIT FOR faadj_amt */
         l-error = no.

         if l-type = "2"
         {&FAFAMTG-P-TAG6}
         and input frame f-1 faadj_amt = 0
         then do:
            /* ZERO NOT ALLOWED */
            {pxmsg.i &MSGNUM=317 &ERRORLEVEL=3}
            l-error = yes.
         end. /* IF l-type = "2" ... */

         /* SS - 090507.1 - B
         if l-type = "1"
         and input frame f-1 faadj_amt <= 0
         then do:
            /* BONUS ADJUSTMENT AMOUNT MUST BE GREATER THAN ZERO */
            {pxmsg.i &MSGNUM=4077 &ERRORLEVEL=3}
            l-error = yes.
         end. /* IF l-type = "1" AND INPUT ... */
         SS - 090507.1 - E */

         /* SS - 090507.1 - B */
         if l-type = "1"
         and input frame f-1 faadj_amt = 0
         then do:
            /* ZERO NOT ALLOWED */
            {pxmsg.i &MSGNUM=317 &ERRORLEVEL=3}
            l-error = yes.
         end. /* IF l-type = "1" AND INPUT ... */
         /* SS - 090507.1 - E */

         if l-error = no
         then do:
            /* CHECK CURRENCY DEPENDENT ROUNDING FORMAT */
            {gprun.i ""gpcurval.p""
               "(input  input frame f-1 faadj_amt,
                 input  gl_ctrl.gl_rnd_mthd,
                 output l-err-nbr)"}

            if global-beam-me-up
            then
               undo, leave.

            assign
               l-error   = l-err-nbr <> 0
               l-err-nbr = 0.
         end. /* IF l-error = NO */

         if l-error = no
         and l-type = "1"
         then do:
            for last fabd-det
               fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper
               fabd_suspend
                       fabd_resrv fabd_post)
                where fabd-det.fabd_domain = global_domain and  fabd_fa_id   =
                fab_fa_id
               and   fabd_fabk_id = fab_fabk_id
               use-index fabd_fa_id no-lock:
            end. /* FOR LAST fabd-det */

            {gprunp.i "fapl" "p" "fa-get-accdep"
               "(input  fab_fa_id,
                 input  fab_fabk_id,
                 input  input frame f-1 faadj_yrper,
                 output l-beg-accdep)"}

            {gprunp.i "fapl" "p" "fa-get-accdep"
               "(input  fab_fa_id,
                 input  fab_fabk_id,
                 input  fabd-det.fabd_yrper,
                 output l-end-accdep)"}

            l-remain-total = l-end-accdep - l-beg-accdep.

            if l-remain-total < input frame f-1 faadj_amt
            then do:
               /* Bonus amount exceeds remaining depreciations */
               {pxmsg.i &MSGNUM=3216 &ERRORLEVEL=3}
               l-error = yes.
            end. /* IF l-remain-total < INPUT FRAME f-1 faadj_amt */
         end.  /* IF l-error = NO AND l-type = "1" */
         {&FAFAMTG-P-TAG7}
         if l-error = no
         and l-type = "2"
         then do:
         {&FAFAMTG-P-TAG8}
            {gprun.i ""faajbla.p""
               "(buffer fa_mstr,
                 buffer fab_det,
                 input  frame f-1 faadj_amt,
                 output l-err-nbr)"}

            if global-beam-me-up
            then
               undo, leave.

            if l-err-nbr <> 0
            then do:
               {pxmsg.i &MSGNUM=l-err-nbr &ERRORLEVEL=3}
               l-error = yes.
            end. /* IF l-err-nbr <> 0 */

         end. /* IF l-error = NO AND l-type = "2" */

         if l-error
         then do:
            next-prompt faadj_amt with frame f-1.
            next.
         end. /* IF l-error */
         /* END FIELD EDIT FOR faadj_amt */

         /* FIELD EDIT FOR faadj_yrper */
         l-error = no.
         if l-type = "1"
         or l-type = "5"
         or l-type = "6"
         then do:

            /* CHECK IF YEAR PERIOD ENTERED IS A VALID ENTRY */
            {gprunp.i "fapl" "p" "fa-chk-input-yrper"
               "(input  frame f-1 faadj_yrper,
                 output l-error-number)"}

            if l-error-number <> 0
            then do:
               l-error = yes.
               /*  40: BLANK NOT ALLOWED */
               /* 495: INVALID PERIOD    */
               {pxmsg.i &MSGNUM=l-error-number &ERRORLEVEL=3}
                next-prompt
                   faadj_yrper
                with frame f-1.
                next.
            end. /* IF l-error-number <> 0 */

            {gprunp.i "fapl" "p" "fa-get-suspend"
               "(input  fab_fa_id,
                 input  fab_fabk_id,
                 input  input frame f-1 faadj_yrper,
                 output l-suspend)"}

            {gprunp.i "fapl" "p" "fa-get-post"
               "(input  fab_fa_id,
                 input  fab_fabk_id,
                 input  input frame f-1 faadj_yrper,
                 output l-post)"}

            /* FIND THE START DATE FOR A GIVEN YEAR AND PERIOD */
            {gprunp.i "fapl" "p" "fa-conv-per-to-date"
               "(input  fabk_mstr.fabk_calendar,
                 input  frame f-1 faadj_yrper,
                 output l-adj-date,
                 output l-error-number)"}

            if l-error-number <> 0
            then do:
               l-error = yes.
               /* DATE NOT WITHIN A VALID PERIOD */
               {pxmsg.i &MSGNUM=l-error-number &ERRORLEVEL=3}
            end. /* IF l-error-number <> 0 */

            if fabk_calendar = ""
            and l-error      = no
            then do:
               {gprun.i ""gpglef1.p""
                  "(input ""FA"",
                    input fa_entity,
                    input l-adj-date,
                    output gpglef_result,
                    output gpglef_msg_nbr)"}

               if global-beam-me-up
               then
                  undo, leave.

               if gpglef_result > 0
               then do:
                  {pxmsg.i &MSGNUM=gpglef_msg_nbr &ERRORLEVEL=3}
                  l-error = yes.
               end. /* IF gpglef_result > 0 */
            end.  /* IF fabk_calendar = "" */

            if l-error = no
            then do:

               for first fabd-det
                  fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper
                  fabd_suspend
                          fabd_post)
                   where fabd-det.fabd_domain = global_domain and  fabd_fa_id =
                   l-fa-id
                  and fabd_fabk_id = l-fabk-id
                  use-index fabd_fa_id:
               end. /* FOR FIRST fabd-det */

               if available fabd-det
               and input frame f-1 faadj_yrper < fabd_yrper
               then do:
                  /* Cannot adjust - period less than beginning
                  depreciation period */
                  {pxmsg.i &MSGNUM=3218 &ERRORLEVEL=3}
                  l-error = yes.
               end. /* IF AVAILABLE fabd-det */
            end.  /* IF l-error = NO */

            if l-error = no
            then do:

               for last fabd-det
                  fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper
                  fabd_suspend
                          fabd_resrv fabd_post)
                   where fabd-det.fabd_domain = global_domain and  fabd_fa_id =
                   fab_fa_id
                  and fabd_fabk_id = fab_fabk_id
                  use-index fabd_fa_id no-lock:
               end. /* FOR LAST fabd-det */

               if l-type <> "6"
               and input frame f-1 faadj_yrper > fabd_yrper
               then do:
                  /* Adjustment date later than depreciation end date */
                  {pxmsg.i &MSGNUM=3217 &ERRORLEVEL=3}
                  l-error = yes.
               end. /* IF l-type <> 6 */
            end.  /* IF l-error = NO */

            if l-error = no
            and l-type = "6"
            then do:

               run p_err_messg.

            end. /* IF l-error = no ... */
            else
            if l-error = no
            and l-type <> "6"
            then
               if l-suspend = yes
               then do:
                  /* Cannot adjust - depreciation suspended */
                  {pxmsg.i &MSGNUM=3226 &ERRORLEVEL=3}
                  l-error = yes.
               end. /* IF l-suspend = YES */
               else
               if l-post
               then do:
                  /* Cannot adjust - depreciation posted */
                  {pxmsg.i &MSGNUM=3222 &ERRORLEVEL=3}
                  l-error = yes.
               end. /* IF l-post */
               else
               CASE l-type:
               when "1"
               then do:

                  l-cnt = 0.

                  for each fabd-det
                     fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper
                     fabd_suspend
                             fabd_resrv fabd_post)
                      where fabd-det.fabd_domain = global_domain and
                      fabd_fa_id = l-fa-id
                     and fabd_fabk_id = l-fabk-id
                     and fabd_yrper > input frame f-1 faadj_yrper
                     no-lock
                     break by fabd_yrper:

                     if first-of(fabd_yrper)
                     then do:

                        if fabd_post = yes
                        then
                           next.
                        l-cnt = l-cnt + 1.
                        leave.
                     end.  /* IF FIRST-OF ... */
                  end.  /* FOR EACH fabd-det ... */

                  if l-cnt = 0
                  then do:
                     /* Cannot adjust - final period */
                     {pxmsg.i &MSGNUM=3227 &ERRORLEVEL=3}
                     l-error = yes.
                  end. /* IF l-cnt = 0 */

               end.  /* when "1" */
               when "5"
               then do:

                  define buffer b-faadj for faadj_mstr.

                  if can-find(b-faadj
                               where b-faadj.faadj_domain = global_domain and
                               faadj_fa_id = l-fa-id
                              and faadj_fabk_id = l-fabk-id
                              and faadj_type = "5"
                              and faadj_yrper >= input frame f-1
                                                 faadj_mstr.faadj_yrper)
                  then do:
                     /* Suspend already happened in a later date */
                     {pxmsg.i &MSGNUM=3215 &ERRORLEVEL=3}
                     l-error = yes.
                  end. /* IF CAN_FIND(b-faadj */
               end. /* WHEN "5" */

            END CASE.

         end.  /* if "1" or "5" or "6" */

         else
         if l-type = "2"
         or l-type = "3"
         or l-type = "4"
         {&FAFAMTG-P-TAG9}
         then do:
            for first fabd-det
               fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper
               fabd_suspend
                       fabd_resrv fabd_post)
                where fabd-det.fabd_domain = global_domain and  fabd_fa_id =
                l-fa-id
               and fabd_fabk_id = l-fabk-id
               and fabd_post = no
               and fabd_suspend = no
               no-lock
               use-index fabd_fa_id:
            end. /* FOR FIRST fabd-det */

            if available fabd-det
            then
               faadj_mstr.faadj_yrper:screen-value = fabd_yrper.
         end. /* IF l-type = "2" ... */

         if l-error
         then do:
            next-prompt faadj_yrper with frame f-1.
            next.
         end. /* IF l-error */

         /* END FIELD EDIT FOR faadj_yrper */

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
         get first q_faadj_mstr no-lock.

         if available faadj_mstr
         then
            assign
               perform-status = "first"
               l-rowid        = rowid(faadj_mstr).
         else
            assign
               perform-status = ""
               l-rowid        = ?.

         clear frame f-1 no-pause.
      end. /* IF perform-status = "add" */
      else
      if available faadj_mstr
      then
         assign
            perform-status = ""
            l-rowid        = rowid(faadj_mstr).
      return.
   end. /* IF KEYFUNCTION(LASTKEY) = "end-error" */

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

         if available faadj_mstr
         then
            get current q_faadj_mstr no-lock.

         if available faadj_mstr
         and current-changed faadj_mstr
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
            end. /* IF l-delete-it = NO */

            hide message no-pause.
         end. /* IF AVAILABLE faadj_mstr */

         if available faadj_mstr
         then
            tran-lock:
            do while perform-status <> "":

               get current q_faadj_mstr exclusive-lock no-wait.

               if locked faadj_mstr
               then do:

                  if pos < 3
                  then do:
                     pos = pos + 1.
                     pause 1 no-message.
                     next tran-lock.
                  end. /* IF pos < 3 */

                  perform-status = "error".
               end. /*  IF LOCKED faadj_mstr */

               leave.
            end. /*while*/

         if (perform-status = "update"
         or  p-status       = "update")
         and l-delete-it    = yes
         then
            run ip-update
               (input-output perform-status).

         if perform-status = "delete"
         then
            run ip-delete
               (input-output perform-status).

         if l-error
         then
            undo ip-lock, leave.
      /* ------------  END /* LOCKED-EDITS */  ----------- */

      if available faadj_mstr
      then
         get current q_faadj_mstr no-lock.
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

   perform-status = "open".

   run ip-query
      (input-output perform-status,
       input-output l-rowid).

   reposition q_faadj_mstr to rowid l-rowid no-error.

   get next q_faadj_mstr no-lock.

   assign
      perform-status = "first"
      l-rowid        = rowid(faadj_mstr).
   return.

END PROCEDURE. /* ip-update */

PROCEDURE ip-add:

   define input-output parameter perform-status as character no-undo.

   create faadj_mstr. faadj_mstr.faadj_domain = global_domain.
   run ip-assign
      (input-output perform-status).

   perform-status = "open".

   /* UPDATE THE POST FLAG AND AMOUNT FOR BASIS ADJUSTMENT */
   if faadj_mstr.faadj_type = "2" and
      fabk_mstr.fabk_post
   then do:
      l_astpost = yes.

      /* GET THE DELTA OF ADJUSTED COST */
      run ip_getcostdiff
         (input faadj_mstr.faadj_fa_id,
          input faadj_mstr.faadj_fabk_id,
          input faadj_mstr.faadj_resrv,
          input yes,
          input-output l_cost).

   end. /* IF faadj_mstr.faadj_type = "2" */

   run ip-query
      (input-output perform-status,
       input-output l-rowid).

   reposition q_faadj_mstr to rowid l-rowid no-error.

   get next q_faadj_mstr no-lock.

   assign
      perform-status = "first"
      l-rowid        = rowid(faadj_mstr).
   return.

END PROCEDURE. /* ip-add */

PROCEDURE ip-delete:

   define input-output parameter perform-status as character no-undo.

   {&FAFAMTG-P-TAG12}
   l-delete-it = no.
   /* Please confirm delete */
   {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=l-delete-it
            &CONFIRM-TYPE='LOGICAL'}
   {&FAFAMTG-P-TAG13}
   CASE l-delete-it:
      when yes
      then do:
         /* UPDATE THE POST FLAG AND AMOUNT FOR BASIS ADJUSTMENT */
         if faadj_mstr.faadj_type = "2"
         then do:
            l_astpost = yes.

            /* GET THE DELTA OF ADJUSTED COST */
            run ip_getcostdiff
               (input l-fa-id,
                input l-fabk-id,
                input faadj_mstr.faadj_resrv,
                input no,
                input-output l_cost).

         end. /* IF faadj_mstr.faadj_type = "2" */

         hide message no-pause.
         /* CHANGED SECOND AND THIRD INPUT PARAMETERS FROM */
         /* fab_det.fab_fa_id AND fab_det.fab_fabk_id TO   */
         /* l-fa-id AND l-fabk-id RESPECTIVELY             */
         {gprun.i ""faudbl.p"" "(buffer faadj_mstr,
                                 input  l-fa-id,
                                 input  l-fabk-id)"}

         if global-beam-me-up
         then
            undo, leave.

         delete faadj_mstr.

         for last fab_det
            fields( fab_domain fab_fabk_id fab_famt_id fab_fa_id fab_life)
             where fab_det.fab_domain = global_domain and  fab_fa_id = l-fa-id
            and fab_fabk_id = l-fabk-id
            no-lock
            use-index fab_resrv:
         end. /* FOR LAST fab_det */

         clear frame f-1 no-pause.
         get next q_faadj_mstr no-lock.

         if available faadj_mstr
         then
            assign
               perform-status = "first"
               l-rowid        = rowid(faadj_mstr)
               l-resrv = faadj_resrv
               l-last-type = faadj_type.
         else do:
            get prev q_faadj_mstr no-lock.
            if available faadj_mstr
            then
               assign
                  perform-status = "first"
                  l-rowid        = rowid(faadj_mstr)
                  l-resrv        = faadj_resrv
                  l-last-type    = faadj_type.
            else
               assign
                  perform-status = "first"
                  l-rowid        = rowid(faadj_mstr)
                  l-resrv        = 0
                  l-last-type    = "".
         end. /* ELSE DO */

         /* RECORD DELETED */
         {pxmsg.i &MSGNUM=22 &ERRORLEVEL=1}
         return.
      end. /* WHEN YES */
      otherwise
         run ip-displayedits.

   END CASE.

END PROCEDURE. /* ip-delete */

PROCEDURE ip-assign:

   define input-output parameter perform-status as character no-undo.

   do with frame f-1:
      assign
         faadj_mstr.faadj_fa_id      = l-fa-id
         faadj_mstr.faadj_resrv      = l-resrv + 1
         faadj_mstr.faadj_fabk_id    = l-fabk-id
         faadj_mstr.faadj_mod_userid = global_userid
         faadj_mstr.faadj_mod_date   = today
         faadj_mstr.faadj_life
         faadj_mstr.faadj_amt
         faadj_mstr.faadj_yrper
         faadj_mstr.faadj_famt_id
         faadj_mstr.faadj_type       = l-type
         l-rowid                     = rowid(faadj_mstr).

      if recid(faadj_mstr) = -1 then .

      /* --------  /* AFTER-ASSIGN-AUDIT-INCLUDE */  ------- */
      /* SS - 090507.1 - B
      {gprun.i ""faajblb.p""
         "(buffer fa_mstr,
           buffer fab_det,
           buffer faadj_mstr,
           output l-err-nbr)"}
      SS - 090507.1 - E */

      /* SS - 090507.1 - B */
      {gprun.i ""xxfafam1ajblb.p""
         "(buffer fa_mstr,
           buffer fab_det,
           buffer faadj_mstr,
           output l-err-nbr)"}
      /* SS - 090507.1 - E */

      if global-beam-me-up
      then
         undo, leave.

      if l-err-nbr = 0
      then do:

         for last fab_det
            fields( fab_domain fab_fabk_id fab_famt_id fab_fa_id fab_life)
             where fab_det.fab_domain = global_domain and  fab_fa_id = l-fa-id
            and fab_fabk_id = l-fabk-id
            no-lock
            use-index fab_resrv:
         end. /* FOR LAST fab_det */

         assign
            l-resrv     = faadj_resrv
            l-last-type = faadj_type.
      end. /* IF l-err-nbr = 0 */
      else do:
         {pxmsg.i &MSGNUM=l-err-nbr &ERRORLEVEL=4}
         l-error = yes.
         scroll from-current up with frame f-1.
         {&FAFAMTG-P-TAG14}
      end. /* ELSE DO */
      /* ------  END /* AFTER-ASSIGN-AUDIT-INCLUDE */  ----- */

   end. /* DO WITH FRAME f-1 */

END PROCEDURE. /* ip-assign */

PROCEDURE ip-predisplay:

   if (perform-status = ""
   or perform-status = "update")
   and available faadj_mstr
   then
      display-loop:
      do:

         if perform-status = ""
         then do:

            clear frame f-1 all no-pause.
            l-top-rowid = rowid(faadj_mstr).
         end. /* IF perform-status = "" */

         read-loop:
         do pos = 1 to lines:
            if perform-status = ""
            then do:
               if session:display-type = "gui"
               then
                  assign
                     l-type-desc:bgcolor = 8
                     l-type-desc:fgcolor = 0.
               else
                  color display normal l-type-desc
                  with frame f-1.
            end. /* IF perform-status = "" */

            run ip-displayedits.

            if perform-status = "update"
            then
               leave display-loop.

            if pos < lines
            then
               down with frame f-1.

            get next q_faadj_mstr no-lock.

            if not available faadj_mstr
            then
               leave.
         end. /* DO pos = 1 to lines */

         run ip-postdisplay.
      end. /* DO */

END PROCEDURE. /* ip-predisplay */

PROCEDURE ip-displayedits:

   if available faadj_mstr
   then do:

      /* DISPLAY-EDITS */
      {gplngn2a.i
         &file = ""faadj_mstr""
         &field = ""faadj_type""
         &code = faadj_type
         &mnemonic = l-type-desc
         &label = l-type-translation}
      /* DISPLAY-EDITS */

      run ip-display.
   end. /* IF AVAILABLE faadj_mstr */

END PROCEDURE. /* ip-displayedits */

PROCEDURE ip-display:

   display
      faadj_mstr.faadj_life
      faadj_mstr.faadj_amt
      faadj_mstr.faadj_yrper
      faadj_mstr.faadj_famt_id
      l-type-desc
   with frame f-1.

END PROCEDURE. /* ip-display */

PROCEDURE ip-postdisplay:

   do pos = 1 to lines:
      if frame-line(f-1) <= 1
      then
         leave.
      up 1 with frame f-1.
   end. /* DO pos = 1 to lines */

   if perform-status = ""
   then do:
      reposition q_faadj_mstr to rowid l-top-rowid no-error.
      get next q_faadj_mstr no-lock.
      l-rowid = l-top-rowid.
      color display message l-type-desc
      with frame f-1.
   end. /* IF perform-status = "" */

END PROCEDURE. /* ip-postdisplay */

PROCEDURE ip-query:

   define input-output parameter perform-status as character no-undo.
   define input-output parameter l-rowid as rowid no-undo.

   if perform-status = "first"
   then do:

      if l-rowid <> ?
      then do:

         reposition q_faadj_mstr to rowid l-rowid no-error.
         get next q_faadj_mstr no-lock.
      end. /* IF l-rowid <> ? */

      if not available faadj_mstr
      then
         get first q_faadj_mstr no-lock.

      if available faadj_mstr
      then
         assign
            perform-status = ""
            l-rowid        = rowid(faadj_mstr).
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

      open query q_faadj_mstr
         for each faadj_mstr
             where faadj_mstr.faadj_domain = global_domain and  faadj_fa_id =
             l-fa-id
            and faadj_fabk_id = l-fabk-id
            and faadj_type < "90"
            use-index faadj_fa_id no-lock.

      reposition q_faadj_mstr to rowid l-rowid no-error.
      get next q_faadj_mstr no-lock.

      if available faadj_mstr
      then
         assign
            perform-status = ""
            l-rowid        = rowid(faadj_mstr).
      else do:
         get first q_faadj_mstr no-lock.
         if not available faadj_mstr
         then do:
            assign
               perform-status    = ""
               frame f-1:visible = true.
            return.
         end. /* IF NOT AVAILABLE faadj_mstr */
         else
            assign
               perform-status = ""
               l-rowid        = rowid(faadj_mstr).
      end. /* ELSE DO */

   end. /* IF perform-status = "open" */

   if perform-status = "next"
   then do:

      get next q_faadj_mstr no-lock.
      if available faadj_mstr
      then do:
         hide message no-pause.
         assign
            l-rowid        = rowid(faadj_mstr)
            perform-status = "next".

         if session:display-type = "gui"
         then
            assign
               l-type-desc:bgcolor = 8
               l-type-desc:fgcolor = 0.
         else
            color display normal l-type-desc
            with frame f-1.
         pause 0.  /* MAKES SCROLLING WORK - DON'T REMOVE */
         down 1 with frame f-1.
         run ip-displayedits.
         color display message l-type-desc
         with frame f-1.
      end. /* IF AVAILABLE faadj_mstr */
      else do:
         perform-status = "next".
         /* End of file */
         {pxmsg.i &MSGNUM=20 &ERRORLEVEL=2}
         get last q_faadj_mstr no-lock.
      end. /* ELSE DO */

   end. /* IF perform-status = "next" */

   if perform-status = "prev"
   then do:

      get prev q_faadj_mstr no-lock.
      if not available faadj_mstr
      then do:
         {pxmsg.i &MSGNUM=21 &ERRORLEVEL=2} /* BEGINNING OF FILE */
         get first q_faadj_mstr no-lock.
         return.
      end. /* IF NOT AVAILABLE faadj_mstr */

      hide message no-pause.
      l-rowid = rowid(faadj_mstr).
      if session:display-type = "gui"
      then
         assign
            l-type-desc:bgcolor = 8
            l-type-desc:fgcolor = 0.
      else
         color display normal l-type-desc
         with frame f-1.

      pause 0.  /* MAKES SCROLLING WORK - DON'T REMOVE */
      up 1 with frame f-1.
      run ip-displayedits.
      color display message l-type-desc
      with frame f-1.
   end. /* IF perform-status = "prev" */

   if perform-status = "update"
   or perform-status = "delete"
   then do:

      get current q_faadj_mstr no-lock.
      if not available faadj_mstr
      then do:
         hide message no-pause.
         /* Record not found */
         {pxmsg.i &MSGNUM=1310 &ERRORLEVEL=3}
         perform-status = "".
      end. /* IF NOT AVAILABLE faadj_mstr */

   end. /* IF perform-status = "update" */
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
      frame f-1:title         = (getFrameTitle("DEPRECIATION_ADJUSTMENTS",34))
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

      on choose of b-add
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle.
         hide frame f-button no-pause.
      end. /* DO */

      on choose of b-undo
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle
            l-title        = current-window:title + " - " + self:label.
         hide frame f-button no-pause.
      end. /* DO */

      on choose of b-end
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle.
         hide frame f-1 no-pause.
         hide frame f-button no-pause.
      end. /* DO */

      on cursor-up, f9 anywhere
      do:
         assign
            perform-status = "prev"
            l-focus        = focus:handle.
         apply "go" to frame f-button.
      end. /* DO */

      on cursor-down, f10 anywhere
      do:
         assign
            perform-status = "next"
            l-focus        = focus:handle.
         apply "go" to frame f-button.
      end. /* DO */

      on cursor-right anywhere
      do:
         l-focus = self:handle.
         apply "tab" to l-focus.
      end. /* DO */

      on cursor-left anywhere
      do:
         l-focus = self:handle.
         if session:display-type = "gui"
         then
            apply "shift-tab" to l-focus.
         else
            apply "ctrl-u" to l-focus.
      end. /* DO */

      on f3 anywhere
         apply "choose" to b-add in frame f-button.
      on esc anywhere
      do:
         if session:display-type = "gui"
         then
            apply "choose" to b-end in frame f-button.
      end. /* DO */

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
      end. /* DO */

      wait-for
         go of frame f-button or
         window-close of current-window or
         choose of
         b-add,
         b-undo,
         b-end
         focus
         l-focus.

   end. /* IF NOT batchrun */
   else
      set perform-status.

   hide message no-pause.
END PROCEDURE. /* PROCEDURE ip-button */


PROCEDURE ip_getcostdiff :
   define input        parameter i_asset  like faadj_fa_id   no-undo.
   define input        parameter i_book   like faadj_fabk_id no-undo.
   define input        parameter i_resrv  like faadj_resrv   no-undo.
   define input        parameter i_add    like mfc_logical   no-undo.
   define input-output parameter io_cost  like fa_puramt     no-undo.

   for each fab_det
      fields( fab_domain fab_fa_id fab_fabk_id fab_resrv fab_amt)
       where fab_det.fab_domain = global_domain and  fab_fa_id   = i_asset
      and   fab_fabk_id = i_book
      and   fab_resrv   = i_resrv
      no-lock:
      if i_add
      then
         io_cost = io_cost + fab_amt.
      else
         io_cost = io_cost - fab_amt.
   end. /* FOR EACH fab_det */
END PROCEDURE. /* IP_GETCOSTDIFF */

/* TO DISPLAY ERROR MESSAGES ON INPUT OF faadj_yrper FIELD */
PROCEDURE p_err_messg:

            define buffer fabddet for fabd_det.

            if  not (can-find(first fabd_det
                                  where fabd_det.fabd_domain = global_domain
                                  and  fabd_fa_id = l-fa-id
                                 and fabd_fabk_id = l-fabk-id
                                 and fabd_suspend = yes
                                 and fabd_yrper  = input frame f-1 faadj_yrper))
            then do:
               /* CANNOT REINSTATE. ASSET NOT SUSPENDED */
               {pxmsg.i &MSGNUM=5969 &ERRORLEVEL=3}
               /* SET l-error FLAG TO UNDO,LEAVE */
               l-error = yes.
            end. /* IF NOT (CAN-FIND ( FIRST fabd_det ... */

            else do:

               for first last-faadj
                  fields( faadj_domain faadj_amt      faadj_fabk_id
                  faadj_famt_id
                          faadj_fa_id    faadj_life       faadj_migrate
                          faadj_mod_date faadj_mod_userid faadj_resrv
                          faadj_type     faadj_yrper)
                   where last-faadj.faadj_domain = global_domain and
                   last-faadj.faadj_fa_id   = l-fa-id
                  and   last-faadj.faadj_fabk_id = l-fabk-id
                  and   last-faadj.faadj_type    = "5"
                  no-lock:

                  if input frame f-1 faadj_mstr.faadj_yrper
                      <= last-faadj.faadj_yrper
                  then do:
                     /* REINSTATE DATE MUST BE LATER THAN SUSPEND DATE */
                     {pxmsg.i &MSGNUM=3219 &ERRORLEVEL=3}
                     l-error = yes.
                  end. /* IF INPUT FRAME f-1 faadj_mstr.faadj_yrper ... */

               end. /* FOR FIRST last-faadj */

            end. /* ELSE DO */

            if l-error
            then do:
               next-prompt faadj_mstr.faadj_yrper with frame f-1.
               next.
            end. /* IF l-error */

            for first fabddet
               fields( fabd_domain fabd_fabk_id fabd_fa_id   fabd_post
                       fabd_resrv   fabd_suspend fabd_transfer
                       fabd_yrper   fabd__qadl01)
                where fabddet.fabd_domain = global_domain and
                fabddet.fabd_fa_id     = l-fa-id
               and   fabddet.fabd_fabk_id   = l-fabk-id
               and   fabddet.fabd_transfer  = yes
               and   fabddet.fabd__qadl01   = yes
               and   fabddet.fabd_yrper     >
                     input frame f-1 faadj_mstr.faadj_yrper
               no-lock:
               /* ASSET TRANSFERRED AND POSTED IN #. */
               /* REINSTATE IN A LATER PERIOD        */
               {pxmsg.i &MSGNUM=5971 &ERRORLEVEL=3
                        &MSGARG1=fabddet.fabd_yrper}
               l-error = yes .
            end. /* FOR FIRST fabddet */

END. /* PROCEDURE p_err_messg */
