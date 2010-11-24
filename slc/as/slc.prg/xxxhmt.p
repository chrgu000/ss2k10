/* SS - 090530.1 By: Neil Gao */

{mfdtitle.i "090520.1"}

define var sonbr like so_nbr.
define var soline like sod_line.
define var xxnbr like so_nbr.
define var xxqty like sod_qty_ord.
define var xxqty1 like sod_qty_ord.
define var xxqty2 as int.
define var xxid  as char format "x(18)".
define var xxid1 like xxid.
define var tqty01 like sod_qty_ord.
define var i as int.
define var j as int.
define var k as int.
define var tid as char.
define var effdate as date init today.

form
	sonbr   colon 25
	skip(1) 
	xxnbr   colon 25 label "客户订单"
	xxqty   colon 25 label "订单数量"
	xxqty1  colon 25 label "已产生数量"
	xxqty2  colon 25 label "需产生数量"
	skip(1)
	xxid   colon 25 label "箱号"
	xxid1  colon 25 label "条码号"
with frame a side-label width 80 .

setFrameLabels(frame a:handle).
	
mainloop:
repeat:
	
	update sonbr with frame a.
	
	find first sod_det where sod_domain = global_domain and sod_nbr = sonbr no-lock no-error.
	if not avail sod_det then do:
		message "错误: 销售订单不存在".
		next.
	end.
	find first so_mstr where so_domain = global_domain and so_nbr = sonbr no-lock no-error.
	
	xxnbr = so__chr03.
	if xxnbr = "" then xxnbr = sonbr.
	
	tqty01 = 0.
	xxid = "".
	xxid1 = "".
	for each xxxh_det where xxxh_domain = global_domain and xxxh_nbr = sonbr no-lock:
		tqty01 = tqty01 + 1.
		xxqty = sod_qty_ord.
		xxid = xxxh_id.
		xxid1 = xxxh_id1.		
	end.
	xxqty1 = tqty01.
	
	xxqty = 0.
	for each sod_det where sod_domain = global_domain and sod_nbr = sonbr no-lock:
		xxqty = xxqty + sod_qty_ord.
	end.
	xxqty2 = max(xxqty - xxqty1,0).
	
	disp xxnbr xxqty xxqty1 xxqty2 xxid xxid1 with frame a.
	
	loop1:
	repeat:
		
		update xxqty2 with frame a.
		
		if xxqty2 + xxqty1 > xxqty then do:
			message "错误:数量超过范围".
			next.
		end.
		
		do i = 1 to xxqty2 :
			
			find last xxxh_det where xxxh_domain = global_domain and xxxh_nbr = sonbr  no-lock no-error.
			if not avail xxxh_det then do:
				j = 1.
			end.
			else do:
				j = int(substring(xxxh_id,11)) + 1.
			end.
			
			tid = "74" + substring(string(year(effdate)),3,2) + string(month(effdate),"99").
			find last xxxh_det use-index xxxh_id1
				where xxxh_domain = global_domain and xxxh_id1 begins tid no-lock no-error.
			if not avail xxxh_det then do:
				k = 1.
			end.
			else do:
				k = int(substring(xxxh_id1,7)) + 1.
			end.
			tid = tid + string(k,"9999999").
			
			create xxxh_det.
			assign xxxh_domain = global_domain
						 xxxh_nbr = sonbr
						 xxxh_id  = caps(xxnbr) + "*" +  string(j,"99999")
						 xxxh_id1 = tid
						 xxxh_date = today
						 xxxh_qty = 1
						 .
			xxid = xxxh_id.
			xxid1 = xxxh_id1.
			
			xxqty1 = xxqty1 + 1.
			
			disp xxid xxid1 xxqty1 xxqty2 with fram a.
			
		end.
		
		leave.
	end.
	
end.	/* mainloop */
