/* flswocr.p -  Flow Schedule Work Order Create                               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.3 $                                                           */
/*                                                                            */
/*V8:ConvertMode=NoConvert                                                    */
/*                                                                            */
/* This routine creates a work order for a flow schedule.  It's work order    */
/* type will be set to 'W'.                                                   */
/*                                                                            */
/*   Inputs:                                                                  */
/*      ip-woSite            Character   Work order Site                      */
/*      ip-productionLine    Character   Production Line                      */
/*      ip-part              Character   Item ID                              */
/*      ip-orderQty          Decimal     Order Quantity                       */
/*      ip-dueDate           Date        Due Date                             */
/*                                                                            */
/*   Outputs:                                                                 */
/*      op-wonbr             Character   Work Order Number                    */
/*      op-wolot             Character   Work Order Lot ID                    */
/*                                                                            */
/* Revision: 1.2        BY: Julie Milligan      DATE: 03/31/02   ECO: *P04Z*  */
/* $Revision: 1.3 $       BY: Julie Milligan      DATE: 06/27/02   ECO: *P08S*  */

{mfdeclre.i}

define input parameter ip-woSite as character no-undo.
define input parameter ip-productionLine as character no-undo.
define input parameter ip-part as character no-undo.
define input parameter ip-orderQty as decimal no-undo.
define input parameter ip-dueDate as date no-undo.
define output parameter op-wonbr as character no-undo.
define output parameter op-wolot as character no-undo.

{gplabel.i}
{pxmaint.i}

/* wocmnrtn.p stores common routines used for work orders */
{pxphdef.i wocmnrtn}

/* Variables needed for date routines */
{mfdatev.i}

{rescttdf.i "new shared"}

/* These shared variables are needed for some of the routines called below */
define new shared variable comp as character.
define new shared variable eff_date as date.
define new shared variable prev_qty like wo_qty_ord.
define new shared variable prev_status like wo_status.
define new shared variable site as character.
define new shared variable wo_recno as recid.
define new shared variable use_op_yield  as logical no-undo.

/* Local variables */
define variable bom_code like pt_bom_code no-undo.
define variable l_errorno  as  integer      no-undo.
define variable mfg_lead like pt_mfg_lead no-undo.
define variable routing like pt_routing no-undo.
define variable v-op       like ro_op         no-undo.
define variable wonbr       like wo_nbr no-undo.
define variable wolot       like wo_lot no-undo.
define variable yield_pct like pt_yield_pct no-undo.

define new shared buffer gl_ctrl for gl_ctrl.

define buffer next_wr_route for wr_route.


define new shared temp-table tt-routing-yields no-undo
   field tt-routing    like ro_routing
   field tt-op         like ro_op
   field tt-start      like ro_start
   field tt-end        like ro_end
   field tt-yield-pct  like ro_yield_pct
   index tt-routing is unique primary
   tt-routing
   tt-op
   tt-start.

/* Compliance Control - When clc_wolot_rctp is yes, then work order receipt  */
/* is set for single lot per wo receipt.                                     */
for first clc_ctrl
   fields(clc_wolot_rcpt) no-lock:
end. /* for first clc_ctrl */

if not available clc_ctrl
then do:
   {gprun.i ""gpclccrt.p""}

   for first clc_ctrl
      fields(clc_wolot_rcpt) no-lock:
   end. /* for first clc_ctrl */

end.

assign
   site = ip-woSite
   comp = ip-part
   bom_code = ""
   routing = "".

for first pt_mstr
   fields(pt_abc pt_avg_int pt_cyc_int pt_ord_pol
          pt_rctpo_status pt_rctwo_active pt_rctwo_status
          pt_bom_code pt_desc1 pt_mfg_lead pt_part pt_prod_line
          pt_op_yield pt_routing pt_yield_pct pt_rctpo_active)
   where pt_part = ip-part no-lock:
end. /* for first pt_mstr */

assign
   pt_recno = recid(pt_mstr)
   yield_pct = pt_yield_pct
   use_op_yield = pt_op_yield
   mfg_lead = pt_mfg_lead
   routing = if pt_routing > ""
             then
                pt_routing
             else
                ""
   bom_code = if pt_bom_code > ""
              then
                 pt_bom_code
              else
                 "".

for first ptp_det
   fields(ptp_bom_code ptp_mfg_lead ptp_part ptp_routing ptp_op_yield
          ptp_site ptp_yld_pct ptp_ord_pol)
   where ptp_part = ip-part
     and ptp_site = site no-lock:
end. /* for first ptp_det */

if available ptp_det
then do:

   assign
      yield_pct = ptp_yld_pct
      use_op_yield = ptp_op_yield
      mfg_lead = ptp_mfg_lead
      routing = if ptp_routing > ""
                then
                   ptp_routing
                else
                   ""
      bom_code = if ptp_bom_code > ""
                 then
                    ptp_bom_code
                 else
                    "".
end.

repeat on error undo, retry:

   {mfnctrl.i woc_ctrl woc_nbr wo_mstr wo_nbr wonbr}
   {mfnxtsq.i wo_mstr wo_lot woc_sq01 wolot}

   release woc_ctrl.
