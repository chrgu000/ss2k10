/* glbsrpb0.p - GENERAL LEDGER BALANCE SHEET REPORT SUBROUTINE             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/*F0PN*/ /*K0V3*/
/*V8:ConvertMode=Report                                                    */
/* Revision: 7.3             Created:  8/13/92  By: mpp  *G030*            */
/* REVISION 8.6       LAST MODIFIED  10/13/97   by: ays  *K0V3*            */
/* Revision: 8.6           MODIFIED: 03/19/98   By: *J240* Kawal Batra     */
/* REVISION: 8.6E     LAST MODIFIED: APR 22 98  BY: LN/SVA  *L00S*RO*      */
/* Revision: 8.6E          MODIFIED: 10/04/98   By: *J314* Alfred Tan      */
/* Revision: 9.1           MODIFIED: 08/14/00   By: *N0L1* Mark Brown      */
/* $Revision: 1.11 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* SS - 090708.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/*!
    This program handles sort_type=0, or acc-sub-cc order.
    Because acct is the most significant sort field, a portion of code
    (in glbsrpb.i) is not needed and is commented out by sending a
    left comment delimiter through &comm1.
*/
/*J240*/ /* ADDED NO_UNDO WHEREVER MISSING   */

        {mfdeclre.i}
        {glbsrp3.i}

        DEFINE INPUT PARAMETER sum_lev  AS INTEGER  no-undo.
        DEFINE INPUT PARAMETER sort_type AS INTEGER  no-undo.
        DEFINE SHARED VARIABLE pl LIKE co_pl  no-undo.
        DEFINE SHARED VARIABLE pl_amt AS DECIMAL NO-UNDO.

/*K0V3*/ {wbrp02.i}

/*J240** FIND fm_mstr WHERE RECID(fm_mstr) = fm_recno NO-LOCK NO-ERROR. **/
/*J240*/ for first fm_mstr  fields( fm_domain fm_fpos fm_dr_cr)
/*J240*/    no-lock WHERE RECID(fm_mstr) = fm_recno: end.

           IF sum_lev=0 THEN DO:        /* asc */
/* SS 090708.1 - B */
/*
            {glbsrpb.i &idx=asc_fasc
*/
            {xxglbsrpb.i &idx=asc_fasc
                        &break1=asc_acc
            &break2="by asc_sub"
            &break3="by asc_cc"
                &test_field=asc_cc
            &test_field2=""""
            &comm1="/*"
            &xtype1=asc_sub
            &xtype2=asc_cc}
/* SS 090708.1 - E */
           END.
           ELSE IF sum_lev=1 THEN DO:       /* as(c) */
/* SS 090708.1 - B */
/*
            {glbsrpb.i &idx=asc_fasc
*/
            {xxglbsrpb.i &idx=asc_fasc
                        &break1=asc_acc
            &break2="by asc_sub"
                        &test_field=asc_sub
            &test_field2=""""
            &comm1="/*"
            &xtype1=asc_sub
            &xtype2=""""
            &xdesc=""""}
/* SS 090708.1 - E */
           END.
           ELSE DO:             /* a(sc) */
/* SS 090708.1 - B */
/*
            {glbsrpb.i &idx=asc_fasc
*/
            {xxglbsrpb.i &idx=asc_fasc
                        &break1=asc_acc
                &test_field=asc_acc
            &test_field2=""""
            &comm1="/*"
            &xtype1=""""
            &xtype2=""""
            &xdesc=""""}
/* SS 090708.1 - E */
           END.

/*K0V3*/ {wbrp04.i}
