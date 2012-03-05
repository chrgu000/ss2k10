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
DEFINE {1} SHARED TEMP-TABLE tta6ictrrp0309
    FIELD tta6ictrrp0309_acct LIKE trgl_dr_acct
    FIELD tta6ictrrp0309_cc LIKE trgl_dr_cc
    FIELD tta6ictrrp0309_site LIKE tr_site
    FIELD tta6ictrrp0309_part LIKE tr_part
    FIELD tta6ictrrp0309_trnbr LIKE tr_trnbr
    FIELD tta6ictrrp0309_type LIKE tr_type
    FIELD tta6ictrrp0309_nbr LIKE tr_nbr
    FIELD tta6ictrrp0309_qty LIKE tr_qty_loc
    FIELD tta6ictrrp0309_amt LIKE trgl_gl_amt
    .
/* SS - 20050901 - E */