/* Create the work order */
   create wo_mstr.

   assign
      wo_lot = wolot
      wo_part = ip-part
      wo_nbr = wonbr
      wo_type = "w"     /* Make it flow schedule */
      wo_status = "e"    /* This will be an exploded work order  */
      wo_line = ip-productionLine
      wo_site = ip-wosite
      op-wonbr = wonbr
      op-wolot = wolot.

   if recid(wo_mstr) = -1 then .

   /* UPDATE THE WORK ORDER ACCOUNTS */
   if available pt_mstr
   then do:

      for first in_mstr
         fields(in_abc in_avg_int in_cur_set in_cyc_int in_gl_set in_level
                in_mrp in_part in_qty_ord in_rctpo_active in_rctpo_status
                in_rctwo_active in_rctwo_status in_site)
         where in_part = wo_part
           and in_site = wo_site
         no-lock:
      end. /* FOR FIRST in_mstr */

      /* ASSIGN DEFAULT RECEIPT STATUS AND ACTIVE FLAG */
      {pxrun.i &PROC    = 'assign_default_wo_rctstat'
               &PROGRAM = 'wocmnrtn.p'
               &HANDLE  = ph_wocmnrtn
               &PARAM   = "(
                            buffer in_mstr,
                            buffer pt_mstr,
                            output wo_rctstat,
                            output wo_rctstat_active,
                            output l_errorno
                           )"
      }

      /*ASSIGN DEFAULT VARIANCE ACCOUNT SUB-ACCOUNT AND COST CENTER CODE*/
      run assign_default_wo_acct(buffer wo_mstr,
                                 input pt_prod_line).

   end. /* IF AVAILABLE PT_MSTR */
   leave.
end. /* repeat do untry */

wo_recno = recid(wo_mstr).
find wo_mstr exclusive-lock
   where recid(wo_mstr) = wo_recno.

/* Calculate needed changes to in_mstr quantity on order */

/* The difference between previous and new quantity (orderQty)
open gets posted against the in_mstr record */
if ip-orderQty <> 0
then do:

   /* Update the in_mstr in_qty_ord field */
   for first in_mstr exclusive-lock
      where in_part = wo_part
        and in_site = wo_site:

      in_qty_ord = in_qty_ord + ip-orderQty.
      release in_mstr.

   end.
end.

assign
   wo_ord_date = today
   wo_due_date = ip-dueDate
   wo_qty_ord = ip-orderQty
   wo_routing = routing
   wo_bom_code = bom_code
   wo_yield_pct = yield_pct
   wo_lot_rcpt = clc_wolot_rcpt
   wo_rel_date = ?.

 /* Get the release date */
{mfdate.i wo_rel_date wo_due_date mfg_lead wo_site}

/* Determine if operation yield is needed, and if so override  */
/* wo_yield_pct.                                               */
/* if global switch for operational yield is no, set local     */
/* switch to no                                                */
/* use_op_yield defaults from pt_mstr or ptp-det */

for first mrpc_ctrl
   fields (mrpc_op_yield)
   no-lock:
end.

if (available mrpc_ctrl and mrpc_op_yield = no)
   or not available mrpc_ctrl
then
   use_op_yield = no.

if use_op_yield
then do:
   /* Load temp table with this item's routing data  */
   run ip-load-routing-temp-table
      (input if wo_routing <> "" then wo_routing else wo_part).

   /* Call internal procedure to calculate yield */
   /* Pass all 9's for operation so all are used */
   v-op = 999999999.
   run ip-get-yield
      (input if wo_routing <> "" then wo_routing else wo_part,
      input v-op,
      input wo_rel_date,
      output yield_pct).

   wo_yield_pct = yield_pct.
end.  /* if use_op_yield... */

/* Changed pre-processor to Term: FLOW_SCHEDULE */
{mfmrw.i "wo_mstr" wo_part wo_nbr wo_lot """" wo_rel_date
   wo_due_date "wo_qty_ord - wo_qty_comp"
   "SUPPLYF" FLOW_SCHEDULE wo_site}

/* Changed pre-processor to Term: SCRAP_REQUIREMENT */
/* Make the expected scrap be visible to MRP */
{mfmrw.i "wo_scrap" wo_part wo_nbr wo_lot """"
   wo_rel_date wo_due_date
   "(wo_qty_ord - wo_qty_comp) * (1 - wo_yield_pct / 100)"
   "DEMAND" SCRAP_REQUIREMENT wo_site}

release in_mstr.

/*CREATE WO ROUTING wr_route records */
/* note wo_recno must be set, this is done above */
{gprun.i ""reworlc.p""}

/*APPLY WIP QTIES TO WO ROUTING QTIES COMPLETED.  NOTE THAT
THE  LARGER A WIP QTY IS AT AN OP THE MORE WE REDUCE DEMAND
FOR THE OP AND PREVIOUS OPS.*/

/*SCHEDULE WO ROUTING OPS ro_det records*/
/* note wo_recno must be set, this is done above */
{gprun.i ""woworle.p""}

/*EXPLODE ITEM TO GET COMPONENT LIST - first level down only */

/* Remove existing pk_det records */
{mfdel1.i pk_det "where pk_user = mfguser"}

/* Create pk_det  based on shared variable comp */
/* pk_det records are used to create the wod_det records for work order */
{gprun.i ""rerpexb.p""}

/*RECALCULATE COMPONENT DEMAND FOR MRP*/
/* Note wo_recno and pt_recno need to be set, done above */
{gprun.i ""rerpexa.p""}

release wo_mstr.

/******************************************************************/

/*   I N T E R N A L    P R O C E D U R E S     */

/******************************************************************/

/* This routine will load routing information  for a part into   */
/* a temp table.                                                 */
{gplodyld.i}

/******************************************************************/

/* This routine will determine operation yield percentage        */
/* used.                                                         */
{gpgetyld.i}

/******************************************************************/

/* INCLUDE FILE WHICH CONTAINS PROCEDURE assign_default_wo_acct */
{woacct.i}
