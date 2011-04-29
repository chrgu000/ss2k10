/* rqgrsxr1.p - GRS Requisitions Line Item Record ROP                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15 $                                                          */
/*                                                                            */
/* This routine provides the procedures which are executed as a result of the */
/* call from the appropriate Data Type Controllers / structured programs      */
/* It contains business logic pertaining to Global Requisition Lines          */
/*                                                                            */
/* Revision: 1.1   BY: Bill Pedersen              DATE: 04/25/00  ECO: *N059* */
/* Revision: 1.2   BY: Stefan Sepanaho            DATE: 08/17/00  ECO: *N0KF* */
/* Revision: 1.5   BY: Stefan Sepanaho            DATE: 08/22/00  ECO: *N0MJ* */
/* Revision: 1.8   BY: Julie Milligan             DATE: 08/24/00  ECO: *N0N2* */
/* Revision: 1.9   BY: Stefan Sepanaho            DATE: 08/28/00  ECO: *N0P8* */
/* Revision: 1.12  BY: Pat Pigatti                DATE: 08/31/00  ECO: *N0MT* */
/* Revision: 1.14  BY: Julie Milligan             DATE: 08/31/00  ECO: *N0S0* */
/* $Revision: 1.15 $    BY: Murali Ayyagari            DATE: 12/01/00  ECO: *N0V1* */
/*                                                                            */
/*V8:ConvertMode=NoConvert                                                    */

/* ========================================================================== */
/* ******************************* DEFINITIONS ****************************** */
/* ========================================================================== */

/* STANDARD INCLUDE FILES */
{mfdeclre.i}
{pxmaint.i}
{rqconst.i} /*REQUISITION CONSTANTS*/

/* Define Handles for the programs. */
{pxphdef.i gplabel}
{pxphdef.i ppitxr}
{pxphdef.i pxgblmgr}
{pxphdef.i rqgrsxr}
/* End Define Handles for the programs. */

define temp-table ttRqd_det like rqd_det.

{gprunpdf.i mcpl p}


/* ========================================================================== */
/* ******************************* MAIN BLOCK ******************************* */
/* ========================================================================== */

/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE checkTolerance :
/*------------------------------------------------------------------------------
Purpose:       Perform a calcualtion to determine whether the requisition has
               gone beyond the tolerance level.
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   rqm_mstr(r), rqd_det(r)
        Post:  rqm_mstr(r), rqd_det(r), rqf_ctrl(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input  parameter pReqNumber as character no-undo.
   define input  parameter pReqLine as integer no-undo.
   define input  parameter pBaseNetPurCost as decimal no-undo.
   define input  parameter pNewRecord as logical no-undo.
   define input  parameter pWarning as logical no-undo.

   define variable maxCost as decimal no-undo.
   define variable baseMaxCost as decimal no-undo.
   define buffer   rqf_ctrl for rqf_ctrl.
   define buffer   rqm_mstr for rqm_mstr.
   define buffer   rqd_det for rqd_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:


      {pxrun.i &PROC='processRead' &PARAM="(
         input pReqNumber,
         input pReqLine,
         buffer rqd_det,
         input {&NO_LOCK_FLAG},
         input {&NO_WAIT_FLAG})"}
      if return-value <> {&SUCCESS-RESULT} then
         return return-value.

      {pxrun.i &PROC='processRead' &PROGRAM='rqgrsxr.p'
                &HANDLE=ph_rqgrsxr
         &PARAM="(input pReqNumber,
                  buffer rqm_mstr,
                  input {&NO_LOCK_FLAG},
                  input {&NO_WAIT_FLAG})"}
      if return-value <> {&SUCCESS-RESULT} then
         return return-value.


      /* Get Max Purchase cost */
      {pxrun.i &PROC='getRequisitionMaxPurchaseCost' &PARAM="(
         input pReqNumber,
         input pReqLine,
         output maxCost,
         output baseMaxCost)"}


      /*NOW WE CAN CHECK IT OUT*/
      {pxrun.i &PROC='readGRSRequisitionControl' &PROGRAM='rqgrsxr.p'
                &HANDLE=ph_rqgrsxr
         &PARAM="(buffer rqf_ctrl)"}

      if
      (
         rqf_use_tolval
         and
         pBaseNetPurCost - baseMaxCost > rqf_tol_val
      )
      or
      (
         rqf_use_tolpct
         and
         pBaseNetPurCost > baseMaxCost * (1 + rqf_tol_pct / 100)
      )
      then do:
         if not pNewRecord then do:

            /*YOU MAY NOT MODIFY A COST SO THE REQUISITION IS OUT OF TOLERANCE*/
            {pxmsg.i &MSGNUM=2056 &ERRORLEVEL={&APP-ERROR-RESULT}}
            return error {&APP-ERROR-RESULT}.

         end.
         else do:
            /*PO LINE NET UNIT COST IS OUT OF TOLERANCE*/
            if pWarning
            then do:
               {pxmsg.i &MSGNUM=2257 &ERRORLEVEL={&WARNING-RESULT}}
               return {&WARNING-RESULT}.
            end.
            else do:
               {pxmsg.i &MSGNUM=2257 &ERRORLEVEL={&APP-ERROR-RESULT}}
               return error {&APP-ERROR-RESULT}.
            end.
         end.
      end.
   end.

   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE deletePurchaseOrderLineForGRS :
