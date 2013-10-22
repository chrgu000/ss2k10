/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*V8:ConvertMode=Report                                                      */

/*******************************************************************************
Description:
  Inventory allocations are linked to the physical quantity via detail
  allocations (lad_det), location allocations (ld_det) and site level
  allocations (in_mstr).  The allocations are linked to demand via
  sales order, work order and other order related tables that
  allow allocations.
The following approach should be taken to correct allocations in these tables
(In batch):
1)  Run xxladswo.p for a site(s) to correct the allocation detail records.
    The following checks are made:
a.  Allocation detail records without valid souce (WO/SO) are deleted.
b.  Allocation detail records with ? in pick or allocated are set to zero
    quantity.
c.  Allocation detail records less than zero in picked or allocated are
    set to zero quantity.
d.  Sales order quantities with ? allocated are set to zero quantity
    (sod_qty_all).

2)  Run xxladdel.p for the site.
    The program deletes detail allocations whose ld_det record
    has a zero quantity on hand.

3)  Run utldqty.p.
    The program recalculates the ld_qty_all based on lad_det records.

4)  Run utptqty.p
    to calculate the quantity allocated based on active sales orders
    and work orders and other order related tables.
*******************************************************************************/


{mfdtitle.i}

run pxgblmgr.p persistent set global_gblmgr_handle.

define variable nbrfrom       like so_nbr                    no-undo.
define variable nbrfrom1      like so_nbr                    no-undo.

define variable lffrom        like si_site              no-undo.
define variable lffrom1       like si_site              no-undo.

define variable lfvalid as logical initial no.

form
   nbrfrom        colon 18
   nbrfrom1       label {t001.i} colon 49 skip(1)
   lffrom         colon 18
   lffrom1        label {t001.i} colon 49
   skip(1)
   lfvalid        label "Update Records" colon 49
   skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

repeat:
   if nbrfrom1   = hi_char        then nbrfrom1  = "".
   if lffrom1    = hi_char        then lffrom1   = "".

   display
      nbrfrom
      nbrfrom1
      lffrom
      lffrom1
      lfvalid
   with frame a.

   set
      nbrfrom
      nbrfrom1
      lffrom
      lffrom1
      lfvalid
   with frame a.

   bcdparm = "".
   {mfquoter.i nbrfrom   }
   {mfquoter.i nbrfrom1   }
   {mfquoter.i lffrom   }
   {mfquoter.i lffrom1  }
   {mfquoter.i lfvalid  }

   if nbrfrom1 = "" then nbrfrom1 = hi_char.
   if lffrom1 = "" then lffrom1 = hi_char.


   /* SELECT PRINTER */
   {mfselbpr.i "printer" 132}
   {mfphead.i}

    for each lad_det where lad_domain = global_domain and
                           lad_nbr >= nbrfrom and lad_nbr <= nbrfrom1 and
                           lad_site >= lffrom and lad_site <= lffrom1:
       find ld_det where
                 ld_domain = lad_domain and
                 ld_site = lad_site and
                 ld_loc = lad_loc and
                 ld_part = lad_part and
                 ld_lot = lad_lot and
                 ld_ref = lad_ref no-lock no-error.
       if available ld_det /* and ld_qty_oh = 0 */ then do:
       display lad_det with side-labels with frame lfb.

       if lfvalid then
       delete lad_det.
       end.
    end.

    for each lad_det where lad_domain = global_domain and
             lad_nbr >= nbrfrom and lad_nbr <= nbrfrom1 and
             lad_site >= lffrom and lad_site <= lffrom1:
       find ld_det where
                 ld_domain = lad_domain and
                 ld_site = lad_site and
                 ld_loc = lad_loc and
                 ld_part = lad_part and
                 ld_lot = lad_lot and
                 ld_ref = lad_ref no-lock no-error.
       if not available ld_det then do:
       display lad_det with side-labels with frame lfc.

       if lfvalid then
       delete lad_det.
       end.

   {mfrpexit.i}

   end.

   /* REPORT TRAILER */
   {mfrtrail.i}

end.