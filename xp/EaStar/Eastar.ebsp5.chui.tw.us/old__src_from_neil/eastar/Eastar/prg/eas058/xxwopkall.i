/* wopkall.i - WORK ORDER PICK LIST HARD ALLOCATIONS                    */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 6.0      LAST MODIFIED: 04/03/90   BY: MLB **D024**/
/* REVISION: 6.0      LAST MODIFIED: 05/30/90   BY: emb */
/* REVISION: 6.0      LAST MODIFIED: 10/05/91   BY: SMM *D887*/
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: emb *G656*/
/* REVISION: 7.3      LAST MODIFIED: 12/16/94   BY: pxd *F09X*/
/* REVISION: 7.3      LAST MODIFIED: 10/08/96   BY: *G2GS* Murli Shastri */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan    */
/* REVISION: 9.0      LAST MODIFIED: 01/05/99   BY: *J3NJ* Vandna Rohira */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb           */
/* Revision: eB.SP5.Chui    Modified: 08/14/06  By: Kaine Zhang     *ss-20060818.1* */

/***********************************************************/
/* &sort1 = field           &sort2 = "" or descending      */
/***********************************************************/

/*F09X*/ find first icc_ctrl no-lock.

      
/* ********************ss-20060818.1 B Del*******************
 *        for each ld_det where ld_site = wod_site
 *                          and ld_part = wod_part
 *  /*G2GS*/ and (ld_lot = if this_lot = ? then ld_lot else this_lot)
 *        and can-find(is_mstr where is_status = ld_status and is_avail = yes)
 *        and ld_qty_oh - ld_qty_all > 0
 *  
 *  /*F09X and (ld_expire > today or ld_expire = ?)  /*07/13/90*/  */
 *  
 *  /*F09X*/ and (ld_expire > today + icc_iss_days
 *  /*F09X*/ or ld_expire = ?)
 *  
 *  /*J3NJ*/ exclusive-lock
 *  
 *           by {&sort1} {&sort2}:
 * ********************ss-20060818.1 E Del*******************/

    /* ***********************ss-20060818.1 B Add********************** */
    FOR EACH ld_det WHERE ld_site = wod_site
        AND ld_part = wod_part
        AND (ld_lot = if this_lot = ? THEN ld_lot ELSE this_lot)
        AND CAN-FIND(is_mstr WHERE is_status = ld_status AND is_avail = YES)
        AND ld_qty_oh - ld_qty_all > 0
        AND (ld_expire > today + icc_iss_days OR ld_expire = ?)
        EXCLUSIVE-LOCK
        ,
    EACH tmploc_tmp
        WHERE tmploc_loc = ld_loc
        BY tmploc_lev
        BY {&sort1} {&sort2}:
    /* ***********************ss-20060818.1 E Add********************** */

     if this_lot <> ? and ld_lot <> this_lot
     then next.

     if qty_to_all < ld_qty_oh - ld_qty_all
     then all_this_loc = qty_to_all.
     else all_this_loc = ld_qty_oh - ld_qty_all.

     if pt_sngl_lot and all_this_loc < qty_to_all
     and this_lot = ?
     then do for lddet:
        for each lddet
/*G656*/    no-lock
        where lddet.ld_site = wod_site
        and lddet.ld_part = wod_part and lddet.ld_lot = ld_det.ld_lot
/*G2GS* /*D887*/    and lddet.ld_ref  = ld_det.ld_ref */
        and can-find(is_mstr where is_status = lddet.ld_status
        and is_avail = yes)
/*G2GS*     and (ld_expire > today or ld_expire = ?)  /*07/13/90*/ */
/*G2GS*/    and (ld_expire > today + icc_iss_days or ld_expire = ?)
        and lddet.ld_qty_oh - lddet.ld_qty_all > 0:
           accum (lddet.ld_qty_oh - lddet.ld_qty_all) (total).
        end.
        if (accum total lddet.ld_qty_oh - lddet.ld_qty_all) >= qty_to_all
        then this_lot = ld_det.ld_lot.
     end.

     /*IF ALL AVAILABLE TO ALLOCATE OR NOT SINGLE LOT THEN CREATE LAD_DET*/
     if all_this_loc = qty_to_all or pt_sngl_lot = no
     or (this_lot <> ? and ld_lot = this_lot)
     then do:
        find lad_det where lad_dataset = "wod_det"
/*G656*     and lad_nbr = wod_nbr and lad_line = wod_lot */
/*G656*/    and lad_nbr = wod_lot and lad_line = string(wod_op)
        and lad_part = wod_part and lad_site = wod_site
        and lad_loc = ld_loc and lad_lot = ld_lot
/*D887*/    and lad_ref = ld_ref
        no-error.

        /*IF SNGL LOT AND LAD EXISTS THEN ALLOCATE ALL TO EXISTING LAD_DET*/
        if not available lad_det then do:
           create lad_det.
           assign
           lad_dataset = "wod_det"
/*G656*        lad_nbr = wod_nbr
           lad_line = wod_lot */
/*G656*/       lad_nbr = wod_lot
/*G656*/       lad_line = string(wod_op)
           lad_site = wod_site
           lad_loc = ld_loc
           lad_part = wod_part
           lad_lot = ld_lot
/*D887*/       lad_ref = ld_ref.
        end.
        lad_qty_all = lad_qty_all + all_this_loc.
        ld_qty_all  = ld_qty_all  + all_this_loc.
        qty_to_all  = qty_to_all  - all_this_loc.
     end.

     if qty_to_all = 0 then leave.

      end. /*FOR EACH LD_DET*/
