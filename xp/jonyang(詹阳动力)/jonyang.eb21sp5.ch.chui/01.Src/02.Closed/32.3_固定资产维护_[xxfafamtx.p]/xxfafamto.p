/* fafamto.p FIXED ASSET MAINTENANCE - TRANSFER                               */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14.1.20 $                                                     */
/*V8:ConvertMode=NoConvert                                                    */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99    BY: *N021* Pat Pigatti       */
/* REVISION: 9.1      LAST MODIFIED: 01/20/00    BY: *N077* Vijaya Pakala     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 05/17/00    BY: *M0LJ* Vihang Talwalkar  */
/* REVISION: 9.1      LAST MODIFIED: 07/28/00    BY: *N0BX* Arul Victoria     */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00    BY: *N0L0* Jacolyn Neder     */
/* REVISION: 9.1      LAST MODIFIED: 09/28/00    BY: *M0T5* Rajesh Lokre      */
/* Revision: 1.14.1.12     BY: Jean Miller       DATE: 09/24/01  ECO: *N130*  */
/* Revision: 1.14.1.13     BY: Ashish M.         DATE: 10/11/01  ECO: *M1M1*  */
/* Revision: 1.14.1.14     BY: Kirti Desai       DATE: 07/16/02  ECO: *N1MJ*  */
/* Revision: 1.14.1.16     BY: Paul Donnelly (SB)DATE: 06/26/03  ECO: *Q00C*  */
/* Revision: 1.14.1.18     BY: Dorota Hohol      DATE: 10/20/03  ECO: *P138*  */
/* Revision: 1.14.1.19     BY: Shivanand H.      DATE: 10/20/03  ECO: *P19F* */
/* $Revision: 1.14.1.20 $     BY: Vandna Rohira     DATE: 12/17/04  ECO: *P2Z5*  */

/* SS - 100521.1  By: Roger Xiao */  /*资产转移标准程式bug修复:无效的账户组合,new sub = old sub ,new cc = new loc cc */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "FAFAMTO.P"}
/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

/* --------------------  Define Query  ------------------- */
define query q_fa_mstr for fa_mstr
   fields( fa_domain fa_entity fa_faloc_id fa_id)
   scrolling.

/* -----------------  Standard Variables  ---------------- */
define output parameter l-flag like mfc_logical no-undo.

define shared variable l-reopen-fa-query like mfc_logical no-undo.

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
define variable l-valid-entity like mfc_logical        no-undo.

/* ------------------  Button Variables  ----------------- */
define button b-update label "Update".
define button b-move   label "Move".
define button b-end    label "End".

/* -------------  Standard Widget Variables  ------------- */
define variable l-focus as widget-handle no-undo.
define variable w-frame as widget-handle no-undo.

/* ------------------  Screen Variables  ----------------- */
define shared variable l-key as   character format "x(12)" no-undo.
define variable valid_acct   like mfc_logical              no-undo.
define variable l-partial    like mfc_logical initial no   no-undo.
define variable l-new        as   character format "x(12)" no-undo.
define variable l-amt        as   integer   format ">>>,>>>,>>9.99<"    no-undo.
define variable l-pct        as   integer   format ">>9.99<"  initial 0 no-undo.
define variable l-err-nbr    as   integer   format ">>>9"     initial 0 no-undo.
define variable l-nrm-err    like mfc_logical                initial no no-undo.
define variable l-total      as   decimal format ">>>,>>>,>>9.99<"      no-undo.
define variable correct-yn   like mfc_logical initial yes               no-undo.
define variable l-period     as   character format "x(6)"               no-undo.
define variable l-trnloc     as   character format "x(8)"               no-undo.
define variable l-trncc      as   character format "x(4)"               no-undo.
define variable l-trnsub     as   character format "x(8)"               no-undo.
define variable l-trndate    as   date      format "99/99/9999"         no-undo.
define variable l-trnentity  as   character format "x(4)"               no-undo.
define variable l-trndesc    as   character format "x(40)"              no-undo.
define variable l-acct-seq   as   integer   format "999999999"
                                                              initial 0 no-undo.
define variable l-update     as   logical     no-undo.
define variable l-post       as   logical     no-undo.
define variable old-entity   like fa_entity   no-undo.
define variable old-location like fa_faloc_id no-undo.
{&FAFAMTO-P-TAG1}
/* ------------------  Frame Definition  ----------------- */

define frame f-button
   b-update at 1
   b-move   at 10
   b-end    at 19
