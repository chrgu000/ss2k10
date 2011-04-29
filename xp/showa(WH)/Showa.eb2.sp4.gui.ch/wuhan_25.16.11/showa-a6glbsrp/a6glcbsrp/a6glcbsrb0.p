/* glcbsrb0.p - GENERAL LEDGER BALANCE SHEET REPORT SUBROUTINE             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                      */
/* Revision: 7.3             Created:  8/13/92  By: mpp  *G030*            */
/* Revision: 8.5             Created: 03/24/98  By: *J241* Jagdish Suvarna */
/* REVISION: 8.6E     LAST MODIFIED: APR 22 98  BY: LN/SVA *L00M*RO*       */
/* Revision: 8.6E      LAST MODIFIED: 10/04/98  By: *J314* Alfred Tan      */
/* Revision: 9.1       LAST MODIFIED: 08/14/00  By: *N0L1* Mark Brown      */
/* Revision: 9.1       LAST MODIFIED: 09/12/05  By: *SS - 20050912* Bill Jiang      */

/*!
    This program handles sort_type=0, or acc-sub-cc order.
    Because acct is the most significant sort field, a portion of code
    (in glcbsrpb.i) is not needed and is commented out by sending a
    left comment delimiter through &comm1.
*/

/* SS - 20050912 - B */
{a6glcbsrp.i}
/* SS - 20050912 - E */

     {mfdeclre.i}

    {glcbsrp3.i}
        DEFINE INPUT PARAMETER sum_lev  AS INTEGER.
        DEFINE INPUT PARAMETER sort_type AS INTEGER.

/*J241*    FIND fm_mstr WHERE RECID(fm_mstr) = fm_recno NO-LOCK NO-ERROR.  */
/*J241*/   For first fm_mstr
/*J241*/        fields (fm_dr_cr fm_fpos)
/*J241*/        WHERE RECID(fm_mstr) = fm_recno NO-LOCK: end.
/* SS - 20050912 - B */
           IF sum_lev=0 THEN DO:        /* asc */
            {a6glcbsrpb.i &idx=asc_fasc
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
            {a6glcbsrpb.i &idx=asc_fasc
                        &break1=asc_acc
            &break2="by asc_sub"
                        &test_field=asc_sub
            &test_field2=""""
            &comm1="/*"
            &xtype1=asc_sub
            &xtype2=""""
            &xdesc=""""}
           END.
            /* SS - 20050912 - E */
