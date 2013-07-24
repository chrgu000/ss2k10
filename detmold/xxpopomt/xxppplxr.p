/* ppplxr.p - PRICELIST RESPONSIBILITY-OWNING PROGRAM                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6 $                                                           */
/*                                                                            */
/* This program contains library of internal procedures. These internal       */
/* procedures contain business logic related to purchase order line, which    */
/* are called by Controllers / GUI & CHUI programs.                           */
/*                                                                            */
/* Revision: 1.3     BY: Poonam Bahl         DATE: 12/07/99   ECO: *N03S*     */
/* Revision: 1.4     BY: Poonam Bahl         DATE: 03/21/00   ECO: *N03T*     */
/* Revision: 1.5     BY: Julie Milligan      DATE: 05/04/00   ECO: *N09T*     */
/* $Revision: 1.6 $      BY: Jeff Wootton        DATE: 04/21/00   ECO: *N0B9*     */
/*                                                                            */
/*V8:ConvertMode=NoConvert                                                    */

{mfdeclre.i}
{pxmaint.i}
{ppprlst.i}

/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE validatePriceList :
/*---------------------------------------------------------------------------
  Purpose:     Validate Price Lists
  Exceptions:  NONE
  Notes:
  History:
---------------------------------------------------------------------------*/
   define input parameter  pPriceListName   as character no-undo.
   define input parameter  pCurrency        as character no-undo.
   define input parameter  pPriceListReq    as logical   no-undo.
   define input parameter  pWarning         as logical   no-undo.
   define input parameter  pPriceListType   as character no-undo.
   define output parameter pPriceListFailed as logical   no-undo.
   define output parameter pMessageNumber   as integer   no-undo.

   define buffer pc_mstr for pc_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      pPriceListFailed = false.

      if pPriceListReq and
         pPriceListName <= "" then
      do:
         pPriceListFailed = true.
         /* MESSAGE #6232  -  PRICE TABLE REQUIRED.  CONTINUE?       */
         /* MESSAGE #2342  -  PRICE TABLE REQUIRED BUT NOT FOUND     */
         /* MESSAGE #6233  -  DISCOUNT TABLE REQUIRED.  CONTINUE?    */
         /* MESSAGE #2857  -  REQUIRED DISCOUNT TABLE NOT FOUND      */
         if pPriceListType = {&LIST-TYPE} then
            pMessageNumber = if pWarning then 6232 else 2342.
         else if pPriceListType = {&DISCOUNT-TYPE} then
            pMessageNumber = if pWarning then 6233 else 2857.
      end. /* IF pPriceListReq AND pPriceListName <= "" */
      else
         if pPriceListName <> "" and
            not can-find (first pc_mstr where
                          pc_list = pPriceListName and
                          pc_curr = pCurrency) then
         do:
            /* WARN IF NO MATCHING PRICE/DISCOUNT TABLE */
            pPriceListFailed = true.
            /* MESSAGE #6202  -  PRICE TABLE NOT FOUND. CONTINUE?     */
            /* MESSAGE #2852  -  PRICE TABLE NOT FOUND                */
            /* MESSAGE #6203  -  DISCOUNT TABLE NOT FOUND.  CONTINUE  */
            /* MESSAGE #2681  -  DISCOUNT TABLE NOT FOUND             */
            if pPriceListType = {&LIST-TYPE} then
               pMessageNumber = if pWarning then 6202 else 2852.
            else if pPriceListType = {&DISCOUNT-TYPE} then
               pMessageNumber = if pWarning then 6203 else 2681.
         end. /* IF pPriceListName <> "" AND */
         else
         if pPriceListName > "" then
         do:
            if pPriceListType = {&LIST-TYPE} then
              /* VALIDATE THAT A PRICE LIST FOR TYPE "L" EXISTS */
              find first pc_mstr where
                 pc_list = pPriceListName and
                 pc_curr = pCurrency       and
                 pc_amt_type = "L"
                 no-lock no-error.
            else if pPriceListType = {&DISCOUNT-TYPE} then
                /* VALIDATE THAT A DISC LIST FOR TYPE "L" EXISTS */
                find first pc_mstr where
                   pc_list = pPriceListName and
                   pc_curr = pCurrency       and
                   index("DMP",pc_amt_type) <> 0
                   no-lock no-error.

            if not available pc_mstr then
            do:
               pPriceListFailed = true.
               /* MESSAGE #6228  -  PRICE LIST MUST BE TYPE L.  CONTINUE  */
               /* MESSAGE #2853  -  PRICE LIST MUST BE TYPE L             */
               /* MESSAGE #6229  -  DISCOUNT LIST MUST BE TYPE D, M OR P. */
               /*                   CONTINUE                              */
               /* MESSAGE #2682  -  DISCOUNT LIST MUST BE TYPE D, M OR P  */
               if pPriceListType = {&LIST-TYPE} then
                  pMessageNumber = if pWarning then 6228 else 2853.
               else if pPriceListType = {&DISCOUNT-TYPE} then
                  pMessageNumber = if pWarning then 6229 else 2682.
            end. /* IF NOT AVAILABLE PC_MSTR */
         end. /* IF pPriceListName >= "" */

   end. /* DO ON ERROR */
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE lookupDiscountData :
/*------------------------------------------------------------------------------
Purpose:       Looks Up for Discount Data
Exceptions:    NONE
Conditions:
        Pre:
        Post:  pt_mstr(r), pc_mstr(r)
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define input parameter        pDiscountList            as character no-undo.
   define input parameter        pPOPart                  as character no-undo.
   define input parameter        pItemQuantityInOrderedUM as decimal   no-undo.
   define input parameter        pUM                      as character no-undo.
   define input parameter        pUMConv                  as decimal   no-undo.
   define input parameter        pEffectiveDate           as date      no-undo.
   define input parameter        pCurrency                as character no-undo.
   define input parameter        pItemCostInOrderedUM     as decimal   no-undo.
   define input parameter        pItemUMMatchRequired     as logical   no-undo.
   define input parameter        pSupplierDiscount        as decimal   no-undo.
   define input-output parameter pListPrice               as decimal   no-undo.
   define input-output parameter pDiscountPercent         as decimal   no-undo.
   define input-output parameter pNetPrice                as decimal   no-undo.
   define output parameter pPriceListMasterRecid          as recid     no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {gprun.i ""gppccal.p""
               "(input        pPOPart,
                 input        pItemQuantityInOrderedUM,
                 input        pUM,
                 input        pUMConv,
                 input        pCurrency,
                 input        pDiscountList,
                 input        pEffectiveDate,
                 input        pItemCostInOrderedUM,
                 input        pItemUMMatchRequired,
                 input        pSupplierDiscount,
                 input-output pItemCostInOrderedUM,
                 output       pDiscountPercent,
                 input-output pNetPrice,
                 output       pPriceListMasterRecid)" }
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.



/*============================================================================*/
PROCEDURE lookupListPriceData :
/*------------------------------------------------------------------------------
Purpose:       Looks up for the list price
Exceptions:    NONE
Conditions:
        Pre:   None
        Post:  pt_mstr(r), pc_mstr(r)
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define input parameter        pPriceList             as character no-undo.
   define input parameter        pPOPart                as character no-undo.
   define input parameter        pUM                    as character no-undo.
   define input parameter        pUMConversion          as decimal   no-undo.
/*Y715*/  define input parameter        pSite           as character no-undo.
   define input parameter        pEffectiveDate         as date      no-undo.
   define input parameter        pCurrency              as character no-undo.
   define input parameter        newPOLine              as logical   no-undo.
   define input parameter        pPriceTableRequired    as logical   no-undo.
   define input-output parameter pListPrice             as decimal   no-undo.
   define input-output parameter pNetPrice              as decimal   no-undo.
   define output parameter       pMinimumPrice          as decimal   no-undo.
   define output parameter       pMaximumPrice          as decimal   no-undo.
   define output parameter       pPriceListMasterRecid  as recid     no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {gprun.i ""xxgppclst.p""
               "(input        pPriceList,
                 input        pPOPart,
                 input        pUM,
                 input        pUMConversion,
/*Y715*/         input        pSite,
                 input        pEffectiveDate,
                 input        pCurrency,
                 input        newPOLine,
                 input        pPriceTableRequired,
                 input-output pListPrice,
                 input-output pNetPrice,
                 output       pMinimumPrice,
                 output       pMaximumPrice,
                 output       pPriceListMasterRecid)" }
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.



