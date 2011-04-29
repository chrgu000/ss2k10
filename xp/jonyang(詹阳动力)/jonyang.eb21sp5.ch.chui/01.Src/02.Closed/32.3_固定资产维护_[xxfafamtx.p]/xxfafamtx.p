/* fafamt.p Fixed Assets Update                                             */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.31.1.43 $                                                   */
/* REVISION: 9.1      LAST MODIFIED: 08/26/99   BY: PJP *N021*              */
/* REVISION: 9.1      LAST MODIFIED: 01/20/00   BY: *N077* Vijaya Pakala    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 05/17/00   BY: *M0LJ* Vihang Talwalkar */
/* REVISION: 9.1      LAST MODIFIED: 05/30/00   BY: *M0MY* Vihang Talwalkar */
/* REVISION: 9.1      LAST MODIFIED: 06/12/00   BY: *N0BX* Arul Victoria    */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder    */
/* REVISION: 9.1      LAST MODIFIED: 10/19/00   BY: *M0VF* Rajesh Lokre     */
/* REVISION: 9.1      LAST MODIFIED: 10/30/00   BY: *M0VM* Rajesh Lokre     */
/* REVISION: 9.1      LAST MODIFIED: 12/18/00   BY: *M0Y3* Veena Lad        */
/* REVISION: 9.1      LAST MODIFIED: 01/02/01   BY: *M0YM* Veena Lad        */
/* Revision: 1.31.1.23     BY: Alok Thacker     DATE: 03/13/02    ECO: *M1NB* */
/* Revision: 1.31.1.24     BY: Vinod Nair       DATE: 05/27/02    ECO: *N1K0* */
/* Revision: 1.31.1.27     BY: Kirti Desai      DATE: 07/16/02    ECO: *N1MJ* */
/* Revision: 1.31.1.28    BY: Deepali Kotavadekar DATE: 12/27/02  ECO: *N22M* */
/* Revision: 1.31.1.29     BY: Manish Dani      DATE: 01/03/03    ECO: *M1YW* */
/* Revision: 1.31.1.30     BY: Rajesh Lokre     DATE: 04/03/03    ECO: *M1RX* */
/* Revision: 1.31.1.32     BY: Paul Donnelly (SB) DATE: 06/26/03  ECO: *Q00C* */
/* Revision: 1.31.1.35     BY: Dorota Hohol     DATE: 10/20/03    ECO: *P138* */
/* Revision: 1.31.1.37     BY: Kirti Desai      DATE: 11/04/03    ECO: *N2M3* */
/* Revision: 1.31.1.38     BY: Robert Jensen    DATE: 09/02/04    ECO: *N2XK* */
/* Revision: 1.31.1.39     BY: Vivek Gogte      DATE: 09/30/04    ECO: *P2LV* */
/* Revision: 1.31.1.40     BY: Jignesh Rachh    DATE: 11/08/04    ECO: *P2T8* */
/* Revision: 1.31.1.41     BY: Sushant Pradhan  DATE: 09/22/05    ECO: *P421* */
/* Revision: 1.31.1.42     BY: cnl              DATE: 02/07/06    ECO: *P4H9* */
/* &Revision: $     BY:  Sandeep Panchal  DATE: 03/14/06    ECO: *P4KC* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=NoConvert                                                  */

/*----rev history-------------------------------------------------------------------------------------*/
/*based on eb21sp6  , and amy's patch Q2SC ,ECO:AMY*/
/* SS - 100419.1  By: Roger Xiao */  /*add validate logic in fafamth.p */
/* SS - 100505.1  By: Roger Xiao */  /*add v_backward when adjust the basis or life */
/* SS - 100521.1  By: Roger Xiao */  /*资产转移标准程式bug修复:无效的账户组合,new sub = old sub ,new cc = new loc cc */
/* SS - 100525.1  By: Roger Xiao */  /*fix qad bug ,Solution ID: qad50713  */
/* SS - 100609.1  By: Roger Xiao */  /*xxfafamtb.p: 暂时取消限制fa_custodian*/
/* SS - 100705.1  By: Roger Xiao */  /*xxfafamtg.p: 允许输入负数的调整金额*/
/* SS - 100810.1  By: Roger Xiao */  /*xxfafamtb.p add xxfabklog01.p 记录定期费用faba_acctype = "3" 账户和成本中心的更改情况*/
/* SS - 110319.1  By: Roger Xiao */  /*xxfafamtg.p: 追溯调整时可输入追溯至指定期间,调整原值时可调整残值*/
/*-Revision end---------------------------------------------------------------*/



{mfdtitle.i "110319.1"} 
{cxcustom.i "FAFAMT.P"}

/* --------------------  DEFINE QUERY  ------------------- */
define query q_fa_mstr
   for fa_mstr
      fields( fa_domain fa_auth_number fa_dep fa_desc1 fa_dispamt fa_disp_dt
             fa_disp_rsn fa_entity fa_facls_id fa_faloc_id fa_id
             fa_mod_date fa_mod_userid fa_post fa_puramt fa_qty
             {&FAFAMT-P-TAG1}
             fa_replamt fa_salvamt fa_startdt)
      scrolling.

/* -----------------  STANDARD VARIABLES  ---------------- */

define new shared variable l-detail       like mfc_logical no-undo.
define new shared variable l-balance-enty like mfc_logical no-undo.

define variable p-status       as   character          no-undo.
define variable perform-status as   character format "x(25)"
                                initial "first"        no-undo.
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

define variable l_postgl        like mfc_logical
   label "Post To GL"   no-undo.
define variable l_printgl       like mfc_logical
   label "Print GL Audit Trail" no-undo.
define variable l_effdate       like glt_effdate
   format "99/99/9999"  no-undo.
define variable l_astpost       like mfc_logical no-undo.
define variable l_cost          like fa_puramt   no-undo.
define variable l_post_bk       like fabk_id     no-undo.
define variable l_ast_del       like fa_id       no-undo.
define variable l_firstcost     like fa_puramt   no-undo.
define variable l_cost_captured like mfc_logical no-undo.
define variable l_newbk         like mfc_logical no-undo.

/* ------------------  BUTTON VARIABLES  ----------------- */
define button b-update label "Update".
define button b-add    label "Add".
define button b-delete label "Delete".
define button b-option label "Option".
define button b-books  label "Books".
define button b-detail label "Detail".
define button b-find   label "Find".
define button b-end    label "End".
{&FAFAMT-P-TAG2}

/* -------------  STANDARD WIDGET VARIABLES  ------------- */
define variable l-focus as widget-handle no-undo.
define variable w-frame as widget-handle no-undo.

/* ------------------  SCREEN VARIABLES  ----------------- */
define new shared variable l-key     as   character format "x(12)" no-undo.
define new shared variable l-reopen-fa-query like mfc_logical      no-undo.
define new shared variable l-flag like mfc_logical initial no      no-undo.

define variable l-post          like mfc_logical              no-undo.
define variable l-gen           like mfc_logical              no-undo.
define variable l-err-nbr       as   integer   format "9999"  no-undo.
define variable valid_acct      like mfc_logical initial no   no-undo.
define variable fa_puramt_fmt   as   character format "x(30)" no-undo.
define variable fa_salvamt_fmt  as   character format "x(30)" no-undo.
define variable fa_replamt_fmt  as   character format "x(30)" no-undo.
define variable fa_dispamt_fmt  as   character format "x(30)" no-undo.
define variable l-first-time    like mfc_logical initial yes  no-undo.
define variable l-continue      like mfc_logical              no-undo.
define variable l-period        as   character format "x(6)"  no-undo.
define variable l-cal           as   character format "x(8)"  no-undo.
define variable l-fa-id         as   character format "x(12)" no-undo.
define variable l-temp-amt      as   decimal
                                format "->>>>,>>>,>>9.99<<<<" no-undo.
define variable mc-error-number as   character format "x(4)"  no-undo.
define variable l_msg_list      as   character                no-undo.
define variable l_sev_list      as   character                no-undo.
define new shared variable l_basis_adj     like mfc_logical   no-undo.  /* Amy -- 091223 -- Q2SC -- A */
define new shared temp-table dep no-undo like fabd_det.

/* ------------------  DESKTOP VARIABLE  ----------------- */
define variable dtokonly as logic initial yes no-undo.

/* ---------------  PRE PROCESSING INCLUDE  -------------- */

/* VARIABLES FOR GPGLEF1.I */
{gpglefv.i}

/* VARIABLES FOR FA PERSISTENT PROCEDURES */
{gprunpdf.i "fapl" "p"}

/* NRM SEQUENCE GENERATOR */
{gpnbrgen.i}

/* VARIABLES FOR MC PROCEDURES */
{gprunpdf.i "mcpl" "p"}

/* EAS PROCEDURES */
{gprunpdf.i "gpglvpl" "p"}

/* GET ENTITY SECURITY INFORMATION */
{glsec.i}

/* DAYBOOK VARIABLES */
{gldydef.i "new"}

/* NRM VARIABLES */
{gldynrm.i "new"}

{gprunpdf.i "nrm" "p"}

/* TEMP TABLE FOR AQUISITION COST POSTING LOGIC */
{fapsmt.i "new"}

/* ------------------  FRAME DEFINITION  ----------------- */
/* ADDED SIDE-LABELS PHRASE TO FRAME STATEMENT             */

