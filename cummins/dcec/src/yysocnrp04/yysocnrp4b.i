define {1} shared variable v_cncu_batch        like    cncu_batch.
define {1} shared variable v_cncu_eff_date     like    cncu_eff_date.
define {1} shared variable v_cncu_shipto       like    cncu_shipto.
define {1} shared variable v_shipto_name       like    ad_name.
define {1} shared variable v_cncu_cust         like    cncu_cust.
define {1} shared variable v_cust_name         like    ad_name.

define {1} shared temp-table tmp_t
           fields t_cncu_batch           Like cncu_batch
           fields t_cncu_eff_date        Like cncu_eff_date
           fields t_cncu_shipto          Like cncu_shipto
           fields t_shipto_name          Like ad_name
           fields t_cncu_cust            Like cncu_cust
           fields t_cust_name            Like ad_name
           fields t_cncu_part            like cncu_part
           fields t_cncu_lotser          like cncu_lotser
           fields t_cncu_so_nbr          like cncu_so_nbr
           fields t_cncu_usage_qty       like cncu_usage_qty
           fields t_cncu_usage_um        like cncu_usage_um
           fields t_cncu_cum_qty         like cncu_cum_qty
           fields t_sod_um               like sod_um
           fields t_sod_list_pr          like sod_list_pr
           fields t_sod_tax_in           like sod_tax_in
           fields t_sod_type             like sod_type
           fields t_cncu_cust_usage_date like cncu_cust_usage_date
           fields t_cncu_selfbill_auth   like cncu_selfbill_auth
           fields t_cncu_ref             like cncu_ref
           fields t_cncu_sod_line        like cncu_sod_line
           fields t_cncu_cust_usage_ref  like cncu_cust_usage_ref
           fields t_pc_price             like sod_list_pr
           .
