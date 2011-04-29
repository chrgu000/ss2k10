/* fafamta.p - FIXED ASSET MAINTENANCE - Depreciation Books                  */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.23.1.29 $                                                    */
/*V8:ConvertMode=NoConvert                                                   */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99   BY: *N021* Pat Pigatti       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 05/17/00   BY: *M0LJ* Vihang Talwalkar  */
/* REVISION: 9.1      LAST MODIFIED: 07/28/00   BY: *N0BX* Arul Victoria     */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder     */
/* REVISION: 9.1      LAST MODIFIED: 12/18/00   BY: *M0Y3* Veena Lad         */
/* REVISION: 9.1      LAST MODIFIED: 01/02/01   BY: *M0YM* Veena Lad         */
/* Revision: 1.23.1.15     BY: Alok Thacker       DATE: 03/13/02 ECO: *M1NB* */
/* Revision: 1.23.1.16     BY: Manish Dani        DATE: 12/20/02 ECO: *M1YW* */
/* Revision: 1.23.1.17     BY: Rajesh Lokre       DATE: 04/03/03 ECO: *M1RX* */
/* Revision: 1.23.1.18     BY: Veena Lad          DATE: 05/21/03 ECO: *N2FY* */
/* Revision: 1.23.1.20     BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00C* */
/* Revision: 1.23.1.21     BY: Veena Lad          DATE: 10/17/03 ECO: *N2LF* */
/* Revision: 1.23.1.22     BY: Dorota Hohol       DATE: 10/27/03 ECO: *P138* */
/* Revision: 1.23.1.23     BY: Robert Jensen      DATE: 09/02/04 ECO: *N2XK* */
/* Revision: 1.23.1.28     BY: Vandna Rohira      DATE: 12/17/04 ECO: *P2Z5* */
/* $Revision: 1.23.1.29 $  BY: Sushant Pradhan    DATE: 09/22/05 ECO: *P421* */

/* SS - 100505.1  By: Roger Xiao */  /*add v_backward when adjust the basis or life */
/* SS - 100525.1  By: Roger Xiao */  /*fix qad bug ,Solution ID: qad50713  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "FAFAMTA.P"}
/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

/* ********** BEGIN TRANSLATABLE STRINGS DEFINITION ********* */
&SCOPED-DEFINE fafamta_p_1 "Net Book Value"
/* MaxLen: 19 Comment: */

&SCOPED-DEFINE fafamta_p_2 "As Of"
/* MaxLen: 7 Comment: */

&SCOPED-DEFINE fafamta_p_3 "Add"
/* MaxLen: 6 Comment: Button label - Add*/

&SCOPED-DEFINE fafamta_p_4 "Delete"
/* MaxLen: 6 Comment: Button label - Delete*/

&SCOPED-DEFINE fafamta_p_5 "Adjust"
/* MaxLen: 6 Comment: Button label - Adjust*/

&SCOPED-DEFINE fafamta_p_6 "Detail"
/* MaxLen: 6 Comment: Button label - Detail*/

&SCOPED-DEFINE fafamta_p_7 "Audit"
/* MaxLen: 6 Comment: Button label - Audit*/

&SCOPED-DEFINE fafamta_p_8 "UOP"
/* MaxLen: 6 Comment: Button label - UOP*/

&SCOPED-DEFINE fafamta_p_9 "End"
/* MaxLen: 6 Comment: Button label - End*/

&SCOPED-DEFINE fafamta_p_11 "Find"
/* MaxLen: 6 Comment: Button label - Find */

/* ********** END TRANSLATABLE STRINGS DEFINITION ********* */

define input parameter l_firstcost      like fa_puramt   no-undo.
define input-output parameter p-status  as character format "x(25)" no-undo.
define input-output parameter l_newbk   like mfc_logical no-undo.
define input-output parameter l_astpost like mfc_logical no-undo.
define input-output parameter l_cost    like fa_puramt   no-undo.
define parameter buffer fa_mstr for fa_mstr.

/* --------------------  DEFINE QUERY  ------------------- */
define query q_fab_det
   for fab_det
      fields( fab_domain fab_amt fab_date fab_fabk_id fab_fabk_seq fab_famt_id
             fab_fa_id fab_life fab_ovramt fab_mod_date fab_mod_userid
             fab_resrv fab_um fab_famtr_id fab_uplife fab_upper)
      scrolling.

/* -----------------  STANDARD VARIABLES  ---------------- */
define variable perform-status as character format "x(25)"
                                      initial "first" no-undo.
define variable p-skip-update like mfc_logical        no-undo.
define variable l-rowid       as   rowid              no-undo.
define variable l-delete-it   like mfc_logical        no-undo.
define variable l-del-rowid   as   rowid              no-undo.
define variable l-top-rowid   as   rowid              no-undo.
define variable lines         as   integer initial 10 no-undo.
define variable l-found       like mfc_logical        no-undo.
define variable pos           as   integer            no-undo.
define variable l-first       like mfc_logical        no-undo.
define variable l-error       like mfc_logical        no-undo.
define variable l-title       as   character          no-undo.
define variable l_ovramt      like fab_ovramt         no-undo.

/* ------------------  BUTTON VARIABLES  ----------------- */
define button b-add    label {&fafamta_p_3}.
define button b-delete label {&fafamta_p_4}.
define button b-adjust label {&fafamta_p_5}.
define button b-detail label {&fafamta_p_6}.
define button b-audit  label {&fafamta_p_7}.

define button b-find   label {&fafamta_p_11}.

define button b-uop    label {&fafamta_p_8}.
define button b-end    label {&fafamta_p_9}.

/* -------------  STANDARD WIDGET VARIABLES  ------------- */
define variable l-focus as widget-handle no-undo.
define variable w-frame as widget-handle no-undo.

/* ------------------  SCREEN VARIABLES  ----------------- */
define new shared variable l-fa-id   as character format "x(8)"   no-undo.
define new shared variable l-id      as character format "x(12)"  no-undo.
define new shared variable l-seq     as integer   format "9999"   no-undo.
define new shared variable l-type    as character format "x(10)"  no-undo.
define new shared variable l-fabk-id as character format "x(4)"   no-undo.

define     shared variable l-flag    like            mfc_logical  no-undo.

define variable l_net            as decimal   format "->>>,>>>,>>>,>>9.99<"
                                                                  no-undo.
define variable l-err-nbr        as   integer    format ">>>9" initial 0
                                                                  no-undo.
