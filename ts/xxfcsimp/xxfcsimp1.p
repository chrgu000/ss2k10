/*V8:ConvertMode=Report                                                       */

{mfdeclre.i}
{xxfcsimp.i}

define variable fn as character.
define variable i as integer.
assign fn = "xxfcsimp" + string(time) + ".cim".
output to value(fn).
  for each xfcs_det no-lock:
      put unformat '"' xfd_part '" "' xfd_site '" ' xfd_year skip.
      do i = 1 to 52:
      	 if xfd_fcs_qty[i] <> ? then
      	 	  put unformat trim(string(xfd_fcs_qty[i],">>>>,>>9")).
      	 else put "-".
         if i <> 52 then put ' '.
      end.
      put skip.
  end.
output close.

batchrun = yes.
INPUT FROM VALUE(fn).
OUTPUT TO VALUE(fn + ".out").
{gprun.i ""fcfsmt01.p""}
INPUT CLOSE .
OUTPUT CLOSE .
batchrun = NO.

for each xfcs_det exclusive-lock:
    find first fcs_sum where fcs_part = xfd_part and
       fcs_site = xfd_site and fcs_year = xfd_year no-error.
    if available fcs_sum then do:
       do i = 1 to 52:
       		if xfd_fcs_qty[i] = ? then next.
          if xfd_fcs_qty[i] <> fcs_fcst_qty[i] then do:
             assign xfd_chk = "error".
          end.
       end.
    end.
end.

if not can-find(first xfcs_det where xfd_chk = "error") then do:
	 os-delete VALUE(fn) no-error.
	 os-delete value(fn + ".out") no-error.
end.
