/* socnis.p - CUSTOMER CONSIGNMENT USAGE RECORD CREATION                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.49 $                                                              */
/******************************************************************************/
/* DESCRIPTION: This program creates the customer consignment usage records.  */
/*              It is called by the usage auto create program, the max aging  */
/*              date maintenance program, and the edi/ecommerce gateway       */
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
/* $Revision: 1.49 $        BY: Kirti Desai        DATE: 07/16/04  ECO: *P29S* */
/* $Revision: 1.49 $        BY: mage chen          DATE: 04/02/07  ECO: *minth* */
/* By: Neil Gao Date: 07/11/28 ECO: * ss 20071128 */

/*-Revision end---------------------------------------------------------------*/

/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */

/*V8:ConvertMode=Maintenance                                                  */






/*************************************************************以下为版本历史 */  
/* minth* 20070402 by Mage Chen  */
/* ss 20070302.1   By Neil Gao   */
/* SS - 090401.1  By: Roger Xiao */

/*************************************************************以下为发版说明 */

/* SS - 090401.1 - RNB
1.原程式库存记录锁定时间太长,原因查找abs_mstr时未加domain,太慢, 仅修改xxsocncixx.p
xxcnuac.p --> xxsocnuac2.p --> xxsocnis.p --> xxsocncixx.p
2.取消锁定库存记录:原xxsocnis.p直接调用ictrans.i,现改为: xxsocnis.p  --> xxictransxp01.p --> xxictransxp01.i
  并release ld_det & in_mstr 
  注意: &slspsn3 &slspsn4 &trordrev 在xxictransxp01.i与ictrans.i使用方式不同

SS - 090401.1 - RNE */


/* Include files */
{mfdeclre.i}
{gpoidfcn.i}   /* Defines nextOidValue() function */
{pxsevcon.i}
{socnvars.i}   /* CUSTOMER CONSIGNMENT VARIABLES */
{socncu.i}     /* SO CONSIGNMENT USAGE MASTER PROCEDURES */
{socncud.i}    /* SO CONSIGNMENT USAGE DETAIL PROCEDURES */
{gldydef.i}
{gldynrm.i}

define variable MANUAL     as character no-undo initial "01".
define variable EDI        as character no-undo initial "02".
define variable ADJUSTMENT as character no-undo initial "03".

/* Temp-Table Definitions */
define temp-table tt_cons_usage  no-undo like cncud_det
   field origin                     like cncu_mstr.cncu_origin
   field trans_date                 like cncu_mstr.cncu_trans_date
   field eff_date                   like cncu_mstr.cncu_eff_date
   field cust_usage_ref             like cncu_mstr.cncu_cust_usage_ref
   field cust_usage_date            like cncu_mstr.cncu_cust_usage_date
   field cncu_batch                 like cncu_mstr.cncu_batch
   field selfbill_auth              as character
   field so_nbr                     like cncu_mstr.cncu_so_nbr
   field sod_line                   like cncu_mstr.cncu_sod_line
   field lotser                     like cncu_mstr.cncu_lotser
   field ref                        like cncu_mstr.cncu_ref
   field auth                       like cncu_mstr.cncu_auth
   field cust_job                   like cncu_mstr.cncu_cust_job
   field cust_seq                   like cncu_mstr.cncu_cust_seq
   field cust_ref                   like cncu_mstr.cncu_cust_ref
   field site                       like cncu_mstr.cncu_site
   field shipto                     like cncu_mstr.cncu_shipto
   field cust                       like cncu_mstr.cncu_cust
   field cust_part                  like cncu_mstr.cncu_custpart
   field po                         like cncu_mstr.cncu_po
   field part                       like cncu_mstr.cncu_part
   field modelyr                    like cncu_mstr.cncu_modelyr.

define buffer bUsage    for tt_cons_usage.
define buffer b_sod_det for sod_det.

/* Input Parameters */
define input        parameter ip_tot_usage_qty as decimal no-undo.
define input        parameter ip_tot_lotser_qty as decimal no-undo.
define input        parameter p_consign_date    like glt_effdate no-undo.
define input-output parameter table for tt_cons_usage.
define input-output parameter io_trnbr  as integer no-undo.

/* Shared Variables */
define new shared variable eff_date        like glt_effdate.
define new shared variable ref             like glt_ref.
define new shared variable ord-db-cmtype   like cm_type no-undo.
define new shared variable sct_recno as recid initial ?.
define new shared variable sod_recno as recid initial ?.
define new shared variable trgl_recno as recid initial ?.
define new shared variable rndmthd         like rnd_rnd_mthd.
define new shared variable trqty           like tr_qty_chg.

