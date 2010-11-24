/*By: Neil Gao 08/08/23 ECO: *SS 20080823* */
{mfdeclre.i }

define input	parameter iptlot like ld_lot.
define output parameter optlog as logical.

optlog = no.
if iptlot <> "" and length(iptlot) > 7 then do:
	find first vd_mstr where vd_domain = global_domain and vd_addr = substring(iptlot,7) no-lock no-error.
	if not avail vd_mstr then optlog = yes.
end.
else optlog = yes. 