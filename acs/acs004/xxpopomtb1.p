/* popomtb1.p - PURCHASE ORDER MAINTENANCE -- ORDER HEADER subroutine        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.8.1.8 $                                                      */
/*                                                                           */
/* REVISION: 7.4      LAST MODIFIED: 09/28/93   BY: cdt *H086*               */
/* REVISION: 7.5      LAST MODIFIED: 02/20/94   BY: dpm *J044*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 06/02/98   BY: *L020* Charles Yen       */
/* REVISION: 8.6E     LAST MODIFIED: 07/29/98   BY: *L056* Charles Yen       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED:            BY: *F0PN* Missing ECO       */
/* Revision: 1.8.1.2  BY: Niranjan R.           Date: 05/24/00  ECO: *N0C7*  */
/* Revision: 1.8.1.5  BY: Jeff Wootton          DATE: 05/10/00  ECO: *N059*  */
/* Revision: 1.8.1.6  BY: Laurene Sheridan DATE: 10/17/02 ECO: *N13P*        */
/* $Revision: 1.8.1.8 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J*    */
/*-Revision end--------------------------------------------------------------*/
/*V8:ConvertMode=Maintenance                                                 */
/* ***************************************************************************/
/* Note: This code has been modified to run when called inside an MFG/PRO API*/
/* method as well as from the MFG/PRO menu, using the global variable        */
/* c-application-mode to conditionally execute API- vs. UI-specific logic.   */
/* Before modifying the code, please review the MFG/PRO API Development Guide*/
/* in the QAD Development Standards for specific API coding standards and    */
/* guidelines.                                                               */
/* ***************************************************************************/
/*===========================================================================*/
/* **************************** Definitions **********************************/
/*===========================================================================*/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE popomtb1_p_1 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE popomtb1_p_2 "Ln Disc"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* SHARED VARIABLES */
define shared variable po_recno  as recid.
define shared variable ponbr     like po_nbr.
define shared variable new_po    like mfc_logical.
define shared variable so_job    like pod_so_job.
define shared variable disc      like pod_disc label {&popomtb1_p_2}.
define shared variable undo_all  like mfc_logical.
define shared variable pocmmts   like mfc_logical label {&popomtb1_p_1}.
define shared variable impexp    like mfc_logical no-undo.

/* SHARED FRAMES */
define shared frame a.
define shared frame b.

{mfaimfg.i} /* Common API constants and variables */

{popoit01.i} /* Purchase Order Temp Table Definition */
{mctrit01.i} /* Exchange Rate Temp Table Definition */

if c-application-mode = "API" then do on error undo, return:

    /* GET HANDLE OF API CONTROLLER */
   {gprun.i ""gpaigh.p""
             "(output ApiMethodHandle,
               output ApiProgramName,
               output ApiMethodName,
               output apiContextString)"}

   /* GET LOCAL PO MASTER TEMP-TABLE */
   create ttPurchaseOrder.
   run getPurchaseOrderRecord in ApiMethodHandle
               (buffer ttPurchaseOrder).

end.  /* If c-application-mode = "API" */

/* Shared frames a and b */
{xxpopomt02.i}

/* LOCAL VARIABLE(S) */
define variable mc-error-number like msg_nbr no-undo.

form po_ent_ex colon 15
   po_fix_rate colon 15
   with frame setb_sub attr-space overlay side-labels
   centered row frame-row(b) + 4.

/* SET EXTERNAL LABELS */
setFrameLabels(frame setb_sub:handle).

undo_all = yes.

for first po_mstr exclusive-lock
   where recid(po_mstr) = po_recno:
end.

setb_sub:
do on error undo, retry:
    /* DO NOT RETRY WHEN PROCESSING API REQUEST */
   if retry and c-application-mode = "API" then
      undo setb_sub, return.

   /* ALLOW CHG TO EXRATE ON ADD AND MODIFY */
   /* AS LONG AS NO PRH_HIST EXISTS */
   if not can-find(first prh_hist  where prh_hist.prh_domain = global_domain
   and  prh_nbr = po_nbr)
      and po_curr <> base_curr
   then do:

      /* DEFAULT EXRATE IF NEW PO FROM EXCHANGE RATE TABLE */
      if new_po then do:
         {pxrun.i &PROC='createExchangeRateUsage' &PROGRAM='mcexxr.p'
                  &PROGRAM='mcexxr.p'
                  &PARAM="(input po_curr,
                           input base_curr,
                           input po_ex_ratetype,
                           input po_ord_date,
                           output po_ex_rate,
                           output po_ex_rate2,
                           output po_exru_seq)"
                  &NOAPPERROR=TRUE &CATCHERROR=TRUE
         }

         if return-value <> {&SUCCESS-RESULT}
         then do:
            undo setb_sub, return.
         end.
      end. /* IF new_po */

      if c-application-mode  = "API" and
         ttPurchaseOrder.exRate <> ? and
         ttPurchaseOrder.baseCurr <> base_curr then
      do:
         /* API message base currency # does not
            equal MFG/PRO base currency.*/
         {pxmsg.i
            &MSGNUM = 5079
            &ERRORLEVEL = 3
            &MSGARG1 = ttPurchaseOrder.baseCurr
         }
         undo setb_sub, return error.
      end.

      if c-application-mode = "API" and
         ttPurchaseOrder.exRate <> ? then
         assign po_fix_rate = yes.

      /*
       * Copy the exchange rate details from the ttPurchaseOrder Temp
       * Table into the Exchange Rate temp table for use in mcui.p
      */
      if c-application-mode = "API" then do:
         {gpttcp.i ttPurchaseOrder
                   ttTransExchangeRates}
         run setTransExchangeRates in ApiMethodHandle
            (input table ttTransExchangeRates).
      end.

      /*TO DO: Leave this for CHUI mode since this method displays a frame.*/
      /*       For API Mode, Call the Exchange Rate ROP as Apporriate for  */
      /*       Read/Write                                                  */
      {gprunp.i "mcui" "p" "mc-ex-rate-input"
         "(input po_curr,
           input base_curr,
           input po_ord_date,
           input po_exru_seq,
           input true,
           input frame-row(b) + 4,
           input-output po_ex_rate,
           input-output po_ex_rate2,
           input-output po_fix_rate)"
      }

      if c-application-mode <> "API" then
         if keyfunction(lastkey) = "end-error" then
            undo setb_sub, leave.
   end.
   undo_all = no.
end.  /* Setb_sub */
