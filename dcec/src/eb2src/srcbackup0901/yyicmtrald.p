/*zzicmtrald.p	CREATE BY LONG BO 2004 JUN 21					*/
/*	ITEM TRANSFER ORDER MAINTENANCE		DELETE					*/
/*	移库单备料维护	删除/取消备料量								*/



	 {mfdeclre.i}
	 
	define input parameter del-lad as logic.
	/*IF DEL-LAD = YES THEN DELETE LAD_DET ELSE ASSIGN LAD_QTY_ALL = 0*/
	 
	define shared variable lad_recno as recid.
	def   shared var nbr like lad_nbr.
	define shared variable site_from like lad_site no-undo.
	define shared variable site_to   like lad_site no-undo.
	define shared variable loc_from  like lad_loc no-undo.
	define shared variable loc_to    like lad_loc no-undo.

	for each lad_det where lad_dataset = "itm_det"
	and lad_nbr = nbr exclusive-lock:
	
		/*UPDATE IN_MSTR AND LD_DET*/
		find in_mstr where in_site = site_from and in_part = lad_part exclusive-lock no-error.
	    if not available in_mstr then do :
	    	{gprun.i ""csincr.p"" "(input lad_part, input site_from)"}
 			if global-beam-me-up then undo, leave.
			find in_mstr where in_site = site_from and in_part = lad_part exclusive-lock no-error.
		end.
		in_qty_all = in_qty_all - lad_qty_all.
		
		find si_mstr where si_site = site_from no-lock no-error.
		find loc_mstr where loc_site = site_from and loc_loc = lad_loc no-lock no-error.
		find ld_det where ld_site = site_from and ld_loc = lad_loc
		and ld_part = lad_part and ld_lot = lad_lot and ld_ref = lad_ref
		exclusive-lock no-error.
		if not available ld_det then do :
			create ld_det.
			assign ld_site = site_from
					ld_loc = lad_loc
					ld_part = lad_part
					ld_lot = lad_lot
					ld_ref = lad_ref
     				ld_date  = today.
     	
            if available loc_mstr then do:
                ld_status = loc_status.
            end.
            else do:
	            if available si_mstr then ld_status = si_status.
	        end.
	    end.
		ld_qty_all = ld_qty_all - lad_qty_all.
		if  del-lad then
			delete lad_det.     
		else
			lad_qty_all = 0.
	end.						                   
	
