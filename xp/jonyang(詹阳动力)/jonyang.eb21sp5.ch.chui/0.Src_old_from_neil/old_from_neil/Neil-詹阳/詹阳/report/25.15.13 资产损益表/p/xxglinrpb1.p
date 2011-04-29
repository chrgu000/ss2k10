/* glinrpb1.p - GENERAL LEDGER INCOME STATEMENT REPORT SUBROUTINE           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*F0PN*/ /*K1DT*/
/*V8:ConvertMode=Report                                            */
/* REVISION: 7.3              CREATED: 8/13/92   BY: mpp    *G030*          */
/* REVISION: 8.6        LAST MODIFIED:12/15/97   BY: bvm    *K1DT*          */
/* REVISION: 8.6        LAST MODIFIED: 03/18/98  BY: *J242*   Sachin Shah   */
/* REVISION: 8.6E       LAST MODIFIED:04/07/98   BY: AWe    *L00S*RO*       */
/* REVISION: 8.6E       LAST MODIFIED: 10/04/98  BY: *J314* Alfred Tan      */
/* REVISION: 9.1        LAST MODIFIED: 08/14/00  BY: *N0L1* Mark Brown      */
/* $Revision: 1.10 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* SS - 090709.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/*!
    This subroutine handles sort_type=1, or sort order by sub, acc, cc.
    Because sub is the most significant sort field, a comment delimiter
    is sent through &comm2 to enable a header-printing if-block in
    glinrpb.i.

*/
/*K1DT*/  {mfdeclre.i}
/*K1DT*/ {wbrp02.i}

    {glinrp3.i}
        DEFINE INPUT PARAMETER sum_lev  as integer.
        DEFINE INPUT PARAMETER sort_type as integer.
   /*     DEFINE SHARED VARIABLE pl like co_pl.
        DEFINE SHARED VARIABLE pl_amt AS DECIMAL NO-UNDO.*/
/*K1DT*  {mfdeclre.i}*/

/*J242** FIND fm_mstr WHERE RECID(fm_mstr) = fm_recno NO-LOCK NO-ERROR. **/
/*J242*/ for first fm_mstr fields( fm_domain fm_dr_cr fm_fpos)
/*J242*/   no-lock WHERE RECID(fm_mstr) = fm_recno: end.
    IF sum_lev=1 THEN DO:           /* sa(c) */
/* SS 090709.1 - B */
/*
              {glinrpb.i &idx=asc_fsac
*/
              {xxglinrpb.i &idx=asc_fsac
                    &break1=asc_sub
            &break2="by asc_acc"
                    &test_field=asc_acc
            &test_field2=asc_sub
            &comm2="/*"
            &xtype1=asc_sub
            &xtype2=""""}
/* SS 090709.1 - E */
        END.
        ELSE DO:                    /* sac */
/* SS 090709.1 - B */
/*
              {glinrpb.i &idx=asc_fsac
*/
              {xxglinrpb.i &idx=asc_fsac
                        &break1=asc_sub
            &break2="by asc_acc"
            &break3="by asc_cc"
                        &test_field=asc_cc
            &test_field2=asc_sub
            &comm2="/*"
            &xtype1=asc_sub
            &xtype2=asc_cc}
/* SS 090709.1 - E */
        END.

/*K1DT*/ {wbrp04.i}
