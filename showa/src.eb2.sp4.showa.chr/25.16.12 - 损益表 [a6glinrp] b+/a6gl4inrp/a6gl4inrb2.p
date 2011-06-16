/* gl4inrb2.p - GENERAL LEDGER INCOME STATEMENT REPORT SUBROUTINE           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* web convert gl4inrb2.p (converter v1.00) Fri Oct 10 13:57:40 1997 */
/* web tag in gl4inrb2.p (converter v1.00) Mon Oct 06 14:18:14 1997 */
/*F0PN*/ /*K0S5*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                            */
/* REVISION: 7.3            CREATED:  8/17/92   BY: mpp *G030*               */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   by: ays   *K0S5*             */
/* REVISION: 8.6           MODIFIED: 03/12/98   BY: *J23W*   Sachin Shah     */
/* REVISION: 8.6E     LAST MODIFIED: 24 apr 98  BY: *L00M* D. Sidel          */
/* REVISION: 8.6E          MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.1           MODIFIED: 08/14/00   BY: *N0L1* Mark Brown        */
/* REVISION: 9.1           MODIFIED: 09/13/05   BY: *SS - 20050913* Bill Jiang        */

/*!
    This subroutine handles sort_type=2, or sort by cc, acc, sub.
    It sends a comment delimiter through &comm2 in order to enable
    an if-block in gl4inrpb.i which will print cc header info.
*/

/* SS - 20050913 - B */
{a6gl4inrp.i}
/* SS - 20050913 - E */

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

/*J23W*/ for first fm_mstr fields (fm_fpos fm_dr_cr)
/*J23W*/     WHERE RECID(fm_mstr) = fm_recno NO-LOCK: end.
/* SS - 20050913 - B */
        IF sum_lev=1 THEN DO:           /* ca(s) */
           {a6gl4inrpb.i &idx=asc_fcas
                        &break1=asc_cc
            &break2="by asc_acc"
                        &test_field=asc_acc
            &test_field2=asc_cc
            &comm2="/*"
            &xtype1=""""
            &xtype2=asc_cc}
        END.
        ELSE DO:                /* cas */
            {a6gl4inrpb.i &idx=asc_fcas
                        &break1=asc_cc
            &break2="by asc_acc"
            &break3="by asc_sub"
                        &test_field=asc_sub
            &test_field2=asc_cc
            &comm2="/*"
            &xtype1=asc_sub
            &xtype2=asc_cc}
        END.
            /* SS - 20050913 - E */

/*K0S5*/ {wbrp04.i}
