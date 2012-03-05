/* rewomt.p - CUMULATIVE REPETITIVE ORDER MAINTENANCE                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9.2.6 $                                                     */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0      LAST EDIT: 06/19/86      MODIFIED BY: EMB         */
/* REVISION: 1.0      LAST EDIT: 05/12/86      MODIFIED BY: pml         */
/* REVISION: 2.0      LAST EDIT: 01/29/87      MODIFIED BY: emb *A19*   */
/* REVISION: 2.0      LAST EDIT: 02/18/87      MODIFIED BY: emb *A25*   */
/* REVISION: 2.0      LAST EDIT: 03/12/87      MODIFIED BY: EMB *A41*   */
/* REVISION: 2.0      LAST EDIT: 05/28/87      MODIFIED BY: EMB *A57*   */
/* REVISION: 2.0      LAST EDIT: 07/30/87      MODIFIED BY: EMB *A75*   */
/* REVISION: 2.0      LAST EDIT: 10/05/87      MODIFIED BY: EMB *A96*   */
/* REVISION: 2.0      LAST EDIT: 12/15/87      MODIFIED BY: EMB *A109*  */
/* REVISION: 4.0      LAST EDIT: 01/04/87      MODIFIED BY: pml *A119*  */
/* REVISION: 4.0      LAST EDIT: 01/04/88      MODIFIED BY: emb *A120*  */
/* REVISION: 4.0      LAST EDIT: 03/02/88      MODIFIED BY: emb *A181*  */
/* REVISION: 4.0      LAST EDIT: 03/23/88      MODIFIED BY: RL  *A171*  */
/* REVISION: 4.0      LAST EDIT: 04/13/88      MODIFIED BY: flm *A199*  */
/* REVISION: 4.0      LAST EDIT: 05/03/88      MODIFIED BY: flm *A222*  */
/* REVISION: 5.0      LAST EDIT: 12/15/88      MODIFIED BY: emb *B001*  */
/* REVISION: 4.0      LAST EDIT: 01/05/89      MODIFIED BY: EMB *A584*  */
/* REVISION: 5.0      LAST EDIT: 01/20/89      MODIFIED BY: pml *B019*  */
/* REVISION: 5.0      LAST EDIT: 03/07/89      MODIFIED BY: emb *B061*  */
/* REVISION: 5.0      LAST EDIT: 06/23/89      MODIFIED BY: MLB *B159*  */
/* REVISION: 6.0      LAST EDIT: 07/06/90      MODIFIED BY: EMB *D040*  */
/* REVISION: 6.0      LAST EDIT: 09/25/90      MODIFIED BY: SMM *D072*  */
/* REVISION: 6.0      LAST EDIT: 05/08/91      MODIFIED BY: emb *D624*  */
/* REVISION: 6.0      LAST EDIT: 08/12/91      MODIFIED BY: emb *D823*  */
/* REVISION: 7.0      LAST EDIT: 10/11/91      MODIFIED BY: emb *F024*  */
/* REVISI0N: 7.0      LAST EDIT: 10/16/91      MODIFIED BY: pma *F003*  */
/* REVISION: 7.0      LAST EDIT: 02/20/92      MODIFIED BY: pma *F217*  */
/* REVISION: 7.0      LAST EDIT: 02/25/92      MODIFIED BY: emb *F227*  */
/* REVISION: 7.0      LAST EDIT: 02/28/92      MODIFIED BY: pma *F085*  */
/* REVISION: 7.0      LAST MODIFIED: 03/09/92           BY: smm *F230*  */
/* REVISION: 7.0      LAST EDIT: 03/23/92      MODIFIED BY: pma *F089*  */
/* REVISION: 7.0      LAST EDIT: 04/29/92      MODIFIED BY: emb *F457*  */
/* REVISION: 7.0      LAST EDIT: 06/23/92      MODIFIED BY: emb *F677*  */
/* REVISION: 7.0      LAST EDIT: 07/02/92      MODIFIED BY: emb *F729*  */
/* Revision: 7.3        Last edit: 09/27/93             By: jcd *G247*  */
/* REVISION: 7.3      LAST EDIT: 11/05/92      MODIFIED BY: emb *G689*  */
/* REVISION: 7.3      LAST EDIT: 08/11/93      MODIFIED BY: ram *GE11*  */
/* REVISION: 7.2      LAST EDIT: 07/14/94      MODIFIED BY: ais *FP42*  */
/* REVISION: 7.2      LAST EDIT: 09/01/94      MODIFIED BY: ljm *FQ67*  */
/* REVISION: 8.5      LAST EDIT: 10/24/94      MODIFIED BY: mwd *J034*  */
/* REVISION: 7.3      LAST EDIT: 10/31/94      MODIFIED BY: WUG *GN76*  */
/* REVISION: 8.5      LAST EDIT: 04/26/95      MODIFIED BY: sxb *J04D*  */
/* REVISION: 8.5      LAST EDIT: 06/16/95      MODIFIED BY: rmh *J04R*  */
/* REVISION: 8.5      LAST EDIT: 09/18/95      MODIFIED BY: kxn *J07Y*  */
/* REVISION: 7.3      LAST EDIT: 11/14/95      MODIFIED BY: rvw *G1CZ*  */
/* REVISION: 8.5      LAST EDIT: 05/14/96      BY: *G1S6* Julie Milligan*/
/* REVISION: 8.5      LAST EDIT: 07/26/96      BY: *J10X* Markus Barone */
/* REVISION: 8.5      LAST EDIT: 01/07/97      BY: *H0QQ* Julie Milligan */
/* REVISION: 8.5    LAST MODIFIED: 01/17/97  BY: *G2JV* Julie Milligan       */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 06/06/00   BY: *L0YT* Vandna Rohira     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb               */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* $Revision: 1.9.2.6 $    BY: Irine D'Mello  DATE: 09/10/01  ECO: *M164*    */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rewomt_p_1 "Created"
/* MaxLen: Comment: */

