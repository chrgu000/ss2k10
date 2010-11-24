/* SS - 090604.1 By: Neil Gao */

{mfdtitle.i}

define var vin  like xxvind_id.
define var sonbr like so_nbr.
define var soline like sod_line.
define var wolot like wo_lot.
define var sonbr1 like so_nbr.
define var soline1 like sod_line.
define var wolot1 like wo_lot.
define buffer bf1 for xxvin_mstr.

form
	vin 		colon 25 label "VIN码" 
	wolot 	colon 25 label "工单ID"
	sonbr 	colon 25 label "销售订单"
	soline 	colon 25 label "项"
	skip (1)
	wolot1 	colon 25 label "工单ID"
	sonbr1	colon 25 label "销售订单"
	soline1	colon 25 label "项"
with frame a side-labels width 80 attr-space.

/*
setFrameLabels(frame a:handle).
*/
mainloop:
repeat:
	
	update vin with frame a.
	
	find first xxvind_det where xxvind_domain = global_domain and xxvind_id = vin no-lock no-error.
	if not avail xxvind_det then do:
		message "错误: VIN码不存在".
		next.
	end.
	
	wolot =  xxvind_wolot.
	sonbr = xxvind_nbr.
	soline = xxvind_line.
	wolot1 = "".
	sonbr1 = "".
	soline1 = 0.
	disp wolot sonbr soline wolot1 sonbr1 soline1 with frame a.
	
	find first xxvin_mstr where xxvin_domain = global_domain and xxvin_nbr = sonbr
		and xxvin_line = soline and xxvin_wolot = wolot no-error.
	if not avail xxvin_mstr then do:
		message "错误: xxvin_mstr 记录不存在".
		next.
	end.
	
	loop1:
	do on error undo,retry:
		
		update wolot1 with frame a. 
		
		if wolot1 = wolot then do:
			message "工单ID不能相同".
			next.
		end.
		
		find first wo_mstr where wo_domain = global_domain and wo_lot = wolot1 no-lock no-error.
		if not avail wo_mstr then do:
			message "工单ID不存在".
			next.
		end.
		sonbr1 = wo_so_Job.
		soline1 = int(wo__dec02).
		find first sod_det where sod_domain = global_domain and sod_nbr = sonbr1 and sod_line = soline1 no-lock no-error.
		if not avail sod_det then do:
			message "工单ID没有对应的销售订单".
			next.
		end.
		
		find first xxsovd_det where xxsovd_domain = global_domain and xxsovd_nbr = sonbr 
			and xxsovd_line = soline and xxsovd_wolot = wolot no-error.
		if not avail xxsovd_det then do:
			message "xxsovd_det 记录不存在".
			next.
		end.
		else do:
			xxsovd_nbr = sonbr1.
			xxsovd_line = soline1. 
			xxsovd_wolot = wolot1.
			xxsovd_wonbr = wo_nbr.
			xxsovd_part  = wo_part.
		end.
		
		find first xxvind_det where xxvind_domain = global_domain and xxvind_nbr = sonbr 
			and xxvind_line = soline and xxvind_wolot = wolot no-error.
		if not avail xxvind_det then	do:
			message "错误: xxvind_det 不存在".
			undo,retry.
		end.
		else do:
			xxvind_nbr = sonbr1.
			xxvind_line = soline1.
			xxvind_wolot = wolot1.
			xxvind_wonbr = wo_nbr.
			xxvind_part = wo_part.
			disp sonbr1 soline1 with frame a.
		end.
		
		find first bf1 where bf1.xxvin_domain = global_domain and bf1.xxvin_nbr = sonbr1
			and bf1.xxvin_line = soline1 and bf1.xxvin_wolot = wolot1 no-error.
		if not avail bf1 then do:
			create bf1.
			assign bf1.xxvin_domain = global_domain
						 bf1.xxvin_wolot  = wolot1
						 bf1.xxvin_wonbr  = wo_nbr
						 bf1.xxvin_nbr    = sonbr1
						 bf1.xxvin_line   = soline1
						 bf1.xxvin_part   = wo_part
						 bf1.xxvin_chr01  = xxvin_mstr.xxvin_chr01
						 bf1.xxvin_prod_line = xxvin_mstr.xxvin_prod_line
						 .
			/* 上线*/
			if xxvind_up_date <> ? then do:
				bf1.xxvin_qty_up = bf1.xxvin_qty_up + 1 .
				xxvin_mstr.xxvin_qty_up = xxvin_mstr.xxvin_qty_up - 1.
			end.
			/* 下线*/
			if xxvind_down_date <> ? then do:
				bf1.xxvin_qty_down = bf1.xxvin_qty_down + 1 .
				xxvin_mstr.xxvin_qty_down = xxvin_mstr.xxvin_qty_down - 1.
			end.
			/* 检测 */
			if xxvind_check_date <> ? then do:
				bf1.xxvin_qty_check = bf1.xxvin_qty_check + 1 .
				xxvin_mstr.xxvin_qty_check = xxvin_mstr.xxvin_qty_check - 1.
			end.
			/* 包装 */
			if xxvind_pack_date <> ? then do:
				bf1.xxvin_qty_pack = bf1.xxvin_qty_check + 1 .
				xxvin_mstr.xxvin_qty_check = xxvin_mstr.xxvin_qty_check - 1.
			end.
			/* 入库 */
			if xxvind_ruku_date <> ? then do:
				bf1.xxvin_qty_ruku = bf1.xxvin_qty_ruku + 1 .
				xxvin_mstr.xxvin_qty_ruku = xxvin_mstr.xxvin_qty_ruku - 1.
			end.
			/* 装箱 */
			if xxvind_zhuangxiang_date <> ? then do:
				bf1.xxvin_qty_zhuangxiang = bf1.xxvin_qty_zhuangxiang + 1 .
				xxvin_mstr.xxvin_qty_zhuangxiang = xxvin_mstr.xxvin_qty_zhuangxiang - 1.
			end.
			/* 出库 */
			if xxvind_cuku_date <> ? then do:
				bf1.xxvin_qty_cuku = bf1.xxvin_qty_cuku + 1 .
				xxvin_mstr.xxvin_qty_cuku = xxvin_mstr.xxvin_qty_cuku - 1.
			end.
			
		end.
		
	end. /* loop1 */
	
	
end. /* mainloop */
	