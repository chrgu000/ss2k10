/* SS - 090531.1 By: Neil Gao */

{mfdtitle.i "090531.1"}

DEFINE new shared VARIABLE loginyn as logical .

view frame dtitle .

DEFINE VARIABLE vin like xxsovd_id .
DEFINE VARIABLE motorVin like xxsovd_id .
DEFINE VARIABLE qty as inte .
DEFINE VARIABLE i as inte .
DEFINE VARIABLE printyn as logi .
DEFINE VARIABLE updatexxsovd_det_ok as logi .
DEFINE VARIABLE wolot as char .
DEFINE VARIABLE site as char .
DEFINE VARIABLE loc as char .
DEFINE VARIABLE sonbr as char .
DEFINE VARIABLE sodline as inte .

DEFINE  new shared VARIABLE lang			LIKE lng_lang .
DEFINE  new shared VARIABLE barcode_domain	LIKE wo_domain .
DEFINE  new shared VARIABLE barcode_part		LIKE wo_part .
DEFINE  new shared VARIABLE barcode_cust		LIKE so_cust .
DEFINE  new shared VARIABLE barcode_wo_nbr	LIKE wo_nbr .
DEFINE  new shared VARIABLE barcode_wo_lot	LIKE wo_lot .
DEFINE  new shared VARIABLE barcode_sod_nbr	LIKE sod_nbr .
DEFINE  new shared VARIABLE barcode_sod_line	LIKE sod_line .
DEFINE  new shared VARIABLE barcode_sod_ord_date	LIKE so_ord_date .
DEFINE  new shared VARIABLE barcode_site		LIKE wo_site .
DEFINE  new shared VARIABLE barcode_wo_vend	LIKE wo_vend .
DEFINE  new shared VARIABLE barcode_vin_id	LIKE xxsovd_id .	/*VIN码*/
DEFINE  new shared VARIABLE barcode_lang		LIKE lng_lang .
DEFINE  new shared VARIABLE barcode_end		as char format "x(30)" .


DEFINE VARIABLE barcode_print_type		as char  .
DEFINE VARIABLE barcode_path		as char  .
DEFINE VARIABLE cust			LIKE so_cust .
DEFINE VARIABLE part			LIKE pt_part .
DEFINE VARIABLE tmp as char extent 16 .
DEFINE VARIABLE checknumber as char .
DEFINE VARIABLE cimError as logi .
DEFINE VARIABLE v_nbr  as char .
DEFINE VARIABLE v_line as char .
DEFINE VARIABLE v_qty_line like wo_qty_ord .
DEFINE VARIABLE msg as char format "x(60)" .
DEFINE VARIABLE huoyundan_no	as char format "x(20)" .	
DEFINE VARIABLE pack_no	as char format "x(20)" .	
DEFINE VARIABLE tot_qty	as int.

define variable usection as char format "x(16)". 

	FORM
		sonbr		 colon 15 label "订 单"
		skip(1)
		huoyundan_no colon 15 label "发运单"
		pack_no      colon 15 label "装箱单"
		"装箱数量:" at 7 
		tot_qty no-label
		vin			 colon 15 label "VIN码"
		skip(2)
		msg at 1 no-label  
	WITH FRAME a SIDE-LABELS WIDTH 80 attr-space.
	/*setFrameLabels(frame a:handle).*/


{wbrp01.i}
lang = "US" .

REPEAT : 	
	vin = "" .
	update 
		sonbr 
	with frame a.
	find first sod_det where sod_domain = global_domain and sod_nbr = sonbr 
	no-lock no-error.
	if not avail sod_det then do:
		msg = "订单项不存在." .
		display msg with frame a .
		sonbr = "" .
		next .
	end.

	/*---Add Begin by davild 20080620.1*/
	update huoyundan_no  with frame a.
	/*20081030检验发运单号是否是正确的 和 是否超过 准备发运数量- begin */
	find first xxspld_det where xxspld_domain = global_domain
		and xxspld_id = huoyundan_no
		and xxspld_nbr = sonbr
/* SS 090531.1 - B */
/*
		and xxspld_line = sodline
*/
/* SS 090531.1 - E */
		no-lock no-error.
	if not avail xxspld_det then do:
		message "没有符合条件的发运单号." view-as alert-box .
		next .
	end.