&SCOPED-DEFINE rewomt_p_2 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE rewomt_p_3 "End"
/* MaxLen: Comment: */

&SCOPED-DEFINE rewomt_p_4 "Post variances at labor entry"
/* MaxLen: Comment: */

&SCOPED-DEFINE rewomt_p_5 "Start"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*          REVISED FORM AND DATA ENTRY IN ORDER TO BRING REWOMT        */
/*          BACK IN LINE WITH WOWOMT.P                                  */

{mfdtitle.i "b+ "}
{pxmaint.i}

{pxphdef.i wocmnrtn}

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
define new shared variable del-yn like mfc_logical initial no.
define new shared variable deliv like wod_deliver.
define new shared variable cmtindx like wo_cmtindx.
define new shared variable new_wo like mfc_logical initial no.
define new shared variable prev_site like wo_site.
define new shared variable undo_all like mfc_logical no-undo.
define new shared variable del-joint like mfc_logical initial no.

define variable i         as integer.
define variable nonwdays  as integer.
define variable workdays  as integer.
define variable overlap   as integer.
define variable know_date as date.
define variable find_date as date.
define variable interval  as integer.
define variable frwrd as integer.
define variable yn like mfc_logical initial no.
define variable wonbr like wo_nbr.
define variable wolot like wo_lot.
define variable wocmmts like woc_wcmmts label {&rewomt_p_2}.
define variable prev_routing like wo_routing.
define variable prev_bomcode like wo_bom_code.
define variable msg-type as integer.
define variable glx_mthd like cs_method.
define variable glx_set like cs_set.
define variable cur_mthd like cs_method.
define variable cur_set like cs_set.
define variable prev_mthd like cs_method.
define variable ptstatus like pt_status.
define variable ok like mfc_logical no-undo.
define variable prompt-routing like mfc_logical no-undo.
define variable l_errorno as   integer          no-undo.

define buffer simstr for si_mstr.