/* Local VARIABLES */
define variable gl_amt                     like glt_amt no-undo.
define variable dr_acct                    like gl_inv_acct no-undo.
define variable dr_sub                     like gl_inv_sub  no-undo.
define variable dr_cc                      like gl_inv_cc   no-undo.
define variable cr_acct                    like gl_inv_acct no-undo.
define variable cr_sub                     like gl_inv_sub  no-undo.
define variable cr_cc                      like gl_inv_cc   no-undo.
define variable consigned_line_item        like mfc_logical no-undo.
define variable consign_inv_acct           as character no-undo.
define variable consign_inv_sub            as character no-undo.
define variable consign_inv_cc             as character no-undo.
define variable consign_intrans_acct       as character no-undo.
define variable consign_intrans_sub        as character no-undo.
define variable consign_intrans_cc         as character no-undo.
define variable consign_offset_acct        as character no-undo.
define variable consign_offset_sub         as character no-undo.
define variable consign_offset_cc          as character no-undo.
define variable exch_rate                  like exr_rate no-undo.
define variable exch_rate2                 like exr_rate2 no-undo.
define variable exch_ratetype              like exr_ratetype no-undo.
define variable exch_exru_seq              like exru_seq no-undo.
define variable mc-error-number as integer no-undo.
define variable gl_tmp_amt as decimal no-undo.
define variable order_cum_used_qty         like sod_qty_ord no-undo.
define variable working_qty                like
                                           cncud_det.cncud_usage_qty no-undo.
define variable working_sod_qty            like
                                           cncud_det.cncud_usage_qty no-undo.
define variable working_inv_qty            like
                                           cncud_det.cncud_usage_qty no-undo.
define variable sod_entity                 like en_entity no-undo.
define variable first_so_entity            like si_entity no-undo.
define variable lotser                     like sod_serial no-undo.
define variable prev_found                 like mfc_logical no-undo.
define variable location                   like sod_loc     no-undo.
define variable l_tr_type like tx2d_tr_type initial "13" no-undo.
define variable l_line    like tx2d_line    initial 0    no-undo.
define variable l_nbr     like tx2d_nbr     initial ""   no-undo.
define variable result-status as integer no-undo.
define variable out_um_conv                as decimal no-undo.
define variable hold_cncu_usage_um         as character no-undo.
define variable hold_cncud_usage_um        as character no-undo.
define variable base-price                 like tr_price no-undo.
define variable first_time_in              as logical initial yes no-undo.
define variable io_batch                   like cnsu_batch no-undo.
define variable using_supplier_consignment as logical no-undo.
define variable supplier_consign_flag      as logical no-undo.
define variable l_ship_date                like so_ship_date no-undo.


/* SS - 090401.1 - B */
define variable op_trglrecno as recid initial ?. 
define variable op_trrecno   as recid initial ?. 
/* SS - 090401.1 - E */




