	
	for each xxindet : delete xxindet. end.
	xsckbypartloclot = no.

	contain_qty = 0.
	for each code_mstr where code_fldname = "partloc" + V1300  and code_value = V1400 no-lock :
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
	     for each xxindet break by xxinpallet  :     /*   xscking Error */
	          if last-of(xxinpallet) then   contain_qty = contain_qty - 1.
	     end.
	     if contain_qty >0  then do:
	        xsckbypartloclot = yes.
	     end.
	end.
	if V1400 = "ASSY" then xsckbypartloclot = yes.
	find first xxin_det where xxin_part = V1300  and xxin_loc = V1400 and xxin_lot = V1500 no-lock no-error.
	if AVAILABLE xxin_det then  xsckbypartloclot = no.