/*------------------------------------------------------------------------------
Purpose:       Deletes a Purchase Order Line for GRS
Exceptions:    NONE
Conditions:
        Pre:   rqd_det(r), rqm_mstr(r),
        Post:  rqpo_ref(d), mrp_det(d)
Notes:
History:       Extracted from popomth.p
------------------------------------------------------------------------------*/
   define input parameter pRequisitionId           as character no-undo.
   define input parameter pRequisitionLineId       as integer   no-undo.
   define input parameter pSiteId                  as character no-undo.
   define input parameter pPOId                    as character no-undo.
   define input parameter pPOLineId                as integer   no-undo.
   define input parameter pLineUM                  as character no-undo.
   define input parameter pOpenRequisitionResponse as logical   no-undo.

   define variable requisitionUM as character no-undo.
   define variable crossReferenceOk as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* REOPENING A CLOSED REQ AND OR REQ LINE WHEN A */
      /* PO REFERENCING A REQ IS DELETED */
      {gprunmo.i &program = "xxpopodel.p" &module = "GRS"
                 &param = """(input pRequisitionId,
                              input pRequisitionLineId,
                              input pOpenRequisitionResponse)"""}


      /* DELETE REQ/PO CROSSREFERENCE RECORD */
      {pxrun.i &PROC='updateRequisitionCrossReference' &PARAM="(
          input pSiteId,
          input pRequisitionId,
          input pRequisitionLineId,
          input pPOId,
          input pPOLineId,
          input 0,
          input pLineUM,
          output requisitionUM,
          output crossReferenceOk)"}


      /* UPDATE REQ MRP */
      {pxrun.i &PROC='updateMRPForRequisition' &PARAM="(
         input pSiteId,
         input pRequisitionId,
         input pRequisitionLineId)"}
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE getRequisitionLineOpenQuantity :
/*------------------------------------------------------------------------------
Purpose:       Obtain the quantity open for the GRS Requisition
Exceptions:    NONE
Conditions:
        Pre:   rqm_mstr(r), rqd_det(r)
        Post:
Notes:
History:
------------------------------------------------------------------------------*/
   define input  parameter pRequisitionId as character no-undo.
   define input  parameter pRequisitionLineId as integer no-undo.
   define input  parameter pSiteId as character no-undo.
   define output parameter pQuantityOpen as decimal no-undo.
   define output parameter pUM as character no-undo.


   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {gprun.i ""rqoqty.p""
               "(input true,
                 input pSiteId,
                 input pRequisitionId,
                 input pRequisitionLineId,
                 output pQuantityOpen,
                 output pUM)"}

   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE getRequisitionMaxPurchaseCost :
