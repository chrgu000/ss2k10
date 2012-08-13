/* GUI CONVERTED from poporcb7.p (converter v1.69) Fri May 23 00:19:00 1997 */
/* poporcb7.p - CREATE PURCHASE ORDER HISTORY (FOR PO RECEIPT)                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/* REVISION: 7.4     LAST MODIFIED: 03/16/95    BY: smp *F0N5*                */
/* REVISION: 7.4     LAST MODIFIED: 04/18/95    BY: dxk *G0KY*                */
/* REVISION: 8.5     LAST MODIFIED: 08/22/95    BY: tjs *J06Z*                */
/* REVISION: 8.5     LAST MODIFIED: 10/02/95    BY: vrn *G0Y8*                */
/* REVISION: 8.5     LAST MODIFIED: 11/09/95    BY: jym *G1BR*                */
/* REVISION: 8.5     LAST MODIFIED: 10/13/95    BY: taf *J053*                */
/* REVISION: 8.5     LAST MODIFIED: 02/05/96    BY: *J0CV* Robert Wachowicz   */
/* REVISION: 8.5     LAST MODIFIED: 09/10/96    BY: *G2DX* Sue Poland         */
/* REVISION: 8.5     LAST MODIFIED: 05/13/97    BY: *G2M4* Ajit Deodhar       */


         {mfdeclre.i}

         /* INPUT PARAMETERS */
         define input        parameter  pod_recno   as   recid.
/*J0CV*/ define input        parameter  ship_date   like prh_ship_date no-undo.
         define input        parameter  po_recno    as   recid.
         define input        parameter  sct_recno   as   recid.
         define input        parameter  rcv_type    like poc_rcv_type.
         define input        parameter  site        like pod_site no-undo.
         define input        parameter  is-return   like mfc_logical no-undo.
         define input        parameter  eff_date    like glt_effdate.
/*J06Z*/ define input        parameter  vendlot     like prh_vend_lot no-undo.
         define input        parameter  receivernbr like prh_receiver.
         define input        parameter  ps_nbr      like prh_ps_nbr.
         define input        parameter  dr_acct     like trgl_dr_acct.
         define input        parameter  dr_cc       like trgl_dr_cc.
         define input        parameter  project     like prh_project.
         define input        parameter  price       like tr_price.
         define input        parameter  exch_rate   like exd_rate.
         define input        parameter  yes_char    as   character
                                                         format "x(1)".
         define input        parameter  crtint_amt  like trgl_gl_amt.
/*G2M4*/ define input        parameter  use_pod_um_conv like mfc_logical no-undo.
         define input-output parameter  stdcst      like tr_price.
/*G0KY   define input-output parameter  old_db      like si_db.
.        define input-output parameter  new_db      like si_db.  */

/*J053*/ define      shared  variable   rndmthd like rnd_rnd_mthd.
/*G0KY*/ define      shared  variable   old_db      like si_db.
/*G0KY*/ define      shared  variable   new_db      like si_db.

         define      shared  stream     hs_prh.
/*G0KY*/ define      shared  frame      hf_prh_hist.

         define      shared  workfile   tax_wkfl
                             field      tax_nbr     like pod_nbr
                             field      tax_line    like pod_line
                             field      tax_env     like pod_tax_env
                             field      tax_usage   like pod_tax_usage
                             field      tax_taxc    like pod_taxc
                             field      tax_in      like pod_tax_in
                             field      tax_taxable like pod_taxable
                             field      tax_price   like prh_pur_cost.

         define              variable   line_amt    like trgl_gl_amt.

         FORM /*GUI*/  prh_hist with frame hf_prh_hist THREE-D /*GUI*/.



         find po_mstr where recid(po_mstr) = po_recno.
         find pod_det where recid(pod_det) = pod_recno.
         find sct_det where recid(sct_det) = sct_recno no-error.
         find first gl_ctrl no-lock.
         find first icc_ctrl no-lock.

         if stdcst = 0 and available sct_det then stdcst = sct_cst_tot.

         /* CREATE PURCHASE RECEIPT HISTORY RECORD */
            create prh_hist.
            if rcv_type = 0 then
               assign
                      prh_print = no.
            if {txnew.i} then do:
                if pod_taxable then
                    assign
                           prh_tax_at = "yes".
                else
                    assign
                           prh_tax_at = "".
            end.
            else
            if pod_taxable and gl_vat = no and gl_can = no then
               assign
                      prh_tax_at = yes_char.

