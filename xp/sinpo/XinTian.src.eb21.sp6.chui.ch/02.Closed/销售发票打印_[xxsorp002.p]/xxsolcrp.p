/* solcrp.p - LINE CHARGE INVOICE PRINT                                 */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.19 $            */
/*                                                                      */
/* Revision: 1.14        BY: Dan Herman    DATE: 07/16/01   ECO: *P006*  */
/* Revision: 1.16        BY: Dan Herman    DATE: 08/15/01   ECO: *P01L*  */
/* Revision: 1.17  BY: Dan Herman DATE: 01/30/02 ECO: *P046* */
/* $Revision: 1.19 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100726.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

/*V8:ConvertMode=Report                                                 */
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

/*------------------------------------------------------------------------
Purpose:       PROCEDURE TO CALCULATE AND PRINT  LINE CHARGES ON
                THE INVOICE OUTPUT.

Exceptions:    None
Conditions:
Pre:           Line Charges must be enabled.
Post:
Notes:
History:

Inputs:
ipSoRecid               (recid)
ipSodRecid              (recid)
ipCombinedInvoiceNumber (character)
Input-Outputs:
iopTotalCharge          (decimal)
----------------------------------------------------------------------------*/

{mfdeclre.i}
{gplabel.i}

define input parameter ipSoRecid as recid no-undo.
define input parameter ipSodRecid as recid no-undo.
define input parameter ipCombinedInvoiceNumber as character no-undo.
define input-output parameter iopTotalCharge as decimal no-undo.

define variable charge_total like idhlc_price no-undo.
define variable print_summ_only like mfc_logical no-undo.
define variable v_shipto like sod_ship no-undo.
define variable vInvoiceNumber as character no-undo.

/* DEFINE TEMP-TABLE FOR LINE CHARGES */
define temp-table linecharge_tt no-undo
   field linecharge_code like absl_trl_code
   field linecharge_ord_line like sod_line
   field linecharge_desc like trl_desc
   field linecharge_taxable like idhlc_taxable
   field linecharge_price like idhlc_price
   field linecharge_ext_price like idhlc_price
   index linecharge_ix is unique primary
   linecharge_ord_line linecharge_code.

/* FORM DEFINITION FOR LINE CHARGES */
form
   linecharge_desc    at 5
   linecharge_taxable at 32
   linecharge_price   at 37
   charge_total       at 55 label "Extended Price"
with frame line_charge down width 80
   title color normal (getFrameTitle("ADDITIONAL_LINE_CHARGES",29)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame line_charge:handle).

for first so_mstr no-lock  where so_mstr.so_domain = global_domain and
      recid(so_mstr) = ipSoRecid.
end.

if not available so_mstr then leave.

for first sod_det no-lock  where sod_det.sod_domain = global_domain and
      recid(sod_det) = ipSodRecid.
end.

assign
   vInvoiceNumber = if so_inv_nbr <> "" then so_inv_nbr
                 else ipCombinedInvoiceNumber
   v_shipto = (if sod_dock > "" then sod_dock
               else if sod_ship > "" then sod_ship
               else so_ship).

for first ccls_mstr no-lock  where ccls_mstr.ccls_domain = global_domain and
      ccls_shipfrom = so_site and
      ccls_shipto = v_shipto:
   print_summ_only = ccls_lc_invoice.
end.
if not available ccls_mstr then
for first ccls_mstr no-lock  where ccls_mstr.ccls_domain = global_domain and
      ccls_shipfrom = "" and
      ccls_shipto = v_shipto:
   print_summ_only = ccls_lc_invoice.
end.

if not available ccls_mstr then
   for first ccl_ctrl  where ccl_ctrl.ccl_domain = global_domain no-lock:
   print_summ_only = ccl_lc_invoice.
end.


for first absl_det no-lock  where absl_det.absl_domain = global_domain and (
      absl_abs_shipfrom = sod_site  and
      absl_order = so_nbr           and
      absl_ord_line = sod_line      and
      (absl_inv_nbr = "" or absl_inv_nbr = vInvoiceNumber) and
      absl_confirmed ) :
end.  /*FOR FIRST ABSL_DET*/

