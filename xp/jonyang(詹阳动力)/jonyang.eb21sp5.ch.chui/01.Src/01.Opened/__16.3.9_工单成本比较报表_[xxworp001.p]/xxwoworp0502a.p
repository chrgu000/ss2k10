/* woworp5a.p - WORK ORDER COST REPORT                                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.22 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 6.0     LAST MODIFIED: 05/01/91    BY: ram *D611*                */
/* REVISION: 7.0     LAST MODIFIED: 10/23/91    BY: pma *F003*                */
/* REVISION: 7.0     LAST MODIFIED: 03/02/92    BY: pma *F085*                */
/* REVISION: 7.0     LAST MODIFIED: 06/17/92    BY: pma *F664*                */
/* REVISION: 7.3     LAST MODIFIED: 04/23/93    BY: ram *GA24*                */
/* REVISION: 7.3     LAST MODIFIED: 04/28/93    BY: pma *GA47*                */
/* REVISION: 7.2     LAST MODIFIED: 04/12/94    BY: pma *FN34*                */
/* REVISION: 7.3     LAST MODIFIED: 09/23/94    BY: cpp *FQ88*                */
/* REVISION: 7.5     LAST MODIFIED: 10/19/94    BY: TAF *J035*                */
/* REVISION: 7.3     LAST MODIFIED: 12/07/94    BY: pxd *FU43*                */
/* REVISION: 7.5     LAST MODIFIED: 02/27/94    BY: tjs *J027*                */
/* REVISION: 8.5     LAST MODIFIED: 03/29/95    BY: dzn *F0PN*                */
/* REVISION: 8.5     LAST MODIFIED: 10/25/95    BY: sxb *J053*                */
/* REVISION: 8.5     LAST MODIFIED: 02/04/97    BY: *J1GW* Julie Milligan     */
/* REVISION: 8.5     LAST MODIFIED: 08/11/97    BY: *J1WK* Molly Balan        */
/* REVISION: 8.6     LAST MODIFIED: 10/14/97    BY: *K0XV* A. Swaminathan     */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan         */
/* REVISION: 9.0     LAST MODIFIED: 01/21/99    BY: *M066* Patti Gaultney     */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 11/23/99    BY: *J3MM* Jyoti Thatte       */
/* REVISION: 9.1     LAST MODIFIED: 03/06/00    BY: *N05Q* Vincent Koh        */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 07/29/00    BY: *N0GV* Mudit Mehta        */
/* Revision: 1.17    BY: Katie Hilbert          DATE: 04/01/01 ECO: *P008*    */
/* Revision: 1.20  BY: Vivek Gogte DATE: 04/30/01 ECO: *P001* */
/* $Revision: 1.22 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N* */
/* $Revision: 1.22 $ BY: Bill Jiang DATE: 07/19/08 ECO: *SS - 20080719.1* */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/**************************************************************/
/*   MOST OF THE ROUNDING FUNCTIONS IN THIS PROGRAM HAVE BEEN */
/*   REMOVED BECAUSE THE VALUES ARE DERIVED FROM AMOUNTS THAT */
/*   HAVE BEEN ROUNDED ELSEWHERE IN MFG/PRO.                  */
/*   WHERE WE DID NEED TO ROUND, WE ROUNDED BASED ON THE      */
/*   DECIMAL PRECISION OF THE BASE CURRENCY.                  */
/**************************************************************/

/* SS - 20080719.1 - B */
{xxwoworp0502.i}

define input parameter acct_close like wo_acct_close.
define input parameter CLOSE_date   like wo_close_date.
define input parameter close_date1  like wo_close_date.
define input parameter CLOSE_eff   like wo_close_eff.
define input parameter close_eff1  like wo_close_eff.
/* SS - 20080719.1 - E */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{wbrp02.i}

define shared variable nbr    like wo_nbr.
define shared variable nbr1   like wo_nbr.
define shared variable lot    like wo_lot.
define shared variable lot1   like wo_lot.
define shared variable site   like wo_site no-undo.
define shared variable site1  like wo_site no-undo.
define shared variable part   like wo_part.
define shared variable part1  like wo_part.
define shared variable due    like wo_due_date.
define shared variable due1   like wo_due_date.
define shared variable vend   like wo_vend.
define shared variable so_job like wo_so_job.
define shared variable stat   like wo_status.
define shared variable mtlyn  like mfc_logical initial yes
   label "Material"           format "Detail/Summary".
