/* sopkb01.i - SALES ORDER PRINT INCLUDE FILE                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 5.0    LAST MODIFIED: 03/28/90   BY: MLB *B615**/
/* REVISION: 5.0    LAST MODIFIED: 03/14/90   BY: MLB *D004**/
/* REVISION: 6.0    LAST MODIFIED: 04/24/90   BY: MLB *D021**/
/* REVISION: 7.3    LAST MODIFIED: 09/17/92   BY: pma *G068**/
/* REVISION: 7.3    LAST MODIFIED: 04/20/95   BY: rxm *F0PD**/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 08/10/00   BY: *N0JM* Mudit Mehta  */
/* NOTE:  to translate change only what is in quotes below and uncomment*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sopkb01_i_3 "     Due! Shipped"
/* MaxLen: Comment: */

/*N0JM*
 * &SCOPED-DEFINE sopkb01_i_1 "Revision: "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE sopkb01_i_2 "Customer Item: "
 * /* MaxLen: Comment: */
 *N0JM*/

/* ********** End Translatable Strings Definitions ********* */

/*        this file compiles into sopkb01.p               */

/*N0JM*   cspart-lbl = {&sopkb01_i_2}. */
/*N0JM*/  cspart-lbl = getTermLabel("CUSTOMER_ITEM",13) + ": ".
/*F0PD   cont_lbl = "*** Cont ***". */
/*N0JM* /*G068*/ rev-lbl = {&sopkb01_i_1}.  /*limited to 10 char*/ */
/*N0JM*/  rev-lbl = getTermLabel("REVISION",8) + ": ".  /*limited to 10 char*/

     display
        sod_line                /* column-label " Ln" */   /*D021 at 3*/
        sod_part                /* column-label  "Item Number       " */
/*G068      rev                     /* column-label  "Rev" */ */

        /*
        sod_type                /* column-label  "T" */
        */

        v_lad_loc @ lad_loc      /*column-label   "Location"*/
        /* 
        "" @ lad_lot            /* column-label  "Lot/Serial" */
        */
        qty_open                /* Column-label  "Qty Open!Qty to Ship" */
        sod_um                  /* column-label   "UM" */
        sod_due_date               column-label  {&sopkb01_i_3}
     with frame d no-attr-space.
