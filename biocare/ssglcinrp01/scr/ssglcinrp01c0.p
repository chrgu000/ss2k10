/* glcinrc0.p - GENERAL LEDGER BALANCE SHEET REPORT SUBROUTINE             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                      */
/* Revision: 7.3             Created:  8/13/92  By: mpp  *G030*            */
/* Revision: 8.5            Modified: 03/18/98  By: *J242*   Sachin Shah   */
/* REVISION: 8.6E      LAST MODIFIED: APR 23 98 BY: LN/SVA  *L00W*         */
/* Revision: 8.6E           Modified: 10/04/98  By: *J314* Alfred Tan      */
/* Revision: 9.1            Modified: 08/14/00  By: *N0L1* Mark Brown      */
/* $Revision: 1.11 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* $Revision: 1.11 $ BY: Bill Jiang DATE: 08/16/07 ECO: *SS - 20070816.1* */
/*-Revision end---------------------------------------------------------------*/

/*!
    This program handles sort_type=0, or acc-sub-cc order.
    Because acct is the most significant sort field, a portion of code
    (in glcbsrpb.i) is not needed and is commented out by sending a
    left comment delimiter through &comm1.
*/

/* SS - 20070816.1 - B */
{ssglcinrp01.i}
/* SS - 20070816.1 - E */

       {mfdeclre.i}

    {glcinrp3.i}
        DEFINE INPUT PARAMETER sum_lev  AS INTEGER.
        DEFINE INPUT PARAMETER sort_type AS INTEGER.

/*L00W* BEGIN ADD*/
        /* DEFINITION OF EURO TOOLKIT VARIABLES */
        {etrpvar.i &new = " "}
        {etvar.i   &new = " "}

        define     shared variable et_income      like income     no-undo.
        define     shared variable et_balance     like balance    no-undo.
        define     shared variable et_tot         like tot        no-undo.
        define     shared variable et_tot1        like tot1       no-undo.
        define            variable et_balance1    like balance1   no-undo.
        define            variable et_variance    like variance   no-undo.
/*L00W* END ADD*/

/*J242**    FIND fm_mstr WHERE RECID(fm_mstr) = fm_recno NO-LOCK NO-ERROR.  **/

/*J242*/   For first fm_mstr
/*J242*/        fields( fm_domain fm_dr_cr fm_fpos)
/*J242*/        WHERE RECID(fm_mstr) = fm_recno NO-LOCK: end.
           IF sum_lev=0 THEN DO:        /* asc */
            {ssglcinrp01c.i &idx=asc_fasc
                        &break1=asc_acc
            &break2="by asc_sub"
            &break3="by asc_cc"
                &test_field=asc_cc
            &test_field2=""""
            &comm1="/*"
            &xtype1=asc_sub
            &xtype2=asc_cc
            &xdesc=""""}
           END.
           ELSE DO:     /* as(c) */
            {ssglcinrp01c.i &idx=asc_fasc
                        &break1=asc_acc
            &break2="by asc_sub"
                        &test_field=asc_sub
            &test_field2=""""
            &comm1="/*"
            &xtype1=asc_sub
            &xtype2=""""
            &xdesc=""""}
           END.