define variable l_asd_seq        as   integer    format "9999"    no-undo.
define variable l_acc            as   decimal    format "->,>>>,>>9.99"
                                                                  no-undo.
define variable l_dep            as   decimal    format "->>>,>>>,>>>.99"
                                                                  no-undo.
define variable l_dispose        like mfc_logical                 no-undo.
define variable l-cal            as   character  format "x(8)"    no-undo.
define variable l-basis-amt      like fab_amt                     no-undo.
define variable correct-yn       like mfc_logical initial yes     no-undo.
define variable l-basis-amt-fmt  as   character  format "x(30)"   no-undo.
define variable l_net_fmt        as   character  format "x(30)"   no-undo.
define variable l-asof-date      as   character  format "9999-99" no-undo.
define variable l-famt-id        like famt_id                     no-undo.
define variable l-fab-life       like fab_life                    no-undo.
define variable l-period         as   character  format "x(6)"    no-undo.
define variable l-table          like mfc_logical                 no-undo.
define variable l-famtr-id       like fab_famtr_id                no-undo.
define variable l-uplife         like fab_uplife                  no-undo.
define variable l-upper          like fab_upper                   no-undo.
define variable l-um             like fab_um                      no-undo.
{&FAFAMTA-P-TAG1}
/* ------------------  FRAME DEFINITION  ----------------- */
/* ADDED SIDE-LABELS PHRASE TO FRAME STATEMENT              */

define frame f-button
   b-add    at 1
   b-adjust at 10
   b-detail at 19
   b-audit  at 28
   b-uop    at 37
   b-find   at 46
   b-delete at 55
   b-end    at 64
with no-box overlay three-d side-labels width 72.

/* CLEAR FRAME REGISTRATION TO TRANSLATE THE FRAME EVERYTIME*/
clearFrameRegistration(frame f-button:handle).

/* SET EXTERNAL LABELS */
setFrameLabels(frame f-button:handle).

assign
   l-focus               = b-add:handle in frame f-button
   b-add:width           = 8
   b-add:private-data    = "add"
   b-delete:width        = 8
   b-delete:private-data = "delete"
   b-adjust:width        = 8
   b-adjust:private-data = "adjust"
   b-detail:width        = 8
   b-detail:private-data = "detail"
   b-audit:width         = 8
   b-audit:private-data  = "audit"
   b-find:width          = 8
   b-find:private-data   = "find"
   b-uop:width           = 8
   b-uop:private-data    = "uop"
   b-end:width           = 8
   b-end:private-data    = "end".

define frame f-1
   skip(.4)
   fab_fabk_id
   fab_date
   l-famt-id
   l-fab-life
   l-basis-amt
   l_net       column-label {&fafamta_p_1}
   l-asof-date column-label {&fafamta_p_2}
   format "9999-99"
with three-d overlay 3 down scroll 1 width 80.

/* CLEAR FRAME REGISTRATION TO TRANSLATE THE FRAME EVERYTIME*/
clearFrameRegistration(frame f-1:handle).

/* SET EXTERNAL LABELS */
setFrameLabels(frame f-1:handle).

run ip-framesetup.

w-frame = frame f-1:handle.
{gprun.i ""fafmtut.p""
   "(w-frame)"}

lines = 03.

if p-status = "add"
then do:
   frame f-1:visible = true.
   return.
end. /* IF p-status = "add" */

/* ---------------  PRE PROCESSING INCLUDE  -------------- */
/* FUNCTION TO VALIDATE ESTIMATED LIFE */
{falffx.i}

/* VARIABLES FOR GPGLEF1.I */
{gpglefv.i}

/* VARIABLES FOR FA PERSISTENT PROCEDURES */
{gprunpdf.i "fapl" "p"}

define new shared temp-table dep no-undo like fabd_det.

/* SET CURRENCY DEPENDENT ROUNDING FORMATS */
for first gl_ctrl
   fields( gl_domain gl_rnd_mthd)
    where gl_ctrl.gl_domain = global_domain no-lock:
end. /* FOR FIRST gl_ctrl */

assign
   l-basis-amt-fmt = l-basis-amt:format
   l_net_fmt       = l_net:format.

{gprun.i ""gpcurfmt.p""
   "(input-output l-basis-amt-fmt,
     input        gl_rnd_mthd)"}
if global-beam-me-up then undo, leave.

{gprun.i ""gpcurfmt.p""
   "(input-output l_net_fmt,
     input        gl_rnd_mthd)"}
if global-beam-me-up
then undo, leave.

assign
   l-basis-amt:format = l-basis-amt-fmt
   l_net:format       = l_net_fmt.
/* -------------  END PRE PROCESSING INCLUDE  ------------ */
{&FAFAMTA-P-TAG2}
open query q_fab_det
   for each fab_det
       where fab_det.fab_domain = global_domain and  fab_fa_id = fa_mstr.fa_id
      and   fab_resrv = 0
      use-index fab_fa_id
      no-lock.

if fa_mstr.fa_disp_dt <> ?
then
   l_dispose = yes.

get first q_fab_det
   no-lock.

main-loop:
do while perform-status <> "end" on error undo:
   if perform-status = ""
      and p-status = "first-one"
   then
      return.

   if p-status = "end"
   then
      perform-status = "end".

   run ip-query
      (input-output perform-status,
       input-output l-rowid).

   if perform-status = "delete"
   then do:
      run ip-lock
         (input-output perform-status).
      perform-status = "first".
      run ip-predisplay.
   end. /* IF PERFORM-STATUS = "delete" */

   if p-status = "first-one"
      and not available fab_det
   then do:
      frame f-1:visible = true.
      return.
   end. /* IF p-status = "first-one"  */

   /* ---------------  AFTER QUERY INCLUDE  --------------- */
   assign
      l-type   = if available fab_det
                 then
                    fab_fabk_id
                 else
                    l-type
      l-id     = if available fab_det
                 then
                    fab_fa_id
                 else
                    l-id
      l-seq    = if available fab_det
                 then
                    fab_fabk_seq
                 else
                    l-seq
      l_ovramt = if available fab_det
                 then
                   fab_ovramt
                 else
                    0.

   /* -------------  END AFTER QUERY INCLUDE  ------------- */

   /* ----------------------  ADJUST  --------------------- */
   if perform-status = "adjust"
   then do:
      p-status = "display".
      if session:display-type = "gui"
      then
         assign
            fab_fabk_id:bgcolor = 8
            fab_fabk_id:fgcolor = 0.
      /* ADDED INPUT-OUPUT PARAMETERS l_astpost AND l_cost */
      {&FAFAMTA-P-TAG3}

