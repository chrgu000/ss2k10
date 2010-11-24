/* By: Neil Gao Date: 08/03/03 ECO: * ss 20080303 * */

if avail tt-rqm-mstr then do:
	disp tt-nbr tt-line tt-req-date tt-vin with frame d.
	/*
	find first ad_mstr where ad_domain = global_domain and ad_addr = tt-cust no-lock no-error.
	if avail ad_mstr then disp ad_name with frame d.
	*/
	find first cd_det where cd_domain = global_domain and cd_ref = tt-part and cd_type = 'sc'
	and cd_lang = 'ch' no-lock no-error.
	if avail cd_det then do:
		cmmt1 = cd_cmmt[1].
		cmmt2 = cd_cmmt[2].
		cmmt3 = cd_cmmt[3].
		cmmt4 = cd_cmmt[4].
		cmmt5 = cd_cmmt[5].
		disp cmmt1 cmmt2 cmmt3 cmmt4 cmmt5 with frame d.
	end.
end.