/*------------------------------------------------------------------------------
Purpose:       Obtain the max purchase cost in transaction currency and base
               currency for the for the GRS Requisition
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   rqm_mstr(r), rqd_det(r)
        Post:  rqm_mstr(r), rqd_det(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input  parameter pRequisitionId as character no-undo.
   define input  parameter pRequisitionLineId as integer no-undo.
   define output parameter pMaxCost     as decimal no-undo.
   define output parameter pBaseMaxCost as decimal no-undo.

   define variable mcErrorNumber as integer no-undo.
   define variable baseCurrency as character no-undo.
   define buffer rqm_mstr for rqm_mstr.
   define buffer rqd_det for rqd_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxgetph.i pxgblmgr}

      baseCurrency =
         {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                     &HANDLE=ph_pxgblmgr
            &PARAM="input 'base_curr'"}.

      {pxrun.i &PROC='processRead' &PARAM="(
         input pRequisitionId,
         input pRequisitionLineId,
         buffer rqd_det,
         input {&NO_LOCK_FLAG},
         input {&NO_WAIT_FLAG})"}
      if return-value <> {&SUCCESS-RESULT} then
         return return-value.

      {pxrun.i &PROC='processRead' &PROGRAM='rqgrsxr.p'
                &HANDLE=ph_rqgrsxr
         &PARAM="(input pRequisitionId,
                  buffer rqm_mstr,
                  input {&NO_LOCK_FLAG},
                  input {&NO_WAIT_FLAG})"}
      if return-value <> {&SUCCESS-RESULT} then
         return return-value.

      /* CONVERT REQ COST TO BASE CURRENCY AND STOCK UM */
      pMaxCost = rqd_max_cost / rqd_um_conv.

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input rqm_curr,
           input baseCurrency,
           input rqm_ex_rate,
           input rqm_ex_rate2,
           input pMaxCost,
           input false, /* DO NOT ROUND */
           output pBaseMaxCost,
           output mcErrorNumber)"}

      if mcErrorNumber > 0 then
         return {&WARNING-RESULT}.

   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE markLineOutOfTolerance :
/*------------------------------------------------------------------------------
Purpose:       Mark the requisistion line out of tolerance. Send email & record
               the history.
Exceptions:    RECORD-NOT-FOUND
Conditions:
        Pre:   rqd_det(r), rqm_mstr(r)
        Post:  rqd_det(w), rqm_mstr(w)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pReqNumber as character no-undo.
   define input parameter pReqLineId as integer no-undo.
   define input parameter pPONetCost as decimal no-undo.
   define input parameter pPOUM as character no-undo.
   define input parameter pReqNetCost as decimal no-undo.
   define input parameter pReqUM as character no-undo.

   define variable globalUserId as character no-undo.
   define variable emailUserId as character no-undo.
   define buffer rqd_det for rqd_det.
   define buffer rqm_mstr for rqm_mstr.


   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /*Obtain the Global user id for writing Out Of Tolerance History*/

       {pxgetph.i pxgblmgr}

       globalUserId =
         {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                     &HANDLE=ph_pxgblmgr
                    &PARAM="input 'global_userid'"}.


      /*Obtain & Lock the requisition line buffer*/
      {pxrun.i &PROC='processRead' &PARAM="(
         input pReqNumber,
         input pReqLineId,
         buffer rqd_det,
         input {&LOCK_FLAG},
         input {&NO_WAIT_FLAG})"}

      if return-value <> {&SUCCESS-RESULT} then
         return error return-value.

      /*STORE DATA*/
      assign
         rqd_oot_ponetcst = pPONetCost
         rqd_oot_poum     = pPOUM
         rqd_oot_rqnetcst = pReqNetCost
         rqd_oot_rqum     = pReqUM
      .

      /*MARK APPROVAL STATUS AS OUT-OF-TOLERANCE*/
      rqd_aprv_stat =  APPROVAL_STATUS_OOT.


      /*Obtain & Lock the requisition buffer*/
      {pxrun.i &PROC='processRead' &PROGRAM='rqgrsxr.p'
                &HANDLE=ph_rqgrsxr
         &PARAM="(input pReqNumber,
                  buffer rqm_mstr,
                  input {&LOCK_FLAG},
                  input {&NO_WAIT_FLAG})"}
      if return-value <> {&SUCCESS-RESULT} then
         return error return-value.

      rqm_aprv_stat =  APPROVAL_STATUS_OOT.


      /*SEND EMAILS*/
      {gprun.i ""rqemsend.p""
         "(input recid(rqm_mstr),
           input ACTION_MARK_OOT,
           output emailUserId)"}


      /*WRITE HISTORY RECORD*/
      {gprun.i ""rqwrthst.p""
         "(input rqm_nbr,
           input rqd_line,
           input ACTION_MARK_OOT,
           input globalUserId,
           input '',
           input emailUserId)"}

   end.

   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE processRead :