/* SS - 100505.1 - B 
      {gprun.i ""fafamtg.p""
         "(input-output l_astpost,
           input-output l_cost)"}
   SS - 100505.1 - E */
/* SS - 100505.1 - B */
      {gprun.i ""xxfafamtg.p""
         "(input-output l_astpost,
           input-output l_cost)"}
/* SS - 100505.1 - E */

      if global-beam-me-up
      then undo, leave.

      assign
         p-status       = ""
         perform-status = "first".
      run ip-displayedits.

      {&FAFAMTA-P-TAG4}
   end. /* IF perform-status = "adjust" */
   /* --------------------  END ADJUST  ------------------- */

   /* ----------------------  DETAIL  --------------------- */
   if perform-status = "detail"
   then do:
      p-status = "display".
      if session:display-type = "gui"
      then
         assign
            fab_fabk_id:bgcolor = 8
            fab_fabk_id:fgcolor = 0.

      {gprun.i ""fafamtd.p""}

      /* l-flag IS SET TO yes IN BATCH MODE IN fafamtd.p */
      /* FOR AN ERROR ENCOUNTERED.                       */
      if l-flag
      then
         return.

      if global-beam-me-up
      then undo, leave.

         assign
            p-status       = ""
            perform-status = "first".
      run ip-displayedits.
   end. /* if perform-status = "detail" */
   /* --------------------  END DETAIL  ------------------- */

   /* ----------------------  AUDIT  ---------------------- */
   if perform-status = "audit"
   then do:
      p-status = "display".
      if session:display-type = "gui"
      then
         assign
            fab_fabk_id:bgcolor = 8
            fab_fabk_id:fgcolor = 0.

      {gprun.i ""fafamtk.p""}
      if global-beam-me-up
      then undo, leave.

      assign
         p-status       = ""
         perform-status = "first".
      run ip-displayedits.
   end. /* IF perform-status = "audit"  */
 /* --------------------  END AUDIT  -------------------- */

 /* -----------------------  UOP  ----------------------- */
   if perform-status = "uop"
   then do:
      p-status = "display".
      if session:display-type = "gui"
      then
         assign
            fab_fabk_id:bgcolor = 8
            fab_fabk_id:fgcolor = 0.
      {gprun.i ""fafamtj.p""}
      if global-beam-me-up
      then undo, leave.

      assign
         p-status       = ""
         perform-status = "first".
      run ip-displayedits.
   end. /* IF perform-status = "uop"  */

/* ---------------------  END UOP  --------------------- */

/* ----------------------  DISPLAY  ---------------------- */
   run ip-predisplay.

/* ----------------------  ADD  ------------------------ */
   if (perform-status = "update"
      or perform-status = "add")
   then do:
      run ip-prompt.
      /* l-flag IS SET TO yes IN BATCH MODE IN PROCEDURE ip-prompt */
      /* FOR AN ERROR ENCOUNTERED.                                 */
      if l-flag
      then
         return.

      if global-beam-me-up
      then undo, leave.

      if perform-status = "undo"
      then do:
         perform-status = "first".
         next main-loop.
      end. /* IF perform-status = "undo"  */
      run ip-displayedits.
   end. /*  IF (perform-status = "update" .... */

   /* ----------------  SELECTION BUTTONS  ---------------- */
   if p-status <> "first-one"
      and p-status <> "end"
      and perform-status <> "first"
   then
      run ip-button
         (input-output perform-status).

   /* -------------  AFTER STRIP MENU INCLUDE  ------------ */
   if (perform-status = "update"
       or perform-status = "delete")
      and fa_post = yes
   then do:
      if perform-status = "delete"
      then do:
         /* CANNOT DELETE - DEPRECIATION POSTED FOR THIS BOOK */
         {pxmsg.i &MSGNUM=4230 &ERRORLEVEL=3}
      end. /* IF perform-status = "delete"  */
      else do:
         /* DEPRECIATION HAS STARTED ON THIS ASSET YOU MAY    */
         /* NOT ADJUST DEPRECIATION                           */
         {pxmsg.i &MSGNUM=3198 &ERRORLEVEL=4}
      end. /* ELSE DO */
      perform-status = "".
   end.  /* IF (perform-status = "update"  */
   p-skip-update = no.

   if perform-status = "adjust"
   then do:
      if fa_post = no
      then
         perform-status = "update".
      else
         if not can-find(first fabd_det
                          where fabd_det.fabd_domain = global_domain and
                          fabd_fa_id   = fab_fa_id
                         and   fabd_fabk_id = fab_fabk_id)
         then do:
            /* DEPRECIATION SCHEDULE DOES NOT EXIST */
            {pxmsg.i &MSGNUM=3199 &ERRORLEVEL=2}
            perform-status = "first".
         end. /* THEN DO */
   end.  /* IF perform-status = "adjust" */
   if available fab_det
   then
      assign
         l-fa-id   = fab_fa_id
         l-fabk-id = fab_fabk_id.

   if perform-status = "find"
   then do:
      run ip-book
         (input-output l-rowid).
      if l-rowid <> ?
      then
         run ip-query
            (input-output perform-status,
             input-output l-rowid).
   end. /* IF PERFORM-STATUS = "FIND" */

   if perform-status = "uop"
   then do:
      for first famt_mstr
         fields( famt_domain famt_id famt_type)
          where famt_mstr.famt_domain = global_domain and  famt_id   =
          l-famt-id:screen-value
         and   famt_type = "2"
         no-lock:
      end. /* FOR FIRST famt_mstr */
      if not available famt_mstr
      then do:
         /* UOP OPTION ONLY AVAILABLE FOR UNITS OF PRODUCTION METHODS */
         {pxmsg.i &MSGNUM=3200 &ERRORLEVEL=4}
         perform-status = "".
      end. /* IF NOT AVAILABLE */
   end.  /* IF "uop" */
   /* -----------  END AFTER STRIP MENU INCLUDE  ---------- */

   /* -----------------------  END  ----------------------- */
   if perform-status = "end"
   then do:
      hide frame f-1 no-pause.
      delete PROCEDURE this-procedure no-error.
      leave.
   end.  /* IF perform-status = "end" */

end. /* mainloop */