define frame f-button
   b-update at 1
   b-add    at 10
   b-option at 19
   b-books  at 28
   b-detail at 37
   b-find   at 46
   b-delete at 55
   {&FAFAMT-P-TAG3}
   b-end    at 64
with no-box overlay three-d side-labels width 73.
{&FAFAMT-P-TAG4}

/* SET EXTERNAL LABELS */
setFrameLabels(frame f-button:handle).

assign
   l-focus               = b-update:handle in frame f-button
   b-update:width        = 8
   b-update:private-data = "update"
   b-add:width           = 8
   b-add:private-data    = "add"
   b-delete:width        = 8
   b-delete:private-data = "delete"
   b-option:width        = 8
   b-option:private-data = "option"
   b-books:width         = 8
   b-books:private-data  = "books"
   b-detail:width        = 8
   b-detail:private-data = "detail"
   b-find:width          = 8
   {&FAFAMT-P-TAG5}
   b-find:private-data   = "find"
   b-end:width           = 8
   b-end:private-data    = "end".

define frame f-1
   skip(.4)
   fa_id          colon 14
   fa_desc1 no-labels at 29
   skip
   fa_facls_id    colon 14
   fa_qty         colon 53
   skip
   fa_faloc_id    colon 14
   fa_dep         colon 53
   skip
   fa_entity      colon 14
   fa_post        colon 53
   skip
   fa_startdt     colon 14
   fa_auth_number colon 53
      format "x(18)"
   skip
   fa_puramt      colon 14
   fa_disp_dt     colon 53
   skip
   fa_salvamt     colon 14
   fa_disp_rsn    colon 53
      format "x(10)"
   skip
   fa_replamt     colon 14
   fa_dispamt     colon 53
with three-d side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame f-1:handle).

form
  skip(.4)
  l_postgl    colon 30
  l_effdate   colon 30
  dft-daybook colon 30
  l_printgl   colon 30
with frame a overlay row 10 side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

run ip-framesetup.

w-frame = frame f-1:handle.
{gprun.i ""fafmtut.p""
   "(w-frame)"}

/* DETERMINE IF BALANCED ENTITIES FLAG USED in 25.24 */
for first co_ctrl
   fields( co_domain co_enty_bal)
    where co_ctrl.co_domain = global_domain no-lock:
end. /* FOR FIRST co_ctrl */

if available co_ctrl
   and co_enty_bal
then
   l-balance-enty = yes.

/* GET THE POSTING BOOK */
for first fabk_mstr
   fields( fabk_domain fabk_id fabk_post)
    where fabk_mstr.fabk_domain = global_domain and  fabk_post = yes
   no-lock:
   l_post_bk = fabk_id.
end. /* FOR FIRST fabk_mstr */

for first fact_ctrl
   fields( fact_domain fact_auto fact_index1 fact_seq_id)
    where fact_ctrl.fact_domain = global_domain and  fact_index1 = 0
   no-lock
   use-index fact_index1:
end. /* FOR FIRST fact_ctrl */

if available fact_ctrl
then
   l-gen = fact_auto.
else do:
   /* CONTROL FILE ERROR. CHECK APPLICABLE CONTROL FILE EXISTENCE*/
   {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}.
   /* KEEP PAUSE TO HOLD THE MESSAGE - DON'T REMOVE */
   pause.
   return.
end. /* ELSE DO */

/* SET CURRENCY DEPENDENT ROUNDING FORMATS */
for first gl_ctrl
   fields( gl_domain gl_rnd_mthd)
    where gl_ctrl.gl_domain = global_domain no-lock:
end. /* FOR FIRST gl_ctrl */

assign
   fa_puramt_fmt  = fa_mstr.fa_puramt:format
   fa_salvamt_fmt = fa_mstr.fa_salvamt:format
   fa_replamt_fmt = fa_mstr.fa_replamt:format
   fa_dispamt_fmt = fa_mstr.fa_dispamt:format.

{gprun.i ""gpcurfmt.p""
   "(input-output fa_puramt_fmt,
     input        gl_rnd_mthd)"}

if global-beam-me-up
then
   undo, leave.

{gprun.i ""gpcurfmt.p""
   "(input-output fa_salvamt_fmt,
     input        gl_rnd_mthd)"}

if global-beam-me-up
then
   undo, leave.

{gprun.i ""gpcurfmt.p""
   "(input-output fa_replamt_fmt,
     input        gl_rnd_mthd)"}

if global-beam-me-up
then
   undo, leave.

{gprun.i ""gpcurfmt.p""
   "(input-output fa_dispamt_fmt,
     input        gl_rnd_mthd)"}

if global-beam-me-up
then
   undo, leave.

assign
   fa_mstr.fa_puramt:format  = fa_puramt_fmt
   fa_mstr.fa_salvamt:format = fa_salvamt_fmt
   fa_mstr.fa_replamt:format = fa_replamt_fmt
   fa_mstr.fa_dispamt:format = fa_dispamt_fmt.
/* -------------  END PRE PROCESSING INCLUDE  ------------ */

open query q_fa_mstr
   for each fa_mstr
       where fa_mstr.fa_domain = global_domain and  fa_id >= ""
      use-index fa_id
      no-lock.

get first q_fa_mstr no-lock.

main-loop:
do while perform-status <> "end" on error undo:
   if perform-status = "first"
   then
      p-status = "first-one".

   /* CHECK FOR ENTITY SECURITY WHEN BUTTON 'UPDATE' 'OPTION' */
   /* 'BOOKS' 'DETAIL' OR 'DELETE' IS SELECTED                */

   l-error = no.

   if  perform-status <> "first"
   and perform-status <> "add"
   and perform-status <> "next"
   and perform-status <> "prev"
   and perform-status <> "find"
   and perform-status <> " "
   and available fa_mstr
   then do:

      /* CHECK ENTITY SECURITY */
      run valid-entity (input  fa_entity,
                        output l-error).

      if l-error
      then
         if batchrun
         then
            return.
         else
            perform-status = " ".

   end. /* IF perform-status <> "first" ... */

   if perform-status = "first"
      and p-status = "first-one"
   then do:
      if available fa_mstr
      then
         /* ADDED INPUT PARAMETER l_firstcost AND               */
         /* INPUT-OUPUT PARAMETERS l_newbk l_astpost AND l_cost */
/* SS - 100505.1 - B 
         {gprun.i ""fafamta.p""
            "(input        l_firstcost,
              input-output p-status,
              input-output l_newbk,
              input-output l_astpost,
              input-output l_cost,
              buffer       fa_mstr)"}
   SS - 100505.1 - E */
/* SS - 100505.1 - B */
         {gprun.i ""xxfafamta.p""
            "(input        l_firstcost,
              input-output p-status,
              input-output l_newbk,
              input-output l_astpost,
              input-output l_cost,
              buffer       fa_mstr)"}
/* SS - 100505.1 - E */

      if global-beam-me-up
      then
         undo, leave.
      p-status = "".
   end. /* IF perform-status = "first" and .... */

   if perform-status = "end"
   or perform-status = "add"
   then do:
      p-status = perform-status.

      if perform-status = "add":u
      then
         l_newbk = yes.

      if available fa_mstr
      then
         /* ADDED INPUT PARAMETER l_firstcost AND               */
         /* INPUT-OUPUT PARAMETERS l_newbk l_astpost AND l_cost */
/* SS - 100505.1 - B 
         {gprun.i ""fafamta.p""
            "(input        l_firstcost,
              input-output p-status,
              input-output l_newbk,
              input-output l_astpost,
              input-output l_cost,
              buffer       fa_mstr)"}
   SS - 100505.1 - E */
/* SS - 100505.1 - B */
         {gprun.i ""xxfafamta.p""
            "(input        l_firstcost,
              input-output p-status,
              input-output l_newbk,
              input-output l_astpost,
              input-output l_cost,
              buffer       fa_mstr)"}
/* SS - 100505.1 - E */
      if global-beam-me-up
      then
         undo, leave.
      p-status = "".
   end. /* IF perform-status = "end" and .... */

   run ip-query
      (input-output perform-status,
       input-output l-rowid).

   if perform-status = "delete"
   then do:
      run ip-lock
         (input-output perform-status).

      perform-status = "first".
      run ip-predisplay.
   end. /* IF perform-status = "delete" and .... */

   /* ---------------  AFTER QUERY INCLUDE  --------------- */
   if l-first-time
      and available fa_mstr
      and fa_mstr.fa_dep
   then do:
      l-post = no.

      for each fab_det
         fields( fab_domain fab_fa_id fab_fabk_id)
         no-lock
          where fab_det.fab_domain = global_domain and  fab_fa_id = fa_id
         and   can-find(first fabk_mstr
                where fabk_mstr.fabk_domain = global_domain and  fabk_id   =
                fab_fabk_id
               and   fabk_post = yes):
         l-post = yes.
      end. /* FOR EACH fab_det .... */

      if l-post = no
      then do:
         for first fabk_mstr
            fields( fabk_domain fabk_id fabk_post)
             where fabk_mstr.fabk_domain = global_domain and  fabk_post = yes
            no-lock:
         end. /* FOR FIRST fabk_mstr */

         if available fabk_mstr
         then do:
            /* POSTING BOOK NOT SET UP FOR THIS ASSET */
            {pxmsg.i &MSGNUM=4236 &ERRORLEVEL=2 &MSGARG1=fabk_id}

            l-first-time = no.
            next main-loop.
         end. /* IF AVAILABLE fabk_mstr */
      end. /* IF l-post = no */
   end.  /* IF FIRST TIME AND DEPRECIATING ASSET */
   /* -------------  END AFTER QUERY INCLUDE  ------------- */

   /* ----------------------  OPTION  --------------------- */
   if perform-status = "option"
   then do:
      p-status = "display".
      if session:display-type = "gui"
      then
         assign
            fa_id:bgcolor = 8
            fa_id:fgcolor = 0.

