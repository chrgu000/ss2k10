/*zzsorp0202.i  create by longbo*/

/*销售员*/
/*
	field sonbr		like so_nbr
	field sopart	like sod_part
	field invqty	like idh_qty_inv
	field soprice	like idh_price
	field soregion	like cm_region
	field socust	like so_cust
	field ptline	like pt_prod_line
	field soslspsn	like so_slspsn[1].
*/		
	do:
		iLine = 2.
		chExcelWorkbook:Worksheets(1):Cells(iLine,1) = "销售员代码". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,2) = "销售员". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,3) = "零件号". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,4) = "零件名". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,5) = "数量". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,6) = "金额". 
	
		allamt = 0.
		
		for each zzwkso break by soslspsn by sopart:

			iTotalLine = iTotalLine - 1.
			message string("写入EXCEL，剩余 " + string(iTotalLine)).

			if first-of(soslspsn) then
				amt = 0.
			if first-of(sopart) or first-of(soslspsn) then do:
				subqty = 0.
				subamt = 0.
			end.
			subqty = subqty + invqty.
			subamt = subamt + invqty * soprice.
			amt = amt + invqty * soprice.
			
			if (not last-of(sopart)) and (not last-of(soslspsn)) then next.
			find pt_mstr no-lock where pt_part = sopart no-error.

			find first sp_mstr no-lock where sp_addr = soslspsn no-error.

			iLine = iLine + 1.
			chExcelWorkbook:Worksheets(1):Cells(iLine,1) = soslspsn . 
			chExcelWorkbook:Worksheets(1):Cells(iLine,2) = if available sp_mstr then sp_sort else "". 
			chExcelWorkbook:Worksheets(1):Cells(iLine,3) = sopart. 
			chExcelWorkbook:Worksheets(1):Cells(iLine,4) = if available pt_mstr then pt_desc2 else "". 
			chExcelWorkbook:Worksheets(1):Cells(iLine,5) = subqty. 
			chExcelWorkbook:Worksheets(1):Cells(iLine,6) = subamt. 
/*
			display			
				soslspsn @ itemcode 	                       
				if available sp_mstr then sp_sort else "" @ itemdesc 	                       
				sopart @ idh_part	                       
				pt_desc1 when available pt_mstr	                       
				subqty @ idh_qty_inv                        
				subamt
			with frame d2 stream-io.
						
			down with frame d2.*/
			if last-of(soslspsn) then do:
				iLine = iLine + 1.
				chExcelWorkbook:Worksheets(1):Cells(iLine,5) = "合计". 
				chExcelWorkbook:Worksheets(1):Cells(iLine,6) = amt. 
				allamt = allamt + amt.
			/*	display amt with frame st stream-io.
				down with frame st. */
			end.
							
		end.
		iLine = iLine + 2.
		chExcelWorkbook:Worksheets(1):Cells(iLine,5) = "总计". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,6) = allamt. 
	end.
