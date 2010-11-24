/* SS - 090402.1 By: Neil Gao */

{mfdtitle.i "090402.1"}

define var vingz as char .
define var vinnf as char format "x(2)".
define var vinhd as int.
define var vinsl as int.
define var yn    as logical.

form
	skip(1)
	vingz colon 15 label "VIN规则"
	vinnf colon 25 no-label
	vinhd colon 15 label "起始号"
	vinsl colon 15 label "数量"
	skip(1)
with frame a side-labels width 80 attr-space.

setframelabels(frame a:handle).
	
Mainloop:
repeat:
	
	clear frame a all no-pause.
	
	update vingz vinnf with frame a.
	
	find first xxslc_mstr where xxslc_domain = global_domain
		and xxslc_QianBaWei = vingz and xxslc_ShiShiYi = vinnf no-error.
	if not avail xxslc_mstr then do:
		create 	xxslc_mstr.
		assign 	xxslc_domain    = global_domain
						xxslc_QianBaWei = vingz
						xxslc_ShiShiYi  = vinnf  
						xxslc_last_number = 9 .
	end.
	
	vinhd = xxslc_last_number + 1.
	vinsl = 0.
	
	loop1:
	repeat:
		update vinhd vinsl with frame a.
		if vinsl = 0 then do:
			message "错误: 数量不能为零".
			next.
		end.
		do on error undo,leave:
			{gprun.i ""xxbomsot01.p"" "(input vingz,input vinnf,input vinhd,input vingz,input 1,
																						input '',input vinsl,output yn)"}
			if not yn then do:
				message "错误: vin产生有错误".
				undo,leave .
			end.
		end.
		if xxslc_last_number < vinhd + vinsl - 1 then xxslc_last_number = vinhd + vinsl - 1 .
		leave.
	end.
	
end.