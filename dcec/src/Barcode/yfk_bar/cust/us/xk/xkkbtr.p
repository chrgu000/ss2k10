/* kbtr.p - KANBAN TRANSACTION ENTRY                                     */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */

/* THIS PROGRAM IS CALLED BY EXECUTE KANBAN TRANSACTIONS:                */
/*     kbtr1.p - Kanban Consume/Post                                     */
/*     kbtr2.p - Kanban Authorize                                        */
/*     kbtr3.p - Kanban Acknowledge                                      */
/*     kbtr4.p - Kanban Ship                                             */
/*     kbtr5.p - Kanban Fill/Receive                                     */

/* Revision: 1.10       BY: Russ Witt           DATE: 05/22/02    ECO: *P03G* */
/* Revision: 1.13       BY: Manjusha Inglay     DATE: 08/20/02    ECO: *N1QP* */
/* Revision: 1.14       BY: Dan Herman          DATE: 08/22/02    ECO: *P0GG* */
/* Revision: 1.16       BY: Inna Fox            DATE: 09/05/02    ECO: *P0GB* */
/* Revision: 1.18       BY: Inna Fox            DATE: 11/12/02    ECO: *P0JP* */
/* Revision: 1.25       BY: Bengt Johansson     DATE: 04/10/03    ECO: *P0M4* */
/* Revision: 1.25.2.1   BY: Vandna Rohira       DATE: 07/16/03    ECO: *P0W2* */
/* $Revision: 1.25.2.2 $  BY: Inna Fox            DATE: 08/28/03    ECO: *P11L* */
/*-Revision end---------------------------------------------------------------*/

/*V8:ConvertMode=Maintenance                                             */
/*Cai last modified by 05/20/2004*/
/*---------------------------------------------------
      2005-01-17, Yang Enping, 000A
          1. 性能调整
 	       2. 解决knbd_det，kbc_ctrl的锁定问题
 	   2006-02-26  Hou, H01
 	       1. 取消结束后的暂停    
-----------------------------------------------------*/
/*Cai last modified by 01/30/05 cj0130*/

{mfdeclre.i}

