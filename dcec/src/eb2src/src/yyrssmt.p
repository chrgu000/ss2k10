/* rssmt.p - Release Management Supplier Schedules                      */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.20.3.1 $                                                    */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.3    LAST MODIFIED: 12/11/92           BY: WUG *G462*    */
/* REVISION: 7.3    LAST MODIFIED: 12/23/92           BY: WUG *G471*    */
/* REVISION: 7.3    LAST MODIFIED: 03/17/93           BY: WUG *G833*    */
/* REVISION: 7.3    LAST MODIFIED: 05/07/93           BY: WUG *GA75*    */
/* REVISION: 7.3    LAST MODIFIED: 01/20/94           BY: WUG *GI51*    */
/* REVISION: 7.3    LAST MODIFIED: 09/21/94           BY: ljm *GM77*    */
/* REVISION: 7.3    LAST MODIFIED: 10/19/94           BY: ljm *GN40*    */
/* REVISION: 7.3    LAST MODIFIED: 11/01/94           BY: ame *GN88*    */
/* REVISION: 7.5    LAST MODIFIED: 12/12/94           BY: mwd *J034*    */
/* REVISION: 7.5    LAST MODIFIED: 03/16/95           BY: dpm *J044*    */
/* REVISION: 7.4    LAST MODIFIED: 04/09/95           BY: vrn *G0MD*    */
/* REVISION: 8.5    LAST MODIFIED: 08/29/95           BY: srk *J07D*    */
/* REVISION: 7.4    LAST MODIFIED: 09/14/95           BY: vrn *G0V2*    */
/* REVISION: 7.4    LAST MODIFIED: 09/16/95           BY: vrn *G0X9*    */
/* REVISION: 7.3    LAST MODIFIED: 11/07/95           BY: vrn *G1CN*    */
/* REVISION: 8.5    LAST MODIFIED: 02/27/96           BY: kjm *G1P5*    */
/* REVISION: 8.5    LAST MODIFIED: 04/09/96           BY: rpw *J0HK*    */
/* REVISION: 8.5    LAST MODIFIED: 06/07/96           by: *J0QS* M. Deleeuw */
/* REVISION: 8.5    LAST MODIFIED: 03/11/97           by: *H0TN* Aruna Patil*/
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98           BY: *L007* A. Rahane */
/* REVISION: 8.6E   LAST MODIFIED: 05/20/98           BY: *K1Q4* Alfred Tan */
/* REVISION: 8.6E   LAST MODIFIED: 08/17/98           BY: *L062* Steve Nugent */
/* REVISION: 8.6E   LAST MODIFIED: 10/04/98           BY: *J314* Alfred Tan   */
/* REVISION: 9.0    LAST MODIFIED: 12/01/98           BY: *K1QY* Steve Nugent */
/* REVISION: 9.0    LAST MODIFIED: 03/13/99           BY: *M0BD* Alfred Tan   */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00           BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00           BY: *N0KP* myb          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.17      BY: Kirti Desai       DATE: 04/12/01 ECO: *M150*       */
/* Revision: 1.18      BY: Rajiv Ramaiah     DATE: 08/05/02 ECO: *N1Q9*       */
/* Revision: 1.20      BY: Laurene Sheridan  DATE: 02/01/02 ECO: *N13P*       */
/* $Revision: 1.20.3.1 $   BY: Vandna Rohira     DATE: 11/17/03 ECO: *P19T*       */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* ************************************************************************** */
/* Note: This code has been modified to run when called inside an MFG/PRO API */
/* method as well as from the MFG/PRO menu, using the global variable         */
/* c-application-mode to conditionally execute API- vs. UI-specific logic.    */
/* Before modifying the code, please review the MFG/PRO API Development Guide */
/* in the QAD Development Standards for specific API coding standards and     */
/* guidelines.                                                                */
/* ************************************************************************** */
/* REVISION: 8.5    LAST MODIFIED: 11/14/03           BY: *LB01* Long Bo      */
/* REVISION: eb2+sp7   retrofit: 2005/06/29           BY: *tfq*  Tao fengqin cj */
/* SUPPLIER SCHEDULE MAINT */

{mfdtitle.i "2+ "}
/* Clear anything displayed by mftitle in api mode */
{mfaititl.i}


