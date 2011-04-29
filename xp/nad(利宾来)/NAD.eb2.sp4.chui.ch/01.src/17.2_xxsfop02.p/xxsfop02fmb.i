/* sfopfmb.i - LABOR FEEDBACK FRAME B DEFINITION                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.6.1.3 $                                                     */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.3      LAST MODIFIED: 03/15/93   BY: emb *G876*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb          */
/* Old ECO marker removed, but no ECO header exists *F0PN*              */
/* $Revision: 1.6.1.3 $    BY: Katie Hilbert  DATE: 04/05/01 ECO: *P008*   */
/*----rev history-------------------------------------------------------------------------------------*/
/* $Revision: 1.3.00   $     BY: Martin tan     DATE: 03/12/08  ECO: *SET2**/
/* SS - 110120.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* This frame used by sfoptr01.p, sfoptr02.p, sfoptr03.p, sfoptra.p     */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sfopfmb_i_1 "Elapsed Run"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfopfmb_i_2 "Elapsed Setup"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

form
   op_qty_comp    colon 20
   eff_date       colon 62
   rejects        colon 20 total_rej no-label
   wocomp         colon 62
   reworks        colon 20 total_rwk no-label
   move           colon 62
   compprev       colon 62
   start_setup    colon 20
/* SS - 110120.1 - B 
   stop_setup     colon 20
/*SET2*/ sttype   colon 40
   op_act_setup   colon 62 format "->>>9.999" label {&sfopfmb_i_2}
   start_run      colon 20
   stop_run       colon 20
   op_act_run     colon 62 format "->>>9.999" label {&sfopfmb_i_1}
/*SFOP   op_comment     colon 20*/
/*SFOP*/ cmmts    colon 20
/*SFOP*/ amch     colon 40
/*SFOP*/ bisu     colon 62
   downtime       colon 20
   reason         colon 62
   SS - 110120.1 - E */
/* SS - 110120.1 - B */
stop_setup     colon 20
op_act_setup   colon 50 format "->>>9.999" label {&sfopfmb_i_2}
sttype         colon 68
start_run      colon 20
v_multi_type   colon 68

stop_run       colon 20 
op_act_run     colon 50 format "->>>9.999" label {&sfopfmb_i_1}

cmmts          colon 20
amch           colon 40
reason         colon 68

downtime       colon 20
bisu           colon 40
v_multi_rsn    colon 68
/* SS - 110120.1 - E */

with frame b side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).
