/* woworl.p - RELEASE / PRINT WORK ORDERS USER INTERFACE                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.18 $                                                          */
/*V8:ConvertMode=Report                                                       */

/* REVISION: 6.0      LAST MODIFIED: 05/03/90   BY: mlb *D024*                */
/* REVISION: 6.0      LAST MODIFIED: 07/10/90   BY: emb *D024a*               */
/* REVISION: 6.0      LAST MODIFIED: 07/06/90   BY: emb *D040*                */
/* REVISION: 5.0      LAST MODIFIED: 08/21/90   BY: emb *B768*                */
/* REVISION: 6.0      LAST MODIFIED: 08/24/90   BY: wug *D054*                */
/* REVISION: 6.0      LAST MODIFIED: 03/14/91   BY: emb *D413*                */
/* REVISION: 6.0      LAST MODIFIED: 07/02/91   BY: emb *D741*                */
/* REVISION: 6.0      LAST MODIFIED: 08/29/91   BY: emb *D841*                */
/* REVISION: 6.0      LAST MODIFIED: 10/07/91   BY: alb *D887*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 04/01/92   BY: ram *F351*                */
/* REVISION: 7.0      LAST MODIFIED: 09/14/92   BY: ram *F896*                */
/* REVISION: 7.3      LAST MODIFIED: 09/29/92   BY: ram *G110*                */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: jcd *G247*                */
/* REVISION: 7.3      LAST MODIFIED: 11/03/92   BY: emb *G268*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 03/25/93   BY: emb *G870*                */
/* REVISION: 7.3      LAST MODIFIED: 04/29/93   BY: ksp *GA63*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 06/15/93   BY: qzl *GC28*                */
/* REVISION: 7.3      LAST MODIFIED: 12/02/93   BY: pxd *GH67*                */
/* REVISION: 7.3      LAST MODIFIED: 02/02/94   BY: qzl *FL91*                */
/* REVISION: 7.3      LAST MODIFIED: 07/27/94   BY: pxd *GK96*                */
/* REVISION: 7.3      LAST MODIFIED: 09/01/94   BY: ljm *FQ67*                */
/* REVISION: 7.5      LAST MODIFIED: 10/04/94   BY: taf *J035*                */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN76*                */
/* REVISION: 7.5      LAST MODIFIED: 12/09/94   BY: mwd *J034*                */
/* REVISION: 7.3      LAST MODIFIED: 12/13/94   BY: pxd *FU55*                */
/* REVISION: 7.5      LAST MODIFIED: 03/03/95   BY: tjs *J027*                */
/* REVISION: 8.5      LAST MODIFIED: 04/10/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 06/11/96   BY: *G1XY* Russ Witt          */
/* REVISION: 8.5      LAST MODIFIED: 02/04/97   BY: *J1GW* Julie Milligan     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/24/98   BY: *J2SX* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 02/23/00   BY: *M0JN* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Vincent Koh        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13     BY: Manisha Sawant        DATE: 11/29/00  ECO: *P008*   */
/* Revision: 1.14     BY: Inna Fox              DATE: 06/13/02  ECO: *P04Z*   */
/* Revision: 1.16     BY: Paul Donnelly (SB)    DATE: 06/28/03  ECO: *Q00N*   */
/* Revision: 1.17     BY: Deepak Rao            DATE: 08/02/03  ECO: *P0VT*   */
/* $Revision: 1.18 $    BY: Manisha Sawant        DATE: 08/25/03  ECO: *N2H7*   */
/* 100716.1  $  BY: mage chen  DATE: 07/16/10    ECO: *P45S*  */
/* 100727.1  $  BY: mage chen  DATE: 07/27/10    ECO: *P45S*  */
/* 101023.1  $  BY: mage chen  DATE: 10/23/10    ECO: *P45S*  */
/* 110408.1.1  $  BY: mage chen  DATE: 04/08/11    ECO: *P45S*  */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "110408.1"}

/* STANDARD INCLUDE FOR MAINTENANCE COMPONENTS */
{pxmaint.i}

define new shared variable comp like ps_comp.
define new shared variable qty like wo_qty_ord.
define new shared variable eff_date as date.
define new shared variable wo_recno as recid.
define new shared variable wo_recno1 as recid.