with no-box overlay three-d side-labels width 28.

/* CLEAR FRAME REGISTRATION TO TRANSLATE THE FRAME EVERYTIME*/
clearFrameRegistration(frame f-button:handle).

/* SET EXTERNAL LABELS */
setFrameLabels(frame f-button:handle).

assign
   l-focus               = b-update:handle in frame f-button
   b-update:width        = 8
   b-update:private-data = "update"
   b-move:width          = 8
   b-move:private-data   = "move"
   b-end:width           = 8
   b-end:private-data    = "end".

define frame f-1
   skip(.4)
   fa_id colon 19
   skip
   old-entity   label "Old Entity"      colon 19
   skip
   old-location label "Old Location"    colon 19
   faloc_desc   no-label at 31 format "x(40)"
   skip(1)
   l-trnloc     label "New Location"    colon 19
   l-trndesc    no-label at 31
   skip
   l-trnentity  label "New Entity"      colon 19
   skip
   l-trnsub     label "New Sub-Account" colon 19
   skip
   l-trncc      label "New Cost Center" colon 19
   skip
   l-partial    label "Partial"         colon 19
   skip
   l-trndate    label "Transfer Date"   colon 19
with three-d overlay side-labels width 80.

/* CLEAR FRAME REGISTRATION TO TRANSLATE THE FRAME EVERYTIME*/
clearFrameRegistration(frame f-1:handle).

/* SET EXTERNAL LABELS */
setFrameLabels(frame f-1:handle).

run ip-framesetup.

assign
   w-frame = frame f-1:handle.

{gprun.i ""fafmtut.p"" "(w-frame)"}

/* ---------------  Pre Processing Include  -------------- */
define new shared workfile temp-select
   field sel_idr    as character format "x(1)"
   field sel_tag    as character format "x(17)"
   field sel_desc   as character format "x(20)"
   field sel_amt    as decimal   format ">>>,>>>,>>9.99<"
   field sel_serial as character format "x(20)".

for first fa_mstr
   fields( fa_domain fa_disp_dt fa_entity fa_faloc_id
       fa_id fa_qty fa_startdt)
    where fa_mstr.fa_domain = global_domain and  fa_id = l-key
   no-lock:
end. /* FOR FIRST fa_mstr */

/* VARIABLES NEEDED FOR GPGLEF1.P */
{gpglefv.i}

/* VARIABLES FOR FA PERSISTENT PROCEDURES */
{gprunpdf.i "fapl" "p"}

/* EAS PROCEDURES */
{gprunpdf.i "gpglvpl" "p"}

/* GET ENTITY SECURITY INFORMATION */
{glsec.i}

/* -------------  END Pre Processing Include  ------------ */

open query q_fa_mstr
   for each fa_mstr  where fa_mstr.fa_domain = global_domain and  fa_id = l-key
   no-lock.

get first q_fa_mstr no-lock.

main-loop:
do while perform-status <> "end" on error undo:

   run ip-query
      (input-output perform-status,
       input-output l-rowid).

   /* -----------------------  Move  ---------------------- */
   if perform-status = "move"
      and l-trnloc  <> ""
      and l-trndate <> ?
   then do:

      if l-partial
      then do:
         /* ADDED SIXTH, SEVENTH, EIGHTH, NINTH, TENTH, ELEVENTH PARAMETER */
/* SS - 100521.1 - B 
         {gprun.i ""fafabla.p""
            "(input fa_mstr.fa_id,
              input-output l-new,
              input l-pct,
              input l-amt,
              input fa_mstr.fa_qty,
              input l-trnloc,
              input l-trnsub,
              input l-trncc,
              input l-trndate,
              input yes,
              output l-err-nbr)"}
   SS - 100521.1 - E */
/* SS - 100521.1 - B */
         {gprun.i ""xxfafabla.p""
            "(input fa_mstr.fa_id,
              input-output l-new,
              input l-pct,
              input l-amt,
              input fa_mstr.fa_qty,
              input l-trnloc,
              input l-trnsub,
              input l-trncc,
              input l-trndate,
              input yes,
              output l-err-nbr)"}
/* SS - 100521.1 - E */

         if global-beam-me-up
         then
            undo, leave.

         if l-err-nbr <> 0
         then do:
            {pxmsg.i &MSGNUM=l-err-nbr &ERRORLEVEL=3}
         end. /* IF l-err-nbr <> 0 */
      end.  /* IF l-partial */

      else do:
         if not l-partial
         then
            l-new = fa_mstr.fa_id.

