/* popoxr1.p - Purchase Order Line Responsible Owning Program                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.21 $                                                        */
/*                                                                            */
/* This program contains library of internal procedures. These internal       */
/* procedures contain business logic related to purchase order line, which    */
/* are called by Controllers / GUI & CHUI programs.                           */
/*                                                                            */
/* Revision: 1.1          By:Jean Miller     DATE:04/21/00    ECO: *N03T*     */
/* Revision: 1.2          BY:Poonam Bahl     DATE:05/08/00    ECO: *N059*     */
/* Revision: 1.3          By:Stefan Sepanaho DATE:08/09/00    ECO: *N0J0*     */
/* Revision: 1.4          By:Mark Brown      DATE:08/13/00    ECO: *N0KQ*     */
/* Revision: 1.5          BY:Larry Leeth     DATE:08/16/00    ECO: *N0LM*     */
/* Revision: 1.9          BY:Hualin Zhong    DATE:08/17/00    ECO: *N0LX*     */
/* Revision: 1.12         BY:Julie Milligan  DATE:08/24/00    ECO: *N0N2*     */
/* Revision: 1.13         BY:Pat Pigatti     DATE:08/31/00    ECO: *N0MT*     */
/* Revision: 1.14         BY:Stefan Sepanaho DATE:08/31/00    ECO: *N0QN*     */
/* Revision: 1.15         BY:Stefan Sepanaho DATE:09/01/00    ECO: *N0R4*     */
/* Revision: 1.16         BY:Zheng Huang     DATE:10/10/00    ECO: *N0SF*     */
/* Revision: 1.17         BY: Larry Leeth    DATE: 12/05/00   ECO: *N0V1*     */
/* Revision: 1.18         BY: Nikita Joshi   DATE: 05/04/01   ECO: *M16J*     */
/* Revision: 1.19         BY: Niranjan R.    DATE: 07/12/01   ECO: *P00L*     */
/* Revision: 1.20        BY: Nikita Joshi   DATE: 08/03/01   ECO: *M1G5*     */
/* $Revision: 1.21 $     BY: Samir Bavkar  DATE: 12/12/01   ECO: *P013*   */
/*                                                                            */
/*V8:ConvertMode=NoConvert                                                    */

/* ========================================================================== */
/* ****************************** Definitions ******************************* */
/* ========================================================================== */

/* STANDARD INCLUDE FILES */
{mfdeclre.i}
{pxmaint.i}

/* Define Handles for the programs. */
{pxphdef.i adsuxr}
{pxphdef.i aperxr}
{pxphdef.i glacxr}
{pxphdef.i gpcmxr}
{pxphdef.i gpcodxr}
{pxphdef.i gplabel}
{pxphdef.i gpsecxr}
{pxphdef.i gpumxr}
{pxphdef.i icsixr}
{pxphdef.i ieiexr1}
{pxphdef.i mcexxr}
{pxphdef.i popoxr}
{pxphdef.i ppicxr}
{pxphdef.i ppitxr}
{pxphdef.i ppplxr}
{pxphdef.i ppsuxr}
{pxphdef.i pxgblmgr}
{pxphdef.i pxtools}
{pxphdef.i rqgrsxr}
{pxphdef.i rqgrsxr1}
{pxphdef.i rqstdxr}
{pxphdef.i wowoxr}
/* End Define Handles for the programs. */


/* Some definitions required by gprunp.i can't be declared in an internal     */
/* Procedure, so they're declared here.                                       */
{gprunpdf.i "mcpl" "p"}

define temp-table ttReq_det like req_det.
define temp-table ttRqd_det like rqd_det.
define temp-table ttRqm_mstr like rqm_mstr.


/* ========================================================================== */
/* ******************************** FUNCTIONS ******************************* */
/* ========================================================================== */

/*============================================================================*/
FUNCTION isOpenLineOnClosedPO RETURNS logical
      (input pPOStatus as character,
      input pPOlineStatus as character):

/*------------------------------------------------------------------------------
Purpose:       Determines if Open line is on a closed PO
Exceptions:    None
Conditions:
Pre:           None
Post:          None
Notes:
History:       Procedure initially extracted from popomtd.p
------------------------------------------------------------------------------*/
   define variable returnData as logical initial false no-undo.

   if (pPOStatus = "c" or pPOStatus = "x")
      and (pPOlineStatus <> "c" and pPOlineStatus <> "x" ) then do:
      returnData = true.
   end.
   return (returnData).

END FUNCTION.

/*============================================================================*/
FUNCTION isSuppItemAvailable RETURNS logical
   (input pItemId            as character,
    input pSupplierId        as character,
    input pRequisitionItemId as character,
    input pRequisitionId     as character):

/*------------------------------------------------------------------------------
Purpose:       Determines if PO Line Item is a Supplier Item of Requisition
               Item and Item master exists for the given PO Line Item.
Exceptions:    None
Conditions:
        Pre:   pod_det(r), po_mstr(r)
       Post:   pt_mstr(r), vp_mstr(r)
Notes:
History:       Extracted from popomtea.p
------------------------------------------------------------------------------*/
   define variable returnData as logical no-undo.

   if can-find(pt_mstr where pt_part = pItemId) and
      can-find(first vp_mstr where vp_part = pRequisitionItemId
                             and   vp_vend = pSupplierId) and
      pRequisitionId > "" and
      pItemId <> pRequisitionItemId and
      can-find(first vp_mstr where vp_vend = pSupplierId
                             and   vp_vend_part = pItemId) then
      returnData = true.
   else
      returnData = false.

   return (returnData).

END FUNCTION.

/*============================================================================*/
FUNCTION isPOLineOpen RETURNS logical
       (input pPOId as character,
        input pPOLineId as integer):

/*------------------------------------------------------------------------------
Purpose:       Determines if PO Line Item isOpen
Exceptions:    None
Conditions:
        Pre:   pod_det(r)
       Post:   pt_mstr(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define variable returnData as logical initial false no-undo.

   if can-find(pod_det where
               pod_nbr =  pPOId     and
               pod_line = pPOLineId and
               pod_status <> "c"    and
               pod_status <> "x" )
   then
      returnData = TRUE.

   return (returnData).

END FUNCTION.


/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE calculateCostFromUMConvertedSupplierItem :

/*------------------------------------------------------------------------------
Purpose:       Calculate PO Cost when PO UM is not equal to Supplier-Item UM
Exceptions:    WARNING-RESULT, RECORD-NOT-FOUND
Conditions:
        Pre:   None
        Post:  vp_mstr(r)
Notes:
History:       Extracted from popomth.p
------------------------------------------------------------------------------*/
   define input        parameter pItemId         as character no-undo.
   define input        parameter pSupplierId     as character no-undo.
   define input        parameter pSupplierItemId as character no-undo.
   define input        parameter pPOLineUM       as character no-undo.
   define input        parameter pQtyOrdered     as decimal   no-undo.
   define input        parameter pCurrency       as character no-undo.
   define input-output parameter pPurchaseCost   as decimal   no-undo.

   define buffer vp_mstr for vp_mstr.

   /* LOCAL VARIABLES */
   define variable conversion as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* READ SUPPLIER ITEM */
      {pxrun.i &PROC='processRead' &PROGRAM='ppsuxr.p'
                &HANDLE=ph_ppsuxr
               &PARAM="(input pItemId,
                        input pSupplierId,
                        input pSupplierItemId,
                        buffer vp_mstr,
                        input {&NO_LOCK_FLAG},
                        input {&NO_WAIT_FLAG})"}

      if return-value = {&SUCCESS-RESULT} then do:
         if pQtyOrdered >= vp_q_qty and
            pPOLineUM = vp_um and
            vp_q_price > 0 and
            pCurrency = vp_curr
         then
            pPurchaseCost = vp_q_price.

         if pPOLineUM <> vp_um and
            vp_q_price > 0 and
            pCurrency = vp_curr
         then do:
            {pxrun.i &PROC='getUMConversion' &PROGRAM='gpumxr.p'
                      &HANDLE=ph_gpumxr
                     &PARAM="(input pItemId,
                              input pPOLineUM,
                              input vp_um,
                              output conversion)"}

            if return-value = {&SUCCESS-RESULT} then do:
               if pQtyOrdered / conversion >= vp_q_qty then
                  pPurchaseCost = vp_q_price / conversion.
            end.
         end. /* If  pPOLineUM <> vp_um and vp_q_price > 0 and ... */

         if pPOLineUM <> vp_um then do:
            /* MESSAGE #304 - UM NOT THE SAME AS FOR SUPPLIER ITEM */
            {pxmsg.i
               &MSGNUM=304
               &ERRORLEVEL={&WARNING-RESULT}
               &MSGARG1=vp_um
               &PAUSEAFTER=TRUE}

            return {&WARNING-RESULT}.
         end. /* IF pPOLineUM <> vp_um */
      end. /* IF RETURN-VALUE = {&SUCCESS-RESULT} */
      else if return-value = {&RECORD-NOT-FOUND} then
         return return-value.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE calculatePOCostInForeignCurr :

/*------------------------------------------------------------------------------
Purpose:       Calculates Purchase Order In PO Currency
Exceptions:    None
Conditions:
        Pre:   pod_det(r), po_mstr(r)
       Post:   None
Notes:
History:       Extracted from popomth.p
------------------------------------------------------------------------------*/
   define input parameter pGLCost            as decimal   no-undo.
   define input parameter pUMConversion      as decimal   no-undo.
   define input parameter pPOCurrency        as character no-undo.
   define input parameter pBaseExchangeRate  as decimal   no-undo.
   define input parameter pTransExchangeRate as decimal   no-undo.
   define output parameter pPurchaseCost     as decimal   no-undo.

   define variable error-number like msg_nbr no-undo.
   define variable baseCurrency like gl_base_curr no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxgetph.i pxgblmgr}
      assign
         pPurchaseCost = pGLCost * pUMConversion
         baseCurrency  =
            {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                        &HANDLE=ph_pxgblmgr
                       &PARAM='base_curr'}.

      /* CONVERT FROM BASE TO FOREIGN CURRENCY */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
          "(input baseCurrency,
           input pPOCurrency,
           input pTransExchangeRate,
           input pBaseExchangeRate,
           input pPurchaseCost,
           input false, /* DO NOT ROUND */
           output pPurchaseCost,
           output error-number)"}.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE calculatePOCurrCostFromSuppItem :

/*------------------------------------------------------------------------------
Purpose:       Obtains Purchase Cost from Supplier-Item Data
Exceptions:    RECORD-NOT-FOUND
Conditions:
        Pre:   None
        Post:  vp_mstr(r)
Notes:
History:       Extracted from popomth.p
------------------------------------------------------------------------------*/
   define input parameter pItemId             as character no-undo.
   define input parameter pSupplierId         as character no-undo.
   define input parameter pSupplierItemId     as character no-undo.
   define input parameter pItemUM             as character no-undo.
   define input parameter pUM                 as character no-undo.
   define input parameter pQtyOrdered         as decimal   no-undo.
   define input parameter pUMConversion       as decimal   no-undo.
   define input parameter pPOCurrency         as character no-undo.
   define input parameter pBaseExchangeRate   as decimal   no-undo.
   define input parameter pTransExchangeRate  as decimal   no-undo.
   define input parameter pGLCost             as decimal   no-undo.
   define output parameter pPurchaseCost      as decimal   no-undo.

   define buffer vp_mstr for vp_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /*Read Supplier Item*/
      {pxrun.i &PROC='processRead' &PROGRAM='ppsuxr.p'
                &HANDLE=ph_ppsuxr
               &PARAM="(input pItemId,
                        input pSupplierId,
                        input pSupplierItemId,
                        buffer vp_mstr,
                        input {&NO_LOCK_FLAG},
                        input {&NO_WAIT_FLAG})"}

      if return-value = {&SUCCESS-RESULT} then do:

         if pQtyOrdered >= vp_q_qty and
            pItemUM = vp_um and
            vp_q_price > 0 and
            pPOCurrency = vp_curr
         then
            pPurchaseCost = vp_q_price * pUMConversion.
         else
         if pQtyOrdered >= vp_q_qty and pItemUM <> vp_um and
            pUM = vp_um and vp_q_price > 0 and
            pPOCurrency = vp_curr
         then
            pPurchaseCost = vp_q_price.
         else do:
            /* Compute costs for foreign currency. */
            {pxrun.i &PROC='calculatePOCostInForeignCurr'
                     &PARAM="(input pGLCost,
                              input pUMConversion,
                              input pPOCurrency,
                              input pBaseExchangeRate,
                              input pTransExchangeRate,
                              output pPurchaseCost)"}

         end. /* ELSE DO */
      end. /* IF RETURN-VALUE = {&SUCCESS-RESULT} */
      else if return-value = {&RECORD-NOT-FOUND} then
         return return-value.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE calculatePOLineUMConversion :

/*------------------------------------------------------------------------------
Purpose:       Calculates Purchase Order Line Unit Of Measure Conversion factor
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  pt_mstr(r), pod_det(w),
Notes:
History:       Extracted from popomth.p
------------------------------------------------------------------------------*/
   define  parameter buffer pod_det for pod_det.

   define variable conversion     as decimal   no-undo.
   define variable dummyCharacter as character no-undo.
   define variable dummyDecimal   as decimal   no-undo.
   define variable itemUM         as character no-undo.
   define variable newPOLine      as logical   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxgetph.i pxtools}
      newPOLine = {pxfunct.i &FUNCTION='isNewRecord' &PROGRAM='pxtools.p'
                              &HANDLE=ph_pxtools
                          &PARAM="input buffer pod_det:handle"} .
      {pxrun.i &PROC='getBasicItemData' &PROGRAM='ppitxr.p'
                &HANDLE=ph_ppitxr
               &PARAM="(input pod_part,
                        output dummyCharacter,
                        output dummyCharacter,
                        output dummyDecimal,
                        output dummyCharacter,
                        output dummyCharacter,
                        output itemUM,
                        output dummyCharacter)"}
      if return-value = {&SUCCESS-RESULT} then do :
         if newPOLine then
            pod_um_conv = 1.

         if pod_um <> "" and pod_um <> itemUM then do:
            {pxrun.i &PROC='getUMConversion' &PROGRAM='gpumxr.p'
                      &HANDLE=ph_gpumxr
                      &PARAM="(input pod_part,
                               input itemUM,
                               input pod_um,
                               output conversion)"}
            if return-value = {&SUCCESS-RESULT} then do:
               if newPOLine then
                  pod_um_conv = conversion.
            end.
            else do:
                if pod_um_conv = 0 or pod_um_conv = ? then
                   pod_um_conv = 1.
            end.
         end. /* ELSE DO */
      end. /* IF RETURN-VALUE = {&SUCCESS-RESULT} */
      else do:
         if pod_um_conv = 0 or pod_um_conv = ? then
            pod_um_conv = 1.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE computeBaseCost :

/*------------------------------------------------------------------------------
Purpose:       Computes the Purchase Order Cost in Base Currency
Exceptions:    NONE
Conditions:
        Pre:
        Post:
Notes:
History:       Extracted from popomth.p
------------------------------------------------------------------------------*/
   define input parameter pItemId       as character no-undo.
   define input parameter pSiteId       as character no-undo.
   define input parameter pUMConversion as decimal no-undo.
   define input parameter pOrderDate    as date no-undo.
   define output parameter pBaseCost    as decimal no-undo.

   /* LOCAL VARIABLES */
   define variable glxcst as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='getStandardCost' &PROGRAM='ppicxr.p'
                &HANDLE=ph_ppicxr
               &PARAM="(input pItemId,
                        input pSiteId,
                        input pOrderDate,
                        output glxcst)"}

      pBaseCost = glxcst * pUMConversion.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE convertFromInventoryToPoUm :

/*------------------------------------------------------------------------------
Purpose:       This converts a decimal field represented in the Inventory UM
               to a decimal field represented in the Po UM
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r), pt_mstr(r)
       Post:
Notes:
History:
------------------------------------------------------------------------------*/
   define  input-output parameter pDecimal      as decimal no-undo.
   define  input        parameter pUmConversion as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pUmConversion <> 0 then
         pDecimal = pDecimal / pUmConversion.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE convertFromPoToInventoryUm :

/*------------------------------------------------------------------------------
Purpose:       This converts a decimal field represented in the PO UM
               to a decimal field represented in the Inventory UM
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r), pt_mstr(r)
       Post:
Notes:
History:
------------------------------------------------------------------------------*/
   define  input-output parameter pDecimal      as decimal no-undo.
   define  input        parameter pUmConversion as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pUmConversion <> 0 then
         pDecimal = pDecimal * pUmConversion.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE createIntrastatDetail :

/*------------------------------------------------------------------------------
Purpose:       Creates An Import/ Export Record for a Purchase Order  Line
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   pod_det(r)
        Post:  ie_mstr(r), ied_det(c), csid_det(r)
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define  parameter buffer pod_det for pod_det.

   define buffer ied_det for ied_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* IE_TYPE = 2 IS FOR PURCHASE ORDER'S */
      if can-find(first ie_mstr where
         ie_type = "2" and ie_nbr =  pod_nbr)
      then do:
         /* Create intrastat (import / export) record */
         {pxrun.i &PROC='processCreate' &PROGRAM='ieiexr1.p'
                   &HANDLE=ph_ieiexr1
            &PARAM="(input '2',
               input pod_det.pod_nbr,
               input pod_det.pod_line,
               buffer ied_det)"}
         /* If we cannot read the record then we cannot create */
         if return-value <> {&SUCCESS-RESULT} then
            return error return-value.

         if recid(ied_det) = -1 then .

         /* SET MODIFICATION INFORMATION - DATE AND USER IDENTIFICATION */
         {pxrun.i &PROC='setModificationInfo' &PROGRAM='ieiexr1.p'
                   &HANDLE=ph_ieiexr1
            &PARAM="(buffer ied_det)"}

      end. /* IF CAN-FIND(FIRST IE_MSTR */

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE createPurchaseOrderLine :

