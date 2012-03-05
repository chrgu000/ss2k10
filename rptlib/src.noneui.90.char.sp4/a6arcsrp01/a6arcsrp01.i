/* gpacctp.i - Defines work file to accumulate currency totals.         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 03/01/91   BY: bjb  /*D461*/   */
/* REVISION: 7.3      LAST MODIFIED: 04/15/96   BY: jzw  /*G1T9*/   */
/* REVISION: 8.6E     LAST MODIFIED: 08/04/05   BY: *SS - 20050804* Bill Jiang       */

/*G1T9*  define new shared workfile ap_wkfl */
/* SS - 20050804 - B */
/*
/*G1T9*/ define {1} shared workfile ap_wkfl
    field apwk_curr like ap_curr         /* Currency Type                */
    field apwk_for like vo_applied      /* Value in foreign currency    */
    field apwk_base like ap_amt.       /* Value in base currency       */
               */
DEFINE {1} SHARED TEMP-TABLE tta6arcsrp01
    FIELD tta6arcsrp01_bill LIKE ar_bill
    FIELD tta6arcsrp01_acct LIKE ar_acct
    FIELD tta6arcsrp01_cc LIKE ar_cc
    FIELD tta6arcsrp01_nbr LIKE ar_nbr
    FIELD tta6arcsrp01_type LIKE ar_type
    FIELD tta6arcsrp01_due_date LIKE ar_due_date
    FIELD tta6arcsrp01_amt1 LIKE ar_amt
    FIELD tta6arcsrp01_amt2 LIKE ar_amt
    FIELD tta6arcsrp01_amt3 LIKE ar_amt
    FIELD tta6arcsrp01_amt4 LIKE ar_amt
    FIELD tta6arcsrp01_amt5 LIKE ar_amt
    FIELD tta6arcsrp01_amt LIKE ar_amt
    .
/* SS - 20050804 - E */

