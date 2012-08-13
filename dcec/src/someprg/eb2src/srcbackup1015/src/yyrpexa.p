/* rerpexa.p - RECALCULATE REPETITIVE ORDER COMPONENT DEMAND            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9.2.8.3.1 $                                                         */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 5.0       LAST EDIT: 04/07/89      MODIFIED BY: EMB      */
/* REVISION: 5.0       LAST EDIT: 06/01/89      MODIFIED BY: EMB      */
/* REVISION: 5.0   LAST MODIFIED: 06/23/89               BY: MLB *B159* */
/* REVISION: 6.0       LAST EDIT: 07/03/90      MODIFIED BY: emb *D040* */
/* REVISION: 6.0       LAST EDIT: 11/07/90      MODIFIED BY: EMB *D192*/
/* REVISION: 7.0       LAST EDIT: 10/11/91      MODIFIED BY: emb *F024*/
/* REVISION: 7.0       LAST EDIT: 10/12/92      MODIFIED BY: emb *G071*/
/* REVISION: 7.3       LAST EDIT: 01/13/93      MODIFIED BY: emb *G689*/
/* REVISION: 7.3       LAST EDIT: 10/19/93      MODIFIED BY: pxd *GG41*/
/* REVISION: 7.3       LAST EDIT: 02/24/94      MODIFIED BY: qzl *FM46*/
/* Oracle changes (share-locks)    09/15/94           BY: rwl *FR25*    */
/* REVISION: 7.3       LAST EDIT: 10/15/94      MODIFIED BY: pxd *FR91*/
/* REVISION: 7.3       LAST EDIT: 12/06/94      MODIFIED BY: emb *FU13*/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 04/01/98   BY: *J23R* Santhosh Nair */
/* REVISION: 8.6E     LAST MODIFIED: 08/11/98   BY: *H1L6* Thomas Fernandes */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 03/03/99   BY: *N00J* Russ Witt         */
/* REVISION: 9.1      LAST MODIFIED: 09/06/99   BY: *J3GQ* Prashanth Narayan */
/* REVISION: 9.1      LAST MODIFIED: 07/02/00   BY: *N0GD* Peggy Ng          */
/* REVISION: 9.1      LAST MODIFIED: 12/13/00   BY: *N0V4* Rajesh Thomas     */
/* Revision: 9.1      LAST MODIFIED: 12/22/00   BY: *N0VF* Jean Miller       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9.2.8     BY: Samir Bavkar        DATE: 04/05/02  ECO: *P000*  */
/* $Revision: 1.9.2.8.3.1 $    BY: Deepak Rao          DATE: 04/20/04  ECO: *P1YB*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i}


define shared variable wo_recno as recid.

define variable i             as   integer     no-undo.
define variable qty           as   decimal     no-undo.
define variable lt_off        like ps_lt_off   no-undo.
define variable open_qty      like mrp_qty     no-undo.
define variable l_new_wod_det like mfc_logical no-undo.
/*roger*/ def var bgy as char.
{mfdatev.i}

define shared variable use_op_yield  as logical no-undo.
define variable yield_pct like wo_yield_pct no-undo.
define shared temp-table tt-routing-yields no-undo
   field tt-routing    like ro_routing
   field tt-op         like ro_op
   field tt-start      like ro_start
   field tt-end        like ro_end
   field tt-yield-pct  like ro_yield_pct
   index tt-routing is unique primary
   tt-routing
   tt-op
   tt-start.

l_new_wod_det = no.

for first wo_mstr
   fields(wo_lot wo_nbr wo_qty_comp wo_qty_ord
   wo_rel_date wo_site)
   where recid(wo_mstr) = wo_recno no-lock:
end. /* for first wo_mstr */

if not available wo_mstr then leave.

for each pk_det
      fields(pk_end pk_lot pk_part pk_qty pk_reference
      pk_start pk_user)
      where pk_user = mfguser no-lock:

   if (pk_start = ? or pk_start <= wo_rel_date)
      and (pk_end = ? or pk_end >= wo_rel_date) then do:
      if can-find (first wod_det where wod_lot = wo_lot
         and wod_part = pk_part and wod_op = integer(pk_reference))
         then next.

      create wod_det.
      assign
         wod_part      = pk_part
         wod_nbr       = wo_nbr
         wod_lot       = wo_lot
         wod_op        = integer(pk_reference)
         wod_site      = wo_site
         wod_iss_date  = wo_rel_date
         l_new_wod_det = yes.
 /*roger*/ find pt_mstr where pt_part = wod_part no-error.
/*roger*/ if avail pt_mstr then wod__chr05 = pt_article.
/*roger*/ else wod__chr05 = "".
   end.  /* if (pk_start = ?... */
end. /* for each pk_det */

