/* popomtra.p - PURCHASE ORDER MAINTENANCE SUBROUTINE -CHECK OUT OF TOLERANCE */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.20 $                                                          */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/*                                                                            */
/* This is a subprogram to handle the checking of an Out Of Tolerance         */
/* when GRS Requisitions are being used.                                      */
/*                                                                            */
/* REVISION: 8.5     LAST MODIFIED: 02/11/97      BY: *J1Q2* B. Gates         */
/* REVISION: 8.5     LAST MODIFIED: 10/27/97      BY: *J243* Patrick Rowan    */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98      BY: *L007* A. Rahane        */
/* REVISION: 8.6E    LAST MODIFIED: 05/09/98      BY: *L00Y* Jeff Wootton     */
/* REVISION: 8.6E    LAST MODIFIED: 07/22/98      BY: *L040* Charles Yen      */
/* REVISION: 8.6E    LAST MODIFIED: 02/24/99      BY: *L0DL* Patrick Rowan    */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00      BY: *N08T* Annasaheb Rahane */
/* Revision: 1.11 BY: Bill Pedersen               DATE: 04/25/00  ECO: *N059* */
/* REVISION: 9.1     LAST MODIFIED: 08/17/00      BY: *N0LJ* Mark Brown       */
/* Revision: 1.13   BY: Julie Milligan            DATE: 08/23/00  ECO: *N0N2* */
/* Revision: 1.14   BY: Stefan Sepanaho           DATE: 08/28/00  ECO: *N0P8* */
/* Revision: 1.15   BY: Pat Pigatti               DATE: 08/31/00  ECO: *N0QR* */
/* Revision: 1.16   BY: Zheng Huang               DATE: 10/16/00  ECO: *N0S0* */
/* $Revision: 1.20 $ BY: Laurene Sheridan     DATE: 10/17/02  ECO: *N13P* */
/*! SUBPROGRAM TO DO TOLERANCE CHECKING FOR POS REFERENCING REQS
    when GRS REQUISITIONING is BEING USED */
/* ************************************************************************** */
/* Note: This code has been modified to run when called inside an MFG/PRO API */
/* method as well as from the MFG/PRO menu, using the global variable         */
/* c-application-mode to conditionally execute API- vs. UI-specific logic.    */
/* Before modifying the code, please review the MFG/PRO API Development Guide */
/* in the QAD Development Standards for specific API coding standards and     */
/* guidelines.                                                                */
/* ************************************************************************** */

