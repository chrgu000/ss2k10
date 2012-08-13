/* GUI CONVERTED from sosomtu2.p (converter v1.75) Tue Oct 31 06:31:51 2000 */
/* sosomtu2.p - SALES ORDER MAINTENANCE INVENTORY UPDATE SUBROUTINE     */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
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
/* REVISION: 8.5      LAST MODIFIED: 09/01/95   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 12/12/95   BY: *F0RL* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 12/12/95   BY: *F0S8* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 12/12/95   BY: *F0TG* Sue Poland   */
/* REVISION: 8.6      LAST MODIFIED: 11/24/97   BY: *K15N* Doug Stevens */
/* REVISION: 8.6      LAST MODIFIED: 01/31/98   BY: *J2D6* Seema Varma  */
/* REVISION: 8.6E     LAST MODIFIED: 07/15/98   BY: *L024* Sami Kureishy*/
/* REVISION: 9.0      LAST MODIFIED: 12/23/98   BY: *J37G* Seema Varma  */
/* REVISION: 9.0      LAST MODIFIED: 01/12/99   BY: *J38F* Reetu Kapoor */
/* REVISION: 9.0      LAST MODIFIED: 03/23/99   BY: *J3BF* Anup Pereira */
/* REVISION: 9.0      LAST MODIFIED: 10/20/00   BY: *M0TV* Santosh Rao  */

/******************************************************************
*  This routine drives the updates to the Inventory Control and   *
*  Planning Modules.                                              *
*                                                                 *
*  If the inventory is in a different database from the sales     *
*  order, this routine will read in the sales order from the      *
*  hidden buffer and write it (temporarily) into the new          *
*  database before performing the updates.                        *
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan   */
******************************************************************/

         {mfdeclre.i}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE sosomtu2_p_1 "计划总装加工单"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtu2_p_2 "客户订单"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */


         {mfdatev.i}

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
/*F0S8*/ define shared frame bi.
         define shared frame hf_so_mstr.
         define shared frame hf_sod_det.
/*J04C*/ define     shared frame hf_rma_mstr.
/*J04C*/ define     shared frame hf_rmd_det.
/*F723*/ define     shared variable prev_confirm like sod_confirm.
/*F723*/ define     shared variable prev_qty_ord like sod_qty_ord.
/*G948*/ define     shared variable prev_type like sod_type.
/*F0RL*/ define     shared variable prev_due like sod_due_date.
/*F0RL*/ define     shared variable prev_abnormal like sod_abnormal.
/*F0RL*/ define     shared variable prev_consume like sod_consume.
/*F0RL*/ define     shared variable new_line like mfc_logical.
/*G948*/ define new shared variable delete_line like mfc_logical.
/*FN92** define            variable old_so_recno   like so_recno. **/
/*FN92*/ define new shared variable old_so_recno   like so_recno.
/*FN92** define            variable old_sod_recno  like sod_recno. **/
/*FN92*/ define new shared variable old_sod_recno  like sod_recno.
         define            variable open_qty       like sod_qty_ord.
/*F382*/ define     shared variable prev_site      like sod_site.
/*GD80*/ define            variable pm_code        like pt_pm_code.
/*FN92*/ define new shared variable inv_so_recno   as recid.
/*FN92*/ define new shared variable inv_sod_recno  as recid.
/*L024*/ define            variable o_seq          like so_exru_seq no-undo.

/*L024*/ define     shared temp-table tt_exru_usage like exru_usage.

/*G266*/ /* Added sobfile declaration */
         define shared workfile sobfile no-undo
          field sobpart like sob_part
          field sobsite like sob_site
          field sobissdate like sob_iss_date
          field sobqtyreq like sob_qty_req
          field sobconsume like sob_qty_req
          field sobabnormal like sob_qty_req.

/*F0S8 BEGINS*/

