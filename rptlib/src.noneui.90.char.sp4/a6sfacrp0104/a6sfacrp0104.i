/* gpacctp.i - Defines work file to accumulate currency totals.         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 03/01/91   BY: bjb  /*D461*/   */
/* REVISION: 7.3      LAST MODIFIED: 04/15/96   BY: jzw  /*G1T9*/   */
/* REVISION: 7.3      LAST MODIFIED: 09/01/05   BY: Bill Jiang  /*SS - 20050901*/   */

/*G1T9*  define new shared workfile ap_wkfl */
/* SS - 20050901 - B */
/*
/*G1T9*/ define {1} shared workfile ap_wkfl
    field apwk_curr like ap_curr         /* Currency Type                */
    field apwk_for like vo_applied      /* Value in foreign currency    */
    field apwk_base like ap_amt.       /* Value in base currency       */
               */
DEFINE {1} SHARED TEMP-TABLE tta6sfacrp0104
    FIELD tta6sfacrp0104_acct LIKE opgl_dr_acct
    FIELD tta6sfacrp0104_cc LIKE opgl_dr_cc
    FIELD tta6sfacrp0104_site LIKE op_site
    FIELD tta6sfacrp0104_part LIKE op_part
    FIELD tta6sfacrp0104_trnbr LIKE op_trnbr
    FIELD tta6sfacrp0104_type LIKE op_type
    FIELD tta6sfacrp0104_nbr LIKE op_wo_nbr
    FIELD tta6sfacrp0104_amt LIKE gltr_amt
    .
/* SS - 20050901 - E */
