/* sopkf01.i - SALES ORDER PRINT SHARED FORM FOR SO LINE DISPLAY        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.3      LAST MODIFIED: 01/06/92   BY: afs *G511*          */
/* REVISION: 7.3      LAST MODIFIED: 01/16/95   BY: bcm *G0CD*          */


/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KN* myb              */
/* NOTE:  to translate change only what is in quotes below and uncomment. */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sopkf01_i_1 "Site!Location"
/* MaxLen: Comment: */

&SCOPED-DEFINE sopkf01_i_2 "     Due! Shipped"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

      form
        sod_line              /* column-label  " Ln"                  */
        sod_part              /* column-label  "Item Number       "   */
        /*
        sod_type              /* column-label  "T"                    */
        */
/*G0CD**    lad_loc               /* column-label  "Location"             */ **/
/*G0CD*/    lad_loc             /*     column-label  {&sopkf01_i_1} */
        /*
        lad_lot               /* column-label  "Lot/Serial"           */
        lad_lot               /* column-label  "Lot/Serial"           */
        */
        qty_open              /* Column-label  "Qty Open!Qty to Ship" */
        sod_um                /* column-label   "UM"                  */
        sod_due_date             column-label  {&sopkf01_i_2}
        with frame d down no-attr-space.

        /* SET EXTERNAL LABELS */
        setFrameLabels(frame d:handle).
