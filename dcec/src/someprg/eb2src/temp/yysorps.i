/*zzsorps.i  create by longbo*/

	do:
		allamt = 0.
		for each zzwkso 
		break by {1}:
			message string("写入EXCEL，剩余 " + string(iTotalLine - iLine + 1)).
			iLine = iLine + 1.
			find cm_mstr no-lock where cm_addr = socust no-error.
			find pt_mstr no-lock where pt_part = sopart no-error.
			find in_mstr no-lock where in_part = sopart and in_site = zzsite no-error.
			
			if available pt_mstr then
				find pl_mstr no-lock where pl_prod_line = pt_prod_line no-error. 
		 	find first sp_mstr no-lock where sp_addr = soslspsn no-error.
			
			chExcelWorkbook:Worksheets(1):Cells(iLine,1) = socust. 
			chExcelWorkbook:Worksheets(1):Cells(iLine,2) = if available cm_mstr then cm_sort else "". 
			chExcelWorkbook:Worksheets(1):Cells(iLine,3) = soregion + "-" + socmtype . 
			chExcelWorkbook:Worksheets(1):Cells(iLine,4) = sopart. 
			chExcelWorkbook:Worksheets(1):Cells(iLine,5) = if available pt_mstr then pt_desc2 else "". 
			chExcelWorkbook:Worksheets(1):Cells(iLine,6) = (if available in_mstr then substring(in_user1,1,1) else "")
														 + (if available pl_mstr then pl_desc else ""). 
			chExcelWorkbook:Worksheets(1):Cells(iLine,7) = if available sp_mstr then sp_sort else "". 
			chExcelWorkbook:Worksheets(1):Cells(iLine,8) = sonbr. 
			chExcelWorkbook:Worksheets(1):Cells(iLine,9) = shipdate. 
			chExcelWorkbook:Worksheets(1):Cells(iLine,10) = invqty. 
			chExcelWorkbook:Worksheets(1):Cells(iLine,11) = invqty * soprice. 
			chExcelWorkbook:Worksheets(1):Cells(iLine,12) = invnbr. 
			chExcelWorkbook:Worksheets(1):Cells(iLine,13) = zzsite. 
			allamt = allamt + invqty * soprice. 
		end.
		iLine = iLine + 1.
		chExcelWorkbook:Worksheets(1):Cells(iLine,11) = "总计". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,12) = allamt. 
	end.


/*-------------------------					
					/*
					display 
						so_cust
						cm_sort
						idh_part
						pt_group when available pt_mstr
						pt_prod_line  when available pt_mstr
						so_slspsn[1]
						so_nbr
						idh_cum_date[2]
						idh_qty_inv
						amt
						idh_inv_nbr
						idh_site
					with frame d STREAM-IO.
					down with frame d.
					{zzsorpreg.i}
					*/
				end.
			end.

			for each so_mstr no-lock
			where so_nbr >= nbr and so_nbr <= nbr1
			and so_cust = cmmstr.cm_addr 
			and (so_slspsn[1] = slspsn or slspsn = "") 
			use-index so_cust:
				
				find first sp_mstr no-lock where sp_addr = so_slspsn[1] no-error.

				for each sod_det no-lock
				where sod_nbr = so_nbr
				and sod_part >= part and sod_part <= part1
			    and sod_cum_date[2] >= cumdate and sod_cum_date[2] <= cumdate1
			    and sod_site >= site and sod_site <= site1
			    and sod_qty_inv <> 0  :
					
					find pt_mstr where pt_part = sod_part no-lock no-error.
					find in_mstr no-lock where in_part = sod_part and in_site = "DCEC-SV" no-error.
					if available pt_mstr then
						find first pl_mstr no-lock where pl_prod_line = pt_prod_line no-error.
					amt = sod_qty_inv * sod_price.
	
					iLine = iLine + 1.
					message string("写入EXCEL，当前 " + string(iLine)).
					chExcelWorkbook:Worksheets(1):Cells(iLine,1) = so_cust. 
					chExcelWorkbook:Worksheets(1):Cells(iLine,2) = cmmstr.cm_sort. 
					chExcelWorkbook:Worksheets(1):Cells(iLine,3) = cmmstr.cm_region. 
					chExcelWorkbook:Worksheets(1):Cells(iLine,4) = sod_part. 
					chExcelWorkbook:Worksheets(1):Cells(iLine,5) = if available pt_mstr then pt_desc2 else "". 
					chExcelWorkbook:Worksheets(1):Cells(iLine,6) = (if available in_mstr then substring(in_user1,1,1) else "")
																 + (if available pl_mstr then pl_desc else ""). 
					chExcelWorkbook:Worksheets(1):Cells(iLine,7) = if available sp_mstr then sp_sort else "". 
					chExcelWorkbook:Worksheets(1):Cells(iLine,8) = so_nbr. 
					chExcelWorkbook:Worksheets(1):Cells(iLine,9) = sod_cum_date[2]. 
					chExcelWorkbook:Worksheets(1):Cells(iLine,10) = sod_qty_inv. 
					chExcelWorkbook:Worksheets(1):Cells(iLine,11) = amt. 
					chExcelWorkbook:Worksheets(1):Cells(iLine,12) = so_inv_nbr. 
					chExcelWorkbook:Worksheets(1):Cells(iLine,13) = sod_site. 
					
	/*				display 
						so_cust 
						cm_sort								
						sod_part @ idh_part						
						pt_group when available pt_mstr	 		
						pt_prod_line  when available pt_mstr 	
						so_slspsn[1] 							
						so_nbr 									
						sod_cum_date[2] @ idh_cum_date[2] 		
						sod_qty_inv @ idh_qty_inv 				
						amt 									
						"" @ idh_inv_nbr 						
						sod_site @ idh_site 					
					with frame d STREAM-IO.
					down with frame d.
					{zzsorpreg.i}*/
					
				end.				
			end.	
		
		end.
	end.
	
	***********/
