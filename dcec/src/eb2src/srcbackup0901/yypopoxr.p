/* popoxr.p - Purchase Order Header Responsiblity Owning Procedure.           */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.17 $                                                               */
/*                                                                            */
/*  Purchase Order Header Responsiblity Owning Procedure.                     */
/*                                                                            */
/* Revision:         BY:Jean Miller      DATE:04/21/00 ECO: *N03T*            */
/* Revision: 1.5     BY:Mugdha Tambe     DATE:06/12/00 ECO: *N0B9*            */
/* Revision: 1.6     BY:Anup Pereira     DATE:07/10/00 ECO: *N059*            */
/* Revision: 1.7     BY:Pat Pigatti      DATE:08/14/00 ECO: *N0KZ*            */
/* Revision: 1.9     BY:Larry leeth      DATE:08/30/00 ECO: *N0QQ*            */
/* Revision: 1.10    BY:Julie Milligan   DATE:09/25/00 ECO: *N0S0*            */
/* Revision: 1.12    BY:Zheng Huang      DATE:10/18/00 ECO: *N0SP*            */
/* Revision: 1.13    BY:Murali Ayyagari  DATE:12/05/00 ECO: *N0V1*            */
/* Revision: 1.14    BY:Nikita Joshi     DATE:02/06/01 ECO: *N0WK*            */
/* Revision: 1.15    BY:Nikita Joshi     DATE:05/04/01 ECO: *M16J*            */
/* Revision: 1.16    BY:Manisha Sawant   DATE:07/30/01 ECO: *M1FV*            */
/* $Revision: 1.17 $      BY:Shilpa Athalye   DATE:05/28/03 ECO: *N2G4*            */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
/*V8:ConvertMode=NoConvert                                                    */


/*============================================================================*/
/* ****************************  DEFINITIONS  ******************************* */
/*============================================================================*/

{mfdeclre.i}

{pxmaint.i}

/* Define Handles for the programs. */
{pxphdef.i adadxr}
{pxphdef.i adcrxr}
{pxphdef.i adsuxr}
{pxphdef.i glacxr}
{pxphdef.i gpcodxr}
{pxphdef.i gplngxr}
{pxphdef.i gpsecxr}
{pxphdef.i icsixr}
{pxphdef.i ieiexr}
{pxphdef.i mcexxr}
{pxphdef.i popoxr1}
{pxphdef.i ppplxr}
{pxphdef.i pxgblmgr}
{pxphdef.i pxtools}
{pxphdef.i txenvxr}
{pxphdef.i txtxxr}
{pxphdef.i mcpl}
/* End Define Handles for the programs. */


/*============================================================================*/
/* ****************************  FUNCTIONS  ********************************* */
/*============================================================================*/

/*============================================================================*/
FUNCTION isPOOpen returns logical
      (input pPOId as character):
/*------------------------------------------------------------------------------
Purpose:       Determines if the PO is Open
Exceptions:    None
onditions:
Pre:           po_mstr(r)
Post:          po_mstr(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define variable returnData as logical initial false no-undo.

   if can-find(po_mstr where po_nbr = pPOId
      and po_stat <> "c"
      and po_stat <> "x")
   then
      returnData = TRUE.

   return (returnData).
END FUNCTION.


/*============================================================================*/
/* ****************************  MAIN BLOCK  ******************************** */
/*============================================================================*/



/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */
/*============================================================================*/
PROCEDURE calculateOrderTotal :
/*------------------------------------------------------------------------------
Purpose:       Calculate total amount for an order, including taxes.
Exceptions:    NONE
Conditions:
        Pre:   NONE
        Post:  NONE
Notes:         Extracted from pomttrld.p and pomttrlc.p.
History:
------------------------------------------------------------------------------*/
   define input parameter pRoundMethod as character no-undo.
   define input parameter pTransactionType as character no-undo.
   define input parameter pReference as character no-undo.
   define input parameter pDocumentNumber as character no-undo.
   define input parameter pTaxLine as integer no-undo.
   define input parameter pIncludeRetained as logical no-undo.
   define output parameter pLineTotalToBeDisplayed as decimal no-undo.
   define output parameter pNonTaxableAmount as decimal no-undo.
   define output parameter pOrderTotal as decimal no-undo.
   define output parameter pTaxableAmount as decimal no-undo.
   define output parameter pTaxTotal as decimal no-undo.
   define output parameter pTotalTaxIncluded as decimal no-undo.


   define buffer pod_det for pod_det.
   define variable ext_actual as decimal no-undo.
   define variable pLinesTotal as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

   /* Get Order Totals for extended line amounts, taxable and non-taxable */
   {pxrun.i &PROC='getPreTaxTotals'
            &PARAM="(input pReference,
                     input pRoundMethod,
                     output pLinesTotal,
                     output pTaxableAmount,
                     output pNonTaxableAMount)"
            &NOAPPERROR=true
            &CATCHERROR=true}

      {pxrun.i &PROC='calculateTaxTotal'
               &PROGRAM='txtxxr.p'
               &HANDLE=ph_txtxxr
               &PARAM="(input pTransactionType,
                        input pReference,
                        input pDocumentNumber,
                        input pTaxLine,
                        input pIncludeRetained,
                        output pTaxTotal,
                        output pTotalTaxIncluded)"}

      pTaxableAmount = pTaxableAmount - pTotalTaxIncluded.
      pLineTotalToBeDisplayed = pLinesTotal - pTotalTaxIncluded.
      pOrderTotal = pLineTotalToBeDisplayed + pTaxTotal.

   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.
/*============================================================================*/
PROCEDURE checkForOpenSupplierPO :
/*------------------------------------------------------------------------------
Purpose: Check for open Purchase Orders for the supplier
Exceptions:    NONE
Conditions:
        Pre:
        Post:
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pSupplierId as character no-undo.

   define buffer po_mstr for po_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
       if can-find(first po_mstr where po_vend = pSupplierId)
       then do:
           find first po_mstr where po_vend = pSupplierId no-lock.
      /* DELETE NOT ALLOWED, PURCHASE ORDER EXISTS */
               {pxmsg.i &MSGNUM=310
                        &ERRORLEVEL={&APP-ERROR-RESULT}
                        &MSGARG1=po_nbr
               }
          return error {&APP-ERROR-RESULT} .

       end. /* if can-find(first po_mstr where po_vend = vd_addr) then do: */
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.
/*============================================================================*/
PROCEDURE closeOrOpenPO:
/*------------------------------------------------------------------------------
Purpose: Check for need to close or open PO header and possibly all lines
Exceptions:    NONE
Conditions:
        Pre:   po_mstr status may have been changed
        Post:  po_mstr and all pod_det may be updated
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPOId as character no-undo.
   define input parameter pCloseAllRequisitionLines as logical no-undo.
   define input parameter pReopenAllLines as logical no-undo.

   define buffer po_mstr for po_mstr.

   {pxrun.i &PROC='processRead'
            &PARAM="(input pPOId,
                     buffer po_mstr,
                     input TRUE,
                     input TRUE)"}

   if po_cls_date <> ?
   and po_stat <> "c"
   and po_stat <> "x"
   then do:
      {pxrun.i &PROC='purchaseOrderIsReOpened'
               &PARAM="(buffer po_mstr)"}
      if pReopenAllLines
      then do:
         {pxrun.i &PROC='reopenPOLines' &PROGRAM='popoxr1.p'
                  &HANDLE=ph_popoxr1
                  &PARAM="(input po_nbr,
                           input (po_type = 'b'))"}
      end.
   end.
   else
   if po_cls_date = ?
   and (po_stat = "c"
     or po_stat = "x")
   then do:
      {pxrun.i &PROC='closePO'
               &PARAM="(buffer po_mstr,
                        input false, /* NOT BLANKET PO MAINT */
                        input pCloseAllRequisitionLines )"}
      {pxrun.i &PROC='informClosePO'}
   end.

END PROCEDURE.

