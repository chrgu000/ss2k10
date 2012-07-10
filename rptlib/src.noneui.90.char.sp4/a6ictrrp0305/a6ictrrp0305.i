/* gpacctp.i - Defines work file to accumulate currency totals.         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 03/01/91   BY: bjb  /*D461*/   */
/* REVISION: 7.3      LAST MODIFIED: 04/15/96   BY: jzw  /*G1T9*/   */
/* REVISION: 7.3      LAST MODIFIED: 08/24/05   BY: Bill Jiang  /*SS - 20050824*/   */

/*G1T9*  define new shared workfile ap_wkfl */
/* SS - 20050824 - B */
/*
/*G1T9*/ define {1} shared workfile ap_wkfl
    field apwk_curr like ap_curr         /* Currency Type                */
    field apwk_for like vo_applied      /* Value in foreign currency    */
    field apwk_base like ap_amt.       /* Value in base currency       */
               */
DEFINE {1} SHARED TEMP-TABLE tta6ictrrp0305
    FIELD tta6ictrrp0305_part LIKE tr_part
    FIELD tta6ictrrp0305_site LIKE tr_site
    FIELD tta6ictrrp0305_nbr LIKE tr_nbr
    FIELD tta6ictrrp0305_lot LIKE tr_lot
    FIELD tta6ictrrp0305_amt LIKE gltr_amt
    INDEX partsite IS UNIQUE
        tta6ictrrp0305_part
        tta6ictrrp0305_site
        tta6ictrrp0305_nbr
        tta6ictrrp0305_lot
    .
/* SS - 20050824 - E */