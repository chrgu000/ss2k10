/*By: Neil Gao 08/12/03 ECO: *SS 20081203* */
/*By: Billy Huang 08/12/15 成车状态表（销售部）*/
/*By: Neil Gao 08/12/29 ECO: *SS 20081229* */


{mfdtitle.i "n1"}

define var wolot like wo_lot.
define var xxgx as char.
define var parent like ps_par.
define var bmcop as char.
define var tpar like ps_par.
define var i as int.
define var cmmt as char format "x(30)" extent 30.
define var cmmt1 as char format "x(76)".
define var cmmt2 as char format "x(76)".
define var cmmt3 as char format "x(76)".
define var vin as char format "x(18)".
define var vin1 as char format "x(18)".
define var sonbr like sod_nbr.
define var soline like sod_line.
define var remark as character format "x(18)".
DEFINE VARIABLE tmp_char as char format "x(76)" label "状态说明".
DEFINE VARIABLE k as integer.

define new shared workfile pkdet no-undo
   field pkpart like ps_comp
   field pkop as integer  format ">>>>>9"
   field pkstart like pk_start
   field pkend like pk_end
   field pkqty like pk_qty
   field pkbombatch like bom_batch
   field pkltoff like ps_lt_off.

form
	sonbr		colon 25
with frame a side-labels width 80 attr-space.

setframelabels(frame a:handle).

form 
	pt_desc1 column-label "零件名称"
	pt_part  column-label "编码"
	cmmt[1]  column-label "状态描述"
	remark   column-label "备注"
with frame c down width 200 no-attr-space.

/*
setframelabels(frame c:handle).
*/

view frame a .

mainloop:
repeat:
	
	update sonbr with frame a.
	hide frame a no-pause.
	
/*SS 20081229 - B*/
	{gprun.i ""xxdysoztxs.p"" "(input sonbr,output soline)"}
