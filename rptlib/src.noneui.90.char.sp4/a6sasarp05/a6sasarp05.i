/* gpacctp.i - Defines work file to accumulate currency totals.         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 03/01/91   BY: bjb  /*D461*/   */
/* REVISION: 7.3      LAST MODIFIED: 04/15/96   BY: jzw  /*G1T9*/   */

/*G1T9*  define new shared workfile ap_wkfl */
/* SS - 20050801 - B */
/*
/*G1T9*/ define {1} shared workfile ap_wkfl
    field apwk_curr like ap_curr         /* Currency Type                */
    field apwk_for like vo_applied      /* Value in foreign currency    */
    field apwk_base like ap_amt.       /* Value in base currency       */
               */
DEFINE {1} SHARED TEMP-TABLE ttcph
    FIELD ttcph_pl LIKE cph_pl
    FIELD ttcph_part LIKE cph_part
    FIELD ttcph_um LIKE pt_um
    FIELD ttcph_desc1 LIKE pt_desc1
    FIELD ttcph_desc2 LIKE pt_desc2
    FIELD ttcph_sales12 AS DECIMAL
    FIELD ttcph_margin12 AS DECIMAL
    FIELD ttcph_qty12 AS DECIMAL
    FIELD ttcph_tot_sales AS DECIMAL
    FIELD ttcph_tot_margin AS DECIMAL
    FIELD ttcph_tot_qty AS DECIMAL
    .
/* SS - 20050801 - E */
