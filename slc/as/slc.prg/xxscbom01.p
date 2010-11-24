/* By: Neil Gao Date: 07/12/18 ECO: * ss 20071218 * */

{mfdeclre.i}
{gplabel.i}

define input parameter iptpart like pt_part.  /*计算价格的零件*/
define input parameter iptsite like sod_site.
define input parameter sodnbr like sod_nbr.
define input parameter sodline like sod_line.
define input parameter soddz as char.
define input parameter socust like so_cust.
define input parameter perqty like ps_qty_per.
define var v_vend as character.

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
		 					xxsob_qty_req = ps_qty_per * perqty.
		end.
		else xxsob_qty_req = xxsob_qty_req + ps_qty_per * perqty.
  end.
  else do:
  	{gprun.i ""xxscbom01.p"" "(input ps_comp, 
    													input iptsite, 
    												 	input sodnbr ,
    												 	input sodline,
    												 	input '',
    												 	input socust,
    												 	input ps_qty_per * perqty
    												 	)"}
  end.
end.