/*------------------------------------------------------------------------------
Purpose:       Create a Purchase Order Line , Defaults data from po_mstr,vd_mstr
Exceptions:    NONE
Conditions:
        Pre:   po_mstr(r), vd_mstr(r)
       Post:   pod_det(c),po_mstr(r), vd_mstr(r)
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define input parameter pPOOrderId as character no-undo.
   define input parameter pPOLineId  as integer   no-undo.
   define parameter buffer pod_det for pod_det.

   define buffer po_mstr for po_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='processRead' &PROGRAM='popoxr.p'
                &HANDLE=ph_popoxr
               &PARAM="(input pPOOrderId,
                        buffer po_mstr,
                        input {&NO_LOCK_FLAG},
                        input {&NO_WAIT_FLAG})"}

      if return-value = {&SUCCESS-RESULT} then do :
         {pxrun.i &PROC= 'processRead'
                  &PARAM="(input pPOOrderId,
                           input pPOLineId,
                           buffer pod_det,
                           input {&NO_LOCK_FLAG},
                           input {&NO_WAIT_FLAG})"}

         if return-value <> {&SUCCESS-RESULT} then do:
            create pod_det.
            {pxgetph.i pxgblmgr}
            assign
               pod_nbr       = pPOOrderId
               pod_line      = pPOLineId
               pod_fix_pr    = po_fix_pr
               pod_taxable   = po_taxable
               pod_pst       = po_pst
               pod_site      = po_site
               pod_tax_usage = po_tax_usage
               pod_project   = po_project
               pod_contract  = po_contract
               pod_taxc      = po_taxc
               pod_tax_env   = po_tax_env.
               pod_po_db
               = {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                             &HANDLE=ph_pxgblmgr
                            &PARAM='global_db'}.

            /* This should be moved to a BlanketPO ROP */
            assign pod_cst_up = yes.

            {pxrun.i &PROC='getPurchaseAccountData' &PROGRAM='adsuxr.p'
                      &HANDLE=ph_adsuxr
                     &PARAM="(input po_vend,
                              output pod_acct,
                              output pod_sub,
                              output pod_cc)"}

            {pxrun.i &PROC='setNewRecord' &PROGRAM='pxtools.p'
                      &HANDLE=ph_pxtools
                     &PARAM="(input buffer pod_det:handle, input TRUE)"}
         end. /* IF RETURN-VALUE <> {&SUCCESS-RESULT} */
         else do :

            /* MESSAGE #7420 - LINE ALREADY EXISTS */
            {pxmsg.i
               &MSGNUM=7420
               &ERRORLEVEL={&APP-ERROR-RESULT}}
            return error {&APP-ERROR-RESULT}.

         end. /* Else Do */
      end. /* IF RETURN-VALUE <> {&SUCCESS-RESULT} */
      else if return-value = {&RECORD-NOT-FOUND} then
         return return-value.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.


/*============================================================================*/
PROCEDURE deleteMRPDetailForPOLine :