/* -------------  ADD / UPDATE / FIELD EDITS  ------------ */
PROCEDURE ip-prompt:
   if perform-status = "add"
   then do:
      scroll from-current down with frame f-1.
      assign
         l_newbk = yes
         l-rowid = ?
/* SS - 100525.1 - B */
         l_ovramt = 0
/* SS - 100525.1 - E */
         .
   end. /* IF perform-status = "add" */

   assign
      l-table = no
      l-first = yes.

   CASE perform-status:
      when ("add")
      then do:
         /* ADDING NEW RECORD */
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      end. /* when (add) */
      when ("update")
      then do:
         /* MODIFYING EXISTING RECORD */
         {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1}
      end. /* when update */
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
            fab_det.fab_fabk_id
               when (perform-status = "add")
            fab_det.fab_date
            l-famt-id
         with frame f-1.

         assign
            l-famt-id.
         if input frame f-1 fab_fabk_id = ""
         then do:
            /* BLANK NOT ALLOWED */
            {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}

            /* l-flag IS SET TO yes IN BATCH MODE. */
            if not batchrun
            then do:
               next-prompt
                  fab_fabk_id
               with frame f-1.
               next.
            end. /* IF NOT batchrun */
            else do:
               l-flag = yes.
               return.
            end. /* ELSE batchrun */
         end. /* if input frame f-1 fab_fabk_id = "" */
         /* FIELD EDIT FOR fab_fabk_id */
         l-error = no.
         if not can-find(fabk_mstr
                          where fabk_mstr.fabk_domain = global_domain and
                          fabk_id = input frame f-1 fab_fabk_id)
         then do:
            /* INVALID BOOK CODE */
            {pxmsg.i &MSGNUM=4214 &ERRORLEVEL=3}
            l-error = yes.
         end. /* if not can-find(fabk_mstr.... */
         if perform-status = "add"
            and can-find(first fab_det
                          where fab_det.fab_domain = global_domain and
                          fab_fa_id   = fa_mstr.fa_id
                         and   fab_fabk_id = input frame f-1 fab_fabk_id)
         then do:
            /* BOOK # ALREADY EXISTS FOR THIS ASSET */
            {pxmsg.i &MSGNUM=4254 &ERRORLEVEL=3
                     &MSGARG1="input frame f-1 fab_fabk_id"}
            l-error = yes.
         end. /* THEN DO */

         /* l-flag IS SET TO yes IN BATCH MODE. */
         if l-error
         then do:
            if not batchrun
            then do:
               next-prompt
                  fab_fabk_id
               with frame f-1.
               next.
            end. /* IF NOT batchrun */
            else do:
               l-flag = yes.
               return.
            end. /* ELSE batchrun */
         end. /* IF l-error */
         /* END FIELD EDIT FOR fab_fabk_id */

         /* FIELD EDIT FOR fab_date */
         l-error = no.

         /* VALIDATE BASIS DATE IN GL/CUSTOM CALENDAR */
         /* BUT ONLY DISPLAY A WARNING SINCE FA POST  */
         /* CAN PERFORM "CATCH UP" FUNCTION.          */
         for first fabk_mstr
            fields( fabk_domain fabk_id fabk_calendar fabk_post)
             where fabk_mstr.fabk_domain = global_domain and  fabk_id = input
             frame f-1 fab_fabk_id
            no-lock:
            /* VALIDATE DATE IN CUSTOM CALENDAR */
         if fabk_calendar <> ""
           and not fabk_post
         then do:
            for first facld_det
               fields( facld_domain facld_facl_id facld_start facld_end)
                where facld_det.facld_domain = global_domain and  facld_facl_id
                = fabk_calendar
               and   facld_start   <= input frame f-1 fab_date
               and   facld_end     >= input frame f-1 fab_date
               no-lock:
            end. /* FOR FIRST facld_det */
            if not available facld_det then do:
               /* DATE NOT WITHIN A VALID PERIOD */
               {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
               l-error = yes.
            end. /* IF NOT AVAILABLE */
         end.  /* IF fabk_calendar <> "" AND NOT fabk_post */
         /* ELSE VALIDATE DATE IN GL CALENDAR */
         else do:
            {gprun.i ""gpglef1.p""
               "(input  ""FA"",
                 input  fa_mstr.fa_entity,
                 input  input frame f-1 fab_date,
                 output gpglef_result,
                 output gpglef_msg_nbr)"}
            if global-beam-me-up
            then undo, leave.
            /* ONLY DISPLAY A WARNING IF INVALID/CLOSED PERIOD */
            if gpglef_result = 1
            then do:
               /* INVALID PERIOD */
               {pxmsg.i &MSGNUM=gpglef_msg_nbr &ERRORLEVEL=3}
               l-error = yes.
            end.  /* IF gpglef_result = 1 */
            else if gpglef_result > 1
            then do:
               /* CLOSED PERIOD */
               {pxmsg.i &MSGNUM=gpglef_msg_nbr &ERRORLEVEL=2}
            end. /* ELSE IF gpglef_reult = 1 */
         end.  /* ELSE DO */
         for first famt_mstr
            fields( famt_domain famt_id famt_type)
             where famt_mstr.famt_domain = global_domain and  famt_id = input
             frame f-1 l-famt-id
            and   famt_type = "6"
              /* CUSTOM TABLE */
            no-lock:
         l-cal = if fabk_post
                 then ""
                 else fabk_calendar.
         {gprunp.i "fapl" "p" "fa-get-per"
            "(input  input frame f-1 fab_date,
              input  l-cal,
              output l-period,
              output l-err-nbr)"}

         if l-err-nbr > 0
         then do:
            {pxmsg.i &MSGNUM=l-err-nbr &ERRORLEVEL=3}
            l-error = yes.
            leave.
         end. /* IF l-err-nbr > 0 */

            if integer(substring(l-period,5,2)) > 13
            then do:
               /* CUSTOM TABLE CANNOT BE USED WITH A     */
               /* CALENDAR THAT HAS MORE THAN 13 PERIODS */
               {pxmsg.i &MSGNUM=3197 &ERRORLEVEL=3}
               l-error = yes.
            end. /* IF integer(substring(l-period,5,2)) > 13 */
         end.  /* FOR FIRST fabk_mstr */
      end.

      /* l-flag IS SET TO yes IN BATCH MODE. */
      if l-error
      then do:
         if not batchrun
         then do:
            next-prompt
               fab_date
            with frame f-1.
            next.
         end. /* IF NOT batchrun */
         else do:
            l-flag = yes.
            return.
         end. /* ELSE batchrun */
      end.  /* IF l-error */
      /* END FIELD EDIT FOR fab_date */

      /* FIELD EDIT FOR l-famt-id */
      l-error = no.
      for first famt_mstr
         fields( famt_domain famt_id famt_type famt_active famt_elife)
          where famt_mstr.famt_domain = global_domain and  famt_id = input
          frame f-1 l-famt-id
         no-lock:
      end.
      if not available famt_mstr
         or (available famt_mstr
            and not famt_active)
      then do:
         /* INVALID DEPRECIATION METHOD */
         {pxmsg.i &MSGNUM=4200 &ERRORLEVEL=3}
         l-error = yes.
      end.

      else do:
         if famt_type = "2"
         then do:
         /* UOP */
            {gprun.i ""fafaut1.p""
               "(input-output l-uplife,
                 input-output l-upper,
                 input-output l-famtr-id,
                 input-output l-um)"}
            if global-beam-me-up
            then undo, leave.
            assign
               l-fab-life:screen-value = "0"
               l-table                 = yes.
            leave.
         end. /* if famt_type = "2" */
         if famt_type = "6"
         then
         /* CUSTOM TABLE */
            assign
               l-table                 = yes
               l-fab-life:screen-value = string(famt_elife).
      end. /* ELSE IF AVAILABLE famt_mstr */

      /* l-flag IS SET TO yes IN BATCH MODE. */
      if l-error
      then do:
         if not batchrun
         then do:
            next-prompt
               l-famt-id
            with frame f-1.
            next.
         end. /* IF NOT batchrun */
         else do:
            l-flag = yes.
            return.
         end. /* ELSE batchrun */
      end. /* IF l-error */
      /* END FIELD EDIT FOR l-famt-id */

      leave.
   end.
   if global-beam-me-up
   then undo, leave.
   if keyfunction(lastkey) = "end-error"
   then do:
      perform-status = "undo".
      return no-apply.
   end. /* if keyfunction(lastkey) */
   repeat:
      prompt-for
         l-fab-life
            when (not l-table)
         l-basis-amt
      with frame f-1.

      assign
         l-fab-life
         l-basis-amt.
      /* FIELD EDIT FOR l-fab-life */

      assign
         l-error   = no
         l-err-nbr = f-validate-life(input frame f-1 l-famt-id,
                                     input frame f-1 l-fab-life)
         l-error = l-err-nbr > 0.

      if l-err-nbr > 0
      then do:
         {pxmsg.i &MSGNUM=l-err-nbr &ERRORLEVEL=3}
      end. /* IF l-err-nbr > 0 */

      /* l-flag IS SET TO yes IN BATCH MODE. */
      if l-error
      then do:
         if not batchrun
         then do:
            next-prompt
               l-fab-life
            with frame f-1.
            next.
         end. /* IF NOT batchrun */
         else do:
            l-flag = yes.
            return.
         end. /* ELSE batchrun */
      end. /* IF l-error */
      /* END FIELD EDIT FOR l-fab-life */

      /* FIELD EDIT FOR l-basis-amt */
      l-error = no.
      /* CHECK CURRENCY DEPENDENT ROUNDING FORMAT */
      {gprun.i ""gpcurval.p""
         "(input  input frame f-1 l-basis-amt,
           input  gl_ctrl.gl_rnd_mthd,
           output l-err-nbr)"}
      if global-beam-me-up
      then undo, leave.
      if l-err-nbr <> 0
      then
         l-error = yes.
      l-err-nbr = 0.

      if l_ovramt > l-basis-amt
      then do:
         /* ACCUMULATED DEPRECIATION IS GREATER */
         /* THAN ADJUSTMENT AMOUNT              */
         {pxmsg.i &MSGNUM=3191 &ERRORLEVEL=3}
         l-error = yes.
      end. /* IF l_ovramt > l-basis-amt */

      /* l-flag IS SET TO yes IN BATCH MODE. */
      if l-error
      then do:
         if not batchrun
         then do:
            next-prompt
               l-basis-amt
            with frame f-1.
            next.
         end. /* IF NOT batchrun */
         else do:
            l-flag = yes.
            return.
         end. /* ELSE batchrun */
      end. /* IF l-error */

      /* END FIELD EDIT FOR l-basis-amt */

      leave.
   end.

   if keyfunction(lastkey) = "end-error"
   then
      next prompt-for-it.

   if global-beam-me-up
   then undo, leave.
   /* IS ALL INFO CORRECT */
   {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=correct-yn
            &CONFIRM-TYPE='LOGICAL'}

   if not correct-yn
   then do:
      l-error = yes.
      if perform-status = "add"
      then do:
         next-prompt
            fab_det.fab_fabk_id
         with frame f-1.
         next prompt-for-it.
      end.  /* IF perform-status = "add" */
      else
      if perform-status = "update"
      then do:
         next-prompt
            fab_det.fab_date
         with frame f-1.
         next prompt-for-it.
      end.  /* IF perform-status = "update" */
   end. /* IF NOT correct .. */

   /* GET ORIGINAL ASSET COST OR DIFFERENCE. THE ORIGINAL ASSET */
   /* COST MEANS COST OBTAINED WHEN ADDING AN ASSET, ADDING A   */
   /* POST BOOK TO EXISTING ASSET OR THE COST OF POST BOOK      */
   /* MODIFIED IMMEDIATELY AFTER ADDING AN ASSET/POST BOOK      */
   else
      if fabk_post
      then do:
         if (perform-status   = "add":U
             and l-basis-amt <> 0)
            or (perform-status = "update":U)
         then
            assign
               l_cost    = if perform-status = "add":U
                              and l_newbk
                           then
                              l-basis-amt
                           else
                              l-basis-amt - l_firstcost.
               l_astpost = if l_cost <> 0
                           then yes
                           else no.
      end. /* IF fabk_post */

   if keyfunction(lastkey) = "end-error"
   then
         next prompt-for-it.
   leave.
end. /* prompt-for-it */
if global-beam-me-up
then undo, leave.
if keyfunction(lastkey) = "end-error"
then do:
   if perform-status = "add"
   then do:
      /* RECORD NOT ADDED */
      {pxmsg.i &MSGNUM=1304 &ERRORLEVEL=1}
      get first q_fab_det
         no-lock.
      if available fab_det
      then do:
         assign
            perform-status = "first"
            l-rowid        = rowid(fab_det).
      end. /* IF AVAILABLE fab_det */
      else
         assign
            perform-status = ""
            l-rowid        = ?.
      clear frame f-1 no-pause.
   end.
   else
      if available fab_det
      then
         assign
            perform-status = ""
            l-rowid        = rowid(fab_det).
   return.
end.  /* IF keyfunction(lastkey) = "end-error" */
run ip-lock
   (input-output perform-status).
END PROCEDURE.

/* -----------------------  LOCKING  ----------------------- */
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

      if available fab_det
      then
         get current q_fab_det
            no-lock.
      if available fab_det
         and current-changed fab_det
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
         end.  /* IF l-delete-it = no */
         hide message no-pause.
      end.  /* IF available fab_det */
      if available fab_det
      then
         tran-lock:
      do while perform-status <> "":
         get current
            q_fab_det exclusive-lock no-wait.
         if locked fab_det
         then do:
            if pos < 3
            then do:
               assign
                  pos = pos + 1.
                  pause 1 no-message.
                  next tran-lock.
            end. /* IF pos < 3 */
            perform-status = "error".
         end.
         leave.
      end. /*while*/

      if (perform-status  = "update"
           or p-status    = "update")
          and l-delete-it = yes
      then
         run ip-update
            (input-output perform-status).
      if perform-status = "delete"
      then
      run ip-delete
         (input-output perform-status).

      if available fab_det
      then
         get current q_fab_det
            no-lock.
      if perform-status = "add"
      then
      run ip-add
         (input-output perform-status).
      if perform-status = "undo"
      then
         undo ip-lock, return.
   end.
END PROCEDURE.

PROCEDURE ip-update:
   define input-output parameter perform-status as character no-undo.

   if p-status = "update"
   then
      p-status = "".
   run ip-assign
      (input-output perform-status).
   if perform-status = "undo"
   then
      return.
   perform-status = "open".
   run ip-query
      (input-output perform-status,
       input-output l-rowid).
   reposition q_fab_det to rowid l-rowid no-error.
   get next q_fab_det
      no-lock.
   assign
      perform-status = "first"
      l-rowid        = rowid(fab_det).
   return.
END PROCEDURE.

PROCEDURE ip-add:
   define input-output parameter perform-status as character no-undo.

   create fab_det. fab_det.fab_domain = global_domain.
   run ip-assign
      (input-output perform-status).
   if perform-status = "undo"
   then
      return.
   perform-status = "open".
   run ip-query
      (input-output perform-status,
       input-output l-rowid).
   reposition q_fab_det to rowid l-rowid no-error.
   get next q_fab_det
      no-lock.
   assign
      perform-status = "first"
      l-rowid        = rowid(fab_det).
   return.
END PROCEDURE.

PROCEDURE ip-delete:
   define input-output parameter perform-status as character no-undo.
   l-delete-it = no.

   /* PLEASE CONFIRM DELETE */
   {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=l-delete-it
            &CONFIRM-TYPE='LOGICAL'}
   CASE l-delete-it:
      when yes
      then do:
         /* LOCKED-DELETE-EDIT */
         /* DELETE DEPRECIATION ARRAY FOR BOOK */
         for each fabd_det
             where fabd_det.fabd_domain = global_domain and  fabd_fa_id   =
             fab_det.fab_fa_id
            and   fabd_fabk_id = fab_det.fab_fabk_id
            exclusive-lock:
            delete fabd_det.
         end. /* FOR EACH fabd_det */

         hide message no-pause.
         delete fab_det.
         clear frame f-1 no-pause.
         get next q_fab_det
            no-lock.
         if available fab_det
         then do:
            assign
               perform-status = "first"
               l-rowid        = rowid(fab_det).
         end. /* IF AVAILABLE fab_det */
         else do:
            get prev q_fab_det
               no-lock.
            if available fab_det
            then do:
               assign
                  perform-status = "first"
                  l-rowid        = rowid(fab_det).
            end. /* IF AVAILABLE fab_det */
            else
               assign
                  perform-status = "first"
                  l-rowid        = rowid(fab_det).
         end. /* ELSE DO */
         /* RECORD DELETED */
         {pxmsg.i &MSGNUM=22 &ERRORLEVEL=1}
         return.
      end. /* when yes */
      otherwise
         run ip-displayedits.
   END CASE.
END PROCEDURE.

PROCEDURE ip-assign:
   define input-output parameter perform-status as character no-undo.
   do with frame f-1:
      assign
         fab_det.fab_fabk_id
         fab_det.fab_fabk_seq   = l_asd_seq
         fab_det.fab_amt        = l-basis-amt
         fab_det.fab_fa_id      = fa_mstr.fa_id
         fab_det.fab_mod_userid = global_userid
         fab_det.fab_mod_date   = today
         fab_det.fab_famtr_id   = l-famtr-id
         fab_det.fab_uplife     = l-uplife
         fab_det.fab_upper      = l-upper
         fab_det.fab_um         = l-um
         fab_det.fab_resrv      = 0
         fab_det.fab_life       = l-fab-life
         fab_det.fab_famt_id    = l-famt-id
         fab_det.fab_date
         fab_det.fab_upcost     = 0
         l-rowid = rowid(fab_det).

      /* --------  AFTER-ASSIGN-AUDIT-INCLUDE  ----------- */
      for first famt_mstr
         fields( famt_domain famt_id famt_salv)
          where famt_mstr.famt_domain = global_domain and  famt_id = fab_famt_id
         no-lock:
      end. /* FOR FIRST famt_mstr */
      if available famt_mstr
         and famt_salv
      then
         fab_det.fab_salvamt = fa_mstr.fa_salvamt.
      else
         fab_det.fab_salvamt = 0.

      for first fabk_mstr
         fields( fabk_domain fabk_id fabk_seq)
          where fabk_mstr.fabk_domain = global_domain and  fabk_id = fab_fabk_id
         no-lock:
      end. /* FOR FIRST fabk_mstr */
      assign
         fab_fabk_seq = if perform-status = "add"
                           and available fabk_mstr
                        then
                           fabk_seq
                        else
                           fab_fabk_seq.

      /* ADDED 1ST INPUT PARAMETER AS yes THIS WILL  */
      /* CHECK THAT THE NEXT CALENDAR IS DEFINED FOR */
      /* AN ASSET PLACED IN A SHORT YEAR.            */

      /* ADDED 5TH AND 6TH PARAMETERS AS THE YEAR FOR ADJUSTMENT   */
      /* AND DEPRECIATION CALCULATION FOR FOLLOWING YEARS IS       */
      /* NEEDED OR NOT RESPECTIVELY. THESE PARAMETERS WILL BE zero */
      /* AND no RESPECTIVELY EXCEPT FOR UTILITY utrgendp.p         */
      {gprun.i ""fadpbla.p""
         "(input  yes,
           input  fab_resrv,
           buffer fa_mstr,
           buffer fab_det,
           input  0,
           input  no,
           output l-err-nbr)"}

      if global-beam-me-up then undo, leave.

      if l-err-nbr <> 0
      then do:
         {pxmsg.i &MSGNUM=l-err-nbr &ERRORLEVEL=4}
         perform-status = "undo".
      end. /* THEN DO: */
      /* ------  END AFTER-ASSIGN-AUDIT-INCLUDE  ----------- */
   end. /* DO WITH frame f-1 */
END PROCEDURE.

PROCEDURE ip-predisplay:
   if (perform-status = ""
       or perform-status = "update")
       and available fab_det
   then
      display-loop:
   do:
      if perform-status = ""
      then do:
         clear frame f-1 all no-pause.
         l-top-rowid = rowid(fab_det).
      end. /* IF perform-status = "" */
      read-loop:
      do pos = 1 to lines:
         if perform-status = ""
         then do:
            if session:display-type = "gui"
            then
               assign
                  fab_fabk_id:bgcolor = 8
                  fab_fabk_id:fgcolor = 0.
            else
               color display normal fab_fabk_id
               with frame f-1.
         end. /* IF perform-status = "" */
         run ip-displayedits.
         if perform-status = "update"
         then
            leave display-loop.
         if pos < lines
         then
            down with frame f-1.
         get next q_fab_det no-lock.
         if not available fab_det
         then
            leave.
      end. /* do pos */
      run ip-postdisplay.
   end. /* do */
END PROCEDURE.

PROCEDURE ip-displayedits:
   if available fab_det
   then do:
      /* DISPLAY-EDITS */
      define buffer fabdet for fab_det.

      for last fabd_det
         fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper fabd_post
                 fabd_accamt fabd_adj_yrper fabd_peramt)
          where fabd_det.fabd_domain = global_domain and  fabd_fa_id   =
          fab_fa_id
         and fabd_fabk_id   = fab_fabk_id
         and fabd_post      = yes
         no-lock:
      end. /* for last fabd_det */
      if available fabd_det
      then
         l-asof-date = fabd_yrper.
      else
         l-asof-date = "".

      assign
         l-famt-id  = ""
         l-fab-life = 0.

      for last fabdet
         fields( fab_domain fab_fa_id fab_fabk_id fab_famt_id fab_life)
          where fabdet.fab_domain = global_domain and  fabdet.fab_fa_id   =
          fab_det.fab_fa_id
         and   fabdet.fab_fabk_id = fab_det.fab_fabk_id
         no-lock:
         assign
            l-famt-id  = fabdet.fab_famt_id
            l-fab-life = fabdet.fab_life.
      end. /* for last fabdet */

      {gprunp.i "fapl" "p" "fa-get-cost"
         "(input  fab_fa_id,
           input  fab_fabk_id,
           output l-basis-amt)"}

      {gprunp.i "fapl" "p" "fa-get-accdep"
         "(input  fab_fa_id,
           input  fab_fabk_id,
           input  l-asof-date,
           output l_dep)"}

      assign
         l_net      = 0
         l_asd_seq  = fab_det.fab_fabk_seq
         l_net      = l-basis-amt - l_dep
         l_dep      = if l_dispose = yes
                      then
                         0
                      else
                         l_dep
         l_net      = if l_dispose = yes
                      then
                         0
                      else
                         l_net
         l-famtr-id = fab_famtr_id
         l-uplife   = fab_uplife
         l-upper    = fab_upper
         l-um       = fab_um.

      /* DISPLAY-EDITS */

      run ip-display.
   end. /* IF AVAIL fab_det */