define shared variable lbryn  like mfc_logical initial yes
   label "Labor"              format "Detail/Summary".
define shared variable bdnyn  like mfc_logical initial yes
   label "Burden"             format "Detail/Summary".
define shared variable subyn  like mfc_logical initial yes
   label "Subcontract"        format "Detail/Summary".
define shared variable skpage like mfc_logical initial yes
   label "Page Break on Work Order".

define variable desc1    like pt_desc1.
define variable acctot   like wod_tot_std.
define variable exptot   like wod_tot_std.
define variable rtetot   like wod_mvrte_post.
define variable usetot   like wod_mvuse_post.
define variable acrtot   like wod_mvuse_accr.
define variable wiptot   like wo_wip_tot.
define variable accqty   like wod_qty_iss
   column-label "Accumulated!Quantity".
define variable acccst   like wod_mvrte_post no-undo
   column-label "Accumulated!Cost".
define variable expcst   like wod_mvrte_post no-undo
   column-label "Expected !Cost   !(Ref Only)".
define variable rtevar   like wod_mvrte_post
   column-label "Rate  !Variance!Posted ".
define variable usevar   like wod_mvuse_post
   column-label "Usage  !Variance!Posted ".
define variable acrvar   like wod_mvuse_accr
   column-label "Accrued!Variance!(Ref Only)".
define variable wipamt   like wod_mvrte_post
   column-label "Balance".
define variable premsg   as character.
define variable item     like wod_part format "x(20)".
define variable i        as integer.
define variable glx_mthd like cs_method.
define variable glx_set  like cs_set.
define variable cur_mthd like cs_method.
define variable cur_set  like cs_set.
define variable wowipx   like wod_mvrte_post no-undo
   column-label "Avg Cost!Received to!Finished Goods".
define variable wototx   like wod_tot_std.
define variable firstwo  like mfc_logical.
define variable display_det like mfc_logical.
define variable tmp_fmt  as   character no-undo.

define buffer wo_mstr1 for wo_mstr.

define variable status-type as character no-undo.
define variable status-label as character no-undo.

form
   wo_nbr         colon 15
   wo_lot         colon 45
   wo_batch       colon 71
   wo_rmks        colon 71
   wo_part        colon 15
   wo_so_job      colon 45
   wo_qty_ord     colon 71
   wo_ord_date    colon 104
   glx_mthd       no-label
   desc1          at 17 no-label
   wo_qty_comp    colon 71
   wo_rel_date    colon 104
   premsg         no-label
   wo_status      colon 15
   wo_vend        colon 45
   wo_qty_rjct    colon 71
   wo_due_date    colon 104
with frame b side-labels width 132 no-attr-space.

/* SS - 20080719.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).
*/
/* SS - 20080719.1 - E */

form
   item
   accqty
   expcst
   acrvar
   acccst
   rtevar
   usevar
   wowipx
   wipamt
with frame c width 132 down no-attr-space.

/* SS - 20080719.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).
*/
/* SS - 20080719.1 - E */

firstwo = yes.
find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

/* FORMAT RETURNED BY gpcurfmt.p IS STORED IN tmp_fmt AND IS   */
/* USED AS THE DISPLAY FORMAT FOR EVERY AMOUNT COLUMN VARIABLE.*/
/* THE FORMAT FOR THESE VARIABLES IS RE-INITIALIZED AFTER EVERY*/
/* UNDERLINE STATEMENT AS THE DISPLAY FORMAT GETS CHANGED.     */

tmp_fmt = expcst:format.
{gprun.i ""gpcurfmt.p"" "(input-output tmp_fmt,
                          input gl_rnd_mthd)"}

