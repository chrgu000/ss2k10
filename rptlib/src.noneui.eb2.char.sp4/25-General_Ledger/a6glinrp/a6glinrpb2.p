/* glinrpb2.p - GENERAL LEDGER INCOME STATEMENT REPORT SUBROUTINE             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* web convert glinrpb2.p (converter v1.00) Fri Oct 10 13:57:44 1997 */
/* web tag in glinrpb2.p (converter v1.00) Mon Oct 06 14:18:18 1997 */
/*F0PN*/ /*K1DT*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                              */
/* REVISION: 7.3            CREATED:  8/17/92   BY: mpp *G030*              */
/* REVISION: 8.6      LAST MODIFIED: 12/15/97   BY: bvm *K1DT*              */
/* REVISION: 8.6      LAST MODIFIED: 03/18/98   BY: *J242*    Sachin Shah   */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/22/05   BY: *SS - 20050922* Bill Jiang         */
/*!
    This subroutine handles sort_type=2, or sort by cc, acc, sub.
    It sends a comment delimiter through &comm2 in order to enable
    an if-block in glinrpb.i which will print cc header info.
*/

/* SS - 20050922 - B */
{a6glinrp.i}
/* SS - 20050922 - E */

/*K1DT*/  {mfdeclre.i}
/*K1DT*/ {wbrp02.i}

    {glinrp3.i}
        DEFINE INPUT PARAMETER sum_lev  AS INTEGER.
        DEFINE INPUT PARAMETER sort_type AS INTEGER.
        /*DEFINE SHARED VARIABLE pl LIKE co_pl.
        DEFINE SHARED VARIABLE pl_amt AS DECIMAL NO-UNDO.*/
/*K1DT*  {mfdeclre.i} */

/*J242** FIND fm_mstr WHERE RECID(fm_mstr) = fm_recno NO-LOCK NO-ERROR. **/
/*J242*/ for first fm_mstr fields (fm_dr_cr fm_fpos)
/*J242*/   no-lock WHERE RECID(fm_mstr) = fm_recno: end.
/* SS - 20050922 - B */
        IF sum_lev=1 THEN DO:           /* ca(s) */
           {a6glinrpb.i &idx=asc_fcas
                        &break1=asc_cc
            &break2="by asc_acc"
                        &test_field=asc_acc
            &test_field2=asc_cc
            &comm2="/*"
            &xtype1=""""
            &xtype2=asc_cc}
        END.
        ELSE DO:                /* cas */
            {a6glinrpb.i &idx=asc_fcas
                        &break1=asc_cc
            &break2="by asc_acc"
            &break3="by asc_sub"
                        &test_field=asc_sub
            &test_field2=asc_cc
            &comm2="/*"
            &xtype1=asc_sub
            &xtype2=asc_cc}
        END.
            /* SS - 20050922 - E */

/*K1DT*/ {wbrp04.i}
