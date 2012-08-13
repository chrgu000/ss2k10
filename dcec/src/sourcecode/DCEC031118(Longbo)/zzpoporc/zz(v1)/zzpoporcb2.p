/* GUI CONVERTED from poporcb2.p (converter v1.69) Fri May 23 00:18:57 1997 */
/* zzpoporcb2.p - PURCHASE ORDER RECEIPT W/ SERIAL NUMBER CONTROL         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.0     LAST MODIFIED: 02/24/92    BY: pma *F085*          */
/* REVISION: 7.0     LAST MODIFIED: 07/29/92    BY: ram *F819*          */
/* REVISION: 7.3     LAST MODIFIED: 08/12/92    BY: tjs *G028*          */
/* REVISION: 7.3     LAST MODIFIED: 09/30/92    BY: afs *G116*          */
/* REVISION: 7.3     LAST MODIFIED: 12/14/92    BY: tjs *G443*          */
/* REVISION: 7.3     LAST MODIFIED: 12/17/92    BY: WUG *G455*          */
/* REVISION: 7.3     LAST MODIFIED: 01/07/93    BY: WUG *G523*          */
/* REVISION: 7.3     LAST MODIFIED: 01/11/93    BY: bcm *G425*          */
/* REVISION: 7.3     LAST MODIFIED: 05/26/93    BY: kgs *GB35*          */
/* REVISION: 7.3     LAST MODIFIED: 09/07/93    BY: WUG *GE83*          */
/* REVISION: 7.4     LAST MODIFIED: 11/23/93    BY: tjs *H082*          */
/* REVISION: 7.4     LAST MODIFIED: 10/23/93    BY: cdt *H184*          */
/* REVISION: 7.4     LAST MODIFIED: 12/20/93    BY: dpm *H074*          */
/* REVISION: 7.4     LAST MODIFIED: 10/11/94    BY: cdt *FS26*          */
/* REVISION: 7.4     LAST MODIFIED: 10/29/94    BY: bcm *FT05*          */
/* REVISION: 7.3     LAST MODIFIED: 11/15/94    BY: bcm *GO37*          */
/* REVISION: 7.4     LAST MODIFIED: 11/18/94    BY: jxz *GO56*          */
/* REVISION: 8.5     LAST MODIFIED: 12/02/94    BY: taf *J038*          */
/* REVISION: 7.4     LAST MODIFIED: 12/21/94    BY: afs *F0BJ*          */
/* REVISION: 7.4     LAST MODIFIED: 03/16/95    BY: smp *F0N5*          */
/* REVISION: 7.4     LAST MODIFIED: 04/18/95    BY: dxk *G0KY*          */
/* REVISION: 7.4     LAST MODIFIED: 08/07/95    BY: jym *G0TP*          */
/* REVISION: 8.5     LAST MODIFIED: 08/22/95    BY: tjs *J06Z*          */
/* REVISION: 8.5     LAST MODIFIED: 10/24/95    BY: taf *J053*          */
/* REVISION: 8.5     LAST MODIFIED: 02/05/96    BY: *J0CV* Robert Wachowicz*/
/* REVISION: 8.5     LAST MODIFIED: 09/26/96    BY: *G2G3* Ajit Deodhar */
/* REVISION: 8.5     LAST MODIFIED: 04/28/97    BY: *G2M7* Suresh Nayak */
/* REVISION: 8.5     LAST MODIFIED: 05/13/97    BY: *G2M4* Ajit Deodhar */

/*! GO56 porvisb.p -- obsolete after GO37.
/*! poporcb2.p - ANY CHANGES TO THIS PROGRAM MAY ALSO HAVE TO BE MADE
                 TO PORVISB.P (bcm)
*/ *GO56*/

         {mfdeclre.i}
         /* NEW SHARED VARIABLES, BUFFERS AND FRAMES */

         /* SHARED VARIABLES, BUFFERS AND FRAMES */
/*J053*/ define     shared variable rndmthd         like rnd_rnd_mthd.
/*J038*/ define     shared variable vendlot         like tr_vend_lot no-undo.
/*H184*/ define     shared variable  crtint_amt     like trgl_gl_amt.
         define     shared variable dr_acct         like trgl_dr_acct extent 6.
         define     shared variable dr_cc           like trgl_dr_cc extent 6.
         define     shared variable eff_date        like glt_effdate.
         define     shared variable exch_rate       like exd_rate.
/*G116*/ define     shared frame    hf_prh_hist.
         define     shared stream   hs_prh.
