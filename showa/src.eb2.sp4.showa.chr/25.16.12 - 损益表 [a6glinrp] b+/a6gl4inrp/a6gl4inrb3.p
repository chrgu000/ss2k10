/* gl4inrb3.p - GENERAL LEDGER INCOME STATEMENT REPORT SUBROUTINE             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* web convert gl4inrb3.p (converter v1.00) Fri Oct 10 13:57:40 1997 */
/* web tag in gl4inrb3.p (converter v1.00) Mon Oct 06 14:18:14 1997 */
/*F0PN*/ /*K0S5*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                              */
/* REVISION: 7.3              CREATED: 8/13/92   BY: mpp    *G030*           */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   by: ays   *K0S5*             */
/* REVISION: 8.6           MODIFIED: 03/12/98   BY: *J23W*  Sachin Shah      */
/* REVISION: 8.6E     LAST MODIFIED: 24 apr 98  BY: *L00M* D. Sidel          */
/* REVISION: 8.6E          MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1           MODIFIED: 08/14/00   BY: *N0L1* Mark Brown         */
/* REVISION: 9.1           MODIFIED: 09/13/05   BY: *SS - 20050913* Bill Jiang        */

/*!
    This subroutine handles sort_type=3, or sort order by acc-cc-sub.
    In this routine, sub is always summarized because acs is not
    a valid sort option using the flags provided.

    Because sub-acct is the most significant sort field, a comment
    delimiter is sent through &comm2 to enable a header-printing
    if-block in gl4inrpb.i.

*/

/* SS - 20050913 - B */
{a6gl4inrp.i}
/* SS - 20050913 - E */

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

/*J23W*/ for first fm_mstr fields (fm_fpos fm_dr_cr)
/*J23W*/    WHERE RECID(fm_mstr) = fm_recno NO-LOCK: end.
/* SS - 20050913 - B */
        {a6gl4inrpb.i &idx=asc_fsca
                &break1=asc_sub
                &break2="by asc_cc"
                &break3="by asc_acc"
                &test_field=asc_acc
                &test_field2=asc_sub
                &xtype1=asc_sub
                &xtype2=asc_cc
                &comm2="/*"}
                /* SS - 20050913 - E */

/*K0S5*/ {wbrp04.i}
