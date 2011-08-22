/* repkall.p - REPETITIVE PICK LIST HARD ALLOCATIONS                    */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.4.1.1.3.3 $                                                         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.3      LAST MODIFIED: 09/06/92       BY: emb *G071*      */
/* REVISION: 8.5      LAST MODIFIED: 09/29/97   BY: *J1PS* Felcy D'Souza*/
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb          */
/* Old ECO marker removed, but no ECO header exists *F0PN*              */
/* $Revision: 1.4.1.1.3.3 $    BY: Kirti Desai  DATE: 10/31/05  ECO: *P467*         */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
define input        parameter nbr                like lad_nbr.
define input        parameter part               like lad_part.
define input        parameter site               like lad_site.
define input        parameter location           like lad_loc.
define input        parameter reference          like lad_ref.
define input        parameter comp_max           like lad_qty_all.
define input        parameter l_use_ord_multiple like mfc_logical no-undo.
define input-output parameter qty_to_all         like lad_qty_all.

define variable all_this_loc like lad_qty_all.
define buffer lddet for ld_det.
define variable this_lot like ld_lot.
define variable qty like lad_qty_all.

define variable ord_mult like pt_ord_mult.
define variable inrecno as recid no-undo.

for first icc_ctrl
   fields(icc_ascend icc_pk_ord)
   no-lock:
end. /* FOR FIRST icc_ctrl */

for each lad_det
   fields(lad_dataset lad_line lad_loc lad_lot lad_nbr lad_part lad_qty_all
          lad_qty_pick lad_ref lad_site lad_user1 lad_user2)
   no-lock
   where lad_dataset = "rps_det"
   and   lad_nbr     = nbr
   and   lad_line    = location
   and   lad_part    = part
   and   lad_user1   = reference
   and   lad_site    = site:
   qty_to_all = max(qty_to_all - lad_qty_all - lad_qty_pick,0).
end. /* FOR EACH lad_det */

assign
   ord_mult = 0
   this_lot = ?
   qty      = qty_to_all.

if qty_to_all > 0
then do:

   for first pt_mstr
      fields(pt_abc pt_avg_int pt_cyc_int pt_ord_mult pt_part pt_rctpo_active
             pt_rctpo_status pt_rctwo_active pt_rctwo_status pt_sngl_lot)
      where pt_part = part
      no-lock:
   end. /* FOR FIRST pt_mstr */

   if pt_sngl_lot
   then do:
      for first lad_det
         fields(lad_dataset lad_line lad_loc lad_lot lad_nbr lad_part
                lad_qty_all lad_qty_pick lad_ref lad_site lad_user1 lad_user2)
         where lad_dataset  = "rps_det"
         and   lad_nbr      = nbr
         and   lad_line     = location
         and   lad_part     = part
         and  (lad_qty_all  > 0
         or    lad_qty_pick > 0)
         no-lock:
      end. /* FOR FIRST lad_det */
      if available lad_det
      then
         this_lot = lad_lot.
   end. /* IF pt_sngl_lot */

   if l_use_ord_multiple
   then
      ord_mult = pt_ord_mult.
   for first ptp_det
      fields(ptp_ord_mult ptp_part ptp_site)
      where ptp_part = part
      and   ptp_site = site
      no-lock:
   end. /* FOR FIRST ptp_det */

   if available ptp_det
   and l_use_ord_multiple
   then
      ord_mult = ptp_ord_mult.

   if icc_ascend
   then do:
      if icc_pk_ord <= 2
      then do:
         {xxrepkall.i &sort1    = "(if icc_pk_ord = 1
                                  then
                                     ld_loc
                                  else
                                     ld_lot)"
                    &part     = part
                    &site     = site
                    &nbr      = nbr
                    &dest_loc = location}
      end.
      /* IF icc_pk_ord <= 2 */
      else do:
         {xxrepkall.i &sort1    = "(if icc_pk_ord = 3
                                  then
                                     ld_date
                                  else
                                     ld_expire)"
                    &part     = part
                    &site     = site
                    &nbr      = nbr
                    &dest_loc = location}
      end. /* ELSE DO */
   end. /* IF icc_ascend */
   else do:
      if icc_pk_ord <= 2
      then do:
         {xxrepkall.i &part     = part
                    &site     = site
                    &nbr      = nbr
                    &dest_loc = location
                    &sort1    = "(if icc_pk_ord = 1
                                  then
                                     ld_loc
                                  else
                                     ld_lot)"
                    &sort2    = "descending"}
      end. /* IF icc_pk_ord <= 2 */
      else do:
         {xxrepkall.i &part     = part
                    &site     = site
                    &nbr      = nbr
                    &dest_loc = location
                    &sort1    = "(if icc_pk_ord = 3
                                  then
                                     ld_date
                                  else
                                     ld_expire)"
                    &sort2    = "descending"}
      end. /* ELSE DO */
   end. /* ELSE DO */
end. /* IF qty_to_all > 0 */

if qty <> qty_to_all
then do:

   /* gpincr.p ROUTINE IS USED TO CREATE in_mstr RECORD. */

   for first si_mstr
      fields(si_site si_cur_set si_gl_set)
      where si_site = site
      no-lock:
   end. /* FOR FIRST si_mstr */

   {gprun.i ""gpincr.p"" "(input no,
                           input part,
                           input site,
                           input if available si_mstr
                                 then
                                    si_gl_set
                                 else
                                    """",
                           input if available si_mstr
                                 then
                                    si_cur_set
                                 else
                                    """",
                           input if available pt_mstr
                                 then
                                    pt_abc
                                 else
                                    """",
                           input if available pt_mstr
                                 then
                                    pt_avg_int
                                 else
                                    0,
                           input if available pt_mstr
                                 then
                                    pt_cyc_int
                                 else
                                    0,
                           input if available pt_mstr
                                 then
                                    pt_rctpo_status
                                 else
                                    """",
                           input if available pt_mstr
                                 then
                                    pt_rctpo_active
                                 else
                                    no,
                           input if available pt_mstr
                                 then
                                    pt_rctwo_status
                                 else
                                    """",
                           input if available pt_mstr
                                 then
                                    pt_rctwo_active
                                 else
                                    no,
                           output inrecno)" }

   find in_mstr
      where recid(in_mstr) = inrecno
      exclusive-lock.

   in_qty_all = in_qty_all + qty - qty_to_all.

end. /* IF qty <> qty_to_all */
