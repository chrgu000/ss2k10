/* rqpobldd.p - Requisition To PO -- Line Items subroutine                    */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13.1.40.2.2 $                                                     */
/*V8:ConvertMode=Report                                                       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* REVISION 8.5       LAST MODIFIED: 04/15/97  BY: *J1Q2* Patrick Rowan       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98  BY: *L007* Annasaheb Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98  BY: *L00Y* Jeff Wootton        */
/* REVISION: 8.6E     LAST MODIFIED: 06/22/98  BY: *J2QB* Bill Gates          */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98  BY: *L040* Brenda Milton       */
/* REVISION: 8.5      LAST MODIFIED: 09/02/98  BY: *J2YD* Patrick Rowan       */
/* REVISION: 8.6E     LAST MODIFIED: 10/28/98  BY: *J30R* Patrick Rowan       */
/* REVISION: 8.6E     LAST MODIFIED: 03/30/99  BY: *K203* Anup Pereira        */
/* REVISION: 8.6E     LAST MODIFIED: 07/27/99  BY: *J3HN* Reetu Kapoor        */
/* REVISION: 9.1      LAST MODIFIED: 08/02/99  BY: *N014* Robin McCarthy      */
/* REVISION: 9.1      LAST MODIFIED: 12/20/99  BY: *K24R* Abhijeet Thakur     */
/* REVISION: 9.1      LAST MODIFIED: 12/21/99  BY: *K24T* Manish Kulkarni     */
/* REVISION: 9.1      LAST MODIFIED: 01/28/00  BY: *K253* Sandeep Rao         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00  BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1      LAST MODIFIED: 09/04/00  BY: *N0RC* Mark Brown          */
/* Revision: 1.13.1.13     BY: Niranjan Ranka      DATE: 04/10/01 ECO: *P00L* */
/* Revision: 1.13.1.14     BY: Tiziana Giustozzi   DATE: 07/05/01 ECO: *N104* */
/* Revision: 1.13.1.15     BY: Rajesh Kini         DATE: 08/13/01 ECO: *M1HF* */
/* Revision: 1.13.1.17     BY: Mugdha Tambe        DATE: 09/20/01 ECO: *P012* */
/* Revision: 1.13.1.18     BY: Steve Nugent        DATE: 05/24/02 ECO: *P018* */
/* Revision: 1.13.1.19     BY: Tiziana Giustozzi   DATE: 05/24/02 ECO: *P03Z* */
/* Revision: 1.13.1.20     BY: Dan Herman          DATE: 06/06/02 ECO: *P07Y* */
/* Revision: 1.13.1.23     BY: Tiziana Giustozzi   DATE: 06/20/02 ECO: *P093* */
/* Revision: 1.13.1.24     BY: Robin McCarthy      DATE: 07/15/02 ECO: *P0BJ* */
/* Revision: 1.13.1.26     BY: Manisha Sawant      DATE: 12/05/02 ECO: *N219* */
/* Revision: 1.13.1.27     BY: Katie Hilbert       DATE: 03/19/03 ECO: *P0NL* */
/* Revision: 1.13.1.29     BY: Paul Donnelly (SB)  DATE: 06/28/03 ECO: *Q00L* */
/* Revision: 1.13.1.30     BY: Rajiv Ramaiah       DATE: 09/19/03 ECO: *P13K* */
/* Revision: 1.13.1.31     BY: Katie Hilbert       DATE: 11/20/03 ECO: *N2N5* */
/* Revision: 1.13.1.32     BY: Deepak Rao          DATE: 01/23/04 ECO: *P1KV* */
/* Revision: 1.13.1.33     BY: Veena Lad           DATE: 02/27/04 ECO: *N2PY* */
/* Revision: 1.13.1.34     BY: Shivaraman V.       DATE: 04/20/04 ECO: *P1YC* */
/* Revision: 1.13.1.35     BY: Anitha Gopal        DATE: 04/24/04 ECO: *P235* */
/* Revision: 1.13.1.36     BY: Vivek Gogte         DATE: 07/07/04 ECO: *P28H* */
/* Revision: 1.13.1.38     BY: Manjusha Inglay     DATE: 10/08/04 ECO: *P2NN* */
/* Revision: 1.13.1.39     BY: Abhishek Jha        DATE: 01/05/05 ECO: *P32G* */
/* Revision: 1.13.1.40     BY: Bhavik Rathod       DATE: 01/28/05 ECO: *P35L* */
/* Revision: 1.13.1.40.2.1 BY: Reena Ambavi        DATE: 06/28/05 ECO: *P3QY* */
/* $Revision: 1.13.1.40.2.2 $   BY: Somesh Jeswani      DATE: 08/03/05 ECO: *P3WK* */


/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/01/16  ECO: *xp003*  */
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/03/28  ECO: *xp004*  */ 
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/06/13  ECO: *xp005*  */ /*C��ͷ���빺��,Ĭ����1.19��λ,����������1.4.16��λ;��C��ͷ���빺��,Ĭ����1.4.16��λ*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/07/28  ECO: *xp006*  */ /*C��ͷ��PR,�ұ�ȡ��ϸ�й�Ӧ�̵ıұ�*/
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
 ----------------------------------------------------------------------------
 DESCRIPTION: Populates purchase order header information.
              Supports the multi-line Purchase Requisition Module of MFG/PRO.

 Notes:
1) Similar to popomta.p, thru eco H0V3.
============================================================================
!*/
{mfdeclre.i}
{gplabel.i}    /* EXTERNAL LABEL INCLUDE */
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */
{pxmaint.i}    /* STANDARD MAINTENANCE COMPONENT INCLUDE FILE */

/* INPUT PARAMETERS */
define input parameter using_consignment like mfc_logical no-undo.

/* LOGICALS */
define variable rqpo_ok                like mfc_logical no-undo.
define variable c-consigment-contract  as character format "x(40)" no-undo.
/* CONSTANTS */
{rqconst.i}

{pocnpo.i}  /* Consignment procedures and frames */

/* SHARED VARIABLES */
{rqpovars.i}

/* POPOMTEA.P VARIABLES */
define variable l_pl_acc               like pl_pur_acct  no-undo.
define variable l_pl_sub               like pl_pur_sub   no-undo.
define variable l_pl_cc                like pl_pur_cc    no-undo.
define variable l_pt_ins               like pt_insp_rqd  no-undo.
define variable l_pt_loc               like pt_loc       no-undo.
define variable l_pt_rev               like pt_rev       no-undo.

/* POPOMTC.P VARIABLES */
define variable line_db                like si_db        no-undo.
define variable openqty                like mrp_qty      no-undo.

/* POPOMTA.P VARIABLES */
define shared variable rndmthd            like rnd_rnd_mthd.
define new shared variable ext_cost_fmt   as character.

