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
DEFINE {1} SHARED WORKFILE wfidh
    FIELD wfidh_inv_nbr LIKE ih_inv_nbr
    FIELD wfidh_nbr LIKE ih_nbr
    FIELD wfidh_line LIKE idh_line
    FIELD wfidh_cust LIKE ih_cust
    FIELD wfidh_part LIKE idh_part
    FIELD wfidh_prodline LIKE idh_prodline
    FIELD wfidh_qty_inv LIKE idh_qty_inv
    FIELD wfidh_ext_price LIKE idh_price FORMAT "->>,>>>,>>>.99"
    FIELD wfidh_ext_gr_margin LIKE idh_price FORMAT "->>,>>>,>>9.99"
    FIELD wfidh_ext_tax_amt LIKE idh_price FORMAT "->>,>>>,>>9.99"
    FIELD wfidh_base_price LIKE idh_price FORMAT "->>,>>>,>>>.99"
    FIELD wfidh_base_margin LIKE idh_price FORMAT "->>,>>>,>>9.99"
    FIELD wfidh_base_tax_amt LIKE idh_price FORMAT "->>,>>>,>>9.99"
    FIELD wfidh_acct LIKE idh_acct
    FIELD wfidh_cc LIKE idh_cc
    FIELD wfidh_taxc LIKE idh_taxc
    /*
    FIELD wfidh_pl_desc LIKE pl_desc
    FIELD wfidh_pl__chr01 LIKE pl__chr01
    FIELD wfidh_pl__chr01_cmmt LIKE CODE_cmmt
    FIELD wfidh_pl__chr02 LIKE pl__chr02
    FIELD wfidh_pl__chr02_cmmt LIKE CODE_cmmt
    FIELD wfidh_cc_desc LIKE cc_desc
    FIELD wfidh_cc_user1 LIKE cc_user1
    FIELD wfidh_cc_user1_cmmt LIKE CODE_cmmt
    FIELD wfidh_cc_user2 LIKE cc_user2
    FIELD wfidh_cc_user2_cmmt LIKE CODE_cmmt
    FIELD wfidh_cc__qadc01 LIKE cc__qadc01
    FIELD wfidh_cc__qadc01_cmmt LIKE CODE_cmmt
    FIELD wfidh_cm_region LIKE cm_region
    FIELD wfidh_cm_region_cmmt LIKE CODE_cmmt
    */
    .
/* SS - Bill - E */
