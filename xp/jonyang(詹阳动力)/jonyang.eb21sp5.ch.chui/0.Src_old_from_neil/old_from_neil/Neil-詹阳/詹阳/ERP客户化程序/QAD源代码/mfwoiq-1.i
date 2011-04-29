/* GUI CONVERTED from mfwoiq.i (converter v1.69) Sat Aug 30 21:23:39 1997 */
/* mfwoiq.i - WORK ORDER INQUIRY                                        */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/* REVISION: 1.0      LAST MODIFIED: 05/07/86   BY: EMB */
/* REVISION: 4.0      LAST MODIFIED: 03/23/88   BY: RL  *A171**/
/* REVISION: 5.0      LAST MODIFIED: 03/15/90   BY: emb *B357**/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*B357*/ qty_open = max(wo_qty_ord - wo_qty_comp - wo_qty_rjct,0).
/*B357*/ if wo_status = "C" then qty_open = 0.

display wo_part format "x(18)" wo_nbr  wo_lot format "x(8)"
/*B357*  wo_qty_ord - wo_qty_comp - wo_qty_rjct label "Qty Open" */
/*B357*/ wo_qty_ord format "->>>,>>9.9<<"
         wo_qty_comp format "->>>,>>9.9<<"
         qty_open format "->>>,>>9.9<<"
         wo_due_date wo_status
         wo_so_job 
         skip(1) with width 110 STREAM-IO /*GUI*/ .
