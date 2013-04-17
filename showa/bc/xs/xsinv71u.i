wxxin_pallet = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
if V1502 <> "" then  do:
   find first xxin_det where xxin_part = V1300 and xxin_lot = V1502 no-lock no-error.
   if AVAILABLE xxin_det then wxxin_pallet = xxin_pallet.
end.

create xxin_det.
          assign xxin_part = V1300
	            xxin_loc    = V1400
		    xxin_lot    = V1500
		    xxin_fb     = no
		    xxin_pallet = wxxin_pallet.