/* mffsmt1b.i - FORECAST MASTER MAINTENANCE (mffsmt01.p) frame          */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 4.0      LAST MODIFIED: 02/23/88   BY: EMB *A162*    */
/* REVISION: 4.0      LAST MODIFIED: 10/18/94   BY: ljm *FS55*    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 07/24/00   BY: *N0G1* BalbeerS Rajput  */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb              */

/*FS55* space(3)
*"Total" totals[1] no-attr-space space(6)
*"Total" totals[2] no-attr-space space(6)
*"Total" totals[3] no-attr-space space(6)
*"Total" totals[4] no-attr-space             */

/* ********** Begin Translatable Strings Definitions ********* */

/*N0G1*
 * &SCOPED-DEFINE mffsmt1b_i_1 "Total"
 * /* MaxLen: Comment: */
 *N0G1*/

/* ********** End Translatable Strings Definitions ********* */

/*N0G1*
 * /*FS55*/ {&mffsmt1b_i_1} to 8  totals[1] no-attr-space
 * /*FS55*/ {&mffsmt1b_i_1} to 28 totals[2] no-attr-space
 * /*FS55*/ {&mffsmt1b_i_1} to 48 totals[3] no-attr-space
 * /*FS55*/ {&mffsmt1b_i_1} to 68 totals[4] no-attr-space
 *N0G1*/

/*N0G1*/ disp-total[1] at  1 totals[1] no-attr-space
/*N0G1*/ disp-total[2] at 21 totals[2] no-attr-space
/*N0G1*/ disp-total[3] at 41 totals[3] no-attr-space
/*N0G1*/ disp-total[4] at 61 totals[4] no-attr-space
