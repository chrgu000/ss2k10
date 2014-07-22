/* dspkall.i - INTERSITE DEMAND HARD ALLOCATIONS                        */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */


/* REVISION: 7.0      LAST MODIFIED: 05/14/92   BY: emb *F611*/
/* REVISION: 7.3      LAST MODIFIED: 09/02/92   BY: emb *G526*/
/* REVISION: 8.5      LAST MODIFIED: 01/22/98   BY: *J2BS* Thomas Fernandes */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 9.0      LAST MODIFIED: 05/04/00   BY: *K25X* Vandna Rohira    */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0KW* Jacolyn Neder    */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.7.1.5  BY: Russ Witt DATE: 06/01/01 ECO: *P00J* */
/* Revision: 1.7.1.7  BY: Paul Donnelly (SB)   DATE: 06/26/03 ECO: *Q00B* */
/* $Revision: 1.7.1.8 $  BY: Ruma Bibra           DATE: 04/11/07 ECO: *P5NG* */
/*-Revision end---------------------------------------------------------------*/


/*V8:ConvertMode=Maintenance                                            */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/***********************************************************/
/* &sort1 = field           &sort2 = "" or descending      */
/***********************************************************/

ldloop:
for each ld_det
   no-lock use-index ld_part_loc
    where ld_det.ld_domain = global_domain and (  ld_site = ds_shipsite
   and ld_part = ds_part
   and ld_qty_oh - ld_qty_all > 0
   and (ld_expire > today + icc_iss_days or ld_expire = ?)
   and can-find(is_mstr  where is_mstr.is_domain = global_domain and  is_status
   = ld_status and is_avail = yes)
   ) by {&sort1} {&sort2}:

   if this_lot <> ? and ld_lot <> this_lot
      then next.

   /* BYPASS ALLOCATION IF THIS IS A RESTRICTED TRANSACTION   */
   for first isd_det fields( isd_domain isd_status isd_tr_type isd_bdl_allowed)
    where isd_det.isd_domain = global_domain and  isd_status = ld_status and
    isd_tr_type = "ISS-DO"
   no-lock:
      if batchrun = no or (batchrun = yes and isd_bdl_allowed = no)
      then next ldloop.
   end.

          if qty_to_all < ld_qty_oh - ld_qty_all                               
             then all_this_loc = qty_to_all.                                   
          else all_this_loc = ld_qty_oh - ld_qty_all.                          

/*
/*324*/   q_qty = ld_qty_oh - ld_qty_all.
/*324*/   if p_mult then do:
/*324*/      assign q_qty = q_qty - q_qty mod q_mult.
/*324*/      if q_qty <= 0 then next.
/*324*/   end.
/*324*/   if qty_to_all < q_qty
/*324*/      then all_this_loc = qty_to_all.
/*324*/   else all_this_loc = q_qty.
*/
/*
output stream b to d:\i\x\tst.txt append.
put stream b unformat ld_site " 1 " ld_loc " " ld_lot " " ld_ref " " ld_part " " q_mult " " q_qty ' ' ld_qty_oh ' ' ld_qty_all ' ' all_this_loc skip.
output stream b close.
*/
         if p_mult then do: 
            all_this_loc = all_this_loc - all_this_loc mod q_mult.
            if all_this_loc <= 0 then next.
         end.   
/*
output stream b to d:\i\x\tst.txt append.
put stream b unformat ld_site " 2 " ld_loc " " ld_lot " " ld_ref " " ld_part " " q_mult " " q_qty ' ' ld_qty_oh ' ' ld_qty_all ' ' all_this_loc skip.
output stream b close.
*/
   if pt_sngl_lot and all_this_loc < qty_to_all
      and this_lot = ?

   then do:
      for each lddet
         no-lock
          where lddet.ld_domain = global_domain and (  lddet.ld_site =
          ds_shipsite
         and lddet.ld_part = ds_part
         and lddet.ld_lot  = ld_det.ld_lot
         and lddet.ld_ref  = ld_det.ld_ref
         and can-find(is_mstr  where is_mstr.is_domain = global_domain and (
         is_status = lddet.ld_status
         and is_avail      = yes))

         and (lddet.ld_expire > today + icc_iss_days
         or lddet.ld_expire = ?)
         and lddet.ld_qty_oh - lddet.ld_qty_all > 0 ) :

         accum (lddet.ld_qty_oh - lddet.ld_qty_all) (total).
      end. /* FOR EACH LDDET */
      if (accum total lddet.ld_qty_oh - lddet.ld_qty_all) >= qty_to_all
         then this_lot = ld_det.ld_lot.
   end. /* IF PT_SNGL_LOT AND ALL_THIS_LOC < QTY_TO_ALL */

   /*IF ALL AVAILABLE TO ALLOCATE OR NOT SINGLE LOT THEN CREATE LAD_DET*/
   if all_this_loc = qty_to_all or pt_sngl_lot = no
      or (this_lot <> ? and ld_lot = this_lot)
   then do:

      find lddet exclusive-lock where recid(lddet) = recid(ld_det)
         no-error.

      find lad_det
         exclusive-lock
          where lad_det.lad_domain = global_domain and  lad_dataset = "ds_det"
         and lad_nbr     = ds_req_nbr
         and lad_line    = ds_site
         and lad_part    = ds_part
         and lad_site    = ds_shipsite
         and lad_loc     = lddet.ld_loc
         and lad_lot     = lddet.ld_lot
         and lad_ref     = lddet.ld_ref
         no-error.

      if not available lad_det then do:
         create lad_det. lad_det.lad_domain = global_domain.
         assign
            lad_dataset = "ds_det"
            lad_nbr     = ds_req_nbr
            lad_line    = ds_site
            lad_site    = ds_shipsite
            lad_loc     = lddet.ld_loc
            lad_part    = ds_part
            lad_lot     = lddet.ld_lot
            lad_ref     = lddet.ld_ref.

      end. /* IF NOT AVAILABLE LAD_DET THEN DO */

      assign
         lad_qty_all       = lad_qty_all       + all_this_loc
         lddet.ld_qty_all  = lddet.ld_qty_all  + all_this_loc
         qty_to_all        = qty_to_all        - all_this_loc.

      release lddet.
      release lad_det.
   end. /* IF ALL_THIS_LOC = QTY_TO_ALL OR PT_SNGL_LOT = NO */

   if qty_to_all = 0 then leave.

end. /*FOR EACH LD_DET*/
