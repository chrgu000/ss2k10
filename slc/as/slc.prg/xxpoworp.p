/* By: Neil Gao Date: 20071221 ECO: *ss 20071221 * */

	{mfdtitle.i "b+ "}

define variable part like mrp_part.
define variable part2 like mrp_part.
define variable date1 as date.
define variable date2 as date.
define variable loc like tr_loc.
define variable loc1 like tr_loc.
define variable buyer like pt_buyer.
define variable sonbr like so_nbr.
define variable vend  like po_vend.
define variable expert as logical.
define variable tmpqty1 like pod_qty_ord.
define variable tmpqty2 like pod_qty_ord.

define buffer womstr for wo_mstr.
define buffer ptmstr for pt_mstr.

define temp-table xxtb
	field xxtb_nbr  like wo_nbr
	field xxtb_vend like po_vend
	field xxtb_part like pt_part
	field xxtb_qty  like tr_qty_loc.
	 
form
	 date1										colon 15
	 date2										colon 45
   part                     colon 15
   part2 label {t001.i}     colon 45 
   buyer                    colon 15
   skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


form
	wo_nbr 
	wo_lot
	wo_so_job
	vend
	ad_name
	expert label "×¨Åú"
	wo_part
	pt_desc1 
	wo_qty_ord
	wo_rel_date
	wo_due_date
with frame c down width 200 .

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

buyer = global_userid.


	{wbrp01.i}
	REPEAT ON ENDKEY UNDO, LEAVE:

   if part2 = hi_char then part2 = "".
   if date1 = low_date then date1 = ?.
   if date2 = hi_date  then date2 = ?.
   
		IF c-application-mode <> 'web':u THEN
	   update
	   	date1 date2
      part part2
      buyer
			WITH FRAME a.

		  if part2 = "" then part2 = hi_char.
		  if date1 = ? then  date1 = low_date.
		  if date2 = ? then date2 = hi_date.
			
    {mfselprt.i "printer" 132}

		empty temp-table xxtb.

		for each wo_mstr where wo_domain = global_domain and wo_part >= part and wo_part <= part2 
			and wo_due_date >= date1 and wo_due_date <= date2 no-lock,
			each pt_mstr where pt_domain = global_domain and pt_part = wo_part and pt_pm_code = "P"
			and (pt_buyer = buyer or buyer = "" ) no-lock by wo_part:
			
			vend = "".
			sonbr = wo_so_job.
			expert = no.
			for each womstr where womstr.wo_domain = global_domain and womstr.wo_lot = wo_mstr.wo_nbr no-lock,   
				each sod_det where sod_domain = global_domain and sod_nbr = womstr.wo_so_job and string(sod_line,"999") = 
          substring(womstr.wo_nbr,length(womstr.wo_nbr) - 2,3) no-lock,
        each xxsob_det where xxsob_domain = global_domain and xxsob_nbr = sod_nbr 
          and xxsob_line = sod_line and xxsob_part = wo_mstr.wo_part no-lock:
        
        assign vend = xxsob_user1 
        			 expert = (xxsob_user2 <> "").
       
			end.
			if vend = "" then do:
				
				for each vp_mstr where vp_domain = global_domain and vp_part = wo_part no-lock  by vp_tp_pct descending :
        	tmpqty1 = 0.
        	tmpqty2 = 0.
        	for each pod_det where pod_domain = global_domain and pod_part = wo_part
        			and pod_per_date >= date( month(today),1,year(today)) 
        			and pod_per_date < if month(today) <> 12 then date(month(today) + 1,1,year(today))
        																							 else	date(1,1,year(today) + 1)
        			no-lock,
        		each po_mstr where po_domain = global_domain and po_nbr = pod_nbr no-lock:
        		if po_vend = vp_vend then 
        			assign
        				tmpqty1 = tmpqty1 + pod_qty_ord - pod_qty_rcvd
        				tmpqty2 = tmpqty2 + pod_qty_ord - pod_qty_rcvd.
        		else 
        			assign
        				tmpqty2 = tmpqty2 +  pod_qty_ord - pod_qty_rcvd.
        	end.
        	
        	for each req_det where req_domain = global_domain and req_part = wo_part
        		and req_rel_date >= date( month(today),1,year(today)) 
        		and req_rel_date < if month(today) <> 12 then date(month(today) + 1,1,year(today))
        																						 else date(1,1,year(today) + 1)
        		no-lock:
        		if req_user1 = vp_vend then
        			assign
        				tmpqty1 = tmpqty1 + req_qty
        				tmpqty2 = tmpqty2 + req_qty.
        		else assign
        				tmpqty2 = tmpqty2 + req_qty.
        			
        	end.
        	
        	for each xxtb where xxtb_part = wo_part  no-lock:
        		if xxtb_vend = vp_vend then 
        			assign tmpqty1 = tmpqty1 + xxtb_qty
        						 tmpqty2 = tmpqty2 + xxtb_qty.
        	  else assign tmpqty2 = tmpqty2 + xxtb_qty.
        	end.	
        	
        	if tmpqty1 <= tmpqty2 * vp_tp_pct / 100 then do:
        		vend = vp_vend.
        		leave.
        	end.
        	
        end. /* for each */
			
			end.
			
			if vend <> "" then do:
      	create xxtb.
      	assign xxtb_nbr  = wo_nbr
      	       xxtb_vend = vend
      				 xxtb_part = wo_part
      				 xxtb_qty  = wo_qty_ord.
      end.
      find first ad_mstr where ad_domain = global_domain and ad_addr = vend no-lock no-error.
      find first vp_mstr where vp_domain = global_domain and vp_part = wo_part and vp_vend = vend no-lock no-error.
      
			disp wo_nbr 
					 wo_lot 
					 wo_so_job 
					 vend  
					 ad_name  when ( avail ad_mstr )
					 expert  
					 wo_part 
					 pt_desc1
					 vp_vend_part when ( avail vp_mstr )
					 wo_qty_ord 
					 wo_rel_date
					 wo_due_date with frame c.
			down with frame c.
			
			find first cd_det where cd_domain = global_domain and cd_ref = wo_part 
      	and cd_lang = 'ch' no-lock no-error.
      if avail cd_det then do:
      	put unformat "    " cd_cmmt[1].
      	for first ptmstr where ptmstr.pt_domain = global_domain and ptmstr.pt_part = substring(cd_cmmt[1],1,4) no-lock:
					put "    "  ptmstr.pt_desc1 .
				end.
				put skip.
			end.
			
		end.
		
		{mfreset.i}
		{mfgrptrm.i}
		

	END.

	{wbrp04.i &frame-spec = a}

    