/*============================================================================*/
PROCEDURE informClosePO :
/*------------------------------------------------------------------------------
Purpose:       Inform Closure of  purchase order.
Exceptions:    NONE
Conditions:
        Pre:
        Post:
Notes:
History:       Extract from popomtf.p
------------------------------------------------------------------------------*/

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* MESSAGE #326 - PURCHASE ORDER CLOSED */
      {pxmsg.i
         &MSGNUM=326
         &ERRORLEVEL={&INFORMATION-RESULT}}
   end.
END PROCEDURE.

/*============================================================================*/
PROCEDURE closePO :
/*------------------------------------------------------------------------------
Purpose:       Close the purchase order.
Exceptions:    NONE
Conditions:
        Pre:   po_mstr(r)
        Post:  pod_det(w)
Notes:
History:
------------------------------------------------------------------------------*/
   define parameter buffer po_mstr for po_mstr.
   define input parameter pBlanket as logical no-undo.
   define input parameter pCloseRequisitionResponse as logical no-undo.

   define buffer poddet for pod_det.
   define buffer pod_det for pod_det.

   define variable bl_qty_chg                   like pod_rel_qty.
   define variable errorCode                    as integer no-undo.
   define variable poDB                         as character no-undo.
   define variable siteDB                       as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      po_cls_date = today.

      /* CLOSE P.O. LINES NOT ALREADY CANCELLED BY ZERO BACKORDERS */
      /* CLOSED PO LINES SHOULD ALSO BE EXCLUDED WHEN CREATING     */
      /* BOOKING TRANSACTIONS                                      */
      for each pod_det exclusive-lock
         where pod_nbr = po_mstr.po_nbr
         and   pod_status <> "x"  /* CANCELLED */
         and   pod_status <> "c": /* CLOSED */

         if not pBlanket
         then do:
            /* RUN FACADE FOR GPPOTR.P, WHICH NEEDS SHARED VARIABLES */
            {gprun.i ""potrxf.p""
               "(input ""DELETE"",
                 input pod_nbr,
                 input pod_line)"}
         end.
         if po_stat = "c" and pod_status <> "x"
         then
            pod_status = "c".
         if po_stat = "x" and pod_status <> "c"
         then
            pod_status = "x".

         /* WHEN THE USER MANUALLY CLOSES A PO AT THE TRAILER FRAME */
         /* WHICH REFERS A REQ/REQS , THE USER IS PROMPTED TO CLOSE */
         /* THE ASSOCIATED REQ AND OR REQ LINE                      */
         if pod_status = "c"
         then do:

            {pxgetph.i pxgblmgr}

            poDB =
           {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                      &HANDLE=ph_pxgblmgr
                      &PARAM="input 'global_db'"}.

            /* GET SITE DB */
            {pxrun.i &PROC='getSiteDataBase' &PROGRAM='icsixr.p'
                     &HANDLE=ph_icsixr
               &PARAM="(pod_det.pod_site, output siteDB)"}

            if siteDB <> poDB
            then do:
               {gprun.i ""gpalias3.p"" "(siteDB, output errorCode)"}
            end.

            if ({pxfunct.i &FUNCTION='isGRSInUse' &PROGRAM='rqgrsxr.p'})
            then do:
               {gprunmo.i &program = "popocls.p" &module = "GRS"
                          &param = """(input pod_req_nbr,
                                       input pod_req_line,
                                       input pCloseRequisitionResponse)"""}
            end. /* IF ({pxfunct.i &FUNCTION='isGRSInUse' ....) */

            if poDB <> siteDB
            then do:
               {gprun.i ""gpalias3.p"" "(poDB, output errorCode)"}
            end.

         end. /* IF POD_STATUS = "C" */

         if pod_type = "" and pBlanket = false
         then do:
            /* UPDATE MRP RECS, ORDER QTY, REQS, NET CHG FLAG */
            /* RUN FACADE BECAUSE MFMRW.I USES INMRP1.I WHICH */
            /* HAS AN INTERNAL PROCEDURE */
            {gprun.i ""popoxf3.p""
               "(buffer pod_det, input 0)"}
         end.

         /* ADJUST pBlanket PO WHEN CANCELING PO CREATED BY pBlanket */
         if pod_status = "x"
            and not pBlanket
         then do:
            {pobladj.i}
         end.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE copyPOToOtherDBs :

/*------------------------------------------------------------------------------
Purpose:       Copy the PO information to other DB's where applicable
Exceptions:    NONE
Conditions:
        Pre:   po_mstr(r)
       Post:   po_mstr(w)
Notes:
History:
------------------------------------------------------------------------------*/

   define input parameter p_po_nbr as character no-undo.
   define input parameter p_blanket as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:


      /* COPY PO HEADER TO ALL REMOTE DATABASES */
      /* COPY PO DETAILS TO APPLICABLE REMOTE DATABASES */
      /* RUN FACADE BECAUSE POPOMTG.P NEEDS SHARED VARIABLES */
      {gprun.i ""popoxf4.p""
         "(input p_po_nbr,
           input p_blanket /* TRUE = RUNNING AS BLANKET PO MAINT */ )"}
   end.


   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE createIntrastatMaster :

/*------------------------------------------------------------------------------
Purpose:       Creates An Import/ Export Record for a Purchase Order
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   po_mstr(r)
        Post:  ie_mstr(r),
Notes:
History:       Extracted from popomtb.p
------------------------------------------------------------------------------*/
   define parameter buffer po_mstr for po_mstr.

   define buffer ie_mstr for ie_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if can-find(iec_ctrl where iec_impexp = yes)
      then do:

         /* CREATE THE IMPORT/EXPORT RECORD */
         {pxrun.i &PROC='processCreate' &PROGRAM='ieiexr.p'
                  &HANDLE=ph_ieiexr
                  &PARAM="(input '2',
                           input po_mstr.po_nbr,
                           buffer ie_mstr)"}

         /* If we cannot read the record then we cannot create */
         if return-value <> {&SUCCESS-RESULT}
         then
            return error return-value.
         if recid(ie_mstr) = -1
         then .


         /* SET MODIFICATION INFORMATION - DATE AND USER IDENTIFICATION */
         {pxrun.i &PROC='setModificationInfo' &PROGRAM='ieiexr.p'
                  &HANDLE=ph_ieiexr
                  &PARAM="(buffer ie_mstr)"}

      end.

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.


/*============================================================================*/
PROCEDURE createPurchaseOrder :

/*------------------------------------------------------------------------------
Purpose:       Create the Purchase Order Header record.
Exceptions:    NONE
Conditions:
        Pre:   None.
       Post:   po_mstr(c)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPOId as character no-undo.
   define parameter buffer po_mstr for po_mstr.

   define buffer poc_ctrl for poc_ctrl.

   define variable globalUserId as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /*Get the Control file for various default values*/
      {pxrun.i &PROC='readPOControl'
               &PARAM="(buffer poc_ctrl)"}

      do on error undo, return {&GENERAL-APP-EXCEPT}:
         create po_mstr.

         {pxgetph.i pxgblmgr}

         assign
            globalUserId
               = {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                            &HANDLE=ph_pxgblmgr
                            &PARAM="input 'global_userid'"}
            po_nbr = pPOId
            po_ord_date = today
            po_due_date = today
            po_tax_date = ?
            po_ship     = poc_ctrl.poc_ship
            po_bill     = poc_bill
            po_confirm  = yes
            po_user_id  = globalUserId
            po_fst_id   = poc_fst_id /*(GST exempt id for company)*/
            po_pst_id   = poc_pst_id
            po_ers_opt  = if poc_ers_proc
                          then poc_ers_opt
                          else "1".

         if recid(po_mstr) = -1
         then.
      end.

      {pxrun.i &PROC='getAPAccountData'
               &PROGRAM='glacxr.p'
               &HANDLE=ph_glacxr
               &PARAM="(output po_ap_acct,
                        output po_ap_sub,
                        output po_ap_cc)"}

      {pxrun.i &PROC='setModificationInfo'
               &PARAM="(buffer po_mstr)"}

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE deletePurchaseOrder :

