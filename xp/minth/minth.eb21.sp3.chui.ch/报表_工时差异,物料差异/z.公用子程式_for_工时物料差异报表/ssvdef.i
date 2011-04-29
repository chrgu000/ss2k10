
DEFINE {1} SHARED TEMP-TABLE tt1
    FIELD tt1_site      LIKE si_site  
    FIELD tt1_lot       LIKE wo_lot
    FIELD tt1_peri        AS  CHAR FORMAT '9999/99' 
    FIELD tt1_cc        LIKE  cc_ctr
    FIELD tt1_pare      LIKE  pt_part
    FIELD tt1_qty_comp  LIKE  wo_qty_comp
    FIELD tt1_comp      LIKE  pt_part   
    FIELD tt1_qty_iss   LIKE  wod_qty_iss
    FIELD tt1_price     LIKE  tr_price  FORMAT '>>>>.<<'
    FIELD tt1_type      LIKE  tr_type 
    FIELD tt1_qty_per   LIKE  ps_qty_per
    FIELD tt1_setup_per_time      like wr_run
    FIELD tt1_setup_std_hrs       like wr_act_run 
    FIELD tt1_setup_act_hrs       like wr_act_run 
    FIELD tt1_setup_lbr_rte       like glt_amt
    FIELD tt1_setup_burden_rte    like glt_amt
    FIELD tt1_run_per_time        like wr_run
    FIELD tt1_run_std_hrs         like wr_act_run 
    FIELD tt1_run_act_hrs         like wr_act_run 
    FIELD tt1_run_lbr_rte         like glt_amt
    FIELD tt1_run_burden_rte like glt_amt   
   
    INDEX tt1all tt1_site  tt1_peri tt1_pare  tt1_lot tt1_cc  tt1_comp
    .
