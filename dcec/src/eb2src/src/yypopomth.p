/* popomth.p - PURCHASE ORDER MAINTENANCE SUBROUTINE                          */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.21.1.20.1.2 $                                                 */
/*                                                                            */
/* This program allows updating line order quantity and unit of measure, it   */
/* also does validations related to quantity ordered and does PO Line delete  */
/* operation.                                                                 */
/*                                                                            */
/* REVISION: 6.0     LAST MODIFIED: 11/11/91    BY: RAM *D921*                */
/* REVISION: 6.0     LAST MODIFIED: 11/15/91    BY: RAM *D952*                */
/* REVISION: 7.2     LAST MODIFIED: 11/19/92    BY: WUG *G340*                */
/* REVISION: 7.3     LAST MODIFIED: 04/29/93    BY: afs *G972*                */
/* REVISION: 7.3     LAST MODIFIED: 07/30/93    BY: cdt *H047*                */
/* REVISION: 7.4     LAST MODIFIED: 09/29/93    BY: cdt *H086*                */
/* REVISION: 7.4     LAST MODIFIED: 11/19/93    BY: pxd *H225*                */
/* REVISION: 7.4     LAST MODIFIED: 02/10/94    BY: dpm *FL69*                */
/* REVISION: 7.3     LAST MODIFIED: 04/20/94    BY: WUG *FN48*                */
/* REVISION: 7.4     LAST MODIFIED: 04/21/94    BY: dpm *FN53*                */
/* Oracle changes (share-locks)    09/12/94     BY: rwl *GM41*                */
/* REVISION: 7.4     LAST MODIFIED: 01/28/95    BY: ljm *G0D7*                */
/* REVISION: 7.4     LAST MODIFIED: 09/19/95    BY: ais *G0X6*                */
/* REVISION: 7.4     LAST MODIFIED: 11/07/95    BY: dxk *G0XK*                */
/* REVISION: 7.4     LAST MODIFIED: 12/12/95    BY: ais *G1G4*                */
/* REVISION: 7.4     LAST MODIFIED: 01/02/96    BY: ais *G1HW*                */
/* REVISION: 7.4     LAST MODIFIED: 01/15/96    BY: ais *G1JY*                */
/* REVISION: 7.4     LAST MODIFIED: 09/04/97    BY: *G2PD* Nirav Parikh       */
/* REVISION: 8.5     LAST MODIFIED: 02/11/97    BY: *J1YW* WUG                */
/* REVISION: 8.5     LAST MODIFIED: 10/09/97    BY: *J231* Patrick Rowan      */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E    LAST MODIFIED: 06/10/98    BY: *L020* Charles Yen        */
/* *D274* PREVIOUS ECO NUMBER WAS REMOVED FROM THE PROGRAM Charles Yen        */
/* *F003* PREVIOUS ECO NUMBER WAS REMOVED FROM THE PROGRAM Charles Yen        */
/* *F033* PREVIOUS ECO NUMBER WAS REMOVED FROM THE PROGRAM Charles Yen        */
/* REVISION: 8.5     LAST MODIFIED: 07/31/98    BY: *J2VH* Patrick Rowan      */
/* REVISION: 8.6E    LAST MODIFIED: 09/18/98    BY: *J307* Irine D'mello      */
/* REVISION: 8.6E    LAST MODIFIED: 09/14/99    BY: *K22R* Santosh Rao        */
/* REVISION: 8.6E    LAST MODIFIED: 10/05/99    BY: *J39R* Reetu Kapoor       */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 04/26/00    BY: *L0WT* Kedar Deherkar     */
/* REVISION:         LAST MODIFIED:             BY: *F0PN* Missing ECO        */
/* Revision: 1.21.1.9  BY: Poonam Bahl          DATE:03/09/00   ECO: *N059*   */
/* Revision: 1.21.1.10 BY: Mark Brown           DATE:09/04/00   ECO: *N0RC*   */
/* Revision: 1.21.1.11 BY: Inna Lyubarsky       DATE:08/24/00   ECO: *N0KM*   */
/* Revision: 1.21.1.12 BY: Ashish Kapadia       DATE: 11/21/01  ECO: *N16F*   */
/* Revision: 1.21.1.13 BY: Samir Bavkar         DATE: 12/12/01  ECO: *P013*   */
/* Revision: 1.21.1.14 BY: Tiziana Giustozzi    DATE: 07/24/02  ECO: *P09N*   */
/* Revision: 1.21.1.15 BY: Rajaneesh S.         DATE: 08/29/02  ECO: *M1BY*   */
/* Revision: 1.21.1.17 BY: Laurene Sheridan     DATE: 10/17/02  ECO: *N13P*   */
/* Revision: 1.21.1.18 BY: Jyoti Thatte         DATE: 11/25/02  ECO: *P0K1*   */
/* Revision: 1.21.1.19 BY: Shilpa Athalye       DATE: 05/22/03  ECO: *P0SJ*   */
/* Revision: 1.21.1.20 BY: Shilpa Athalye       DATE: 05/28/03  ECO: *N2G4*   */
/* Revision: 1.21.1.20.1.1 BY: Gnanasekar       DATE: 07/22/03  ECO: *P0XW*   */
/* $Revision: 1.21.1.20.1.2 $ BY: Deepak Rao       DATE: 08/05/03  ECO: *P0YZ*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */
/* ************************************************************************** */
/* Note: This code has been modified to run when called inside an MFG/PRO API */
/* method as well as from the MFG/PRO menu, using the global variable         */
/* c-application-mode to conditionally execute API- vs. UI-specific logic.    */
/* Before modifying the code, please review the MFG/PRO API Development Guide */
/* in the QAD Development Standards for specific API coding standards and     */
/* guidelines.                                                                */
/* ************************************************************************** */