{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{pxmaint.i}

/* Define Handles for the programs. */
{pxphdef.i gplngxr}
{pxphdef.i icsixr}
{pxphdef.i kbtranxr}
{pxphdef.i kbknbdxr}
{pxphdef.i kbtrxr}
{pxphdef.i popoxr}


/* GL Daybook Include files needed for kblotr.p call */
{gldydef.i new}
{gldynrm.i new}

{kbconst.i}

define input parameter  pKBCardEvent     as character no-undo.
define input parameter kanbanID like knbd_id           no-undo.
define input parameter effDate  like tr_effdate        no-undo.

define variable CEPart                         like pt_part           no-undo.
define variable CESite                         like si_site           no-undo.
define variable CESupplier                     like vd_addr           no-undo.
define variable CEPurchaseOrder                like po_nbr            no-undo
                                               label "PO Number".
define variable CESuperMarket                  like knbsm_supermarket_id
                                                                      no-undo.
define variable CEProcess                      like knp_process_id    no-undo.
define variable CESourceSM                     like knbsm_supermarket_id
                                               label "From Supermarket ID"
                                                                      no-undo.
define variable CESourceSMDesc                 like knbsm_desc        no-undo.
define variable CESourceSMSite                 like si_site           no-undo
                                               label "Transfer From Site".
define variable CESourceSMSiteDesc             like si_desc           no-undo.
define variable CEcardType                     like lngd_mnemonic
                                               label "Card Type"  no-undo.
define variable CEcardTypeMnemonic             like lngd_mnemonic
                                               label "Card Type"  no-undo.


define variable pTransactionDate               as   date              no-undo.
define variable pTransactionTime               as   integer           no-undo.
define variable pausemsg                       as character           no-undo.
define variable errorMessage         as integer no-undo initial 0.
define variable errorSeverity        as integer no-undo initial 0.
define variable opPOLine             as integer no-undo.
define variable confirmOK            like mfc_logical no-undo.
define variable sourceType           like lngd_mnemonic
                                          label "Transaction Type"  no-undo.
define variable sourceTypeDesc       like lngd_translation  no-undo.
define variable cardType             like lngd_mnemonic
                                          label "Card Type"  no-undo.
define variable cardTypeDesc         like lngd_translation  no-undo.
define variable kanbanEvent          like lngd_mnemonic
                                          label "Event" no-undo.
define variable kanbanEventDesc      like lngd_translation no-undo.
define variable kanbanAccumType      like lngd_mnemonic
                                          label "Accumulator" no-undo.
define variable kanbanAccumTypeDesc  like lngd_translation no-undo.
define variable kanbanLoopType       like lngd_mnemonic
                                          label "Loop Type" no-undo.
define variable kanbanLoopTypeDesc   like lngd_translation no-undo.
define variable consumingReference   like knbd_pou_ref no-undo.

define variable PONumber             as character format "x(8)"
                                          label "PO Number" no-undo.
define variable POLine               as character format "x(3)"
                                          label "Line" no-undo.
define variable prev-knbd-status     like knbd_status no-undo.
define variable sourceRef            as character format "x(8)"
                                          label "Source" no-undo.
define variable sourceRefDesc        as character format "x(24)"  no-undo.
define variable sourceSite           as character format "x(8)"
                                          label "Source Site" no-undo.
define variable sourceSiteDesc       as character format "x(24)"  no-undo.
define variable sourceSMInvLoc       as character no-undo.
define variable blanketPO  as character format "x(8)"  no-undo.
define variable transTime  as character format "x(8)"  no-undo.
define variable hasCEErrors as logical  no-undo.
define variable supplierID           like vd_addr  no-undo.

/* FOLLOWING 4 NEW SHARED VARIABLES NEEDED FOR KBPORCM.P   */
define new shared variable porec       like mfc_logical                no-undo.
define new shared variable ports       as   character                  no-undo.
define new shared variable is-return   like mfc_logical                no-undo.
define new shared variable tax_tr_type like tx2_tax_type  initial "21" no-undo.


/* BUFFERS */
define buffer bSourceSM for knbsm_mstr.
define buffer bSourceSMSite for si_mstr.
define buffer knbsmmstr for knbsm_mstr.

/* KANBAN ID ENTRY FRAME  */
form
   kanbanID             colon 26 label "Kanban Card ID"
   effDate             colon 60 label "Effective Date"
with frame c
side-labels width 80 attr-space.
/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

/* EFFECTIVE DATE ENTRY FRAME  */
form
   effDate                   colon 25 label "Effective Date"
with frame effDate
side-labels width 80 attr-space.
/* SET EXTERNAL LABELS */
setFrameLabels(frame effDate:handle).

/* CONFIRMATION FRAME DEFINITION */
form
   knbd_id              colon 26
   sourceType           colon 26
   sourceTypeDesc       colon 48 no-label skip
   knbi_part            colon 26
   pt_desc1             colon 48 no-label skip
   knbsm_site           colon 26
   si_desc              colon 48 no-label skip
   knbsm_supermarket_id colon 26
   knbsm_desc           colon 48 no-label skip(1)
   sourceType           colon 26
   sourceTypeDesc       colon 48 no-label
   sourceRef            colon 26
   sourceRefDesc        colon 48 no-label
   sourceSite           colon 26
   sourceSiteDesc       colon 48 no-label
   PONumber             colon 26
   POLine               colon 43          skip(1)
   knbl_cont_size       colon 26          skip
   knbd_kanban_quantity colon 26 label "Kanban Quantity" skip
   knbsm_inv_loc        colon 26
   cardType             colon 26
   cardTypeDesc         colon 48 no-label skip
   kanbanEvent          colon 26
   kanbanEventDesc      colon 48 no-label skip
   kanbanAccumType      colon 26
   kanbanAccumTypeDesc  colon 48 no-label skip
   kanbanLoopType       colon 26
   kanbanLoopTypeDesc   colon 48 no-label skip
with frame confirmCard title color normal
(getFrameTitle("KANBAN_TRANSACTION",32))
side-labels width 80 attr-space.
/* SET EXTERNAL LABELS */
setFrameLabels(frame confirmCard:handle).

do on error undo, return error {&GENERAL-APP-EXCEPT}:

for first kbc_ctrl
fields(kbc_controlled_entry
       kbc_display_pause
          kbc_eff_date_entry
          kbc_fifo_entry)
no-lock: end.

if not available kbc_ctrl then do:
   {pxmsg.i &MSGNUM=3292
            &ERRORLEVEL={&APP-ERROR-RESULT}}
   /* KANBAN CONTROL FILE DOES NOT EXIST  */
   return.
end.

ststatus = stline[1].
status input ststatus.

mainloop:
   repeat: 

      /* SEE IF CONTROLLED ENTRY IS TO BE ENTERED */
      if kbc_controlled_entry <> {&SUCCESS-RESULT} then do:
         {pxrun.i &PROC  = 'promptForControlledEntry'
                         &NOAPPERROR = true
                         &CATCHERROR = true}
         if return-value <> {&SUCCESS-RESULT} then
            undo mainloop, leave mainloop.
      end.

      hide frame b no-pause.

      /* SEE IF EFFECTIVE DATE IS TO BE ENTERED */
      if kbc_eff_date_entry = yes then
         do on endkey undo mainloop, leave mainloop
            on error undo, retry:

         hide frame effDate no-pause.

      end.  /* if kbc_eff_date_entry = yes */


      {pxrun.i &PROC  = 'promptForConsumingReference'
                         &PARAM = "(input   pKBCardEvent,
                                    output  consumingReference)"
                         &NOAPPERROR = true
                         &CATCHERROR = true}
      if return-value <> {&SUCCESS-RESULT} then
         undo mainloop, leave mainloop.

      kanban-entry-loop:
      repeat with frame c on error undo, retry
                          on endkey undo mainloop, leave mainloop:

         hide frame confirmCard.

         run displayLastTransactions.

      /* DON'T ALLOW ENTRY OF UNKNOWN VALUE IN ANY FIELD */
         {gpchkqsi.i &fld=kanbanID     &frame-name=c}

         /* VALIDATE KANBAN ID EXISTS */
         find knbd_det where knbd_id = kanbanId exclusive-lock no-error.
         if not available (knbd_det) then
         do :
            {pxmsg.i &MSGNUM=5046
                     &ERRORLEVEL={&APP-ERROR-RESULT}}
            /*  KANBAN ID DOES NOT EXIST */
            next-prompt kanbanID with frame c.
            undo, retry.
         end.

         /* RETRIEVE LOOP DETAIL RECORD */
         for first knbl_det
         where knbl_keyid       = knbd_knbl_keyid
         no-lock:  end.

         /* RETRIEVE KANBAN MASTER RECORD */
         for first knb_mstr
         where knb_keyId       = knbl_knb_keyId
         no-lock:  end.

         /* RETRIEVE KANBAN SUPERMATER ITEM DETAIL */
         for first knbism_det exclusive-lock where
            knbism_knbsm_keyid = knb_knbsm_keyid and
            knbism_knbi_keyid = knb_knbi_keyid: end.

         /* ASSIGN DEFAULT PO NUMBER */
         if knbd_source_type = {&KB-SOURCETYPE-SUPPLIER} then
            assign
               PONumber = knbd_ref2
               POLine   = knbd_ref3.

         /* RETRIEVE KANBAN Item SuperMarket MASTER RECORD */
         for first knbsm_mstr
         where knbsm_keyId       = knb_knbsm_keyId
         no-lock: end.

         /* RETRIEVE KANBAN Item MASTER RECORD */
         for first knbi_mstr
         where knbi_keyId       = knb_knbi_keyId
         no-lock: end.

         /* RETRIEVE KANBAN PROCESS MASTER RECORD */
         if knbd_source_type = {&KB-SOURCETYPE-PROCESS} then
         for first knp_mstr
         where knp_mstr.knp_site       = knbd_ref1 and
               knp_mstr.knp_process_id = knbd_ref2
         no-lock: end.

         /* RETRIEVE PART DESCRIPTION */
         for first pt_mstr
         fields (pt_part pt_desc1 pt_routing pt_bom_code)
         where pt_part = knbi_part no-lock: end.

         /* RETRIEVE SITE */
         for first si_mstr
         fields (si_site si_desc)
         where si_site = knbsm_site no-lock: end.

         /* DETERMINE KANBAN SOURCE DATA */
         assign
            sourceSite =
               if knbd_det.knbd_source_type = {&KB-SOURCETYPE-PROCESS} or
                  knbd_det.knbd_source_type = {&KB-SOURCETYPE-INVENTORY}
                                            then
                                               knbd_det.knbd_ref1
                                            else
                                               ""
            sourceRef =
               if knbd_det.knbd_source_type = {&KB-SOURCETYPE-SUPPLIER}
                                            then
                                               knbd_det.knbd_ref1
                                            else
                                               knbd_det.knbd_ref2
            PONumber =
               if knbd_det.knbd_source_type = {&KB-SOURCETYPE-SUPPLIER}
                                            then
                                               knbd_det.knbd_ref2
                                            else
                                               ""
            POLine =
               if knbd_det.knbd_source_type = {&KB-SOURCETYPE-SUPPLIER}
                                            then
                                               knbd_det.knbd_ref3
                                            else
                                               "".

         /* RETRIEVE SUPPLYING SOURCE DESCRIPTION */
         if knbd_det.knbd_source_type = {&KB-SOURCETYPE-PROCESS} then do:
            for first knp_mstr
                where knp_mstr.knp_site = sourceSite
                  and knp_mstr.knp_process_id = sourceRef
                no-lock: end.

               for first si_mstr
                   where si_site = sourceSite
                   no-lock: end.

            assign
               sourceRefDesc = if available(knp_mstr) then knp_desc
                                                      else ""
               sourceSiteDesc = if available(si_mstr) then si_desc
                                                      else "".
         end.  /* if knbd_source_type = {&KB-SOURCETYPE-PROCESS}  */
         else do:
            if knbd_det.knbd_source_type = {&KB-SOURCETYPE-SUPPLIER}
            then do:
               {pxrun.i &PROC  = 'getSupplierName' &PROGRAM = 'kbtranxr.p'
                        &PARAM = "(input  sourceRef,
                                   output sourceRefDesc)"
                        &NOAPPERROR = true
                        &CATCHERROR = true}
               assign
                  supplierID = sourceRef
                  sourceSiteDesc = "".
            end.
            else do for bSourceSM:
               for first bSourceSM
                   where bSourceSM.knbsm_site = sourceSite
                     and bSourceSM.knbsm_supermarket_id = sourceRef
                   no-lock: end.

               for first si_mstr
                   where si_site = sourceSite
                   no-lock: end.

               assign
                  sourceRefDesc = if available(bSourceSM)
                                     then bSourceSM.knbsm_desc
                                     else ""
                  sourceSMInvLoc = if available(bSourceSM)
                                      then bSourceSM.knbsm_inv_loc
                                      else ""
                  sourceSiteDesc = if available(si_mstr)
                                      then si_desc
                                      else "".
            end.  /* else do */
         end.  /* else do */

         /* RETRIEVE LANGUAGE DETAIL RECORD FOR TRANSACTION TYPE */
         {pxrun.i &PROC  = 'getsourceTypeMneumonic' &PROGRAM = 'kbtranxr.p'
                  &PARAM = "(input  knbd_source_type,
                             output sourceType,
                             output sourceTypeDesc)"
                  &NOAPPERROR = true
                  &CATCHERROR = true
         }

         /* RETRIEVE LANGUAGE DETAIL RECORD FOR KNBD_CARD_TYPE */
         {pxrun.i &PROC  = 'getCardTypeMneumonic'
                 &PROGRAM = 'kbtranxr.p'
                 &PARAM = "(input  knbl_card_type,
                            output cardType,
                            output cardTypeDesc)"
                 &NOAPPERROR = true
                 &CATCHERROR = true
         }

         /* RETRIEVE LANGUAGE DETAIL RECORD FOR EVENT */
         {pxrun.i &PROC  ='convertNumericToAlpha' &PROGRAM = 'gplngxr.p'
               &HANDLE=ph_gplngxr
               &PARAM = "(input 'kanban',
                         input  'kbtr_transaction_event',
                         input  pKBCardEvent,
                         output kanbanEvent,
                         output kanbanEventDesc)"
               &NOAPPERROR = true
               &CATCHERROR = true
         }

         /* Get Kanban Accumulator Type from lngd_det */
         {pxrun.i &PROC = 'convertNumericToAlpha' &PROGRAM = 'gplngxr.p'
            &HANDLE = ph_gplngxr
            &PARAM = "(input  'kanban',
                       input  'kanban-accum-type',
                       input   knbl_accum_type,
                       output kanbanAccumType,
                       output kanbanAccumTypeDesc)"
            &NOAPPERROR = true
            &CATCHERROR = true}

         /* Get Kanban Card Loop Type from lngd_det */
         {pxrun.i &PROC = 'convertNumericToAlpha' &PROGRAM = 'gplngxr.p'
            &HANDLE = ph_gplngxr
            &PARAM = "(input  'kanban',
                       input  'kanban-loop-type',
                       input   knb_loop_type,
                       output kanbanLoopType,
                       output kanbanLoopTypeDesc)"
            &NOAPPERROR = true
            &CATCHERROR = true}

         /* VALIDATE SITE SECURITY */
         {gprun.i ""gpsiver.p""
            "(input knbsm_site,
              input ?,
              output return_int)"}
         if return_int = 0 then do:
            /* USER DOES NOT HAVE ACCESS TO THIS SITE */
            {pxmsg.i &MSGNUM=2710 &ERRORLEVEL={&APP-ERROR-RESULT}
                                  &MSGARG1=knbsm_site}
            next-prompt kanbanID with frame c.
            undo, retry.
         end.

         /* VALIDATE KANBAN */
         {pxrun.i &PROC ='validateKanbanCardForTransaction'
            &PROGRAM='kbknbdxr.p'
                      &HANDLE=ph_kbknbdxr
                      &PARAM = "(buffer knbd_det,
                                 input pKBCardEvent,
                                 output errorMessage,
                                 output errorSeverity)"
         }

         if errorMessage <> 0 then
         do :
            {pxmsg.i &MSGNUM=errorMessage
                     &ERRORLEVEL=errorSeverity}
            if errorSeverity > 2 then do:
               next-prompt kanbanID with frame c.
               undo, retry.
            end.
         end.

         if kbc_controlled_entry <> {&SUCCESS-RESULT} then do:
            {pxrun.i &PROC  = 'validateControlledEntry'
                      &PARAM = "(buffer knbd_det,
                                 input  kbc_controlled_entry,
                                 output errorSeverity)"
                            &NOAPPERROR = true
                            &CATCHERROR = true}
            if errorSeverity > 2 then do:
               next-prompt kanbanID with frame c.
               undo, retry.
            end.
         end.

         /* SEE IF MINIMUM THRESHOLD CHECKING IS NEEDED */
         /* ISSUE WARNING IS "1", ERROR IS "2"          */
         if knbl_min_cycle_check = {&KB-MIN-CYCLE-TIME-WARN} or
            knbl_min_cycle_check = {&KB-MIN-CYCLE-TIME-ERROR}
         then do:
            /* FIND LAST TRANSACTION FOR THIS KANBAN ID */
            for last kbtr_hist
            fields(kbtr_id
                   kbtr_trans_date
                   kbtr_trans_time)
            where kbtr_id = knbd_id
            use-index kbtr_id_date
            no-lock:  end.

            if available kbtr_hist then do:
               /* USE CURRENT DATE AND TIME IN SECONDS AND COMPARE LESS */
               /* TRANSACTION DATE AND TIME IN SECONDS, AND COMPARE TO  */
               /* MINIMUM CYCLE TIME IN SECONDS                         */
               if (decimal(today) * 86400 + time) -
                  (decimal(kbtr_trans_date) * 86400 + kbtr_trans_time)
               < knbl_min_cycle_time then do:
                  /* THIS KANBAN ID WAS LAST USED ON # AT # */
                  transTime = string(integer(kbtr_trans_time),"HH:MM:SS").
                  {pxmsg.i &MSGNUM     = 5068
                           &ERRORLEVEL = {&INFORMATION-RESULT}
                           &MSGARG1    = kbtr_trans_date
                           &MSGARG2    = transTime
                  }
                  /* ISSUE WARNING OR ERROR BASED ON MIN CYCLE CHECK FLAG */
                  /* CHECK FOR WARNING MESSAGE */
                  if knbl_min_cycle_check = {&KB-MIN-CYCLE-TIME-WARN} then do:
                     /* THIS IS A MIN CYCLE CHECK VIOLATION. PLEASE CONFIRM */
                     confirmOK = no.
                     {pxmsg.i &MSGNUM     = 5070
                              &ERRORLEVEL = {&INFORMATION-RESULT}
                              &CONFIRM    = confirmOK
                     }
                     if confirmOK = no then do:
                        next-prompt kanbanID with frame c.
                        undo, retry.
                     end.
                  end.  /* knbl_min_cycle_check = "&KB-MIN-CYCLE-TIME-WARN"  */

                  /* CHECK FOR ERROR MESSAGE */
                  if knbl_min_cycle_check = {&KB-MIN-CYCLE-TIME-ERROR} then do:
                     /* THIS IS A MINIMUM CYCLE CHECK VIOLATION */
                     {pxmsg.i &MSGNUM     = 5069
                              &ERRORLEVEL = {&APP-ERROR-RESULT}}
                     next-prompt kanbanID with frame c.
                     undo, retry.
                  end.  /* knbl_min_cycle_check = "&KB-MIN-CYCLE-TIME-ERROR"  */
               end.  /* if (integer(today) * 86400 + time)... */
            end.  /* if available kbtr_hist */
         end.  /* knbl_min_cycle_check > "1" */

         prev-knbd-status = knbd_status.
         {pxrun.i &PROC  = 'executeActiveCodeRequirementsBeforeTransaction'
                            &HANDLE=ph_kbknbdxr
                            &PARAM = "(buffer knbism_det,
                                       buffer knbd_det,
                                       buffer knbl_det,
                                       input pKBCardEvent)"
                            &NOAPPERROR = true
                            &CATCHERROR = true}
         if return-value <> {&SUCCESS-RESULT} then do:
            next-prompt kanbanID with frame c.
            undo, retry.
         end.

         /* IF THE ACTIVE STATUS HAS BEEN CHANGED TO INACTIVE BY THE        */
         /* PROCEDURE executeActiveCodeRequirementsForTransaction           */
         /* THEN NO FURTHER PROCESSING IS NECESSARY.                        */
         if not knbd_active then next kanban-entry-loop.

         /* SEE IF PO NUMBER POP-UP FRAME IS NEEDED                  */
         /* IT IS NEEDED IF THIS LOOP IS A SUPPLIER KANBAN LOOP AND  */
         /* IMPACT INVENTORY = YES AND PO NBR IS BLANK               */
         /* AND CARD IS A REPLENISHMENT CARD AND NOT A MOVE CARD     */

         if knbd_source_type = {&KB-SOURCETYPE-SUPPLIER} and
             pKBCardEvent = {&KB-CARDEVENT-FILL} and
             knbl_impact_inventory = yes and
             knbl_card_type = {&KB-CARDTYPE-REPLENISHMENT}
         then do:
            {pxrun.i &PROC='promptForPONumberPOLine'
                     &PARAM="(input supplierID,
                              input knbsm_site,
                              input knbi_part,
                              input knbd_kanban_quantity,
                              input-output PONumber,
                              input-output POLine)"
                        &NOAPPERROR = true
                        &CATCHERROR = true
            }

            if  return-value <> {&SUCCESS-RESULT} then do:
               undo, retry.
            end.

            if kbc_display_pause > 0 and not batchrun then do:
               display
                    PONumber
                    POLine
               with frame confirmCard.
            end. /* kbc_display_pause > 0  */
         end.  /* if knbd_source_type = {&KB-SOURCETYPE-SUPPLIER} and ... */
         if kbc_display_pause > 0
            and not batchrun
            and c-application-mode <> 'web'
         then do:
            /* DISPLAY MSG FOR NUMBER OF SECONDS REQUESTED IN CONTROL FILE */
            assign pausemsg = " ".
            /* PAUSING # SECONDS, PRESS SPACEBAR TO CONTINUE */
            {pxmsg.i
               &MSGNUM=5065
               &ERRORLEVEL={&INFORMATION-RESULT}
               &MSGBUFFER=pausemsg
               &MSGARG1="kbc_display_pause"}
            status default pausemsg.