define new shared variable desc1          like pt_desc1.
define new shared variable desc2          like pt_desc2.
define new shared variable qty_ord        like pod_qty_ord.
define new shared variable old_qty_ord    like pod_qty_ord.
define new shared variable old_pod_status like pod_status.
define new shared variable old_type       like pod_type.
define new shared variable pod_recno      as recid.
define new shared variable podcmmts       like mfc_logical label "Comments".
define new shared variable cmtindx        as integer.
define new shared variable ext_cost       like pod_pur_cost.
define new shared variable mfgr           like vp_mfgr.
define new shared variable mfgr_part      like vp_mfgr_part.
define new shared variable req_ok         like mfc_logical.
define new shared variable continue       like mfc_logical.
define new shared variable st_qty         like pod_qty_ord.
define new shared variable st_um          like pod_um.
define new shared variable old_um         like pod_um.
define new shared variable clines         as integer initial ?.
define new shared variable podnbr         like pod_nbr.
define new shared variable podline        like pod_line.
define new shared variable podreqnbr      like pod_req_nbr.
define new shared variable old_pod_site   like pod_site.
define new shared variable new_pod        like mfc_logical.
define new shared variable pcqty          like pod_qty_ord.
define new shared variable base_cost      like pod_pur_cost.
define new shared variable poc_pt_req     like mfc_logical.
define new shared variable match_pt_um    like mfc_logical initial no.

define new shared frame chead.
define new shared frame c.
define new shared frame d.

define shared variable line               like sod_line.
define shared variable due_date           like pod_due_date.
define shared variable del-yn             like mfc_logical.
define shared variable so_job             like pod_so_job.
define shared variable disc               like pod_disc_pct.
define shared variable po_recno           as recid.
define shared variable vd_recno           as recid.
define shared variable sngl_ln            like poc_ln_fmt.
define shared variable tax_in             like ad_tax_in.
define shared variable base_amt           like pod_pur_cost.
define shared variable blanket            like mfc_logical.
define shared variable new_db             like si_db.
define shared variable old_db             like si_db.
define shared variable new_site           like si_site.
define shared variable old_site           like si_site.
define shared variable pocrt_int          like pod_crt_int.
define shared variable line_opened        as logical.
define shared variable impexp             like mfc_logical no-undo.

/* VARIABLES */
define variable var_disc_pct           like pod_disc_pct no-undo.
define variable var_vend_pur_cost      like pod_pur_cost no-undo.
define variable var_pt_pur_cost        like pod_pur_cost no-undo.
define variable var_pur_cost           like pod_pur_cost no-undo.
define variable var_req_cost           like pod_pur_cost no-undo.
define variable var_requm              like pod_um   no-undo.
define variable dftPURAcct             like pod_acct no-undo.
define variable dftPURSubAcct          like pod_sub  no-undo.
define variable dftPURCostCenter       like pod_cc   no-undo.
define variable var_acct               like pod_acct no-undo.
define variable var_sub                like pod_sub  no-undo.
define variable var_cc                 like pod_cc   no-undo.
define variable var_um                 like pod_um   no-undo.
define variable var_um_conv            like pod_um_conv no-undo.
define variable var_net_qty            like pod_qty_ord no-undo.
define variable errcd                  as integer no-undo.
define variable old_pur_cost           like pod_pur_cost.
define variable old_vpart              like pod_vpart.
define variable last_date              like pod_due_date.
define variable yn                     like mfc_logical initial no.
define variable l_sngl_ln              like poc_ln_fmt no-undo.
define variable first_time             like mfc_logical initial yes.
define variable i                      as integer.
define variable minprice               like pc_min_price.
define variable maxprice               like pc_min_price.
define variable lineffdate             like po_due_date.
define variable warning                like mfc_logical initial no.
define variable warmess                like mfc_logical initial yes.
define variable minmaxerr              like mfc_logical.
define variable dummy_cost             like pc_min_price.
define variable netcost                like pod_pur_cost.
define variable old_disc_pct           like pod_disc_pct.
define variable pc_recno               as recid.
define variable err-flag               as integer no-undo.
define variable porecno                as recid no-undo.
define variable podrecno               as recid no-undo.
define variable pacrecno               as recid initial ? no-undo.
define variable imp-okay               like mfc_logical no-undo.
define variable l_actual_disc          as decimal no-undo.
define variable l_display_disc         as decimal no-undo.
define variable l_min_disc             as decimal initial -99.99 no-undo.
define variable l_max_disc             as decimal initial 999.99 no-undo.
define variable mc-error-number        like msg_nbr      no-undo.
define variable exchg_rate             as   decimal      no-undo.
define variable exchg_rate2            as   decimal      no-undo.
define variable exch-error-number      like msg_nbr      no-undo.
define variable exchg_ratetype         like exr_ratetype no-undo.
define variable linecost               like pod_pur_cost no-undo.
define variable unitcost               like pod_pur_cost no-undo.
define variable purcost                like pod_pur_cost no-undo.
define variable use-log-acctg          as logical        no-undo.
define variable pPurCost               like pod_pur_cost no-undo.
define variable l-pur_cost             like pod_pur_cost no-undo.
define variable l_netprice             like pc_min_price no-undo.
define variable conversion_factor      as   decimal      no-undo.
define variable l_po_line_qty          like pod_qty_ord  no-undo.

define variable l_price_cost           like pod_pur_cost no-undo.
define var v_sojob like pod_so_job . /*xp003*/



/* FRAME BUYER FORM */
form
   po_buyer
with frame buyer side-labels width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame buyer:handle).

/* FRAME VEND FORM */
form
   rqd_vend
with frame vend side-labels width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame vend:handle).

/* FRAME CURR FORM */
form
   po_curr     label "PO Currency"
   wkrqd_curr  label "Requisition Currency"
with frame curr side-labels width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame curr:handle).

/* FRAME UM FORM */
form
   pod_um      label "PO Unit of Measure"
   wkrqd_um    label "Requisition Unit of Measure"
with frame um side-labels width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame um:handle).

/* FRAME UM_CHANGE FORM */
form
   rqd_req_qty   label "Requisition Line Qty"
   wkrqd_um      label "Requisition Unit of Measure"
   space(5)
   l_po_line_qty label "PO Line Qty "
   pod_um        label "PO Unit of Measure"
with frame um_change side-labels width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame um_change:handle).

/* FRAME BASE_COST FORM */
form
   base_cost   label "Base Cost"
with frame base_cost side-labels width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame base_cost:handle).

/* FRAME REV FORM */
form
   pod_rev
with frame rev side-labels width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame rev:handle).

/* FRAME PRICE FORM */
form
   var_req_cost        label "Requisition Price"
   dummy_cost          label "Computed Price"
with frame price side-labels width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame price:handle).

/* FRAME PO_LINE_RPT FORM */
form
   line
   pod_site
   pod_req_nbr
   pod_req_line
   pod_part
   pod_qty_ord
   pod_um
   pod_pur_cost
   pod_disc_pct
   ext_cost            label "Extended Cost"
   pod_so_job
