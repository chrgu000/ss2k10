
procedure getTrLoc:
  define output parameter oloc like loc_loc.
  define output parameter ostat like ld_status.
  assign oloc = "P-4RPS".
  find first loc_mstr no-lock where loc_loc = oloc no-error.
  if availa loc_mstr then do:
     assign ostat = loc_status.
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