/* SS - 100521.1 - B 
         {gprun.i ""fatrbla.p""
            "(input l-new,
              input fa_mstr.fa_faloc_id,
              input l-trnloc,
              input l-trnsub,
              input l-trncc,
              input l-trndate,
              output l-err-nbr)"}
   SS - 100521.1 - E */
/* SS - 100521.1 - B */
         {gprun.i ""xxfatrbla.p""
            "(input l-new,
              input fa_mstr.fa_faloc_id,
              input l-trnloc,
              input l-trnsub,
              input l-trncc,
              input l-trndate,
              output l-err-nbr)"}
/* SS - 100521.1 - E */

         if global-beam-me-up
         then
            undo, leave.

         if l-err-nbr <> 0
         then do:
            {pxmsg.i &MSGNUM=l-err-nbr &ERRORLEVEL=3}
         end. /* IF l-err-nbr <> 0 */
      end. /* ELSE DO */

      l-update = no.

   end.  /* IF perform-status = "move" */

   else
   if perform-status = "move"
   then do:
      /* NEW LOCATION NOT ENTERED. UNABLE TO COMPLETE TRANSFER */
      {pxmsg.i &MSGNUM=3240 &ERRORLEVEL=3}
      perform-status = "".
      next main-loop.
   end. /* ELSE IF perform-status = "move" */
   /* ---------------------  END Move  -------------------- */

   /* ----------------------  Display  ---------------------- */
   run ip-predisplay.

   if (perform-status = "update"
   or  perform-status = "add")
   then do:

      run ip-prompt.

      /* l-flag IS SET TO yes IN BATCH MODE IN PROCEDURE ip-prompt */
      /* FOR AN ERROR ENCOUNTERED.                                 */
      if l-flag
      then
         return.

      if global-beam-me-up
      then
         undo, leave.

      if perform-status = "undo"
      then do:
         assign
            perform-status = "first".
         next main-loop.
      end. /* IF perform-status = "undo" */

      run ip-displayedits.

   end. /* IF (perform-status = "update" ... */

   /* -----------------------  End  ----------------------- */
   if perform-status = "end"
   then do:
      hide frame f-1 no-pause.
      DELETE PROCEDURE this-procedure no-error.
      leave.
   end. /* IF perform-status = "end" */

   /* ----------------  Selection Buttons  ---------------- */
   if perform-status <> "first"
   then
      run ip-button
         (input-output perform-status).

end. /* main-loop */

/* -------------  Add / Update / Field Edits  ------------ */
PROCEDURE ip-prompt:

   if perform-status = "add"
   then
      clear frame f-1 all no-pause.

   l-first = yes.

   CASE perform-status:
      when ("add") then do:
         /* ADDING NEW RECORD */
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      end.
      when ("update") then do:
         /* MODIFYING EXISTING RECORD */
         {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1}
      end.
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
            l-trnloc
         with frame f-1.

         assign
            l-trnloc.

         /* FIELD EDIT FOR l-trnloc */
         l-error = no.

         if not can-find(faloc_mstr
                 where faloc_mstr.faloc_domain = global_domain and  faloc_id =
                 input frame f-1 l-trnloc)
         then do:
            /* INVALID LOCATION */
            {pxmsg.i &MSGNUM=4220 &ERRORLEVEL=3}
            assign
               l-trnloc:screen-value = ""
               l-error               = yes.
         end. /* IF NOT CAN-FIND(faloc_mstr */

         else do:

            for first faloc_mstr
               fields( faloc_domain faloc_cc faloc_desc faloc_entity faloc_id
               faloc_sub)
                where faloc_mstr.faloc_domain = global_domain and  faloc_id =
                input frame f-1 l-trnloc
               no-lock:

               /* CHECK ENTITY SECURITY */
               {glenchk.i &entity=faloc_entity
                          &entity_ok=valid_entity}

               if not valid_entity
               then do:

                  if not batchrun
                  then
                     assign
                        l-error               = yes
                        l-trnloc:screen-value = "".
                  else do:
                     /* l-flag IS SET TO yes IN BATCH MODE. */
                     l-flag = yes.
                     return.
                  end. /* ELSE DO */

               end. /* IF NOT valid_entity */

               else do:

                  assign
                     l-trndesc   = faloc_desc
                     l-trnentity = faloc_entity
                     l-trncc     = faloc_cc
                    /* SS - 100521.1 - B 
                     l-trnsub    = faloc_sub
                       SS - 100521.1 - E */
                     .

                  display
                     l-trndesc
                     l-trnentity
                     l-trncc
                     l-trnsub
                  with frame f-1.
               end. /* ELSE DO */
            end. /* FOR FIRST faloc_mstr */

         end. /* ELSE DO */

         if l-error
         then do:
            next-prompt
               l-trnloc
               with frame f-1.
            next.
         end. /* IF l-error */
         /* END FIELD EDIT FOR l-trnloc */

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
/* SS - 100521.1 - B 
            l-trnsub
            l-trncc
   SS - 100521.1 - E */
            l-partial
            l-trndate
         with frame f-1.

         assign
            {&FAFAMTO-P-TAG2}
