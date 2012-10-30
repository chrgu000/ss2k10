		/* xxppifiosh.p */
		define variable current_cursor as integer.
		/* SCHEDULE OUTPUT xxppifiosh.p */
		find first code_mstr no-lock where code_fldname = "PPIF_SCHEDULE" no-error.   /*Get filename Noted by MJH007*/
		if not available code_mstr then do:
			find last xxppif_log no-lock no-error.
			trid = if available xxppif_log then (xxppif_tr_id + 1) else 1.
			create xxppif_log.
			assign 	xxppif_tr_id 	= trid
					xxppif_act_date	= today
					xxppif_act_time	= string(time, "HH:MM:SS")
					xxppif_err		= 2
					xxppif_msg		= "CODE_MSTR NOT DEFINE PPIF_SCHEDULE"
					xxppif_tr_code	= "XSYS".
			leave.
		end.
		else do:
			filename = trim(code_value).
			filepath = trim(code_cmmt).
			sourcename = trim(code_cmmt) + "\" + trim(code_value).
		end.		

		output stream batchdata to value(sourcename) no-echo.	

		/*for each rps_mstr no-lock where rps_due_date >= today and rps_due_date <= (today + MAX_LT): 09-04-20*/
		for each rps_mstr no-lock where rps_due_date = (today + SCD_DAY):
			/*2004-9-29 11:01*/
			find first pt_mstr where pt_part = rps_part no-lock no-error.
			if not available pt_mstr then next.
			
			if pt_part_type <> "58" then next. /*if pt_group <> "58" then next.MJH007 by weihua's logical */
			/*2004-9-29 11:08*/			
			
			find first ptp_det no-lock where ptp_part = rps_part and ptp_site = rps_site no-error.
			if not available ptp_det then next. /* IN DCEC, ALL ITEM SHOULD MAINT WITH SITE-PLAN*/
			/*bld_date = rps_due_date - ptp_mfg_lead.  /*上线日期  remarked by MJH007 缓冲期*/
			if (bld_date > today + SCD_DAY) or bld_date < today then next.  09-04-20*/
                        bld_date = rps_due_date.
			old_qty = 0.
			for each xxppif_log no-lock where xxppif_part = rps_part 
			and xxppif_bld_date = bld_date:
				old_qty = old_qty + xxppif_qty_chg.
			end.
			/* QTY CHANGED, OR ADDED TO SCHEDULE*/
			if rps_qty_req - old_qty <> 0 then do:
				find last xxppif_log no-lock no-error.
				trid = if available xxppif_log then (xxppif_tr_id + 1) else 1.
				create xxppif_log.
				assign 	xxppif_tr_id 	= trid
						xxppif_act_date	= today
						xxppif_act_time	= string(time, "HH:MM:SS")
						xxppif_tr_code	= "XSCD"
						xxppif_part 	= rps_part
						xxppif_bld_date = bld_date
						xxppif_qty_chg	= rps_qty_req - old_qty.
			end.
			
			if rps_qty_req - old_qty > 0 then do:  /*MJH007 2005-01-22 16:16*/
			   /*when qty_req is changed and changed qty > 0 */
			   iDay = bld_date - date(1,1,year(bld_date)) + weekday(date(1,1,year(bld_date))) + 5.
			   dWeek = 100 + iDay / 7.
			   strbldday = substring(string(year(bld_date)),3,2) + 
			               substring(string(dWeek),2,2) + 
			               string(weekday(bld_date - 1)).
			   if rps_qty_req > 99999 then do:
			      find last xxppif_log no-lock no-error.
				  trid = if available xxppif_log then (xxppif_tr_id + 1) else 1.
				  create xxppif_log.
				  assign 	xxppif_tr_id 	= trid
							xxppif_act_date	= today
							xxppif_act_time	= string(time, "HH:MM:SS")
							xxppif_tr_code	= "XSCD"
							xxppif_err		= 2
							xxppif_qty_chg	= rps_qty_req
							xxppif_msg		= "Qty is large than 99999".
			      next.
			   end.			
			   /*sQty = string(100000 + rps_qty_req). MJH007*/
			   sQty = string(100000 + rps_qty_req - old_qty).
			   sQty = substring(sQty,2,5).	
			   do while (integer(sQty) > 0) :
			      
				  find last xxppifla_un  where xxppifla_so = rps_part no-error.
				  if available xxppifla_un then do:
				     assign xxppifla_un = xxppifla_un + 1.
				  end.
				  else do:
				     create xxppifla_un.
				     assign xxppifla_so = rps_part
				            xxppifla_un = 1.
				  end. 
				  
				  /*Create xxppiftr_un history record*/
				  create xxppiftr_un.
				  assign xxppiftr_so = rps_part
				         xxppiftr_bd = rps_due_date
				         xxppiftr_flag = yes
				         xxppiftr_un = xxppifla_un.
				  
				  put stream batchdata 
				  rps_part at 1 format "x(11)"	/* SO	11	*/			
				  "  " 							/* Filler	2		SPACES*/
				  "58"							/* ID CODE	2		58*/
			      strbldday						/* Explosion Date	5	*/	
				  strbldday						/* Build Start Date	5	*/	
				  "00001"  /*sQty MJH007 2005-01-22 16:55							/* Quantity	5		*/*/
				  substring(string(xxppiftr_un,"99999"),2,4) format "9999"  /*"0001" MJH007		*/					/* Beginning unit number	4		*/
				  substring(string(xxppiftr_un,"99999"),2,4) format "9999"  /*"0001" MJH007		*/					/* End unit number	4		*/
				  "00"							/* Explosion Level Number	2		0*/
				  "      "						/* Report Selection Code	6		Spaces*/
				  "  "							/* Transaction Code	2		Spaces*/
