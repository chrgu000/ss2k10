/* socnrp1b.p - Consignment Cross Reference Sub-pgm - Sort ShipFrom/Item      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14 $                                             */

/******************************************************************************/
/* Notes: This program reports the Customer consignment cross reference by    */
/*        Ship-From, Item, Customer, Ship-to, Order, and PO.                  */
/*                                                                            */
/******************************************************************************/


/* Revision: 1.12     BY: Steve Nugent   DATE: 04/04/02  ECO:  *P00F* */
/* $Revision: 1.14 $      BY: Dan Herman     DATE: 06/19/02  ECO:  *P091* */
/* $Revision: 1.14 $      BY: Bill Jiang     DATE: 06/01/06  ECO:  *SS - 20060601.1* */

/*V8:ConvertMode=Report                                             */


/*                                                                            */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----    */
/*                                                                            */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.             */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN          */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO   */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.  */
/*                                                                            */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----    */
/*                                                                            */

/* SS - 20060601.1 - B */
/*
1. 标准输入输出
*/
/* SS - 20060601.1 - E */

/* SS - 20060601.1 - B */
{a6socnrp0101.i}
/* SS - 20060601.1 - E */


{mfdeclre.i}
{gplabel.i}
{wbrp02.i}

{socnvars.i}


define input parameter shipfrom_from like cncix_site no-undo.
define input parameter shipfrom_to like cncix_site no-undo.
define input parameter cust_from   like cncix_cust no-undo.
define input parameter cust_to    like cncix_cust no-undo.
define input parameter shipto_from like cncix_shipto no-undo.
define input parameter shipto_to  like cncix_shipto no-undo.
define input parameter part_from  like cncix_part no-undo.
define input parameter part_to    like cncix_part no-undo.
define input parameter po_from    like cncix_po no-undo.
define input parameter po_to      like cncix_po no-undo.
define input parameter order_from like cncix_so_nbr no-undo.
define input parameter order_to   like cncix_so_nbr no-undo.
define input parameter date_from  like cncix_ship_date no-undo.
define input parameter date_to    like cncix_ship_date no-undo.
define input parameter show_amts  like mfc_logical no-undo.


define variable site_description like ad_name no-undo.
define variable cust_description like cm_sort no-undo.
define variable part_description like pt_desc1 no-undo.
define variable ship_description like si_desc no-undo.
define variable new_header       like mfc_logical no-undo.
define variable curr_error1      as character no-undo.
define variable curr_error2      as character no-undo.
define variable qoh_value        as decimal label "QOH Value" no-undo.
define variable qoh_base_curr    as decimal
                                    label "QOH Value Base Currency" no-undo.
define variable sales_order      as character label "Sales Order" no-undo.
define variable ex_rate1         like so_ex_rate no-undo.
define variable ex_rate2         like so_ex_rate no-undo.
define variable mc-error-number  like msg_nbr no-undo.

define buffer bf_sod_det for sod_det.

/* HEADER FRAME */
 form
skip(2)
   cncix_site         colon 12
   site_description   colon 33 format "x(22)" no-label
   cncix_so_nbr       colon 70 label "Sales Order"
   cncix_sod_line
   cncix_cust         colon 12 label "Customer"
   cust_description   colon 33 no-label
   cncix_shipto       colon 12
   ship_description   colon 33 no-label
   cncix_part         colon 12
   part_description   colon 33 format "x(22)" no-label
   cncix_po           colon 12 label "PO Number"
   max_aging_days     colon 83 label "Maximum Aging Days"
with frame xref_header side-labels width 132 no-box.

/* SS - 20060601.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame xref_header:handle).
*/
/* SS - 20060601.1 - E */



/* DETAIL FRAME */
form
   cncix_current_loc   at 1
   cncix_lotser        at 11 column-label "Lot/Serial!Ref"
   cncix_auth          at 31 format "x(20)"
   cncix_qty_stock     at 53 column-label "Quantity!In-Stock"
   cncix_stock_um      at 68
   cncix_qty_ship      at 72  column-label "Qty Shipped"
   cncix_asn_shipper   at 87  column-label "Shipper!In-Transit"
   cncix_ship_date     at 109 column-label "Ship Date!Max Age Date"
with frame detail down width 132 attr-space.

/* SS - 20060601.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame detail:handle).
*/
/* SS - 20060601.1 - E */



