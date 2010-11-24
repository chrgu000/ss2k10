/* By: Neil Gao Date: 08/03/04 ECO: * ss 20080304 * */

if avail xxtsod then do:
	disp xxtsod_nbr xxtsod_line with frame bb.
	find first ad_mstr where ad_domain = global_domain and ad_addr = xxtsod_cust no-lock no-error.
	if avail ad_mstr then disp ad_name with frame bb.
  find first cd_det where cd_domain = global_domain and cd_ref = xxtsod_part and cd_type = 'sc'
   	and cd_lang = 'ch' no-lock no-error.
  if avail cd_det then do: 
  	disp cd_cmmt[1] @ cmmt1 cd_cmmt[2] @ cmmt2
         cd_cmmt[3] @ cmmt3 cd_cmmt[4] @ cmmt4 with frame bb.
  end.
end.

