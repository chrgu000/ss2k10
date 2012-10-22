/* GUI CONVERTED from popomth.p (converter v1.78) Wed Jul 13 01:02:37 2011 */
/* popomth.p - PURCHASE ORDER MAINTENANCE SUBROUTINE                          */
/* Copyright 1986-2011 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* This program allows updating line order quantity and unit of measure, it   */
/* also does validations related to quantity ordered and does PO Line delete  */
/* operation.                                                                 */
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
/* Revision: 1.21.1.9     BY: Poonam Bahl       DATE:03/09/00   ECO: *N059*   */
/* Revision: 1.21.1.10    BY: Mark Brown        DATE:09/04/00   ECO: *N0RC*   */
/* Revision: 1.21.1.11    BY: Inna Lyubarsky    DATE:08/24/00   ECO: *N0KM*   */
/* Revision: 1.21.1.12    BY: Ashish Kapadia    DATE: 11/21/01  ECO: *N16F*   */
/* Revision: 1.21.1.13    BY: Samir Bavkar      DATE: 12/12/01  ECO: *P013*   */
/* Revision: 1.21.1.14    BY: Tiziana Giustozzi DATE: 07/24/02  ECO: *P09N*   */
/* Revision: 1.21.1.15    BY: Rajaneesh S.      DATE: 08/29/02  ECO: *M1BY*   */
/* Revision: 1.21.1.17    BY: Laurene Sheridan  DATE: 10/17/02  ECO: *N13P*   */
/* Revision: 1.21.1.18    BY: Jyoti Thatte      DATE: 11/25/02  ECO: *P0K1*   */
/* Revision: 1.21.1.19    BY: Shilpa Athalye    DATE: 05/22/03  ECO: *P0SJ*   */
/* Revision: 1.21.1.20    BY: Shilpa Athalye    DATE: 05/28/03  ECO: *N2G4*   */
/* Revision: 1.21.1.22    BY: Paul Donnelly (SB)DATE: 06/28/03  ECO: *Q00J*   */
/* Revision: 1.21.1.23    BY: Gnanasekar        DATE: 08/05/03  ECO: *P0XW*   */
/* Revision: 1.21.1.24    BY: Deepak Rao        DATE: 08/07/03  ECO: *P0YZ*   */
/* Revision: 1.21.1.25    BY: Priyank Khandare  DATE: 10/6/04   ECO: *P2R5*   */
/* Revision: 1.21.1.26    BY: Alok Gupta        DATE: 11/26/04  ECO: *P2WZ*   */
/* Revision: 1.21.1.27    BY: Nishit V          DATE: 06/08/05  ECO: *P3NR*   */
/* Revision: 1.21.1.28    BY: B. Gates          DATE: 08/03/05  ECO: *P3WP*   */
/* Revision: 1.21.1.28.1.1 BY: Nishit V         DATE: 11/24/05  ECO: *Q0MY*   */
/* Revision: 1.21.1.28.1.4  BY: Masroor Alam   DATE: 06/14/06   ECO: *P4TJ*   */
/* Revision: 1.21.1.28.1.5  BY: Masroor Alam   DATE: 02/12/07   ECO: *P5Q6*   */
/* Revision: 1.21.1.28.1.6  BY: Munira Savai   DATE: 04/18/07   ECO: *P5TK*   */
/* Revision: 1.21.1.28.1.7  BY: Prashant Menezes   DATE: 06/26/07 ECO: *P5GF* */
/* Revision: 1.21.1.28.1.8  BY: Sundeep Kalla      DATE: 08/14/07 ECO: *P60Q* */
/* Revision: 1.21.1.28.1.9  BY: Alex Joy           DATE: 07/25/08 ECO: *P6WM* */
/* Revision: 1.21.1.28.1.12 BY: Sandeep Rohila     DATE: 11/04/08 ECO: *Q1YW* */
/* Revision: 1.21.1.28.1.13 BY: Amit Kumar         DATE: 06/12/09 ECO: *Q30J* */
/* Revision: 1.21.1.28.1.17 BY: Chandrakant I      DATE: 02/12/10 ECO: *Q3V2* */
/* Revision: 1.21.1.28.1.18 BY: Avishek Chakraborty DATE: 03/30/10 ECO: *Q3Y0* */
/* $Revision: 1.21.1.28.1.19 $ BY: Ambrose Almeida    DATE: 07/12/11 ECO: *Q4XH* */
/*-Revision end---------------------------------------------------------------*/

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