/*------------------------------------------------------------------------------
Purpose:       Delete MRP workfile(mrp_det) record for PO Line
Exceptions:    NONE
Conditions:
        Pre:
        Post:
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPartNumber              as character no-undo.
   define input parameter pOrderNumber             as character no-undo.
   define input parameter pLineNumber              as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* DELETE MRP WORKFILE */
      {mfmrwdel.i "pod_det" pPartNumber pOrderNumber pLineNumber """"}
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE deletePurchaseOrderLine :

/*------------------------------------------------------------------------------
Purpose:       Delete a Purchase Order Line in Central and Remote DataBase
Exceptions:    NONE
Conditions:
        Pre:
        Post:
Notes:
History:       Extracted from popomth.p
------------------------------------------------------------------------------*/
   define  parameter buffer pod_det                for pod_det.
   define input parameter pPOType                  as character no-undo.
   define input parameter pPOStatus                as character no-undo.
   define input parameter pGRSInUse                as logical   no-undo.
   define input parameter pIsBlanket               as logical   no-undo.
   define input parameter pOpenRequisitionResponse as logical no-undo.

   /* LOCAL VARIABLES */
   define variable siteDB   like si_db no-undo.
   define variable old_db   like si_db no-undo.
   define variable err-flag as integer no-undo.

   /* VARIABLES REQUIRED FOR POBLADJ.I */
   define buffer poddet for pod_det.
   define variable bl_qty_chg like pod_rel_qty no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
     if pGRSInUse            and
        pod_req_nbr  >  ""   and
        pPOType      <> "b"  and
        pod_req_line <> 0 then do:
       {pxrun.i &PROC='deletePurchaseOrderLineForGRS' &PROGRAM='rqgrsxr1.p'
                 &HANDLE=ph_rqgrsxr1
                &PARAM="(input pod_req_nbr,
                         input pod_req_line,
                         input pod_site,
                         input pod_nbr,
                         input pod_line,
                         input pod_um,
                         input pOpenRequisitionResponse)"}
     end. /* IF pGRSInUse AND .. */

     {pxrun.i &PROC='getSiteDataBase' &PROGRAM='icsixr.p'
              &HANDLE=ph_icsixr
             &PARAM="(input pod_site,output siteDB)"}

     if siteDB <> global_db then do:

       old_db = global_db.

       /* Delete the line in the remote database */
       {gprun.i ""gpalias3.p"" "(siteDB, output err-flag)" }

       /* Popoxf2.p is a facade for popomta2.p */
       {gprun.i ""popoxf2.p"" "(pod_nbr, pod_line, pIsBlanket)"}

       {gprun.i ""gpalias3.p"" "(old_db, output err-flag)" }

       /* Adjust Blanket PO in Header/Central DB */
       if pPOStatus <> "c" and pPOStatus <> "x"
          and pod_status <> "c" and pod_status <> "x"
          and not pIsBlanket
       then do:
          {pobladj.i}
       end. /* IF pPOStatus <> "c" AND pPOStatus <> "x" ... */

       /* Delete the local database line data */
       {pxrun.i &PROC='deleteAllTransactionComments' &PROGRAM='gpcmxr.p'
                 &HANDLE=ph_gpcmxr
                &PARAM="(input pod_cmtindx)"}

       delete pod_det.
     end. /* IF siteDB <> GLOBAL_DB */
     else do:
       /* DELETE PURCHASE ORDER IN CENTRAL DB */
       /* Popoxf2.p is a facade for popomta2.p */
       {gprun.i ""popoxf2.p"" "(pod_nbr, pod_line, pIsBlanket)"}
     end. /* ELSE DO */
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE initializeBlanketPOLine :
/*------------------------------------------------------------------------------
<Comment1>
popoxr1.p
initializeBlanketPOLine (
   input logical pBlanket,
   Buffer pod_det)

Parameters:
   pBlanket - Flag indicating if Blanket PO
   pod_det  - Buffer for the Blanket PO Line

Exceptions: NONE

PreConditions: pod_det(c)

PostConditions: pod_det(w)

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pBlanket as logical no-undo.
   define parameter buffer pod_det for pod_det.

   define buffer po_mstr for po_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pBlanket then do:
         {pxrun.i &PROC='processRead' &PROGRAM='popoxr.p'
                   &HANDLE=ph_popoxr
                  &PARAM="(input pod_nbr,
                           buffer po_mstr,
                           input {&NO_LOCK_FLAG},
                           input {&NO_WAIT_FLAG})"}

         if return-value = {&SUCCESS-RESULT} then
            assign
               pod_type    = "B"
               pod_blanket = po_blanket.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE getAccountFieldsForLine :

/*------------------------------------------------------------------------------
Purpose:       Defaults PO Line Account from Product Line master and also
               defaults other PO Line details from Item master.
Exceptions:    NONE
Conditions:
        Pre:   po_mstr(r), pod_det(r)
       Post:   None
Notes:
History:       Extracted from popomtea.p
------------------------------------------------------------------------------*/
   define input  parameter pEffectiveDate        as date no-undo.
   define input  parameter pItem                 as character no-undo.
   define input  parameter pSiteId               as character no-undo.
   define input  parameter pInspectionLocationId as character no-undo.
   define input  parameter pSupplierType   as character no-undo.
   define output parameter pStandardCost         as decimal no-undo.
   define output parameter pRevision             as character no-undo.
   define output parameter pLocationId           as character no-undo.
   define output parameter pInspectionRequired   as logical no-undo.
   define output parameter pPurchaseAccount      as character no-undo.
   define output parameter pPurchaseSubAccount   as character no-undo.
   define output parameter pPurchaseCostCenter   as character no-undo.
   define output parameter pItemType             as character no-undo.

   define variable acct like pod_acct no-undo.
   define variable sub  like pod_sub no-undo.
   define variable cc   like pod_cc no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* SET REV, LOC, INSPECTN RQD, ACCT, SUB, CC */

      /* Added supplier type as fourth input parameter */
      {pxrun.i &PROC='getRemoteItemData'
               &PARAM="(input pEffectiveDate,
                        input pItem,
                        input pSiteId,
                        input pSupplierType,
                        output pStandardCost,
                        output pRevision,
                        output pLocationId,
                        output pInspectionRequired,
                        output acct,
                        output sub,
                        output cc,
                        output pItemType)"}

      if acct > "" then do:
         assign
           pPurchaseAccount    = acct
           pPurchaseSubAccount = sub
           pPurchaseCostCenter = cc.
      end.

      if pInspectionRequired then
         pLocationId = pInspectionLocationId.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getCostAndDiscount :
/*------------------------------------------------------------------------------
  Purpose:     Gets the Default PO Line Cost and Discount Percent.
  Exceptions:  None
  Notes:
  History:
------------------------------------------------------------------------------*/
   define parameter buffer pod_det          for pod_det.
   define output parameter pUnitCost        as decimal   no-undo.
   define output parameter pDiscountPercent as decimal   no-undo.

   define variable errorCode          as integer   no-undo.
   define variable exchangeRate1      as decimal   no-undo.
   define variable exchangeRate2      as decimal   no-undo.
   define variable baseCurrency       as character no-undo.
   define variable priceCameFromReq   as logical   no-undo.
   define variable glxcst             as decimal   no-undo.
   define variable priceTableRequired as logical   no-undo.
   define variable listPrice          as decimal   no-undo.
   define variable lineEffDate        as date      no-undo.
   define variable minPrice           as decimal   no-undo.
   define variable maxPrice           as decimal   no-undo.
   define variable pc_recno           as recid     no-undo.
   define variable quantityOrdered    as decimal   no-undo.
   define variable ctr                as integer   no-undo.
   define variable dummyCost          as decimal   no-undo.
   define variable warnmess           as logical   no-undo.
   define variable warning            as logical   no-undo.
   define variable minmaxerror        as logical   no-undo.
   define variable netPrice           as decimal   no-undo.
   define variable netCost            as decimal   no-undo.
   define variable failed             as logical   no-undo.
   define variable returnValue        as character no-undo.
   define variable poDB               as character no-undo.
   define variable siteDB             as character no-undo.
   define variable usingGRS           as logical   no-undo.

   define buffer poc_ctrl for poc_ctrl.
   define buffer po_mstr  for po_mstr.
   define buffer pt_mstr  for pt_mstr.
   define buffer vp_mstr  for vp_mstr.
   define buffer pc_mstr  for pc_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxgetph.i pxgblmgr}
      baseCurrency = {pxfunct.i &FUNCTION='getCharacterValue'
                                &PROGRAM='pxgblmgr.p'
                                 &HANDLE=ph_pxgblmgr
                                &PARAM="input 'base_curr'"}.

      {pxrun.i &PROC='readPOControl' &PROGRAM ='popoxr.p'
                &HANDLE=ph_popoxr
               &PARAM="(buffer poc_ctrl)"}

      {pxrun.i &PROC ='processRead' &PROGRAM='popoxr.p'
                &HANDLE=ph_popoxr
               &PARAM="(input  pod_nbr,
                        buffer po_mstr,
                        input  {&NO_LOCK_FLAG},
                        input  {&NO_WAIT_FLAG})"}
      {pxgetph.i rqgrsxr}
      assign
         pDiscountPercent = po_disc_pct
         usingGRS  = {pxfunct.i &FUNCTION='isGRSInUse' &PROGRAM='rqgrsxr.p'
                                 &HANDLE=ph_rqgrsxr}

      returnValue = {&SUCCESS-RESULT}.

      {pxrun.i &PROC='validatePriceList' &PROGRAM='popoxr.p'
                &HANDLE=ph_popoxr
           &PARAM="(input po_mstr.po_pr_list2,
                        input po_mstr.po_curr)"}

      returnValue = return-value.

      {pxrun.i &PROC='validateDiscountList' &PROGRAM='popoxr.p'
                &HANDLE=ph_popoxr
           &PARAM="(input po_mstr.po_pr_list,
                        input po_mstr.po_curr)"}


      if return-value = {&APP-ERROR-RESULT}
      or returnValue = {&APP-ERROR-RESULT}
      then return {&APP-ERROR-RESULT}.


      {pxrun.i &PROC='calculatePOLineUMConversion'
               &PARAM="(buffer pod_det)"}

      if usingGRS and pod_req_nbr <> ""
      then do:
         {pxgetph.i pxgblmgr}
         poDB = {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                            &HANDLE=ph_pxgblmgr
                           &PARAM="input 'global_db'"}.

         /* GET SITE DB */
         {pxrun.i &PROC='getSiteDataBase' &PROGRAM='icsixr.p'
              &HANDLE=ph_icsixr
            &PARAM="(input pod_det.pod_site, output siteDB)"}

         if siteDB <> poDB then do:
            {gprun.i ""gpalias3.p"" "(siteDB, output errorCode)"}
         end.

         {pxrun.i &PROC='processReadReturnTempTable' &PROGRAM='rqgrsxr.p'
                  &PARAM="(input pod_req_nbr,
                           buffer ttRqm_mstr,
                           input {&NO_LOCK_FLAG},
                           input {&NO_WAIT_FLAG})"}

         if return-value = {&SUCCESS-RESULT} then do:
            {pxrun.i &PROC='processReadReturnTempTable' &PROGRAM='rqgrsxr1.p'
                     &PARAM="(input pod_req_nbr,
                              input pod_req_line,
                              buffer ttRqd_det,
                              input {&NO_LOCK_FLAG},
                              input {&NO_WAIT_FLAG})"}

            if return-value = {&SUCCESS-RESULT} then do:
               {gprun.i 'rqexrt.p'
                  "(input ttRqm_mstr.rqm_curr,
                    input po_curr,
                    input ttRqm_mstr.rqm_ex_ratetype,
                    output exchangeRate1,
                    output exchangeRate2,
                    output errorCode)"}

               pUnitCost =  ttRqd_det.rqd_pur_cost.

               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ttRqm_mstr.rqm_curr,
                    input po_curr,
                    input exchangeRate1,
                    input exchangeRate2,
                    input pUnitCost,
                    input false,
                    output pUnitCost,
                    output errorCode)"}
            end.
         end.

         if poDB <> siteDB then do:
            {gprun.i ""gpalias3.p"" "(poDB, output errorCode)"}
         end.

      end. /* If usingGRS then */

      priceCameFromReq = usingGRS and pUnitCost <> 0.

      {pxrun.i &PROC ='processRead' &PROGRAM='ppitxr.p'
                &HANDLE=ph_ppitxr
               &PARAM="(input pod_part,
                        buffer pt_mstr,
                        input {&NO_LOCK_FLAG},
                        input {&NO_WAIT_FLAG})"}

      if return-value = {&RECORD-NOT-FOUND} then do:
         if not usingGRS and pod_req_nbr <> "" then do:
            {pxgetph.i pxgblmgr}
            poDB =
               {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                           &HANDLE=ph_pxgblmgr
                           &PARAM="input 'global_db'"}.

            /* GET SITE DB */
            {pxrun.i &PROC='getSiteDataBase' &PROGRAM='icsixr.p'
               &HANDLE=ph_icsixr
               &PARAM="(input pod_det.pod_site, output siteDB)"}

            if siteDB <> poDB then do:
               {gprun.i ""gpalias3.p"" "(siteDB, output errorCode)"}
            end.

            {pxrun.i &PROC='processReadReturnTempTable' &PROGRAM='rqstdxr.p'
                     &PARAM="(input pod_req_nbr,
                              buffer ttReq_det,
                              input {&NO_LOCK_FLAG},
                              input {&NO_WAIT_FLAG})"}

            if return-value = {&SUCCESS-RESULT} then do:
               if po_curr = baseCurrency then
                  pUnitCost = ttReq_det.req_pur_cost.
            end.

            if poDB <> siteDB then do:
               {gprun.i ""gpalias3.p"" "(poDB, output errorCode)"}
            end.

         end.
      end.
      else if return-value = {&SUCCESS-RESULT} then do:
         if not priceCameFromReq then do:
            {pxrun.i &PROC='getStandardCost' &PROGRAM='ppicxr.p'
                      &HANDLE=ph_ppicxr
                     &PARAM="(input pod_part,
                              input pod_site,
                              input po_ord_date,
                              output glxcst)"}

            {pxrun.i &PROC='processRead' &PROGRAM='ppsuxr.p'
                      &HANDLE=ph_ppsuxr
                     &PARAM="(input pod_part,
                              input po_vend,
                              input pod_vpart,
                              buffer vp_mstr,
                              input {&NO_LOCK_FLAG},
                              input {&NO_WAIT_FLAG})"}

            if return-value = {&RECORD-NOT-FOUND} then do:
               {pxrun.i &PROC='calculatePOCostInForeignCurr'
                        &PARAM="(input glxcst,
                                 input pod_um_conv,
                                 input po_curr,
                                 input po_ex_rate,
                                 input po_ex_rate2,
                                 output pUnitCost)"}
            end.
            else if return-value = {&SUCCESS-RESULT} then do:
               {pxrun.i &PROC='calculatePOCurrCostFromSuppItem'
                        &PARAM="(input pod_part,
                                 input po_vend,
                                 input pod_vpart,
                                 input pt_um,
                                 input pod_um,
                                 input pod_qty_ord,
                                 input pod_um_conv,
                                 input po_curr,
                                 input po_ex_rate,
                                 input po_ex_rate2,
                                 input glxcst,
                                 output pUnitCost)"}
            end.
         end. /* If not priceCameFromReq then */
      end.

      if not priceCameFromReq then do:
         {pxrun.i &PROC='calculateCostFromUMConvertedSupplierItem'
                  &PARAM="(input pod_part,
                           input po_vend,
                           input pod_vpart,
                           input pod_um,
                           input pod_qty_ord,
                           input po_curr,
                           input-output pUnitCost)"}
      end. /* If not priceCameFromReq then */

      pod__qad09 = pUnitCost * (1 - (pDiscountPercent / 100)).
      pod__qad02 = (pUnitCost * (1 - (pDiscountPercent / 100))
                                      - pod__qad09) * 100000.

      {pxrun.i &PROC='getPOLinePricingEffectiveDate'
               &PARAM="(input poc_pc_line,
                        input po_ord_date,
                        input pod_due_date,
                        output lineEffDate)"}

      {pxrun.i &PROC='getPriceListRequired' &PROGRAM='popoxr.p'
                &HANDLE=ph_popoxr
               &PARAM="(output priceTableRequired)"}


      if po_pr_list2 <> "" then do:
         listPrice = ?.

         {pxrun.i &PROC='lookupListPriceData' &PROGRAM='ppplxr.p'
                   &HANDLE=ph_ppplxr
                  &PARAM="(input po_pr_list2,
                           input pod_part,
                           input pod_um,
                           input pod_um_conv,
                           input lineEffDate,
                           input po_curr,
                           input true,
                           input priceTableRequired,
                           input-output pUnitCost,
                           input-output listPrice,
                           output minPrice,
                           output maxPrice,
                           output pc_recno)"}

         if listPrice <> ? then
            /* Apply the line discount to the PLTL price */
            listPrice = listPrice * (1 - pDiscountPercent / 100).
         else
            /* Calculate the Net Price from the PO line info */
            listPrice = pUnitCost * (1 - pDiscountPercent / 100).
      end.

      if priceTableRequired and
         (po_pr_list2 = "" or pc_recno = 0) then do:
         /* MESSAGE #6231 - REQUIRED PRICE TABLE FOR ITEM # IN */
         /*                 UM # NOT FOUND                     */
         {pxmsg.i
            &MSGNUM=6231
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &MSGARG1=pod_part
            &MSGARG2=pod_um
            &PAUSEAFTER=TRUE}

         return error {&APP-ERROR-RESULT}.
      end. /* If priceTableRequired and ... */

      if po_pr_list <> "" then do:
         assign
            quantityOrdered = pod_qty_ord
            dummyCost = listPrice.

         {pxrun.i &PROC='lookupDiscountData' &PROGRAM='ppplxr.p'
                   &HANDLE=ph_ppplxr
                  &PARAM="(input po_pr_list,
                           input pod_part,
                           input quantityOrdered,
                           input pod_um,
                           input pod_um_conv,
                           input lineEffDate,
                           input po_curr,
                           input pUnitCost,
                           input poc_pl_req,
                           input pDiscountPercent,
                           input-output pUnitCost,
                           input-output pDiscountPercent,
                           input-output listPrice,
                           output pc_recno)"}

         /* BACK OUT DISCOUNT APPLIED IF QTY IS BELOW DISCOUNT */
         /* TABLE QUANTITY (TYPE P) RANGE                      */
         find pc_mstr where recid(pc_mstr) = pc_recno no-lock no-error.

         if available pc_mstr and
            pc_amt_type  = "p" and
            pUnitCost <> 0 and
            listPrice <> pUnitCost
         then do:
            /* CONVERT TO STOCK UM IF WE DON'T HAVE A UM MATCH */
            if pc_um <> pod_um then
               quantityOrdered = quantityOrdered * pod_um_conv.

            do ctr = 1 to 15:
               if pc_min_qty[ctr] > quantityOrdered or
                  (pc_min_qty[ctr] = 0 and
                   pc_amt[ctr] = 0)
               then
                  leave.
            end.

            ctr = ctr - 1.

            if ctr <= 0 then
               assign
                  listPrice = dummyCost
                  pDiscountPercent = po_disc_pct.
         end.
      end.

      if poc_pl_req and
         (po_pr_list = "" or pc_recno = 0) then do:

         /* MESSAGE #982 - REQUIRED DISCOUNT TABLE FOR */
         /*                ITEM # IN UM # NOT FOUND    */
         {pxmsg.i
            &MSGNUM=982
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &MSGARG1=pod_part
            &MSGARG2=pod_um
            &PAUSEAFTER=TRUE}

         return error {&APP-ERROR-RESULT}.
      end. /* If poc_pl_req */

      assign
         pod__qad09 = listPrice
         pod__qad02 = (listPrice - pod__qad09) * 100000.

      /* PRICE TABLE MIN/MAX WARNING FOR  DISCOUNT TABLES. PLUG PRICES */
      if po_pr_list2 <> "" then do:

         assign
            warnmess = yes
            netPrice = pUnitCost * (1 - pDiscountPercent / 100)
            netCost  = netPrice
            warning  = yes.

         {pxrun.i &PROC='validateMinMaxRange' &PROGRAM='ppplxr.p'
                   &HANDLE=ph_ppplxr
                  &PARAM="(input warning,
                           input warnmess,
                           input pod_part,
                           input maxPrice,
                           input minPrice,
                           input-output listPrice,
                           input-output netPrice,
                           output minmaxerror)"}

         /* IF NET COST IS BELOW MIN/MAX RANGE THEN RECALCULATE */
         /* DISCOUNT SO THAT NET COST IS THE MIN/MAX VALUE      */
         if netPrice <> netCost then
            pDiscountPercent = (1 - (netPrice / pUnitCost) ) * 100.
      end.
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT} */

   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE getExtendedCost :
/*------------------------------------------------------------------------------
  Purpose:     Gets the Net Unit Cost, Extended Cost & Base Unit Cost.
  Exceptions:  None
  Notes:
  History:
------------------------------------------------------------------------------*/
   define parameter buffer pod_det           for pod_det.
   define output parameter pUnitCostBase     as decimal   no-undo.
   define output parameter pUnitCostExtended as decimal   no-undo.
   define output parameter pNetUnitCost      as decimal   no-undo.

   define variable roundingMethod as character no-undo.
   define variable baseCurrency   as character no-undo.
   define variable errorCode      as integer   no-undo.

   define buffer po_mstr  for po_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxgetph.i pxgblmgr}
      baseCurrency = {pxfunct.i &FUNCTION='getCharacterValue'
                                &PROGRAM='pxgblmgr.p'
                                 &HANDLE=ph_pxgblmgr
                                &PARAM="input 'base_curr'"}.

      {pxrun.i &PROC='getNetUnitCost'
               &PARAM="(buffer pod_det,
                        output pNetUnitCost)"}

      {pxrun.i &PROC='processRead' &PROGRAM='popoxr.p'
                &HANDLE=ph_popoxr
               &PARAM="(input pod_nbr,
                        buffer po_mstr,
                        input {&NO_LOCK_FLAG},
                        input {&NO_WAIT_FLAG})"}

      {pxrun.i &PROC='getRoundingMethod' &PROGRAM='mcexxr.p'
                &HANDLE=ph_mcexxr
               &PARAM="(input po_curr,
                        output roundingMethod)"}

      {pxrun.i &PROC='getPOLineExtendedCost'
               &PARAM="(input pod_nbr,
                        input pod_line,
                        input roundingMethod,
                        output pUnitCostExtended)"}

      if po_curr = baseCurrency then
         pUnitCostBase = pod_pur_cost.
      else do:
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input po_curr,
              input baseCurrency,
              input po_ex_rate,
              input po_ex_rate2,
              input pod_pur_cost,
              input false,
              output pUnitCostBase,
              output errorCode)"}
      end.
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT} */

   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE getFirstPOLine :

/*---------------------------------------------------------------------------
  Purpose:        Return the first PO Line
  Exceptions:     RECORD-NOT-FOUND
  Dependencies:
     Input-      po_mstr(r)
     Output-     pod_det(r)
  Notes:
  History:
---------------------------------------------------------------------------*/
   define input parameter  pPOId as character no-undo.
   define       parameter  buffer pod_det for pod_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      find first pod_det
         where pod_nbr = pPOId
         use-index pod_nbrln
         no-lock no-error.
      if not available pod_det then
         return {&RECORD-NOT-FOUND}.

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getInspectionLocation :

/*------------------------------------------------------------------------------
Purpose:       Gets Inspection Location for the Purchase Order Line
Exceptions:    NONE
Conditions:
        Pre:   None
        Post:  poc_ctrl(r),
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define output parameter pLocationId as character no-undo.

   define buffer poc_ctrl for poc_ctrl.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='readPOControl' &PROGRAM='popoxr.p'
                &HANDLE=ph_popoxr
               &PARAM="(buffer poc_ctrl)"}

      pLocationId = poc_insp_loc.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getItemAndPriceOfLastQuote :

/*------------------------------------------------------------------------------
Purpose:       Gets Supplier Item and Supplier Quote Price from Supplier Item
               master.
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r), po_mstr(r)
       Post:   vp_mstr(r)
Notes:         The data is selected from Supplier Item master for the given
               Item, Supplier and for latest Quote Date.
History:       Extracted from popomtea.p
------------------------------------------------------------------------------*/
   define input  parameter pItemId          as character no-undo.
   define input  parameter pQuantityOrdered as decimal no-undo.
   define input  parameter pUnitOfMeasure   as character no-undo.
   define input  parameter pSupplierId      as character no-undo.
   define input  parameter pCurrency        as character no-undo.
   define input  parameter pLineCost        as decimal no-undo.
   define output parameter pSupplierItemId  as character no-undo.
   define output parameter pUnitCost        as decimal no-undo.

   define buffer vp_mstr for vp_mstr.

   define variable umConversion as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      pUnitCost = pLineCost.

      for each vp_mstr
         fields (vp_part vp_vend vp_q_date vp_q_qty vp_um
                 vp_curr vp_q_price vp_vend_part)
         where vp_part = pItemId
         and   vp_vend = pSupplierId
         no-lock
         break by vp_q_date descending:

         if first(vp_q_date) then do:
            if pQuantityOrdered >= vp_q_qty and
               pUnitOfMeasure = vp_um and
               vp_q_price > 0 and
               pCurrency = vp_curr then
               pUnitCost = vp_q_price.

            pSupplierItemId = vp_vend_part.

            if PUnitOfMeasure <> "" and pUnitOfMeasure <> vp_um then do:
               {pxrun.i &PROC='getUMConversion' &PROGRAM='gpumxr.p'
                         &HANDLE=ph_gpumxr
                          &PARAM="(input pItemId,
                                   input pUnitOfMeasure,
                                   input vp_um,
                                   output umConversion)"}

               if return-value = {&SUCCESS-RESULT} then do:
                  if pQuantityOrdered / umConversion >= vp_q_qty and
                     pCurrency = vp_curr then
                     pUnitCost = vp_q_price / umConversion.
               end. /* If return-value = SUCCESS-RESULT */
               else if return-value = {&WARNING-RESULT} then
                  return return-value.

            end. /* IF pUnitOfMeasure <> VP_UM */

            leave.
         end. /* IF FIRST VP_MSTR */
      end. /* FOR EACH VP_MSTR */
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getLastPOLine :

/*---------------------------------------------------------------------------
  Purpose:        Return the last PO Line
  Exceptions:     RECORD-NOT-FOUND
  Dependencies:
     Input-      pod_det(r)
     Output-     pod_det(r)
  Notes:
  History:
---------------------------------------------------------------------------*/
   define input parameter  pPOId as character no-undo.
   define output parameter pLine as integer no-undo.

   define buffer pod_det for pod_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      find last pod_det
         where pod_nbr = pPOId
         use-index pod_nbrln
         no-lock no-error.
      if available pod_det then
         pLine = pod_line.
      else
         return {&RECORD-NOT-FOUND}.

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getNetUnitCost :

/*------------------------------------------------------------------------------
Purpose:       Calculates Net Unit Cost for the Purchase Order Line
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  pod_det(r)
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define parameter buffer poddet       for pod_det.
   define output parameter pNetUnitCost as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if  ((pod__qad02 = 0 or pod__qad02 = ?)
      and  (pod__qad09 = 0 or pod__qad09 = ?))
      then
         pNetUnitCost = pod_pur_cost *  (1 - (pod_disc_pct / 100)).
      else
         pNetUnitCost = pod__qad09 + pod__qad02 / 100000.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getNextPurchaseOrderLineId :

/*------------------------------------------------------------------------------
Purpose:       On Create, if a new line Id needs to be generated, this method
               will get the next number.
Exceptions:    NONE
Conditions:
        Pre:   pod_det(c)
       Post:
Notes:
History:
------------------------------------------------------------------------------*/
   define  input  parameter pPurchaseOrderId     as character no-undo.
   define  output parameter pPurchaseOrderLineId as integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC = 'getLastPOLine'
               &PARAM = "(input pPurchaseOrderId,
                          output pPurchaseOrderLineId)"}

      pPurchaseOrderLineId = pPurchaseOrderLineId + 1.

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getPOItemDefaults :

/*------------------------------------------------------------------------------
Purpose:       Obtain default values from Item if available,
Exceptions:    NONE
Conditions:
        Pre:   None
        Post:  None
Notes:
History:       Extracted from popomtr1.p
------------------------------------------------------------------------------*/
   define input parameter pItemId              as character no-undo.
   define input parameter pSiteId              as character no-undo.
   define output parameter pDescription1       as character no-undo.
   define output parameter pDescription2       as character no-undo.
   define output parameter pItemUM             as character no-undo.
   define output parameter pRevision           as character no-undo.
   define output parameter pLocation           as character no-undo.
   define output parameter pInspectionRequired as logical no-undo.
   define output parameter pPOLineTaxable      as logical no-undo.
   define output parameter pPOLineTaxClass     as character no-undo.

   define variable dummyCharacter as character no-undo.
   define buffer pt_mstr for pt_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /*GET TAX INDICATORS*/
      {pxrun.i &PROC='processRead' &PROGRAM='ppitxr.p'
                &HANDLE=ph_ppitxr
         &PARAM="(input pItemId,
                  buffer pt_mstr,
                  input {&NO_LOCK_FLAG},
                  input {&NO_WAIT_FLAG})"}

      if return-value <> {&SUCCESS-RESULT} then
         return return-value.

      assign
         pPOLineTaxClass = pt_taxc
         pPOLineTaxable  = pt_taxable
         pDescription1   = pt_desc1
         pDescription2   = pt_desc2
         pItemUM         = pt_um.

      /*GET REV, LOC, INSP RQD*/
      /* Added supplier type as third input parameter */
      {gprun.i ""popomte1.p""
         "(input  pItemId,
           input  pSiteId,
           input  """",
           output pRevision,
           output pLocation,
           output pInspectionRequired,
           output dummyCharacter,
           output dummyCharacter,
           output dummyCharacter,
           output dummyCharacter)"}

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getPOLineExtendedCost :

