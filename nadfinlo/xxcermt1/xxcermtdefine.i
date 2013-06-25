define {1} shared variable old_xxcer_req_dpt 	 like xxcer_req_dpt  .
define {1} shared variable old_xxcer_req_user	 like xxcer_req_user .
define {1} shared variable old_xxcer_test_dpt	 like xxcer_test_dpt .
define {1} shared variable old_xxcer_due_date	 like xxcer_due_date .
define {1} shared variable old_xxcer_vend    	 like xxcer_vend     .
define {1} shared variable old_xxcer_part    	 like xxcer_part     .
define {1} shared variable old_xxcer_qty     	 like xxcer_qty      .
define {1} shared variable old_xxcer_usage   	 like xxcer_usage    .
define {1} shared variable old_xxcer_safety  	 like xxcer_safety   .
define {1} shared variable old_xxcer_std1	like xxcer_std1	    .
define {1} shared variable old_xxcer_result1	 like xxcer_result1.	
define {1} shared variable old_xxcer_std2	like xxcer_std2	    .
define {1} shared variable old_xxcer_result2	 like xxcer_result2.	
define {1} shared variable old_xxcer_std3	like xxcer_std3	    .
define {1} shared variable old_xxcer_result3	 like xxcer_result3.	
define {1} shared variable old_xxcer_std4	like xxcer_std4	    .
define {1} shared variable old_xxcer_result4	 like xxcer_result4.	
define {1} shared variable old_xxcer_std5	like xxcer_std5	    .
define {1} shared variable old_xxcer_result5	 like xxcer_result5.	
define {1} shared variable old_xxcer_std6	like xxcer_std6	    .
define {1} shared variable old_xxcer_result6	 like xxcer_result6.	
define {1} shared variable old_xxcer_std7	like xxcer_std7	    .
define {1} shared variable old_xxcer_result7	 like xxcer_result7.	
define {1} shared variable old_xxcer_std8	like xxcer_std8	    .
define {1} shared variable old_xxcer_result8	 like xxcer_result8  .
define {1} shared variable old_xxcer_std_user		 like xxcer_std_user	  .
define {1} shared variable old_xxcer_std_date		 like xxcer_std_date	  .
define {1} shared variable old_xxcer_qc_result		 like xxcer_qc_result	  .
define {1} shared variable old_xxcer_result_user	 like xxcer_result_user  .
define {1} shared variable old_xxcer_result_date	 like xxcer_result_date  .

define {1} shared variable old_xxcer_dec_rmks1 	 like xxcer_dec_rmks1   .
define {1} shared variable old_xxcer_dec_rmks2 	 like xxcer_dec_rmks2   .
define {1} shared variable old_xxcer_dec_rmks3 	 like xxcer_dec_rmks3   .
define {1} shared variable old_xxcer_dec_result	 like xxcer_dec_result  .
define {1} shared variable old_xxcer_pur_qty   	 like xxcer_pur_qty     .
define {1} shared variable old_xxcer_ord_qty   	 like xxcer_ord_qty     .
define {1} shared variable old_xxcer_dec_user  	 like xxcer_dec_user    .
define {1} shared variable old_xxcer_dec_date  	 like xxcer_dec_date    .
define {1} shared variable old_xxcer_test_per  	 like xxcer_test_per    .
define {1} shared variable old_xxcer_test_date 	 like xxcer_test_date   .
define {1} shared variable old_xxcer_qm_per    	 like xxcer_qm_per      .
define {1} shared variable old_xxcer_qm_date   	 like xxcer_qm_date     .
define {1} shared variable old_xxcer_eng_per   	 like xxcer_eng_per     .
define {1} shared variable old_xxcer_eng_date  	 like xxcer_eng_date    .
define {1} shared variable old_xxcer_audit_user	 like xxcer_audit_user  .
define {1} shared variable old_xxcer_audit_date	 like xxcer_audit_date  .
define {1} shared variable old_xxcer_effdate   	 like xxcer_effdate     .
define {1} shared variable old_xxcer_expire    	 like xxcer_expire      .

