{mfdeclre.i}
/**************************begin define********************************************/
define var v_pm        as char .
define var v_duedate   as date label "新交货日期" .
define var v_qty_oh like ld_qty_oh .
define var qty_rst1 like pod_qty_ord label "前次多购".
define var qty_min  like pod_qty_ord label "最小订购".
define var qty_mpq  like pod_qty_ord label "订购倍数".
define var v_lt     like pt_pur_lead label "PUR提前期".  /*xp002*/
define var v_expire as date label "此日期之后的取消" . /*xp002*/
define var v_id     as integer  .  /*xp002*/
define var vfile    as char .
define var v_qty_test  like ld_qty_oh .

define buffer xchgdet for xchg_det . 

/*1供给: 现有采购单项次清单  xpod_det : uniq index  site + part + nbr + line  */
define temp-table xpod_det
	field xpod_site      like mrp_site
	field xpod_part      like pod_part 
	field xpod_nbr       like pod_nbr 
	field xpod_line      like pod_line 	
	field xpod_qty_ord   like pod_qty_ord	
	field xpod_qty_rcvd  like pod_qty_rcvd 
	field xpod_need      as date  /*xp002*/
	field xpod_ord_date  as date  /*xp002*/
	field xpod_due_date  as date .	  /*xp002*/

/*2需求: mrp每天材料需求累计 xreq_det : create in db,  unique_index:  domain + site + part + date */
/*3.采购单交期调整讯息表 xchg_det :     create in db , unique_index: domain + site  + nbr + line + (date_to + part)*/



/******************************end define****************************************/


vfile = "pochg" 
		+ TRIM ( string(year(TODAY)) 
		+ string(MONTH(TODAY)) 
		+ string(DAY(TODAY)))  
		+ trim(STRING(TIME)) 
		+ trim(string(RANDOM(1,100))) 
		+ ".txt"  .


output to value(vfile).  /**/ 

put "start run: " string(time , "HH:MM:SS") skip  . /**/

for each xchg_det   where c_domain = global_domain :
	delete xchg_det .
end.

for each xreq_det   where xreq_domain = global_domain :
	delete xreq_det.
end.

for each xpod_det :
	delete xpod_Det .
end.

v_id = 0 . /*xp002*/

for each mrp_det no-lock use-index mrp_det 
    where mrp_domain = global_domain 
	and mrp_dataset = "wod_Det"
    break by mrp_site by mrp_dataset by mrp_part by mrp_due_date by mrp_nbr by mrp_line :
						/*with frame x with width 300 :
						disp mrp_part mrp_due_date mrp_qty 
						mrp_nbr mrp_line mrp_site with frame x .*/

	if first-of(mrp_part) then do:
		v_pm = "P" .
		find first ptp_det where ptp_domain = global_domain and ptp_site = mrp_site and ptp_part = mrp_part no-lock no-error .
		if avail ptp_det then do :
			v_pm = ptp_pm_code .
		end.
		else do:
			find first pt_mstr where pt_domain = global_domain and  pt_part = mrp_part no-lock no-error .
			if avail pt_mstr then do :
				v_pm = pt_pm_code .
			end.
			else do:
				v_pm = "P" .
			end.
		end.

		v_qty_oh = 0 .
		/*xp002 如果用ld_qty_oh,要考虑ld_stat*/
		for each in_mstr where in_domain = global_domain and  in_site = mrp_site and in_part = mrp_part no-lock :
			v_qty_oh = v_qty_oh + in_qty_oh .
		end.

	end.

	if v_pm <> "P" then next .  /*限制采购件*/

	if mrp_qty - v_qty_oh < 0  then do:
		v_qty_oh = v_qty_oh - mrp_qty.
		next .
	end.
	else do:  /*require new stocks */
		find first xreq_det where xreq_domain = global_domain and xreq_site = mrp_site 
						and xreq_part = mrp_part 
						and xreq_date = mrp_due_date 
						exclusive-lock no-error .
		if not avail xreq_det then do:
			create  xreq_det .
			assign  xreq_domain = global_domain 
					xreq_site = mrp_site 
					xreq_part = mrp_part 
					xreq_date = mrp_due_date 
					xreq_qty  = mrp_qty - v_qty_oh .
					v_qty_oh  = max(0,v_qty_oh - mrp_qty) .	
			

			/*按料件设定,计算交运日期*/
			{gprun.i  ""xxmpshp1.p""
					  "(input xreq_site ,
						input xreq_part ,
						input xreq_date ,
						input today ,
						output v_duedate)"}
			assign  xreq_date_to = v_duedate .
		end.
		else do:
			assign  xreq_qty  = xreq_qty + (mrp_qty - v_qty_oh) .
					v_qty_oh  = max(0,v_qty_oh - mrp_qty) .
		end.
	end. /*require new stocks */
