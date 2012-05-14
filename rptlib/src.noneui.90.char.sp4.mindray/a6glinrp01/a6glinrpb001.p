/* glinrpb0.p - GENERAL LEDGER INCOME STATEMENT REPORT SUBROUTINE          */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.    */
/* web convert glinrpb0.p (converter v1.00) Fri Oct 10 13:57:44 1997 */
/* web tag in glinrpb0.p (converter v1.00) Mon Oct 06 14:18:18 1997 */
/*F0PN*/ /*K1DT*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                           */
/* Revision: 7.3             Created:  8/13/92  By: mpp  *G030*            */
/* Revision: 8.6       LAST MODIFIED: 12/15/97  By: bvm  *K1DT*            */
/* REVISION: 8.6       LAST MODIFIED: 03/18/98  BY: *J242*   Sachin Shah   */
/* Revision: 8.6E      LAST MODIFIED: 04/07/98  By: AWe  *L00S*RO*         */
/* Revision: 8.6E      LAST MODIFIED: 10/04/98  By: *J314* Alfred Tan      */
/*!
    This program handles sort_type=0, or acc-sub-cc order.
    Because acct is the most significant sort field, a portion of code
    (in glinrpb.i) is not needed and is commented out by sending a
    left comment delimiter through &comm1.
*/

/*K1DT*/  {mfdeclre.i}
/*K1DT*/  {wbrp02.i}

       /* SS - 20050710 - B */
       /*
       {glinrp3.i}
       */
       {a6glinrp301.i}
       {a6glinrp01.i}
       /* SS - 20050710 - E */
        DEFINE INPUT PARAMETER sum_lev  AS INTEGER.
        DEFINE INPUT PARAMETER sort_type AS INTEGER.
/*K1DT*  {mfdeclre.i} */

/*J242**    FIND fm_mstr WHERE RECID(fm_mstr) = fm_recno NO-LOCK NO-ERROR.**/
/*J242*/   for first fm_mstr fields(fm_dr_cr fm_fpos)
/*J242*/     no-lock WHERE RECID(fm_mstr) = fm_recno: end.
/* SS - Bill - B 2005.07.06 */
           IF sum_lev=0 THEN DO:        /* asc */
            {a6glinrpb.i &idx=asc_fasc
                        &break1=asc_acc
            &break2="by asc_sub"
            &break3="by asc_cc"
                &test_field=asc_cc
            &test_field2=""""
            &comm1="/*"
            &xtype1=asc_sub
            &xtype2=asc_cc}
           END.
           ELSE IF sum_lev=1 THEN DO:       /* as(c) */
            {a6glinrpb.i &idx=asc_fasc
                        &break1=asc_acc
            &break2="by asc_sub"
                        &test_field=asc_sub
            &test_field2=""""
            &comm1="/*"
            &xtype1=asc_sub
            &xtype2=""""}
           END.
           ELSE DO:             /* a(sc) */
                {a6glinrpb.i &idx=asc_fasc
                        &break1=asc_acc
                        &test_field=asc_acc
                        &test_field2=""""
                        &comm1="/*"
                        &xtype1=""""
                        &xtype2=""""}
      END.
                /* SS - Bill - E */
/*K1DT*/ {wbrp04.i}