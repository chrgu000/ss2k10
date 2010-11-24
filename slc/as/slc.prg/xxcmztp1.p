/*By: Neil Gao 09/01/20 ECO: *SS 20090120* */

/* DISPLAY TITLE */
{mfdtitle.i "n1"}

define var part like pt_part init "D".
define var i as int.

form
	part colon 25 
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
	
form
	pt_part column-label "³ÉÆ·Âë" 
	cd_cmmt[1] column-label "ÃèÊö"
with frame c down width 200.

mainloop:
repeat:
	
	update part with frame a.
	
	{mfselprt.i "printer" 132}
	
	for each pt_mstr where pt_domain = global_domain and pt_part begins part and length(pt_part) = 13 no-lock:
		disp pt_part with frame c.
		find first cd_det where cd_domain = global_domain and cd_ref = pt_part and cd_type = "SC"
			and cd_lang = "ch" no-lock no-error.
		if avail cd_det then do:
			do i = 1 to 15 :
				if cd_cmmt[i] <> "" then do:
					disp cd_cmmt[i] @ cd_cmmt[1] with frame c.
					down 1 with frame c.
				end.
			end.
		end.
		else	down with frame c .
	end.
	
	{mfreset.i}
	{mfgrptrm.i}

end. /* mainloop */		
