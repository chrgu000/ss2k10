/*zzsorp0206.i  create by longbo*/

/*零件*/
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
		chExcelWorkbook:Worksheets(1):Cells(iLine,1) = "零件号". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,2) = "零件名". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,3) = "数量". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,4) = "金额". 

		amt = 0.
		for each zzwkso break by sopart:

			iTotalLine = iTotalLine - 1.
			message string("写入EXCEL，剩余 " + string(iTotalLine)).
			
			if first-of(sopart) then do:
				subqty = 0.
				subamt = 0.
			end.
			
			subqty = subqty + invqty.
			subamt = subamt + invqty * soprice.
			amt = amt + invqty * soprice.
			
			if (not last-of(sopart)) then next.
			
			find pt_mstr no-lock where pt_part = sopart no-error.
			iLine = iLine + 1.
			chExcelWorkbook:Worksheets(1):Cells(iLine,1) = sopart . 
			chExcelWorkbook:Worksheets(1):Cells(iLine,2) = if available pt_mstr then pt_desc2 else "".
			chExcelWorkbook:Worksheets(1):Cells(iLine,3) = subqty. 
			chExcelWorkbook:Worksheets(1):Cells(iLine,4) = subamt. 

/*
			display			
				sopart @ idh_part	                       
				pt_desc1 when available pt_mstr	                       
				subqty @ idh_qty_inv                        
				subamt
			with frame d6 stream-io.
			down with frame d6.
*/							
		end.
		iLine = iLine + 1.
		chExcelWorkbook:Worksheets(1):Cells(iLine,3) = "总计". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,4) = amt. 
/*		display amt with frame st stream-io.
		down with frame st. */
	end.
