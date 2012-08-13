/*zzsorp02.i  create by longbo*/


	do:
		iLine = 2.
		chExcelWorkbook:Worksheets(1):Cells(iLine,1) = "区域代码". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,2) = "区域描述". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,3) = "零件号". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,4) = "零件名". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,5) = "数量". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,6) = "金额". 
		
		allamt = 0.
		
		for each zzwkso break by soregion by sopart:
			
			iTotalLine = iTotalLine - 1.
			message string("写入EXCEL，剩余 " + string(iTotalLine)).
			
			if first-of(soregion) then
				amt = 0.
			if first-of(sopart) or first-of(soregion) then do:
				subqty = 0.
				subamt = 0.
			end.
			subqty = subqty + invqty.
			subamt = subamt + invqty * soprice.
			amt = amt + invqty * soprice.
		
			if (not last-of(sopart)) and (not last-of(soregion)) then next.
			find pt_mstr no-lock where pt_part = sopart no-error.

			find first code_mstr no-lock
			where code_fldname = "cm_region" and code_value = soregion no-error.

			iLine = iLine + 1.
			chExcelWorkbook:Worksheets(1):Cells(iLine,1) = soregion . 
			chExcelWorkbook:Worksheets(1):Cells(iLine,2) = if available code_mstr then code_cmmt else "". 
			chExcelWorkbook:Worksheets(1):Cells(iLine,3) = sopart. 
			chExcelWorkbook:Worksheets(1):Cells(iLine,4) = if available pt_mstr then pt_desc2 else "". 
			chExcelWorkbook:Worksheets(1):Cells(iLine,5) = subqty. 
			chExcelWorkbook:Worksheets(1):Cells(iLine,6) = subamt. 
			
			/*
			display			
				soregion @ itemcode 	                       
				if available code_mstr then code_cmmt else "" @ itemdesc 	                       
				sopart @ idh_part	                       
				pt_desc1 when available pt_mstr	                       
				subqty @ idh_qty_inv                        
				subamt
			with frame d1 stream-io.
						
			down with frame d1.
			*/	
				
			if last-of(soregion) then do:
				iLine = iLine + 1.
				chExcelWorkbook:Worksheets(1):Cells(iLine,5) = "合计". 
				chExcelWorkbook:Worksheets(1):Cells(iLine,6) = amt. 
				allamt = allamt + amt.
				/*
				display amt with frame st stream-io.
				down with frame st.
				*/
			end.
							
		end.
		iLine = iLine + 2.
		chExcelWorkbook:Worksheets(1):Cells(iLine,5) = "总计". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,6) = allamt. 
		allamt = allamt + amt.

	end.