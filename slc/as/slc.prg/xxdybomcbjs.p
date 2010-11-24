/* neil Gao Date: 07/12/29 ECO: * ss 20071229 * */

{mfdeclre.i}

define input parameter sod_nbr_input      like sod_nbr .
define input parameter sod_line_input like sod_line .
define output parameter price_output as decimal format "->>,>>>,>>9.99" init 0.
define variable  v_pc_amt like pc_amt[1].
define var iffind as logical.


for each xxsob_det where xxsob_domain = global_domain and xxsob_nbr = sod_nbr_input and xxsob_line = sod_line_input:
	
	find first xxpc_mstr where xxpc_domain = global_domain and xxpc_part = xxsob_part and (xxpc_start <= today or xxpc_start = ?) 
    	and  (xxpc_expire >= today or xxpc_expire = ?) no-lock no-error.
  if not avail xxpc_mstr then do:
  	message xxsob_part "没有维护价格".
  	price_output = 0.
  	return.
  end.
	if xxsob_user1 = "" then do:
  	iffind = no.
  	find first sct_det where sct_domain = global_domain and sct_sim = "Standard" and sct_part = xxsob_part no-lock no-error.
  	if avail sct_det then do:
  		xxsob_price = sct_cst_tot.
  		iffind = yes.
  	end.
	end.
	else	do: 
		iffind = no.
    for each xxpc_mstr where xxpc_domain = global_domain and xxpc_part = xxsob_part and (xxpc_start <= today or xxpc_start = ?) 
    	and xxpc_list = xxsob_user1 and  (xxpc_expire >= today or xxpc_expire = ?) no-lock:
      assign	xxsob_price = xxpc_amt[1].
           		iffind = yes.
    end.
	  if not iffind then do:
    	find first sct_det where sct_domain = global_domain and sct_sim = "Standard" and sct_part = xxsob_part no-lock no-error.
  		if avail sct_det then do:
	   		assign xxsob_price = sct_cst_tot.
	   	end.
	  end.
	end. /* else do: */ 
end. /* for each xxsob_det */

price_output = 0 .
for each xxsob_det where xxsob_domain = global_domain and xxsob_nbr = sod_nbr_input and xxsob_line = sod_line_input no-lock:
	price_output = price_output + xxsob_price * xxsob_qty_req.
end.

