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
DEFINE {1} SHARED TEMP-TABLE tta6ppptrp0601
    field tta6ppptrp0601_site like IN_site
    field tta6ppptrp0601_pl like pl_prod_line
    field tta6ppptrp0601_qty like in_qty_oh
    field tta6ppptrp0601_ext AS DECIMAL
    INDEX index1 IS UNIQUE tta6ppptrp0601_site tta6ppptrp0601_pl
    .
/* SS - 20050901 - E */