/* CURRENCY FRAME */
form
  skip(1)
  space(10)
  sales_order
  space(2)
  qoh_value
  cncix_curr    no-label
  qoh_base_curr colon 100
  gl_base_curr  no-label
with frame currency side-labels width 132 no-box.

/* SS - 20060601.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame currency:handle).
*/
/* SS - 20060601.1 - E */



/* ERRORS FRAME */
form
  skip(1)
  space(10)
  curr_error1 no-label
  curr_error2 no-label
with frame errors width 132 attr-space.


PROCEDURE get_ship_name:
   define input parameter ip_shipto like cncix_shipto no-undo.
   define output parameter op_shipname like ad_name no-undo.

   op_shipname = "".

   for first si_mstr no-lock
       where si_site = ip_shipto:
       op_shipname = si_desc.
   end.
   if not available si_mstr then
      for first ad_mstr no-lock
          where ad_addr = ip_shipto:
          op_shipname = ad_name.
      end.

END PROCEDURE. /*get_ship_name*/


PROCEDURE get_site_name:
   define input parameter ip_shipfrom like si_site no-undo.
   define output parameter op_sitename like si_desc no-undo.

   op_sitename = "".

   for first si_mstr no-lock
       where si_site = ip_shipfrom:
       op_sitename = si_desc.
   end.

END PROCEDURE. /*get_site_name*/


PROCEDURE get_cust_name:
   define input parameter ip_cust like cm_addr no-undo.
   define output parameter op_cust_name like cm_sort no-undo.

   op_cust_name = "".
   for first cm_mstr no-lock
       where cm_addr = ip_cust:
      op_cust_name = cm_sort.
   end.

END PROCEDURE. /*get_cust_name*/

PROCEDURE get_part_desc:
   define input parameter ip_part like pt_part no-undo.
   define output parameter op_partdesc like pt_desc1 no-undo.

   op_partdesc = "".
   for first pt_mstr no-lock
       where pt_part = ip_part:
       op_partdesc = pt_desc1.
   end.
END PROCEDURE. /*get_part_desc*/


for first gl_ctrl no-lock:
end.

