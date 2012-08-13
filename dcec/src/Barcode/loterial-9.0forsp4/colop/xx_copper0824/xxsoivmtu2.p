/* xxsoivmtu2.p - SALES ORDER MAINTENANCE INVENTORY UPDATE SUBROUTINE     */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.16.1.6.1.1 $                                            */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040**/
/* REVISION: 7.0      LAST MODIFIED: 06/09/91   BY: tjs *F504**/
/* REVISION: 7.3      LAST MODIFIED: 04/23/93   BY: WUG *GA26**/
/* REVISION: 7.3      LAST MODIFIED: 04/28/93   BY: tjs *G948**/
/* REVISION: 7.3      LAST MODIFIED: 06/14/93   BY: afs *GC26**/
/* REVISION: 7.3      LAST MODIFIED: 08/06/93   BY: dpm *GD71**/
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049**/
/* REVISION: 7.4      LAST MODIFIED: 01/21/94   BY: afs *FL51**/
/* REVISION: 7.2      LAST MODIFIED: 01/27/94   BY: afs *FL76**/
/* REVISION: 7.4      LAST MODIFIED: 05/19/94   BY: afs *FN92**/
/* REVISION: 7.4      LAST MODIFIED: 05/31/94   BY: dpm *FO23**/
/* REVISION: 7.4      LAST MODIFIED: 10/04/94   BY: dpm *GN06**/
/* REVISION: 7.4      LAST MODIFIED: 08/30/95   BY: jym *G0VQ**/
/* REVISION: 7.4      LAST MODIFIED: 09/22/95   BY: ais *F0VH**/
/* REVISION: 7.4      LAST MODIFIED: 10/05/95   BY: ais *G0YK**/
/* REVISION: 7.4      LAST MODIFIED: 12/13/95   BY: ais *G1GC**/
/* REVISION: 7.4      LAST MODIFIED: 12/19/95   BY: ais *G1H3**/
/* REVISION: 7.4      LAST MODIFIED: 01/10/96   BY: ais *G1JT**/
/* REVISION: 7.4      LAST MODIFIED: 02/15/96   BY: ais *G1ND**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan     */
/* REVISION: 8.6E     LAST MODIFIED: 07/09/98   BY: *L024* Bill Reckard   */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney */
/* REVISION: 9.1      LAST MODIFIED: 08/23/00   BY: *N0ND* Mark Brown     */
/* REVISION: 9.1      LAST MODIFIED: 11/08/00   BY: *N0TN* Jean Miller    */
/* Old ECO marker removed, but no ECO header exists *F003*                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                */
/* Revision: 1.16.1.4 BY: Jeff Wootton     DATE: 09/21/01 ECO: *P01H*     */
/* Revision: 1.16.1.5    BY: Veena Lad    DATE: 06/26/02 ECO: *N1M4*          */
/* Revision: 1.16.1.6      BY: Dorota Hohol    DATE: 02/25/03  ECO: *P0N6* */
/* $Revision: 1.16.1.6.1.1 $     BY: Santosh Rao     DATE: 06/25/03  ECO: *N2HN* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/******************************************************************
*  This routine drives the updates to the Inventory Control and   *
*  Planning Modules.                                              *
*                                                                 *
*  If the inventory is in a different database from the sales     *
*  order, this routine will read in the sales order from the      *
*  hidden buffer and write it into the new                        *
*  database before performing the updates.                        *
*****************************************************************/

{mfdeclre.i}
{gplabel.i}
{cxcustom.i "SOIVMTU2.P"}


/* ********** Begin Translatable Strings Definitions ********* */

/* MaxLen: Comment: */

/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define shared variable eff_date as date.
define shared variable so_recno as recid.
define shared variable sod_recno as recid.
define shared variable ad_mod_del as character.
define shared variable del-yn like mfc_logical.

define shared variable change_db as logical.
define shared frame hf_so_mstr.
define shared frame hf_sod_det.
define shared stream hs_so.

define new shared variable old_so_recno  like so_recno.

define new shared variable old_sod_recno like sod_recno.
define            variable open_qty      like sod_qty_ord.
define new shared variable transtype     as character.
define shared variable prev_type         like sod_type.
define new shared variable delete_line   like mfc_logical.
define new shared variable inv_so_recno  as recid.
define new shared variable inv_sod_recno as recid.
define new shared variable hdr_qty_chg   like sod_qty_chg.
define new shared variable hdr_qty_all   like sod_qty_all.
define new shared variable hdr_qty_pick  like sod_qty_pick.
define new shared variable prev_qty_ship like sod_qty_ord.
define            variable demand_qty    like sod_qty_ord.
define     shared variable noentries     as integer no-undo.
define     shared variable new_line      like mfc_logical.

