/* Creation: eB21SP3 Chui Last Modified: 20080107 By: Davild Xu *ss-20071228.1*/
DEFINE shared var global_domain like pt_domain .

DEFINE input  parameter vin like xxsovd_id .	

{xxddiqvindet.i " "}	/*定义共享表xxddiqvindet_mstr*/

pause 0 .
find first xxddiqvindet_mstr where xxddiqvindet_id = vin no-error.
if not avail xxddiqvindet_mstr then do:
	for each xxvind_det where xxvind_domain = global_domain 
			and xxvind_id = vin no-lock :
		find first xxddiqvindet_mstr where xxddiqvindet_id = xxvind_id no-error.
		if not avail xxddiqvindet_mstr then do:
			create xxddiqvindet_mstr .
			assign	xxddiqvindet_id			= xxvind_id
				xxddiqvindet_nbr		= xxvind_nbr
				xxddiqvindet_line		= xxvind_Line
				xxddiqvindet_sod_qty_ord	= xxvind_dec01
				xxddiqvindet_print_vin_date	= xxvind_print_vin_date
				xxddiqvindet_print_vin_time	= if xxvind_print_vin_time <> 0 then string(xxvind_print_vin_time,"HH:MM:SS") else ""
				.

		end.
			if xxddiqvindet_print_vin_date > xxvind_print_vin_date then
			assign	xxddiqvindet_print_vin_date	= xxvind_print_vin_date
				xxddiqvindet_print_vin_time	= if xxvind_print_vin_time <> 0 then string(xxvind_print_vin_time,"HH:MM:SS") else "" 
				.
		if xxvind_log01 = yes then do:	/*如果是销售成品则挂父件东西*/
			assign	xxddiqvindet_par_part		= xxvind_part
				xxddiqvindet_par_wolot		= xxvind_wolot
				xxddiqvindet_par_prod_line	= xxvind_prod_Line
				xxddiqvindet_par_down_date	= xxvind_down_date 
				xxddiqvindet_par_down_time	= if xxvind_down_time <> 0 then string(xxvind_down_time,"HH:MM:SS") else ""
				xxddiqvindet_par_pack_date	= xxvind_pack_date
				xxddiqvindet_par_pack_time	= if xxvind_pack_time <> 0 then string(xxvind_pack_time,"HH:MM:SS") else ""
				xxddiqvindet_par_ruku_date	= xxvind_ruku_date
				xxddiqvindet_par_ruku_time	= if xxvind_ruku_time <> 0 then string(xxvind_ruku_time,"HH:MM:SS") else ""
				xxddiqvindet_par_cuku_date	= xxvind_cuku_date
				xxddiqvindet_par_cuku_time	= if xxvind_cuku_time <> 0 then string(xxvind_cuku_time,"HH:MM:SS") else ""
				.
		end.
		else do:
			assign	xxddiqvindet_comp_part		= xxvind_part                                                               
				xxddiqvindet_comp_wolot		= xxvind_wolot                                                              
				xxddiqvindet_comp_prod_line	= xxvind_prod_Line                                                          
				xxddiqvindet_comp_down_date	= xxvind_down_date                                                          
				xxddiqvindet_comp_down_time	= if xxvind_down_time <> 0 then string(xxvind_down_time,"HH:MM:SS") else "" 
				xxddiqvindet_comp_pack_date	= xxvind_pack_date                                                          
				xxddiqvindet_comp_pack_time	= if xxvind_pack_time <> 0 then string(xxvind_pack_time,"HH:MM:SS") else "" 
				xxddiqvindet_comp_ruku_date	= xxvind_ruku_date                                                          
				xxddiqvindet_comp_ruku_time	= if xxvind_ruku_time <> 0 then string(xxvind_ruku_time,"HH:MM:SS") else "" 
				xxddiqvindet_comp_cuku_date	= xxvind_cuku_date                                                          
				xxddiqvindet_comp_cuku_time	= if xxvind_cuku_time <> 0 then string(xxvind_cuku_time,"HH:MM:SS") else "" 
				.
		end.
	end.
end.