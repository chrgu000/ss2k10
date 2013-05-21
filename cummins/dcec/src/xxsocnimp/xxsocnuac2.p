/* socnuac2.p - Sales Order Consignment Usage Process Temp-Table Program      */
/* Copyright 1986-2008 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* Revision: 1.21       BY: Patrick Rowan          DATE: 04/04/02 ECO: *P00F* */
/* Revision: 1.23       BY: Paul Donnelly (SB)     DATE: 06/28/03 ECO: *Q00L* */
/* Revision: 1.25       BY: Paul Donnelly          DATE: 07/17/03 ECO: *Q014* */
/* Revision: 1.26       BY: Sandy Brown (OID)      DATE: 12/06/03 ECO: *Q04L* */
/* Revision: 1.27       BY: Preeti Sattur          DATE: 02/06/04 ECO: *P1N2* */
/* Revision: 1.28       BY: Laxmikant Bondre       DATE: 04/26/04 ECO: *P1TT* */
/* Revision: 1.29       BY: Somesh Jeswani         DATE: 06/14/04 ECO: *P25V* */
/* Revision: 1.30       BY: Reena Ambavi           DATE: 06/29/04 ECO: *P27C* */
/* Revision: 1.31       BY: Vandna Rohira          DATE: 08/17/04 ECO: *P2FL* */
/* Revision: 1.32       BY: Robin McCarthy         DATE: 09/08/05 ECO: *P3PP* */
/* Revision: 1.33       BY: Robin McCarthy         DATE: 10/01/05 ECO: *P3MZ* */
/* Revision: 1.34       BY: Robin McCarthy         DATE: 10/14/05 ECO: *P44V* */
/* Revision: 1.34.1.1   BY: Sanat Paul             DATE: 06/06/07 ECO: *P5KL* */
/* Revision: 1.34.1.2   BY: Ed van de Gevel        DATE: 10/22/07 ECO: *P51G* */
/* Revision: 1.34.1.3   BY: Prashant S             DATE: 11/21/07 ECO: *P6F1* */
/* $Revision: 1.34.1.4 $ BY: Deepak Keni DATE: 01/28/08  ECO: *P6KN* */
/*-Revision end---------------------------------------------------------------*/

/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */

/*V8:ConvertMode=NoConvert                                                    */

{mfdeclre.i}
{gpoidfcn.i}   /* Defines nextOidValue() function */
{cxcustom.i "SOCNUAC2.P"}
{pxsevcon.i}
{socnutmp.i}   /* COMMON USAGE TEMP-TABLE DEFINITIONS */

/* MUST INCLUDE gprunpdf.i IN THE MAIN BLOCK OF THE PROGRAM SO THAT */
/* CALLS TO gprunp.i FROM ANY OF THE INTERNAL PROCEDURES SKIPS      */
/* DEFINITION OF SHARED VARS OF gprunpdf.i                          */
/* FOR FURTHER INFO REFER TO HEADER COMMENTS IN gprunp.i            */
{gprunpdf.i "mcpl" "p"}

/* PARAMETERS */
define input-output parameter table for tt_autocr.
define input-output parameter table for tt_so_update.
define input        parameter ip_using_selfbilling as   logical         no-undo.
define input        parameter ip_origin            as   character       no-undo.
define input        parameter ip_effdate           as   date            no-undo.
define input        parameter ip_invoice_domain    as   character       no-undo.
define output       parameter op_batch_id          as   character       no-undo.
define output       parameter op_continue-yn       as   logical         no-undo.

/* SHARED VARIABLES FOR icsrup.p */
define shared variable multi_entry       like mfc_logical           no-undo.
define shared variable site              like sr_site               no-undo.
define shared variable location          like sr_loc                no-undo.
define shared variable trans_conv        like sod_um_conv.
{&SOCNUAC2-P-TAG1}

define new shared temp-table work_trnbr no-undo
   field work_sod_nbr  like sod_nbr
   field work_sod_line like sod_line
   field work_tr_recid like tr_trnbr
index work_sod_nbr work_sod_nbr ascending.