/* SS - 100521.1 - B 
            l-trnsub
            l-trncc
   SS - 100521.1 - E */
            l-partial
            l-trndate.

         /* FIELD EDIT FOR l-trncc */
         l-error = no.

         for first fa_mstr
            fields( fa_domain fa_disp_dt fa_entity fa_faloc_id fa_id fa_qty
            fa_startdt)
             where fa_mstr.fa_domain = global_domain and  fa_id = l-key
            no-lock:
         end. /* FOR FIRST fa_mstr */

         for last faba_det
            fields( faba_domain faba_acct faba_fa_id faba_glseq)
             where faba_det.faba_domain = global_domain and  faba_fa_id = l-key
            no-lock use-index faba_fa_id:
         end. /* FOR LAST faba_det */

         if available faba_det
         then
            l-acct-seq = faba_glseq.
         else
            l-acct-seq = 0.

         if available fa_mstr
         then do:

            for each faba_det
               fields( faba_domain faba_fa_id faba_acct)
                where faba_det.faba_domain = global_domain and  faba_fa_id =
                fa_mstr.fa_id
                 and faba_acct <> ""
               no-lock:

               /* INITIALIZE SETTINGS */
               {gprunp.i "gpglvpl" "p" "initialize"}

               /* SET PROJECT VERIFICATION TO NO */
               {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}

               /* ACCT/SUB/CC/PROJ VALIDATION */
