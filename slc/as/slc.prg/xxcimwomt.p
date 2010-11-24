/* wowomt.p - WORK ORDER MAINTENANCE                                          */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.32 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0      LAST EDIT: 10/11/91      MODIFIED BY: emb *F024*/
/* REVISION: 7.0      LAST EDIT: 02/20/92      MODIFIED BY: pma *F217**/
/* REVISION: 7.0      LAST EDIT: 02/21/92      MODIFIED BY: emb *F227**/
/* REVISION: 7.0      LAST EDIT: 02/28/92      MODIFIED BY: pma *F085**/
/* REVISION: 7.0      LAST EDIT: 03/23/92      MODIFIED BY: pma *F089**/
/* REVISION: 7.0      LAST EDIT: 04/29/92      MODIFIED BY: emb *F457**/
/* REVISION: 7.0      LAST EDIT: 06/18/92      MODIFIED BY: JJS *F672* (rev) */
/* REVISION: 7.0      LAST EDIT: 07/01/92      MODIFIED BY: afs *F723* (rev) */
/* REVISION: 7.0      LAST EDIT: 07/02/92      MODIFIED BY: emb *F729**/
/* REVISION: 7.0      LAST EDIT: 10/05/92      MODIFIED BY: emb *G125**/
/* REVISION: 7.3      LAST EDIT: 09/27/92      MODIFIED BY: jcd *G255**/
/* REVISION: 7.3      LAST EDIT: 11/03/92      MODIFIED BY: emb *G268* (rev) */
/* REVISION: 7.3      LAST EDIT: 12/22/92      MODIFIED BY: tjs *G463* (rev) */
/* REVISION: 7.3      LAST EDIT: 03/04/93      MODIFIED BY: emb *G870**/
/* REVISION: 7.3      LAST EDIT: 09/03/93      MODIFIED BY: pma *GE81* (rev) */
/* REVISION: 7.3      LAST EDIT: 11/16/93      MODIFIED BY: pxd *GH30**/
/* REVISION: 7.3      LAST EDIT: 12/22/93      MODIFIED BY: ais *GI25**/
/* REVISION: 8.5      LAST EDIT: 03/22/94      MODIFIED BY: tjs *J014**/
/* REVISION: 7.3      LAST EDIT: 04/06/94      MODIFIED BY: pma *FN27**/
/* REVISION: 7.3      LAST EDIT: 07/14/94      MODIFIED BY: ais *FP42**/
/* REVISION: 7.3      LAST EDIT: 08/08/94      MODIFIED BY: pxd *FP91**/
/* REVISION: 7.3      LAST EDIT: 09/01/94      MODIFIED BY: ljm *FQ67**/
/* REVISION: 7.3      LAST EDIT: 09/27/94      MODIFIED BY: rmh *FR82**/
/* REVISION: 8.5      LAST EDIT: 10/20/94      MODIFIED BY: mwd *J034**/
/* REVISION: 7.3      LAST EDIT: 10/31/94      MODIFIED BY: WUG *GN76**/
/* REVISION: 8.5      LAST EDIT: 11/30/94      MODIFIED BY: taf *J040**/
/* REVISION: 7.3      LAST EDIT: 12/27/94      MODIFIED BY: srk *G0B2**/
/* REVISION: 7.3      LAST EDIT: 02/10/95      MODIFIED BY: pxd *F0HS**/
/* REVISION: 7.3      LAST EDIT: 02/15/95      MODIFIED BY: pxe *F0H7**/
/* REVISION: 8.5      LAST EDIT: 03/07/95      MODIFIED BY: tjs *J027**/
/* REVISION: 7.3      LAST EDIT: 03/27/95      MODIFIED BY: srk *G0JB**/
/* REVISION: 7.2      LAST EDIT: 04/13/95      MODIFIED BY: ais *F0PM**/
/* REVISION: 7.2      LAST EDIT: 05/24/95      MODIFIED BY: qzl *F0S4**/
/* REVISION: 8.5      LAST EDIT: 06/07/95      MODIFIED BY: sxb *J04D**/
/* REVISION: 8.5      LAST EDIT: 06/16/95      MODIFIED BY: rmh *J04R**/
/* REVISION: 7.2      LAST EDIT: 06/19/95      MODIFIED BY: qzl *F0ST**/
/* REVISION: 7.3      LAST EDIT: 10/24/95      MODIFIED BY: jym *G19X**/
/* REVISION: 7.3      LAST EDIT: 11/10/95      MODIFIED BY: rvw *G1CZ**/
/* REVISION: 8.5      LAST EDIT: 04/11/96       BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST EDIT: 04/11/96       BY: *J04C* Markus Barone      */
/* REVISION: 8.5      LAST EDIT: 06/11/96       BY: *G1XY* Russ Witt          */
/* REVISION: 8.5      LAST EDIT: 07/26/96       BY: *J10X* Markus Barone      */
/* REVISION: 8.5      LAST EDIT: 02/04/97       BY: *J1GW* Murli Shastri      */
/* REVISION: 8.5      LAST EDIT: 05/11/97       BY: *G2MF* Julie Milligan     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 12/08/98   BY: *M02C* Jim Williams       */
/* REVISION: 9.0      LAST MODIFIED: 02/04/99   BY: *J38K* Viswanathan M      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 11/14/99   BY: *N05J* Michael Amaladhas  */
/* REVISION: 9.1      LAST MODIFIED: 12/15/99   BY: *L0MR* Rajesh Thomas      */
/* REVISION: 9.1      LAST MODIFIED: 02/07/00   BY: *M0JN* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Vincent Koh        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/06/00   BY: *L0YT* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* Revision: 1.20       BY: Falguni Dalal       DATE: 11/23/00 ECO: *M0WH*    */
/* Old ECO marker removed, but no ECO header exists *F003*                    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.21     BY: Manish Kulkarni     DATE: 11/15/00  ECO: *P008*    */
/* Revision: 1.23     BY: Vinod Nair          DATE: 08/23/02  ECO: *N1S2*    */
/* Revision: 1.26     BY: Deirdre O'Brien     DATE: 10/16/02  ECO: *N14F*    */
/* Revision: 1.29     BY: Narathip W.         DATE: 04/19/03  ECO: *P0Q7*    */
/* Revision: 1.31     BY: Paul Donnelly (SB)  DATE: 06/28/03  ECO: *Q00N*    */
/* $Revision: 1.32 $ BY: Sukhad Kulkarni    DATE: 02/22/05  ECO: *P37G*    */
/* By: Neil Gao Date: 07/06/26 ECO: * ss 20070626 * */
/* By: Neil Gao Date: 07/10/30 ECO: * ss 20071030 * */
/* By: Neil Gao Date: 07/12/25 ECO: * ss 20071225 * */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/**********************************************************************/
/*     MAKE SURE THAT ANY CHANGES TO THIS PROGRAM ARE ALSO REFLECTED  */
/*     IN REWOMT.P UNLESS REPETITIVE DOES NOT USE THAT FEATURE        */
/**********************************************************************/
/**************************************************************************/
/*     PROGRAM wowomt.p WAS USED AS A TEMPLATE FOR NEW PROGRAM giapimpc.p */
/*     IN THE ON/Q PLANNING AND OPTIMIZATION API INTERFACE PROJECT.  NEW  */
/*     FUNCTIONAL AND STRUCTURAL CHANGES MADE TO wowomt.p SHOULD BE       */
/*     EVALUATED FOR SUITABILITY FOR INCLUSION WITHIN giapimpc.p.         */
/**************************************************************************/

