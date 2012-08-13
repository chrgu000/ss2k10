/* GUI CONVERTED from rssupb.p (converter v1.75) Mon Nov 13 06:36:36 2000 */
/* rssupb.p - Release Management Supplier Schedules                     */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3      LAST MODIFIED: 11/02/93           BY: WUG *GG88*  */
/* REVISION: 7.3      LAST MODIFIED: 01/24/94           BY: WUG *GI51*  */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown   */
/* REVISION: 9.1      LAST MODIFIED: 10/06/00   BY: *N0RT* Jean Miller  */
/* REVISION: 9.1      LAST MODIFIED: 11/13/00   BY: *N0TN* Jean Miller  */


/* SCHEDULE UPDATE SUBROUTINE - DELETE WORK ORDER DATA SELECTED FOR FIRM */
/*eb+sp4 retrofit on 2005/07/05 by taofengqin *tfq*                      */
         {mfdeclre.i}
/*N0RT*/ {gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

/*N0RT* &SCOPED-DEFINE rssupb_p_1 "WORK ORDER COMPONENT" */
/* MaxLen: Comment: */

/*N0RT* &SCOPED-DEFINE rssupb_p_2 "PLANNED ORDER"  */
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define input parameter firm_end_date as date.

         define shared workfile work_schd like schd_det.

         define variable work_qty as decimal.
         define variable ord_chg  as decimal.

         for each work_schd no-lock
         where schd_date <= firm_end_date,
         each wo_mstr exclusive-lock where wo_lot = schd__chr01:
/*GUI*/ if global-beam-me-up then undo, leave.


            work_qty = min(wo_qty_ord, schd_discr_qty).

            ord_chg = (wo_qty_ord - work_qty) / wo_qty_ord.

            wo_qty_ord = wo_qty_ord - work_qty.

/*N0TN*/    /* Changed pre-processor to Term: PLANNED_ORDER */
            {mfmrw.i "wo_mstr" wo_part wo_nbr wo_lot """"
               wo_rel_date wo_due_date
               wo_qty_ord "SUPPLYP" PLANNED_ORDER wo_site}

            /* USUALLY THE FOLLOWING WONT DO ANYTHING
             * BECAUSE THERE PROBABLY WONT BE ANY COMPONENTS */
            for each wr_route exclusive-lock where wr_lot = wo_lot:
                wr_qty_ord = wr_qty_ord * ord_chg.
                if ord_chg = 0 then delete wr_route.
            end.

            for each wod_det exclusive-lock where wod_lot = wo_lot:
/*GUI*/ if global-beam-me-up then undo, leave.


               wod_qty_req = wod_qty_req * ord_chg.

               {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}

/*N0TN*/       /* Changed pre-processor to TERM: WORK_ORDER_COMPONENT */
               {mfmrw.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)
                 ? wod_iss_date wod_qty_req
                 "DEMAND" WORK_ORDER_COMPONENT wod_site}

               {inmrp.i &part=wod_part &site=wod_site}

               if ord_chg = 0 then delete wod_det.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.


            {inmrp.i &part=wo_part &site=wo_site}

            if ord_chg = 0 then do:
/*FH49*/       {mfmrwdel.i "wo_scrap" wo_part wo_nbr wo_lot """"}
               delete wo_mstr.
            end.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.