/*G2M4*/  /* WHEN PO IS RAISED IN STOCKING UM AND RECEIVED IN ALTERNATE UM;   */
/*G2M4*/  /* CONVERT THE QUANTITY RECEIVED BY DIVIDING WITH CONVERSION FACTOR */
/*G2M4*/  /* TO AVOID ROUNDING ERRORS. */

/*G2M4*/   /* ADDED TO ASSIGN prh_rcvd CONDITIONALLY */
/*G2M4*/    if use_pod_um_conv then
/*G2M4*/           prh_rcvd = ( if is-return then (- pod_qty_chg)
/*G2M4*/                        else pod_qty_chg) / pod_um_conv.
/*G2M4*/    else
/*G2M4*/           prh_rcvd = ( if is-return then (- pod_qty_chg)
/*G2M4*/                       else pod_qty_chg) * pod_rum_conv.

            assign prh_site = site
                   prh_part = pod_part
                   prh_nbr = pod_nbr
                   prh_line = pod_line
/*G2M4**  COMMENTED AND MOVED BEFORE assign TO ASSIGN prh_rcvd CONDITIONALLY **
 *                 prh_rcvd = ( if is-return then (- pod_qty_chg)
 *                               else pod_qty_chg) * pod_rum_conv
 **G2M4*/
                   prh_cum_rcvd = pod_cum_qty[1] +
/*G0Y8*                           (if is-return then 0 else prh_rcvd) */
/*G0Y8*/                          prh_rcvd
                   prh_curr_rlse_id[1] = pod_curr_rlse_id[1]
                   prh_rcp_date = eff_date
/*J06Z*/           prh_vend_lot = vendlot
                   prh_vend = po_vend
                   prh_receiver = receivernbr
                   prh_lot = pod_wo_lot
                   prh_ps_nbr = ps_nbr
                   prh_ps_qty = pod_ps_chg *
                                (if is-return then pod_rum_conv else 1)
                   prh_bo_qty = pod_bo_chg
                   prh_acct = dr_acct
                   prh_cc = dr_cc
                   prh_project = project
                   prh_po_site = pod_po_site
                   prh_pur_std = stdcst
/*G1BR*/           prh_sub_std = (if pod_type = "s" then stdcst else 0)
                   prh_rev = pod_rev
                   prh_type = pod_type
                   prh_buyer = po_buyer
                   prh_cst_up = pod_cst_up
                   prh_um = pod_um
                   prh_um_conv = pod_um_conv
                   prh_pur_cost = price
                   prh_ex_rate = exch_rate
                   prh_fix_pr  = pod_fix_pr
                   prh_crt_int = pod_crt_int
                   prh_curr = po_curr
                   prh_per_date = pod_per_date
                   prh_qty_ord = pod_qty_ord
                   prh_ship = po_ship
                   prh_request = pod_request
                   prh_curr_amt = prh_pur_cost
                   prh_approve = pod_approve
/*G2DX*/           prh_rma_type = pod_rma_type
/*G2DX*/           prh_fsm_type = pod_fsm_type		
                   prh_taxc = pod_taxc
                   prh_tax_env = pod_tax_env
                   prh_tax_in = pod_tax_in
/*J0CV*/           prh_ship_date = ship_date
                   prh_tax_usage = pod_tax_usage.

            if is-return then
               assign
                   prh_rcp_type = "R"
                   prh_reason = pod_reason.

            /* For RTS's assign the receipt type to  */
            /* "R" signifying an Return to Supplier. */
            if pod_fsm_type <> "" then
               assign prh_rcp_type = "R".

            /* UPDATE TAX INFORMATION IF FISCAL RECEIVING */
            find first  tax_wkfl
               where tax_nbr = pod_nbr and  tax_line = pod_line no-error.
            if available tax_wkfl then do:
               assign
                  prh_taxc      = tax_wkfl.tax_taxc
                  prh_tax_env   = tax_wkfl.tax_env
                  prh_tax_in    = tax_wkfl.tax_in
                  prh_tax_usage = tax_wkfl.tax_usage
                  prh_pur_cost  = tax_wkfl.tax_price.
            end.

            /* ACCUMULATE CREDIT TERMS INTEREST */
            if pod_crt_int <> 0 then do:
/*J053*/       /* PRICE IS UNIT PRICE IN DOCUMENT CURRENCY */
               line_amt = prh_rcvd * price.
/*J053*/       /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
/*J053*/       {gprun.i ""gpcurrnd.p"" "(input-output line_amt,
                                         input rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               crtint_amt = crtint_amt +
                  (line_amt - (line_amt / ((pod_crt_int + 100) / 100))).
/*J053*/       /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
/*J053*/       {gprun.i ""gpcurrnd.p"" "(input-output crtint_amt,
                                         input rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.

            if pod_sched then do:
               find last schd_det where schd_type = 4
                                  and   schd_nbr = pod_nbr
                                  and   schd_line = pod_line
                                  and   schd_rlse_id = pod_curr_rlse_id[1]
                                  and   schd_date <= eff_date
                                  no-lock no-error.
               if available schd_det then do:
                  prh_cum_req = schd_cum_qty.
               end.

               assign
                       prh_qty_ord = 0
                       prh_per_date = ?.

               find sch_mstr where sch_type = 4
                             and   sch_nbr = pod_nbr
                             and   sch_line = pod_line
                             and   sch_rlse_id = pod_curr_rlse_id[1]
                             no-lock no-error.

               if available sch_mstr then do:
                  prh_per_date = sch_pcs_date.

                  if sch_pcr_qty > pod_cum_qty[1] then do:
                     prh_qty_ord = sch_pcr_qty - pod_cum_qty[1].
                  end.
                  else do:
                     find first schd_det
                     where schd_type = 4
                     and schd_nbr = pod_nbr
                     and schd_line = pod_line
                     and schd_rlse_id = pod_curr_rlse_id[1]
                     and schd_cum_qty > pod_cum_qty[1]
                     no-lock no-error.

                     if available schd_det then do:
                        assign
                                 prh_per_date = schd_date
                                 prh_qty_ord = schd_cum_qty - pod_cum_qty[1].
                     end.
                     else do:
                        find last schd_det
                        where schd_type = 4
                        and schd_nbr = pod_nbr
                        and schd_line = pod_line
                        and schd_rlse_id = pod_curr_rlse_id[1]
                        no-lock no-error.

                        if available schd_det then do:
                           assign
                                   prh_per_date = schd_date
                                   prh_qty_ord = 0.
                        end.
                     end.
                  end.   /* else do */
               end.  /* if available sch_mstr then do: */
            end.  /* if pod_sched then do: */

            if prh_curr <> base_curr then
               prh_pur_cost = prh_pur_cost / prh_ex_rate.

            /* GET STANDARD COSTS FOR THIS LEVEL USING SCT_DET RECORD */
            if available sct_det and pod_type  = "" then do:
               if icc_cogs then do:
                  assign prh_mtl_std = sct_mtl_tl + sct_mtl_ll
                                     + sct_lbr_ll + sct_bdn_ll
                                     + sct_ovh_ll + sct_sub_ll
                         prh_lbr_std = sct_lbr_tl
                         prh_bdn_std = sct_bdn_tl
                         prh_ovh_std = sct_ovh_tl
                         prh_sub_std = sct_sub_tl.
               end.
               else do:
                  assign prh_mtl_std = sct_mtl_tl + sct_mtl_ll
                         prh_lbr_std = sct_lbr_tl + sct_lbr_ll
                         prh_bdn_std = sct_bdn_tl + sct_bdn_ll
                         prh_ovh_std = sct_ovh_tl + sct_ovh_ll
                         prh_sub_std = sct_sub_tl + sct_sub_ll.
               end.
            end. /* if available sct_det and... then do */

            assign old_db = global_db.
            if pod_po_db <> "" and pod_po_db <> global_db then do:
               display stream
                         hs_prh
                         prh_hist
               with frame hf_prh_hist.
               new_db = pod_po_db.
               {gprun.i ""gpaliasd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

               /* COPY PRH_HIST TO THE PO DB */
               {gprun.i ""poporcb1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

               new_db = old_db.
               {gprun.i ""gpaliasd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

               prh_last_vo = pod_po_db.
            end.
