/* rsiq1a.p - Release Management Supplier Schedules                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*F0PN*/ /*V8:ConvertMode=Report                                            */
/* REVISION: 7.0    LAST MODIFIED: 01/29/92           BY: WUG *F110*        */
/* REVISION: 7.0    LAST MODIFIED: 03/16/92           BY: WUG *F312*        */
/* REVISION: 7.0    LAST MODIFIED: 03/26/92           BY: WUG *F323*        */
/* REVISION: 7.0    LAST MODIFIED: 09/17/92           BY: WUG *G155*        */
/* REVISION: 7.3    LAST MODIFIED: 10/13/92           BY: WUG *G462*        */
/* REVISION: 7.3    LAST MODIFIED: 06/03/93           BY: WUG *GA75*        */
/* REVISION: 7.3    LAST MODIFIED: 07/14/93           BY: WUG *GD42*        */
/* REVISION: 7.4    LAST MODIFIED: 09/29/93           BY: WUG *H142*        */
/*                                 08/27/94           BY: bcm *GL63*        */
/*                                 10/19/94           BY: ljm *GN40*        */
/* REVISION: 7.3    LAST MODIFIED: 10/31/94           BY: qzl *GN75*        */
/* REVISION: 7.4    LAST MODIFIED: 04/28/95           BY: dpm *H0CX*        */
/* REVISION: 7.4    LAST MODIFIED: 09/16/95           BY: vrn *G0X9*        */
/* REVISION: 7.4    LAST MODIFIED: 10/22/95           BY: vrn *G0YF*        */
/* REVISION: 7.4    LAST MODIFIED: 11/13/95           BY: vrn *G1CP*        */
/* REVISION: 8.5    LAST MODIFIED: 02/28/96     BY: *J0CV* Brandy J Ewing   */
/* REVISION: 8.6    LAST MODIFIED: 10/08/97           BY:       GYK *K0MZ*  */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/29/98   BY: *K1RD* A. Shobha */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/98   BY: *L062* Steve Nugent */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.0      LAST MODIFIED: 12/01/98   BY: *K1QY* Pat McCormick    */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 05/12/00   BY: *N09X* Antony Babu      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb              */
/* REVISION: 9.1      LAST MODIFIED: 08/28/00   BY: *N0P6* Arul Victoria   */
/* $Revision: 1.25 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* $Revision: 1.25 $ BY: Bill Jiang DATE: 08/07/08 ECO: *SS - 20080807.1* */
/*-Revision end---------------------------------------------------------------*/

/* REPORT/INQUIRY DISPLAY SUBPROGRAM */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* SS - 20080807.1 - B */
{ssrsrp010001.i}
/* SS - 20080807.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rsiq1a_p_4 "Active End"
/* MaxLen: Comment: */

&SCOPED-DEFINE rsiq1a_p_5 "Active Start"
/* MaxLen: Comment: */

&SCOPED-DEFINE rsiq1a_p_6 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE rsiq1a_p_10 "Subcontract Type"
/* MaxLen: Comment: */

/*N09X**  -------------- BEGIN - COMMENT ----------------------------
* &SCOPED-DEFINE rsiq1a_p_1 "Required Quantities"
* /* MaxLen: Comment: */
*
* &SCOPED-DEFINE rsiq1a_p_2 "Cum Required Quantities"
* /* MaxLen: Comment: */
*
* &SCOPED-DEFINE rsiq1a_p_3 "Net Required Quantities"
* /* MaxLen: Comment: */
*
* &SCOPED-DEFINE rsiq1a_p_7 " Transaction Comments "
* /* MaxLen: Comment: */
*
* &SCOPED-DEFINE rsiq1a_p_9 " Schedule Detail Data "
* /* MaxLen: Comment: */
*
* &SCOPED-DEFINE rsiq1a_p_11 " Planning Detail Data "
* /* MaxLen: Comment: */
*
* &SCOPED-DEFINE rsiq1a_p_12 " Shipping Detail Data "
* /* MaxLen: Comment: */
*
**N09X**  -------------- END - COMMENT ----------------------------*/
/* ********** End Translatable Strings Definitions ********* */

