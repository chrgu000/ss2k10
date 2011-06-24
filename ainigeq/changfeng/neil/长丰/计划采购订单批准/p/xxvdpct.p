/* By: Neil Gao Date: 07/11/24 ECO: * ss 20071124 * */

/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}
{mf1.i}

define temp-table tvd
	field tvd_part like pt_part
	field tvd_vend like po_vend
	field tvd_vendqty like ld_qty_oh 
	index tvd_part
				tvd_part	tvd_vend.
				
define temp-table tvm
	field tvm_part 	like pt_part
	field tvm_qty 	like ld_qty_oh 
	index tvm_part
				tvm_part.


PROCEDURE initvd:
   empty temp-table tvd.
   empty temp-table tvm.
END PROCEDURE.  /* ip-validate */

PROCEDURE getvend:

	define input parameter iptpart like pt_part.
	define input parameter iptdate1 as date.
	define input parameter iptdate2 as date.
	define input parameter iptqty  like ld_qty_oh.
	define output parameter optvend like po_vend.
	define var tmpqty1 as deci.
	define var tmpqty2 as deci.
	define var tmppct like vp_tp_pct.
	
	tmpqty1 = 0.
	tmpqty2 = 0.
	optvend = "".
	
	find first tvd where tvd_part = iptpart no-lock no-error.
	if not avail tvd then do:
		for each pod_det where pod_part = iptpart no-lock,
	  	each po_mstr where po_nbr = pod_nbr
	   		and po_ord_date >= iptdate1	and po_ord_date <= iptdate2 no-lock
	   		break by po_vend :
	   	
	   	tmpqty1 = tmpqty1 + pod_qty_ord - pod_qty_rtnd.
	   	tmpqty2 = tmpqty2 + pod_qty_ord - pod_qty_rtnd.
	   	
	   	if last-of(po_vend) then do:
	   		create 	tvd.
	   		assign 	tvd_part = pod_part
								tvd_vend = po_vend
								tvd_vendqty = tmpqty2.
				find first tvm where tvm_part = pod_part no-error.
				if avail tvm then do:
					tvm_qty = tmpqty1.
				end.
				else do:
					create 	tvm.
					assign 	tvm_part = pod_part.
									tvm_qty  = tmpqty1.
				end.
	   		tmpqty2 = 0.
	  	end.
	  end.
	  for each req_det where req_part = iptpart and req_user1 <> ""
	  	and req_rel_date >= iptdate1 and req_rel_date <= iptdate2 no-lock:
	  	find first tvd where tvd_part = req_part and tvd_vend = req_user1 no-error.
	  	if avail tvd then do:
	  		assign 	tvd_vendqty = tvd_vendqty + req_qty.
	  	end.
	  	else do:
	  		create 	tvd.
	  		assign 	tvd_part = req_part
	  						tvd_vend = req_user1
	  						tvd_vendqty = req_qty.
	  	end.
	  	find first tvm where tvm_part = req_part no-error.
			if avail tvm then do:
				tvm_qty = tvm_qty + req_qty.
			end.
			else do:
				create 	tvm.
				assign 	tvm_part = pod_part.
								tvm_qty  = req_qty.
			end.
	  end.
	end.
	
	tmppct = 0.
	for each vp_mstr where vp_part = iptpart and vp_vend <> "" and vp_tp_pct <> 0 no-lock by vp_tp_pct descending:
	  find first tvd where tvd_part = iptpart and tvd_vend = vp_vend no-lock no-error.
	  find first tvm where tvm_part = iptpart no-lock no-error.
	  if avail tvd and avail tvm and tvm_qty > 0 then do:
	  	if tmppct < vp_tp_pct  - tvd_vendqty / tvm_qty * 100 then do:
	  		tmppct = vp_tp_pct  - tvd_vendqty / tvm_qty * 100.
	  		optvend = vp_vend.
	  	end.
	  end.
	 	else if tmppct < vp_tp_pct then do:
	 		tmppct = vp_tp_pct.
	 		optvend = vp_vend.
	 	end.
	end.
	if optvend = "" then do:
		for each vp_mstr where vp_part = iptpart and vp_tp_pct <> 0 and vp_vend <> "" no-lock
		by vp_tp_pct descending :
			optvend = vp_vend.
			leave.
		end.
	end.
	if iptqty > 0 then do:
		find first tvd where tvd_part = iptpart and tvd_vend = optvend no-error.
		if not avail tvd then do:
			create 	tvd.
			assign 	tvd_part = iptpart
							tvd_vend = optvend
							tvd_vendqty = iptqty.
		end.
		else tvd_vendqty = tvd_vendqty + iptqty.
		
		find first tvm where tvm_part = iptpart no-error.
		if not avail tvm then do:
			create tvm.
	  	assign 	tvm_part = iptpart
	  					tvm_qty = iptqty.
	  end.
	  else tvm_qty = tvm_qty + iptqty.
	end.
	
END PROCEDURE.

PROCEDURE dispvend:
	
	for each tvd no-lock:
		disp tvd.
	end.
	
end procedure.