if can-find(first qad_wkfl where qad_key1 = "WO-CLOSE")
then do:
   {pxmsg.i &MSGNUM=1361 &ERRORLEVEL=1}
   /* OLD WORK ORDER DATA STORAGE HAS BEEN DETECTED IN QAD_WKFL */
   {pxmsg.i &MSGNUM=1362 &ERRORLEVEL=1}
   /* PLEASE RUN "UTQADWO.P" BEFORE EXECUTING THIS FUNCTION     */
   pause.
   hide message no-pause.
   return.
end.

find first woc_ctrl no-lock no-error.
if available woc_ctrl
then
   wocmmts = woc_wcmmts.

find first clc_ctrl no-lock no-error.
if not available clc_ctrl
then do:
   {gprun.i ""gpclccrt.p""}
   find first clc_ctrl no-lock.
end.

find mfc_ctrl
   where mfc_field = "rpc_using_new" no-lock no-error.

if available mfc_ctrl
   and mfc_logical = true
then do:
   {pxmsg.i &MSGNUM=5122 &ERRORLEVEL=3}
   message.
   message.
   undo, leave.
end.

/* DISPLAY SELECTION FORM */
eff_date = today.

form
   wo_nbr         colon 25
   wo_lot
   wo_part        colon 25
   pt_desc1       at 47 no-label
   wo_type        colon 25
   pt_desc2       at 47 no-label
   wo_site        colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   wo_qty_ord     colon 25
   wo_ord_date    colon 55 label {&rewomt_p_1}
   wo_qty_comp    colon 25
   wo_rel_date    colon 55 label {&rewomt_p_5}
   wo_qty_rjct    colon 25
   wo_due_date    colon 55 label {&rewomt_p_3}
   skip(1)
   wo_status      colon 25
   wo_site        colon 55
   wo_so_job      colon 25
   wo_line        colon 55
   wo_vend        colon 25
   wo_routing     colon 55
   wo_yield_pct   colon 25
   wo_bom_code    colon 55
   skip(1)
   wo_rmks        colon 25
   wocmmts        colon 25
   wo_var         colon 62 label {&rewomt_p_4}
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
         prev_release = ?
         prev_due = ?
         prev_qty = 0
         leadtime = 0
         new_wo = no.

      prompt-for wo_nbr wo_lot
      editing:
         if frame-field = "wo_nbr"
         then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i wo_mstr wo_type_nbr "wo_type = ""C"""
               wo_nbr "input wo_nbr"}

            if recno <> ?
            then do:

               find pt_mstr
                  where pt_part = wo_part
                  no-lock no-error no-wait.

               if available pt_mstr
               then
                  display pt_desc1 pt_desc2.
               else
                  display " " @ pt_desc1 " " @ pt_desc2.
               display
                  wo_nbr
                  wo_lot
                  wo_part
                  wo_type
                  wo_site
               with frame a.

               if wo_cmtindx > 0
                  or (available woc_ctrl and woc_wcmmts)
               then
                  wocmmts = yes.
               else
                  wocmmts = no.

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
                  wo_line
                  wo_rmks
                  wocmmts
                  wo_var
               with frame b.
            end.
         end.

         else if frame-field = "wo_lot"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i wo_mstr wo_type_nbr "wo_type = ""C""
                      and wo_nbr = wo_nbr" wo_lot "input wo_lot"}

            if recno <> ?
            then do:

               find pt_mstr where pt_part = wo_part
                  no-lock no-error no-wait.

               if available pt_mstr
               then
                  display pt_desc1 pt_desc2.
               else
                  display " " @ pt_desc1 " " @ pt_desc2.
               display
                  wo_nbr
                  wo_lot
                  wo_part
                  wo_type
                  wo_site
               with frame a.

               if wo_cmtindx > 0
                  or (available woc_ctrl and woc_wcmmts)
               then
                  wocmmts = yes.
               else
                  wocmmts = no.

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
                  wo_line
                  wo_rmks
                  wocmmts
                  wo_var
               with frame b.
            end.
         end.

         else do:
            readkey.
            apply lastkey.
         end.
      end.  /* PROMPT-FOR...EDITING */
   end. /* TRANSACTION */

   do transaction:

      /* ADD/MOD/DELETE */
      if available wo_mstr
      then
         release wo_mstr.

      assign
         wonbr = ""
         wolot = "".

      if input wo_nbr <> ""
         and input wo_lot <> ""
      then
         find wo_mstr
            use-index wo_lot
            using wo_lot and wo_nbr
         no-error.

      if input wo_nbr = ""
         and input wo_lot <> ""
      then
         find wo_mstr
            use-index wo_lot
            using wo_lot no-error.

      if input wo_nbr <> ""
        and input wo_lot = ""
      then
         find first wo_mstr
            use-index wo_type_nbr
            where wo_type = "C"
              and wo_nbr = input wo_nbr no-error.

      if not available wo_mstr
      then
         if input wo_lot <> ""
         then
            find wo_mstr
               use-index wo_lot
               using wo_lot no-error.

      if not available wo_mstr
      then do:

         if input wo_nbr <> ""
         then
            wonbr = input wo_nbr.

         else do:

            find first woc_ctrl no-lock no-error.
            if not available woc_ctrl
            then
               create woc_ctrl.
            if not woc_auto_nbr
            then
               undo mainloop, retry mainloop.

            {mfnctrl.i woc_ctrl woc_nbr wo_mstr wo_nbr wonbr}

         end.

         if input wo_lot <> ""
         then
            wolot = input wo_lot.

         else do:
            /* GET NEXT LOT NUMBER */
            {mfnxtsq.i wo_mstr wo_lot woc_sq01 wolot}
         end.

         if wonbr = "" or wolot = ""
         then
            undo, retry.
         display wonbr @ wo_nbr wolot @ wo_lot with frame a.
      end.

      else do:
         /* wo_mstr IS AVAILABLE */
         if wo_nbr <> input wo_nbr
            and input wo_nbr <> ""
         then do:

            {pxmsg.i &MSGNUM=508 &ERRORLEVEL=3}
            /*  LOT NUMBER ENTERED BELONGS TO DIFFERENT WORK ORDER.*/
            undo mainloop, retry mainloop.
         end.

         wo_recno = recid(wo_mstr).
         if wo_type <> "C"
         then do:

            {pxmsg.i &MSGNUM=555 &ERRORLEVEL=3}
            /*  INVALID ORDER TYPE (NOT A CUMULATIVE ORDER) */
            undo mainloop, retry mainloop.
         end.

         {gprun.i ""gpsiver.p""
            "(input wo_site, input ?, output return_int)"}

         if return_int = 0
         then do:

            display wo_nbr wo_lot wo_part wo_type wo_site
            with frame a.
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
            /* USER DOES NOT HAVE ACCESS TO THIS SITE */
            undo mainloop, retry mainloop.
         end.

         wolot = wo_lot.
         {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1}
         find pt_mstr where pt_part = wo_part no-lock no-error.
         if available pt_mstr
         then
            leadtime = pt_mfg_lead.
      end.
   end. /* TRANSACTION */

   do transaction:

      find wo_mstr
         exclusive-lock
         use-index wo_lot
         where wo_lot = wolot no-error.

      if not available wo_mstr
      then do with frame a:

         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
         new_wo = yes.
         create wo_mstr.
         assign
            wo_nbr = wonbr
            wo_lot = wolot
            wo_status = "R"
            wo_type   = "C"
            wo_recno  = recid(wo_mstr)
            wo_lot_rcpt  = clc_relot_rcpt.

         display wo_nbr wo_lot.
         setitem:
         do on error undo, retry:
            set wo_part wo_site
            editing:

               if frame-field = "wo_part"
               then do:

                  /* FIND NEXT/PREVIOUS RECORD */
                  {mfnp.i pt_mstr wo_part pt_part wo_part
                     pt_part pt_part}

                  if recno <> ?
                  then
                     display
                        pt_part @ wo_part
                        pt_desc1
                        pt_desc2.
               end.

               else do:
                  readkey.
                  apply lastkey.
               end.
            end. /* SET...EDITING */

            {gprun.i ""gpsiver.p""
               "(input wo_site, input ?, output return_int)"}

            if return_int = 0
            then do:

               {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3} /* USER DOES NOT HAVE  */
               /* ACCESS TO THIS SITE */
               next-prompt wo_site with frame a.
               undo setitem, retry.
            end.

            assign wo_part.

            find pt_mstr no-lock
               where pt_part = wo_part no-error.

            if available pt_mstr
            then do:

               assign
                  ptstatus = pt_status
                  substring(ptstatus,9,1) = "#".

               if can-find(isd_det where isd_status = ptstatus
                  and isd_tr_type = "ADD-RE")
               then do:
                  {pxmsg.i &MSGNUM=358 &ERRORLEVEL=3 &MSGARG1=pt_status}
                  undo setitem, retry.
               end.

               assign
                  leadtime = pt_mfg_lead
                  wo_part = pt_part
                  wo_yield_pct = pt_yield_pct
                  wo_routing = pt_routing
                  wo_bom_code = pt_bom_code.

               if wo_site = ""
               then
                  wo_site = pt_site.

               find ptp_det no-lock
                  where ptp_part = wo_part
                    and ptp_site = wo_site no-error.

               if available ptp_det
               then
                  assign
                     wo_yield_pct = ptp_yld_pct
                     leadtime = ptp_mfg_lead
                     wo_routing = ptp_routing
                     wo_bom_code = ptp_bom_code.

               find first woc_ctrl no-lock.
               wo_var = woc_var.

            end.  /* IF AVAILABLE PT_MSTR */

            else do:

               {pxmsg.i &MSGNUM=17 &ERRORLEVEL=3}
               undo, retry.
            end.
         end.  /* SETITEM: DO: */

         assign
            wo_ord_date = today
            wo_rel_date = today.

         find first woc_ctrl no-lock.
         wo_var = woc_var.

         /* ASSIGN DEFAULT RECEIPT STATUS AND ACTIVE FLAG */
         {pxrun.i &PROC    = 'get_default_wo_rctstat'
                  &PROGRAM = 'wocmnrtn.p'
                  &HANDLE  = ph_wocmnrtn
                  &PARAM   = "(
                               input  wo_part,
                               input  wo_site,
                               output wo_rctstat,
                               output wo_rctstat_active,
                               output l_errorno
                              )"
         }

      end. /* IF NOT AVAILABLE WO_MSTR */

      find pt_mstr no-lock
         where pt_part = wo_part no-error.

      assign
         global_part = wo_part
         prev_status = wo_status
         prev_release = wo_rel_date
         prev_due = wo_due_date
         prev_qty = wo_qty_ord
         prev_site = wo_site
         prev_routing = wo_routing
         prev_bomcode = wo_bom_code.

      /*DETERMINE COSTING METHOD*/
      {gprun.i ""csavg01.p"" "(input global_part,
                               input prev_site,
                               output glx_set,
                               output glx_mthd,
                               output cur_set,
                               output cur_mthd)"
      }

      if glx_mthd = "AVG"
      then
         wo_var = no.

      assign
         prev_mthd = glx_mthd
         recno = recid(pt_mstr)
         wo_recno = recid(wo_mstr)
         ststatus = stline[2].

      status input ststatus.
      del-yn = no.

      /* SET GLOBAL ITEM VARIABLE */
      assign
         global_part = wo_part
         global_site = wo_site.

      display
         wo_nbr
         wo_lot
         wo_part
         wo_type
         wo_site
      with frame a.

      /* COMMENTS FLAG SHOULD BE DEFAULTED FROM CONTROL FILE */

      for first woc_ctrl
         fields(woc_auto_nbr woc_nbr woc_var woc_wcmmts)
         no-lock:
      end. /* FOR FIRST WOC_CTRL */

      if wo_cmtindx > 0
         or (available woc_ctrl and woc_wcmmts)
      then
         wocmmts = yes.
      else
         wocmmts = no.
      release woc_ctrl.

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
         wo_line
         wo_rmks
         wocmmts
         wo_var
      with frame b.

      if available pt_mstr
      then
         display
            pt_desc1
            pt_desc2
         with frame a.
      else
         display
            " " @ pt_desc1
            " " @ pt_desc2
         with frame a.

      detail-loop:
      do on error undo, retry with frame b:

         set
            wo_rel_date
            wo_status
            wo_so_job
            wo_vend
            wo_site
            wo_line
            wo_routing
            wo_bom_code
            wo_rmks
            wocmmts
            wo_var when (glx_mthd <> "AVG")
            go-on(F5 CTRL-D).

         /* DELETE */
         if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
         then do:

            /* ISSUE WARNING IF QUALITY TEST RESULTS EXIST FOR THIS W/O */
            find first mph_hist
               where mph_lot = wo_lot no-lock no-error.

            if available mph_hist
            then do:

               {pxmsg.i &MSGNUM=7109 &ERRORLEVEL=2 &MSGARG1=mph_part}
               /* QUALITY TEST RESULTS EXIST FOR THIS WORK ORDER FOR ITEM# */
               pause.
            end.

            if wo_wip_tot <> 0
            then do:
               {pxmsg.i &MSGNUM=536 &ERRORLEVEL=3}
               undo.
            end.

            del-yn = yes.
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
            if del-yn = no
            then
               undo.

         end.

         if not del-yn
         then do:

            if wo_ord_date = ?
            then
               wo_ord_date = today.
            if wo_status = ""
            then
               wo_status = prev_status.
            if wo_rel_date = ?
            then
               wo_rel_date = wo_ord_date.

            if index("BFEARC",wo_status) = 0
               or ((index("RE",wo_type) > 0)
               and index("ARC",wo_status) = 0)
               or ((index("F",wo_type) > 0)
               and index("EARC",wo_status) = 0)
            then do:
               {pxmsg.i &MSGNUM=19 &ERRORLEVEL=3}
               /*  INVALID STATUS */
               next-prompt wo_status.
               undo, retry.
            end.

            if index("pfbearc",wo_status) > 0
            then
               wo_status = entry(index("pfbearc",wo_status),"P,F,B,E,A,R,C").

            {gprun.i ""gpsiver.p""
               "(input wo_site, input ?, output return_int)"}

            if return_int = 0
            then do:

               {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3} /* USER DOES NOT HAVE  */
               /* ACCESS TO THIS SITE */
               next-prompt wo_site with frame b.
               undo, retry.
            end.

            if index("PFB",prev_status) = 0
               and index("PFB",wo_status) = 0
               and wo_routing <> prev_routing
            then do:

               {pxmsg.i &MSGNUM=127 &ERRORLEVEL=3}
               next-prompt wo_routing.
               display prev_routing @ wo_routing.
               undo, retry.
            end.

            if index("PFB",prev_status) = 0
               and index("PFB",wo_status) = 0
               and wo_bom_code <> prev_bomcode
            then do:

               {pxmsg.i &MSGNUM=153 &ERRORLEVEL=3}
               next-prompt wo_bom_code.
               display prev_bomcode @ wo_bom_code.
               undo, retry.
            end.

            /* FOR RMA TYPE WORK ORDERS, DON'T PERFORM ROUTING */
            /* AND PRODUCT STRUCTURE CHECKS.                   */
            if wo_fsm_type <> "RMA"
            then do:

               msg-type = 3.
               if index("PFB",prev_status) = 0
                  and index("PFB",wo_status) = 0
               then
                  msg-type = 2.

               {gprun.i ""wortbmv.p""
                                     "(input wo_part,
                                       input wo_site,
                                       input wo_routing,
                                       input wo_bom_code,
                                       input msg-type,
                                       output ok,
                                       output prompt-routing)"}

               if not ok
               then do:

                  if prompt-routing
                  then
                     next-prompt wo_routing.
                  else
                     next-prompt wo_bom_code.
                  undo, retry.
               end.

               if wo_routing = "" and
                  not can-find (first ro_det
                  where ro_routing = wo_part)
               then do:

                  next-prompt wo_routing.
                  /* ROUTING DOES NOT EXISTS */
                  {pxmsg.i &MSGNUM=126 &ERRORLEVEL=3}
                  undo, retry.
               end.
            end.

            if wo_wip_tot <> 0 and wo_site <> prev_site
            then do:

               find simstr
                  where simstr.si_site = prev_site no-lock.
               find si_mstr
                  where si_mstr.si_site = wo_site no-lock.

               if simstr.si_entity <> si_mstr.si_entity
               then do:

                  {pxmsg.i &MSGNUM=551 &ERRORLEVEL=3}
                  next-prompt wo_site.
                  undo, retry.
               end.
            end.

            if prev_site <> wo_site
            then do:

               {gprun.i ""csavg01.p"" "(input global_part,
                                        input wo_site,
                                        output glx_set,
                                        output glx_mthd,
                                        output cur_set,
                                        output cur_mthd)"
               }

               if  (prev_mthd <> glx_mthd)
                  and (wo_mtl_tot <> 0 or wo_lbr_tot <> 0 or
                  wo_bdn_tot <> 0 or wo_ovh_tot <> 0 or
                  wo_sub_tot <> 0 or wo_wip_tot <> 0)
               then do:

                  {pxmsg.i &MSGNUM=5426 &ERRORLEVEL=3}
                  next-prompt wo_site.
                  display prev_site @ wo_site.
                  undo, retry.
               end.

               if glx_mthd = "AVG" and wo_var
               then do:

                  {pxmsg.i &MSGNUM=5427 &ERRORLEVEL=3}
                  next-prompt wo_var.
                  undo, retry.
               end.
            end. /* IF PREV_SITE <> WO_SITE */

            hide frame b no-pause.
            {gprun.i ""womtacct.p""}
            view frame a.
            view frame b.

            if prev_status = "C" and wo_status <> "C"
            then
               assign
                  wo_acct_close = no
                  wo_close_date = ?
                  wo_close_eff  = ?.

            /* TRANSACTION COMMENTS */
            if not available woc_ctrl
            then
               find first woc_ctrl no-lock.

            if wocmmts = yes
            then do:

               assign
                  global_ref = wo_part
                  cmtindx = wo_cmtindx.

               hide frame a no-pause.
               hide frame b no-pause.

               {gprun.i ""gpcmmt01.p"" "(input ""wo_mstr"")"}
               view frame a.
               view frame b.
               wo_cmtindx = cmtindx.
            end.

            if new_wo
            then do:

               assign
                  prev_due = wo_due_date
                  prev_qty = wo_qty_ord
                  prev_site = wo_site
                  prev_routing = wo_routing
                  prev_bomcode = wo_bom_code
                  prev_release = wo_rel_date.

               /* create work order routing */
               {gprun.i ""woworlc.p""}
               new_wo = no.
            end.

         end.  /* CHECK-ROUTING: DO: */
      end.  /* IF NOT DEL-YN */

      if del-yn and wo_wip_tot <> 0
      then do:

         {pxmsg.i &MSGNUM=536 &ERRORLEVEL=3}
      end.

      /* DELETE WORK ORDER AND DETAIL */
      if del-yn and wo_wip_tot = 0
      then do:

         /* DELETE CODE MOVED TO WOWOMTE.P */
         {gprun.i ""wowomte.p""}
         clear frame b no-pause.
         clear frame a no-pause.
         del-yn = no.
      end.

   end. /*TRANSACTION*/
end. /* MAINLOOP: REPEAT: */

status input.