{mfdtitle.i "1+ "}
{cxcustom.i "WOWOMT.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE wowomt_p_1 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowomt_p_2 "Adjust Co/By Order Quantities"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowomt_p_3 "Adjust Co/By Order Dates"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable comp like ps_comp.
define new shared variable qty like wo_qty_ord.
define new shared variable eff_date as date.
define new shared variable wo_recno as recid.
define new shared variable leadtime like pt_mfg_lead.
define new shared variable prev_status like wo_status.
define new shared variable prev_release like wo_rel_date.
define new shared variable prev_due like wo_due_date.
define new shared variable prev_qty like wo_qty_ord.
define new shared variable any_issued like mfc_logical.
define new shared variable any_feedbk like mfc_logical.

define new shared variable wo_recno1      as recid.
define new shared variable jpwo_recno     as recid.
define new shared variable prev_ord       like wo_ord_date.
define new shared variable del-joint      like mfc_logical initial no.
define new shared variable wopart         like wo_part.
define new shared variable joint_type     like wo_joint_type.
define new shared variable qty_type       like wo_qty_type.
define new shared variable prod_pct       like wo_prod_pct.
define new shared variable no_msg         like mfc_logical initial no.
define new shared variable screen_used    like mfc_logical.
define new shared variable err_msg        as integer.
define new shared variable add_2_joint    like mfc_logical.
define new shared variable rel_date       like wo_rel_date.
define new shared variable due_date       like wo_due_date.
define new shared variable base_lot       like wo_lot.
define new shared variable base_qty       like wo_qty_ord.
define new shared variable base_um        like bom_batch_um.
define new shared variable prev_routing   like wo_routing.
define new shared variable prev_bomcode   like wo_bom_code.
define new shared variable updt_subsys    like mfc_logical.
define new shared variable joint_qtys     like mfc_logical
   label {&wowomt_p_2} initial yes.
define new shared variable joint_dates    like mfc_logical
   label {&wowomt_p_3} initial yes.

define variable jplabel        as character format "x(15)".
define variable valid_mnemonic like mfc_logical.
define variable prod_percent   like mfc_logical.
define variable joint_label    like lngd_translation.
define variable joint_code     like wo_joint_type.
define variable conv           like ps_um_conv.
define new shared variable cmtindx like wo_cmtindx.
define new shared variable del-yn like mfc_logical initial no.
define new shared variable deliv like wod_deliver.
define new shared variable prev_site like wo_site.
define new shared variable undo_all like mfc_logical no-undo.
define new shared variable critical-part like wod_part no-undo.
define new shared variable wonbr like wo_nbr.
define new shared variable wolot like wo_nbr.
define new shared variable know_date as date.
define new shared variable find_date as date.
define new shared variable interval as integer.
define new shared variable frwrd as integer.
define new shared variable undoretrymain as logical.
define new shared variable undoleavemain as logical.
define new shared variable pt_rec as recid.
define new shared variable new_wo like mfc_logical initial no.
define new shared variable prev_mthd    like cs_method   no-undo.
define new shared variable critical_flg like mfc_logical no-undo.
{&WOWOMT-P-TAG1}

define variable i as integer.
define variable nonwdays as integer.
define variable workdays as integer.
define variable overlap as integer.
define variable yn like mfc_logical initial no.
define variable wocmmts like woc_wcmmts label {&wowomt_p_1}.
define variable msg-type as integer.
define variable glx_mthd like cs_method.
define variable glx_set like cs_set.
define variable cur_mthd like cs_method.
define variable cur_set like cs_set.
define variable msg-counter as integer.
define variable do-delete as logical.

define new shared frame attrmt.
define new shared frame a.
define new shared frame b.

define buffer wo_mstr1 for wo_mstr.

define variable wo_owner as character no-undo.

if can-find(first qad_wkfl  where qad_wkfl.qad_domain = global_domain and
qad_key1 = "WO-CLOSE") then do:
   {pxmsg.i &MSGNUM=1361 &ERRORLEVEL=1}
   /* OLD WORK ORDER DATA STORAGE HAS BEEN DETECTED IN QAD_WKFL */
   {pxmsg.i &MSGNUM=1362 &ERRORLEVEL=1}
   /* PLEASE RUN "UTQADWO.P" BEFORE EXECUTING THIS FUNCTION     */
   pause.
   hide message no-pause.
   return.
end.

/* ATTRIBUTES FRAME DEFINITION */
{mfwoat.i}

{gprun.i ""gplotwdl.p""}

do transaction on error undo, retry:
   find first woc_ctrl  where woc_ctrl.woc_domain = global_domain no-lock
   no-error.
   if not available woc_ctrl then
       do: create woc_ctrl. woc_ctrl.woc_domain = global_domain. end.
   if available woc_ctrl then
      wocmmts = woc_wcmmts.
   release woc_ctrl.
end.

assign
   critical_flg = no
   eff_date     = today.

{&WOWOMT-P-TAG2}
form
   wo_nbr         colon 25
   wo_lot
   wo_part        colon 25
   /*V8! view-as fill-in size 20 by 1 */
   pt_desc1       at 47 no-label
   wo_type        colon 25
   pt_desc2       at 47 no-label
   wo_site        colon 25
   joint_label    at 47 no-label
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   wo_qty_ord     colon 25
   wo_ord_date    colon 55
   wo_qty_comp    colon 25
   wo_rel_date    colon 55
   wo_qty_rjct    colon 25
   wo_due_date    colon 55
   skip(1)
   wo_status      colon 25
   wo_site        colon 55
   wo_so_job      colon 25
   wo_routing     colon 55
   wo_vend        colon 25
   wo_bom_code    colon 55
   wo_yield_pct   colon 25
   skip(1)
   wo_rmks        colon 25
   wocmmts        colon 25
   wo_var         colon 62
with frame b side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* DISPLAY */
view frame a.
view frame b.

mainloop:
repeat:
   do transaction with frame a:

      assign
         prev_status = ""
         prev_ord = ?
         prev_release = ?
         prev_due = ?
         prev_qty = 0
         leadtime = 0
         new_wo = no.

      prompt-for wo_nbr wo_lot
      editing:
         if frame-field = "wo_nbr" then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i wo_mstr wo_nbr  " wo_mstr.wo_domain = global_domain and
            wo_nbr "  wo_nbr wo_nbr wo_nbr}

         end.
         else if frame-field = "wo_lot" then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i wo_mstr wo_lot  " wo_mstr.wo_domain = global_domain and
            wo_lot "  wo_nbr wo_nbr wo_lot}

         end.
         else do:
            readkey.
            apply lastkey.
         end.

         if recno <> ? then do:

            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = wo_part
            no-lock no-error no-wait.
            if available pt_mstr then
            display
               pt_desc1
               pt_desc2.
            else
            display
               " " @ pt_desc1
               " " @ pt_desc2.

            for first woc_ctrl
               fields( woc_domain woc_auto_nbr woc_nbr woc_wcmmts)
             where woc_ctrl.woc_domain = global_domain no-lock:
            end. /* FOR FIRST WOC_CTRL */

            if wo_cmtindx > 0
               or (available woc_ctrl and woc_wcmmts) then
               wocmmts = yes.
            else
               wocmmts = no.

            if wo_joint_type <> "" then do:
               /* NUMERIC WO_JOINT_TYPE RETURNS ALPHA CODE, LABEL */
               {gplngn2a.i
                  &file     = ""wo_mstr""
                  &field    = ""wo_joint_type""
                  &code     = wo_joint_type
                  &mnemonic = joint_code
                  &label    = joint_label}
            end.
            else do:
               assign
                  joint_code = ""
                  joint_label = "".
            end.

            display
               wo_nbr
               wo_lot
               wo_part
               wo_type
               wo_site
               joint_label
            with frame a.

            display
               wo_qty_ord
               wo_qty_comp
               wo_qty_rjct
               wo_ord_date
               wo_rel_date
               wo_due_date
               wo_status
               wo_so_job
               wo_vend
               wo_yield_pct
               wo_site
               wo_routing
               wo_bom_code
               wo_rmks
               wocmmts
               wo_var
            with frame b.

         end.

      end.

   end. /* TRANSACTION */

   joint_type = "".

   do transaction:

      /* ADD/MOD/DELETE */
      if available wo_mstr then release wo_mstr.

      wonbr = "".
      wolot = "".
/* ss 20070626 - b */
/*
      if input wo_nbr <> "" and
         input wo_lot <> ""
         then
      find wo_mstr no-lock use-index wo_lot
using  wo_lot and wo_nbr where wo_mstr.wo_domain = global_domain  no-error.

      if input wo_nbr = "" and input wo_lot <> "" then
find wo_mstr no-lock use-index wo_lot using  wo_lot where wo_mstr.wo_domain =
global_domain  no-error.

      if input wo_nbr <> "" and input wo_lot = "" then
      find first wo_mstr no-lock use-index wo_nbr
using  wo_nbr where wo_mstr.wo_domain = global_domain  no-error.

      if not available wo_mstr then
         if input wo_lot <> "" then
find wo_mstr no-lock use-index wo_lot using  wo_lot where wo_mstr.wo_domain =
global_domain  no-error.
*/
      if input wo_nbr <> "" and
         input wo_lot <> ""
         then
      find wo_mstr no-lock use-index wo_lot
			using  wo_lot and wo_nbr where wo_mstr.wo_domain = global_domain  no-error.

      if input wo_nbr = "" and input wo_lot <> "" then
			find wo_mstr no-lock use-index wo_lot using  wo_lot where wo_mstr.wo_domain =	
			global_domain  no-error.

/* ss 20070626 - e */

      if available wo_mstr then do:

         /* PREVENT ACCESS TO PROJECT ACTIVITY RECORDING WORKORDERS */
         if wo_fsm_type = "PRM" then do:
            {pxmsg.i &MSGNUM=3426 &ERRORLEVEL=3}
            /* CONTROLLED BY PRM MODULE */
            undo mainloop, retry mainloop.
         end.

         /* PREVENT ACCESS TO CALL ACTIVITY RECORDING WORK ORDERS */
         if wo_fsm_type = "FSM-RO" then do:
            {pxmsg.i &MSGNUM=7492 &ERRORLEVEL=3}
            /* FIELD SERVICE CONTROLLED.  */
            undo mainloop, retry mainloop.
         end.

         if wo_nbr <> input wo_nbr and input wo_nbr <> "" then do:
            {pxmsg.i &MSGNUM=508 &ERRORLEVEL=3}
            /* LOT NUMBER ENTERED BELONGS TO DIFFERENT WORK ORDER.*/
            undo mainloop, retry mainloop.
         end.

         wolot = wo_lot.

         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         wo_part no-lock no-error.

         if available pt_mstr then
         display
            pt_desc1
            pt_desc2
         with frame a.
         else
         display
            " " @ pt_desc1
            " " @ pt_desc2
         with frame a.

         if wo_joint_type <> "" then do:

            /* NUMERIC WO_JOINT_TYPE RETURNS ALPHA CODE & LABEL */
            {gplngn2a.i
               &file     = ""wo_mstr""
               &field    = ""wo_joint_type""
               &code     = wo_joint_type
               &mnemonic = joint_code
               &label    = joint_label}

            if wo_joint_type = "5" then
               base_lot = wo_lot.
            else
               base_lot = wo_base_id.

         end.

         else do:
            assign
               joint_code = ""
               joint_label = "".
         end.

         display
            joint_label
         with frame a.

         if wo_type = "c" and wo_nbr = "" then do:
            /* WORK ORDER TYPE IS CUMULATIVE */
            {pxmsg.i &MSGNUM=5123 &ERRORLEVEL=3}
            undo mainloop, retry mainloop.
         end.

      end.

      else do:  /* NOT AVAILABLE WO_MSTR */

         if input wo_nbr <> ""
            and input wo_nbr <> ?
            {&WOWOMT-P-TAG3}
            then
            wonbr = input wo_nbr.
            {&WOWOMT-P-TAG4}
         else do:
            find first woc_ctrl  where woc_ctrl.woc_domain = global_domain
            no-lock no-error.
            if not woc_auto_nbr then
               undo mainloop, retry mainloop.
            {mfnctrl.i "woc_ctrl.woc_domain = global_domain"
            "woc_ctrl.woc_domain" "wo_mstr.wo_domain = global_domain" woc_ctrl
            woc_nbr wo_mstr wo_nbr wonbr}
            {&WOWOMT-P-TAG5}
         end.

         if input wo_lot <> ""
            and input wo_lot <> ?
            then
            wolot = input wo_lot.
         else do:
            /* GET NEXT LOT NUMBER */
            {mfnxtsq.i  "wo_mstr.wo_domain = global_domain and " wo_mstr wo_lot
            woc_sq01 wolot}
         end.

         release woc_ctrl.

         if wonbr = "" or wolot = "" then
            undo, retry.

         display
            wonbr @ wo_nbr
            wolot @ wo_lot
         with frame a.

/* ss 20071030 */ global_addr = wolot.

      end.

   end. /* TRANSACTION */

   do transaction:

      if keyfunction (lastkey) = "END-ERROR" then
         next mainloop.

      if available wo_mstr and wo_joint_type = "" then do:

         /* FIND ON wo_mstr TO REFRESH THE RECORD BUFFER */
         find first wo_mstr
            where wo_domain = global_domain
            and   wo_lot    = wolot
         exclusive-lock no-error.
         if available wo_mstr
         then
            wo_recno = recid(wo_mstr).

      end.

      if (available wo_mstr and wo_joint_type <> "")
         or (not available wo_mstr and joint_type <> "")
      then do:
         if available wo_mstr then do:
            wonbr = wo_nbr.
            wolot = wo_lot.
         end.
         /* LOCK ALL THE JOINT WOS */
         /* IF ANY IN GROUP ARE LOCKED UNDO & ISSUE MESSAGE */
         /* RECORD IS LOCKED. PLEASE TRY AGAIN LATER */
         {gplock1.i &domain="wo_mstr.wo_domain = global_domain and "
            &file-name="wo_mstr"
            &group-criteria="wo_nbr = wonbr and wo_type = """""
            &find-criteria="wo_lot = wolot"
            &undo-block=mainloop
            &retry="retry mainloop"
            &record-id=wo_recno}
         /* gplock1.i also done later in wowomtc.p */

      end.

      if keyfunction(lastkey) = "END-ERROR" then
         undo mainloop, retry.

      if available wo_mstr then do:
         {gprun.i ""gpsiver.p""
            "(input wo_site, input ?, output return_int)"}
         if return_int = 0 then do:
            display
               wo_nbr
               wo_lot
               wo_part
               wo_type
               wo_site
            with frame a.
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
            /* USER DOES NOT HAVE ACCESS TO THIS SITE*/
            undo mainloop, retry mainloop.
         end.
      end.

      if not available wo_mstr then do with frame a:

         clear frame b no-pause.

         assign
            wo_recno = ?
            wopart = ""
            screen_used = yes
            undoleavemain = no.

         /* CREATE WO_MSTR, SET PART TYPE & SITE, AND TAKE DEFAULTS */
         {gprun.i ""wowomtc.p""}

         if undoleavemain then
            undo mainloop, leave mainloop.
         if undo_all then
            undo mainloop, retry mainloop.

         find wo_mstr exclusive-lock where recid(wo_mstr) = wo_recno.
         find pt_mstr no-lock where recid(pt_mstr) = pt_recno.

      end.

      assign
         prev_status = wo_status
         prev_ord = wo_ord_date
         prev_release = wo_rel_date
         prev_due = wo_due_date
         prev_qty = wo_qty_ord
         prev_site = wo_site
         prev_routing = wo_routing
         prev_bomcode = wo_bom_code.

      if new_wo and index("R",wo_type) > 0 then wo_status = "A".
      if new_wo and index("E",wo_type) > 0 then wo_status = "R".

      /*DETERMINE COSTING METHOD*/
      {gprun.i ""csavg01.p""
         "(input wo_part,
           input wo_site,
           output glx_set,
           output glx_mthd,
           output cur_set,
           output cur_mthd)"}

      if glx_mthd = "AVG" then
         wo_var = no.

      /* SET GLOBAL ITEM VARIABLE */
      assign
         prev_mthd = glx_mthd
         del-yn = no
         global_part = wo_part
         global_site = wo_site.

      /* SET COMMENT DEFAULT FIELD      */
      if new_wo then do:
         if available woc_ctrl then wocmmts = woc_wcmmts.
      end.
      else do:
         find first woc_ctrl  where woc_ctrl.woc_domain = global_domain no-lock
         no-error.
         if wo_cmtindx > 0 or (available woc_ctrl and woc_wcmmts)
            then
            wocmmts = yes.
         else
            wocmmts = no.
         release woc_ctrl.
      end.

      display
         wo_nbr
         wo_lot
         wo_part
         wo_type
         wo_site
      with frame a.

      display
         wo_qty_ord
         wo_qty_comp
         wo_qty_rjct
         wo_ord_date
         wo_rel_date
         wo_due_date
         wo_status
         wo_so_job
         wo_vend
         wo_yield_pct
         wo_site
         wo_routing
         wo_bom_code
         wo_rmks
         wocmmts
         wo_var
      with frame b.

      /* UPDATE FRAME B */
      {gprun.i ""wowomtj.p""}

      if undo_all then
         undo mainloop, retry mainloop.

      find wo_mstr exclusive-lock where recid(wo_mstr) = wo_recno.

      /* UPDATE MRP */
      {gprun.i ""wowomta5.p"" "(input wo_recno)"}

   end. /* TRANSACTION */

   updt_subsys = yes.

   /* JOINT WORK ORDER */
   if wo_joint_type <> "" and wo_status <> "B" and not del-yn
   then do:

      hide frame a no-pause.
      hide frame b no-pause.

      /* NEW JOINT WO OR (RE-EXPLODE) STATUS CHANGE */
      if (new_wo and not add_2_joint) or
         (wo_status = "F" and prev_status <> "F") or
         (wo_bom_code <> prev_bomcode) or
         ((index("PBF",prev_status) > 0 and index("FEAR",wo_status) > 0)
         and prev_status <> wo_status)
      then do:

         /* CREATE/RE-ESTABLISH ITS EFFECTIVE JOINT WOS.*/
         {gprun.i ""wowomtf.p""}

         find wo_mstr where recid(wo_mstr) = wo_recno.

         if new_wo and wo_joint_type = "5" then
         do for wo_mstr1:

            find first wo_mstr1 no-lock  where wo_mstr1.wo_domain =
            global_domain and
                       wo_mstr1.wo_nbr = wo_mstr.wo_nbr and
                       wo_mstr1.wo_type = "" and
                       wo_mstr1.wo_joint_type = "1"
            no-error.
            if not available wo_mstr1 then do:
               undo_all = yes.
               /* JOINT PRODUCT NOT PRODUCED BY BOM/FORMULA */
               {pxmsg.i &MSGNUM=6546 &ERRORLEVEL=3}
            end.
         end.

         if undo_all then do:

            if new_wo then do:
               /* FAILED VALIDATION, DEL THIS WO AND ITS JOINT WOS */
               del-joint = yes.
               {gprun.i ""wowomte.p""}
            end.

            else do transaction:
               assign
                  wo_site = prev_site
                  wo_ord_date = prev_ord
                  wo_due_date = prev_due
                  wo_rel_date = prev_release
                  wo_qty_ord = prev_qty
                  wo_routing = prev_routing
                  wo_bom_code = prev_bomcode
                  wo_status = prev_status.
            end.

            view frame a.
            view frame b.

            undo mainloop, retry mainloop.

         end.

      end.

      /* Qty or dates or non re-explode status change */
      else do:

         if prev_status <> wo_status
            or (joint_qtys and (prev_qty <> wo_qty_ord))
            or (joint_dates and
            (prev_ord     <> wo_ord_date) or
            (prev_release <> wo_rel_date) or
            (prev_due     <> wo_due_date))
         then do:

            /* Update other joint WOs with status, qty & dates */
            wo_recno = recid(wo_mstr).
            {gprun.i ""wowomti.p""}

            if undo_all then do:

               if critical_flg then do transaction:

                  /* UPDATE OTHER JOINT WOS WITH STATUS */
                  assign
                     wo_status    = "E"
                     critical_flg = no
                     wo_recno     = recid(wo_mstr).

                  {gprun.i ""wowomti.p""}

                  view frame a.

                  display
                     wo_status
                  with frame b.

               end.

               view frame b.

               undo, retry.

            end.

         end.

      end.

      /* DISPLAY/UPDATE LIST OF JOINT ORDERS */
      if wo_joint_type <> "" and wo_status <> "C" then do:
         wo_recno = recid(wo_mstr).
         {gprun.i ""wowomth.p""}
      end.

      view frame a.
      view frame b.

      if wo_recno = ? then do:
         updt_subsys = no.
         clear frame a no-pause.
         clear frame b no-pause.
      end.

      /* CHANGED NO-LOCK TO EXCLUSIVE-LOCK TO ALLOW UPDATE OF */
      /* JOINT WOS WHEN CRITICAL COMPONENT IS NOT AVAILABLE   */
      else do transaction:
         find wo_mstr exclusive-lock where recid(wo_mstr) = wo_recno.

         display wo_nbr wo_lot wo_part wo_type wo_site joint_label
         with frame a.
         display wo_qty_ord wo_qty_comp wo_qty_rjct
            wo_ord_date wo_rel_date wo_due_date
            wo_status wo_so_job wo_vend wo_yield_pct
            wo_site wo_routing wo_bom_code wo_rmks wocmmts wo_var
         with frame b.
      end.

   end.

   if not del-yn and updt_subsys then do:

      joint_type = wo_joint_type.

      /* ADD WO BILL, WO ROUTING, ON ORDER, ETC */
      {gprun.i ""wowomta.p""}

      /* AT THIS POINT, BASE PROCESS WORK ORDERS WO_REL_DATE &      */
      /* WO_DUE_DATE WILL HAVE NON-BLANK DATE(AFTER RECALCULATION), */
      /* WHEN ? IS ENTERED IN WO_REL_DATE OR/AND WO_DUE_DATE OF THE */
      /* ACTIVE WORK ORDER.                                         */
      if joint_dates then
         run sync-release-due-dates.

      display
         wo_rel_date
         wo_due_date
      with frame b.

      if undo_all then do:

         if wo_status = "A" then do:
            /*CRITICAL PART NOT AVAILABLE, WORK ORDER NOT ALLOCATED.*/
            {pxmsg.i &MSGNUM=4985 &ERRORLEVEL=2 &MSGARG1=wo_nbr}
         end.
         else do:
            if wo_joint_type = "" then do:
               /*CRITICAL PART NOT AVAILABLE, WORK ORDER NOT RELEASED*/
               {pxmsg.i &MSGNUM=4984 &ERRORLEVEL=2 &MSGARG1=wo_nbr}
            end.
            else do transaction:
               /*CRITICAL ITEM NOT AVAIL, STATUS CHANGED FROM R TO E */
               {pxmsg.i &MSGNUM=6547 &ERRORLEVEL=2}
               wo_status = "E".
               display
                  wo_status
               with frame b.
               /* UPDATE OTHER JOINT ORDER WITH STATUS */
               wo_recno = recid(wo_mstr).
               {gprun.i ""wowomti.p""}
            end.
         end.

         /* Item in work order that is not available */
         {pxmsg.i &MSGNUM=989 &ERRORLEVEL=1 &MSGARG1=critical-part}

      end.

      if any_issued then do:
         /* WORK ORDER COMPONENTS HAVE BEEN ISSUED */
         {pxmsg.i &MSGNUM=529 &ERRORLEVEL=4}
      end.

      if any_feedbk then do:
         /* LABOR FEEDBACK HAS BEEN REPORTED */
         {pxmsg.i &MSGNUM=554 &ERRORLEVEL=4}
      end.

      if undo_all or any_issued or any_feedbk
         then do transaction:

         wo_status = prev_status.

         {gprun.i ""wowomta5.p"" "(input wo_recno)"}

         if any_issued or any_feedbk then
         assign
            wo_site = prev_site
            wo_ord_date = prev_ord
            wo_rel_date = prev_release
            wo_due_date = prev_due
            wo_qty_ord = prev_qty
            wo_routing = prev_routing
            wo_bom_code = prev_bomcode.

         clear frame b no-pause.
         view frame b.

         next mainloop.

      end.

   end.

   /* DELETE WORK ORDER AND DETAIL */
   if del-yn and wo_wip_tot = 0 then do:

      /* DELETE FUNCTION MOVED TO wowomte.p */
      {gprun.i ""wowomte.p""}

      clear frame b no-pause.
      clear frame a no-pause.

      del-yn = no.

   end.

   /*
   * Get the Q/LinQ application id of the document being
   * used when applicable.
   */
   run logExternalApplication in this-procedure.

   /* ADDED TO RESOLVE LOCKING PROBLEM */
   release wo_mstr.

end.

status input.

PROCEDURE sync-release-due-dates:
/*------------------------------------------------------------------------------
Purpose:    To synchronise release and due dates betweeen Base process and
Co/By Product Work Orders.
Parameters: None
Notes:
------------------------------------------------------------------------------*/
   define buffer b1-womstr for wo_mstr.
   define buffer b2-womstr for wo_mstr.

   find first b2-womstr  where b2-womstr.wo_domain = global_domain and
      b2-womstr.wo_nbr        = wo_mstr.wo_nbr
      and b2-womstr.wo_joint_type = "5"
   no-lock no-error.

   if available b2-womstr
      and (b2-womstr.wo_rel_date <> ? or
      b2-womstr.wo_due_date <> ?)
   then do:

      for each b1-womstr exclusive-lock
             where b1-womstr.wo_domain = global_domain and  b1-womstr.wo_nbr
                = b2-womstr.wo_nbr
            and b1-womstr.wo_lot        <> b2-womstr.wo_lot
            and b1-womstr.wo_joint_type <> "":

         if b1-womstr.wo_rel_date <> b2-womstr.wo_rel_date then
            b1-womstr.wo_rel_date = b2-womstr.wo_rel_date.

         if b1-womstr.wo_due_date <> b2-womstr.wo_due_date then
            b1-womstr.wo_due_date = b2-womstr.wo_due_date.

      end. /* FOR EACH B1-WOMSTR */

   end. /* IF AVAILABLE B2-WOMSTR */

END PROCEDURE.

PROCEDURE logExternalApplication:

/*------------------------------------------------------------------------------
Purpose:    To log the work order and the associated external application
in qad_wkfl if it was created in API mode
Parameters: None
Notes:      /*N14F*/
------------------------------------------------------------------------------*/

{mgqqapp.i "wo_owner"}

/*
* Store the Q/LinQ Application ID in the wo__qadc01 field if wo_owner isn't
* null or blank for reference in the wow.t trigger. This field is used to
* trigger the creation of the RECEIVE_PRODORDER OAGIS BOD.
*/
if wo_owner <> ? and wo_owner <> "" then
   assign
      wo_mstr.wo_app_owner = wo_owner.

END PROCEDURE.
