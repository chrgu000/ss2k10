/*By: Neil Gao 08/11/13 ECO: *SS 20081113* */

{mfdtitle.i}

define var parent like ps_par.
define var bmcop as char.
define var line like pod_line.

form
	parent colon 25
	bmcop	colon 25 label "工序"
with frame a side-labels width 80 attr-space.

setframelabels(frame a:handle).
	
form
	line 				column-label "项" 
	xxbmc_part  
	xxbmc_desc
	xxbmc_rmks  format "x(30)"
with frame c 12 down width 80 no-attr-space.

setframelabels(frame c:handle).
	
view frame a .

mainloop:
repeat:
	
	clear frame c all no-pause.
	
	update parent bmcop with frame a.
	
	if parent <> "" then do:
		find first ps_mstr where ps_domain = global_domain and ps_par = parent no-lock no-error.
		if not avail ps_mstr then do:
			message "不存在产品结构".
			next.
		end.
	end.
	
	if bmcop = "" then do:
		message "工艺不能为空".
		next.
	end.
	
	find last xxbmc_det where xxbmc_domain = global_domain and xxbmc_bom = parent and xxbmc_ref = bmcop no-lock no-error.
	if avail xxbmc_det then line = xxbmc_line + 1.
	else line = 1.
	disp line with frame c.
	
	loop1:
	repeat:
		
		prompt-for line with frame c editing:
			if frame-field = "line" then do:
				{mfnp05.i  xxbmc_det xxbmc_part "xxbmc_domain = global_domain and xxbmc_bom = parent and xxbmc_ref = bmcop "
				           xxbmc_line "input line"}
			end.
			else do:
				status input.
				readkey.
				apply lastkey.
			end.
			if recno <> ? then do:
					disp 	xxbmc_line @ line 
								xxbmc_part 
								xxbmc_desc
								xxbmc_rmks with frame c.
			end.
		end. /* editing */
		
		line = input line.
		do on error undo,next loop1 :
			find last xxbmc_det where xxbmc_domain = global_domain and xxbmc_bom = parent and xxbmc_ref = bmcop 
				and xxbmc_line = input line no-error.
			if not avail xxbmc_det then do:
				create xxbmc_det.
				assign xxbmc_domain = global_domain 
							 xxbmc_bom    = parent
							 xxbmc_ref    = bmcop
							 xxbmc_line   = input line.
				
				disp xxbmc_desc xxbmc_rmks with frame c.
				update xxbmc_part with frame c.
				find first pt_mstr where pt_domain = global_domain and pt_part begins xxbmc_part no-lock no-error.
				if not avail pt_mstr then do:
					message "类别不存在".
					undo,retry.
				end.
				
				xxbmc_desc = pt_desc1.
				update xxbmc_desc with frame c.
			end.
			else do:
				disp xxbmc_part xxbmc_desc with frame c.
			end.
		end. /* do no error */
		
		update xxbmc_rmks with frame c.
		assign xxbmc_date = today
					 xxbmc_userid = global_userid.
					 
		down 1 with frame c.
	  line = line + 1.
		disp line with frame c.
		
	end. /* loop1 */
	
end. /* mainloop */
	