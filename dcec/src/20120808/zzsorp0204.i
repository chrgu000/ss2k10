/*zzsorp0203.i  create by longbo*/

/*客户零件数*/
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
		chExcelWorkbook:Worksheets(1):Cells(iLine,3) = "客户". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,4) = "客户名". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,5) = "数量". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,6) = "金额". 

		allamt = 0.

		/* consolidate the same part and same customer */
		for each zzwkso break by sopart by socust:
			if first-of(sopart) or first-of(socust) then do:
				subqty = 0.
				subamt = 0.
			end.

			subqty = subqty + invqty.
			subamt = subamt + invqty * soprice.
			
			if last-of(sopart) or last-of(socust) then do:
				assign
					invqty = subqty
					soprice = subamt
					soslspsn = "sys-zz-con"
					sonbr	= "sys-zz-con".
			end.			
		end.

		for each zzwkso where soslspsn = "sys-zz-con"
					and sonbr	= "sys-zz-con"	
					break by sopart by invqty desc:

			iTotalLine = iTotalLine - 1.
			message string("写入EXCEL，剩余 " + string(iTotalLine)).
		
			if first-of(sopart) then
				amt = 0.
			amt = amt + soprice.
			
			find pt_mstr no-lock where pt_part = sopart no-error.
			find cm_mstr no-lock where cm_addr = socust no-error.
			iLine = iLine + 1.
			chExcelWorkbook:Worksheets(1):Cells(iLine,1) = sopart . 
			chExcelWorkbook:Worksheets(1):Cells(iLine,2) = if available pt_mstr then pt_desc2 else "".
			chExcelWorkbook:Worksheets(1):Cells(iLine,3) = socust. 
			chExcelWorkbook:Worksheets(1):Cells(iLine,4) = if available cm_mstr then cm_sort else "" . 
			chExcelWorkbook:Worksheets(1):Cells(iLine,5) = invqty. 
			chExcelWorkbook:Worksheets(1):Cells(iLine,6) = soprice. 
		
		/*
			display			
				sopart @ idh_part
				pt_desc1 when available pt_mstr	                       
				socust @ itemcode
				if available cm_mstr then cm_sort else "" @ itemdesc
				invqty @ idh_qty_inv                        
				soprice @ subamt
			with frame d4 stream-io.
						
			down with frame d4.*/
				
			if last-of(sopart) then do:
				iLine = iLine + 1.
				chExcelWorkbook:Worksheets(1):Cells(iLine,5) = "合计". 
				chExcelWorkbook:Worksheets(1):Cells(iLine,6) = amt. 
				allamt = allamt + amt.
/*				display amt with frame st stream-io.
				down with frame st.*/
			end.
							
		end.
		iLine = iLine + 2.
		chExcelWorkbook:Worksheets(1):Cells(iLine,5) = "总计". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,6) = allamt. 
	end.
