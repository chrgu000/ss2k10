/* xxsosoprc.p - REPRICING AFTER LINE PROCESSING                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/*V8:ConvertMode=Maintenance                                             */
/*K1Q4*/ /*V8:WebEnabled=No                                              */
/* REVISION: 8.5      CREATED : 01/16/98   BY: *J25N* Aruna Patil        */
/* REVISION: 8.6     MODIFIED : 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1     MODIFIED : 08/12/00   BY: *N0KN* myb                */


         {mfdeclre.i}
         /* SHARED PRICING VARIABLES */
         {pppivar.i }
         /* WORKFILE FOR ACCUM QTY FOR PRICING ROUTINES */
         {pppiwqty.i }

         define input parameter so_recno as recid no-undo.
         define input parameter reprice like mfc_logical no-undo.
         define input parameter new_order like mfc_logical initial no no-undo.
         define input parameter line_pricing like mfc_logical no-undo.

         define new shared variable sod_recno as recid.
         define shared variable price_changed like mfc_logical.

         define shared stream bi.
         define shared frame bi.

         /* FORM DEFINITION FOR HIDDEN FRAME BI */
         {sobifrm.i}

         FORM /*GUI*/  sod_det with frame bi width 80 THREE-D /*GUI*/.


         find so_mstr where recid(so_mstr) = so_recno no-lock no-error.

         if new_order and not line_pricing then do:
             /*ALL LINES NEED TO BE PRICED, ENTERED PRICES WILL BE RETAINED*/
             for each sod_det where sod_nbr       = so_nbr
                                and sod_fsm_type <> "RMA-RCT" no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

                sod_recno = recid(sod_det).
                /*TRANSACTION HISTORY WILL BE REWRITTEN WITH REVISED PRICE*/
                do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                   {gprun.i ""sosoprln.p"" "(input no,
                                             input yes,
                                             input yes,
                                             input yes,
                                             input yes,
                                             input no,
                                             input 0,
                                             input yes
                                             )"}
/*GUI*/ if global-beam-me-up then undo, leave.


                   find so_mstr where recid(so_mstr) = so_recno
                      exclusive-lock.
                   so_priced_dt = today.
                end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO TRANSACTION */
             end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH SOD_DET WHERE..*/
         end. /* IF NEW_ORDER AND NOT LINE_PRICING */

         if reprice or new_order then do:
            price_changed = no.
            /*CHECK REPRICE TABLE TO DETERMINE WHICH LINES REQUIRE REPRICING*/
            for each wrep_wkfl where wrep_parent and wrep_rep no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

               find sod_det where sod_nbr  = so_nbr and
                                  sod_line = wrep_line no-lock no-error.
               if available sod_det then do:
                  sod_recno = recid(sod_det).
                  /*REVERSE OLD TRANSACTION HISTORY*/
                  do with frame bi on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                     FORM /*GUI*/  sod_det with frame bi width 80 THREE-D /*GUI*/.

                     {mfoutnul.i &stream_name = "bi"}
                     display stream bi sod_det with frame bi.
                     output stream bi close.
                  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO WITH FRAME BI */
                  do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                     {gprun.i ""sosoprln.p"" "(input yes,
                                               input yes,
                                               input yes,
                                               input yes,
                                               input no,
                                               input no,
                                               input 0,
                                               input yes
                                               )"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     find so_mstr where recid(so_mstr) = so_recno
                         exclusive-lock.
                     so_priced_dt = today.
                  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO TRANSACTION */
               end. /* IF AVAILABLE SOD_DET */
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH WREP_WKFL */
            if price_changed then do:
               /*RE-DISPLAY LINE ITEMS*/
               {gprun.i ""sophdp.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* IF PRICE_CHANGED */
         end. /* IF REPRICE OR NEW_ORDER */