/*N0P6* ------------------- BEGIN DELETE ----------------------- *
 * &SCOPED-DEFINE rsiq1a_p_8 " Resource Authorization Data "
 * /* MaxLen: Comment: */
 *N0P6* ------------------- END   DELETE ----------------------- */

/*K1RD /*K0MZ*/ {wbrp02.i}*/

define input parameter schtype like sch_type.
define input parameter schnbr like sch_nbr.
define input parameter schline like sch_line.
define input parameter schrlseid like sch_rlse_id.
define input parameter show_net_req like mfc_logical.
/*J0CV*/ define input parameter show_ers as logical no-undo.

define variable disp_qty like schd_upd_qty.
define variable prior_disp_qty like sch_pcr_qty.
/*N09X**  -------------- BEGIN - COMMENT ----------------------------
* define variable detail_frame_titles as character extent 3
*    initial [
*    {&rsiq1a_p_3},
*    {&rsiq1a_p_2},
*    {&rsiq1a_p_1}].
**N09X**  -------------- END - COMMENT ----------------------------*/
/*N09X*/ define variable detail_frame_titles as character extent 3 no-undo.

define variable detail_frame_title as character.
/*H0CX*/ define variable impexp   like mfc_logical no-undo.
/*H0CX*/ define variable impexp_label as character format "x(8)" no-undo.
/*H0CX*/ define variable ietype   as character no-undo.
/*L062*/ define variable subtype  as character format "x(12)"
        label {&rsiq1a_p_10} no-undo.
/*K1QY*/ define variable detail_frm_title as character no-undo.

/*N09X*/ assign
      detail_frame_titles[1] = getFrameTitle("NET_REQUIRED_QUANTITIES",32)
          detail_frame_titles[2] = getFrameTitle("CUM_REQUIRED_QUANTITIES",32)
      detail_frame_titles[3] = getFrameTitle("REQUIRED_QUANTITIES",27).


{rsordfrm.i}

define variable cmmts like poc_hcmmts label {&rsiq1a_p_6}.
define variable i as integer.

form
   cmt_cmmt[1] no-label
with frame cmmts_data down width 80 attr-space
/*N0P6*    title color normal (getFrameTitle("TRANSACTION_COMMENTS",29)).  */
/*N0P6*/   title color normal (getFrameTitle("TRANSACTION_COMMENTS",78)).

/*N0P6* ------------------- BEGIN DELETE ----------------------- *
 *         /* SET EXTERNAL LABELS */
 *         setFrameLabels(frame cmmts_data:handle).
 *N0P6* ------------------- END   DELETE ----------------------- */

program:
/*GN75* do: */
/*GN75*/ do on endkey undo, leave program:
   find sch_mstr  where sch_mstr.sch_domain = global_domain and  sch_type =
   schtype
   and sch_nbr = schnbr
   and sch_line = schline
   and sch_rlse_id = schrlseid
   no-lock.

   find po_mstr  where po_mstr.po_domain = global_domain and  po_nbr = sch_nbr
   no-lock.
   find pod_det  where pod_det.pod_domain = global_domain and  pod_nbr =
   sch_nbr and pod_line = sch_line no-lock.
   find scx_ref  where scx_ref.scx_domain = global_domain and  scx_type = 2 and
   scx_order = pod_nbr
   and scx_line = pod_line no-lock.
   find si_mstr  where si_mstr.si_domain = global_domain and  si_site =
   scx_shipto no-lock.
   find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
   scx_shipfrom no-lock.
   find vd_mstr  where vd_mstr.vd_domain = global_domain and  vd_addr = po_vend
   no-lock.
   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
   scx_part no-lock.

   if show_net_req then detail_frame_title = detail_frame_titles[1].
   else
   if sch_cumulative then detail_frame_title = detail_frame_titles[2].
   else detail_frame_title = detail_frame_titles[3].

   cmmts = sch_cmtindx > 0.

   form