/*H01*      pause kbc_display_pause no-message.  */
            /* RESET SO OTHER MESSAGES DISPLAY CORRECTLY */
            status default.
         end.  /* kbc_display_pause > 0 */
         /* IF THE PROGRAM MAKES IT TO HERE, EVERYTHING IS OK TO GENERATE */
         /* ALL APPROPRIATE KANBAN TRANSACTION DATA                       */

         /* GENERATE ALL DATA TRANSACTIONS FOR KANBAN ID */
         {pxrun.i &PROC='processTransaction'
                  &PARAM= "(input pKBCardEvent,
                    buffer knbd_det,
                    input PONumber,
                    input POLine,
                    input supplierID,
                    input knbi_part,
                    input knbsm_site,
                    input knbsm_inv_loc,
                    input knbsm_inv_loc_type,
                    input sourceSite,
                    input sourceSMInvLoc,
                    input effDate,
                    input consumingReference,
                    output pTransactionDate,
                    output pTransactionTime,
                    output errorMessage,
                    output errorSeverity)"}
         if errorMessage <> 0 then do:
            {pxmsg.i &MSGNUM=errorMessage
                     &ERRORLEVEL=errorSeverity}
            next-prompt kanbanID with frame c.
         end.
         if errorSeverity = 3 then undo, retry kanban-entry-loop.

         {pxrun.i &PROC  = 'executeActiveCodeRequirementsAfterTransaction'
                            &HANDLE=ph_kbknbdxr
                            &PARAM = "(buffer knbism_det,
                                       buffer knbd_det,
                                       buffer knbl_det,
                                       input pKBCardEvent,
                                       input prev-knbd-status)"
                            &NOAPPERROR = true
                            &CATCHERROR = true}

         /* KANBAN WAS PROCESSED SUCCESSFULLY */
         leave .
      end.  /* kanban-entry-loop */

     leave .
   end. /* mainloop */ 
   ststatus = stline[1].
   status input ststatus.
end. /* do on error undo, return {&GENERAL-APP-EXCEPT}: */

ststatus = stline[1].
status input ststatus.
status default.
return {&SUCCESS-RESULT}.

/* ************************************************************************** */
/* ****************** I N T E R N A L   P R O C E D U R E S ***************** */
/* ************************************************************************** */

/*============================================================================*/
PROCEDURE processTransaction:
/*---------------------------------------------------------------------------
   Purpose:    Updates the card with the event and create kanban history.
   Exceptions: NONE
   Notes:
   History:
---------------------------------------------------------------------------*/
define input  parameter  pKBCardEvent          as character no-undo.
define        parameter buffer knbd_det        for knbd_det.
define input  parameter pPONbr                 as character          no-undo.
define input  parameter pPOLine                as character          no-undo.
define input  parameter pSupplierID            as character          no-undo.
define input  parameter pPart                  as character          no-undo.
define input  parameter pSupermarketSite       as character          no-undo.
define input  parameter pReceiptLocation       as character          no-undo.
define input  parameter pReceiptLocationType   as character          no-undo.
define input  parameter pSourceSite            as character          no-undo.
define input  parameter pSourceLocation        as character          no-undo.
define input  parameter pEffDate               as date               no-undo.
define input  parameter pConsumingReference    as character          no-undo.
define output parameter transactionDate        as date               no-undo.
define output parameter transactionTime        as integer            no-undo.
define output parameter errorMessage           as integer            no-undo.
define output parameter errorSeverity          as integer            no-undo.

define buffer bf-knp_mstr for knp_mstr.

/* ***  CANNOT DEFINE SHARED VARIABLES IN AN INTERNAL PROCEDURE  *** *
/* FOLLOWING 4 NEW SHARED VARIABLES NEEDED FOR KBPORCM.P   */
define new shared variable porec       like mfc_logical                no-undo.
define new shared variable ports       as   character                  no-undo.
define new shared variable is-return   like mfc_logical                no-undo.
define new shared variable tax_tr_type like tx2_tax_type  initial "21" no-undo.
 * ***  CANNOT DEFINE SHARED VARIABLES IN AN INTERNAL PROCEDURE  *** */


define variable ReturnOKFlag                   as   logical          no-undo.
define variable KanbanTransNbr                 as integer            no-undo.
define variable routing                        like knbi_routing     no-undo.
define variable bomCode                        like knbi_bom_code    no-undo.
define variable iss-receipt                    as logical            no-undo.

do on error undo, return error {&GENERAL-APP-EXCEPT}:
   /* ABORT IF RECORD NOT FOUND */
   if not available knbd_det then do:
      assign
         errorMessage  = 5046
         errorSeverity = 3.
         /* Kanban ID does not exist. */
      return.
   end.

   /* RETRIEVE LOOP DETAIL RECORD */
   for first knbl_det
   where knbl_keyid       = knbd_knbl_keyid
   no-lock:  end.

   /* RETRIEVE KANBAN MASTER RECORD */
   for first knb_mstr
   where knb_keyId       = knbl_knb_keyId
   no-lock: end.

   if pKBCardEvent = {&KB-CARDEVENT-SHIP} and
      can-find (first knbfd_det where knbfd_knb_keyid = knb_keyid)
   then do:
      if knbd_next_process_id = "" then do:
         knbd_next_process_id = knp_mstr.knp_process_id.
      end.
      if kbc_ctrl.kbc_fifo_entry then do:
      Get-Curr-Fifo-Loop:
         do while true:
            /* Please enter the process ID you are shipping from */
            {pxmsg.i &MSGNUM     = 5978
                     &ERRORLEVEL = {&INFORMATION-RESULT}
                     &CONFIRM    = knbd_next_process_id
                     &CONFIRM-TYPE = 'NON-LOGICAL'
            }
            if knbd_next_process_id = knp_mstr.knp_process_id
            then leave Get-Curr-Fifo-Loop.

            for first bf-knp_mstr no-lock where
               bf-knp_mstr.knp_site = knp_mstr.knp_site and
               bf-knp_mstr.knp_process_id = knbd_next_process_id: end.
            if not available bf-knp_mstr then do:
               /* FIFO PROCESS NOT DEFINE FOR KANBAN LOOP */
               {pxmsg.i &MSGNUM     = 5977
                     &ERRORLEVEL = {&APP-ERROR-RESULT}}
               next Get-Curr-Fifo-Loop.
            end.
            if not can-find(first knbfd_det where knbfd_knb_keyid = knb_keyid
               and knbfd_knp_keyid = bf-knp_mstr.knp_keyid) then do:
               /* FIFO PROCESS NOT DEFINE FOR KANBAN LOOP */
               {pxmsg.i &MSGNUM     = 5977
                     &ERRORLEVEL = {&APP-ERROR-RESULT}}
               next Get-Curr-Fifo-Loop.
            end.
            leave Get-Curr-Fifo-Loop.
         end.
      end. /* kbc_fifo_entry */
   end.   /* SHIP EVENT WITH FIFO PROCESSING */

   {pxrun.i &PROC ='updateKanbanCardWithEvent' &PROGRAM='kbknbdxr.p'
            &HANDLE=ph_kbknbdxr
            &PARAM="(buffer knbd_det,
                     input pKBCardEvent,
                     input pEffDate,
                     input pSupermarketSite,
                     input pConsumingReference,
                     output KanbanTransNbr)"}
   /* DETERMINE TRANSACTION QUANTITY TO BE USED */
   /* AND IF THERE IS TO BE ANY INVENTORY IMPACT */
   if pKBCardEvent = {&KB-CARDEVENT-FILL} and
      knbl_card_type = {&KB-CARDTYPE-REPLENISHMENT} and
      knbl_impact_inventory = yes
   then do:

      /* PERFORM EDITS HERE FOR EACH TRANSACTION TYPE */
      /* IF OK RUN POSTING PROGRAM TO UPDATE DATABASE */

      /* CHECK FOR PURCHASE RECEIPT TRANSACTION TYPE */
      if knbd_source_type = {&KB-SOURCETYPE-SUPPLIER} then do:
      
