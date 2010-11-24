/* By: Neil Gao Date: 07/10/18 ECO: *ss 20071018 */

{mfdeclre.i} /* SHARED VARIABLE INCLUDE */

define input parameter iptsodnbr like sod_nbr no-undo.
define input parameter iptsodline like sod_line no-undo.
define input parameter iptsodpart like sod_part no-undo.
define input parameter iptdate as date no-undo.
define input parameter iptdue  as date .
define input parameter iptlogi  as logical.
define input-output parameter iptqty  like sod_qty_ord no-undo.
define input parameter iptline like xxseq_line no-undo.
define shared variable site like pt_site no-undo.
define shared variable part like pt_part.
define shared variable multiple as decimal init 1 .
define shared variable line_rate      like lnd_rate.
define variable new_priority   as   decimal no-undo.
define var i as int.
define var prline like xxseq_line.
define variable hours          as   decimal extent 4.
define variable cap            as   decimal extent 4.
define var daterange as int.
define var totqty like sod_qty_ord.
define var tothours as decimal.
define var tmpqty like sod_qty_ord.
define var wosodnbr as char format "x(11)".
define var linedate as date.
define var yn as logical.
define var check_date as date.

	DEFINE VARIABLE vchr_filename_in AS CHARACTER.
	DEFINE VARIABLE vchr_filename_out AS CHARACTER.	
	DEFINE VARIABLE vlog_fail_flag AS LOGICAL.

	vchr_filename_in = "./ssi" + mfguser.
	vchr_filename_out = "./sso" + mfguser.

define shared temp-table xuln_det no-undo
	field xuln_sel as char format "x(3)"
	field xuln_line like ln_line
	field xuln_seq  like lnd_run_seq1
	field xuln_rate like lnd_rate
	field xuln_rate1 like lnd_rate
	index xuln_line 
	xuln_seq 
	xuln_line.

define shared temp-table tmtwo no-undo
	field tmtwo_f1 like xxseq_priority
	field tmtwo_f2 like xxseq_site.

daterange = 300.

i = 0.

mainloop:
repeat :

	linedate = iptdate.
	for each xuln_det where xuln_sel =  "*" no-lock:
		
		prline = xuln_line.
		if iptlogi then do:
			if iptdate > iptdue then do:
				message "订单:" iptsodnbr iptsodline "排程日期:" iptdate "截至日期:" iptdue "是否排程: " update yn.
				if yn then do:
					iptdate = iptdue.
					leave.
				end.
				else 
					leave mainloop.
			end.
		end.
		else if iptdate < today then do:
			message "时间过短,无法排程".
			leave mainloop.
		end.

		{xxrecaldt.i "linedate" "site" "prline" iptlogi }
		{xxrecalcap.i &date = linedate}
		if linedate <> iptdate then next.
		
		if cap[1] + cap[2] + cap[3] + cap[4] <= 0 then next.
		
		tothours = 0.
		for each xxseq_mstr where xxseq_domain = global_domain and xxseq_site = site
			and xxseq_line = prline and xxseq_due_date = iptdate no-lock :
			tothours = tothours + xxseq_shift1.
		end.
		
		line_rate = xuln_rate.
		if line_rate = 0 then leave.
		
		if tothours > max(cap[1] + cap[2] + cap[3] + cap[4],xuln_rate1 / xuln_rate)then next.	
		
		new_priority = 0.
		find last xxseq_mstr use-index xxseq_priority where xxseq_domain = global_domain
			and xxseq_site = site no-lock no-error.
		if avail xxseq_mstr then 
			new_priority = xxseq_priority.
		new_priority = new_priority + 1.
		
		if xuln_rate1 > 0 then
    	tmpqty = min( xuln_rate1, ( max(xuln_rate1 / line_rate,cap[1] + cap[2] + cap[3] + cap[4]) - tothours ) * line_rate ,iptqty).
    else
      tmpqty = min( ( cap[1] + cap[2] + cap[3] + cap[4] - tothours ) * line_rate,iptqty).
    tmpqty = round(tmpqty,0).
		if tmpqty <= 0 then next.
		
		create xxseq_mstr. xxseq_mstr.xxseq_domain = global_domain.
    assign  xxseq_priority = new_priority
    				xxseq_part     = iptsodpart
            xxseq_site     = site
            xxseq_line     = prline
            xxseq_due_date = iptdate
            xxseq_sod_nbr  = iptsodnbr
            xxseq_sod_line = iptsodline
         		xxseq_qty_req  = tmpqty
    				xxseq_shift1   = xxseq_qty_req / line_rate
    				xxseq_user1    = "P"
    				iptqty = iptqty - xxseq_qty_req.
		
		create 	tmtwo.
		assign 	tmtwo_f1 = xxseq_priority
						tmtwo_f2 = xxseq_site.
		
		if iptqty <= 0 then leave.
		
	end. /* for each */
	
/* 时间不够,剩余量都排在最后一天 */
/*SS 20080715 - B*/
	if iptlogi and iptdate = iptdue then do:
		for first xuln_det where xuln_sel =  "*" no-lock:
			{xxrecaldt.i "iptdate" "site" "xuln_line" no }
			{xxrecalcap.i &date = iptdate}
			find first xxseq_mstr where xxseq_domain = global_domain and xxseq_part = iptsodpart
				and xxseq_site = site and xxseq_due_date = iptdate and xxseq_sod_nbr = iptsodnbr 
				and xxseq_line = xuln_line and xxseq_sod_Line = iptsodline no-error.
			if avail xxseq_mstr then do:
				xxseq_qty_req = xxseq_qty_req + iptqty.
				xxseq_shift1 = xxseq_qty_req / xuln_rate.
				iptqty = 0.
			end.
			else do:
                            new_priority = 0.
				find last xxseq_mstr use-index xxseq_priority where xxseq_domain = global_domain
					and xxseq_site = site no-lock no-error.
				if avail xxseq_mstr then 
					new_priority = xxseq_priority.
					new_priority = new_priority + 1.
                            
				create xxseq_mstr. xxseq_mstr.xxseq_domain = global_domain.
   	 		assign  xxseq_priority = new_priority
    						xxseq_part     = iptsodpart
            		xxseq_site     = site
            		xxseq_line     = xuln_line
            		xxseq_due_date = iptdate
            		xxseq_sod_nbr  = iptsodnbr
            		xxseq_sod_line = iptsodline
         				xxseq_qty_req  = iptqty
    						xxseq_shift1   = xxseq_qty_req / xuln_rate
    						xxseq_user1 	 = "P"
    						iptqty = iptqty - xxseq_qty_req.
		
				create 	tmtwo.
				assign 	tmtwo_f1 = xxseq_priority
								tmtwo_f2 = xxseq_site.
				
			end.
		end.
		leave.
	end.
/*SS 20080715 - E*/
	
	if iptlogi then
		iptdate = iptdate + 1.
	else iptdate = iptdate - 1.
	if iptqty <= 0 or abs(iptdate - today) > daterange then leave.
	if iptlogi then do:
		if iptdate > iptdue then do:
			message "时间过短,无法排程".
			leave.
		end.
	end.
	else if iptdate < today then do:
		message "时间过短,无法排程".
		leave.
	end.
end.