/*------------------------------------------------------------------------------
Purpose:       Obtains The Extended Cost for Purchase Order Line
Exceptions:    RECORD-NOT-FOUND
Conditions:
        Pre:   pod_det(r)
        Post:
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define input  parameter pPurchaseOrderId as character no-undo.
   define input  parameter pPOLineId        as integer   no-undo.
   define input  parameter pRoundingMethod  as character no-undo.
   define output parameter pExtendedCost    as decimal   no-undo.

   define buffer pod_det for pod_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC= 'processRead'
               &PARAM="(input pPurchaseOrderId,
                        input pPOLineId,
                        buffer pod_det,
                        input {&NO_LOCK_FLAG},
                        input {&NO_WAIT_FLAG})"}

      if return-value = {&SUCCESS-RESULT} then do:

         if ((pod__qad02 = 0 or pod__qad02 = ?) and
            (pod__qad09 = 0 or pod__qad09 = ?))
         then
            pExtendedCost = pod_qty_ord * pod_pur_cost *
                                          (1 - (pod_disc_pct / 100)).
         else
            pExtendedCost = pod_qty_ord * (pod__qad09 + pod__qad02 / 100000).

         {gprun.i ""gpcurrnd.p""
            "(input-output pExtendedCost,
              input pRoundingMethod)"}
      end.
      else
         if return-value = {&RECORD-NOT-FOUND} then
            return return-value.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getPOLinePricingEffectiveDate :

/*------------------------------------------------------------------------------
Purpose:       Gets Line Pricing Effective Date from Order or Due Date
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define input parameter  pPriceByPOLineDueDate as logical no-undo.
   define input parameter  pPOOrderDate          as date    no-undo.
   define input parameter  pPODueDate            as date    no-undo.
   define output parameter pPOLinePricingEffDate as date    no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pPriceByPOLineDueDate then do:
         pPOLinePricingEffDate = pPODueDate.
         if pPOLinePricingEffDate = ? then
            pPOLinePricingEffDate = today.
      end.
      else
          pPOLinePricingEffDate = pPOOrderDate.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getPOLineToReqDifferences :

/*------------------------------------------------------------------------------
Purpose:       Gets the base percent and base cost differences between the
               PO Line and the Requisition Line
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:
Notes:
History:       Only used in JAVA UI
------------------------------------------------------------------------------*/
   define parameter buffer pod_det for pod_det.
   define input parameter  pNetPurchaseCostBase as decimal no-undo.
   define output parameter pBaseCostDifference as decimal no-undo.
   define output parameter pBasePercentDifference as decimal no-undo.

   define variable baseCurrency                 as character no-undo.
   define variable errorCode                    as integer   no-undo.
   define variable mc-error-number              as integer   no-undo.
   define variable poDB                         as character no-undo.
   define variable reqNetPurchaseCostBase       as decimal   no-undo.
   define variable siteDB                       as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      assign
         pBaseCostDifference   = 0
         pBasePercentDifference = 0.
      {pxgetph.i pxgblmgr}
      poDB = {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                         &HANDLE=ph_pxgblmgr
                           &PARAM="input 'global_db'"}.

      /* GET SITE DB */
      {pxrun.i &PROC='getSiteDataBase' &PROGRAM='icsixr.p'
               &HANDLE=ph_icsixr
         &PARAM="(input pod_det.pod_site, output siteDB)"}

      if siteDB <> poDB then do:
         {gprun.i ""gpalias3.p"" "(siteDB, output errorCode)"}
      end.

      {pxrun.i &PROC='processReadReturnTempTable' &PROGRAM='rqgrsxr1.p'
          &PARAM = "(input pod_req_nbr,
                     input pod_req_line,
                     buffer ttRqd_det,
                     input {&NO_LOCK_FLAG},
                     input {&NO_WAIT_FLAG})"
          &NOAPPERROR=True}

      if return-value <> {&SUCCESS-RESULT} then do:
         if poDB <> siteDB then do:
            {gprun.i ""gpalias3.p"" "(poDB, output errorCode)"}
         end.
         return {&SUCCESS-RESULT}.
      end.

      {pxrun.i &PROC='processReadReturnTempTable' &PROGRAM='rqgrsxr.p'
                &HANDLE=ph_rqgrsxr
          &PARAM = "(input pod_req_nbr,
                     buffer ttRqm_mstr,
                     input {&NO_LOCK_FLAG},
                     input {&NO_WAIT_FLAG})"
          &NOAPPERROR=True}

      if return-value <> {&SUCCESS-RESULT} then do:
         if poDB <> siteDB then do:
            {gprun.i ""gpalias3.p"" "(poDB, output errorCode)"}
         end.
         return {&SUCCESS-RESULT}.
      end.

      if poDB <> siteDB then do:
         {gprun.i ""gpalias3.p"" "(poDB, output errorCode)"}
      end.

      /* GET BASE CURRENCY FROM GLOBAL MANAGER */
      {pxgetph.i pxgblmgr}
      baseCurrency = {pxfunct.i &FUNCTION='getCharacterValue'
                                &PROGRAM='pxgblmgr.p'
                                 &HANDLE=ph_pxgblmgr
                                &PARAM="input 'base_curr'"}.

       {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ttRqm_mstr.rqm_curr,
              input baseCurrency,
              input ttRqm_mstr.rqm_ex_rate,
              input ttRqm_mstr.rqm_ex_rate2,
              input ttRqd_det.rqd_pur_cost,
              input false,     /*  NO ROUNDING */
              output reqNetPurchaseCostBase,
              output mc-error-number)"}

       assign
          pBaseCostDifference = pNetPurchaseCostBase - reqNetPurchaseCostBase
          pBasePercentDifference =
                (pBaseCostDifference / reqNetPurchaseCostBase) * 100.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.


/*============================================================================*/
PROCEDURE getPOLineTypeAndTaxFlag :
/*------------------------------------------------------------------------------
Purpose:       Sets PO Line Type to Memo and defaults PO Line Taxable flag from
               PO header for PO Line Item without Item master.
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   pod_det(r), po_mstr(r)
       Post:   pt_mstr(r)
Notes:
History:       Extracted from popomtea.p
------------------------------------------------------------------------------*/
   define input        parameter pItemId        as character no-undo.
   define input        parameter pItemType      as character no-undo.
   define input        parameter pPOTaxable     as logical no-undo.
   define input-output parameter pPOLineType    as character no-undo.
   define input-output parameter pPOLineTaxable as logical no-undo.

   define buffer pt_mstr for pt_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      if (not can-find(pt_mstr where pt_part = pItemId) and
         pPOLineType = "") or
         (pItemType = "M" and pPOLineType = "") then do:
         assign
            pPOLineTaxable = pPOTaxable
            pPOLineType    = "M".

         if pItemType = "M" then do:
            /* MESSAGE #42 - ITEM NUMBER DOES NOT EXIST FOR THIS SITE */
            {pxmsg.i
               &MSGNUM=42
               &ERRORLEVEL={&WARNING-RESULT}}
         end. /* IF pItemType = "M" */

         /* MESSAGE #25 - TYPE SET TO (M)EMO */
         {pxmsg.i
            &MSGNUM=25
            &ERRORLEVEL={&WARNING-RESULT}}
         return {&WARNING-RESULT}.
      end. /* IF (NOT CAN-FIND... */
      else do:
         for first pt_mstr no-lock
            where pt_part = pItemId:
            if available pt_mstr then
               pPOLineTaxable = pt_taxable and pPOTaxable.
         end. /* FOR FIRST pt_mstr NO-LOCK */
      end. /* ELSE DO */
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getPORemoteDataBase:

/*---------------------------------------------------------------------------
  Purpose:     Get the PO database name and determine if the PO database
               is the same as the default database.
  Exceptions:  NONE
  Dependencies:
       Input-      pod_det(r)
       Output-     pod_det(r)
  Notes:
  History:
---------------------------------------------------------------------------*/
   define input parameter pPONbr as character no-undo.
   define output parameter pIsOnRemoteDatabase as logical no-undo.
   define output parameter pDatabase as character no-undo.

   define buffer pod_det for pod_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      for first pod_det fields(pod_nbr pod_po_db) no-lock
         where pod_nbr = pPONbr:
         {pxgetph.i pxgblmgr}
         if pod_po_db <>
            {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                        &HANDLE=ph_pxgblmgr
                       &PARAM='global_db'}
         then
            pIsOnRemoteDatabase = true.
         pDatabase = pod_po_db.

      end.

   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getPricingData :
/*------------------------------------------------------------------------------
Purpose:       Obtains Price Data for Purchase Order Line
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   pod_det(r)
        Post:  pc_mstr(r)
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define parameter buffer pod_det for pod_det.
   define input parameter pPriceTableRequired        as logical   no-undo.
   define input parameter pDiscountTableRequired     as logical   no-undo.
   define input parameter pPriceList                 as character no-undo.
   define input parameter pDiscountList              as character no-undo.
   define input parameter pPOLinePriceEffectiveDate  as date      no-undo.
   define input parameter pPOCurrency                as character no-undo.
   define input parameter pNewPOLine                 as logical   no-undo.
   define input parameter pSupplierDiscount          as decimal   no-undo.
   define input-output parameter pOldPOLineCost      as decimal   no-undo.
   define input-output parameter pOldDiscountPercent as decimal   no-undo.
   define output parameter pNetPrice                 as decimal   no-undo.
   define output parameter pListPrice                as decimal   no-undo.
   define output parameter pMinPrice                 as decimal   no-undo.
   define output parameter pMaxPrice                 as decimal   no-undo.

   define buffer pc_mstr for pc_mstr.

   /* LOCAL VARIABLES */
   define variable stockingQuantity as decimal no-undo.
   define variable quantityOrdered  as decimal no-undo.
   define variable dummyCost        as decimal no-undo.
   define variable oldDiscount      as decimal no-undo.
   define variable matchItemUM      as logical no-undo.
   define variable ctr              as integer no-undo.
   define variable netCost          as decimal no-undo.
   define variable warning          as logical no-undo.
   define variable warnmess         as logical no-undo.
   define variable newPOLine        as logical no-undo.
   define variable pc_recno         as recid   no-undo.
   define variable minmaxerror      as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxgetph.i pxtools}
      newPOLine = {pxfunct.i &FUNCTION='isNewRecord' &PROGRAM='pxtools.p'
                              &HANDLE=ph_pxtools
                             &PARAM="input buffer pod_det:handle"}.

       assign
          stockingQuantity = pod_qty_ord * pod_um_conv
          pListPrice = pod_pur_cost * (1 - pod_disc_pct / 100).
       /* PRICE TABLE LIST PRICE LOOK-UP */
       if pPriceList <> "" then do:
          pListPrice = ?.
          {pxrun.i &PROC='lookupListPriceData' &PROGRAM='xxppplxr.p'
                    &HANDLE=ph_ppplxr
                   &PARAM="(input pPriceList,
                            input pod_part,
                            input pod_um,
                            input pod_um_conv,
/*Y715*/                    input pod_site,
                            input pPOLinePriceEffectiveDate,
                            input pPOCurrency,
                            input newPOLine,
                            input pPriceTableRequired,
                            input-output pod_pur_cost,
                            input-output pListPrice,
                            output pMinPrice,
                            output pMaxPrice,
                            output pc_recno)"}

          /**************************************************************/
          /* The Price List Table Look-Up (PLTL) routine (gppclst.p)    */
          /* May not return a price.  This can be intentional           */
          /* Example (pNewPOLine = "no"), or it can be due to a failure */
          /* To find a table or the table contains a zero               */
          /* Price.  In all cases, pListPrice returns with              */
          /* Its original value (?) when no table price is found.       */
          /* It returns with a non-? value if a price *is* found.       */
          /* pListPrice needs to hold the Net Price for processing      */
          /* Below, but doesn't on return from the PLTL routine.        */
          /* The statements below ensure that pListPrice contains       */
          /* The Net Price                                              */
          /**************************************************************/

          if pListPrice <> ? then
             /* Apply the line discount to the PLTL price */
             pListPrice = pListPrice * (1 - pod_disc_pct / 100).
          else
             /* Calculate the Net Price from the PO line info */
             pListPrice = pod_pur_cost * (1 - pod_disc_pct / 100).

       end. /* if pPriceList <> ""  */

       /* Bounce line if the required item/um price tbl not found */
       if pPriceTableRequired and
          (pPriceList = "" or pc_recno = 0) then do:
          /* MESSAGE #6231 - REQUIRED PRICE TABLE FOR ITEM # IN */
          /* UM # NOT FOUND */
          {pxmsg.i
             &MSGNUM=6231
             &ERRORLEVEL={&APP-ERROR-RESULT}
             &MSGARG1=pod_part
             &MSGARG2=pod_um
             &PAUSEAFTER=TRUE}
          return error {&APP-ERROR-RESULT}.
       end. /* If pPriceTableRequired and ... */

       /**********************************************************/
       /* Since price lists are created for alternate units of   */
       /* Measure expressing the auntities in stocking um. It    */
       /* Is not necessary to mulitply the "P" type lists by the */
       /* Unit of measure conversion factor before price list    */
       /* Lookup.                                                */
       /**********************************************************/

       if pDiscountList <> "" then do:
          assign
             quantityOrdered = pod_qty_ord
             dummyCost = pListPrice
             oldDiscount = pod_disc_pct
             matchItemUM = pDiscountTableRequired.

          /* DISCOUNT TABLE LOOK-UP */

          {pxrun.i &PROC='lookupDiscountData' &PROGRAM='ppplxr.p'
                    &HANDLE=ph_ppplxr
                   &PARAM="(input pDiscountList,
                            input pod_part,
                            input quantityOrdered,
                            input pod_um,
                            input pod_um_conv,
                            input pPOLinePriceEffectiveDate,
                            input pPOCurrency,
                            input pod_pur_cost,
                            input matchItemUM,
                            input pSupplierDiscount,
                            input-output pod_pur_cost,
                            input-output pod_disc_pct,
                            input-output pListPrice,
                            output pc_recno)"}

          /* BACK OUT DISCOUNT APPLIED IF QTY IS BELOW DISCOUNT */
          /* TABLE QUANTITY (TYPE P) RANGE                      */
          find pc_mstr
             where recid(pc_mstr) = pc_recno
             no-lock no-error.

          if available pc_mstr
             and pc_amt_type  = "p"
             and pod_pur_cost <> 0
             and pListPrice   <> pod_pur_cost then do:

             /* CONVERT TO STOCK UM IF WE DON'T HAVE A UM MATCH */
             if pc_um <> pod_um then
                quantityOrdered = quantityOrdered * pod_um_conv.

             do ctr = 1 to 15:
                if pc_min_qty[ctr] > quantityOrdered
                   or (pc_min_qty[ctr] = 0
                   and pc_amt[ctr] = 0)
                then
                   leave.
             end. /* DO ctr = 1 TO 15 */
             ctr = ctr - 1.

             if ctr <= 0 then do:
                assign
                   pListPrice   = dummyCost
                   pod_disc_pct = oldDiscount.
             end. /* IF ctr <= 0 */
          end. /* IF AVAILABLE pc_mstr */
       end. /* IF pDiscountList <> "" */

       /* Bounce the line if the required item/um */
       /* Price list was not found                */
       if pDiscountTableRequired
          and (pDiscountList = "" or pc_recno = 0) then do:

          /* Price list for pod_part in pod_um not found      */
          /* Required Discount table for item in um not found */
          /* MESSAGE #982 - REQUIRED DISCOUNT TABLE FOR       */
          /* ITEM # IN UM # NOT FOUND                         */
          {pxmsg.i
             &MSGNUM=982
             &ERRORLEVEL={&APP-ERROR-NO-REENTER-RESULT}
             &MSGARG1=pod_part
             &MSGARG2=pod_um
             &PAUSEAFTER=TRUE}
          return error {&APP-ERROR-RESULT}.
       end. /* if pDiscountTableRequired */

       if newPOLine then
          assign
            pod__qad09 = pListPrice
            pod__qad02 = (pListPrice - pod__qad09) * 100000
            pOldPOLineCost = pod_pur_cost
            pOldDiscountPercent = pod_disc_pct.

        /********************************************************/
        /* Since price lists are created for alterante units of */
        /* Measure expressing the qauntities in stocking um. It */
        /* Is necessary to mulitply the "P" type lists by the   */
        /* Unit of measure conversion factor after returning    */
        /* From the proce list look up.                         */
        /* It is not necessary to multiply the price with the   */
        /* Unit of measure conversion factor                    */
        /* Pod_pur_cost = pod_pur_cost * pod_um_conv.           */
        /********************************************************/

        /* PRICE TABLE MIN/MAX WARNING FOR  DISCOUNT TABLES. PLUG PRICES */
        if pPriceList <> "" then do:
           pNetPrice = pod_pur_cost * (1 - pod_disc_pct / 100).
           assign
              warnmess   = yes
              netCost = pNetPrice
              warning   = yes.

            {pxrun.i &PROC='validateMinMaxRange' &PROGRAM='ppplxr.p'
                      &HANDLE=ph_ppplxr
                     &PARAM="(input warning,
                              input warnmess,
                              input pod_part,
                              input pMaxPrice,
                              input pMinPrice,
                              input-output pListPrice,
                              input-output pNetPrice,
                              output minmaxerror)"}
            /* IF NET COST IS BELOW MIN/MAX RANGE THEN RECALCULATE */
            /* DISCOUNT SO THAT NET COST IS THE MIN/MAX VALUE      */

            if pNetPrice <> netCost then
               pod_disc_pct = (1 - ( pNetPrice / pod_pur_cost) ) * 100.
        end. /* if pPriceList <> "" */
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getPurchaseCost :

