/* By: Neil Gao Date: 07/11/24 ECO: * ss 20071124 * */


/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}
{mf1.i}
{gplabel.i} 

define new shared workfile pkdet no-undo
   field pkpart like ps_comp
   field pkop as integer  format ">>>>>9"
   field pkstart like pk_start
   field pkend like pk_end
   field pkqty like pk_qty
   field pkbombatch like bom_batch
   field pkltoff like ps_lt_off.

define temp-table xuld_det
	field xuld_site like ld_site
	field xuld_part like pt_part
	field xuld_qty_oh like ld_qty_oh
	field xuld_qty_all like ld_qty_all
	field xuld_qty_pick like ld_qty_all
	field xuld_qty_ic		like ld_qty_all
	index xuld_part
	xuld_site
	xuld_part.

define temp-table xulad_det
	field xulad_site like ld_site
	field xulad_priority like xxseq_priority
	field xulad_part like pt_part
	field xulad_nbr  like wo_lot
	field xulad_qty_all like ld_qty_all
	field xulad_qty_pick like ld_qty_oh
	field xulad_ii like xxseq_priority
	index xulad_priority
	xulad_site
	xulad_priority.

PROCEDURE initld:
   empty temp-table xuld_det.
   empty temp-table xulad_det.
END PROCEDURE.  /* ip-validate */


PROCEDURE createld:
		
		define input  parameter iptsite  like in_site.
		define input  parameter iptwolot like wo_lot.
		define input  parameter iptreqqty as deci.
		define input	parameter iptwodqty as deci.
		define input  parameter iptseqii  as deci.
		define input  parameter iptpriority as deci.
		define output parameter optpickqty as deci.
		define output parameter optpickrmks as char.
		define var tmpqty 	as deci.
		define var tmpqty1 	as deci.
		define var tmpqty2 	as deci.
		define var tmpqty3  as deci.
		define var tmppick 	as deci.
		
		tmppick = 999999.
		tmpqty1 = 0.
   	tmpqty2 = 0.
   	tmpqty3 = 0.
   	
   	   	
/*SS 20080313 - B*/
		find first wo_mstr where wo_domain = global_domain and wo_lot = iptwolot no-lock no-error.
		if not avail wo_mstr or wo_status = "R" or wo_status = "C" then leave.
/*SS 20080313 - E*/
   	
   	for each pkdet :	delete pkdet.	end.
   	
   	{gprun.i ""xxwobmfj.p""  "(
    						input wo_part,
    						input today,
    						input wo_site )"}
   	
/*SS 20081105 - B*/
/*   	
		for each wod_det where wod_domain = global_domain and wod_lot = iptwolot 	no-lock:
*/
/*SS 20081105 - E*/   		
   	for each pkdet where (pkstart = ? or pkstart <= today ) and
			(pkend = ? or pkend >= today ) no-lock,
			each pt_mstr where pt_domain = global_domain and pt_part = pkpart  and pt_pm_code = "P" no-lock:
				
   		find first xuld_det where	xuld_site = iptsite and xuld_part = pkpart no-error.
   		if not avail xuld_det then do:
   			tmpqty = 0.
   			tmpqty3 = 0.
/*SS 20080313 - B*/
/*
   			for each ld_det where ld_domain = global_domain and ld_site = iptsite
   				and ld_part = pkpart no-lock :
   				if ld_status begins "Y" then
   					tmpqty = tmpqty + max(ld_qty_oh - ld_qty_all,0).
   				else if ld_status = "N-Y-N" then
   					tmpqty3 = tmpqty3 + max(ld_qty_oh - ld_qty_all,0).
   			end.
*/
   			for each ld_det where ld_domain = global_domain and ld_site = iptsite
   				and ld_part = pkpart and ld_qty_oh <> 0 no-lock:
   				if ld_status begins "Y" then do:
   					tmpqty = tmpqty + max(ld_qty_oh,0).
						for each lad_det use-index lad_site
							where lad_domain = global_domain and lad_site = ld_site and lad_loc = ld_loc
							and lad_part = pkpart and lad_dataset = "wod_det" and lad_qty_pick > 0 
							and lad_lot = ld_lot and lad_ref = ld_ref no-lock:
							tmpqty = tmpqty - lad_qty_pick.
						end.
					end.
   				else if ld_status = "N-Y-N" then
   					tmpqty3 = tmpqty3 + max(ld_qty_oh,0).
   			end.
				tmpqty = max(tmpqty,0).