/*============================================================================*/
/* **************************** Definitions ********************************* */
/*============================================================================*/

/* STANDARD INCLUDE FILES */
{mfdeclre.i}
{gplabel.i}  /* EXTERNAL LABEL INCLUDE */
{pxsevcon.i}
{pxpgmmgr.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE popomth_p_1 "Comments"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* SHARED FRAMES */
define shared frame chead.
define shared frame c.
define shared frame d.

/* SHARED VARIABLES */
define shared variable desc1               like pt_desc1.
define shared variable desc2               like pt_desc2.
define shared variable line                like sod_line.
define shared variable del-yn              like mfc_logical.
define shared variable po_recno            as   recid.
define shared variable vd_recno            as   recid.
define shared variable old_qty_ord         like pod_qty_ord.
define shared variable ext_cost            like pod_pur_cost.
define shared variable pod_recno           as   recid.
define shared variable podcmmts            like mfc_logical
label {&popomth_p_1}.
define shared variable sngl_ln             like poc_ln_fmt.
define shared variable mfgr                like vp_mfgr.
define shared variable mfgr_part           like vp_mfgr_part.
define shared variable continue            like mfc_logical.
define shared variable st_qty              like pod_qty_ord.
define shared variable st_um               like pod_um.
define shared variable old_um              like pod_um.
define shared variable clines              as   integer initial ?.
define shared variable blanket             like mfc_logical.
define shared variable new_db              like si_db.
define shared variable old_db              like si_db.
define shared variable new_site            like si_site.
define shared variable old_site            like si_site.
define shared variable podnbr              like pod_nbr.
define shared variable podline             like pod_line.
define shared variable podreqnbr           like pod_req_nbr.
define shared variable base_cost           like pod_pur_cost.
define shared variable line_opened         as   logical.
define shared variable price_came_from_req as   logical   no-undo.
define shared variable old_pod_status      like pod_status.

/* REQUISITION BY SITE WORKFILE INCLUDE FILE */
{poprwkfl.i}


/* LOCAL VARIABLES */
define variable requm             as   character no-undo.
define variable open_qty          as   decimal   no-undo.
define variable ok                as   logical   no-undo.
define variable yn                like mfc_logical initial no.
define variable itemAvailable     as   logical   no-undo.
define variable supplierAvailable as   logical   no-undo.
define variable itemUM            as   character no-undo.
define variable dummyDecimal      as   decimal   no-undo.
define variable dummyCharacter    as   character no-undo.
define variable l_conf_ship     as   integer     no-undo.
define variable l_conf_shid     like abs_par_id  no-undo.
define variable l_shipper_found as   integer     no-undo.
define variable l_save_abs      like abs_par_id  no-undo.
define variable using_grs         like mfc_logical no-undo.
define variable use-log-acctg     as logical no-undo.

/* VARIABLES FOR CONSIGNMENT INVENTORY */
{pocnvars.i}

/* PROCEDURES AND FRAMES FOR CONSIGNMENT INVENTORY */
{pocnpo.i}


if c-application-mode = "API"
then do on error undo,return error:

   /* COMMON API CONSTANTS AND VARIABLES */
   {mfaimfg.i}

   /* PURCHASE ORDER API TEMP-TABLE, NAMED USING THE "Api" PREFIX */
   {popoit01.i}

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

   /* GET LOCAL PO MASTER TEMP-TABLE */
   create ttPurchaseOrderDet.
   run getPurchaseOrderDetRecord in ApiMethodHandle
      (buffer ttPurchaseOrderDet).


end.  /* If c-application-mode = "API" */

/* PURCHASE ORDER MAINTENANCE SINGLE LINE ITEMS */
{mfpomtb.i} /* Defines forms c & d */

/*V8:HiddenDownFrame=c */

using_grs = can-find(mfc_ctrl
               where mfc_field   = "grs_installed"
                 and mfc_logical = yes).

{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

/*============================================================================*/
/* ****************************** Main Block ******************************** */
/*============================================================================*/

for first po_mstr where recid(po_mstr) = po_recno:
end.
for first vd_mstr where recid(vd_mstr) = vd_recno no-lock:
end.
for first pod_det where recid(pod_det) = pod_recno:
end.

{pxrun.i &PROC       = 'getBasicItemData'
         &PROGRAM    = 'ppitxr.p'
         &PARAM      = "(input pod_part,
                         output dummyCharacter,
                         output dummyCharacter,
                         output dummyDecimal,
                         output dummyCharacter,
                         output dummyCharacter,
                         output itemUM,
                         output dummyCharacter)"
         &NOAPPERROR = true
         &CATCHERROR = true}
if return-value = {&SUCCESS-RESULT}
then
   itemAvailable = true.

{pxrun.i &PROC       = 'processRead'
         &PROGRAM    = 'ppsuxr.p'
         &PARAM      = "(input pod_part,
                         input po_vend,
                         input pod_vpart,
                         buffer vp_mstr,
                         input FALSE,
                         input FALSE)"
         &NOAPPERROR = true
         &CATCHERROR = true}