with frame po_line_rpt width 132 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame po_line_rpt:handle).

c-consigment-contract = getTermLabel("CONTRACT",15) + ": " +
                        getTermLabel("CONSIGNMENT_INVENTORY",33).

find first gl_ctrl where gl_domain = global_domain no-lock.
find first poc_ctrl where poc_domain = global_domain no-lock.
find first icc_ctrl where icc_domain = global_domain no-lock.

/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

/* READ COMPLIANCE CONTROL FILE */
find first clc_ctrl where clc_domain = global_domain no-lock no-error.
if not available clc_ctrl then do:
   {gprun.i ""gpclccrt.p""}
   find first clc_ctrl where clc_domain = global_domain no-lock.
end.

/* READ PRICE TABLE REQUIRED FLAG FROM MFC_CTRL */
find first mfc_ctrl
   where mfc_domain = global_domain
   and   mfc_field = "poc_pt_req"
no-lock no-error.
if available (mfc_ctrl) then
   poc_pt_req = mfc_logical.

find po_mstr where recid(po_mstr) = po_recno.
find vd_mstr where recid(vd_mstr) = vd_recno no-lock.

do with frame po_header_rpt:
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame po_header_rpt:handle).
   display
      po_nbr
      po_vend
      po_ship
   with frame po_header_rpt side-labels width 132.
end. /* do with */

/* REQ. HEADER WARNINGS */
if not {gpcode.v po_buyer} then do:
   /* VALUE MUST EXIST IN GENERALIZED CODES */
   display
      po_buyer
   with frame buyer.
   run put_message (input 716, input 2).
end.

find first rqpo_wrk no-lock.

/* COPY REQUISITION LINES FROM REMOTE DB TO TEMP-TABLE */
{gprun.i ""xxrqpobldg.p""
   "(input true,
     input rqpo_site)"}  /*xp006*/

rqpoloop:
for each rqpo_wrk
   where rqpo_copy_to_po no-lock
      break by rqpo_nbr by rqpo_line
