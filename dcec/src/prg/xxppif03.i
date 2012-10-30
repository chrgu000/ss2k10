		/* PROCESS PDID */
		for each xxppif_log exclusive-lock where xxppif_tr_id >= trid_begin and
		(xxppif_tr_code = "PDID"):
			run SET_TRAN_DATE(6).
			if xxppif_tr_date = ? then do:
				xxppif_err = 2.
				xxppif_msg = "Transaction Date Format YYMMDD Error.".
				next.
			end.
/*			xxppif_part = trim(substring(xxppif_content,12,16)).  */
			xxppif_part = trim(substring(xxppif_content,12,12)).
            find first pt_mstr no-lock where pt_part = xxppif_part no-error.
			if not available pt_mstr then do:
				xxppif_err = 2.
				xxppif_msg = "Item not in pt_mstr:" + xxppif_part.
				next.
			end.
			
			
			put stream batchdata "~"" xxppif_part at 1 "~"" skip "yes".

	/*
			INPUT CLOSE.
			INPUT from value(filepath + "\" + "ppif.tmp").
			output to value(filepath + "\" + "ppif.out").
			PAUSE 0 BEFORE-HIDE.
			RUN MF.P.
			INPUT CLOSE.
			OUTPUT CLOSE.
	
            
            find first pt_mstr no-lock where pt_part = xxppif_part no-error.
            if available pt_mstr then do:
            	xxppif_err = 0.
            	xxppif_msg = "Delete Faild.".
            end.			
*/
		end.
		/* PROCESS PPID END*/		
