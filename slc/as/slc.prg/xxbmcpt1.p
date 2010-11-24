/*By: Neil Gao 08/12/03 ECO: *SS 20081203* */

{mfdtitle.i "n1"}

define var wolot like wo_lot.
define var xxgx as char.
define var parent like ps_par.
define var bmcop as char.
define var tpar like ps_par.
define var i as int.
define var cmmt as char format "x(76)".
define var cmmt1 as char format "x(76)".
define var cmmt2 as char format "x(76)".
define var cmmt3 as char format "x(76)".
define var vin as char format "x(18)".
define var vin1 as char format "x(18)".

define new shared workfile pkdet no-undo
   field pkpart like ps_comp
   field pkop as integer  format ">>>>>9"
   field pkstart like pk_start
   field pkend like pk_end
   field pkqty like pk_qty
   field pkbombatch like bom_batch
   field pkltoff like ps_lt_off.

form
	wolot		colon 25
	xxgx  	colon 25 label "工序"
with frame a side-labels width 80 attr-space.

setframelabels(frame a:handle).

form 
	pt_desc1 column-label "名称"
	cmmt column-label "描述"
with frame c down width 200 no-attr-space.
/*
setframelabels(frame c:handle).
	*/
view frame a .

mainloop:
repeat:
	
	update wolot xxgx with frame a.
	
	find first wo_mstr where wo_domain = global_domain and wo_lot = wolot no-lock no-error.
	if not avail wo_mstr then do:
		message "工单ID不存在".
		next.
	end.
		
	find first xxbmc_det where xxbmc_domain = global_domain and xxbmc_bom = wo_part and ( xxbmc_ref = xxgx or xxgx = "" ) no-lock no-error.
	if not avail xxbmc_det then 
		find first xxbmc_det where xxbmc_domain = global_domain and xxbmc_bom = "" and ( xxbmc_ref = xxgx or xxgx = "" ) no-lock no-error.
	if avail xxbmc_det then tpar = xxbmc_bom.	
	
	find first cd_det where cd_domain = global_domain and cd_ref = wo_part and cd_lang = "ch" and cd_type = "sc" no-lock no-error.
	if avail cd_det then do:
		cmmt1 = cd_cmmt[1].
		cmmt2 = cd_cmmt[2].
		cmmt3 = cd_cmmt[3].
	end.
	else do:
		cmmt1 = "".
		cmmt2 = "".
		cmmt3 = "".
	end.
	vin = "".
	vin1 = "".
	for each xxsovd_det where xxsovd_domain = global_domain and xxsovd_wolot = wo_lot no-lock 
	break by substring(xxsovd_id,12) :
		if first(substring(xxsovd_id,12)) then vin = xxsovd_id.
		if last(substring(xxsovd_id,12)) then vin1 = xxsovd_id.
	end.
	
	{mfselprt.i "printer" 132}
	
	for each pkdet :	delete pkdet.	end.
   	
  {gprun.i ""xxwobmfj.p""  "(
    						input wo_part,
    						input today,
    						input '10000' )"}
	
	for each pkdet where (pkstart = ? or pkstart <= today ) and
			(pkend = ? or pkend >= today ) no-lock,
		each xxbmc_det where xxbmc_domain = global_domain and xxbmc_bom = tpar and ( xxbmc_ref = xxgx or xxgx = "" )  no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = pkpart and pt_part begins xxbmc_part no-lock,
		each code_mstr  where code_mstr.code_domain = global_domain and code_fldname = "xxgx" and code_value = xxbmc_ref no-lock
		break by xxbmc_ref by xxbmc_line:
		
		form header
			"工单号:" wo_nbr no-label "ID:" wo_lot no-label "成品号:" wo_part no-label "数量:" wo_qty_ord no-label 
			"      " code_cmmt no-label format "x(8)" skip
			"状态描述:" cmmt1 no-label colon 10
									cmmt2 no-label colon 10
									cmmt3 no-label colon 10 skip
			"条码范围:" vin no-label "到" vin1 no-label
		with stream-io frame phead page-top width 132 no-box.
		
		view frame phead.
		
		disp pt_desc1 with frame c.
		
		find first cd_det where cd_domain = global_domain and cd_ref = pt_part and cd_lang = "ch" and cd_type = "SC" no-lock no-error.
		if avail cd_det then do:
			repeat i = 1 to 15:
				if cd_cmmt[i] <> "" then do:
					disp cd_cmmt[i] @ cmmt with frame c.
					down with frame c.
				end.
			end.
		end.
		else down with frame c.
		
		if last-of(xxbmc_ref) and not last(xxbmc_ref) then do:
			page.
		end.
	
	end.
	
	{mfreset.i}
	{mfgrptrm.i}
	
end. /* mainloop */
		