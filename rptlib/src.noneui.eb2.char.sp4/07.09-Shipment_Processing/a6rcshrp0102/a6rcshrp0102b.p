/* rcshrp1b.p - Shipper  Report - PRINT SHIPPER LINES                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.6.1.5 $                                                         */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 8.6      LAST MODIFIED: 10/09/96   BY: *K003* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 04/25/97   BY: *K0CH* Taek-Soo Chang    */
/* REVISION: 8.6      LAST MODIFIED: 07/30/97   BY: *K0H7* Taek-Soo Chang    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 09/23/99   BY: *K230* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb               */
/* REVISION: 9.1      LAST MODIFIED: 01/25/01   BY: *M101* Rajesh Thomas     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.6.1.5 $    BY: Katie Hilbert         DATE: 04/15/02  ECO: *P03J*  */
/* $Revision: 1.6.1.5 $    BY: Bill Jiang         DATE: 05/22/06  ECO: *SS - 20060522.1*  */
/* $Revision: 1.6.1.5 $    BY: Bill Jiang         DATE: 06/01/06  ECO: *SS - 20060601.2*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
                                                                                       
/* SS - 20060601.2 - B */
/*
1. 增加了以下输出字段:
   abs_arr_date:到达日期
   abs_cmtindx:备注
2. 执行列表:
   a6rcshrp0102.p   
   a6rcshrp0102b.p*
*/
/* SS - 20060601.2 - E */

/* SS - 20060522.1 - B */
/*
1. 增加了以下字段的输出:
   推销员
   销往
   发往
   采购单
   批序号
   订单日期
   截止日期
   承运人
   运输方式
   车辆标志
   件数
2. 执行列表:
   a6rcshrp0102.p   
   a6rcshrp0102b.p
*/
/* SS - 20060522.1 - E */

/* SS - 20060522.1 - B */
{a6rcshrp0102.i}

DEFINE SHARED VARIABLE s_shipfrom LIKE ABS_shipfrom.
DEFINE SHARED VARIABLE s_shipto LIKE ABS_shipto.
DEFINE SHARED VARIABLE s_inv_mov LIKE ABS_inv_mov.
DEFINE SHARED VARIABLE s_id LIKE abs_id.

DEFINE SHARED VARIABLE s_id2 LIKE abs_id.
DEFINE SHARED VARIABLE s_trans_mode LIKE abs__qad01.
DEFINE SHARED VARIABLE s_veh_ref LIKE abs__qad01.
DEFINE SHARED VARIABLE s_dec02 LIKE ABS__dec02.

/* SS - 20060601.2 - B */
DEFINE SHARED VARIABLE s_arr_date LIKE ABS_arr_date.
DEFINE SHARED VARIABLE s_cmtindx LIKE ABS_cmtindx.
/* SS - 20060601.2 - E */

DEFINE VARIABLE slspsn LIKE so_slspsn.
DEFINE VARIABLE cust LIKE so_cust.
DEFINE VARIABLE ship LIKE so_ship.
DEFINE VARIABLE po LIKE so_po.
DEFINE VARIABLE ord_date LIKE so_ord_date.
DEFINE VARIABLE sodue_date LIKE so_due_date.
/* SS - 20060522.1 - E */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* INPUT PARAM */
define input parameter abs_recid  as recid.
define input parameter indent_ct  as integer.
define input parameter sched_date as date.

/* SHARED VARIABLE */
define shared variable part   like pt_part no-undo.
define shared variable part1  like pt_part no-undo.
define shared variable sonbr  like so_nbr no-undo.
define shared variable sonbr1 like so_nbr no-undo.
define shared variable stype  as character no-undo.
define shared frame c.

/* LOCAL VARIABLE */
define variable indent_id     as character format "x(12)" label "Type".
define variable par_shipfrom  as character.
define variable par_id        as character.
define variable open_qty      like sod_qty_ord label "Open Qty".
define variable due_date      like sod_due_date.
define variable sched_netting as logical initial no.
define variable l_shipper_po  like sod_contr_id format "x(22)" no-undo.

