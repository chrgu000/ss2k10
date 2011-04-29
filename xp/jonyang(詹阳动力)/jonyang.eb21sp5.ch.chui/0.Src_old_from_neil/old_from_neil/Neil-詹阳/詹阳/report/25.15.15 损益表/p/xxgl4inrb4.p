/* gl4inrb4.p - GENERAL LEDGER BALANCE SHEET REPORT SUBROUTINE              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*F0PN*/ /*K0S5*/
/*V8:ConvertMode=Report                                            */
/* REVISION: 7.3              CREATED: 8/18/92   BY: mpp    *G030*           */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   by: ays   *K0S5*             */
/* REVISION: 8.6           MODIFIED: 03/12/98   BY: *J23W*  Sachin Shah      */
/* REVISION: 8.6E     LAST MODIFIED: 24 apr 98  BY: *L00M* D. Sidel          */
/* REVISION: 8.6E          MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.1           MODIFIED: 08/14/00   BY: *N0L1* Mark Brown        */
/* $Revision: 1.9 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/*-Revision end---------------------------------------------------------------*/


/*!
    This subroutine handles sort_type=4, or sort order by acc-cc-sub.
    In this routine, sub is always summarized because acs is not
    a valid sort option using the flags provided.

    Because acct is the most significant sort field, a comment delimiter
    is sent through &comm1 to disable a header-printing if-block in
    gl4inrpb.i.

*/

        {mfdeclre.i}
/*K0S5*/ {wbrp02.i}

    {gl4inrp3.i}
        DEFINE INPUT PARAMETER sum_lev  as integer.
        DEFINE INPUT PARAMETER sort_type as integer.

/*L00M - BEGIN ADD*/
        /* *** DEFINITION OF EURO TOOLKIT VARIABLES */
        {etrpvar.i }
        {etvar.i   }
/*L00M - END ADD*/

/*J23W** FIND fm_mstr WHERE RECID(fm_mstr) = fm_recno NO-LOCK NO-ERROR. **/

/*J23W*/ for first fm_mstr fields( fm_domain fm_fpos fm_dr_cr)
/*J23W*/    WHERE RECID(fm_mstr) = fm_recno NO-LOCK: end.

                        /*ac(s)*/
/* SS 090715.1 - B */
/*
        {gl4inrpb.i &idx=asc_facs
*/
        {xxgl4inrpb.i &idx=asc_facs
                &break1=asc_acc
                &break2="by asc_cc"
                &test_field=asc_cc
                &test_field2=asc_acc
                &xtype1=""""
                &xtype2=asc_cc
                &comm1="/*" }
/* SS 090715.1 - E */
/*K0S5*/ {wbrp04.i}
