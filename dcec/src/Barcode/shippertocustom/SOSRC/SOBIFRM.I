/* GUI CONVERTED from sobifrm.i (converter v1.71) Tue Oct  6 14:48:52 1998 */
/* sobifrm.i - DEFINE FORM FOR FRAME BI                                 */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*V8:ConvertMode=Maintenance                                            */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 8.5      LAST MODIFIED: 01/16/98   BY: *J25N* Aruna Patil  */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sobifrm_i_1 "уш©ш%"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         FORM /*GUI*/ 
            sod_qty_ord                format "->>>>,>>9.9<<<<"
            sod_list_pr                format ">>>,>>>,>>9.99<<<"
            sod_disc_pct label {&sobifrm_i_1} format "->>>>9.99"
         with frame bi width 80 THREE-D /*GUI*/.