with frame rpt width 132 down:

   /* FIND REQUISITION LINE IN TEMP-TABLE */
   find wkrqd_det where
      wkrqd_nbr = rqpo_nbr and
      wkrqd_line = rqpo_line no-lock.

   assign
      var_sub    = wkrqd_sub
      var_cc     = wkrqd_cc.

   /* SCREENS & REPORTS DON'T SUPPORT 4 DIGIT LINE NOS. */
   if line < 999 then
      line = line + 1.

   if line >= 999 then do:
      run put_message (input 7418, input 4).
      run put_message (input 1304, input 4).
      next rqpoloop.
   end.

   /* VALIDATE SITE ACCESS */
   do with frame site:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame site:handle).
      if wkrqd_site = "" then do:
         find pt_mstr
            where pt_domain = global_domain
             and  pt_part = wkrqd_part
         no-lock no-error.
         if available pt_mstr and pt_site <> "" then do:
            {gprun.i ""gpsiver.p""
               "(input pt_site, input ?, output return_int)"}
            if return_int = 0 then do:
               display
                  wkrqd_site
               with frame site.
               run put_message (input 726, input 4).
               run put_message (input 1304, input 4).
               undo rqpoloop, retry.
            end.

         end.

      end.  /* IF RQD_SITE = "" */

      else do:
         {gprun.i ""gpsiver.p""
            "(input wkrqd_site, input ?, output return_int)"}
         if return_int = 0 then do:
            display
               wkrqd_site
            with frame site.
            run put_message (input 725, input 4).
            run put_message (input 1304, input 4).
            undo rqpoloop, retry.
         end.

      end.  /* IF RQD_SITE <> "" */

   end. /* do with */

   /* FIND PURCHASE ORDER LINE */
   find pod_det where
      pod_domain = global_domain and
      pod_nbr    = po_nbr and
      pod_line   = line
   no-lock no-error.
   if not available pod_det then do:
		find first rqd_det where rqd_domain = global_domain and rqd_nbr = rqpo_nbr and rqd_line = rqpo_line no-lock no-error . /*xp003*/
		v_sojob = if avail rqd_det then rqd__chr01 else "" .  /*xp003*/

      create pod_det.
      pod_domain = global_domain.
      assign
         pod_nbr      = po_nbr
         pod_line     = line
         pod_lot_rcpt = clc_polot_rcpt
         pod_due_date = wkrqd_due_date
         pod_so_job   =	v_sojob 	/*wkrqd_job*/ /*xp003*/
         pod_fix_pr   = po_fix_pr
         pod_disc_pct = wkrqd_disc_pct
         pod_pst      = po_pst
         pod_site     = wkrqd_site
         pod_po_db    = global_db
         pod_desc     = wkrqd_desc
         pod_tax_env  = po_tax_env
         pod_tax_usage = po_tax_usage
         pod_project  = wkrqd_project
         pod_crt_int  = pocrt_int
         pod_contract = po_contract
         pod_cst_up   = yes.

      {pxrun.i &PROC      ='getPurchaseOrderLinePOSite'
               &PROGRAM   ='popoxr1.p'
               &PARAM     ="(input po_site,
                             input pod_site,
                             output pod_po_site)"
               &NOAPPERROR=True
               &CATCHERROR=True}

      if return-value <> {&SUCCESS-RESULT}
      then do:

         if c-application-mode <> "API"
         then
            next rqpoloop.
         else
            return error.

         next rqpoloop.

      end. /* IF return-value <> {&SUCCESS-RESULT} */

      for first pt_mstr
         fields (pt_domain pt_part pt_site pt_taxable pt_taxc pt_um
                 pt_prod_line)
         where pt_domain = global_domain
          and  pt_part = rqpo_item
      no-lock:
      end. /* FOR FIRST PT_MSTR */
      if available pt_mstr then
         assign
            pod_taxable = (pt_taxable and po_taxable)
            pod_taxc    = if pt_taxc <> "" then
                             pt_taxc
                          else
                             po_taxc.
      else
         /** FOR MEMO ITEMS **/
         assign
            pod_taxable = po_taxable
            pod_taxc    = po_taxc.

      pod_tax_in  = tax_in.

      /* GETS AND UPDATES PO LINE TAX ENVIRONMENT */
      if  pod_taxable
      and pod_site <> old_pod_site
      then do:
         {pxrun.i &PROC='getTaxEnvironment'
                  &PROGRAM='popoxr.p'
                  &PARAM="(input  vd_addr,
                           input  pod_site,
                           input  '',
                           input  po_taxc,
                           output pod_tax_env)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if pod_tax_env = ""
         then do:
            /* NO TAX ENVIRONMENT FOUND.        */
            /* USING PO HEADER TAX ENVIRONMENT. */
            {pxmsg.i &MSGNUM=5366 &ERRORLEVEL=2}

            pod_tax_env = po_tax_env.
         end. /* IF pod_tax_env = "" */
      end. /* IF pod_taxable ... */

      /* CONVERT TO SUPPLIER ITEM UNIT OF MEASURE */
      /* CHANGED EIGHTH PARAMETER WKRQD_VPART FROM */
      /* OUTPUT TO INPUT-OUTPUT PARAMETER          */
      run get_vendor_item_info
         (input rqpo_item,
         input po_vend,
         input po_curr,
         input rqpo_net_qty,
         input wkrqd_pur_cost,
         input wkrqd_um,
         input wkrqd_um_conv,
         input-output wkrqd_vpart,
         output mfgr,
         output mfgr_part,
         output var_um,
         output var_um_conv,
         output var_pur_cost,
         output var_net_qty).
      assign
         pod_req_nbr        = rqpo_nbr
         pod_req_line       = rqpo_line
         pod_part           = rqpo_item
         pod_um             = var_um
         pod_um_conv        = var_um_conv
         pod_qty_ord        = var_net_qty
         pod_acct           = wkrqd_acct
         pod_sub            = var_sub
         pod_cc             = var_cc
         pod_approve        = wkrqd_prev_userid
         pod_request        = wkrqd_rqby_userid
         pod_apr_code       = wkrqd_status
         pod_pur_cost       = var_pur_cost
         pod_vpart          = wkrqd_vpart
         pod_insp_rqd       = wkrqd_insp_rqd
         pod_loc            = wkrqd_loc
         /* REFERENCE: POPOMTI.P */
         pod_rev            = wkrqd_rev
         pod_per_date       = wkrqd_due_date
         pod_need           = wkrqd_need_date
         pod_consignment    = po_consignment
         pod_max_aging_days = po_max_aging_days
         new_pod            = yes
         pod_type           = wkrqd_type.

        find first in_mstr 
			where in_domain = global_domain 
			and in_site = pod_site 
			and in_part = pod_part 
		no-lock no-error .
		if avail in_mstr then do:
			pod_loc = in_loc .
		end.  /*xp004*/ 

        find first rqd_det where rqd_domain = global_domain and rqd_nbr = rqpo_nbr and rqd_line = rqpo_line no-lock no-error .
		if avail rqd_det then do:
            if rqd_nbr begins "C" then do:
                find first vp_mstr 
                        where vp_domain = global_domain
                        and vp_part = "C"
                        and vp_vend = rqd_vend 
                no-lock no-error .
                if avail vp_mstr then do:
                    pod_loc = vp_vend_part .
                end.
            end.
        end. /*xp005*/




      if using_consignment and
         can-find(pt_mstr where pt_domain = global_domain
                           and  pt_part = pod_part)
      then do:

         run initializeSuppConsignDetailFields
            (input po_vend,
             input pod_part,
             input po_consignment,
             input po_max_aging_days,
             output pod_consignment,
             output pod_max_aging_days).
      end.

      /* CONVERT ITEM COST TO PO CURRENCY */
      if wkrqd_curr <> po_curr then do:
         if wkrqd_curr <> base_curr then do:
            for first rqm_mstr
               fields (rqm_domain rqm_curr rqm_ex_rate rqm_ex_rate2
                       rqm_fix_rate rqm_nbr)
               where rqm_domain = global_domain
                and  rqm_nbr = wkrqd_nbr
            no-lock:
            end. /* FOR FIRST */

            if rqm_curr <> base_curr then do:
               if rqm_fix_rate then
                  assign
                     exchg_rate = rqm_ex_rate
                     exchg_rate2 = rqm_ex_rate2.

               else do:
                  {gprun.i ""rqexrt.p""
                     "(input rqm_curr,
                       input base_curr,
                       input exchg_ratetype,
                       output exchg_rate,
                       output exchg_rate2,
                       output exch-error-number)"}
                  if exch-error-number <> 0 then do:
                     /* NO EXCHANGE RATE FOR REQUISITION TO */
                     /* BASE CURRENCY */
                     run put_message (input 2088, input 3).
                     undo rqpoloop,retry.
                  end. /* IF EXCH-ERROR-NUMBER */

               end. /* IF NOT RQM_FIX_RATE */
            end. /* IF RQM_CURR <> BASE_CURR */

            /* CONVERSION  BETWEEN REQUISITION AND BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input rqm_curr,
                 input base_curr,
                 input exchg_rate,
                 input exchg_rate2,
                 input var_pur_cost,
                 input false, /* DO NOT ROUND */
                 output var_pur_cost,
                 output mc-error-number)"}
         end. /* WKRQD_CURR <> BASE_CURR */

         pod_pur_cost = var_pur_cost.

         /* CONVERSION BETWEEN BASE AND PO CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input base_curr,
              input po_curr,
              input po_ex_rate2,
              input po_ex_rate,
              input pod_pur_cost,
              input false, /* DO NOT ROUND */
              output pod_pur_cost,
              output mc-error-number)"}

      end. /* WKRQD_CURR <> PO_CURR */

      po_tot_terms_code = vd_tot_terms_code.

      /* UPDATE l_netprice TO INCLUDE UM CONVERSION WHEN  */
      /* REQUISITION UM AND PO UM ARE DIFFERENT           */

      l_netprice = if wkrqd_um <> var_um
                   then
                      decimal(wkrqd_qadc01) * var_um_conv
                   else
                      decimal(wkrqd_qadc01).

      if ((pod__qad02 = 0 or pod__qad02 = ?) and
          (pod__qad09 = 0 or pod__qad09 = ?))
      then

         /* EXT COST (ext_cost) WILL NOW BE CALCULATED USING */
         /* l_netprice AND PURCHASE COST (pod_pur_cost)      */
         /* INSTEAD OF DISC% (pod_disc_pct)                  */

         ext_cost = if pod_pur_cost <> 0
                    then
                       pod_qty_ord * pod_pur_cost
                          * (1 - (- (l_netprice - pod_pur_cost)
                                  / (pod_pur_cost / 100)) / 100)
                    else
                       0.
      else
         ext_cost = pod_qty_ord *
                   (pod__qad09 + pod__qad02 / 100000).

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output ext_cost,
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      if pod_disc_pct >  l_max_disc then
         l_display_disc =  l_max_disc.
      else
      if pod_disc_pct < l_min_disc then
         l_display_disc = l_min_disc.
      else
         l_display_disc = pod_disc_pct.

      /* UPDATE LOGISTICS ACCOUNTING TERMS OF TRADE FIELD */
      if use-log-acctg
         and po_tot_terms_code <> ""
      then do:

         /* VENDOR MASTER PRICE */
         run get_pur_cost
            (input pod_part,
             input po_vend,
             input pod_site,
             input po_curr,
             input pod_qty_ord,
             input pod_um,
             input po_ex_rate,
             input po_ex_rate2,
             output var_vend_pur_cost).

         if available pt_mstr
         then
            if pod_um <> pt_um
            then do:

               {gprun.i ""gpumcnv.p""
                        "(input pod_um,
                          input pt_um,
                          input pt_part,
                          output conversion_factor)"}

               linecost = round(linecost * conversion_factor,6).

            end. /*IF pod_um <> pt_um */

         if po_curr = base_curr
         then do:

            if linecost = var_pur_cost
            then do:

               /* UPDATE LOGISTICS ACCOUNTING TERMS OF TRADE FIELD */
               {gprunmo.i &module = "LA" &program = "lapopr.p"
                  &param = """(input pod_um,
                               input linecost,
                               input po_nbr,
                               input pod_part,
                               input pod_site,
                               output l-pur_cost)"""}

               pod_pur_cost = l-pur_cost.

            end. /* linecost = var_req_cost */

         end. /* IF po_curr = base_curr */
         else do:

            /* CONVERT FROM BASE TO FOREIGN CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input base_curr,
                input po_curr,
                input po_ex_rate2,
                input po_ex_rate,
                input linecost,
                input false, /* DO NOT ROUND */
                output unitcost,
                output mc-error-number)"}.

            if unitcost = if (wkrqd_curr = po_curr)
                          then
                             var_pur_cost
                          else
                             var_vend_pur_cost
            then do:

               /* UPDATE LOGISTICS ACCOUNTING TERMS OF TRADE FIELD */
               {gprunmo.i &module = "LA" &program = "lapopr.p"
                  &param="""(input pod_um,
                             input linecost,
                             input po_nbr,
                             input pod_part,
                             input pod_site,
                             output purcost)"""}

               /* CONVERT FROM BASE TO FOREIGN CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input base_curr,
                   input po_curr,
                   input po_ex_rate2,
                   input po_ex_rate,
                   input purcost,
                   input false, /* DO NOT ROUND */
                   output l-pur_cost,
                   output mc-error-number)"}.

               pod_pur_cost = l-pur_cost.

            end. /* IF linecost = var_req_cost */

         end. /* IF po_curr <> base_curr */

      end. /* IF use-log-acctg */

      /* REPORT LINE ITEM ADDED */
      display
         line
         pod_site
         pod_req_nbr
         pod_req_line
         pod_part
         pod_qty_ord
         pod_um
         pod_pur_cost
         l_display_disc @ pod_disc_pct
         ext_cost
         pod_so_job
      with frame po_line_rpt width 132 down.

      if pod_desc <> "" then
         put
            space(30)
            pod_desc
            skip.

      /* REQ. LINE WARNINGS */
      if wkrqd_vend <> po_vend then do:

         /* REQUISITION LINE SUPPLIER IS DIFFERENT FROM PO SUPPLIER */
         display
            po_vend @ rqd_vend
         with frame vend.
         run put_message (input 1874, input 2).
      end.

      if po_curr <> wkrqd_curr then do:

         /* PO CURRENCY IS DIFFERENT FROM REQUISITION CURRENCY */
         display
            po_curr
            wkrqd_curr
         with frame curr.
         run put_message (input 1875, input 2).
      end.

      /* SUPPLIER ITEM UM IS DIFFERENT THAT REQ UM */
      if pod_um <> wkrqd_um then do:
         display
            pod_qty_ord  @ l_po_line_qty
            pod_um
            rqpo_net_qty @ rqd_req_qty
            wkrqd_um
         with frame um_change.
         run put_message (input 2784, input 2).
      end. /* if pod_um <> wkrqd_um */

      if not {gpcode.v pod_rev} then do:

         /* VALUE MUST EXIST IN GENERALIZED CODES */
         display
            pod_rev
         with frame rev.
         run put_message (input 716, input 2).
      end.

      if recid(pod_det) = -1 then .

      /* CREATE REQ - PO CROSS-REFERENCE RECORD */
      {gprun.i ""rqporef.p""
         "(input true,
           input pod_site,
           input pod_req_nbr,
           input pod_req_line,
           input pod_nbr,
           input pod_line,
           input pod_qty_ord,
           input pod_um,
           output var_requm,
           output rqpo_ok)"}

      if not rqpo_ok then do:
         /* NO UNIT OF MEASURE CONVERSION EXISTS */
         display
            pod_um
            var_requm @ wkrqd_um
         with frame um.
         run put_message (input 33, input 3).
      end.

      /* DETERMINE ITEM PRICE FROM:   */
      /*   1) PRICE LIST              */
      /*   2) VENDOR MASTER           */
      /* IF PRICE LIST IS LESS THAN REQUISITION PRICE THEN     */
      /* DISPLAY A WARNING AND THE PRICE.  OTHERWISE,          */
      /* CHECK THE VENDOR MASTER.                              */
      /* IF VENDOR MASTER PRICE IS LESS THAN REQUISITION THEN  */
      /* DISPLAY A WARNING AND THE CALCULATED PRICE.           */

      /* PRICE LIST */
      /* THIS PART HAS TO BE SOMEWHERE AFTER POD_QTY_ORD AND */
      /* POD_UM HAVE BEEN UPDATED                            */
      assign
         st_qty       = pod_qty_ord * pod_um_conv
         var_pur_cost = pod_pur_cost
         dummy_cost   = pod_pur_cost * (1 - pod_disc_pct / 100)
         var_req_cost = dummy_cost.

      /* PRICE TABLE LIST PRICE LOOK-UP */
      if po_pr_list2 <> "" then do:
         dummy_cost = ?.
         {gprun.i ""gppclst.p""
            "(input        po_pr_list2,
              input        pod_part,
              input        pod_um,
              input        pod_um_conv,
              input        lineffdate,
              input        po_curr,
              input        new_pod,
              input        poc_pt_req,
              input-output var_pur_cost,
              input-output dummy_cost,
              output       minprice,
              output       maxprice,
              output       pc_recno)" }
         /* The Price List Table Look-Up (PLTL) routine (gppclst.p)
         * may not return a price.  This can be intentional
         * (new_pod = "no"), or it can be due to a failure
         * to find a table or the table contains a zero
         * price.  In all cases, dummy_cost returns with
         * its original value (?) when no table price is found.
         * It returns with a non-? value if a price *is* found.
         * dummy_cost needs to hold the Net Price for processing
         * below, but doesn't on return from the PLTL routine.
         * The statements below ensure that dummy_cost contains
         * the Net Price */

         if dummy_cost <> ? then
            /*Apply the line discount to the PLTL price */
            dummy_cost = dummy_cost * (1 - pod_disc_pct / 100).
         else
            /*Calculate the Net Price from the PO line info */
            dummy_cost = dummy_cost * (1 - pod_disc_pct / 100).

      end.  /* if po_pr_list2 <> "" */

      /* Warn if the required item/um price tbl not found */
      if poc_pt_req and
         (po_pr_list2 = "" or pc_recno = 0)
      then do:
         /* Price table for pod_part in pod_um not found */
         {pxmsg.i &MSGNUM=6231 &ERRORLEVEL=2
            &MSGARG1=pod_part
            &MSGARG2=pod_um}
      end.

      /* Since price lists are created for alternate units of   */
      /* measure expressing the quantities in stocking um. It   */
      /* is not necessary to mulitply the "P" type lists by the */
      /* unit of measure conversion factor before price list    */
      /* lookup.                                                */
      /* st_qty = pod_qty_ord * pod_um_conv.                    */

      if po_pr_list <> "" then do:
         assign
            pt_recno    = recid(pt_mstr)
            pcqty       = pod_qty_ord
            match_pt_um = poc_pl_req.
         /* DISCOUNT TABLE LOOK-UP */
         /* Use lineffdate for look-up, same as Price Table */
         {gprun.i ""gppccal.p""
            "(input        pod_part,
              input        pcqty,
              input        pod_um,
              input        pod_um_conv,
              input        po_curr,
              input        po_pr_list,
              input        lineffdate,
              input        var_pur_cost,
              input        match_pt_um,
              input        disc,
              input-output var_pur_cost,
              output       var_disc_pct,
              input-output dummy_cost,
              output       pc_recno)" }   /* DON'T LET OUTPUT CHANGE POD_* */

      end. /* po_pr_list <> "" */

      /* WARN if the required item/um price list was not found */
      if poc_pl_req and
         (po_pr_list = "" or pc_recno = 0)
      then do:
         /* Price list for pod_part in pod_um not found */
         /* Required Discount table for item in um not found*/
         {pxmsg.i &MSGNUM=982 &ERRORLEVEL=4
            &MSGARG1=pod_part
            &MSGARG2=pod_um}
      end.

      /* IF UNIT COST DEFAULTING FROM PRICE LIST IN REQUISITION    */
      /* IS CHANGED THEN dummy_cost SHOULD STORE THE UPDATED VALUE */

      if var_req_cost <> dummy_cost
      then
         assign
            var_pur_cost = pod_pur_cost
            l_price_cost = dummy_cost
            dummy_cost   = pod_pur_cost * (1 - pod_disc_pct / 100).

      if new_pod then
         assign
            pod__qad09   = dummy_cost
            pod__qad02   = (dummy_cost - pod__qad09) * 100000
            old_pur_cost = var_pur_cost
            old_disc_pct = var_disc_pct.

      /* Used pod__qad02 and pod__qad09 to store net price   */
      /* and avoid rounding errors.                          */
      /* Changed 8th input from pod_std_cost to pod_pur_cost */
      /* since in PO, the purchase price is the cost and in  */
      /* this program the pod_std_cost is not updated anyhow */

      /* Since price lists are created for alternate units of */
      /* measure expressing the qauntities in stocking um. It */
      /* is necessary to mulitply the "P" type lists by the   */
      /* unit of measure conversion factor after returning    */
      /* from the proce list look up.                         */
      /* It is not necessary to multiply the price with the */
      /* unit of measure conversion factor                  */
      /* pod_pur_cost = pod_pur_cost * pod_um_conv.         */

      /* Only display base cost when adding new lines. Since    */
      /* thats the only time it's calculated in popomth.p       */
      /* if po_curr <> base_curr and pod_pur_cost <> 0 then do: */

      if new pod_det and
         po_curr <> base_curr and
         pod_pur_cost <> 0
      then do:
         base_cost = pod_pur_cost.

         /* CONVERT FROM FOREIGN CURRENCY TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input base_curr,
              input po_curr,
              input po_ex_rate,
              input po_ex_rate2,
              input base_cost,
              input true, /* ROUND */
              output base_cost,
              output mc-error-number)"}.

         /* Base currency list price: 19.99 */

         display
            base_cost
         with frame base_cost.
         run put_message (input 716, input 2).
      end.

      /* PRICE TABLE MIN/MAX WARNING FOR DISC TABLES. PLUG PRICES */
      if po_pr_list2 <> "" then do:
         assign
            netcost = var_pur_cost * (1 - var_disc_pct / 100)
            warmess = yes
            warning = yes.
         {gprun.i ""gpmnmx.p""
            "(input warning,
              input warmess,
              input minprice,
              input maxprice,
              output minmaxerr,
              input-output netcost,
              input-output dummy_cost,
              input pod_part)"}

      end.  /* if po_pr_list2 <> "" */

      var_req_cost = if pod_disc_pct <> 0
                     then
                        pod_pur_cost
                           * (1 - (- (dummy_cost - pod_pur_cost)
                                   / (pod_pur_cost / 100)) / 100)
                     else
                        pod_pur_cost.

      if var_req_cost <> 0
      then do:

         if dummy_cost      <> 0
            and var_req_cost > dummy_cost
         then do:
            display
               var_req_cost
               dummy_cost
            with frame price.
            /* REQUISITION PRICE IS GREATER THAN PRICE LIST */
            run put_message (input 1873, input 2).
         end. /* if dummy_cost <> 0 AND ... */
         else
         if l_price_cost    <> 0
            and var_req_cost > l_price_cost
         then do:
            display
               var_req_cost
               l_price_cost @ dummy_cost
            with frame price.
            /* REQUISITION PRICE IS GREATER THAN PRICE LIST */
            run put_message (input 1873, input 2).
         end. /* if l_price_cost <> 0 AND ... */

         else do:

            /* VENDOR MASTER PRICE */
            run get_pur_cost
               (input pod_part,
               input po_vend,
               input pod_site,
               input po_curr,
               input pod_qty_ord,
               input pod_um,
               input po_ex_rate,
               input po_ex_rate2,
               output var_vend_pur_cost).

            if use-log-acctg
               and po_tot_terms_code <> ""
            then do:

               run get_vendor_q_price
                  (input pod_part,
                   input po_vend,
                   input po_curr,
                   input pod_qty_ord,
                   input pod_um,
                   output pPurcost).

               if pPurcost = ? then do:

                  /* IS REQUISITION PRICE GREATER THAN VENDOR PRICE? */
                  if var_req_cost <> 0
                     and l-pur_cost <> 0
                     and var_req_cost > l-pur_cost then do:

                     /* REQUISITION PRICE IS GREATER THAN VENDOR PRICE */
                     display
                        var_req_cost
                        l-pur_cost @ dummy_cost
                     with frame price.

                     run put_message (input 1866, input 2).
                  end.

               end. /* if pPurcost = ? */
               else do:

                  /* IS REQUISITION PRICE GREATER THAN VENDOR PRICE? */
                  if var_req_cost <> 0
                     and var_vend_pur_cost <> 0
                     and var_req_cost > var_vend_pur_cost
                  then do:

                     /* REQUISITION PRICE IS GREATER THAN VENDOR PRICE */
                     display
                        var_req_cost
                        var_vend_pur_cost @ dummy_cost
                     with frame price.

                     run put_message (input 1866, input 2).
                  end.

               end. /* if pPurcost <> ? */

            end. /* if use-log-acctg */
            else do:

               /* IS REQUISITION PRICE GREATER THAN VENDOR PRICE? */
               if var_req_cost <> 0 and var_vend_pur_cost <> 0 and
                  var_req_cost > var_vend_pur_cost
               then do:
                  /* REQUISITION PRICE IS GREATER THAN VENDOR PRICE */
                  display
                     var_req_cost
                     var_vend_pur_cost @ dummy_cost
                  with frame price.
                  run put_message (input 1866, input 2).
               end.

            end. /* if not use-log-acctg */

         end.  /* if dummy_cost = 0 */

      end.  /* if wkrqd_pur_cost <> 0 */

      /* COPY REQ LINE COMMENTS, IF THEY EXIST & ARE FLAGGED */
      if include_lcmmts and wkrqd_cmtindx <> 0 then do:

         /* INITIALIZE COUNTER */
         i = -1.

         /* COPY COMMENTS FROM WORKFILE */
         for each wkcmt_det
            where wkcmt_det.cmt_indx = wkrqd_cmtindx
         no-lock:

            create cmt_det.
            cmt_det.cmt_domain = global_domain.
            if i = -1 then do:
               assign cmt_det.cmt_seq = wkcmt_det.cmt_seq.
               {mfrnseq.i cmt_det cmt_det.cmt_indx cmt_sq01}
               pod_cmtindx = cmt_det.cmt_indx.
            end.

            assign
               cmt_det.cmt_indx  = pod_cmtindx
               cmt_det.cmt_seq   = wkcmt_det.cmt_seq
               cmt_det.cmt_ref   = wkcmt_det.cmt_ref
               cmt_det.cmt_type  = wkcmt_det.cmt_type
               cmt_det.cmt_print = wkcmt_det.cmt_print
               cmt_det.cmt_lang  = wkcmt_det.cmt_lang .

            do i = 1 to 15:
               cmt_det.cmt_cmmt[i] = wkcmt_det.cmt_cmmt[i].
            end.

            i = 1.

         end.  /* for cmt_det where cmt_indx = wkrqd_cmtindx */

      end.  /* if wkrqd_cmtindx <> 0 */

      else
         pod_cmtindx = 0.

      /* Update ORD-PO and MRP Supply records */
      /* (Local database only - remote db updates in popomtg2.) */
      pod_recno = recid(pod_det).
      {gprun.i ""popomtc.p""}

      /*DEFAULT ERS LINE ITEM OPTION TO PROPER VALUE*/
      if po_ers_opt = "" then do:
         /*DEFAULT TO VALUE IN ERS TABLE*/
         {gprun.i ""poers.p"" "(po_vend, pod_site, pod_part,
            output pod_ers_opt,
            output pod_pr_lst_tp,
            output errcd)" }

         /*ONLY USE RETURN VALUE IF PO PRICE LIST OPTION IS 0*/
         if po_pr_lst_tp <> 0 then
            pod_pr_lst_tp = po_pr_lst_tp.
      end. /*PO_ERS_OPT = "" */
      else
         assign
            pod_ers_opt = integer(po_ers_opt)
            pod_pr_lst_tp = po_pr_lst_tp.

      /* UPDATE REMOTE DB */
      /* REFERENCE: POPOMTH.P */
      assign
         old_db   = global_db
         new_site = pod_site.
      if pod_site <> "" then do:
         {gprun.i ""gpalias.p""}
      end.

      /* UPDATE PART MASTER MRP FLAG */
      global_part = pod_part.
      {gprun.i ""inmrp.p"" "(pod_part, pod_site)"}

      /* REMOVE REQ FROM MRP VISIBILITY */
      {gprun.i ""rqmrw.p""
         "(input true,
           input pod_site,
           input pod_req_nbr,
           input pod_req_line)"}

      /*WRITE HISTORY RECORD*/
      {gprun.i ""rqwrthst.p""
         "(input rqpo_nbr,
           input rqpo_line,
           input ACTION_CREATE_PO_LINE,
           input global_userid,
           input '',
           input '')"}

      new_db = old_db.
      {gprun.i ""gpaliasd.p""}

      /* IF THE PO IS CONSIGNED, THEN INDICATE THIS ON THE */
      /* OUTPUT REPORT.                                    */
      if using_consignment and pod_consignment then
         display c-consigment-contract no-label.

      /* RECORD ADDED */
      run put_message (input 663, input 1).

   end.  /* if not available pod_det */

   {mfrpchk.i}

