/* glbsrpb3.p - GENERAL LEDGER BALANCE SHEET REPORT SUBROUTINE              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*F0PN*/ /*K0V3*/
/*V8:ConvertMode=Report                                                     */
/* REVISION: 7.3            CREATED:  8/13/92   BY: mpp    *G030*           */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   by: ays    *K0V3*           */
/* REVISION: 8.6           MODIFIED: 03/19/98   BY: *J240* Kawal Batra      */
/* REVISION: 8.6E     LAST MODIFIED: APR 22 98  BY: LN/SVA  *L00S*RO*       */
/* REVISION: 8.6E          MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1           MODIFIED: 08/14/00   BY: *N0L1* Mark Brown       */
/* $Revision: 1.11 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* SS - 090708.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/*!
    This subroutine handles sort_type=3, or sort order by acc-cc-sub.
    In this routine, sub is always summarized because acs is not
    a valid sort option using the flags provided.

    Because sub-acct is the most significant sort field, a comment
    delimiter is sent through &comm2 to enable a header-printing
    if-block in glbsrpb.i.

*/
/*J240*/ /*ADDED NO-UNDO WHEREVER MISSING */
        {mfdeclre.i}
        {glbsrp3.i}

        DEFINE INPUT PARAMETER sum_lev  as integer  no-undo.
        DEFINE INPUT PARAMETER sort_type as integer  no-undo.
        DEFINE SHARED VARIABLE pl like co_pl  no-undo.
        DEFINE SHARED VARIABLE pl_amt AS DECIMAL NO-UNDO.
/*K0V3*/ {wbrp02.i}

/*J240** FIND fm_mstr WHERE RECID(fm_mstr) = fm_recno NO-LOCK NO-ERROR.**/
/*J240*/ for first fm_mstr fields( fm_domain fm_fpos fm_dr_cr)
/*J240*/     no-lock WHERE RECID(fm_mstr) = fm_recno: end.

/* SS 090708.1 - B */
/*
        {glbsrpb.i &idx=asc_fsca
*/
        {xxglbsrpb.i &idx=asc_fsca
                &break1=asc_sub
                &break2="by asc_cc"
                &break3="by asc_acc"
                &test_field=asc_acc
                &test_field2=asc_sub
                &xtype1=asc_sub
                &xtype2=asc_cc
                &comm2="/*"}
/* SS 090708.1 - E */
/*K0V3*/ {wbrp04.i}