define variable o_seq like so_exru_seq no-undo.
define variable l_qty_change like mfc_logical no-undo.

FORM /*GUI*/  so_mstr with overlay frame hf_so_mstr THREE-D /*GUI*/.

FORM /*GUI*/  sod_det with overlay frame hf_sod_det THREE-D /*GUI*/.


if change_db then do:

   old_so_recno  = so_recno.
   old_sod_recno = sod_recno.

   /* Read the sales order header from hidden frame */
   do with frame hf_so_mstr on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

      find so_mstr where so_nbr = input so_nbr no-error.
      if not available so_mstr then do:
         create so_mstr.
         assign so_mstr.
      end.
      else
         do:
         assign
            so_mstr.so_shipvia = input frame hf_so_mstr so_shipvia
            so_mstr.so_bol = input frame hf_so_mstr so_bol
            so_mstr.so_rmks = input frame hf_so_mstr so_rmks
            so_mstr.so_inv_nbr = input frame hf_so_mstr so_inv_nbr
            so_mstr.so_to_inv = input frame hf_so_mstr so_to_inv
            so_mstr.so_ship_date = input frame hf_so_mstr so_ship_date
            so_mstr.so_invoiced = input frame hf_so_mstr so_invoiced.
         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
            "(input so_exru_seq)" }
      end.
      so_recno = recid(so_mstr).

      {gprun.i ""mccpexru.p"" "(output o_seq)" }
/*GUI*/ if global-beam-me-up then undo, leave.

      so_exru_seq = o_seq.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.


   /* Read the sales order line from hidden frame */
   do with frame hf_sod_det on error undo, retry:
      find sod_det where sod_nbr  = so_nbr
         and sod_line = input sod_line no-error.
      if not available sod_det then do:
         create sod_det.
         assign sod_det.
      end.
      else do:
         assign
            sod_abnormal
            sod_acct
            sod_bo_chg
            sod_cc
            sod_confirm
            sod_consume
            sod_disc_pct
            sod_dsc_acct
            sod_dsc_cc
            sod_dsc_project
            sod_dsc_sub
            sod_due_date
            sod_expire
            sod_list_pr
            sod_loc
            sod_lot
            sod_per_date
            sod_pickdate
            sod_price
            sod_prodline
            sod_project
            sod_promise_date
            sod_qty_all
            sod_qty_chg
            sod_qty_inv
            sod_qty_ord
            sod_qty_pick
            sod_qty_ship
            sod_req_date
            sod_serial
            sod_site
            sod_sob_rev
            sod_sob_std
            sod_status
            sod_std_cost
            sod_sub
            sod_type
            sod_um
            sod_um_conv
            .
      end.
      sod_recno = recid(sod_det).
   end.
end.
else do:
   find so_mstr where recid(so_mstr) = so_recno.
   find sod_det where recid(sod_det) = sod_recno.
end.