/*				   1234567890123456789012345*/
				  "                         "		/* Filler	25		Spaces*/
				  "10"							/* Record Type Report	2		10*/
				  "EC"							/* System ID	2		EC*/
				  "00"							/* Record Type Code	2		0*/
				  "              "				/* Filler	14		Spaces*/
/*				   1234567890123456789012345*/
				  "00000000"						/* ESN	8		Zeros*/
				  "            "					/* Work Order Number	12		Spaces*/
				  "       "						/* Filler	7		Spaces*/
				  .
				  sQty = string(integer(sQty) - 1).
				end.
			end.  /*End of if rps_qty_req - old_qty > 0 then do:*/
			
			if old_qty = 0 /* NOT SEND SCHEDULE BEFORE */
			and rps_qty_req <> 0 then do: /* SCHEDULED AND WILL SEND INFOMATION TO PPIF*/
				
				iDay = bld_date - date(1,1,year(bld_date)) + weekday(date(1,1,year(bld_date))) + 5.
				dWeek = 100 + iDay / 7.
				strbldday = substring(string(year(bld_date)),3,2) + 
				            substring(string(dWeek),2,2) + 
				            string(weekday(bld_date - 1)).
				if rps_qty_req > 99999 then do:
					find last xxppif_log no-lock no-error.
					trid = if available xxppif_log then (xxppif_tr_id + 1) else 1.
					create xxppif_log.
					assign 	xxppif_tr_id 	= trid
							xxppif_act_date	= today
							xxppif_act_time	= string(time, "HH:MM:SS")
							xxppif_tr_code	= "XSCD"
							xxppif_err		= 2
							xxppif_qty_chg	= rps_qty_req
							xxppif_msg		= "Qty is large than 99999".
					next.
				end.			
				sQty = string(100000 + rps_qty_req).
				sQty = substring(sQty,2,5).	
				do while (integer(sQty) > 0) : /*MJH007*/
				   
				   find last xxppifla_un  where xxppifla_so = rps_part no-error.
				   if available xxppifla_un then do:
				      assign xxppifla_un = xxppifla_un + 1.
				   end.
				   else do:
				      create xxppifla_un.
				      assign xxppifla_so = rps_part
				             xxppifla_un = 1.
				   end. 
				   /*Create xxppiftr_un history record*/
				   create xxppiftr_un.
				   assign xxppiftr_so = rps_part
				          xxppiftr_bd = rps_due_date
				          xxppiftr_flag = yes
				          xxppiftr_un = xxppifla_un.

				   put stream batchdata 
				   rps_part at 1 format "x(11)"	/* SO	11	*/			
				   "  " 							/* Filler	2		SPACES*/
				   "58"							/* ID CODE	2		58*/
			       strbldday						/* Explosion Date	5	*/	
				   strbldday						/* Build Start Date	5	*/	
				   "00001"  /*sQty MJH007 2005-01-22 16:55							/* Quantity	5		*/*/
				   substring(string(xxppiftr_un,"99999"),2,4)  format "9999" /*"0001" MJH007		*/					/* Beginning unit number	4		*/
				   substring(string(xxppiftr_un,"99999"),2,4)  format "9999" /*"0001" MJH007		*/					/* End unit number	4		*/
				   "00"							/* Explosion Level Number	2		0*/
				   "      "						/* Report Selection Code	6		Spaces*/
				   "  "							/* Transaction Code	2		Spaces*/
/*				    1234567890123456789012345*/
				   "                         "		/* Filler	25		Spaces*/
				   "10"							/* Record Type Report	2		10*/
				   "EC"							/* System ID	2		EC*/
				   "00"							/* Record Type Code	2		0*/
				   "              "				/* Filler	14		Spaces*/
/*				    1234567890123456789012345*/
				   "00000000"						/* ESN	8		Zeros*/
				   "            "					/* Work Order Number	12		Spaces*/
				   "       "						/* Filler	7		Spaces*/
				   .
				   sQty = string(integer(sQty) - 1).
				end.
				
			end.
		
		end. /* FOR EACH RPS_MSTR*/
		
		output stream batchdata close.		
			
		/* SCHEDULE OUTPUT END*/
