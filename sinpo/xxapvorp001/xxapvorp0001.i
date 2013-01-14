 
DEFINE {1} SHARED TEMP-TABLE ttxxapvorp0001
   field ttxxapvorp0001_vo_ref like vo_ref
   field ttxxapvorp0001_ap_date like ap_date
   field ttxxapvorp0001_vd_remit like vd_remit
   field ttxxapvorp0001_ap_curr like ap_curr
   field ttxxapvorp0001_disp_curr as   character 
   field ttxxapvorp0001_ap_amt like ap_amt
   field ttxxapvorp0001_vopo as   character 
   field ttxxapvorp0001_ap_effdate like ap_effdate
   field ttxxapvorp0001_vo_ship like vo_ship
   field ttxxapvorp0001_curr_disp_line1 as character 
   field ttxxapvorp0001_ap_acct like ap_acct
   field ttxxapvorp0001_ap_sub like ap_sub
   field ttxxapvorp0001_ap_cc like ap_cc
   field ttxxapvorp0001_curr_disp_line2 as character 
   field ttxxapvorp0001_ap_vend like ap_vend
   field ttxxapvorp0001_vo_due_date like vo_due_date
   field ttxxapvorp0001_vo_invoice like vo_invoice
   field ttxxapvorp0001_ap_bank like ap_bank
   field ttxxapvorp0001_vo_ndisc_amt like vo_ndisc_amt
   field ttxxapvorp0001_name like ad_name
   field ttxxapvorp0001_vo_disc_date like vo_disc_date
   field ttxxapvorp0001_ap_entity like ap_entity
   field ttxxapvorp0001_vo_type like vo_type
   field ttxxapvorp0001_vo_applied like vo_applied
   field ttxxapvorp0001_flag as   character 
   field ttxxapvorp0001_ap_rmk like ap_rmk 
   field ttxxapvorp0001_ap_ckfrm like ap_ckfrm
   field ttxxapvorp0001_vo_confirmed like vo_confirmed
   field ttxxapvorp0001_vo_conf_by like vo_conf_by
   field ttxxapvorp0001_vo_hold_amt like vo_hold_amt
   field ttxxapvorp0001_vo_is_ers like vo_is_ers
   field ttxxapvorp0001_remit_label as character 
   field ttxxapvorp0001_remit_name like ad_name
   field ttxxapvorp0001_ap_batch like ap_batch
   field ttxxapvorp0001_vod_ln like vod_ln
   field ttxxapvorp0001_vod_acc like vod_acct
   field ttxxapvorp0001_vod_sub like vod_sub
   field ttxxapvorp0001_vod_cc like vod_cc
   field ttxxapvorp0001_vod_project like vod_project
   field ttxxapvorp0001_vod_entity like vod_entity
   field ttxxapvorp0001_vod_amt like vod_amt
   field ttxxapvorp0001_vod_desc like vod_desc
    
   field ttxxapvorp0001_prh_receiver like prh_receiver
   field ttxxapvorp0001_prh_line like prh_line
   field ttxxapvorp0001_prh_nbr like prh_nbr
   field ttxxapvorp0001_prh_part like prh_part
   field ttxxapvorp0001_prh_um like prh_um
   field ttxxapvorp0001_prh_type like prh_type
   field ttxxapvorp0001_prh_rcvd like prh_rcvd
   field ttxxapvorp0001_inv_qty like vph_inv_qty
   field ttxxapvorp0001_pur_amt AS DECIMAL
   field ttxxapvorp0001_prh_curr like prh_curr
   field ttxxapvorp0001_inv_amt AS DECIMAL
   field ttxxapvorp0001_vo_curr like vo_curr
   field ttxxapvorp0001_pvod_trans_qty as decimal /* like pvod_trans_qty */
   INDEX ttxxapvorp0001_index1 IS UNIQUE 
   ttxxapvorp0001_vo_ref
   ttxxapvorp0001_prh_nbr
   ttxxapvorp0001_prh_receiver 
   ttxxapvorp0001_prh_line
   .
/* SS - 100705.1 - E */