end. /*for each mrp_det*/


										 
for each xreq_det no-lock break by xreq_site by xreq_part by xreq_date 
with frame abc width 300 :
disp xreq_site xreq_part xreq_date xreq_qty xreq_date_to with frame abc .    /**/
end.
put "end mrp req by detail: " string(time , "HH:MM:SS") skip(3) .  /**/	


for each xreq_det no-lock break by xreq_site by xreq_part by xreq_date_to 
	with frame ccc width 300 :
	if first-of(xreq_date_to) then v_qty_test = 0 .
	v_qty_test = v_qty_test + xreq_qty .
	if last-of(xreq_date_to) then disp xreq_site xreq_part xreq_date_to with frame ccc .    /**/
end.
put "end mrp req by dateto: " string(time , "HH:MM:SS") skip(5) .	/**/

/*xp002*/
/*seastar采购提前期+28天之后的需求,取消
v_expire = today + 28 .
for each xreq_det exclusive-lock 
	break by xreq_site by xreq_part :
	if first-of(xreq_part) then do:
		v_expire = today + 28 .
		find first pt_mstr where pt_part = xreq_part no-lock no-error .
		v_lt = if avail pt_mstr then pt_pur_lead else 0 .
		v_expire = v_expire + v_lt .
	end.

	if xreq_date > v_expire then do:
		xreq_date_to = date(01,01,year(today) + 2 ) .
	end.
end.*/
/*xp002*/