/*GN40*/ /*V8! scx_shipfrom
               scx_shipto
               ad_name
               scx_part
               pod_vpart
               pod_um
               scx_po space(1) */
/*G0X9*        sch_rlse_id format "x(24)" */
/*G1CP* /*G0X9*/ sch_rlse_id */
/*G1CP*/       sch_rlse_id colon 16
/*GN40*/ /*V8! scx_line skip(.4) */
/*G0YF*  with frame a. */
/*G0YF*/ with frame prm width 80.

   /* SS - 20080807.1 - B */
   /*
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame prm:handle).
   */
   /* SS - 20080807.1 - E */
/*K0MZ*
   disp
   scx_shipfrom
   scx_shipto
   ad_name
   scx_part
   pod_vpart
   pod_um
   /*GD42*/
   scx_po
   sch_rlse_id
   scx_line
/*G0YF*  with frame a. */
/*G0YF*/ with frame prm.
*/
   /* SS - 20080807.1 - B */
   /*
/*K0MZ*/ display
         scx_shipfrom
         scx_shipto
         ad_name
         scx_part
         pod_vpart
         pod_um                               /*GD42*/
         scx_po
         sch_rlse_id
         scx_line
         with frame prm.
   */
   /* SS - 20080807.1 - E */

   /*GL63** title "Supplier Schedule" + " - " + detail_frame_title. **/

   {mfrpchk.i &warn=false &label=program}

/*J0CV*/ /* DISPLAY ERS INFORMATION ONLY IF ERS IS ENABLED */
/*J0CV*/ if show_ers and can-find(first poc_ctrl  where poc_ctrl.poc_domain =
global_domain and  poc_ers_proc = yes)
/*J0CV*/ then do with frame pers:
   /* SS - 20080807.1 - B */
   /*
            /* SET EXTERNAL LABELS */
            setFrameLabels(frame pers:handle).
/*J0CV*/    display
/*J0CV*/       pod_ers_opt   colon 16
/*J0CV*/       pod_pr_lst_tp colon 68
/*J0CV*/    with frame pers side-labels width 80 no-attr-space.
   */
   /* SS - 20080807.1 - E */

/*J0CV*/    {mfrpchk.i &warn=false &label=program}
/*J0CV*/ end.

   if show_net_req then prior_disp_qty = max(sch_pcr_qty - pod_cum_qty[1],0).
   else prior_disp_qty = sch_pcr_qty.
/*K0MZ*
   disp
   cmmts          colon 20
   sch_cr_date    colon 55
   string(sch_cr_time,"HH:MM:SS") format "x(8)" @
   sch_cr_time    no-label
   prior_disp_qty colon 20
   sch_eff_start  colon 55 label "Active Start"
   sch_pcs_date   colon 20
   sch_eff_end    colon 55 label "Active End"
   with frame sched1_data attr-space side-labels width 80.
*K0MZ*/
   /* SS - 20080807.1 - B */
   /*
/*K0MZ*/ display
        cmmts          colon 20
        sch_cr_date    colon 55
        string(sch_cr_time,"HH:MM:SS") format "x(8)" @
        sch_cr_time    no-label
        prior_disp_qty colon 20
        sch_eff_start  colon 55 label {&rsiq1a_p_5}
        sch_pcs_date   colon 20
        sch_eff_end    colon 55 label {&rsiq1a_p_4}
        with frame sched1_data attr-space side-labels width 80.
        /* SET EXTERNAL LABELS */
        setFrameLabels(frame sched1_data:handle).
  {mfrpchk.i &warn=false &label=program}

   hide frame sched1_data.

   clear frame cmmts_data all no-pause.

   for each cmt_det no-lock  where cmt_det.cmt_domain = global_domain and
   cmt_indx = sch_cmtindx:
      do i = 1 to 15:
         if cmt_cmmt[i] > "" then do:
         /*K0MZ*
            disp cmt_cmmt[i] @ cmt_cmmt[1] with frame cmmts_data.
          *K0MZ*/
          /*K0MZ*/ display cmt_cmmt[i] @ cmt_cmmt[1] with frame cmmts_data.
            down 1 with frame cmmts_data.
            {mfrpchk.i &warn=false &label=program}
         end.
      end.
   end.

   hide frame cmmts_data.