/* INPUT/OUTPUT PARAMETERS */
define input parameter pDelay               like mfc_logical  no-undo.
define input-output parameter pPod_qty_ord  like pod_qty_ord  no-undo.
define input-output parameter pPod_pur_cost like pod_pur_cost no-undo.
define input parameter pPod_site            like pod_site no-undo.

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
define shared variable new_pod             like mfc_logical.

/* REQUISITION BY SITE WORKFILE INCLUDE FILE */
{poprwkfl.i}


/* LOCAL VARIABLES */
define variable requm             as   character  no-undo.
define variable open_qty          as   decimal    no-undo.
define variable ok                as   logical    no-undo.
define variable yn                like mfc_logical initial no.
define variable itemAvailable     as   logical    no-undo.
define variable supplierAvailable as   logical    no-undo.
define variable itemUM            as   character  no-undo.
define variable dummyDecimal      as   decimal    no-undo.
define variable dummyCharacter    as   character  no-undo.
define variable l_conf_ship       as   integer    no-undo.
define variable l_conf_shid       like abs_par_id no-undo.
define variable l_shipper_found as   integer     no-undo.
define variable l_save_abs      like abs_par_id  no-undo.
define variable using_grs         like mfc_logical no-undo.
define variable use-log-acctg     as logical no-undo.

define variable l_site_db         as character                 no-undo.
define variable l_err_flag        as integer                   no-undo.
define variable l_um              as decimal                   no-undo.
define variable l_pod_qty_ord     like pod_qty_ord             no-undo.
define variable l_display_disc    as decimal                   no-undo.
define variable l_min_disc        as decimal initial -99.99    no-undo.
define variable l_max_disc        as decimal initial 999.99    no-undo.
define variable l_pod_qty_ord1    like pod_qty_ord             no-undo.
define variable l_yn              like mfc_logical initial no  no-undo.

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
/*GUI*/ if global-beam-me-up then undo, leave.


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
                where mfc_ctrl.mfc_domain = global_domain and  mfc_field   =
                "grs_installed"
                 and mfc_logical = yes).