for each wod_det exclusive-lock where wod_lot = wo_lot:
/*roger*/ find pt_mstr where pt_part = wod_part no-error.
/*roger*/ if avail pt_mstr then wod__chr05 = pt_article.
/*roger*/ else wod__chr05 = "".  
   lt_off = ?.
   qty = 0.

   for each pk_det
         fields(pk_end pk_lot pk_part pk_qty pk_reference
         pk_start pk_user)
         where pk_user = mfguser
         and pk_part = wod_part
         and pk_reference = string(wod_op) no-lock:

      if (pk_start = ? or pk_start <= wo_rel_date)
         and (pk_end = ? or pk_end >= wo_rel_date) then do:
         if lt_off = ? then lt_off = integer(pk_lot).
         else lt_off = min(lt_off,integer(pk_lot)).
         qty = qty + pk_qty.
      end.   /* if (pk_start = ?... */
   end. /* for each pk_det */

   wod_bom_qty = qty.

   for first in_mstr
      fields(in_abc in_avg_int in_cur_set in_cyc_int
      in_gl_set in_level in_mrp in_part in_qty_req
      in_rctpo_active in_rctpo_status in_rctwo_active
      in_rctwo_status in_site in_gl_cost_site)
      where in_site = wod_site
      and in_part = wod_part no-lock:
   end. /* for first in_mstr */

   {gpsct03.i &cost=sct_cst_tot}
   wod_bom_amt = glxcst.

   if qty = 0 then do:

      {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}

      {mfmrw.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)
         ? wod_iss_date "0" "DEMAND" REPETITIVE_COMPONENT wod_site}

      if wod_qty_iss = 0 then delete wod_det.
   end.  /* if qty = 0... */
   else do:
      /* Determine if operation yield is needed, and if so adjust qty   */
      /* to be reduced by effective yield percent...                    */
      yield_pct = 100.
      if use_op_yield = yes then do:
         /*               Call internal procedure to calculate yield */
         run ip-get-yield
            (input if wo_routing <> "" then wo_routing else wo_part,
            input wod_op,
            input wo_rel_date,
            output yield_pct).
      end.  /* if use_op_yield... */

      if wod_iss_date <> wo_rel_date or lt_off <> 0
         or wod_qty_req <> qty * yield_pct * .01 * wo_qty_ord
      then do:
         find in_mstr exclusive-lock
            where in_part = wod_part and in_site = wod_site no-error.
         if available in_mstr then do:
            if wod_qty_req >= 0 then
               in_qty_req = in_qty_req - max(wod_qty_req - wod_qty_iss,0).
            else
               in_qty_req = in_qty_req - min(wod_qty_req - wod_qty_iss,0).
         end.    /* if available inb_mstr... */

         for first wr_route no-lock where wr_lot = wo_lot
            and wr_op  = wod_op:
         end.   /* for first wr_route... */

         /* IF ITEM IS OP BASED YIELD ITEM, THEN ANTICIPATED YIELD HAS */
         /* BEEN BASED FROM ORDER QUANTITY.  THUS, DO NOT USE ORDER    */
         /* QUANTITY FROM WORK ORDER ROUTING WHICH MAY BE REDUCED BY   */
         /* ANY SCRAP TRANSACTION PREVIOUSLY ENTERED.  IF OP BASED     */
         /* YIELD ITEM ALWAYS DERIVE OFF FULL ORDER QUANTITY...        */
         /* WOD_QTY_REQ = QTY * (IF AVAILABLE(WR_ROUTE)                */

         if use_op_yield = no then
         wod_qty_req = qty * yield_pct * .01 * (if available(wr_route)
            then
         wr_qty_ord
         else
            wo_qty_ord).
         else wod_qty_req = qty * yield_pct * .01 * wo_qty_ord.

         wod_yield_pct = yield_pct.

         if available in_mstr then do:
            if wod_qty_req >= 0 then
               in_qty_req = in_qty_req + max(wod_qty_req - wod_qty_iss,0).
            else
               in_qty_req = in_qty_req + min(wod_qty_req - wod_qty_iss,0).
         end.

         if lt_off = 0 then wod_iss_date = wo_rel_date.
         else do:
            wod_iss_date = ?.
            {mfdate.i wo_rel_date wod_iss_date lt_off wod_site}
         end.  /* else do... */
      end.  /* if wod_iss_date <> wo_rel_date */

      for first wr_route
         fields(wr_lot wr_op wr_qty_comp wr_qty_ord)
         where wr_lot = wo_lot
         and wr_op  = wod_op no-lock:
      end. /* for first wo_route */

      /* CALCULATE ISSUE QUANTITY IN ADVANCE REPETITIVE */
      if available wr_route then do:
         for first mfc_ctrl
            fields (mfc_field mfc_logical)
            where mfc_field = "rpc_using_new" no-lock:
         end.
         if (available mfc_ctrl
            and mfc_logical)
            or l_new_wod_det
         then do:
            wod_qty_iss = wod_qty_req * wr_qty_comp / wr_qty_ord.
         end.
      end. /* IF AVAILABLE wr_route */

      if not available wr_route then do:
         wod_qty_iss = wod_qty_req *
         (wo_qty_comp + wo_qty_rjct) / wo_qty_ord.
      end.

      if wod_qty_req >= 0
         then open_qty = max(wod_qty_req - wod_qty_iss,0).
      else open_qty = min(wod_qty_req - wod_qty_iss,0).

      /* MRP WORKFILE */

      {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}

      /* NINTH PRAMETER IN CALL to mfmrw.i CORRECTED TO DEMAND.      */

      {mfmrw.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)
         ? wod_iss_date open_qty "DEMAND" REPETITIVE_COMPONENT wod_site}

   end.  /* else do (qty <> )..  */
end.  /* for each wod_det... */

/******************************************************************/

/*   I N T E R N A L    P R O C E D U R E S     */

/******************************************************************/

/* This routine will determine operation yield percentage        */
/* used.                                                         */
{gpgetyld.i}