/* FIND AND DISPLAY */
for each wo_mstr
       where wo_mstr.wo_domain = global_domain and (  (wo_nbr >= nbr) and
       (wo_nbr <= nbr1)
      and (wo_lot >= lot) and (wo_lot <= lot1 )
      and (wo_part >= part) and (wo_part <= part1 or part1 = "" )
      and (wo_site >= site) and (wo_site <= site1)
      and (wo_due_date >= due or due = ?)
      and (wo_due_date <= due1 or due1 = ?)
      and (wo_vend = vend or vend = "" )
      and (wo_so_job = so_job or so_job = "" )
      and (wo_status = stat or stat = "")
      and (wo_joint_type = "" or wo_joint_type = "5")
      ) 
   /* SS - 20080719.1 - B */
   AND (wo_acct_close = acct_close OR acct_close = NO)
   and (wo_close_date >= CLOSE_date or CLOSE_date = ?)
   and (wo_close_date <= close_date1 or close_date1 = ?)
   and (wo_close_eff >= CLOSE_eff or CLOSE_eff = ?)
   and (wo_close_eff <= close_eff1 or close_eff1 = ?)
   /* SS - 20080719.1 - E */
   no-lock break by wo_nbr by wo_lot with frame c width 132
      no-attr-space:

   find pt_mstr no-lock
       where pt_mstr.pt_domain = global_domain and  pt_part = wo_part no-error.

   find ptp_det no-lock
       where ptp_det.ptp_domain = global_domain and  ptp_part = wo_part
      and ptp_site = wo_site no-error.

   /* PLANNED ORDERS(wo_status = P)PRINT ONLY IF pm_code = M,SPACE OR L */
   if wo_status = "P"
      and ((available ptp_det and
      ptp_pm_code <> "M" and ptp_pm_code <> "" and ptp_pm_code <> "L")
      or (not available ptp_det and available pt_mstr and
      pt_pm_code <> "M" and pt_pm_code <> "" and pt_pm_code <> "L"))
      then next.

   assign
      acctot = 0
      exptot = 0
      rtetot = 0
      usetot = 0
      wiptot = 0
      acrtot = 0
      wototx = 0

      display_det = yes.

   /* DETERMINE THE COST SET METHOD FOR MEMO ITEMS */
   if wo_fsm_type = "FSM-RO"
      or wo_fsm_type = "PRM"
   then do:
      if not available pt_mstr then do:
         find si_mstr  where si_mstr.si_domain = global_domain and  si_site =
         wo_site no-lock no-error.
         if available si_mstr then do:
            if si_gl_set > "" then
               find cs_mstr  where cs_mstr.cs_domain = global_domain and
               cs_set = si_gl_set no-lock no-error.
            else do:
               find first icc_ctrl  where icc_ctrl.icc_domain = global_domain
               no-lock no-error.
               if available icc_ctrl then
                  find cs_mstr  where cs_mstr.cs_domain = global_domain and
                  cs_set = icc_gl_set no-lock no-error.
            end. /* ELSE DO */
            if available cs_mstr then glx_mthd = cs_method.
         end. /* IF AVAILABLE si_mstr */
      end. /* IF NOT AVAILABLE pt_mstr */
   end. /* IF wo_fsm_type = "FSM-RO" */

   /* DETERMINE COSTING METHOD                             */
   /* COST METHOD IS BEING DETERMINED EARLIER FOR "FSM-RO" */
   /* csavg01.p NEED NOT BE EXECUTED FOR CAR-RELATED WO'S. */
   if wo_fsm_type <> "FSM-RO"
      and wo_fsm_type <> "PRM"
      or available pt_mstr
   then do:
      {gprun.i ""csavg01.p"" "(input wo_part,
                               input wo_site,
                               output glx_set,
                               output glx_mthd,
                               output cur_set,
                               output cur_mthd)"
      }
   end. /* IF wo_fsm_type <> "FSM-RO" */

   if glx_mthd = "AVG"
      and (wo_qty_ord < 0 or wo_rjct_tot <> 0 or wo_mthd_var <> 0)
   then display_det = no.

   /* SS - 20080719.1 - B */
   /*
   if not firstwo and skpage then page.
   if not firstwo and not skpage then
      display fill("=",130) format "x(130)"
      with frame d width 132 no-attr-space.
   */
   /* SS - 20080719.1 - E */

   assign
      firstwo = no
      desc1 = "".

   if available pt_mstr then desc1 = pt_desc1.

   premsg = "".
   if substring(wo_rev,3,1) = "#" then premsg = "PRE-7.0".

   /* CONVERT wo_status INTO ITS ALPHA MNEMONIC FOR CAR WO'S      */
   if wo_fsm_type = "FSM-RO"
      or wo_fsm_type = "PRM"
   then do:
      {gplngn2a.i
         &file       =  ""wo_mstr""
         &field      =  ""wo_status""
         &code       =    wo_status
         &mnemonic   =    status-type
         &label      =    status-label}
   end. /* IF wo_fsm_type <> "FSM-RO" */

   /* SS - 20080719.1 - B */
   /*
   display
      wo_nbr
      wo_lot
      wo_batch
      wo_qty_ord
      wo_ord_date
      glx_mthd
      wo_part
      desc1
      wo_qty_comp
      wo_rel_date
      premsg
      wo_so_job
      wo_qty_rjct
      wo_due_date
      wo_vend
      if wo_fsm_type = "FSM-RO"
      or wo_fsm_type = "PRM"
      then status-type
      else wo_status @ wo_status
      wo_rmks
   with frame b side-labels.

   assign
      expcst:format = tmp_fmt
      acrvar:format = tmp_fmt
      acccst:format = tmp_fmt
      rtevar:format = tmp_fmt
      usevar:format = tmp_fmt
      wowipx:format = tmp_fmt
      wipamt:format = tmp_fmt.
   */
   CREATE ttsswoworp0502.
   ASSIGN
      ttsswoworp0502_wo_nbr = wo_nbr
      ttsswoworp0502_wo_lot = wo_lot
      ttsswoworp0502_wo_batch = wo_batch

      ttsswoworp0502_wo_rmks = wo_rmks

      ttsswoworp0502_wo_part = wo_part
      ttsswoworp0502_wo_so_job = wo_so_job
      ttsswoworp0502_wo_qty_ord = wo_qty_ord
      ttsswoworp0502_wo_ord_date = wo_ord_date
      ttsswoworp0502_glx_mthd = glx_mthd

      ttsswoworp0502_desc1 = desc1
      ttsswoworp0502_wo_qty_comp = wo_qty_comp
      ttsswoworp0502_wo_rel_date = wo_rel_date
      ttsswoworp0502_premsg = premsg

      ttsswoworp0502_wo_status = wo_status
      ttsswoworp0502_wo_vend = wo_vend
      ttsswoworp0502_wo_qty_rjct = wo_qty_rjct
      ttsswoworp0502_wo_due_date = wo_due_date
      .
   if wo_fsm_type = "FSM-RO"
   or wo_fsm_type = "PRM"
   then DO:
      ASSIGN 
         ttsswoworp0502_wo_status = status-type
         .
   END.
   /* SS - 20080719.1 - E */

   for each wod_det  where wod_det.wod_domain = global_domain and  wod_lot =
   wo_lot no-lock break by wod_lot
         by wod_part with frame c:
      assign
         accqty = wod_qty_iss
         acccst = wod_tot_std.
      if glx_mthd = "AVG"
      then do:
         if display_det
         then wowipx = wod_mtl_totx.
         else wowipx = 0.
         assign
            wipamt = wod_tot_std - wowipx
            expcst = 0
            rtevar = 0
            usevar = 0
            acrvar = 0.
      end.
      else do:
         expcst = ((wo_qty_comp + wo_qty_rjct)
                   * wod_bom_qty * wod_bom_amt)
                   - wod_mvrte_rval.
         /* ROUND expcst TO BASE CURRENCY PRECISION */
         {gprun.i ""gpcurrnd.p"" "(input-output expcst,
                                   input gl_rnd_mthd)"}
         assign
            rtevar = wod_mvrte_post
            usevar = wod_mvuse_post
            wipamt = acccst - (rtevar + usevar)
            acrvar = (wod_mvrte_accr + wod_mvuse_accr)
            wowipx = 0.
      end.

      accumulate acccst (total by wod_lot).
      accumulate expcst (total by wod_lot).
      accumulate rtevar (total by wod_lot).
      accumulate usevar (total by wod_lot).
      accumulate wipamt (total by wod_lot).
      accumulate acrvar (total by wod_lot).
      accumulate wowipx (total by wod_lot).

      /* SS - 20080719.1 - B */
      /*
      if page-size - line-counter < 4 then page.

      if mtlyn then do with frame c:
         display
            "  " + wod_part @ item
            accqty
            expcst
            acrvar
            acccst
            rtevar
            usevar
            wowipx
            wipamt.
         down 1.
      end.

      if last(wod_lot) then do with frame c:
         if mtlyn then
         do:
            underline
               expcst
               acrvar
               acccst
               rtevar
               usevar
               wowipx
               wipamt.

            /* RE-INITIALIZE FORMAT */
            assign
               expcst:format = tmp_fmt
               acrvar:format = tmp_fmt
               acccst:format = tmp_fmt
               rtevar:format = tmp_fmt
               usevar:format = tmp_fmt
               wowipx:format = tmp_fmt
               wipamt:format = tmp_fmt.
         end.

         display
            getTermLabel("MATERIAL_TOTAL",19) + ":" @ item
            accum total by wod_lot expcst @ expcst
            accum total by wod_lot acccst @ acccst
            accum total by wod_lot acrvar @ acrvar
            accum total by wod_lot rtevar @ rtevar
            accum total by wod_lot usevar @ usevar
            accum total by wod_lot wowipx @ wowipx
            accum total by wod_lot wipamt @ wipamt.
         down 2.

         assign
            exptot = exptot + accum total by wod_lot expcst
            acctot = acctot + accum total by wod_lot acccst
            acrtot = acrtot + accum total by wod_lot acrvar
            rtetot = rtetot + accum total by wod_lot rtevar
            usetot = usetot + accum total by wod_lot usevar
            wototx = wototx + accum total by wod_lot wowipx
            wiptot = wiptot + accum total wipamt.
      end.
      */
      if last(wod_lot) then do with frame c:
         ASSIGN
            ttsswoworp0502_mtl_expcst = (accum total by wod_lot expcst)
            ttsswoworp0502_mtl_acrvar = (accum total by wod_lot acrvar)
            ttsswoworp0502_mtl_acccst = (accum total by wod_lot acccst)
            ttsswoworp0502_mtl_rtevar = (accum total by wod_lot rtevar)
            ttsswoworp0502_mtl_usevar = (accum total by wod_lot usevar)
            ttsswoworp0502_mtl_wowipx = (accum total by wod_lot wowipx)
            ttsswoworp0502_mtl_wipamt = (accum total by wod_lot wipamt)
            .

         assign
            exptot = exptot + accum total by wod_lot expcst
            acctot = acctot + accum total by wod_lot acccst
            acrtot = acrtot + accum total by wod_lot acrvar
            rtetot = rtetot + accum total by wod_lot rtevar
            usetot = usetot + accum total by wod_lot usevar
            wototx = wototx + accum total by wod_lot wowipx
            wiptot = wiptot + accum total wipamt.
      end.
      /* SS - 20080719.1 - E */

      {mfrpchk.i &warn=no}
   end.  /*for each wod_det*/

   do i = 1 to 3:
      for each wr_route  where wr_route.wr_domain = global_domain and  wr_lot =
      wo_lot no-lock
            break by wr_lot by wr_op with frame c:

         /* LABOR */
         if i = 1 then do:
            assign
               accqty = wr_qty_comp + wr_qty_rjct
               acccst = wr_lbr_act.
            if glx_mthd = "AVG" then do:
               if display_det
               then wowipx = wr_lbr_totx.
               else wowipx = 0.
               assign
                  wipamt = wr_lbr_act - wowipx
                  expcst = 0
                  rtevar = 0
                  usevar = 0
                  acrvar = 0.
            end.
            else
               assign
                  expcst = wr_lbr_std
                  rtevar = wr_lvrte_post
                  usevar = wr_lvuse_post
                  wipamt = acccst - (rtevar + usevar)
                  acrvar = wr_lvrte_accr + wr_lvuse_accr
                  wowipx = 0.
         end.

         /* BURDEN */
         if i = 2 then do:
            assign
               accqty = wr_qty_comp + wr_qty_rjct
               acccst = wr_bdn_act.
            if glx_mthd = "AVG" then do:
               if display_det
               then wowipx = wr_bdn_totx.
               else wowipx = 0.
               assign
                  wipamt = wr_bdn_act - wowipx
                  expcst = 0
                  rtevar = 0
                  usevar = 0
                  acrvar = 0.

            end.
            else
               assign
                  expcst = wr_bdn_std
                  rtevar = wr_bvrte_post
                  usevar = wr_bvuse_post
                  wipamt = acccst - (rtevar + usevar)
                  acrvar = wr_bvrte_accr + wr_bvuse_accr
                  wowipx = 0.
         end.

         /* SUBCONTRACT */
         if i = 3 then do:
            assign
               accqty = wr_sub_comp
               acccst = wr_sub_act.
            if glx_mthd = "AVG" then do:
               if display_det
               then wowipx = wr_sub_totx.
               else wowipx = 0.
               assign
                  wipamt = wr_sub_act - wowipx
                  expcst = 0
                  rtevar = 0
                  usevar = 0
                  acrvar = 0.
            end.
            else
               assign
                  expcst = wr_sub_std
                  rtevar = wr_svrte_post
                  usevar = wr_svuse_post
                  wipamt = acccst - (rtevar + usevar)
                  acrvar = wr_svrte_accr + wr_svuse_accr
                  wowipx = 0.
         end.

         accumulate acccst (total by wr_lot).
         accumulate expcst (total by wr_lot).
         accumulate rtevar (total by wr_lot).
         accumulate usevar (total by wr_lot).
         accumulate wipamt (total by wr_lot).
         accumulate acrvar (total by wr_lot).
         accumulate wowipx (total by wr_lot).

         /* SS - 20080719.1 - B */
         /*
         if page-size - line-counter < 4 then page.

         if (i = 1 and lbryn) or (i = 2 and bdnyn) or
            (i = 3 and subyn) then do with frame c:

            display
               getTermLabelRt("OPERATION",12) + ": " +
               string(wr_op,">>>>>9") @ item
               accqty
               expcst
               acrvar
               acccst
               rtevar
               usevar
               wowipx
               wipamt.
            down 1.
         end.
         */
         /* SS - 20080719.1 - E */

         if last(wr_lot) then do with frame c:
            /* SS - 20080719.1 - B */
            /*
            if (i = 1 and lbryn) or (i = 2 and bdnyn)
               or (i = 3 and subyn) then
            do:
               underline
                  expcst
                  acrvar
                  acccst
                  rtevar
                  usevar
                  wowipx
                  wipamt.

               /* RE-INITIALIZE FORMAT */
               assign
                  expcst:format = tmp_fmt
                  acrvar:format = tmp_fmt
                  acccst:format = tmp_fmt
                  rtevar:format = tmp_fmt
                  usevar:format = tmp_fmt
                  wowipx:format = tmp_fmt
                  wipamt:format = tmp_fmt.
            end.

            if i = 1 then
               display getTermLabel("LABOR_TOTAL",19) + ":"
               @ item.
            else
            if i = 2 then
               display getTermLabel("BURDEN_TOTAL",19)
               + ":" @ item.
            else
            if i = 3 then
               display
               getTermLabel("SUBCONTRACT_TOTAL",19) + ":" @ item.

            display
               accum total by wr_lot expcst @ expcst
               accum total by wr_lot acccst @ acccst
               accum total by wr_lot acrvar @ acrvar
               accum total by wr_lot rtevar @ rtevar
               accum total by wr_lot usevar @ usevar
               accum total by wr_lot wowipx @ wowipx
               accum total by wr_lot wipamt @ wipamt.
            down 2.
            */
            if i = 1 THEN DO:
               ASSIGN
                  ttsswoworp0502_lbr_expcst = (accum total by wr_lot expcst)
                  ttsswoworp0502_lbr_acrvar = (accum total by wr_lot acrvar)
                  ttsswoworp0502_lbr_acccst = (accum total by wr_lot acccst)
                  ttsswoworp0502_lbr_rtevar = (accum total by wr_lot rtevar)
                  ttsswoworp0502_lbr_usevar = (accum total by wr_lot usevar)
                  ttsswoworp0502_lbr_wowipx = (accum total by wr_lot wowipx)
                  ttsswoworp0502_lbr_wipamt = (accum total by wr_lot wipamt)
                  .
            END.
            if i = 2 THEN DO:
               ASSIGN
                  ttsswoworp0502_bdn_expcst = (accum total by wr_lot expcst)
                  ttsswoworp0502_bdn_acrvar = (accum total by wr_lot acrvar)
                  ttsswoworp0502_bdn_acccst = (accum total by wr_lot acccst)
                  ttsswoworp0502_bdn_rtevar = (accum total by wr_lot rtevar)
                  ttsswoworp0502_bdn_usevar = (accum total by wr_lot usevar)
                  ttsswoworp0502_bdn_wowipx = (accum total by wr_lot wowipx)
                  ttsswoworp0502_bdn_wipamt = (accum total by wr_lot wipamt)
                  .
            END.
            if i = 3 THEN DO:
               ASSIGN
                  ttsswoworp0502_sub_expcst = (accum total by wr_lot expcst)
                  ttsswoworp0502_sub_acrvar = (accum total by wr_lot acrvar)
                  ttsswoworp0502_sub_acccst = (accum total by wr_lot acccst)
                  ttsswoworp0502_sub_rtevar = (accum total by wr_lot rtevar)
                  ttsswoworp0502_sub_usevar = (accum total by wr_lot usevar)
                  ttsswoworp0502_sub_wowipx = (accum total by wr_lot wowipx)
                  ttsswoworp0502_sub_wipamt = (accum total by wr_lot wipamt)
                  .
            END.
            /* SS - 20080719.1 - E */

            assign
               exptot = exptot + accum total by wr_lot expcst
               acctot = acctot + accum total by wr_lot acccst
               acrtot = acrtot + accum total by wr_lot acrvar
               rtetot = rtetot + accum total by wr_lot rtevar
               usetot = usetot + accum total by wr_lot usevar
               wototx = wototx + accum total by wr_lot wowipx
               wiptot = wiptot + accum total wipamt.

         end.

         {mfrpchk.i &warn=no}
      end.  /*for each wr_route*/
   end.  /*do i = 1 to 3*/

   /* SS - 20080719.1 - B */
   /*
   do with frame c:
      underline
         expcst
         acrvar
         acccst
         rtevar
         usevar
         wowipx
         wipamt.

      /* RE-INITIALIZE FORMAT */
      assign
         expcst:format = tmp_fmt
         acrvar:format = tmp_fmt
         acccst:format = tmp_fmt
         rtevar:format = tmp_fmt
         usevar:format = tmp_fmt
         wowipx:format = tmp_fmt
         wipamt:format = tmp_fmt.

      display
         getTermLabel("WORK_ORDER_SUBTOTAL",18) + ":" @ item
         exptot @ expcst
         acctot @ acccst
         acrtot @ acrvar
         rtetot @ rtevar
         usetot @ usevar
         wototx @ wowipx
         wiptot @ wipamt.
      down 1.

      /* REGULAR PRODUCTS (AVG) */
      if glx_mthd = "AVG" and wo_joint_type = "" then do:
         if display_det then do:
            display
               " - " + getTermLabel("DISCREPANCY",16) + ":" @ item
               -1 * wo_mthd_var @ wipamt.
            underline wipamt.

            /* RE-INITIALIZE FORMAT */
            wipamt:format = tmp_fmt.

            display
               getTermLabel("BALANCE",19) + ":" @ item
               wo_wip_tot @ wipamt.
         end.
         else do:

            display
               " - " + getTermLabel("COST_RECEIVED_TO_FG",16)
               + ":" @ item
               -1 *
               (wo_mtl_tot + wo_lbr_tot + wo_bdn_tot + wo_sub_tot
               - wo_rjct_tot - wo_wip_tot - wo_mthd_var) @ wipamt.
            down 1.

            display
               " - " + getTermLabel("SCRAPPED",16) + ":" @ item
               -1 * wo_rjct_tot @ wipamt.
            down 1.

            display
               " - " + getTermLabel("DISCREPANCY",16) + ":" @ item
               -1 * wo_mthd_var @ wipamt.
            underline wipamt.

            /* RE-INITIALIZE FORMAT */
            wipamt:format = tmp_fmt.

            display
               getTermLabel("BALANCE",19) + ":" @ item
               wo_wip_tot @ wipamt.
         end.
      end.

      /* REGULAR PRODUCTS (STD) AND JOINT PRODUCTS (AVG & STD) */
      else do:

         /*  JOINT PRODUCTS (AVG & STD) */
         if wo_joint_type = "5" then do: /* base process */
            do for wo_mstr1:
               do i = 1 to 3:
                  if i = 3 and glx_mthd = "AVG" then leave.
                  down 1.
                  if i = 1 then do:

                     display getTermLabel("CO/BY-PRODUCTS",20) @ item.
                     down 1.
                     if glx_mthd = "AVG" then
                        display
                        " - " + getTermLabel("COST_RECEIVED_TO_FG",16)
                        + ":" @ item.
                     else
                        display
                        " - " + getTermLabel("STANDARD_COST_RECEIVED",16)
                        + ":" @ item.
                  end.
                  else
                  if i = 2 then
                     display " - " + getTermLabel("SCRAPPED",16) + ":"
                     @ item.
                  else
                  if i = 3 then  /* glx_mthd = "STD" */
                     display " - " + getTermLabel("MIX_VARIANCES",16)
                     + ":" @ item.
                  down 1.

                  /* CO- AND BY-PRODUCTS */
                  for each wo_mstr1 no-lock
                         where wo_mstr1.wo_domain = global_domain and
                         wo_mstr1.wo_nbr = wo_mstr.wo_nbr and
                        wo_mstr1.wo_lot <> wo_mstr.wo_lot and
                        wo_mstr1.wo_type = "" with frame c:

                     if i = 1 and (wo_mstr1.wo_qty_comp <> 0 or
                        (wo_mstr1.wo_mtl_totx + wo_mstr1.wo_lbr_totx +
                        wo_mstr1.wo_bdn_totx + wo_mstr1.wo_sub_totx +
                        wo_mstr1.wo_rjct_tot <> 0))
                     then do:  /* RECEIPTS */
                        display
                           "  " + wo_mstr1.wo_part        @ item
                           wo_mstr1.wo_qty_comp           @ accqty
                           -1 *
                           ((wo_mstr1.wo_mtl_totx +
                           wo_mstr1.wo_lbr_totx +
                           wo_mstr1.wo_bdn_totx +
                           wo_mstr1.wo_sub_totx +
                           wo_mstr1.wo_rjct_tot)) @ wipamt.
                        down 1.
                     end.
                     else
                     if i = 2 and wo_mstr1.wo_qty_rjct <> 0
                     then do:  /* SCRAP */
                        display
                           "  " + wo_mstr1.wo_part            @ item
                           wo_mstr1.wo_qty_rjct               @ accqty
                           -1 * wo_mstr1.wo_rjct_tot          @ wipamt.
                        down 1.
                     end.
                     else
                     if i = 3 and wo_mstr1.wo_mix_var <> 0
                        and glx_mthd <> "AVG"
                     then do: /* MIX VARIANCES */
                        display
                           "  " + wo_mstr1.wo_part           @ item
                           wo_mstr1.wo_qty_comp +
                           wo_mstr1.wo_qty_rjct              @ accqty
                           -1 * wo_mstr1.wo_mix_var          @ wipamt.
                        down 1.
                     end.
                  end. /* for each wo_mstr1 */
               end. /* i = 1 to 3 */
            end. /* do for wo_mstr1 */
            down 1.
         end. /* if wo_joint_type = "5" */

         /* REGULAR PRODUCTS (STD)  wo_joint_type = ""  */
         else do:

            display
               " - " + getTermLabel("STANDARD_COST_RECEIVED",16)
               + ":" @ item
               -1 *
               (wo_mtl_tot + wo_lbr_tot + wo_bdn_tot + wo_sub_tot
               - wo_rjct_tot - wo_wip_tot - wo_mthd_var) @ wipamt.
            down 1.
         end.

         display
            " - " + getTermLabel("SCRAPPED",16) + ":" @ item
            -1 * wo_rjct_tot @ wipamt.
         down 1.

         /* DISPLAY DISCREPANCY FOR BASE PROCESS ORDERS */
         /* AND METHOD CHANGE FOR BASE PROCESS & REGULAR ORDERS */
         if glx_mthd = "AVG" then
            display " - " + getTermLabel("DISCREPANCY",16) + ":" @ item.
         else
            display " - " + getTermLabel("METHOD_CHANGE_VARIANCE",16)
            + ":" @ item
            -1 * wo_mthd_var @ wipamt.
         underline wipamt.

         /* RE-INITIALIZE FORMAT */
         wipamt:format = tmp_fmt.

         /* BALANCE FOR JOINT PRODUCTS (AVG & STD) & REGULAR (STD) */
         display
            getTermLabel("BALANCE",19) + ":" @ item
            wo_wip_tot @ wipamt.
      end. /* REGULAR PRODUCTS (STD) AND JOINT PRODUCTS (AVG & STD) */
   end.
   */
   /* SS - 20080719.1 - E */

   {mfrpchk.i}
end.

{wbrp04.i}