END PROCEDURE.

PROCEDURE ip-display:
   display
      fab_det.fab_fabk_id
      l_net
      l-basis-amt
      l-asof-date
      l-famt-id
      l-fab-life
      fab_det.fab_date
   with frame f-1.
END PROCEDURE.

PROCEDURE ip-postdisplay:
   do pos = 1 to lines:
      if frame-line(f-1) <= 1
      then
         leave.
      up 1 with frame f-1.
   end. /* do pos = 1 to lines */
   if perform-status = ""
   then do:
      reposition q_fab_det to rowid l-top-rowid no-error.
      get next q_fab_det
         no-lock.
      l-rowid = l-top-rowid.
      if p-status <> "first-one"
      then
         color display message fab_fabk_id
         with frame f-1.
   end. /* IF perform-status = "" */
END PROCEDURE.

PROCEDURE ip-query:
   define input-output parameter perform-status as character no-undo.
   define input-output parameter l-rowid        as rowid     no-undo.

   if perform-status = "first"
   then do:
      if l-rowid <> ?
      then do:
         reposition q_fab_det to rowid l-rowid
            no-error.
         get next q_fab_det
            no-lock.
      end. /* if l-rowid <> ? */
      if not available fab_det
      then
         get first q_fab_det
            no-lock.
      if available fab_det
      then
         assign
            perform-status = ""
            l-rowid        = rowid(fab_det).
      else do:
         assign
            perform-status    = ""
            l-rowid           = ?
            frame f-1:visible = true.
         return.
      end. /* else do */
   end.  /* IF perform-status = "first" */

   if perform-status = "open"
   then do:
      open query q_fab_det
         for each fab_det
             where fab_det.fab_domain = global_domain and  fab_fa_id =
             fa_mstr.fa_id
            and   fab_resrv = 0
            use-index fab_fa_id
            no-lock.

      reposition q_fab_det to rowid l-rowid
         no-error.
      get next q_fab_det
         no-lock.
      if available fab_det
      then
         assign
            perform-status = ""
            l-rowid        = rowid(fab_det).
      else do:
         get first q_fab_det
            no-lock.
         if not available fab_det
         then do:
            assign
               perform-status    = ""
               frame f-1:visible = true.
            return.
         end. /* if not available */
         else
            assign
               perform-status = ""
               l-rowid        = rowid(fab_det).
      end. /* ELSE DO */
   end.  /* IF perform-status = "open" */

   if perform-status = "next"
   then do:
      get next q_fab_det
         no-lock.
      if available fab_det
      then do:
         hide message no-pause.
         assign
            l-rowid        = rowid(fab_det)
            perform-status = "next".
         if session:display-type = "gui"
         then
            assign
               fab_fabk_id:bgcolor = 8
               fab_fabk_id:fgcolor = 0.
         else
            color display normal fab_fabk_id
            with frame f-1.
         /* MAKES SCROLLING WORK - DON'T REMOVE */
         pause 0.
         down 1 with frame f-1.
         run ip-displayedits.
         color display message fab_fabk_id
         with frame f-1.
      end. /* IF AVAILABLE fab_det */
      else do:
         perform-status = "next".
         /* END OF FILE */
         {pxmsg.i &MSGNUM=20 &ERRORLEVEL=2}
         get last q_fab_det
            no-lock.
      end. /* ELSE DO */
   end.  /* IF perform-status = "next" */

   if perform-status = "prev"
   then do:
      get prev q_fab_det
         no-lock.
      if not available fab_det
      then do:
         /* BEGINNING OF FILE */
         {pxmsg.i &MSGNUM=21 &ERRORLEVEL=2}
         get first q_fab_det
            no-lock.
         return.
      end. /* if not avai fab_det */
      hide message no-pause.
      l-rowid = rowid(fab_det).
      if session:display-type = "gui"
      then
         assign
            fab_fabk_id:bgcolor = 8
            fab_fabk_id:fgcolor = 0.
      else
         color display normal fab_fabk_id
         with frame f-1.
      /* MAKES SCROLLING WORK - DON'T REMOVE */
      pause 0.
      up 1 with frame f-1.
      run ip-displayedits.
      color display message fab_fabk_id
      with frame f-1.
   end.  /* IF perform-status = "prev" */

   if perform-status = "update" or
      perform-status = "delete" then
   do:
      get current q_fab_det no-lock.
      if not available fab_det
      then do:
         hide message no-pause.
         /* RECORD NOT FOUND */
         {pxmsg.i &MSGNUM=1310 &ERRORLEVEL=3}
         perform-status = "".
      end. /* if not avai fab_det then do.... */
   end. /* if perform-status = "update" or .... */

   if perform-status = "find"
   then do:
      reposition q_fab_det to rowid l-rowid
         no-error.
      get next q_fab_det
         no-lock.
      assign
         l-rowid        = rowid(fab_det)
         perform-status = "".
      run ip-displayedits.
   end. /* IF PERFORM_STATUS = "FIND" */

