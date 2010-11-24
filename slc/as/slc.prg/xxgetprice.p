/* SS - 090611.1 By: Neil Gao */

{mfdeclre.i}

define input parameter iptf1 like ad_addr.
define input parameter iptf2 like pt_part.
define input parameter iptf3 as date.
define output parameter optf1 like pt_price.

find last xxpc_mstr where xxpc_domain = global_domain and xxpc_nbr <> "" and xxpc_approve_userid <> ""  
	and xxpc_list = iptf1 and xxpc_part = iptf2
	and (xxpc_start <= iptf3 or xxpc_start = ? ) 
	and ( xxpc_expire >= iptf3 or xxpc_expire  = ? ) no-lock no-error.
if avail xxpc_mstr then do:
	optf1 = xxpc_amt[1].
end.
else do:
	optf1 = 0.
end.