/*cj0130******************DELETE BEGIN********************  
         /*  VALIDATE SUPPLYING SOURCE IS A VALID SUPPLIER  */
         {pxrun.i &PROC  = 'validateSupplier' &PROGRAM = 'kbtranxr.p'
                  &PARAM = "(input  pSupplierID,
                             output errorMessage,
                             output errorSeverity)"
                  &NOAPPERROR = true
                  &CATCHERROR = true
         }

         if errorMessage <> 0 then do:
            {pxmsg.i &MSGNUM=errorMessage
                     &ERRORLEVEL=errorSeverity}
            if errorSeverity = 3 then return.
         end.

         /*  VALIDATE PURCHASE ORDER TO BE USED  */
         {pxrun.i &PROC  = 'validatePurchaseOrder' &PROGRAM = 'kbtranxr.p'
                  &PARAM = "(input  pPONbr,
                             input  pSupplierID,
                             input  pPart,
                             input  pSupermarketSite,
                             output errorMessage,
                             output errorSeverity)"
                  &NOAPPERROR = true
                  &CATCHERROR = true
         }

         if errorMessage <> 0 then do:
            {pxmsg.i &MSGNUM=errorMessage
                     &ERRORLEVEL=errorSeverity}
            if errorSeverity = 3 then return.
         end.

         /*  VALIDATE PURCHASE ORDER LINE TO BE USED  */
         {pxrun.i &PROC  = 'validatePurchaseOrderLine' &PROGRAM = 'kbtranxr.p'
                  &PARAM = "(input  pPONbr,
                             input  pPOLine,
                             input  pPart,
                             input  pSupermarketSite,
                             output errorMessage,
                             output errorSeverity)"
                  &NOAPPERROR = true
                  &CATCHERROR = true
         }

         if errorMessage <> 0 then do:
            {pxmsg.i &MSGNUM=errorMessage
                     &ERRORLEVEL=errorSeverity}
            if errorSeverity = 3 then return.
         end.

         /* PURCHASE RECEIPT KANBAN TRANSACTION IS OK */
         /* UPDATE DATABASE FOR PURRCP TRANSACTION    */
         /* LET POPORCM.P KNOW THAT WE'RE RECEIVING PURCHASE ORDERS. */
         assign
            ports     = ""
            porec     = yes
            is-return = no.

         {gprun.i ""kbporcm.p""
                  "(input  pPONbr,
                    input  pPOLine,
                    input  knbd_kanban_quantity,
                    input  pEffDate,
                    input  pSupermarketSite,
                    input  pReceiptLocation,
                    input  KanbanTransNbr,
                    output ReturnOKFlag)" }

         /* IF RETURN FLAG NOT = YES, AN ERROR HAS OCCURRED*/
         /* THE CALLED PROGRAM WILL DISPLAY THE ERROR MSG */
         /* SO HERE ONLY AN UNDO, RETURN MUST BE DONE     */
         if ReturnOKFlag = no then do:
            errorSeverity = 3.
            undo, return.
         end.

**CJ0130 DELETE END**********************************/

         /* IF THE PO IS NOT THE SAME AS THE PO ON THE CARD */
         /* THEN UPDATE THE KANBAN HISTORY WITH THE PO      */
         if knbd_ref2 <> pPONbr then do:
            {pxrun.i &PROC ='updateKanbanHistoryWithPO'
                     &PROGRAM='kbtrxr.p'
                     &HANDLE=ph_kbtrxr
                     &PARAM="(input KanbanTransNbr,
                              input pPONbr,
                              input pPOLine)"}
         end.  /* if knbd_ref2 <> pPONbr */

      end.  /* if knbd_source_type = {&KB-SOURCETYPE-SUPPLIER} */



      /* CHECK FOR ITEM MOVEMENT TRANSACTION TYPE */
      if knbd_source_type = {&KB-SOURCETYPE-INVENTORY} then do:

         /* THERE ARE FOUR (4) TYPES OF INVENTORY TRANSFERS BUT ONLY */
         /* THREE (3) HAVE INVENTORY IMPACTS:                        */
         /*                                                          */
         /*    Source Location Type     Receipt Location Type        */
         /*    ====================     =====================        */
         /* 1. INVENTORY       ----->   INVENTORY                    */
         /* 2. INVENTORY       ----->   RAW-IN-PROCESS               */
         /* 3. RAW-IN-PROCESS  ----->   INVENTORY                    */
         /* 4. RAW-IN-PROCESS  ----->   RAW-IN-PROCESS  (NO IMPACT)  */
         /*                                                          */

         if knbd_source_type = {&KB-SOURCETYPE-INVENTORY} and
            pReceiptLocationType = {&KB-SUPERMARKETTYPE-INVENTORY}
         then do:

            /* TRANSFER:  INVENTORY -----> INVENTORY              */

            /* IF THE SUPERMARKET IS AN INVENTORY LOCATION THEN   */
            /* CREATE A STANDARD INVENTORY TRANSFER TRANSACTION.  */
            
/*CJ0130***********DELETE BEGIN**********************
            /* CALL ITEM TRANSFER PROGRAM TO UPDATE ALL DATABASE FILES */
            {gprun.i ""kblotr.p""
                     "(input  pPart,
                       input  knbd_kanban_quantity,
                       input  pEffDate,
                       input  pSourceSite,
                       input  pSourceLocation,
                       input  pSupermarketSite,
                       input  pReceiptLocation,
                       input  KanbanTransNbr,
                       output ReturnOKFlag)" }
            /* IF RETURN FLAG NOT = YES, AN ERROR HAS OCCURRED*/
            /* THE CALLED PROGRAM WILL DISPLAY THE ERROR MSG */
            /* SO HERE ONLY AN UNDO, RETURN MUST BE DONE     */
            if ReturnOKFlag = no then do:
               errorSeverity = 3.
               undo, return.
            end.