do on error undo, return error {&GENERAL-APP-EXCEPT}:

   find first bUsage exclusive-lock.

   if not available bUsage then
      return {&RECORD-NOT-FOUND}.

   assign
      prev_found = no
      working_qty = bUsage.cncud_usage_qty.

   if bUsage.origin = EDI then do:

      /*Check if a manual cncu_mstr already exists for the same shipment*/
      /*with a manual qty that is not equal to zero and has the same    */
      /*sign (pos or neg) as the edi usage qty.  Increment or decrement */
      /*the manual qty by the amount of the edi usage qty or until it   */
      /*becomes  zero, whichever occurs first.  If there is remaining   */
      /*edi usage qty, continue to read more cncu_mstr records and  use */
      /*up their manual qty.  If there are no more cncu_mstr records,   */
      /*the edi usage qty remaining should be issued and the sales order*/
      /*quantities updated.                                             */

      /*Manual quantities:                                              */
      /*  origin = adjustment (from Aging)                              */
      /*  origin = manual     (from Auto-Create)                        */
      /*                        so verify the match on cust_usage_ref.  */

      for each cncu_mstr
         where cncu_mstr.cncu_domain    = global_domain
         and  (cncu_mstr.cncu_so_nbr    = bUsage.so_nbr
         and   cncu_mstr.cncu_sod_line  = bUsage.sod_line
         and   cncu_mstr.cncu_lotser    = bUsage.lotser
         and   cncu_mstr.cncu_ref       = bUsage.ref
         and   cncu_mstr.cncu_auth      = bUsage.auth
         and   cncu_mstr.cncu_cust_job  = bUsage.cust_job
         and   cncu_mstr.cncu_cust_seq  = bUsage.cust_seq
         and   cncu_mstr.cncu_cust_ref  = bUsage.cust_ref
         and  (cncu_mstr.cncu_origin   = ADJUSTMENT
                                   or
              (cncu_mstr.cncu_origin   = MANUAL
         and   cncu_mstr.cncu_cust_usage_ref = bUsage.cust_usage_ref))
         and ((cncu_mstr.cncu_manual_qty < 0  and working_qty < 0)
                                   or
             (cncu_mstr.cncu_manual_qty > 0  and working_qty > 0)))
      exclusive-lock
      break by cncu_mstr.cncu_so_nbr
            by cncu_mstr.cncu_sod_line
            by cncu_mstr.cncu_batch:


         out_um_conv = 1.
         /*Convert the qty passed in to the um of the cncu master record*/
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

         /*Convert the working qty back to the um it originally came in as*/
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

      end. /*for each cncu_mstr*/

   end. /*if bUsage.origin = EDI*/

   /* Create the ISS-SO and CN-USE transaction history and update   */
   /* the sales order qty and invoice flag for the usage qty. This  */
   /* section processes manual records and edi quantities that have */
   /* not already been previously posted on a manual record.        */

   if (bUsage.origin <> EDI) or (working_qty <> 0) then do:

      /* Determine Consignment Accounts*/
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

      /* Determine Consignment options found on Order/Line */
      {gprun.i ""socnsod1.p""
               "(input bUsage.so_nbr,
                 input bUsage.sod_line,
                 output consigned_line_item,
                 output consign_loc,
                 output intrans_loc,
                 output max_aging_days,
                 output auto_replenish)"}

      for first so_mstr
         where so_mstr.so_domain = global_domain
         and   so_mstr.so_nbr = bUsage.so_nbr
      no-lock:
         for first sod_det
            where  sod_domain = global_domain and
                   sod_nbr  = so_mstr.so_nbr and
                   sod_line = bUsage.sod_line
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
         and   pt_part = bUsage.part
      no-lock: end.

      assign
         prev_found = yes
         sct_recno = recid(sct_det)
         recno = sct_recno
         out_um_conv = 1.

      /* UNIT OF MEASURE CONVERSIONS - STOCK UM */
      if busage.cncud_usage_um <> pt_um then do:

         /*Get the correct unit of measure conversion factor */
         run callUmConvertProgram
            (input bUsage.cncud_usage_um,
             input pt_um,
             input bUsage.part,
             output out_um_conv).

         if return-value <> {&SUCCESS-RESULT} then
            return {&GENERAL-APP-EXCEPT}.
      end.

      assign
         working_inv_qty = working_qty * out_um_conv
         out_um_conv = 1.

      /* UNIT OF MEASURE CONVERSIONS - SALES ORDER UM */
      if sod_um <> pt_um then do:

         /*Get the correct unit of measure conversion factor */
         run callUmConvertProgram
            (input pt_um,
             input sod_um,
             input bUsage.part,
             output out_um_conv).

         if return-value <> {&SUCCESS-RESULT} then
            return {&GENERAL-APP-EXCEPT}.
      end.

      working_sod_qty = working_inv_qty * out_um_conv.

      /*Update Sales Order detail invoice and cum quantities*/
      run updateSalesOrderQuantities
         (input bUsage.so_nbr,
          input bUsage.sod_line,
          input working_sod_qty,
          input bUsage.eff_date,
          output order_cum_used_qty).

      /* Create ISS-SO transaction record                             */
      /* Read the sales order master, sales order detail, abs master, */
      /* transaction history, part master and general ledger control  */
      /* file to get data needed to call ictrans.i to create the      */
      /* sales order transaction history.  Also call the exchange rate*/
      /* routine to get the correct exchange rate to pass to ictrans.i*/
      if sod_consignment
      then do:
         for first so_mstr exclusive-lock
            where so_mstr.so_domain = global_domain
            and   so_mstr.so_nbr    = bUsage.so_nbr:
            assign
               l_ship_date  = so_ship_date
               so_ship_date = p_consign_date.
         end. /* FOR FIRST so_mstr */
         release so_mstr.
         /* A DUMMY FIND ON sod_det IS REQUIRED AS THE RECORDS COMMIT IS  */
         /* DONE AT THE END OF THE TRANSACTION IN ORACLE ENVIRONMENT.     */
         /* WITH THIS THE UPDATED VALUES PRESENT IN THE BUFFER of sod_det */
         /* CAN BE READ.                                                  */
         for first b_sod_det
            fields(sod_domain sod_nbr sod_line sod_qty_chg sod_qty_inv)
            where b_sod_det.sod_domain = global_domain
            and   b_sod_det.sod_nbr    = sod_det.sod_nbr
            and   b_sod_det.sod_line   = sod_det.sod_line
            no-lock:
         end. /* FOR FIRST b_sod_det */
      end. /* IF sod_consignment */

      {gprun.i ""txcalc.p""
               "(input l_tr_type,
                 input sod_nbr,
                 input l_nbr,
                 input l_line,
                 input no,
                 output result-status)"}

      if sod_consignment
      then do:
         for first so_mstr exclusive-lock
            where  so_mstr.so_domain = global_domain
            and    so_mstr.so_nbr    = bUsage.so_nbr:
            so_ship_date   = l_ship_date.
         end.  /* FOR FIRST so_mstr */
         release so_mstr.
         for first so_mstr
            fields(so_domain so_bill so_curr so_cust so_exru_seq so_ex_rate
                   so_ex_rate2 so_ex_ratetype so_fix_rate so_nbr
                   so_po so_rev so_ship so_ship_date so_to_inv)
            where so_mstr.so_domain = global_domain
            and   so_mstr.so_nbr    = bUsage.so_nbr
            no-lock:
         end. /* FOR FIRST so_mstr */
      end. /* IF sod_consignment */

      if so_fix_rate then
         assign
            exch_rate     = so_ex_rate
            exch_rate2    = so_ex_rate2
            exch_ratetype = so_ex_ratetype
            exch_exru_seq = so_exru_seq.
      else do:

         /* GET EXCHANGE RATE FOR BASE TO ACCOUNT CURRENCY */
         {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                   "(input  so_curr,
                     input  base_curr,
                     input  so_ex_ratetype,
                     input  bUsage.eff_date,
                     output exch_rate,
                     output exch_rate2,
                     output mc-error-number)"}

         if mc-error-number <> 0 then do:
            return {&GENERAL-APP-EXCEPT}.
         end.

         assign
            exch_ratetype = so_ex_ratetype
            exch_exru_seq = 0.

      end.  /* else do*/

      for first abs_mstr
         where abs_domain = global_domain
         and   abs_shipfrom = bUsage.site
         and   abs_id = "s" + bUsage.cncud_asn_shipper
      no-lock: end.

      for first pl_mstr
         where pl_domain = global_domain
         and   pl_prod_line = pt_prod_line
      no-lock: end.

      for first pld_det
         where pld_domain = global_domain
         and   pld_prodline = pt_prod_line
         and   pld_site = bUsage.site
         and   pld_loc = bUsage.cncud_current_loc
      no-lock: end.

      for first tr_hist
         where tr_domain = global_domain
         and   tr_trnbr = bUsage.cncud_ship_trnbr
      no-lock: end.

      if not available tr_hist then
         return {&GENERAL-APP-EXCEPT}.

      for first si_mstr
         fields (si_domain si_db si_desc si_entity si_site)
         where   si_domain = global_domain
         and     si_site = sod_site
      no-lock: end.

      assign
         sod_entity = si_entity
         first_so_entity = if available si_mstr then si_entity
                           else "".

      /*! MULTI-DB: USE SHIP-TO CUSTOMER TYPE FOR DEFAULT
       *  IF AVAILABLE ELSE USE BILL-TO TYPE USED TO
       *  FIND COGS ACCOUNT IN SOCOST02.p */
     {gprun.i ""gpcust.p""
              "(input  bUsage.so_nbr,
                output ord-db-cmtype)"}

      for first gl_ctrl
         fields (gl_domain gl_rnd_mthd)
         where   gl_domain = global_domain
      no-lock: end.

      assign
         eff_date = bUsage.eff_date
         lotser = bUsage.lotser
         location = bUsage.cncud_current_loc
         base-price =  sod_price / sod_um_conv.

      if so_curr <> base_curr then do:
         /* CONVERT PRICE TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
                   "(input  so_curr,
                     input  base_curr,
                     input  exch_rate,
                     input  exch_rate2,
                     input  base-price,
                     input  no,   /* DO NOT ROUND */
                     output base-price,
                     output mc-error-number)"}
      end.  /* if so_mstr.so_curr <> base_curr */

      if io_trnbr = 0 then do:
