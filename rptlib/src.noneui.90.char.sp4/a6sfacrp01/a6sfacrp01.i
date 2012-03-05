/* gpacctp.i - Defines work file to accumulate currency totals.         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 03/01/91   BY: bjb  /*D461*/   */
/* REVISION: 7.3      LAST MODIFIED: 04/15/96   BY: jzw  /*G1T9*/   */
/* REVISION: 9.0 LAST MODIFIED: 2005/07/13 BY: *SS - 20050713* Bill Jiang */
/* REVISION: 9.0 LAST MODIFIED: 2005/08/09 BY: *SS - 20050809* Bill Jiang */

/*G1T9*  define new shared workfile ap_wkfl */
/* SS - 20050713 - B */
/*
/*G1T9*/ define {1} shared workfile ap_wkfl
    field apwk_curr like ap_curr         /* Currency Type                */
    field apwk_for like vo_applied      /* Value in foreign currency    */
    field apwk_base like ap_amt.       /* Value in base currency       */
               */
DEFINE {1} SHARED TEMP-TABLE tta6sfacrp01
    /* SS - 20050809 - B */
    FIELD tta6sfacrp01_acc LIKE gltr_acc
    FIELD tta6sfacrp01_sub LIKE gltr_sub
    FIELD tta6sfacrp01_ctr LIKE gltr_ctr
    FIELD tta6sfacrp01_amt LIKE gltr_amt
    FIELD tta6sfacrp01_type LIKE op_type
    FIELD tta6sfacrp01_part LIKE op_part
    FIELD tta6sfacrp01_trnbr LIKE op_trnbr
    /*
    FIELD tta6sfacrp01_inv_nbr LIKE tr_rmks
    FIELD tta6sfacrp01_nbr LIKE tr_nbr
    FIELD tta6sfacrp01_line LIKE tr_line
    FIELD tta6sfacrp01_acct LIKE trgl_dr_acct
    FIELD tta6sfacrp01_cc LIKE trgl_dr_cc
    FIELD tta6sfacrp01_base_price LIKE trgl_gl_amt FORMAT "->>,>>>,>>>.99"
    INDEX tta6sfacrp01_index tta6sfacrp01_inv_nbr tta6sfacrp01_nbr tta6sfacrp01_line tta6sfacrp01_acct
    */
    /* SS - 20050809 - E */
    .
/* SS - 20050713 - E */