/*SS 20080313 - E*/
   			create xuld_det.
   			assign xuld_site = iptsite
   					 xuld_part = pkpart
   					 xuld_qty_oh = tmpqty
   					 xuld_qty_ic = tmpqty3.
   		end.
   						
   		create xulad_det.
   		assign xulad_site = iptsite
   				 xulad_part = pkpart
   				 xulad_nbr = iptwolot
   				 xulad_qty_all = truncate(wo_qty_ord * pkqty * iptreqqty / iptwodqty,0)
   				 xuld_qty_all = xulad_qty_all
   				 xulad_ii  = iptseqii
   				 xulad_priority = iptpriority.
   						
   		if xuld_qty_oh - xuld_qty_pick > 0 then
   		assign 	xulad_qty_pick = min(xuld_qty_oh - xuld_qty_pick,xulad_qty_all)
   						/*xuld_qty_pick = xuld_qty_pick + xulad_qty_pick*/ .
   						
   		if pkqty <> 0 then
   			tmppick = min(tmppick,xulad_qty_pick / pkqty).
   		else tmppick = min(tmppick,xulad_qty_pick).
   		if xulad_qty_all > xulad_qty_pick then 
   			assign 	tmpqty1 = tmpqty1 + 1
   							tmpqty2 = tmpqty2 + xulad_qty_all - xulad_qty_pick.
   						
   	end. /*for each pkdet*/
		if tmppick = 999999 then tmppick = 0.
			optpickqty = tmppick.
		if tmpqty1 > 0 then 
   		optpickrmks = string(tmpqty1) + "/" + string(tmpqty2).
   	else optpickrmks = "".
   	if tmppick > 0 then do:
   		for each pkdet no-lock:
   			for each xuld_det where xuld_site = iptsite and xuld_part = pkpart no-lock:
   				
   					xuld_qty_pick = xuld_qty_pick + tmppick * pkqty.
   					
   			end.
   		end.
   	end.
   	
   	
END PROCEDURE.


procedure displd:
	
	define input parameter iptsite like in_site.
	define input parameter iptseqii as deci.
	
	
	form 
		xuld_part      column-label "物料号"
		pt_desc1       column-label "名称"
		xuld_qty_oh    column-label "可用库存"  format "->>>>>>"
		xuld_qty_ic   column-label "待检量" format "->>>>>>>"
		xulad_qty_all  column-label "需备料" format "->>>>>>" 
		xulad_qty_pick column-label "已备料" format "->>>>>>"
		pt_pur_lead    column-label "采购"	format ">>>>"
	with frame e overlay down no-attr-space row 10 width 80.
	setFrameLabels(frame e:handle).
	
	clear frame e all no-pause.
  for each xulad_det where xulad_site = iptsite and xulad_ii = iptseqii 
  	and xulad_qty_all > xulad_qty_pick no-lock,
     	each xuld_det where xuld_site = iptsite and xuld_part = xulad_part no-lock,
     	each pt_mstr  where pt_domain = global_domain and pt_part = xuld_part no-lock:
     	disp xuld_part xuld_qty_oh xuld_qty_ic xulad_qty_all xulad_qty_pick pt_desc1 format 'x(18)' pt_pur_lead with frame e.
     	down 1 with frame e.
  end.
  pause.
  hide frame e no-pause.
  
end procedure.