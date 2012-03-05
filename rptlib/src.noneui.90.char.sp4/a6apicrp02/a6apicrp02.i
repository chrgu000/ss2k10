/* gpacctp.i - Defines work file to accumulate currency totals.         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 03/01/91   BY: bjb  /*D461*/   */
/* REVISION: 7.3      LAST MODIFIED: 04/15/96   BY: jzw  /*G1T9*/   */
/* REVISION: 7.3      LAST MODIFIED: 08/15/05   BY: Bill Jiang  /*SS - 20050815*/   */

/*G1T9*  define new shared workfile ap_wkfl */
/* SS - 20050815 - B */
/*
/*G1T9*/ define {1} shared workfile ap_wkfl
    field apwk_curr like ap_curr         /* Currency Type                */
    field apwk_for like vo_applied      /* Value in foreign currency    */
    field apwk_base like ap_amt.       /* Value in base currency       */
               */
DEFINE {1} SHARED TEMP-TABLE tta6apicrp02
    field tta6apicrp02_part like prh_part
    field tta6apicrp02_vend like prh_vend
    field tta6apicrp02_nbr like prh_nbr
    field tta6apicrp02_type like prh_type
    field tta6apicrp02_disp_curr AS CHARACTER
    field tta6apicrp02_pur_cost AS DECIMAL
    field tta6apicrp02_inv_cost AS DECIMAL
    field tta6apicrp02_qty AS DECIMAL
    field tta6apicrp02_pur_ext AS DECIMAL
    field tta6apicrp02_inv_ext AS DECIMAL
    field tta6apicrp02_pvar_unit AS DECIMAL
    field tta6apicrp02_pvar_ext AS DECIMAL
    field tta6apicrp02_ref like vph_ref
    .
/* SS - 20050815 - E */
