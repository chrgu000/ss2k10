/* sfopfmb.i - LABOR FEEDBACK FRAME B DEFINITION                        */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.3      LAST MODIFIED: 03/15/93   BY: emb *G876*          */


/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KN* myb              */
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
        stop_setup     colon 20
        op_act_setup   colon 62 format "->>>9.999" label {&sfopfmb_i_2}
        start_run      colon 20
        stop_run       colon 20
        op_act_run     colon 62 format "->>>9.999" label {&sfopfmb_i_1}
        op_comment     colon 20
       /*
        downtime       colon 20
        reason         colon 62
       */
        /* 130712.1 -b */
        v_down       colon 20
       
      /*  ss - 130712.1 -e */
        
        
     with frame b side-labels width 80 attr-space.

     /* SET EXTERNAL LABELS */
     setFrameLabels(frame b:handle).
