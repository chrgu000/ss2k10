/* gl4inrb2.p - GENERAL LEDGER INCOME STATEMENT REPORT SUBROUTINE           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*F0PN*/ /*K0S5*/
/*V8:ConvertMode=Report                                            */
/* REVISION: 7.3            CREATED:  8/17/92   BY: mpp *G030*               */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   by: ays   *K0S5*             */
/* REVISION: 8.6           MODIFIED: 03/12/98   BY: *J23W*   Sachin Shah     */
/* REVISION: 8.6E     LAST MODIFIED: 24 apr 98  BY: *L00M* D. Sidel          */
/* REVISION: 8.6E          MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.1           MODIFIED: 08/14/00   BY: *N0L1* Mark Brown        */
/* $Revision: 1.9 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* SS - 090715.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/


/*!
    This subroutine handles sort_type=2, or sort by cc, acc, sub.
    It sends a comment delimiter through &comm2 in order to enable
    an if-block in gl4inrpb.i which will print cc header info.
*/

        {mfdeclre.i}
/*K0S5*/ {wbrp02.i}

    {gl4inrp3.i}
        DEFINE INPUT PARAMETER sum_lev  AS INTEGER.
        DEFINE INPUT PARAMETER sort_type AS INTEGER.

/*L00M - BEGIN ADD*/
        /* *** DEFINITION OF EURO TOOLKIT VARIABLES */
        {etrpvar.i }
        {etvar.i   }
/*L00M - END ADD*/

/*J23W** FIND fm_mstr WHERE RECID(fm_mstr) = fm_recno NO-LOCK NO-ERROR. **/

/*J23W*/ for first fm_mstr fields( fm_domain fm_fpos fm_dr_cr)
/*J23W*/     WHERE RECID(fm_mstr) = fm_recno NO-LOCK: end.
        IF sum_lev=1 THEN DO:           /* ca(s) */
/* SS 090715.1 - B */
/*
           {gl4inrpb.i &idx=asc_fcas
*/
           {xxgl4inrpb.i &idx=asc_fcas
                        &break1=asc_cc
            &break2="by asc_acc"
                        &test_field=asc_acc
            &test_field2=asc_cc
            &comm2="/*"
            &xtype1=""""
            &xtype2=asc_cc}
/* SS 090715.1 - E */
        END.
        ELSE DO:                /* cas */
/* SS 090715.1 - B */
/*
            {gl4inrpb.i &idx=asc_fcas
*/
            {xxgl4inrpb.i &idx=asc_fcas
                        &break1=asc_cc
            &break2="by asc_acc"
            &break3="by asc_sub"
                        &test_field=asc_sub
            &test_field2=asc_cc
            &comm2="/*"
            &xtype1=asc_sub
            &xtype2=asc_cc}
/* SS 090715.1 - E */
        END.

/*K0S5*/ {wbrp04.i}