/*GO37*/ define     shared variable is-return       like mfc_logical no-undo.
         define     shared variable new_db          like si_db.
         define     shared variable old_db          like si_db.
         define     shared variable old_status      like pod_status.
         define     shared variable po_recno        as recid.
         define     shared variable pod_recno       as recid.
         define     shared variable price           like tr_price.
         define     shared variable project         like prh_project.
         define     shared variable ps_nbr          like prh_ps_nbr.
         define     shared variable openqty         like mrp_qty.
         define     shared variable qty_ord         like pod_qty_ord.
         define     shared variable rcv_type        like poc_rcv_type.
         define     shared variable replace         like mfc_logical.
         define     shared variable receivernbr     like prh_receiver.
         define     shared variable sct_recno       as recid.
/*G443*/ define     shared variable site            like pod_site no-undo.
         define     shared variable stdcst          like tr_price.
/*GB35*/ define     shared variable updt_blnkt      like mfc_logical.
/*G0TP*/ define     shared variable updt_blnkt_list as character no-undo.
         define     shared variable yes_char        as character format "x(1)".
/*G2M4*/ define     variable use_pod_um_conv        like mfc_logical no-undo.

/*J0CV*/ define     input parameter ship_date like prh_ship_date no-undo.

/*H074*/ define     shared workfile tax_wkfl
/*H074*/            field tax_nbr           like pod_nbr
/*H074*/            field tax_line          like pod_line
/*H074*/            field tax_env           like pod_tax_env
/*H074*/            field tax_usage         like pod_tax_usage
/*H074*/            field tax_taxc          like pod_taxc
/*H074*/            field tax_in            like pod_tax_in
/*H074*/            field tax_taxable       like pod_taxable
/*H074*/            field tax_price         like prh_pur_cost.

         /* LOCAL VARIABLES, BUFFERS AND FRAMES */
/*F0N5* *H184* define variable    line_amt    like trgl_gl_amt.  */
         define buffer      poddet      for pod_det.
/*GB35*/ define buffer      pomstr      for po_mstr.
/*F0BJ*/ define variable    over_qty    like pod_qty_rcvd.

         find po_mstr where recid(po_mstr) = po_recno.
         find pod_det where recid(pod_det) = pod_recno.
/*F0N5*  THESE RECORDS ARE ONLY USED IN POPORCB7.P               */
/*F0N5*  find sct_det where recid(sct_det) = sct_recno no-error. */
/*F0N5*  find first gl_ctrl no-lock.                             */
/*F0N5*  find first icc_ctrl no-lock.                            */
/*G116*/ FORM /*GUI*/  prh_hist with frame hf_prh_hist THREE-D /*GUI*/.


/*F0N5*  if stdcst = 0 and available sct_det then stdcst = sct_cst_tot. */

/*G2M4*/ use_pod_um_conv = no.
/*G2M4*/ find pt_mstr where pt_part = pod_part no-lock no-error.
/*G2M4*/ if available pt_mstr and pod_rum = pt_um
/*G2M4*/ then
/*G2M4*/     use_pod_um_conv = yes.
/*G2M4*/ else
/*G2M4*/     use_pod_um_conv = no.

         /* CREATE PURCHASE RECEIPT HISTORY RECORD */
/*F819*/ if pod_qty_chg <> 0 then do:

/*J06Z*/    /* Added 'input vendlot,' below */

/*J0CV ADDED LINE "INPUT SHIP_DATE" */
/*G2M4*/    /* ADDED INPUT PARAMETER use_pod_um_conv TO HANDLE ROUNDING ERROR */
/*F0N5*/    {gprun.i ""zzpoporcb7.p""
                     "(input pod_recno,
                       input ship_date,
                       input po_recno,
                       input sct_recno,
                       input rcv_type,
                       input site,
                       input is-return,
                       input eff_date,
                       input vendlot,
                       input receivernbr,
                       input ps_nbr,
                       input dr_acct[1],
                       input dr_cc[1],
                       input project,
                       input price,
                       input exch_rate,
                       input yes_char,
                       input crtint_amt,
/*G2M4*/               input use_pod_um_conv,
/*G0KY*/               input-output stdcst)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G0KY                 input-output stdcst,
.                      input-output old_db,
.                      input-output new_db)"}  */