/*------------------------------------------------------------------------------
Purpose:       Gets PO Line Unit Cost after applying the conversion factor and
               currency exchange rate.
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r), po_mstr(r), si_mstr(r)
       Post:   pt_mstr(r)
Notes:         This procedure calls other procedures getSupplierQuotePrice and
               getRemoteItemData to determine PO Line Unit Cost.
History:       Extracted from popomtea.p
------------------------------------------------------------------------------*/
   define input  parameter pItem          as character no-undo.
   define input  parameter pSupplier      as character no-undo.
   define input  parameter pSite          as character no-undo.
   define input  parameter pCurr          as character no-undo.
   define input  parameter pUM            as character no-undo.
   define input  parameter pPodQtyOrd     as decimal no-undo.
   define input  parameter pExRate        as decimal no-undo.
   define input  parameter pExRate2       as decimal no-undo.
   define input  parameter pEffectiveDate as date no-undo.
   define output parameter pPurCost       as decimal no-undo.

   define variable conversion_factor as decimal no-undo.
   define variable glxcst            as decimal no-undo.
   define variable l_pl_acc          like pl_pur_acct no-undo.
   define variable l_pl_sub          like pl_pur_sub no-undo.
   define variable l_pl_cc           like pl_pur_cc no-undo.
   define variable l_pt_ins          like pt_insp_rqd no-undo.
   define variable l_pt_loc          like pt_loc no-undo.
   define variable l_pt_rev          like pt_rev no-undo.
   define variable l_pod_type        like pod_type no-undo.
   define variable basecurrency      like gl_base_curr no-undo.
   define variable mc-error-number   like msg_nbr no-undo.

   define buffer pt_mstr for pt_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='getSupplierQuotePrice' &PROGRAM='ppsuxr.p'
                &HANDLE=ph_ppsuxr
               &PARAM="(input pItem,
                        input pSupplier,
                        input pCurr,
                        input pUM,
                        input pPodQtyOrd,
                        output pPurCost)"}

      if pPurCost = ? then do:

         {pxrun.i &PROC='processRead' &PROGRAM='ppitxr.p'
                   &HANDLE=ph_ppitxr
                  &PARAM="(input pItem,
                           buffer pt_mstr,
                           input {&NO_LOCK_FLAG},
                           input {&NO_WAIT_FLAG})"}

         if return-value = {&SUCCESS-RESULT} then do:

            /* Added supplier type as fourth input parameter */
            {pxrun.i &PROC='getRemoteItemData'
                     &PARAM="(input pEffectiveDate,
                              input pItem,
                              input pSite,
                              input """",
                              output glxcst,
                              output l_pt_rev,
                              output l_pt_loc,
                              output l_pt_ins,
                              output l_pl_acc,
                              output l_pl_sub,
                              output l_pl_cc,
                              output l_pod_type)"}

            conversion_factor = 1.

            if pt_um <> pUM then do:
               {gprun.i ""gpumcnv.p""
                  "(input pt_um,
                    input pUM,
                    input pt_part,
                    output conversion_factor)"}
            end.
            {pxgetph.i pxgblmgr}
            basecurrency =
               {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                           &HANDLE=ph_pxgblmgr
                          &PARAM="input 'base_curr'"}.

            /* CONVERT FROM BASE TO FOREIGN CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input basecurrency,
                 input pCurr,
                 input pExRate2,
                 input pExRate,
                 input (glxcst / conversion_factor),
                 input false, /* DO NOT ROUND */
                 output pPurCost,
                 output mc-error-number)"}.

         end. /* If return-value = success-result */
      end. /* If pPurCost = ? */
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getPurchaseOrderLinePOSite :

/*------------------------------------------------------------------------------
Purpose:       Gets Purchase Order Line PO Site
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  si_mstr(r)
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define input parameter  pPOSiteId       as character no-undo.
   define input parameter  pPOLineSiteId   as character no-undo.
   define output parameter pPOLinePOSiteId as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      if pPOLineSiteId = pPOSiteId then
         pPOLinePOSiteId = pPOSiteId.
      else if pPOSiteId <> "" then
         pPOLinePOSiteId = pPOSiteId.
      else
         pPOLinePOSiteId = pPOLineSiteId.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getRemoteItemData :

/*------------------------------------------------------------------------------
Purpose:       Defaults PO Line Account from Product Line master and other PO
               Line details from Item master and also gets the Standard Cost
               after applying currency exchange rate.
Exceptions:    NONE
Conditions:
        Pre:   po_mstr(r), pod_det(r), si_mstr(r)
       Post:   None
Notes:         This procedure switches the database in mutli-DB environment to
               default the required values.
History:       Extracted from popomtea.p
------------------------------------------------------------------------------*/
   define input  parameter pEffectiveDate      as date no-undo.
   define input  parameter pItemId             as character no-undo.
   define input  parameter pSiteId             as character no-undo.
   define input  parameter pSupplierType as character no-undo.
   define output parameter pStandardCost       as decimal no-undo.
   define output parameter pRevision           as character no-undo.
   define output parameter pLocationId         as character no-undo.
   define output parameter pInspectionRequired as logical no-undo.
   define output parameter pPurchaseAccount    as character no-undo.
   define output parameter pPurchaseSubAccount as character no-undo.
   define output parameter pPurchaseCostCenter as character no-undo.
   define output parameter pItemType           as character no-undo.

   define variable old_db           like si_db no-undo.
   define variable err-flag         as integer no-undo.
   define variable curcst           as decimal no-undo.
   define variable exch_rate        like exr_rate no-undo.
   define variable exch_rate2       like exr_rate2 no-undo.
   define variable remote_base_curr like gl_base_curr no-undo.
   define variable siteDB           like si_db no-undo.
   define variable basecurrency     like gl_base_curr no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='getSiteDataBase' &PROGRAM='icsixr.p'
                &HANDLE=ph_icsixr
               &PARAM="(input pSiteId,
                        output siteDB)"}

      {pxgetph.i pxgblmgr}
      assign
         basecurrency     =
            {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                        &HANDLE=ph_pxgblmgr
                       &PARAM="input 'base_curr'"}
         remote_base_curr = basecurrency.

      if siteDB
         <> {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                        &HANDLE=ph_pxgblmgr
                       &PARAM="input 'global_db'"}
      then do:

         old_db =
            {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                        &HANDLE=ph_pxgblmgr
                       &PARAM="input 'global_db'"}.

         {gprun.i ""gpalias3.p""
            "(input siteDB,
              output err-flag)"}

         /* GET THE BASE CURRENCY OF THE REMOTE DATABASE */
         if err-flag = 0 then do:
            {gprun.i ""gpbascur.p""
               "(output remote_base_curr)"}
         end. /* IF err-flag = 0 */
      end.

      {gprun.i ""gpsct05.p""
         "(input pItemId,
           input pSiteId,
           input 2,
           output pStandardCost,
           output curcst)"}
      /* Added supplier type as third input parameter */
      {gprun.i ""popomte1.p""
         "(input pItemId,
           input pSiteId,
           input pSupplierType,
           output pRevision,
           output pLocationId,
           output pInspectionRequired,
           output pPurchaseAccount,
           output pPurchaseSubAccount,
           output pPurchaseCostCenter,
           output pItemType)"}

      if old_db
         <> {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                       &PARAM="input 'global_db'"}
      then do:
         {gprun.i ""gpalias3.p""
            "(input old_db,
              output err-flag)" }
      end.

      /* CALCULATE THE STANDARD COST IN TERMS OF */
      /* THE BASE CURRENCY OF THE ORDER DB       */
      assign
         exch_rate  = 1
         exch_rate2 = 1.

      if remote_base_curr <> basecurrency then do:

         {pxrun.i &PROC='getExchangeRate' &PROGRAM='mcexxr.p'
                   &HANDLE=ph_mcexxr
                  &PARAM="(input basecurrency,
                           input remote_base_curr,
                           input """",
                           input pEffectiveDate,
                           output exch_rate2,
                           output exch_rate)"}

         {pxrun.i &PROC='convertAmtToTargetCurr' &PROGRAM='mcexxr.p'
                   &HANDLE=ph_mcexxr
                  &PARAM="(input remote_base_curr,
                           input basecurrency,
                           input exch_rate,
                           input exch_rate2,
                           input pStandardCost,
                           input false,
                           output pStandardCost)"}

      end. /* IF remote_base_curr <> basecurrency */

   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getSingleLotReceipt :

/*------------------------------------------------------------------------------
Purpose:       Determines if Item has lot serial qualities
Exceptions:    NONE
Conditions:
Pre:
Post:          pt_mstr(r)
Notes:
History:       Procedure initially extracted from popomtd.p
------------------------------------------------------------------------------*/
   define input parameter  pItemId     as character no-undo.
   define output parameter pLotReciept as logical initial false no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if can-find(first pt_mstr where
                  pt_part = pItemId and
                  pt_lot_ser = "s")
      then
         pLotReciept = true.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getSite :

/*------------------------------------------------------------------------------
Purpose:       Get the Site code for a Purchase Order Detail.
Exceptions:    RECORD-NOT-FOUND
Conditions:
        Pre:   NONE
        Post:  pod_det(r)
Notes:         Extracted from iedmta.p
History:
------------------------------------------------------------------------------*/
   define input parameter pOrderId as character no-undo.
   define input parameter pOrderLine as integer no-undo.
   define output parameter pSite as character no-undo.

   define buffer pod_det for pod_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      for first pod_det
         fields(pod_site)
         where pod_nbr = pOrderId
           and pod_line = pOrderLine
      no-lock:
         pSite = pod_site.
      end.
      if not available pod_det then
         return {&RECORD-NOT-FOUND}.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getTaxableData :

/*------------------------------------------------------------------------------
Purpose:       Gets PO Line Tax Class and Taxable flag.
Exceptions:    NONE
Conditions:
        Pre:   po_mstr(r), pt_mstr(r)
       Post:   None
Notes:
History:       Extracted from popomtea.p
------------------------------------------------------------------------------*/
   define input  parameter pDefaultOrderTaxClass as character no-undo.
   define input  parameter pDefaultOrderTaxable  as logical no-undo.
   define input  parameter pItemTaxable          as logical no-undo.
   define output parameter pTaxClass             as character no-undo.
   define output parameter pTaxable              as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* SET TAX FLAGS */
      assign
         pTaxClass = pDefaultOrderTaxClass
         pTaxable  = (pDefaultOrderTaxable and pItemTaxable).
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE processRead :

/*------------------------------------------------------------------------------
Purpose:       Read PO Line based on Lock and Wait Flags
Exceptions:    RECORD-LOCKED , RECORD-NOT-FOUND
Conditions:
        Pre:
        Post:  po_mstr(r)
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define input parameter   pPOOrderId   as character no-undo.
   define input parameter   pPOLineId    as integer   no-undo.
   define parameter buffer  pod_det      for pod_det.
   define input parameter   pLockFlag    as logical   no-undo.
   define input parameter   pWaitFlag    as logical   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pLockFlag then do :
         if pWaitFlag then
            for first pod_det where
               pod_nbr  = pPOOrderId and
               pod_line =  pPOLineId
            exclusive-lock : end.
          else do :
            find pod_det where
               pod_nbr  = pPOOrderId and
               pod_line =  pPOLineId
            exclusive-lock no-wait no-error.
            if locked pod_det then
               return {&RECORD-LOCKED}.
          end. /* ELSE DO */
      end. /* IF PLOCKFLAG */
      else
         for first pod_det where
            pod_nbr  = pPOOrderId and
            pod_line =  pPOLineId
         no-lock : end.

      if not available pod_det then
         return {&RECORD-NOT-FOUND}.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE reopenPOLines :

/*------------------------------------------------------------------------------
Purpose:       Reopen the purchase order lines.
Exceptions:    NONE
Conditions:
        Pre:   None.
        Post:  pod_det(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pOrder   as character no-undo.
   define input parameter pBlanket as logical   no-undo.

   define variable openqty as decimal.
   define variable bl_qty_chg like pod_rel_qty.
   define buffer poddet for pod_det.
   define buffer pod_det for pod_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* BUFFER FOR POBLADJ.I */
      for each pod_det exclusive-lock
         where pod_nbr = pOrder and pod_status <> "":

         /* ADJUST pBlanket PO WHEN UN-CANCELING */
         /* PO CREATED BY pBlanket               */
         if pod_status = "x"
            and not pBlanket then do:
            {pobladj.i &incr="yes"}
         end. /* IF pod_status = "x" AND NOT pBlanket */

         /* RE-OPENING A REQ/REQ LINE WHEN THE STATUS OF THE  */
         /* CLOSED/CANCELLED PO IS CHANGED AT THE TRAILER     */

         if ({pxfunct.i &FUNCTION='isGRSInUse' &PROGRAM='rqgrsxr.p'})
         then do:
            {gprunmo.i &program = "poreopn.p" &module = "GRS"
               &param = """(input pod_req_nbr, input pod_req_line)"""}
         end. /* IF ({pxfunct.i &FUNCTION='isGRSInUse'....*/

            pod_status = "".

          if not pBlanket then do:

             /* Potrxf.p is a Facade for gppotr.p*/
             /* Update in_mstr and tr_hist */
             {gprun.i ""potrxf.p""
                      "(input ""ADD"",
                        input pod_nbr,
                        input pod_line)"}

             if pod_type = "" then do:
                if pod_qty_ord >= 0 then
                   openqty = maximum(pod_qty_ord - pod_qty_rcvd,0)
                      * pod_um_conv.
                else
                   openqty = minimum(pod_qty_ord - pod_qty_rcvd,0)
                      * pod_um_conv.

                /* UPDATE MRP RECS, ORDER QTY, REQS, NET CHG FLAG */
                /* RUN FACADE BECAUSE MFMRW.I USES INMRP1.I WHICH */
                /* HAS AN INTERNAL PROCEDURE */
                {gprun.i ""popoxf3.p""
                   "(buffer pod_det,
                     input openqty)"}
             end.
         end.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE replaceItemWithSupplierItem :

/*------------------------------------------------------------------------------
Purpose:       Updates PO Line Supplier Item from Supplier Item master, UOM and
               PO Line Item from Item master.
Exceptions:    INFORMATION-RESULT, RECORD-NOT-FOUND
Conditions:
        Pre:   pod_det(r), po_mstr(r)
       Post:   vp_mstr(r), pt_mstr(r)
Notes:
History:       Extracted from popomtea.p
------------------------------------------------------------------------------*/
   define input-output parameter pItemId         as character no-undo.
   define input        parameter pSupplierId     as character no-undo.
   define output       parameter pSupplierItemId as character no-undo.
   define output       parameter pUmForStock     as character no-undo.

   define buffer pt_mstr for pt_mstr.
   define buffer vp_mstr for vp_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      for each vp_mstr
         fields(vp_vend vp_vend_part vp_q_date vp_part)
         where vp_vend = pSupplierId
         and   vp_vend_part = pItemId
         no-lock
         break by vp_q_date descending:

         if first(vp_q_date) then do:
            {pxrun.i &PROC='processRead' &PROGRAM='ppitxr.p'
                      &HANDLE=ph_ppitxr
                     &PARAM="(input vp_part,
                              buffer pt_mstr,
                              input {&NO_LOCK_FLAG},
                              input {&NO_WAIT_FLAG})"}

            if return-value = {&SUCCESS-RESULT} then do:
               assign
                  pUmForStock     = pt_um
                  pItemId         = pt_part
                  pSupplierItemId = vp_vend_part.

               /* MESSAGE #371 - SUPPLIER ITEM # REPLACED BY #*/
               {pxmsg.i
                  &MSGNUM=371
                  &ERRORLEVEL={&INFORMATION-RESULT}
                  &MSGARG1=pSupplierItemId
                  &MSGARG2=pItemId}
               return {&INFORMATION-RESULT}.
            end. /* IF AVAILABLE pt_mstr */
            else
               if return-value = {&RECORD-NOT-FOUND} then
                  return return-value.

            leave.
         end.  /* IF first(vq_q_date) */
      end. /* For each vp_mstr */
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE reversePOTransactionHistory :

/*------------------------------------------------------------------------------
Purpose:       Update Inventory, Transaction History, Requisition
Exceptions:    NONE
Conditions:
        Pre:
        Post:  cmt_det(d), um_mstr(r), pt_mstr(r), req_det(r), pod_det(r)
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define input parameter pPOOrderId       as character no-undo.
   define input parameter pSiteId          as character no-undo.
   define input parameter pPOLineId        as integer   no-undo.

   define variable siteDB     as character no-undo.
   define variable globalDB   as character no-undo.
   define variable oldDB      as character no-undo.
   define variable errorFlag  as integer   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxgetph.i pxgblmgr}
      globalDB
         = {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                       &HANDLE=ph_pxgblmgr
                      &PARAM="input 'global_db'"}.

      /* Potrxf.p is a Facade for gppotr.p*/
      {gprun.i ""potrxf.p""
         "(input ""DELETE"",
           input pPOOrderId,
           input pPOLineId)"}
       {pxrun.i &PROC='getSiteDatabase' &PROGRAM='icsixr.p'
                 &HANDLE=ph_icsixr
                &PARAM="(input pSiteId,
                         output siteDB)"}

      if siteDB <> globalDB then do:
         oldDB = globalDB.
         /* DELETE THE LINE IN THE REMOTE DATABASE */

         {gprun.i ""gpalias3.p"" "(siteDB, output errorFlag)" }

         {gprun.i ""potrxf.p""
            "(input ""DELETE"",
              input pPOOrderId,
              input pPOLineId)"}

         {gprun.i ""gpalias3.p"" "(oldDB, output errorFlag)" }
      end. /* IF siteDB <> globalDB */

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE setNetCostWithMinMaxPrice :

/*------------------------------------------------------------------------------
Purpose:       Update PO Line Net Cost with min/max price.
Exceptions:    None
Conditions:
        Pre:
       Post:
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define input parameter        pMaxPrice     as decimal   no-undo.
   define input parameter        pMinPrice     as decimal   no-undo.
   define input-output parameter pNetPrice     as decimal   no-undo.
   define input-output parameter pDiscPercent  as decimal   no-undo.
   define input-output parameter pListPrice    as decimal   no-undo.
   define input-output parameter pPurchaseCost as decimal   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* IF THE NET COST ENTERED BY THE USER VIOLATES THE     */
      /* MINIMUM/MAXIMUM PRICE , THEN SET THE NET COST TO THE */
      /* MINIMUM/MAXIMUM PRICE WHICHEVER IS APPROPRIATE, UNIT */
      /* COST REMAINS THE SAME AND DISCOUNT IS RECALCULATED   */
      /* SO THAT NET COST IS THE MIN/MAX VALUE AND USER IS    */
      /* PLACED BACK ON THE UNIT COST FIELD.                  */

      if pMinPrice > 0 and pNetPrice < pMinPrice then
         pListPrice = pMinPrice.
      else if pMaxPrice > 0 and pNetPrice > pMaxPrice then
         pListPrice = pMaxPrice.

      pDiscPercent = (1 - ( pListPrice / pPurchaseCost) ) * 100.
   end. /* do on error undo, return error */

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE setNetPriceDecimalAndWholeNumber:

/*------------------------------------------------------------------------------
Purpose:       Store decimal portion and whole number portion of net price.
Exceptions:    None
Conditions:
        Pre:   pod_det(r)
       Post:   pod_det(w)
Notes:
History:       Procedure initially extracted from popomta.p. Used pod__qad02
               and pod__qad09 to store net price and avoid rounding errors.
------------------------------------------------------------------------------*/
   define parameter buffer pod_det for pod_det.
   define input parameter pOldUnitCost as decimal no-undo.
   define input parameter pOldDiscountPercent as decimal no-undo.
   define input parameter pNewRecord as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      if pod_pur_cost <> pOldUnitCost or
         pod_disc_pct <> pOldDiscountPercent or
         (pNewRecord and
         (pod__qad09 + pod__qad02 / 100000) = 0)
      then do:
         assign
           pod__qad09 = pod_pur_cost * (1 - (pod_disc_pct / 100))
           pod__qad02 = (pod_pur_cost * (1 - (pod_disc_pct / 100))
                                     - pod__qad09) * 100000.
      end.


   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE. /* setNetPriceDecimalAndWholeNumber */


/*============================================================================*/
PROCEDURE setPOItemDescription :

