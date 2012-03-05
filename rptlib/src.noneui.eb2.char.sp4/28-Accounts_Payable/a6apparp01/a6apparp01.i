DEFINE {1} SHARED temp-table tta6apparp01      
      FIELD tta6apparp01_ap_vend LIKE ap_vend 
      FIELD tta6apparp01_name    like ad_name
      FIELD tta6apparp01_vo__qad02 LIKE vo__qad02
      FIELD tta6apparp01_disp_bankno like ad_bk_acct1
      FIELD tta6apparp01_vo_ref  LIKE vo_ref
      FIELD tta6apparp01_vo_invoice LIKE vo_invoice
      FIELD tta6apparp01_vopo        like vpo_po
      FIELD tta6apparp01_ap_bank    LIKE ap_bank
      FIELD tta6apparp01_ap_effdate LIKE ap_effdate 
      FIELD tta6apparp01_vo_due_date LIKE vo_due_date
      FIELD tta6apparp01_vo_disc_date LIKE vo_disc_date
      FIELD tta6apparp01_disp_curr as character
      FIELD tta6apparp01_ap_ckfrm LIKE ap_ckfrm
      FIELD tta6apparp01_gross_amt like vo_amt_chg
      FIELD tta6apparp01_hold as character
      FIELD tta6apparp01_base_disc_chg like vo_amt_chg
      FIELD tta6apparp01_base_amt_chg like vo_amt_chg
      FIELD tta6apparp01_ap_rmk LIKE ap_rmk 
      FIELD  tta6apparp01_flag AS LOGICAL
      index ref tta6apparp01_vo_ref 
      .