/*F0N5*     MOVED THE FOLLOWING CODE INTO POPORCB7.P
.            create prh_hist.
.            if rcv_type = 0 then prh_print = no.
./*G425*/    if {txnew.i} then do:
.                if pod_taxable then
.                    prh_tax_at = "yes".
.                else
.                    prh_tax_at = "".
.            end.
./*G425*/    else
.            if pod_taxable and gl_vat = no and gl_can = no then
.            prh_tax_at = yes_char.
./*G443*     assign prh_site = pod_site */
./*G443*/    assign prh_site = site
.                   prh_part = pod_part
.                   prh_nbr = pod_nbr
.                   prh_line = pod_line
./*GO37**           prh_rcvd = pod_qty_chg * pod_rum_conv **/
./*GO37*/           prh_rcvd = ( if is-return then (- pod_qty_chg)
.                                else pod_qty_chg) * pod_rum_conv
./*GO37**           prh_cum_rcvd = pod_cum_qty[1] + prh_rcvd **/
./*G455*/           prh_cum_rcvd = pod_cum_qty[1] +
./*GO37*/                          (if is-return then 0 else prh_rcvd)
./*G455*/           prh_curr_rlse_id[1] = pod_curr_rlse_id[1]
.                   prh_rcp_date = eff_date
.                   prh_vend = po_vend
.                   prh_receiver = receivernbr
.                   prh_lot = pod_wo_lot
.                   prh_ps_nbr = ps_nbr
./*GO37**           prh_ps_qty = pod_ps_chg **/
./*GO37*/           prh_ps_qty = pod_ps_chg *
./*GO37*/                        (if is-return then pod_rum_conv else 1)
.                   prh_bo_qty = pod_bo_chg
.                   prh_acct = dr_acct[1]
.                   prh_cc = dr_cc[1]
.                   prh_project = project
.                   prh_po_site = pod_po_site
.                   prh_pur_std = stdcst
.                   prh_rev = pod_rev
.                   prh_type = pod_type
.                   prh_buyer = po_buyer
.                   prh_cst_up = pod_cst_up
.                   prh_um = pod_um
.                   prh_um_conv = pod_um_conv
.                   prh_pur_cost = price
.                   prh_ex_rate = exch_rate
./*H082*/           prh_fix_pr   = pod_fix_pr
./*H184*/           prh_crt_int  = pod_crt_int
.                   prh_curr = po_curr
.                   prh_per_date = pod_per_date
.                   prh_qty_ord = pod_qty_ord
.                   prh_ship = po_ship
.                   prh_request = pod_request
.                   prh_curr_amt = prh_pur_cost
./*FT05*/           prh_approve = pod_approve
./*G425*/           prh_taxc = pod_taxc
./*G425*/           prh_tax_env = pod_tax_env
./*G425*/           prh_tax_in = pod_tax_in
./*G425*/           prh_tax_usage = pod_tax_usage.
./*G425*/
.
./*GO37*/    if is-return then
./*GO37*/       assign
./*GO37*/           prh_rcp_type = "R"
./*GO37*/           prh_reason = pod_reason.
.
./*FS26*/    /* For RTS's assign the receipt type to  */
./*FS26*/    /* "R" signifying an Return to Supplier. */
./*FS26*/    if pod_fsm_type <> "" then
./*FS26*/       assign prh_rcp_type = "R".
.
./*H074*/    /* UPDATE TAX INFORMATION IF FISCAL RECEIVING */
./*H074*/    find first  tax_wkfl
./*H074*/       where tax_nbr = pod_nbr and  tax_line = pod_line no-error.
./*H074*/    if available tax_wkfl then do:
./*H074*/       assign
./*H074*/          prh_taxc      = tax_wkfl.tax_taxc
./*H074*/          prh_tax_env   = tax_wkfl.tax_env
./*H074*/          prh_tax_in    = tax_wkfl.tax_in
./*H074*/          prh_tax_usage = tax_wkfl.tax_usage
./*H074*/          prh_pur_cost  = tax_wkfl.tax_price.
./*H074*/    end.
.
./*H184*/    /* ACCUMULATE CREDIT TERMS INTEREST */
./*H184*/    if pod_crt_int <> 0 then do:
./*H184*/       line_amt = prh_rcvd * price.
./*H184*/       crtint_amt = crtint_amt +
./*H184*/          (line_amt - (line_amt / ((pod_crt_int + 100) / 100))).
./*H184*/    end.
.
.            /*G523 ADDED FOLLOWING SECTION*/
.            if pod_sched then do:
.               find last schd_det where schd_type = 4 and schd_nbr = pod_nbr
.               and schd_line = pod_line and schd_rlse_id = pod_curr_rlse_id[1]
.               and schd_date <= eff_date no-lock no-error.
.               if available schd_det then do:
.                  prh_cum_req = schd_cum_qty.
.               end.
.
.               /*GE83 ADDED FOLLOWING SECTION*/
.               assign
.               prh_qty_ord = 0
.               prh_per_date = ?.
.
.               find sch_mstr where sch_type = 4
.               and sch_nbr = pod_nbr
.               and sch_line = pod_line
.               and sch_rlse_id = pod_curr_rlse_id[1]
.               no-lock no-error.
.
.               if available sch_mstr then do:
.                  prh_per_date = sch_pcs_date.
.
.                  if sch_pcr_qty > pod_cum_qty[1] then do:
.                     prh_qty_ord = sch_pcr_qty - pod_cum_qty[1].
.                  end.
.                  else do:
.                     find first schd_det
.                     where schd_type = 4
.                     and schd_nbr = pod_nbr
.                     and schd_line = pod_line
.                     and schd_rlse_id = pod_curr_rlse_id[1]
.                     and schd_cum_qty > pod_cum_qty[1]
.                     no-lock no-error.
.
.                     if available schd_det then do:
.                        assign
.                        prh_per_date = schd_date
.                        prh_qty_ord = schd_cum_qty - pod_cum_qty[1].
.                     end.
.                     else do:
.                        find last schd_det
.                        where schd_type = 4
.                        and schd_nbr = pod_nbr
.                        and schd_line = pod_line
.                        and schd_rlse_id = pod_curr_rlse_id[1]
.                        no-lock no-error.
.
.                        if available schd_det then do:
.                           assign
.                           prh_per_date = schd_date
.                           prh_qty_ord = 0.
.                        end.
.                     end.
.                  end.
.               end.
.               /*GE83 END SECTION*/
.            end.
.            /*G523 END SECTION*/
.
.            if prh_curr <> base_curr then
.            prh_pur_cost = prh_pur_cost / prh_ex_rate.
.
.            /* GET STANDARD COSTS FOR THIS LEVEL */
.            /*F003*****************************************************/
.            /*F003     MODIFIED COSTS BELOW TO USE SCT_DET RECORD     */
.            /*F003*****************************************************/
.            if available sct_det and pod_type  = "" then do:
.               if icc_cogs then do:
.                  assign prh_mtl_std = sct_mtl_tl + sct_mtl_ll
.                                     + sct_lbr_ll + sct_bdn_ll
.                                     + sct_ovh_ll + sct_sub_ll
.                         prh_lbr_std = sct_lbr_tl
.                         prh_bdn_std = sct_bdn_tl
.                         prh_ovh_std = sct_ovh_tl
.                         prh_sub_std = sct_sub_tl.
.               end.
.               else do:
.                  assign prh_mtl_std = sct_mtl_tl + sct_mtl_ll
.                         prh_lbr_std = sct_lbr_tl + sct_lbr_ll
.                         prh_bdn_std = sct_bdn_tl + sct_bdn_ll
.                         prh_ovh_std = sct_ovh_tl + sct_ovh_ll
.                         prh_sub_std = sct_sub_tl + sct_sub_ll.
.               end.
.            end.
.            old_db = global_db.
.            if pod_po_db <> "" and pod_po_db <> global_db then do:
.               display stream hs_prh prh_hist with frame hf_prh_hist.
.               new_db = pod_po_db.
.               {gprun.i ""gpaliasd.p""}
.               {gprun.i ""poporcb1.p""}
.               new_db = old_db.
.               {gprun.i ""gpaliasd.p""}
.               prh_last_vo = pod_po_db.
.            end.
.*F0N5*      END MOVED CODE */

