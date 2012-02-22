/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*                                                                           */

/*******************************************************************************
Description:
  Inventory allocations are linked to the physical quantity via detail 
  allocations (lad_det), location allocations (ld_det) and site level 
  allocations (in_mstr).  The allocations are linked to demand via 
  sales order, work order and other order related tables that 
  allow allocations.  
The following approach should be taken to correct allocations in these tables 
(In batch):
1)	Run xxladswo.p for a site(s) to correct the allocation detail records. 
	  The following checks are made:
a.  Allocation detail records without valid souce (WO/SO) are deleted.  
b.	Allocation detail records with ? in pick or allocated are set to zero 
		quantity.
c.	Allocation detail records less than zero in picked or allocated are 
	  set to zero quantity.
d.	Sales order quantities with ? allocated are set to zero quantity 
	  (sod_qty_all).

2)	Run xxladdel.p for the site.  
		The program deletes detail allocations whose ld_det record 
		has a zero quantity on hand.

3)	Run utldqty.p.  
    The program recalculates the ld_qty_all based on lad_det records.

4)	Run utptqty.p 
		to calculate the quantity allocated based on active sales orders 
		and work orders and other order related tables.
*******************************************************************************/

{mfdtitle.i}

run pxgblmgr.p persistent set global_gblmgr_handle.

define variable lffrom        like si_site                   no-undo.
define variable lffrom1       like si_site                   no-undo.

define variable lfpart        like pt_part                   no-undo.
define variable lfpart1       like pt_part                   no-undo.


define variable lfto          like abs_shipto                no-undo.
define variable lfto1         like abs_shipto                no-undo.

define variable lfyn          like mfc_logical               no-undo.

define variable lfrecid         as recid.
define buffer lflad for lad_det.
define buffer lfsod for sod_det.

form
   lffrom         colon 18
   lffrom1        label {t001.i} colon 49
   lfpart         colon 18
   lfpart1        label {t001.i} colon 49
   lfyn           colon 18
   skip(2)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

repeat:

display
"Program xxladswo.p scans your detail allocations records for valid orders "
"Sales and Work orders.  If the sales order does not exist or the work order"
"is closed or does not exist, the record will display.  If the program is"
"run with Update set to Yes, the detail allocation will be deleted." 
with frame lf.
   
   
   
   lfyn = no.
   
   if lffrom1    = hi_char        then lffrom1   = "".
   if lfpart1    = hi_char        then lfpart1   = "".

   
   display
      lffrom
      lffrom1
      lfpart  
      lfpart1
      lfyn label "Update"
   with frame a.

   
   
   set
      lffrom
      lffrom1
      lfpart
      lfpart1
      lfyn
   with frame a.

   bcdparm = "".

   {mfquoter.i lffrom   }
   {mfquoter.i lffrom1  }
   {mfquoter.i lfpart   }
   {mfquoter.i lfpart1  }
   {mfquoter.i lfyn     }

   if lffrom1 = "" then lffrom1 = hi_char.
   if lfpart1 = "" then lfpart1   = hi_char.
   

   /* SELECT PRINTER */
   {mfselbpr.i "printer" 132}
   {mfphead.i}


   for each lad_det no-lock
      where lad_domain = global_domain and
            lad_site >=  lffrom and lad_site <= lffrom1 and 
            lad_part >=  lfpart and lad_part <= lfpart1 and
            (lad_dataset begins "so" or lad_dataset begins "wo"):
                         
     lfrecid = recid(lad_det).
     
     if lad_det.lad_dataset begins "so" then do:
        find first sod_det no-lock 
           where sod_domain = global_domain and 
                 sod_nbr    = lad_nbr and 
         string(sod_line)   = lad_line no-error.
     
     
     
        if not available sod_det then do:
     
           display lad_det.lad_dataset 
                   lad_det.lad_nbr 
                   lad_det.lad_line 
                   lad_det.lad_part 
                   lad_det.lad_site
                   lad_det.lad_qty_all 
                   lad_det.lad_qty_pick
           with down frame lfa with width 120.
        
        
           if lfyn = yes then do:
        
              find first lflad exclusive-lock where 
                   recid(lflad) = lfrecid no-error.
              if available lflad then 
              delete lflad.

           end.
        end.
     end.
     
     if not available lad_det then next.
     
     
     if lad_det.lad_dataset begins "wo" then do:
        find first wo_mstr no-lock
           where wo_domain = global_domain and
                 wo_lot    = lad_det.lad_nbr and 
                 wo_status <> "c" no-error.
        if not available wo_mstr then do:
             display lad_det.lad_dataset
                     lad_det.lad_nbr
                     lad_det.lad_line
                     lad_det.lad_part
                     lad_det.lad_site
                     lad_det.lad_qty_all
                     lad_det.lad_qty_pick
             with down frame lfa with width 120.
                  
           if lfyn = yes then do:
              find first lflad exclusive-lock where
                 recid(lflad) = lfrecid no-error.
              if available lflad then
              delete lflad.
           end.                                                 
        end.
     end.

       if not available lad_det then next.

       if (lad_det.lad_qty_all = ? or lad_det.lad_qty_pick = ?) then do:
          display lad_det.lad_dataset
                  lad_det.lad_nbr
                  lad_det.lad_line
                  lad_det.lad_part
                  lad_det.lad_site
                  lad_det.lad_qty_all
                  lad_det.lad_qty_pick
          with down frame lfa with width 120.
   
          if lfyn = yes then do:
             find first lflad exclusive-lock where
                recid(lflad) = lfrecid no-error.
             
             
             if available lflad and
             lflad.lad_qty_all = ? then 
             assign lflad.lad_qty_all = 0.

             if available lflad and
             lflad.lad_qty_pick = ? then
             assign lflad.lad_qty_pick = 0.
          
          end.
       end.
       
       
       if (lad_det.lad_qty_all < 0 or lad_det.lad_qty_pick < 0) then do:
          
          display lad_det.lad_dataset
                  lad_det.lad_nbr
                  lad_det.lad_line
                  lad_det.lad_part
                  lad_det.lad_site
                  lad_det.lad_qty_all
                  lad_det.lad_qty_pick
          with down frame lfa with width 120.
   
          if lfyn = yes then do:
             find first lflad exclusive-lock where
                recid(lflad) = lfrecid no-error.
             
             
             if available lflad and
             lflad.lad_qty_all < 0 then 
             assign lflad.lad_qty_all = 0.

             if available lflad and
             lflad.lad_qty_pick < 0 then
             assign lflad.lad_qty_pick = 0.
          
          end.
       end.
   
   end.

   for each sod_det no-lock 
      where sod_domain = global_domain and  
            sod_part  >= lfpart and 
            sod_part  <= lfpart1 and 
            sod_site  >= lffrom and
            sod_site  <= lffrom1 and 
            (sod_qty_all = ? or sod_qty_pick = ?):

      lfrecid = recid(sod_det).
      
      
      display sod_nbr sod_line sod_site sod_qty_ord sod_qty_all sod_qty_pick
      with frame lfb.
   
         if lfyn = yes then do:
            find first lfsod exclusive-lock where 
                 recid(lfsod) = lfrecid no-error.
            if available 
               sod_det and
               sod_qty_all = ? then
               sod_qty_all = 0.
            if available
               sod_det and
               sod_qty_pick = ? then
               sod_qty_pick = 0.
         
         end.   
   end.
   
   {mfrpexit.i}
   
   
   /* REPORT TRAILER */
   {mfrtrail.i}

end.