for each cncix_mstr no-lock where
         cncix_site      >= shipfrom_from      and
         cncix_site      <= shipfrom_to        and
         cncix_cust      >= cust_from          and
         cncix_cust      <= cust_to            and
         cncix_shipto    >= shipto_from        and
         cncix_shipto    <= shipto_to          and
         cncix_part      >= part_from          and
         cncix_part      <= part_to            and
         cncix_po        >= po_from            and
         cncix_po        <= po_to              and
         cncix_so_nbr    >= order_from         and
         cncix_so_nbr    <= order_to           and
         cncix_ship_date >= date_from          and
         cncix_ship_date <= date_to
         break by cncix_site
               by cncix_part
               by cncix_cust
               by cncix_shipto
               by cncix_so_nbr
               by cncix_sod_line
               by cncix_po:

   new_header = no.
   accumulate cncix_qty_stock (total by cncix_po).
   accumulate cncix_ship_value (total by cncix_sod_line).

   if first-of(cncix_site) then do:
      run get_site_name
      (input cncix_site,
      output site_description).
      new_header = yes.

   end.

   if first-of(cncix_part) then do:
      run get_part_desc
      (input cncix_part,
       output part_description).
      new_header = yes.
   end. /*IF FIRST-OF*/

   if first-of(cncix_cust) then do:
      run get_cust_name
      (input cncix_cust,
       output cust_description).
      new_header = yes.
   end. /*IF FIRST-OF*/

   if first-of(cncix_shipto) then do:
      run get_ship_name
      (input cncix_shipto,
       output ship_description).
      new_header = yes.
   end. /*IF FIRST-OF*/

   if first-of(cncix_so_nbr) then
      new_header = yes.

   if first-of(cncix_sod_line) then do:
      assign
         new_header = yes
         max_aging_days = 0.
      /* FIND THE MAX AGING DAYS ON THE ORDER/LINE */
      for first bf_sod_det no-lock where
         bf_sod_det.sod_nbr = cncix_so_nbr and
         bf_sod_det.sod_line = cncix_sod_line:
         max_aging_days = sod_max_aging_days.
      end.
   end.  /* if first-of(cncix_sod_line) */

   if first-of(cncix_po) then
      new_header = yes.

   /* SS - 20060601.1 - B */
   /*
   if new_header then do:
      display
      cncix_site
      site_description
      cncix_so_nbr
      cncix_sod_line
      cncix_cust
      cust_description
      cncix_shipto
      ship_description
      cncix_part
      part_description
      cncix_po
      max_aging_days
      skip(1)
      with frame xref_header.
   end.


   display
      cncix_current_loc
      cncix_lotser
      cncix_auth
      cncix_qty_stock
      cncix_stock_um
      cncix_qty_ship
      cncix_asn_shipper
      cncix_ship_date
      with frame detail.
      down 1 with frame detail.

   display
      cncix_ref           @ cncix_lotser
      cncix_intransit     @ cncix_asn_shipper
      cncix_aged_date     @ cncix_ship_date
   with frame detail.
   down 1 with frame detail.

   display
      cncix_auth @ cncix_lotser
   with frame detail.
   down 1 with frame detail.
   */
   CREATE tta6socnrp0101.
   ASSIGN
      tta6socnrp0101_cncix_site = cncix_site
      tta6socnrp0101_site_description = site_description
      tta6socnrp0101_cncix_so_nbr = cncix_so_nbr
      tta6socnrp0101_cncix_sod_line = cncix_sod_line
      tta6socnrp0101_cncix_cust = cncix_cust
      tta6socnrp0101_cust_description = cust_description
      tta6socnrp0101_cncix_shipto = cncix_shipto
      tta6socnrp0101_ship_description = ship_description
      tta6socnrp0101_cncix_part = cncix_part
      tta6socnrp0101_part_description = part_description
      tta6socnrp0101_cncix_po = cncix_po
      tta6socnrp0101_max_aging_days = max_aging_days
      tta6socnrp0101_cncix_current_loc = cncix_current_loc
      tta6socnrp0101_cncix_lotser = cncix_lotser
      tta6socnrp0101_cncix_auth = cncix_auth
      tta6socnrp0101_cncix_qty_stock = cncix_qty_stock
      tta6socnrp0101_cncix_stock_um = cncix_stock_um
      tta6socnrp0101_cncix_qty_ship = cncix_qty_ship
      tta6socnrp0101_cncix_asn_shipper = cncix_asn_shipper
      tta6socnrp0101_cncix_ship_date = cncix_ship_date
      tta6socnrp0101_cncix_ref = cncix_ref
      tta6socnrp0101_cncix_intransit = cncix_intransit
      tta6socnrp0101_cncix_aged_date = cncix_aged_date
      .
   /* SS - 20060601.1 - E */

   /* SS - 20060601.1 - B */
   /*
   if last-of(cncix_po) then do:
      underline
         cncix_qty_stock
         with frame detail.
      display
         (accum total by cncix_po cncix_qty_stock) @ cncix_qty_stock
         with frame detail.
      down with frame detail.
   end.  /* if last-of(cncix_po) */


   if last-of(cncix_sod_line) and show_amts then do:

      assign
        sales_order = cncix_so_nbr
        qoh_value = accum total by cncix_sod_line cncix_ship_value.

      if cncix_curr <> gl_base_curr then do:

         {gprunp.i "mcpl" "p" "mc-get-ex-rate"
               "(input cncix_curr,
                 input gl_base_curr,
                 input """",
                 input cncix_ship_date,
                 output ex_rate1,
                 output ex_rate2,
                 output mc-error-number)"}.

         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number
                     &ERRORLEVEL=2
                     &MSGBUFFER=curr_error1}
         end.

         {gprunp.i "mcpl" "p" "mc-curr-conv"
           "(input cncix_curr,
             input gl_base_curr,
             input ex_rate1,
             input ex_rate2,
             input qoh_value,
             input false,
             output qoh_base_curr,
             output mc-error-number)"}.

         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number
                     &ERRORLEVEL=2
                     &MSGBUFFER=curr_error2}
         end.
      end. /* IF cncix_curr <> gl_base_curr */
      else qoh_base_curr = qoh_value.

      display
         sales_order
         qoh_value
         cncix_curr
         qoh_base_curr
         gl_base_curr
      with frame currency.

      display
         curr_error1 when (curr_error1 <> "")
         curr_error2 when (curr_error2 <> "")
      with frame errors.
   end.
   */
   /* SS - 20060601.1 - E */

   {mfrpchk.i}
end. /*FOR EACH CNCIX_REF*/