/*------------------------------------------------------------------------------
Purpose:       Returns the value of the item description for display
Exceptions:    RECORD-NOT-FOUND
Conditions:
        Pre:   pod_det(r)
       Post:   None
Notes:
History:       Procedure initially extracted from popomtd.p
------------------------------------------------------------------------------*/
   define input parameter        pItemId               as character no-undo.
   define input-output parameter pDescription          as character no-undo.
   define input parameter        pDisplayedDescription as character no-undo.

   define variable dummyCharacter as character no-undo.
   define variable dummyDecimal as decimal no-undo.
   define variable itemDesc1 as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='getBasicItemData' &PROGRAM='ppitxr.p'
                &HANDLE=ph_ppitxr
         &PARAM="(input pItemId,
                  output itemDesc1,
                  output dummyCharacter,
                  output dummyDecimal,
                  output dummyCharacter,
                  output dummyCharacter,
                  output dummyCharacter,
                  output dummyCharacter)" }

      if return-value = {&SUCCESS-RESULT} and
         pDisplayedDescription = itemDesc1 then
         pDescription = "".
      else do:
         pDescription = pDisplayedDescription.

         if return-value = {&RECORD-NOT-FOUND} then
            return return-value.
      end. /* ELSE */
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE setPOLineCostAndDiscountPercent :

/*------------------------------------------------------------------------------
Purpose:       Gets PO Line Purchase Cost And Discount Percent
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   pod_det(r)
        Post:  pod_det(w)
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define input  parameter pOldDiscPercent as decimal no-undo.
   define input  parameter pOldUnitCost    as decimal no-undo.
   define output parameter pActualDiscount as decimal no-undo.
   define parameter buffer pod_det for pod_det.

   define variable minDisc as decimal initial -99.99 no-undo.
   define variable maxDisc as decimal initial 999.99 no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxgetph.i pxtools}
      if not {pxfunct.i &FUNCTION='isNewRecord' &PROGRAM='pxtools.p'
                         &HANDLE=ph_pxtools
                        &PARAM="input buffer pod_det:handle"} then
         assign
            pod_pur_cost = pOldUnitCost
            pod_disc_pct = pOldDiscPercent.

      assign
         pActualDiscount = pod_disc_pct.

      if  pod_disc_pct < minDisc or
          pod_disc_pct > maxDisc then do:
         if pod_disc_pct >  maxDisc then
            pod_disc_pct =  maxDisc.

         if pod_disc_pct < minDisc then
            pod_disc_pct = minDisc.

         if c-application-mode <> 'API' then do:
            /* MESSAGE #1651 - DISCOUNT # CANNOT BE DISPLAYED, */
            /* SHOWN AS ALL 9's */
            {pxmsg.i
               &MSGNUM=1651
               &ERRORLEVEL={&WARNING-RESULT}
               &MSGARG1=pActualDiscount}
            return {&WARNING-RESULT}.
         end.
      end. /* if  pod_disc_pct < minDisc or pod_disc_pct > maxDisc */
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE setSubcontractType:

/*------------------------------------------------------------------------------
Purpose:       Set the type of operation performed on the subcontract
               PO material
Exceptions:    NONE
Conditions:
        Pre:   po_mstr(r)
       Post:   None
Notes:
History:       Extracted from popomtd1.p
------------------------------------------------------------------------------*/
   define parameter buffer pod_det for pod_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      if pod_type <> "S" and pod__qad16 = ? then pod__qad16 = " ".

   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE setUnitCostWithMinMaxPrice :

/*------------------------------------------------------------------------------
Purpose:       Update PO Line Unit Cost with min/max price.
Exceptions:    None
Conditions:
        Pre:
       Post:
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define input parameter        pMaxPrice     as decimal   no-undo.
   define input parameter        pMinPrice     as decimal   no-undo.
   define input-output parameter pPurchaseCost as decimal   no-undo.
   define input-output parameter pDiscPercent  as decimal   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* IF THE UNIT COST ENTERED BY THE USER VIOLATES THE       */
      /* MINIMUM/MAXIMUM PRICE , THEN SET THE UNIT COST TO THE   */
      /* MINIMUM/MAXIMUM PRICE WHICHEVER IS APPROPRIATE, SET     */
      /* DISCOUNT TO ZERO AND PLACE BACK ON THE UNIT COST FIELD. */

      if pMinPrice > 0 and pPurchaseCost < pMinPrice then
         pPurchaseCost = pMinPrice.
      else if pMaxPrice > 0 and pPurchaseCost > pMaxPrice then
         pPurchaseCost = pMaxPrice.

      pDiscPercent = 0.
   end. /* Do on error undo */

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE updateItemForMRP :

/*------------------------------------------------------------------------------
Purpose:       Update MRP For MRP Required Flag
Exceptions:    NONE
Conditions:
        Pre:   in_mstr(r), pt_mstr(r)
        Post:  in_mstr(w), pt_mstr(w)
Notes:
History:       Extracted from popomth.p
------------------------------------------------------------------------------*/
   define input parameter pItemId       as character no-undo.
   define input parameter pPOLineSiteId as character no-undo.

   /* LOCAL VARIABLES */
   define variable old_db   like si_db   no-undo.
   define variable err-flag as   integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* UPDATE PART MASTER MRP FLAG */
      {pxgetph.i pxgblmgr}
      assign
         old_db
            = {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                          &HANDLE=ph_pxgblmgr
                         &PARAM='global_db'}.

      if pPOLineSiteId <> "" then do:
         {gprun.i ""gpalias2.p"" "(pPOLineSiteId, output err-flag)"}
      end.
      if {pxfunct.i &FUNCTION='setCharacterValue' &PROGRAM='pxgblmgr.p'
                    &PARAM="'global_part',pItemId"} then .

      /* FLIP IN_MSTR MRP REQUIRED FLAG TO YES */
      {gprun.i ""inmrp.p"" "(pItemId, pPOLineSiteId)"}

      {gprun.i ""gpalias3.p"" "(old_db, output err-flag)" }
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE updatePOLineData :

/*------------------------------------------------------------------------------
Purpose:       Update Purchase Order Line Data
Exceptions:    NONE
Conditions:
        Pre:
        Post:  po_mstr(w), pod_det(w), mrp_det (c)
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define input parameter pPONbr           as character no-undo.
   define input parameter pPOLineId        as integer   no-undo.
   define input parameter pPOLineOldStatus as character no-undo.
   define input parameter pPOLIneOldType   as character no-undo.
   define input parameter pIsBlanket       as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* Update ORD-PO and MRP Supply records */
      if pIsBlanket = false then do:
         /* POPOXF1.P is a facade for popomtc.p */
         {gprun.i ""popoxf1.p""
                  "(pPONbr,
                   pPOLineId,
                   pPOLineOldStatus,
                   pPOLineOldType,
                   pIsBlanket)"}

      end. /* IF IsBlanket = false */
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE updatePOLineLocationForInspection :

/*------------------------------------------------------------------------------
Purpose:       Returns default inspection location if inspection is required
Exceptions:    INFORMATION-RESULT
Conditions:
        Pre:   poc_ctrl(r)
       Post:   None
Notes:
History:       Procedure initially extracted from popomtd.p
------------------------------------------------------------------------------*/
   define input parameter pInspectionRequired        as logical no-undo.
   define input parameter pDefaultInspectionLocation as character no-undo.
   define input-output parameter pLocation as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pLocation = "" and pInspectionRequired
      then do:
         pLocation = pDefaultInspectionLocation.

         /* MESSAGE #351 - INSPECTION REQUIRED - LOCATION SET TO */
         {pxmsg.i
            &MSGNUM=351
            &ERRORLEVEL={&INFORMATION-RESULT}
            &MSGARG1=pLocation}

         return {&INFORMATION-RESULT}.
      end. /* IF LOCATION = "" AND ... */
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateBlanketOrderReleased :

/*------------------------------------------------------------------------------
Purpose:       Checks if any Purchase Order Was Released from this Blanket Order               And then Disallows Deletion.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   po_mstr(r), pod_det(r)
         Post: po_mstr(r), pod_det(r)
Notes:
History:       Procedure Extracted from popomth.p
------------------------------------------------------------------------------*/
   define input parameter pPOId       as character no-undo.
   define input parameter pSupplierId as character no-undo.
   define input parameter pPOPart     as character no-undo.
   define input parameter pPOLineId   as integer   no-undo.

   define buffer po_mstr for po_mstr.
   define buffer pod_det for pod_det.

   /* LOCAL VARIABLES */
   define variable po-found          as character  no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      for each po_mstr
         fields (po_vend po_nbr po_blanket) no-lock
         where po_vend = pSupplierId and
               po_nbr <> pPOId :

         if po_blanket <> pPOId then next.

         for first pod_det
            fields (pod_nbr pod_part pod_line pod_blanket pod_blnkt_ln) no-lock
            where pod_nbr      = po_nbr   and
                  pod_part     = pPOPart  and
                  pod_blanket  = pPOId    and
                  pod_blnkt_ln = pPOLineId
            use-index pod_part :
         end. /* FOR FIRST POD_DET */
         if available pod_det
         then do:
             po-found = pod_nbr + "/" + string(pod_line).

             /* MESSAGE #1102 - DELETE NOT ALLOWED.  # WAS */
             /* RELEASED FROM THIS BLANKET PO */
             {pxmsg.i
                &MSGNUM=1102
                &ERRORLEVEL={&APP-ERROR-NO-REENTER-RESULT}
                &MSGARG1=po-found}
             return error {&APP-ERROR-RESULT}.
         end. /* IF AVAILABLE POD_DET */
      end. /* FOR EACH PO_MSTR */
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateBlanketRelQty :
/*------------------------------------------------------------------------------
<Comment1>
popoxr1.p
validateBlanketRelQty (
   input logical pBlanket,
   Buffer pod_det)

Parameters:
   pBlanket - Flag indicating if Blanket PO
   pod_det  - Buffer for the Blanket PO Line

Exceptions: APP-ERROR-RESULT

PreConditions: Entry of Blanket Release Quantity

PostConditions: Validated Blanket Release Quantity

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pBlanket as logical no-undo.
   define parameter buffer pod_det for pod_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pBlanket and pod_qty_chg > (pod_qty_ord - pod_rel_qty) then do:
         /* MESSAGE #384 - QUANTITY TO RELEASE IS MORE THAN THE OPEN QUANTITY */
         {pxmsg.i
            &MSGNUM=384
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE validateDelete :

/*------------------------------------------------------------------------------
Purpose:       Checks for existance of PO Receipts and Schedule before deleting
               a Purchase Order Line.
Exceptions:    None
Conditions:
        Pre:   None
       Post:   None
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPOId     as character no-undo.
   define input parameter pPOLineId as integer   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* CHECKS FOR EXISTANCE OF PO RECEIPTS */
      {pxrun.i &PROC='validateForExistingReceipts'
               &PARAM="(input pPOId,
                        input pPOLineId)"}

      /* CHECKS FOR EXISTANCE OF SCHEDULES FOR A PO LINE */
      {pxrun.i &PROC='validateForExistingSchedules'
               &PARAM="(input pPOId,
                        input pPOLineId)"}
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateForBlanketType :

/*------------------------------------------------------------------------------
Purpose:       Validates that PO Line Types matches blanket PO setting
Exceptions:    APP-EROR-RESULT
Conditions:
        Pre:   pod_det(r)
       Post:   None
Notes:
History:       Procedure initially extracted from popomtd.p
------------------------------------------------------------------------------*/
   define input parameter pPOIsBlanket as logical   no-undo.
   define input parameter pPOLineType  as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      if pPOLineType = "B" and not pPOIsBlanket then do:
         /* MESSAGE #683 - TYPE "B" IS RESERVED FOR BLANKET ORDERS */
         {pxmsg.i
            &MSGNUM=683
            &ERRORLEVEL={&APP-ERROR-RESULT}}

         return error {&APP-ERROR-RESULT}.
      end.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateForExistingReceipts :

/*------------------------------------------------------------------------------
Purpose:       Checks for Existing Receipt transactions for a Purchase OrderLine               and dis-allows deletion of such lines
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   pod_det(r)
        Post:  prh_hist(r)
Notes:
History:       Procedure Extracted from popomth.p
------------------------------------------------------------------------------*/
   define input parameter pPOId   as character no-undo.
   define input parameter pLineId as integer   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
         if can-find(first prh_hist where
                     prh_nbr  = pPOId and
                     prh_line = pLineId)
         then do:
            /* DELETE NOT ALLOWED, PO LINE HAS RECEIPTS */
            /* MESSAGE #364 - DELETE NOT ALLOWED, PO LINE HAS RECEIPTS */
            {pxmsg.i
               &MSGNUM=364
               &ERRORLEVEL={&APP-ERROR-NO-REENTER-RESULT}}
            return error {&APP-ERROR-RESULT}.
         end. /* IF CAN-FIND(PRH_HIST */
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateForExistingSchedules :

/*------------------------------------------------------------------------------
Purpose:       Checks for Existing Schedules for a Purchase Order Line and                     disallows deletion for such a line.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   pod_det(r)
        Post:  sch_mstr(r)
Notes:
History:       Procedure Extracted from popomth.p
------------------------------------------------------------------------------*/
   define input parameter pPOId   as character no-undo.
   define input parameter pLineId as integer   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* SCH_TYPE  4 IS FOR PURCHASE ORDERS */
      if can-find(first sch_mstr where
                  sch_type = 4 and
                  sch_nbr = pPOId and
                  sch_line = pLineId)
      then do :
         /* MESSAGE #6022 - SCHEDULE EXISTS, DELETE NOT ALLOWED */
         {pxmsg.i
            &MSGNUM=6022
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* IF CAN-FIND(SCH_MSTR */
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateItemOnRemoteDB :

/*------------------------------------------------------------------------------
Purpose:       Validates items that exist on a Remote DB
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   pod_det(r)
       Post:   pt_mstr(r)
Notes:
History:       Procedure initially extracted from popomtd.p
------------------------------------------------------------------------------*/
   define input parameter pItemId as character no-undo.
   define input parameter pSiteId as character no-undo.

   define variable err-flag          as integer no-undo.
   define variable oldDBId          as character no-undo.
   define variable globalDBId as character no-undo.
   define variable siteDB            as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxgetph.i pxgblmgr}
      globalDBId =
         {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                     &HANDLE=ph_pxgblmgr
                    &PARAM='global_db'}.

      /*Get site database*/
      {pxrun.i &PROC='getSiteDataBase' &PROGRAM='icsixr.p'
                &HANDLE=ph_icsixr
               &PARAM="(input pSiteId,
                        output siteDB)"}

      /* Multi-Database Re-assignment */
      oldDBId = globalDBId.

      if siteDB <> globalDBId then do:
         {gprun.i ""gpalias3.p"" "(siteDB, output err-flag)"}
         globalDBId = siteDB.
      end.

      if err-flag <> 0 then do:
         /* MESSAGE #2510 - DATABASE # NOT AVAILABLE */
         {pxmsg.i
            &MSGNUM=2510
            &ERRORLEVEL={&APP-ERROR-NO-REENTER-RESULT}
            &MSGARG1="siteDB"}
      end.
      else do:
         if not can-find (first pt_mstr where pt_part = pItemId) then do:
            /* MESSAGE #715 - ITEM DOES NOT EXIST AT THIS SITE */
            {pxmsg.i
               &MSGNUM=715
               &ERRORLEVEL={&APP-ERROR-NO-REENTER-RESULT}}

            err-flag = -1.
         end.
      end.

      /* If any errors then reset DB aliases and Item Type */
      if err-flag <> 0 then do:
         if oldDBId <> globalDBId then do:
            {gprun.i ""gpalias3.p"" "(oldDBId, output err-flag)"}
         end.

         return error {&APP-ERROR-RESULT}.
      end.
      else do:
         if oldDBId <> globalDBId then do:
            {gprun.i ""gpalias3.p"" "(oldDBId, output err-flag)"}
         end.
      end.

   end. /* Do on error */

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateOrderQtyAgainstBlanketOrderOpenQty :

/*------------------------------------------------------------------------------
Purpose:       Checks if the order qty does not exceed the open qty on the
               blanket order.
Exceptions:    APP-ERROR-RESULT
Conditions:
         Pre:  pod_det(r),
         Post: pod_det(r),
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pBlanketOrderNbr       as character no-undo.
   define input parameter pBlanketOrderLn       as integer no-undo.
   define input parameter pQuantityOrdered       as decimal no-undo.
   define input parameter pOldQuantityOrdered       as decimal no-undo.
   define input parameter pOldLineStatus       as character no-undo.

   define buffer pod_det for pod_det.

   /* LOCAL VARIABLES */
   define variable po-found          as character  no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      for first pod_det
         fields (pod_qty_ord pod_rel_qty) no-lock
         where pod_nbr  = pBlanketOrderNbr
           and pod_line = PBlanketOrderLn:
      end. /* FOR FIRST PODDET */

      if available pod_det then do:
          if (pOldLineStatus = "" and
             (pQuantityOrdered >
            (pod_qty_ord - pod_rel_qty + pOldQuantityOrdered)))
           or (pOldLineStatus <> "" and
             (pQuantityOrdered >
            (pod_qty_ord - pod_rel_qty)))
          then do:
             /*  MESSAGE # 4768 - QTY EXCEEDS THE OPEN QTY ON BLANKET ORDER */
             {pxmsg.i
                &MSGNUM=4768
                &ERRORLEVEL={&APP-ERROR-RESULT}}
             return error {&APP-ERROR-RESULT}.
          end.
      end. /* IF AVAILABLE POD_DET */
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateOrderQtyAgainstRcptQty :

/*------------------------------------------------------------------------------
Purpose:       Validates Order Quantity Against the Receipt quantity
Exceptions:    WARNING-RESULT
Conditions:
        Pre:
        Post:
Notes:
History:       Extracted from popomth.p
------------------------------------------------------------------------------*/
   define input parameter pQuantityOrdered as decimal no-undo.
   define input parameter pOldQuantityOrdered as decimal no-undo.
   define input parameter pQuantityReceived as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if (pQuantityOrdered < pQuantityReceived and pOldQuantityOrdered > 0
         and pQuantityReceived > 0)
         or (pQuantityOrdered > pQuantityReceived and pOldQuantityOrdered < 0
         and pQuantityReceived < 0)
      then do:
         /* MESSAGE #330 - INVALID ORDER QUANTITY FOR QUANTITY RECEIVED */
         {pxmsg.i
            &MSGNUM=330
            &ERRORLEVEL={&WARNING-RESULT}}
         return {&WARNING-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOCostsForMinMaxViolation :

/*------------------------------------------------------------------------------
Purpose:       Checks Purchase Cost and Net Cost for min/max price table
               violation.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:
       Post:
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define input parameter        pPriceList    as character no-undo.
   define input parameter        pItemId       as character no-undo.
   define input parameter        pMaxPrice     as decimal   no-undo.
   define input parameter        pMinPrice     as decimal   no-undo.
   define input-output parameter pNetPrice     as decimal   no-undo.
   define input-output parameter pPurchaseCost as decimal   no-undo.

   define variable warning   as logical no-undo.
   define variable warmess   as logical no-undo.
   define variable minmaxerr as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* PRICE TABLE MIN/MAX ERROR */
      if pPriceList <> "" then do:
         assign
            warmess = yes
            warning = no.

         {pxrun.i &PROC='validateMinMaxRange' &PROGRAM='ppplxr.p'
                   &HANDLE=ph_ppplxr
                  &PARAM="(input warning,
                           input warmess,
                           input pItemId,
                           input pMaxPrice,
                           input pMinPrice,
                           input-output pPurchaseCost,
                           input-output pNetPrice,
                           output minmaxerr)"}

         if minmaxerr then
            return error {&APP-ERROR-RESULT}.

      end. /* If pListPrice <> "" */
   end. /* Do on error undo, return error */

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineAssay :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_assay
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: USER DOES NOT HAVE ACCESS TO THIS FIELD. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
                &HANDLE=ph_gpsecxr
               &PARAM="(input 'pod_assay', input '')"
               &FIELD-LIST=pod_det.pod_assay}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePODataBase :

/*---------------------------------------------------------------------------
  Purpose:     Determine if the PO DB is the same as the default DB
  Exceptions:  APP-ERROR-RESULT
  Dependencies:
       Input-      pod_det(r)
       Output-     pod_det(r)
  Notes:
  History:
---------------------------------------------------------------------------*/
   define input parameter pPONbr as character no-undo.

   define variable isOnRemoteDatabase as logical no-undo.
   define variable databaseName as character no-undo.
   define variable POTermLabel as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='getPORemoteDataBase'
               &PARAM="(input pPONbr,
                        output isOnRemoteDatabase,
                        output databaseName)"}
      if isOnRemoteDatabase
      then do:
         /* GET TERM LABEL FOR PURCHASE ORDER */
         {pxgetph.i gplabel}
         POTermLabel = ({pxfunct.i &FUNCTION='getTermLabel'
                                   &PROGRAM='gplabel.p'
                                    &HANDLE=ph_gplabel
                                   &PARAM="input 'PURCHASE_ORDER',
                                           input 18"}).
         /* PO is for database pod_po_db */
         /* MESSAGE #2514 - # IS FOR DATABASE */
         {pxmsg.i
            &MSGNUM=2514
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &MSGARG1=POTermLabel
            &MSGARG2=databaseName}
         return error {&APP-ERROR-RESULT}.
      end.

   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineCreditTermsInt :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_crt_int
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: USER DOES NOT HAVE ACCESS TO THIS FIELD. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
                &HANDLE=ph_gpsecxr
               &PARAM="(input 'pod_crt_int', input '')"
               &FIELD-LIST=pod_det.pod_crt_int}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineDiscountPct :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_disc_pct
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: USER DOES NOT HAVE ACCESS TO THIS FIELD. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
                &HANDLE=ph_gpsecxr
               &PARAM="(input 'pod_disc_pct', input '')"
               &FIELD-LIST=pod_det.pod_disc_pct}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineERSOptSecurity :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_ers_opt
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: USER DOES NOT HAVE ACCESS TO THIS FIELD. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
                &HANDLE=ph_gpsecxr
               &PARAM="(input 'pod_ers_opt', input '')"
               &FIELD-LIST=pod_det.pod_ers_opt}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineExpire :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_expire
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as date no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: USER DOES NOT HAVE ACCESS TO THIS FIELD. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
                &HANDLE=ph_gpsecxr
               &PARAM="(input 'pod_expire', input '')"
               &FIELD-LIST=pod_det.expire}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineFixedPrice :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_fix_pr
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: USER DOES NOT HAVE ACCESS TO THIS FIELD. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
                &HANDLE=ph_gpsecxr
               &PARAM="(input 'pod_fix_pr', input '')"
               &FIELD-LIST=pod_det.pod_fix_pr}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineGrade :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_grade
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: VALUE MUST EXIST IN GENERALIZED CODES. */
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
               &PARAM="(input 'pod_grade',
                        input '',
                        input pValue,
                        input '')"
               &FIELD-LIST=pod_det.pod_grade}

      /* ERROR: USER DOES NOT HAVE ACCESS TO THIS FIELD. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
                &HANDLE=ph_gpsecxr
               &PARAM="(input 'pod_grade', input '')"
               &FIELD-LIST=pod_det.pod_grade}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLinePurchaseOrderId :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_nbr
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* MESSAGE #3770 - PURCHASE ORDER MUST EXIST. */
      if not(can-find(po_mstr where po_nbr = pValue)) then do:
         {pxmsg.i
            &MSGNUM=3770
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &FIELDNAME='pod_det.pod_nbr'}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLinePayUM :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_pay_um
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT} :
      /* ERROR: VALUE MUST EXIST IN GENERALIZED CODES. */
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
               &PARAM="(input 'pod_pay_um',
                        input '',
                        input pValue,
                        input '')"
               &FIELD-LIST=pod_det.pod_pay_um}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLinePODataBase :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_po_db
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* MESSAGE # 2501 - INVALID DATABASE */
      if not(can-find(dc_mstr where dc_name = pValue) or pValue = "") then do:
         {pxmsg.i
            &MSGNUM=2501
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &FIELDNAME='pod_det.pod_po_db'}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLinePOSite :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_po_site
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateSite' &PROGRAM='icsixr.p'
                &HANDLE=ph_icsixr
               &PARAM="(input 'pod_po_site',
                        input pValue,
                        input no,
                        input '')"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineERSPriceListOpt :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_pr_lst_tp
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* PRICE LIST OPTION MUST BE 0, 1, 2, OR 3 */
      if not({gpprlst.v integer(pValue)}) then do:
         {pxmsg.i &MSGNUM=3769
                  &ERRORLEVEL={&APP-ERROR-RESULT}
                  &FIELDNAME='pod_det.pod_pr_lst_tp'}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLinePayUMConv :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_pum_conv
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* MESSAGE #7259 - UM CONVERSION MAY NOT EQUAL 0. */
      if pValue = 0 then do:
         {pxmsg.i
            &MSGNUM=7259
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &FIELDNAME='pod_det.pod_pum_conv'}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineUnitCost :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_pur_cost
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as decimal no-undo.

   do on error undo, return {&GENERAL-APP-EXCEPT} :
      /*ERROR: USER DOES NOT HAVE ACCESS TO THIS FIELD. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
                &HANDLE=ph_gpsecxr
               &PARAM="(input 'pod_pur_cost', input '')"
               &FIELD-LIST=pod_det.pod_pur_cost}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineReceiptStatus :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_rctstat
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: STATUS DOES NOT EXIST OR USER DOES NOT HAVE ACCESS. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
                &HANDLE=ph_gpsecxr
               &PARAM="(input 'pod_rctstat', input '')"
               &FIELD-LIST=pod_det.pod_rctstat}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineRevision :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_rev
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: VALUE MUST EXIST IN GENERALIZED CODES. PLEASE RE-ENTER. */
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
               &PARAM="(input 'pod_rev',
                        input '',
                        input pValue,
                        input '')"
               &FIELD-LIST=pod_det.pod_rev}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineReceiptUM :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_rum
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: VALUE MUST EXIST IN GENERALIZED CODES. */
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
               &PARAM="(input 'pod_rum',
                        input '',
                        input pValue,
                        input '')"
               &FIELD-LIST=pod_det.pod_rum}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineReceiptUMConv :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_rum_conv
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* MESSAGE # 7259 - UM CONVERSION MAY NOT EQUAL 0 */
      if pValue = 0 then do:
         {pxmsg.i
            &MSGNUM=7259
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &FIELDNAME='pod_det.pod_rum_conv'}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineSite :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_site
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateSite' &PROGRAM='icsixr.p'
                &HANDLE=ph_icsixr
               &PARAM="(input 'pod_site',
                        input pValue,
                        input no,
                        input '')"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineStatus :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_status
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* MESSAGE #3465- STATUS MUST BE BLANK (OPEN), C (CLOSED),  */
      /*                OR X (CANCELLED).                         */
      if not(pValue = "" or pValue = "C" or pValue = "X") then do:
         {pxmsg.i
            &MSGNUM=3465
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &FIELDNAME='pod_det.pod_status'}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineTaxUsage :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_tax_usage
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: VALUE MUST EXIST IN GENERALIZED CODES. */
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
               &PARAM="(input 'tx2_tax_usage',
                        input '',
                        input pValue,
                        input '')"
               &FIELD-LIST=pod_det.pod_tax_usage}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineType :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_type
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: VALUE MUST EXIST IN GENERALIZED CODES. */
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
               &PARAM="(input 'pod_type',
                        input '',
                        input pValue,
                        input '')"
               &FIELD-LIST=pod_det.pod_type}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineUM :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_um
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: VALUE MUST EXIST IN GENERALIZED CODES.  */
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
               &PARAM="(input 'pod_um',
                        input '',
                        input pValue,
                        input '')"
               &FIELD-LIST=pod_det.pod_um}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineUMConv :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_um_conv
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
        Post:  None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* MESSAGE #7259 - UM CONVERSION MAY NOT EQUAL 0 */
      if pValue = 0 then do:
         {pxmsg.i
            &MSGNUM=7259
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &FIELDNAME='pod_det.pod_um_conv'}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineAccount :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_acct
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
       Post:   None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='validateAccountCode' &PROGRAM='glacxr.p'
                &HANDLE=ph_glacxr
               &PARAM="(input pValue)"
               &NOAPPERROR=true}

      if return-value <> {&SUCCESS-RESULT} then do :
         /* MESSAGE # 3052 - INVALID ACCOUNT CODE */
         {pxmsg.i
            &MSGNUM=3052
            &ERRORLEVEL={&APP-ERROR-RESULT}}

         return error {&APP-ERROR-RESULT}.
      end.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineCostCenter :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_cc
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
       Post:   None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='validateCostCenterCode' &PROGRAM='glacxr.p'
                &HANDLE=ph_glacxr
               &PARAM="(input pValue)"
               &NOAPPERROR=True}


      if return-value <> {&SUCCESS-RESULT} then do :
         /* MESSAGE # 3057 - INVALID COST CENTER */
         {pxmsg.i
            &MSGNUM=3057
            &ERRORLEVEL={&APP-ERROR-RESULT}}

         return error {&APP-ERROR-RESULT}.
      end.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineERSOption :

/*------------------------------------------------------------------------------
Purpose:       validate the ERS Option for purchase order line
Exceptions:    None
Conditions:
        Pre:   pod_det(r)
       Post:   None
Notes:
History:       Procedure initially extracted from popomtd.p
------------------------------------------------------------------------------*/
   define input parameter pERSOption as integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pERSOption <> 0 then do:
         {pxrun.i &PROC='validateERSOption' &PROGRAM='aperxr.p'
                   &HANDLE=ph_aperxr
                  &PARAM="(input pERSOption)"}
      end.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineNumber :

/*------------------------------------------------------------------------------
Purpose:       validates Purchase Order Line Number
Exceptions:    WARNING-RESULT, APP-ERROR-RESULT
Conditions:
        Pre:
        Post:
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define input parameter pPOLine as integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pPOLine > 999 then do:
         /* MESSAGE #7418 -  pPOLine NUMBER CANNOT EXCEED 999 */
         {pxmsg.i
            &MSGNUM=7418
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* IF pPOLine = 999 */
      else if pPOLine = 0  then do:
         /* MESSAGE #3953 - VALUE MUST BE GREATER THAN ZERO */
         {pxmsg.i
            &MSGNUM=3953
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* ELSE IF */
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineProject :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_project
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
       Post:   None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateProjectCode' &PROGRAM='glacxr.p'
                &HANDLE=ph_glacxr
               &PARAM="(input pValue)"}

      if return-value <> {&SUCCESS-RESULT} then
         return return-value.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineQuantityOrdered :

/*------------------------------------------------------------------------------
Purpose:       Validate Purchase Order Line quantity for Negative values
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:
        Post:
Notes:
History:       Extracted from popomth.p
------------------------------------------------------------------------------*/
   define input parameter pPOLineQuantityOrdered as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pPOLineQuantityOrdered < 0 then do:
         /* MESSAGE #5619 - NEGATIVE NUMBERS NOT ALLOWED */
         {pxmsg.i
            &MSGNUM=5619
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineStatusChanged :

/*------------------------------------------------------------------------------
Purpose:       validate the status change of a purchase order line
Exceptions:    WARNING-RESULT
Conditions:
Pre:
Post:
Notes:
History:       Procedure initially extracted from popomtd.p
------------------------------------------------------------------------------*/
   define input parameter pNewStatus as character no-undo.
   define input parameter pOldStatus as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pNewStatus = "c" and pOldStatus = "x" then do:
         /* MESSAGE #329 - CANCELLED LINE CHANGED TO CLOSED */
         {pxmsg.i
            &MSGNUM=329
            &ERRORLEVEL={&WARNING-RESULT}}
         return {&WARNING-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineSubAccount :

/*------------------------------------------------------------------------------
Purpose:       Validate pod_det.pod_sub
Exceptions:    NONE
Conditions:
        Pre:   pod_det(r)
       Post:   None.
Notes:
History:       Pulled from schema
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='validateSubAccountCode' &PROGRAM='glacxr.p'
                &HANDLE=ph_glacxr
               &PARAM="(input pValue)"
               &NOAPPERROR=True}

      if return-value <> {&SUCCESS-RESULT} then do :
         /* MESSAGE #3131 -  INVALID SUB-ACCOUNT CODE */
         {pxmsg.i
            &MSGNUM=3131
            &ERRORLEVEL={&APP-ERROR-RESULT}}

         return error {&APP-ERROR-RESULT}.
      end.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLineTypeForRequisition :

/*------------------------------------------------------------------------------
Purpose:       Checks if PO Line with requisition does not have PO line type.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   pod_det(r)
       Post:   None
Notes:
History:       Procedure initially extracted from popomtd.p
------------------------------------------------------------------------------*/
   define input parameter pPOIsBlanket          as logical   no-undo.
   define input parameter pPOLineRequisitionNbr as character no-undo.
   define input parameter pPOLinePart           as character no-undo.
   define input parameter pPOLineType           as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pPOLineRequisitionNbr <> "" and
         can-find(last req_det where req_nbr = pPOLineRequisitionNbr) and
         can-find(pt_mstr where pt_part = pPOLinePart) and
         pPOIsBlanket = false and
         pPOLineType <> ""
      then do:
         /* MESSAGE #348 - PO TYPE NOT ALLOWED WHEN USING REQUISITION */
         {pxmsg.i
            &MSGNUM=348
            &ERRORLEVEL={&APP-ERROR-RESULT}}

         return error {&APP-ERROR-RESULT}.
      end.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOSubcontractData :

/*------------------------------------------------------------------------------
Purpose:       Validate PO subcontracting data against Work Order master.
Exceptions:    RECORD-NOT-FOUND, APP-ERROR-RESULT, WARNING-RESULT
Conditions:
        Pre:   None
       Post:   wo_mstr(r), wr_route(r), mfc_ctrl(r)
Notes:         This procedure validates if Work Order/ID & WO routing exists,
               WO item & project matches with PO Line item & project, WO is not
               for CO/BY-Product and not closed, firmed, planned or scheduled,
               WO operation is not closed and Advanced Repetitive Cummulative
               Order is not expired and subcontract cost is not nil.
History:       Extracted from popomtd1.p
------------------------------------------------------------------------------*/
   define input parameter pWorkOrderNumber as character no-undo.
   define input parameter pWorkOrderId     as character no-undo.
   define input parameter pItem            as character no-undo.
   define input parameter pProject         as character no-undo.
   define input parameter pOperation       as integer   no-undo.

   define buffer wr_route for wr_route.
   define buffer wo_mstr  for wo_mstr.
   define buffer mfc_ctrl for mfc_ctrl.

   define variable checkWarning like mfc_logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* IF WORK ORDER ID IS BLANK, THEN GET FIRST WORK ORDER ID */
      /* FROM WORK ORDER MASTER BASED ON WORK ORDER NUMBER       */
      if pWorkOrderId = "" then do:
         {pxrun.i &PROC='getFirstWOIdForNumber' &PROGRAM='wowoxr.p'
                   &HANDLE=ph_wowoxr
                  &PARAM="(input pWorkOrderNumber,
                           output pWorkOrderId)"}
      end.

      {pxrun.i &PROC='processRead' &PROGRAM='wowoxr.p'
                &HANDLE=ph_wowoxr
               &PARAM="(input pWorkOrderId,
                        buffer wo_mstr,
                        input {&NO_LOCK_FLAG},
                        input {&NO_WAIT_FLAG})"}

      /* VALIDATE WO AGAINST PO INFO */
      if return-value = {&RECORD-NOT-FOUND} then do:
         /* MESSAGE #510 - WORK ORDER/ID DOES NOT EXIST */
         {pxmsg.i
            &MSGNUM=510
            &ERRORLEVEL={&WARNING-RESULT}
            &PAUSEAFTER=TRUE}
         return {&RECORD-NOT-FOUND}.
      end.

      if pItem <> wo_part then do:
         /* MESSAGE #692 - WORK ORDER IS FOR ITEM NUMBER */
         {pxmsg.i
            &MSGNUM=692
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &MSGARG1=wo_part
            &PAUSEAFTER=true}
         return error {&APP-ERROR-RESULT}.
      end.

      if wo_joint_type <> "" then do:
         /* MESSAGE #6517 - CO/BY-PRODUCT WORK ORDER MAY NOT BE */
         /*                 SUBCONTRACTED                       */
         {pxmsg.i
            &MSGNUM=6517
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &PAUSEAFTER=true}
         return error {&APP-ERROR-RESULT}.
      end.

      if index ("FPC",wo_status) <> 0 then do:
         /* MESSAGE #523 - WORK ORDER ID IS CLOSED, */
         /*                PLANNED OR FIRM PLANNED  */
         {pxmsg.i
            &MSGNUM=523
            &ERRORLEVEL={&WARNING-RESULT}
            &PAUSEAFTER=TRUE}
         checkWarning = true.
      end.

      if index ("S",wo_type) <> 0 then do:
         /* MESSAGE #506 - WORK ORDER IS SCHEDULED ORDER */
         {pxmsg.i
            &MSGNUM=506
            &ERRORLEVEL={&WARNING-RESULT}
            &PAUSEAFTER=TRUE}
         checkWarning = true.
      end.

      if wo_project <> pProject then do:
         /* MESSAGE #553 - WORK ORDER PROJECT DOES MATCH */
         /*                PURCHASE ORDER PROJECT        */
         {pxmsg.i
            &MSGNUM=553
            &ERRORLEVEL={&WARNING-RESULT}
            &PAUSEAFTER=TRUE}
         checkWarning = true.
      end.

      /* EDIT OPERATION DATA ONLY IF WORK ORDER EXISTS */
      for first wr_route
         fields(wr_lot wr_op wr_status wr_sub_cost)
         where wr_lot = pWorkOrderId
         and   wr_op  = pOperation
         no-lock: end.

      if not available wr_route then do:
         /* MESSAGE #511 - WORK ORDER OPERATION DOES NOT EXIST */
         {pxmsg.i
            &MSGNUM=511
            &ERRORLEVEL={&WARNING-RESULT}
            &PAUSEAFTER=TRUE}
         checkWarning = true.
      end.

      if available wr_route and wr_status = "c" then do:
         /* MESSAGE #524 - WORK ORDER OPERATION IS CLOSED */
         {pxmsg.i
            &MSGNUM=524
            &ERRORLEVEL={&WARNING-RESULT}
            &PAUSEAFTER=TRUE}
         checkWarning = true.
      end.

      if wo_type = "c" then do: /* CUMULATIVE */
         /* VALIDATION FOR ADVANCED REPETITIVE */
         for first mfc_ctrl
            fields(mfc_field mfc_logical)
            where mfc_field = "rpc_using_new"
            no-lock: end.

         if available mfc_ctrl and mfc_ctrl.mfc_logical then do:

            if wo_type = "c" and wo_due_date < today then do:
               /* MESSAGE #5124 - CUM ORDER HAS EXPIRED */
               {pxmsg.i
                  &MSGNUM=5124
                  &ERRORLEVEL={&WARNING-RESULT}
                  &PAUSEAFTER=TRUE}
               checkWarning = true.
            end.

            if available wr_route then do:
               if wr_sub_cost = 0 then do:
                  /* MESSAGE #5118 - THERE IS NO SUBCONTRACT COST FOR */
                  /*                 THIS OPERATION                   */
                  {pxmsg.i
                     &MSGNUM=5118
                     &ERRORLEVEL={&WARNING-RESULT}
                     &PAUSEAFTER=TRUE}
                  checkWarning = true.
               end. /* IF wr_sub_cost = 0 */
            end. /* IF AVAILABLE wr_route */
         end. /* IF AVAILABLE mfc_ctrl AND mfc_logical */
      end. /* IF wo_type = "C" */

      if checkWarning then
         return {&WARNING-RESULT}.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePurchaseCost :

/*------------------------------------------------------------------------------
Purpose:       Checks if Purchase Cost is Zero
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   pod_det(r)
        Post:
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define input parameter pPOLineCost as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      if pPOLineCost = 0 then do:
         /* MESSAGE #363 - LINE ITEM HAS NO COST */
         {pxmsg.i
            &MSGNUM=363
            &ERRORLEVEL={&WARNING-RESULT}}
         return {&WARNING-RESULT}.
      end. /* If POLineCost = 0 */
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateRequisitionRequired :

/*------------------------------------------------------------------------------
Purpose:       Validates If requisition is required
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   req_det(r), pod_det(r) , poc_ctrl
       Post:   pac_mstr(r)
Notes:
History:       Extracted from popomta.p
------------------------------------------------------------------------------*/
   define  parameter buffer  pod_det for pod_det.
   define  input  parameter  pIsBlanket           as logical no-undo.

   define variable pPOApprovalCodeRecid as recid   no-undo.
   define buffer poc_ctrl for poc_ctrl.
   define buffer req_det for req_det.
   define buffer pac_mstr for pac_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='readPOControl' &PROGRAM='popoxr.p'
                &HANDLE=ph_popoxr
               &PARAM="(buffer poc_ctrl)"}

      /* EXISTS AND NO REQ ENTERED (NEW POD_DET ONLY) */
      find last req_det where
         req_nbr = pod_req_nbr and
         (req_part = pod_part or req_part = pod_vpart)
      no-lock no-error.

      /* WE DO THIS BLOCK NOW ONLY FOR TRADITIONAL REQ'S */
      {pxgetph.i pxtools}
      if (not available req_det or
          pod_req_nbr = "") and
          {pxfunct.i &FUNCTION='isNewRecord' &PROGRAM='pxtools.p'
                      &HANDLE=ph_pxtools
                     &PARAM="input buffer pod_det:handle"}
      then do:
         /* Approval Code subroutine */
         /* Porqxf.p is a Facade for popomtaa.p */
         {gprun.i ""porqxf.p""
            "(input  pod_nbr,
              input  pod_line,
              input  pIsBlanket,
              output pPOApprovalCodeRecid)"}
      end. /* if not available req_det */

      find pac_mstr where
         recid(pac_mstr) = pPOApprovalCodeRecid
      no-lock no-error.
      if available pac_mstr and poc_apv_req then
         return {&WARNING-RESULT}.

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateShipperExists :

/*------------------------------------------------------------------------------
Purpose:       Validate that a shipper exists.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   NONE
       Post:   purchaseOrderLine(r)
Notes:
History:       Extracted from popomtd.p
------------------------------------------------------------------------------*/
   define input parameter pOrderStatus as character no-undo.
   define input parameter pOrderNumber as character no-undo.
   define input parameter pSiteId      as character no-undo.
   define input parameter pPOLineId    as integer   no-undo.

   /* LOCAL VARIABLES */
   define buffer purchaseOrderLine for pod_det.
   define variable l_conf_ship     as   integer    initial 0 no-undo.
   define variable l_shipper_found as   integer    initial 0 no-undo.
   define variable l_conf_shid     like abs_par_id no-undo.
   define variable l_save_abs      like abs_par_id no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* IF ORDER IS CLOSED OR CANCELLED */
      if pOrderStatus = "c" or
         pOrderStatus = "x" then do:
         if pSiteId <> "*" and pPOLineId <> 0 then do:
            for each purchaseOrderLine no-lock
               where purchaseOrderLine.pod_nbr  = pOrderNumber
               and   purchaseOrderLine.pod_site = pSiteId
               and   purchaseOrderLine.pod_line = pPOLineId :
               /* CHECKS CONFIRMED/UNCONFIRMED SHIPPERS FOR A PO LINE */
               {gprun.i ""rssddelb.p"" "(input purchaseOrderLine.pod_nbr,
                  input purchaseOrderLine.pod_line,
                  input purchaseOrderLine.pod_site,
                  input-output l_shipper_found,
                  input-output l_save_abs,
                  input-output l_conf_ship,
                  input-output l_conf_shid)"}
            end. /* FOR EACH PODDET WHERE PODDET.POD_NBR ... */
         end. /* IF pSiteId <> "*" AND pPOLineId <> 0 */
         else do:
            for each purchaseOrderLine no-lock
               where purchaseOrderLine.pod_nbr  = pOrderNumber:
               /* CHECKS CONFIRMED/UNCONFIRMED SHIPPERS FOR A PO LINE */
               {gprun.i ""rssddelb.p"" "(input purchaseOrderLine.pod_nbr,
                  input purchaseOrderLine.pod_line,
                  input purchaseOrderLine.pod_site,
                  input-output l_shipper_found,
                  input-output l_save_abs,
                  input-output l_conf_ship,
                  input-output l_conf_shid)"}
            end. /* FOR EACH PODDET WHERE PODDET.POD_NBR ... */
         end. /* ELSE */

         if l_shipper_found > 0 then do:
            l_save_abs = substring(l_save_abs,2,20).
            /* MESSAGE #1118 - # SHIPPERS/CONTAINERS EXIST FOR */
            /* ORDER, INCLUDING # */
            {pxmsg.i
               &MSGNUM=1118
               &ERRORLEVEL={&APP-ERROR-RESULT}
               &MSGARG1=l_shipper_found
               &MSGARG2=l_save_abs}
            return error {&APP-ERROR-RESULT}.
          end. /* IF L_SHIPPER_FOUND > 0 */

          /* IF ALL THE SHIPPERS FOR THE ORDER HAVE BEEN CONFIRMED  */
          /* DISPLAY WARNING AND ALLOW TO DELETE ORDER              */
          else if l_conf_ship > 0 then do:
             l_conf_shid = substring(l_conf_shid,2,20).
             /* MESSAGE #3314 - # CONFIRMED SHIPPERS EXIST FOR */
             /* ORDER, INCLUDING # */
             {pxmsg.i
                &MSGNUM=3314
                &ERRORLEVEL={&WARNING-RESULT}
                &MSGARG1=l_conf_ship
                &MSGARG2=l_conf_shid
                &PAUSEAFTER=TRUE}
          end. /* IF L_CONF_SHIP > 0 */
       end. /* IF PO_STAT = "C" OR ... */
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateSiteChanged :

/*------------------------------------------------------------------------------
Purpose:       Validates If the Site was Changed, to warn for a change in Tax                  Environment
Exceptions:    WARNING-RESULT
Conditions:
Pre:
Post:
Notes:
History:       Procedure initially extracted from popomtd.p
------------------------------------------------------------------------------*/
   define input parameter pNewSite as character no-undo.
   define input parameter pOldSite as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pNewSite <> pOldSite then do:
         /* MESSAGE #955 - NEW SITE SPECIFIED; CHECK TAX ENVIRONMENT */
         {pxmsg.i
            &MSGNUM=955
            &ERRORLEVEL={&WARNING-RESULT}}
         return {&WARNING-RESULT}.
      end. /* IF PNEWSITE <> POLDSITE */
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateSubcontractItem :

/*------------------------------------------------------------------------------
Purpose:       Validates if an item can be a sub-contract item on PO Line
Exceptions:    NONE
Conditions:
Pre:
Post:
Notes:
History:       Procedure initially extracted from popomtd.p
------------------------------------------------------------------------------*/
   define input parameter pQtyOrdered as decimal   no-undo.
   define input parameter pItemId     as character no-undo.
   define input parameter pPOType     as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if (pQtyOrdered = 0 or
         not can-find(pt_mstr where pt_part = pItemId)) and
         pPOType = "S"
      then do:
         /* MESSAGE #342 - TYPE (S)UBCONTRACT NOT ALLOWED FOR MEMO */
         /* ITEMS OR ZERO QUANTITIES */
         {pxmsg.i
            &MSGNUM=342
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateSubTypeCode :

/*------------------------------------------------------------------------------
Purpose:       Validate Subcontract Type from Generalized Codes master for
               Subcontracting PO's.
Exceptions:    None
Conditions:
        Pre:   None
       Post:   None
Notes:
History:       Extracted from popomtd1.p
------------------------------------------------------------------------------*/
   define input parameter pSubtype as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
               &PARAM="(input 'subtype',
                       input '',
                       input pSubtype,
                       input '')"
               &FIELD-LIST="SubContract Type"}
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateSupplierSiteItemERSOption :

/*------------------------------------------------------------------------------
Purpose:       Validates the ERS options for a supplier, site and item
               combination
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   po_mstr(r), pod_det(r)
       Post:   None
Notes:
History:       Procedure initially extracted from popomtd.p
------------------------------------------------------------------------------*/
   define input        parameter pSupplierId  as character no-undo.
   define input        parameter pSiteId      as character no-undo.
   define input        parameter pItemId      as character no-undo.
   define input-output parameter pPOERSOption as integer no-undo.

   define variable ersnbr as integer no-undo.
   define variable ersplo as integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='determineERSOption' &PROGRAM='aperxr.p'
                &HANDLE=ph_aperxr
               &PARAM="(input pSupplierId,
                        input pSiteId,
                        input pItemId,
                        output ersnbr,
                        output ersplo)"}

      if return-value <> {&SUCCESS-RESULT} then do:
         pPOERSOption = 1.
         return return-value.
      end.
      else do:
         if pPOERSOption > ersnbr then do:
            /* MESSAGE #2317 - ERS OPTION NOT VALID BASED UPON */
            /*                 SUPPLIER/SITE/ITEM ERS VALUES   */
            {pxmsg.i
               &MSGNUM=2317
               &ERRORLEVEL={&INFORMATION-RESULT}}

            /* MESSAGE #2318 - ERS OPTION MUST BE LESS THAN OR EQUAL TO */
            {pxmsg.i
               &MSGNUM=2318
               &ERRORLEVEL={&APP-ERROR-RESULT}
               &MSGARG1="string(ersnbr)"}

            return error {&APP-ERROR-RESULT}.
         end.
      end. /* ELSE */
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateQuantityOrdered :

/*------------------------------------------------------------------------------
Purpose:       Validates for Zero or Negative Quantity
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   po_mstr(r), pod_det(r)
       Post:   None
Notes:
History:       Procedure initially extracted from popomth.p
------------------------------------------------------------------------------*/
define input parameter pQuantityOrdered as decimal no-undo.

    if pQuantityOrdered <= 0 then do:
       /* MESSAGE #331 - ORDER QUANTITY LESS THAN ZERO - RETURN */
       /* ITEMS TO SUPPLIER */
       /* MESSAGE #332 - ORDER QUANTITY IS ZERO */
       {pxmsg.i
          &MSGNUM="(if pQuantityOrdered < 0 then 331 else 332)"
          &ERRORLEVEL={&WARNING-RESULT}}
    end. /* IF pQuantityOrdered <= 0 */

END PROCEDURE.

/*============================================================================*/
PROCEDURE redefaultPurchaseAccount:

/*------------------------------------------------------------------------------
Purpose: Re-default purchases account using PO vendor
         See if this is a stocked item or a memo item
Exceptions:    None
Conditions:
        Pre:
       Post:   None
Notes:
History:       New for PO/WO accounting from EIDG.
------------------------------------------------------------------------------*/
   define input  parameter pAccountType          as character no-undo.
   define input  parameter pSiteId               as character no-undo.
   define input  parameter pSupplierId           as character no-undo.
   define input  parameter pItemId               as character no-undo.
   define output parameter pPurchaseAccount      as character no-undo.
   define output parameter pPurchaseSubAccount   as character no-undo.
   define output parameter pPurchaseCostCenter   as character no-undo.

   define buffer pt_mstr for pt_mstr.
   define buffer vd_mstr for vd_mstr.
   define buffer gl_ctrl for gl_ctrl.

   {pxrun.i &PROC ='processRead' &PROGRAM='adsuxr.p'
            &HANDLE=ph_adsuxr
            &PARAM="(input pSupplierId,
                     buffer vd_mstr,
                     input {&NO_LOCK_FLAG},
                     input {&NO_WAIT_FLAG})"}

   {pxrun.i &PROC ='processRead' &PROGRAM='ppitxr.p'
            &HANDLE=ph_ppitxr
            &PARAM="(input pItemId,
                     buffer pt_mstr,
                     input {&NO_LOCK_FLAG},
                     input {&NO_WAIT_FLAG})"}


   if return-value = {&SUCCESS-RESULT} then do:
      /* This is a stocked item  */
      /* Find default for purchases acct */
      {gprun.i ""glactdft.p""
          "(input pAccountType,
            input pt_prod_line,
            input pSiteId,
            input if available vd_mstr then vd_type else """",
            input """",
            input yes,
            output pPurchaseAccount,
            output pPurchaseSubAccount,
            output pPurchaseCostCenter)"}
   end.
   else if return-value = {&RECORD-NOT-FOUND} then do:
      /* This is a non-stocked memo item */
      /* Find default for purchases acct */
      if available vd_mstr then
         assign
            pPurchaseAccount    = vd_pur_acct
            pPurchaseSubAccount = vd_pur_sub
            pPurchaseCostCenter = vd_pur_cc.
      else do:
         for first gl_ctrl
            fields(gl_pur_acct gl_pur_sub gl_pur_cc)
            no-lock:
         assign
            pPurchaseAccount    = gl_pur_acct
            pPurchaseSubAccount = gl_pur_sub
            pPurchaseCostCenter = gl_pur_cc.
         end.
      end.
   end.  /* not available pt_mstr */
END PROCEDURE.
