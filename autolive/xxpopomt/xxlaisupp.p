/* laisupp.p - LOGISTICS ACCOUNTING CHARGE DETAILS POPOULATE lacd-det         */
/* Copyright 1986 QAD Inc. All rights reserved.                               */
/* $Id:: laisupp.p 32651 2013-07-05 02:01:07Z lez                          $: */
/*                                                                            */
/* Revision: 1.7       BY: Tiziana Giustozzi   DATE: 05/24/02 ECO: *P03Z*     */
/* Revision: 1.9       BY: Jean Miller         DATE: 06/06/02 ECO: *P080*     */
/* Revision: 1.10  BY: Tiziana Giustozzi DATE: 06/17/02  ECO: *P08H*    */
/* Revision: 1.12  BY: Tiziana Gisutozzi DATE: 07/17/02 ECO: *P0BG* */
/* $Revision: 1.14 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/*-Revision end---------------------------------------------------------------*/
/*                                                                            */
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

{us/bbi/mfdeclre.i}
{us/ap/apconsdf.i}
{us/px/pxmaint.i}
{us/px/pxphdef.i laplxr}
define input parameter ip-internal-ref like lacd_internal_ref no-undo.
define input parameter ip-internal-ref-type like lacd_internal_ref_type no-undo.
define input parameter ip-po-vend like po_vend no-undo.
define input parameter show-details as logical no-undo.

define variable type-po as character format "x(2)" no-undo.
define variable update-supp as logical no-undo.

for first po_mstr
    where po_mstr.po_domain = global_domain and  po_nbr = ip-internal-ref
     and po_vend = ip-po-vend
no-lock: end.

mainloop:
do on error undo, retry:

   for each totd_det
       where totd_det.totd_domain = global_domain
        and  totd_terms_code = po_tot_terms_code
        and  totd_responsibility = {&CUSTOMER}
   no-lock:

      for first lc_mstr
          where lc_mstr.lc_domain = global_domain
           and  lc_charge = totd_lc_charge
      no-lock: end.

      if not available lc_mstr then next.

      for first lacd_det
          where lacd_det.lacd_domain = global_domain
           and lacd_det.lacd_internal_ref = ip-internal-ref
           and lacd_det.lacd_shipfrom = ip-po-vend
           and lacd_det.lacd_lc_charge = lc_charge
           and lacd_det.lacd_internal_ref_type = ip-internal-ref-type
      exclusive-lock: end.

      if not available lacd_det
      then do:

         create lacd_det.
         assign
            lacd_det.lacd_domain = global_domain
            lacd_det.lacd_internal_ref = ip-internal-ref
            lacd_det.lacd_internal_ref_type = ip-internal-ref-type
            lacd_det.lacd_shipfrom = ip-po-vend
            lacd_det.lacd_lc_charge = totd_lc_charge
            lacd_det.lacd_element = lc_element
            lacd_det.lacd_accrual_level = {&LEVEL_Line}
            lacd_det.lacd_mod_userid =  global_userid
            lacd_det.lacd_ex_rate  = po_ex_rate
            lacd_det.lacd_ex_rate2 = po_ex_rate2
            lacd_det.lacd_fix_rate = po_fix_rate
            lacd_det.lacd_apportion_method  = lc_apportion_method
            lacd_det.lacd_mod_date  = today.

/*616       if lc_supplier = "" and execname = "popomt.p" then do:           */
/*616*/     if lc_supplier = "" and (execname = "popomt.p" or execname = "xxpopomt.p") then do:
               lacd_det.lacd_log_supplier = ip-po-vend.
            end.
            else do:
               lacd_det.lacd_log_supplier = lc_supplier.
            end.

         if lacd_det.lacd_apportion_method = "01" then
            assign lacd_det.lacd_curr = base_curr
                   lacd_det.lacd_ex_rate  = 1
                   lacd_det.lacd_ex_rate2 = 1
                   .
         else do:
            /* POPULATE LOG SUPPLIER CURRENCY AND EX RATE IF IT IS NEEDED */
            find vd_mstr where vd_domain = global_domain
                           and vd_addr   = lc_supplier
                           no-lock no-error.
            if available vd_mstr then do:
               assign lacd_det.lacd_curr = vd_curr.

               if vd_curr <> base_curr then do:
                  {us/px/pxrun.i &PROC='getExchangeRate' &PROGRAM='mcexxr.p'
                           &PROGRAM='mcexxr.p'
                           &PARAM="(input vd_curr,
                                    input base_curr,
                                    input vd_ex_ratetype,
                                    input today,
                                    output lacd_det.lacd_ex_rate,
                                    output lacd_det.lacd_ex_rate2)"
                           &NOAPPERROR=TRUE &CATCHERROR=TRUE
                  }
               end. /* if vd_curr <> base_curr */
            end. /* if avail vd_mstr  */
            else
               assign lacd_det.lacd_curr = po_curr.

            {us/px/pxrun.i &PROC ='pProcLogisticChargePriceList'
                     &PROGRAM='laplxr.p'
                     &HANDLE = ph_laplxr
                     &PARAM ="(input  lacd_lc_charge,
                               input  lacd_curr,
                               input  po_vend,
                               input  po_ship,
                               input  lacd_log_supplier,
                               output lacd_list,
                               output lacd_charge)"}

            assign
               lacd_type = lc_type
               lacd_um   = lc_um.
         end.
         if recid(lacd_det) = -1 then .

      end. /* if not available lacd_det */

   end. /* for each totd_det */

   if show-details
   then do:
      for first lacd_det
          where lacd_det.lacd_domain = global_domain and
          lacd_det.lacd_internal_ref = ip-internal-ref
           and lacd_det.lacd_shipfrom = ip-po-vend
           and lacd_det.lacd_lc_charge = lc_charge
           and lacd_det.lacd_internal_ref_type = ip-internal-ref-type
      no-lock: end.

      pause 0.
      assign
         type-po = {&TYPE_PO}
         update-supp = yes.

      {us/bbi/gprun.i ""lalgsupp.p""
         "(input po_nbr,
           input type-po,
           input update-supp,
           input ip-po-vend)"}

   end. /* if show-details */

end. /* mainloop */