define {1} shared variable wolot as char label "工单ID" .
define {1} shared variable tt_ad_sort as char .
define {1} shared variable v_name as char .
define {1} shared variable serial as char .
define {1} shared variable file_name as char .	/*文件名*/
define {1} shared variable rtv_rmk as char .	/*结算客户*/
define {1} shared variable invnbr as char .	/*发票号*/
define {1} shared variable invdate as date .	/*发票过账日期*/
define {1} shared variable jstr_type as char .	/*寄售类型*/
define {1} shared variable trtype_name as char .	
define {1} shared variable cimERROR as logi no-undo.
define {1} shared variable choice as logi .
define {1} shared variable printyn as logi .
define {1} shared variable del-yn as logi .
define {1} shared variable checkEffdateError as logi .
define {1} shared variable approve_yn_xxjsd_det as logi .

define {1} shared variable k as integer .
define {1} shared variable i as integer .
define {1} shared variable j as integer .
 define {1} shared variable cust as char .
 define {1} shared variable bill as char .
 define {1} shared variable ship as char .
 define {1} shared variable jsdtrtypecu as char .
 define {1} shared variable jsdtrtyperu as char .
 DEFINE  {1} shared VARIABLE danhao1 as char .
 DEFINE  {1} shared VARIABLE v_user as char .
 DEFINE  {1} shared VARIABLE rmks like wo_rmks .
 DEFINE  {1} shared VARIABLE ostype as char format "x(1)" .
 DEFINE  {1} shared VARIABLE ext_bom as logi .
 DEFINE  {1} shared VARIABLE new_order as logi .
 DEFINE  {1} shared VARIABLE date_create as date .
 DEFINE  {1} shared VARIABLE date_ord as date .
 DEFINE  {1} shared VARIABLE date_shp   as date .
 DEFINE  {1} shared VARIABLE date_rel   as date .
 DEFINE  {1} shared VARIABLE date_due   as date .
 DEFINE  {1} shared VARIABLE slspsn   as char .
 DEFINE  {1} shared VARIABLE sonbr   as char .
 DEFINE  {1} shared VARIABLE slspsn_name   as char .
 DEFINE  {1} shared VARIABLE max_line   like sod_line .
 DEFINE  {1} shared VARIABLE qty   like sod_qty_ord .
 DEFINE  {1} shared VARIABLE dd_tot_qty_iss   like sod_qty_ord .
 DEFINE  {1} shared VARIABLE dd_old_tot_qty_iss   like sod_qty_ord .
 DEFINE  {1} shared VARIABLE banzucode   as char .
 DEFINE  {1} shared VARIABLE banzucode_desc   like code_cmmt .
 DEFINE  {1} shared VARIABLE banci   as char .
 DEFINE  {1} shared VARIABLE diaoduyuan   as char .
 DEFINE  {1} shared VARIABLE diaoduyuan_desc   as char .