/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rssmt_p_2 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE rssmt_p_3 "Active Start"
/* MaxLen: Comment: */

&SCOPED-DEFINE rssmt_p_4 "Active End"
/* MaxLen: Comment: */

&SCOPED-DEFINE rssmt_p_5 "Subcontract Type"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable cmtindx like cmt_indx.
define new shared variable global_schtype as integer.

define variable schtype as integer initial 4.
define variable i as integer.
define variable del-yn like mfc_logical.
define variable yn like mfc_logical.
define variable cmmts like poc_hcmmts label {&rssmt_p_2} initial yes.
define variable this_eff_start as date.
define variable sch_recid as recid.
define variable impexp   like mfc_logical no-undo.
define variable impexp_label as character no-undo.
define variable old_db as character no-undo.
define variable sdb_err as integer no-undo.

/*SCHEDULE ORDER API TEMP-TABLE, NAMED USING THE "api" PREFIX*/
{rssit01.i}

define variable subtype as character format "x(12)"
   label {&rssmt_p_5} no-undo.

define buffer prev_sch_mstr for sch_mstr.
define buffer prev_schd_det for schd_det.

define new shared frame a.
define new shared workfile work_schd like schd_det.
/* COMMON API CONSTANTS AND VARIABLES */
{mfaimfg.i}

/*Schedule Cross Reference temp table*/
{scxit01.i}
{mfctit01.i}

if c-application-mode = "API"
then do on error undo, return:

   /* GET HANDLE OF API CONTROLLER */
   {gprun.i ""gpaigh.p""
             "(output ApiMethodHandle,
               output ApiProgramName,
               output ApiMethodName,
               output apiContextString)"}

   /*GET LOCAL SCHEDULE ORDER TEMP-TABLES */
   create ttScheduleOrder.
   run getScheduleOrderRecord in ApiMethodHandle
       (buffer ttScheduleOrder).

   run getScheduleOrderCmt in ApiMethodHandle
                (output table ttScheduleOrderCmt).

   run getScheduleCrossRefRecord in ApiMethodHandle
               (buffer ttScheduleCrossRef).

end.  /* If c-application-mode = "API" */

/* CHECK FLAG TO SEE IF ADG 862 MODULE IS TURNED */
/* ON AND SUPPLIER SHIPPING SCHEDULES IS ACTIVE  */

if can-find (first mfc_ctrl where
   mfc_field   = "enable_shipping_schedules" and
   mfc_seq     = 4                           and
   mfc_module  = "ADG"                       and
   mfc_logical = yes)
then do:
   {pxmsg.i &MSGNUM=4377 &ERRORLEVEL=4} /* PRO/PLUS SUPPLIER SCHEDULES IN USE */
   if c-application-mode <> "API" and not batchrun
   then do:
      pause.
      leave.
   end. /* c-application-mode <> "API" and not batchrun */
   else if c-application-mode = "API" then
      undo ,return error.
end. /* if can-find first mfc_ctrl */

{rsordfrm.i}

form
/*GM65*/
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   space(1)
   sch_rlse_id colon 16
  SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

/*TFQ  DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "". */
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

for first poc_ctrl no-lock:
end.

repeat transaction:

   /* DO NOT RETRY WHEN PROCESSING API REQUEST */
   if retry and c-application-mode = "API" then
      undo, return error.

   /* GET SCHEDULED ORDER */
   /* ADDED PARAM #5 TO THE CALL: "poApi" USED FOR PURCHASE ORDER API   */
/*cj*/   {yyrsgetord.i "old"  " "  " "  "validate" "poApi"}

   /* GET SCHEDULE RECORD */
   /* ADDED PARAM #1 TO THE CALL: "poApi" USED FOR PURCHASE ORDER API   */
   {rsgetrel.i "poApi"}
   cmmts = poc_lcmmts.
   if sch_cmtindx > 0 then cmmts = yes.

   form
   RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
      cmmts          colon 20
      sch_cr_date    colon 55
      sch_cr_time    no-label
      sch_pcr_qty    colon 20
      sch_eff_start  colon 55 label {&rssmt_p_3}
      sch_pcs_date   colon 20
      sch_eff_end    colon 55 label {&rssmt_p_4}
       SKIP(.4)  /*GUI*/