/*============================================================================*/
PROCEDURE validateMinMaxRange :
/*------------------------------------------------------------------------------
Purpose:       Issue Min/Max Error/ Warning for Price Tables
Exceptions:    NONE
Conditions:
        Pre:   None
        Post:  None
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define input parameter        pWarning            as logical   no-undo.
   define input parameter        pWarningMessageFlag as logical   no-undo.
   define input parameter        pItemId             as character no-undo.
   define input parameter        pMaxPrice           as decimal   no-undo.
   define input parameter        pMinPrice           as decimal   no-undo.
   define input-output parameter pListPrice          as decimal   no-undo.
   define input-output parameter pNetPrice           as decimal   no-undo.
   define output parameter       pError              as logical   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {gprun.i ""gpmnmx.p""
               "(input        pWarning,
                 input        pWarningMessageFlag,
                 input        pMinPrice,
                 input        pMaxPrice,
                 output       pError,
                 input-output pNetPrice,
                 input-output pListPrice,
                 input        pItemId)"}
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE checkIfItemOnPOPriceList:
   /*---------------------------------------------------------------------------
   Purpose:     TO CHECK IF ITEM EXISTS IN PO PRICE LIST
   Exceptions:  NONE
   Notes:
   History:
   ---------------------------------------------------------------------------*/
   define input parameter  pItemId    as character no-undo.
   define output parameter pReference as character no-undo initial "".

   define buffer pc_mstr for pc_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      for first pc_mstr
         fields(pc_part pc_list)
         where pc_part = pItemId
         no-lock:
      end. /* for first pc_mstr */
      if available pc_mstr then
         pReference = pc_mstr.pc_list.

   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE. /* checkIfItemOnPOPriceList*/