/*F819*/ end.  /* if pod_qty_chg <> 0 */

/*G2M4*/  /* WHEN PO IS RAISED IN STOCKING UM AND RECEIVED OR RETURNED       */
/*G2M4*/  /* IN ALTERNATE UM; CONVERT THE QUANTITY RECEIVED OR RETURNED BY   */
/*G2M4*/  /* DIVIDING WITH CONVERSION FACTOR TO AVOID ROUNDING ERRORS. */

         /*UPDATE PURCHASE ORDER QUANTITY RECEIVED OR RETURNED */
/*GO37*/ if is-return then do:
/*G2M4*/    if use_pod_um_conv then do:
/*G2M4*/        pod_qty_rtnd = pod_qty_rtnd + pod_qty_chg / pod_um_conv.
/*G2M4*/        pod_cum_qty[1] = pod_cum_qty[1] - pod_qty_chg / pod_um_conv.
/*G2M4*/    end. /* IF USE_POD_UM_CONV */
/*G2M4*/    else do:
/*GO37*/        pod_qty_rtnd = pod_qty_rtnd + pod_qty_chg * pod_rum_conv.
/*GO37*/        pod_cum_qty[1] = pod_cum_qty[1] - pod_qty_chg * pod_rum_conv.
/*G2M4*/    end. /* ELSE DO */
/*GO37*/ end.
/*GO37*/ else do:
/*G2M4*/    if use_pod_um_conv then do:
/*G2M4*/        pod_qty_rcvd = pod_qty_rcvd + pod_qty_chg / pod_um_conv.
/*G2M4*/        pod_cum_qty[1] = pod_cum_qty[1] + pod_qty_chg / pod_um_conv.
/*G2M4*/    end. /* IF USE_POD_UM_CONV */
/*G2M4*/    else do:
                pod_qty_rcvd = pod_qty_rcvd + pod_qty_chg * pod_rum_conv.
                pod_cum_qty[1] = pod_cum_qty[1] + pod_qty_chg * pod_rum_conv.
