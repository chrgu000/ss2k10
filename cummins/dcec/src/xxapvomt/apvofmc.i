/* apvofmc.i - AP VOUCHER MAINTENANCE form c                                  */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.1.5 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.5            CREATED: 04/19/96 BY: *J0JP* Andrew Wasilczuk     */
/* REVISION: 8.5            CREATED: 07/15/96 BY: *J0VY* Marianna Deleeuw     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98 BY: *L007* A. Rahane            */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98 BY: *K1Q4* Alfred Tan           */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98 BY: *J314* Alfred Tan           */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99 BY: *M0B3* Michael Amaladhas    */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99 BY: *M0BD* Alfred Tan           */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                  */
/* $Revision: 1.5.1.5 $    BY: Hareesh V.            DATE: 02/08/02  ECO: *P04C*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ********** BEGIN TRANSLATABLE STRINGS DEFINITIONS ********* */

&SCOPED-DEFINE apvofmc_i_1 "Tot"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmc_i_2 "Voucher"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmc_i_3 "Ctrl"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmc_i_4 "Batch Ctrl"
/* MaxLen: Comment: */

/* ********** END TRANSLATABLE STRINGS DEFINITIONS ********* */

/*DEFINE FRAME C FOR CONTROL TOTALS*/
form
   ba_batch       colon 10
   ba_ctrl        colon 31 format "->>>>>>>,>>>,>>9.999" label {&apvofmc_i_4}
   ba_total       colon 57 format "->>>>>>>,>>>,>>9.999" label {&apvofmc_i_1}
   ap_ref         colon 10 format "x(8)"                 label {&apvofmc_i_2}
   ap_curr                                               no-label
   aptotal        colon 31                               label {&apvofmc_i_3}
   ap_amt         colon 57                               label {&apvofmc_i_1}
with side-labels frame c width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).
