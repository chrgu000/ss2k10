/* wowomta.p - WORK ORDER MAINTENANCE SUBROUTINE                              */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 7.0     LAST MODIFIED: 10/16/91    BY: pma *F003*                */
/* REVISION: 7.0     LAST MODIFIED: 02/19/92    BY: pma *F214*                */
/* REVISION: 7.0     LAST MODIFIED: 07/30/92    BY: pma *F821*                */
/* REVISION: 7.0     LAST MODIFIED: 09/14/92    BY: pma *F891*                */
/* REVISION: 7.0     LAST MODIFIED: 09/14/92    BY: ram *F896*                */
/* REVISION: 7.0     LAST MODIFIED: 09/15/92    BY: emb *F892*                */
/* REVISION: 7.0     LAST MODIFIED: 10/19/92    BY: emb *G208*                */
/* REVISION: 7.3     LAST MODIFIED: 09/27/93    BY: jcd *G247*                */
/* REVISION: 7.3     LAST MODIFIED: 12/31/92    BY: pma *G382*                */
/* REVISION: 7.3     LAST MODIFIED: 02/08/93    BY: emb *G656*                */
/* REVISION: 7.3     LAST MODIFIED: 03/25/93    BY: emb *G870*                */
/* REVISION: 7.3     LAST MODIFIED: 01/27/94    BY: pma *FL71*                */
/* REVISION: 7.3     LAST MODIFIED: 03/18/94    BY: ais *FM19*                */
/* REVISION: 7.3     LAST MODIFIED: 04/06/94    BY: pma *FN28*                */
/* REVISION: 7.3     LAST MODIFIED: 06/21/94    BY: pxd *FO90*                */
/* REVISION: 7.3     LAST MODIFIED: 09/01/94    BY: ljm *FQ67*                */
/* REVISION: 7.3     LAST MODIFIED: 09/15/94    BY: rwl *GM56*                */
/* REVISION: 7.3     LAST MODIFIED: 09/10/94    BY: pxd *FR91*                */
/* REVISION: 7.4     LAST MODIFIED: 11/02/94    BY: ame *FT23*                */
/* REVISION: 7.2     LAST MODIFIED: 11/18/94    BY: qzl *FT74*                */
/* REVISION: 7.2     LAST MODIFIED: 12/06/94    BY: emb *FU13*                */
/* REVISION: 7.2     LAST MODIFIED: 01/18/95    BY: ais *F0F2*                */
/* REVISION: 7.5     LAST MODIFIED: 02/09/95    BY: tjs *J027*                */
/* REVISION: 7.2     LAST MODIFIED: 03/17/95    BY: ais *F0JR*                */
/* REVISION: 7.2     LAST MODIFIED: 05/24/95    BY: qzl *F0S4*                */
/* REVISION: 8.5     LAST MODIFIED: 07/26/96    BY: *J10X* Markus Barone      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 01/18/99   BY: *N00J* Russ Witt          */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/16/00   BY: *N0SX* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 11/06/00   BY: *N0TN* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 12/01/00   BY: *M0XD* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 02/07/01   BY: *M10Z* Mark Christian     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.15  BY: Jyoti Thatte       DATE: 11/16/00 ECO: *P008*          */
/* Revision: 1.17  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N*          */
/* Revision: 1.18  BY: Subramanian Iyer   DATE: 03/05/04 ECO: *P1S8*          */
/* Revision: 1.19  BY: Surajit Roy        DATE: 12/30/04 ECO: *P2QK*          */
/* $Revision: 1.20 $ BY: Amit Singh        DATE: 04/17/06 ECO: *P4PR*   */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gplabel.i}

define new shared workfile pkdet no-undo
   field pkpart like pk_part
   field pkop as integer
   field pkstart like pk_start
   field pkend like pk_end
   field pkqty like pk_qty
   field pkltoff like ps_lt_off.

define variable part_global  like mfc_logical init no no-undo.