for each xreq_det where xreq_domain = global_domain exclusive-lock 
	break by xreq_site by xreq_part by xreq_date_to  :
	
	if first-of(xreq_part) then do :
		find first ptp_det where ptp_domain = global_domain 
							and ptp_site = xreq_site 
							and ptp_part = xreq_part 
		no-lock no-error .
		if avail ptp_det then do :
			qty_min = ptp_ord_min .
			qty_mpq = ptp_ord_mult .
		end.
		else do:
			find first pt_mstr where pt_domain = global_domain and pt_part = xreq_part no-lock no-error .
			if avail pt_mstr then do :
				qty_min = pt_ord_min .
				qty_mpq = pt_ord_mult .
			end.
			else do:
				qty_min = 0 .
				qty_mpq = 0 .
			end.
		end.
		qty_rst1 = 0 .

		for each xpod_det :
			delete xpod_det .
		end.
					
		for each pod_det where pod_domain = global_domain 
						and pod_site = xreq_site
						and pod_part = xreq_part
						and pod_stat = ""   
						and pod_qty_ord > 0 no-lock,
			each po_mstr where po_domain = global_domain 
						and po_nbr = pod_nbr 
						and po_stat = "" 
						and po_fsm_type = "" /*防止ReturnToSupplier PO = RTS*/
						and po_type = ""     /*防止ReturnToSupplier PO = P ;Blanketpo = B */ 
						no-lock
			break by po_ord_date by po_nbr:


			find first xpod_det where  xpod_site = pod_site
								and xpod_nbr = pod_nbr 
								and xpod_line = pod_line 
								and xpod_part = pod_part 
								exclusive-lock no-error.
			if not avail xpod_det then do:
				create  xpod_det .
				assign  xpod_site = pod_site
					xpod_nbr  = pod_nbr 
					xpod_line = pod_line 
					xpod_part = pod_part 
					xpod_need       = pod_need /*xp002*/
					xpod_ord_date   = po_ord_date /*xp002*/
					xpod_due_date   = pod_due_date /*xp002*/
					xpod_qty_ord    = pod_qty_ord 						
					xpod_qty_rcvd   = pod_qty_rcvd .
			end.

		end.

					put skip(1) "XPOD LINES :" skip .		/**/
					for each xpod_det no-lock with frame bcd width 300 :
						disp xpod_det with frame bcd .	  /**/
					end.
					put skip(3) .		  /**/		


	end. /*if first-of(xreq_part)*/

	if first-of(xreq_date_to) then v_qty_oh = 0 .

	v_qty_oh = v_qty_oh + xreq_qty .


	if last-of(xreq_date_to) then do:
		/*按MPQ,MOQ ,计算订单量*/
		{gprun.i  ""xxmpqty1.p""
				  "(input v_qty_oh ,
					input qty_rst1 ,
					input qty_min ,
					input qty_mpq ,
					output v_qty_oh , 
					output qty_rst1)"}

		/*put "REQ LINES BY date_po:   "  xreq_site "" xreq_part "" xreq_date_to "" v_qty_oh "" qty_rst1 skip .	  */	

	    if v_qty_oh > 0 then do:

		for each xpod_det exclusive-lock 
					where xpod_site = xreq_site 
					and xpod_part = xreq_part 
					break by xpod_site by xpod_part 
					by xpod_ord_date  /*xp002*/
					by xpod_need by xpod_nbr by xpod_line :

			if v_qty_oh = 0 then leave .
				if xpod_due_date <> xreq_date_to or ( xpod_qty_ord - xpod_qty_rcvd ) <> v_qty_oh then do:
					
					v_id = v_id + 1 .
					create xchg_det .
					assign  
						c_domain = global_domain 
						c_site = xpod_site 
						c_id   = v_id 
						c_nbr  = xpod_nbr 
						c_line = xpod_line 
						c_part = xpod_part 
						c_qty  = xpod_qty_ord - xpod_qty_rcvd
						c_date_from = xpod_due_date
						c_date_to =  xreq_date_to 
						c_qty_to  = xpod_qty_ord - xpod_qty_rcvd
						c_detail  = "C".	
					find first pod_det use-index pod_nbrln 
							where pod_domain = global_domain 
							and  pod_nbr = xpod_nbr 
							and pod_line = xpod_line 
					no-lock no-error .
					c_req_nbr = if avail pod_det then pod_req_nbr else "".
					c_req_line = if avail pod_det then pod_req_line else 0 .
					
					v_qty_oh = v_qty_oh - (xpod_qty_ord - xpod_qty_rcvd) .

					/*按MPQ,MOQ ,计算订单量*/
					{gprun.i  ""xxmpqty1.p""
							  "(input v_qty_oh ,
								input qty_rst1 ,
								input qty_min ,
								input qty_mpq ,
								output v_qty_oh , 
								output qty_rst1)"}					

					delete xpod_det .
					if v_qty_oh = 0 then leave .				

				end.
				else do:
					v_id = v_id + 1 .
					create xchg_det .
					assign  
						c_domain = global_domain
						c_site = xpod_site 
						c_id   = v_id 
						c_nbr  = xpod_nbr 
						c_line = xpod_line 
						c_part = xpod_part 
						c_qty  = xpod_qty_ord - xpod_qty_rcvd
						c_date_from = xpod_due_date
						c_date_to =  xpod_due_date 
						c_qty_to  = xpod_qty_ord - xpod_qty_rcvd
						c_detail  = "".	
					find first pod_det use-index pod_nbrln 
							where pod_domain = global_domain 
							and pod_nbr = xpod_nbr 
							and pod_line = xpod_line 
					no-lock no-error .
					c_req_nbr = if avail pod_det then pod_req_nbr else "".
					c_req_line = if avail pod_det then pod_req_line else 0 .
					
					v_qty_oh = 0 .
					delete xpod_det .
					if v_qty_oh = 0 then leave .					
				end.

		end. /*for each xpod_det */
	    end. /*if v_qty_oh > 0 then do:*/		
	end. /*if last-of(xreq_date_to) */
	
	if last-of(xreq_part) then do:
		/*取消剩下的无需求部分pod*/
		for each xpod_det where xpod_site = xreq_site 
			and xpod_part = xreq_part 
			and xpod_qty_ord > 0 exclusive-lock :

			v_id = v_id + 1 .  
			create xchg_det .
			assign  
				c_domain = global_domain 
				c_site = xpod_site  
				c_id   = v_id 
				c_nbr  = xpod_nbr 
				c_line = xpod_line 
				c_part = xpod_part 
				c_qty  = xpod_qty_ord - xpod_qty_rcvd
				c_date_from = xpod_due_date  /*xp002*/
				c_date_to =  xpod_due_date
				c_qty_to  = xpod_qty_ord - xpod_qty_rcvd
				c_detail  = "X" .
			find first pod_det use-index pod_nbrln 
						where pod_domain = global_domain 
						and pod_nbr = xpod_nbr 
						and pod_line = xpod_line 
			no-lock no-error .
			c_req_nbr = if avail pod_det then pod_req_nbr else "".
			c_req_line = if avail pod_det then pod_req_line else 0 .
		end.
	end. /*if last-of(xreq_part) */
	
