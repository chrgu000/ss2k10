{mfdeclre.i}
{gplabel.i} 

define input parameter iptsite like ld_site no-undo.
define input parameter iptpart like pt_part no-undo.
define var tt_recid as recid no-undo.
define var ti as int.
define shared temp-table xuln_det no-undo
	field xuln_sel as char format "x(1)"
	field xuln_line like ln_line
	field xuln_seq  like lnd_run_seq1
	field xuln_rate like lnd_rate
	field xuln_rate1 like lnd_rate
	index xuln_line 
	xuln_seq 
	xuln_line.


form 
	xuln_sel label "选"
	xuln_line label "生产线"
	xuln_seq label "顺序"
	xuln_rate label "件数/小时"
	xuln_rate1 label "每天件数"
with frame c width 80 5 down overlay scroll 1 .

loop1:
do with frame c:
	
	empty temp-table xuln_det.
	ti = 1.
	for each pt_mstr where pt_domain = global_domain and pt_part = iptpart no-lock,
			each lnd_det where lnd_domain = global_domain and lnd_start <= today
				and lnd_site = iptsite and ( lnd_part = pt_part or lnd_part = pt_group) no-lock,
			each lna_det where lna_domain = global_domain and lna_site = lnd_site 
				and lna_line = lnd_line and lna_part = lnd_part 
				and lna_allocation = 100 no-lock
			break by lnd_part descending by lnd_line  by lnd_start descending:
			if first-of(lnd_line) then do:
				find first xuln_det where xuln_line = lnd_line no-lock no-error.
				if not avail xuln_det then do:
					create xuln_det.
					assign xuln_line = lnd_line
						 xuln_rate = lnd_rate
						 xuln_seq = string(ti)
						 xuln_sel = "*"
						 ti = ti + 1
						 . 
				end.	 
			end.
	end.
	
	for each pt_mstr where pt_domain = global_domain and pt_part = iptpart no-lock,
			each lnd_det where lnd_domain = global_domain and lnd_start <= today
				and lnd_site = iptsite and ( lnd_part = pt_part or lnd_part = pt_group) no-lock,
			each lna_det where lna_domain = global_domain and lna_site = lnd_site 
				and lna_line = lnd_line and lna_part = lnd_part 
				and lna_allocation = 0 no-lock
			break by lnd_part descending by lnd_line by lnd_start descending:
			if first-of(lnd_line) then do: 	
				find first xuln_det where xuln_line = lnd_line no-lock no-error.
				if not avail xuln_det then do:
					create xuln_det.
					assign xuln_line = lnd_line
								 xuln_rate = lnd_rate
								 xuln_seq = string(ti)
						 		 xuln_sel = "*"
						 		 ti = ti + 1
						 			.
			 	end. 
			end.
	end.
	
	find first xuln_det no-lock no-error.
	if not avail xuln_det then do:
		message "生产线不存在".
		hide frame c no-pause.
		pause.
		leave.
	end.
	/*
	{xusel.i
         &detfile = xuln_det
         &scroll-field = xuln_line
         &framename = "c"
         &framesize = 5
         &display1     = xuln_sel
         &display2     = xuln_line
         &display3     = xuln_seq
         &display4     = xuln_rate
         &display5     = xuln_rate1
         &sel_on    = ""*""
         &sel_off   = """"
         &exitlabel = loop1
         &exit-flag = true
         &record-id = tt_recid
         &include1 = "xuln_rate1 = 0. disp xuln_rate1 with frame c."
         &include2 = "update xuln_rate1 with frame c."
         }
	*/
  hide frame c no-pause.
 
  
end.