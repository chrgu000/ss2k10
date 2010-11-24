/* Creation: eB21SP3 Chui Last Modified: 20080107 By: Davild Xu *ss-20071228.1*/
 {a6mfdtitle.i "SS"}
/*检查是否已下线
	checknumber = 0  上线检查或新增
	checknumber = 1  下线检查或新增
	checknumber = 2  包装检查或新增
	checknumber = 3  入库(成品或半成品)检查或新增
	checknumber = 4  出库或发料(半成品,如机组动力)检查或新增
	*/
DEFINE input  parameter vin like xxsovd_id .
DEFINE VARIABLE barcode_userid as char .

pause 0 .
find first xxvind_det where xxvind_domain = global_domain 
		and xxvind_id = vin no-error.
if avail xxvind_det then do :
	assign
		xxvind_print_vin_date	= today 
		xxvind_print_vin_time	= time  
	.
	/* SS - 100609.1 - B */
	find first xxsovd_det where xxsovd_domain = global_domain and xxsovd_id = vin no-lock no-error.
	if available(xxsovd_det) then do:
	    find first wo_mstr where wo_domain = global_domain and wo_lot = xxsovd_wolot no-lock no-error.
    	assign
    	    xxvind_wonbr	= xxsovd_wonbr
    		xxvind_wolot	= xxsovd_wolot
    		xxvind_prod_line = if avail wo_mstr then wo_vend else ""
    		.
    end.
	/* SS - 100609.1 - E */
end .
else do:
	{gprun.i ""xxddgetbarcodeuser.p"" 
	"(output barcode_userid)"} 
	for each xxsovd_det where xxsovd_domain = global_domain and xxsovd_id = vin no-lock :
		find first wo_mstr where wo_domain = global_domain and wo_lot = xxsovd_wolot no-lock no-error.
		create  xxvind_det .
		assign 
			xxvind_domain	= global_domain
			xxvind_wonbr	= xxsovd_wonbr
			xxvind_wolot	= xxsovd_wolot
			xxvind_nbr	= xxsovd_nbr
			xxvind_line	= xxsovd_line
			xxvind_part	= xxsovd_part
			xxvind_prod_line = if avail wo_mstr then wo_vend else ""
			xxvind_id	= xxsovd_id
			xxvind_lot	= xxsovd_id1
			xxvind_print_vin_date	= today
			xxvind_print_vin_time	= time
			xxvind_print_Userid	= barcode_userid 

			.
			/*---Add Begin by davild 20080120.1*/
			/*有SO的料相同的做一个标识--xxvind_log01=YES
			  同时把SO数量存入xxvind_dec01*/
			if xxvind_dec01 = 0 then do:
				find first sod_det where sod_domain = global_domain and sod_nbr = xxvind_nbr
					and sod_line = xxvind_line 
					no-lock no-error .
				if avail sod_det then do:
					if  sod_part = xxvind_part then do:
						assign xxvind_log01 = yes .
					end.
						assign xxvind_dec01 = sod_qty_ord .
				end.
			end.
			/*---Add End   by davild 20080120.1*/
		find first xxvin_mstr where xxvin_domain	= global_domain
					 and xxvin_wolot	= xxsovd_wolot
					 and xxvin_part	= xxsovd_part 
					 no-lock no-error.
		if not avail xxvin_mstr then do:
			create  xxvin_mstr .
			assign  
				xxvin_domain	= global_domain 
				xxvin_wonbr	= xxsovd_wonbr  
				xxvin_wolot	= xxsovd_wolot  
				xxvin_nbr	= xxsovd_nbr    
				xxvin_line	= xxsovd_line   
				xxvin_part	= xxsovd_part 
				xxvin_prod_line = if avail wo_mstr then wo_vend else ""				
				. 
		end.
	end.
end.
