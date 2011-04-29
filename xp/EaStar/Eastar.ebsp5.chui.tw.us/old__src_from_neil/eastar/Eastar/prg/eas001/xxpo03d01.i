/* po03d01.i - PO PRINT FORM STATEMENT FOR FRAME C                      */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 8.5     LAST MODIFIED: 10/09/95    BY: taf *J053**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb              */
/*        This file compiles into porp0301.p                  */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE po03d01_i_1 "Extended Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE po03d01_i_2 "Qty Open"
/* MaxLen: Comment: */

&SCOPED-DEFINE po03d01_i_3 "Unit Cost"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */
/*eas001a delete******************************************************************************
         form
            pod_line    at 1
            pod_part
            tax_flag             column-label "T"
            pod_due_date
            qty_open             column-label {&po03d01_i_2}
            pod_um
            pod_pur_cost         column-label {&po03d01_i_3}
              format "->,>>>,>>9.99<<<"
            ext_cost             column-label {&po03d01_i_1}
            with frame c no-box width 80 down.

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame c:handle).
*eas001a delete******************************************************************************/

/*eas001a add******************************************************************************/
         form
            pod_line    at 3
            pod_part    at 9
            due_date  at 42
            qty_open             at 55
            um#           at 69
            pod_pur_cost    
              format "->,>>>,>>9.99<<" to 86
            ext_cost             to 106
            with frame c no-box no-label width 110 down.

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame c:handle).
/*eas001a end******************************************************************************/
