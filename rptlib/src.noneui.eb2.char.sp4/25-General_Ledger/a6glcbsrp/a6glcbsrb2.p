/* glcbsrb2.p - GENERAL LEDGER BALANCE SHEET REPORT SUBROUTINE              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                       */
/* REVISION: 7.3            CREATED:  8/13/92   BY: mpp *G030*              */
/* Revision: 8.5            Created: 03/24/97   By: *J241* Jagdish Suvarna  */
/* REVISION: 8.6E     LAST MODIFIED: APR 22 98  BY: LN/SVA *L00M*RO*        */
/* Revision: 8.6E     LAST MODIFIED: 10/04/98   By: *J314* Alfred Tan       */
/* Revision: 9.1      LAST MODIFIED: 08/14/00   By: *N0L1* Mark Brown       */
/* Revision: 9.1      LAST MODIFIED: 09/12/05   By: *SS - 20050912* Bill Jiang       */
/*!
    This subroutine handles sort_type=2, or sort by cc, acc, sub.
    It sends a comment delimiter through &comm2 in order to enable
    an if-block in glcbsrpb.i which will print cc header info.
*/

/* SS - 20050912 - B */
{a6glcbsrp.i}
/* SS - 20050912 - E */

       {mfdeclre.i}

    {glcbsrp3.i}
        DEFINE INPUT PARAMETER sum_lev  AS INTEGER.
        DEFINE INPUT PARAMETER sort_type AS INTEGER.
        /*DEFINE SHARED VARIABLE pl LIKE co_pl.
        DEFINE SHARED VARIABLE pl_amt AS DECIMAL NO-UNDO.*/


/*J241*    FIND fm_mstr WHERE RECID(fm_mstr) = fm_recno NO-LOCK NO-ERROR.  */
/*J241*/   For first fm_mstr
/*J241*/        fields (fm_dr_cr fm_fpos)
/*J241*/        WHERE RECID(fm_mstr) = fm_recno NO-LOCK: end.
/* SS - 20050912 - B */
        IF sum_lev=1 THEN DO:           /* ca(s) */
           {a6glcbsrpb.i &idx=asc_fcas
                        &break1=asc_cc
            &break2="by asc_acc"
                        &test_field=asc_acc
            &test_field2=asc_cc
            &comm2="/*"
            &xtype1=""""
            &xtype2=asc_cc}
        END.
        ELSE DO:                /* cas */
            {a6glcbsrpb.i &idx=asc_fcas
                        &break1=asc_cc
            &break2="by asc_acc"
            &break3="by asc_sub"
                        &test_field=asc_sub
            &test_field2=asc_cc
            &comm2="/*"
            &xtype1=asc_sub
            &xtype2=asc_cc}
        END.
            /* SS - 20050912 - E */