define new shared variable leadtime like pt_mfg_lead.
define new shared variable prev_status like wo_status.
define new shared variable prev_release like wo_rel_date.
define new shared variable prev_due like wo_due_date.
define new shared variable prev_qty like wo_qty_ord.
define new shared variable del-yn like mfc_logical initial no.
define new shared variable deliv like wod_deliver.
define new shared variable wo_des like pt_desc1.
define new shared variable wo_qty like wo_qty_ord.
define new shared variable wo_um like pt_um.
define new shared variable wc_description like wc_desc.
define new shared variable move like woc_move.
define new shared variable prd_recno as recid.
define new shared variable critical-part like wod_part    no-undo.

define new shared variable critical_flg like mfc_logical no-undo.
define new shared variable barcode      like mfc_logical label "Print Bar Code".
define new shared variable print_pick   like mfc_logical label "Print Picklist"
                                                         initial yes.
define new shared variable print_rte    like mfc_logical label "Print Routing"
                                                         initial no.
define new shared variable print_jp     like mfc_logical label "Print Co/By-Products"
                                                       initial no.

define variable des     like pt_desc1.
define variable wrnbr   like wo_nbr.
define variable wrlot   like wr_lot.
define variable base_id like wo_base_id.
define variable wobatch like wo_batch.
define variable l_ptstatus like pt_status no-undo.

define new shared variable s_wodloc like   wod_loc  .
define new shared variable s_wodop     like wod_op  .
/* OVERLAY FRAME a1 REPORT OPTIONS */
/*ss - 100717.1 - b*/
{xxmfworlb1.i &new="new" &row="10"}
/*ss - 100717.1 - e*/
/*ss - 100717.1 - b*
{mfworlb1.i &new="new" &row="10"}
*ss - 100717.1 - e*/
/* DEFINE THE PERSISTENT HANDLE FOR THE PROGRAM wocmnrtn.p */
{pxphdef.i wocmnrtn}

eff_date = today.

find first woc_ctrl  where woc_ctrl.woc_domain = global_domain no-lock no-error.
if available woc_ctrl then
   move = woc_move.
release woc_ctrl.

form
   skip(1)
   wrnbr          colon 23
   deliv          colon 58
   wrlot          colon 23
   barcode        colon 58
   wobatch        colon 23
   move           colon 58 label "Operation"
   print_pick     colon 23          s_wodloc   colon 58      label  "ø‚Œª"
   print_rte      colon 23           s_wodop   colon 58      label  "π§–Ú"
   print_jp       colon 23 skip(1)
   wo_part        colon 23
   wo_rel_date    colon 58
   des            at 25 no-label
   wo_qty_ord     colon 23
   wo_due_date    colon 58
   wo_qty_comp    colon 23
   wo_status      colon 58
   wo_so_job      colon 23
   wo_vend        colon 58
   skip(1)
   wo_rmks        colon 23
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