**CJ0130*************DELETE END*******************/      
       
         end.  /* if knbd_source_type = {&KB-SOURCETYPE-INVENTORY} */

         if knbd_source_type = {&KB-SOURCETYPE-INVENTORY} and
            pReceiptLocationType = {&KB-SUPERMARKETTYPE-RIP} then do:

            /*                                                    */
            /* TRANSFER:  INVENTORY -----> RAW-IN-PROCESS         */
            /*                                                    */
            /*    *** F U T U R E   E N H A N C E M E N T ***     */
            /*                                                    */
            /* IF THE SUPERMARKET IS A RIP LOCATION THEN CREATE   */
            /* AN UNPLANNED ISSUE TO DEDUCT INVENTORY FROM THE    */
            /* AN UNPLANNED ISSUE FROM THE SOURCE LOCATION.       */
            /* SOURCE LOCATION.  CALL icintra.p                   */
            /*                                                    */
            /*    *** F U T U R E   E N H A N C E M E N T ***     */
            /*                                                    */

            /* IF RETURN FLAG NOT = YES, AN ERROR HAS OCCURRED*/
            /* THE CALLED PROGRAM WILL DISPLAY THE ERROR MSG */
            /* SO HERE ONLY AN UNDO, RETURN MUST BE DONE     */
            if ReturnOKFlag = no then do:
               errorSeverity = 3.
               undo, return.
            end.
         end.  /* if knbd_source_type = {&KB-SOURCETYPE-INVENTORY} */

      end.  /* if knbd_source_type = {&KB-SOURCETYPE-INVENTORY} */

      if knbd_source_type =  {&KB-SOURCETYPE-PROCESS} then do:
         /* RETRIEVE KANBAN SOURCE MASTER RECORD */
         for first knbs_det no-lock
            where knbs_keyid = knb_knbs_keyid: end.

         /* RETRIEVE KANBAN ITEM MASTER RECORD */
         for first knbi_mstr no-lock where
            knbi_keyid = knb_knbi_keyid: end.

         /* GET THE KANBAN PROCESS MASTER RECORD */
         for first knp_mstr no-lock where
            knp_mstr.knp_site = knbs_ref1 and
            knp_mstr.knp_process_id = knbs_ref2: end.

         /* GET THE KANBAN PROCESS DETAIL RECORD */
         for first knpd_det no-lock where
            knpd_knbi_keyid = knbi_keyid and
            knpd_knp_keyid = knp_mstr.knp_keyid: end.

         /* GET THE KANBAN SUPERMARKET MASTER RECORD */
         for first knbsm_mstr no-lock where
            knbsm_keyid = knb_knbsm_keyid: end.

         if available knbs_det and
            available knbi_mstr and
            available knp_mstr  and
            available knpd_det  and
            available knbsm_mstr
         then do:

            /* DON'T ALLOW CO/BY PRODUCT ITEM FOR PRODRCPT   */
            /* CHECK  ITEM/SUPPLYING SITE NOT A COBY PRODUCT */
            {pxrun.i &PROC  = 'validateCoByProduct' &PROGRAM = 'kbtranxr.p'
                     &HANDLE = ph_kbtranxr
                     &PARAM = "(input  knbi_part,
                                input  knp_mstr.knp_site,
                                output errorMessage)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
            }
            if errorMessage <> 0 then do:
               errorSeverity = 3.
               undo, return.
            end.

            if knp_mstr.knp_site <> knbsm_site then do:
               /* CHECK  ITEM/SUPERMARKET SITE NOT A COBY PRODUCT */
               {pxrun.i &PROC  = 'validateCoByProduct' &PROGRAM = 'kbtranxr.p'
                        &PARAM = "(input  knbi_part,
                                   input  knbsm_site,
                                   output errorMessage)"
                        &NOAPPERROR = true
                        &CATCHERROR = true
               }
               if errorMessage <> 0 then do:
                  errorSeverity = 3.
                  undo, return.
               end.
            end. /* if knp_mstr.knp_site <> knbsm_site */

            /* PRODUCTION RECEIPT KANBAN TRANSACTION IS OK */
            /* CALL ITEM RECEIPT WITH BACKFLUSH PROGRAM TO */
            /* UPDATE ALL DATABASE FILES                   */

            for last kbtr_hist no-lock where
               kbtr_id = knbd_id and
               kbtr_transaction_event = {&KB-CARDEVENT-FILL}: end.

            for first ptp_det fields (ptp_routing ptp_bom_code) no-lock where
               ptp_part = knbi_part and
               ptp_site = knbsm_site: end.

            /* IF THE ROUTING CODE IS NOT DEFINED IN MFG/PRO,               */
            /* AND THIS PROCESS DOES NOT CONTAIN FIFO PROCESSING,           */
            /* THEN THE ROUTINE KBINTR01.P ONLY NEEDS TO BE CALLED ONCE.    */
            /* HOWEVER, IF THE LOOP TO SET UP TO EXECUTE ADDITIONAL         */
            /* FIFO PROCESSES, AND THE ROUTING CODE EXISTS IN MFG/PRO,      */
            /* THEN THE ROUTINE KBINTR01.P NEEDS TO BE EXECUTED FOR THE     */
            /* NON-FIFO AND FIFO PROCESSES.                                 */

            /* GET THE ROUTING AND BOM CODE TO USE */
            assign
               bomCode = knbi_bom_code.
               routing = knbi_routing.

            if routing = "" and available ptp_det then routing = ptp_routing.
            if routing = "" and pt_mstr.pt_routing <> ""
                then routing = pt_routing.
            if routing = "" then routing = knbi_part.

            if bomCode = "" and available ptp_det then bomCode = ptp_bom_code.
            if bomCode = "" and pt_mstr.pt_bom_code <> ""
                then bomCode = pt_bom_code.
            if bomCode = "" then bomCode = knbi_part.

            if not can-find(first knbfd_det where knbfd_knb_keyid = knb_keyid)
               or
               not can-find(first ro_det where ro_routing = routing)
            then do:
               {gprun.i ""kbintr01.p""
                        "(input  knbi_part,
                          input  kbtr_kanban_quantity,
                          input  pEffDate,
                          input  knp_mstr.knp_site,
                          input  knp_mstr.knp_loc,
                          input  knbsm_site,
                          input  knbsm_inv_loc,
                          input  knbl_backflush,
                          input  kbtr_trans_nbr,
                          input  routing,
                          input  bomCode,
                          input  knpd_op_start,
                          input  knpd_op_end,
                          input  yes,
                          output ReturnOKFlag)" }

               /* IF RETURN FLAG NOT = YES, AN ERROR HAS OCCURRED*/
               /* THE CALLED PROGRAM WILL DISPLAY THE ERROR MSG */
               /* SO HERE ONLY AN UNDO, RETURN MUST BE DONE     */
               if ReturnOKFlag = no then do:
                  errorSeverity = 3.
                  undo, return.
               end.
            end. /* NO FIFO PROCESSES or NO ROUTING DEFINED */
            else do:
               /* FIRST PROCES THE NON FIFO PROCESS */
               {gprun.i ""kbintr01.p""
                        "(input  knbi_part,
                          input  kbtr_kanban_quantity,
                          input  pEffDate,
                          input  knp_mstr.knp_site,
                          input  knp_mstr.knp_loc,
                          input  knbsm_site,
                          input  knbsm_inv_loc,
                          input  knbl_backflush,
                          input  kbtr_trans_nbr,
                          input  routing,
                          input  bomCode,
                          input  knpd_op_start,
                          input  knpd_op_end,
                          input  no,
                          output ReturnOKFlag)" }

               /* IF RETURN FLAG NOT = YES, AN ERROR HAS OCCURRED*/
               /* THE CALLED PROGRAM WILL DISPLAY THE ERROR MSG */
               /* SO HERE ONLY AN UNDO, RETURN MUST BE DONE     */
               if ReturnOKFlag = no then do:
                  errorSeverity = 3.
                  undo, return.
               end.

               iss-receipt = no.

               /* NOW PROCESS ALL FIFO PROCESSES */
               for each knbfd_det no-lock where
                  knbfd_knb_keyid = knb_keyid,
                  each knp_mstr no-lock where
                     knp_mstr.knp_keyid = knbfd_knp_keyid,
                  each knpd_det no-lock where
                     knpd_knp_keyid = knp_mstr.knp_keyid and
                     knpd_knbi_keyid = knbi_keyid
                  break by knbfd_knb_keyid
                        by knbfd_seq:

                  if last-of(knbfd_knb_keyid) then iss-receipt = yes.

                  {gprun.i ""kbintr01.p""
                           "(input  knbi_part,
                             input  kbtr_kanban_quantity,
                             input  pEffDate,
                             input  knp_mstr.knp_site,
                             input  knp_mstr.knp_loc,
                             input  knbsm_site,
                             input  knbsm_inv_loc,
                             input  knbl_backflush,
                             input  kbtr_trans_nbr,
                             input  routing,
                             input  bomCode,
                             input  knpd_op_start,
                             input  knpd_op_end,
                             input  iss-receipt,
                             output ReturnOKFlag)" }

                  /* IF RETURN FLAG NOT = YES, AN ERROR HAS OCCURRED*/
                  /* THE CALLED PROGRAM WILL DISPLAY THE ERROR MSG */
                  /* SO HERE ONLY AN UNDO, RETURN MUST BE DONE     */
                  if ReturnOKFlag = no then do:
                     errorSeverity = 3.
                     undo, return.
                  end.

               end.  /* for each knbfd_det..... */

            end. /* DO FIFO RECEIPT PROCESSING */

            /* SEE IF THIS KANBAN PRODUCTION LINE IS ALSO A FLOW PRODUCTION LINE */
            /* IF SO, CALL PROGRAM TO APPLY RECEIPT TO FLOW LINE                 */
            /* THIS IS ACTIVATED BY THE LN_KANBAN_RECEIPT FLAG IN LN_MSTR        */
            for first ln_mstr
            fields(ln_site
                   ln_line
                   ln_kanban_receipts)
            where ln_line = knp_mstr.knp_production_line
            and   ln_site = knp_mstr.knp_site
            no-lock:  end.

            if available ln_mstr and ln_kanban_receipts = yes then do:
               /* VERIFY AT LEAST ONE FLOW SCHEDULE EXISTS PRIOR TO THE  */
               /* KANBAN EFFECTIVE DATE                                  */
               if can-find(first flsd_det
                  where flsd_site            =  knp_mstr.knp_site
                    and flsd_production_line =  knp_mstr.knp_production_line
                    and flsd_due_date        <= pEffDate)
               then do:
                  /* CALL PROGRAM TO POST TO FLOW SCHEDULE */
                  {gprun.i ""kbflrc.p""
                           "(input knbi_part,
                             input knp_mstr.knp_site,
                             input knp_mstr.knp_production_line,
                             input knbd_kanban_quantity,
                             input pEffDate)" }
               end.  /* if can-find(first flsd_det...) */
            end. /* if available ln_mstr... */
         end. /* available all kanban master loop data */
      end.  /* Source is a process  (ProdRcpt) */

   end.  /* if pKBCardEvent = {&KB-CARDEVENT-FILL} and ... */
end. /* do on error undo, return {&GENERAL-APP-EXCEPT}: */

return {&SUCCESS-RESULT}.
end procedure. /* processTransaction */


/*============================================================================*/
PROCEDURE displayLastTransactions:
/*---------------------------------------------------------------------------
   Purpose:    Lists the last transactions for this user,
               as many as can fit in a frame.
   Exceptions: NONE
   Notes:
   History:
---------------------------------------------------------------------------*/
define variable displayTime as character format "x(8)" no-undo.
define variable refInfo as character format "x(18)" label "Reference" no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* DEFINE SCROLLING WINDOW FRAME kbTransactions */
      form       displayTime   label "Time"
                 kbtr_id
                 kbtr_part
                 kbtr_supermarket_id
                 refInfo
                 kanbanEvent
      with frame kbTransactions
         width 80
         down
         title color normal
         (getFrameTitle("TRANSACTION_LOG",32))
         no-underline.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame kbTransactions:handle).

      clear frame kbTransactions all no-pause.

      for each kbtr_hist where kbtr_mod_userid = global_userid and
                               kbtr_trans_date = today
                               no-lock
                               by kbtr_trans_time descending
                               by kbtr_trans_nbr descending
                               with frame kbTransactions:

      /* Get Kanban Event from lngd_det */
      {pxrun.i &PROC = 'convertNumericToAlpha' &PROGRAM = 'gplngxr.p'
         &HANDLE = ph_gplngxr
         &PARAM = "(input  'kanban',
                    input  'kbtr_transaction_event',
                    input   kbtr_transaction_event,
                    output kanbanEvent,
                    output kanbanEventDesc)"
         &NOAPPERROR = true
         &CATCHERROR = true}

         assign displayTime = string(integer(kbtr_trans_time), "HH:MM:SS")
                refInfo = if kbtr_card_type = {&KB-CARDTYPE-REPLENISHMENT}
                        then string(kbtr_source_ref1 + "-" +
                             (if kbtr_source_ref2 <> "" then
                                 kbtr_source_ref2       else kbtr_po_nbr) +
                             (if kbtr_source_ref3 <> "" then "-" else "") +
                             kbtr_source_ref3 +
                             (if kbtr_source_ref4 <> "" then "-" else "") +
                             kbtr_source_ref4 +
                             (if kbtr_source_ref5 <> "" then "-" else "") +
                             kbtr_source_ref5)
                        else string(kbtr_pou_site +
                             (if kbtr_pou_ref <> "" then "-" else "") +
                             kbtr_pou_ref).

         if frame-line (kbTransactions) = frame-down(kbTransactions)
         then leave.
      end.
   end. /* do on error undo, return {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
end procedure. /* displayLastTransactions */