/*------------------------------------------------------------------------------
Purpose:       Delete the Purchase Order and all associated records
Exceptions:    APP-ERROR-RESULT
Conditions:
   Pre:      po_mstr(r)
   Post:     po_mstr(d), pod_det(d)

Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPONbr      as character no-undo.
   define input parameter pBlanket  like mfc_logical   no-undo.
   define input parameter pOpenRequisitionResponse as logical no-undo.

   define variable failed as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {gprun.i 'popoxf.p'
         "(input pPONbr,
           input pBlanket,
           input pOpenRequisitionResponse,
           output failed)"}

      if failed
      then
         return error {&APP-ERROR-RESULT}.

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getEdiPo :

/*------------------------------------------------------------------------------
Purpose:       Set the EDI purchase order to true or false depending
               upon the first letter value of the invoice method.
Exceptions:    NONE
Conditions:
        Pre:   None
        Post:  None
Notes:
History:
------------------------------------------------------------------------------*/
   define input  parameter pInvoiceMethod as character no-undo.
   define output parameter pEDIPO         as logical   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      pEDIPO = (substring(pInvoiceMethod,1,1) = "e" or
         substring(pInvoiceMethod,1,1) = "b").
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getInvoiceMethod :

/*------------------------------------------------------------------------------
Purpose:       Set the invoice method depending upon whether the print
               is set and the EDI setting.
Exceptions:    NONE
Conditions:
        Pre:   None.
        Post:  None.
Notes:
History:
------------------------------------------------------------------------------*/
   define input  parameter pPrint         as logical   no-undo.
   define input  parameter pEDIPO         as logical   no-undo.
   define output parameter pInvoiceMethod as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pPrint
      then do:
         if pEDIPO
         then
            pInvoiceMethod = "b".
         else
            pInvoiceMethod = "p".
      end. /* IF pPrint */
      else do:
         if pEDIPO
         then
            pInvoiceMethod = "e".
         else
            pInvoiceMethod = "n".
      end. /* ELSE */
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.
/*============================================================================*/
PROCEDURE generateNextPONumber:
/*------------------------------------------------------------------------------
  Purpose:     Connect to another appserver and call ROP to get the Next
               sequential PO Number
  Exceptions:  None
  Notes:
  History:
------------------------------------------------------------------------------*/
   define output parameter pPOId as character no-undo.

   define variable globalDB as character no-undo.
   define variable globalUserLanguageDir as character no-undo.
   define variable myAppServer as handle no-undo.
   define variable myPOROP as handle no-undo.

   do on error undo, return error return-value:

      /* OBTAIN THE NAME OF THE DEFAULT CONNECTED DB & DIRECTORY PATH */
      {pxgetph.i pxgblmgr}

      globalDB = {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                            &HANDLE=ph_pxgblmgr
                            &PARAM="input 'global_db'"}.

      globalUserLanguageDir =
            {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                       &HANDLE=ph_pxgblmgr
                       &PARAM="input 'global_user_lang_dir'"}.

      /* CONNECT TO THE NAMED APPSERVER */
      {pxascon.i &APPSERVER='mfgpro' &MULTIDB=globalDB &HANDLE=myAppServer}

      /* EXECUTE THE popogen.p IN THE NEW APPSERVER*/
      {pxasrun.i &APPSERVER=myAppServer
                 &PROGRAM='popogen.p'
                 &PARAM="(input globalUserLanguageDir, output pPOId)"
           }


      /* DISCONNECT FROM THE APPSERVER */
      {pxasdisc.i &HANDLE=myAppServer}

   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.



/*============================================================================*/
PROCEDURE getNextPONumber :

/*------------------------------------------------------------------------------
Purpose:       Return the next sequence number, increment and store on the PO
               Control file
Exceptions:    NONE
Conditions:
        Pre:   poc_ctrl(r)
       Post:   poc_ctrl(w)
Notes:
History:
------------------------------------------------------------------------------*/
   define output parameter pNextPONumber as character no-undo.

   define buffer poc_ctrl for poc_ctrl.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /*GET NEXT SEQUENCE NUMBER*/
      {mfnctrlc.i
         poc_ctrl
         poc_po_pre
         poc_po_nbr
         po_mstr
         po_nbr
         pNextPONumber}
      release poc_ctrl.

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE initializeBlanketPO :
/*------------------------------------------------------------------------------
<Comment1>
zzpopoxr.p
initializeBlanketPO (
   input  logical pBlanket,
   buffer po_mstr)

Parameters:
   pBlanket - Flag indicating if Blanket PO
   po_mstr  - Buffer for the Blanket PO

Exceptions: NONE

PreConditions: po_mstr(c)

PostConditions: po_mstr(w)

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pBlanket as logical no-undo.
   define parameter buffer po_mstr for po_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pBlanket
      then
         assign
            po_blanket  = po_nbr
            po_rel_nbr  = 0
            po_type     = "B"
            po_due_date = ?
            po_eff_strt = today.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE setPOPrint :

/*------------------------------------------------------------------------------
Purpose:       Show error message if the revision is the same as the
               old revision, and print is set to no.  Otherwise, set
               print to yes.
Exceptions:    INFORMATION-RESULT
Conditions:
        Pre:   None.
        Post:  None.
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pOldRevision  as integer no-undo.
   define input parameter pRevision     as integer no-undo.
   define input-output parameter pPrint as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pOldRevision = pRevision
      then do:
         if pPrint = no
         then do:
            /* MESSAGE #335 - REVISION NOT CHANGED - PURCHASE ORDER */
            /* HAS BEEN PRINTED */
            {pxmsg.i
               &MSGNUM=335
               &ERRORLEVEL={&INFORMATION-RESULT}
               &PAUSEAFTER=TRUE}
            /* Pauseafter was added to overcome flashing-by message, */
            /* Which existed in earlier versions.                    */
         end. /* IF pPrint = NO */
      end. /* IF pOldRevision = pRevision */
      else
         pPrint = yes.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getPriceListRequired :

/*------------------------------------------------------------------------------
Purpose:       Determine if a Price List is required for the PO and return a Flag
Exceptions:    RECORD-NOT-FOUND
Conditions:
        Pre:   None.
       Post:   None.
Notes:
History:
------------------------------------------------------------------------------*/
   define output parameter pPriceListRequired as logical no-undo.

   define buffer mfc_ctrl for mfc_ctrl.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      for first mfc_ctrl
         where mfc_field = "poc_pt_req"
         no-lock:
      end.

      if available mfc_ctrl
      then
         pPriceListRequired = mfc_logical.
      else
         pPriceListRequired = false.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getSupplier :
/*------------------------------------------------------------------------------
Purpose:       Get Supplier code from PO header.
Exceptions:    RECORD-NOT-FOUND
Conditions:
        Pre:   NONE
        Post:  None
Notes:         Extracted from iemstrcr.p.
History:
------------------------------------------------------------------------------*/
   define input parameter pOrderId as character no-undo.
   define output parameter pSupplierId as character no-undo.

   define buffer po_mstr for po_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      for first po_mstr
      fields(po_vend)
      where po_nbr = pOrderId no-lock:
         pSupplierId = po_vend.
         return {&SUCCESS-RESULT}.
      end.
      if not available po_mstr
      then
         return {&RECORD-NOT-FOUND}.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE getPreTaxTotals :