/*J2D6*/ /* FORM DEFINITION FOR HIDDEN FRAME BI */
/*J2D6*/ {sobifrm.i}

         FORM /*GUI*/  sod_det with frame bi THREE-D /*GUI*/.

/*F0S8 ENDS*/

         FORM /*GUI*/  so_mstr with overlay frame hf_so_mstr THREE-D /*GUI*/.

         FORM /*GUI*/  sod_det with overlay frame hf_sod_det THREE-D /*GUI*/.

/*J04C*/ FORM /*GUI*/  rma_mstr with overlay frame hf_rma_mstr THREE-D /*GUI*/.

/*J04C*/ FORM /*GUI*/  rmd_det with overlay frame hf_rmd_det THREE-D /*GUI*/.


/* F0RL - CHANGED THE WAY 'PREV' VARIABLES WERE SET. THIS ECO'S LOGIC */
/* WAS REPLACED BY F0S8. ONLY THE F0S8 CHANGE WAS MERGED INTO 8.5.    */

/*F0S8 - MOVES THE SHARED FRAME AND FORM DECLARATIONS OF PATCH F0RL TO BE
     ABOVE THOSE FOR SHARED FRAME HF_SOD_DET.  THIS MUST BE DONE DUE
     TO THE BEHAVIOR OF "ASSIGN"; IE, THE LAST DEFINE/FORM DECLARATION
     FOR PROGRESS V7/6 IS USED IN ASSIGNS EVEN IF THE DO-BLOCK SPECIFIES
     SOME OTHER FRAME TO USE. */

/*F0S8 BEGINS*/
  if not new_line then
  do with frame bi:
     assign
    prev_type     = input frame bi sod_type
    prev_due      = input frame bi sod_due_date
/*F0TG  prev_qty_ord  = input frame bi sod_qty_ord * input sod_um_conv  */
/*F0TG*/ prev_qty_ord  = input frame bi sod_qty_ord * input frame bi sod_um_conv
    prev_abnormal = input frame bi sod_abnormal
    prev_consume  = input frame bi sod_consume
    prev_site     = input frame bi sod_site.
  end.

/*F0S8 ENDS*/

if change_db then do:

   old_so_recno  = so_recno.
   old_sod_recno = sod_recno.

         /* Read the sales order header from hidden frame */
         do with frame hf_so_mstr on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

            find so_mstr where so_nbr = input so_nbr no-error.

            if not available so_mstr then do:
               create so_mstr.
               assign so_mstr.
/*J3BF*/       so_cmtindx = 0.
/*L024*/       if recid(so_mstr) = -1 then .
            end. /* if not available so_mstr */

/*L024*/    /* UPON FINDING so_mstr, DELETE ASSOCIATED USAGE RECORDS */
/*L024*/    else do:
/*L024*/       {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                  "(input so_exru_seq)"}
/*L024*/    end.  /* if available so_mstr */

