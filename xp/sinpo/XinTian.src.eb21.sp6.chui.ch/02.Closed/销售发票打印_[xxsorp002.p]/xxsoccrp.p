/* soccrp.p - CONTAINER CHARGE INVOICE PRINT                               */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.17 $            */
/*                                                                         */
/* Revision: 1.13        BY: Dan Herman    DATE: 07/16/01   ECO: *P006*  */
/* Revision: 1.15  BY: Dan Herman DATE: 08/15/01 ECO: *P01L* */
/* $Revision: 1.17 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100726.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

/*V8:ConvertMode=FullGUIReport                                              */
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
Purpose:       PROCEDURE TO CALCULATE AND PRINT CONTAINER CHARGES ON
                THE INVOICE OUTPUT.

Exceptions:    None
Conditions:
Pre:           Container Charges must be enabled.
Post:
Notes:
History:

Inputs:
ipSoRecid               (recid)
ipCombinedInvoiceNumber (character)

Outputs:
opTotalCharge           (decimal)
----------------------------------------------------------------------------*/

{mfdeclre.i}
{gplabel.i}

define input parameter ipSoRecid as recid no-undo.
define input parameter ipCombinedInvoiceNumber as character no-undo.
define output parameter opTotalCharge as decimal no-undo.

define     shared variable inv_only as logical.

define variable print_summ_only like mfc_logical no-undo.
define variable v_shipto like sod_ship no-undo.
define variable charge_total like idhlc_price no-undo.
define variable vInvoiceNumber as character no-undo.

/* DEFINE TEMP-TABLE FOR CONTAINER CHARGES */
define temp-table container_tt no-undo
   field container_item like abs_item
   field container_charge_type like abscc_charge_type
   field container_charge as decimal
   field container_taxable like idhlc_taxable
   field container_qty like sod_qty_inv
   field container_desc like pt_desc1
   field container_desc1 like pt_desc1
   field container_desc2 like pt_desc1
   index container_ix is unique primary
   container_item container_charge_type container_charge.

/* FORM DEFINITION FOR CONTAINER CHARGES */
form
   container_item     at 5
   container_taxable  at 25
   container_qty      at 30 label "Shipped"
   container_charge   at 45 label "Price"
   charge_total       at 63 label "Extended Price"
with frame container_charges down width 80
   title color normal (getFrameTitle("CONTAINER_CHARGES",29)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame container_charges:handle).

for first so_mstr no-lock  where so_mstr.so_domain = global_domain and
   recid(so_mstr) = ipSoRecid.
end.

if not available so_mstr then leave.

vInvoiceNumber = if so_inv_nbr <> "" then so_inv_nbr
                 else ipCombinedInvoiceNumber.

for first ccls_mstr no-lock  where ccls_mstr.ccls_domain = global_domain and
   ccls_shipfrom = so_site and
   ccls_shipto = so_ship:
   print_summ_only = ccls_cc_invoice.
end.
if not available ccls_mstr then
for first ccls_mstr no-lock  where ccls_mstr.ccls_domain = global_domain and
   ccls_shipfrom = "" and
   ccls_shipto = so_ship:
   print_summ_only = ccls_cc_invoice.
end.

if not available ccls_mstr then
   for first ccl_ctrl  where ccl_ctrl.ccl_domain = global_domain no-lock:
   print_summ_only = ccl_cc_invoice.
end.

for each abscc_det exclusive-lock  where abscc_det.abscc_domain = global_domain
and (
   abscc_order = so_nbr and
   (abscc_inv_nbr = "" or abscc_inv_nbr = vInvoiceNumber) and
   abscc_confirmed ) :

   if inv_only and abscc_qty = 0 then next.

   assign
      abscc_inv_nbr = vInvoiceNumber
      opTotalCharge = opTotalCharge + (abscc_qty * abscc_cont_price).

   if not print_summ_only then do:
      for first container_tt exclusive-lock where
         container_item = abscc_container and
         container_charge_type = abscc_charge_type and
         container_charge = abscc_cont_price:

         container_qty = container_qty + abscc_qty.

      end.

      if not available container_tt then do:
         create container_tt.
         assign
            container_item = abscc_container
            container_charge_type = abscc_charge_type
            container_charge = abscc_cont_price
            container_taxable = abscc_taxable
            container_qty = abscc_qty.
         if recid(container_tt) = -1 then.

         for first ptc_det no-lock  where ptc_det.ptc_domain = global_domain
         and
            ptc_part = container_item:
            container_desc = ptc_container_desc.
         end.
         if available ptc_det then do:
            for first pt_mstr fields( pt_domain pt_desc1 pt_desc2) no-lock
                where pt_mstr.pt_domain = global_domain and  pt_part = ptc_part:
               assign
                  container_desc1 = pt_desc1
                  container_desc2 = pt_desc2.
            end.
         end.
      end. /* IF NOT AVAILABLE CONTAINER_TT */
   end. /* IF NOT PRINT_SUMM_ONLY */
end. /*FOR EACH ABSCC_DET */

/* SS - 100726.1 - B 
if not print_summ_only then do:
   for each container_tt no-lock:

      assign
         charge_total = (container_qty * container_charge).

      display
         container_item
         container_taxable
         container_qty
         container_charge
         charge_total
      with frame container_charges.

      if container_desc > "" then put container_desc at 5.
      if container_desc1 > "" then put container_desc1 at 5.
      if container_desc2 > "" then put container_desc2 at 5.

      down with frame container_charges.
   end. /* FOR EACH CONTAINER_TT ... */
end. /* IF NOT PRINT_SUMM_ONLY */
   SS - 100726.1 - E */
