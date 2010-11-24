/*By: Neil Gao 08/07/12 ECO: *SS 20080712* */

{mfdeclre.i}

define input parameter iptsite like sod_site.
define input parameter sodnbr like sod_nbr.
define input parameter sodline like sod_line.
define output parameter xxper as int.

xxper = 0.
for each xxsob_det where xxsob_domain = global_domain and xxsob_site = iptsite
		and xxsob_nbr = sodnbr and xxsob_line = sodline no-lock,
	each pt_mstr where pt_domain = global_domain and xxsob_part = pt_part 
		and pt_pm_code = "P" no-lock:
	
	xxper = max(xxper,pt_pur_lead).
	/*xxsob_qty_all = pt_pur_lead.*/
	
end.