if available absl_det then do:
   for each absl_det exclusive-lock  where absl_det.absl_domain = global_domain
   and (
         absl_abs_shipfrom = sod_site  and
         absl_order = so_nbr           and
         absl_ord_line = sod_line      and
         (absl_inv_nbr = "" or absl_inv_nbr = vInvoiceNumber) and
         absl_confirmed
         ) break by absl_ord_line:

      absl_inv_nbr = vInvoiceNumber.

      for first sodlc_det exclusive-lock  where sodlc_det.sodlc_domain =
      global_domain and
            sodlc_order = absl_order and
            sodlc_ord_line = absl_ord_line and
            sodlc_lc_line = absl_lc_line:

         if sodlc_owned_by > "" then sodlc_one_time = yes.
         sodlc_times_charged = sodlc_times_charged + 1.
      end.

      /* IF PRINTING LINE CHARGES, ACCUMULATE TOTALS */
      /* FOR EACH DIFFERENT LINE CHARGE IN A TEMP    */
      /* TABLE TO BE USED LATER ON FOR PRINTING.     */

      if not print_summ_only then do:
         for first trl_mstr no-lock  where trl_mstr.trl_domain = global_domain
         and
               trl_code = absl_trl_code:
         end.

         for first linecharge_tt exclusive-lock where
               linecharge_code = absl_trl_code:
            assign
               linecharge_ext_price = linecharge_ext_price +
                                      (if sod_qty_inv = 0 then 0
                                         else absl_ext_price)
               linecharge_price = linecharge_price + absl_ext_price.
         end.

         if not available linecharge_tt then do:
            create linecharge_tt.
            assign
               linecharge_code = absl_trl_code
               linecharge_ord_line = sod_line
               linecharge_desc = trl_desc
               linecharge_taxable = trl_taxable
               linecharge_price = absl_ext_price
               linecharge_ext_price = if sod_qty_inv = 0 then 0
                                         else absl_ext_price.
            if recid(linecharge_tt) = -1 then.
         end.

      end. /* IF NOT PRINT_SUMM_ONLY */

      iopTotalCharge = iopTotalCharge + absl_ext_price.
   end. /* FOR EACH ABSL_DET */
end. /* IF AVAILABLE ABSL_DET */

else do:
   for each sodlc_det exclusive-lock  where sodlc_det.sodlc_domain =
   global_domain and
         sodlc_order = so_nbr          and
         sodlc_ord_line = sod_line
         break by sodlc_ord_line:

      if sodlc_one_time and sodlc_times_charged > 1 then next.

      sodlc_times_charged = sodlc_times_charged + 1.

      /* IF PRINTING LINE CHARGES, ACCUMULATE TOTALS */
      /* FOR EACH DIFFERENT LINE CHARGE IN A TEMP    */
      /* TABLE TO BE USED LATER ON FOR PRINTING.     */
      if not print_summ_only then do:
         for first trl_mstr no-lock  where trl_mstr.trl_domain = global_domain
         and
               trl_code = sodlc_trl_code:
         end.

         for first linecharge_tt exclusive-lock where
               linecharge_code = sodlc_trl_code:
            assign
               linecharge_ext_price = linecharge_ext_price +
                                      (if sod_qty_inv = 0 then 0
                                         else sodlc_ext_price)
               linecharge_price = linecharge_price + sodlc_ext_price.
         end.

         if not available linecharge_tt then do:
            create linecharge_tt.
            assign
               linecharge_code = sodlc_trl_code
               linecharge_ord_line = sod_line
               linecharge_desc = trl_desc
               linecharge_taxable = trl_taxable
               linecharge_price = sodlc_ext_price
               linecharge_ext_price = if sod_qty_inv = 0 then 0
                                         else sodlc_ext_price.
            if recid(linecharge_tt) = -1 then.
         end.
      end. /* IF print_summ_only */
      iopTotalCharge = iopTotalCharge + sodlc_ext_price.
   end. /* FOR EACH sodlc_det*/
end. /* ELSE DO*/

/* PRINT DETAILS OF ACCUMULATED LINE CHARGE TOTALS */
/* SS - 100726.1 - B 
if not print_summ_only then do:
   for each linecharge_tt no-lock
         break by linecharge_ord_line:

      accumulate linecharge_ext_price (total).

      display
         linecharge_desc
         linecharge_taxable
         linecharge_price
      with frame line_charge.

      if last-of(linecharge_ord_line) then do:
         charge_total = accum total linecharge_ext_price.
         display
            charge_total
         with frame line_charge.
      end.
      down with frame line_charge.
   end. /* FOR EACH LINECHARGE_TT */
end. /* PRINT_SUMM_ONLY */
   SS - 100726.1 - E */