/*SS 20081229 - E*/	
	
	find first sod_det where sod_domain = global_domain and sod_nbr = sonbr and sod_line = soline no-lock no-error.
	if not avail sod_det then do:
		message "销售订单不存在".
		next.
	end.
	find first so_mstr where so_domain = global_domain and so_nbr = sod_nbr no-lock no-error.
	find first cm_mstr where cm_domain = global_domain and cm_addr = so_cust no-lock no-error.
		
	find first xxbmc_det where xxbmc_domain = global_domain and xxbmc_bom = sod_part and xxbmc_ref = "90" no-lock no-error.
	if not avail xxbmc_det then 
		find first xxbmc_det where xxbmc_domain = global_domain and xxbmc_bom = "" and xxbmc_ref = "90" no-lock no-error.
	if avail xxbmc_det then tpar = xxbmc_bom.	
	
	find first cd_det where cd_domain = global_domain and cd_ref = sod_part and cd_lang = "ch" and cd_type = "sc" no-lock no-error.
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
	
	{mfselprt.i "printer" 132}
	
	for each pkdet :	delete pkdet.	end.
   	
  {gprun.i ""xxwobmfj.p""  "(
    						input sod_part,
    						input today,
    						input '10000' )"}
    						
	for each pkdet where (pkstart = ? or pkstart <= today ) and (pkend = ? or pkend >= today ) no-lock,
		each xxbmc_det where xxbmc_domain = global_domain and xxbmc_bom = tpar and xxbmc_ref = "90"  no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = pkpart and pt_part begins xxbmc_part no-lock,
		each code_mstr  where code_mstr.code_domain = global_domain and code_fldname = "xxgx" and code_value = xxbmc_ref no-lock
		break by xxbmc_ref by xxbmc_line:
		
		form header
		  "成车状态表" at 40 skip(1)
			"订单号:" sod_nbr no-label "项:" string(sod_line) no-label "成品号:" sod_part no-label "数量:" string(sod_qty_ord) no-label "客户:" cm_sort skip
			"状态描述:" cmmt1 no-label colon 10
									cmmt2 no-label colon 10
									cmmt3 no-label colon 10 skip
			/*"图片位置:"*/ so__chr02 no-label format "x(50)"					
									skip
		with stream-io frame phead page-top width 132 no-box.
		
		view frame phead.
		
		disp pt_desc1 pt_part with frame c.
		
		find first cd_det where cd_domain = global_domain and cd_ref = pt_part and cd_lang = "ch" and cd_type = "SC" no-lock no-error.
		if avail cd_det then do:
			repeat i = 1 to 15:
				if trim(cd_cmmt[i]) <> "" then do:
					tmp_char = tmp_char + trim(cd_cmmt[i]).
				end.
			end.
			k = 1.
			run getstring(input tmp_char ,input 30, output tmp_char ,output k).
			do i = 1 to k:
				assign cmmt[i] = ENTRY(i, tmp_char, "^").
		  end.
		  display cmmt[1] remark with frame c.
			
		end.
		else down with frame c.
		do i = 2 to 15 :
				if trim(cmmt[i]) <> "" then do:
					down 1 with frame c.
					display cmmt[i] @ cmmt[1] with frame c.
				end.
		end.
		put "----------------------------------------------------------------------------------------------" skip.
		do i = 1 to 30:
			if trim(cmmt[i]) <> "" then cmmt[i] = "".
		end.
		tmp_char = "".
	
	end.
		
	for each pkdet where pkpart begins "D" no-lock:
		{gprun.i ""xxwobmfj.p""  "(
    						input pkpart,
    						input today,
    						input '10000' )"}
	end.
	
	for each pkdet where (pkstart = ? or pkstart <= today ) and (pkend = ? or pkend >= today ) no-lock,
		each xxbmc_det where xxbmc_domain = global_domain and xxbmc_bom = tpar and xxbmc_ref = "90"  no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = pkpart and pt_part begins xxbmc_part no-lock,
		each code_mstr  where code_mstr.code_domain = global_domain and code_fldname = "xxgx" and code_value = xxbmc_ref no-lock
		break by xxbmc_ref by xxbmc_line:
		
		disp pt_desc1 pt_part with frame c.
		
		find first cd_det where cd_domain = global_domain and cd_ref = pt_part and cd_lang = "ch" and cd_type = "SC" no-lock no-error.
		if avail cd_det then do:
			repeat i = 1 to 15:
				if trim(cd_cmmt[i]) <> "" then do:
					tmp_char = tmp_char + trim(cd_cmmt[i]).
				end.
			end.
			k = 1.
			run getstring(input tmp_char ,input 30, output tmp_char ,output k).
			do i = 1 to k:
				assign cmmt[i] = ENTRY(i, tmp_char, "^").
		  end.
		  display cmmt[1] remark with frame c.
			
		end.
		else down with frame c.
		do i = 2 to 15 :
				if trim(cmmt[i]) <> "" then do:
					down 1 with frame c.
					display cmmt[i] @ cmmt[1] with frame c.
				end.
		end.
		put "----------------------------------------------------------------------------------------------" skip.
		do i = 1 to 30:
			if trim(cmmt[i]) <> "" then cmmt[i] = "".
		end.
		tmp_char = "".
	
	end.
	put "备注:" .
	
	{mfreset.i}
	{mfgrptrm.i}

end. /* mainloop */
		
PROCEDURE getstring:
		define input  parameter iptstring as char.
		define input  parameter iptlength as int.
		define output parameter optstring as char.
		define output parameter xxk as int.	/*---Add by davild 20071220.1*/
		define var xxs as char.
		define var xxss as char.
		define var xxi as int.
		define var xxj as int.
		
		optstring = "".
		xxss = "".
		xxi = 1.
		
		if iptlength < 2 then return.
		
		repeat while xxi <= length(iptstring,"RAW") :
			xxs = substring(iptstring,xxi,1).
			if length( xxss + xxs , "RAW") > iptlength then do:
				optstring = optstring + xxss + "^".
				xxss = "".
				next.
			end.
			xxi = xxi + 1.
			xxss = xxss + xxs.
		end.
		optstring = optstring + xxss.

		/*---Add Begin by davild 20071220.1*/
		xxk = 1 .
		do xxj = 1 to length(optstring):
			if substring(optstring,xxj,1) = "^" then assign xxk = xxk + 1 .
		end.
		/*---Add End by davild 20071220.1*/
END PROCEDURE.