/*============================================================================*/
/* ****************************  Definitions  ******************************* */
/*============================================================================*/
{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}
{rqconst.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE popomtra_p_1 "Reroute Requisition"
/* MaxLen: Comment: */

&SCOPED-DEFINE popomtra_p_2 "Req Max Unit Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE popomtra_p_3 "Mark Requisition Line Out Of Tolerance"
/* MaxLen: Comment: */

&SCOPED-DEFINE popomtra_p_4 "PO Net Unit Cost"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* PARAMETERS */
define input parameter p_first_call as logical no-undo.
define input parameter p_pod_site like pod_site no-undo.
define input parameter p_pod_req_nbr like pod_req_nbr no-undo.
define input parameter p_pod_req_line like pod_req_line no-undo.
define input parameter p_pod_pur_cost like pod_pur_cost no-undo.
define input parameter p_po_ex_rate like po_ex_rate no-undo.
define input parameter p_po_ex_rate2 like po_ex_rate2 no-undo.
define input parameter p_po_curr like po_curr no-undo.
define input parameter p_po_fix_rate like po_fix_rate no-undo.
define input parameter p_po_vend like po_vend no-undo.
define input parameter p_pod_disc_pct like pod_disc_pct no-undo.
define input parameter p_pod_qty_ord like pod_qty_ord no-undo.
define input parameter p_pod_um like pod_um no-undo.
define input parameter p_pod_um_conv like pod_um_conv no-undo.
define input parameter p_pod_part like pod_part no-undo.
define input parameter p_new_pod as logical no-undo.
define output parameter p_oot_ponetcst as decimal no-undo.
define output parameter p_oot_poum as character no-undo.
define output parameter p_oot_rqnetcst as decimal no-undo.
define output parameter p_oot_rqum as character no-undo.
define output parameter p_return_status as character no-undo.

/* LOCAL VARIABLES */
define variable yn like mfc_logical no-undo.
define variable exchg_rate as decimal no-undo.
define variable exchg_rate2 as decimal no-undo.
define variable exchg_ratetype like exr_ratetype no-undo.
define variable exch-error-number like msg_nbr no-undo.
define variable mc-error-number   like msg_nbr no-undo.
define variable base_to_basecurr_exchg_rate as decimal no-undo.
define variable email_sent_to as character no-undo.
define variable siteDB as character no-undo.
define variable dummyChar as character no-undo.
define variable dummyDecimal as decimal no-undo.
define variable podnetpurcost like rqd_max_cost no-undo.
define variable podnetunitcost like rqd_max_cost no-undo
   label {&popomtra_p_4}
   format "zzz,zzz,zz9.99999".
define variable podbasenetpurcost like rqd_max_cost
   no-undo
   format "zzz,zzz,zz9.99999".
define variable rqdmaxcost like rqd_max_cost no-undo
   label {&popomtra_p_2}
   format "zzz,zzz,zz9.99999".
define variable rqdbasemaxcost like rqd_max_cost
   no-undo
   format "zzz,zzz,zz9.99999".
define variable basecurr1 like rqm_curr no-undo.
define variable basecurr2 like rqm_curr no-undo.
define variable old_db as character no-undo.
define variable err-flag as integer no-undo.
define variable mark_oot like mfc_logical
   label {&popomtra_p_3} no-undo.
define variable route_req like mfc_logical
   label {&popomtra_p_1} no-undo.
define variable pod_stk_um like pt_um no-undo.
define variable rqd_stk_um like pt_um no-undo.

define shared variable sngl_ln like poc_ln_fmt.
define shared variable clines as integer initial ?.
define shared variable line   like sod_line.
define shared variable podcmmts like mfc_logical.
define shared variable desc1 like pt_desc1.
define shared variable desc2 like pt_desc2.
define shared variable ext_cost like pod_pur_cost.
define shared variable mfgr_part like vp_mfgr_part.
define shared variable st_qty like pod_qty_ord.
define shared variable st_um like pod_um.
define shared variable mfgr like vp_mfgr.
define shared frame c.
define shared frame d.

define buffer rqd_det for rqd_det.
define buffer rqm_mstr for rqm_mstr.


/* FORM(S) */
/* Defines forms c & d */
/*tfq {mfpomtb.i} */
/*tfq*/ {yymfpomtb.i}

form
   p_pod_req_nbr         colon 28
   p_pod_req_line
   skip(1)
   podnetunitcost        colon 20
   p_po_curr             no-labels
   p_pod_um              no-labels
   podbasenetpurcost     no-labels
   basecurr1             no-labels
   pod_stk_um            no-labels
   rqd_det.rqd_max_cost  colon 20 format "zzz,zzz,zz9.99999"
   label {&popomtra_p_2}
   rqm_mstr.rqm_curr     no-labels
   rqd_det.rqd_um        no-labels
   rqdbasemaxcost        no-labels
   basecurr2             no-labels
   rqd_stk_um            no-labels
   skip(1)
   mark_oot              colon 45
   route_req             colon 45
with frame cac side-labels
   overlay row 10 width 80 no-attr-space.


/*============================================================================*/
/* ****************************  Main Block  ******************************** */
/*============================================================================*/

/* SET EXTERNAL LABELS */
setFrameLabels(frame cac:handle).

if p_first_call
then do:
   /* FIRST TIME IN, WE SWITCH DB'S IF WE HAVE TO THEN */
   /* CALL OURSELVES AGAIN, WHICH WILL EXECUTE THE ELSE BLOCK */

   {pxrun.i &PROC='getSiteDataBase' &PROGRAM='icsixr.p'
            &PARAM="(input p_pod_site,
                     output siteDB)"
            &NOAPPERROR=True
            &CATCHERROR=True}

   if siteDB <> global_db
   then do:
      old_db = global_db.
      {gprun.i ""gpalias3.p"" "(input siteDB, output err-flag)"}
   end.

   /* ADDED SECOND EXCHANGE RATE BELOW */
   /*tfq {gprun.i ""popomtra.p""
      "(input no,
        input p_pod_site,
        input p_pod_req_nbr,
        input p_pod_req_line,
        input p_pod_pur_cost,
        input p_po_ex_rate,
        input p_po_ex_rate2,
        input p_po_curr,
        input p_po_fix_rate,
        input p_po_vend,
        input p_pod_disc_pct,
        input p_pod_qty_ord,
        input p_pod_um,
        input p_pod_um_conv,
        input p_pod_part,
        input p_new_pod,
        output p_oot_ponetcst,
        output p_oot_poum,
        output p_oot_rqnetcst,
        output p_oot_rqum,
        output p_return_status)"} */

 /*tfq*/   {gprun.i ""yypopomtra.p""
      "(input no,
        input p_pod_site,
        input p_pod_req_nbr,
        input p_pod_req_line,
        input p_pod_pur_cost,
        input p_po_ex_rate,
        input p_po_ex_rate2,
        input p_po_curr,
        input p_po_fix_rate,
        input p_po_vend,
        input p_pod_disc_pct,
        input p_pod_qty_ord,
        input p_pod_um,
        input p_pod_um_conv,
        input p_pod_part,
        input p_new_pod,
        output p_oot_ponetcst,
        output p_oot_poum,
        output p_oot_rqnetcst,
        output p_oot_rqum,
        output p_return_status)"}

   if old_db <> global_db
   then do:
      {gprun.i ""gpalias3.p"" "(input old_db, output err-flag)"}
   end.
