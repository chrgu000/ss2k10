/* By: Neil Gao Date: 07/12/18 ECO: * ss 20071218 * */

/*
功能：展开bom
*/
{mfdeclre.i}
{gplabel.i}

define input parameter iptpart like pt_part.  /*计算价格的零件*/
define input parameter iptsite like sod_site.
define input parameter sodnbr like sod_nbr.
define input parameter sodline like sod_line.
define input parameter sodzd as char.
define input parameter socust like so_cust.
define buffer ptmstr for pt_mstr .
define var v_vend as character.
define var ptgrp like pt_group.

for each xxsob_det where xxsob_domain= global_domain and xxsob_nbr = sodnbr and xxsob_line = sodline 
	and xxsob_site = iptsite :
	delete xxsob_det.
end.

for each ps_mstr where ps_domain = global_domain and ps_par = iptpart no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock:
	
	if pt_pm_code = "P" then do:
		find first xxsob_det where xxsob_domain = global_domain and xxsob_site = iptsite and xxsob_nbr = sodnbr and xxsob_line = sodline
			and xxsob_part = ps_comp no-error.
		if not avail xxsob_det then do:
    	create 	xxsob_det.
	  	assign 	xxsob_site = iptsite
						 	xxsob_domain = global_domain
	      	   	xxsob_nbr =  sodnbr
	        	 	xxsob_line = sodline
		 					xxsob_parent = iptpart
		 					xxsob_part   = ps_comp
		 					xxsob_qty_req = ps_qty_per.
		end.
		else xxsob_qty_req = xxsob_qty_req + ps_qty_per.
  end.
  else do:
    {gprun.i ""xxscbom01.p"" "(input ps_comp, 
    													input iptsite, 
    												 	input sodnbr ,
    												 	input sodline,
    												 	input sodzd,
    												 	input socust,
    												 	input ps_qty_per
    												 	)"}
    													
  end.
end.

find first pt_mstr where pt_domain = global_domain and pt_part = iptpart no-lock no-error.
if avail pt_mstr then ptgrp = pt_group.

if sodzd <> "" then
for each xxsob_det where xxsob_domain= global_domain and xxsob_nbr = sodnbr and xxsob_line = sodline 
	and xxsob_site = iptsite ,
	each pt_mstr where pt_domain = global_domain and pt_part = xxsob_part no-lock :
	find first xxvbomd_det where xxvbomd_domain = global_domain and xxvbomd_cust = socust and iptpart = xxvbomd_parent 
		and xxsob_part = xxvbomd_part and xxvbomd_nbr = sodzd no-lock no-error.
	if not avail xxvbomd_det then
		find first xxvbomd_det where xxvbomd_domain = global_domain and xxvbomd_cust = socust and xxvbomd_parent = ptgrp 
			and xxsob_part = xxvbomd_part and xxvbomd_nbr = sodzd no-lock no-error.
	if avail xxvbomd_det then
		xxsob_user1 =  xxvbomd_vend.
end.