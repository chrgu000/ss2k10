/* xxsosomtu2.p - SALES ORDER MAINTENANCE INVENTORY UPDATE SUBROUTINE     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.30 $                                             */

/*V8:ConvertMode=Maintenance                                            */

/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040**/
/* REVISION: 7.0      LAST MODIFIED: 10/11/91   BY: emb *F024**/
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: pma *F003**/
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: emb *F369**/
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: dld *F382**/
/* REVISION: 7.0      LAST MODIFIED: 06/10/92   BY: tjs *F504**/
/* REVISION: 7.0      LAST MODIFIED: 07/08/92   BY: tjs *F723**/
/* REVISION: 7.0      LAST MODIFIED: 07/28/92   BY: emb *F817**/
/* REVISION: 7.3      LAST MODIFIED: 11/02/92   BY: emb *G266**/
/* REVISION: 7.3      LAST MODIFIED: 11/12/92   BY: tjs *G191**/
/* REVISION: 7.3      LAST MODIFIED: 01/18/93   BY: tjs *G557**/
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   BY: tjs *G702**/
/* REVISION: 7.3      LAST MODIFIED: 03/04/93   BY: tjs *G789**/
/* REVISION: 7.3      LAST MODIFIED: 04/13/93   BY: tjs *G911**/
/* REVISION: 7.3      LAST MODIFIED: 04/15/93   BY: tjs *G948**/
/* REVISION: 7.3      LAST MODIFIED: 06/14/93   BY: afs *GC26**/
/* REVISION: 7.3      LAST MODIFIED: 07/28/93   BY: tjs *GD80**/
/* REVISION: 7.3      LAST MODIFIED: 08/06/93   BY: dpm *GD71**/
/* REVISION: 7.2      LAST MODIFIED: 01/27/94   BY: afs *FL76**/
/* REVISION: 7.3      LAST MODIFIED: 05/18/94   BY: afs *FN92**/
/* REVISION: 8.5      LAST MODIFIED: 09/01/95   BY: *J04C* Sue Poland     */
/* REVISION: 8.5      LAST MODIFIED: 12/12/95   BY: *F0RL* Sue Poland     */
/* REVISION: 8.5      LAST MODIFIED: 12/12/95   BY: *F0S8* Sue Poland     */
/* REVISION: 8.5      LAST MODIFIED: 12/12/95   BY: *F0TG* Sue Poland     */
/* REVISION: 8.6      LAST MODIFIED: 11/24/97   BY: *K15N* Doug Stevens   */
/* REVISION: 8.6      LAST MODIFIED: 01/31/98   BY: *J2D6* Seema Varma    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan     */
/* REVISION: 8.6E     LAST MODIFIED: 07/15/98   BY: *L024* Sami Kureishy  */
/* REVISION: 9.0      LAST MODIFIED: 12/23/98   BY: *J37G* Seema Varma    */
/* REVISION: 9.0      LAST MODIFIED: 01/12/99   BY: *J38F* Reetu Kapoor   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan     */
/* REVISION: 9.0      LAST MODIFIED: 03/23/99   BY: *J3BF* Anup Pereira   */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CG* Santosh Rao    */
/* REVISION: 9.1      LAST MODIFIED: 08/23/00   BY: *N0ND* Mark Brown     */
/* REVISION: 9.1      LAST MODIFIED: 10/20/00   BY: *M0TV* Santosh Rao    */
/* REVISION: 9.1      LAST MODIFIED: 11/08/00   BY: *N0TN* Jean Miller    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                */
/* Revision: 1.28     BY: Jeff Wootton  DATE: 09/21/01 ECO: *P01H*        */
/* Revision: 1.29     BY: Ellen Borden  DATE: 10/15/01  ECO: *P004*       */
/* $Revision: 1.30 $  BY: Sandeep P.    DATE: 11/05/01  ECO: *M1MQ*       */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/******************************************************************
*  This routine drives the updates to the Inventory Control and   *
*  Planning Modules.                                              *
*                                                                 *
*  If the inventory is in a different database from the sales     *
*  order, this routine will read in the sales order from the      *
*  hidden buffer and write it (temporarily) into the new          *
*  database before performing the updates.                        *
******************************************************************/