define variable assy_qty like wo_qty_ord.
define shared variable comp like ps_comp.
define shared variable qty like wo_qty_ord decimals 10.
define new shared variable eff_date as date.
define shared variable wo_recno as recid.
define shared variable leadtime like pt_mfg_lead.
define shared variable prev_status like wo_status.
define shared variable prev_release like wo_rel_date.
define shared variable prev_due like wo_due_date.
define shared variable prev_qty like wo_qty_ord.
define shared variable joint_type like wo_joint_type.
define buffer womstr for wo_mstr.
define variable i as integer.
define variable nonwdays as integer.
define variable workdays as integer.
define variable overlap as integer.
define variable know_date as date.
define variable find_date as date.
define variable interval as integer.
define variable frwrd as integer.
define shared variable del-yn like mfc_logical.
define shared variable deliv like wod_deliver.
define shared variable any_issued like mfc_logical.
define shared variable any_feedbk like mfc_logical.
define variable required like wod_qty_req.
define variable avail_qty like in_qty_avail.
define variable lt_off like ps_lt_off.
define variable open_ref like mrp_qty.
define new shared variable wod_recno as recid.
define shared variable prev_site like wo_site.
define new shared variable qty_to_all like wod_qty_all.
define new shared variable gen_alloc  like wod_qty_all.
define variable det_alloc like wod_qty_all.
define shared variable undo_all like mfc_logical no-undo.
define new shared variable ord_chg as decimal initial 1.
define new shared variable site like rps_site no-undo.
define new shared variable par_bombatch like bom_batch.
define variable oldwod_qty_req like wod_qty_req.
define variable phantom-loop like mfc_logical no-undo.
define variable bomqty like wod_bom_qty.
define new shared variable phantom like mfc_logical initial no.

define variable yield_pct like wo_yield_pct no-undo.
define new shared variable use_op_yield  as logical no-undo.

define new shared temp-table tt-routing-yields no-undo
   field tt-op         like ro_op
   field tt-yield-pct  like ro_yield_pct
   index tt-op is primary
   tt-op.

/*DEFINE VARIABLES FOR BILL OF MATERIAL EXPLOSION*/
{gpxpld01.i "new shared"}

do transaction:
   find wo_mstr where recid(wo_mstr) = wo_recno
      exclusive-lock no-error.
   if available wo_mstr and
      prev_status = "C" and
      wo_status  <> "C"
      then
   assign
      wo_acct_close = no
      wo_close_date = ?
      wo_close_eff  = ?.
end.  /* transaction */

undo_all = no.

/* HOLD LOCK ON JOINT PRODUCT ORDERS */
if joint_type <> "" then
find wo_mstr where recid(wo_mstr) = wo_recno.
else
find wo_mstr no-lock where recid(wo_mstr) = wo_recno.

eff_date = wo_rel_date.

if ((index("PFB",prev_status) > 0 and index("FEAR",wo_status) > 0))
or ((index("FEARC",prev_status) > 0 and index("FB",wo_status) > 0))
then do:

   /* LEAVE IF COMPONENTS HAVE BEEN ISSUED OR ANY LABOR REPORTED */
   if wo_joint_type = "" or wo_joint_type = "5" then do:
      {mfwomta.i wo_lot any_issued any_feedbk}
   end.
   else do:
      /* IF THIS IS A JOINT PRODUCT WO CHECK BASE WO */
      {mfwomta.i wo_base_id any_issued any_feedbk}
   end.

   if any_issued or any_feedbk
      then leave.

end.

if prev_qty <> wo_qty_ord and prev_qty <> 0 then
   ord_chg = wo_qty_ord / prev_qty.

if (index("FB",wo_status) > 0)
   or (index("PFB",prev_status) > 0 and index("FEAR",wo_status) > 0)
   or (wo_type = "S")