END PROCEDURE.

PROCEDURE ip-framesetup:
   assign
      frame f-1:row           = 12
      frame f-1:box           = true
      frame f-1:centered      = true
      frame f-1:title         = (getFrameTitle("DEPRECIATION_BOOKS",26))
      frame f-button:centered = true
      frame f-button:row      = 20.
END PROCEDURE.

PROCEDURE ip-button:
   define input-output parameter perform-status as character
      format "x(25)" no-undo.

   if not batchrun
   then do:
      enable all with frame f-button.
      ststatus = stline[2].
      status input ststatus.
      on choose of b-add
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle.
         hide frame f-button no-pause.
      end.  /* ON CHOOSE OF b-add */

      on choose of b-delete
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle.
         hide frame f-button no-pause.
      end.  /* ON CHOOSE OF b-delete */

      on choose of b-adjust
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle
            l-title        = current-window:title
                             + " - "
                             + self:label.
         hide frame f-button no-pause.
      end.  /* ON CHOOSE OF b-adjust */

      on choose of b-detail
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle
            l-title        = current-window:title
                             + " - "
                             + self:label.
         hide frame f-button no-pause.
      end.  /* ON CHOOSE OF b-detail */

      on choose of b-audit
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle
            l-title        = current-window:title
                             + " - "
                             + self:label.
         hide frame f-button no-pause.
      end.  /* ON CHOOSE OF b-audit  */

      on choose of b-uop
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle
            l-title        = current-window:title
                             + " - "
                             + self:label.
         hide frame f-button no-pause.
      end.  /* ON CHOOSE OF b-uop    */

      on choose of b-find
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle.
         hide frame f-button no-pause.
      end. /* ON CHOOSE OF B-FIND */

      on choose of b-end
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle.
         hide frame f-1 no-pause.
         hide frame f-button no-pause.

         /* ADDED HIDE STATEMENT SO THAT MESSAGE IS HIDDEN */
         /* EVEN WHEN END-ERROR KEY IS PRESSED INSTEAD OF  */
         /* CHOOSING END BUTTON.                           */
         hide message no-pause.
      end. /* ON CHOOSE OF B-END  */

      on cursor-up, f9 anywhere
      do:
         assign
            perform-status = "prev"
            l-focus        = focus:handle.
         apply "go" to frame f-button.
      end.  /* ON CURSOR-UP, F9 ANYWHERE */

      on cursor-down, f10 anywhere
      do:
         assign
            perform-status = "next"
            l-focus        = focus:handle.
         apply "go" to frame f-button.
      end.  /* ON CURSOR-UP, F10 ANYWHERE */

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

      on f3 anywhere
         apply "choose" to b-add in frame f-button.
      on f5, ctrl-d anywhere
         apply "choose" to b-delete in frame f-button.
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
         go of frame f-button
         or window-close of current-window
         or choose of
            b-add,
            b-delete,
            b-adjust,
            b-detail,
            b-audit,
            b-uop,
            b-find,
            b-end
            focus
            l-focus.
      hide message no-pause.

   end. /* IF NOT BATCHRUN */
   else
      set perform-status.

END PROCEDURE.

PROCEDURE ip-book:

   define input-output parameter l-rowid as rowid no-undo.

   prompt-for
      fab_fabk_id
   with frame f-1.
   for first fab_det
      fields( fab_domain fab_fabk_id fab_fa_id)
       where fab_det.fab_domain = global_domain and  fab_fa_id   = fa_mstr.fa_id
      and   fab_fabk_id = input frame f-1 fab_fabk_id
      no-lock:
   end. /* FOR FIRST fab_det */
   if available fab_det
   then
      l-rowid = rowid(fab_det).
   else do:
      /* INVALID BOOK CODE */
      {pxmsg.i &MSGNUM=4214 &ERRORLEVEL=4}
   end. /* ELSE DO */
END PROCEDURE. /* PROCEDURE IP-BOOK */
