/* ppsuxr.p - Supplier Item Responsibility Program                            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.1.3.2 $                                                      */
/*                                                                            */
/* This program contains library of internal procedures. These internal       */
/* procedures contain business logic related to supplier item, which are      */
/* called by Controllers / GUI & CHUI programs.                               */
/*                                                                            */
/* Revision: 1.1      BY:Poonam Bahl       DATE: 03/21/00   ECO: *N059*    */
/* Revision: 1.1.3.1  BY: Pankaj Goswami   DATE: 12/24/03   ECO: *P1FV*    */
/* $Revision: 1.1.3.2 $  BY: Pankaj Goswami   DATE: 01/16/04   ECO: *P1K0*  */
/*                                                                            */
/*V8:ConvertMode=NoConvert                                                    */

/* ========================================================================== */
/* ******************************* DEFINITIONS ****************************** */
/* ========================================================================== */

/* STANDARD INCLUDE FILES */
{mfdeclre.i}
{pxmaint.i}


/* ========================================================================== */
/* ******************************** FUNCTIONS ******************************* */
/* ========================================================================== */

/*============================================================================*/
FUNCTION isSupplierItemInUse RETURNS logical :

/*------------------------------------------------------------------------------
Purpose:       Determines if Supplier Items are being used by this installation.
Exceptions:    None
Conditions:
        Pre:   None
       Post:   vp_mstr(r)
Notes:
History:       Extracted from popomtd.p
------------------------------------------------------------------------------*/
   define variable returnData as logical no-undo.

   if can-find(first vp_mstr where vp_part >= ""
                 and vp_vend >= ""
                 and vp_vend_part >= "")
   then
      returnData = TRUE.
   else
      returnData = FALSE.

   return (returnData).

END FUNCTION.


/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE getManufacturerItemData :

/*------------------------------------------------------------------------------
Purpose:       Gets Manufacturer Data
Exceptions:    RECORD-NOT-FOUND
Conditions:
        Pre:   vp_mstr(r)
        Post:  vp_mstr(r)
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define input parameter  pItemId           as character  no-undo.
   define input parameter  pSupplierItemId   as character no-undo.
   define input parameter  pSupplierId       as character no-undo.
   define output parameter pManufactItemId   as character no-undo.
   define output parameter pManufacturer     as character no-undo.
   define output parameter pSupplierItemUOM  as character no-undo.

   define buffer vp_mstr for vp_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
     if pSupplierItemId = "" then do :
         /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
         /* FOR AN INVENTORY ITEM                                      */
         for first vp_mstr
            fields(vp_part vp_mfgr vp_vend vp_mfgr_part vp_um) where
            vp_part = pItemId and
            ( vp_vend = pSupplierId
              or (vp_vend = ""
                  and not can-find(first vp_mstr
                  where vp_part = pItemId
                  and   vp_vend = pSupplierId)) )
         no-lock: end.
         if available vp_mstr then
            assign
               pManufactItemId  = vp_mstr.vp_mfgr_part
               pManufacturer    = vp_mfgr
               pSupplierItemUOM = vp_um.
         else
            return {&RECORD-NOT-FOUND}.
      end. /* If pSupplierItemId = "" */
      else do :
         /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
         /* FOR AN INVENTORY ITEM                                      */
         for first vp_mstr
           fields(vp_part vp_vend_part vp_mfgr vp_vend vp_mfgr_part vp_um) where
           vp_part      = pItemId and
           vp_vend_part = pSupplierItemId and
           ( vp_vend      = pSupplierId
             or (vp_vend = ""
                 and not can-find(first vp_mstr
                 where vp_part = pItemId
                 and   vp_vend = pSupplierId)) )
         no-lock: end.
         if available vp_mstr then
            assign
               pManufactItemId  = vp_mfgr_part
               pManufacturer    = vp_mfgr
               pSupplierItemUOM = vp_um.
         else
            return {&RECORD-NOT-FOUND}.
      end. /* Else Do */

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getManufacturerItemDataOfLastQuote :

/*------------------------------------------------------------------------------
Purpose:       Gets Supplier Item, Manufacturer and Manufacturer Item from
               Supplier Item master.
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r),po_mstr(r)
       Post:   vp_mstr(r)
Notes:         The data is selected from Supplier Item master for a given Item,
               Supplier, Supplier Item and for the latest Quote Date.
History:       Extracted from popomtea.p
------------------------------------------------------------------------------*/
   define input        parameter pItemId             as character no-undo.
   define input        parameter pSupplierId         as character no-undo.
   define input-output parameter pSupplierItemId     as character no-undo.
   define output       parameter pManufacturer       as character no-undo.
   define output       parameter pManufacturerItemId as character no-undo.

   define buffer vp_mstr for vp_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
      /* FOR AN INVENTORY ITEM                                      */
      for each vp_mstr
         fields(vp_part vp_vend_part vp_vend vp_q_date
                vp_mfgr vp_mfgr_part)
         where vp_part = pItemId
         and   ( vp_vend = pSupplierId
                 or (vp_vend = "" and
                     not can-find(first vp_mstr
                     where vp_part = pItemId
                     and   vp_vend = pSupplierId)) )
         and   (pSupplierItemId = ""
                or vp_vend_part = pSupplierItemId)
         no-lock
         break by vp_q_date descending:

         if first(vp_q_date) then do:
            assign
               pSupplierItemId     = vp_mstr.vp_vend_part
               pManufacturer       = vp_mfgr
               pManufacturerItemId = vp_mfgr_part.

            leave.
         end.
      end. /* For each vp_mstr */
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getSupplierQuotePrice :