/*G2M4*/    end. /* ELSE DO */
/*GO37*/ end.


/*GO37*/ if is-return and pod_qty_chg <> 0 then pod_status = "".

/*GO56 /*GO37*/ if is-return and replace then do:*/
/*GO56*/ if is-return and replace and not pod_sched then do:
/*GO37*/    po_recno = recid(po_mstr).
/*GO37*/    pod_recno = recid(pod_det).
/*G2M4**
 * /*GO37*/    {gprun.i ""porvisc.p""} /* Add new pod to receive replacement */
 *G2M4**/
/*G2M4*/    /* ADDED INPUT PARAMETER use_pod_um_conv TO HANDLE ROUNDING ERROR */
/*G2M4*/    {gprun.i ""porvisc.p"" "(input use_pod_um_conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GO37*/ end.

         if pod_sched then do:
            {gprun.i ""rsmrw.p""
               "(input pod_nbr, input pod_line, input no)"
            }
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

/*F0BJ** if pod_blanket <> "" then do for poddet: **/
/*F0BJ*/ if pod_blanket <> "" and not is-return then do for poddet:

            find poddet where poddet.pod_nbr  = pod_det.pod_blanket
            and poddet.pod_line = pod_det.pod_blnkt_ln no-error.
            if available poddet then do:

/*G0TP* * * UPDT_BLNKT_LIST IS A COMMA SEPARATED LIST OF ALL POD_LINE     *
 *          NUMBERS WHICH MUST HAVE THE BLANK PO RELEASE QUANTITY UPDATED *
 *G0TP*/

/*G0TP*/       if can-do(updt_blnkt_list,string(poddet.pod_line)) then
/*G0TP*/         updt_blnkt = yes.
/*G0TP*/         else updt_blnkt = no.

/*GB35*/       if updt_blnkt then do for pomstr:

/*GO37*/          /* FLIP THE SIGN FOR RETURNS */
/*GO37*/          if is-return then
/*GO37*/             pod_det.pod_qty_chg = - pod_det.pod_qty_chg.

/*GB35*/          find pomstr where pomstr.po_nbr = pod_det.pod_blanket.

                  /* Increase blanket released qty by qty overreceived */
/*F0BJ*******************************
 *GB35*           if poddet.pod_um_conv = pod_det.pod_um_conv then
 *GB35*              poddet.pod_rel_qty = poddet.pod_rel_qty
 *GB35*                 + ((pod_det.pod_qty_chg * pod_det.pod_rum_conv)
 *GB35*                 - pod_det.pod_qty_ord).
 *GB35*           else
 *GB35*              poddet.pod_rel_qty = poddet.pod_rel_qty
 *GB35*                 + ((pod_det.pod_qty_chg * pod_det.pod_rum_conv
 *GB35*                     / poddet.pod_um_conv)
 *GB35*                 - pod_det.pod_qty_ord).
 **F0BJ******/
/*F0BJ*/          /* Qty overreceived is the larger of this receipt  */
/*F0BJ*/          /* and the total amount overreceived on this line. */
/*F0BJ*/          over_qty = pod_det.pod_qty_chg * pod_det.pod_rum_conv.
/*F0BJ*/          if poddet.pod_um_conv <> pod_det.pod_um_conv then
/*F0BJ*/             over_qty = over_qty / poddet.pod_rum_conv.
/*F0BJ*/          if over_qty > 0 then over_qty =
/*F0BJ*/             min(over_qty, pod_det.pod_qty_rcvd - pod_det.pod_qty_ord).
/*F0BJ*/          else over_qty =
/*F0BJ*/             max(over_qty, pod_det.pod_qty_rcvd - pod_det.pod_qty_ord).
/*F0BJ*/          poddet.pod_rel_qty = poddet.pod_rel_qty + over_qty.

/*GB35*/          if pomstr.po_recur
/*GB35*/          then poddet.pod_qty_chg =
/*GB35*/             min((poddet.pod_qty_ord - poddet.pod_rel_qty),
/*GB35*/                  poddet.pod_qty_chg).
/*GB35*/          if pomstr.po_recur = false
/*GB35*/             or (poddet.pod_qty_ord - poddet.pod_rel_qty <= 0 )
/*GB35*/          then poddet.pod_qty_chg = 0.
/*GB35*/

/*GB35*/          if (poddet.pod_qty_ord - poddet.pod_rel_qty <= 0)
/*GB35*/             then poddet.pod_status = "C".

/*GB35*/          /* Close Blanket PO if all lines released */
/*GB35*/          find first poddet where poddet.pod_nbr = pod_det.pod_blanket
/*GB35*/          and poddet.pod_status = "" no-lock no-error.
/*GB35*/          if not available poddet then do:
/*GB35*/             pomstr.po_cls_date = today.
/*GB35*/             pomstr.po_stat = "C".
/*GB35*/          end.

/*GO37*/          /* RESTORE THE SIGN FOR RETURNS */
/*GO37*/          if is-return then
/*GO37*/             pod_det.pod_qty_chg = - pod_det.pod_qty_chg.

/*GB35*/       end. /* if updt_blnkt */

/*GB35*/       find poddet where poddet.pod_nbr  = pod_det.pod_blanket
/*GB35*/       and poddet.pod_line = pod_det.pod_blnkt_ln no-error.

               if poddet.pod_um_conv = pod_det.pod_um_conv then
                  poddet.pod_qty_rcvd = poddet.pod_qty_rcvd
                                      + pod_det.pod_qty_chg
                                      * pod_det.pod_rum_conv.
               else
                  poddet.pod_qty_rcvd = poddet.pod_qty_rcvd
                                      + pod_det.pod_qty_chg
                                      * pod_det.pod_rum_conv
                                      * pod_det.pod_um_conv
                                      / poddet.pod_um_conv.
            end.

/*GO37*/    /* Update the blanket order in the remote database */
/*G2G3*/       old_db = global_db.

/*G2M7*/    if available poddet and pod_po_db <> "" and
/*G2M7*/    pod_po_db <> global_db then do:
/*G2M7** /*GO37*/ if pod_po_db <> "" and pod_po_db <> global_db then do: */

/*GO37*/       new_db = pod_po_db.
/*GO37*/       {gprun.i ""gpaliasd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GO37*/       {gprun.i ""poporcb3.p""
                 "(pod_det.pod_blanket, pod_det.pod_blnkt_ln, updt_blnkt,
                   poddet.pod_rel_qty, poddet.pod_qty_chg, poddet.pod_qty_rcvd)"
               }
/*GUI*/ if global-beam-me-up then undo, leave.

/*GO37*/       new_db = old_db.
/*GO37*/       {gprun.i ""gpaliasd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GO37*/    end.

         end.

         if not pod_sched then do:
            if (pod_qty_ord - pod_qty_rcvd) / pod_qty_ord <= 0
            or pod_qty_ord = 0 then pod_status = "c".

            if  pod_bo_chg = 0
                and (pod_qty_ord - pod_qty_rcvd) / pod_qty_ord > 0
                and old_status    <> "c"
                and old_status    <> "x"
                and pod_rma_type  <>  "O"
                and pod_rma_type  <>  "I"
/*GO37*/        and ( not is-return )
            then pod_status = "x".
         end.

/*H082*/ /* UPDATE MRP AND TRANSACTION HISTORY */
/*H082*/ /* code moved to poporcb5.p due to r code size */
/*H082*/ {gprun.i ""poporcb5.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


         /* RESET TEMPORARY VARIABLES */
         assign pod_qty_chg = 0
                pod_bo_chg = 0
                pod_ps_chg = 0
                pod_cost_chg = 0
                pod_rum = ""
                pod_rum_conv = 1.
