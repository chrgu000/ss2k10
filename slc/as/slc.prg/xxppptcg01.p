/* SS - 090729.1 By: Neil Gao */

{mfdeclre.i}

define input parameter iptf1 like pt_part.
define input parameter iptf2 like pt_part.

for each xxabs_mstr where xxabs_domain = global_domain and xxabs_part = iptf1 :
	xxabs_part = iptf2.
end.

for each xxglpod_det where xxglpod_domain = global_domain and  xxglpod_part = iptf1 :
	xxglpod_part = iptf2.
end.

for each xxglso_mstr where xxglso_domain = global_domain and  xxglso_part = iptf1 :
	xxglso_part = iptf2.
end.

for each xxglt_det where xxglt_domain = global_domain and xxglt_part = iptf1 :
	xxglt_part = iptf2.
end.

for each xxglwod_det where xxglwod_domain = global_domain and xxglwod_part = iptf1 :
	xxglwod_part = iptf2.
end.

for each xxgzd_det where xxgzd_domain = global_domain and  xxgzd_part = iptf1 :
	xxgzd_part = iptf2.
end.


for each xxld_det where xxld_domain = global_domain and xxld_part = iptf1 :
	xxld_part = iptf2.
end.

for each xxpc_mstr where xxpc_domain = global_domain and xxpc_part = iptf1 :
	xxpc_part = iptf2.
end.

for each xxpi_mstr where xxpi_domain = global_domain and xxpi_part = iptf1 :
	xxpi_part = iptf2.
end.

for each xxtr_hist where xxtr_domain = global_domain and xxtr_part = iptf1 :
	xxtr_part = iptf2.
end.

for each xxzgp_det where xxzgp_domain = global_domain and xxzgp_part = iptf1 :
	xxzgp_part = iptf2.
end.