do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


   find pt_mstr where pt_part = sod_part no-lock no-error.

   /* CREATE TRANSACTION HISTORY RECORD AND UPDATE ITEM MASTER */
   sod_recno = recid(sod_det).
   eff_date = so_ship_date.

   {&SOIVMTU2-P-TAG1}

   if noentries = 0
   then do:
      {gprun.i ""soivtr.p""
         "(input-output l_qty_change)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end.
   else do:
      {gprun.i ""xxsoivtra.p""
         "(input-output l_qty_change)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end.
   /* UPDATE QTY ALLOCATED AND PICKED */
   assign
      sod_qty_chg  = sod_qty_chg - sod_qty_inv
      sod_qty_all = if l_qty_change
                    then
                       sod_qty_all + sod_qty_pick
                    else
                       sod_qty_all
      sod_qty_pick = if l_qty_change
                     then
                        0
                     else
                        sod_qty_pick
      sod_qty_all = max(0,sod_qty_all - sod_qty_chg)
      sod_qty_all = min(sod_qty_all, sod_bo_chg)
      sod_qty_all = if sod_bo_chg < 0
                    then
                       0
                    else
                       sod_qty_all.

   /* IF QTY ORDERED CHANGED, CREATE ORD-SO TRANSACTION, UPDATE PART MASTER.*/
   /*  INSTEAD OF A SIMPLE MODIFY TO CAPTURE THE CHANGE, WE WILL NOW    */
   /*  DELETE (REVERSE) THE BACKORDERED QUANTITY AND THEN USE MODIFY    */
   /*  TO BOOK THE NEW QUANTITIES.                                      */
   /*  At this point these variables hold the following:                */
   /*      sod_qty_ord  - old quantity ordered                          */
   /*      sod_qty_ship - old quantity shipped                          */
   /*      sod_bo_chg   - change in quantity backordered                */
   /*      sod_qty_chg  - change in quantity shipped                    */
   /*      The entire original line is held in the hidden frame bi      */
   so_recno = recid(so_mstr).
   sod_recno = recid(sod_det).
   /* Capture changed variables so they are available immediately */

   assign hdr_qty_chg  = sod_qty_chg
      hdr_qty_all  = sod_qty_all
      hdr_qty_pick = sod_qty_pick .
   if change_db then do:
      {gprun.i ""sohddb01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.
  /* Set db pointer to SO db */
   end.
   ad_mod_del = "DELETE".
   {gprun.i ""sosotr01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


   /* IF WE ARE NOT PROCESSING A DELETE, THEN DO THE CHANGE */
   if del-yn = no
   then do:

      if not new_line
      then do:
         ad_mod_del = "MODIFY".
         {gprun.i ""sosotr01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

      end.
      else do:

         ad_mod_del = "INV-ADD".
         {gprun.i ""sosotr01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

      end.
   end.

   if change_db then do:
      {gprun.i ""sohddb02.p""}
/*GUI*/ if global-beam-me-up then undo, leave.
  /* Reset the db pointer to inv db */
   end.

   /* UPDATE SALES ORDER */
   sod_qty_ship = sod_qty_ship + sod_qty_chg.

   if sod_sched then
      sod_cum_qty[1] = sod_cum_qty[1] + sod_qty_chg.
   else
      sod_qty_ord = sod_qty_ship + sod_bo_chg.

   sod_qty_inv = sod_qty_inv + sod_qty_chg.

   /* FORECAST RECORD */

   if sod_type = "" or (prev_type = "" and sod_type <> ""
      and not new sod_det) then do:
      sod_recno = recid(sod_det).
      {gprun.i ""sosofc.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

   end.

   /* IF LINE CHGD TO MEMO, REVERSE MRP, IN QTY REQD, FORECAST ON SOB */

   if prev_type = "" and sod_type <> "" then do:
      delete_line = no.
      {gprun.i ""sosomtk.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

   end.

   /* DENOTE QTY SHIPPED IN PENDING INVOICE MAINTENANCE TO */
   /* ENABLE FREIGHT ACCRUAL POSTINGS FOR THE SHIPMENT.    */
   sod__qad01 = sod_qty_chg.

   sod_qty_chg = 0.
   sod_bo_chg  = 0.

   /* MRP WORKFILE */
   if sod_type = "" then do:

      if sod_qty_ord >= 0
         then demand_qty = max(sod_qty_ord - max(sod_qty_ship,0),0).
      else demand_qty = min(sod_qty_ord - min(sod_qty_ship,0),0).

      /* Changed pre-processor to a Term */
      {mfmrw.i "sod_det" sod_part sod_nbr string(sod_line) """"
         ? sod_due_date
         "demand_qty * sod_um_conv" "DEMAND"
         SALES_ORDER sod_site}
   end.
   else if prev_type = "" then do:
      /* LINE CHGD TO MEMO, DELETE MRP */
      /* Changed pre-processor to a Term */
      {mfmrw.i "sod_det" sod_part sod_nbr string(sod_line) """"
         ? sod_due_date "0" "DEMAND" SALES_ORDER sod_site}
      /* Changed pre-processor to a Term */
      {mfmrw.i "sod_fas" sod_part sod_nbr string(sod_line) """"
         ? sod_due_date "0" "SUPPLYF" PLANNED_F/A_ORDER sod_site}
   end.

   if sod_sched then do:
      {gprun.i ""rcmrw.p"" "(input sod_nbr, input sod_line, input no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end.

end.
/*GUI*/ if global-beam-me-up then undo, leave.


/* Restore the old db record ids if necessary */
if change_db then do:

   /* Send the updated fields back to the calling program */
   display stream hs_so
      sod_qty_all
      sod_qty_inv
      sod_qty_ord
      sod_qty_pick
      sod_qty_ship
      sod_std_cost
   with frame hf_sod_det.

   so_recno  = old_so_recno.
   sod_recno = old_sod_recno.

end.
