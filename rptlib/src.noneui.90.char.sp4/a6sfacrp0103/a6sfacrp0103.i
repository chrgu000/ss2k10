/* gpacctp.i - Defines work file to accumulate currency totals.         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 03/01/91   BY: bjb  /*D461*/   */
/* REVISION: 7.3      LAST MODIFIED: 04/15/96   BY: jzw  /*G1T9*/   */
/* REVISION: 7.3      LAST MODIFIED: 08/30/05   BY: Bill Jiang  /*SS - 20050830*/   */

/*G1T9*  define new shared workfile ap_wkfl */
/* SS - 20050830 - B */
/*
/*G1T9*/ define {1} shared workfile ap_wkfl
    field apwk_curr like ap_curr         /* Currency Type                */
    field apwk_for like vo_applied      /* Value in foreign currency    */
    field apwk_base like ap_amt.       /* Value in base currency       */
               */
DEFINE {1} SHARED TEMP-TABLE tta6sfacrp0103
    FIELD tta6sfacrp0103_site LIKE op_site
    FIELD tta6sfacrp0103_part LIKE op_part
    FIELD tta6sfacrp0103_nbr LIKE op_wo_nbr
    FIELD tta6sfacrp0103_lot LIKE op_wo_lot
    FIELD tta6sfacrp0103_amt_dr LIKE gltr_amt
    FIELD tta6sfacrp0103_amt_cr LIKE gltr_amt
    INDEX index1 IS UNIQUE
        tta6sfacrp0103_site
        tta6sfacrp0103_part
        tta6sfacrp0103_nbr
        tta6sfacrp0103_lot
    .
/* SS - 20050830 - E */
