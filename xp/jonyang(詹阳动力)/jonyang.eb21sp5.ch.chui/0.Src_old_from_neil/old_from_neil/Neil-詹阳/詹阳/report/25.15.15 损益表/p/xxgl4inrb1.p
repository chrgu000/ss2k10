/* gl4inrb1.p - GENERAL LEDGER INCOME STATEMENT REPORT SUBROUTINE           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*F0PN*/ /*K0S5*/
/*V8:ConvertMode=Report                                            */
/* REVISION: 7.3              CREATED: 8/13/92   BY: mpp    *G030*          */
/* REVISION: 8.6        LAST MODIFIED: 10/11/97  by: ays  **K0S5**          */
/* REVISION: 8.6             MODIFIED: 03/12/98  BY: *J23W*  Sachin Shah    */
/* REVISION: 8.6E       LAST MODIFIED: 24 apr 98 BY: *L00M* D. Sidel        */
/* REVISION: 8.6E            MODIFIED: 10/04/98  BY: *J314* Alfred Tan      */
/* REVISION: 9.1             MODIFIED: 08/14/00  BY: *N0L1* Mark Brown      */
/* $Revision: 1.9 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* SS - 090715.1 By: Neil Gao */
/*-Revision end---------------------------------------------------------------*/



/*!
    This subroutine handles sort_type=1, or sort order by sub, acc, cc.
    Because sub is the most significant sort field, a comment delimiter
    is sent through &comm2 to enable a header-printing if-block in
    gl4inrpb.i.

*/

        {mfdeclre.i}
/*K0S5*/ {wbrp02.i}

    {gl4inrp3.i}
        DEFINE INPUT PARAMETER sum_lev  as integer.
        DEFINE INPUT PARAMETER sort_type as integer.
   /*     DEFINE SHARED VARIABLE pl like co_pl.
        DEFINE SHARED VARIABLE pl_amt AS DECIMAL NO-UNDO.*/

/*L00M - BEGIN ADD*/
        /* *** DEFINITION OF EURO TOOLKIT VARIABLES */
        {etrpvar.i }
        {etvar.i   }
/*L00M - END ADD*/

/*J23W** FIND fm_mstr WHERE RECID(fm_mstr) = fm_recno NO-LOCK NO-ERROR.**/

/*J23W*/ for first fm_mstr fields( fm_domain fm_fpos fm_dr_cr)
/*J23W*/     WHERE RECID(fm_mstr) = fm_recno NO-LOCK: end.
    IF sum_lev=1 THEN DO:           /* sa(c) */
/* SS 090715.1 - B */
/*
              {gl4inrpb.i &idx=asc_fsac
*/
              {xxgl4inrpb.i &idx=asc_fsac
                    &break1=asc_sub
            &break2="by asc_acc"
                    &test_field=asc_acc
            &test_field2=asc_sub
            &comm2="/*"
            &xtype1=asc_sub
            &xtype2=""""}
/* SS 090715.1 - E */
        END.
        ELSE DO:                    /* sac */
/* SS 090715.1 - B */
/*
              {gl4inrpb.i &idx=asc_fsac
*/
              {xxgl4inrpb.i &idx=asc_fsac
                        &break1=asc_sub
            &break2="by asc_acc"
            &break3="by asc_cc"
                        &test_field=asc_cc
            &test_field2=asc_sub
            &comm2="/*"
            &xtype1=asc_sub
            &xtype2=asc_cc}
/* SS 090715.1 - E */
        END.

/*K0S5*/ {wbrp04.i}
