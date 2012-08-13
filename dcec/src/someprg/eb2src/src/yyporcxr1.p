/* porcxr1.p - Purchase Order Receipts Line Responsiblity Owning Procedure.   */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.25 $                                                          */
/*                                                                            */
/* Purchase Order Receipts Line Responsiblity Owning Procedure.               */
/*                                                                            */
/* Revision: 1.3       BY: Zheng Huang            DATE: 07/12/00  ECO: *N0DK* */
/* Revision: 1.4       BY: Mark Brown             DATE: 08/13/00  ECO: *N0KQ* */
/* Revision: 1.8       BY: Markus Barone          DATE: 08/13/00  ECO: *N0R3* */
/* Revision: 1.11      BY: Markus Barone          DATE: 09/11/00  ECO: *N0HS* */
/* Revision: 1.12      BY: Nikita Joshi           DATE: 11/07/00  ECO: *L15J* */
/* Revision: 1.13      BY: Larry Leeth            DATE: 12/14/00  ECO: *N0V1* */
/* Revision: 1.14      BY: Ravikumar K            DATE: 12/20/00  ECO: *L16V* */
/* Revision: 1.15      BY: Katie Hilbert          DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.19      BY: Hareesh V              DATE: 08/06/01  ECO: *M1GV* */
/* Revision: 1.20      BY: Steve Nugent           DATE: 04/17/02  ECO: *P043* */
/* Revision: 1.21      BY: Dan Herman             DATE: 05/17/02  ECO: *P06Q* */
/* Revision: 1.23      BY: Tiziana Giustozzi      DATE: 06/20/02  ECO: *P093* */
/* Revision: 1.24      BY: Robin McCarthy         DATE: 07/15/02  ECO: *P0BJ* */
/* $Revision: 1.25 $   BY: Deepali Kotavadekar    DATE: 01/24/03  ECO: *N23Y* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
/*V8:ConvertMode=NoConvert                                                    */
 /* $Revision: eb2+sp7  BY: Steve judy Liu    DATE: 05/08/12  ECO: *judy*     */
/* Define Handles for the programs. */
{pxphdef.i clalxr}
{pxphdef.i icinxr}
{pxphdef.i icisdxr}
{pxphdef.i icsixr}
{pxphdef.i mcexxr}
{pxphdef.i mcpl}
{pxphdef.i popoxr}
{pxphdef.i porcxr}
{pxphdef.i ppitxr}
{pxphdef.i ppsuxr}
{pxphdef.i pxgblmgr}
{pxphdef.i rewoxr}
{pxphdef.i rsscxr}
{pxphdef.i txtxxr}
{pxphdef.i wowoxr}
{pxphdef.i wowrxr}
/* End Define Handles for the programs. */

/* ========================================================================== */
/* ******************************* DEFINITIONS ****************************** */
/* ========================================================================== */

/* STANDARD INCLUDE FILES */
{mfdeclre.i}
{pxmaint.i}
{porcdefx.i}
{gprunpdf.i "mcpl" "p"}
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */

define temp-table   tt_pvo_mstr  no-undo like pvo_mstr.

/* ========================================================================== */
/* ******************************* MAIN BLOCK ******************************* */
/* ========================================================================== */

FUNCTION isPRMRequiredForLine returns logical
      (input pPurchaseOrderId as character,
      input pPurchaseOrderLineId as integer):

/*------------------------------------------------------------------------------
Purpose:       Determines if PRM is required to process a PO receipt line
Exceptions:    None
Conditions:
Pre:   pod_det(r)
Post:
Notes:
History:
------------------------------------------------------------------------------*/
   define variable returnData as logical initial false no-undo.

   /* CHECK IF PRM IS INSTALLED */
   {pjchkprm.i}

   if can-find(pod_det where
      pod_nbr =  pPurchaseOrderId     and
      pod_line = pPurchaseOrderLineId and
      pod_project  <> ""              and
      pod_pjs_line <> 0               and
      prm-enabled)
      then
      returnData = true.

   return (returnData).

END FUNCTION.

/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE initializeAttributes:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
initializeAttributes (
buffer pPod_det,
output decimal pAssay,
output character pGrade,
output date pExpireDate,
output character pInventoryStatus,
output logical pAssayActive,
output logical pGradeActive,
output logical pExpireDateActive,
output logical pInventoryStatusActive)

Parameters:
pPod_det -
pAssay -
pGrade -
pExpireDate -
pInventoryStatus -
pAssayActive -
pGradeActive -
pExpireDateActive -
pInventoryStatusActive -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define parameter buffer pPod_det for pod_det.
   define input  parameter pEffectiveDate as date no-undo.
   define output parameter pAssay as decimal no-undo.
   define output parameter pGrade as character no-undo.
   define output parameter pExpireDate as date no-undo.
   define output parameter pInventoryStatus as character no-undo.
   define output parameter pAssayActive as logical no-undo.
   define output parameter pGradeActive as logical no-undo.
   define output parameter pExpireDateActive as logical no-undo.
   define output parameter pInventoryStatusActive as logical no-undo.
   define output parameter pErrorFlag  as logical no-undo.

   define buffer pt_mstr for pt_mstr.
   define buffer in_mstr for in_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      assign
         pAssay                  = pPod_det.pod_assay
         pGrade                  = pPod_det.pod_grade
         pExpireDate             = pPod_det.pod_expire
         pInventoryStatus        = pPod_det.pod_rctstat
         pAssayActive            = yes
         pGradeActive            = yes
         pExpireDateActive       = yes
         pInventoryStatusActive  = yes.

      if pod_rctstat_active = no then do:
         {pxrun.i &PROC='processRead' &PROGRAM='icinxr.p'
                  &HANDLE=ph_icinxr
                  &PARAM="(input  pPod_det.pod_part,
                           input  pPod_det.pod_site,
                           buffer in_mstr,
                           input  {&NO_LOCK_FLAG},
                           input  {&NO_WAIT_FLAG})"}

         if return-value = {&SUCCESS-RESULT} and
            in_rctpo_active = yes then
            pInventoryStatus = in_rctpo_status.
         else do:
            {pxrun.i &PROC='processRead' &PROGRAM='ppitxr.p'
                     &HANDLE=ph_ppitxr
                     &PARAM="(input  pPod_det.pod_part,
                              buffer pt_mstr,
                              input  {&NO_LOCK_FLAG},
                              input  {&NO_WAIT_FLAG})"}

            if return-value = {&SUCCESS-RESULT} and
               pt_mstr.pt_rctpo_active = yes then
               pInventoryStatus = pt_rctpo_status.
            else
            assign
               pInventoryStatus  = ""
               pInventoryStatusActive = no.
         end. /* ELSE DO: */

      end. /* IF POD_RCTSTAT_ACTIVE = NO */

      /*TEST FOR ATTRIBUTE CONFLICTS*/
      {gprun.i ""porcat01.p""
            "(input recid(pPod_det),
              input pPod_det.pod_site,
              input pPod_det.pod_loc,
              input """",
              input """",
              input pEffectiveDate,
              input-output pAssay,
              input-output pGrade,
              input-output pExpireDate,
              input-output pInventoryStatus,
              input-output pAssayActive,
              input-output pGradeActive,
              input-output pExpireDateActive,
              input-output pInventoryStatusActive,
              output pErrorFlag)"}
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/* extract from poporca.p */
/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE assignDefaultsForNewLine:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
assignDefaultsForNewLine (
Buffer pPod_det,
input pReceiveAll,
output logical pCancelBackOrder)

Parameters:
pPod_det -
pReceiveAll -
pCancelBackOrder -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define parameter buffer pPod_det for pod_det.
   define input  parameter pReceiveAll as logic no-undo.
   define output parameter pCancelBackOrder as logical no-undo.
   define output parameter pSiteId as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if not pReceiveAll then
      assign
         pod_qty_chg  = 0
         pod_bo_chg   = pod_qty_ord - pod_qty_rcvd.
      assign
         pod_ps_chg       = pod_qty_chg
         pod_rum          = pod_um
         pod_rum_conv     = 1
         pCancelBackOrder = can-find(first poc_ctrl where poc_ln_stat = "x")
         psiteid          = pod_site.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE getOpenQuantity:
/*------------------------------------------------------------------------------
Purpose:       Get Open Quantity ( = quantity order - quantity received )
porcxr1.p
getOpenQuantity (
input decimal pQuantityOrdered,
input decimal pQuantityReceived,
output decimal pQuantityOpen)

Parameters:
pQuantityOrdered -
pQuantityReceived -
pQuantityOpen -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input  parameter pQuantityOrdered as decimal no-undo.
   define input  parameter pQuantityReceived as decimal no-undo.
   define output parameter pQuantityOpen as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      assign
         pQuantityOpen  =  pQuantityOrdered - pQuantityReceived.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE getReceiptUMConversion:
/*------------------------------------------------------------------------------
Purpose:       Get PO receipts unit of measure conversion.
porcxr1.p
getReceiptUMConversion (
input character pReceiptUM,
output decimal pUMConversion,
Buffer pPt_mstr,
Buffer pPod_det,
output decimal pTransConv)

Parameters:
pReceiptUM -
pUMConversion -
pPt_mstr -
pPod_det -
pTransConv -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pReceiptUM as character no-undo.
   define input parameter pUMConversion as decimal no-undo.
   define  parameter buffer pPt_mstr for pt_mstr.
   define  parameter buffer pPod_det for pod_det.
   define output parameter pTransConv as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      pTransConv = if available pPt_mstr and pReceiptUM = pt_um
         then
      1
      else pUMConversion * pod_um_conv.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE getScheduleOpenQuantity:
/*------------------------------------------------------------------------------
Purpose:       Calculate open quantity in a schedule as-of a day.
porcxr1.p
getScheduleOpenQuantity (
Buffer pPod_det,
input date pEffectiveDate,
output decimal pQuantityOpen)

Parameters:
pPod_det -
pEffectiveDate -
pQuantityOpen -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define  parameter buffer pPod_det for pod_det.
   define input parameter pEffectiveDate as date no-undo.
   define input-output parameter pQuantityOpen as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pod_sched then do:
         {gprun.i ""rsoqty.p""
            "(input recid(pPod_det),
              input pEffectiveDate,
              output pQuantityOpen)"}
      end. /* IF POD_SCHED */
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE getUMConversionToPOLine:
/*------------------------------------------------------------------------------
Purpose:       Get unit of measure conversion to PO line.
porcxr1.p
getUMConversionToPOLine (
input character pReceiptUM,
Buffer pPod_det,
output decimal pUMConversion,
output logical pUsePOUMConversion)

Parameters:
pReceiptUM -
pPod_det -
pUMConversion -
pUsePOUMConversion -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pReceiptUM as character no-undo.
   define  parameter buffer pPod_det for pod_det.
   define output parameter pUMConversion as decimal no-undo.
   define output parameter pUsePOUMConversion as logical no-undo.

   define variable vPtUM like pt_um no-undo.
   define variable vAvailablePt_mstr as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      assign
         pUMConversion  = 1
         pUsePOUMConversion = no.

      {pxrun.i &PROC='getUnitOfMeasure' &PROGRAM='ppitxr.p'
               &HANDLE=ph_ppitxr
               &PARAM="(input  pod_part,
                        output vPtUM)"
               &CATCHERROR=true
      }

      if return-value = {&SUCCESS-RESULT} then do:
         vAvailablePt_mstr = yes.
         if pReceiptUM = vPtUM then
         assign
            pUsePOUMConversion = yes
            pUMConversion  = 1 / pod_um_conv.
      end. /* IF AVAILABLE PT_MSTR */
      else vAvailablePt_mstr = no.

      if pReceiptUM <> pod_um then do:
         /*LOOK FOR RCPT UM TO LINE ITEM UM CONV*/
         {gprun.i ""gpumcnv.p""
            "(input pReceiptUM,
                    input pod_um,
                    input pod_part,
                    output pUMConversion)"}
         if pUMConversion = ? then do:
            /*NOT FOUND, LOOK FOR RCPT UM TO STOCKING UM CONV*/

            if vAvailablePt_mstr then do:
               {gprun.i ""gpumcnv.p""
                  "(input pReceiptUM,
                          input vPtUM,
                          input pod_part,
                          output pUMConversion)"}

               if pUMConversion <> ? then
               /*CHG RCPT-TO-STKG-UM-CONV TO RCPT-TO-LINEITEM-CONV*/
               pUMConversion =  pUMConversion / pod_um_conv.

            end. /* IF AVAILABLE PT_MSTR */
         end. /* IF pUMConversion = ? */
      end. /* IF pReceiptUM <> POD_UM */

      if pUMConversion = ? then do:
         /* MESSAGE #33 - NO UNIT OF MEASURE CONVERSION EXISTS */
         {pxmsg.i
            &MSGNUM=33
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE setAutoLotNumber:
/*------------------------------------------------------------------------------
Purpose:       Set Autolot number.
porcxr1.p
setAutoLotNumber (
Buffer pPod_det,
input logical pReceive,
input-output character pNewLot,
output pTransactionSuccessful)

Parameters:
pPod_det -
pReceive -
pNewLot -
pTransactionSuccessful -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define  parameter buffer pPod_det for pod_det.
   define input parameter pReceive as logical no-undo.
   define input-output parameter pNewLot as character no-undo.
   define output parameter pTransactionSuccessful as logical no-undo.

   define buffer pt_mstr for pt_mstr.
   define buffer alm_mstr for alm_mstr.
   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      pTransactionSuccessful = true.

      {pxrun.i &PROC='processRead' &PROGRAM='ppitxr.p'
               &HANDLE=ph_ppitxr
               &PARAM="(input pod_part,
                        buffer pt_mstr,
                        input {&NO_LOCK_FLAG},
                        input {&NO_WAIT_FLAG})"}
      if return-value = {&SUCCESS-RESULT} then do:
         {pxgetph.i ppitxr}
         if {pxfunct.i &FUNCTION='isAutoLotControlled' &PROGRAM='ppitxr.p'
                       &HANDLE=ph_ppitxr
                       &PARAM="input pod_type,
                               input pod_part"}
            and pReceive then do:
            {pxrun.i &PROC='readLotFormat' &PROGRAM='clalxr.p'
                     &HANDLE=ph_clalxr
                     &PARAM="(input pt_lot_grp,
                              input pod_site,
                              buffer alm_mstr)"
                     &CATCHERROR=true
            }
        if return-value <> {&SUCCESS-RESULT} then do:
               /* LOT FORMAT DOES NOT EXIST */
               {pxmsg.i
                  &MSGNUM=2737
                  &ERRORLEVEL={&APP-ERROR-RESULT}}
               return error {&APP-ERROR-RESULT}.
            end.
            else do:
               {pxrun.i &PROC='setNewLotNumber' &PROGRAM='clalxr.p'
                        &HANDLE=ph_clalxr
                        &PARAM="(buffer alm_mstr,
                                 buffer pPod_det,
                                 input-output pNewLot,
                                 output pTransactionSuccessful)"
                        &CATCHERROR=true
               }
               if return-value <> {&SUCCESS-RESULT} then
                  return error {&APP-ERROR-RESULT}.

               release alm_mstr.
            end.  /* IF NEW LOT = "" */
         end.  /* IF (PT_LOT_SER = "L" AND PT_AUTO_LOT = YES */
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE setBackOrder:
/*------------------------------------------------------------------------------
Purpose:       Set Back order.
porcxr1.p
setBackOrder (
input logical pCancelBO,
input decimal pTotalReceived,
input date pEffectiveDate,
input decimal pUMConversion,
Buffer pPod_det,
input decimal pLotSerialQuantity,
output decimal pQuantityOpen,
)

Parameters:
pCancelBO -
pTotalReceived -
pEffectiveDate -
pUMConversion -
pPod_det -
pLotSerialQuantity -
pQuantityOpen -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input  parameter pCancelBO as logical no-undo.
   define input  parameter pTotalReceived as decimal no-undo.
   define input  parameter pEffectiveDate as date no-undo.
   define input  parameter pUMConversion as decimal no-undo.
   define parameter buffer pPod_det for pod_det.
   define input  parameter pLotSerialQuantity as decimal no-undo.
   define input-output parameter pQuantityOpen as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pCancelBO then
         pod_bo_chg = 0.
      else
         pod_bo_chg = pod_qty_ord - pTotalReceived.

      if not pCancelBO and pod_sched then
   do:
         {gprun.i ""rsoqty.p""
            "(input  recid(pPod_det),
                    input  pEffectiveDate,
                    output pQuantityOpen)"}
         pod_bo_chg =
         max(0,pQuantityOpen - pLotSerialQuantity * pUMConversion).
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE setReceiptSite:
/*------------------------------------------------------------------------------
Purpose:       Set Receipt Site.
porcxr1.p
setReceiptSite (
Buffer pPod_det,
Buffer pWo_mstr,
output character pReceiptSite)

Parameters:
pPod_det -
pWo_mstr -
pReceiptSite -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define  parameter buffer pPod_det for pod_det.
   define  parameter buffer pWo_mstr for wo_mstr.
   define output parameter pReceiptSite as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if available pPod_det then
         pReceiptSite = pPod_det.pod_site.
      else
         if available pWo_mstr and index("FPC", pWo_mstr.wo_status) = 0 then
         pReceiptSite = pWo_mstr.wo_site.
      else
         return error {&APP-ERROR-RESULT}.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE setTotalReceived:
/*------------------------------------------------------------------------------
Purpose:       Set Total received.
porcxr1.p
setTotalReceived (
input logical pUsePOUMConversion,
input decimal pLotSerialQty,
input decimal pUMConversion,
input decimal pQuantityReceived,
input decimal pUMConv,
output decimal pTotalReceived)

Parameters:
pUsePOUMConversion -
pLotSerialQty -
pUMConversion -
pQuantityReceived -
pUMConv -
pTotalReceived -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pUsePOUMConversion as logical no-undo.
   define input parameter pLotSerialQty as decimal no-undo.
   define input parameter pUMConversion as decimal no-undo.
   define input parameter pQuantityReceived as decimal no-undo.
   define input parameter pUMConv as decimal no-undo.
   define output parameter pTotalReceived as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pUsePOUMConversion then
      pTotalReceived = pQuantityReceived
      + (pLotSerialQty / pUMConv).
      else
      pTotalReceived = pQuantityReceived
      + (pLotSerialQty * pUMConversion).
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE validateRestrictedTrans:
/*------------------------------------------------------------------------------
Purpose:       Validate restricted transaction.
porcxr1.p
validateRestrictedTrans (
Buffer pPt_mstr,
input character pReceiptType,
input character pTransType)

Parameters:
pPt_mstr -
pReceiptType -
pTransType -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define  parameter buffer pPt_mstr for pt_mstr.
   define input parameter pReceiptType as character no-undo.
   define input parameter pTransType as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ICEDIT PERFORMS CHECK AGAINST RECEIPT WHICH AFFECT     */
      /* INVENTORY.TO RESTRICT THE RECEIPT WHEN PO LINE IS      */
      /* EITHER OF TYPE "S" (SUBCONTRACT) OR TYPE "M" (MEMO),   */
      /* WHICH DOES NOT AFFECTS UPDATE INVENTORY.               */

      {pxgetph.i icisdxr}
      if (pReceiptType = "M" or pReceiptType = "S") and available pPt_mstr
         and
         ({pxfunct.i &FUNCTION='isRestrictedTrans' &PROGRAM='icisdxr.p'
                     &HANDLE=ph_icisdxr
                     &PARAM="input pt_status, input pTransType"})
      then do:
         /* RESTRICTED TRANSACTION FOR STATUS CODE */
         {pxmsg.i
            &MSGNUM=373
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &MSGARG1="pt_status"}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE validateSiteId:
/*------------------------------------------------------------------------------
Purpose:    Validate PO Receipt line site
validateSiteId(
input character pSiteId)
Parameters:
pSiteId -
Exceptions:    NONE
PreConditions:
PostConditions:
</Comment1>
<Comment2>
Notes:          Pulled from schema for pod_site.
</Comment2>
<Comment3>
History:
</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pSiteId as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i  &PROC='validateSite'  &PROGRAM='icsixr.p'
                &HANDLE=ph_icsixr
                &PARAM="(input '',
                         input pSiteId,
                         input no,
                         input '')"}
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE validateSiteDatabase:
/*------------------------------------------------------------------------------
Purpose:       Validate site database.
porcxr1.p
validateSIteDatabase (
input character pSiteId)

Parameters:
pSiteId -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pSiteId as character no-undo.

   define variable vSiteDB like si_db no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='getSiteDatabase' &PROGRAM='icsixr.p'
               &HANDLE=ph_icsixr
               &PARAM="(input pSiteId,
                        output vSiteDB)"
               &CATCHERROR=true
      }

      {pxgetph.i pxgblmgr}

      if return-value <> {&SUCCESS-RESULT} or
         vSiteDB <>
         ({pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                     &HANDLE=ph_pxgblmgr
                     &PARAM="input 'global_db'"})
      then do:
         /* SITE NOT ASSIGNED TO THIS DATABASE */
         {pxmsg.i
            &MSGNUM=5421
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE validateStatusId:
/*------------------------------------------------------------------------------
Purpose:       validate status ID.
porcxr1.p
validateStatusId (
input character pLineStatus)

Parameters:
pLineStatus -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pLineStatus as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pLineStatus = "c" or pLineStatus = "x" then do:
         /* MESSAGE #336 - PURCHASE ORDER LINE IS CLOSED OR CANCELLED - */
         {pxmsg.i
            &MSGNUM=336
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &MSGARG1=pLineStatus}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/* extract from poporca3.p */
/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE checkOpenVouchers:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
checkOpenVouchers (
input logical pPODetailScheduled,
input character pPurchaseOrderId,
input integer pPurchaseOrderLineId)

Parameters:
pPODetailScheduled -
pPurchaseOrderId -
pPurchaseOrderLineId -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
The new Pending Voucher table holds the information needed for
the check on open vouchers. This procedure has been re-written
to use the new Pending Voucher table (pvo_mstr).
------------------------------------------------------------------------------*/
   define input parameter pPODetailScheduled as logical no-undo.
   define input parameter pPurchaseOrderId as character no-undo.
   define input parameter pPurchaseOrderLineId as integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* But NOT for Supplier Schedules */
      if not pPODetailScheduled then
         for each pvo_mstr
            where pvo_order = pPurchaseOrderId and
            pvo_line = pPurchaseOrderLineId and
            pvo_last_voucher <> "" no-lock:

         for first ap_mstr fields(ap_open ap_ref ap_type)
               where ap_type = "VO" and
               ap_ref  = pvo_last_voucher no-lock:
         end. /* FOR FIRST AP_MSTR */

         if available ap_mstr and ap_open = yes then do:
            /* PO RECEIPT PREVIOUSLY VOUCHERED, REFERENCE: */
            {pxmsg.i &MSGNUM=2204
               &ERRORLEVEL={&WARNING-RESULT}
               &MSGARG1=pvo_internal_ref
               }
            return {&WARNING-RESULT} .
         end.

      end.

   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/* extract from poporca2.p */
/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE defaultSubcontractOperation:
/*------------------------------------------------------------------------------
Purpose:       get default subcontract operation.
porcxr1.p
defaultSubcontractOperation (
input-output integer pWorkOrderOperation)

Parameters:
pWorkOrderOperation -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input-output parameter pWorkOrderOperation as integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* EDIT OPERATION DATA ONLY IF WORK ORDER EXISTS */
      if pWorkOrderOperation = ? then pWorkOrderOperation = 0.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE setSubcontractOperation:
/*------------------------------------------------------------------------------
Purpose:       Set subcontract operation.
porcxr1.p
setSubcontractOperation (
Buffer pPod_det,
input character pWorkOrderId,
input integer pWorkOrderOperation)

Parameters:
pPod_det -
pWorkOrderId -
pWorkOrderOperation -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define  parameter buffer pPod_det for pod_det.
   define input parameter pWorkOrderId as character no-undo.
   define input parameter pWorkOrderOperation as integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      assign
         pod_wo_lot = pWorkOrderId
         pod_op     = pWorkOrderOperation.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE validateSubcontractOperation:
/*------------------------------------------------------------------------------
Purpose:       validate subcontract operation.
porcxr1.p
validateSubcontractOperation (
Buffer pWr_route,
input character pWOStatus,
input character pWOType,
input character pWONumber,
output logical pOperationExist)

Parameters:
pWr_route -
pWOStatus -
pWOType -
pWONumber -
pOperationExist -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define parameter buffer pWr_route for wr_route.
   define input  parameter pWOStatus as character no-undo.
   define input  parameter pWOType as character no-undo.
   define input  parameter pWONumber as character no-undo.

   define variable vRetVal as character initial {&SUCCESS-RESULT}.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      if available pWr_route and pWr_route.wr_status = "c" then do:
         /* MESSAGE #524 - WORK ORDER OPERATION IS CLOSED */
         {pxmsg.i
            &MSGNUM=524
            &ERRORLEVEL={&WARNING-RESULT}}
         vRetVal = {&WARNING-RESULT}.
      end.
      {pxgetph.i wowrxr}
      {pxgetph.i rewoxr}

      if {pxfunct.i &FUNCTION = 'isSubcontractOperationMissing'
                    &PROGRAM = 'wowrxr.p'
                    &HANDLE=ph_wowrxr
                    &PARAM="input (available pWr_route),
                            input pWOStatus"}
         and
         {pxfunct.i &FUNCTION = 'isRepetitiveProduction'
                    &PROGRAM = 'rewoxr.p'
                    &HANDLE=ph_rewoxr
                    &PARAM="input pWOType,
                            input pWONumber"}
      then do:
         /* MESSAGE #106 - OPERATION DOES NOT EXIST */
         {pxmsg.i
            &MSGNUM=106
            &ERRORLEVEL={&WARNING-RESULT}}
         vRetVal = {&WARNING-RESULT}.
      end.

   end.
   return vRetVal.
END PROCEDURE.

/*============================================================================*/
PROCEDURE validateSubcontractWorkOrder:
/*------------------------------------------------------------------------------
Purpose:       validate subcontract work order.
porcxr1.p
validateSubcontractWorkOrder (
Buffer pWo_mstr,
input character pItemId,
input character pPurchaseOrderProject,
input logical pWorkOrderLotExist,
input character pReceiptSite)

Parameters:
pWo_mstr -
pItemId -
pPurchaseOrderProject -
pWorkOrderLotExist -
pReceiptSite -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define parameter buffer pWo_mstr for wo_mstr.
   define input  parameter pItemId as character no-undo.
   define input  parameter pPurchaseOrderProject as character no-undo.
   define output parameter pWorkOrderLotExists as logical no-undo.

   define buffer pod_det for pod_det.
   define variable vRetVal as character initial {&SUCCESS-RESULT}.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if not available pWo_mstr or pWo_mstr.wo_lot = "" then do:
         /* WORK ORDER LOT DOES NOT EXIST */
         {pxmsg.i
            &MSGNUM=510
            &ERRORLEVEL={&WARNING-RESULT}}
         assign vRetVal = {&WARNING-RESULT}
            pWorkOrderLotExists = no.
      end.
      else do:
         pWorkOrderLotExists = yes.

         if pItemId <> pWo_mstr.wo_part then do:
            /* MESSAGE #692 - WORK ORDER IS FOR ITEM NUMBER */
            {pxmsg.i
               &MSGNUM=692
               &ERRORLEVEL={&WARNING-RESULT}
               &MSGARG1=pWo_mstr.wo_part}
            assign vRetVal = {&WARNING-RESULT}.
         end.
         if pWo_mstr.wo_joint_type <> "" then do:
            /* JOINT WORK ORDER MAY NOT BE SUBCONTRACTED */
            {pxmsg.i
               &MSGNUM=6517
               &ERRORLEVEL={&APP-ERROR-RESULT}}
            return error {&APP-ERROR-RESULT}.
         end.

         /* WO STATUS IS CLOSED, PLANNED OR FIRM PLANNED */
         if index ("FPC",pWo_mstr.wo_status) <> 0 then do:
            /* WORK ORDER ID IS CLOSED, PLANNED OR FIRM PLANNED */
            {pxmsg.i
               &MSGNUM=523
               &ERRORLEVEL={&WARNING-RESULT}}
            assign vRetVal = {&WARNING-RESULT}.
         end.
         /* WORK ORDER LOT IS SCHEDULED WORK ORDER */
         if index ("S",pWo_mstr.wo_type) <> 0 then do:
            {pxmsg.i
               &MSGNUM=506
               &ERRORLEVEL={&WARNING-RESULT}}
            assign vRetVal = {&WARNING-RESULT}.
         end.
         /* WO PROJECT DOES NOT MATCH PO PROJECT */
         if pWo_mstr.wo_project <> pPurchaseOrderProject then do:
            {pxmsg.i
               &MSGNUM=553
               &ERRORLEVEL={&WARNING-RESULT}}
            assign vRetVal = {&WARNING-RESULT}.
         end.
      end.
   end.
   return vRetVal.
END PROCEDURE.

/* extract from porcat02.p */
/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE defaultExpireDate:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
defaultExpireDate (
input character pItemId,
input date pEffectiveDate,
input-output date pExpireDate)

Parameters:
pItemId -
pEffectiveDate -
pExpireDate -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pItemId as character no-undo.
   define input parameter pEffectiveDate as date no-undo.
   define input-output parameter pExpireDate as date no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      for first pt_mstr fields (pt_part pt_shelflife)
            where pt_part = pItemId no-lock:
      end. /* FOR FIRST PT_MSTR */

      if pExpireDate = ? and available pt_mstr and pt_shelflife <> 0
         then pExpireDate = pEffectiveDate + pt_shelflife.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*hze*/
/*============================================================================*/
PROCEDURE setAttributes:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
setAttributes (
Buffer pPod_det,
input decimal pAssay,
input character pGrade,
input date pExpireDate,
input character pInventoryStatus,
input logical pInventoryStatusActive,
input logical pAssayActive,
input logical pGradeActive,
input logical pExpireDateActive)

Parameters:
pPod_det -
pAssay -
pGrade -
pExpireDate -
pInventoryStatus -
pInventoryStatusActive -
pAssayActive -
pGradeActive -
pExpireDateActive -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define parameter buffer pPod_det for pod_det.
   define input  parameter pAssay as decimal no-undo.
   define input  parameter pGrade as character no-undo.
   define input  parameter pExpireDate as date no-undo.
   define input  parameter pInventoryStatus as character no-undo.
   define input  parameter pInventoryStatusActive as logical no-undo.
   define input  parameter pAssayActive as logical no-undo.
   define input  parameter pGradeActive as logical no-undo.
   define input  parameter pExpireDateActive as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      if pAssayActive  then pod_assay = pAssay.
      else pod_assay = 0.

      if pGradeActive  then pod_grade = pGrade.
      else pod_grade = "".

      if pExpireDateActive then pod_expire = pExpireDate.
      else pod_expire = ?.

      if pInventoryStatusActive then pod_rctstat = pInventoryStatus.
      else pod_rctstat = "".

      pod_rctstat_active = pInventoryStatusActive.

   end.

   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE validateInventoryStatus:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
validateInventoryStatus (
input character pInventoryStatus)

Parameters:
pInventoryStatus -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pInventoryStatus as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if not can-find(is_mstr where is_status = pInventoryStatus) then do:
         /*STATUS DOES NOT EXIST*/
         {pxmsg.i &MSGNUM     = 362
            &ERRORLEVEL = {&APP-ERROR-RESULT}
            }
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/* extract from poporca6.p */
/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE checkRepetitiveQueueQty:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
checkRepetitiveQueueQty (
input character pPurchaseOrderId,
input character pWorkOrderLot,
input integer pWorkOrderOperation,
input logical pMove)

Parameters:
pPurchaseOrderId -
pWorkOrderLot -
pWorkOrderOperation -
pMove -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pPurchaseOrderId as character no-undo.
   define input parameter pWorkOrderLot as character no-undo.
   define input parameter pWorkOrderOperation as integer no-undo.
   define input parameter pMove as logical no-undo.

   define buffer wo_mstr for wo_mstr.
   define buffer wr_route for wr_route.

   define variable qty_chg              as decimal  no-undo.
   define variable input_que_op_to_ck   as integer  no-undo.
   define variable input_que_qty_chg    as decimal  no-undo.
   define variable vMove                as logical  no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='processRead' &PROGRAM='wowoxr.p'
               &HANDLE=ph_wowoxr
               &PARAM="(input  pWorkOrderLot,
                        buffer wo_mstr,
                        input  {&NO_LOCK_FLAG},
                        input  {&NO_WAIT_FLAG})"
      }
      if return-value <> {&SUCCESS-RESULT} then
         return return-value.

      {pxrun.i &PROC='readOperationForFirstWOID' &PROGRAM='wowrxr.p'
               &HANDLE=ph_wowrxr
               &PARAM="(input  pWorkOrderLot,
                        input  pWorkOrderOperation,
                        buffer wr_route,
                        input  {&NO_LOCK_FLAG},
                        input  {&NO_WAIT_FLAG})"
         }
      if return-value <> {&SUCCESS-RESULT} then
         return return-value.

      if pMove = ? then
         vMove = wr_mv_nxt_op.
      else
         vMove = pMove.
      {pxgetph.i rewoxr}

      if not {pxfunct.i &FUNCTION='isRepetitiveProduction' &PROGRAM='rewoxr.p'
                        &HANDLE=ph_rewoxr
                        &PARAM="input wo_type,
                                input wo_nbr"}
         then
         return.

      {pxrun.i &PROC='validateSubcontractCost' &PROGRAM='wowrxr.p'
               &HANDLE=ph_wowrxr
               &PARAM="(input wr_sub_cost)"
      }

      {pxrun.i &PROC='getQtyReceivedOnWO'
               &PARAM="(input  pPurchaseOrderId,
                        input  pWorkOrderLot,
                        input  pWorkOrderOperation,
                        output qty_chg)"
      }

      /*DETERMINE INPUT QUE pWorkOrderOperation TO CHECK;
      COULD BE PRIOR NONMILESTONES*/
      {gprun.i ""reiqchg.p"" "(input pWorkOrderLot,
                               input pWorkOrderOperation,
                               input qty_chg,
                               output input_que_op_to_ck,
                               output input_que_qty_chg)"
      }

      {pxrun.i &PROC='validateQueueQty' &PROGRAM='rewoxr.p'
               &HANDLE=ph_rewoxr
               &PARAM="(input pWorkOrderLot,
                      input input_que_op_to_ck,
                      input 'i',
                      input input_que_qty_chg)"
      }

      /*CHECK OUTPUT QUEUE IF NOT pMove*/
      if not vMove then do:
         {pxrun.i &PROC='validateQueueQty' &PROGRAM='rewoxr.p'
                  &HANDLE=ph_rewoxr
                  &PARAM="(input pWorkOrderLot,
                           input pWorkOrderOperation,
                           input 'o',
                           input qty_chg)"
         }
      end.

      /*CHECK INPUT QUEUE NEXT pWorkOrderOperation IF pMove*/
      if vMove then do:
         {pxrun.i &PROC='readNextOperationForWOID' &PROGRAM='wowrxr.p'
                  &HANDLE=ph_wowrxr
                  &PARAM="(input pWorkOrderLot,
                           input pWorkOrderOperation,
                           buffer wr_route,
                           input {&NO_LOCK_FLAG},
                           input {&NO_WAIT_FLAG})"
         }

         if available wr_route then do:
            {pxrun.i &PROC='validateQueueQty' &PROGRAM='rewoxr.p'
                     &HANDLE=ph_rewoxr
                     &PARAM="(input pWorkOrderLot,
                              input wr_op,
                              input 'i',
                              input qty_chg)"
            }
         end.
      end.

   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE getQtyReceivedOnWO:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