/* SS - 090401.1 - B 
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
            &line="bUsage.sod_line"
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
 SS - 090401.1 - E */

/* SS - 090401.1 - B */


{gprun.i ""xxictransxp01.p""
    "(
/*  &addrid       */ input so_cust ,
/*  &bdnstd       */ input 0 ,
/*  &cracct       */ input (if available pt_mstr then
                                if available pld_det then pld_inv_acct
                                else pl_inv_acct
			                else """") ,
/*  &crsub        */ input (if available pt_mstr then
                               if available pld_det then pld_inv_sub
                               else pl_inv_sub
                            else """")  , 
/*  &crcc         */ input (if available pt_mstr then
                              if available pld_det then pld_inv_cc
                              else pl_inv_cc
                           else """")  ,
/*  &crproj       */ input sod_project  ,
/*  &curr         */ input so_curr  ,
/*  &dracct       */ input """"  ,
/*  &drsub        */ input """"  ,
/*  &drcc         */ input """"  ,
/*  &drproj       */ input sod_project  ,
/*  &effdate      */ input bUsage.eff_date  ,
/*  &exrate       */ input exch_rate  ,
/*  &exrate2      */ input exch_rate2  ,
/*  &exratetype   */ input exch_ratetype  ,
/*  &exruseq      */ input exch_exru_seq  ,
/*  &glamt        */ input gl_amt  ,
/*  &lbrstd       */ input 0  ,
/*  &location     */ input bUsage.cncud_current_loc  ,
/*  &lotnumber    */ input tr_lot  ,
/*  &lotref       */ input bUsage.ref  ,
/*  &lotserial    */ input bUsage.lotser  ,
/*  &mtlstd       */ input (if sod_type = 'M' and not available pt_mstr
                             then sod_std_cost else 0)  ,
/*  &ordernbr     */ input sod_nbr  ,
/*  &line         */ input bUsage.sod_line  ,
/*  &ovhstd       */ input 0  ,
/*  &part         */ input bUsage.part  ,
/*  &perfdate     */ input sod_per_date  ,
/*  &price        */ input base-price  ,
/*  &quantityreq  */ input 0  ,
/*  &quantityshort*/ input sod_bo_chg  ,
/*  &quantity     */ input ( - ip_tot_lotser_qty)  ,
/*  &revision     */ input """"  ,
/*  &rmks         */ input """"  ,
/*  &shiptype     */ input sod_type  ,
/*  &site         */ input sod_site  ,
/*  &slspsn1      */ input sod_slspsn[1]  ,
/*  &slspsn2      */ input sod_slspsn[2]  ,
/*  &sojob        */ input (if sod_fsm_type begins """RMA""" then sod_contr_id
                            else sod_nbr)  ,
/*  &substd       */ input 0  ,
/*  &transtype    */ input ""ISS-SO""  ,
/*  &msg          */ input 0  ,
/*  &ref_site     */ input tr_site  ,
/*  &invmov       */ input (if available abs_mstr then abs_inv_mov else """")  ,
/*  &shipdate     */ input bUsage.cncud_ship_date  ,
/*  &shipnbr      */ input """"  ,
/*  &slspsn3      */ input sod_slspsn[3]  ,
/*  &slspsn4      */ input sod_slspsn[4]  ,
/*  &tempid       */ input 1  ,
/*  &trordrev     */ input so_rev  ,
/*  recno         */ input recno   ,
/*  op_trglrecno  */ output  op_trglrecno   ,
/*  op_trrecno    */ output  op_trrecno     ,
/*  op_tr_trnbr   */ output  io_trnbr     
    )"
}


release ld_det.
release in_mstr.

find trgl_det where recid(trgl_Det) = op_trglrecno no-error .
find tr_hist  where recid(tr_hist)  = op_trrecno no-error .

/* SS - 090401.1 - E */



         {gprun.i ""socost01.p""
                  "(- ip_tot_lotser_qty,
                    bUsage.lotser,
                    prev_found,
                    sod_entity,
                    bUsage.cncud_current_loc,
                    input recid(tr_hist))"}

         {gprun.i ""socost02.p""
                  "(input - ip_tot_lotser_qty,
                    input  sod_entity,
                    input recid(trgl_det),
                    input recid(tr_hist) )"}

         /* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
         {gprun.i ""gpmfc01.p""
                  "(input 'enable_supplier_consignment',
                    input 11,
                    input 'ADG',
                    input 'cns_ctrl',
                    output using_supplier_consignment)"}

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
                       input bUsage.lotser,
                       input bUsage.ref,
                       input false,
                       output supplier_consign_flag)"}

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

            end. /*If supplier_consign_flag*/
         end. /*IF USING_SUPPLIER_CONSIGNMENT*/

      end. /*if io_trnbr = ""*/

      /*Set the debit and credit accounts for inventory location */
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

      /*Create a CN-USE   transaction history record */
/* SS - 090401.1 - B 
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
          &line="bUsage.sod_line"
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

 SS - 090401.1 - E */

/* SS - 090401.1 - B */
define var v_tmp_io_trnbr like io_trnbr .
v_tmp_io_trnbr = io_trnbr .

{gprun.i ""xxictransxp01.p""
    "(
/*  &addrid       */ input so_cust       , 
/*  &bdnstd       */ input 0       ,
/*  &cracct       */ input cr_acct       ,
/*  &crsub        */ input cr_sub       ,
/*  &crcc         */ input cr_cc        ,
/*  &crproj       */ input sod_project       ,
/*  &curr         */ input so_curr       ,
/*  &dracct       */ input dr_acct       ,
/*  &drsub        */ input dr_sub       ,
/*  &drcc         */ input dr_cc       ,
/*  &drproj       */ input sod_project       ,
/*  &effdate      */ input bUsage.eff_date       ,
/*  &exrate       */ input exch_rate           ,
/*  &exrate2      */ input exch_rate2          ,
/*  &exratetype   */ input exch_ratetype       ,
/*  &exruseq      */ input exch_exru_seq       ,
/*  &glamt        */ input sct_cst_tot * working_inv_qty       ,
/*  &lbrstd       */ input 0       ,
/*  &location     */ input bUsage.cncud_current_loc       ,
/*  &lotnumber    */ input tr_lot       ,
/*  &lotref       */ input bUsage.ref  ,
/*  &lotserial    */ input bUsage.lotser  ,
/*  &mtlstd       */ input (if sod_type = 'M' and not available pt_mstr then sod_std_cost else 0)  ,
/*  &ordernbr     */ input sod_nbr  ,
/*  &line         */ input bUsage.sod_line  ,
/*  &ovhstd       */ input 0  ,
/*  &part         */ input bUsage.part  ,
/*  &perfdate     */ input sod_per_date  ,
/*  &price        */ input base-price  ,
/*  &quantityreq  */ input 0  ,
/*  &quantityshort*/ input sod_bo_chg  ,
/*  &quantity     */ input 0  ,
/*  &revision     */ input """"  ,
/*  &rmks         */ input string(io_trnbr)  ,
/*  &shiptype     */ input sod_type  ,
/*  &site         */ input sod_site  ,
/*  &slspsn1      */ input sod_slspsn[1]  ,
/*  &slspsn2      */ input sod_slspsn[2]  ,
/*  &sojob        */ input (if sod_fsm_type begins """RMA""" then sod_contr_id else sod_nbr)  ,
/*  &substd       */ input 0  ,
/*  &transtype    */ input ""CN-USE""  ,
/*  &msg          */ input 0  ,
/*  &ref_site     */ input tr_site  ,
/*  &invmov       */ input (if available abs_mstr then abs_inv_mov else """")  ,
/*  &shipdate     */ input bUsage.cncud_ship_date  ,
/*  &shipnbr      */ input bUsage.cncud_asn_shipper  ,
/*  &slspsn3      */ input sod_slspsn[3]  ,
/*  &slspsn4      */ input sod_slspsn[4]  ,
/*  &tempid       */ input 1  ,
/*  &trordrev     */ input so_rev  ,
/*  recno         */ input  recno ,
/*  op_trglrecno  */ output  op_trglrecno      ,
/*  op_trrecno    */ output  op_trrecno        ,
/*  op_tr_trnbr   */ output  io_trnbr     
    )"
}

io_trnbr = v_tmp_io_trnbr  .

release ld_det.
release in_mstr.

find trgl_det where recid(trgl_Det) = op_trglrecno no-error .
find tr_hist  where recid(tr_hist)  = op_trrecno no-error .

/* SS - 090401.1 - E */


       /* Update the appropriate cross reference records.           */
 /*MINTH    {gprun.i ""socncix.p""                       
               "(input bUsage.so_nbr,
                 input bUsage.sod_line,
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
                 input-output first_time_in)"} */
/* ss 20071128 - b */
/*
/*MINTH */    {gprun.i ""xxsocncix.p"" 
*/                      
/*MINTH */    {gprun.i ""xxsocncixx.p""                       
               "(input bUsage.so_nbr,
                 input bUsage.sod_line,
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
		 input busage.cncud_cncix_pkey,      
                 input-output first_time_in)"} 
       first_time_in = no.
/* ss 20071128 - e */

       if bUsage.cncud_selfbill and bUsage.cncud_asn_shipper <> "" then do:
          run updateSelfBillShipmentXRef
             (input bUsage.so_nbr,
              input bUsage.sod_line,
              input working_sod_qty,
              input sod_site,
              input so_cust,
              input so_ship,
              input so_bill,
              input sod_part,
              input (if sod_custpart <> "" then
                     sod_custpart else sod_part),
              input sod_um,
              input sod_price,
              input bUsage.cncud_asn_shipper,
              input (if sod_sched then sod_contr_id else so_po),
              input bUsage.selfbill_auth,
              input bUsage.cncud_ship_date,
              input so_curr).
         if return-value <> {&SUCCESS-RESULT} then
            return {&GENERAL-APP-EXCEPT}.
       end.  /* if bUsage.cncud_selfbill */

   end. /*If origin <> edi or working_qty <> 0*/

   /*This section will create/update usage master records  and create*/
   /*detail usage records for manual or edi usage.                   */

   /*Create the buffer to hold the usage master record.           */
   run disposeConsignUsageMasterBuffer
      (buffer bConsignUsageMaster).

   run createConsignUsageMasterBuffer
      (buffer bConsignUsageMaster).

   /*Create or update consignment usage master record, cncu_mstr*/
   /*Get a usage id if one was not passed in and create a usage master rec*/
   if bUsage.cncu_batch = 0 then do:
      {mfrnseq.i bUsage bUsage.cncu_batch cncu_sq02}
   end.

   assign
      bConsignUsageMaster.cncu_batch    = bUsage.cncu_batch
      bConsignUsageMaster.cncu_so_nbr   = bUsage.so_nbr
      bConsignUsageMaster.cncu_sod_line = bUsage.sod_line
      bConsignUsageMaster.cncu_lotser   = bUsage.lotser
      bConsignUsageMaster.cncu_ref      = bUsage.ref
      bConsignUsageMaster.cncu_auth     = bUsage.auth
      bConsignUsageMaster.cncu_cust_job = bUsage.cust_job
      bConsignUsageMaster.cncu_cust_seq = bUsage.cust_seq
      bConsignUsageMaster.cncu_cust_ref = bUsage.cust_ref
      bConsignUsageMaster.cncu_trans_date = bUsage.trans_date
      bConsignUsageMaster.cncu_eff_date = bUsage.eff_date
      bConsignUsageMaster.cncu_cust_usage_date = bUsage.cust_usage_date.

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

   end. /*if return-value = not {&SUCCESS-RESULT} */
   else do:

      /*Get the usage master record using the usage id and keys passed in    */
      /*by the calling programs.                                             */
      run readConsignUsageMaster
         (buffer bConsignUsageMaster,
          input  {&NO_LOCK_FLAG},
          input  {&NO_WAIT_FLAG}).

      if return-value = {&SUCCESS-RESULT} then do:
         assign
            out_um_conv = 1
            hold_cncu_usage_um =  bConsignUsageMaster.cncu_usage_um.

         if busage.cncud_usage_um <> bConsignUsageMaster.cncu_usage_um then do:

            run callUmConvertProgram
               (input bUsage.cncud_usage_um,
                input bConsignUsageMaster.cncu_usage_um,
                input bUsage.part,
                output out_um_conv).
            if return-value <> {&SUCCESS-RESULT} then
               return {&GENERAL-APP-EXCEPT}.

            bUsage.cncud_usage_qty = bUsage.cncud_usage_qty * out_um_conv.

         end. /*if busage.cncud_usage_um <> bConsignUsageMaster.cncu_usage_um */

         assign
            bConsignUsageMaster.cncu_cum_qty =
               bConsignUsageMaster.cncu_cum_qty + bUsage.cncud_usage_qty
            bConsignUsageMaster.cncu_usage_qty =
               bConsignUsageMaster.cncu_usage_qty + bUsage.cncud_usage_qty
            bConsignUsageMaster.cncu_manual_qty =
              (if bUsage.origin = MANUAL then
                 (bConsignUsageMaster.cncu_manual_qty + bUsage.cncud_usage_qty)
               else
                  bConsignUsageMaster.cncu_manual_qty).

         run updateConsignUsageMaster
            (buffer bConsignUsageMaster).

         out_um_conv = 1.
         if busage.cncud_usage_um <> hold_cncu_usage_um then do:

            run callUmConvertProgram
               (input hold_cncu_usage_um,
                input bUsage.cncud_usage_um,
                input bUsage.part,
                output out_um_conv).
            if return-value <> {&SUCCESS-RESULT} then
               return {&GENERAL-APP-EXCEPT}.

            bUsage.cncud_usage_qty = bUsage.cncud_usage_qty * out_um_conv.

         end.  /* if busage.cncud_usage_um <> hold_cncu_usage_um */

      end.  /* if return-value = {&SUCCESS-RESULT} */

   end. /* else do*/

   /*Create consignment usage detail record, cncud_det*/
   run createConsignUsageDetailBuffer
      (buffer bConsignUsageDetail).

   /* Populate the key fields in order to create a usage detail record */
   assign
      bConsignUsageDetail.cncud_cncu_pkey  = bConsignUsageMaster.cncu_pkey
      bConsignUsageDetail.cncud_cncix_pkey = bUsage.cncud_cncix_pkey
      bConsignUsageDetail.cncud_cust_dock  = bUsage.cncud_cust_dock
      bConsignUsageDetail.cncud_line_feed  = bUsage.cncud_line_feed
      bConsignUsageDetail.cncud_ship_date  = today
      bConsignUsageDetail.cncud_aged_date  = bUsage.cncud_aged_date
      bConsignUsageDetail.cncud_orig_aged_date =
                                             bUsage.cncud_orig_aged_date.

   if not isConsignUsageDetailExists (buffer bConsignUsageDetail) then do:

      run createConsignUsageDetail
         (buffer bConsignUsageDetail).

      /*Populate the remaining usage detail fields  and udpate the record */
      assign
         bConsignUsageDetail.cncud_selfbill   = bUsage.cncud_selfbill
         bConsignUsageDetail.cncud_qty_ship   = bUsage.cncud_qty_ship
         bConsignUsageDetail.cncud_usage_um   = bUsage.cncud_usage_um
         bConsignUsageDetail.cncud_usage_um_conv = bUsage.cncud_usage_um_conv
         bConsignUsageDetail.cncud_stock_um   = bUsage.cncud_stock_um
         bConsignUsageDetail.cncud_price      = bUsage.cncud_price
         bConsignUsageDetail.cncud_ship_value = bUsage.cncud_ship_value
         bConsignUsageDetail.cncud_curr       = bUsage.cncud_curr
         bConsignUsageDetail.cncud_asn_shipper = bUsage.cncud_asn_shipper
         bConsignUsageDetail.cncud_ship_date  = bUsage.cncud_ship_date
         bConsignUsageDetail.cncud_usage_qty  = bUsage.cncud_usage_qty
         bConsignUsageDetail.cncud_current_loc = bUsage.cncud_current_loc
         bConsignUsageDetail.cncud_ship_trnbr = bUsage.cncud_ship_trnbr.

      run updateConsignUsageDetail
         (buffer bConsignUsageDetail).

   end.  /* If not isConsignUsageDetailExists */
   else do:

      /*Get the usage detail record using the master record key    */
      run readConsignUsageDetail
         (buffer bConsignUsageDetail,
          input  {&NO_LOCK_FLAG},
          input  {&NO_WAIT_FLAG}).

      if return-value = {&SUCCESS-RESULT} then do:
         assign
            out_um_conv = 1
            hold_cncud_usage_um =  bConsignUsageDetail.cncud_usage_um.

         if busage.cncud_usage_um <> bConsignUsageDetail.cncud_usage_um then do:

            run callUmConvertProgram
               (input bUsage.cncud_usage_um,
                input bConsignUsageDetail.cncud_usage_um,
                input bUsage.part,
                output out_um_conv).
            if return-value <> {&SUCCESS-RESULT} then
               return {&GENERAL-APP-EXCEPT}.

            bUsage.cncud_usage_qty = bUsage.cncud_usage_qty * out_um_conv.

         end.

         bConsignUsageDetail.cncud_usage_qty =
               bConsignUsageDetail.cncud_usage_qty + bUsage.cncud_usage_qty.

         run updateConsignUsageDetail
            (buffer bConsignUsageDetail).

         out_um_conv = 1.
         if busage.cncud_usage_um <> hold_cncud_usage_um then do:

            run callUmConvertProgram
               (input hold_cncud_usage_um,
                input bUsage.cncud_usage_um,
                input bUsage.part,
                output out_um_conv).
            if return-value <> {&SUCCESS-RESULT} then
               return {&GENERAL-APP-EXCEPT}.

            bUsage.cncud_usage_qty = bUsage.cncud_usage_qty * out_um_conv.

         end.  /* if busage.cncud_usage_um <> hold_cncu_usage_um */

      end.  /* if return-value = {&SUCCESS-RESULT} */

   end.  /* else do */

end. /*do on error,  undo ..*/

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

   define input  parameter p_order      like sod_det.sod_nbr  no-undo.
   define input  parameter p_line       like sod_det.sod_line no-undo.
   define input  parameter p_qty        like cncud_det.cncud_usage_qty no-undo.
   define input  parameter p_eff_date   as date no-undo.
   define output parameter p_cum_qty    like sod_qty_ord  no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

/*mage del 08/08/20      for first sod_det
         where sod_domain = global_domain
         and   sod_nbr    = p_order
         and   sod_line   = p_line
      exclusive-lock:  */
/*mage del 08/08/20 */     for first sod_det
         where sod_domain = global_domain
         and   sod_nbr    = p_order
         and   sod_line   = p_line
          :  

         assign
            sod_cum_qty[4]  = sod_cum_qty[4] + p_qty
            sod_cum_date[4] = p_eff_date

/* ss 20070302.1 - b */
/*
            sod_qty_inv     = sod_qty_inv + p_qty
 */
            sod_qty_inv     = 0.
/* ss 20070302.1 - e */

            p_cum_qty       = sod_cum_qty[4].

         for first so_mstr
            where so_mstr.so_domain = global_domain
            and   so_mstr.so_nbr = sod_nbr
         exclusive-lock:
            so_to_inv = yes.
         end.

         if not available so_mstr then
            return {&RECORD-NOT-FOUND}.

      end. /*for first sod_det*/

      if not available sod_det then
         return {&RECORD-NOT-FOUND}.

   end. /*Do on error undo..*/

   return {&SUCCESS-RESULT}.

END PROCEDURE. /*updateSalesOrderQuantities*/


/* ========================================================================= */
PROCEDURE callUmConvertProgram:
/* -------------------------------------------------------------------------
 * Purpose:      This calls the unit of measure conversion program.
 * ------------------------------------------------------------------------- */

   define input  parameter p_from_um     as character no-undo.
   define input  parameter p_to_um       as character no-undo.
   define input  parameter p_part        as character  no-undo.
   define output  parameter p_out_um_conv as decimal    no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {gprun.i ""gpumcnv.p""
               "(input p_from_um,
                 input p_to_um,
                 input p_part,
                 output p_out_um_conv)"}

      if p_out_um_conv = ? then
         return {&GENERAL-APP-EXCEPT}.

   end. /*Do on error undo..*/

   return {&SUCCESS-RESULT}.

END PROCEDURE. /*callUmConvertProgram*/


/* ========================================================================= */
PROCEDURE updateSelfBillShipmentXRef:
/* -------------------------------------------------------------------------
 * Purpose:    Update Self-Bill Shipping/Invoice Crossreference records.
 *             One record is created for each line.
 * Notes:      One record is created for each shipper line.  This means
 *             this routine updates an existing record if it has already
 *             been create for the shipper line.
 *-------------------------------------------------------------------------- */

   define input parameter ip_order as character no-undo.
   define input parameter ip_line as integer no-undo.
   define input parameter ip_qty as decimal no-undo.
   define input parameter ip_site as character no-undo.
   define input parameter ip_cust as character no-undo.
   define input parameter ip_ship as character no-undo.
   define input parameter ip_bill as character no-undo.
   define input parameter ip_part as character no-undo.
   define input parameter ip_sopart as character no-undo.
   define input parameter ip_um as character no-undo.
   define input parameter ip_price as decimal no-undo.
   define input parameter ip_asn_shipper as character no-undo.
   define input parameter ip_po as character no-undo.
   define input parameter ip_auth as character no-undo.
   define input parameter ip_shipdate as date no-undo.
   define input parameter ip_curr as character no-undo.


   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* DETERMINE IF SHIPMENT X-REFERENCE RECORD EXISTS */
      for first six_ref
         where six_domain         = global_domain
         and   six_bill           = ip_bill
         and   six_inv_nbr        = ""
         and   six_type           = ""
         and   six_order          = ip_order
         and   six_line           = ip_line
         and   six_ship_id        = ip_asn_shipper
         and   six_authorization  = ip_auth
      exclusive-lock: end.

      /* IF IT DOESN'T EXIST, THEN CREATE A NEW RECORD */
      if not available six_ref then do:

         create six_ref.
         assign
            six_domain          = global_domain
            six_type            = " "
            six_order           = ip_order
            six_line            = integer(ip_line)
            six_site            = ip_site
            six_cust            = ip_cust
            six_ship            = ip_ship
            six_bill            = ip_bill
            six_part            = ip_part
            six_sopart          = ip_sopart
            six_um              = ip_um
            six_price           = ip_price
            six_ship_id         = ip_asn_shipper
            six_po              = ip_po
            six_qty_paid        = 0
            six_amt_paid        = 0
            six_closed          = no
            six_shipdt          = ip_shipdate
            six_curr            = ip_curr
            six_authorization   = ip_auth.

         {mfrnseq.i six_ref six_ref.six_trnbr tr_sq02}

         if recid(six_ref) = -1 then .

      end.  /* if not available six_ref */


      /* UPDATE THE QUANTITY AND TOTAL AMOUNT */
      assign
         six_qty = six_qty + ip_qty
         six_amt = six_amt + (six_price * ip_qty).

      /* IF THERE IS NO QTY TO SELF-BILL, THEN DELETE */
      if six_qty = 0 then
         delete six_ref.

   end. /*Do on error undo..*/

   return {&SUCCESS-RESULT}.

END PROCEDURE. /*updateSelfBillShipmentXRef*/