{mfdeclre.i}
{gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

/* MaxLen: Comment: */

/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{mfdatev.i}

define input parameter reason-code like rsn_code.
define input parameter tr-cmtindx  like tr_fldchg_cmtindx.

define shared variable all_days as integer.
define shared variable line like sod_line.
define shared variable sngl_ln like soc_ln_fmt.
define shared variable so_recno as recid.
define shared variable sod_recno as recid.
define shared variable sod-detail-all like soc_det_all.
define shared variable totallqty like sod_qty_all.
define shared variable old_site like sod_site.
define shared variable new_site like si_site.
define shared variable so_db like dc_name.
define shared variable inv_db like dc_name.
define shared variable sodreldate like sod_due_date.
define shared variable change_db as logical.
define shared stream hs_so.
define shared frame bi.
define shared frame hf_so_mstr.
define shared frame hf_sod_det.
define     shared frame hf_rma_mstr.
define     shared frame hf_rmd_det.
define     shared variable prev_confirm like sod_confirm.
define     shared variable prev_qty_ord like sod_qty_ord.
define     shared variable prev_type like sod_type.
define     shared variable prev_due like sod_due_date.
define     shared variable prev_abnormal like sod_abnormal.
define     shared variable prev_consume like sod_consume.
define     shared variable new_line like mfc_logical.
define new shared variable delete_line like mfc_logical.
define new shared variable old_so_recno   like so_recno.
define new shared variable old_sod_recno  like sod_recno.
define            variable open_qty       like sod_qty_ord.
define     shared variable prev_site      like sod_site.
define            variable pm_code        like pt_pm_code.
define new shared variable inv_so_recno   as recid.
define new shared variable inv_sod_recno  as recid.
define            variable o_seq          like so_exru_seq no-undo.
define     shared temp-table tt_exru_usage like exru_usage.

/* Added sobfile declaration */
define shared workfile sobfile no-undo
   field sobpart like sob_part
   field sobsite like sob_site
   field sobissdate like sob_iss_date
   field sobqtyreq like sob_qty_req
   field sobconsume like sob_qty_req
   field sobabnormal like sob_qty_req.

/* FORM DEFINITION FOR HIDDEN FRAME BI */
{sobifrm.i}

FORM /*GUI*/ 
   sod_det
with frame bi
width 80 THREE-D /*GUI*/.

FORM /*GUI*/  so_mstr with overlay frame hf_so_mstr THREE-D /*GUI*/.

FORM /*GUI*/  sod_det with overlay frame hf_sod_det THREE-D /*GUI*/.

FORM /*GUI*/  rma_mstr with overlay frame hf_rma_mstr THREE-D /*GUI*/.

FORM /*GUI*/  rmd_det with overlay frame hf_rmd_det THREE-D /*GUI*/.


if not new_line then
   do with frame bi:
   assign
      prev_type     = input frame bi sod_type
      prev_due      = input frame bi sod_due_date

      prev_qty_ord  = input frame bi sod_qty_ord * input frame bi sod_um_conv
      prev_abnormal = input frame bi sod_abnormal
      prev_consume  = input frame bi sod_consume
      prev_site     = input frame bi sod_site.
end.

if change_db then do:

   assign
      old_so_recno  = so_recno
      old_sod_recno = sod_recno.

   /* Read the sales order header from hidden frame */
   do with frame hf_so_mstr on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


      find so_mstr
         where so_nbr = input so_nbr exclusive-lock no-error.

      if not available so_mstr then do:
         create so_mstr.
         assign so_mstr.
         so_cmtindx = 0.
         if recid(so_mstr) = -1 then .
      end. /* if not available so_mstr */

      /* UPON FINDING so_mstr, DELETE ASSOCIATED USAGE RECORDS */
      else do:
         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
            "(input so_exru_seq)"}
      end.  /* if available so_mstr */

      {gprun.i ""mccpexru.p"" "(output o_seq)" }
