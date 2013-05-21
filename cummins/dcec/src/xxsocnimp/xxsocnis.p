/* GUI CONVERTED from xxsocnis.p (converter v1.78) Tue May 21 09:52:42 2013 */
/* GUI CONVERTED from socnis.p (converter v1.78) Thu Jun  3 07:33:26 2010 */
/* socnis.p - CUSTOMER CONSIGNMENT USAGE RECORD CREATION                      */
/* Copyright 1986-2010 QAD Inc., Santa Barbara, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/******************************************************************************/
/* DESCRIPTION: This program creates the customer consignment usage records.  */
/*              It is called by the usage auto create program, the max aging  */
/*              date maintenance program, and the EDI/ecommerce gateway       */
/*              program.                                                      */
/******************************************************************************/
/* Revision: 1.37          BY: Ellen Borden       DATE: 04/04/02  ECO: *P00F* */
/* Revision: 1.38          BY: Patrick Rowan      DATE: 06/27/02  ECO: *P091* */
/* Revision: 1.39          BY: Patrick Rowan      DATE: 07/11/02  ECO: *P0BF* */
/* Revision: 1.40          BY: Abbas Hirkani      DATE: 07/24/02  ECO: *P0C3* */
/* Revision: 1.42          BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00L* */
/* Revision: 1.43          BY: Katie Hilbert      DATE: 08/25/03  ECO: *P10Y* */
/* Revision: 1.44          BY: Sandy Brown (OID)  DATE: 12/06/03  ECO: *Q04L* */
/* Revision: 1.45          BY: Vivek Gogte        DATE: 01/05/04  ECO: *P1H4* */
/* Revision: 1.46          BY: Ajay Nair          DATE: 03/19/04  ECO: *P1T6* */
/* Revision: 1.47          BY: Robin McCarthy     DATE: 04/19/04  ECO: *P15V* */
/* Revision: 1.48          BY: Somesh Jeswani     DATE: 06/14/04  ECO: *P25V* */
/* Revision: 1.49          BY: Kirti Desai        DATE: 07/16/04  ECO: *P29S* */
/* Revision: 1.50          BY: Robin McCarthy     DATE: 09/08/05  ECO: *P3PP* */
/* Revision: 1.52          BY: Robin McCarthy     DATE: 10/01/05  ECO: *P3MZ* */
/* Revision: 1.53          BY: Tejasvi Kulkarni   DATE: 01/17/06  ECO: *Q0PP* */
/* Revision: 1.54          BY: Samit Patil        DATE: 04/04/06  ECO: *Q0SY* */
/* Revision: 1.54.1.1   BY: Vaibhav Desai    DATE: 11/16/06   ECO: *P52L* */
/* Revision: 1.54.1.2   BY: Suyash Keny      DATE: 12/01/06   ECO: *P57L* */
/* Revision: 1.54.1.3   BY: Iram Momin       DATE: 07/12/07   ECO: *P623* */
/* Revision: 1.54.1.4   BY: Vivek Kamath     DATE: 02/08/06   ECO: *Q1H5* */
/* Revision: 1.54.1.6   BY: Prajakta Patil     DATE: 04/07/08  ECO: *Q1KH* */
/* Revision: 1.54.1.7   BY: Mallika Poojary    DATE: 02/11/09  ECO: *Q29Z* */
/* Revision: 1.54.1.8   BY: Prabu M            DATE: 03/23/09  ECO: *Q2LN* */
/* Revision: 1.54.1.9   BY: Rajalaxmi Ganji    DATE: 05/26/09  ECO: *Q2XS* */
/* Revision: 1.54.1.10  BY: Sandeep Rohila     DATE: 09/18/09  ECO: *Q3F4* */
/* $Revision: 1.54.1.14 $  BY: Prabu M    DATE: 05/27/10  ECO: *Q43C* */
/*-Revision end---------------------------------------------------------------*/

/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */

/*V8:ConvertMode=Maintenance                                                  */

/* INCLUDE FILES */
{mfdeclre.i}
{gpoidfcn.i}   /* Defines nextOidValue() function */
{pxsevcon.i}
{socnvars.i}   /* CUSTOMER CONSIGNMENT VARIABLES */
{socnutmp.i}   /* COMMON USAGE TEMP-TABLE DEFINITIONS */
{socncu.i}     /* SO CONSIGNMENT USAGE MASTER PROCEDURES */
{socncud.i}    /* SO CONSIGNMENT USAGE DETAIL PROCEDURES */
{gldydef.i}
{gldynrm.i}

/* INPUT PARAMETERS */
define input        parameter ip_invoice_domain   as   character        no-undo.
define input        parameter ip_tot_usage_qty    as decimal            no-undo.
define input        parameter ip_tot_lotser_qty   as decimal            no-undo.
define input        parameter p_consign_date      like glt_effdate      no-undo.
define input-output parameter io_trnbr            as   integer          no-undo.
define input-output parameter table               for  tt_cons_usage.
define input-output parameter table               for  tt_so_update.

/* SHARED VARIABLES */
define new shared variable eff_date        like glt_effdate.
define new shared variable ref             like glt_ref.
define new shared variable ord-db-cmtype   like cm_type                 no-undo.
define new shared variable sct_recno       as   recid      initial ?.
define new shared variable sod_recno       as   recid      initial ?.
define new shared variable trgl_recno      as   recid      initial ?.
define new shared variable rndmthd         like rnd_rnd_mthd.
define new shared variable trqty           like tr_qty_chg.

/* LOCAL VARIABLES */
define variable MANUAL                     as   character  initial "01" no-undo.
define variable EDI                        as   character  initial "02" no-undo.
define variable ADJUSTMENT                 as   character  initial "03" no-undo.
define variable gl_amt                     like glt_amt                 no-undo.
define variable dr_acct                    as   character               no-undo.
define variable dr_sub                     as   character               no-undo.
define variable dr_cc                      as   character               no-undo.
define variable cr_acct                    as   character               no-undo.
define variable cr_sub                     as   character               no-undo.
define variable cr_cc                      as   character               no-undo.
define variable consigned_line_item        as   logical                 no-undo.
define variable consign_inv_acct           as   character               no-undo.
define variable consign_inv_sub            as   character               no-undo.
define variable consign_inv_cc             as   character               no-undo.
define variable consign_intrans_acct       as   character               no-undo.
define variable consign_intrans_sub        as   character               no-undo.
define variable consign_intrans_cc         as   character               no-undo.
define variable consign_offset_acct        as   character               no-undo.
define variable consign_offset_sub         as   character               no-undo.
define variable consign_offset_cc          as   character               no-undo.
define variable exch_rate                  like exr_rate                no-undo.
define variable exch_rate2                 like exr_rate2               no-undo.
define variable exch_ratetype              as   character               no-undo.
define variable exch_exru_seq              as   integer                 no-undo.
define variable mc-error-number            as   integer                 no-undo.
define variable gl_tmp_amt                 as   decimal                 no-undo.
define variable order_cum_used_qty         like sod_qty_ord             no-undo.
define variable working_qty                like
                                           cncud_det.cncud_usage_qty    no-undo.