/* SS - 100521.1 - B 
               {gprunp.i "gpglvpl" "p" "validate_fullcode"
                  "(input faba_acct,
                    input input frame f-1 l-trnsub,
                    input input frame f-1 l-trncc,
                    input """",
                    output valid_acct)"}

               if global-beam-me-up
               then
                  undo, leave.

               if not valid_acct
               then do:
                  l-error = yes.
                  leave.
               end. /* IF NOT valid_acct */
   SS - 100521.1 - E */
            end.  /* FOR EACH faba_det */

         end.  /* IF AVAILABLE fa_mstr */

         if l-error
         then do:
            next-prompt
               l-trnsub
               with frame f-1.
            next.
         end. /* IF l-error */
         /* END FIELD EDIT FOR l-trncc */

         /* FIELD EDIT FOR l-trndate */
         l-error = no.

         if  input frame f-1 l-trndate <> ?
         and input frame f-1 l-trndate <= fa_mstr.fa_startdt
         then do:
            /* Transfer date must be greater than service date */
            {pxmsg.i &MSGNUM=3241 &ERRORLEVEL=3}
            l-error = yes.
         end. /* IF  INPUT FRAME f-1 l-trndate <> ? ... */

         else
         if  input frame f-1 l-trndate <> ?
         and input frame f-1 l-trndate >= fa_mstr.fa_disp_dt
         then do:
            /* TRANSFER DATE MUST BE LESS THAN DISPOSAL DATE */
            {pxmsg.i &MSGNUM=3242 &ERRORLEVEL=3}
            l-error = yes.
         end. /* IF  INPUT FRAME f-1 l-trndate <> ?  ... */

         else
         if input frame f-1 l-trndate = ?
         then do:
            /* DATE REQUIRED */
            {pxmsg.i &MSGNUM=711 &ERRORLEVEL=3}
            l-error = yes.
         end. /* IF INPUT frame f-1 l-trndate = ? */

         if l-error = no
         then do:

            /* VALIDATE TRANSFER DATE AGAINST GL CALENDAR */
            {gprun.i ""gpglef1.p""
               "(input ""FA"",
                 input input frame f-1 l-trnentity,
                 input input frame f-1 l-trndate,
                 output gpglef_result,
                 output gpglef_msg_nbr)"}

            if global-beam-me-up
            then
               undo, leave.

            if gpglef_result > 1
            then do:
               /* CLOSED PERIOD */
               {pxmsg.i &MSGNUM=gpglef_msg_nbr &ERRORLEVEL=2}
            end. /* IF gpglef_result > 1 */

            else
            if gpglef_result = 1
            then do:
               /* INVALID PERIOD */
               {pxmsg.i &MSGNUM=gpglef_msg_nbr &ERRORLEVEL=3}
               l-error = yes.
            end. /* IF gpglef_result = 1 */

            if l-error = no
            then do:

               /* VALIDATE TRANSFER DATE AGAINST CUSTOM CALENDAR */
               for each fab_det no-lock
                   where fab_det.fab_domain = global_domain and  fab_fa_id =
                   fa_mstr.fa_id,
                  first fabk_mstr no-lock
                   where fabk_mstr.fabk_domain = global_domain and  fabk_id =
                   fab_fabk_id
                    and fabk_post = no:

                  if fabk_calendar <> ""
                  then do:

                     for first facld_det
                        fields( facld_domain facld_facl_id facld_per
                        facld_start facld_end)
                         where facld_det.facld_domain = global_domain and
                         facld_facl_id = fabk_calendar
                        and   facld_start <= input frame f-1 l-trndate
                        and   facld_end   >= input frame f-1 l-trndate
                        no-lock:
                     end. /* FOR FIRST facld_det */

                     if not available facld_det
                     then do:
                        /* DATE NOT WITHIN A VALID PERIOD */
                        {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
                        l-error = yes.
                     end. /* IF NOT AVAILABLE facld_det */

                  end. /* IF fabk_calendar <> "" */

               end.  /* FOR EACH fab_det */

            end. /* IF l-error = no */

         end.  /* IF l-error = no */

         /* VALIDATE THAT PERIOD IS NOT ALREADY POSTED */
         if l-error = no
         then do:

            for first fabk_mstr
               fields( fabk_domain fabk_calendar fabk_id fabk_post)
                where fabk_mstr.fabk_domain = global_domain and  fabk_post
               no-lock:
            end. /* FOR FIRST fabk_mstr */

            {gprunp.i "fapl" "p" "fa-get-per"
               "(input  input frame f-1 l-trndate,
                 input  """",
                 output l-period,
                 output l-err-nbr)"}

            {gprunp.i "fapl" "p" "fa-get-post"
               "(input  fa_id,
                 input  fabk_id,
                 input  l-period,
                 output l-post)"}

            if l-post = yes
            then do:
               /* DEPRECIATION POSTED FOR THIS PERIOD */
               {pxmsg.i &MSGNUM=3243 &ERRORLEVEL=3}
               l-error = yes.
            end. /* IF l-post = yes */

            else
            if can-find(first fabd_det
                where fabd_det.fabd_domain = global_domain and  fabd_fa_id  =
                fa_id
               and fabd_fabk_id  = fabk_id
               and fabd_yrper    = l-period
               and fabd_transfer = yes)
            then do:
               /* TRANSFER FOR THIS PERIOD ALREADY EXISTS */
               {pxmsg.i &MSGNUM=3315 &ERRORLEVEL=2}
            end. /* IF CAN-FIND(FIRST fabd_det */

         end.  /* IF l-error = no */

         if l-error
         then do:
            next-prompt
               l-trndate
               with frame f-1.
            next.
         end. /* IF l-error */
         /* END FIELD EDIT FOR l-trndate */

         leave.

      end. /* REPEAT */

      if global-beam-me-up
      then
         undo, leave.

      if keyfunction(lastkey) = "end-error"
      then
         next prompt-for-it.

      /* AFTER-UPDATE-EDITS */
      if perform-status = "update"
      then do:

         /* IF PARTIAL TRANSFER THEN PROMPT USER TO ENTER     */
         /* NEW ASSET ID THAT WILL CONTAIN THE TRANSFERRED    */
         /* PORTION OF THIS ASSET.  ALSO PROMPT FOR EITHER    */
         /* THE AMOUNT OR PERCENT OF A SINGLE COMPONENT ASSET */
         /* TO TRANSFER OR WHICH COMPONENTS TO TRANSFER.      */
         if input frame f-1 l-partial = yes
         then do:
            /* PROMPT FOR NEW ASSET, PERCENT, AMOUNT AND COMPONENTS */
            {gprun.i ""fafablc.p""
               "(input fa_mstr.fa_id,
                 output l-new,
                 output l-pct,
                 output l-amt,
                 output l-err-nbr)"}

            if global-beam-me-up
            then
               undo, leave.

            l-reopen-fa-query = yes.

         end.  /* IF l-partial */

      end. /* IF perform-status = "update" */

      /* AFTER-UPDATE-EDITS */
      l-update = yes.
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

END PROCEDURE. /* ip-prompt */

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
      for first faloc_mstr
         fields( faloc_domain faloc_cc faloc_desc faloc_entity faloc_id
         faloc_sub)
          where faloc_mstr.faloc_domain = global_domain and  faloc_id =
          fa_mstr.fa_faloc_id
         no-lock:
      end. /* FOR FIRST faloc_mstr */

      run ip-display.

   end. /* IF AVAILABLE fa_mstr */

END PROCEDURE. /* ip-displayedits */

PROCEDURE ip-display:

   assign
      old-entity   = fa_mstr.fa_entity
      old-location = fa_mstr.fa_faloc_id.

   display
      fa_mstr.fa_id
      old-entity
      old-location
      faloc_mstr.faloc_desc when (available faloc_mstr)
      l-partial
      l-trnloc
      l-trncc
      l-trnsub
      l-trndate
      l-trnentity
      l-trndesc
   with frame f-1.

END PROCEDURE. /* ip-display */

PROCEDURE ip-postdisplay:

   color display message fa_id
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

      open query q_fa_mstr
         for each fa_mstr
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
               perform-status    = ""
               frame f-1:visible = true.
            return.
         end. /* IF NOT AVAILABLE fa_mstr */

         else
            assign
               perform-status = ""
               l-rowid        = rowid(fa_mstr).
      end. /* ELSE DO */

   end. /* IF perform-status = "open" */

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
      end. /* IF NOT AVAILABLE fa_mstr */

   end. /* IF perform-status = "update" */

END PROCEDURE. /* ip-query */

PROCEDURE ip-framesetup:

   if session:display-type = "gui"
   then
      frame f-1:row = 3.
   else
      frame f-1:row = 2.

   assign
      frame f-1:box      = true
      frame f-1:centered = true
      frame f-1:title    = (getFrameTitle("ASSET_TRANSFER",21))
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

      on choose of b-update do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle.
         hide frame f-button no-pause.
      end. /*  ON CHOOSE OF b-update */

      on choose of b-move do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle
            l-title        = current-window:title + " - " + self:label.
         hide frame f-button no-pause.
      end. /*  ON CHOOSE OF b-move */

      on choose of b-end do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle.
         hide frame f-1 no-pause.
         hide frame f-button no-pause.
      end. /*  ON CHOOSE OF b-end */

      on cursor-up, f9 anywhere do:
         assign
            perform-status = "prev"
            l-focus        = focus:handle.
         apply "go" to frame f-button.
      end. /*  ON cursor-up ... */

      on cursor-down, f10 anywhere do:
         assign
            perform-status = "next"
            l-focus        = focus:handle.
         apply "go" to frame f-button.
      end. /*  ON cursor-down ... */

      on cursor-right anywhere do:
         assign
            l-focus = self:handle.
         apply "tab" to l-focus.
      end. /*  ON cursor-right ... */

      on cursor-left anywhere do:

         l-focus = self:handle.

         if session:display-type = "gui"
         then
            apply "shift-tab" to l-focus.
         else
            apply "ctrl-u" to l-focus.
      end. /*  ON cursor-left ... */

      on esc anywhere do:
         if session:display-type = "gui"
         then
            apply "choose" to b-end in frame f-button.
      end. /* ON ESC */

      on end-error anywhere
         apply "choose" to b-end in frame f-button.

      on window-close of current-window
         apply "choose" to b-end in frame f-button.

      on go anywhere do:
         if (lastkey = keycode("cursor-down")
         or  lastkey = keycode("cursor-up")
         or  lastkey = keycode("f9")
         or  lastkey = keycode("f10"))
         then
            return.
         else
            l-focus = focus:handle.
         apply "choose" to l-focus.
      end. /* ON GO */

      wait-for go of frame f-button
               or window-close of current-window
               or choose of b-update, b-move, b-end
      focus l-focus.

   end. /* IF NOT BATCHRUN */

   else
      set perform-status.

   hide message no-pause.

END PROCEDURE. /* ip-button */
