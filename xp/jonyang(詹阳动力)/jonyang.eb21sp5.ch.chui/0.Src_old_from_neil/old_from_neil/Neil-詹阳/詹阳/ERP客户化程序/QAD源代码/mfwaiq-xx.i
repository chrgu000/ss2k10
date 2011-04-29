/* GUI CONVERTED from mfwaiq.i (converter v1.71) Tue Oct  6 14:33:27 1998 */
/* mfwaiq.i - WORK ORDER ALLOCATION INQUIRY                             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/* REVISION: 1.0      LAST MODIFIED: 05/07/86   BY: EMB       */
/* REVISION: 5.0      LAST MODIFIED: 01/20/89   BY: pml  B020 */
/* REVISION: 7.3      LAST MODIFIED: 02/09/93   BY: emb  G656 */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

     so_job = "".
     stat = "".
     part1 = "".
     part2 = "".
     part3 = 0.
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mfwaiq_i_1 "×ÓÁã¼þ"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

     find wo_mstr where wo_lot = wod_lot no-lock no-error.
     if available wo_mstr then do:
        so_job = wo_so_job.
        stat = wo_status.
     end.
     open_ref = wod_qty_req - wod_qty_iss.

     display wod_nbr wod_lot wod_part label {&mfwaiq_i_1}
      wod_iss_date
/*G656*/ wod_op
     wod_qty_req wod_qty_iss open_ref stat with width 108 STREAM-IO /*GUI*/ .
   
     find pt_mstr where pt_part = wod_part no-lock no-error.
     if available pt_mstr then do:
       part1 = pt_desc1.
       part2 = pt_desc2.
     end.  
/*     find ps_mstr where ps_par = wo_part and ps_comp = wod_part no-lock no-error.
     if available pt_mstr then part3 = ps_qty_per.
*/
     display part1 at 30. 
     display part2 at 30.
