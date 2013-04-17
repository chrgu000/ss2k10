
procedure getTrLoc:
/*------------------------------------------------------------------------------
  Purpose: 取备料区库位的算法
    Notes:
------------------------------------------------------------------------------*/
  define input parameter ipart like pt_part.
  define output parameter oloc like loc_loc.
  define output parameter ostat like ld_status.
  assign oloc = "P-ALL".
  find first pt_mstr no-lock where pt_part = iPart no-error.
  if available pt_mstr then do:
  	 find first code_mstr no-lock where code_fldname = pt_buyer and 
  	 		        code_value = pt_buyer no-error.
  	 if available code_mstr then do:
  	 		assign oloc = code_desc.
  	 end.
	end.
  find first loc_mstr no-lock where loc_loc = oloc no-error.
  if availa loc_mstr then do:
     assign ostat = loc_status.
  end.
  else do:
  	 find first loc_mstr no-lock where loc_loc = "P-ALL" no-error.
  	 if availa loc_mstr then do:
  	    assign  oloc = "P-ALL"
  	    				ostat = loc_status.
  	 end.  	 
  end.
end procedure.

FUNCTION getSaveLogStat RETURNS logical() :
/*------------------------------------------------------------------------------
  Purpose: 是否保存临时文件(for test program)
    Notes:
------------------------------------------------------------------------------*/
  define variable ostat as logical initial yes.
  find first code_mstr no-lock where code_fldname = "barcode" and
             code_value = "savecimlogforcheck" and code_cmmt = "yes" no-error.
  if available code_mstr then do:
     assign ostat = no.
  end.
  return ostat.
END FUNCTION.