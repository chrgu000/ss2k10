/* piptcr.i - PART TAG CREATE SUBROUTINE                                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.4.1.4 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 03/06/90   BY: WUG *D015*/
/* REVISION: 6.0      LAST MODIFIED: 11/14/90   BY: WUG *D210*/
/* REVISION: 7.0      LAST MODIFIED: 09/25/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*                */
/* REVISION: 7.4      LAST MODIFIED: 10/10/96   BY: *H0N4* Murli Shastri      */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* Mark Brown         */
/* Revision: 1.4.1.2       BY: Patrick Rowan     DATE: 04/24/01  ECO: *P00G*  */
/* Revision: 1.4.1.3       BY: Jean Miller       DATE: 04/08/02  ECO: *P058*  */
/* $Revision: 1.4.1.4 $    BY: Patrick Rowan     DATE: 04/11/02  ECO: *P05G*  */
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

for each ld_det no-lock
   use-index {1}
   where ld_site >= site and ld_site <= site1
     and ld_loc >= loc and ld_loc <= loc1
     and ld_part >= part and ld_part <= part1
     and (ld_qty_oh > 0 or
         (incl_zero and ld_qty_oh = 0) or
         (incl_negative and ld_qty_oh < 0)),
    each in_mstr no-lock
   where in_part = ld_part and in_site = ld_site
     and (in_abc >= abc and in_abc <= abc1),
    each pt_mstr no-lock
   where pt_part = ld_part
     and pt_prod_line >= line and pt_prod_line <= line1
on error undo, leave:

   /* INITIALIZE QUANTITY ON-HAND */
   calculated_qty_oh = ld_qty_oh.

   /*DETERMINE CONSIGNMENT QUANTITIES */
   if using_cust_consignment then do:

      /*GET THE LOCATION DETAIL CONSIGNMENT ON-HAND QTY*/
      cust_consign_qty = ld_cust_consign_qty.

      /* IF "EXCLUDE" THEN SUBTRACT CONSIGNMENT INVENTORY QTY */
      if customer_consign_code = EXCLUDE then
         calculated_qty_oh = calculated_qty_oh - cust_consign_qty.

      /* IF "ONLY" THEN SUBTRACT THE LOCATION QTY ON-HAND  */
      /* AND ADD CONSIGNMENT INVENTORY QTY.                */
      if customer_consign_code = ONLY then
         calculated_qty_oh = calculated_qty_oh - ld_qty_oh + cust_consign_qty.

   end. /*If using_cust_consignment*/

   if using_supplier_consignment then do:

      /*GET THE LOCATION DETAIL CONSIGNMENT ON-HAND QTY*/
      supp_consign_qty = ld_supp_consign_qty.

      /* IF "EXCLUDE" THEN SUBTRACT CONSIGNMENT INVENTORY QTY */
      if supplier_consign_code = EXCLUDE then
         calculated_qty_oh = calculated_qty_oh - supp_consign_qty.

      /* IF "ONLY" THEN SUBTRACT THE LOCATION QTY ON-HAND  */
      /* AND ADD CONSIGNMENT INVENTORY QTY.                */
      if supplier_consign_code = ONLY then
         calculated_qty_oh = calculated_qty_oh - ld_qty_oh + supp_consign_qty.

   end. /*If using_supplier_consignment*/

   if calculated_qty_oh = 0
      then next.

   create tag_mstr.
   assign
      tag_nbr        = tagnbr
      tag_site       = ld_site
      tag_loc        = ld_loc
      tag_part       = ld_part
      tag_serial     = ld_lot
      tag_ref        = ld_ref
      tag_type       = "I"
      tag_crt_dt     = todays_date
      tag_cnt_cnv    = 1
      tag_rcnt_cnv   = 1
      tag__qad01     = ld_qty_oh   /* ss - 130916.1*/
      .

   tagcount = tagcount + 1.
   tagnbr = tagnbr + 1.

   if (tagnbr > 99999999) or (tagcount = avail_tags) then
      leave.

end.

/* TOTAL TAGS CREATED = */
/* ss - 130916.1 -  
{pxmsg.i &MSGNUM=1573 &ERRORLEVEL=1 &MSGARG1=tagcount}
*/