{gprun.i ""lactrl.p"" "(output use-log-acctg)"}
/*GUI*/ if global-beam-me-up then undo, leave.


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
/*GUI*/ if global-beam-me-up then undo, leave.

   /* DO NOT RETRY WHEN PROCESSING API REQUEST */
   if retry and c-application-mode = "API" then
      undo setc-1, return error.

   if c-application-mode <> "API"
   then do:
      if pod_disc_pct >  l_max_disc
      then
         l_display_disc =  l_max_disc.
      else if pod_disc_pct < l_min_disc
      then
         l_display_disc = l_min_disc.
      else
         l_display_disc = pod_disc_pct.

      display
         pod_pur_cost
         l_display_disc @ pod_disc_pct
      with frame c.

      update
         pod_qty_ord when (not pod_sched)
         pod_um when ((new pod_det or new_pod) and not pod_sched)
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
/*GUI*/ if global-beam-me-up then undo, leave.


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
            then do:
               if pDelay
               then do:
                  if pod_status <> ""
                  then
                     assign pPod_qty_ord  = 0
                            pPod_pur_cost = 0.
                  /* REVERSE OLD HISTORY */
                  /* potrxf.p IS A FACADE FOR gppotr.p */
                  {gprun.i ""potrxf.p""
                     "(input ""DELETE"",
                       input pod_nbr,
                       input pod_line,
                       input pDelay,
                       input pPod_qty_ord,
                       input pPod_pur_cost,
                       input pPod_site)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  assign pPod_qty_ord  = 0
                         pPod_pur_cost = 0.
                end. /* IF pDelay */
                leave.

            end. /* IF del-yn */

         end. /* IF lastkey = keycode("F5") or lastkey = keycode("CTRL-D") */
         else apply lastkey.
      end. /* END EDITING PORTION OF FRAME C */
      l_pod_qty_ord1 = pod_qty_ord.
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
/*GUI*/ if global-beam-me-up then undo, leave.


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
            and old_qty_ord <> pod_qty_ord
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

      /* VALIDATE THAT CHANGING OF QTY OR PRICE WITH REQUISITE CAN ONLY HAPPEN*/
      /* IF REQUISITE IS APPROVED*/

       if    (pod_qty_ord > old_qty_ord)
          and pod_req_nbr <> ""
          and not new pod_det
       then do:

          if can-find (rqd_det
                          where rqd_domain    = global_domain
                          and   rqd_nbr       = pod_req_nbr
                          and   rqd_line      = pod_req_line
                          and   rqd_aprv_stat <> "2")
          then do:
             /*CANNOT INCREASE ORDER QUANTITY - REQUISITION IS UNAPPROVED*/
             {pxmsg.i
                &MSGNUM     = 7753
                &ERRORLEVEL = 3}
             undo, retry.
          end. /* IF CAN-FIND (rqd_det..*/
       end. /*IF (pod_qty_ord > old_qty_ord)*/

      if  using_grs
         and pod_req_nbr  >  ""
         and po_type      <> "b"
         and pod_req_line <>  0
         and supplierAvailable
         and price_came_from_req
      then do:
         if pod_um <> vp_um
         then do:
            /* MESSAGE #304 - UM NOT THE SAME AS FOR SUPPLIER ITEM */
            {pxmsg.i
               &MSGNUM     = 304
               &ERRORLEVEL = 2
               &MSGARG1    = vp_um
               &PAUSEAFTER = TRUE}
         end. /* IF pod_um <> vp_um */
      end. /* IF  using_grs */

      /*@TO DO: Message not required for API mode, just perform conversion*/
      if pod_qty_ord     <> old_qty_ord
         and pod_req_nbr <> ""
         and pod_um      = old_um
         and pod_um      <> st_um
         and not new pod_det
      then do:
         yn = no.

         /* MESSAGE #6701 - AMOUNTS MAY MISMATCH DUE TO UM CONVERSION */
         /* ROUNDING ERRORS */
         {pxmsg.i
            &MSGNUM     = 6701
            &ERRORLEVEL = 2}

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
            assign
               l_yn = yn
               pod_qty_ord = pod_qty_ord / pod_um_conv.

            if c-application-mode <> "API" then
               display pod_qty_ord with frame c.
         end. /* IF yn = YES */

      end. /* IF pod_qty_ord <> old_qty_ord AND pod_req_nbr <> "" ... */

      /* GET DEFAULT PURCHASE ORDER UNIT COST */
     if (
              (c-application-mode    <> "API"
        and    pod_um entered
           or  new pod_det)
        or    (c-application-mode    <> "API"
           and not new pod_det
           and pod_site              <> old_site)
        or    (c-application-mode    =  "API"
           and ttPurchaseOrderDet.um <> ?
           or  new pod_det)
        )
        and    itemAvailable
      then do:

         if price_came_from_req
         then do:
            if using_grs
               and pod_req_nbr  >  ""
               and po_type      <> "b"
               and pod_req_line <>  0
            then do:
               if pod_req_nbr      <> ""
                  and pod_um       <> st_um
                  and (pod_qty_ord <> old_qty_ord or
                       pod_um      <> old_um)
               then do:
                  yn = no.
                  /* MESSAGE #6701 - AMOUNTS MAY MISMATCH DUE TO UM */
                  /* CONVERSION ROUNDING ERRORS */
                  {pxmsg.i
                     &MSGNUM     = 6701
                     &ERRORLEVEL = 2}
                  /* MESSAGE #372 - CONVERT QUANTITY FROM STOCK UNITS */
                  /* TO PURCHASED UNITS */
                  {pxmsg.i
                     &MSGNUM     = 372
                     &ERRORLEVEL = {&WARNING-RESULT}
                     &CONFIRM    = yn}
                  if yn = yes
                  then do:
                     if c-application-mode = "API"
                     then
                        yn = yes.
                     if yn = yes
                     then do:
                        assign
                           l_yn = yn
                           pod_qty_ord = pod_qty_ord / pod_um_conv.
                        if c-application-mode <> "API"
                        then
                           display pod_qty_ord with frame c.
                     end. /* IF yn = yes THEN DO: */
                  end. /* IF yn = YES */
               end. /* pod_req_nbr <> "" .. */
            end. /* IF using_grs ... */

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

            {pxrun.i &PROC       = 'getSiteDataBase'
                     &PROGRAM    = 'icsixr.p'
                     &PARAM      = "(input  pod_site,
                                     output l_site_db)"
                     &NOAPPERROR = true
                     &CATCHERROR = true}

            if l_site_db <> global_db
            then do:

               {gprun.i ""gpalias3.p"" "(l_site_db, output l_err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.



               if l_err_flag <> 0
               then do:

                  /* DOMAIN # IS NOT AVAILABLE */
                  {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=l_site_db}
                  undo, leave.

               end. /* IF l_err_flag <> 0*/

            end. /* IF l_site_db <> global_db */

            {gprun.i ""popomth1.p""
                     "(input pod_req_nbr,
                       input pod_req_line,
                       input pod_um_conv,
                       input-output pod_pur_cost)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            if old_db <> global_db
            then do:

               {gprun.i ""gpalias3.p"" "(old_db, output l_err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               if l_err_flag <> 0
               then do:

                  /* DOMAIN # IS NOT AVAILABLE */
                  {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=old_db}
                  undo, leave.

               end. /* IF l_err_flag <> 0*/

            end. /* IF old_db <> global_db */

         end. /* IF price_came_from_req */
         else do:

            /*TO DO: Once again, not required in API mode*/
            if     pod_req_nbr <> ""
               and pod_um      <> st_um
               and (pod_qty_ord <> old_qty_ord or
                    pod_um      <> old_um)
            then do:
               yn = no.

               /* MESSAGE #6701 - AMOUNTS MAY MISMATCH DUE TO UM CONVERSION */
               /* ROUNDING ERRORS */
               {pxmsg.i
                  &MSGNUM     = 6701
                  &ERRORLEVEL = 2}

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
                     assign
                        l_yn = yn
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
         and pod_req_line <>  0
      then do:

         if po_type <> "b"
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
         end. /* IF po_type <> "b" */

         /* CHECK REQ OPEN QTY; MUST NOT BE NEGATIVE */
         /* AS A RESULT OF THIS PO LINE QTY */

         /* CREATING qad_wkfl RECORD TO STORE THE ACTUAL   */
         /* PURCHASE ORDER QTY IN REQUISTION UNIT          */
         for first qad_wkfl
           where qad_domain = global_domain
             and qad_key1   = mfguser
             and qad_key2   = pod_nbr + string(pod_line)
         exclusive-lock:
         end. /* FOR FIRST qad_wkfl */
         if not available qad_wkfl
         then do:
            create qad_wkfl.
            assign
               qad_domain = global_domain
               qad_key1   = mfguser
               qad_key2   = pod_nbr + string(pod_line).
            if recid(qad_wkfl) = -1
            then
               .
            if l_yn
            then
               qad_decfld[1] = l_pod_qty_ord1.
            else
               qad_decfld[1] = l_pod_qty_ord1 * pod_um_conv.
         end. /* IF NOT AVAILABLE qad_wkfl */

         assign
            l_um          = 0
            l_pod_qty_ord = 0.

         if old_um <> pod_um
         then do:
            {gprun.i ""gpumcnv.p""
               "(input  reqUM,
                 input  pod_um,
                 input  pod_part,
                 output l_um)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            if l_um = ?
               then l_um = 1.
            old_qty_ord = old_qty_ord * truncate(l_um,9).
         end. /* IF old_um <> pod_um */

         if reqUM <> pod_um
         then do:
            {gprun.i ""gpumcnv.p""
               "(input  pod_um,
                 input  reqUM,
                 input  pod_part,
                 output l_um)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            if l_um = ?
               then l_um = 1.
            assign
               l_pod_qty_ord = pod_qty_ord * truncate(l_um,9)
               old_qty_ord   = old_qty_ord * truncate(l_um,9).
         end. /* IF reqUM <> pod_um */
         else
            l_pod_qty_ord = pod_qty_ord.

         {pxrun.i &PROC       = 'validateRequisitionLineOpenQuantity'
                  &PROGRAM    = 'rqgrsxr1.p'
                  &PARAM      = "(input pod_req_nbr,
                                  input pod_req_line,
                                  input pod_site,
                                  input l_pod_qty_ord,
                                  input old_qty_ord,
                                  input pod_rel_qty,
                                  input pod_type)"
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

         if po_type <> "b"
         then do:

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
         end. /* IF po_type <> "b" */
      end. /* IF using_grs... */
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* ELSE DO : (ADD OR MODIFY) */
end.  /* setc-1 */
for first qad_wkfl
   where qad_domain = global_domain
   and   qad_key1   = mfguser
   and   qad_key2   = pod_nbr + string(pod_line)
exclusive-lock:
   delete qad_wkfl.
end. /* FOR FIRST qad_wkfl */