/*------------------------------------------------------------------------------
Purpose:       Locate and bring the Requisition Line detail record into scope.
Exceptions:    RECORD-LOCKED, RECORD-NOT-FOUND
Conditions:
        Pre:   None
        Post:  rqd_det(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pReqNumber as character no-undo.
   define input parameter pReqLine as integer no-undo.
   define parameter buffer rqd_det for rqd_det.
   define input parameter pLockFlag as logical no-undo.
   define input parameter pWaitFlag as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pLockFlag then do:
         if pWaitFlag then do:
            for first rqd_det
               where rqd_nbr = pReqNumber and rqd_line = pReqLine
               exclusive-lock:
            end.
         end.
         else do:
            find rqd_det
               where rqd_nbr = pReqNumber and rqd_line = pReqLine
               exclusive-lock no-error no-wait.

            if locked rqd_det then return {&RECORD-LOCKED}.
         end.
      end.
      else do:
         for first rqd_det
            where rqd_nbr = pReqNumber and rqd_line = pReqLine
            no-lock:
         end.
      end.

      if not available rqd_det then return {&RECORD-NOT-FOUND}.
   end.

   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE processReadReturnTempTable :
/*------------------------------------------------------------------------------
Purpose:       Locate and bring the GRS Requisition Detail record into scope.
Exceptions:    RECORD-LOCKED, RECORD-NOT-FOUND
Conditions:
        Pre:   None
        Post:  rqd_det(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pRequisitonId as character no-undo.
   define input parameter pReqLine as integer no-undo.
   define parameter buffer ttRqd_det for ttRqd_det.
   define input parameter pLockFlag as logical no-undo.
   define input parameter pWaitFlag as logical no-undo.

   define buffer rqd_det for rqd_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='processRead' &PARAM="(
         input pRequisitonId,
         input pReqLine,
         buffer rqd_det,
         input pLockFlag,
         input pWaitFlag)"}

         if return-value <> {&SUCCESS-RESULT} then
            return error return-value.

         buffer-copy rqd_det to ttRqd_det.

   end.

   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE updateMRPForRequisition :
/*------------------------------------------------------------------------------
Purpose:       Update MRP Detail File for Direct Requisitions
Exceptions:    NONE
Conditions:
        Pre:   rqm_mstr(r), rqd_det(r)
        Post:  mrp_det(w)
Notes:
History:       Extracted from popomth.p
------------------------------------------------------------------------------*/
   define input parameter pLineSiteId as character no-undo.
   define input parameter pRequisitionId as character no-undo.
   define input parameter pRequisitionLineId as integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {gprunmo.i &program="rqmrw.p" &module="GRS"
                 &param="""(input true,
                            input pLineSiteId,
                            input pRequisitionId,
                            input pRequisitionLineId)"""}
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.

