/* gl4inrb0.p - GENERAL LEDGER INCOME STATEMENT REPORT SUBROUTINE          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/*F0PN*/ /*K0S5*/
/*V8:ConvertMode=Report                                           */
/* Revision: 7.3             Created:  8/13/92  By: mpp  *G030*            */
/* REVISION: 8.6       LAST MODIFIED: 10/11/97  by: ays  *K0S5*            */
/* Revision: 8.6            Modified: 03/12/98  By: *J23W*  Sachin Shah    */
/* REVISION: 8.6E     LAST MODIFIED: 24 apr 98  BY: *L00M* D. Sidel        */
/* Revision: 8.6E           Modified: 10/04/98  By: *J314* Alfred Tan      */
/* Revision: 9.1            Modified: 08/14/00  By: *N0L1* Mark Brown      */
/* $Revision: 1.9 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/*-Revision end---------------------------------------------------------------*/


/*!
    This program handles sort_type=0, or acc-sub-cc order.
    Because acct is the most significant sort field, a portion of code
    (in gl4inrpb.i) is not needed and is commented out by sending a
    left comment delimiter through &comm1.
*/

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

/*J23W**    FIND fm_mstr WHERE RECID(fm_mstr) = fm_recno NO-LOCK NO-ERROR. **/

/*J23W*/   for first fm_mstr fields( fm_domain fm_fpos fm_dr_cr)
/*J23W*/       WHERE RECID(fm_mstr) = fm_recno NO-LOCK: end.
           IF sum_lev=0 THEN DO:        /* asc */
/* SS 090715.1 - B */
/*
            {gl4inrpb.i &idx=asc_fasc
*/
            {xxgl4inrpb.i &idx=asc_fasc
                        &break1=asc_acc
            &break2="by asc_sub"
            &break3="by asc_cc"
                &test_field=asc_cc
            &test_field2=""""
            &comm1="/*"
            &xtype1=asc_sub
            &xtype2=asc_cc}
/* SS 090715.1 - E */
           END.
           ELSE IF sum_lev=1 THEN DO:       /* as(c) */
/* SS 090715.1 - B */
/*
            {gl4inrpb.i &idx=asc_fasc
*/
            {xxgl4inrpb.i &idx=asc_fasc
                        &break1=asc_acc
            &break2="by asc_sub"
                        &test_field=asc_sub
            &test_field2=""""
            &comm1="/*"
            &xtype1=asc_sub
            &xtype2=""""}
/* SS 090715.1 - E */
           END.
           ELSE DO:             /* a(sc) */
/* SS 090715.1 - B */
/*
                {gl4inrpb.i &idx=asc_fasc
*/
                {xxgl4inrpb.i &idx=asc_fasc
                        &break1=asc_acc
                        &test_field=asc_acc
                        &test_field2=""""
                        &comm1="/*"
                        &xtype1=""""
                        &xtype2=""""}
/* SS 090715.1 - E */
      END.
/*K0S5*/ {wbrp04.i}
