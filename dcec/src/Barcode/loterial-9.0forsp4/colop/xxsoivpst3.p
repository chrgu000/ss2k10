/* soivpst3.p - CONTAINER AND LINE CHARGES                                  */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.9 $     */
/*                                                                          */
/* -------------------------------------------------------------------------
Purpose:       Get the container and line charge totals for the
                Sales Order.

Exceptions:    None
Conditions:
Pre:           Container and or Line Charges must be enabled.
Post:
Notes:
History:

Inputs:
ipSoRecid                (recid)

Outputs:
opContainerCharges       (decimal)
opLineCharges            (decimal)
----------------------------------------------------------------------------*/
/*                                                                          */
/* Revision: 1.8       BY: Dan Herman       DATE: 07/16/01   ECO: *P006*  */
/* $Revision: 1.9 $      BY: Dan Herman       DATE: 01/30/02   ECO: *P046*  */
/*V8:ConvertMode=NoConvert                                            */
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



{mfdeclre.i}

define input parameter ipSoRecid as recid no-undo.
define output parameter opContainerCharges as decimal no-undo.
define output parameter opLineCharges as decimal no-undo.

define variable vAbslExists as logical no-undo.
{gpfilev.i}
{cclc.i}

for first so_mstr fields(so_nbr so_inv_nbr) no-lock where
   recid(so_mstr) = ipSoRecid.
end.

for each sod_det
   fields (sod_site sod_nbr sod_line sod_qty_inv sod_part)
   no-lock where
   sod_nbr = so_nbr  and
   sod_qty_inv <> 0:

   if using_line_charges then do:
      vAbslExists = no.
      for each absl_det
         fields(absl_order absl_ord_line absl_inv_nbr
                absl_abs_shipfrom absl_confirmed
                absl_ext_price)
         no-lock where
         absl_abs_shipfrom = sod_site  and
         absl_order = so_nbr           and
         absl_ord_line = sod_line      and
         absl_inv_nbr = so_inv_nbr     and
         absl_confirmed:

         assign
            vAbslExists = yes
            opLineCharges = opLineCharges + absl_ext_price.
      end. /* FOR EACH absl_det */

      if not vAbslExists then do:
         for each sodlc_det
            fields(sodlc_order sodlc_ord_line
                   sodlc_ext_price sodlc_one_time
                   sodlc_times_charged)
            no-lock where
            sodlc_order = so_nbr  and
            sodlc_ord_line = sod_line:

            if sodlc_one_time and sodlc_times_charged > 1
               then next.

            opLineCharges = opLineCharges + sodlc_ext_price.

         end. /* FOR EACH sodlc_det */
      end. /* IF NOT absl_exists */
   end. /* IF using_line_charges */


   if using_container_charges then do:
      for each abscc_det
         fields(abscc_abs_shipfrom abscc_order
                abscc_ord_line abscc_inv_nbr
                abscc_qty abscc_cont_price)
         no-lock where
         abscc_abs_shipfrom = sod_site and
         abscc_order = sod_nbr and
         abscc_ord_line = sod_line and
         abscc_inv_nbr = so_inv_nbr:

         opContainerCharges = opContainerCharges +
                              (abscc_qty * abscc_cont_price).
      end.
   end. /* IF pUsingContainerCharge */
end. /* FOR EACH sod_det */