end.
else do:
   p_return_status = "ok_to_proceed".
   if p_pod_req_nbr = "" then leave.

   /*CHECK IF TOLERANCE CHECKING IS ENABLED*/
   if not {pxfunct.i &FUNCTION='isToleranceCheckingActive' &PROGRAM='rqgrsxr.p'}
   then leave.

   {pxrun.i &PROC='processRead' &PROGRAM='rqgrsxr1.p'
            &PARAM="(input p_pod_req_nbr,
                     input p_pod_req_line,
                     buffer rqd_det,
                     input {&LOCK_FLAG},
                     input {&WAIT_FLAG})"
            &NOAPPERROR=True
            &CATCHERROR=True}
   if return-value <> {&SUCCESS-RESULT}
   then do:
      p_return_status = "ok_to_proceed".
      leave.
   end.

   {pxrun.i &PROC='processRead' &PROGRAM='rqgrsxr.p'
            &PARAM="(input p_pod_req_nbr,
                     buffer rqm_mstr,
                     input {&LOCK_FLAG},
                     input {&WAIT_FLAG})"
            &NOAPPERROR=True
            &CATCHERROR=True}

   /* OBTAIN PURCHASE COSTS FOR DISPLAY & TOLERANCE CHECKING */
   assign
      basecurr1 = base_curr
      basecurr2 = base_curr
      podnetunitcost = p_pod_pur_cost * (1 - p_pod_disc_pct / 100)
      podnetpurcost = p_pod_pur_cost / p_pod_um_conv.

   /* CONVERT PO COST TO BASE CURRENCY AND STOCK UM */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input p_po_curr,
        input base_curr,
        input p_po_ex_rate,
        input p_po_ex_rate2,
        input podnetpurcost,
        input false, /* DO NOT ROUND */
        output podbasenetpurcost,
        output exch-error-number)"}

   /*CHECK TOLERANCE*/
   {pxrun.i &PROC='checkTolerance' &PROGRAM='rqgrsxr1.p'
            &PARAM="(input p_pod_req_nbr,
                          input p_pod_req_line,
                          input podbasenetpurcost,
                          input p_new_pod,
                          input true)"
            &NOAPPERROR=True &CATCHERROR=True}

   if return-value <> {&SUCCESS-RESULT}
   then do:
      if p_new_pod
      then do:

         assign
            mark_oot = false
            route_req = false.

         hide frame d.


         /*GET PO STOCK UM*/
         pod_stk_um = "".
         {pxrun.i &PROC='getBasicItemData' &PROGRAM='ppitxr.p'
                  &PARAM="(input p_pod_part,
                           output dummyChar,
                           output dummyChar,
                           output dummyDecimal,
                           output dummyChar,
                           output dummyChar,
                           output pod_stk_um,
                           output dummyChar)"
                  &NOAPPERROR=True
                  &CATCHERROR=True}



         /*GET REQ STOCK UM*/
         rqd_stk_um = "".
         {pxrun.i &PROC='getBasicItemData' &PROGRAM='ppitxr.p'
                  &PARAM="(input rqd_part,
                           output dummyChar,
                           output dummyChar,
                           output dummyDecimal,
                           output dummyChar,
                           output dummyChar,
                           output rqd_stk_um,
                           output dummyChar)"
                  &NOAPPERROR=True
                  &CATCHERROR=True}

         /* Get Max Purchase cost */
         {pxrun.i &PROC='getRequisitionMaxPurchaseCost' &PROGRAM='rqgrsxr1.p'
                  &PARAM="(input p_pod_req_nbr,
                           input p_pod_req_line,
                           output rqdmaxcost,
                           output rqdbasemaxcost)"
                  &NOAPPERROR=True
                  &CATCHERROR=True}

         if c-application-mode <> "API" then
            display
               p_pod_req_nbr
               p_pod_req_line
               podnetunitcost
               p_po_curr
               p_pod_um
               podbasenetpurcost
               basecurr1
               pod_stk_um
               rqd_max_cost
               rqm_curr
               rqd_um
               rqdbasemaxcost
               basecurr2
               rqd_stk_um
               mark_oot
               route_req
            with frame cac.

         p_return_status = "undoretry_unitcostprompt".

         do on endkey undo, leave on error undo, retry:
            /* DO NOT RETRY WHEN PROCESSING API REQUEST */
            if retry and c-application-mode = "API" then
               undo, return error.

            if c-application-mode <> "API" then
               set mark_oot with frame cac.

            if mark_oot
            then do:
               if rqm_mstr.rqm_rtto_userid = global_userid
               then
                  if c-application-mode <> "API" then
                     set route_req with frame cac.

               assign
                  p_return_status = "undo_pod_line_mark_req_oot"
                  p_oot_ponetcst  = podbasenetpurcost
                  p_oot_poum      = pod_stk_um
                  p_oot_rqnetcst  = rqdbasemaxcost
                  p_oot_rqum      = rqd_stk_um.

               if route_req
               then do:
                  p_return_status = p_return_status + ",reroute".
               end.
            end.
         end.
         if c-application-mode <> "API"
         then do:
            hide frame cac no-pause.
            if not mark_oot then view frame d.
         end.
      end.  /* if p_new_pod */
      else
         p_return_status = "undoretry_unitcostprompt".
   end.  /*    if return-value <> {&SUCCESS-RESULT} */
   else do:
      /* REFERENCING A REQ, RESET OOT STATUS IF TURNED ON */

      if rqd_aprv_stat = APPROVAL_STATUS_OOT
      then do:
         /* SEND EMAILS */
         {gprun.i ""rqemsend.p""
         "(input recid(rqm_mstr),
         input ACTION_RESET_OOT,
         output email_sent_to)"}

         /* WRITE HISTORY RECORD */
         {gprun.i ""rqwrthst.p""
         "(input rqm_nbr,
         input rqd_line,
         input ACTION_RESET_OOT,
         input global_userid,
         input '',
         input email_sent_to)"}

         rqd_aprv_stat = APPROVAL_STATUS_APPROVED.
      end.
   end.
end.

