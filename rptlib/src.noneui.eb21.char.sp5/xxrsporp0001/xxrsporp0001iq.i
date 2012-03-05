/* rspoiq.i - Release Management Supplier Schedules                         */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.24 $                                                         */
/* SCHEDULE ORDER INQUIRY INCLUDE                                             */
/* REVISION: 7.3    LAST MODIFIED: 09/30/92           BY: WUG *G462*        */
/* REVISION: 7.3    LAST MODIFIED: 05/24/93           BY: WUG *GB29*        */
/* REVISION: 7.3    LAST MODIFIED: 06/11/93           BY: WUG *GB74*        */
/* REVISION: 7.3    LAST MODIFIED: 06/24/93           BY: WUG *GC68*        */
/* REVISION: 7.3    LAST MODIFIED: 07/13/93           BY: WUG *GD42*        */
/* REVISION: 7.3    LAST MODIFIED: 07/13/93           BY: WUG *GD43*        */
/* REVISION: 7.3    LAST MODIFIED: 08/18/93           BY: WUG *GE32*        */
/* REVISION: 7.3    LAST MODIFIED: 06/10/94           BY: dpm *GK23*        */
/* REVISION: 7.3    LAST MODIFIED: 10/31/94           BY: WUG *GN76*        */
/* REVISION: 7.3    LAST MODIFIED: 11/07/94           BY: ljm *GO33*        */
/* REVISION: 7.5    LAST MODIFIED: 03/16/95           BY: dpm *J044*        */
/* REVISION: 7.3    LAST MODIFIED: 03/23/95           BY: bcm *G0J1*        */
/* REVISION: 7.4    LAST MODIFIED: 06/08/95           BY: dxk *G0PM*        */
/* REVISION: 7.4    LAST MODIFIED: 06/08/95           BY: dxk *GOPM*        */
/* REVISION: 7.4    LAST MODIFIED: 10/22/95           BY: vrn *G0YF*        */
/* REVISION: 7.4    LAST MODIFIED: 01/03/96           BY: kjm *G1HR*        */
/* REVISION: 8.5    LAST MODIFIED: 02/26/96     BY: *J0CV* Brandy J Ewing   */
/* REVISION: 8.5    LAST MODIFIED: 06/06/96     BY: *G1XN* Robin McCarthy   */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/98   BY: *L062* Steve Nugent     */
/* REVISION: 8.6E     LAST MODIFIED: 09/02/98   BY: *L08H* A. Shobha        */
/* REVISION: 9.0      LAST MODIFIED: 12/01/98   BY: *K1QY* Suresh Nayak     */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb              */
/* REVISION: 9.1      LAST MODIFIED: 08/28/00   BY: *N0P6* Arul Victoria    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.20     BY: Dan Herman      DATE: 05/24/02  ECO: *P018*  */
/* Revision: 1.21  BY: Patrick de Jong DATE: 07/04/02 ECO: *P086* */
/* Revision: 1.23  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* $Revision: 1.24 $  BY: Robin McCarthy      DATE: 08/11/05  ECO: *P2PJ* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Report                                                       */

/* SS - 090115.1 By: Bill Jiang */

define variable l_adg_module like mfc_logical no-undo.

/* SCHEDULE ORDER INQUIRY INCLUDE */

form
   pod__qad05 colon 38 label "Generate Ship Schedule From MRP"
   pod__qad07 colon 38 label "SDT Code"
   skip(2)
with frame pod3 side-labels width 80.

/* SS - 090115.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame pod3:handle).
*/
/* SS - 090115.1 - E */

