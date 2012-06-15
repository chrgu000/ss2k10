/* repkall.p - REPETITIVE PICK LIST HARD ALLOCATIONS                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 7.3      LAST MODIFIED: 09/06/92       BY: emb *G071*      */
/* REVISION: 8.5      LAST MODIFIED: 09/29/97   BY: *J1PS* Felcy D'Souza*/
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb          */


/*J1PS*/ {mfdeclre.i}
         define input parameter nbr  like lad_nbr.
         define input parameter part like lad_part.
         define input parameter site like lad_site.
         define input parameter location like lad_loc.
         define input parameter reference like lad_ref.
         define input parameter comp_max like lad_qty_all.
         define input-output parameter qty_to_all like lad_qty_all.
         /* 从 repkupd.p 调用，传递阐述需求数量 qty_need 给 qty_to_all */

         define variable all_this_loc like lad_qty_all.
         define buffer lddet for ld_det.
         define variable this_lot like ld_lot.
         define variable qty like lad_qty_all.

         define variable ord_mult like pt_ord_mult.
/*J1PS*/ define variable inrecno as recid no-undo.

         find first icc_ctrl no-lock.

         for each lad_det no-lock where lad_dataset = "rps_det"
              and lad_nbr = nbr and lad_line = location and lad_part = part
              and lad_user1 = reference
              and lad_site = site:
              qty_to_all = max(qty_to_all - lad_qty_all - lad_qty_pick,0).
         end.

         this_lot = ?.
         qty = qty_to_all.

         if qty_to_all > 0 then do:

             find pt_mstr where pt_part = part no-lock no-error.
             if pt_sngl_lot then do:
                find first lad_det no-lock where lad_dataset = "rps_det"
                  and lad_nbr = nbr and lad_line = location and lad_part = part
                  and (lad_qty_all > 0 or lad_qty_pick > 0) no-error.
                if available lad_det then this_lot = lad_lot.
             end.
             /* pt_ord_mult 为1.4.7订单倍数 */
             /* ord_mult = pt_ord_mult. */
/**************
       ord_mult = pt_ord_min.
             find ptp_det no-lock where ptp_part = part
                  and ptp_site = site no-error.
             if available ptp_det then ord_mult = ptp_ord_mult.
*****************/
						 ord_mult = pt__dec01.
             if icc_ascend then do:
                 if icc_pk_ord <= 2 then do:
                    {xxrepkall.i &sort1 = "(if icc_pk_ord = 1 then
                                          ld_loc else ld_lot)"
                               &part = part         &site = site
                               &nbr = nbr           &dest_loc = location}
                 end.
                 else do:
                    {xxrepkall.i &sort1 = "(if icc_pk_ord = 3 then
                                          ld_date else ld_expire)"
                               &part = part         &site = site
                               &nbr = nbr           &dest_loc = location}
                 end.
             end.
             else do:
                 if icc_pk_ord <= 2 then do:
                     {xxrepkall.i
                        &part = part         &site = site
                        &nbr = nbr           &dest_loc = location
                        &sort1 = "(if icc_pk_ord = 1 then ld_loc else ld_lot)"
                        &sort2 = "descending"}
                 end.
                 else do:
                     {xxrepkall.i
                        &part = part         &site = site
                        &nbr = nbr           &dest_loc = location
                        &sort1 = "(if icc_pk_ord = 3 then
                                   ld_date else ld_expire)"
                        &sort2 = "descending"}
                 end.
             end.
         end.

         if qty <> qty_to_all then do:

/*J1PS** BEGIN DELETE */
/*J1PS*  FOLLOWING CODE IS COMMENTED OUT SINCE GPINCR.P ROUTINE IS USED */
/*       IN THE CREATION OF IN_MSTR RECORD. ALSO, IN_MSTR RECORD IS     */
/*       FOUND IN GPINCR.P ROUTINE BEFORE THE CREATION.                 */
/*J1PS**    find in_mstr exclusive where in_part = part and
 *                 in_site = site no-error.
 *          if not available in_mstr then do:
 *              create in_mstr.
 *              assign in_part = part in_site = site.
 *J1PS** END DELETE */

/*J1PS*  BEGIN OF ADDED CODE */
/*J1PS*  gpincr.p ROUTINE IS USED TO CREATE in_mstr RECORD. */

            find si_mstr where si_site = site no-lock no-error.
            {gprun.i ""gpincr.p"" "(input no,
                                    input part,
                                    input site,
                                    input if available si_mstr then
                                              si_gl_set
                                          else """",
                                    input if available si_mstr then
                                              si_cur_set
                                          else """",
                                    input if available pt_mstr then
                                              pt_abc
                                          else """",
                                    input if available pt_mstr then
                                              pt_avg_int
                                          else 0,
                                    input if available pt_mstr then
                                              pt_cyc_int
                                          else 0,
                                    input if available pt_mstr then
                                              pt_rctpo_status
                                          else """",
                                    input if available pt_mstr then
                                              pt_rctpo_active
                                          else no,
                                    input if available pt_mstr then
                                              pt_rctwo_status
                                          else """",
                                    input if available pt_mstr then
                                              pt_rctwo_active
                                          else no,
                                    output inrecno)" }

            find in_mstr where recid(in_mstr) = inrecno
            exclusive-lock.
/*J1PS*  END OF ADDED CODE */

/*J1PS**    end. /*IF NOT AVAILABLE in_mstr*/       */
            in_qty_all = in_qty_all + qty - qty_to_all.

         end.