/*------------------------------------------------------------------------------
Purpose:       Gets the Supplier Quote Price after applying conversion factor
               from Supplier Item master.
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r),po_mstr(r)
       Post:   vp_mstr(r)
Notes:         The data is selected from Supplier Item master for the given
               Item, Supplier and for latest Quote Date.
History:       Extracted from popomtea.p
------------------------------------------------------------------------------*/
   define input  parameter pItemId          as character no-undo.
   define input  parameter pSupplierId      as character no-undo.
   define input  parameter pCurrencyId      as character no-undo.
   define input  parameter pUnitOfMeasure   as character no-undo.
   define input  parameter pQuantityOrdered as decimal no-undo.
   define input  parameter pSupplierItemId  as character no-undo.
   define output parameter pPurchaseCost    as decimal no-undo.

   define buffer vp_mstr for vp_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      pPurchaseCost = ?.

      if pSupplierItemId = ""
      then do:
         /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
         /* FOR AN INVENTORY ITEM                                      */
         for each vp_mstr
            fields(vp_part vp_vend vp_vend_part vp_q_date vp_um
                   vp_q_qty vp_curr vp_q_price)
            where vp_part = pItemId
            and   ( vp_vend = pSupplierId
                    or (vp_vend = ""
                        and not can-find(first vp_mstr
                        where vp_part = pItemId
                        and   vp_vend = pSupplierId)) )
            no-lock
            break by vp_q_date descending:

            if first(vp_q_date)
            then do:
               run purCostItem(input  vp_um,
                               input  pUnitOfMeasure,
                               input  pItemId,
                               input  pQuantityOrdered,
                               input  vp_q_qty,
                               input  pCurrencyId,
                               input  vp_curr,
                               input  vp_q_price,
                               output pPurchaseCost).

               leave.
            end. /* If first(vp_q_date) */
         end. /* For each vp_mstr */
      end. /* IF pSupplierItemId = "" */
      else
      do:
         /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
         /* FOR AN INVENTORY ITEM                                      */
         for each vp_mstr
            fields(vp_part vp_vend vp_vend_part vp_q_date vp_um
                   vp_q_qty vp_curr vp_q_price)
            where vp_part = pItemId
            and   ( vp_vend = pSupplierId
                    or (vp_vend = ""
                        and not can-find(first vp_mstr
                        where vp_part = pItemId
                        and   vp_vend = pSupplierId)) )
            and vp_vend_part = pSupplierItemId
            no-lock
            break by vp_q_date descending:

            if first(vp_q_date)
            then do:
               run purCostItem(input  vp_um,
                               input  pUnitOfMeasure,
                               input  pItemId,
                               input  pQuantityOrdered,
                               input  vp_q_qty,
                               input  pCurrencyId,
                               input  vp_curr,
                               input  vp_q_price,
                               output pPurchaseCost).

               leave.
            end. /* If first(vp_q_date) */
         end. /* For each vp_mstr */
      end. /* else do */
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE processRead :

