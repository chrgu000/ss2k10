	for each xxindet : delete xxindet. end.
	contain_qty = 0.
	def_loc = "".
	for each code_mstr where code_fldname = "partloc" + V1300 no-lock :
              contain_qty = decimal (code_cmmt).
	      for each xxindet : delete xxindet. end.
	     /* δQAD Feedback*/
	     for each xxin_det where xxin_part = V1300  and xxin_loc = code_value and xxin_fb = no  no-lock :
                  create xxindet .
		              assign
		             xxinpart =   xxin_part
			     xxinloc   =   xxin_loc
			     xxinlot  =   xxin_lot
			     xxinpallet = xxin_pallet.
	     end.

	     for each ld_det where ld_part = V1300 and ld_loc = code_value  and ld_qty_oh <> 0 no-lock:
	     	   create xxindet.
		             assign
		             xxinpart =   ld_part
			     xxinloc   =   ld_loc
			     xxinlot  =    ld_lot.

	           find first xxin_det where xxin_part = ld_part and xxin_lot = ld_lot    no-lock no-error.
		   if AVAILABLE xxin_det then do:
			     xxinpallet = xxin_pallet.
		   end.

	     end.
	     for each xxindet break by xxinpallet  :     /*   Checking Error */
	          if last-of(xxinpallet) then   contain_qty = contain_qty - 1.
	     end.
	     if contain_qty >0  then do:
	        def_loc = code_value.
		leave.
	     end.
	end.
	if def_loc = "" then def_loc = "ASSY".
