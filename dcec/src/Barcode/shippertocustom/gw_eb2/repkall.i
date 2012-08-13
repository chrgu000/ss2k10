/* GUI CONVERTED from repkall.i (converter v1.78) Fri Oct 29 14:34:01 2004 */
/* repkall.i - REPETITIVE PICK LIST HARD ALLOCATIONS                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.3.2.2 $                                     */
/* REVISION: 7.3      LAST MODIFIED: 09/06/92   BY: emb *G071*/
/* REVISION: 7.3      LAST MODIFIED: 11/08/94   BY: ais *GO35*/
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb          */
/* $Revision: 1.3.2.2 $    BY: Russ Witt  DATE: 06/01/01 ECO: *P00J*  */

/*V8:ConvertMode=Maintenance                                            */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

ldloop:
for each ld_det where ld_site = {&site}
   and ld_part = {&part}
   and can-find(is_mstr where is_status = ld_status and is_avail = yes)
   and ld_qty_oh - ld_qty_all > 0
   and (ld_expire > today or ld_expire = ?)
   and ld_loc <> {&dest_loc}
   and not can-find(first wc_mstr where wc_wkctr = ld_loc)
   by {&sort1} {&sort2}:

   find first wc_mstr no-lock where wc_wkctr = ld_loc no-error.
   if available wc_mstr then next.

   if this_lot <> ? and ld_lot <> this_lot then next.

   /* BYPASS ALLOCATION IF THIS IS A RESTRICTED TRANSACTION   */
   for first isd_det fields (isd_status isd_tr_type isd_bdl_allowed)
   where isd_status = ld_status and isd_tr_type = "ISS-TR"
   no-lock:
      if batchrun = no or (batchrun = yes and isd_bdl_allowed = no)
      then next ldloop.
   end.

   if qty_to_all < ld_qty_oh - ld_qty_all
      then all_this_loc = qty_to_all.
   else all_this_loc = ld_qty_oh - ld_qty_all.

 /*  if ord_mult <> 0 and
      all_this_loc / ord_mult <> truncate(all_this_loc / ord_mult,0)
      then
   all_this_loc = min(ld_qty_oh - ld_qty_all,
      (truncate (all_this_loc / ord_mult,0) + 1) * ord_mult).
*/
   if pt_sngl_lot and all_this_loc < qty_to_all
      and this_lot = ?
      then do for lddet:
         for each lddet
               no-lock
               where lddet.ld_site = {&site}
               and lddet.ld_part = {&part} and lddet.ld_lot = ld_det.ld_lot
               and can-find(is_mstr where is_status = lddet.ld_status
               and is_avail = yes)
               and (lddet.ld_expire > today or lddet.ld_expire = ?)
               and lddet.ld_loc <> {&dest_loc}
               and lddet.ld_qty_oh - lddet.ld_qty_all > 0:
            accum (lddet.ld_qty_oh - lddet.ld_qty_all) (total).
         end.
         if (accum total lddet.ld_qty_oh - lddet.ld_qty_all) >= qty_to_all
            then this_lot = ld_det.ld_lot.
      end.

      /*IF ALL AVAILABLE TO ALLOCATE OR NOT SINGLE LOT THEN CREATE LAD_DET*/
      if all_this_loc >= qty_to_all or pt_sngl_lot = no
         or (this_lot <> ? and ld_lot = this_lot)
      then do:
         find first
            lad_det where lad_dataset = "rps_det"
            and lad_nbr = {&nbr} and lad_line = {&dest_loc}
            and lad_part = {&part} and lad_site = {&site}
            and lad_loc = ld_loc and lad_lot = ld_lot
            and lad_ref = ld_ref
            and lad_user1 = reference
            no-error.

         /*IF SNGL LOT AND LAD EXISTS THEN ALLOCATE ALL TO EXISTING LAD_DET*/
         if not available lad_det then do:
            create lad_det.
            assign
               lad_dataset = "rps_det"
               lad_nbr = {&nbr}
               lad_line = {&dest_loc}
               lad_site = {&site}
               lad_loc = ld_loc
               lad_part = {&part}
               lad_ref = ld_ref
               lad_lot = ld_lot.
            lad_user1 = reference.
            lad_user2 = string(comp_max).
         end.
         lad_qty_all = lad_qty_all + all_this_loc.
         ld_qty_all  = ld_qty_all  + all_this_loc.
         qty_to_all  = qty_to_all  - all_this_loc.
      end.

      if qty_to_all = 0 then leave.
      if qty_to_all < 0 then leave.

   end. /*FOR EACH LD_DET*/
