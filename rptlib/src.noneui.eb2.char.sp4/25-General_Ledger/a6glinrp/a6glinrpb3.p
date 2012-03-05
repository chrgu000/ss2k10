/* glinrpb3.p - GENERAL LEDGER INCOME STATEMENT REPORT SUBROUTINE             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* web convert glinrpb3.p (converter v1.00) Fri Oct 10 13:57:44 1997 */
/* web tag in glinrpb3.p (converter v1.00) Mon Oct 06 14:18:18 1997 */
/*F0PN*/ /*web*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                              */
/* REVISION: 7.3              CREATED: 8/13/92   BY: mpp    *G030*          */
/* REVISION: 8.6        LAST MODIFIED:12/15/97   BY: bvm    *K1DT*          */
/* REVISION: 8.6     LAST MODIFIED: 03/18/98      BY: *J242* Sachin Shah */
/* REVISION: 8.6E       LAST MODIFIED:04/07/98   BY: AWe    *L00S*RO*      */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98      BY: *J314* Alfred Tan       */
/* REVISION: 9.1     LAST MODIFIED: 08/14/00      BY: *N0L1* Mark Brown       */
/* REVISION: 9.1     LAST MODIFIED: 09/22/05      BY: *SS - 20050922* Bill Jiang       */
/*!
    This subroutine handles sort_type=3, or sort order by acc-cc-sub.
    In this routine, sub is always summarized because acs is not
    a valid sort option using the flags provided.

    Because sub-acct is the most significant sort field, a comment
    delimiter is sent through &comm2 to enable a header-printing
    if-block in glinrpb.i.

*/

/* SS - 20050922 - B */
{a6glinrp.i}
/* SS - 20050922 - E */

/*K1DT*/  {mfdeclre.i}
/*K1DT*/ {wbrp02.i}

    {glinrp3.i}
        DEFINE INPUT PARAMETER sum_lev  as integer.
        DEFINE INPUT PARAMETER sort_type as integer.
        /*DEFINE SHARED VARIABLE pl like co_pl.
        DEFINE SHARED VARIABLE pl_amt AS DECIMAL NO-UNDO.*/
/*K1DT* {mfdeclre.i} */

/*J242** FIND fm_mstr WHERE RECID(fm_mstr) = fm_recno NO-LOCK NO-ERROR. **/
/*J242*/ for first fm_mstr fields (fm_dr_cr fm_fpos)
/*J242*/   no-lock WHERE RECID(fm_mstr) = fm_recno: end.
/* SS - 20050922 - B */
        {a6glinrpb.i &idx=asc_fsca
                &break1=asc_sub
                &break2="by asc_cc"
                &break3="by asc_acc"
                &test_field=asc_acc
                &test_field2=asc_sub
                &xtype1=asc_sub
                &xtype2=asc_cc
                &comm2="/*"}
                /* SS - 20050922 - E */

/*K1DT*/ {wbrp04.i}
