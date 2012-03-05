/* gpacctp.i - Defines work file to accumulate currency totals.         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 03/01/91   BY: bjb  /*D461*/   */
/* REVISION: 7.3      LAST MODIFIED: 04/15/96   BY: jzw  /*G1T9*/   */
/* REVISION: 9.0 LAST MODIFIED: 2005/07/13 BY: *SS - 20050713* Bill Jiang */

/*G1T9*  define new shared workfile ap_wkfl */
/* SS - 20050713 - B */
/*
/*G1T9*/ define {1} shared workfile ap_wkfl
    field apwk_curr like ap_curr         /* Currency Type                */
    field apwk_for like vo_applied      /* Value in foreign currency    */
    field apwk_base like ap_amt.       /* Value in base currency       */
               */
DEFINE {1} SHARED TEMP-TABLE tttrgl
    FIELD tttrgl_acct LIKE trgl_dr_acct
    FIELD tttrgl_prodline LIKE tr_prod_line
    FIELD tttrgl_base_price LIKE trgl_gl_amt FORMAT "->>,>>>,>>>.99"
    INDEX tttrgl_index tttrgl_acct tttrgl_prodline
    .
/* SS - 20050713 - E */