/*============================================================================*/
PROCEDURE updateReqLineOutOfTolerance :
/*------------------------------------------------------------------------------
<Comment1>
rqgrsxr1.p
 updateReqLineOutOfTolerance(
   input character pRequisitionId,
   input integer   pRequisitionLineId,
   input decimal   pPoBaseNetPurCost,
   input character pPoStockUm)

Parameters:
   pRequisitionId - GRS Requisition ID
   pRequisitionLineId - GRS Requsition Line ID
   pPoBaseNetPurCost - Purchase Order Base Net Purchase Cost
   pPoStockUm - Purchase Order Item Stocking Unit of Measure

Exceptions: APP-ERROR-RESULT

PreConditions: Create a Purchase Order Line and Mark it out of Tolerance.
               The switch to the req database must have occurred prior
               calling this procedure.

PostConditions: Requisition and Requisition Line will have email acknowledments
                sent and Requisition History will be tracked.

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pRequisitionId as character no-undo.
   define input parameter pRequisitionLineId as integer no-undo.
   define input parameter pPoBaseNetPurCost as decimal no-undo.
   define input parameter pPoStockUm as character no-undo.

   define variable dummyChar   as character no-undo.
   define variable dummyDecimal as decimal no-undo.
   define variable globalUserId as character no-undo.
   define variable reqStockUm as character no-undo.

   define buffer rqd_det for rqd_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* GET VARIABLES FROM PO MAINT DTC */

      {pxgetph.i pxgblmgr}

      globalUserId =
         {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                     &HANDLE=ph_pxgblmgr
                            &PARAM="input 'global_userid'"}.

      {pxrun.i &PROC='processRead'
                   &PARAM="(input pRequisitionId,
                      input pRequisitionLineId,
                      buffer rqd_det,
                      input {&LOCK_FLAG},
                      input {&NO_WAIT_FLAG})"}

       if return-value <> {&SUCCESS-RESULT} then do:
          return error return-value.
       end.

       /* GET REQ STOCK UM */
       reqStockUm = "".
       {pxrun.i &PROC='getBasicItemData' &PROGRAM='ppitxr.p'
                 &HANDLE=ph_ppitxr
                  &PARAM="(input rqd_det.rqd_part,
                           output dummyChar,
                           output dummyChar,
                           output dummyDecimal,
                           output dummyChar,
                           output dummyChar,
                           output reqStockUm,
                           output dummyChar)"}

      /* SET OUT OF TOLERANCE INFO. */
      {pxrun.i &PROC='markLineOutOfTolerance'
               &PARAM="(input pRequisitionId,
                     input pRequisitionLineId,
                     input pPoBaseNetPurCost,
                     input pPostockUM,
                     input rqd_det.rqd_max_cost,
                     input reqStockUm)"}

   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE updateRequisitionCrossReference :