/*============================================================================*/
PROCEDURE promptForConsumingReference:
/*---------------------------------------------------------------------------
   Purpose:     Prompts for Point of Use Reference.
   Exceptions:  NONE
   Notes:
   History:
---------------------------------------------------------------------------*/
define input  parameter ip-kanbanEvent          as character no-undo.
define output parameter op-consumingReference   like knbd_pou_ref no-undo.

do on error undo, return error {&GENERAL-APP-EXCEPT}:

   if ip-kanbanEvent <> {&KB-CARDEVENT-CONSUME} then return {&SUCCESS-RESULT}.

   /* EFFECTIVE DATE ENTRY FRAME  */
   form
      op-consumingReference  colon 25
   with frame consumingReference
   side-labels width 80 attr-space.
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame consumingReference:handle).

   set
      op-consumingReference
      go-on("F4" "CTRL-E")
      with frame consumingReference.

   /* RETURN IF ENDKEY CONDITION IS REACHED */
   if lastkey = keycode("F4") or lastkey = keycode("CTRL-D") then do:
      hide frame consumingReference no-pause.
      return {&GENERAL-APP-EXCEPT}.
   end.  /* if lastkey = keycode("F4") or lastkey = keycode("CTRL-D") */

   /* DON'T ALLOW ENTRY OF UNKNOWN VALUE IN ANY FIELD */
   {gpchkqsi.i &fld=op-consumingReference     &frame-name=consumingReference}

   hide frame consumingReference no-pause.
end. /* do on error undo, return {&GENERAL-APP-EXCEPT}: */
return {&SUCCESS-RESULT}.
end procedure. /* promptForConsumingReference */

/*============================================================================*/
PROCEDURE promptForControlledEntry:
/*---------------------------------------------------------------------------
   Purpose:     Prompts for fields to validate the cards against.
   Exceptions:  NONE
   Notes:
   History:
---------------------------------------------------------------------------*/

