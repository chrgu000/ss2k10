/* gpacctp.i - Defines work file to accumulate currency totals.         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 03/01/91   BY: bjb  /*D461*/   */
/* REVISION: 7.3      LAST MODIFIED: 04/15/96   BY: jzw  /*G1T9*/   */
/* REVISION: 7.3      LAST MODIFIED: 08/25/05   BY: Bill Jiang  /*SS - 20050825*/   */

/*G1T9*  define new shared workfile ap_wkfl */
/* SS - 20050825 - B */
/*
/*G1T9*/ define {1} shared workfile ap_wkfl
    field apwk_curr like ap_curr         /* Currency Type                */
    field apwk_for like vo_applied      /* Value in foreign currency    */
    field apwk_base like ap_amt.       /* Value in base currency       */
               */
DEFINE {1} SHARED TEMP-TABLE tta6glabiq
    FIELD tta6glabiq_acc LIKE gltr_acc
    FIELD tta6glabiq_curr LIKE ac_curr
    FIELD tta6glabiq_beg LIKE gltr_amt
    FIELD tta6glabiq_dr LIKE gltr_amt
    FIELD tta6glabiq_cr LIKE gltr_amt
    FIELD tta6glabiq_end LIKE gltr_amt
    INDEX index1 IS UNIQUE tta6glabiq_acc tta6glabiq_curr
    INDEX index2 tta6glabiq_acc
    .
/* SS - 20050825 - E */