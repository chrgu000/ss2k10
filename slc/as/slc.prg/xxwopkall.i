/* wopkall.i - WORK ORDER PICK LIST HARD ALLOCATIONS                          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.12 $                                                 */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 04/03/90   BY: MLB **D024*               */
/* REVISION: 6.0      LAST MODIFIED: 05/30/90   BY: emb                       */
/* REVISION: 6.0      LAST MODIFIED: 10/05/91   BY: SMM *D887*                */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: emb *G656*                */
/* REVISION: 7.3      LAST MODIFIED: 12/16/94   BY: pxd *F09X*                */
/* REVISION: 7.3      LAST MODIFIED: 10/08/96   BY: *G2GS* Murli Shastri      */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 01/05/99   BY: *J3NJ* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7     BY: Katie Hilbert  DATE: 04/01/01 ECO: *P008*            */
/* Revision: 1.8     BY: Russ Witt      DATE: 06/04/01 ECO: *P00J*            */
/* Revision: 1.10  BY: Niranjan R. DATE: 06/25/02 ECO: *P09L* */
/* $Revision: 1.12 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N* */
/* By: Neil Gao Date: 07/11/26 ECO: * ss 20071126 * */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/***********************************************************/
/* &sort1 = field           &sort2 = "" or descending      */
/***********************************************************/

	 find first icc_ctrl  where icc_ctrl.icc_domain = global_domain no-lock.

   ldloop:

   for each ld_det  where ld_det.ld_domain = global_domain and (  ld_site =
   wod_site and ld_part = wod_part {&sort2}
   and can-find(is_mstr  where is_mstr.is_domain = global_domain and (
      is_status = ld_status and is_avail = yes))
   and ld_qty_oh - ld_qty_all > 0
   and (ld_expire > today + icc_iss_days or ld_expire = ?)
   ) exclusive-lock
   by {&sort1}:

      /* BYPASS ALLOCATION IS THIS IS A RESTRICTED TRANSACTION   */
      for first isd_det fields( isd_domain isd_status isd_tr_type
      isd_bdl_allowed)
       where isd_det.isd_domain = global_domain and  isd_status = ld_status and
       isd_tr_type = "ISS-WO"
      no-lock:
         if batchrun = no or (batchrun = yes and isd_bdl_allowed = no)
         then next ldloop.
      end.

      if qty_to_all < ld_qty_oh - ld_qty_all then
         all_this_loc = qty_to_all.
      else
         all_this_loc = ld_qty_oh - ld_qty_all.

      
     /*IF ALL AVAILABLE TO ALLOCATE OR NOT SINGLE LOT THEN CREATE LAD_DET*/

        find lad_det  where lad_det.lad_domain = global_domain and  lad_dataset
        = "wod_det"    and lad_nbr = wod_lot and lad_line = string(wod_op)
                       and lad_part = wod_part and lad_site = wod_site
                       and lad_loc = ld_loc and lad_lot = ld_lot
                       and lad_ref = ld_ref
        no-error.

        /*IF SNGL LOT AND LAD EXISTS THEN ALLOCATE ALL TO EXISTING LAD_DET*/
        if not available lad_det then do:
           create lad_det. lad_det.lad_domain = global_domain.
           assign
              lad_dataset = "wod_det"
              lad_nbr = wod_lot
              lad_line = string(wod_op)
              lad_site = wod_site
              lad_loc = ld_loc
              lad_part = wod_part
              lad_lot = ld_lot
              lad_ref = ld_ref.
        end.
        assign
           lad_qty_all = lad_qty_all + all_this_loc
           ld_qty_all  = ld_qty_all  + all_this_loc
           qty_to_all  = qty_to_all  - all_this_loc.

     if qty_to_all = 0 then leave.

   end. /*FOR EACH LD_DET*/