/*------------------------------------------------------------------------------
Purpose:       Read Supplier-Item Record Based On Lock And Wait Flags
Exceptions:    RECORD-NOT-FOUND, RECORD-LOCKED
Conditions:
        Pre:   None
        Post:  vp_mstr(r)
Notes:
History:       Extracted from popomth.p
------------------------------------------------------------------------------*/
   define input parameter pItemId         as character no-undo.
   define input parameter pSupplierId     as character no-undo.
   define input parameter pSupplierItemId as character no-undo.
   define parameter buffer vp_mstr        for vp_mstr.
   define input parameter pLockFlag       as logical no-undo.
   define input parameter pWaitFlag       as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      if pSupplierItemId <> '' then do:
         if pLockFlag then do :
            if pWaitFlag then
               /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
               /* FOR AN INVENTORY ITEM                                      */
               for first vp_mstr
                  where vp_part      = pItemId
                  and   ( vp_vend      = pSupplierId
                          or (vp_vend = ""
                              and not can-find(first vp_mstr
                              where vp_part = pItemId
                              and   vp_vend = pSupplierId)) )
                  and   vp_vend_part = pSupplierItemId
                  exclusive-lock : end.
            else do :
               /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
               /* FOR AN INVENTORY ITEM                                      */
               find first vp_mstr
                  where vp_part      = pItemId
                  and   ( vp_vend      = pSupplierId
                          or (vp_vend = ""
                              and not can-find(first vp_mstr
                              where vp_part = pItemId
                              and   vp_vend = pSupplierId)) )
                  and   vp_vend_part = pSupplierItemId
                  exclusive-lock no-wait no-error.

               if locked vp_mstr then
                  return {&RECORD-LOCKED}.
            end.
         end. /* If pLockFlag */
         else
            /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
            /* FOR AN INVENTORY ITEM                                      */
            for first vp_mstr
               where vp_part      = pItemId
               and   ( vp_vend      = pSupplierId
                       or (vp_vend = ""
                           and not can-find(first vp_mstr
                           where vp_part = pItemId
                           and   vp_vend = pSupplierId)) )
               and   vp_vend_part = pSupplierItemId
               no-lock : end.

      end. /* If pSupplierItemId <> '' */
      else do:

         if pLockFlag then do :
            if pWaitFlag then
               /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
               /* FOR AN INVENTORY ITEM                                      */
               for first vp_mstr
                  where vp_part = pItemId
                  and   ( vp_vend = pSupplierId
                          or (vp_vend = ""
                              and not can-find(first vp_mstr
                              where vp_part = pItemId
                              and   vp_vend = pSupplierId)) )
                  exclusive-lock : end.
            else do :
               /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
               /* FOR AN INVENTORY ITEM                                      */
               find first vp_mstr
                  where vp_part = pItemId
                  and   ( vp_vend = pSupplierId
                          or (vp_vend = ""
                              and not can-find(first vp_mstr
                              where vp_part = pItemId
                              and   vp_vend = pSupplierId)) )
                  exclusive-lock no-wait no-error.

               if locked vp_mstr then
                  return {&RECORD-LOCKED}.
            end.
         end. /* If pLockFlag */
         else
            /* CHECKING FOR BLANK SUPPLIER BUT, WITH NO SPECIFIC SUPPLIER */
            /* FOR AN INVENTORY ITEM                                      */
            for first vp_mstr
               where vp_part = pItemId
               and   ( vp_vend = pSupplierId
                       or (vp_vend = ""
                           and not can-find(first vp_mstr
                           where vp_part = pItemId
                           and   vp_vend = pSupplierId)) )
               no-lock : end.

      end. /* Else */

      if not available vp_mstr then
         return {&RECORD-NOT-FOUND}.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE setQuoteCost :

/*------------------------------------------------------------------------------
Purpose:       Set the quote cost from Purchase Order
Exceptions:    NONE
Conditions:
Pre:           vp_mstr(r)
Post:          vp_mstr(w)
Notes:
History:       Procedure initially extracted from popomtd.p
------------------------------------------------------------------------------*/
   define input parameter pSupplierItemId as character no-undo.
   define input parameter pItemId         as character no-undo.
   define input parameter pSupplierId     as character no-undo.
   define input parameter pQuotePrice     as decimal   no-undo.

   define buffer vp_mstr for vp_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='processRead'
         &PARAM="(input pItemId,
                  input pSupplierId,
                  input pSupplierItemId,
                  buffer vp_mstr,
                  input TRUE,
                  input TRUE)"}
      if return-value = {&SUCCESS-RESULT} then
      assign
         vp_q_price = pQuotePrice
         vp_q_date = today.

   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE purCostItem:

/*------------------------------------------------------------------------------
Purpose:       To get the Purchase Cost depending on conversion factor.
Exceptions:    NONE
Conditions:    NONE
History:       Repetition of code in procedure getSupplierQuotePrice.
------------------------------------------------------------------------------*/
   define input  parameter pUm              as character no-undo.
   define input  parameter pUnitOfMeasure   as character no-undo.
   define input  parameter pItemId          as character no-undo.
   define input  parameter pQuantityOrdered as decimal   no-undo.
   define input  parameter pVpQty           as decimal   no-undo.
   define input  parameter pCurrencyId      as character no-undo.
   define input  parameter pVpCurr          as character no-undo.
   define input  parameter pVpPrice         as decimal   no-undo.
   define output parameter pPurchaseCost    as decimal   no-undo.

   define variable conversion_factor as decimal no-undo.

   conversion_factor = 1.

   if pUm <> pUnitOfMeasure
   then do:
      {gprun.i ""gpumcnv.p""
                "(input pUm,
                  input pUnitOfMeasure,
                  input pItemId,
                  output conversion_factor)"}
   end. /* IF pUm <> pUnitOfMeasure */

   if conversion_factor <> ?
   then do:
      if pQuantityOrdered / conversion_factor >= pVpQty
         and pCurrencyId = pVpCurr
      then
         pPurchaseCost = pVpPrice / conversion_factor.
   end. /* IF conversion_factor <> ? */

END PROCEDURE.  /* purCostItem */