/* SS 090531.1 - B */
/*
	if xxspld_bc_qty_packing >= xxspld_qty_ship then do:
		if xxspld_bc_qty_packing = xxspld_qty_ship then 
		message "此发运单号已经满了" .		
		else 
		message "已装箱数量:" + string(xxspld_bc_qty_packing) + 
				" 不能超过安排出货数量:" + string(xxspld_qty_ship)
				view-as alert-box .
		next .
	end.
*/
/* SS 090531.1 - E */
	/*20081030检验装箱单号是否是正确的 和 是否超过 准备发运数量- end */
	/*---Add Begin by davild 20081011.1*/
	/*装箱单号*/
	update pack_no with frame a .
	if trim(pack_no) = "" then do:
		message "装箱单号不能为空" view-as alert-box .
		next .
	end.
	/*---Add End   by davild 20081011.1*/
 	repeat:
		
/* SS 090531.1 - B */
/* 计算已装箱数量 */
		tot_qty = 0.
		for each xxvind_det where xxvind_domain = global_domain and xxvind_nbr = sonbr
			and xxvind_zhuangXiang_nbr = pack_no no-lock :
		
			tot_qty = tot_qty + 1.
		
		end.
		disp tot_qty with frame a.
/* SS 090531.1 - B */
		
		UPDATE
			vin 
		WITH FRAME a.

		find first  xxsovd_det where xxsovd_domain = global_domain and xxsovd_id = vin no-error.
		if avail xxsovd_det then do:
			if not(xxsovd_nbr = sonbr ) then do:
 				msg = "错误:VIN码对应的订单项是 " + xxsovd_nbr.
				display msg with frame a .
				next .
			end.
			wolot = xxsovd_wolot .
			find first xxvind_det where xxvind_domain = global_domain and xxvind_id = vin 
				and xxvind_ruku_date <> ? no-lock no-error.
			if not avail xxvind_det  then do:
				message "未做入库扫描,不能做装箱处理!" view-as alert-box .
				next .
			end.
			checknumber = "6" .
			{gprun.i ""xxddcheckvinhist.p""
			"(input vin,
			  input xxsovd_wolot ,
			  input checknumber ,
			  output cimError)"}
			if cimError then do:
				message "VIN码 " + vin + " 已经装箱了,不需要再次装箱." view-as alert-box .
				next .
			end.
			/*20081030检验装箱单号是否是正确的 和 是否超过 准备发运数量- begin */
			find first xxspld_det where xxspld_domain = global_domain
				and xxspld_id = huoyundan_no
				and xxspld_nbr = xxvind_nbr
				and xxspld_line = xxvind_line
				no-lock no-error.
			if not avail xxspld_det then do:
				message "没有符合条件的装箱单号." view-as alert-box .
				next .
			end.
			if xxspld_bc_qty_packing >= xxspld_qty_ship then do:
				message "已装箱数量:" + string(xxspld_bc_qty_packing) + 
				        " 不能超过安排出货数量:" + string(xxspld_qty_ship)
						view-as alert-box .
				next .
			end.
			/*20081030检验装箱单号是否是正确的 和 是否超过 准备发运数量- end */
			/*下线装箱成品如机组，单机动力*/
			site = "10000" .
			loc  = pack_no /*装箱单号*/ .
			motorvin  = huoyundan_no /*发运单号*/ .
			cimError = no .
			do transaction:
				
				if cimError = no then do:
					message "VIN码 " + string(vin) + " 装箱成功." .
					msg = "VIN码 " + string(vin) + " 装箱成功." .
					display msg with frame a .
					
					/*自动更新历史记录xxvind_det和汇总记录xxvin_mstr*/
					/*检查是否已下线
						checknumber = 1=上线
						checknumber = 2=下线
						checknumber = 3=检测
						checknumber = 4=包装
						checknumber = 5=装箱
						checknumber = 6=装箱	loc 此时要为 装箱单号
						checknumber = 7=出库
					*/
					checknumber = "6" .
					/*更新装箱表 xxspld_det--BEGIN*/
					pause 0 .
					{gprun.i ""xxddupdatexxspld.p""
					"(input checknumber,
					  input site,
					  input huoyundan_no,
					  input xxvind_nbr,
					  input xxvind_line)"}
					/*更新装箱表 xxspld_det--end*/
					pause 0 .
					/*motorvin 为 发运单号 loc 为 装箱单号 */
					{gprun.i ""xxddupdatevinhist.p""
					 "(input vin,
					   input motorvin , 
					   input xxsovd_wolot ,
					   input loc,
					   input checknumber ,
					   output cimError)"}
					if cimError then undo,next .
				end.
				else do:
					message "装箱动作失败，请联系管理员." view-as alert-box .
					msg = "装箱动作失败，请联系管理员." .
					display msg with frame a .
					undo,next .
				end.
			end.	/*do transaction*/
		end.
		else do:
			message "VIN码不存在!" view-as alert-box .
		end.
	end.
	leave .
	/*{mfreset.i}
	{mfgrptrm.i}*/
END.	/*{wbrp01.i} REPEAT*/

{wbrp04.i &frame-spec = a}
