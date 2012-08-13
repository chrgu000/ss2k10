/*zzsorp0203.i  create by longbo*/

/*客户销售*/
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
		chExcelWorkbook:Worksheets(1):Cells(iLine,1) = "客户". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,2) = "客户名". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,3) = "金额". 

		/* consolidate the   same customer */
		for each zzwkso break by socust:
			if first-of(socust) then do:
				subamt = 0.
			end.

			subamt = subamt + invqty * soprice.
			
			if last-of(socust) then do:
				assign
					soprice = subamt
					soslspsn = "sys-zz-con"
					sonbr	= "sys-zz-con".
			end.			
		end.

		amt = 0.
		for each zzwkso where soslspsn = "sys-zz-con"
					and sonbr	= "sys-zz-con"	
					break by soprice desc:

			iTotalLine = iTotalLine - 1.
			message string("写入EXCEL，剩余 " + string(iTotalLine)).
			
			amt = amt + soprice.		
			
			find cm_mstr no-lock where cm_addr = socust no-error.

			iLine = iLine + 1.
			chExcelWorkbook:Worksheets(1):Cells(iLine,1) = socust . 
			chExcelWorkbook:Worksheets(1):Cells(iLine,2) = if available cm_mstr then cm_sort else "" .
			chExcelWorkbook:Worksheets(1):Cells(iLine,3) = soprice. 
		/*	
			display			
				socust @ itemcode
				if available cm_mstr then cm_sort else "" @ itemdesc
				soprice @ subamt
			with frame d5 stream-io.
			down with frame d4.
	*/
		end.
		iLine = iLine + 1.
		chExcelWorkbook:Worksheets(1):Cells(iLine,2) = "总计". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,3) = amt. 
		/*
		display amt with frame st stream-io.
		down with frame st.*/

	end.
