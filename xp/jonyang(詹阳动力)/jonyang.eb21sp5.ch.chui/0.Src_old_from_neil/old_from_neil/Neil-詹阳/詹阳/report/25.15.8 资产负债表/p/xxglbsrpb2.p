/* glbsrpb2.p - GENERAL LEDGER BALANCE SHEET REPORT SUBROUTINE              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*F0PN*/ /*K0V3*/
/*V8:ConvertMode=Report                                                     */
/* REVISION: 7.3            CREATED:  8/13/92   BY: mpp  *G030*             */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   by: ays  *K0V3*             */
/* REVISION: 8.6           MODIFIED: 03/19/98   BY: *J240* Kawal Batra      */
/* REVISION: 8.6E     LAST MODIFIED: APR 22 98  BY: LN/SVA  *L00S*RO*       */
/* REVISION: 8.6E          MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1           MODIFIED: 08/14/00   BY: *N0L1* Mark Brown       */
/* $Revision: 1.11 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* SS - 090708.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/*!
    This subroutine handles sort_type=2, or sort by cc, acc, sub.
    It sends a comment delimiter through &comm2 in order to enable
    an if-block in glbsrpb.i which will print cc header info.
*/
/*J240*/ /* ADDED NO-UNDO THROUGHOUT */
        {mfdeclre.i}
        {glbsrp3.i}
        DEFINE INPUT PARAMETER sum_lev  AS INTEGER  no-undo.
        DEFINE INPUT PARAMETER sort_type AS INTEGER  no-undo.
        DEFINE SHARED VARIABLE pl LIKE co_pl  no-undo.
        DEFINE SHARED VARIABLE pl_amt AS DECIMAL NO-UNDO.
/*K0V3*/ {wbrp02.i}

/*J240** FIND fm_mstr WHERE RECID(fm_mstr) = fm_recno NO-LOCK NO-ERROR. **/
/*J240*/ For first fm_mstr fields( fm_domain fm_fpos fm_dr_cr)
/*J240*/     no-lock WHERE RECID(fm_mstr) = fm_recno: end.

        IF sum_lev=1 THEN DO:           /* ca(s) */
/* SS 090708.1 - B */
/*
           {glbsrpb.i &idx=asc_fcas
*/
           {xxglbsrpb.i &idx=asc_fcas
                        &break1=asc_cc
            &break2="by asc_acc"
                        &test_field=asc_acc
            &test_field2=asc_cc
            &comm2="/*"
            &xtype1=""""
            &xtype2=asc_cc}
/* SS 090708.1 - E */
        END.
        ELSE DO:                /* cas */
/* SS 090708.1 - B */
/*
            {glbsrpb.i &idx=asc_fcas
*/
            {xxglbsrpb.i &idx=asc_fcas
                        &break1=asc_cc
            &break2="by asc_acc"
            &break3="by asc_sub"
                        &test_field=asc_sub
            &test_field2=asc_cc
            &comm2="/*"
            &xtype1=asc_sub
            &xtype2=asc_cc}
/* SS 090708.1 - B */
        END.

/*K0V3*/ {wbrp04.i}
