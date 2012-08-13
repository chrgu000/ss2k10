/*zzsorp0203.i  create by longbo*/

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
		chExcelWorkbook:Worksheets(1):Cells(iLine,1) = "产品类". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,2) = "描述". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,3) = "零件号". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,4) = "零件名". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,5) = "数量". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,6) = "金额". 

		allamt = 0.
	
		for each zzwkso
		,
		each in_mstr no-lock 
		where in_part = sopart
		and in_site = "DCEC-SV"
		break by ptline by substring(in_user1,1,1) by sopart 
		:
			iTotalLine = iTotalLine - 1.
			message string("写入EXCEL，剩余 " + string(iTotalLine)).

			if first-of(ptline) 
			or first-of(substring(in_user1,1,1))
			then
				amt = 0.
			if first-of(sopart) or first-of(ptline) 
			or first-of(substring(in_user1,1,1))
			then do:
				subqty = 0.
				subamt = 0.
			end.
			subqty = subqty + invqty.
			subamt = subamt + invqty * soprice.
			amt = amt + invqty * soprice.
			
			if (not last-of(sopart)) and (not last-of(ptline))
				and (not last-of(substring(in_user1,1,1)))
			then next.
			
			find pt_mstr no-lock where pt_part = sopart no-error.
			find first pl_mstr no-lock where pl_prod_line = ptline no-error.

			iLine = iLine + 1.
			chExcelWorkbook:Worksheets(1):Cells(iLine,1) = ptline . 
			chExcelWorkbook:Worksheets(1):Cells(iLine,2) = string(substring(in_user1,1,1) + (if available pl_mstr then pl_desc else "")). 
			chExcelWorkbook:Worksheets(1):Cells(iLine,3) = sopart. 
			chExcelWorkbook:Worksheets(1):Cells(iLine,4) = if available pt_mstr then pt_desc2 else "". 
			chExcelWorkbook:Worksheets(1):Cells(iLine,5) = subqty. 
			chExcelWorkbook:Worksheets(1):Cells(iLine,6) = subamt. 

		/*
			display			
				ptline @ itemcode 	                       
				if available pl_mstr then pl_desc else "" @ itemdesc 	                       
				sopart @ idh_part	                       
				pt_desc1 when available pt_mstr	                       
				subqty @ idh_qty_inv                        
				subamt
			with frame d3 stream-io.
						
			down with frame d3. */
				
			if last-of(ptline) 
			or last-of(substring(in_user1,1,1))
			then do:
				iLine = iLine + 1.
				chExcelWorkbook:Worksheets(1):Cells(iLine,5) = "合计". 
				chExcelWorkbook:Worksheets(1):Cells(iLine,6) = amt. 
				allamt = allamt + amt.
/*				display amt with frame st stream-io.
				down with frame st. */
			end.
							
		end.
		iLine = iLine + 2.
		chExcelWorkbook:Worksheets(1):Cells(iLine,5) = "总计". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,6) = allamt. 

	end.