def {1} shared temp-table xxddiqvindet_mstr
	field xxddiqvindet_id			like xxvind_id            
	field xxddiqvindet_nbr			like xxvind_nbr           
	field xxddiqvindet_line			like xxvind_Line          
	field xxddiqvindet_sod_qty_ord		like sod_qty_ord         
	field xxddiqvindet_print_vin_date	like xxvind_print_vin_date
	field xxddiqvindet_print_vin_time	as char

	field xxddiqvindet_par_part		like xxvind_part          
	field xxddiqvindet_par_wolot		like xxvind_wolot         
	field xxddiqvindet_par_prod_line	like xxvind_prod_Line         
	field xxddiqvindet_par_down_date	like xxvind_down_date     
	field xxddiqvindet_par_down_time	as char
	field xxddiqvindet_par_pack_date	like xxvind_pack_date     
	field xxddiqvindet_par_pack_time	as char
	field xxddiqvindet_par_ruku_date	like xxvind_ruku_date     
	field xxddiqvindet_par_ruku_time	as char 
	field xxddiqvindet_par_cuku_date	like xxvind_cuku_date     
	field xxddiqvindet_par_cuku_time	as char
							       
	field xxddiqvindet_comp_part		like xxvind_part          
	field xxddiqvindet_comp_wolot		like xxvind_wolot  
	field xxddiqvindet_comp_prod_line	like xxvind_prod_Line         
	field xxddiqvindet_comp_down_date	like xxvind_down_date     
	field xxddiqvindet_comp_down_time	as char  
	field xxddiqvindet_comp_pack_date	like xxvind_pack_date     
	field xxddiqvindet_comp_pack_time	as char
	field xxddiqvindet_comp_ruku_date	like xxvind_ruku_date     
	field xxddiqvindet_comp_ruku_time	as char
	field xxddiqvindet_comp_cuku_date	like xxvind_cuku_date     
	field xxddiqvindet_comp_cuku_time	as char
	
	field xxddiqvindet_chr01	as char  
	field xxddiqvindet_chr02	as char  

	index idx1 xxddiqvindet_nbr xxddiqvindet_line xxddiqvindet_id
	.