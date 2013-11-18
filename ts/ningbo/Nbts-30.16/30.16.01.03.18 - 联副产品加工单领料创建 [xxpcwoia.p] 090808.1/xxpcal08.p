/* wocsal02.p - -- JOINT PRODUCTS AVG COST: ALLOCATION METHOD 02              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.5     LAST MODIFIED: 02/21/95    BY: pma *J026*                */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00    BY: *N0KC* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.4  BY: Katie Hilbert DATE: 04/01/01 ECO: *P008* */
/* $Revision: 1.6 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/************************************************************************/
/* Allocation Method based on Price                                     */
/*                                                                      */
/* Allocation percentage must be a number between 0.00 and 1.00         */
/*                                                                      */
/* Cost of negative work orders is not re-averaged; the allocation      */
/*    percentage equals zero and the cost falls to discrepany           */
/************************************************************************/

/* SS - 090713.1 By: Bill Jiang */

/* SS - 090713.1 - RNB

[090713.1]

pt_size

[090713.1]

SS - 090713.1 - RNE */

{mfdeclre.i}

define input parameter base_recid as recid.

define shared workfile alloc_wkfl no-undo
   field alloc_wonbr as character
   field alloc_recid as recid
   field alloc_numer as decimal
   field alloc_pct   as decimal.

define variable denom as decimal no-undo.
define variable conv as decimal no-undo.
define variable wonbr like wo_nbr no-undo.
define variable alloctot as decimal no-undo.

/*INITIALIZE VARIABLES*/
for each alloc_wkfl exclusive-lock:
   delete alloc_wkfl.
end.
denom = 0.

/*GET BASE WORK ORDER AND BASE UM FROM BOM_MSTR*/
find wo_mstr no-lock where recid(wo_mstr) = base_recid no-error.
if not available wo_mstr then return.
wonbr = wo_nbr.
find bom_mstr no-lock  where bom_mstr.bom_domain = global_domain and
bom_parent = wo_part no-error.
if not available bom_mstr then return.

/*CREATE ALLOC_WKFL FOR CO-PRODUCTS ONLY*/
/*CALCULATE DENOMINATOR & STORE NUMERATOR FOR ALLOCATION PERCENTAGE*/
for each wo_mstr no-lock  where wo_mstr.wo_domain = global_domain and  wo_nbr =
wonbr
      and wo_joint_type = "1":

   find first alloc_wkfl exclusive-lock
      where alloc_recid = recid(wo_mstr) no-error.
   if not available alloc_wkfl then do:
      create alloc_wkfl.
      assign
         alloc_wonbr = wonbr
         alloc_recid = recid(wo_mstr).
   end.

   /* SS - 090713.1 - B
   if wo_qty_comp + wo_qty_rjct <> 0 then do:
   SS - 090713.1 - E */
   /* SS - 090713.1 - B */
   if wo_qty_ord <> 0 then do:
   /* SS - 090713.1 - E */
      find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
      pt_part = wo_part no-error.
      if available pt_mstr then do:
         conv = 1.
         if available pt_mstr and pt_um <> bom_batch_um then do:
            {gprun.i ""gpumcnv.p"" "(pt_um,
                                     bom_batch_um,
                                     pt_part,
                                     output conv)"}
            if conv = ? or conv = 0 then conv = 1.
         end.

         /* SS - 090713.1 - B
         alloc_numer = max(0,pt_price / conv).
         SS - 090713.1 - E */
         /* SS - 090713.1 - B */
         alloc_numer = max(0,pt_size / conv).
         /* SS - 090713.1 - E */
         if alloc_numer = ? then alloc_numer = 0.
         denom = denom + alloc_numer.
      end.
   end.
end.

/*
/*CALCULATE ALLOCATION PERCENTAGE*/
if denom <> 0 then do:
   for each alloc_wkfl exclusive-lock where alloc_wonbr = wonbr:
      alloc_pct = min(1,max(0,alloc_numer / denom)).
      if alloc_pct = ? then alloc_pct = 0.
      alloctot = alloctot + alloc_pct.
   end.
end.

/*ELIMINATE ROUNDING ERROR*/
/*APPLY DIFFERENCE TO CO-PRODUCT WITH GREATEST ALLOCATION*/
if alloctot <= 0 or alloctot >= 1 then return.
for each alloc_wkfl exclusive-lock where alloc_wonbr = wonbr
      break by alloc_pct descending:
   alloc_pct = alloc_pct + (1 - alloctot).
   leave.
end.
*/
/*CALCULATE ALLOCATION PERCENTAGE*/
if denom <> 0 then do:
   for each alloc_wkfl exclusive-lock where alloc_wonbr = wonbr
      AND alloc_numer <> 0
      BREAK
      BY alloc_recid
      :
      IF LAST(alloc_recid) THEN DO:
         alloc_pct = 1 - alloctot.
      END.
      ELSE DO:
         alloc_pct = min(1,max(0,alloc_numer / denom)).
         if alloc_pct = ? then alloc_pct = 0.
         alloctot = alloctot + alloc_pct.
      END.
   end.
end.
