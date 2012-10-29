{mfdtitle.i "20121009"}
define variable duedate like po_due_date.
define variable duedate1 like po_due_date.
define variable site like pt_site label "地点".
define variable site1 like pt_site label "地点".
define variable prodline like pt_prod_line label "产品线".
define variable prodline1 like pt_prod_line label "至".
define variable costset like cost_set.
define variable mon like glc_per label "会计期间".
define variable startdate like glc_start.
define variable enddate like glc_end.
define variable i as int initial 1.

DEF VAR h-tt AS HANDLE.
DEFINE VAR inp_where     AS CHAR.
DEFINE VAR inp_sortby    AS CHAR.
DEFINE VAR inp_bwstitle  AS CHAR.
DEF    VAR      v_list AS CHAR INITIAL "".

define temp-table xx
field xxpart like pt_part
field xxdesc like pt_desc1
field xxvend like prh_vend
field sum1	 as decimal extent 12 initial [0,0,0,0,0,0,0,0,0,0,0,0]
field sum2   as decimal extent 12 initial [0,0,0,0,0,0,0,0,0,0,0,0].

define temp-table yyyy
field yypart like pt_part
field yydesc like pt_desc1
field yyvend like prh_vend
field yyplan1 as decimal label "一月份计划量"
field yyhist1 as decimal label "一月采购收货量"
field yyplan2 as decimal label "二月份计划量"
field yyhist2 as decimal label "二月采购收货量"
field yyplan3 as decimal label "三月份计划量"
field yyhist3 as decimal label "三月采购收货量"
field yyplan4 as decimal label "四月份计划量"
field yyhist4 as decimal label "四月采购收货量"
field yyplan5 as decimal label "五月份计划量"
field yyhist5 as decimal label "五月采购收货量"
field yyplan6 as decimal label "六月份计划量"
field yyhist6 as decimal label "六月采购收货量"
field yyplan7 as decimal label "七月份计划量"
field yyhist7 as decimal label "七月采购收货量"
field yyplan8 as decimal label "八月份计划量"
field yyhist8 as decimal label "八月采购收货量"
field yyplan9 as decimal label "九月份计划量"
field yyhist9 as decimal label "九月采购收货量"
field yyplan10 as decimal label "十月份计划量"
field yyhist10 as decimal label "十月采购收货量"
field yyplan11 as decimal label "十一月份计划量"
field yyhist11 as decimal label "十一月采购收货量"
field yyplan12 as decimal label "十二月份计划量"
field yyhist12 as decimal label "十二月采购收货量".



form
site	colon 15	site1	 colon 50
prodline colon 15	prodline1 colon 50
mon		colon 15
with frame a side-labels width 80  .
/*setframelabels(frame a:handle).*/