define variable working_sod_qty            like
                                           cncud_det.cncud_usage_qty    no-undo.
define variable working_inv_qty            like
                                           cncud_det.cncud_usage_qty    no-undo.
define variable sod_entity                 as   character               no-undo.
define variable first_so_entity            as   character               no-undo.
define variable lotser                     as   character               no-undo.
define variable prev_found                 as   logical                 no-undo.
define variable location                   as   character               no-undo.
define variable result-status              as   integer                 no-undo.
define variable out_um_conv                as   decimal                 no-undo.
define variable hold_cncu_usage_um         as   character               no-undo.
define variable hold_cncud_usage_um        as   character               no-undo.
define variable base-price                 like tr_price                no-undo.
define variable first_time_in              as   logical initial yes     no-undo.
define variable io_batch                   as   integer                 no-undo.
define variable using_supplier_consignment as   logical                 no-undo.
define variable supplier_consign_flag      as   logical                 no-undo.
define variable ship_date                  as   date                    no-undo.
define variable inventory_domain           as   character               no-undo.
define variable l_undo_flag                like mfc_logical             no-undo.

/* BUFFERS */
define buffer b_sod_det for sod_det.

do on error undo, return error {&GENERAL-APP-EXCEPT}:

   find first bUsage exclusive-lock.

   if not available bUsage then
      return {&RECORD-NOT-FOUND}.

   assign
      inventory_domain = global_domain
      prev_found = no
      working_qty = bUsage.cncud_usage_qty.

   if bUsage.origin = EDI then do:

      /* Check if a manual cncu_mstr already exists for the same shipment */
      /* with a manual qty that is not equal to zero and has the same     */
      /* sign (pos or neg) as the EDI usage qty.  Increment or decrement  */
      /* the manual qty by the amount of the EDI usage qty or until it    */
      /* becomes  zero, whichever occurs first.  If there is remaining    */
      /* EDI usage qty, continue to read more cncu_mstr records and use   */
      /* up their manual qty.  If there are no more cncu_mstr records,    */
      /* the EDI usage qty remaining should be issued and the sales order */
      /* quantities updated.                                              */

      /* Manual quantities:                                               */
      /*   origin = adjustment (from Aging)                               */
      /*   origin = manual     (from Auto-Create)                         */
      /*                         so verify the match on cust_usage_ref.   */

      for each cncu_mstr
         where cncu_mstr.cncu_domain    = global_domain
         and  (cncu_mstr.cncu_so_nbr    = bUsage.order_nbr
         and   cncu_mstr.cncu_sod_line  = bUsage.order_line
         and   cncu_mstr.cncu_lotser    = bUsage.lotser
         and   cncu_mstr.cncu_ref       = bUsage.ref
         and   cncu_mstr.cncu_auth      = bUsage.auth
         and   cncu_mstr.cncu_cust_job  = bUsage.cust_job
         and   cncu_mstr.cncu_cust_seq  = bUsage.cust_seq
         and   cncu_mstr.cncu_cust_ref  = bUsage.cust_ref
         and  (cncu_mstr.cncu_origin    = ADJUSTMENT
                                   or
              (cncu_mstr.cncu_origin    = MANUAL
         and   cncu_mstr.cncu_cust_usage_ref = bUsage.cust_usage_ref))
         and ((cncu_mstr.cncu_manual_qty < 0  and working_qty < 0)
                                   or
             (cncu_mstr.cncu_manual_qty > 0  and working_qty > 0)))
      exclusive-lock
      break by cncu_mstr.cncu_so_nbr
            by cncu_mstr.cncu_sod_line
            by cncu_mstr.cncu_batch:

         out_um_conv = 1.

         /* Convert the qty passed in to the UM of the cncu master record */
         if bUsage.cncud_usage_um <> cncu_mstr.cncu_usage_um then do:
            run callUmConvertProgram
               (input bUsage.cncud_usage_um,
                input cncu_mstr.cncu_usage_um,
                input bUsage.part,
                output out_um_conv).

            if return-value <> {&SUCCESS-RESULT} then
               return {&GENERAL-APP-EXCEPT}.
         end.

         assign
             working_qty = working_qty * out_um_conv.

         if (working_qty >= cncu_mstr.cncu_manual_qty and
             working_qty > 0)
                or
            (working_qty <= cncu_mstr.cncu_manual_qty and
             working_qty < 0)
         then
            assign
               working_qty = (working_qty - cncu_mstr.cncu_manual_qty)
               cncu_mstr.cncu_manual_qty = 0.
         else
            assign
               cncu_mstr.cncu_manual_qty =
                         cncu_mstr.cncu_manual_qty - working_qty
               working_qty = 0.

         out_um_conv = 1.

         /* Convert the working qty back to the um it originally came in as */
         if bUsage.cncud_usage_um <> cncu_mstr.cncu_usage_um then do:
            run callUmConvertProgram
               (input cncu_mstr.cncu_usage_um,
                input bUsage.cncud_usage_um,
                input bUsage.part,
                output out_um_conv).

            if return-value <> {&SUCCESS-RESULT} then
               return {&GENERAL-APP-EXCEPT}.

         end.

         assign working_qty = working_qty * out_um_conv.

         if working_qty = 0 then
            leave.

      end. /* FOR EACH cncu_mstr */
   end.   /* IF bUsage.origin = EDI */

   /* Create the ISS-SO and CN-USE transaction history and update   */
   /* the sales order qty and invoice flag for the usage qty. This  */
   /* section processes manual records and EDI quantities that have */
   /* not already been previously posted on a manual record.        */

   if (bUsage.origin <> EDI) or (working_qty <> 0) then do:
      /* Determine Consignment Accounts */
      {gprun.i ""socnacct.p""
               "(input bUsage.part,
                 input bUsage.site,
                 input bUsage.cncud_current_loc,
                 output consign_inv_acct,
                 output consign_inv_sub,
                 output consign_inv_cc,
                 output consign_intrans_acct,
                 output consign_intrans_sub,
                 output consign_intrans_cc,
                 output consign_offset_acct,
                 output consign_offset_sub,
                 output consign_offset_cc)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GUI*/ if global-beam-me-up then undo, leave.


      /* Determine Consignment options found on Order/Line */
      {gprun.i ""socnsod1.p""
               "(input bUsage.order_nbr,
                 input bUsage.order_line,
                 output consigned_line_item,
                 output consign_loc,
                 output intrans_loc,
                 output max_aging_days,
                 output auto_replenish)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GUI*/ if global-beam-me-up then undo, leave.


      for first so_mstr
         where so_mstr.so_domain = global_domain
         and   so_mstr.so_nbr    = bUsage.order_nbr
      no-lock:
         for first sod_det
            where  sod_domain = global_domain and
                   sod_nbr    = so_mstr.so_nbr and
                   sod_line   = bUsage.order_line
         no-lock:
            sod_recno = recid(sod_det).
         end.
      end.

      /* If the sales order line is missing, return an error*/
      if not available sod_det then
         return {&RECORD-NOT-FOUND}.

      {gpsct06.i &part=sod_part
                 &site=sod_site
                 &type=""GL""}

      for first pt_mstr
         where pt_domain = global_domain
         and   pt_part   = bUsage.part
      no-lock: end.

      assign
         prev_found  = yes
         sct_recno   = recid(sct_det)
         recno       = sct_recno
         out_um_conv = 1.

      /* UNIT OF MEASURE CONVERSIONS - STOCK UM */
      if bUsage.cncud_usage_um <> pt_um then do:

         /* Get the correct unit of measure conversion factor */
         run callUmConvertProgram
            (input bUsage.cncud_usage_um,
             input pt_um,
             input bUsage.part,
             output out_um_conv).

         if return-value <> {&SUCCESS-RESULT} then
            return {&GENERAL-APP-EXCEPT}.
         if bUsage.cncud_usage_um =  sod_um
            and out_um_conv       <> sod_um_conv
         then
            out_um_conv = sod_um_conv.
      end. /* IF  bUsage.cncud_usage_um <> pt_um THEN */

      assign
         working_inv_qty = working_qty * out_um_conv
         out_um_conv = 1.

      /* UNIT OF MEASURE CONVERSIONS - SALES ORDER UM */
      if sod_um <> pt_um then do:

         /* Get the correct unit of measure conversion factor */
         run callUmConvertProgram
            (input  pt_um,
             input  sod_um,
             input  bUsage.part,
             output out_um_conv).

         if return-value <> {&SUCCESS-RESULT} then
            return {&GENERAL-APP-EXCEPT}.
         if bUsage.cncud_usage_um =  sod_um
            and out_um_conv       <> sod_um_conv
         then
            out_um_conv =  sod_um_conv.
      end. /* IF sod_um <> pt_um THEN  */
      if bUsage.cncud_usage_um = sod_um
      then
         working_sod_qty = working_qty.
      else
         working_sod_qty = round((working_inv_qty * out_um_conv),5).
      /* Update Sales Order detail invoice and cum quantities */
      run updateSalesOrderQuantities
         (input  inventory_domain,
          input  ip_invoice_domain,
          input  bUsage.order_nbr,
          input  bUsage.order_line,
          input  working_sod_qty,
          input  bUsage.eff_date,
          input  bUsage.site,
          input  bUsage.cncud_asn_shipper,
          output order_cum_used_qty,
          input-output bUsage.cncud_price,
          input-output table tt_so_update,
          input-output bUsage.cncud__qadc01).

      /* Create ISS-SO transaction record                             */
      /* Read the sales order master, sales order detail, abs master, */
      /* transaction history, part master and general ledger control  */
      /* file to get data needed to call ictrans.i to create the      */
      /* sales order transaction history.  Also call the exchange rate*/
      /* routine to get the correct exchange rate to pass to ictrans.i*/

      for first tt_so_update
         where tt_inventory_domain = global_domain
         and   tt_sod_site         = bUsage.site
         and   tt_shipper          = bUsage.cncud_asn_shipper
      no-lock: end.

      for first abs_mstr
         where abs_domain = global_domain
         and   abs_shipfrom = bUsage.site
         and   abs_id = "s" + bUsage.cncud_asn_shipper
      no-lock: end.

      for first pl_mstr
         where pl_domain    = global_domain
         and   pl_prod_line = pt_prod_line
      no-lock: end.

      for first pld_det
         where pld_domain   = global_domain
         and   pld_prodline = pt_prod_line
         and   pld_site     = bUsage.site
         and   pld_loc      = bUsage.cncud_current_loc
      no-lock: end.

      for first tr_hist
         where tr_domain = global_domain
         and   tr_trnbr  = bUsage.cncud_ship_trnbr
      no-lock: end.

      if not available tr_hist then
         return {&GENERAL-APP-EXCEPT}.

      for first si_mstr
         fields (si_domain si_db si_desc si_entity si_site)
         where   si_domain = global_domain
         and     si_site   = sod_site
      no-lock: end.

      assign
         sod_entity      = si_entity
         first_so_entity = if available si_mstr then si_entity
                           else "".

      assign
         eff_date   = bUsage.eff_date
         lotser     = bUsage.lotser
         location   = bUsage.cncud_current_loc
         base-price =  sod_price / sod_um_conv.

      /*! MULTI-DB: USE SHIP-TO CUSTOMER TYPE FOR DEFAULT
       *  IF AVAILABLE ELSE USE BILL-TO TYPE USED TO
       *  FIND COGS ACCOUNT IN SOCOST02.p */

      if ip_invoice_domain <> global_domain
      then do:
         /* SWITCH TO INVOICE DOMAIN */
         run switchDomain
            (input  ip_invoice_domain,
             output l_undo_flag).

         if l_undo_flag
         then
            undo, return.
      end. /* IF ip_invoice_domain <> global_domain */

      {gprun.i ""gpcust.p""
              "(input  bUsage.order_nbr,
                output ord-db-cmtype)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GUI*/ if global-beam-me-up then undo, leave.


      {gprun.i ""socnconv.p""
               "(input  so_nbr,
                 input  bUsage.eff_date,
                 output exch_rate,
                 output exch_rate2,
                 output exch_ratetype,
                 output exch_exru_seq,
                 input-output base-price)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GUI*/ if global-beam-me-up then undo, leave.


      if inventory_domain <> global_domain
      then do:
         /* SWITCH TO INVENTORY DOMAIN */
         run switchDomain
            (input  inventory_domain,
             output l_undo_flag).

         if l_undo_flag
         then
            undo, return.
      end. /* IF inventory_domain <> global_domain */

      for first gl_ctrl
         fields (gl_domain gl_rnd_mthd)
         where   gl_domain = global_domain
      no-lock: end.

      if io_trnbr = 0 then do:
         {ictrans.i
            &addrid="so_cust"
            &bdnstd=0
            &cracct="if available pt_mstr then
                        if available pld_det then pld_inv_acct
                        else pl_inv_acct
                     else """""
            &crsub="if available pt_mstr then
                       if available pld_det then pld_inv_sub
                       else pl_inv_sub
                    else """""
            &crcc="if available pt_mstr then
                      if available pld_det then pld_inv_cc
                      else pl_inv_cc
                   else """""
            &crproj="sod_project"
            &curr="so_curr"
            &dracct=""""
            &drsub=""""
            &drcc=""""
            &drproj="sod_project"
            &effdate="bUsage.eff_date"
            &exrate="exch_rate"
            &exrate2="exch_rate2"
            &exratetype="exch_ratetype"
            &exruseq="exch_exru_seq"
            &glamt="gl_amt"
            &invmov="(if available abs_mstr then abs_inv_mov else """")"
            &lbrstd=0
            &line="bUsage.order_line"
            &location="bUsage.cncud_current_loc"
            &lotnumber= "tr_lot"
            &lotserial="bUsage.lotser"
            &lotref="bUsage.ref"
            &mtlstd="if sod_type = 'M' and not available pt_mstr
                     then sod_std_cost else 0"
            &ordernbr="sod_nbr"
            &ovhstd=0
            &part="bUsage.part"
            &perfdate="sod_per_date"
            &price="base-price"
            &quantityreq=0
            &quantityshort="sod_bo_chg"
            &quantity=" - ip_tot_lotser_qty"
            &revision=""""
            &rmks=""""
            &shipdate="bUsage.cncud_ship_date"
            &shipnbr=""""
            &shiptype="sod_type"
            &site="sod_site"
            &slspsn1="sod_slspsn[1]"
            &slspsn2="sod_slspsn[2]"
            &slspsn3="tr_slspsn[3] = sod_slspsn[3]"
            &slspsn4="tr_slspsn[4] = sod_slspsn[4]"
            &sojob="if sod_fsm_type begins """RMA""" then sod_contr_id
                    else sod_nbr"
            &substd=0
            &transtype=""ISS-SO""
            &msg=0
            &ref_site="tr_site"
            &tempid=1
            &trordrev="tr_ord_rev = so_rev"}

         io_trnbr = tr_trnbr.

         if available pt_mstr
            and sod_det.sod_prodline <> pt_prod_line
         then
         if     sod_det.sod_fsm_type = ""
            and sod_det.sod_rma_type = ""
         then do for b_sod_det:
            find b_sod_det
               where b_sod_det.sod_domain = global_domain
               and   b_sod_det.sod_nbr    = sod_det.sod_nbr
               and   b_sod_det.sod_line   = sod_det.sod_line
            exclusive-lock no-error.
            if available b_sod_det
            then
               b_sod_det.sod_prodline = pt_prod_line.
         end. /* IF sod_det.sod_fsm_type = "" and */

         {gprun.i ""socost01.p""
                  "(- ip_tot_lotser_qty,
                    bUsage.lotser,
                    no,
                    sod_entity,
                    bUsage.cncud_current_loc,
                    input recid(tr_hist))"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GUI*/ if global-beam-me-up then undo, leave.


         {gprun.i ""socost02.p""
                  "(input - ip_tot_lotser_qty,
                    input  sod_entity,
                    input recid(trgl_det),
                    input recid(tr_hist) )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GUI*/ if global-beam-me-up then undo, leave.


         /* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
         {gprun.i ""gpmfc01.p""
                  "(input 'enable_supplier_consignment',
                    input 11,
                    input 'ADG',
                    input 'cns_ctrl',
                    output using_supplier_consignment)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GUI*/ if global-beam-me-up then undo, leave.


         /* CREATE CONSIGNMENT USAGE RECORDS IF CONSIGNMENT ENABLED */
         /* AND CONSIGNMENT INVENTORY EXISTS.                       */
         if using_supplier_consignment
            and ip_tot_lotser_qty > 0
            /* DON'T CREATE RCT-PO AND CN-ISS TRANSACTIONS WHEN REVERSING */
            /* CUSTOMER CONSIGNED USAGE OF SUPPLIER CONSIGNED INVENTORY.  */
         then do:
            {gprun.i ""pocnsix4.p""
                     "(input sod_part,
                       input sod_site,
                       input location,
                       input bUsage.lotser,
                       input bUsage.ref,
                       input false,
                       output supplier_consign_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GUI*/ if global-beam-me-up then undo, leave.


            /* IF CONSIGNED INVENTORY EXISTS, DETERMINE WHETHER TO */
            /* USE IT PRIOR TO UNCONSIGNED INVENTORY.              */
            if supplier_consign_flag then do:
               {gprun.i ""ictrancn.p""
                        "(input sod_nbr,
                          input '',
                          input 0,
                          input tr_so_job,
                          input ip_tot_lotser_qty,
                          input bUsage.lotser,
                          input sod_part,
                          input sod_site,
                          input location,
                          input bUsage.ref,
                          input eff_date,
                          input tr_trnbr,
                          input FALSE,
                          input-output io_batch)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GUI*/ if global-beam-me-up then undo, leave.


            end.   /* IF supplier_consign_flag */
         end.   /* IF USING_SUPPLIER_CONSIGNMENT */
      end.   /* IF io_trnbr = "" */

      /* Set the debit and credit accounts for inventory location */
      assign
         dr_acct = consign_offset_acct
         dr_sub  = consign_offset_sub
         dr_cc   = consign_offset_cc
         cr_acct = (if location = intrans_loc then consign_intrans_acct
                    else consign_inv_acct)
         cr_sub  = (if location = intrans_loc then consign_intrans_sub
                    else consign_inv_sub)
         cr_cc   = (if location = intrans_loc then consign_intrans_cc
                    else consign_inv_cc).

      /* Create a CN-USE transaction history record */
      {ictrans.i
          &addrid="so_cust"
          &bdnstd=0
          &cracct="cr_acct"
          &crsub="cr_sub"
          &crcc="cr_cc"
          &crproj="sod_project"
          &curr="so_curr"
          &dracct="dr_acct"
          &drsub="dr_sub"
          &drcc="dr_cc"
          &drproj="sod_project"
          &effdate="bUsage.eff_date"
          &exrate="exch_rate"
          &exrate2="exch_rate2"
          &exratetype="exch_ratetype"
          &exruseq="exch_exru_seq"
          &glamt="sct_cst_tot * working_inv_qty"
          &invmov="(if available abs_mstr then abs_inv_mov else """")"
          &lbrstd=0
          &line="bUsage.order_line"
          &location="bUsage.cncud_current_loc"
          &lotnumber= "tr_lot"
          &lotserial="bUsage.lotser"
          &lotref="bUsage.ref"
          &mtlstd="if sod_type = 'M' and not available pt_mstr
                   then sod_std_cost else 0"
          &ordernbr="sod_nbr"
          &ovhstd=0
          &part="bUsage.part"
          &perfdate="sod_per_date"
          &price="base-price"
          &quantityreq=0
          &quantityshort="sod_bo_chg"
          &quantity=0
          &revision=""""
          &rmks="string(io_trnbr)"
          &shipdate="bUsage.cncud_ship_date"
          &shipnbr="bUsage.cncud_asn_shipper"
          &shiptype="sod_type"
          &site="sod_site"
          &slspsn1="sod_slspsn[1]"
          &slspsn2="sod_slspsn[2]"
          &slspsn3="tr_slspsn[3] = sod_slspsn[3]"
          &slspsn4="tr_slspsn[4] = sod_slspsn[4]"
          &sojob="if sod_fsm_type begins """RMA""" then sod_contr_id
                  else sod_nbr"
          &substd=0
          &transtype=""CN-USE""
          &msg=0
          &ref_site="tr_site"
          &tempid=1
          &trordrev="tr_ord_rev = so_rev"}

      /* Update the appropriate cross reference records */
      /* ADDED 20TH PARAMETER TO INDICATE THE REVERSAL OF THE SHIPMENT */
      {gprun.i ""socncix.p""
               "(input bUsage.order_nbr,
                 input bUsage.order_line,
                 input bUsage.site,
                 input bUsage.cncud_ship_date,
                 input ( - working_inv_qty),
                 input bUsage.cncud_stock_um,
                 input bUsage.cncud_asn_shipper,
                 input bUsage.cncud_ship_trnbr,
                 input bUsage.cncud_current_loc,
                 input bUsage.lotser,
                 input bUsage.ref,
                 input bUsage.auth,
                 input bUsage.cust_job,
                 input bUsage.cust_seq,
                 input bUsage.cust_ref,
                 input bUsage.cncud_cust_dock,
                 input bUsage.cncud_line_feed,
                 input bUsage.modelyr,
                 input no,
                 input no,
                 input-output first_time_in,
         input """")"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GUI*/ if global-beam-me-up then undo, leave.

      for first cncix_mstr
         where cncix_domain       = global_domain
         and   cncix_so_nbr       = bUsage.order_nbr
         and   cncix_sod_line     = bUsage.order_line
         and   cncix_lotser       = bUsage.lotser
         and   cncix_ref          = bUsage.ref
         and   cncix_auth         = bUsage.auth
         and   cncix_cust_job     = bUsage.cust_job
         and   cncix_cust_ref     = bUsage.cust_ref
         and   cncix_cust_dock    = bUsage.cncud_cust_dock
         and   cncix_line_feed    = bUsage.cncud_line_feed
         and   cncix_asn_shipper  = bUsage.cncud_asn_shipper
         and   cncix_site         = bUsage.site
         and   cncix_current_loc  = bUsage.cncud_current_loc
      exclusive-lock:
      end.
      if available cncix_mstr
         and cncix__qadc01 = ""
      then
         cncix__qadc01 = bUsage.cncud__qadc01.

       first_time_in = no.

       if     bUsage.cncud_selfbill
          and bUsage.cncud_asn_shipper <> ""
       then do:
          if ip_invoice_domain <> global_domain
          then do:
             /* SWITCH TO INVOICE DOMAIN */
             run switchDomain
                (input  ip_invoice_domain,
                 output l_undo_flag).

             if l_undo_flag
             then
                undo, return.
          end. /* IF ip_invoice_domain <> global_domain */

          {gprun.i ""socnshrf.p""
                   "(input bUsage.order_nbr,
                     input bUsage.order_line,
                     input working_sod_qty,
                     input sod_site,
                     input so_cust,
                     input so_ship,
                     input so_bill,
                     input sod_part,
                     input (if sod_custpart <> ''
                            then
                               sod_custpart
                            else
                               sod_part),
                     input sod_um,
                     input sod_price,
                     input bUsage.cncud_asn_shipper,
                     input (if sod_sched
                            then
                               sod_contr_id
                            else
                               so_po),
                     input bUsage.selfbill_auth,
                     input bUsage.cncud_ship_date,
                     input so_curr)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GUI*/ if global-beam-me-up then undo, leave.


          if return-value <> {&SUCCESS-RESULT}
          then
             return {&GENERAL-APP-EXCEPT}.

          if inventory_domain <> global_domain
          then do:
             /* SWITCH TO INVENTORY DOMAIN */
             run switchDomain
                (input  inventory_domain,
                 output l_undo_flag).

             if l_undo_flag
             then
                undo, return.
          end. /* IF inventory_domain <> global_domain */


       end.  /* IF bUsage.cncud_selfbill */

   end.   /* IF origin <> EDI or working_qty <> 0 */

   /* This section will create/update usage master records  and create */
   /* detail usage records for manual or EDI usage.                    */

   /* Create the buffer to hold the usage master record */
   run disposeConsignUsageMasterBuffer
      (buffer bConsignUsageMaster).

   run createConsignUsageMasterBuffer
      (buffer bConsignUsageMaster).

   /* Create or update consignment usage master record, cncu_mstr */
   /* Get a usage id if one was not passed in and create a usage master rec */
   if bUsage.cncu_batch = 0 then do:
      {mfrnseq.i bUsage bUsage.cncu_batch cncu_sq02}
   end.

   assign
      bConsignUsageMaster.cncu_batch    = bUsage.cncu_batch
      bConsignUsageMaster.cncu_so_nbr   = bUsage.order_nbr
      bConsignUsageMaster.cncu_sod_line = bUsage.order_line
      bConsignUsageMaster.cncu_lotser   = bUsage.lotser
      bConsignUsageMaster.cncu_ref      = bUsage.ref
      bConsignUsageMaster.cncu_auth     = bUsage.auth
      bConsignUsageMaster.cncu_cust_job = bUsage.cust_job
      bConsignUsageMaster.cncu_cust_seq = bUsage.cust_seq
      bConsignUsageMaster.cncu_cust_ref = bUsage.cust_ref
      bConsignUsageMaster.cncu_trans_date = bUsage.trans_date
      bConsignUsageMaster.cncu_eff_date = bUsage.eff_date
      bConsignUsageMaster.cncu_cust_usage_date =
                                          bUsage.cust_usage_date.

   if not isConsignUsageMasterExists (buffer bConsignUsageMaster) then do:

      run createConsignUsageMasterPrimaryKey
         (buffer bConsignUsageMaster).

      run createConsignUsageMaster
         (buffer bConsignUsageMaster).

      assign
         bConsignUsageMaster.cncu_origin     = bUsage.origin
         bConsignUsageMaster.cncu_cust_usage_ref
                                             = bUsage.cust_usage_ref
         bConsignUsageMaster.cncu_site       = bUsage.site
         bConsignUsageMaster.cncu_shipto     = bUsage.shipto
         bConsignUsageMaster.cncu_cust       = bUsage.cust
         bConsignUsageMaster.cncu_part       = bUsage.part
         bConsignUsageMaster.cncu_custpart   = bUsage.cust_part
         bConsignUsageMaster.cncu_usage_qty  = bUsage.cncud_usage_qty
         bConsignUsageMaster.cncu_usage_um   = bUsage.cncud_usage_um
         bConsignUsageMaster.cncu_usage_um_conv
                                             = bUsage.cncud_usage_um_conv
         bConsignUsageMaster.cncu_cum_qty    = order_cum_used_qty
         bConsignUsageMaster.cncu_po         = bUsage.po
         bConsignUsageMaster.cncu_selfbill_auth
                                             = bUsage.selfbill_auth
         bConsignUsageMaster.cncu_manual_qty = (if bUsage.origin = MANUAL
                                                then bUsage.cncud_usage_qty
                                                else 0)
         bConsignUsageMaster.cncu_trnbr      = io_trnbr.

      run updateConsignUsageMaster
         (buffer bConsignUsageMaster).

   end.   /* IF return-value = not {&SUCCESS-RESULT} */
   else do:
      /* Get the usage master record using the usage id and keys passed in    */
      /* by the calling programs.                                             */
      run readConsignUsageMaster
         (buffer bConsignUsageMaster,
          input  {&NO_LOCK_FLAG},
          input  {&NO_WAIT_FLAG}).

      if return-value = {&SUCCESS-RESULT} then do:
         assign
            out_um_conv = 1
            hold_cncu_usage_um =  bConsignUsageMaster.cncu_usage_um.

         if bUsage.cncud_usage_um <> bConsignUsageMaster.cncu_usage_um then do:

            run callUmConvertProgram
               (input bUsage.cncud_usage_um,
                input bConsignUsageMaster.cncu_usage_um,
                input bUsage.part,
                output out_um_conv).

            if return-value <> {&SUCCESS-RESULT} then
               return {&GENERAL-APP-EXCEPT}.

            bUsage.cncud_usage_qty = bUsage.cncud_usage_qty
                                            * out_um_conv.

         end.   /* IF bUsage.cncud_usage_um <> */

         assign
            bConsignUsageMaster.cncu_cum_qty = bConsignUsageMaster.cncu_cum_qty
                                             + bUsage.cncud_usage_qty
            bConsignUsageMaster.cncu_usage_qty =
               bConsignUsageMaster.cncu_usage_qty
               + bUsage.cncud_usage_qty
            bConsignUsageMaster.cncu_manual_qty =
              (if bUsage.origin = MANUAL then
                 (bConsignUsageMaster.cncu_manual_qty
                  + bUsage.cncud_usage_qty)
               else
                  bConsignUsageMaster.cncu_manual_qty).

         run updateConsignUsageMaster
            (buffer bConsignUsageMaster).

         out_um_conv = 1.
         if bUsage.cncud_usage_um <> hold_cncu_usage_um then do:

            run callUmConvertProgram
               (input hold_cncu_usage_um,
                input bUsage.cncud_usage_um,
                input bUsage.part,
                output out_um_conv).
            if return-value <> {&SUCCESS-RESULT} then
               return {&GENERAL-APP-EXCEPT}.

            bUsage.cncud_usage_qty = bUsage.cncud_usage_qty
                                            * out_um_conv.

         end.  /* IF bUsage.cncud_usage_um <> hold_cncu_usage_um */
      end.   /* IF return-value = {&SUCCESS-RESULT} */
   end.   /* ELSE DO*/

   /* Create consignment usage detail record, cncud_det */
   run createConsignUsageDetailBuffer
      (buffer bConsignUsageDetail).

   /* Populate the key fields in order to create a usage detail record */
   assign
      bConsignUsageDetail.cncud_cncu_pkey      = bConsignUsageMaster.cncu_pkey
      bConsignUsageDetail.cncud_cncix_pkey     = bUsage.cncud_cncix_pkey
      bConsignUsageDetail.cncud_cust_dock      = bUsage.cncud_cust_dock
      bConsignUsageDetail.cncud_line_feed      = bUsage.cncud_line_feed
      bConsignUsageDetail.cncud_ship_date      = today
      bConsignUsageDetail.cncud_aged_date      = bUsage.cncud_aged_date
      bConsignUsageDetail.cncud_orig_aged_date =
         bUsage.cncud_orig_aged_date.

   if not isConsignUsageDetailExists (buffer bConsignUsageDetail) then do:

      run createConsignUsageDetail
         (buffer bConsignUsageDetail).

      /* Populate the remaining usage detail fields and udpate the record */
      assign
         bConsignUsageDetail.cncud_selfbill      = bUsage.cncud_selfbill
         bConsignUsageDetail.cncud_qty_ship      = bUsage.cncud_qty_ship
         bConsignUsageDetail.cncud_usage_um      = bUsage.cncud_usage_um
         bConsignUsageDetail.cncud_usage_um_conv =
            bUsage.cncud_usage_um_conv
         bConsignUsageDetail.cncud_stock_um      = bUsage.cncud_stock_um
         bConsignUsageDetail.cncud_price         = bUsage.cncud_price
         bConsignUsageDetail.cncud_ship_value    = bUsage.cncud_ship_value
         bConsignUsageDetail.cncud_curr          = bUsage.cncud_curr
         bConsignUsageDetail.cncud_asn_shipper   =
            bUsage.cncud_asn_shipper
         bConsignUsageDetail.cncud_ship_date     = bUsage.cncud_ship_date
         bConsignUsageDetail.cncud_usage_qty     = bUsage.cncud_usage_qty
         bConsignUsageDetail.cncud_current_loc   =
            bUsage.cncud_current_loc
         bConsignUsageDetail.cncud_ship_trnbr    = bUsage.cncud_ship_trnbr
         bConsignUsageDetail.cncud__qadc01       = bUsage.cncud__qadc01.

      run updateConsignUsageDetail
         (buffer bConsignUsageDetail).

   end.    /* IF NOT isConsignUsageDetailExists */
   else do:

      /* Get the usage detail record using the master record key */
      run readConsignUsageDetail
         (buffer bConsignUsageDetail,
          input  {&NO_LOCK_FLAG},
          input  {&NO_WAIT_FLAG}).

      if return-value = {&SUCCESS-RESULT} then do:
         assign
            out_um_conv = 1
            hold_cncud_usage_um =  bConsignUsageDetail.cncud_usage_um.

         if bUsage.cncud_usage_um <> bConsignUsageDetail.cncud_usage_um
         then do:

            run callUmConvertProgram
               (input bUsage.cncud_usage_um,
                input bConsignUsageDetail.cncud_usage_um,
                input bUsage.part,
                output out_um_conv).
            if return-value <> {&SUCCESS-RESULT} then
               return {&GENERAL-APP-EXCEPT}.

            bUsage.cncud_usage_qty = bUsage.cncud_usage_qty
                                            * out_um_conv.

         end.

         bConsignUsageDetail.cncud_usage_qty =
            bConsignUsageDetail.cncud_usage_qty
            + bUsage.cncud_usage_qty.

         run updateConsignUsageDetail
            (buffer bConsignUsageDetail).

         out_um_conv = 1.
         if bUsage.cncud_usage_um <> hold_cncud_usage_um then do:

            run callUmConvertProgram
               (input hold_cncud_usage_um,
                input bUsage.cncud_usage_um,
                input bUsage.part,
                output out_um_conv).
            if return-value <> {&SUCCESS-RESULT} then
               return {&GENERAL-APP-EXCEPT}.

            bUsage.cncud_usage_qty =
               bUsage.cncud_usage_qty * out_um_conv.

         end.   /* IF bUsage.cncud_usage_um <> hold_cncu_usage_um */
      end.   /* IF return-value = {&SUCCESS-RESULT} */
   end.   /* ELSE DO */
end.   /* DO ON ERROR UNDO */

return {&SUCCESS-RESULT}.


/* ========================================================================= */
/* ************************ INTERNAL PROCEDURES **************************** */
/* ========================================================================= */

/* ========================================================================= */
PROCEDURE updateSalesOrderQuantities:
/* -------------------------------------------------------------------------
 * Purpose:   This procedure updates the invoice qty, the cum shipped qty and
 *            the cum shipped qty over the life of the contract. This routine
 *            also sets the ready to invoice flag to yes.
 * ------------------------------------------------------------------------- */
   define input  parameter inventory_domain as   character              no-undo.
   define input  parameter invoice_domain   as   character              no-undo.
   define input  parameter p_order          like sod_nbr                no-undo.
   define input  parameter p_line           like sod_line               no-undo.
   define input  parameter p_qty            as   decimal                no-undo.
   define input  parameter p_eff_date       as   date                   no-undo.
   define input  parameter p_site           like cncix_site             no-undo.
   define input  parameter p_shipper        like cncud_det.cncud_asn_shipper
                                                                        no-undo.
   define output parameter p_cum_qty        like sod_qty_ord            no-undo.
   define input-output parameter p_price    like sod_price              no-undo.
   define input-output parameter table      for  tt_so_update.
   define input-output parameter p_fr_chrg  as  character               no-undo.

   define variable pc_recno                 as   recid                  no-undo.
   define variable net_price                like sod_price              no-undo.
   define variable list_price               like sod_list_pr            no-undo.
   define variable undo_flag                as   logical                no-undo.
   define variable cum_date                 as   date                   no-undo.
   define variable qty_inv                  like sod_qty_inv            no-undo.
   define variable l_oldnetprice            like sod_price              no-undo.

   define buffer sod_det  for sod_det.
   define buffer so_mstr  for so_mstr.
   define buffer soc_ctrl for soc_ctrl.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      for first sod_det
         where sod_domain = global_domain
         and   sod_nbr    = p_order
         and   sod_line   = p_line
      no-lock:
         assign
            net_price  = sod_price
            list_price = sod_list_pr.

/*521         if sod_sched                                                 */
/*521        and sod_pr_list <> ""                                         */
/*521*/   if sod_pr_list <> ""
         then do: /* NO PRICE LIST LOOKUP FOR DISCRETE ORDERS AT USAGE    */

            for first soc_ctrl
               fields (soc_domain soc_pl_req)
               where soc_domain = global_domain
            no-lock:

               for first so_mstr
                  fields (so_domain so_nbr so_curr)
                  where so_domain = global_domain
                  and   so_nbr    = sod_nbr
               no-lock:

                  /* WHEN USING CENTRALIZED ORDERS, PRICE */
                  /* LISTS ARE ONLY ON INVOICE DOMAIN     */
                  if invoice_domain <> global_domain then do:
                     /* SWITCH TO INVOICE DOMAIN */
                        run switchDomain
                           (input  invoice_domain,
                            output undo_flag).

                        if undo_flag then
                           undo, return.
                  end.

                  /* FOR SCHEDULED ORDERS LOOK UP THE SO PRICE USING THE  */
                  /* PRICE LIST ON THE SCHEDULED ORDER IF ONE HAS BEEN    */
                  /* SPECIFIED. IF THERE ISN'T A PRICE LIST, OR THE PRICE */
                  /* LIST LOOKUP RETURNS A ZERO PRICE, THEN USE THE PRICE */
                  /* ON THE SCHEDULED ORDER.                              */
                  /* CONSIGNMENT IGNORES QTY BREAKS IN PRICE LIST TABLES  */
                  /* BECAUSE USAGE QTY'S FROM ONE BATCH GET COMBINED INTO */
                  /* ONE INVOICE. THEREFORE THE FIRST ENTRY IN THE PRICE  */
                  /* LIST TABLE WILL BE USED.                             */
                  {gprun.i ""socnpcal.p""
                           "(input        sod_part,
                             input        sod_um,
                             input        sod_um_conv,
                             input        so_curr,
                             input        sod_pr_list,
                             input        p_eff_date,
                             input        sod_std_cost,
                             input        soc_pl_req,
                             input-output list_price,
                             input-output net_price,
                             output       pc_recno)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GUI*/ if global-beam-me-up then undo, leave.



                  if inventory_domain <> global_domain
                  then do:
                    /* SWITCH TO INVENTORY DOMAIN */
                    run switchDomain
                       (input  inventory_domain,
                        output undo_flag).

                    if undo_flag
                    then
                       undo, return.
                  end.

                  for first pc_mstr
                     where recid(pc_mstr) = pc_recno
                  no-lock:
                  end. /* FOR FIRST */
                  if available pc_mstr
                     and pc_amt_type <> "D"
                  then do:
                     for first ft_mstr
                        where ft_domain = global_domain
                        and   ft_terms  = so_fr_terms
                     no-lock:
                     end.
                     if available ft_mstr
                        and ft_type = "5"
                        and sod_fr_list <> ""
                     then do:
                        if sod_price <> net_price
                        then do:
                           if p_fr_chrg = ""
                           then do:
                              l_oldnetprice = net_price.
                              {gprun.i ""socnfrcl.p""
                                 "(input        recid(sod_det),
                                   input        p_site,
                                   input        p_shipper,
                                   input-output net_price)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GUI*/ if global-beam-me-up then undo, leave.

                              p_fr_chrg = string(net_price - l_oldnetprice).
                           end. /* IF p_fr_chrg = ""  THEN  */
                           else
                              net_price = net_price + decimal(p_fr_chrg).
                        end. /* IF sod_price <> net_price THEN */
                     end. /* IF available ft_mstr THEN   */
                  end. /* IF AVAILABLE pc_mstr THEN */
                  if p_price <> net_price
                  then
                     p_price = net_price.
               end.   /* FOR FIRST so_mstr */
            end.   /* FOR FIRST soc_ctrl */

         end.   /* IF sod_sched */

         /* UPDATE sod_det AND so_mstr */
         {gprun.i ""socnisa.p""
                 "(input  p_order,
                   input  p_line,
                   input  pc_recno,
                   input  list_price,
                   input  net_price,
                   input  p_qty,
                   input  p_eff_date,
                   output cum_date,
                   output qty_inv,
                   output p_cum_qty)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GUI*/ if global-beam-me-up then undo, leave.


         if return-value <> {&SUCCESS-RESULT} then
            undo, return.

         for each tt_so_update
            where tt_so_nbr   = p_order
            and   tt_sod_line = p_line
         exclusive-lock:
            assign
               tt_so_to_inv    = yes
               tt_so_bol       = ""
               tt_sod_cum_qty  = p_cum_qty
               tt_sod_cum_date = cum_date
               tt_sod_qty_inv  = qty_inv
               tt_sod_list_pr  = list_price
               tt_sod_price    = net_price.

         end.   /* FOR FIRST tt_so_update */
      end.   /* FOR FIRST sod_det */

      if not available sod_det then
         return {&RECORD-NOT-FOUND}.

   end.   /* DO ON ERROR UNDO */

   return {&SUCCESS-RESULT}.

END PROCEDURE.   /* updateSalesOrderQuantities */


/* ========================================================================= */
PROCEDURE callUmConvertProgram:
/* -------------------------------------------------------------------------
 * Purpose:      This calls the unit of measure conversion program.
 * ------------------------------------------------------------------------- */

   define input  parameter p_from_um     as character no-undo.
   define input  parameter p_to_um       as character no-undo.
   define input  parameter p_part        as character no-undo.
   define output parameter p_out_um_conv as decimal   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {gprun.i ""gpumcnv.p""
               "(input  p_from_um,
                 input  p_to_um,
                 input  p_part,
                 output p_out_um_conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GUI*/ if global-beam-me-up then undo, leave.


      if p_out_um_conv = ? then
         return {&GENERAL-APP-EXCEPT}.

   end.   /* DO ON ERROR UNDO */

   return {&SUCCESS-RESULT}.

END PROCEDURE.   /* callUmConvertProgram */

/* ========================================================================== */
PROCEDURE switchDomain:
/* -------------------------------------------------------------------------- */
   define input        parameter ip_domain         as character         no-undo.
   define output       parameter op_undo           as logical           no-undo.

   define variable err-flag                        as integer           no-undo.


   /* SWITCH TO INVOICE DOMAIN */
   {gprun.i ""gpmdas.p""
            "(input  ip_domain,
              output err-flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GUI*/ if global-beam-me-up then undo, leave.


   if err-flag <> 0 then do:
      /* DOMAIN # IS NOT AVAILABLE */
      {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=ip_domain}

      assign
         global_domain = ip_domain
         op_undo       = yes.
   end.

END PROCEDURE.   /* switchDomain */
