/* By: Neil Gao Date: 08/03/03 ECO: * ss 20080303 * */

if avail tt-rqm-mstr then do:
	disp tt-nbr tt-line with frame d.
	find first pt_mstr where pt_domain = global_domain and pt_part = substring(tt-part,1,4) no-lock no-error.
	if avail pt_mstr then do:
		disp pt_desc1 with frame d.
	end.
	find first cd_det where cd_domain = global_domain and cd_ref = tt-part and cd_type = 'sc'
	and cd_lang = 'ch' no-lock no-error.
	if avail cd_det then do:
		cmmt1 = cd_cmmt[1].
		cmmt2 = cd_cmmt[2].
		cmmt3 = cd_cmmt[3].
		cmmt4 = cd_cmmt[4].
		cmmt5 = cd_cmmt[5].
		disp cmmt1 cmmt2 cmmt3 cmmt4 with frame d.
	end.
	find first cm_mstr where cm_domain = global_domain and cm_addr = tt-cust no-lock no-error.
	if avail cm_mstr then do:
		disp cm_cr_limit @ crlimit with frame d.
	end.
	soamt = 0.
	for each sod_det where sod_domain = global_domain and sod_nbr = tt-nbr no-lock:
		soamt = soamt + sod_qty_ord * sod_price.
	end.
	disp soamt with frame d.
end.