define {1} shared variable sel as char .
define {1} shared variable v_ad_name  as char .
define {1} shared variable part  like pt_part  .
define {1} shared variable desc1  like pt_part  .
define {1} shared variable desc2  like pt_part  .
define {1} shared variable op  like wod_op label "工序" .
define {1} shared variable v_ad_line  as char .
define {1} shared variable v_loc  as char .
define {1} shared variable v_vp_vend_part like vp_vend_part .
DEFINE {1} shared temp-table tmp2_mstr
	field tmp2_ii as char format "x(1)"
	field tmp2_danhao like tr_nbr
	field tmp2_wolot like wo_Lot
	field tmp2_part like pt_part
	field tmp2_cust_part as char format "x(20)"
	field tmp2_desc1 like pt_desc1
	field tmp2_desc2 like pt_desc2
	field tmp2_rtv_rmk like code_cmmt
	field tmp2_rmks as char format "x(70)"
	field tmp2_op as char
	field tmp2_op_desc as char
	field tmp2_cc as char	/*工作中心*/
	field tmp2_um like pt_um
	field tmp2_cust like cm_addr
	field tmp2_desc as char format "x(40)"
	field tmp2_site as char 
	
	field tmp2_nbr like sod_nbr
	field tmp2_line	like sod_line	/*---Add by davild 20080303.1*/
	field tmp2_price	like sod_price

	field tmp2_ref	like tr_ref
	field tmp2_loc	like tr_Loc
	field tmp2_lot	like ld_Lot
	field tmp2_count	as inte 
	field tmp2_sod_qty_ship	like ld_qty_oh 
	field tmp2_qty_ord	like ld_qty_oh 
	field tmp2_ld_qty_oh	like ld_qty_oh 
	field tmp2_ok_iss	like ld_qty_oh /*本次要换数量*/
	field tmp2_qty_iss	like ld_qty_oh /*已发数量*/
	field	tmp2_date_rel	as date 
	field	tmp2_date_ord	as date 
	field	tmp2_date_due	as date 
	field	tmp2_logfile	as char format "x(20)" 
	field	tmp2_wo_status	as char format "x(20)" 

	index tmpii tmp2_ii tmp2_line tmp2_lot tmp2_loc
	index tmpid2 tmp2_part tmp2_lot tmp2_loc 
	.
DEFINE {1} shared temp-table tmp_mstr
	field tmp_ii as char format "x(1)"
	field tmp_danhao like tr_nbr
	field tmp_wolot like wo_Lot
	field tmp_part like pt_part
	field tmp_cust_part like pt_part
	field tmp_desc1 like pt_desc1
	field tmp_desc2 like pt_desc2
	field tmp_op as char
	field tmp_op_desc as char
	field tmp_cc as char	/*工作中心*/
	field tmp_um like pt_um
	field tmp_cust like cm_addr
	field tmp_desc as char format "x(40)"
	field tmp_site as char 
	
	field tmp_nbr like sod_nbr
	field tmp_line	like sod_line	/*---Add by davild 20080303.1*/
	field tmp_price	like sod_price
	field tmp_amt	like sod_price
	/*---Add Begin by davild 20080529.1*/
	field tmp_sod_taxable	as char format "x(1)"
	field tmp_sod_tax_in	as char format "x(1)"
	/*---Add End   by davild 20080529.1*/

	field tmp_ref	like tr_ref
	field tmp_loc	like tr_Loc
	field tmp_lot	like ld_Lot
	field tmp_count	as inte 
	field tmp_sod_qty_ship	like ld_qty_oh 
	field tmp_sod_qty_ord	like ld_qty_oh 
	field tmp_qty_ord	like ld_qty_oh 
	field tmp_ld_qty_oh	like ld_qty_oh 
	field tmp_ok_iss	like ld_qty_oh /*本次要换数量*/
	field tmp_qty_iss	like ld_qty_oh /*已发数量*/
	field	tmp_date_rel	as date 
	field	tmp_date_ord	as date 
	field	tmp_date_due	as date 
	field	tmp_logfile	as char format "x(20)" 
	field	tmp_wo_status	as char format "x(20)" 

	index tmpii tmp_ii tmp_line tmp_lot tmp_loc
	index tmp2id2 tmp_part tmp_lot tmp_loc 
	.
/*---Add Begin by davild 20080104.1*/
DEFINE {1} shared temp-table tmp3_mstr
	field tmp3_line like sod_line
	field tmp3_count as inte 
	index tmp3 tmp3_line .
/*---Add End   by davild 20080104.1*/
define {1} shared variable danju as char .
define {1} shared variable loc as char .
define {1} shared variable tt as inte .
define {1} shared variable v_trnbr like  tr_trnbr .