/*------------------------------------------------------------------------------
Purpose:       Calculate the taxable, non-taxable & line totals for an order.
Exceptions:    NONE
Conditions:
        Pre:   None
        Post:  None
Notes:         Extracted from pomttrld.p and pomttrlc.p.
History:
------------------------------------------------------------------------------*/
   define input parameter pOrderId as character no-undo.
   define input parameter pRoundMethod as character no-undo.
   define output parameter pLineTotal as decimal no-undo.
   define output parameter pTaxableAmt as decimal no-undo.
   define output parameter pNonTaxableAmt as decimal no-undo.

   define buffer pod_det for pod_det.


   define variable ext_actual as decimal no-undo.
   define variable mc-error-number as integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      assign
         pLineTotal = 0
         pTaxableAmt = 0
         pNonTaxableAmt = 0.
      for each pod_det
      where pod_nbr =  pOrderId
      and pod_status <> "c"
      and pod_status <> "x" no-lock:

         if ((pod__qad02 = 0 or pod__qad02 = ?) and
            (pod__qad09 = 0 or pod__qad09 = ?))
         then
            if pod_qty_ord > 0
            then
               ext_actual =  maximum( ((pod_qty_ord - pod_qty_rcvd) *
                  pod_pur_cost) * (1 - (pod_disc_pct / 100)), 0).
            else
               ext_actual =  minimum( ((pod_qty_ord - pod_qty_rcvd) *
                  pod_pur_cost) * (1 - (pod_disc_pct / 100)), 0).
         else
            if pod_qty_ord > 0
            then
               ext_actual =  maximum( ((pod_qty_ord - pod_qty_rcvd) *
                  (pod__qad09 + pod__qad02 / 100000)), 0).
            else
               ext_actual =  minimum( ((pod_qty_ord - pod_qty_rcvd) *
                  (pod__qad09 + pod__qad02 / 100000)), 0).

         /* ROUND EXT_ACTUAL PER DOCUMENT CURRENCY pRoundMethod */
         {pxrun.i &PROC='roundAmount'
                  &PROGRAM='mcexxr.p'
                  &HANDLE=ph_mcexxr
                  &PARAM="(input-output ext_actual,
                           input pRoundMethod,
                           output mc-error-number)"}

         pLineTotal = pLineTotal + ext_actual.
         if pod_taxable
         then
            pTaxableAmt = pTaxableAmt + ext_actual.
         else
            pNonTaxableAmt = pNonTaxableAmt + ext_actual.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE getTaxDate :
/*------------------------------------------------------------------------------
Purpose:       Retrieve the tax date based on PO Tax Date, Order Date or Due
               Date
Exceptions:    NONE
Conditions:
        Pre:   None
       Post:   None
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPOTaxDate as date no-undo.
   define input parameter pPODueDate as date no-undo.
   define input parameter pOrderDate as date no-undo.
   define output parameter pTaxDate as date no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pPOTaxDate <> ?
      then
         pTaxDate = pPOTaxDate.
      else
      if pPODueDate <> ?
      then
         pTaxDate = pPODueDate.
      else
         pTaxDate = pOrderDate.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE getTaxEnvironment :

/*------------------------------------------------------------------------------
Purpose:       Return the default tax environemnt based on the supplier and
               ship-to
Exceptions:    NONE
Conditions:
        Pre:   None
       Post:   None
Notes:
History:
------------------------------------------------------------------------------*/
   define input  parameter pSupplierId     as character no-undo.
   define input  parameter pSiteId         as character no-undo.
   define input  parameter pShipToId       as character no-undo.
   define input  parameter pTaxClass       as character no-undo.
   define output parameter pTaxEnvironment as character no-undo.

   define variable zoneFrom as character no-undo.
   define variable zoneTo   as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='getZoneFrom'
               &PARAM="(input pSupplierId, output zoneFrom)"}

      {pxrun.i &PROC='getZoneTo'
               &PARAM="(input pSiteId, input pShipToId, output zoneTo)"}

      {pxrun.i &PROC='getTaxEnvironment' &PROGRAM='txenvxr.p'
               &HANDLE=ph_txenvxr
               &PARAM="(input  zoneTo,
                        input  zoneFrom,
                        input  pTaxClass,
                        output pTaxEnvironment)"}

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getTaxTypeTaxNbr :
/*------------------------------------------------------------------------------
Purpose:       Get tax transaction type.
Exceptions:    NONE
Conditions:
        Pre:   None
        Post:  NONE
Notes:         Extracted from pomttrld.p and pomttrlc.p.
History:
------------------------------------------------------------------------------*/
   define input parameter pBlanketOrder as character no-undo.
   define input parameter pFSMType as character no-undo.
   define output parameter pTaxNumber as character no-undo.
   define output parameter pTaxTransactionType as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      assign
         pTaxNumber = pBlanketOrder
         pTaxTransactionType =
            if pFSMType = "RTS" then "37" else "20".
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE getZoneFrom :

/*------------------------------------------------------------------------------
Purpose:       Obtain the default Tax Zone for the Supplier Address
Exceptions:    NONE
Conditions:
        Pre:   ad_mstr(r)
       Post:   None
Notes:
History:
------------------------------------------------------------------------------*/
   define input  parameter pSupplierId as character no-undo.
   define output parameter pZoneFrom as character no-undo.

   define variable dummyLogicalValue as logical no-undo.
   define variable dummyCharValue    as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* GET VENDOR SHIP-FROM TAX ZONE FROM ADDRESS */
      {pxrun.i &PROC='getTaxData' &PROGRAM='adadxr.p'
               &HANDLE=ph_adadxr
               &PARAM="(input  pSupplierId,
                        output dummyLogicalValue,     /*taxable*/
                        output dummyCharValue,        /*taxClass*/
                        output dummyLogicalValue,     /*taxIncluded*/
                        output dummyCharValue,        /*taxType*/
                        output dummyCharValue,        /*taxUsage*/
                        output pZoneFrom)"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getZoneTo :

/*------------------------------------------------------------------------------
Purpose:       Obtain the Tax Zone for the Purchaser, this is either from the
               site address, ship to address or the default Tax control record
               for the installation.
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   None
       Post:   None
Notes:
History:
------------------------------------------------------------------------------*/
   define input  parameter pSiteAddress as character no-undo.
   define input  parameter pShipAddress as character no-undo.
   define output parameter pZoneTo      as character no-undo.

   define variable dummyLogicalValue as logical no-undo.
   define variable dummyCharValue    as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* GET SHIP-TO TAX ZONE FROM pSiteAddress ADDRESS */
      {pxrun.i &PROC='getTaxData' &PROGRAM='adadxr.p'
               &HANDLE=ph_adadxr
               &PARAM="(input pSiteAddress,
                        output dummyLogicalValue,    /*taxable*/
                        output dummyCharValue,       /*taxClass*/
                        output dummyLogicalValue,    /*taxIncluded*/
                        output dummyCharValue,       /*taxType*/
                        output dummyCharValue,       /*taxUsage*/
                        output pZoneTo)"}

      if return-value <> {&SUCCESS-RESULT}
      then do:

         /*ONLY GET VALUE FOR SHIP-TO IF IT EXISTS (NOT NULL)*/
         if pShipAddress <> ""
         then do:
            /* GET SHIP-TO TAX ZONE FROM pShipAddress ADDRESS */
            {pxrun.i &PROC='getTaxData' &PROGRAM='adadxr.p'
                     &HANDLE=ph_adadxr
                     &PARAM="(input pShipAddress,
                              output dummyLogicalValue,    /*taxable*/
                              output dummyCharValue,       /*taxClass*/
                              output dummyLogicalValue,    /*taxIncluded*/
                              output dummyCharValue,       /*taxType*/
                              output dummyCharValue,       /*taxUsage*/
                              output pZoneTo)"}
         end.

         if return-value <> {&SUCCESS-RESULT}
         then do:
            /* USE TAX DEFAULT COMPANY ADDRESS */
         {pxrun.i &PROC='getTaxData' &PROGRAM='adadxr.p'
                  &HANDLE=ph_adadxr
                  &PARAM="(input '~~~~taxes',
               /* (WILL NOT WORK WITH FEWER THAN 4 TILDES) */
                           output dummyLogicalValue,    /*taxable*/
                           output dummyCharValue,       /*taxClass*/
                           output dummyLogicalValue,    /*taxIncluded*/
                           output dummyCharValue,       /*taxType*/
                           output dummyCharValue,       /*taxUsage*/
                           output pZoneTo)"}
            if return-value <> {&SUCCESS-RESULT}
            then do:
               pZoneTo = "".
               /* MESSAGE #864 - SITE ADDRESS DOES NOT EXIST */
               {pxmsg.i
                  &MSGNUM=864
                  &ERRORLEVEL={&WARNING-RESULT}}
               return {&WARNING-RESULT}.
            end.
         end.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE processCreate :

