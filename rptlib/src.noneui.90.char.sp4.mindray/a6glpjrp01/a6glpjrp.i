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
DEFINE {1} SHARED WORKFILE wfpj
    FIELD wfpj_acc LIKE gltr_acc
    FIELD wfpj_sub LIKE gltr_sub
    FIELD wfpj_project LIKE gltr_project
    FIELD wfpj_type LIKE pj_type
    FIELD wfpj_desc LIKE pj_desc
    FIELD wfpj_amt LIKE gltr_amt
    .
/* SS - Bill - E */