program:
do:
   print_sch = (po_sch_mthd = ""
   or substring(po_sch_mthd,1,1) = "y"
      or po_sch_mthd = "p"
      or po_sch_mthd = "b").

   edi_sch = (po_sch_mthd = "e" or po_sch_mthd = "b"
      or substring(po_sch_mthd,2,1) = "y").
   fax_sch = substring(po_sch_mthd,3,1) = "y".

   form with frame prm.
   /* SS - 090115.1 - B */
   /*
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame prm:handle).
   display
      scx_po
      scx_line
      scx_part
      pod_vpart
      pod_um
      scx_shipfrom
      ad_name
      scx_shipto
   with frame prm.
   */
   CREATE ttxxrsporp0001.
   ASSIGN
      ttxxrsporp0001_scx_po = scx_po
      ttxxrsporp0001_scx_line = scx_line
      ttxxrsporp0001_scx_part = scx_part
      ttxxrsporp0001_pod_vpart = pod_vpart
      ttxxrsporp0001_pod_um = pod_um
      ttxxrsporp0001_scx_shipfrom = scx_shipfrom
      ttxxrsporp0001_ad_name = ad_name
      ttxxrsporp0001_scx_shipto = scx_shipto
      .
   /* SS - 090115.1 - E */

   {mfrpchk.i &warn=false &label=program}

   pocmmts = (po_cmtindx <> 0 or (new po_mstr and poc_hcmmts)).

   impexp = no.

   if can-find( first ie_mstr
       where ie_mstr.ie_domain = global_domain and  ie_type = "2" and ie_nbr =
       po_nbr ) then impexp = yes.

   form with frame po1.
   /* SS - 090115.1 - B */
   /*
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame po1:handle).
   display
      po_ap_acct
      po_ap_sub
      po_ap_cc
      po_shipvia
      po_taxable
      po_fob
      po_cr_terms
      po_buyer
      po_bill
      po_ship
      po_contact
      print_sch
      po_contract
      edi_sch
      fax_sch
      po_curr
      pocmmts
      po_site
      po_consignment
      impexp
   with frame po1.
   */
   ASSIGN
      ttxxrsporp0001_po_ap_acct = po_ap_acct
      ttxxrsporp0001_po_ap_sub = po_ap_sub
      ttxxrsporp0001_po_ap_cc = po_ap_cc
      ttxxrsporp0001_po_shipvia = po_shipvia
      ttxxrsporp0001_po_taxable = po_taxable
      ttxxrsporp0001_po_fob = po_fob
      ttxxrsporp0001_po_cr_terms = po_cr_terms
      ttxxrsporp0001_po_buyer = po_buyer
      ttxxrsporp0001_po_bill = po_bill
      ttxxrsporp0001_po_ship = po_ship
      ttxxrsporp0001_po_contact = po_contact
      ttxxrsporp0001_print_sch = print_sch
      ttxxrsporp0001_po_contract = po_contract
      ttxxrsporp0001_edi_sch = edi_sch
      ttxxrsporp0001_fax_sch = fax_sch
      ttxxrsporp0001_po_curr = po_curr
      ttxxrsporp0001_pocmmts = pocmmts
      ttxxrsporp0001_po_site = po_site
      ttxxrsporp0001_po_consignment = po_consignment
      ttxxrsporp0001_impexp = impexp
      .
   /* SS - 090115.1 - E */

   {mfrpchk.i &warn=false &label=program}

   /* SS - 090115.1 - B */
   /*
   if using_supplier_consignment and po_consignment then do:
      {pxrun.i &PROC='displayAgingDays'
               &PARAM="(input po_max_aging_days,
                        input po__qadc01)"}
      hide frame aging2.
      {mfrpchk.i &warn=false &label=program}
   end.

   hide frame po1.

   /* HEADER COMMENTS */
   if pocmmts then do:
      form
         cmt_cmmt[1] no-label
      with frame cmmts_data down width 80 attr-space
      title color normal (getFrameTitle("TRANSACTION_COMMENTS",78)).

      for each cmt_det no-lock  where cmt_det.cmt_domain = global_domain and
      cmt_indx = po_cmtindx:
         do i = 1 to 15:
            if cmt_cmmt[i] > "" then do:
               display cmt_cmmt[i] @ cmt_cmmt[1] with frame
                  cmmts_data.
               down 1 with frame cmmts_data.
               {mfrpchk.i &warn=false &label=program}
            end.
         end.
      end.

      hide frame cmmts_data.
   end.

   hide frame po1.
   */
   /* SS - 090115.1 - E */

   podcmmts = (pod_cmtindx <> 0 or (new pod_det and poc_lcmmts)).

   form with frame pod1.
   /* SS - 090115.1 - B */
   /*
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame pod1:handle).
   display
      pod_pr_list
      pod_cst_up
      pod_pur_cost
      pod_acct
      pod_sub
      pod_cc
      pod_loc
      pod_taxable
      pod_um
      pod_um_conv
      pod_type
      pod_consignment
      pod_wo_lot
      pod_op
      subtype
   with frame pod1.
   */
   ASSIGN
      ttxxrsporp0001_pod_pr_list = pod_pr_list
      ttxxrsporp0001_pod_cst_up = pod_cst_up
      ttxxrsporp0001_pod_pur_cost = pod_pur_cost
      ttxxrsporp0001_pod_acct = pod_acct
      ttxxrsporp0001_pod_sub = pod_sub
      ttxxrsporp0001_pod_cc = pod_cc
      ttxxrsporp0001_pod_loc = pod_loc
      ttxxrsporp0001_pod_taxable = pod_taxable
      ttxxrsporp0001_pod_um = pod_um
      ttxxrsporp0001_pod_um_conv = pod_um_conv
      ttxxrsporp0001_pod_type = pod_type
      ttxxrsporp0001_pod_consignment = pod_consignment
      ttxxrsporp0001_pod_wo_lot = pod_wo_lot
      ttxxrsporp0001_pod_op = pod_op
      ttxxrsporp0001_subtype = subtype
      .
   /* SS - 090115.1 - E */

   {mfrpchk.i &warn=false &label=program}

   /* SS - 090115.1 - B */
   /*
   /* DISPLAY ERS INFORMATION IF ERS PROCESSING IS ENABLED */
   if poc_ers_proc then do with frame pers:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame pers:handle).
      display
         pod_ers_opt   colon 15
         pod_pr_lst_tp colon 55
      with frame pers side-labels width 80 no-attr-space.

      hide frame pers.
      {mfrpchk.i &warn=false &label=program}
   end.

   if using_supplier_consignment and pod_consignment then do:
      {pxrun.i &PROC='displayAgingDays'
               &PARAM="(input pod_max_aging_days,
                        input po__qadc01)"}
      hide frame aging2.
      {mfrpchk.i &warn=false &label=program}
   end.

   hide frame pod1.
   */
   /* SS - 090115.1 - E */

   form with frame pod2.
   /* SS - 090115.1 - B */
   ASSIGN
      ttxxrsporp0001_pod_firm_days = pod_firm_days
      ttxxrsporp0001_pod_sd_pat = pod_sd_pat
      ttxxrsporp0001_pod_plan_days = pod_plan_days
      ttxxrsporp0001_pod_plan_weeks = pod_plan_weeks
      ttxxrsporp0001_pod_cum_qty[3] = pod_cum_qty[3]
      ttxxrsporp0001_pod_plan_mths = pod_plan_mths
      ttxxrsporp0001_pod_ord_mult = pod_ord_mult
      ttxxrsporp0001_pod_fab_days = pod_fab_days
      ttxxrsporp0001_pod_cum_date[1] = pod_cum_date[1]
      ttxxrsporp0001_pod_raw_days = pod_raw_days
      ttxxrsporp0001_podcmmts = podcmmts
      ttxxrsporp0001_pod_sftylt_days = pod_sftylt_days
      ttxxrsporp0001_pod_vpart = pod_vpart
      ttxxrsporp0001_pod_translt_days = pod_translt_days
      ttxxrsporp0001_pod_start_eff[1] = pod_start_eff[1]
      ttxxrsporp0001_pod_end_eff[1] = pod_end_eff[1]
      ttxxrsporp0001_pod_pkg_code = pod_pkg_code
      .
   /*
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame pod2:handle).
   display
      pod_firm_days
      pod_sd_pat
      pod_plan_days
      pod_plan_weeks
      pod_cum_qty[3]
      pod_plan_mths
      pod_ord_mult
      pod_fab_days
      pod_cum_date[1]
      pod_raw_days
      podcmmts
      pod_sftylt_days
      pod_vpart
      pod_translt_days
      pod_start_eff[1]
      pod_end_eff[1]
      pod_pkg_code
   with frame pod2.

   /* The flag on the control file rsc_ctrl and mfc_ctrl would always
   be maintained in sync. So we test the value of mfc_ctrl flag */

   l_adg_module = no.
   if can-find(first mfc_ctrl  where mfc_ctrl.mfc_domain = global_domain and
      mfc_field = "enable_shipping_schedules"
      and mfc_seq = 4 and mfc_module = "ADG"
      and mfc_logical = yes) then
      l_adg_module = yes.
   else
      l_adg_module = no.

   if l_adg_module then do:
      display
         pod__qad05
         pod__qad07
      with frame pod3.
   end. /* if l_adg_module */

   hide frame pod2.
   hide frame pod3.

   {mfrpchk.i &warn=false &label=program}

   /* LINE COMMENTS */
   if podcmmts then do:
      form
         cmt_cmmt[1] no-label
      with frame cmmts_data down width 80 attr-space
      title color normal (getFrameTitle("TRANSACTION_COMMENTS",78)).

      for each cmt_det no-lock  where cmt_det.cmt_domain = global_domain and
      cmt_indx = pod_cmtindx:
         do i = 1 to 15:
            if cmt_cmmt[i] > "" then do:
               display cmt_cmmt[i] @ cmt_cmmt[1] with frame
                  cmmts_data.
               down 1 with frame cmmts_data.
               {mfrpchk.i &warn=false &label=program}
            end.
         end.
      end.

      hide frame cmmts_data.
   end.

   page.
   */
   /* SS - 090115.1 - E */
end.
