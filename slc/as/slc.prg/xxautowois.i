define {1} shared variable wolot as char label "工单ID" .
define {1} shared variable tt_ad_sort as char .
define {1} shared variable v_name as char .
define {1} shared variable cimERROR as logi .
define {1} shared variable choice as logi .
define {1} shared variable printyn as logi .

define {1} shared variable k as integer .
define {1} shared variable j as integer .
 define {1} shared variable tmp_char as char .
 DEFINE  {1} shared VARIABLE danhao1 as char .
 DEFINE  {1} shared VARIABLE v_user as char .

define {1} shared variable sel as char .
define {1} shared variable v_ad_name  as char .
define {1} shared variable part  like pt_part label "物料号" .
define {1} shared variable desc1  like pt_part label "物料号" .
define {1} shared variable desc2  like pt_part label "物料号" .
define {1} shared variable op  like wod_op label "工序" .
define {1} shared variable v_ad_line  as char .
define {1} shared variable v_loc  as char .
define {1} shared variable v_vp_vend_part like vp_vend_part .
/*---Add Begin by davild 20080104.1*/
DEFINE {1} shared temp-table tmp2_mstr
	field tmp2_line like sod_line
	field tmp2_count as inte 
	index tmp2 tmp2_line .
/*---Add End   by davild 20080104.1*/
DEFINE {1} shared temp-table tmp_mstr
	field tmp_ii as char format "x(1)"
	field tmp_wolot like wo_Lot
	field tmp_part like pt_part
	field tmp_op like wod_op
	field tmp_um like pt_um
	field tmp_cust like cm_addr
	field tmp_desc as char format "x(40)"
	field tmp_site as char 
	field tmp_wonbr like tr_nbr
	field tmp_line	like tr_line
	field tmp_ref	like tr_ref
	field tmp_loc	like tr_Loc
	field tmp_lot	like ld_Lot
	field tmp_count	as inte 
	field tmp_sod_qty_ship	like ld_qty_oh 
	field tmp_sod_qty_ord	like ld_qty_oh 
	field tmp_ld_qty_oh	like ld_qty_oh 
	field tmp_ok_iss	like ld_qty_oh /*本次要换数量*/
	field tmp_qty_iss	like ld_qty_oh /*已发数量*/

	index tmpii  tmp_loc tmp_part tmp_lot
	index tmpid2 tmp_ii tmp_part tmp_lot tmp_loc 
	.
DEFINE {1} shared temp-table ruku_mstr
	field ruku_ii as char format "x(1)"
	field ruku_wolot like wo_Lot
	field ruku_part like pt_part
	field ruku_op like wod_op
	field ruku_um like pt_um
	field ruku_cust like cm_addr
	field ruku_desc as char format "x(40)"
	field ruku_site as char 
	field ruku_wonbr like tr_nbr
	field ruku_line	like tr_line
	field ruku_ref	like tr_ref
	field ruku_loc	like tr_Loc
	field ruku_lot	like ld_Lot
	field ruku_count	as inte 
	field ruku_sod_qty_ship	like ld_qty_oh 
	field ruku_sod_qty_ord	like ld_qty_oh 
	field ruku_ld_qty_oh	like ld_qty_oh 
	field ruku_ok_iss	like ld_qty_oh /*本次要换数量*/
	field ruku_qty_iss	like ld_qty_oh /*已发数量*/
	field ruku_cuku_yn	as logi		/*已发料*/

	index rukuii ruku_lot ruku_loc
	index idxrukuwolotpart ruku_wolot ruku_part 
	index rukuid2 ruku_ii ruku_part ruku_lot ruku_loc 
	.
define {1} shared variable danhao as char .
define {1} shared variable loc as char .
define {1} shared variable v_trnbr like  tr_trnbr .