then do:

   ord_chg = 1.

   if wo_qty_ord >= 0 then
      qty = max(wo_qty_ord - wo_qty_comp - wo_qty_rjct,0).
   else
      qty = min(wo_qty_ord - wo_qty_comp - wo_qty_rjct,0).

   /* DELETE EXISTING wod_det AND THEIR ALLOCATIONS AND mrp_det */
   if index("1234",wo_joint_type) = 0 then do:
      {gprun.i ""wowomta4.p""}
   end.

   comp = wo_part.

   if index("1234",wo_joint_type) = 0
   then do:

{mfdel.i wr_route " where wr_route.wr_domain = global_domain and  wr_lot =
wo_lot"}

      if index("B",wo_status) = 0
         and index("E",wo_type) = 0
      then do:
         if not (wo_type = "R" and wo_routing = "") then do:
            {gprun.i ""woworlc.p""}
            {gprun.i ""woworle.p""}
            if prev_due = ? then
               prev_due = wo_due_date.
            if prev_release = ? then
               prev_release =  wo_rel_date.
         end. /* IF NOT (wo_type = "R" ...      */
      end. /* IF INDEX("B",wo_status) = 0 ...   */

   end.  /* IF (INDEX("1234"... */

   /* CREATE PICK LIST DETAIL (pk_det) AND WORK ORDER BILL (wod_det)*/
   if qty <> 0 and index("B",wo_status) = 0 and wo_type <> "E"
      and index("1234",wo_joint_type) = 0
   then do:

      if wo_type = "R" then do:
         /* REWORK */
         {gprun.i ""woworla1.p""}
         par_bombatch = 1.
      end.

      else do:

         if wo_bom_code <> "" then
            comp = wo_bom_code.
         site = wo_site.
         {gprun.i ""woworla.p""}

         if wo_bom_code <> "" then
            find bom_mstr  where bom_mstr.bom_domain = global_domain and
            bom_parent = wo_bom_code
            no-lock no-error.
         else
            find bom_mstr  where bom_mstr.bom_domain = global_domain and
            bom_parent = wo_part
            no-lock no-error.

         if available bom_mstr and bom_batch <> 0 then
            par_bombatch = bom_batch.
         else
            par_bombatch = 1.

      end.

      assign
         bomqty   = 1
         assy_qty = qty
         lt_off   = 0.

      /* CHECK FOR OPERATION YIELD AND LOAD TEMP TABLE */
      run ip-load-routing-temp-table.

      {mfworla.i}

   end.

   release in_mstr.

end.  /* IF INDEX(FB...  */

if ord_chg <> 1 then do:

   for each wod_det  where wod_det.wod_domain = global_domain and  wod_lot =
   wo_lot
   exclusive-lock:

      find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
      pt_part = wod_part no-error.

      find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part =
      wod_part
                     and ptp_site = wod_site
      no-lock no-error.

      find in_mstr  where in_mstr.in_domain = global_domain and  in_part =
      wod_part
                     and in_site = wod_site
      exclusive-lock no-error.

      if available pt_mstr
         and prev_status <> "C"
         and (index("AR",prev_status) = 0
         or (available ptp_det and ptp_iss_pol = yes)
         or (not available ptp_det and pt_iss_pol = yes))
      then do:

         if wod_qty_req >= 0 then
            open_ref = max(wod_qty_req * wo_qty_ord / prev_qty
                         - wod_qty_iss,0).
         else
            open_ref = min(wod_qty_req * wo_qty_ord / prev_qty
                         - wod_qty_iss,0).

         if available in_mstr
         and (index("EAR", wo_status)   > 0
         or   index("EAR", prev_status) > 0)
         then do:
            if wod_qty_req >= 0 then
               in_qty_req = in_qty_req + open_ref
                          - max(wod_qty_req - wod_qty_iss,0).
            else
               in_qty_req = in_qty_req + open_ref
                          - min(wod_qty_req - wod_qty_iss,0).
         end.

         {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}

         {mfmrw.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)
            ? wod_iss_date open_ref "DEMAND" WORK_ORDER_COMPONENT wod_site}

      end.  /* IF AVAILABLE pt_mstr... */

      if index("AR",prev_status) > 0
         and ((available ptp_det
           and ptp_iss_pol = no)
              or (not available ptp_det
                  and available pt_mstr
          and pt_iss_pol = no))
      then
         wod_qty_iss = wod_qty_iss - wod_qty_req +
                       wod_qty_req * wo_qty_ord / prev_qty.
         wod_qty_req = wod_qty_req * wo_qty_ord / prev_qty.

   end.  /* FOR EACH wod_det... */

   for each wr_route exclusive-lock  where wr_route.wr_domain = global_domain
   and  wr_lot = wo_lot:
      if wr_qty_ord = prev_qty then
         wr_qty_ord = wo_qty_ord.
      else
         wr_qty_ord = wr_qty_ord * wo_qty_ord / prev_qty.
   end.