end.  /* rqpoloop */

/* RETURN */

/*  POPOMTEA.P  */

/******************************************************/
/******************************************************/
/**                 PROCEDURES                       **/
/******************************************************/
/******************************************************/

PROCEDURE get_remote_item_data:
   define input  parameter p_part       like pt_part     no-undo.
   define input  parameter p_site       like pt_site     no-undo.
   define input  parameter p_supp_type  like pt_site     no-undo.
   define output parameter p_std_cost   as   decimal     no-undo.
   define output parameter p_rev        like pt_rev      no-undo.
   define output parameter p_loc        like pt_loc      no-undo.
   define output parameter p_ins        like pt_insp_rqd no-undo.
   define output parameter p_acct       like pod_acct    no-undo.
   define output parameter p_sub        like pod_sub     no-undo.
   define output parameter p_cc         like pod_cc      no-undo.
   define variable         old_db       like si_db.
   define variable         err-flag     as   integer.
   define variable         curcst       as   decimal.
   define variable         l_dummy_type like pod_type    no-undo.

   find si_mstr
      where si_domain = global_domain
       and  si_site = p_site
   no-lock.

   if si_db <> global_db then do:
      old_db = global_db.
      {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
   end.

   {gprun.i ""gpsct05.p""
      "(p_part, si_site, 2, output p_std_cost, output curcst)"}

   /* ADDED L_DUMMY_TYPE AS NINTH OUTPUT PARAMETER */
   /* ADDED SUPPLIER TYPE AS THIRD INPUT PARAMETER */
   {gprun.i ""popomte1.p""
              "(p_part,
                si_site,
                p_supp_type,
                output p_rev,
                output p_loc,
                output p_ins,
                output p_acct,
                output p_sub,
                output p_cc,
                output l_dummy_type)"}

   if old_db <> global_db then do:
      {gprun.i ""gpalias3.p"" "(old_db, output err-flag)" }
   end.

END PROCEDURE.

PROCEDURE get_vendor_q_price:
   define input parameter p_part      like pod_part no-undo.
   define input parameter p_vend      like po_vend no-undo.
   define input parameter p_curr      like po_curr no-undo.
   define input parameter p_qty_ord   like pod_qty_ord no-undo.
   define input parameter p_um        like pod_um no-undo.
   define output parameter p_pur_cost like pod_pur_cost no-undo.

   define variable conversion_factor as decimal no-undo.

   p_pur_cost = ?.

   for each vp_mstr no-lock
      where vp_domain = global_domain
       and  vp_part = p_part
       and  vp_vend = p_vend
   break by vp_q_date descending:
      if first(vp_q_date) then do:
         conversion_factor = 1.

         if vp_um <> p_um then do:
            {gprun.i ""gpumcnv.p""
               "(input vp_um, input p_um, input vp_part,
                 output conversion_factor)"}
         end.

         if conversion_factor <> ? then do:
            if p_qty_ord >= vp_q_qty / conversion_factor
               and p_curr = vp_curr
            then
               p_pur_cost = vp_q_price * conversion_factor.
         end.

         leave.

      end.

   end.

END PROCEDURE.

PROCEDURE get_vendor_item_info:
   define input   parameter p_part        like pod_part     no-undo.
   define input   parameter p_vend        like  po_vend     no-undo.
   define input   parameter p_curr        like po_curr      no-undo.
   define input   parameter p_qty_ord     like pod_qty_ord  no-undo.
   define input   parameter p_pur_cost    like pod_pur_cost no-undo.
   define input   parameter p_um          like pod_um       no-undo.
   define input   parameter p_um_conv     like pod_um_conv  no-undo.

   define input-output parameter p_vpart  like pod_vpart    no-undo.
   define output  parameter p_mfgr        as character      no-undo.
   define output  parameter p_mfgr_part   as character      no-undo.
   define output  parameter p_vp_um       like pod_um       no-undo.
   define output  parameter p_vp_um_conv  like pod_um_conv  no-undo.
   define output  parameter p_vp_q_price  like pod_pur_cost no-undo.
   define output  parameter p_vp_qty_ord  like pod_qty_ord  no-undo.

   define variable conversion_factor      as decimal        no-undo.

   /* INITIALIZE */
   assign
      p_vp_um      = p_um
      p_vp_um_conv = p_um_conv
      p_vp_qty_ord = p_qty_ord
      p_vp_q_price = p_pur_cost
      p_mfgr       = ""
      p_mfgr_part  = "".

   for each vp_mstr no-lock
      where vp_domain = global_domain
       and  vp_part = p_part
       and  vp_vend = p_vend
   break by vp_q_date descending:

      if first(vp_q_date) then do:
         assign
            p_vpart           = vp_vend_part
            p_mfgr            = vp_mfgr
            p_mfgr_part       = vp_mfgr_part
            conversion_factor = 1.

         if vp_um <> p_um then do:
            {gprun.i ""gpumcnv.p""
               "(input vp_um,
                 input p_um,
                 input vp_part,
                 output conversion_factor)"}

            if conversion_factor <> ? then do:
               assign
                  p_vp_um_conv = conversion_factor
                  p_vp_um      = vp_um
                  p_vp_qty_ord = p_qty_ord / conversion_factor.
               if p_curr = vp_curr then
                  if vp_q_price <> 0
                  then
                     p_vp_q_price = vp_q_price.
                  else
                     p_vp_q_price = p_vp_q_price * conversion_factor.
            end.  /* if conversion_factor <> ? */
            for first  pt_mstr
               fields (pt_domain pt_part pt_prod_line
                       pt_site pt_taxable pt_taxc pt_um)
               where pt_domain = global_domain
                 and pt_part   = vp_part
            no-lock:
               if pt_um <> vp_um
                 then do :
                     {gprun.i ""gpumcnv.p""
                        "(input pt_um,
                          input vp_um,
                          input vp_part,
                          output conversion_factor)"}
                  end. /* IF pt_um <> vp_um */
               else
                  conversion_factor = 1.

               p_vp_um_conv = conversion_factor.
            end. /* FOR FIRST pt_mstr */
         end.  /* if vp_um <> p_um */

         leave.

      end.

   end.

END PROCEDURE.

PROCEDURE get_pur_cost:
   define input parameter p_part      like pt_part      no-undo.
   define input parameter p_vend      like po_vend      no-undo.
   define input parameter p_site      like si_site      no-undo.
   define input parameter p_curr      like po_curr      no-undo.
   define input parameter p_qty_ord   like pod_qty_ord  no-undo.
   define input parameter p_um        like pod_um       no-undo.
   define input parameter p_ex_rate   like po_ex_rate   no-undo.
   define input parameter p_ex_rate2  like po_ex_rate2  no-undo.
   define output parameter p_pur_cost like pod_pur_cost no-undo.

   define variable conversion_factor  as decimal        no-undo.
   define variable glxcst             as decimal        no-undo.
   define variable l_pl_acc           like pl_pur_acct  no-undo.
   define variable l_pl_sub           like pl_pur_sub   no-undo.
   define variable l_pl_cc            like pl_pur_cc    no-undo.
   define variable l_pt_ins           like pt_insp_rqd  no-undo.
   define variable l_pt_loc           like pt_loc       no-undo.

   run get_vendor_q_price
      (input p_part, input p_vend,
      input p_curr,
      input p_qty_ord, input p_um,
      output p_pur_cost).

   if p_pur_cost = ? then do:
      find pt_mstr
         where pt_domain = global_domain
          and  pt_part = p_part
      no-lock no-error.

      if available pt_mstr then do:

         /* ADDED SUPPLIER TYPE AS THIRD INPUT PARAMETER */
         run get_remote_item_data
            (input p_part,
             input p_site,
             input if available vd_mstr then vd_mstr.vd_type
                   else """",
             output glxcst,
             output l_pt_rev,
             output l_pt_loc,
             output l_pt_ins,
             output l_pl_acc,
             output l_pl_sub,
             output l_pl_cc).

         conversion_factor = 1.
         linecost = glxcst.

         if pt_um <> p_um then do:
            {gprun.i ""gpumcnv.p""
               "(input pt_um, input p_um, input pt_part,
                 output conversion_factor)"}
         end.

         /* CONVERT FROM BASE TO FOREIGN CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input base_curr,
              input po_mstr.po_curr,
              input p_ex_rate2,
              input p_ex_rate,
              input (glxcst / conversion_factor),
              input false, /* DO NOT ROUND */
              output p_pur_cost,
              output mc-error-number)"}
      end.

   end.

END PROCEDURE.

PROCEDURE put_message:
   define input parameter m_message    like msg_nbr no-undo.
   define input parameter m_err_level  as integer no-undo.

   define variable m_msg_desc          like msg_desc no-undo.

  {pxmsg.i &MSGNUM=m_message &ERRORLEVEL=m_err_level
           &MSGBUFFER=m_msg_desc}

   put
      m_msg_desc
      skip.
END PROCEDURE.