/*GUI*/ if global-beam-me-up then undo, leave.

      assign
         so_exru_seq = o_seq
         so_recno = recid(so_mstr).
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do with frame hf_so_mstr */

   /* Read the sales order line from hidden frame */
   do with frame hf_sod_det on error undo, retry:

      find sod_det
         where sod_nbr  = so_nbr
         and sod_line = input sod_line exclusive-lock no-error.

      if not available sod_det then do:
         create sod_det.
         assign sod_det.
      end.
      else do:
         assign
            sod_abnormal
            sod_acct
            sod_sub
            sod_cc
            sod_confirm
            sod_consume
            sod_disc_pct
            sod_dsc_acct
            sod_dsc_sub
            sod_dsc_cc
            sod_dsc_project
            sod_due_date
            sod_expire
            sod_list_pr
            sod_loc
            sod_lot
            sod_per_date
            sod_pickdate
            sod_price
            sod_prodline
            sod_project
            sod_promise_date
            sod_qty_all
            sod_qty_inv
            sod_qty_ord
            sod_qty_pick
            sod_qty_ship
            sod_req_date
            sod_serial
            sod_site
            sod_sob_rev
            sod_sob_std
            sod_status
            sod_std_cost
            sod_type
            sod_um
            sod_um_conv
            .
      end.
      sod_recno = recid(sod_det).
   end.

   if so_fsm_type begins "RMA" then do:
      /* Read the RMA header from hidden frame */
      do with frame hf_rma_mstr on error undo, retry:

         find rma_mstr
            where rma_nbr    = input so_nbr and
            rma_prefix = "C" exclusive-lock no-error.

         if not available rma_mstr then do:
            create rma_mstr.
            assign rma_mstr.
         end.
         so_recno = recid(so_mstr).
      end.

      /* Read the RMA line from hidden frame */
      do with frame hf_rmd_det on error undo, retry:

         find rmd_det
            where rmd_nbr    = so_nbr
            and rmd_line   = input rmd_line
            and rmd_prefix = "C" exclusive-lock no-error.

         if not available rmd_det then do:
            create rmd_det.
            assign rmd_det.
         end.
         else do:
            assign
               rmd_part
               rmd_qty_ord
               rmd_qty_acp
               rmd_price
               rmd_ser
               rmd_desc
               rmd_cmtindx
               rmd_status
               rmd_prodline
               rmd_fault_cd
               rmd_ref
               rmd_exp_date
               rmd_cpl_date
               rmd_rma_nbr
               rmd_rma_line
               rmd_restock
               rmd_type
               rmd_link
               rmd_rma_rtrn
               rmd_cvr_pct
               rmd_iss
               rmd_site
               rmd_loc
               rmd_edit_isb
               rmd_rev
               rmd_um
               rmd_um_conv
               rmd_sv_code
               rmd_eng_code
               rmd_qty_rel
               rmd_sa_nbr
               rmd_covered
               rmd_par_ser
               rmd_qty_non
               rmd_par_part
               rmd_ins_date
               rmd_process
               .
         end.
      end.
   end.    /* if so_fsm_type begins "RMA" */

end.    /* if change_db then */
else do:

   find so_mstr
      where recid(so_mstr) = so_recno exclusive-lock no-error.

   find sod_det
      where recid(sod_det) = sod_recno exclusive-lock no-error.

end.

do on error undo, retry:

   find first sobfile no-error.

   for first sob_det
         fields(sob_line sob_nbr sob_part sob_qty_req sob_site)
         where sob_nbr  = sod_nbr
         and   sob_line = sod_line no-lock:
   end. /* FOR FIRST SOB_DET */

   if available sobfile
      or available sob_det then do:

      if sod_type = "" then do:
         {gprun.i ""sosomti.p""}
