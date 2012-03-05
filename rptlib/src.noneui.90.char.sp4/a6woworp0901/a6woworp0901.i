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
DEFINE {1} SHARED TEMP-TABLE tta6woworp0901
    FIELD tta6woworp0901_acct LIKE wo_acct
    FIELD tta6woworp0901_cc LIKE wo_cc
    FIELD tta6woworp0901_project LIKE wo_project
    FIELD tta6woworp0901_nbr LIKE wo_nbr
    FIELD tta6woworp0901_lot LIKE wo_lot
    FIELD tta6woworp0901_part LIKE wo_part
    FIELD tta6woworp0901_site LIKE wo_site
    FIELD tta6woworp0901_desc1 LIKE pt_desc1
    FIELD tta6woworp0901_qty_ord LIKE wo_qty_ord
    FIELD tta6woworp0901_qty_comp LIKE wo_qty_comp
    FIELD tta6woworp0901_mtl_tot LIKE wo_mtl_tot
    FIELD tta6woworp0901_lbr_tot LIKE wo_lbr_tot
    FIELD tta6woworp0901_bdn_tot LIKE wo_bdn_tot
    FIELD tta6woworp0901_sub_tot LIKE wo_sub_tot
    FIELD tta6woworp0901_wip_tot LIKE wo_wip_tot
    .
/* SS - 20050804 - E */