/* SS - 100419.1 - B 
      {gprun.i ""fafamtb.p""
         "(output l-flag)"}
   SS - 100419.1 - E */
/* SS - 100419.1 - B */
      {gprun.i ""xxfafamtb.p""  "(output l-flag)"}
/* SS - 100419.1 - E */

      /* l-flag IS SET TO yes IN BATCH MODE IN PROGRAM fafamto.p */
      /* FOR AN ERROR ENCOUNTERED.                               */
      if l-flag
      then
         undo main-loop, leave main-loop.

      if global-beam-me-up
      then
         undo, leave.

      assign
         p-status       = ""
         perform-status = "first".

      run ip-displayedits.
      perform-status = "first".
   end. /* IF perform-status = "option" */
   /* --------------------  END OPTION  ------------------- */

   /* ----------------------  BOOKS  ---------------------- */
   if perform-status = "books"
   then do:
      p-status = "display".

      if session:display-type = "gui"
      then
         assign
            fa_id:bgcolor = 8
            fa_id:fgcolor = 0.
      else
         color display normal fa_id
         with frame f-1.

      if available fa_mstr then
      do:

         for first fab_det
            fields( fab_domain fab_amt fab_date fab_fabk_id fab_famt_id
                    fab_fa_id fab_ovramt fab_resrv fab_salvamt)
            no-lock
             where fab_det.fab_domain = global_domain and  fab_fa_id = fa_id
            and can-find(first fabk_mstr
                where fabk_mstr.fabk_domain = global_domain and  fabk_id   =
                fab_fabk_id
               and   fabk_post = yes)
               and   l_cost_captured = no:
            assign
               l_firstcost     = fab_amt
               l_cost_captured = yes.
         end. /* FOR EACH fab_det */

         if l_newbk
         then
            l_firstcost = 0.

         /* ADDED INPUT PARAMETER l_firstcost AND               */
         /* INPUT-OUPUT PARAMETERS l_newbk l_astpost AND l_cost */
/* SS - 100505.1 - B 
         {gprun.i ""fafamta.p""
            "(input        l_firstcost,
              input-output p-status,
              input-output l_newbk,
              input-output l_astpost,
              input-output l_cost,
              buffer       fa_mstr)"}
   SS - 100505.1 - E */
/* SS - 100505.1 - B */
         {gprun.i ""xxfafamta.p""
            "(input        l_firstcost,
              input-output p-status,
              input-output l_newbk,
              input-output l_astpost,
              input-output l_cost,
              buffer       fa_mstr)"}
/* SS - 100505.1 - E */
      end. /* IF AVAILABLE fa_mstr */

      /* l-flag IS SET TO yes IN BATCH MODE IN fafamta.p */
      /* FOR AN ERROR ENCOUNTERED.                       */
      if l-flag
      then
         undo main-loop, leave main-loop.

      if global-beam-me-up
      then
         undo, leave.

      assign
         p-status       = ""
         perform-status = "first".
      run ip-displayedits.
   end.  /* IF perform-status = "books" */
   /* --------------------  END BOOKS  -------------------- */

   /* ----------------------  DETAIL  --------------------- */
   if perform-status = "detail"
   then do:
      p-status = "display".

      if session:display-type = "gui"
      then
         assign
            fa_id:bgcolor = 8
            fa_id:fgcolor = 0.

      {gprun.i ""fafamtc.p""}

      if global-beam-me-up
      then
         undo, leave.

      assign
         p-status       = ""
         perform-status = "first".

      run ip-displayedits.
      perform-status = "first".
   end.  /* IF perform-status = "detail"  */
   /* --------------------  END DETAIL  ------------------- */
   {&FAFAMT-P-TAG6}
   /* ----------------------  DISPLAY  ---------------------- */

   run ip-predisplay.

   /* -------------------  ADD/UPDATE  -------------------- */
   if (perform-status = "update"
   or  perform-status = "add")
   then do:
      run ip-prompt.

      if l_cost <> 0
      then
         l_cost = fa_mstr.fa_puramt.

      if l_cost_captured = yes
         and l_newbk     = no
      then
         l_cost = fa_mstr.fa_puramt - l_firstcost.
/* Amy -- 091223 -- Q2SC -- B */
     if     l_cost_captured = no
        and l_newbk         = no
        and l_basis_adj     = no
        and l_firstcost     = 0
    then
       l_cost = 0.
/* Amy -- 091223 -- Q2SC -- E */
      /* l-flag IS SET TO yes IN BATCH MODE IN PROCEDURE ip-prompt */
      /* FOR AN ERROR ENCOUNTERED.                                 */
      if l-flag
      then
         undo main-loop, leave main-loop.

      if global-beam-me-up
      then
         undo, leave.

      if perform-status = "undo"
      then do:
         perform-status = "first".
         next main-loop.
      end. /* IF perform-status = "undo" */
      run ip-displayedits.
   end. /* IF perform-status = "update" AND ... */

   /* -----------------------  END  ----------------------- */
   if perform-status = "end"
   then do:
      hide frame f-1 no-pause.
      delete PROCEDURE this-procedure no-error.
      leave.
   end. /* IF perform-status = "end" */

   /* ----------------  SELECTION BUTTONS  ---------------- */
   if perform-status <> "first" then
   do:
      run ip-button
      (input-output perform-status).

      /* LOGIC FOR THE ACCEPTANCE AND PRINTING OF POST TO GL DATA */
      /* AND CREATION OF THE TEMP TABLE tt_pstast                 */
      if perform-status    = "add":U
         or perform-status = "find":U
         or perform-status = "next":U
         or perform-status = "prev":U
         or perform-status = "end":U
      then do:

         /* ACCEPT AND  STORE POST TO GL DATA */
         run ip_posttogl.

         /* PRINT THE GL AUDIT TRAIL BASED ON USER INPUT */
         if perform-status = "end"
         then do:

            find first tt_pstast
               no-lock no-error.

            if available tt_pstast
            then do:

               printloop:
               do on error undo, retry:
                  display
                     l_printgl
                  with frame a overlay.

                  prompt-for
                     l_printgl
                  with frame a overlay.

                  l_printgl = input l_printgl.

                  {gprun.i ""fafamt1a.p""
                     "(input l_postgl,
                       input l_effdate,
                       input dft-daybook,
                       input l_post_bk,
                       input l_printgl)"}

                 hide frame a.
                 leave printloop.
               end. /* PRINTLOOP */

            end. /* IF AVAILABLE tt_pstast */
         end. /* IF perform-status = "end" */

         assign
            l_astpost       = no
            l_cost          = 0
            l_cost_captured = no
            l_firstcost     = 0
            l_newbk         = no.

         if perform-status = "end":U
            and not can-find(first tt_pstast)
         then
            return.

      end. /* IF perform-status = "add":U ... */

   end. /* IF perform-status <> "first":U */

   /* -------------  AFTER STRIP MENU INCLUDE  ------------ */
   if available fa_mstr
   then
      l-key = fa_id.

   if perform-status = "books"
      and not input frame f-1 fa_dep
   then do:
      /* BOOKS ARE NOT MAINTAINED FOR NON DEPRECIATING ASSETS  */
      {pxmsg.i &MSGNUM=3194 &ERRORLEVEL=4}

      perform-status = "".
      next main-loop.
   end. /* IF perform-status = "books" */

   if perform-status = "find"
   then do:
      prompt-for
         fa_id
      with frame f-1.
      for first fa_mstr
         fields( fa_domain fa_auth_number fa_dep fa_desc1 fa_dispamt
                fa_disp_dt fa_disp_rsn fa_entity fa_facls_id
                fa_faloc_id fa_id fa_mod_date fa_mod_userid fa_post
                fa_puramt fa_qty fa_replamt fa_salvamt fa_startdt)
          where fa_mstr.fa_domain = global_domain and  fa_id >= input frame f-1
          fa_id
         no-lock:
         l-rowid = rowid(fa_mstr).
      end. /* FOR FIRST fa_mstr */

      run ip-query
         (input-output perform-status,
          input-output l-rowid).
      perform-status = "first".
   end. /* IF perform-status = "find" */

   if global-beam-me-up
   then
      undo, leave.

/*
 * When output to PAGE in Desktop, have to wait here in order to finish report.
 */
if {gpiswrap.i} and (perform-status = "end") then do:
   /* Please confirm exit */
   {pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=dtokonly &CONFIRM-TYPE='LOGICAL'}
end.

   /* -----------  END AFTER STRIP MENU INCLUDE  ---------- */
end.  /* MAIN-LOOP: */