end.  /* IF ORD_CHG <> 1... */

/* PASSING part_global AS AN INPUT PARAMETER TO wowomta1.p TO  */
/* RETAIN ITS VALUE DURING  PICKLIST PRINT                     */
/* ss 20071127 - b */
/*
{gprun.i ""wowomta1.p""
*/
{gprun.i ""xxwowomta101.p""
         "(input part_global)"}
/* ss 20071127 - e */

/* ENSURES THAT THE RELEASE DATES OF THE COMPONENTS ARE            */
/* UPDATED IN THE mrp_det FOR ALL THE COMPONENTS WHETHER THEY ARE  */
/* KEY ITEMS OR NOT, IRRESPECTIVE OF WHETHER INVENTORY EXISTS FOR  */
/* THESE COMPONENTS OR NOT                                         */
{gprun.i ""wowomtb.p""}

PROCEDURE ip-load-routing-temp-table:
/*--------------------------------------------------------------------
  Purpose:      Loads routing information for a part into a temp table
  Parameters:   <None>
   Notes:
----------------------------------------------------------------------*/
   define variable         v-routing   as character  no-undo.

   /* BYPASS ALL JOINT PRODUCTS...  */
   if wo_mstr.wo_joint_type <> ""
      then return.

   assign
      use_op_yield = no.

   for first mrpc_ctrl
   fields( mrpc_domain mrpc_op_yield)
    where mrpc_ctrl.mrpc_domain = global_domain no-lock:
      use_op_yield = mrpc_op_yield.
   end.

   if use_op_yield = no then
      return.

   for first pt_mstr
   fields( pt_domain pt_part pt_routing pt_op_yield)
    where pt_mstr.pt_domain = global_domain and  pt_part = wo_mstr.wo_part
   no-lock: end.

   for first ptp_det
   fields( ptp_domain ptp_part ptp_site ptp_routing ptp_op_yield)
    where ptp_det.ptp_domain = global_domain and  ptp_part = wo_mstr.wo_part
    and ptp_site = wo_mstr.wo_site
   no-lock: end.

   if available ptp_det then
      use_op_yield = ptp_op_yield.
   else
      use_op_yield = pt_op_yield.

   if use_op_yield = no then
      return.

   /* IF ROUTING SPECIFIED IN WORK ORDER USE IT... */
   /* OTHERWISE USE PART IN WORK ORDER             */
   if wo_mstr.wo_routing <> "" then
      v-routing = wo_mstr.wo_routing.
   else
      v-routing = wo_mstr.wo_part.

   /* LOAD ALL ROUTING RECORDS FOUND */
   for each ro_det
   fields( ro_domain ro_routing ro_op ro_start ro_end ro_yield_pct)
    where ro_det.ro_domain = global_domain and (  ro_routing = v-routing
     and (ro_start <= wo_rel_date or ro_start = ?)
     and (ro_end   >= wo_rel_date or ro_end   = ?)
   ) no-lock:

      if ro_yield_pct = 0 or ro_yield_pct = ? then
         next.

      create tt-routing-yields.
      assign
         tt-op        = ro_op
         tt-yield-pct = ro_yield_pct.

   end.  /* FOR EACH ro_det... */

END PROCEDURE.   /* PROCEDURE ip-load-routing-temp-table */