/*G0YF* hide frame a. */
/*G0YF*/ hide frame prm.

   clear frame schd1d all no-pause.
   */
   /* SS - 20080807.1 - E */

   for each schd_det no-lock
    where schd_det.schd_domain = global_domain and  schd_type = sch_type
   and schd_nbr = sch_nbr
   and schd_line = sch_line
   and schd_rlse_id = sch_rlse_id
   break by schd_date:
      cmmts = schd_cmtindx > 0.

      if show_net_req then do:
         disp_qty =
         max(min(schd_discr_qty, schd_cum_qty - pod_cum_qty[1]),0).
      end.
      else
      if sch_cumulative then disp_qty = schd_cum_qty.
      else disp_qty = schd_discr_qty.

/*N09X**  -------------- BEGIN - COMMENT ----------------------------
* /*K1QY*/ if schtype = 5 then detail_frm_title = {&rsiq1a_p_11}.
* /*K1QY*/ else if schtype = 6 then detail_frm_title = {&rsiq1a_p_12}.
* /*K1QY*/ else detail_frm_title = {&rsiq1a_p_9}.
**N09X**  -------------- END - COMMENT ----------------------------*/
/*N09X** -------------- BEGIN - ADD CODE  ------------------------*/
         if schtype = 5 then
        detail_frm_title = getFrameTitle("PLANNING_DETAIL_DATA",28).
         else if schtype = 6 then
        detail_frm_title = getFrameTitle("SHIPPING_DETAIL_DATA",28).
         else detail_frm_title = getFrameTitle("SCHEDULE_DETAIL_DATA",28).
/*N09X** -------------- END - ADD CODE ---------------------------*/

      form
         space(5)
         schd_date
         schd_time
/*K1QY*/ schd_interval
         schd_reference
         disp_qty
         schd_fc_qual
      with frame schd1d down attr-space width 80
/*K1QY** title color normal {&rsiq1a_p_9}. */
/*K1QY*/ title color normal detail_frm_title.

      /* SS - 20080807.1 - B */
      /*
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame schd1d:handle).
/*K0MZ*
      disp
      schd_date
      schd_time
      schd_reference
      disp_qty
      schd_fc_qual
      with frame schd1d.
*K0MZ*/
/*K0MZ*/ display
          schd_date
          schd_time