/* -------------  ADD / UPDATE / FIELD EDITS  ------------ */
PROCEDURE ip-prompt:
   if perform-status = "add"
   then
      clear frame f-1 all no-pause.

   l-first = yes.
   CASE perform-status:
      when ("add")
      then do:
         /* ADDING NEW RECORD */
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      end. /* WHEN ("add") */
      when ("update")
      then do:
         /* MODIFYING EXISTING RECORD */
         {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1}
      end. /* WHEN ("update") */
      otherwise
         hide message no-pause.
   END CASE.

   ststatus = stline[3].
   status input ststatus.

   /* BEFORE-ADD-EDIT */
   if l-first
   and perform-status = "add"
   then
      fa_qty:screen-value = "1".
      /* THE CODE HAS BEEN MOVED TO THE BEGINING OF PROCEDURE IP-ADD */

   /* BEFORE-ADD-EDIT */
   l-post = if available fa_mstr
            and perform-status <> "add"
            then
               fa_mstr.fa_post
            else
               no.

   prompt-for-it:
   repeat:
      l-first = no.
      repeat:
         prompt-for
            fa_mstr.fa_id
               when (perform-status = "add"
                     and l-gen = no)
            fa_mstr.fa_desc1
            fa_mstr.fa_facls_id
            fa_mstr.fa_faloc_id
               when (l-post = no)
         with frame f-1.

         /* FIELD EDIT FOR fa_id */
         l-error = no.

         if l-gen = no
         then

            if (can-find(fa_mstr
                          where fa_mstr.fa_domain = global_domain and (  fa_id
                          = input frame f-1 fa_id
                         ) no-lock)
                or can-find(fabchd_det
                             where fabchd_det.fabchd_domain = global_domain and
                              fabchd_fa_id = input frame f-1 fa_id
                            no-lock))
               and perform-status = "add"
            then do:
               l-error = yes.
               /* DUPLICATE RECORD EXISTS */
               {pxmsg.i &MSGNUM=2041 &ERRORLEVEL=3}
            end. /* IF (CAN-FIND(fa_mstr .... */

         if input frame f-1 fa_mstr.fa_id = ""
            and l-gen                     = no
         then do:
            /* BLANK NOT ALLOWED */
            {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
            l-error = yes.
         end. /* IF INPUT frame f-1 fa_mstr.fa_id .... */

         /* l-flag IS SET TO yes IN BATCH MODE. */
         if l-error
         then do:
            if not batchrun
            then do:
               next-prompt fa_id with frame f-1.
               next.
            end. /* IF NOT batchrun */
            else do:
               l-flag = yes.
               return.
            end. /* ELSE batchrun */
         end. /* IF l-error */
         /* END FIELD EDIT FOR fa_id */

         if input frame f-1 fa_facls_id = ""
         then do:
            /* BLANK NOT ALLOWED */
            {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}

            /* l-flag IS SET TO yes IN BATCH MODE. */
            if not batchrun
            then do:
               next-prompt fa_facls_id with frame f-1.
               next.
            end. /* IF NOT batchrun */
            else do:
               l-flag = yes.
               return.
            end. /* ELSE batchrun */
         end. /* IF INPUT frame f-1 fa_facls_id = "" */

         if input frame f-1 fa_faloc_id = ""
         then do:
            /* BLANK NOT ALLOWED */
            {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}

            if not batchrun
            then do:
               next-prompt fa_faloc_id with frame f-1.
               next.
            end. /* IF NOT batchrun */
            else do:
               l-flag = yes.
               return.
            end. /* ELSE batchrun */
         end. /* IF INPUT frame f-1 fa_faloc_id = "" */

         /* FIELD EDIT FOR fa_facls_id */
         l-error = no.
         for first facls_mstr
            fields( facls_domain facls_dep facls_id)
             where facls_mstr.facls_domain = global_domain and  facls_id =
             input frame f-1 fa_facls_id
            no-lock:
         end. /* FOR FIRST facls_mstr */

         if not available facls_mstr
         then do:
            l-error = yes.
            /* INVALID CLASS CODE */
            {pxmsg.i &MSGNUM=4212 &ERRORLEVEL=3}
         end. /* IF NOT AVAILABLE facls_mstr */
         else
            if perform-status = "add"
            then
               fa_dep:screen-value = string(facls_dep).

         /* l-flag IS SET TO yes IN BATCH MODE. */
         if l-error
         then do:
            if not batchrun
            then do:
               next-prompt
                  fa_facls_id
               with frame f-1.
               next.
            end. /* IF NOT batchrun */
            else do:
               l-flag = yes.
               return.
            end. /* ELSE batchrun */
         end. /* IF l-error */
         /* END FIELD EDIT FOR fa_facls_id */

         /* FIELD EDIT FOR fa_faloc_id */
         l-error = no.
         for first faloc_mstr
            fields( faloc_domain faloc_id faloc_entity faloc_sub faloc_cc)
             where faloc_mstr.faloc_domain = global_domain and  faloc_id =
             input frame f-1 fa_faloc_id
            no-lock:
         end. /* FOR FIRST faloc_mstr */


         if can-find(first facd_det no-lock
                        where facd_det.facd_domain = global_domain
                        and   facd_facls_id        =  input frame f-1 fa_facls_id
                        and   facd_acctype         <> "0"
                        and   facd_acct            =  "")
         then do:
            /* VALID NON-BLANK ACCOUNT NUMBER REQUIRED */
            {pxmsg.i &MSGNUM=5227 &ERRORLEVEL=2}
         end.


         if available faloc_mstr
         then do:

            /* CHECK ENTITY SECURITY */
            run valid-entity (input  faloc_entity,
                              output l-error).

            if l-error
            then do:

               if not batchrun
               then do:
                  next-prompt
                     fa_faloc_id
                  with frame f-1.
                  next.
               end. /* IF NOT batchrun */
               else do:
                  l-flag = yes.
                  return.
               end. /* ELSE DO */
            end. /* IF NOT l-error */

            fa_mstr.fa_entity:screen-value = faloc_mstr.faloc_entity.

            {&FAFAMT-P-TAG7}
            /* VALIDATE ACCT/SUB/CC FOR EACH DEFAULT ACCOUNT */
            for each facd_det
               fields( facd_domain facd_facls_id facd_acct)
                where facd_det.facd_domain = global_domain and  facd_facls_id =
                input frame f-1 fa_facls_id
               and   facd_acct     <> ""
               no-lock:

               /* INITIALIZE SETTINGS */
               {gprunp.i "gpglvpl" "p" "initialize"}

               /* SET PROJECT VERIFICATION TO NO */
               {gprunp.i "gpglvpl" "p" "set_proj_ver"
                  "(input false)"}

               /* TURN OFF THE DISPLAY MESSAGES */
               {gprunp.i "gpglvpl" "p" "set_disp_msgs"
                  "(input false)"}

               /* ACCT/SUB/CC/PROJ VALIDATION */
               {gprunp.i "gpglvpl" "p" "validate_fullcode"
                  "(input  facd_acct,
                    input  faloc_sub,
                    input  faloc_cc,
                    input  """",
                    output valid_acct)"}

               /* GET THE ERROR MESSAGES FROM gpglvpl.p */
               {gprunp.i "gpglvpl" "p" "get_msgs"
                  "(output l_msg_list,
                    output l_sev_list)"}

               /* SUPPRESS HARD ERRORS FROM gpglvpl.p */
               if integer(l_sev_list)    = 3
                  or integer(l_sev_list) = 4
               then
                  l_sev_list = "2".

               if global-beam-me-up
               then
                  undo, leave.

               if not valid_acct
               then do:
                  {pxmsg.i &MSGNUM=integer(l_msg_list)
                           &ERRORLEVEL=integer(l_sev_list)}
                  leave.
               end. /* IF NOT valid_acct */
            end.  /* FOR EACH facd_det */
         end.  /* IF AVAILABLE faloc_mstr */
         else do:
            l-error = yes.
            /* LOCATION DOES NOT EXIST */
            {pxmsg.i &MSGNUM=4220 &ERRORLEVEL=3}
         end. /* ELSE DO */

         /* l-flag IS SET TO yes IN BATCH MODE. */
         if l-error
         then do:
            if not batchrun
            then do:
               next-prompt
                  fa_faloc_id
               with frame f-1.
               next.
            end. /* IF NOT batchrun */
            else do:
               l-flag = yes.
               return.
            end. /* ELSE batchrun */
         end. /* IF l-error */
         /* END FIELD EDIT FOR fa_faloc_id */

         leave.
      end. /* REPEAT */

      if global-beam-me-up
      then
         undo, leave.

      if keyfunction(lastkey) = "end-error"
      then do:
         perform-status = "undo".
         return no-apply.
      end. /* IF KEYFUNCTION(lastkey) = "end-error" */

      repeat:
         prompt-for
            fa_mstr.fa_startdt
               when (l-post = no)
            fa_mstr.fa_puramt
               when (l-post = no)
         with frame f-1.

         /* FIELD EDIT FOR fa_startdt */
         l-error = no.

         if not l-post
         then do:
            if input frame f-1 fa_startdt = ?
            then do:
               /* DATE REQUIRED */
               {pxmsg.i &MSGNUM=711 &ERRORLEVEL=3}

               /* l-flag IS SET TO yes IN BATCH MODE. */
               if not batchrun
               then do:
                  next-prompt
                     fa_startdt
                  with frame f-1.
                  next.
               end. /* IF NOT batchrun */
               else do:
                  l-flag = yes.
                  return.
               end. /* ELSE batchrun */
            end. /* IF INPUT FRAME f-1 fa_startdt = ? */

            /* VALIDATE SERVICE DATE IN GL CALENDAR   */
            /* BUT ONLY DISPLAY A WARNING SINCE FA    */
            /* POST CAN PERFORM A "CATCH UP" FUNCTION */
            {gprun.i ""gpglef1.p""
               "(input  ""FA"",
                 input  input frame f-1 fa_mstr.fa_entity,
                 input  input frame f-1 fa_mstr.fa_startdt,
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

            /* VALIDATE DATE IN CUSTOM CALENDAR IF ANY */
            for each fadf_mstr
               fields( fadf_domain fadf_facls_id fadf_fabk_id fadf_famt_id)
                where fadf_mstr.fadf_domain = global_domain and  fadf_facls_id
                = input frame f-1 fa_facls_id
               no-lock:

               for first fabk_mstr
                  fields( fabk_domain fabk_id fabk_calendar fabk_post)
                   where fabk_mstr.fabk_domain = global_domain and  fabk_id
                     =  fadf_fabk_id
                  and   fabk_calendar <> ""
                  and   fabk_post     =  no
                  no-lock:
               end. /* FOR FIRST fabk_mstr */

               if available fabk_mstr
               then do:
                  for first facld_det
                     fields( facld_domain facld_facl_id facld_per facld_start
                     facld_end)
                      where facld_det.facld_domain = global_domain and
                      facld_facl_id = fabk_calendar
                     and   facld_start   <= input frame f-1 fa_startdt
                     and   facld_end     >= input frame f-1 fa_startdt
                     no-lock:
                  end. /* FOR FIRST facld_det */

                  if not available facld_det
                  then do:
                     /* DATE NOT WITHIN A VALID PERIOD */
                     {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
                     l-error = yes.
                     leave.
                  end. /* IF NOT AVAILABLE facld_det */
               end.  /* FOR FIRST fabk_mstr */

               /* CUSTOM TABLE */
               for first famt_mstr
                  fields( famt_domain famt_id famt_type)
                   where famt_mstr.famt_domain = global_domain and  famt_id   =
                   fadf_famt_id
                  and   famt_type = "6"
                  no-lock:

                  l-cal = if available fabk_mstr
                          then
                             fabk_calendar
                          else
                             "".

                  {gprunp.i "fapl" "p" "fa-get-per"
                     "(input  input frame f-1 fa_startdt,
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
                     /* CUSTOM TABLE CANNOT BE USED WITH A CALENDAR */
                     /* THAT HAS MORE THAN 13 PERIODS               */
                     {pxmsg.i &MSGNUM=3197 &ERRORLEVEL=3}
                     l-error = yes.
                  end. /* IF INTEGER(SUBSTRING(l-period,5,2)) > 13 */
               end. /* FOR FIRST fabk_mstr */
            end.  /* FOR EACH fadf_mstr */
         end. /* IF NOT l-post */

         /* l-flag IS SET TO yes IN BATCH MODE. */
         if l-error
         then do:
            if not batchrun
            then do:
               next-prompt
                  fa_startdt
               with frame f-1.
               next.
            end. /* IF NOT batchrun */
            else do:
               l-flag = yes.
               return.
            end. /* ELSE batchrun */
         end. /* IF l-error */
         /* END FIELD EDIT FOR fa_startdt */

         /* FIELD EDIT FOR fa_puramt */
         l-error = no.

         if input frame f-1 fa_puramt = 0
            and available fa_mstr
            and fa_mstr.fa_post       = no
            then do:
               /* BLANK NOT ALLOWED */
               {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
            l-error = yes.
         end. /* IF INPUT frame .... */

         if input frame f-1 fa_puramt entered
            and l-error = no
         then
            fa_replamt:screen-value = input frame f-1 fa_puramt.

         /* CHECK CURRENCY DEPENDENT ROUNDING FORMAT */
         {gprun.i ""gpcurval.p""
            "(input  input frame f-1 fa_puramt,
              input  gl_ctrl.gl_rnd_mthd,
              output l-err-nbr)"}

         if global-beam-me-up
         then
            undo, leave.

         if l-err-nbr <> 0
         then
            l-error = yes.

         l-err-nbr = 0.

         /* l-flag IS SET TO yes IN BATCH MODE. */
         if l-error
         then do:
            if not batchrun
            then do:
               next-prompt
                  fa_puramt
               with frame f-1.
               next.
            end. /* IF NOT batchrun */
            else do:
               l-flag = yes.
               return.
            end. /* ELSE batchrun */
         end. /* IF l-error */

         if perform-status = "update"
         then do:
            l-continue = yes.

            if input frame f-1 fa_puramt entered
            then do:
               {pxmsg.i &MSGNUM=3349 &ERRORLEVEL=1 &CONFIRM=l-continue
                        &CONFIRM-TYPE='LOGICAL'}
            end. /* IF perform-status = "update" */
            if l-continue = no
            then do:
               perform-status = "first".
               return no-apply.

            end. /* IF l-continue = no */
         end.  /* IF perform-status = "update" */
         /* END FIELD EDIT FOR fa_puramt */

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
            fa_mstr.fa_salvamt
               when (l-post = no)
            fa_mstr.fa_replamt
            fa_mstr.fa_qty
               when (perform-status = "add")
            fa_mstr.fa_dep
               when (perform-status = "add")
            fa_mstr.fa_auth_number
         with frame f-1.

         /* FIELD EDIT FOR fa_salvamt */
         l-error = no.
         if input frame f-1 fa_salvamt > input frame f-1 fa_puramt
         then do:
            /* SALVAGE VALUE CANNOT BE GREATER THAN COST */
            {pxmsg.i &MSGNUM=3196 &ERRORLEVEL=3}
            l-error = yes.
         end. /* IF INPUT frame .... */

         if input frame f-1 fa_salvamt < 0
         then do:
            /* SALVAGE VALUE CANNOT BE LESS THAN ZERO */
            {pxmsg.i &MSGNUM=228 &ERRORLEVEL=3}
            l-error = yes.
         end. /* IF INPUT frame .... */

         /* CHECK CURRENCY DEPENDENT ROUNDING FORMAT */
         {gprun.i ""gpcurval.p""
            "(input  input frame f-1 fa_salvamt,
              input  gl_ctrl.gl_rnd_mthd,
              output l-err-nbr)"}

         if global-beam-me-up
         then
            undo, leave.

         if l-err-nbr <> 0
         then
            l-error = yes.

         l-err-nbr = 0.

         /* l-flag IS SET TO yes IN BATCH MODE. */
         if l-error
         then do:
            if not batchrun
            then do:
               next-prompt
                  fa_salvamt
               with frame f-1.
               next.
            end. /* IF NOT batchrun */
            else do:
               l-flag = yes.
               return.
            end. /* ELSE batchrun */
         end. /* IF l-error */

         if perform-status = "update"
         then do:
            l-continue = yes.

            if not input frame f-1 fa_puramt entered
               and input frame f-1 fa_salvamt entered
            then do:
               {pxmsg.i &MSGNUM=3350 &ERRORLEVEL=1 &CONFIRM=l-continue
                        &CONFIRM-TYPE='LOGICAL'}
            end. /* IF NOT INPUT frame .... */

            if l-continue = no
            then do:
               perform-status = "first".
               return no-apply.
            end. /* IF l-continue = no */
         end. /* IF perform-status = "update" */
         /* END FIELD EDIT FOR fa_salvamt */

         /* FIELD EDIT FOR fa_replamt */
         l-error = no.

         /* CHECK CURRENCY DEPENDENT ROUNDING FORMAT */
         {gprun.i ""gpcurval.p""
            "(input  input frame f-1 fa_replamt,
              input  gl_ctrl.gl_rnd_mthd,
              output l-err-nbr)"}

         if global-beam-me-up
         then
            undo, leave.

         if l-err-nbr <> 0
         then
            l-error = yes.
         l-err-nbr = 0.

         /* l-flag IS SET TO yes IN BATCH MODE. */
         if l-error
         then do:
            if not batchrun
            then do:
               next-prompt
                  fa_replamt
               with frame f-1.
               next.
            end. /* IF NOT batchrun */
            else do:
               l-flag = yes.
               return.
            end. /* ELSE batchrun */
         end. /* IF l-error */
         /* END FIELD EDIT FOR fa_replamt */

         /* FIELD EDIT FOR fa_qty */
         l-error = no.

         if perform-status = "add"
         then do:
            if input frame f-1 fa_qty < 1
            then do:
               /* QUANITY MUST BE GREATER THAN 0 */
               {pxmsg.i &MSGNUM=3195 &ERRORLEVEL=3}

               assign
                  fa_qty:screen-value = "1"
                  l-error             = yes.
            end. /* IF INPUT FRAME .... */

            /* VALIDATE THAT NUMBER OF COMPONENTS DOES NOT */
            /* RESULT IN TOO SMALL OF A COMPONENT COST     */
            l-temp-amt = input frame f-1 fa_puramt
                         / input frame f-1 fa_qty.

            if l-temp-amt < 0.01
            then do:
               /* COST PER COMPONENT MUST BE GREATER THAN 0 */
               {pxmsg.i &MSGNUM=3221 &ERRORLEVEL=3}
               l-error = yes.
            end. /* IF l-temp-amt < 0.01 */
         end.  /* IF perform-status = "add" */

         /* l-flag IS SET TO yes IN BATCH MODE. */
         if l-error
         then do:
            if not batchrun
            then do:
               next-prompt
                  fa_qty
               with frame f-1.
               next.
            end. /* IF NOT batchrun */
            else do:
               l-flag = yes.
               return.
            end. /* ELSE batchrun */
         end. /* IF l-error */
         /* END FIELD EDIT FOR fa_qty */

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
      end.  /* IF perform-status = "add" */

      perform-status = "first".
      clear frame f-1.
      get current q_fa_mstr
         no-lock.
      run ip-displayedits.
      return.
   end. /* IF KEYFUNCTION(lastkey) = "end-error" */
   run ip-lock
      (input-output perform-status).
END PROCEDURE. /* ip-prompt */

/* -----------------------  Locking  ----------------------- */
PROCEDURE ip-lock:

   define input-output parameter perform-status as character no-undo.

   if perform-status    = "add"
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
         get current q_fa_mstr
         no-lock.

      if available fa_mstr and
         current-changed fa_mstr
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
         end. /* IF l-delete-it = no  */
         hide message no-pause.
      end. /* IF AVAILABLE fa_mstr .... */

      if available fa_mstr
      then
         tran-lock:

         do while perform-status <> "":
         get current q_fa_mstr
            exclusive-lock no-wait.

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
      end. /* DO WHILE */

      if (perform-status = "update"
          or p-status    = "update")
         and l-delete-it = yes
      then
         run ip-update
            (input-output perform-status).

      if perform-status = "delete"
      then run ip-delete
         (input-output perform-status).

      if available fa_mstr
      then
         get current q_fa_mstr
            no-lock.

      if perform-status = "add"
      then
         run ip-add
            (input-output perform-status).

      if perform-status = "undo"
      then
         undo ip-lock, return.
   end. /* IF perform-status = "add" */

END PROCEDURE. /* ip-lock */

PROCEDURE ip-update:

   define input-output parameter perform-status as character no-undo.

   if p-status = "update"
   then
      p-status = "".

   /* LOCKED-UPDATE-EDITS */
   /* UPDATE CLASS ON DEPRECIATION ARRAY FROM THIS POINT FORWARD */
   if frame f-1 fa_facls_id entered
   then
      for each fabd_det
          where fabd_det.fabd_domain = global_domain and  fabd_fa_id =
          fa_mstr.fa_id
         exclusive-lock:

         fabd_facls_id = input frame f-1 fa_facls_id.
      end. /* FOR EACH fabd_det */
   /* LOCKED-UPDATE-EDITS */

   run ip-assign
      (input-output perform-status).
   if perform-status = "undo"
   then
      return.

   perform-status = "open".
   run ip-query
      (input-output perform-status,
       input-output l-rowid).
END PROCEDURE. /* ip-update */

PROCEDURE ip-add:

   define input-output parameter perform-status as character no-undo.

   if l-gen
   then do:
      repeat:
         run getnbr
            (input  fact_ctrl.fact_seq_id,
             input  today,
             output l-fa-id,
             output l-error,
             output l-err-nbr).

         if l-error
         then do:
            {pxmsg.i &MSGNUM=l-err-nbr &ERRORLEVEL=1}
            perform-status = "undo".
            return.
         end. /* IF l-error */

         if length(l-fa-id) > 12
         then do:
            /* ASSET ID IS MORE THAN 12 CHARACTERS LENGTH */
            {pxmsg.i &MSGNUM=3193 &ERRORLEVEL=3}
            return.
         end. /* IF LENGTH(l-fa-id) > 12 */

         if not can-find(first fa_mstr
             where fa_mstr.fa_domain = global_domain and  fa_id = l-fa-id)
            and not can-find(first fabchd_det
                              where fabchd_det.fabchd_domain = global_domain
                              and  fabchd_fa_id = l-fa-id)
            then
            leave.
      end. /* REPEAT */

      fa_id:screen-value in frame f-1 = l-fa-id.

   end. /* IF l-gen */

   create fa_mstr. fa_mstr.fa_domain = global_domain.
   run ip-assign
      (input-output perform-status).
   {&FAFAMT-P-TAG8}
   if recid(fa_mstr) = -1 then .

   if perform-status = "undo"
   then
      return.

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
   {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=l-delete-it
            &CONFIRM-TYPE='LOGICAL'}

   CASE l-delete-it:
      when yes
      then do:
         /* LOCKED-DELETE-EDIT */
         if fa_mstr.fa_post = yes
         then do:
            /* CANNOT DELETE - DEPRECIATION TAKEN FOR THIS ASSET */
            {pxmsg.i &MSGNUM=4226 &ERRORLEVEL=3}
            perform-status = "".
            return.
         end. /* if fa_post = yes */

         /* DELETE ASSOCIATED RECORDS */
         {gprun.i ""fadebl.p""
            "(input fa_id,
              input yes)"}

         if global-beam-me-up
         then
            undo, leave.
         /* LOCKED-DELETE-EDIT */

         hide message no-pause.
         /* STORE DELETED ASSET CODE TO ENSURE THAT POSTING */
         /* DATA IF STORED IN tt_pstast GETS CLEARED        */
         assign
            l_ast_del = fa_id
            l_astpost = no.

         {&FAFAMT-P-TAG9}
         delete fa_mstr.
         clear frame f-1 no-pause.
         get next q_fa_mstr
            no-lock.
         if available fa_mstr
         then
            assign
               perform-status = "first"
               l-rowid        = rowid(fa_mstr).
         else do:
            get prev q_fa_mstr
               no-lock.
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
      end. /* WHEN YES */
      otherwise
         run ip-displayedits.
   END CASE.
END PROCEDURE. /* ip-delete */

PROCEDURE ip-assign:

   define input-output parameter perform-status as character no-undo.

   do with frame f-1:
      assign
         fa_mstr.fa_id
         fa_mstr.fa_desc1
         fa_mstr.fa_faloc_id
         fa_mstr.fa_startdt
         fa_mstr.fa_puramt
         fa_mstr.fa_salvamt
         fa_mstr.fa_replamt
         fa_mstr.fa_mod_userid = global_userid
         fa_mstr.fa_mod_date   = today
         fa_mstr.fa_auth_number
         fa_mstr.fa_dep
         fa_mstr.fa_qty
         fa_mstr.fa_facls_id
         l-rowid               = rowid(fa_mstr).

      /* --------  /* AFTER-ASSIGN-AUDIT-INCLUDE */  ----------- */
      fa_entity = input frame f-1 fa_entity.
      if  (perform-status = "add"
        or perform-status = "update")
      then do:
         {gprun.i ""fadpblb.p""
            "(buffer fa_mstr,
              """",
              perform-status,
              0,
              0,
              """",
              output l-err-nbr)"}

         /* RETURNS YES IF POSTING BOOK IS ATTACHED TO THE CLASS */
         {gprunp.i "fapl" "p" "fa-get-post-class"
            "(input  input frame f-1 fa_facls_id,
              output l_astpost)"}

         if l_astpost
         then
            l_cost = fa_puramt.

         if global-beam-me-up
         then
            undo, leave.

         if l-err-nbr <> 0
         then do:
            {pxmsg.i &MSGNUM=l-err-nbr &ERRORLEVEL=3}
            perform-status = "undo".
         end. /* IF l-err-nbr <> 0 */
      end. /* IF perform-status = "add" or perform-status = "update" */

      if perform-status = "update"
         and (fa_puramt entered
                 or fa_salvamt entered)
      then do:

         if l_newbk = no
         then do:
            for first fab_det
               fields (fab_amt   fab_date   fab_fabk_id fab_famt_id fab_domain
                       fab_fa_id fab_ovramt fab_resrv   fab_salvamt)
               where fab_det.fab_domain = global_domain
               and   fab_fa_id          = fa_id
               and   can-find(first fabk_mstr
                                 where fabk_mstr.fabk_domain = global_domain
                                 and   fabk_id               = fab_fabk_id
                                 and   fabk_post             = yes)
               and   l_cost_captured    = no
            no-lock:
               assign
                  l_firstcost     = fab_amt
                  l_cost_captured = yes.
            end. /* FOR EACH fab_det */
         end.  /* IF l_newbk = no */

         for each fab_det
             where fab_det.fab_domain = global_domain and  fab_fa_id = fa_id
            exclusive-lock:
            assign
               fab_amt     = if fa_puramt entered
                             then fa_puramt
                             else fab_amt
               fab_salvamt = if fa_salvamt entered
                             then fa_salvamt
                             else fab_salvamt.
            if recid(fab_det) = -1 then .

            /* ADDED 1ST INPUT PARAMETER AS yes THIS WILL CHECK THAT THE     */
            /* NEXT CALENDAR IS DEFINED FOR AN ASSET PLACED IN A SHORT YEAR. */

            /* ADDED 5TH AND 6TH PARAMETERS AS THE YEAR FOR ADJUSTMENT */
            /* AND DEPRECIATION CALCULATION FOR FOLLOWING YEARS IS     */
            /* NEEDED OR NOT RESPECTIVELY. THESE PARAMETERS WILL BE    */
            /* zero AND no RESPECTIVELY EXCEPT FOR UTILITY utrgendp.p  */
            {gprun.i ""fadpbla.p""
               "(input  yes,
                 input  fab_det.fab_resrv,
                 buffer fa_mstr,
                 buffer fab_det,
                 input  0,
                 input  no,
                 output l-err-nbr)"}

            if l-err-nbr <> 0
            then do:
               {pxmsg.i &MSGNUM=l-err-nbr &ERRORLEVEL=3}
               perform-status = "undo".
               return.
            end. /* IF l-err-nbr <> 0 */
         end. /* FOR EACH fab_det */

         if fa_puramt entered
         then do:
            {gprun.i ""faadbl.p""
               "(buffer fa_mstr)"}

            p-status = "first-one".

            /* ADDED INPUT PARAMETER l_firstcost AND               */
            /* INPUT-OUPUT PARAMETERS l_newbk l_astpost AND l_cost */
/* SS - 100505.1 - B 
            {gprun.i ""fafamta.p""
               "(input        l_firstcost,
                 input-output p-status,
                 input-output l_newbk,
                 input-output l_astpost,
                 input-output l_cost,
                 buffer fa_mstr)"}
   SS - 100505.1 - E */
/* SS - 100505.1 - B */
            {gprun.i ""xxfafamta.p""
               "(input        l_firstcost,
                 input-output p-status,
                 input-output l_newbk,
                 input-output l_astpost,
                 input-output l_cost,
                 buffer fa_mstr)"}
/* SS - 100505.1 - E */

            /* RETURNS YES IF POSTING BOOK IS ATTACHED TO THE CLASS */
            {gprunp.i "fapl" "p" "fa-get-post-class"
               "(input  input frame f-1 fa_facls_id,
                 output l_astpost)"}
            if l_astpost
            then
               l_cost = fa_puramt - l_firstcost.

            p-status = "".
         end.  /* IF fab_amt ENTERED */
      end. /* IF perform-status = "update" .... */

      else
      if perform-status = "update"
         and fa_faloc_id entered
      then do:

         for each fabd_det
             where fabd_det.fabd_domain = global_domain and  fabd_fa_id = fa_id
            exclusive-lock:
            assign
               fabd_faloc_id = fa_faloc_id
               fabd_entity   = fa_entity.
         end. /* FOR EACH fabd_det */

      end. /* IF perform-status = "update" */
      /* ------  END AFTER-ASSIGN-AUDIT-INCLUDE  ----------- */
   end. /* DO WITH frame f-1 */
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
      end. /* DO: */

END PROCEDURE. /* ip-predisplay */

PROCEDURE ip-displayedits:

   if available fa_mstr
   then do:

      /* DISPLAY-EDITS */
      if l-reopen-fa-query = yes
      then do:

         /* RE-OPEN QUERY TO INCLUDE NEWLY CREATED ASSETS */
         perform-status = "open".
         run ip-query
            (input-output perform-status,
             input-output l-rowid).
      end. /* IF l-reopen-fa-query = yes */

      run ip-display.
      l-reopen-fa-query = no.

   end. /* IF AVAILABLE fa_mstr */

END PROCEDURE. /* ip-displayedits */

PROCEDURE ip-display:

   display
      fa_mstr.fa_id
      fa_mstr.fa_desc1
      fa_mstr.fa_faloc_id
      fa_mstr.fa_post
      fa_mstr.fa_startdt
      fa_mstr.fa_puramt
      fa_mstr.fa_salvamt
      fa_mstr.fa_disp_dt
      fa_mstr.fa_replamt
      fa_mstr.fa_disp_rsn
      fa_mstr.fa_dispamt
      fa_mstr.fa_entity
      fa_mstr.fa_auth_number
      fa_mstr.fa_dep
      fa_mstr.fa_qty
      fa_mstr.fa_facls_id
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

         reposition q_fa_mstr to rowid l-rowid
            no-error.

         get next q_fa_mstr
            no-lock.
      end.  /* IF l-rowid <> ?  */

      if not available fa_mstr
      then
         get first q_fa_mstr
            no-lock.

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
             where fa_mstr.fa_domain = global_domain and  fa_id >= ""
            use-index fa_id
            no-lock.

      reposition q_fa_mstr to rowid l-rowid
         no-error.
      get next q_fa_mstr
         no-lock.

      if available fa_mstr
      then
         assign
            perform-status = ""
            l-rowid        = rowid(fa_mstr).
      else do:
         get first q_fa_mstr
            no-lock.
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
   end. /* IF perform-status = "open"  */

   if perform-status = "next"
   then do:
      get next q_fa_mstr
         no-lock.
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
         get prev q_fa_mstr
            no-lock.
      end. /* ELSE DO */
   end. /* IF perform-status = "next" */

   if perform-status = "prev"
   then do:

      get prev q_fa_mstr
         no-lock.
      if available fa_mstr
      then do:
         assign
            l-rowid        = rowid(fa_mstr)
            perform-status = "first".
         hide message no-pause.
         run ip-displayedits.

      end. /* IF AVAILABLE fa_mstr .... */
      else do:

         perform-status = "".
         /* BEGINNING OF FILE */
         {pxmsg.i &MSGNUM=21 &ERRORLEVEL=2}
         get next q_fa_mstr
            no-lock.
      end. /* ELSE DO */

   end. /* IF perform-status = "prev" */

   if perform-status = "update"
      or perform-status = "delete"
   then do:

      get current q_fa_mstr
         no-lock.
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
      assign
         current-window:bgcolor  = 8
         frame f-1:box           = true
         frame f-1:row           = 3
         frame f-1:centered      = true
         frame f-1:overlay       = true
         frame f-button:centered = true
         frame f-button:row      = 20.
   else
      assign
         frame f-1:row           = 2
         frame f-1:box           = true
         frame f-1:centered      = true
         frame f-button:centered = true
         frame f-button:row      = 20.

   assign
      frame a:centered = true
      frame a:row      = 10
      frame a:overlay  = true.

END PROCEDURE. /* ip-framesetup */

PROCEDURE ip-button:

   define input-output parameter perform-status as character
                                                format "x(25)" no-undo.

   if not batchrun
   then do:

      enable all with frame f-button.
      ststatus = stline[2].
      status input ststatus.
      on choose of b-update
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle.
         hide frame f-button no-pause.
      end. /* ON CHOOSE OF b-update */

      on choose of b-add
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle.
         hide frame f-button no-pause.
      end. /* ON CHOOSE OF b-add */

      on choose of b-delete
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle.
         hide frame f-button no-pause.
      end. /* ON CHOOSE OF b-delete */

      on choose of b-option
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle
            l-title        = current-window:title
                             + " - "
                             + self:label.
         hide frame f-button no-pause.
      end. /* ON CHOOSE OF b-option */

      on choose of b-books
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle
            l-title        = current-window:title
                             + " - "
                             + self:label.
         hide frame f-button no-pause.
      end. /* ON CHOOSE OF b-books */

      on choose of b-detail
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle
            l-title        = current-window:title
                             + " - "
                             + self:label.
         hide frame f-button no-pause.
      end. /* ON CHOOSE OF b-detail */

      on choose of b-find
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle
            l-title        = current-window:title
                             + " - "
                             + self:label.
         hide frame f-button no-pause.
      end. /* ON CHOOSE OF b-find */

      on choose of b-end
      do:
         assign
            perform-status = self:private-data
            l-focus        = self:handle.
         hide frame f-1 no-pause.
         hide frame f-button no-pause.
      end. /* ON CHOOSE OF b-end */
      {&FAFAMT-P-TAG10}

      on cursor-up, f9 anywhere
      do:
         assign
            perform-status = "prev"
            l-focus        = focus:handle.
         apply "go" to frame f-button.
      end. /* ON CURSOR-UP, F9 ANYWHERE */

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
         if (lastkey    = keycode("cursor-down")
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
            b-update,
            b-add,
            b-delete,
            b-option,
            b-books,
            b-detail,
            b-find,
            b-end
            {&FAFAMT-P-TAG11}
            focus
            l-focus.
      hide message no-pause.

   end. /* IF NOT BATCHRUN */
   else
      set perform-status.

END PROCEDURE. /* ip-button */

PROCEDURE valid-entity:

   define input  parameter p_faloc_entity like faloc_entity no-undo.
   define output parameter p_error        like mfc_logical  no-undo.

   /* CHECK ENTITY SECURITY */
   {glenchk.i &entity=p_faloc_entity &entity_ok=valid_entity}

   /* IF LOCATION HAS ENTITY SECURITY THEN SET p_error TO YES */
   if not valid_entity
   then
      p_error = yes.
   else
      p_error = no.

END PROCEDURE. /* valid-entity */

/* STORE DATA FOR POSTING OF ACQUISITION COST AND ADJUSTMENTS */
PROCEDURE ip_posttogl:

   define variable l_entity_ok    like mfc_logical no-undo.
   define variable l_suspend      like mfc_logical no-undo.
   define variable l_uop          like mfc_logical no-undo.
   define variable l_post_yrper   like fabd_yrper  no-undo.
   define variable l_daybook_desc like dy_desc     no-undo.
   define variable l_error        as   integer     no-undo.

   if not available fa_mstr
   then
      return.

   /* NO POSTING BOOK SET UP */
   if l_post_bk = ""
   then
      return.

   /* ACCOUNT FOR DELETION OF MODIFIED ASSET */
   find first tt_pstast
      where tt_asset = l_ast_del
      exclusive-lock no-error.
   if available tt_pstast
   then do:
      delete tt_pstast.

      l_ast_del = "".
      return.
   end. /* IF AVAILABLE tt_pstast */

   for first fab_det
      fields( fab_domain fab_fa_id fab_fabk_id fab_ovramt fab_famt_id fab_date)
       where fab_det.fab_domain = global_domain and  fab_fa_id   = fa_id
      and   fab_fabk_id = l_post_bk
      no-lock:
   end. /* FOR FIRST fab_det */

   /* ACCOUNT FOR DELETION OF MODIFIED POSTING BOOK */
   if not available fab_det
      and fa_dep
   then do:
      find first tt_pstast
         where tt_asset = fa_id
         exclusive-lock no-error.
      if available tt_pstast
      then
         delete tt_pstast.

      return.

   end. /* IF NOT AVAILABLE fab_det */

   else do:
      /* DO NOT CONSIDER UNPOSTED ASSETS HAVING NON-ZERO */
      /* OVERRIDE ACCUMULATED DEPRECIATION AMOUNT        */
      if available fab_det
      then do:
         if not fa_post
            and fab_ovramt <> 0
         then
            return.
      end. /* IF AVAILABLE fab_det */

      if l_astpost
         and l_cost <> 0
      then do:

         for first fabd_det
            fields( fabd_domain fabd_entity fabd_fabk_id fabd_facls_id
                   fabd_faloc_id fabd_fa_id fabd_post fabd_retired
                   fabd_rt_period fabd_suspend fabd_yrper)
             where fabd_det.fabd_domain = global_domain and (  fabd_entity  =
             fa_entity
            and   fabd_fa_id   = fa_id
            and   fabd_fabk_id = l_post_bk
            and   fabd_post    = no
            and   fabd_suspend = no
            and  (fabd_retired = no
                  or fabd_rt_period = yes)
            ) 
            use-index fabd_fa_id            
            no-lock:
         end. /* FOR FIRST fabd_det */

         if available fabd_det
         then
            assign
               l_uop        = no
               l_post_yrper = fabd_yrper.

         else do:

            if fa_dep
            then do:
               /* ACQUISITION LOGIC FOR UN-POSTED UOP TYPE OF ASSETS */
               if can-find(first famt_mstr
                            where famt_mstr.famt_domain = global_domain and
                            famt_id   = fab_famt_id
                           and   famt_type = "2")
               then do:
                  l_uop = yes.
                  {gprunp.i "fapl" "p" "fa-get-per"
                     "(input  fab_date,
                       input  '',
                       output l_post_yrper,
                       output l_error)"}
                  if l_error <> 0
                  then
                     return.
               end. /* IF CAN-FIND(FIRST famt_mstr */
            end. /* IF fa_dep */
            /* ACQUISITION LOGIC FOR NON-DEPRECIATING ASSETS */
            else do:

               l_uop = no.
               {gprunp.i "fapl" "p" "fa-get-per"
                  "(input  fa_startdt,
                    input  '',
                    output l_post_yrper,
                    output l_error)"}

               if l_error <> 0
               then
                  return.

            end. /* ELSE DO */

         end. /* ELSE DO */

         {gprunp.i "fapl" "p" "fa-get-suspend"
            "(input  fa_id,
              input  l_post_bk,
              input  l_post_yrper,
              output l_suspend)"}

         if l_suspend
         then
            return.

         /* DEFAULT FA DAYBOOK; DOC TYPE AND TRANSACTION TYPE - "FA"*/
         {gprun.i ""gldydft.p""
            "(input  ""FA"",
              input  ""FA"",
              input  fa_entity,
              output dft-daybook,
              output l_daybook_desc)"}

         find first tt_pstast
            where tt_asset = fa_id
            exclusive-lock no-error.
         if available tt_pstast
         then do:

            /* IF THE MODIFICATION TO ASSET COST IS UNDONE */
            /* DELETE THE STORED POSTING DATA in tt_pstast */
            if tt_cost + l_cost = 0
            then do:
               assign
                  l_cost    = 0
                  l_astpost = no.
               delete tt_pstast.
               return.
            end. /* IF tt_cost + l_cost = 0 */
            else
               assign
                  l_postgl    = yes
                  l_effdate   = tt_effdt
                  dft-daybook = tt_daybk.
         end. /* IF AVAILABLE tt_pstast */
         else
            assign
               l_postgl  = no
               l_effdate = today.

         postloop:
         repeat on error undo, retry:

         if fa_dep
         then do:

            display
               l_postgl
            with frame a.

            prompt-for
               l_postgl
            with frame a.

            l_postgl = input l_postgl.

            if not l_postgl
            then do:
               if available tt_pstast
               then
                  delete tt_pstast.

               assign
                  l_cost    = 0
                  l_astpost = no.

               hide frame a.
               leave postloop.
            end. /* IF NOT l_postgl */

            postloop1:
            do on error undo, retry:

               /* ACCEPT BELOW FIELDS ONLY IF USER WANTS TO POST */
               /* THE ASSETS TO GL                               */
               display
                  l_effdate
                  dft-daybook when (daybooks-in-use)
               with frame a.

               prompt-for
                  l_effdate
                  dft-daybook when (daybooks-in-use)
               with frame a.

                 assign
                  l_effdate   = input l_effdate
                  dft-daybook = input dft-daybook.

               /* VALIDATION FOR l_effdate */
               if l_effdate = ?
               then do:
                  /* DATE REQUIRED */
                  {pxmsg.i &MSGNUM=711 &ERRORLEVEL=3}

                  if not batchrun
                  then do:
                     next-prompt
                        l_effdate
                     with frame a.
                     undo postloop1, retry postloop1.
                  end. /* IF NOT batchrun */
                  else
                     return.
               end. /* IF l_effdate = ? */
               else do:
                  /* VALIDATE EFFECTIVE DATE AGAINST GL CALENDAR */
                  for first en_mstr
                      where en_mstr.en_domain = global_domain and  en_entity =
                      fa_entity
                     no-lock:

                     {gprun.i ""gpglef1.p""
                        "(input ""FA"",
                          input en_entity,
                          input l_effdate,
                          output gpglef_result,
                          output gpglef_msg_nbr)"}

                     if gpglef_result > 0
                     then do:
                        /* INVALID/CLOSED PERIOD */
                        {pxmsg.i &MSGNUM=gpglef_msg_nbr &ERRORLEVEL=3
                           &MSGARG1="en_entity"}

                        if not batchrun
                        then do:
                           next-prompt
                              l_effdate
                           with frame a.
                           undo postloop1, retry postloop1.
                        end. /* IF NOT batchrun */
                        else
                           return.
                     end. /* IF gpglef_result > 0 */
                  end. /* FOR FIRST en_mstr */
               end. /* ELSE DO */
               /* END VALIDATION FOR l-effdate */

               /* VALIDATION FOR dft-daybook */
               if daybooks-in-use
               then do:
                  if not can-find(first dy_mstr
                                   where dy_mstr.dy_domain = global_domain and
                                   dy_dy_code = dft-daybook)
                  then do:
                     /* INVALID DAYBOOK */
                     {pxmsg.i &MSGNUM=1299 &ERRORLEVEL=3}

                     if not batchrun
                     then do:
                        next-prompt
                           dft-daybook
                        with frame a.
                        undo postloop1, retry postloop1.
                     end. /* IF NOT batchrun */
                     else
                        return.
                  end. /* IF NOT CAN-FIND ... */
                  else do:
                     /* VERIFY DAYBOOK */
                     {gprun.i ""gldyver.p""
                        "(input ""FA"",
                          input ""FA"",
                          input dft-daybook,
                          input fa_entity,
                          output daybook-error)"}

                     if daybook-error
                     then do:
                        /* DAYBOOK DOES NOT MATCH ANY DEFAULT */
                        {pxmsg.i &MSGNUM=1674 &ERRORLEVEL=2}
                     end. /* IF daybook-error */

                     {gprunp.i "nrm" "p" "nr_can_dispense"
                        "(input dft-daybook,
                          input l_effdate)"}

                     {gprunp.i "nrm" "p" "nr_check_error"
                        "(output daybook-error,
                          output return_int)"}

                     if daybook-error
                     then do:
                        {pxmsg.i &MSGNUM=return_int &ERRORLEVEL=3}

                        if not batchrun
                        then do:
                           next-prompt
                              dft-daybook
                           with frame a.
                           undo postloop1, retry postloop1.
                        end. /* IF NOT batchrun */
                        else
                           return.
                     end. /* IF daybook-error */
                  end. /* ELSE DO */
               end. /* IF daybooks-in-use */
            end. /* DO ON ERROR UNDO, RETRY */

            if not available tt_pstast
            then do:
               create tt_pstast.
               tt_asset = fa_id.
            end. /* IF NOT AVAILABLE tt_pstast */

            assign
               tt_daybk    = dft-daybook
               tt_effdt    = l_effdate
               tt_cost     = tt_cost + l_cost
               tt_entity   = fa_entity
               tt_pstyrper = l_post_yrper
               tt_uop      = l_uop
               l_astpost   = no
               l_cost      = 0.

         end. /* IF fa_dep */

            hide frame a.
            leave postloop.
         end. /* postloop */

      end. /* IF l_astpost */

   end. /* ELSE DO */

END PROCEDURE. /* ip_posttogl */
