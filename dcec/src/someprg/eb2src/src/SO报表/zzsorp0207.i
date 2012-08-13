/*zzsorp0206.i  create by longbo*/

/*���*/
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
		chExcelWorkbook:Worksheets(1):Cells(iLine,1) = "�����". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,2) = "�����". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,3) = "����". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,4) = "���". 

		amt = 0.
		for each zzwkso break by sopart:
			if first-of(sopart) then do:
				subqty = 0.
				subamt = 0.
			end.
			
			subqty = subqty + invqty.
			subamt = subamt + invqty * soprice.
			amt = amt + invqty * soprice.
			
			if (not last-of(sopart)) then next.

			assign
				soprice = subamt
				invqty = subqty
				soslspsn = "sys-zz-con"
				sonbr	= "sys-zz-con".
		end.
		
		for each zzwkso where soslspsn = "sys-zz-con"
				and sonbr	= "sys-zz-con" break by soprice desc:
						
			iTotalLine = iTotalLine - 1.
			message string("д��EXCEL��ʣ�� " + string(iTotalLine)).
			
			find pt_mstr no-lock where pt_part = sopart no-error.

			iLine = iLine + 1.
			chExcelWorkbook:Worksheets(1):Cells(iLine,1) = sopart . 
			chExcelWorkbook:Worksheets(1):Cells(iLine,2) = if available pt_mstr then pt_desc2 else "".
			chExcelWorkbook:Worksheets(1):Cells(iLine,3) = invqty. 
			chExcelWorkbook:Worksheets(1):Cells(iLine,4) = soprice. 
/*			display			
				sopart @ idh_part	                       
				pt_desc1 when available pt_mstr	                       
				invqty @ idh_qty_inv                        
				soprice @ subamt
			with frame d7 stream-io.
			down with frame d7.*/
		end.							
		iLine = iLine + 1.
		chExcelWorkbook:Worksheets(1):Cells(iLine,3) = "�ܼ�". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,4) = amt. 
/*
		display amt with frame st stream-io.
		down with frame st.*/
	end.