getQtyReceivedOnWO (
input character pPurchaseOrderId,
input character pWorkOrderLot,
input integer pWorkOrderOperation,
output decimal pQuantityChange)

Parameters:
pPurchaseOrderId -
pWorkOrderLot -
pWorkOrderOperation -
pQuantityChange -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pPurchaseOrderId as character no-undo.
   define input parameter pWorkOrderLot as character no-undo.
   define input parameter pWorkOrderOperation as integer no-undo.
   define output parameter pQuantityChange as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      for each pod_det
            fields(pod_nbr pod_op pod_qty_chg pod_type pod_um_conv pod_wo_lot)
            where pod_nbr = pPurchaseOrderId and
            pod_wo_lot = pWorkOrderLot and
            pod_type = "s" and
            pod_op = pWorkOrderOperation no-lock:
         pQuantityChange = pQuantityChange + (pod_qty_chg * pod_um_conv).
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/* extract from poporca4.p */
/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE checkCostTolerance:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
checkCostTolerance (
input decimal pExchRate,
input decimal pExchRate2,
input decimal pToleranceCost,
input character pCurrencyId,
Buffer pPod_Det)

Parameters:
pExchRate -
pExchRate2 -
pToleranceCost -
pCurrencyId -
pPod_Det -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pExchRate as decimal no-undo.
   define input parameter pExchRate2 as decimal no-undo.
   define input parameter pToleranceCost as decimal no-undo.
   define input parameter pCurrencyId as character no-undo.
   define input parameter pOverageQty  as decimal no-undo.
   define parameter buffer pPod_Det for pod_det.

   define variable vBaseCurrency as character no-undo.
   define variable vBaseAmount   as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxgetph.i pxgblmgr}
      vBaseCurrency = {pxfunct.i &FUNCTION='getCharacterValue'
                                 &PROGRAM='pxgblmgr.p'
                                 &HANDLE=ph_pxgblmgr
                                 &PARAM="input 'base_curr'"}.

      /*! CHECK DOLLAR AMOUNT OVERSHIP*/
      vBaseAmount = pod_pur_cost.

      if pCurrencyId <> vBaseCurrency then do:

         {pxrun.i &PROC='convertAmtToTargetCurr' &PROGRAM='mcexxr.p'
                  &HANDLE=ph_mcexxr
                  &PARAM="(input pCurrencyId,
                           input vBaseCurrency,
                           input pExchRate,
                           input pExchRate2,
                           input vBaseAmount,
                           input false,
                           output vBaseAmount)"}

      end. /* IF pCurrencyId <> vBaseCurrency */

      if pOverageQty < 0 then pOverageQty = 0 - pOverageQty .
      /*! CHECK PERCENT OVERSHIP*/

      if pOverageQty * vBaseAmount > pToleranceCost then do:
         /* Error Overshipment cost exceeds...*/
         /* MESSAGE #338 - OVERSHIPMENT COST EXCEEDS */
         {pxmsg.i
            &MSGNUM=338
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &MSGARG1=pToleranceCost}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE checkMaxOrderQty:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
checkMaxOrderQty (
Buffer pPod_det,
input decimal pTotalLotSerialQuantity)

