/* By: Neil Gao Date: 08/03/03 ECO: * ss 20080303 * */

if avail tt2 then do:
	disp tt2_f1 with frame d.
	find first cd_det where cd_domain = global_domain and cd_ref = tt2_f4 and cd_type = 'sc'
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