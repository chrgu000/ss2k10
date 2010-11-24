/*By: Neil Gao 08/11/13 ECO: *SS 20081113* */

{mfdtitle.i}

define var parent like ps_par.
define var bmcop as char.
define var tpar like ps_par.
define var i as int.
define var cmmt as char format "x(76)".

define new shared workfile pkdet no-undo
   field pkpart like ps_comp
   field pkop as integer  format ">>>>>9"
   field pkstart like pk_start
   field pkend like pk_end
   field pkqty like pk_qty
   field pkbombatch like bom_batch
   field pkltoff like ps_lt_off.

form
	parent colon 25
	bmcop  colon 25 label "工序"
with frame a side-labels width 80 attr-space.

setframelabels(frame a:handle).

form
	xxbmc_ref 
	pkpart 
	pt_desc1 
	cmmt
with frame c down width 200 no-attr-space.

setframelabels(frame c:handle).
	
view frame a .




mainloop:
repeat:
	
	update parent bmcop with frame a.
	
	find first ps_mstr where ps_domain = global_domain and ps_par = parent no-lock no-error.
	if not avail ps_mstr then do:
		message "不存在产品结构".
		next.
	end.
	
	find first xxbmc_det where xxbmc_domain = global_domain and xxbmc_bom = parent and ( xxbmc_ref = bmcop or bmcop = "" ) no-lock no-error.
	if not avail xxbmc_det then 
		find first xxbmc_det where xxbmc_domain = global_domain and xxbmc_bom = "" and ( xxbmc_ref = bmcop or bmcop = "" ) no-lock no-error.
	if avail xxbmc_det then tpar = xxbmc_bom.
	else do:
		message "没有bom工序控制".
		next.
	end.
	
	
	{mfselprt.i "printer" 132}
	
	for each pkdet :	delete pkdet.	end.
   	
  {gprun.i ""xxwobmfj.p""  "(
    						input parent,
    						input today,
    						input '10000' )"}
	
	for each pkdet where (pkstart = ? or pkstart <= today ) and
			(pkend = ? or pkend >= today ) no-lock,
		each xxbmc_det where xxbmc_domain = global_domain and xxbmc_bom = tpar and ( xxbmc_ref = bmcop or bmcop = "" )  no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = pkpart and pt_part begins xxbmc_part no-lock
		break by xxbmc_ref by xxbmc_line:
		
		
		disp xxbmc_ref pkpart pt_desc1 with frame c.
		
		find first cd_det where cd_domain = global_domain and cd_ref = pt_part no-lock no-error.
		if avail cd_det then do:
			repeat i = 1 to 15:
				if cd_cmmt[i] <> "" then do:
					disp cd_cmmt[i] @ cmmt with frame c.
					down with frame c.
				end.
			end.
		end.
		else down with frame c.
		
		if last-of(xxbmc_ref) then do:
			page.
		end.
	
	end.
	
	{mfreset.i}
	{mfgrptrm.i}
	
end. /* mainloop */
		