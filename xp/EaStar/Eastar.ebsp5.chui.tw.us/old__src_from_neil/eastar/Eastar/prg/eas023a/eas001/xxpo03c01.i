/* po03c01.i - PURCHASE ORDER PRINT INCLUDE FILE                        */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 5.0     LAST MODIFIED: 03/28/90    BY: MLB *B615**/
/* REVISION: 6.0     LAST MODIFIED: 06/14/90    BY: RAM *D030**/
/* REVISION: 8.5     LAST MODIFIED: 10/09/95    BY: taf *J053**/
/* REVISION: 8.5     LAST MODIFIED: 06/19/97    BY: *H19R* Suresh Nayak */
/* REVISION: 8.6E    LAST MODIFIED: 04/28/98    BY: *H1KW* A. Licha     */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan   */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KQ* myb          */
/* NOTE:  To translate, change only what is in quotes below   */
/*        and uncomment.                                      */
/*        This file compiles into porp0301.p                  */

/*J053*********** REDO DISPLAY TO USE FRAME C *******************
**       display
**          pod_line    at 1     /*column-label " Ln"*/
**          pod_part             /*column-label "Item Number       "*/
**          tax_flag             column-label "T"
**          pod_due_date         /*column-label "Due     "*/
**          qty_open             column-label "Qty Open"
**          pod_um               /*column-label "UM"*/
**          pod_pur_cost         column-label "Unit Cost" format "->,>>>,>>9.99<<<"
**          ext_cost             column-label "Extended Cost"
**          with no-box.
**J053*********** REDO DISPLAY TO USE FRAME C *******************/

/*H19R*/
/* FOLLOWING SECTION MODIFIED BECAUSE THE ACTUAL PRICE WILL BE   */
/* DISPLAYED  WHEN THE DISCOUNT TABLE IN THE PO HAS A PRICE LIST */
/* OF TYPE P AND  THE PRICE TABLE IS BLANK.                      */
/*H19R*/

/*eas001a delete******************************************************************************
/*J053*/ display
/*J053*/    pod_line
/*J053*/    pod_part
/*J053*/    tax_flag
/*J053*/    pod_due_date
/*J053*/    qty_open
/*J053*/    pod_um
/*H19R** /*J053*/    pod_pur_cost     */
/*H19R*/    l_unit_cost @ pod_pur_cost
/*J053*/    ext_cost
/*J053*/ with frame c.
/*H1KW*/ down 1 with frame c.
*eas001a delete******************************************************************************/

/*eas001a add*****************************************************************************/
/*J053*/ display
/*J053*/    pod_line
/*J053*/    pod_part
/*J053*/    due_date
/*J053*/    qty_open
/*J053*/    um#
/*H19R** /*J053*/    pod_pur_cost     */
/*H19R*/    l_unit_cost @ pod_pur_cost
/*J053*/    ext_cost
/*J053*/ with frame c.
/*H1KW*/ down 1 with frame c.
/*eas001a add******************************************************************************/
