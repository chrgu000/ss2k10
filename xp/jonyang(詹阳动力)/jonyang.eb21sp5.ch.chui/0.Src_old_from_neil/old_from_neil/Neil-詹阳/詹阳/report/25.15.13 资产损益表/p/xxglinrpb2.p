/* glinrpb2.p - GENERAL LEDGER INCOME STATEMENT REPORT SUBROUTINE             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*K1DT*/
/*V8:ConvertMode=Report                                              */
/* REVISION: 7.3            CREATED:  8/17/92   BY: mpp *G030*              */
/* REVISION: 8.6      LAST MODIFIED: 12/15/97   BY: bvm *K1DT*              */
/* REVISION: 8.6      LAST MODIFIED: 03/18/98   BY: *J242*    Sachin Shah   */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown         */
/* $Revision: 1.9 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* SS - 090709.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/*!
    This subroutine handles sort_type=2, or sort by cc, acc, sub.
    It sends a comment delimiter through &comm2 in order to enable
    an if-block in glinrpb.i which will print cc header info.
*/

/*K1DT*/  {mfdeclre.i}
/*K1DT*/ {wbrp02.i}

    {glinrp3.i}
        DEFINE INPUT PARAMETER sum_lev  AS INTEGER.
        DEFINE INPUT PARAMETER sort_type AS INTEGER.
        /*DEFINE SHARED VARIABLE pl LIKE co_pl.
        DEFINE SHARED VARIABLE pl_amt AS DECIMAL NO-UNDO.*/
/*K1DT*  {mfdeclre.i} */

/*J242** FIND fm_mstr WHERE RECID(fm_mstr) = fm_recno NO-LOCK NO-ERROR. **/
/*J242*/ for first fm_mstr fields( fm_domain fm_dr_cr fm_fpos)
/*J242*/   no-lock WHERE RECID(fm_mstr) = fm_recno: end.
        IF sum_lev=1 THEN DO:           /* ca(s) */
/* SS 090709.1 - B */
/*
           {glinrpb.i &idx=asc_fcas
*/
           {xxglinrpb.i &idx=asc_fcas
                        &break1=asc_cc
            &break2="by asc_acc"
                        &test_field=asc_acc
            &test_field2=asc_cc
            &comm2="/*"
            &xtype1=""""
            &xtype2=asc_cc}
/* SS 090709.1 - E */
        END.
        ELSE DO:                /* cas */
/* SS 090709.1 - B */
/*
            {glinrpb.i &idx=asc_fcas
*/
            {xxglinrpb.i &idx=asc_fcas
                        &break1=asc_cc
            &break2="by asc_acc"
            &break3="by asc_sub"
                        &test_field=asc_sub
            &test_field2=asc_cc
            &comm2="/*"
            &xtype1=asc_sub
            &xtype2=asc_cc}
/* SS 090709.1 - E */
        END.

/*K1DT*/ {wbrp04.i}
