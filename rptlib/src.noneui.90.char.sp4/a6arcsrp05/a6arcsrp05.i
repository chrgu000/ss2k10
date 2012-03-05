/* gpacctp.i - Defines work file to accumulate currency totals.         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 03/01/91   BY: bjb  /*D461*/   */
/* REVISION: 7.3      LAST MODIFIED: 04/15/96   BY: jzw  /*G1T9*/   */

/*G1T9*  define new shared workfile ap_wkfl */
/* SS - Bill - B 2005.06.30 */
/*
/*G1T9*/ define {1} shared workfile ap_wkfl
    field apwk_curr like ap_curr         /* Currency Type                */
    field apwk_for like vo_applied      /* Value in foreign currency    */
    field apwk_base like ap_amt.       /* Value in base currency       */
               */
DEFINE {1} SHARED TEMP-TABLE ttar
    FIELD ttar_bill LIKE ar_bill
    FIELD ttar_acct LIKE ar_acct
    FIELD ttar_cc LIKE ar_cc
    FIELD ttar_nbr LIKE ar_nbr
    FIELD ttar_type LIKE ar_type
    FIELD ttar_effdate LIKE ar_effdate
    FIELD ttar_due_date LIKE ar_due_date
    FIELD ttar_date LIKE ar_date
    FIELD ttar_et_age_amt LIKE ar_amt EXTENT 6
    FIELD ttar_amt LIKE ar_amt
    .
/* SS - Bill - E */