/*------------------------------------------------------------------------------
Purpose:       Maintain Requisition Cross Reference Record
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:    rqm_mstr(r), rqd_det(r)
        Post:   rqpo_ref(d), rqpo_ref(c)
Notes:
History:       Extracted from popomth.p
------------------------------------------------------------------------------*/
   define input  parameter pSiteId            as character no-undo.
   define input  parameter pRequisitionId     as character no-undo.
   define input  parameter pRequisitionLineId as integer   no-undo.
   define input  parameter pPOId              as character no-undo.
   define input  parameter pPOLineId          as integer   no-undo.
   define input  parameter pQuantityOrdered   as decimal   no-undo.
   define input  parameter pPOLineUM          as character no-undo.
   define output parameter pRequisitionUM     as character no-undo.
   define output parameter pCrossReferenceOk  as logical   no-undo.

   define variable POTermLabel as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {gprunmo.i &PROGRAM="rqporef.p" &module="GRS"
                 &PARAM="""(input true,
                            input pSiteId,
                            input pRequisitionId,
                            input pRequisitionLineId,
                            input pPOId,
                            input pPOLineId,
                            input pQuantityOrdered,
                            input pPOLineUM,
                            output pRequisitionUM,
                            output pCrossReferenceOk)"""}
      if not pCrossReferenceOk then do:
         /* GET TERM LABEL FOR PURCHASE ORDER */

         {pxgetph.i gplabel}

         POTermLabel = ({pxfunct.i &FUNCTION='getTermLabel'
                                   &PROGRAM='gplabel.p'
                                    &HANDLE=ph_gplabel
                                   &PARAM="input 'FOR_REQUISITION_UM',
                                           input 23"}).
         /* MESSAGE #33 - NO UNIT OF MEASURE CONVERSION EXISTS */
         {pxmsg.i
            &MSGNUM=33
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &MSGARG1=POTermLabel
            &MSGARG2="' '"
            &MSGARG3=pRequisitionUM}
         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateReqLineIsApproved :
/*------------------------------------------------------------------------------
Purpose:       Ensure the requisition is approved by Purchasing before allowing
               it to be used on a PO.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   rqd_det(r)
        Post:  rqd_det(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pReqNumber as character no-undo.
   define input parameter pReqLine as integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if can-find(first rqd_det where rqd_nbr = pReqNumber
         and rqd_line = pReqLine and rqd_aprv_stat = APPROVAL_STATUS_UNAPPROVED)
      then do:

         /*REQUISITION LINE IS NOT APPROVED*/
         {pxmsg.i &MSGNUM=2117 &ERRORLEVEL={&APP-ERROR-RESULT}}

         return error {&APP-ERROR-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.



/*============================================================================*/
PROCEDURE validateReqLineIsOpen :
/*------------------------------------------------------------------------------
Purpose:       Ensure the requisition selected is open. A closed requisition
               cannot be used on a PO.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   None
        Post:  None
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pReqNumber as character no-undo.
   define input parameter pReqLine as integer no-undo.

   define buffer rqd_det for rqd_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='processRead' &PARAM="(
         input pReqNumber,
         input pReqLine,
         buffer rqd_det,
         input {&NO_LOCK_FLAG},
         input {&NO_WAIT_FLAG})"}
      if return-value <> {&SUCCESS-RESULT} then
         return return-value.

      if rqd_status = "C" then do:
         /* MESSAGE #3326 - REQUISITION LINE IS CLOSED */
         {pxmsg.i
            &MSGNUM=3326
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.

      if rqd_status = "x" then do:
         /*REQUISITION LINE IS CANCELLED*/
         {pxmsg.i &MSGNUM=2059 &ERRORLEVEL={&APP-ERROR-RESULT}}

         return error {&APP-ERROR-RESULT}.
      end.

   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateRequisitionLineOpenQuantity :
/*------------------------------------------------------------------------------
Purpose:       Ensure there is a available quantity on the requisition to
               satisfy the PO
Exceptions:    APP-ERROR-RESULT, WARNING-RESULT
Conditions:
        Pre:   rqd_det(r)
        Post:  rqd_det(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pRequisitionId as character no-undo.
   define input parameter pRequisitionLineId as integer no-undo.
   define input parameter pSiteId as character no-undo.

   define variable qtyOpen as decimal no-undo.
   define variable reqUM as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='getRequisitionLineOpenQuantity' &PARAM="(
         input pRequisitionId,
         input pRequisitionLineId,
         input pSiteId,
         output qtyOpen,
         output reqUM)"}

      if qtyOpen < 0 then do:
         /*NO REMAINING QUANTITY OPEN ON REQUISITION LINE*/
         {pxmsg.i &MSGNUM=2057 &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end.

      if qtyOpen = ? then do:
         /* MESSAGE #193 - REQUISITION DOES NOT EXIST */
         {pxmsg.i
            &MSGNUM=193
            &ERRORLEVEL={&WARNING-RESULT}
            &MSGARG1="pRequisitionId + ' ' + string(pRequisitionLineId)"}
         return {&WARNING-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateReqLineSite :
/*------------------------------------------------------------------------------
Purpose:       Ensure the site associated with the requisition is the same as
               the site for the PO
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   None.
        Post:  None.
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pRequisitionLineSiteId as character no-undo.
   define input parameter pPOLineSiteId as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pPOLineSiteId <> pRequisitionLineSiteId then do:
         /*REQUISITION SITE AND PO SITE ARE DIFFERENT*/
         {pxmsg.i
            &MSGNUM=2061
            &ERRORLEVEL={&WARNING-RESULT}
            &MSGARG1=pRequisitionLineSiteId}

         return {&WARNING-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.



/*============================================================================*/
PROCEDURE validateRequisitionLineSupplier :
/*------------------------------------------------------------------------------
Purpose:       Ensure the supplier referenced on the requisition is the same
               as the PO supplier
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   None
        Post:  None
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPORequisitionSupplierId as character no-undo.
   define input parameter pPOSupplierId as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if  pPORequisitionSupplierId <> ""
      and pPORequisitionSupplierId <> pPOSupplierId
      then do:
         /*REQUISITION SUPPLIER AND PO SUPPLIER ARE DIFFERENT*/
         {pxmsg.i &MSGNUM=2063 &ERRORLEVEL={&WARNING-RESULT}}

         return {&WARNING-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.