repeat with frame a:

   seta:

   do on error undo, retry:

      if batchrun then do
      with frame batch 2 columns width 80 no-attr-space:

         prompt-for
            wrnbr
            wrlot
            print_pick   s_wodloc
            print_rte     s_wodop
            print_jp
            deliv
            barcode
            move
            incl_zero_reqd
            incl_zero_open
            incl_pick_qtys
            incl_floor_stk
            jp_1st_last_doc
         with frame batch.

         assign
            wrnbr
            wrlot
            print_pick   s_wodloc
            print_rte    s_wodop
            print_jp
            deliv
            barcode
            move
            incl_zero_reqd
            incl_zero_open
            incl_pick_qtys
            incl_floor_stk
            jp_1st_last_doc.

         display
            wrnbr
            wrlot
            print_pick  s_wodloc
            print_rte   s_wodop
            print_jp
            deliv
            barcode
            move
         with frame a.

         find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_nbr =
         wrnbr and wo_lot = wrlot no-error.

      end.

      else do:

         update
            wrnbr
         with frame a editing:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i wo_mstr wrnbr  " wo_mstr.wo_domain = global_domain and
            wo_nbr "  wrnbr wo_nbr wo_nbr}

            if recno <> ? then do:
               assign
                  wrlot = wo_lot
                  des = "".
               find pt_mstr  where pt_mstr.pt_domain = global_domain and
               pt_part = wo_part
               no-lock no-error no-wait.
               if available pt_mstr then des = pt_desc1.
               display
                  wo_nbr @ wrnbr
                  wo_lot @ wrlot
                  wo_batch @ wobatch
                  wo_part
                  des
                  wo_qty_ord
                  wo_qty_comp
                  wo_so_job
                  wo_rel_date
                  wo_due_date
                  wo_status
                  wo_vend
                  wo_rmks.
            end.

         end.

      end.

      if available wo_mstr then
      find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_nbr = wrnbr
                     and wo_lot = wrlot
      no-lock no-error.
      if not available wo_mstr then
         if wrnbr <> "" then
         find wo_mstr no-lock  where wo_mstr.wo_domain = global_domain and
         wo_nbr = wrnbr no-error.

      if ambiguous wo_mstr and wrnbr <> "" then
         find first wo_mstr no-lock  where wo_mstr.wo_domain = global_domain
         and  wo_nbr = wrnbr no-error.

      if available wo_mstr then do:
         des = "".
         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         wo_part
         no-lock no-error no-wait.
         if available pt_mstr then
            des = pt_desc1.
         display
            wo_nbr @ wrnbr
            wo_lot @ wrlot
            wo_batch @ wobatch
            wo_part
            des
            wo_qty_ord
            wo_qty_comp
            wo_so_job
            wo_rel_date
            wo_due_date
            wo_status
            wo_vend
            wo_rmks.
      end.
      else
      display
         " " @ wrlot
         "" @ wobatch.

      if input wrlot = "" then
      find first wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_nbr =
      wrnbr no-lock no-error.

      if available wo_mstr then
         wrlot = wo_lot.

      if not batchrun then
      prompt-for
         wrlot
      editing:

         if wrnbr = "" then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i wo_mstr wrlot  " wo_mstr.wo_domain = global_domain and
            wo_lot "  wrlot wo_lot wo_lot}
         end.
         else do:
            {mfnp01.i wo_mstr wrlot wo_lot wrnbr  " wo_mstr.wo_domain =
            global_domain and wo_nbr "  wo_nbr}
         end.

         if recno <> ? then do:
            des = "".
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = wo_part
            no-lock no-error no-wait.
            if available pt_mstr then
               des = pt_desc1.
            display
               wo_nbr @ wrnbr
               wo_lot @ wrlot
               wo_batch @ wobatch
               wo_part
               des
               wo_qty_ord
               wo_qty_comp
               wo_so_job
               wo_rel_date
               wo_due_date
               wo_status
               wo_vend
               wo_rmks.
         end.
      end.

      assign wrlot.

      find wo_mstr no-lock  where wo_mstr.wo_domain = global_domain and  wo_lot
      = wrlot no-error.
      if not available wo_mstr then do:
         /* WORK ORDER NOT FOUND */
         {pxmsg.i &MSGNUM=503 &ERRORLEVEL=3}
         next.
      end.
      else do:
         if wo_nbr <> wrnbr and wrnbr <> "" then do:
            /* LOT NUMBER BELONGS TO A DIFFERENT WORK ORDER */
            {pxmsg.i &MSGNUM=508 &ERRORLEVEL=3}
            next.
         end.
      end.

      /* CHECK IF ADD-WO TRANSACTION IS PERMITTED FOR ITEM BEFORE */
      /* CHANGING THE STATUS OF WORK ORDER FROM PLANNED TO ANY    */
      /* OTHER STATUS                                             */
      if wo_status = "p"
      then do:

         {pxrun.i &PROC = 'validateRestrictedStatus'
                  &PROGRAM = 'wocmnrtn.p'
                  &HANDLE = ph_wocmnrtn
                  &PARAM = "(input wo_part,
                             ""ADD-WO"",
                             output l_ptstatus)"
                  &NOAPPERROR = true
                  &CATCHERROR = true}

         if return-value = {&APP-ERROR-RESULT}
         then do:
            /* RESTRICTED PROCEDURE FOR ITEM STATUS CODE */
            {pxmsg.i &MSGNUM = 358
                     &ERRORLEVEL = return-value
                     &MSGARG1 = l_ptstatus}

            next.
         end. /* IF return-value = {&APP-ERROR-RESULT} */

      end. /* IF wo_status = "P" */

      /* PREVENT ACCESS TO PROJECT ACTIVITY RECORDING WORK ORDERS */
      if wo_fsm_type = "PRM" then do:
         /* Controlled by PRM Module */
         {pxmsg.i &MSGNUM=3426 &ERRORLEVEL=3}
         next.
      end.

      /* PREVENT ACCESS TO CALL ACTIVITY RECORDING WORK ORDERS */
      if wo_fsm_type = "FSM-RO" then do:
         /* Controlled by Service/Support Module */
         {pxmsg.i &MSGNUM=7492 &ERRORLEVEL=3}
         next.
      end.

      assign
         wrnbr = wo_nbr
         wrlot = wo_lot
         des = ""
         .
      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      wo_part no-lock no-error no-wait.
      if available pt_mstr then des = pt_desc1.
      display
         wo_nbr @ wrnbr
         wo_lot @ wrlot
         wo_batch @ wobatch
         wo_part
         des
         wo_qty_ord
         wo_qty_comp
         wo_so_job
         wo_rel_date
         wo_due_date
         wo_status
         wo_vend
         wo_rmks.

      if index("PFBEAR",wo_status) = 0 then do:
         /* CAN ONLY RELEASE FIRM PLANNED OR ALLOCATED WORK ORDERS */
         {pxmsg.i &MSGNUM=516 &ERRORLEVEL=3}
         next.
      end.

      if wo_type = "C" and wo_nbr = "" then do:
         /* Work Order Type is Cumulative */
         {pxmsg.i &MSGNUM=5123 &ERRORLEVEL=3}
         next.
      end.

      /* Word Order type is flow */
      if wo_type = "w" then do:
         {pxmsg.i &MSGNUM=5285 &ERRORLEVEL=3}
         next.
      end.

      /* GET BASE PROCESS WO IF THIS IS A JOINT PRODUCT */
      if index("1234",wo_joint_type) > 0 then do:
         base_id = wo_base_id.
         find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_lot =
         base_id no-lock no-error.
         if not available wo_mstr then do:
            /* JOINT PRODUCT NOT PRODUCED BY BOM/FORMULA */
            {pxmsg.i &MSGNUM=6546 &ERRORLEVEL=3}
            next.
         end.
      end.

      if not batchrun then do:
         {gprun.i ""gpsiver.p""
            "(input wo_site, input ?, output return_int)"}
         if return_int = 0 then do:
            /* User does not have access to site */
            {pxmsg.i &MSGNUM=2710 &ERRORLEVEL=3 &MSGARG1=wo_site}
            undo seta, retry.
         end.
      end.

      if wo_qty_ord >= 0 then
         qty = max (wo_qty_ord - wo_qty_comp - wo_qty_rjct, 0).
      else
         qty = min (wo_qty_ord - wo_qty_comp - wo_qty_rjct, 0).

      assign
         wo_qty = qty
         wo_recno = recid(wo_mstr)
         comp = wo_part
         prev_status = wo_status
         prev_release = wo_rel_date
         prev_due = wo_due_date
         prev_qty = wo_qty_ord.

      if not batchrun then
      update
         print_pick   s_wodloc
         print_rte    s_wodop
         print_jp
         deliv
         barcode
         move.

      if (print_pick or print_jp) and not batchrun
      then do:
         update
            incl_zero_reqd when (print_pick)
            incl_zero_open when (print_pick)
            incl_pick_qtys when (print_pick)
            incl_floor_stk when (print_pick)
            jp_1st_last_doc when (print_jp)
         with frame a1.
      end.

      bcdparm = "".
      {mfquoter.i wrnbr}
      {mfquoter.i wrlot}
      {mfquoter.i print_pick}
            {mfquoter.i s_wodloc }
      {mfquoter.i print_rte}
                  {mfquoter.i s_wodop}

      {mfquoter.i print_jp}
      {mfquoter.i deliv}
      {mfquoter.i barcode}
      {mfquoter.i move}
      {mfquoter.i incl_zero_reqd}
      {mfquoter.i incl_zero_open}
      {mfquoter.i incl_pick_qtys}
      {mfquoter.i incl_floor_stk}
      {mfquoter.i jp_1st_last_doc}

      /* SELECT PRINTER */
      {gpselout.i &printType = "printer"
                  &printWidth = 80
                  &pagedFlag  = " "
                  &stream = " "
                  &appendToFile = " "
                  &streamedOutputToTerminal = " "
                  &withBatchOption = "yes"
                  &displayStatementType = 1
                  &withCancelMessage = "yes"
                  &pageBottomMargin = 6
                  &withEmail = "yes"
                  &withWinprint = "yes"
                  &defineVariables = "yes"}

      /* SAVE prd_det RECID FOR BAR-CODES LATER */
      find prd_det where prd_dev = dev no-lock no-error.
      if available prd_det then
         prd_recno = recid(prd_det).

      /* Print Work Order Driver */
  /*ss - 100716.1 - b*/    {gprun.i ""xxwoworl1x.p""}

      {mfreset.i}

   end.

end.