end. /*for each xreq_det*/


for each xreq_det where xreq_domain = global_domain exclusive-lock :
	delete xreq_det.
end.


/*xp002*/
/*MRP无需求的pod,有需求但库存就足够的, 也show在拆分计划*/
		for each po_mstr where po_domain = global_domain 
						and po_stat = "" 
						and po_fsm_type = "" /*防止ReturnToSupplier PO = RTS*/
						and po_type = ""     /*防止ReturnToSupplier PO = P ;Blanketpo = B */ 
						no-lock,
			each pod_det where pod_domain = global_domain 
						and pod_nbr = po_nbr 
						and pod_stat = ""   
						and pod_qty_ord > 0
						no-lock :
			find first xchg_det 
					where c_domain = global_domain 
					and c_site = pod_site 
					and c_nbr = pod_nbr 
					and c_line = pod_line 
					and c_part = pod_part 
			no-lock no-error .
			if avail xchg_det then next .
			else do: /*not avail xchg_Det*/
				find first mrp_Det 
						where mrp_domain = global_domain 
						and mrp_dataset = "wod_det" 
						and mrp_site = pod_site 
						and mrp_part = pod_part 
				no-lock no-error .
				if not avail mrp_det then do: /*MRP无需求*/
							
							v_id = v_id + 1 .  
							create xchg_det .
							assign  
								c_domain = global_domain 
								c_site = pod_site 
								c_id   = v_id 
								c_nbr  = pod_nbr 
								c_line = pod_line 
								c_part = pod_part 
								c_qty  = pod_qty_ord  - pod_qty_rcvd
								c_date_from = pod_due_date
								c_date_to =   pod_due_date
								c_qty_to  = pod_qty_ord - pod_qty_rcvd
								c_detail  = "X"
								c_req_nbr = pod_req_nbr 
								c_req_line = pod_req_line .
				end.  /*MRP无需求*/
				else do: /*有需求但库存就足够*/
							v_id = v_id + 1 .   
							create xchg_det .
							assign  
								c_domain = global_domain 
								c_site = pod_site 
								c_id   = v_id 
								c_nbr  = pod_nbr 
								c_line = pod_line 
								c_part = pod_part 
								c_qty  = pod_qty_ord - pod_qty_rcvd
								c_date_from = pod_due_Date
								c_date_to =   pod_due_date
								c_qty_to  = pod_qty_ord  - pod_qty_rcvd
								c_detail  = "X"
								c_req_nbr = pod_req_nbr 
								c_req_line = pod_req_line .
				end. /*有需求但库存就足够*/
			end. /*not avail xchg_Det*/
		end .  /*for each po_mstr ,pod_det*/



/*xp002*/


for each xchg_det no-lock 
	break by xchg_det.c_site by xchg_det.c_part by xchg_det.c_nbr by xchg_det.c_line
	with frame xx with width 300:
	   disp xchg_det.c_site 
			xchg_det.c_part 
			xchg_det.c_nbr 
			xchg_det.c_line
			xchg_det.c_detail	
			xchg_det.c_date_to 				
			xchg_det.c_qty_to
			xchg_det.c_qty  
			xchg_det.c_date_from 
			xchg_det.c_req_nbr 
			xchg_det.c_req_line
			with frame xx . 
			if last-of(xchg_det.c_part) then down 1 .
end.   /**/



put skip(3) "end run : " string(time , "HH:MM:SS") .   /**/
output close .	  /**/	