/*GUI*/ if global-beam-me-up then undo, leave.
 /* Update pt_mstr qty req for sob_det */
      end.
      else if prev_type = "" and (not new sod_det) then do:
         /* LINE CHGD TO MEMO, REVERSE MRP, IN QTY REQD, FORECAST ON SOB */
         delete_line = no.
         {gprun.i ""sosomtk.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

         /* DELETE MRP PLANNED ORDER FOR PARENT */
         /* Replaced pre-processor with Term */
         {mfmrw.i "sod_fas" sod_part sod_nbr string(sod_line) """"
            ? sod_due_date "0" "SUPPLYF" PLANNED_F/A_ORDER sod_site}
      end.

   end.

   for first pt_mstr
         fields(pt_abc pt_avg_int pt_bom_code pt_cyc_int pt_desc1
         pt_desc2 pt_insp_lead pt_insp_rqd pt_joint_type
         pt_loc pt_mfg_lead pt_mrp pt_network pt_ord_max
         pt_ord_min pt_ord_mult pt_ord_per pt_ord_pol
         pt_ord_qty pt_part pt_plan_ord pt_pm_code pt_prod_line
         pt_pur_lead pt_rctpo_active pt_rctpo_status
         pt_rctwo_active pt_rctwo_status pt_routing pt_sfty_time
         pt_timefence pt_um pt_yield_pct)
         where pt_part = sod_part no-lock:
   end. /* FOR FIRST PT_MSTR */

   /* TRANSACTION HISTORY RECORD */
   /* Set database pointer to SO Header DB (if different) */
   if change_db then do:
      {gprun.i ""sohddb01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.
  /* Set db pointer */
   end.

   {gprun.i ""xxsosotr.p""
      "(input reason-code,
        input tr-cmtindx)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   if change_db then do:
      {gprun.i ""sohddb02.p""}
/*GUI*/ if global-beam-me-up then undo, leave.
  /* Reset db pointer */
   end.

   /* RE-COST WHEN SITE CHANGES */
   if available pt_mstr
      and sod_site <> prev_site
   then do:
      sod_std_cost = 0.

      if can-find(first sob_det where sob_nbr = sod_nbr
         and sob_line = sod_line) and sod_qty_ord <> 0 then do:
         /* CONFIG'D PARENT'S THIS LVL COST AND ALL SOB'S TOTAL COST */
         {gpsct05.i &part=sod_part &site=sod_site &cost=
            "sct_bdn_tl + sct_lbr_tl + sct_mtl_tl + sct_ovh_tl + sct_sub_tl"}
         sod_std_cost = glxcst * sod_um_conv.

         for each sob_det
               fields(sob_line sob_nbr sob_part sob_qty_req sob_site)
               where sob_nbr  = sod_nbr
               and   sob_line = sod_line no-lock:

            for first pt_mstr
                  fields(pt_abc pt_avg_int pt_bom_code pt_cyc_int pt_desc1
                  pt_desc2 pt_insp_lead pt_insp_rqd pt_joint_type
                  pt_loc pt_mfg_lead pt_mrp pt_network pt_ord_max
                  pt_ord_min pt_ord_mult pt_ord_per pt_ord_pol
                  pt_ord_qty pt_part pt_plan_ord pt_pm_code pt_prod_line
                  pt_pur_lead pt_rctpo_active pt_rctpo_status
                  pt_rctwo_active pt_rctwo_status pt_routing pt_sfty_time
                  pt_timefence pt_um pt_yield_pct)
                  where pt_part = sob_part no-lock:
            end. /* FOR FIRST PT_MSTR */

            if available pt_mstr then pm_code = pt_pm_code.
            else pm_code = "".

            for first ptp_det
                  fields(ptp_bom_code ptp_ins_lead ptp_ins_rqd
                  ptp_joint_type ptp_mfg_lead ptp_network ptp_ord_max
                  ptp_ord_min ptp_ord_mult ptp_ord_per ptp_ord_pol
                  ptp_ord_qty ptp_part ptp_plan_ord ptp_pm_code
                  ptp_pur_lead ptp_routing ptp_sfty_tme ptp_site
                  ptp_timefnce ptp_yld_pct)
                  where ptp_part = sob_part
                  and   ptp_site = sob_site no-lock:
            end. /* FOR FIRST PTP_DET */

            if available ptp_det then pm_code = ptp_pm_code.
            if pm_code <> "C" then do:
               {gpsct05.i &part=sob_part &site=sob_site &cost=sct_cst_tot}
            end.
            else do: /* This level cost on config parents */
               {gpsct05.i &part=sob_part &site=sob_site &cost=
                  "sct_bdn_tl + sct_lbr_tl + sct_mtl_tl + sct_ovh_tl + sct_sub_tl"}
            end.
            sod_std_cost =
            sod_std_cost + glxcst * sob_qty_req / sod_qty_ord.
         end. /* each sob_det */

         for first pt_mstr
               fields(pt_abc pt_avg_int pt_bom_code pt_cyc_int pt_desc1
               pt_desc2 pt_insp_lead pt_insp_rqd pt_joint_type
               pt_loc pt_mfg_lead pt_mrp pt_network pt_ord_max
               pt_ord_min pt_ord_mult pt_ord_per pt_ord_pol
               pt_ord_qty pt_part pt_plan_ord pt_pm_code pt_prod_line
               pt_pur_lead pt_rctpo_active pt_rctpo_status
               pt_rctwo_active pt_rctwo_status pt_routing pt_sfty_time
               pt_timefence pt_um pt_yield_pct)
               where pt_part = sod_part no-lock:
         end. /* FOR FIRST PT_MSTR */

      end.
      else do:
         {gpsct05.i &part=sod_part &site=sod_site &cost=sct_cst_tot}
         sod_std_cost = glxcst * sod_um_conv.
      end.
   end.

   if sod_type = "" or (prev_type = "" and sod_type <> ""

      and not new_line) then
   do:

      if not new_line and
         not prev_confirm and
         sod_confirm
         then prev_qty_ord = 0.
      /* FORECAST RECORD */
      {gprun.i ""sosofc.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

   end. /* IF SOD_TYPE = "" OR ... */

   open_qty = 0.

   find first sob_det where sob_nbr = sod_nbr and sob_line = sod_line
      no-lock no-error.

   for first sob_det
         fields(sob_line sob_nbr sob_part sob_qty_req sob_site)
         where sob_nbr  = sod_nbr
         and   sob_line = sod_line no-lock:
   end. /* FOR FIRST SOB_DET */

   if available sob_det then do:

      open_qty = max(sod_qty_ord * sod_um_conv,0).
      if sod_fa_nbr > "" then

      for each wo_mstr
            fields(wo_nbr wo_part wo_qty_ord wo_type)
            where wo_nbr  = sod_fa_nbr
            and   wo_type = "F"
            and   wo_part = sod_part no-lock:

         open_qty = max(open_qty - wo_qty_ord,0).
      end. /* FOR EACH WO_MSTR */

      open_qty =
      min(open_qty,max((sod_qty_ord - sod_qty_ship) * sod_um_conv,0)).

      if available pt_mstr then do:
         sodreldate = ?.

         for first ptp_det
               fields(ptp_bom_code ptp_ins_lead ptp_ins_rqd
               ptp_joint_type ptp_mfg_lead ptp_network ptp_ord_max
               ptp_ord_min ptp_ord_mult ptp_ord_per ptp_ord_pol
               ptp_ord_qty ptp_part ptp_plan_ord ptp_pm_code
               ptp_pur_lead ptp_routing ptp_sfty_tme ptp_site
               ptp_timefnce ptp_yld_pct)
               where ptp_part = sod_part
               and   ptp_site = sod_site no-lock:
         end. /* FOR FIRST PTP_DET */

         if available ptp_det then do:
            {mfdate.i sodreldate sod_due_date ptp_mfg_lead sod_site}
         end.
         else do:
            {mfdate.i sodreldate sod_due_date pt_mfg_lead sod_site}
         end.
      end.
      else do:
         sodreldate = sod_due_date.
         {mfhdate.i sodreldate -1 sod_site}
      end.

   end.

   /* RMA RECEIPTS SHOULD NOT BE REFLECTED IN MRP */

   /* MRP WORKFILE */
   if sod_type <> ""
      or sod_fsm_type = "RMA-RCT"
      then open_qty = 0.

   if  not (sod_cfg_type = "2"
   and sod_btb_po <> ""
   and can-find(soc_ctrl where soc_use_btb = yes))
   then do:
      /* Replaced pre-processor with Term */
      {mfmrw.i
         "sod_fas"
         sod_part
         sod_nbr
         string(sod_line)
         """"
         sodreldate
         sod_due_date
         open_qty
         "SUPPLYF"
         PLANNED_F/A_ORDER
         sod_site}
   end. /* IF NOT (sod_cfg_type = "2" ...) */

   if sod_qty_ord >= 0 then
      open_qty = max((sod_qty_ord - sod_qty_ship) * sod_um_conv,0).
   else
      open_qty = min((sod_qty_ord - sod_qty_ship) * sod_um_conv,0).

   if sod_type <> ""
      or sod_fsm_type = "RMA-RCT"
      then open_qty = 0.

   /* MRP WORKFILE */
   /* Replaced pre-processor with Term */
   {mfmrw.i "sod_det" sod_part sod_nbr string(sod_line) """"
      ? sod_due_date open_qty "DEMAND" SALES_ORDER
      sod_site}

   /*Delete sob_det records & reverse MRP demands of components */
   /*If the order quantity is changed to zero */
   if sod_qty_ord = 0 then do:

      /* DELETE KIT COMPONENT DETAIL ALLOCATIONS */
      {gprun.i ""soktdel1.p"" "(input recid(sod_det))"}
/*GUI*/ if global-beam-me-up then undo, leave.


      sod_recno = recid(sod_det).
      if can-find (first sob_det where sob_nbr  = sod_nbr
         and sob_line = sod_line)
      then do:
         /* DELETE SOB_DET */
         delete_line = yes.
         {gprun.i ""sosomtk.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

      end. /* IF CAN-FIND(FIRST SOB_DET .. */

   end. /* if sod_qty_ord = 0 */

end.  /* Inventory database updates */

/* Reset the recids for the sales order database */
if change_db then do:

   /* Send the local db cost back to the main database */
   display stream hs_so
      sod_std_cost
   with frame hf_sod_det.

   assign
      so_recno  = old_so_recno
      sod_recno = old_sod_recno.

end.