/*K1QY*/  schd_interval
          schd_reference
          disp_qty
          schd_fc_qual
          with frame schd1d.

      down 1 with frame schd1d.
      */
      CREATE ttssrsrp010001.
      ASSIGN
         ttssrsrp010001_scx_po = scx_po
         ttssrsrp010001_scx_line = scx_line
         ttssrsrp010001_scx_part = scx_part
         ttssrsrp010001_pod_vpart = pod_vpart
         ttssrsrp010001_pod_um = pod_um
         ttssrsrp010001_scx_shipfrom = scx_shipfrom
         ttssrsrp010001_ad_name = ad_name
         ttssrsrp010001_scx_shipto = scx_shipto
         ttssrsrp010001_sch_rlse_id = sch_rlse_id

         ttssrsrp010001_cmmts = cmmts
         ttssrsrp010001_sch_cr_date = sch_cr_date
         ttssrsrp010001_sch_cr_time = sch_cr_time
         ttssrsrp010001_prior_disp_qty = prior_disp_qty 
         ttssrsrp010001_sch_eff_start  = sch_eff_start
         ttssrsrp010001_sch_pcs_date = sch_pcs_date
         ttssrsrp010001_sch_eff_end = sch_eff_end

         ttssrsrp010001_schd_date = schd_date
         ttssrsrp010001_schd_time = schd_time
         ttssrsrp010001_schd_interval = schd_interval
         ttssrsrp010001_schd_reference = schd_reference
         ttssrsrp010001_disp_qty = disp_qty
         ttssrsrp010001_schd_fc_qual = schd_fc_qual

         ttssrsrp010001_scx_order = scx_order
         ttssrsrp010001_po_buyer = po_buyer
         .
      /* SS - 20080807.1 - E */
      {mfrpchk.i &warn=false &label=program}

      /* SS - 20080807.1 - B */
      /*
      if schd_cmtindx > 0 then do:
         clear frame cmmts_data all no-pause.

         for each cmt_det no-lock  where cmt_det.cmt_domain = global_domain and
          cmt_indx = schd_cmtindx:
            do i = 1 to 15:
               if cmt_cmmt[i] > "" then do:
               /*K0MZ*
                  disp cmt_cmmt[i] @ cmt_cmmt[1] with frame cmmts_data.
                *K0MZ*/
                /*K0MZ*/ display cmt_cmmt[i] @ cmt_cmmt[1] with frame cmmts_data.
                  down 1 with frame cmmts_data.
                  {mfrpchk.i &warn=false &label=program}
               end.
            end.
         end.

         hide frame cmmts_data.
      end.
      */
      /* SS - 20080807.1 - E */
   end.

   /* SS - 20080807.1 - B */
   /*
   hide frame schd1d.

/*G0YF*
.   form
.      sch_fab_qty       colon 15
./*G0K2*/ sch_fab_strt /*V8! colon 39 */
./*G0K2*/ sch_fab_end  /*V8! colon 60 skip(1) */
.      sch_raw_qty       colon 15
./*G0K2*/ sch_raw_strt /*V8! colon 39 */
./*G0K2*/ sch_raw_end  /*V8! colon 60 skip(1) */
./*H0CX* with frame res_auth_data width 80 title "Resource Authorization Data"*/
./*H0CX*/  with frame res_auth_data width 80
./*H0CX*/  title color normal " Resource Authorization Data "
.   attr-space side-labels
./*G0K2*/ /* /*GN40*/ /*V8! font 0 */ */  .
.*G0YF*/

/*G0YF* Entire form defined afresh */
   form
      sch_fab_qty       colon 15
      sch_fab_strt      colon 40
      sch_fab_end       colon 61 skip
      sch_raw_qty       colon 15
      sch_raw_strt      colon 40
      sch_raw_end       colon 61 skip
      /*V8! skip(.4) */
   with frame res_auth_data width 80 title color normal
        (getFrameTitle("RESOURCE_AUTHORIZATION_DATA",38)) attr-space
        side-labels.
/*K0MZ*
   disp
   sch_fab_qty
   sch_fab_strt
   sch_fab_end
   sch_raw_qty
   sch_raw_strt
   sch_raw_end
   with frame res_auth_data.
*K0MZ*/

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame res_auth_data:handle).
/*K1QY*/ if schtype <> 6 then
/*K0MZ*/ display
         sch_fab_qty
         sch_fab_strt
         sch_fab_end
         sch_raw_qty
         sch_raw_strt
         sch_raw_end
         with frame res_auth_data.

   {mfrpchk.i &warn=false &label=program}

   hide frame res_auth_data.
   page.
   */
   /* SS - 20080807.1 - E */
end.

/* SS - 20080807.1 - B */
/*
/*G0YF* /*GN75*/ if keyfunction(lastkey) = "END-ERROR" then hide frame a no-pause. */
/*G0YF*/ if keyfunction(lastkey) = "END-ERROR" then hide frame prm no-pause.
/*K1RD /*K0MZ*/ {wbrp04.i} */
*/
/* SS - 20080807.1 - E */