/*------------------------------------------------------------------------------
Purpose:       Create the Purchase Order header record. Validate and assign
               default values.
Exceptions:    NONE
Conditions:
        Pre:   None
       Post:   po_mstr(c)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPOId       as character no-undo.
   define parameter buffer po_mstr for po_mstr.

   define variable dummyLogicalValue as logical no-undo.
   define variable dummyCharValue    as character no-undo.
   define variable shipToValue       as character no-undo.
   define buffer poc_ctrl for poc_ctrl.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='createPurchaseOrder'
         &PARAM="(input pPOId,
                  buffer po_mstr)"}

      /* MARK THE RECORD AS NEW IN THE INFRASTRUCTURE */
      {pxrun.i &PROC='setNewRecord'
               &PROGRAM='pxtools.p'
               &HANDLE=ph_pxtools
               &PARAM="(input buffer po_mstr:handle, input TRUE)"}

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE processDelete :

/*------------------------------------------------------------------------------
Purpose:       Control the deletion of the PO record
Exceptions:    NONE
Conditions:
        Pre:   po_mstr(r)
       Post:   po_mstr(d), pod_det(d)
Notes:
History:
------------------------------------------------------------------------------*/
   define parameter buffer po_mstr for po_mstr.
   define input parameter pBlanket as logical no-undo.
   define input parameter pOpenRequisitionResponse as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='deletePurchaseOrder'
               &PARAM="(input po_nbr,
                        input pBlanket,
                        input pOpenRequisitionResponse)"}

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE processRead :

/*------------------------------------------------------------------------------
Purpose:       Read the po_mstr record
Exceptions:    RECORD-NOT-FOUND, RECORD-LOCKED
Conditions:
        Pre:   None
       Post:   po_mstr(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPOId as character no-undo.
   define parameter buffer po_mstr for po_mstr.
   define input parameter pLock as logical   no-undo.
   define input parameter pWait as logical   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      if pLock
      then do:
         if pWait
         then do:
            for first po_mstr where po_nbr = pPOId exclusive-lock:
            end.
         end.
         else do:
            find first po_mstr where po_nbr = pPOId
               exclusive-lock no-error no-wait.
            if locked po_mstr
            then
               return {&RECORD-LOCKED} .
         end.
      end.
      else do:
         for first po_mstr where po_nbr = pPOId no-lock:
         end.
      end.
      if not available po_mstr
      then
         return {&RECORD-NOT-FOUND}.

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE readPOControl :

/*------------------------------------------------------------------------------
Purpose:       Read the Purchase Order Control file into scope
Exceptions:    {&APP-ERROR-RESULT}
Conditions:
        Pre:   None
       Post:   poc_ctrl(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define parameter buffer poc_ctrl for poc_ctrl.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      for first poc_ctrl no-lock:
      end.

      if not available poc_ctrl
      then do:
         /*594-CONTROL FILE ERROR.CHECK APPLICABLE CONTROL FILES FOR EXISTENCE*/
         {pxmsg.i
            &MSGNUM=594
            &ERRORLEVEL={&APP-ERROR-NO-REENTER-RESULT}}

         /*291 - NO CONTROL FILE RECORD FOUND FOR poc_ctrl*/
         {pxmsg.i
            &MSGNUM=291
            &ERRORLEVEL={&APP-ERROR-NO-REENTER-RESULT}
            &MSGARG1='poc_ctrl'}
         return error {&APP-ERROR-RESULT}.
      end.

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE reOpenPurchaseOrder :
/*------------------------------------------------------------------------------
Purpose:       ReOpens A Purchase Order
Exceptions:    NONE
Conditions:
        Pre:   po_mstr(r)
        Post:  po_mstr(w)
Notes:
History:       Extracted from popomth.p
------------------------------------------------------------------------------*/
   define input parameter pPOId as character no-undo.

   define buffer po_mstr for po_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='processRead'
               &PARAM="(input pPOId,
                        buffer po_mstr,
                        input TRUE,
                        input TRUE)"}

      if return-value = {&SUCCESS-RESULT}
      then do:
         po_stat = "".
         {pxrun.i &PROC='purchaseOrderIsReOpened'
                  &PARAM="(buffer po_mstr)"}
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE purchaseOrderIsReOpened :
/*------------------------------------------------------------------------------
Purpose:       Updates A Purchase Order after it is ReOpened.
Exceptions:    NONE
Conditions:
        Pre:   po_mstr(r)
        Post:  po_mstr(w)
Notes:
History:       Extracted from popomth.p
------------------------------------------------------------------------------*/
   define parameter buffer pPo_mstr for po_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      po_cls_date = ?.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE setModificationInfo :

/*------------------------------------------------------------------------------
Purpose:       Update the modification information to indicate the user
               of the last modification to the record
Exceptions:    NONE
Conditions:
        Pre:   po_mstr(r)
       Post:   po_mstr(w)
Notes:
History:
------------------------------------------------------------------------------*/
   define parameter buffer po_mstr for po_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* STORE USERID */
      {pxgetph.i pxgblmgr}

      po_user_id
         = {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                      &HANDLE=ph_pxgblmgr
                      &PARAM="input 'global_userid'"}.

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE setSupplierDefaults :

/*------------------------------------------------------------------------------
Purpose:       Assign default value to the Purchase Order based on the Supplier
               Identified.
Exceptions:    NONE
Conditions:
        Pre:   ad_mstr(r), vd_mstr(r)
       Post:   po_mstr(w)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pSupplierId as character no-undo.
   define parameter buffer po_mstr for po_mstr.

   define buffer vd_mstr for vd_mstr.
   define buffer ad_mstr for ad_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='processRead' &PROGRAM='adsuxr.p'
               &HANDLE=ph_adsuxr
               &PARAM="(input pSupplierId,
                        buffer vd_mstr,
                        input no,
                        input no)"}

      if return-value = {&SUCCESS-RESULT}
      then do:

         /* Get invoice method from address */
         {pxrun.i &PROC='processRead' &PROGRAM='adadxr.p'
                  &HANDLE=ph_adadxr
                  &PARAM="(input pSupplierId,
                           buffer ad_mstr,
                           input no,
                           input no)"}

         if return-value = {&SUCCESS-RESULT}
         then
            po_mstr.po_inv_mthd = ad_mstr.ad_po_mthd.

         /* USE VENDOR INFO FOR DEFAULT */
         assign
            po_vend     = pSupplierId
            po_cr_terms = vd_mstr.vd_cr_terms
            po_buyer    = vd_buyer
            po_disc_pct = vd_disc_pct
            po_shipvia  = vd_shipvia
            po_taxable  = vd_taxable
            po_contact  = vd_pur_cntct
            po_rmks     = vd_rmks
            po_ap_acct  = vd_ap_acct
            po_ap_sub   = vd_ap_sub
            po_ap_cc    = vd_ap_cc
            po_curr     = vd_curr
            po_pr_list  = vd_pr_list
            po_pr_list2 = vd_pr_list2
            po_fix_pr   = vd_fix_pr
            po_lang     = vd_lang.

         if po_inv_mthd = "n"
         or po_inv_mthd = "e"
         then do:
            po_print = no.
         end.

      end.

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateAccountCurrency :

/*------------------------------------------------------------------------------
Purpose:       Call retrieve account currency from API call.  Validate
               the account currency.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   None.
        Post:  ac_mstr(r)
Notes:
History:
------------------------------------------------------------------------------*/
   /* ADDED THE INPUT PARAMETERS pPurchaseDt AND pCheckEuro */
   /* TO CHECK FOR EURO TRANSPARENCY                        */

   define input parameter pAccountCode as   character   no-undo.
   define input parameter pCurrencyId  as   character   no-undo.
   define input parameter pBaseCurr    as   character   no-undo.
   define input parameter pPurchaseDt  as   date        no-undo.
   define input parameter pCheckEuro   like mfc_logical no-undo.

   define variable accountCurrency like ac_curr no-undo.
   define variable l_error         as   integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='getAccountCurrency' &PROGRAM='glacxr.p'
               &HANDLE=ph_glacxr
               &PARAM="(input pAccountCode,
                        output accountCurrency)"}
      if return-value = {&SUCCESS-RESULT}
         and accountCurrency <> pCurrencyId
         and accountCurrency <> pBaseCurr
         then do:

            if pCheckEuro
            then do:
               {pxrun.i &PROC='mc-chk-transaction-curr' &PROGRAM='mcpl.p'
                        &HANDLE=ph_mcpl
                        &PARAM="(input  accountCurrency,
                                 input  pCurrencyId,
                                 input  pPurchaseDt,
                                 input  true,
                                 output l_error)"}
            end. /* IF pCheckEuro */

            if l_error <> 0
            or not pCheckEuro
            then do:
               /* MESSAGE #134 - ACCOUNT CURRENCY MUST MATCH BASE OR */
               /* TRANSACTION CURRENCY */
               {pxmsg.i
                  &MSGNUM=134
                  &ERRORLEVEL={&APP-ERROR-RESULT}}
               return error {&APP-ERROR-RESULT}.
            end. /* IF l_error <> 0 */
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateBillToAddress :

/*------------------------------------------------------------------------------
Purpose:       Validate the Bill-To Id entered is a valid address
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   None
       Post:   ad_mstr(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pBillToId as character no-undo.

   define buffer ad_mstr for ad_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='processRead' &PROGRAM='adadxr.p'
               &HANDLE=ph_adadxr
               &PARAM="(input pBillToId,
                        buffer ad_mstr,
                        input no,
                        input no)"}
      if return-value = {&RECORD-NOT-FOUND}
      then do:
         /* MESSAGE #2577 - BILL-TO ADDRESS DOES NOT EXIST */
         {pxmsg.i
            &MSGNUM=2577
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateBlanketEstValue :
/*------------------------------------------------------------------------------
<Comment1>
zzpopoxr.p
validateBlanketEstValue (
   input  decimal   pBlanketPOEstVal,
   input  character pRoundMethod,
   output integer   pRetVal)

Parameters:
   pBlanketPOEstVal - Estimated value of the Blanket PO
   pRoundMethod     - Rounding method of the Blanket PO Currency
   pRetVal          - Return value to determine error condition

Exceptions: NONE

PreConditions: po_mstr(r)

PostConditions: Validated Blanket PO Estimated Value

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input  parameter pBlanketPOEstVal as decimal   no-undo.
   define input  parameter pRoundMethod     as character no-undo.

   define variable lRetVal as integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if (pBlanketPOEstVal <> 0)
      then do:
         {gprun.i ""gpcurval.p"" "(input pBlanketPOEstVal,
                                   input  pRoundMethod,
                                   output lRetVal)"}
         if lRetVal <> 0
         then
            return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE validateBlanketPO :

/*------------------------------------------------------------------------------
Purpose:       Validate that the entered PO Id is not a Blanket PO
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   po_mstr(r)
       Post:   None
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPOType as character no-undo.
   define input parameter pBlanket as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pPOType <> "B" and pBlanket
      then do:
         /* MESSAGE #383 - THIS IS NOT A BLANKET ORDER */
         {pxmsg.i
            &MSGNUM=383
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
         /*undo mainloop, retry mainloop.*/
      end.
      if pPOType = "B" and not pBlanket
      then do:
         /* MESSAGE #385 - BLANKET ORDER NOT ALLOWED */
         {pxmsg.i
            &MSGNUM=385
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateBlanketStart :
/*------------------------------------------------------------------------------
<Comment1>
zzpopoxr.p
validateBlanketStart (
   input date pBlanketPOStartDate,
   input date pBlanketPOEndDate)

Parameters:
   pBlanketPOStartDate - Start Date for the Blanket PO
   pBlanketPOEndDate   - End Date for the Blanket PO

Exceptions: {&APP-ERROR-RESULT}

PreConditions: po_mstr(r)

PostConditions: Validated Blanket PO Start and End date combination

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pBlanketPOStartDate as date no-undo.
   define input parameter pBlanketPOEndDate   as date no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pBlanketPOStartDate <> ? and pBlanketPOEndDate <> ? and
         pBlanketPOStartDate > pBlanketPOEndDate
      then do:
         /* MESSAGE #4 - START DATE MUST BE PRIOR TO END DATE */
         {pxmsg.i
            &MSGNUM=4
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE validateCreditTermsInterest :

/*------------------------------------------------------------------------------
Purpose:       Validate that the credit terms interest for the PO matches the
               master Terms interest
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   ct_mstr(r)
       Post:   None
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pCreditTerms as character no-undo.
   define input parameter pTermsInterest as decimal no-undo.

   define variable masterTermsInterest as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='getCreditTermsInterest' &PROGRAM='adcrxr.p'
               &HANDLE=ph_adcrxr
               &PARAM="(input  pCreditTerms,
                        output masterTermsInterest)"}
      if return-value = {&SUCCESS-RESULT}
      then do:
         if pTermsInterest <> 0
         then do:
            if pTermsInterest <> masterTermsInterest
            then do:
               /* MESSAGE #6212 - ENTERED TERMS INTEREST # DOES */
               /* NOT MATCH CREDIT TERMS INTEREST # */
               {pxmsg.i
                  &MSGNUM=6212
                  &ERRORLEVEL={&WARNING-RESULT}
                  &MSGARG1=pTermsInterest
                  &MSGARG2=masterTermsInterest}
               return {&WARNING-RESULT}.
            end.
         end.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateDiscountList :

/*------------------------------------------------------------------------------
Purpose:       Validate the entered Discount list is valid for the PO
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   None
       Post:   poc_ctrl(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPriceList as character no-undo.
   define input parameter pCurr      as character no-undo.

   define buffer poc_ctrl for poc_ctrl.
   define variable discListValidationFailed as logical no-undo.
   define variable discListErrorMsg         as integer no-undo.

   /* PRICE LIST TYPES CONSTANT DEFINITION INCLUDE FILE */
   {ppprlst.i}

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='readPOControl' &PARAM="(buffer poc_ctrl)"}
      {pxrun.i &PROC='validatePriceList' &PROGRAM='ppplxr.p'
               &HANDLE=ph_ppplxr
               &PARAM="(input pPriceList,
                        input pCurr,
                        input poc_ctrl.poc_pl_req,
                        input false,
                        input {&DISCOUNT-TYPE},
                        output discListValidationFailed,
                        output discListErrorMsg)"
      }
      if discListValidationFailed
      then do:
         {pxmsg.i
            &MSGNUM=discListErrorMsg
            &ERRORLEVEL={&WARNING-RESULT}
         }
         return {&WARNING-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateEMTOrder :

/*------------------------------------------------------------------------------
Purpose:       Validate PO to prevent update if the PO is a EMT order
               (Enterprise Material Transfer)
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   po_mstr(r)
       Post:   None
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pIsEMTOrder as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pIsEMTOrder
      then do:
         /* MESSAGE #2827 - EMT PURCHASE ORDER CANNOT BE MODIFIED */
         {pxmsg.i
            &MSGNUM=2827
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &PAUSEAFTER=true}
         /* BTB PO ARE NOT ALLOWED */
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateERSOption :

/*------------------------------------------------------------------------------
Purpose:        Validate ERS Option available to Purchase Orders. This is a
                of the valid ones allowed for  ERS in general
Exceptions:     APP-ERROR-RESULT
Conditions:
         Pre:   None.
        Post:   None.
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pERSOption as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if not ({gppoers.v pERSOption})
      then do:
         /* MESSAGE #2303 - INVALID ERS OPTION */
         {pxmsg.i
            &MSGNUM=2303
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateExchangeRate :

/*------------------------------------------------------------------------------
Purpose:        Validate the Exchange Rate entered by the client to ensure that
      the rate entered is greater than 0
      Exceptions:     APP-ERROR-RESULT
      Conditions:
                Pre:            None.
                Post:           None.
                Notes:
                History:
------------------------------------------------------------------------------*/
   define input parameter pExchangeRate as character no-undo.
   /* THIS MAY LOOK LIKE IT SHOULD BE DECIMAL, BUT IT NEEDS TO BE CHARACTER */
   /* BECAUSE IT IS PASSED FROM A GENERIC PROCEDURE WHICH TREATS ALL DATA  */
   /* AS CHARACTER. */

   define variable exchangeRate as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      assign exchangeRate = decimal(pExchangeRate) no-error.

      if error-status:error
      or exchangeRate <= 0
      then do:

         /* MESSAGE #3163 - EXCHANGE RATE MUST BE GREATER THAN ZERO */
         {pxmsg.i &MSGNUM=3163
                  &ERRORLEVEL={&APP-ERROR-RESULT}}

         return error {&APP-ERROR-RESULT}.
      end.

   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateNotPrinted:

/*------------------------------------------------------------------------------
Purpose:       Show error message if the purchase order has been printed.
               This is usually to verify that modifications can be made
               to an existing purchase order.
Exceptions:    INFORMATION-RESULT
Conditions:
        Pre:   None.
        Post:  None.
Notes:         Extracted from popomtb.p
History:
------------------------------------------------------------------------------*/
   define input parameter pPrint as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pPrint = no
      then do:
      /* No means PO has been printed, yes means PO waiting to be printed */
         /* MESSAGE #302 - PURCHASE ORDER ALREADY PRINTED */
         {pxmsg.i
            &MSGNUM=302
            &ERRORLEVEL={&INFORMATION-RESULT}
            &PAUSEAFTER=TRUE}
      end. /* IF pPrint = NO */
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOAcctPayAcct :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_ap_acct
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* USER DOES NOT HAVE ACCESS TO THIS FIELD. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'po_ap_acct',
                        input '')"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOAcctPayCC :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_ap_cc
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* USER DOES NOT HAVE ACCESS TO THIS FIELD. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'po_ap_cc',
                        input '')"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOAPSubAcct :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_ap_sub.
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* USER DOES NOT HAVE ACCESS TO THIS FIELD. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'po_ap_sub',
                        input '')"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOBuyer :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_buyer
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: VALUE MUST EXIST IN GENERALIZED CODES. */
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
               &HANDLE=ph_gpcodxr
               &PARAM="(input 'po_buyer',
                        input '',
                        input pValue,
                        input '')"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOCreditTerms :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_cr_terms
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   ct_mstr(r)
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* 840 - CREDIT TERMS CODE MUST EXIST OR BE BLANK */
      if not(can-find(ct_mstr where ct_code = pValue)
         or pValue = "")
      then do:
         {pxmsg.i
            &MSGNUM=840
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOCreditTermsInt:

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_crt_int
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema. (Field added after baseline code)
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* USER DOES NOT HAVE ACCESS TO THIS FIELD. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'po_crt_int',
                        input '')"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOCurrency :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_curr
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* USER DOES NOT HAVE ACCESS TO THIS FIELD. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'po_curr',
                       input '')"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePODutyType :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_duty_type
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* VALUE MUST EXIST IN GENERALIZED CODES. */
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
               &HANDLE=ph_gpcodxr
               &PARAM="(input 'po_duty_type',
                        input '',
                        input pValue,
                        input '')"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOERSOption :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_ers_opt.
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
  define input parameter pValue as character no-undo.

  do on error undo, return error {&GENERAL-APP-EXCEPT}:
     /* USER DOES NOT HAVE ACCESS TO THIS FIELD. */
     {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
              &HANDLE=ph_gpsecxr
              &PARAM="(input 'po_ers_opt',
                       input '')"}
  end.
  return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOERSPriceListOption :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_pr_lst_tp.
  Exceptions:     APP-ERROR-RESULT
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* MESSAGE #3769 - PRICE LIST OPTION MUST BE 0, 1, 2, OR 3 */
      if not({gpprlst.v integer(pValue)})
      then do:

         {pxmsg.i &MSGNUM=3769
                  &ERRORLEVEL={&APP-ERROR-RESULT}}

         return error {&APP-ERROR-RESULT}.
      end.
   end.
  return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOExchangeRate :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_ent_ex.
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* USER DOES NOT HAVE ACCESS TO THIS FIELD. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'po_ent_ex',
                        input '')"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOFixedPrice :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_fix_pr.
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* USER DOES NOT HAVE ACCESS TO THIS FIELD. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'po_fix_pr',
                        input '')"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOFob :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_fob
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.

  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: VALUE MUST EXIST IN GENERALIZED CODES. */
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
               &HANDLE=ph_gpcodxr
               &PARAM="(input 'po_fob',
                        input '',
                        input pValue,
                        input '')"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOId :

/*------------------------------------------------------------------------------
  Purpose:        Validate the PO Id specified conforms to rules required for
                  creating a valid purchase order
  Exceptions:     APP-ERROR-RESULT
  Conditions:
          Pre:    None
          Post:   po_mstr(r)
  Notes:
  History:
------------------------------------------------------------------------------*/
   define input parameter pPOId as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* Make sure PO Id is not blank. This must be assured at this point. */
      /* The value must either be entered or the next value generated      */
      if pPOId = ""
      then do:
         /*MESSAGE #40 - BLANK NOT ALLOWED*/
         {pxmsg.i
            &MSGNUM=40
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.

      if can-find(first po_mstr where po_nbr = pPOId)
      then do:
         /*MESSAGE #914 - UNABLE TO CREATE; RECORD ALREADY EXISTS WITH # */
         {pxmsg.i
            &MSGNUM=914
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &MSGARG1=pPOId}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOLanguage :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_lang
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='validateLanguageCode' &PROGRAM='gplngxr.p'
               &HANDLE=ph_gplngxr
               &PARAM="(input 'po_lang',
                        input pValue,
                        input TRUE,
                        input '')"}

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOOrderDate :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_ord_date
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as date no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* USER DOES NOT HAVE ACCESS TO THIS FIELD */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'po_ord_date',
                        input '')"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOPriceList2 :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_pr_list2.
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* USER DOES NOT HAVE ACCESS TO THIS FIELD. PLEASE RE-ENTER. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'po_pr_list2',
                        input '')"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOProject :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_project.
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateProjectCode' &PROGRAM='glacxr.p'
               &HANDLE=ph_glacxr
               &PARAM="(input pValue)"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOShipVia :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_shipvia
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.

  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: VALUE MUST EXIST IN GENERALIZED CODES. */
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
               &HANDLE=ph_gpcodxr
               &PARAM="(input 'po_shipvia',
                        input '',
                        input pValue,
                        input '')"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOSite :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_site.
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* INVALID SITE. PLEASE RE-ENTER. */
      {pxrun.i &PROC='validateSite' &PROGRAM='icsixr.p'
               &HANDLE=ph_icsixr
               &PARAM="(input 'po_site',
                        input pValue,
                        input yes,
                        input '')"}
      /* USER DOES NOT HAVE ACCESS TO THIS FIELD. */
      {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'po_site',
                        input '')"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOStatus :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_stat
  Exceptions:     APP-ERROR-RESULT
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: STATUS MUST BE BLANK (OPEN), C (CLOSED), */
      /* OR X (CANCELLED). */
      if not(pValue = "" or pValue = "C" or pValue = "X")
      then do:
         {pxmsg.i &MSGNUM=3465
                  &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOTaxUsage :

/*------------------------------------------------------------------------------
  Purpose:        Validate po_mstr.po_tax_usage.
  Exceptions:     NONE
  Conditions:
           Pre:   po_mstr(r)
          Post:   None.
  Notes:
  History:        Pulled from schema.
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* ERROR: VALUE MUST EXIST IN GENERALIZED CODES */
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
               &HANDLE=ph_gpcodxr
               &PARAM="(input 'tx2_tax_usage',
                        input '',
                        input pValue,
                        input '')"}
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePrepaid :

/*------------------------------------------------------------------------------
Purpose:       Run the validate currency input according to rounding
               method.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   po_mstr(r)
        Post:  None
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPrepaidAmt  as decimal   no-undo.
   define input parameter pRoundMethod as character no-undo.

   define variable retval as integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if (pPrepaidAmt <> 0)
      then do:
         {gprun.i ""gpcurval.p"" "(input pPrepaidAmt,
                                   input pRoundMethod,
                                   output retval)"}
         if retval <> 0
         then
            return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePriceList :

/*------------------------------------------------------------------------------
Purpose:       Validate that the entered Price List is valid for the PO
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   po_mstr(r)
       Post:   poc_ctrl(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPriceList as character no-undo.
   define input parameter pCurr      as character no-undo.

   define variable priceListRequired as logical no-undo.
   define variable priceListValidationFailed as logical no-undo.
   define variable priceListErrorMsg         as integer no-undo.

   /* PRICE LIST TYPES CONSTANT DEFINITION INCLUDE FILE */
   {ppprlst.i}

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='getPriceListRequired'
               &PARAM="(output priceListRequired)"}
      /* NOTE - POC-PT-REQ IS NOT BEING USED FOR PRICE-LIST-REQUIRED */
      /* MFC_CTRL IS USED INSTEAD                                    */
      {pxrun.i &PROC='validatePriceList' &PROGRAM='ppplxr.p'
               &HANDLE=ph_ppplxr
               &PARAM="(input pPriceList,
                        input pCurr,
                        input priceListRequired,
                        input false,
                        input {&LIST-TYPE},
                        output priceListValidationFailed,
                        output priceListErrorMsg)"
         }

      if priceListValidationFailed
      then do:
         {pxmsg.i
            &MSGNUM=priceListErrorMsg
            &ERRORLEVEL={&WARNING-RESULT}
         }
         return {&WARNING-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateRTSOrder :
/*------------------------------------------------------------------------------
Purpose:       Validate PO to prevent update if the PO is a RTS (Return To
               Supplier) order.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   po_mstr(r)
       Post:   None
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pFMSType as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pFMSType <> ""
      then do:
         /* Can not process RTS orders with PO programs. */
         /* MESSAGE #7364 - CANNOT PROCESS RTS ORDERS WITH */
         /* PURCHASE ORDER PROGRAMS */
         {pxmsg.i
            &MSGNUM=7364
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateScheduledOrder :
/*------------------------------------------------------------------------------
Purpose:       Validate PO to test if it is a Supplier Scheduled Order
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   po_mstr(r)
       Post:   None
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pScheduledOrder as logical no-undo.
   define input parameter pSeverity as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pScheduledOrder
      then do:
         /* MESSAGE #8210 - ORDER WAS CREATED BY SCHEDULED ORDER */
         /* MAINTENANCE */
         {pxmsg.i
            &MSGNUM=8210
            &ERRORLEVEL=pSeverity}
         if pSeverity = {&WARNING-RESULT}
         then
            return pSeverity.
         else
            return error pSeverity.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.


/*============================================================================*/
PROCEDURE validateShipperExists:
/*------------------------------------------------------------------------------
Purpose:       Validate that a shipper exists.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   None
       Post:   None
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pOrderStatus as character no-undo.
   define input parameter pOrderNumber as character no-undo.
   define input parameter pSiteId      as character no-undo.
   define input parameter pPOLineId    as integer   no-undo.

   /* CHANGED THIRD INPUT PARAMETER TO pSiteId FROM '*' */
   /* AND FOURTH INPUT PARAMETER TO pPOLineId FROM 0    */
   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateShipperExists' &PROGRAM='popoxr1.p'
               &HANDLE=ph_popoxr1
               &PARAM="(input pOrderStatus,
                        input pOrderNumber,
                        input pSiteId,
                        input pPOLineId)"
               &NOAPPERROR=true
               &CATCHERROR=true}
      /* PASS ERRORS BACK DOWN TO CALLING PROCEDURE */
      if return-value <> {&SUCCESS-RESULT}
      then
         return error return-value.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateShipTo:
/*------------------------------------------------------------------------------
Purpose:       Validate that the entered Ship-To Id is a valid Ship-To Address
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   None
       Post:   None
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pShipToId as character no-undo.

   define buffer ad_mstr for ad_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='processRead' &PROGRAM='adadxr.p'
               &HANDLE=ph_adadxr
               &PARAM="(input pShipToId,
                        buffer ad_mstr,
                        input no,
                        input no)"}

      if return-value = {&RECORD-NOT-FOUND}
      then do:
         /* MESSAGE #8501 - SHIP-TO DOES NOT EXIST */
         {pxmsg.i
            &MSGNUM=8501
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.


/*============================================================================*/
PROCEDURE validateSupplier :
/*------------------------------------------------------------------------------
Purpose:       Validate the entered supplier Id to ensure a valid supplier
               record exists.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   None
       Post:   None
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pSupplierId as character no-undo.

   define buffer ad_mstr for ad_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='validateSupplierId' &PROGRAM='adsuxr.p'
               &HANDLE=ph_adsuxr
               &PARAM="(input pSupplierId)"}

      /* Check Address Record */
      {pxrun.i &PROC='processRead' &PROGRAM='adadxr.p'
               &HANDLE=ph_adadxr
               &PARAM="(input pSupplierId,
                        buffer ad_mstr,
                        input no,
                        input no)"}
      if return-value = {&RECORD-NOT-FOUND}
      then do:
         /* MESSAGE #2 - NOT A VALID SUPPLIER */
         {pxmsg.i
            &MSGNUM=2
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.


/*============================================================================*/
PROCEDURE validateSupplierCurrency :
/*------------------------------------------------------------------------------
Purpose:       Validate that the Supplier default currency is the same as the
               PO transaction currency entered.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   None
       Post:   None
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pCurrency   as character no-undo.
   define input parameter pSupplierId as character no-undo.

   define variable supplierCurr as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='getSupplierCurrency' &PROGRAM='adsuxr.p'
               &HANDLE=ph_adsuxr
               &PARAM="(input  pSupplierId,
                        output supplierCurr)"}

      if (pCurrency <> supplierCurr)
      then do:
         /* MESSAGE #6225 - SUPPLIER CURRENCY MUST BE */
         /* CONSISTENT WITH PURCHASE ORDER */
         {pxmsg.i
            &MSGNUM=6225
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateSupplierReceipts :

/*------------------------------------------------------------------------------
Purpose:       Validate PO to ensure that no Transaction History Records exist
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   po_mstr(r)
       Post:   tr_hist(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pSupplierId as character no-undo.
   define input parameter pPOId       as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if can-find(first tr_hist where tr_addr = pSupplierId
                     and tr_nbr = pPOId
                     and tr_type = "RCT-PO")
      then do:
         /* MESSAGE #7303 - CANNOT MODIFY # -- TRANSACTION */
         /* HISTORY EXISTS */
         {pxmsg.i
            &MSGNUM=7303
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validatePOEditStatus :

/*------------------------------------------------------------------------------
Purpose:       Check the Status of the PO and issue a message if the PO is
               Closed or Cancelled
Exceptions:    INFORMATION-RESULT
Conditions:
        Pre:   po_mstr(r)
       Post:   None
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pStatusValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pStatusValue = "C"
      then do:
         /* MESSAGE #326 - PURCHASE ORDER CLOSED */
         {pxmsg.i
            &MSGNUM=326
            &ERRORLEVEL={&INFORMATION-RESULT}}
         return {&INFORMATION-RESULT}.
      end.
      else
      if pStatusValue = "X"
      then do:
         /* MESSAGE #395 - PURCHASE ORDER CANCELLED */
         {pxmsg.i
            &MSGNUM=395
            &ERRORLEVEL={&INFORMATION-RESULT}}
         return {&INFORMATION-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE validateExistingPO :
/*------------------------------------------------------------------------------
Purpose:       Validate that the purchaseOrderId entered has not already been
               used.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   None
       Post:   None
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPOId   as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      if can-find(po_mstr
                  where po_mstr.po_nbr = pPOId)
      then do:
         /* MESSAGE #914 - RECORD ALREADY EXISTS WITH # */
         {pxmsg.i
            &MSGNUM=914
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &MSGARG1=pPOId}
         return error {&APP-ERROR-RESULT}.
      end.

   end.
   return {&SUCCESS-RESULT}.

END PROCEDURE.