repeat:
	
	for each xx:
		delete xx.
	end.

	for each yyyy:
		delete yyyy.
	end.

	find first glc_cal where glc_domain = global_domain and glc_start <= today and today <= glc_end 
						and glc_year = year(today)
						no-lock no-error.
		mon = glc_per.
		
	display mon with frame a.
	
	/*if duedate = low_date then duedate = ?.
	if duedate1 = hi_date then duedate1 = ?.*/
	if site1 = hi_char then site1 = "".
	if prodline1 = hi_char then prodline1 = "".
	
	update	
			site
			site1
			prodline
			prodline1
			mon
			with frame a.

	/*if duedate = ? then duedate = low_date.
	if duedate1 = ? then duedate1 = hi_date.*/
	if site1 = "" then site1 = hi_char.
	if prodline1 = "" then prodline1 = hi_char.
	
	do i = 1 to mon:
			startdate = ?.
			enddate = ?.
		find first glc_cal where glc_domain = global_domain and glc_per = i and glc_year = year(today)
							  no-lock no-error.
			if available glc_cal then do:
				startdate = glc_start.
				enddate = glc_end.
			end.
			else do:
				message "错误：会计区间未定义" view-as alert-box.
					undo,retry.
			end.


		for each prh_hist where prh_hist.prh_domain = global_domain
							and startdate <= prh_rcp_date and prh_rcp_date <= enddate
							and site <= prh_site and prh_site <= site1
							no-lock:

			find first pt_mstr where pt_mstr.pt_domain = global_domain
								and pt_part = prh_part and pt_prod_line >= prodline and pt_prod_line <= prodline1 no-lock no-error.		
				IF not available pt_mstr then next.
											
			find first xx where xxpart  = prh_part no-lock no-error.
				if not available xx then do:
					create xx.
						xxpart = prh_part.
						xxvend = prh_vend.
						sum2[i] = prh_rcvd.
						xxdesc = pt_desc1.
				end.
				else do:					
					sum2[i] = sum2[i] + prh_rcvd.
				end.

		end. /*for each prh_hist*/

		for each po_mstr where po_domain = global_domain
							and startdate <= po_due_date and po_due_date <= enddate 
							no-lock:

			if po_sched = yes then do:
				/******************************************
				for each scx_ref where scx_order = po_nbr and scx_domain = global_domain no-lock:
					find first pt_mstr where pt_part = scx_part and pt_domain = global_domain
										and prodline <= pt_prod_line and pt_prod_line <= prodline1
										no-lock no-error.
						if not available pt_mstr then next.
						for each sch_mstr where sch_nbr = scx_order and sch_domain = global_domain no-lock:
							find last schd_det where schd_nbr = sch_nbr and schd_domain = global_domain
												and startdate <= schd_date and schd_date <= enddate
												no-lock no-error.
								if available schd_det then do:
									find first xx where xxpart = scx_part no-lock no-error.
										if available xx then do:										
											sum1[i] = sum1[i] + schd_upd_qty.
										end.

										else do:
											create xx.
													xxpart = pt_part.
													xxdesc = pt_desc1.	
													xxvend = scx_shipfrom.
													sum1[i] = schd_upd_qty.
													
										end.			
								end. /*if available schd_det then do*/
								else do:
									next.
								end.
						end. /*for each sch_mstr*/
				end. /*for each scx_ref */   
				*************************************************/

				for each scx_ref where scx_domain = global_domain and scx_order = po_nbr  no-lock:	
					for each sch_mstr where sch_mstr.sch_domain = global_domain no-lock,
						each schd_det where schd_domain = global_domain
						and schd_type = sch_type
						and schd_nbr = sch_nbr
						and schd_line = sch_line
						and schd_rlse_id = sch_rlse_id						
						and startdate <= schd_date and schd_date <= enddate
						no-lock:

							find first pt_mstr where pt_domain = global_domain and pt_part = scx_part 
											and prodline <= pt_prod_line and pt_prod_line <= prodline1
											no-lock no-error.
								if not available pt_mstr then next.
							
							find first pod_det where pod_det.pod_domain = global_domain
												and pod_nbr = sch_nbr and pod_line = sch_line 
												and pod_curr_rlse_id[(sch_type - 3)] = sch_rlse_id no-lock no-error.
							if available pod_det then do:
								find first xx where xxpart = scx_part no-lock no-error.
									if available xx then do:										
										sum1[i] = sum1[i] + schd_upd_qty.
									end.

									else do:
										create xx.
												xxpart = pt_part.
												xxdesc = pt_desc1.	
												xxvend = scx_shipfrom.
												sum1[i] = schd_upd_qty.
												
									end.
							
							end. /*if available pod_det then do*/
					end. /*for each sch_mstr*/
				end. /*for reach scx_ref */


			end. /*if po_sched = yes then do*/  
			
			else do:
				for each pod_det  where pod_det.pod_domain = global_domain
									and pod_nbr = po_nbr
									and site <= pod_site and pod_site <= site1
									no-lock:

					find first pt_mstr where pt_domain = global_domain
										and prodline <= pt_prod_line and pt_prod_line <= prodline1 
										and pt_part = pod_part
										 
										no-lock no-error.

						if not available pt_mstr then next.

					 find first xx where xxpart = pod_part no-lock no-error. 
						if available xx then do:					
							sum1[i] = sum1[i] + pod_qty_ord.
						end.
						if not available xx then do:
							create xx.
								xxpart = pt_part.
								xxdesc = pt_desc1.	
								xxvend = po_vend.
								sum1[i] = pod_qty_ord.
						end.

				end. /*for each pod_det */
			end. /*else do*/ 
		end. /*for each po_mstr*/


	end. /*do i = 1 to mon*/


for each xx:
	create yyyy.
		assign
			yypart = xxpart
			yydesc = xxdesc
			yyvend = xxvend
			yyplan1 = sum1[1]
			yyhist1 = sum2[1]
			yyplan2 = sum1[2]
			yyhist2 = sum2[2]
			yyplan3 = sum1[3]
			yyhist3 = sum2[3]
			yyplan4 = sum1[4]
			yyhist4 = sum2[4]
			yyplan5 = sum1[5]
			yyhist5 = sum2[5]
			yyplan6 = sum1[6]
			yyhist6 = sum2[6]
			yyplan7 = sum1[7]
			yyhist7 = sum2[7]
			yyplan8 = sum1[8]
			yyhist8 = sum2[8]
			yyplan9 = sum1[9]
			yyhist9 = sum2[9]
			yyplan10 = sum1[10]
			yyhist10 = sum2[10]
			yyplan11 = sum1[11]
			yyhist11 = sum2[11]
			yyplan12 = sum1[12]
			yyhist12 = sum2[12].

end.

    h-tt = TEMP-TABLE yyyy:HANDLE.
    RUN value(lc(global_user_lang) + "\yy\yytoexcel.p") (INPUT TABLE-HANDLE h-tt, INPUT inp_where, INPUT inp_sortby, INPUT v_list, INPUT inp_bwstitle).        

	empty temp-table yyyy.

end. /*REPEAT */