/* VARIABLES */
define variable residual_qty                    like cncix_qty_stock    no-undo.
define variable save_sbinfo                     as   logical            no-undo.
define variable scheduled                       as   logical            no-undo.
define variable curr_rlse_id                    as   character          no-undo.
define variable cum_shipped_qty                 as   decimal            no-undo.
define variable shipfrom_site                   as   character          no-undo.
define variable prior_cum_qty                   as   decimal            no-undo.
define variable working_trnbr                   as   integer            no-undo.
define variable op-err                          as   integer            no-undo.

{socnvars.i}
{socnuvar.i}   /* COMMON USAGE VARIABLE DEFINITIONS */

/* BUFFERS */
define buffer bConsignedShipment    for cncix_mstr.
define buffer bConsignedUsageMaster for cncu_mstr.

/* INITIALIZE WORKFILE */
   for each work_trnbr exclusive-lock:
   delete work_trnbr.
   end.
assign
   op_continue-yn = no
   op-err      = 0.

/* READ THE AUTOCREATE TEMP-TABLE BUFFER */
for each tt_autocr
   where ac_tot_qty_consumed <> 0
exclusive-lock break by ac_line:

   /* DETERMINE IF BILL-TO IS REGISTERED FOR SELF-BILLING */
   assign
      inventory_domain = ac_domain
      save_sbinfo = if ip_using_selfbilling and ac_selfbill then yes
                    else no.

   if inventory_domain <> global_domain then do:
      /* SWITCH TO INVENTORY DOMAIN */
      run switchDomain
         (input  inventory_domain,
          output undo_flag).

      if undo_flag then
         undo, return.
   end.

   /* CREATE USAGE RECORDS IN INVENTORY DOMAIN */
   {gprun.i ""xxsocnua2a.p""
            "(input-output table bUsage,
              input-output table tt_so_update,
              buffer       bConsignedShipment,
              buffer       bConsignedUsageMaster,
              input        ip_invoice_domain,
              input        ip_origin,
              input-output ip_effdate,
              input-output op_continue-yn,
              input-output save_sbinfo,
              input-output residual_qty,
              input-output working_trnbr,
              input-output scheduled,
              input-output curr_rlse_id,
              input-output cum_shipped_qty,
              input-output shipfrom_site,
              input-output prior_cum_qty,
              input-output op_batch_id,
              input-output ac_part,
              input-output ac_site,
              input-output ac_ship,
              input-output ac_cust,
              input-output ac_sopart,
              input-output ac_order,
              input-output ac_line,
              input-output ac_asn_shipper,
              input-output ac_auth,
              input-output ac_cust_job,
              input-output ac_cust_seq,
              input-output ac_cust_ref,
              input-output ac_eff_date,
              input-output ac_consumed_um_conv,
              input-output ac_consumed_um,
              input-output ac_cust_usage_ref,
              input-output ac_cust_usage_date,
              input-output ac_selfbill_auth,
              input-output ac_tot_qty_consumed,
              input-output ac_lotser,
              input-output ac_ref,
              input-output ac_loc,
              input-output ac_count,
              output       op-err)"}

   if ip_invoice_domain <> global_domain then do:
      /* SWITCH TO INVOICE DOMAIN */
      run switchDomain
         (input  ip_invoice_domain,
          output undo_flag).

      if undo_flag then do:
         op_continue-yn = no.
         hide message.
         undo, return.
      end.
   end.

   if op-err = 1 then
      leave.

   if op_continue-yn = no
      and op-err = 2
   then
      leave.

   if op_continue-yn = no
      and op-err = 3
   then
      return.

   /* UPDATE SO IN INVOICE DOMAIN */
   if last(ac_line) then
      {gprun.i ""socnua2b.p""
            "(input ip_effdate,
              input-output table tt_so_update,
              input ac_asn_shipper)"}


end.   /* FOR EACH bUsage */

op_continue-yn = yes.

/* RUN THE AUTO INVOICE POST PROGRAM */
{gprun.i ""socnpst.p""
         "(input op_batch_id,
           input ip_effdate,
           input ip_invoice_domain,
           input-output table tt_so_update)"}

/* ========================================================================== */
/* ************************* INTERNAL PROCEDURES **************************** */
/* ========================================================================== */

{socnucpl.i}   /* COMMON INTERNAL PROCEDURES FOR ALL USAGE PROGRAMS */