/*L024*     This call to mccpexru will copy the temp table tt_exru_usage */
/*L024*     to the exru_usage file for the current db */
/*L024*/    {gprun.i ""mccpexru.p"" "(output o_seq)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*L024*/    so_exru_seq = o_seq.
            so_recno = recid(so_mstr).
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do with frame hf_so_mstr */

   /* Read the sales order line from hidden frame */
   do with frame hf_sod_det on error undo, retry:
/*GC26*/ find sod_det where sod_nbr  = so_nbr
/*GC26*/                and sod_line = input sod_line no-error.
/*GC26*/ if not available sod_det then do:
        create sod_det.
        assign sod_det.
/*GC26*/ end.
/*GC26*/ else do:
/*GC26*/    assign
/*GC26*/     sod_abnormal
/*GC26*/     sod_acct
/*GC26*/     sod_cc
/*GC26*/     sod_confirm
/*GC26*/     sod_consume
/*GC26*/     sod_disc_pct
/*GC26*/     sod_dsc_acct
/*GC26*/     sod_dsc_cc
/*GC26*/     sod_due_date
/*GC26*/     sod_expire
/*GC26*/     sod_list_pr
/*GC26*/     sod_loc
/*GC26*/     sod_lot
/*GC26*/     sod_per_date
/*GC26*/     sod_pickdate
/*GC26*/     sod_price
/*GC26*/     sod_prodline
/*GC26*/     sod_project
/*GC26*/     sod_qty_all
/*GC26*/     sod_qty_inv
/*GC26*/     sod_qty_ord
/*GC26*/     sod_qty_pick
/*GC26*/     sod_qty_ship
/*GC26*/     sod_req_date
/*GC26*/     sod_serial
/*GC26*/     sod_site
/*GC26*/     sod_sob_rev
/*GC26*/     sod_sob_std
/*GC26*/     sod_status
/*GC26*/     sod_std_cost
/*GC26*/     sod_type
/*GC26*/     sod_um
/*GC26*/     sod_um_conv
/*GC26*/     .
/*GC26*/ end.
      sod_recno = recid(sod_det).
   end.
/*J04C*     ADDED THE FOLLOWING */
            if so_fsm_type begins "RMA" then do:
                /* Read the RMA header from hidden frame */
                do with frame hf_rma_mstr on error undo, retry:
                    find rma_mstr where rma_nbr = input so_nbr and
                        rma_prefix = "C" no-error.
                    if not available rma_mstr then do:
                   create rma_mstr.
                   assign rma_mstr.
                    end.
                    so_recno = recid(so_mstr).
                end.

                /* Read the RMA line from hidden frame */
                do with frame hf_rmd_det on error undo, retry:
                    find rmd_det where rmd_nbr  = so_nbr
                        and rmd_line = input rmd_line
                        and rmd_prefix = "C" no-error.
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
/*J04C*     END ADDED CODE */
end.    /* if change_db then */
else do:
   find so_mstr where recid(so_mstr) = so_recno.
   find sod_det where recid(sod_det) = sod_recno.
end.

do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


/*G266*/ find first sobfile no-error.
/*G557*/ find first sob_det where sob_nbr = sod_nbr and sob_line = sod_line
/*G557*/ no-lock no-error.
/*G266*/ if available sobfile
/*G557*/ or available sob_det then do:
/*G557*******
/*G266*/*or can-find (first sob_det where sob_nbr = sod_nbr
/*G266*/*and sob_line = sod_line) then do:
 *G557*******/

/*G702*/   if sod_type = "" then do:
/*F817*/    {gprun.i ""sosomti.p""}
/*GUI*/ if global-beam-me-up then undo, leave.
 /* Update pt_mstr qty req for sob_det */
/*G702*/   end.
/*G948*/   else if prev_type = "" and (not new sod_det) then do:
/*G948*/      /* LINE CHGD TO MEMO, REVERSE MRP, IN QTY REQD, FORECAST ON SOB */
/*G948*/      delete_line = no.
/*G948*/      {gprun.i ""sosomtk.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G948*/      /* DELETE MRP PLANNED ORDER FOR PARENT */
/*G948*/      {mfmrw.i "sod_fas" sod_part sod_nbr string(sod_line) """"
          ? sod_due_date "0" "SUPPLYF" {&sosomtu2_p_1} sod_site}
/*G948*/   end.

/*G266*/ end.

     find pt_mstr where pt_part = sod_part no-lock no-error.

     /* TRANSACTION HISTORY RECORD */
/*FN92*/ /* Set database pointer to SO Header DB (if different) */
/*FN92*/ if change_db then do:
/*FN92*/    {gprun.i ""sohddb01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.
  /* Set db pointer */
/*FN92*/ end.

     {gprun.i ""sosotr.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*FN92*/ if change_db then do:
/*FN92*/    {gprun.i ""sohddb02.p""}
/*GUI*/ if global-beam-me-up then undo, leave.
  /* Reset db pointer */
/*FN92*/ end.

     /* RE-COST WHEN SITE CHANGES */
     if available pt_mstr
/*F382*/ and sod_site <> prev_site
     then do:
/*F382*/    sod_std_cost = 0.
/*G789* if pt_pm_code = "C" or can-find (first sob_det where sob_nbr  = sod_nbr
 *G789* and sob_line = sod_line) then do: */
/*GD80*     if pt_pm_code = "C" then do:  */

/*GD80*/    if can-find(first sob_det where sob_nbr = sod_nbr
/*GD80*/    and sob_line = sod_line) and sod_qty_ord <> 0 then do:
/*GD80*/       /* CONFIG'D PARENT'S THIS LVL COST AND ALL SOB'S TOTAL COST */
/*GD80*/       {gpsct05.i &part=sod_part &site=sod_site &cost=
           "sct_bdn_tl + sct_lbr_tl + sct_mtl_tl + sct_ovh_tl + sct_sub_tl"}
/*GD80*/       sod_std_cost = glxcst * sod_um_conv.

           for each sob_det no-lock where sob_nbr = sod_nbr
           and sob_line = sod_line:
/*GUI*/ if global-beam-me-up then undo, leave.


/*GD80*/          find pt_mstr where pt_part = sob_part no-lock no-error.
/*GD80*/          if available pt_mstr then pm_code = pt_pm_code.
/*GD80*/          else pm_code = "".
/*GD80*/          find ptp_det where ptp_part = sob_part and
/*GD80*/          ptp_site = sob_site no-lock no-error.
/*GD80*/          if available ptp_det then pm_code = ptp_pm_code.
/*GD80*/          if pm_code <> "C" then do:
/*GD80*/             {gpsct05.i &part=sob_part &site=sob_site &cost=sct_cst_tot}
/*GD80*/          end.
/*GD80*/          else do: /* This level cost on config parents */
/*GD80*/             {gpsct05.i &part=sob_part &site=sob_site &cost=
           "sct_bdn_tl + sct_lbr_tl + sct_mtl_tl + sct_ovh_tl + sct_sub_tl"}
/*GD80*/          end.
/*GD80*/          sod_std_cost =
/*GD80*/          sod_std_cost + glxcst * sob_qty_req / sod_qty_ord.
           end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* each sob_det */
           find pt_mstr where pt_part = sod_part no-lock no-error.
        end.
        else do:
           {gpsct05.i &part=sod_part &site=sod_site &cost=sct_cst_tot}
           sod_std_cost = glxcst * sod_um_conv.
        end.
     end.

/*GD71*/ if sod_type = "" or (prev_type = "" and sod_type <> ""
/*J37G** /*GD71*/         and not new sod_det) then do: */
/*J37G*/                  and not new_line) then
/*J37G*/ do:
/*F723*/    /* if unconfirmed line changed to confirmed prepare to 4cast */
/*J37G**    /*F723*/  if not new sod_det and not prev_confirm and sod_confirm */
/*J37G*/    if not new_line and
/*J37G*/       not prev_confirm and
/*J37G*/       sod_confirm
/*F723*/    then prev_qty_ord = 0.
        /* FORECAST RECORD */
        {gprun.i ""sosofc.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F504*/ end. /* IF SOD_TYPE = "" OR ... */

     open_qty = 0.

/*G789*/ find first sob_det where sob_nbr = sod_nbr and sob_line = sod_line
/*G789*/ no-lock no-error.
/*G789*/ if available sob_det then do:

     open_qty = max(sod_qty_ord * sod_um_conv,0).
     if sod_fa_nbr > "" then
     for each wo_mstr no-lock where wo_nbr  = sod_fa_nbr
                    and wo_type = "F"
                    and wo_part = sod_part:
        open_qty = max(open_qty - wo_qty_ord,0).
     end.
     open_qty =
     min(open_qty,max((sod_qty_ord - sod_qty_ship) * sod_um_conv,0)).

/*G789*/ if available pt_mstr then do:
/*G789*/    sodreldate = ?.
/*G911*/    find ptp_det no-lock where ptp_part = sod_part
/*G911*/    and ptp_site = sod_site no-error.
/*G911*/    if available ptp_det then do:
/*G911*/       {mfdate.i sodreldate sod_due_date ptp_mfg_lead sod_site}
/*G911*/    end.
/*G911*/    else do:
/*G789*/       {mfdate.i sodreldate sod_due_date pt_mfg_lead sod_site}
/*G911*/    end.
/*G789*/ end.
/*G789*/ else do:
/*G789*/    sodreldate = sod_due_date.
/*G789*/    {mfhdate.i sodreldate -1 sod_site}
/*G789*/ end.

   end.

/*J04C*/ /* RMA RECEIPTS SHOULD NOT BE REFLECTED IN MRP */

         /* MRP WORKFILE */
         if sod_type <> ""
/*J04C*/ or sod_fsm_type = "RMA-RCT"
         then open_qty = 0.

         {mfmrw.i "sod_fas" sod_part sod_nbr string(sod_line) """"
            sodreldate sod_due_date open_qty "SUPPLYF"
            {&sosomtu2_p_1} sod_site}

         if sod_qty_ord >= 0 then
            open_qty = max((sod_qty_ord - sod_qty_ship) * sod_um_conv,0).
         else
            open_qty = min((sod_qty_ord - sod_qty_ship) * sod_um_conv,0).

         if sod_type <> ""
/*J04C*/ or sod_fsm_type = "RMA-RCT"
         then open_qty = 0.

         /* MRP WORKFILE */
         {mfmrw.i "sod_det" sod_part sod_nbr string(sod_line) """"
            ? sod_due_date open_qty "DEMAND" {&sosomtu2_p_2}
            sod_site}

/*K15N*/ /*Delete sob_det records & reverse MRP demands of components */
/*K15N*/ /*If the order quantity is changed to zero */
/*K15N*/ if sod_qty_ord = 0 then do:

/*J38F** BEGIN DELETE **
 * /*K15N*/    for each sob_det exclusive-lock where sob_nbr = sod_nbr
 * /*K15N*/       and sob_line = sod_line:
 *
 * /*K15N*/       {inmrp.i &part=sob_part &site=sob_site}
 * /*K15N*/       {mfmrwdel.i "sob_det" sob_part sob_nbr
 *                       "string(sob_line) + ""-"" + sob_feature" sob_parent }
 *
 * /*K15N*/       delete sob_det.
 * /*K15N*/    end. /* for each sob_det */
 *J38F** END DELETE **/

/*M0TV*/    /* DELETE KIT COMPONENT DETAIL ALLOCATIONS */
/*M0TV*/    {gprun.i ""soktdel1.p"" "(input recid(sod_det))"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*M0TV*/    sod_recno = recid(sod_det).
/*M0TV*/    if can-find (first sob_det where sob_nbr  = sod_nbr
/*M0TV*/                                 and sob_line = sod_line)
/*M0TV*/    then do:
/*J38F*/       /* DELETE SOB_DET */
/*J38F*/       delete_line = yes.
/*J38F*/       {gprun.i ""sosomtk.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*M0TV*/    end. /* IF CAN-FIND(FIRST SOB_DET .. */

/*K15N*/ end. /* if sod_qty_ord = 0 */

end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* Inventory database updates */

/* Reset the recids for the sales order database */
if change_db then do:

/*FL76*/ /* Send the local db cost back to the main database */
/*FL76*/ display stream hs_so
/*FL76*/    sod_std_cost
/*FL76*/    with frame hf_sod_det.

   so_recno  = old_so_recno.
   sod_recno = old_sod_recno.

end.