with frame sched_data side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

/*TFQ*/  DEFINE VARIABLE F-sched_data-title AS CHARACTER INITIAL "". 
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-sched_data-title.
 RECT-FRAME-LABEL:HIDDEN in frame sched_data = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame sched_data =
  FRAME sched_data:HEIGHT-PIXELS - RECT-FRAME:Y in frame sched_data - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME sched_data = FRAME sched_data:WIDTH-CHARS - .5.  /*GUI*/

  /*TFQ with frame sched_data attr-space side-labels width 80. */

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame sched_data:handle).

   if c-application-mode <> "API" then
      display sch_cr_date
         string(sch_cr_time,"HH:MM:SS") format "x(8)" @ sch_cr_time
      with frame sched_data.

   ststatus = stline[2].
   status input ststatus.

   if c-application-mode <> "API" then
      display
         cmmts
         sch_pcr_qty
         sch_pcs_date
         sch_eff_start
         sch_eff_end
      with frame sched_data.

   do on error undo, retry:
      if retry and c-application-mode = "API" then
      undo, return error.

      if c-application-mode <> "API" then
         set
            cmmts
            sch_pcr_qty
            sch_pcs_date
            sch_eff_start
            sch_eff_end
            go-on(F5 CTRL-D) with frame sched_data.
      else
         assign
         {mfaiset.i sch_pcr_qty   ttScheduleOrder.pcrQty}
         {mfaiset.i sch_pcs_date  ttScheduleOrder.pcsDate}
         {mfaiset.i sch_eff_start ttScheduleOrder.effStart}
         {mfaiset.i sch_eff_end   ttScheduleOrder.effEnd}.

      if (c-application-mode <> "API" and lastkey = keycode("F5")
         or lastkey = keycode("CTRL-D")) or
         (c-application-mode = "API"
         and ttScheduleOrder.operation = {&REMOVE})
      then do:

         /* WARN THE USER WHEN A CONTAINER/SHIPPER IS FOUND FOR THE
          * PURCHASE ORDER. */
         for first scx_ref where  scx_type  = 2
                         and scx_order = sch_nbr
                         and scx_line  = sch_line
         no-lock:
         end.

         for first abs_mstr where abs_shipfrom = scx_shipfrom
                               and abs_dataset  = "pod_det"
                               and abs_order    = sch_nbr
                               and abs_line     = string(sch_line)
         no-lock:
         end.
         if available abs_mstr
         then do:
            /* SHIPPER OR CONTAINER EXISTS FOR SCHEDULE LINE */
            {pxmsg.i &MSGNUM=8304 &ERRORLEVEL=2}
         end.

         del-yn = no.
         if c-application-mode <> "API"
         then do:
         /*tfq   {mfmsg01.i 11 1 del-yn} */
          {pxmsg.i
               &MSGNUM=11
               &ERRORLEVEL=1
               &COMFIRM=del-yn
             }

         end.  /* If c-application-mode <> "API" */
         else  /* c-application-mode = "API" */
             del-yn = (ttScheduleOrder.operation = {&REMOVE}).

         if del-yn = no then undo, retry.

         if pod_curr_rlse_id[schtype - 3] = sch_rlse_id then
            pod_curr_rlse_id[schtype - 3] = "".

         {gprun.i ""rcschdel.p"" "(input recid(sch_mstr), input no)"}

         /* UPDATE MRP */
         {gprun.i ""rsmrw.p"" "(input pod_nbr,
                                input pod_line,
                                input yes)"}
         if c-application-mode <> "API"
         then do:
            clear frame sched_data.
            clear frame a.
         end.  /* If c-application-mode <> "API" */

         release pod_det.
         if c-application-mode <> "API" then
            next.
         else
            leave.
      end.  /* IF (C-APP-MODE ... */

      if sch_pcs_date = ?
      then do:
         {pxmsg.i &MSGNUM=8240 &ERRORLEVEL=3}
         if c-application-mode <> "API"
         then do:
            next-prompt sch_pcs_date with frame sched_data.
            undo , retry.
         end.  /* If c-application-mode <> "API" */
         else   /* c-application-mode = "API" */
            undo, return error.
      end.  /* if sch_pcs_date = ? then do: */

      if new sch_mstr and sch_eff_start < today
      then do:
         {pxmsg.i &MSGNUM=27 &ERRORLEVEL=3}
         if c-application-mode <> "API"
         then do:
            next-prompt sch_eff_start with frame sched_data.
            undo , retry.
         end.  /*if c-application-mode <> "API" */
         else /*if c-application-mode = "API"*/
            undo, return error.
      end.

      if sch_eff_end < sch_eff_start
      then do:
         {pxmsg.i &MSGNUM=4 &ERRORLEVEL=3}
         if c-application-mode <> "API"
         then do:
            next-prompt sch_eff_start with frame sched_data.
            undo, retry.
         end.  /* If c-application-mode <> "API" */
         else  /* c-application-mode = "API" */
           undo, return error.
      end.  /* if sch_eff_end < sch_eff_start then do: */
   end.  /* DO ON ERROR UNDO, RETRY */

   if cmmts
   then do:
      if c-application-mode = "API"
      then do:
         {gpttcp.i ttScheduleOrderCmt
                   ttTransComment

                   "ttScheduleOrderCmt.apiExternalKey =
                   ttScheduleOrder.apiExternalKey"}
         run setTransComment in ApiMethodHandle
            (input table ttTransComment).

      end.
      assign
         cmtindx = sch_cmtindx
         global_ref = po_vend.
      {gprun.i ""gpcmmt01.p"" "(input ""po_mstr"")"}
      sch_cmtindx = cmtindx.
      if c-application-mode <> "API" then
         view frame a.
   end.

   if c-application-mode <> "API" then
      view frame a.

   /* REMEMBER CURRENT F/P INDICATORS */
   for each schd_det exclusive-lock
         where schd_type = sch_type
         and schd_nbr = sch_nbr
         and schd_line = sch_line
         and schd_rlse_id = sch_rlse_id:
      schd__chr02 = schd_fc_qual.
   end.

   if c-application-mode <> "API" then
      hide frame sched_data.
   /* DO DETAIL MAINTENANCE */
   {gprun.i ""rssmtb.p"" "(input recid(sch_mstr))"}

   /* GET ANY DETAIL RECORDS NEWLY FIRMED AND REDUCE THEIR PLANNED WO'S */
   for each work_schd
      exclusive-lock:
      delete work_schd.
   end.

   for each schd_det exclusive-lock
         where schd_type    = sch_type
         and   schd_nbr     = sch_nbr
         and   schd_line    = sch_line
         and   schd_rlse_id = sch_rlse_id
         and   schd__chr02  = "p"
         and schd_fc_qual = "f":

      do for work_schd:
         create work_schd.

         assign
            work_schd.schd_discr_qty = schd_det.schd_discr_qty
            work_schd.schd_date      = schd_det.schd_date
            work_schd.schd__chr01    = schd_det.schd__chr01.
      end.
   end.

   /* WORK ORDER OF PARENT ITEM WILL NOT BE DELETED WHEN Q STATUS  */
   /* IS CHANGED FROM "P" TO "F" IN SCHEDULE DETAIL DATA FRAME FOR */
   /* SUBCONTRACT PURCHASE ORDERS.                                 */

   if pod_type <> "S"
   then do:
   /*LB01*/    {gprun.i ""yyrssupb.p"" "(input today + 100000)"}
   /*tfq   {gprun.i ""rssupb.p"" "(input today + 100000)"} */
   end. /* IF pod_type <> "S" */

   /* AUTHORIZATIONS */

   form
      sch_fab_qty       colon 15
      sch_fab_strt  /*V8! colon 40 */
      sch_fab_end   /*V8! colon 60 */
      sch_raw_qty       colon 15
      sch_raw_strt  /*V8! colon 40 */
      sch_raw_end   /*V8! colon 60 */
   with frame res_auth_data width 80
      title color normal
      (getFrameTitle("RESOURCE_AUTHORIZATION_DATA",38))
/*cj*/ THREE-D
      attr-space side-labels.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame res_auth_data:handle).

   if new sch_mstr
   then do:
      assign
         sch_fab_strt = pod_cum_date[1]
         sch_raw_strt = pod_cum_date[1].

      if pod_fab_days > 0
      then do:
         sch_fab_qty = sch_pcr_qty.

         for each schd_det no-lock
               where schd_type = sch_type
               and schd_nbr = sch_nbr
               and schd_line = sch_line
               and schd_rlse_id = sch_rlse_id
               and schd_date <= sch_pcs_date + pod_fab_days:
            assign
               sch_fab_qty = sch_fab_qty + schd_discr_qty
               sch_fab_end = schd_date.
         end.
      end.

      if pod_raw_days > 0
      then do:
         sch_raw_qty = sch_pcr_qty.

         for each schd_det no-lock
               where schd_type = sch_type
               and schd_nbr = sch_nbr
               and schd_line = sch_line
               and schd_rlse_id = sch_rlse_id
               and schd_date <= sch_pcs_date + pod_raw_days:
            assign
               sch_raw_qty = sch_raw_qty + schd_discr_qty
               sch_raw_end = schd_date.
         end.
      end.
   end.

   ststatus = stline[3].
   status input ststatus.

   if c-application-mode <> "API"
   then do:
      do on endkey undo , leave:
         update
            sch_fab_qty
            sch_fab_strt
            sch_fab_end
            sch_raw_qty
            sch_raw_strt
            sch_raw_end
         with frame res_auth_data.
      end.

      hide frame res_auth_data.
   end. /*if c-appication-mode <> "API"*/
   else  /*if c-application-mode ="API"*/
      assign
         {mfaiset.i sch_fab_qty  ttScheduleOrder.fabQty}
         {mfaiset.i sch_fab_strt ttScheduleOrder.fabStrt}
         {mfaiset.i sch_fab_end  ttScheduleOrder.fabEnd}
         {mfaiset.i sch_raw_qty  ttScheduleOrder.rawQty}
         {mfaiset.i sch_raw_strt ttScheduleOrder.rawStrt}
         {mfaiset.i sch_raw_end  ttScheduleOrder.rawEnd}
         .

   yn = no.
   if sch_rlse_id <> pod_curr_rlse_id[schtype - 3]
   then do:
      if c-application-mode <> "API"
      then do:
        /*TFQ {mfmsg01.i 6001 1 yn} */
         {pxmsg.i
               &MSGNUM=6001
               &ERRORLEVEL=1
               &CONFIRM=yn
             }

      end.    /* if c-application-mode <> "API" */
      else  /* if c-application-mode = "API" */
         yn = yes.

      if yn
      then do:
         assign
            this_eff_start = sch_eff_start
            sch_recid = recid(sch_mstr).

         for first sch_mstr where sch_type = schtype
            and sch_nbr = pod_nbr
            and sch_line = pod_line
            and sch_rlse_id = pod_curr_rlse_id[schtype - 3]
            exclusive-lock:
            end.

         if available sch_mstr then
            assign
               sch_eff_end = this_eff_start.

         for first sch_mstr where recid(sch_mstr) = sch_recid exclusive-lock:
         end.

         assign
            sch_eff_end = ?
            pod_curr_rlse_id[schtype - 3] = sch_rlse_id.
         /* SET POD_CURR_RLSE_ID IN REMOTE DB TOO */
         if available po_mstr then
            for first si_mstr where si_site = po_site
            no-lock:
            end.
         else
            for first si_mstr where si_site = pod_po_site
            no-lock:
            end.
         if available si_mstr
         then do:
            if si_db <> global_db
            then do:
               old_db = global_db.
               {gprun.i ""gpalias3.p"" "(input si_db, output sdb_err)"}
               {gprun.i ""rssmt01.p"" "(input scx_po, input scx_line,
                                        input sch_rlse_id, input schtype)"}
               {gprun.i ""gpalias3.p"" "(input old_db, output sdb_err)"}
            end.
         end.
      end.  /* if yn  */
   end.  /* if sch_rlse_id <> pod_curr_rlse_id[schtype - 3]  */

   /* UPDATE MRP */

   {gprun.i ""rsmrw.p"" "(input pod_nbr, input pod_line, input yes)"}
   release pod_det.

   if c-application-mode = "API" then
      leave.

end.  /* REPEAT TRANSACTION */

/*RETURN SUCCESS STATUS TO API CALLER*/
if c-application-mode = "API" then
   return {&SUCCESS-RESULT}.