define variable supplierName         like vd_sort  no-undo.

   do on error undo, return {&GENERAL-APP-EXCEPT}:

      /* CONTROLLED ENTRY FRAME  */
      form
         CEPart             colon 26
         pt_desc1                       colon 48 no-label skip
         CESite             colon 26
         si_desc                        colon 48 no-label skip
         CESuperMarket      colon 26
         knbsm_desc                     colon 48 no-label skip
         CEProcess          colon 26
         knp_mstr.knp_desc              colon 48 no-label skip
         CESupplier         colon 26
         supplierName                   colon 48 no-label skip
         CEPurchaseOrder    colon 26                      skip
         CESourceSMSite     colon 26
         CESourceSMSiteDesc             colon 48 no-label skip
         CESourceSM         colon 26
         CESourceSMDesc                 colon 48 no-label skip
         CECardTypeMnemonic colon 26
         cardTypeDesc                   colon 48 no-label skip
      with frame b title color normal (getFrameTitle("CONTROLLED_ENTRY",24))
      side-labels width 80 attr-space.
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

         view frame b.

      controlled-entry:
      do on error undo, retry
         on endkey undo, return {&GENERAL-APP-EXCEPT} with frame b:

         prompt-for
            CEPart
            CESite
            CESuperMarket
            CEProcess
            CESupplier
            CEPurchaseOrder
            CESourceSMSite
            CESourceSM
            CECardTypeMnemonic
         with frame b editing:
            if frame-field = "CEPart" then do:
               {mfnp.i pt_mstr CEPart pt_part
                       CEPart pt_part pt_part}
               if recno <> ? then do:
                  display pt_part @ CEPart
                          pt_desc1 with frame b.
                  recno = ?.
               end.

            end.
            else if frame-field = "CESite" then do:
               {mfnp.i si_mstr CESite si_site
                       CESite si_site si_site}
               if recno <> ? then do:
                  display si_site @ CESite
                          si_desc with frame b.
                  recno = ?.
               end.
            end.
            else if frame-field = "CESuperMarket" then do:
               {mfnp05.i knbsm_mstr
                         knbsm_site_id
                         "(knbsm_site = input CESite)"
                         knbsm_supermarket_id
                         "input CESuperMarket"}
               if recno <> ? then do:
                  display knbsm_supermarket_id @ CESuperMarket
                          knbsm_desc with frame b.
                  recno = ?.
               end.
            end.
            else if frame-field = "CEProcess" then do:
               {mfnp05.i knp_mstr
                         knp_process_id
                         "(knp_mstr.knp_site = input CESite)"
                         knp_mstr.knp_process_id
                         "input CEProcess"}
               if recno <> ? then do:
                  display si_site @ CEProcess
                          knp_mstr.knp_desc with frame b.
                  recno = ?.
               end.
            end.
            else if frame-field = "CESupplier" then do:
               {mfnp.i vd_mstr CESupplier vd_addr
                       CESupplier vd_addr vd_addr}
               if recno <> ? then do:
                  /* RETRIEVE SUPPLIER DESCRIPTION */
                  {pxrun.i &PROC  = 'getSupplierName' &PROGRAM = 'kbtranxr.p'
                           &PARAM = "(input vd_addr,
                                      output supplierName)"
                           &NOAPPERROR = true
                           &CATCHERROR = true
                  }
                  display vd_addr @ CESupplier
                          supplierName with frame b.
                  recno = ?.
               end.
            end.
            else if frame-field = "CEPurchaseOrder" then do:
               {mfnp05.i po_mstr
                         po_nbr
                         "po_fsm_type = """""
                         po_nbr
                         "input CEPurchaseOrder"}
               if recno <> ? then do:
                  /* RETRIEVE SUPPLIER DESCRIPTION */
                  {pxrun.i &PROC  = 'getSupplierName' &PROGRAM = 'kbtranxr.p'
                           &PARAM = "(input po_vend,
                                      output supplierName)"
                           &NOAPPERROR = true
                           &CATCHERROR = true
                  }
                  display po_nbr @ CEPurchaseOrder
                          po_vend @ CESupplier
                          supplierName with frame b.
                  recno = ?.
               end.
            end.
            else if frame-field = "CESourceSMSite" then do:
               {mfnp.i si_mstr CESourceSMSite si_site
                       CESourceSMSite si_site si_site}
               if recno <> ? then do:
                  display si_site @ CESourceSMSite
                          si_desc @ CESourceSMSiteDesc with frame b.
                  recno = ?.
               end.
            end.
            else if frame-field = "CESourceSM" then do:
               {mfnp05.i knbsm_mstr
                         knbsm_site_id
                         "(knbsm_site = input CESourceSMSite)"
                         knbsm_supermarket_id
                         "input CESourceSM"}
               if recno <> ? then do:
                  display knbsm_supermarket_id @ CESourceSM
                          knbsm_desc @ CESourceSMDesc with frame b.
                  recno = ?.
               end.
            end.
            else do:
              readkey.
              apply lastkey.
            end.
         end.  /* editing  */

         /* DON'T ALLOW ENTRY OF UNKNOWN VALUE IN ANY FIELD */
         {gpchkqsi.i &fld=CEPart              &frame-name=b}
         {gpchkqsi.i &fld=CESite                 &frame-name=b}
         {gpchkqsi.i &fld=CESuperMarket          &frame-name=b}
         {gpchkqsi.i &fld=CEProcess              &frame-name=b}
         {gpchkqsi.i &fld=CESupplier             &frame-name=b}
         {gpchkqsi.i &fld=CEPurchaseOrder        &frame-name=b}
         {gpchkqsi.i &fld=CESourceSMSite         &frame-name=b}
         {gpchkqsi.i &fld=CESourceSM             &frame-name=b}
         {gpchkqsi.i &fld=CECardTypeMnemonic     &frame-name=b}

         assign
            CEPart
            CESite
            CESuperMarket
            CEProcess
            CESupplier
            CEPurchaseOrder
            CESourceSMSite
            CESourceSM
            CECardTypeMnemonic.

         /* VALIDATE PART  */
         if CEPart <> "" then do:
               for first pt_mstr
               fields (pt_part pt_desc1)
            where pt_part = CEPart no-lock: end.

            if available pt_mstr then do:
               display pt_desc1 with frame b.
               end.
            else do:
               /* Item Number does not exist */
               {pxmsg.i &MSGNUM=16
                        &ERRORLEVEL={&APP-ERROR-RESULT}}
               next-prompt CEPart with frame b.
               undo, retry.
            end.
         end.  /* CEPart <> "" */

         if CESite <> "" then do:
            {pxrun.i &proc='validateSite' &program='icsixr.p'
               &handle=ph_icsixr
               &param="(input '',
                        input CESite,
                        input no,
                        input {&SUPPRESS-MSG})"
               &catcherror=TRUE
               &noapperror=TRUE}

            /* IF THIS IS A SITE, DOES USER HAVE ACCESS TO THIS SITE? */
               {pxrun.i &PROC='validateSiteSecurity' &PROGRAM='icsixr.p'
                        &HANDLE=ph_icsixr
                     &PARAM="(input CESite,
                                 input '')"
                        &NOAPPERROR = true
                        &CATCHERROR = true
               }
               if  return-value <> {&SUCCESS-RESULT} then do:
               next-prompt CESite with frame b.
                  undo, retry.
               end.

            /* IF THIS IS A SITE, IS SITE IN THE CURRENT DATABASE? */
            {pxrun.i &PROC='validateDatabaseSite' &PROGRAM='icsixr.p'
                     &HANDLE=ph_icsixr
                     &PARAM="(input CESite)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
            }
            if  return-value <> {&SUCCESS-RESULT} then do:
               next-prompt CESite with frame b.
               undo, retry.
            end.
            else do:
               /* RETRIEVE SITE DESCRIPTION */
               for first si_mstr
               fields (si_site si_desc)
               where si_site = CESite no-lock: end.
               display si_desc with frame b.
            end.
         end.

         if CESupplier <> "" then do:
            /*  VALIDATE IF SUPPLYING SOURCE IS A SUPPLIER  */
            {pxrun.i &PROC  = 'validateSupplier' &PROGRAM = 'popoxr.p'
                     &PARAM = "(input  CESupplier)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
            }

            if  return-value <> {&SUCCESS-RESULT} then do:
               next-prompt CESupplier with frame b.
               undo, retry.
            end.

            /* RETRIEVE SUPPLIER DESCRIPTION */
            {pxrun.i &PROC  = 'getSupplierName' &PROGRAM = 'kbtranxr.p'
                     &PARAM = "(input CESupplier,
                                output supplierName)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
            }
            display supplierName with frame b.
         end.  /* if CESupplier <> "" */

         /* VALIDATE PO */
         if CEPurchaseOrder <> "" then do:
            for first po_mstr
            where po_nbr = CEPurchaseOrder
            no-lock: end.
            if not available (po_mstr)
            then do:
               {pxmsg.i &MSGNUM=343
                        &ERRORLEVEL={&APP-ERROR-RESULT}}
               /* Purchase Order does not exist */
               next-prompt CEPurchaseOrder with frame b.
               undo, retry.
            end.

            /*  VALIDATE THE PO TYPE */
            {pxrun.i &PROC  = 'validateRTSOrder' &PROGRAM = 'popoxr.p'
                     &PARAM = "(input po_fsm_type)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
            }
            if  return-value <> {&SUCCESS-RESULT} then do:
               next-prompt CEPurchaseOrder with frame b.
               undo, retry.
            end.

         end.   /* CEPurchaseOrder <> ""  */

         /* VALIDATE SUPER MARKET */
         if CESupermarket <> "" then do:

            for first knbsm_mstr
            where knbsm_supermarket_id = CESupermarket
            no-lock: end.

            if not available (knbsm_mstr)
            then do:
               {pxmsg.i &MSGNUM=5951
                        &ERRORLEVEL={&APP-ERROR-RESULT}}
               /* Super Market does not exist */
               next-prompt CESupermarket with frame b.
               undo, retry.
            end.

            display knbsm_desc with frame b.
         end.   /* CESupermarket <> ""  */

         /* VALIDATE THE PROCESS */
         if CEProcess <> "" then do:

            for first knp_mstr
            where knp_mstr.knp_process_id = CEProcess
            no-lock: end.
            if not available (knp_mstr)
            then do:
               {pxmsg.i &MSGNUM=5899
                        &ERRORLEVEL={&APP-ERROR-RESULT}}
               /* Process Master does not exist */
               next-prompt CEProcess with frame b.
               undo, retry.
            end.

            display knp_mstr.knp_desc with frame b.
         end. /* CEProcess <> "" */

         if CESourceSMSite <> "" then do:
            {pxrun.i &proc='validateSite' &program='icsixr.p'
               &handle=ph_icsixr
               &param="(input '',
                        input CESourceSMSite,
                        input no,
                        input {&SUPPRESS-MSG})"
               &catcherror=TRUE
               &noapperror=TRUE}

            /* IF THIS IS A SITE, DOES USER HAVE ACCESS TO THIS SITE? */
            {pxrun.i &PROC='validateSiteSecurity' &PROGRAM='icsixr.p'
                     &HANDLE=ph_icsixr
                     &PARAM="(input CESourceSMSite,
                              input '')"
                     &NOAPPERROR = true
                     &CATCHERROR = true
            }
            if  return-value <> {&SUCCESS-RESULT} then do:
               next-prompt CESourceSMSite with frame b.
               undo, retry.
            end.

            /* IF THIS IS A SITE, IS SITE IN THE CURRENT DATABASE? */
            {pxrun.i &PROC='validateDatabaseSite' &PROGRAM='icsixr.p'
                     &HANDLE=ph_icsixr
                     &PARAM="(input CESourceSMSite)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
            }
            if  return-value <> {&SUCCESS-RESULT} then do:
               next-prompt CESourceSMSite with frame b.
               undo, retry.
            end.
            else do:
               /* RETRIEVE SITE DESCRIPTION */
               for first si_mstr
               fields (si_site si_desc)
               where si_site = CESourceSMSite no-lock: end.
               display si_desc @ CESourceSMSiteDesc with frame b.
            end.
         end.

         /* VALIDATE SUPER MARKET */
         if CESourceSM <> "" then do:

            for first knbsm_mstr
            where knbsm_supermarket_id = CESourceSM
            no-lock: end.
            if not available (knbsm_mstr)
            then do:
               {pxmsg.i &MSGNUM=5951
                        &ERRORLEVEL={&APP-ERROR-RESULT}}
               /* Super Market does not exist */
               next-prompt CESourceSM with frame b.
               undo, retry.
            end.

            display knbsm_desc @ CESourceSMDesc with frame b.
         end.   /* CESourceSM <> ""  */

         /* VALIDATE THE Card Type*/
         if CECardTypeMnemonic <> "" then do:
            {pxrun.i &PROC  = 'validateCardType' &PROGRAM = 'kbtranxr.p'
                     &PARAM = "(input  CECardTypeMnemonic)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
            }
            if  return-value <> {&SUCCESS-RESULT} then do:
               next-prompt CECardTypeMnemonic with frame b.
               undo, retry.
            end.
            {pxrun.i &PROC  = 'getCardTypeValue' &PROGRAM = 'kbtranxr.p'
                     &PARAM = "(input  CECardTypeMnemonic,
                                output CECardType,
                                output cardTypeDesc)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
            }

            display cardTypeDesc with frame b.
         end. /* CECardTypeMnemonic <> "" */
      end. /* controlled-entry: */
   end. /* do on error undo, return {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.

END PROCEDURE. /* promptForControlledEntry */


/*============================================================================*/
PROCEDURE promptForPONumberPOLine:
/*---------------------------------------------------------------------------
   Purpose:     Prompts for, and validate, PO number and PO line.
   Exceptions:  NONE
   Notes:
   History:
---------------------------------------------------------------------------*/

   define input        parameter pSupplierID as character.
   define input        parameter pSite       as character.
   define input        parameter pPart       as character.
   define input        parameter pQty        as decimal.
   define input-output parameter pPONumber   as character
                       format "x(8)" label "PO Number" no-undo.
   define input-output parameter pPOLine     as character
                       format "x(3)" label "Line" no-undo.

   define variable oldPONumber               as character no-undo.

   /* PO ENTRY POP-UP FRAME */
   form
      space(2)
      pPONumber colon 22
      pPOLine   colon 52
      space(2)
   /*V8-*/
   with frame f row 4 centered overlay side-labels.
   /* SET EXTERNAL LABELS */
   /*V8+*/
   /*V8!
   with frame f centered overlay side-labels.
   frame f:row = 4.
   FRAME f:HEIGHT-PIXELS = FRAME f:HEIGHT-PIXELS + 4. */
   setFrameLabels(frame f:handle).

   do on error undo, return {&GENERAL-APP-EXCEPT}:

      /* SEE IF PO NUMBER POP-UP FRAME IS NEEDED                  */


      /* IF PO FOUND IN KANBAN, SEE IF IT IS A BLANKET PO, AND IF SO */
      /* DETERMINE OLDEST OPEN PO RELEASE TO USE           */
      if pPONumber <> "" then do:
         for first po_mstr
         fields(po_nbr
                po_type)
         where po_nbr = pPONumber
         no-lock:
            if po_type = "B" then do:
            
/*Cai*             {pxrun.i &PROC  = 'findOpenBlanketPO' */
/*Cai*                        &PROGRAM = 'kbtranxr.p' */
/*Cai*                        &PARAM = "(input  pPONumber, */
/*Cai*                                   input  pSupplierID, */
/*Cai*                                   input  pSite, */
/*Cai*                                   input  pPart, */
/*Cai*                                   input  pQty, */
/*Cai*                                   output blanketPO)" */
/*Cai*                     &NOAPPERROR = true */
/*Cai*                     &CATCHERROR = true */
/*Cai*               } */

/*xw0621* /*Cai*/ find knbd_det where knbd_id = kanbanID . */
/*xw0621* /*Cai*/ blanketPO = knbd_user1 . */
/*xw0621*/ /*Cai*/ find first knbd_det where knbd_id = kanbanID /*no-lock* no-error*/ . 
/*xw0621*/         IF available knbd_det THEN blanketPO = knbd_user1.
/*xw0621*/				 ELSE DO: 
/*xw0621*/					Message "错误: 找不到对应的看板资料:" + string(kanbanID).
/*xw0621*/					blanketPO = "".
/*xw0621*/				 END.
               /* IF NO QUALIFYING PO RELEASE IS FOUND THIS WILL RETURN */
               /* BLANKS AS OUTPUT PARAMETER  */
               if blanketPO = "" then do:
                  /* ISSUE WARNING AND ALLOW USER TO ENTER ANOTHER PO BY */
                  /* BLANKING pPONumber          */

                  /* NO QUALIFYING PO RELEASE FOUND FOR BLANKET PO # */
                  {pxmsg.i &MSGNUM    = 5244
                           &ERRORLEVEL={&WARNING-RESULT}
                           &MSGARG1   = po_nbr
                  }
               end.
               pPONumber = blanketPO.
            end.  /* po_type = "B" */
         end.
      end.  /* pPONumber <> "" */

/*Cai*/ find knbl_det where knbl_keyid = knbd_knbl_keyid no-lock.
/*Cai*/ find knb_mstr where knb_keyid = knbl_knb_keyid no-lock.
/*Cai*/ find knbi_mstr where knbi_keyid = knb_knbi_keyid no-lock.
/*Cai*/ find first pod_det where pod_nbr = pPONumber and pod_part = knbi_part no-error .
/*Cai*/ if available pod_det then do:
/*xw0625*/		pPOLine = string(pod_line) .
/*xw0625*/	IF pod_status = "C" or pod_status = "X" THEN
/*xw0625*/	DO:
/*xw0625*/		message "错误: 该项已被关闭!" .			
/*xw0625*/	END.
	end.
	
      /* OLD PO NUMBER IS USED TO CONTROL WHETHER THE POP-UP */
      /* SHOULD ALLOW ENTRY IN THE PO NUMBER FIELD.          */
      oldPONumber = pPONumber.

      /* PROMPT USER FOR WHEN PO OR LINE IS BLANK */
      if pPONumber = "" or pPOLine = ""
      then do:

         /* THIS IS TO PREVENT "PRESS SPACE BAR" MESSAGE */
         pause 0.

         if oldPONumber <> "" then
         display
            pPONumber
         with frame f.

         PONumber-entry:
         do on error undo, retry with frame f:

            update
               pPONumber when (oldPONumber = "")
               pPOLine
               go-on("F4" "CTRL-E").

            /* RETURN IF ENDKEY CONDITION IS REACHED */
            if lastkey = keycode("F4") or lastkey = keycode("CTRL-D") then do:
               hide frame f no-pause.
               return {&GENERAL-APP-EXCEPT}.
            end.  /* if lastkey = keycode("F4") or keycode("CTRL-D") */

            /* CHECK FOR BLANKS */
            if pPONumber = "" then do:
               /* BLANK NOT ALLOWED */
               {pxmsg.i &MSGNUM     = 40
                        &ERRORLEVEL = {&APP-ERROR-RESULT}}
               next-prompt pPONumber with frame f.
               undo, retry.
            end.

            {pxrun.i &PROC  = 'validatePurchaseOrder' &PROGRAM = 'kbtranxr.p'
                     &PARAM = "(input  pPONumber,
                                input  pSupplierID,
                                input  pPart,
                                input  pSite,
                                output errorMessage,
                                output errorSeverity)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
            }
            if errorMessage <> 0 then do:
               {pxmsg.i &MSGNUM=errorMessage
                        &ERRORLEVEL={&APP-ERROR-RESULT}}
               next-prompt pPONumber with frame f.
               undo, retry.
            end.

            if pPOLine = "" then do:
               /* BLANK NOT ALLOWED */
               {pxmsg.i &MSGNUM     = 40
                        &ERRORLEVEL = {&APP-ERROR-RESULT}}
               next-prompt pPOLine with frame f.
               undo, retry.
            end.

            {pxrun.i &PROC  = 'validatePurchaseOrderLine'
                     &PROGRAM = 'kbtranxr.p'
                     &PARAM = "(input  pPONumber,
                                input  integer(pPOLine),
                                input  pPart,
                                input  pSite,
                                output errorMessage,
                                output errorSeverity)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
            }
            if errorMessage <> 0 then do:
               {pxmsg.i &MSGNUM=errorMessage
                        &ERRORLEVEL={&APP-ERROR-RESULT}}
               next-prompt pPOLine with frame f.
               undo, retry.
            end.

         end.  /* pPONumber-entry */

         hide frame f no-pause.

      end.  /* pPONumber = "" */

   end. /* do on error undo, return {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE. /* promptForPONumberPOLine */


/*============================================================================*/
PROCEDURE validateControlledEntry:
/*---------------------------------------------------------------------------
   Purpose:     Validate the card entered against the criteria entered in
                Controlled entry.
   Exceptions:  NONE
   Notes:
   History:
---------------------------------------------------------------------------*/
define parameter buffer knbd_det for knbd_det.
define input parameter ip-CE-severity as integer no-undo.
define output parameter op-errorSeverity as integer no-undo.

define buffer knbl_det for knbl_det.
define buffer knb_mstr for knb_mstr.
define buffer knbsm_mstr for knbsm_mstr.
define buffer knbi_mstr for knbi_mstr.
define buffer si_mstr for si_mstr.
define buffer knp_mstr for knp_mstr.

   do for knbl_det, knb_mstr, knbsm_mstr, knbi_mstr, si_mstr, knp_mstr
      on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* SEE IF CONTROLLED ENTRY IS IN EFFECT, AND IF SO VALIDATE KANBAN */
      if ip-CE-severity <> 0 then do:

         assign
            ip-CE-severity = ip-CE-severity + 1
            op-errorSeverity = 0.

         /* RETRIEVE LOOP DETAIL RECORD */
         for first knbl_det
         where knbl_keyid       = knbd_knbl_keyid
         no-lock:  end.

         /* RETRIEVE KANBAN MASTER RECORD FOR DEFAULT PO NUMBER */
         for first knb_mstr
         where knb_keyId       = knbl_knb_keyId
         no-lock: end.

         /* RETRIEVE KANBAN SuperMarket MASTER RECORD */
         for first knbsm_mstr
         where knbsm_keyId       = knb_knbsm_keyId
         no-lock: end.

         /* RETRIEVE Site MASTER RECORD */
         for first si_mstr
         where si_site           = knbsm_site
         no-lock: end.

         /* RETRIEVE KANBAN Item MASTER RECORD */
         for first knbi_mstr
         where knbi_keyId       = knb_knbi_keyId
         no-lock: end.

         /* RETRIEVE KANBAN PROCESS MASTER RECORD */
         if knbd_source_type = {&KB-SOURCETYPE-PROCESS} then
         for first knp_mstr
         where knp_mstr.knp_site       = knbd_ref1 and
               knp_mstr.knp_process_id = knbd_ref2
         no-lock: end.

         /* CHECK FOR CONTROLLED ENTRY PART MATCH */
         if CEPart <> "" then do:
            if CEPart <> knbi_part then do:
               /*  CONTROLLED ENTRY VIOLATION FOR FIELD # */
               {pxmsg.i &MSGNUM=5066
                        &ERRORLEVEL=ip-CE-severity
                        &MSGARG1=getTermLabel(""ITEM_NUMBER"",30)
               }
               assign op-errorSeverity = ip-CE-severity.
               return.
            end. /* CEPart <> knbi_part  */
         end.  /* CEPart <> "" */

         /* CHECK FOR CONTROLLED ENTRY SITE MATCH */
         if CESite <> "" then do:
            if CESite <> knbsm_site then do:
               /*  CONTROLLED ENTRY VIOLATION FOR FIELD # */
               {pxmsg.i &MSGNUM=5066
                        &ERRORLEVEL=ip-CE-severity
                        &MSGARG1=getTermLabel(""SITE"",30)
               }
               assign op-errorSeverity = ip-CE-severity.
               return.
            end. /* CESuppSource <> knbd_supp_source  */
         end.  /* CESuppSource <> "" */

         /* CHECK FOR CONTROLLED ENTRY SUPERMARKET MATCH */
         if CESuperMarket <> "" then do:
            if CESuperMarket <> knbsm_supermarket_id then do:
               /*  CONTROLLED ENTRY VIOLATION FOR FIELD # */
               {pxmsg.i &MSGNUM=5066
                        &ERRORLEVEL=ip-CE-severity
                        &MSGARG1=getTermLabel(""Supermarket"",30)
               }
               assign op-errorSeverity = ip-CE-severity.
               return.
            end. /* CESuppRef <> knbd_supp_ref  */
         end.  /* CESuppRef <> "" */

         /* CHECK FOR CONTROLLED ENTRY PROCESS MATCH */
         if CEProcess <> "" then do:
            if knbd_source_type <> {&KB-SOURCETYPE-PROCESS} or
              (knbd_source_type = {&KB-SOURCETYPE-PROCESS} and
                      CEProcess <> knbd_ref2)  then do:
               /*  CONTROLLED ENTRY VIOLATION FOR FIELD # */
               {pxmsg.i &MSGNUM=5066
                        &ERRORLEVEL=ip-CE-severity
                        &MSGARG1=getTermLabel(""PROCESS_ID"",30)
               }
               assign op-errorSeverity = ip-CE-severity.
               return.
            end. /* CEConsSource <> knbd_cons_source  */
         end.  /* CEConsSource <> "" */

         /* CHECK FOR CONTROLLED ENTRY SUPPLIER MATCH */
         if CESupplier <> "" then do:
            if CESupplier <> knbd_ref1 then do:
               /*  CONTROLLED ENTRY VIOLATION FOR FIELD # */
               {pxmsg.i &MSGNUM=5066
                        &ERRORLEVEL=ip-CE-severity
                        &MSGARG1=getTermLabel(""SUPPLIER"",30)
               }
               assign op-errorSeverity = ip-CE-severity.
               return.
            end. /* CESupplier <> knbd_ref1  */
         end.  /* CESupplier <> "" */

         /* CHECK FOR CONTROLLED ENTRY PO MATCH */
         if CEPurchaseOrder <> "" then do:
            if CEPurchaseOrder <> knbd_ref2 then do:
               /*  CONTROLLED ENTRY VIOLATION FOR FIELD # */
               {pxmsg.i &MSGNUM=5066
                        &ERRORLEVEL=ip-CE-severity
                        &MSGARG1=getTermLabel(""PO_NUMBER"",30)
               }
               assign op-errorSeverity = ip-CE-severity.
               return.
            end. /* CEPurchaseOrder <> knbd_ref2  */
         end.  /* CEPurchaseOrder <> "" */

         /* CHECK FOR CONTROLLED ENTRY SOURCE-SITE MATCH */
         if CESourceSMSite <> "" then do:
            if CESourceSMSite <> knbd_ref1 then do:
               /*  CONTROLLED ENTRY VIOLATION FOR FIELD # */
               {pxmsg.i &MSGNUM=5066
                        &ERRORLEVEL=ip-CE-severity
                        &MSGARG1=getTermLabel(""TRANSFER_FROM_SITE"",30)
               }
               assign op-errorSeverity = ip-CE-severity.
               return.
            end. /* CESourceSM <> knbd_ref1  */
         end.  /* CESourceSM <> "" */

         /* CHECK FOR CONTROLLED ENTRY SOURCE-SUPERMARKET MATCH */
         if CESourceSM <> "" then do:
            if CESourceSM <> knbd_ref2 then do:
               /*  CONTROLLED ENTRY VIOLATION FOR FIELD # */
               {pxmsg.i &MSGNUM=5066
                        &ERRORLEVEL=ip-CE-severity
                        &MSGARG1=getTermLabel(""FROM_SUPERMARKET"",30)
               }
               assign op-errorSeverity = ip-CE-severity.
               return.
            end. /* CESourceSM <> knbd_ref2  */
         end.  /* CESourceSM <> "" */

         /* CHECK FOR CONTROLLED ENTRY CARD TYPE MATCH */
         if CECardType <> "" then do:
            if CECardType <> knbl_card_type then do:
               /*  CONTROLLED ENTRY VIOLATION FOR FIELD # */
               {pxmsg.i &MSGNUM=5066
                        &ERRORLEVEL=ip-CE-severity
                        &MSGARG1=getTermLabel(""CARD_TYPE"",30)
               }
               assign op-errorSeverity = ip-CE-severity.
               return.
            end. /* CECardType <> knbd_card_type   */
         end.  /* CECardType <> "" */

      end. /* ip-CE-severity <> "0" */

   end. /* do on error undo, return {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.

END PROCEDURE. /* validateControlledEntry */