form
   indent_id
   abs_item     column-label "Ship-To!Item Number!Model Year"
   scx_po       column-label "ID!PO Number!Customer Ref"
   abs_site     column-label "Ship-From!Site"
   abs_order    column-label "Inv Mov!Order"
   abs_line     column-label "Line"
   pt_um
   open_qty
   due_date
   abs_qty      format "->,>>>,>>9.9<<<"
   abs_shp_date
with frame c down width 132 no-box.

/* SS - 20060522.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).
*/
/* SS - 20060522.1 - E */

find abs_mstr where recid(abs_mstr) = abs_recid no-lock.

if indent_ct = 0 or
   abs_id begins "c" or
   ((abs_item >= part and abs_item <= part1) and
   (abs_order >= sonbr and abs_order <= sonbr1))
then do:

   find pt_mstr where pt_part = abs_item no-lock no-error.

   if indent_ct = 0 then
      indent_id = stype.
   else
      indent_id = substring("...........",1,indent_ct) +
                  if abs_id begins "i" then "I" else abs_id.

   indent_id = caps(indent_id).

   find so_mstr where so_nbr = abs_order no-lock no-error.
   find sod_det where sod_nbr = abs_order and
                      sod_line = integer(abs_line)
   no-lock no-error.

   /* SS - 20060522.1 - B */
   IF AVAILABLE so_mstr THEN DO:
      ASSIGN
         slspsn[1] = so_slspsn[1]
         cust = so_cust
         ship = so_ship
         po = so_po
         ord_date = so_ord_date
         sodue_date = so_due_date
         .
   END.
   ELSE DO:
      for first ih_hist
         where ih_nbr = abs_order no-lock:
         ASSIGN
            slspsn[1] = ih_slspsn[1]
            cust = ih_cust
            ship = ih_ship
            po = ih_po
            ord_date = ih_ord_date
            sodue_date = ih_due_date
            .
      END.
   END.
   /* SS - 20060522.1 - E */

   if available sod_det
   then do:
      if sod_sched
      then do:
         {gprun.i ""rcoqty.p""
            "(input recid(sod_det),
              input sched_date,
              input sched_netting,
              output open_qty)"}.
         due_date = sched_date.
      end.
      else
         assign
            due_date = sod_due_date
            open_qty = sod_qty_ord - sod_qty_ship.
   end.  /* if available sod_det */
   else
      open_qty = 0.

   if available sod_det
   then do:
      if sod_sched then
         l_shipper_po = sod_contr_id.
      else
      if available so_mstr then
         l_shipper_po = so_ship_po.
   end. /* IF AVAILABLE SOD_DET */
   else do:
      for first idh_hist
         fields(idh_contr_id idh_line idh_nbr idh_part idh_sched)
         where idh_nbr = abs_order
           and idh_line = integer (abs_line)
           and idh_part = abs_item no-lock:
      end. /* FOR FIRST IDH_HIST */
      if available idh_hist
      then do:
         if idh_sched then
            l_shipper_po = idh_contr_id.
         else
            for first ih_hist
               fields(ih_nbr ih_ship_po)
               where ih_nbr = idh_nbr no-lock:
               l_shipper_po = ih_ship_po.
            end. /* FOR FIRST IH_HIST */
      end. /* IF AVAILABLE IDH_HIST */
      else
         l_shipper_po = "".
   end. /* IF NOT AVAILABLE SOD_DET */

   /* SS - 20060522.1 - B */
   /*
   if indent_ct = 0
   then
      display
         indent_id
         abs_shipfrom        @ abs_site
         abs_shipto          @ abs_item
         abs_inv_mov         @ abs_order
         substring(abs_id,2) @ scx_po
      with frame c.
   else do:
      display
         indent_id
         abs_item
         l_shipper_po @ scx_po
         abs_site
         abs_order
         string(integer(abs_line),">>>9") format "x(4)" @ abs_line
         abs_qty
         pt_um      when (available pt_mstr)
         open_qty
         due_date
         abs_shp_date
      with frame c.
      down 1 with frame c.
      display
         sod_modelyr when (available sod_det) @ abs_item
         sod_custref when (available sod_det) @ scx_po
      with frame c.
   end.

   down 1 with frame c.
   */
   if indent_ct = 0
   then
      ASSIGN
      s_shipfrom = ABS_shipfrom
      s_shipto = ABS_shipto
      s_inv_mov = ABS_inv_mov
      s_id = substring(abs_id,2)

      s_id2 = abs_id
      s_trans_mode = substring(abs__qad01,61,20,"RAW")
      s_veh_ref    = substring(abs__qad01,81,20,"RAW")
      s_dec02 = ABS__dec02
      /* SS - 20060601.2 - B */
      s_arr_date = ABS_arr_date
      s_cmtindx = ABS_cmtindx
      /* SS - 20060601.2 - E */
      .
   else do:
      CREATE tta6rcshrp0102.
      ASSIGN
         tta6rcshrp0102_abs_shipfrom = s_shipfrom
         tta6rcshrp0102_abs_shipto = s_shipto
         tta6rcshrp0102_abs_inv_mov = s_inv_mov
         tta6rcshrp0102_abs_id = s_id

         tta6rcshrp0102_abs_item = abs_ITEM
         tta6rcshrp0102_shipper_po = l_shipper_po
         tta6rcshrp0102_abs_site = abs_site
         tta6rcshrp0102_abs_order = ABS_order
         tta6rcshrp0102_abs_line = ABS_line
         tta6rcshrp0102_abs_qty = ABS_qty
         tta6rcshrp0102_open_qty = OPEN_qty
         tta6rcshrp0102_due_date = due_date
         tta6rcshrp0102_abs_shp_date = ABS_shp_date

         tta6rcshrp0102_slspsn[1] = slspsn[1]
         tta6rcshrp0102_cust = cust
         tta6rcshrp0102_ship = ship
         tta6rcshrp0102_po = po
         tta6rcshrp0102_abs_lotser = abs_lotser
         tta6rcshrp0102_ord_date = ord_date
         tta6rcshrp0102_so_due_date = sodue_date

         tta6rcshrp0102_trans_mode = s_TRANS_mode
         tta6rcshrp0102_veh_ref = s_veh_ref
         tta6rcshrp0102_dec02 = s_dec02

         /* SS - 20060601.2 - B */
         tta6rcshrp0102_abs_arr_date = s_arr_date
         tta6rcshrp0102_abs_cmtindx = s_cmtindx
         /* SS - 20060601.2 - E */
         .
      IF AVAILABLE pt_mstr THEN DO:
         ASSIGN
            tta6rcshrp0102_pt_um = pt_um
            .
      END.

      find first absc_det
      where absc_abs_id = s_id2 NO-LOCK no-error.
      if available absc_det then do:
         ASSIGN
            tta6rcshrp0102_carrier = absc_carrier
            .
      end. /* IF NOT AVAILABLE ABSC_DET */
   end.
   /* SS - 20060522.1 - E */

end.

if abs_id begins "i" then return.

assign
   par_shipfrom = abs_shipfrom
   par_id = abs_id.

for each abs_mstr no-lock
   where abs_shipfrom = par_shipfrom
     and abs_par_id = par_id:

   if (abs_order >= sonbr and abs_order <= sonbr1 and
       abs_item  >= part  and abs_item  <= part1) or
      abs_id begins "c"
   then do:

      /* SS - 20060522.1 - B */
      /*
      {gprun.i ""rcshrp1b.p""
         "(input recid(abs_mstr),
           input (indent_ct + 1),
           input sched_date)"}
         */
      {gprun.i ""a6rcshrp0102b.p""
         "(input recid(abs_mstr),
           input (indent_ct + 1),
           input sched_date)"}
         /* SS - 20060522.1 - E */
   end.
end.
