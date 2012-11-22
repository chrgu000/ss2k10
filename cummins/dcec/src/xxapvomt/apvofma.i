/* apvofma.i - DEFINE FORM FOR VOUCHER MAINTENANCE FRAME A                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.1.5 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3            CREATED: 02/18/93     by: jms *G698*              */
/* REVISION: 8.5      LAST MODIFIED: 02/02/96     by: mwd *J053*              */
/* REVISION: 8.5      LAST MODIFIED: 07/15/96     by: *J0VY* M. Deleeuw       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   By: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.7.1.5 $    BY: Hareesh V.            DATE: 02/06/02  ECO: *P04C*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ********** BEGIN TRANSLATABLE STRINGS DEFINITIONS ********* */

&SCOPED-DEFINE apvofma_i_1 "Control"
/* MaxLen: Comment: */

/* ********** END TRANSLATABLE STRINGS DEFINITIONS ********* */

form
   batch          colon 8  deblank
   bactrl          format "->>>>>>>,>>>,>>9.999" label {&apvofma_i_1}
   ba_total        format "->>>>>>>,>>>,>>9.999"
with side-labels frame a width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