Parameters:
pPod_det -
pTotalLotSerialQuantity -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define  parameter buffer pPod_det for pod_det.
   define input parameter pTotalLotSerialQuantity as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* Warn if the Max Order Qty is exceeded*/

      if pod_cum_qty[3] > 0 and pTotalLotSerialQuantity > 0 and
         pod_cum_qty[1] + pTotalLotSerialQuantity * pod_rum_conv >
         pod_cum_qty[3] then do:

         /* CUM RCVD QTY GREATER OR EQUAL MAX ORDER QTY FOR ORDER SELECTED*/
         /* MESSAGE #8232 - CUM RECEIVED QTY >= MAX ORDER QTY FOR */
         /* ORDER SELECTED */
         {pxmsg.i
            &MSGNUM=8232
            &ERRORLEVEL={&WARNING-RESULT}}
         return {&WARNING-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE checkQtyTolerance:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
checkQtyTolerance (
input decimal pOverage,
input decimal pQuantityOrdered,
input decimal pToleranceCost)

Parameters:
pOverage -
pQuantityOrdered -
pToleranceCost -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pOverage as decimal no-undo.
   define input parameter pQuantityOrdered as decimal no-undo.
   define input parameter pTolerancePercent as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* WHEN pQuantityOrdered = 0 THE CALCULATION  OF        */
      /* (pOverage / pQuantityOrdered) WILL BE UNKNOWN HENCE  */
      /* THE CONDITION ADDED                                  */
      if pQuantityOrdered = 0
         or (pOverage / pQuantityOrdered) * 100 > pTolerancePercent
      then do:
         /* Error Overshipment percentage exceeds...*/
         /* MESSAGE #337 - OVERSHIPMENT PERCENTAGE EXCEEDS */
         {pxmsg.i
            &MSGNUM=337
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &MSGARG1=pTolerancePercent}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE checkScheduleCostTolerance:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
checkScheduleCostTolerance (
input decimal pExchRate,
input decimal pExchRate2,
input integer pQtyOpen,
input decimal pUnitOfMeasureConversion,
input decimal pTotalLotSerialQty,
input decimal pToleranceCost,
input date pEffDate,
input character pCurrencyId,
Buffer pPod_Det)

Parameters:
pExchRate -
pExchRate2 -
pQtyOpen -
pUnitOfMeasureConversion -
pTotalLotSerialQty -
pToleranceCost -
pEffDate -
pCurrencyId -
pPod_Det -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pExchRate as decimal no-undo.
   define input parameter pExchRate2 as decimal no-undo.
   define input parameter pQtyOpen as integer no-undo.
   define input parameter pUnitOfMeasureConversion as decimal no-undo.
   define input parameter pTotalLotSerialQty as decimal no-undo.
   define input parameter pToleranceCost as decimal no-undo.
   define input parameter pEffDate as date no-undo.
   define input parameter pCurrencyId as character no-undo.
   define  parameter buffer pPod_Det for pod_det.

   define variable vBaseCurrency as character no-undo.
   define variable vBaseAmount   as decimal no-undo.
   define variable vOverageQty   as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxgetph.i pxgblmgr}
      vBaseCurrency = {pxfunct.i &FUNCTION='getCharacterValue'
                                 &PROGRAM='pxgblmgr.p'
                                 &HANDLE=ph_pxgblmgr
                                 &PARAM="input 'base_curr'"}.

      /*! CHECK DOLLAR AMOUNT OVERSHIP*/
      vBaseAmount = pod_pur_cost.

      if pCurrencyId <> vBaseCurrency then do:

         {pxrun.i &PROC='convertAmtToTargetCurr' &PROGRAM='mcexxr.p'
                  &HANDLE=ph_mcexxr
                  &PARAM="(input pCurrencyId,
                           input vBaseCurrency,
                           input pExchRate,
                           input pExchRate2,
                           input vBaseAmount,
                           input false,
                           output vBaseAmount)"}

      end. /* IF pCurrencyId <> vBaseCurrency */

      vOverageQty = (pTotalLotSerialQty * pUnitOfMeasureConversion) - pQtyOpen.

      if vOverageQty < 0 then vOverageQty = 0.
      /*! CHECK PERCENT OVERSHIP*/

      if vOverageQty * vBaseAmount > pToleranceCost then do:
         /* WARN OVERSHIPMENT COST EXCEEDS...*/
         /* Overship cost exceeds schedule as of <date> Tolerance: <amt> */
         /* MESSAGE #8306 - OVERSHIP COST EXCEEDS SCHEDULE AS OF */
         /* #. TOLERANCE: # */
