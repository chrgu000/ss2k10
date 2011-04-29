/* reupdscb.p - REPETITIVE                                                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/* REVISION: 7.3               LAST MODIFIED: 10/31/94   BY: WUG *GN77*       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/05/00   BY: *N0RQ* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 11/13/00   BY: *N0TN* Jean Miller        */
/* $Revision: 1.10 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/*-Revision end---------------------------------------------------------------*/


/* SUBPROGRAM TO UPDATE REPETITIVE SCHEDULE -                                 */
/* UPDATES SCHEDULE WORK ORDER AND SCHEDULE RECORD                            */

         {mfdeclre.i}
/*N0RQ*/ {gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

/*N0RQ* &SCOPED-DEFINE reupdscb_p_1 "Scrap Requirement" */
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define input parameter lot as character.
         define input parameter qty_to_apply as decimal.

         define variable qty_open as decimal.

         find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_lot =
         lot exclusive-lock.

         wo_qty_comp = wo_qty_comp + qty_to_apply.

         find in_mstr  where in_mstr.in_domain = global_domain and  in_part =
         wo_part and in_site = wo_site
         exclusive-lock no-error.

         if available in_mstr then do:
            in_qty_ord = in_qty_ord - qty_to_apply.
         end.

         qty_open = wo_qty_ord - wo_qty_comp.

         {mfmrw.i "wo_mstr" wo_part wo_nbr wo_lot """"
          wo_rel_date wo_due_date qty_open "SUPPLYF" " " wo_site}

/*N0TN*/ /* Changed pre-processor to Term:SCRAP_REQUIREMENT */
         {mfmrw.i "wo_scrap" wo_part wo_nbr wo_lot """"
          wo_rel_date wo_due_date
          "qty_open * (1 - wo_yield_pct / 100)"
          "DEMAND" SCRAP_REQUIREMENT wo_site}

         find rps_mstr  where rps_mstr.rps_domain = global_domain and  rps_part
         = wo_part
                         and rps_due_date = wo_due_date
                         and rps_site = wo_site
                         and rps_line = wo_line
         exclusive-lock.

/*mage  sp件或不良品扣减生产计划****************
rps_qty_comp = rps_qty_comp + qty_to_apply. */
