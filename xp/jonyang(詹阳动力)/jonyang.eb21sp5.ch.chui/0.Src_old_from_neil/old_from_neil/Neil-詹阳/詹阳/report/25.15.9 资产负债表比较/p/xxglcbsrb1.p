/* glcbsrb1.p - GENERAL LEDGER BALANCE SHEET REPORT SUBROUTINE              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                       */
/* REVISION: 7.3            CREATED:  8/13/92   BY: mpp    *G030*           */
/* Revision: 8.5            Created: 03/24/98   By: *J241* Jagdish Suvarna  */
/* REVISION: 8.6E     LAST MODIFIED: APR 22 98  BY: LN/SVA *L00M*RO*        */
/* Revision: 8.6E     LAST MODIFIED: 10/04/98   By: *J314* Alfred Tan       */
/* Revision: 9.1      LAST MODIFIED: 08/14/00   By: *N0L1* Mark Brown       */
/* $Revision: 1.9 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/*-Revision end---------------------------------------------------------------*/


/*!
    This subroutine handles sort_type=1, or sort order by sub, acc, cc.
    Because sub is the most significant sort field, a comment delimiter
    is sent through &comm2 to enable a header-printing if-block in
    glcbsrpb.i.

*/
        {mfdeclre.i}

    {glcbsrp3.i}
        DEFINE INPUT PARAMETER sum_lev  as integer.
        DEFINE INPUT PARAMETER sort_type as integer.
   /*     DEFINE SHARED VARIABLE pl like co_pl.
        DEFINE SHARED VARIABLE pl_amt AS DECIMAL NO-UNDO.*/

/*J241*       FIND fm_mstr WHERE RECID(fm_mstr) = fm_recno NO-LOCK NO-ERROR. */
/*J241*/ For first fm_mstr
/*J241*/    fields( fm_domain fm_dr_cr fm_fpos)
/*J241*/    no-lock WHERE RECID(fm_mstr) = fm_recno: end.

    IF sum_lev=1 THEN DO:           /* sa(c) */
/* SS 090715.1 - B */
/*
              {glcbsrpb.i &idx=asc_fsac
*/
              {xxglcbsrpb.i &idx=asc_fsac
                    &break1=asc_sub
            &break2="by asc_acc"
                    &test_field=asc_acc
            &test_field2=asc_sub
            &comm2="/*"
            &xtype1=asc_sub
            &xtype2=""""}
/* SS 090715.1 - E */
        END.
        ELSE DO:                    /* sac */
/* SS 090715.1 - B */
/*
              {glcbsrpb.i &idx=asc_fsac
*/
              {xxglcbsrpb.i &idx=asc_fsac
                        &break1=asc_sub
            &break2="by asc_acc"
            &break3="by asc_cc"
                        &test_field=asc_cc
            &test_field2=asc_sub
            &comm2="/*"
            &xtype1=asc_sub
            &xtype2=asc_cc}
/* SS 090715.1 - E */
        END.
