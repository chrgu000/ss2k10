/*By: Neil Gao 08/09/08 ECO: *SS 20080908* */

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define var xxcjnbr as char format "x(24)".
define var xxmtnbr as char format "x(24)".
define var part like pt_part.
define var reldate like wo_rel_date.
define var sonbr like so_nbr.
define var xxop  as char.
define var xxopdesc as char format "x(18)".
define var xxgw  as char format "x(16)".
define var xxreas as char.
define var xxemp  as char.
define var tseq as int.

form
	xxcjnbr colon 12 label "车架号"
	xxmtnbr colon 50 label "发动机号"
	part 		colon 12 label "Bom"
	reldate colon 45
	sonbr  
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
	xxop label "工序"
	xxopdesc label "工序名称" format "x(18)"
	xxgw label "工位/调试员"
	xxreas label "原因代码"
	xxemp label "解决人"
with frame b 10 down width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
	
view frame a.
repeat with frame a:

	update xxcjnbr xxmtnbr.
	
	find first xxsovd_det where xxsovd_domain = global_domain and xxsovd_id = xxcjnbr no-lock no-error.
	if not avail xxsovd_det then do:
		message "发动机号不存在".
		/*next.*/
	end.
	else do:
		disp xxsovd_id1 @ xxmtnbr xxsovd_part @ part with frame a.
		find first wo_mstr where wo_domain = global_domain and wo_lot = xxsovd_wolot no-lock no-error.
		if not avail wo_mstr then do:
			message "工单不存在".
		end.
		else disp wo_rel_date @ reldate.
	end.
	
	loop1:
	repeat: 
		view frame b .
	
		update xxop with frame b.
	
		find first code_mstr where code_domain = global_domain and code_fldname = "xxop" and code_value = xxop no-lock no-error.
		if not avail code_mstr then do:
			message "工序不存在".
			undo,retry.
		end.
		else do:
			disp code_cmmt @ xxopdesc with frame b.
		end.
		loop2:
		repeat:
			update xxgw xxreas xxemp with frame b.
			find first xxcode_mstr where xxcode_domain = global_domain and xxcode_fldname = "xxgw" and xxcode_nbr = xxop 
			and xxcode_value = xxgw no-lock no-error.
			if not avail xxcode_mstr then do:
				message "工位或调试员不存在".
				undo,retry.
			end.
			find last xxop_hist use-index xxop_trnbr where xxop_domain = global_domain no-lock no-error.
			if avail xxop_hist then do:
				tseq = xxop_trnbr.
			end.
			else tseq = 0.
			tseq = tseq + 1.
			create xxop_hist.
			assign xxop_domain = global_domain 
						 xxop_trnbr  = tseq
						 xxop_type   = "rwrk"
						 xxop_date	 = today
						 xxop_wo_nbr   = xxsovd_wonbr
						 xxop_wo_lot   = xxsovd_wolot
						 xxop_wo_op  = int(xxop)
						 xxop_wkctr  = xxgw
						 xxop_qty_rwrk = 1
						 xxop_rsn_rwrk  = xxreas
						 xxop_emp		= xxemp
						 xxop_program = execname
						 xxop_time = time
						 xxop_userid = global_userid.
			down 1 with frame b.
						 	
		end. /* loop2: */
		
	end.
end. 	