/*judy 05/08/12 begin delete*/   
	 /*{pxmsg.i
            &MSGNUM=8306
            &ERRORLEVEL={&WARNING-RESULT}
            &MSGARG1=string(pEffDate)
            &MSGARG2=string(pToleranceCost)
            &MSGARG3=""""}*/
/*judy 05/08/12 end delete*/  
/*judy 05/08/12 begin added*/ 
	  {pxmsg.i
            &MSGNUM=8306
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &MSGARG1=string(pEffDate)
            &MSGARG2=string(pToleranceCost)
            &MSGARG3=""""}   
/*judy 05/08/12 end added*/   

/*judy 05/08/12*/   /* return {&WARNING-RESULT}.*/
/*judy  05/08/12*/ RETURN  ERROR {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE checkScheduleQtyTolerance:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
checkScheduleQtyTolerance (
input integer pDivisor,
input integer pQtyOpen,
input integer pLotQty,
input decimal pUmConversion,
input  decimal pTolerancePercent,
input date pEffDate)

Parameters:
pDivisor -
pQtyOpen -
pLotQty -
pUmConversion -
pTolerancePercent -
pEffDate -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pDivisor as integer no-undo.
   define input parameter pQtyOpen as integer no-undo.
   define input parameter pLotQty as integer no-undo.
   define input parameter pUmConversion as decimal no-undo.
   define input parameter pTolerancePercent as decimal no-undo.
   define input parameter pEffDate as date no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /*! CHECK PERCENT OVERSHIP*/
      if pDivisor = 0 or
         ((pLotQty * pUmConversion - pQtyOpen) * 100)
         / pDivisor > pTolerancePercent then do:

         /* Overship % exceeds schedule as of <date> Tolerance: <pct> */
         /* MESSAGE #8305 - OVERSHIP % EXCEEDS SCHEDULE AS OF #. */
         /* TOLERANCE: # */
/*judy  05/08/12 begin detele*/
       /*  {pxmsg.i
            &MSGNUM=8305
            &ERRORLEVEL={&WARNING-RESULT}
            &MSGARG1=string(pEffDate)
            &MSGARG2=string(pTolerancePercent)
            &MSGARG3=""""} */
/*judy  05/08/12 end delete*/
/*judy  05/08/12 begin added*/
          {pxmsg.i
            &MSGNUM=8305
            &ERRORLEVEL={&APP-ERROR-RESULT}  
            &MSGARG1=string(pEffDate)
            &MSGARG2=string(pTolerancePercent)
            &MSGARG3=""""}   
/*judy  05/08/12 end added*/

/*judy  05/08/12*/ /*return {&WARNING-RESULT}. */
/*judy  05/08/12*/ RETURN  ERROR {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE getScheduleReceiptCost:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
getScheduleReceiptCost (
input character pEffectiveDate,
input character pCurrency,
input character pSupplierId,
input integer   pLotSerialQty,
Buffer pPod_det)

Parameters:
pEffectiveDate -
pCurrency -
pSupplierId -
pLotSerialQty -
pPod_det -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pEffectiveDate as character no-undo.
   define input parameter pCurrency as character no-undo.
   define input parameter pSupplierId as character no-undo.
   define input parameter pLotSerialQty as integer no-undo.
   define parameter buffer pPod_det for pod_det.

   define variable vPc_recno  as recid no-undo.
   define variable vNewPrice  as decimal no-undo.
   define variable vPriceQty  as decimal no-undo.
   define variable vDummyDisc as decimal no-undo.
   define variable use-log-acctg as logical no-undo.
   define variable l_basecurrency    like gl_base_curr    no-undo.
   define variable l_exch_rate       like po_ex_rate      no-undo.
   define variable l_exch_rate2      like po_ex_rate2     no-undo.
   define variable l_exch_ratetype   like po_ex_ratetype  no-undo.
   define variable l_exch_exru_seq   like exru_seq        no-undo.
   define variable l_mc-error-number like msg_nbr         no-undo.

   define buffer vp_mstr for vp_mstr.
   define buffer icc_ctrl for icc_ctrl.
   define buffer in_mstr for in_mstr.
   define buffer sct_det for sct_det.
   define buffer po_mstr for po_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {gprun.i ""rsplqty.p""
               "(input recid(pPod_Det),
                 input (pLotSerialQty * pod_rum_conv),
                 output vPriceQty)"}


      {gprun.i ""gpsct05.p""
               "(input        pod_part,
                 input        pod_site,
                 input        2,
                 output       glxcst,
                 output       curcst)"}

      glxcst = glxcst * pod_um_conv.

      /* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
      {gprun.i ""lactrl.p"" "(output use-log-acctg)"}

      if use-log-acctg then do:

         for first po_mstr
            fields(po_nbr po_tot_terms_code)
            where po_nbr = pod_nbr
         no-lock:
         end.

         if available po_mstr and po_mstr.po_tot_terms_code <> ""
         then do:

            /* UPDATE LOGISTICS ACCOUNTING TERMS OF TRADE FIELD */
            {gprunmo.i &module = "LA" &program = "lapopr.p"
                       &param = """(input pod_um,
                                    input glxcst,
                                    input po_nbr,
                                    input pod_part,
                                    input pod_site,
                                    output glxcst)"""}

         end. /* if available po_mstr */

      end. /* if use-log-acctg */

      if pCurrency <> base_curr
      then do:

         for first po_mstr
            fields(po_nbr po_ex_rate po_ex_rate2)
            where po_nbr = pod_nbr
         no-lock:
         end.
         if available po_mstr
         then
            {pxrun.i &PROC='mc-curr-conv'
                     &PROGRAM='mcpl.p'
                     &HANDLE=ph_mcpl
                     &PARAM="(input base_curr,
                              input pCurrency,
                              input po_ex_rate2,
                              input po_ex_rate,
                              input glxcst,
                              input true,
                              output glxcst,
                              output l_mc-error-number)"}

         if l_mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=l_mc-error-number &ERRORLEVEL=2}
         end. /* IF l_mc-error-number <> 0 */
      end. /* IF po_curr <> base_curr */

      vDummyDisc = 0.
      /* CHANGING EIGHTH PARAMETER TO glxcst FROM pod_pur_cost */
      /* AND ELEVENTH PARAMETER TO glxcst FROM vNewPrice       */
      {gprun.i ""gppccal.p""
               "(input        pod_part,
                 input        vPriceQty,
                 input        pod_um,
                 input        pod_um_conv,
                 input        pCurrency,
                 input        pod_pr_list,
                 input        pEffectiveDate,
                 input        glxcst,
                 input        no,
                 input        vDummyDisc,
                 input-output glxcst,
                 output       vDummyDisc,
                 input-output vNewPrice,
                 output       vPc_recno)" }

      /* IF NO LIST PRICE WAS FOUND LETS TRY TO CHECK FOR */
      /* A VP_Q_PRICE FOR THE ITEM.  IF WE CANT FIND ONE, */
      /* POD_PRICE WILL REMAIN AS IT WAS ORIGINALLY.      */

      if vPc_recno = 0 or vNewPrice = 0 then do:

         /* ADDED VP_VEND_PART IN THE FIELD LIST BELOW */

         {pxrun.i &PROC='processRead' &PROGRAM='ppsuxr.p'
                  &HANDLE=ph_ppsuxr
                  &PARAM="(input  pod_part,
                           input  pSupplierId,
                           input  pod_vpart,
                           buffer vp_mstr,
                           input  {&NO_LOCK_FLAG},
                           input  {&NO_WAIT_FLAG})"
         }

         if return-value = {&SUCCESS-RESULT} and
            vPriceQty >= vp_q_qty and
            pod_um = vp_um        and
            vp_q_price > 0        and
            pCurrency = vp_curr     then do:
            pod_pur_cost = vp_q_price.
         end.  /* IF AVAIL VP_MSTR */
      end. /* IF PC_RECNO = 0 OR VNEWPRICE = 0 */

      else
         pod_pur_cost = vNewPrice.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE checkScheduleTolerance:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
checkScheduleTolerance(
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define parameter buffer pPod_Det for pod_det.
   define input parameter pLotSerialQty as integer no-undo.
   define input parameter pEffDate as date no-undo.
   define input parameter pUMConversion as decimal no-undo.
   define input parameter pExchRate as decimal no-undo.
   define input parameter pExchRate2 as decimal no-undo.

   define variable vDivisor as integer no-undo.
   define variable vOpenQty as integer no-undo.

   define buffer poc_ctrl for poc_ctrl.
   define buffer bPO_mstr for po_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      for first poc_ctrl
            fields(poc_tol_cst poc_tol_pct)
            no-lock:

         {pxrun.i &PROC='processRead' &PROGRAM='popoxr.p'
                  &HANDLE=ph_popoxr
                  &PARAM="(input  pod_nbr,
                           buffer bPO_mstr,
                           input  {&NO_LOCK_FLAG},
                           input  {&NO_WAIT_FLAG})"}

         {pxrun.i &PROC='checkMaxOrderQty'
                  &PARAM="(buffer pPod_det,
                           input  pLotSerialQty)"}

         {pxrun.i &PROC='getScheduleReceiptCost'
                  &PARAM="(input  pEffDate,
                           input  po_curr,
                           input  po_vend,
                           input  pLotSerialQty,
                           buffer pPod_det)"}

         {pxrun.i &PROC='getOpenScheduleQuantity' &PROGRAM='rsscxr.p'
                  &HANDLE=ph_rsscxr
                  &PARAM="(output vDivisor,
                           output vOpenQty,
                           input  pEffDate,
                           buffer pPod_det)"}

         {pxrun.i &PROC='checkScheduleQtyTolerance'
                  &PARAM="(input vDivisor,
                           input vOpenQty,
                           input pLotSerialQty,
                           input pUMConversion,
                           input poc_tol_pct,
                           input pEffDate)"}

         {pxrun.i &PROC='checkScheduleCostTolerance'
                  &PARAM="(input  pExchRate,
                        input  pExchRate2,
                        input  vOpenQty,
                        input  pUMConversion,
                        input  pLotSerialQty,
                        input  poc_tol_cst,
                        input  pEffDate,
                        input  po_curr,
                        buffer pPod_det)"}
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE checkTolerance:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
checkTolerance(
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define parameter buffer pPod_Det for pod_det.
   define input parameter pTotalReceived as decimal no-undo.
   define input parameter pExchRate as decimal no-undo.
   define input parameter pExchRate2 as decimal no-undo.

   define variable vOverageQty as decimal no-undo.

   define buffer bPO_mstr for po_mstr.
   define buffer poc_ctrl for poc_ctrl.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      if (pTotalReceived > pod_qty_ord and pod_qty_ord >= 0 )
      or (pTotalReceived < pod_qty_ord and pod_qty_ord < 0 )
      then do:

         vOverageQty = pTotalReceived - pod_qty_ord .

         for first poc_ctrl
               fields(poc_tol_cst poc_tol_pct)
               no-lock:

            {pxrun.i &PROC='processRead' &PROGRAM='popoxr.p'
                     &HANDLE=ph_popoxr
                     &PARAM="(input  pod_nbr,
                              buffer bPO_mstr,
                              input  {&NO_LOCK_FLAG},
                              input  {&NO_WAIT_FLAG})"}

            {pxrun.i &PROC='checkQtyTolerance'
                     &PARAM="(input vOverageQty,
                           input pod_qty_ord,
                           input poc_tol_pct)"}

            {pxrun.i &PROC='checkCostTolerance'
                     &PARAM="(input  pExchRate,
                           input  pExchRate2,
                           input  poc_tol_cst,
                           input  po_curr,
                           input  vOverageQty,
                           buffer pPod_Det)"}
         end.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE processCreate:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
checkTolerance(
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define parameter buffer bPod_det for pod_det.
   define input  parameter pEffectiveDate as date no-undo.
   define output parameter pAssay as decimal no-undo.
   define output parameter pAssayActive as logical no-undo.
   define output parameter pGrade as character no-undo.
   define output parameter pGradeActive as logical no-undo.
   define output parameter pExpireDate as date no-undo.
   define output parameter pExpireDateActive as logical no-undo.
   define output parameter pInventoryStatus as character no-undo.
   define output parameter pInventoryStatusActive as logical no-undo.
   define output parameter pQuantityOpen as decimal no-undo.

   define variable vErrorFlag as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='initializeAttributes'
               &PARAM="(buffer bPod_det,
                           input  pEffectiveDate,
                           output pAssay,
                           output pGrade,
                           output pExpireDate,
                           output pInventoryStatus,
                           output pAssayActive,
                           output pGradeActive,
                           output pExpireDateActive,
                           output pInventoryStatusActive,
                           output vErrorFlag)"
         }

      {pxrun.i &PROC='defaultExpireDate'
               &PARAM="(input bPod_det.pod_part,
                        input pEffectiveDate,
                        input-output pExpireDate)"
         }

      {pxrun.i &PROC='getOpenQuantity'
               &PARAM="(input  bPod_Det.pod_qty_ord,
                        input  bPod_Det.pod_qty_rcvd,
                        output pQuantityOpen)"
         }

      {pxrun.i &PROC='getScheduleOpenQuantity'
               &PARAM="(buffer bPod_det,
                        input  pEffectiveDate,
                        input-output pQuantityOpen)"
         }

   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE validateAttributes:
/*------------------------------------------------------------------------------
Purpose:       Validate attributes.
porcxr1.p
validateAttribute (
input character pLine,
input recid pRecid,
input date pEffDate,
input decimal pChg_assay,
input character pChg_grade,
input date pChg_expire,
input character pChg_status,
input logical pAssay_actv,
input logical pGrade_actv,
input logical pExpire_actv,
input logical pStatus_actv)

Parameters:
pLine -
pRecid -
pEffDate -
pChg_assay -
pChg_grade -
pChg_expire -
pChg_status -
pAssay_actv -
pGrade_actv -
pExpire_actv -
pStatus_actv -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define parameter buffer bPod_detClean for pod_det.
   define input parameter pEffectiveDate as date no-undo.
   define input parameter pChg_assay like tr_assay no-undo.
   define input parameter pChg_grade like tr_grade no-undo.
   define input parameter pChg_expire like tr_expire no-undo.
   define input parameter pChg_status like tr_status no-undo.
   define input parameter pAssay_actv as logical no-undo.
   define input parameter pGrade_actv as logical no-undo.
   define input parameter pExpire_actv as logical no-undo.
   define input parameter pStatus_actv as logical no-undo.

   define buffer sr_wkfl for sr_wkfl.

   define variable vMfgUser as character no-undo.
   define variable err_flag as logical no-undo.
   define variable srlot as character no-undo.
   {pxgetph.i pxgblmgr}
   vMfgUser = ({pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                          &HANDLE=ph_pxgblmgr
                          &PARAM="input 'mfguser'"}).

   for each sr_wkfl
         fields(sr_lineid sr_loc sr_lotser sr_qty
         sr_ref sr_site sr_userid sr_vend_lot)
         where sr_userid = vMfgUser
         and sr_lineid = string(bPod_detClean.pod_line) no-lock:

      {gprun.i ""porcat01.p""
         "(input recid(bPod_detClean),
              input sr_site,
              input sr_loc,
              input sr_ref,
              input sr_lotser,
              input pEffectiveDate,
              input-output pChg_assay,
              input-output pChg_grade,
              input-output pChg_expire,
              input-output pChg_status,
              input-output pAssay_actv,
              input-output pGrade_actv,
              input-output pExpire_actv,
              input-output pStatus_actv,
              output err_flag)"}

      if err_flag then do:
         srlot = sr_lotser.

         if sr_ref <> "" then
            srlot = srlot + "/" + sr_ref.

         /*ATTRIBUTES DO NOT MATCH EXISTING DETAIL: SN/REF# */
         {pxmsg.i
            &MSGNUM=2742
            &ERRORLEVEL={&APP-ERROR-NO-REENTER-RESULT}
            &MSGARG1=srlot}
         return error {&APP-ERROR-RESULT}.
      end. /* IF ERR_FLAG THEN DO WITH FRAME A: */
   end. /* FOR EACH SR_WKFL..*/
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE calculateLineTotal:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
calculateLineTotals (
input character )

Parameters:
-

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

------------------------------------------------------------------------------*/

   define parameter  buffer pPod_det for pod_det .
   define input parameter  pPoCurrency      as character no-undo.
   define output parameter pLineTotal  as decimal   no-undo.

   define variable vUnitOfMeasure as character no-undo.
   define variable vQtyReceived as integer   no-undo.
   define variable vPrice as decimal   no-undo.
   define variable vRoundingMethod  as character no-undo.
   define variable vError  as integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='getUnitOfMeasure' &PROGRAM='ppitxr.p'
               &HANDLE=ph_ppitxr
               &PARAM="( input pod_part ,
                         output vUnitOfMeasure)"
         }
      if vUnitOfMeasure = pod_um then
         vQtyReceived = pod_qty_chg / pod_um_conv .
      else
         vQtyReceived = pod_qty_chg * pod_um_conv .

      {pxrun.i &PROC='calculateUnitCost'
         &PARAM="(buffer pPod_det,
                  output vPrice)"
         }

      pLineTotal = vQtyReceived * pod_um_conv * vPrice.

      {pxrun.i &PROC='getRoundingMethod' &PROGRAM='mcexxr.p'
               &HANDLE=ph_mcexxr
               &PARAM="(input pPOCurrency,
                        output vRoundingMethod)"
         }

      {pxrun.i &PROC='roundAmount' &PROGRAM='mcexxr.p'
               &HANDLE=ph_mcexxr
               &PARAM="(input-output pLineTotal,
                        input        vRoundingMethod,
                        output       vError)"
         }
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE createTempHistoryRecords:
/*------------------------------------------------------------------------------
Purpose:       Create prh_hist records used to calculate taxes during purchase
order receipt processing.
Exceptions:
Conditions:
Pre:   NONE
Post:  NONE
Notes:         Extracted from poporcx.p
History:
Last change:  JLR  19 Jul 2000    11:51 am
------------------------------------------------------------------------------*/
   define parameter buffer pPodDet for pod_det.
   define input parameter pSiteId as character no-undo.
   define input parameter pEffectiveDate as date no-undo.
   define input parameter pReceiverNbr as character no-undo.
   define input parameter pPrice as decimal no-undo.
   define input parameter pPackingSlipNbr as character no-undo.
   define input parameter pAccount as character no-undo.
   define input parameter pSubAccount as character no-undo.
   define input parameter pCostCenter as character no-undo.
   define input parameter pProject as character no-undo.
   define input parameter pStandardCost as decimal no-undo.
   define input parameter pExchangeRate as decimal no-undo.
   define input parameter pExchangeRate2 as decimal no-undo.

   define variable proc_id       as character no-undo.

   define buffer prh_hist for prh_hist.
   define buffer po_mstr for po_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='processRead' &PROGRAM='popoxr.p'
               &HANDLE=ph_popoxr
               &PARAM="(input pod_nbr,
                        buffer po_mstr,
                        input {&NO_LOCK_FLAG},
                        input {&NO_WAIT_FLAG})"
         }

      create prh_hist.  /* TEMPORARY, DELETED LATER */

      assign
         prh_site            = pSiteId
         prh_part            = pod_part
         prh_nbr             = pod_nbr
         prh_line            = pod_line
         prh_rcvd            = pod_qty_chg * pod_rum_conv
         prh_cum_rcvd        = pod_cum_qty[1] + prh_rcvd
         prh_curr_rlse_id[1] = pod_curr_rlse_id[1]
         prh_rcp_date        = pEffectiveDate
         prh_vend            = po_vend
         prh_receiver        = pReceiverNbr
         prh_lot             = pod_wo_lot
         prh_ps_nbr          = pPackingSlipNbr
         prh_ps_qty          = pod_ps_chg
         prh_bo_qty          = pod_bo_chg
         prh_po_site         = pod_po_site
         prh_pur_std         = pStandardCost
         prh_rev             = pod_rev
         prh_type            = pod_type
         prh_buyer           = po_buyer
         prh_cst_up          = pod_cst_up
         prh_um              = pod_um
         prh_um_conv         = pod_um_conv
         prh_pur_cost        = pPrice
         prh_fix_pr          = pod_fix_pr
         prh_curr            = po_curr
         prh_per_date        = pod_per_date
         prh_qty_ord         = pod_qty_ord
         prh_ship            = po_ship
         prh_request         = pod_request
         prh_curr_amt        = prh_pur_cost
         prh_ex_rate         = pExchangeRate
         prh_ex_rate2        = pExchangeRate
         prh_taxc            = pod_taxc
         prh_tax_env         = pod_tax_env
         prh_tax_in          = pod_tax_in
         prh_tax_usage       = pod_tax_usage.

      if pod_taxable then prh_tax_at = "yes".
      else prh_tax_at = "".

      empty temp-table tt_pvo_mstr.
      create tt_pvo_mstr.

      assign
         tt_pvo_mstr.pvo_id                = 0
         tt_pvo_mstr.pvo_supplier          = prh_vend
         tt_pvo_mstr.pvo_internal_ref_type = {&TYPE_POReceiver}
         tt_pvo_mstr.pvo_internal_ref      = pReceiverNbr
         tt_pvo_mstr.pvo_external_ref      = prh_ps_nbr
         tt_pvo_mstr.pvo_trans_date        = prh_rcp_date
         tt_pvo_mstr.pvo_eff_date          = pEffectiveDate
         tt_pvo_mstr.pvo_cost_update       = prh_cst_up
         tt_pvo_mstr.pvo_part              = prh_part
         tt_pvo_mstr.pvo_shipto            = prh_site
         tt_pvo_mstr.pvo_trans_qty         = prh_rcvd
         tt_pvo_mstr.pvo_vouchered_qty     = 0
         tt_pvo_mstr.pvo_vouchered_amt     = 0
         tt_pvo_mstr.pvo_accrued_amt       = 0
         tt_pvo_mstr.pvo_curr              = prh_curr
         tt_pvo_mstr.pvo_order             = pod_nbr
         tt_pvo_mstr.pvo_line              = pod_line
         tt_pvo_mstr.pvo_order_type        = {&TYPE_PO}
         tt_pvo_mstr.pvo_ers_status        = 0
         tt_pvo_mstr.pvo_mod_userid        = global_userid
         tt_pvo_mstr.pvo_mod_date          = today
         tt_pvo_mstr.pvo_accrual_acct      = pAccount
         tt_pvo_mstr.pvo_accrual_sub       = pSubAccount
         tt_pvo_mstr.pvo_accrual_cc        = pCostCenter
         tt_pvo_mstr.pvo_project           = pProject
         tt_pvo_mstr.pvo_ex_rate           = pExchangeRate
         tt_pvo_mstr.pvo_ex_rate2          = pExchangeRate2
         tt_pvo_mstr.pvo_ex_ratetype       = ""
         tt_pvo_mstr.pvo_taxable           = pod_taxable
         tt_pvo_mstr.pvo_buyer             = prh_buyer
         tt_pvo_mstr.pvo_approve           = prh_approve
         tt_pvo_mstr.pvo_taxc              = pod_taxc
         tt_pvo_mstr.pvo_tax_env           = pod_tax_env
         tt_pvo_mstr.pvo_tax_in            = pod_tax_in
         tt_pvo_mstr.pvo_tax_usage         = pod_tax_usage
         tt_pvo_mstr.pvo_consignment       = no
         proc_id                           = "create".

      if recid(tt_pvo_mstr) = -1 then.
      /* CREATE A PENDING VOUCHER PHYSICAL RECORD*/
      {gprun.i ""appvorop.p""
         "(input proc_id,
           input-output table tt_pvo_mstr)"}

      release prh_hist.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE deleteTempHistoryRecords:
/*------------------------------------------------------------------------------
Purpose:       Delete prh_hist records used to calculate taxes during purchase
order receipt processing.
Exceptions:
Conditions:
Pre:   NONE
Post:  NONE
Notes:         Extracted from poporcx.p
History:
Last change:  JLR  19 Jul 2000    11:51 am
------------------------------------------------------------------------------*/
   define input parameter pOrderId as character no-undo.
   define input parameter pReceiverId as character no-undo.
   define input parameter pTaxLine as integer no-undo.

   define buffer prh_hist for prh_hist.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      for each prh_hist exclusive-lock where
            prh_receiver = pReceiverId and
            prh_nbr      = pOrderId      and
            (pTaxLine = 0 or prh_line = pTaxLine):
         for first pvo_mstr
            where pvo_internal_ref_type = {&TYPE_POReceiver}
            and pvo_lc_charge    = ""
            and pvo_internal_ref = prh_receiver
            and pvo_line = prh_line
            exclusive-lock:
            delete pvo_mstr.
         end.
         delete prh_hist.
      end.

   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE calculateUnitCost:
/*------------------------------------------------------------------------------
Purpose:       Calculate and return the item purchase price using record passed
in the purchase order line (pod_det) buffer.
Exceptions:
Conditions:
Pre:   Valid record available in pPOLineBuffer buffer.
Post:  pPrice contains calculated value
Notes:         Extracted from poporcx.p
History:
Last change:  JLR  19 Jul 2000    11:51 am
------------------------------------------------------------------------------*/
   define parameter buffer pPOLineBuffer for pod_det.
   define output parameter pPrice as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      if (pod__qad02 = 0 or pod__qad02 = ?) and
         (pod__qad09 = 0 or pod__qad09 = ?) then
      assign
         pPrice = pod_pur_cost * (1 - (pod_disc_pct / 100)) / pod_um_conv.
      else
      assign
         pPrice = (pod__qad09 + (pod__qad02 / 100000)) / pod_um_conv.

   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE getItemConversionFactor:
/*------------------------------------------------------------------------------
Purpose:       Calculate and return the converion factor to be used for
receiving.
Exceptions:
Conditions:
Pre:   NONE
Post:  pConversionFactor contains calculated value
Notes:         Extracted from poporcb.p
History:
Last change:  JLR  21 Jul 2000    11:51 am
------------------------------------------------------------------------------*/
   define input parameter pPartId as character no-undo.
   define input parameter pReceiveUom as character no-undo.
   define input parameter pReceiveConversion as decimal no-undo.
   define input parameter pUomConversion as decimal no-undo.
   define output parameter pConversionFactor as decimal no-undo.

   define buffer pt_mstr for pt_mstr.

   /* If receipt_um = pt_um, the conversion factor should be 1. */
   /* Due to truncation, conv_to_pod_um * pod_um_conv doesn't   */
   /* always equal 1, leading to inventory problems             */

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      for first pt_mstr
            fields(pt_part pt_um)
            where pt_part = pPartId no-lock:
      end. /* FOR FIRST PT_MSTR */

      if available pt_mstr and pt_mstr.pt_um = pReceiveUom then
         pConversionFactor = 1.
      else
         pConversionFactor = pReceiveConversion * pUomConversion.

   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE calculateLineTax:
/*-----------------------------------------------------------------------------
Purpose:  Read Data set for POR line Taxes
Exceptions:  None
Notes:
History:
------------------------------------------------------------------------------*/
   define parameter buffer pPod_det for pod_det.
   define input parameter pReceiverId as character no-undo.
   define input parameter pCopyPOTaxes as logical no-undo.
   define input parameter pEffectiveDate as date no-undo.
   define input parameter pExchRate1 as decimal no-undo.
   define input parameter pExchRate2 as decimal no-undo.
   define input parameter pPackingSlipId as character no-undo.
   define input parameter pRetainTaxValue as logical no-undo.

   define variable vPrice as decimal no-undo.
   define variable vResultStatus as logical no-undo.
   define variable recalcTaxes as logical initial yes no-undo.
   define variable tx2dRecFound as logical no-undo.
   define variable lMfgUser as character no-undo.

   define buffer po_mstr  for po_mstr.
   define buffer tx2d_det for tx2d_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='processRead' &PROGRAM='popoxr.p'
               &HANDLE=ph_popoxr
               &PARAM="(input  pod_nbr,
                        buffer po_mstr,
                        input  {&NO_LOCK_FLAG},
                        input  {&NO_WAIT_FLAG})"
         }

      if return-value <> {&SUCCESS-RESULT} then
         return error return-value.

      {pxgetph.i pxgblmgr}
      lMfgUser = ({pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                             &HANDLE=ph_pxgblmgr
                             &PARAM="input 'mfguser'"}).

      if pReceiverId <> lMfgUser then
      for each tx2d_det exclusive-lock
            where tx2d_ref     = lMfgUser
            and tx2d_nbr     = pod_nbr
            and tx2d_line    = pod_line
            and tx2d_tr_type = {&TAX-TR-TYPE-PO-RECEIPT}:
         tx2d_ref = pReceiverId.
      end.

      {pxrun.i &PROC='calculateUnitCost'
               &PARAM="(buffer pPod_det,
                        output vPrice)"
         }

      {pxrun.i &PROC='createTempHistoryRecords'
               &PARAM="(buffer pPod_det,
                        input pPod_det.pod_site,
                        input pEffectiveDate,
                        input pReceiverId,
                        input vPrice,
                        input pPackingSlipId,
                        input pod_acct,
                        input pod_sub,
                        input pod_cc,
                        input pod_project,
                        input pod_std_cost,
                        input pExchRate1,
                        input pExchRate2)"
         }

      if pod_taxable then
      for each tx2d_det no-lock
            where tx2d_ref     = pReceiverId
            and tx2d_nbr     = pod_nbr
            and tx2d_line    = pod_line
            and tx2d_tr_type = {&TAX-TR-TYPE-PO-RECEIPT}
            break by tx2d_nbr by tx2d_line:

         tx2dRecFound = yes.

         /* If any tax-line is edited, flip the flag */
         if tx2d_edited then assign recalcTaxes = no.

         if last-of(tx2d_line) then do:

            /* Recalculate taxes if nothing was edited, */
            /* unless overridden by the pRetainEdited   */
            if recalcTaxes or not pRetainTaxValue then do:
               {gprun.i ""porcxf2.p""
                  "(input  {&TAX-TR-TYPE-PO-RECEIPT},
                             input  pReceiverId,
                             input  pod_nbr,
                             input  pod_line,
                             input  no,
                             input  pEffectiveDate,
                             input  no,
                             output vResultStatus)"}

               {pxgetph.i txtxxr}
               if {pxfunct.i &FUNCTION='isTaxLineEdited' &PROGRAM='txtxxr.p'
                             &HANDLE=ph_txtxxr
                             &PARAM="input pod_nbr,
                                     input pod_line,
                                     input po_blanket,
                                     input {&TAX-TR-TYPE-PO}"}
                  and pCopyPOTaxes
               then do:

                  {pxrun.i &PROC='copyTaxValues' &PROGRAM='txtxxr.p'
                           &HANDLE=ph_txtxxr
                           &PARAM="(input {&TAX-TR-TYPE-PO},
                                    input pod_nbr,
                                    input po_blanket,
                                    input {&TAX-TR-TYPE-PO-RECEIPT},
                                    input pReceiverId,
                                    input pod_nbr,
                                    input pod_line)"
                     }

               end.
            end.  /* if recalcTaxes or not pRetainTaxValue */

         end.  /* if last-of(tx2d_line) */
      end.  /* for each tx2d_det */

      /* If no tx2d_det records were found assume tax calculation is needed */
      /* this will also happen if not taxable, because we need to run the */
      /* txcalc.p to delete any existing tax-lines if the order-line was set */
      /* to not taxable */
      if not tx2dRecFound or not pod_taxable then do:
         {gprun.i ""porcxf2.p""
                  "(input  {&TAX-TR-TYPE-PO-RECEIPT},
                    input  pReceiverId,
                    input  pod_nbr,
                    input  pod_line,
                    input  no,
                    input  pEffectiveDate,
                    input  no,
                    output vResultStatus)"}

         {pxgetph.i txtxxr}
         if {pxfunct.i &FUNCTION='isTaxLineEdited' &PROGRAM='txtxxr.p'
                       &HANDLE=ph_txtxxr
                       &PARAM="input pod_nbr,
                               input pod_line,
                               input po_blanket,
                               input {&TAX-TR-TYPE-PO}"}
            and pCopyPOTaxes
         then do:

            {pxrun.i &PROC='copyTaxValues' &PROGRAM='txtxxr.p'
                     &HANDLE=ph_txtxxr
                     &PARAM="(input {&TAX-TR-TYPE-PO},
                              input pod_nbr,
                              input po_blanket,
                              input {&TAX-TR-TYPE-PO-RECEIPT},
                              input pReceiverId,
                              input pod_nbr,
                              input pod_line)"
               }

         end.
      end. /* if not tx2dRecFound */

      {pxrun.i &PROC='deleteTempHistoryRecords'
               &PARAM="(input pod_nbr,
                       input pReceiverId,
                       input pod_line)"
         }

   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE clearTaxDetails:
/*------------------------------------------------------------------------------
<Comment1>
porcxr1.p
clearTaxDetails (
input character pReceiverId
input character pPurchaseOrderId)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pReceiverId      as character no-undo.
   define input parameter pPurchaseOrderId as character no-undo.

   define buffer tx2d_det for tx2d_det.

   define variable lMfgUser as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxgetph.i pxgblmgr}
      lMfgUser = {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                            &HANDLE=ph_pxgblmgr
                            &PARAM="input 'mfguser'"}.

      for each  tx2d_det exclusive-lock
            where tx2d_ref     = pReceiverId
            and tx2d_nbr     = pPurchaseOrderId
            and tx2d_tr_type = {&TAX-TR-TYPE-PO-RECEIPT}:

         if tx2d_line = 0 or
            can-find(pod_det where pod_nbr = pPurchaseOrderId
            and pod_line = tx2d_line
            and pod_qty_chg = 0)
            then
            delete tx2d_det.
      end.

      for each  tx2d_det exclusive-lock
            where tx2d_ref     = lMfgUser
            and tx2d_nbr     = pPurchaseOrderId
            and tx2d_tr_type = {&TAX-TR-TYPE-PO-RECEIPT}:

         if tx2d_line = 0 or
            can-find(pod_det where pod_nbr = pPurchaseOrderId
            and pod_line = tx2d_line
            and pod_qty_chg = 0)
            then
            delete tx2d_det.
      end.

   end.
   return {&SUCCESS-RESULT} .
END PROCEDURE.