if return-value = {&SUCCESS-RESULT}
then
   supplierAvailable = true.

base_cost = 0.

if not new pod_det
   and pod_req_nbr > ''
then do:
   /* MESSAGE #1655 - REQUISITION FOR THIS LINE IS */
   {pxmsg.i
      &MSGNUM     = 1655
      &ERRORLEVEL = {&INFORMATION-RESULT}
      &MSGARG1    = "if using_grs
                     then
                        pod_req_nbr + ' ' + string(pod_req_line)
                     else
                        pod_req_nbr"}
end. /* IF NOT NEW pod_det AND ... */

setc-1:
do on error undo, retry:
   /* DO NOT RETRY WHEN PROCESSING API REQUEST */
   if retry and c-application-mode = "API" then
      undo setc-1, return error.

   if c-application-mode <> "API"
   then do:
      set
         pod_qty_ord when (not pod_sched)
         pod_um when (new pod_det and not pod_sched)
         with frame c no-validate
      editing:

         readkey.
         /* DELETE */
         if    lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
         then do:
            {pxrun.i &PROC       = 'validateForExistingReceipts'
                     &PROGRAM    = 'popoxr1.p'
                     &PARAM      = "(input pod_nbr,
                                     input pod_line)"
                     &NOAPPERROR = true
                     &CATCHERROR = true}
            if return-value <> {&SUCCESS-RESULT}
            then
               undo setc-1.

            {pxrun.i &PROC       = 'validateForExistingSchedules'
                     &PROGRAM    = 'popoxr1.p'
                     &PARAM      = "(input pod_nbr,
                                     input pod_line)"
                     &NOAPPERROR = true
                     &CATCHERROR = true}
            if return-value <> {&SUCCESS-RESULT}
            then
               undo setc-1.

            if (po_type     = "B" and
                po_rel_nbr  <> 0  and
                pod_rel_nbr <> 0)
            then do:

               {pxrun.i &PROC      = 'validateBlanketOrderReleased'
                        &PROGRAM   = 'popoxr1.p'
                        &PARAM     = "(input pod_nbr,
                                       input po_vend,
                                       input pod_part,
                                       input pod_line)"
                        &NOAPPERROR = true
                       &CATCHERROR  = true}
               if return-value <> {&SUCCESS-RESULT}
               then
                  undo setc-1.
            end. /* IF (po_type = "B" AND... */

            /* CHECK FOR EXISTENCE OF CONFIRMED/UNCONFIRMED SHIPPER */

           assign
              l_conf_ship     = 0
              l_shipper_found = 0.

           {gprun.i ""rssddelb.p"" "(input pod_det.pod_nbr,
                                     input pod_det.pod_line,
                                     input pod_det.pod_site,
                                     input-output l_shipper_found,
                                     input-output l_save_abs,
                                     input-output l_conf_ship,
                                     input-output l_conf_shid)"}

                 if l_shipper_found > 0
                 then do:
                    l_save_abs   = substring(l_save_abs,2,20).

                    /* # SHIPPERS/CONTAINERS EXISTS FOR ORDER, INCLUDING # */
                    {pxmsg.i
                        &MSGNUM = 1118
                        &ERRORLEVEL = 3
                        &MSGARG1 = l_shipper_found
                        &MSGARG2 = l_save_abs
                        &MSGARG3 = """"}

                    /* DO NOT ALLOW TO DELETE ORDER LINE, IF UNCONFIRMED */
                    /* SHIPPER EXISTS                                    */
                    undo setc-1.

                 end. /* IF L_SHIPPER_FOUND > 0 */

                 /* IF ALL THE SHIPPERS FOR THE ORDER HAVE BEEN CONFIRMED  */
                 /* DISPLAY WARNING AND ALLOW TO DELETE ORDER              */

                 else if l_conf_ship > 0
                 then do:
                    l_conf_shid = substring(l_conf_shid,2,20).
                    /* # CONFIRMED SHIPPERS EXIST FOR ORDER, INCLUDING # */
                    {pxmsg.i
                        &MSGNUM = 3314
                        &ERRORLEVEL = 2
                        &MSGARG1 = l_conf_ship
                        &MSGARG2 = l_conf_shid
                        &MSGARG3 = """"}

                    /* PAUSING FOR USER TO SEE THE MESSAGE */
                    if not batchrun
                    then
                       pause.

                 end. /* IF L_CONF_SHIP > 0 */
            del-yn = yes.
            /* Please confirm delete */
            /* MESSAGE #11 - PLEASE CONFIRM DELETE */
            {pxmsg.i
               &MSGNUM     = 11
               &ERRORLEVEL = {&INFORMATION-RESULT}
               &CONFIRM    = del-yn}
            if del-yn
            then
               leave.
         end. /* IF lastkey = keycode("F5") or lastkey = keycode("CTRL-D") */
         else apply lastkey.
      end. /* END EDITING PORTION OF FRAME C */
   end. /* c-application-mode <> "API" */
   else /* Delete block c-application-mode = "API" */
   do:
      assign
         {mfaiset.i pod_det.pod_qty_ord ttPurchaseOrderDet.qtyOrd}
         {mfaiset.i pod_det.pod_um ttPurchaseOrderDet.um} when (new pod_det).


      if ttPurchaseOrderDet.operation = {&REMOVE}
      then do:
         {pxrun.i &PROC='validateForExistingReceipts'
                  &PROGRAM='popoxr1.p'
                  &PARAM="(input pod_nbr,
                           input pod_line)"
                  &NOAPPERROR=True &CATCHERROR=True}
         if return-value <> {&SUCCESS-RESULT} then
            undo setc-1,return error.

         {pxrun.i &PROC='validateForExistingSchedules'
                  &PROGRAM='popoxr1.p'
                  &PARAM="(input pod_nbr,
                           input pod_line)"
                  &NOAPPERROR=True &CATCHERROR=True}
         if return-value <> {&SUCCESS-RESULT} then
            undo setc-1,return error.

         if (po_type = "B" and po_rel_nbr <> 0 and pod_rel_nbr <> 0)
         then do:

            {pxrun.i &PROC='validateBlanketOrderReleased' &PROGRAM='popoxr1.p'
                     &PARAM="(input pod_nbr,
                              input po_vend,
                              input pod_part,
                              input pod_line)"
                     &NOAPPERROR=True &CATCHERROR=True}
            if return-value <> {&SUCCESS-RESULT} then
               undo setc-1,return error.
         end. /* IF (PO_TYPE = "B" AND PO_REL_NBR <> 0 AND POD_REL_NBR <> 0) */

         /* CHECK FOR EXISTENCE OF CONFIRMED/UNCONFIRMED SHIPPER */

         assign
            l_conf_ship     = 0
            l_shipper_found = 0.

         {gprun.i ""rssddelb.p"" "(input pod_det.pod_nbr,
                                   input pod_det.pod_line,
                                   input pod_det.pod_site,
                                   input-output l_shipper_found,
                                   input-output l_save_abs,
                                   input-output l_conf_ship,
                                   input-output l_conf_shid)"}

         if l_shipper_found > 0
         then do:
            l_save_abs   = substring(l_save_abs,2,20).

            /* # SHIPPERS/CONTAINERS EXISTS FOR ORDER, INCLUDING # */
            {pxmsg.i
             &MSGNUM = 1118
             &ERRORLEVEL = 3
             &MSGARG1 = l_shipper_found
             &MSGARG2 = l_save_abs
             &MSGARG3 = """"}

             /* DO NOT ALLOW TO DELETE ORDER LINE, IF UNCONFIRMED */
             /* SHIPPER EXISTS                                    */
             undo setc-1,return error.

         end. /* IF L_SHIPPER_FOUND > 0 */

          /* IF ALL THE SHIPPERS FOR THE ORDER HAVE BEEN CONFIRMED  */
          /* DISPLAY WARNING AND ALLOW TO DELETE ORDER              */

         else if l_conf_ship > 0
         then do:
          l_conf_shid = substring(l_conf_shid,2,20).

          /* # CONFIRMED SHIPPERS EXIST FOR ORDER, INCLUDING # */
          {pxmsg.i
           &MSGNUM = 3314
           &ERRORLEVEL = 2
           &MSGARG1 = l_conf_ship
           &MSGARG2 = l_conf_shid
           &MSGARG3 = """"}

         end. /* IF L_CONF_SHIP > 0 */
         del-yn = yes.

      end. /* if ttPurchaseOrderDet.operation = {&REMOVE} */
   end. /* else c-application-mode = "API" */

   /* VALIDATES PO LINE UNIT OF MEASURE */
   {pxrun.i &PROC       = 'validatePOLineUM'
            &PROGRAM    = 'popoxr1.p'
            &PARAM      = "(input pod_um)"
            &NOAPPERROR = true
            &CATCHERROR = true}

   if return-value <> {&SUCCESS-RESULT}
   then do:
      if c-application-mode <> "API"
      then do:
         next-prompt
         pod_um
         with frame c no-validate.

         undo setc-1, retry setc-1.
      end. /* c-application-mode <> "API" */
      else
         undo setc-1, return error.
   end.  /* if return-value <> {&SUCCESS-RESULT} then do: */

   ststatus = stline[3].
   status input ststatus.

   if  (po_stat    <> "c" and
        po_stat    <> "x")
   and (pod_status <> "c" and
        pod_status <> "x")
   and  pod_type    = ""
   and  blanket     = false
   then do:

      /* UPDATE PART MASTER MRP FLAG */
      {pxrun.i &PROC       = 'updateItemForMRP'
               &PROGRAM    = 'popoxr1.p'
               &PARAM      = "(input pod_part,
                              input pod_site)"
               &NOAPPERROR = true
               &CATCHERROR = true}
   end. /* IF (po_stat <> "C" AND po_stat <> "X") AND .... */

   if del-yn = yes
   then do:

      /* DELETE LOGISTICS ACCOUNTING tx2d_det RECORDS FOR THIS LINE */
      if use-log-acctg then do:
         {gprunmo.i &module = "LA" &program = "lataxdel.p"
                    &param  = """(input '48',
                                  input pod_nbr,
                                  input pod_line)"""}
      end.


      {pxrun.i &PROC      = 'deletePurchaseOrderLine'
               &PROGRAM   = 'popoxr1.p'
               &PARAM     = "(buffer pod_det,
                              input po_type,
                              input po_stat,
                              input using_grs,
                              input blanket,
                              input no)"
               &NOAPPERROR = true
               &CATCHERROR = true}
      if return-value = {&SUCCESS-RESULT}
      then do:
         del-yn = no.
         if c-application-mode <> "API" then
            clear frame c.
            /* Single Line Entry. */


         if sngl_ln and
            c-application-mode <> "API"
         then
            clear frame d all no-pause.
         /* End Single Line Entry. */
         /* MESSAGE #6 - LINE ITEM DELETED */
         {pxmsg.i
            &MSGNUM    = 6
            &ERRORLEVEL= {&INFORMATION-RESULT}}
         continue = no.
         leave setc-1.
      end. /* IF return-value = {&SUCCESS-RESULT} */
   end. /* IF del-yn = yes */

   else do:

      /* ADD OR MODIFY  */

      if old_pod_status = "" then old_pod_status = pod_status.
      if new pod_det
      then do:
         if pod_qty_ord <= 0
         then do:
            /* TWO POSSIBLE MESSAGES */
            /* MESSAGE #331 - ORDER QUANTITY LESS THAN ZERO - RETURN */
            /* ITEMS TO SUPPLIER */
            /* MESSAGE #332 - ORDER QUANTITY IS ZERO */
            {pxmsg.i
               &MSGNUM     = "(if pod_qty_ord < 0
                               then
                                  331
                               else
                                  332)"
               &ERRORLEVEL = {&INFORMATION-RESULT}}
         end. /* IF pod_qty_ord <= 0 */
      end. /* IF NEW pod_det */

      if not new pod_det
      then do:

         if pod_cmtindx <> 0
         then
            podcmmts = yes.

         if      pod_qty_ord <> old_qty_ord
            and (po_stat     = "c" or
                 po_stat     = "x" or
                 pod_status  = "c" or
                 pod_status  = "x")
         then do:

            yn = no.
            /* PO and/or PO line closed or cancelled - reopen? */
            /* MESSAGE #339 - PO AND/OR PO LINE CLOSED OR */
            /* CANCELLED - REOPEN? */
            {pxmsg.i
               &MSGNUM     = 339
               &ERRORLEVEL = {&INFORMATION-RESULT}
               &CONFIRM    = yn}
            if c-application-mode = "API" then
                  yn = yes.

            if yn = yes
            then do :
               {pxrun.i &PROC='reOpenPurchaseOrder'
                        &PROGRAM='popoxr.p'
                        &PARAM      = "(input pod_nbr)"
                        &NOAPPERROR = true
                        &CATCHERROR = true}

               assign
                  pod_status  = ""
                  line_opened = true.
               {pxrun.i &PROC       = 'reOpenRequisition'
                        &PROGRAM    = 'rqgrsxr.p'
                        &PARAM      = "(input pod_req_nbr,
                                        input pod_req_line)"
                        &NOAPPERROR = true
                        &CATCHERROR = true}

            end. /* IF yn = YES */

            if yn = no
            then do:
               pod_qty_ord = old_qty_ord.
               if c-application-mode <> "API"
               then do:
                  display pod_qty_ord with frame c.
                  next-prompt pod_qty_ord with frame c.
                  undo setc-1, retry.
               end. /* if c-application-mode <> "API" */
               else
                  undo setc-1, return error.
            end. /* IF YN = NO */
         end. /* IF POD_QTY_ORD <> OLD_QTY_ORD AND (PO_STAT = "C"... */

         {pxrun.i &PROC       = 'validateOrderQtyAgainstRcptQty'
                  &PROGRAM    = 'popoxr1.p'
                  &PARAM      = "(input pod_qty_ord,
                                  input old_qty_ord,
                                  input pod_qty_rcvd)"
                  &NOAPPERROR = true
                  &CATCHERROR = true}

         if     pod_blanket <> ""
            and pod_qty_ord <> old_qty_ord
         then do:
            {pxrun.i &PROC='validateOrderQtyAgainstBlanketOrderOpenQty'
                     &PROGRAM='popoxr1.p'
                     &PARAM="(input pod_blanket,
                       input pod_blnkt_ln,
                       input pod_qty_ord,
                       input old_qty_ord,
                       input old_pod_status)"
                     &NOAPPERROR=true &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT}
            then do:
               next-prompt pod_qty_ord with frame c.
               undo setc-1, retry.
            end. /* IF RETURN-VALUE <> {&SUCCESS-RESULT} */
         end. /* IF POD_BLANKET <> "" */

         if     pod_qty_ord < 0
            and pod_consignment
         then do:
            /* ERROR: NEGATIVE QUANTITY ENTERED FOR A CONSIGNED LINE ITEM */
            {pxmsg.i
               &MSGNUM=4938
               &ERRORLEVEL=3
            }
            undo setc-1, retry.
         end. /* IF pod_qty_ord < 0 */

         /* IF QTY ORDERED IS CHANGED FROM -VE TO +VE      */
         /* RE-INITIALIZE CONSIGNMENT DETAILS FOR THE LINE */

         if     old_qty_ord <  0
            and pod_qty_ord >= 0
         then do:
            run 'initializeSuppConsignDetailFields'
                (input po_vend,
                 input pod_part,
                 input po_consignment,
                 input po_max_aging_days,
                 output pod_consignment,
                 output pod_max_aging_days).

            if not sngl_ln
            then do:
               /* WARNING: CONSIGNMENT SET TO YES/NO */
               {pxmsg.i
                  &MSGNUM=6304
                  &ERRORLEVEL=2
                  &MSGARG1=pod_consignment
                  &PAUSEAFTER=TRUE
               }
            end. /* IF NOT sngl_ln */
         end. /* IF old_qty_ord < 0 */

      end. /* IF NOT NEW pod_det */

      /* Only need to calc UM conversion on new line. */
      if (new pod_det)
      then do:
         {pxrun.i &PROC       = 'calculatePOLineUMConversion'
                  &PROGRAM    = 'popoxr1.p'
                  &PARAM      = "(buffer pod_det)"
                  &NOAPPERROR = true
                  &CATCHERROR = true}
      end. /*IF (NEW pod_det)*/

      /*@TO DO: Message not required for API mode, just perform conversion*/
      if pod_qty_ord     <> old_qty_ord
         and pod_req_nbr <> ""
         and pod_um      = old_um
         and pod_um      <> st_um
         and not new pod_det
      then do:
         yn = no.
         /* MESSAGE #372 - CONVERT QUANTITY FROM STOCK UNITS TO */
         /* PURCHASED UNITS */
         {pxmsg.i
            &MSGNUM     = 372
            &ERRORLEVEL = {&WARNING-RESULT}
            &CONFIRM    = yn}

         if c-application-mode = "API" then
            yn = yes.

         if yn = yes
         then do:
            pod_qty_ord = pod_qty_ord / pod_um_conv.

            if c-application-mode <> "API" then
               display pod_qty_ord with frame c.
         end. /* IF yn = YES */

      end. /* IF pod_qty_ord <> old_qty_ord AND pod_req_nbr <> "" ... */

      /* GET DEFAULT PURCHASE ORDER UNIT COST */

      if (c-application-mode <> "API" and pod_um entered or new pod_det)
        or (c-application-mode = "API" and ttPurchaseOrderDet.um <> ?
           or new pod_det)
         and itemAvailable
      then do:

         if price_came_from_req
         then do:

            /* COMPUTE THE BASE COST EVEN WHEN THE PRICE COMES    */
            /* THE REQ.  THIS COST IS DISPLAYED IN A MESSAGE      */
            /* WHEN BASE CURRENCY <> PO CURRENCY.                 */
            {pxrun.i &PROC       = 'computeBaseCost'
                     &PROGRAM    = 'popoxr1.p'
                     &PARAM      = "(input pod_part,
                                     input pod_site,
                                     input pod_um_conv,
                                     input po_ord_date,
                                     output base_cost)"
                     &NOAPPERROR = true
                     &CATCHERROR = true}

            /* CALCULATE THE UNIT COST OF THE PO DETAIL WHEN       */
            /* PURCHASE ORDER UM IS DIFFERENT THEN REQUISITION UM. */

            for first rqd_det
               fields(rqd_line rqd_nbr rqd_um_conv)
               where rqd_nbr  = pod_req_nbr
               and   rqd_line = pod_req_line
            no-lock:
               pod_pur_cost = (pod_pur_cost / rqd_um_conv) * pod_um_conv.
            end. /* FOR FIRST rqd_det */

         end. /* IF price_came_from_req */
         else do:

            /*TO DO: Once again, not required in API mode*/
            if     pod_req_nbr <> ""
               and pod_um      <> st_um
               and (pod_qty_ord <> old_qty_ord or
                    pod_um      <> old_um)
            then do:
               yn = no.
               /* MESSAGE #372 - CONVERT QUANTITY FROM STOCK UNITS */
               /* TO PURCHASED UNITS */
               {pxmsg.i
                  &MSGNUM    = 372
                  &ERRORLEVE = {&WARNING-RESULT}
                  &CONFIRM   = yn}
               if yn = yes
               then do:

                  if c-application-mode = "API" then
                     yn = yes.

                  if yn = yes
                  then do:
                     pod_qty_ord = pod_qty_ord / pod_um_conv.

                     if c-application-mode <> "API" then
                        display pod_qty_ord with frame c.
                  end. /* if yn = yes then do: */
               end. /* IF yn = YES */
            end. /* IF pod_req_nbr <> "" AND pod_um <> st_um */

            /* GET PART COSTS */

            {pxrun.i &PROC    = 'getStandardCost'
                     &PROGRAM = 'ppicxr.p'
                     &PARAM   = "(input pod_part,
                                  input pod_site,
                                  input po_ord_date,
                                  output glxcst)"}

            base_cost = glxcst * pod_um_conv.

            if not supplierAvailable
            then do:
               {pxrun.i &PROC       = 'calculatePOCostInForeignCurr'
                        &PROGRAM    = 'popoxr1.p'
                        &PARAM      = "(input glxcst,
                                        input pod_um_conv,
                                        input po_curr,
                                        input po_ex_rate,
                                        input po_ex_rate2,
                                        output pod_pur_cost)"
                        &NOAPPERROR = true
                        &CATCHERROR = true}

            end. /* IF NOT AVAILABLE vp_mstr */

            else
               if new pod_det
            then do:

               {pxrun.i &PROC    = 'calculatePOCurrCostFromSuppItem'
                        &PROGRAM = 'popoxr1.p'
                        &PARAM   = "(input pod_part,
                                     input po_vend,
                                     input pod_vpart,
                                     input itemUM,
                                     input pod_um,
                                     input pod_qty_ord,
                                     input pod_um_conv,
                                     input po_curr,
                                     input po_ex_rate,
                                     input po_ex_rate2,
                                     input glxcst,
                                     output pod_pur_cost)"
                  &NOAPPERROR    = true
                  &CATCHERROR    = true}

            end. /* ELSE IF NEW pod_det */
         end. /* END - ELSE PORTION OF IF price_came_from_req */
      end. /* END - if (pod_um entered OR NEW pod_det) */
      if new pod_det
         and not price_came_from_req
      then do:

         {pxrun.i &PROC       = 'calculateCostFromUMConvertedSupplierItem'
                  &PROGRAM    = 'popoxr1.p'
                  &PARAM      = "(input pod_part,
                                  input po_vend,
                                  input pod_vpart,
                                  input pod_um,
                                  input pod_qty_ord,
                                  input po_curr,
                                  input-output pod_pur_cost)"
                  &NOAPPERROR = true
                  &CATCHERROR = true}
      end. /* IF NEW pod_det */

      if  using_grs
         and pod_req_nbr  >  ""
         and po_type      <> "b"
         and pod_req_line <>  0
      then do:

         /* ADD / MODIFY REQ / PO CROSS REFERENCE RECORD */

         {pxrun.i &PROC       = 'updateRequisitionCrossReference'
                  &PROGRAM    = 'rqgrsxr1.p'
                  &PARAM      = "(input pod_site,
                                  input pod_req_nbr,
                                  input pod_req_line,
                                  input pod_nbr,
                                  input pod_line,
                                  input pod_qty_ord,
                                  input pod_um,
                                  output requm,
                                  output ok)"
                  &NOAPPERROR = true
                  &CATCHERROR = true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               undo, retry.
            else /* c-application-mode = "API" */
               undo, return error.
         end.

         /* CHECK REQ OPEN QTY; MUST NOT BE NEGATIVE */
         /* AS A RESULT OF THIS PO LINE QTY */
         {pxrun.i &PROC       = 'validateRequisitionLineOpenQuantity'
                  &PROGRAM    = 'rqgrsxr1.p'
                  &PARAM      = "(input pod_req_nbr,
                                  input pod_req_line,
                                  input pod_site)"
                  &NOAPPERROR = true
                  &CATCHERROR = true}

         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               undo setc-1, retry setc-1.
            else /* c-application-mode = "API" */
               undo setc-1, return error.
         end.

         if return-value = {&SUCCESS-RESULT}
         then do:
            {pxrun.i &PROC      = 'getRequisitionLineOpenQuantity'
                     &PROGRAM   = 'rqgrsxr1.p'
                     &PARAM     = "(input pod_req_nbr,
                                    input pod_req_line,
                                    input pod_site,
                                    output open_qty,
                                    output requm)"
                     &NOAPPERROR = true
                     &CATCHERROR = true}
         end. /* IF return-value ... */

         {pxrun.i &PROC       = 'validatePOLineQuantityOrdered'
                  &PROGRAM    = 'popoxr1.p'
                  &PARAM      = "(input pod_qty_ord)"
                  &NOAPPERROR = true
                  &CATCHERROR = true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               undo setc-1, retry setc-1.
            else /* c-application-mode = "API" */
               undo setc-1, return error.
         end.

         {pxrun.i &PROC       = 'updateMRPForRequisition'
                  &PROGRAM    = 'rqgrsxr1.p'
                  &PARAM      = "(input pod_site,
                                  input pod_req_nbr,
                                  input pod_req_line)"
                  &NOAPPERROR = true
                  &CATCHERROR = true}

      end. /* IF using_grs... */
   end. /* ELSE DO : (ADD OR MODIFY) */
end.  /* setc-1 */
