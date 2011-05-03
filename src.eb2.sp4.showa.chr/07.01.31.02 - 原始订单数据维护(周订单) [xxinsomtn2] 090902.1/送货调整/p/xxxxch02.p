/* SS - 090720.1 By: Neil Gao */

{mfdtitle.i "090720.1"}

define var sonbr like so_nbr.
define var soline like sod_line.
define var part like pt_part.
define var cust like so_cust.
define var tqty01 like sod_qty_ord.
define var tdate as char.
define var tmonth as char.
define var i as int.
define var yn as logical.
define var fn_i as char init "xxch02".
define var fdate as date.
define var fhour as int.
define var fminute as int.
define var v_tax LIKE pt_taxable .
define var v_tax1 LIKE pt_taxable .


define temp-table tt1
	field tt1_f1 as int format ">>9"
	field tt1_f2 as char format "x(11)"
	field tt1_f3 as char format "x(5)"
	field tt1_f4 like sod_qty_ord
	field tt1_f5 as recid
	field tt1_f6 like so_nbr
	index tt1_f1 tt1_f1
	. 

form
	sonbr colon 25 
with frame a side-label width 80 attr-space.

setframelabels(frame a:handle).
	
form
	part 
	pt_desc1
	sod_qty_ord
	sod_qty_ship
with frame b side-label width 80 attr-space.

setframelabels(frame b:handle).	
	
form
	tt1_f1 	column-label "序"
	tt1_f2	column-label "送货日期"
	tt1_f3  column-label "送货时间"
	tt1_f4  column-label "订货数量"
	tt1_f6  column-label "销售订单"
with frame c 5 down width 80 attr-space.

/*
setframelabels(frame c:handle).
*/
	
form
	tt1_f1 	label "序"
	tt1_f2	label "送货日期"
	tt1_f3  label "送货时间"
	tt1_f4  label "订货数量"
with frame d side-label width 80 attr-space.

mainloop:
repeat:
	
	hide frame b no-pause.
	hide frame c no-pause.
	hide frame d no-pause.
	
	update sonbr with frame a.
	
	find first so_mstr where so_nbr = sonbr no-lock no-error.
	if not avail so_mstr then do:
		message "错误: 销售订单不存在".
		next.
	end.
	cust = so_cust.
	
	loop1:
	repeat:
		
		hide frame c no-pause.
		hide frame d no-pause.
		prompt-for part with frame b editing:
			if frame-field = "part" then do:
				{mfnp05.i sod_det sod_nbrln
			  	 "sod_nbr = sonbr"
			  	 sod_part "input part"}
			end.
			else do:
				readkey.
				apply lastkey.
			end.
			if recno <> ? then do:
				disp sod_part @ part sod_qty_ord sod_qty_ship with frame b.
				find first pt_mstr where pt_part = sod_part no-lock no-error.
				if avail pt_mstr then disp pt_desc1 with frame b.
			end.
		end. /* editing */
		
		part = input part.
	  FIND FIRST pt_mstr WHERE pt_part = part no-lock no-error.
  	IF AVAIL pt_mstr THEN v_tax = pt_taxable .

  	find first ad_mstr where ad_addr = cust no-lock no-error.
  	if avail ad_mstr then v_tax1 = ad_taxable .

		find first sod_det where sod_nbr = sonbr and sod_part = part no-lock no-error.
		if not avail sod_det then do:
			message "错误: 销售订单项不存在".
			next .
		end.
		else do:
			disp part sod_qty_ord sod_qty_ship with frame b.
			find first pt_mstr where pt_part = sod_part no-lock no-error.
			if avail pt_mstr then disp pt_desc1 with frame b.
		end.
		
		empty temp-table tt1.
		i = 0.
		for each cp_mstr where cp_cust = so_cust and cp_part = part no-lock,
			each xxsod_det where xxsod_cust = so_cust and xxsod_part = cp_cust_part no-lock ,
			each cm_mstr where cm_addr = xxsod_cust no-lock by xxsod_due_date1 by xxsod_due_time1:

/* SS 090722.1 - B */
/*
			tdate = substring(xxsod_rmks, index(xxsod_rmks, " " ) + 1).
			IF SUBSTRING(tdate,5,2) = "10" THEN tmonth = "A".
			else if SUBSTRING(tdate,5,2) = "11" then tmonth = "B".
			else if SUBSTRING(tdate,5,2) = "12" then tmonth = "C".
			else tmonth = SUBSTRING(tdate,6,1) .
*/
			tdate = xxsod_due_date1.
			IF SUBSTRING(tdate,6,2) = "10" THEN tmonth = "A".
			else if SUBSTRING(tdate,6,2) = "11" then tmonth = "B".
			else if SUBSTRING(tdate,6,2) = "12" then tmonth = "C".
			else tmonth = SUBSTRING(tdate,7,1) .
/* SS 090722.1 - E */
			
			if sonbr = SUBSTRING(cm_sort,1,2) + substring(xxsod_type,1,1) + substring(tdate,4,1)
									+ tmonth + SUBSTRING(xxsod_project,1,1) + string(xxsod_week,"99") then do:
				
				i = i + 1.
				create tt1.
				assign tt1_f1 = i
							 tt1_f2 = xxsod_due_date1
							 tt1_f3 = xxsod_due_time1
							 tt1_f4 = xxsod_qty_ord
							 tt1_f5 = recid(xxsod_det)
							 tt1_f6 = so_nbr
							 .
			end. /* if sonbr */
			
		end. /* for each xxsod_det */
		
		view frame c.
		clear frame c all no-pause.
		for each tt1 no-lock:
			disp tt1_f1 tt1_f2 tt1_f3 tt1_f4 tt1_f6 with frame c.
			down with frame c.
			if line-counter >= page-size then leave.
		end.
		
		loop2:
		repeat:
			prompt-for tt1_f1 with frame d editing :
				{mfnp05.i tt1 tt1_f1
									" true " tt1_f1 "input tt1_f1"}
				if recno <> ? then do:
					disp tt1_f1 tt1_f2 tt1_f3 tt1_f4 with frame d.
				end.
			end.
		
			find first tt1 where tt1_f1 = input tt1_f1 no-lock no-error.
			if avail tt1 then do:
				clear frame c all no-pause.
				for each tt1 where tt1_f1 >= input tt1_f1 no-lock:
					disp tt1_f1 tt1_f2 tt1_f3 tt1_f4 tt1_f6 with frame c.
					down with frame c.
					if line-counter >= page-size then leave.
				end.
				update tt1_f2 tt1_f3 tt1_f4 with frame d.
				
				fdate = ?.
				fdate = date(int(substring(tt1_f2,6,2)),int(substring(tt1_f2,9,2)),int(substring(tt1_f2,1,4))) no-error.
				fhour = 99.
				fminute = 99.
				fhour = int(substring(tt1_f3,1,2)) no-error.
				fminute = int(substring(tt1_f3,4,2)) no-error.
				if fdate = ? or fhour > 23 or fminute > 59 then do:
					message "错误: 时间或日期输入有误".
					undo,retry.
				end.
				
				tdate = tt1_f2.
				IF SUBSTRING(tdate,6,2) = "10" THEN tmonth = "A".
				else if SUBSTRING(tdate,6,2) = "11" then tmonth = "B".
				else if SUBSTRING(tdate,6,2) = "12" then tmonth = "C".
				else tmonth = SUBSTRING(tdate,7,1) .
			
				tt1_f6 = SUBSTRING(sonbr,1,3) + substring(tdate,4,1)
									+ tmonth + SUBSTRING(sonbr,6,1) + substring(tdate,9,2).
			end.
		
		end. /* loop2 */
		
		message "是否更新 ?" update yn.
		if yn then do on error undo,leave :
			
			tqty01 = 0.
			for each tt1 no-lock where tt1_f6 = sonbr,
				each xxsod_det where recid(xxsod_det) = tt1_f5 no-lock :
				tqty01 = tqty01 + tt1_f4.
			end.
			
			find first sod_det where sod_nbr = tt1_f6 and sod_part = part no-lock no-error.
			if avail sod_det and sod_qty_ord <> tqty01 then do:
				OUTPUT TO VALUE(fn_i + ".inp").
				put unformat """" + trim(sonbr) + """" skip.
				put "-" skip.
				put "-" skip.
				put "-" skip.
				put "-" skip.
				put "-" skip.
				put "-" skip.
				put unformat string(sod_line) skip.
				put "-" skip.
				put unformat string(tqty01) skip.
				put "-" skip.
				put "-" skip.
				IF v_tax = YES AND v_tax1 = YES THEN DO:
        	put "-" skip.
        END.
				put "." skip.
				put "." skip.
				put "-" skip.
				put "-" skip.
				put "." skip.
				OUTPUT CLOSE .
				
				INPUT FROM VALUE(fn_i + ".inp") .
        OUTPUT TO VALUE(fn_i + ".cim") .
        batchrun = YES.
        {gprun.i ""sosomt.p""}
       	batchrun = NO.
        INPUT CLOSE .
        OUTPUT CLOSE .
				find first sod_det where sod_nbr = sonbr and sod_part = part no-lock no-error.
				if not avail sod_det or sod_qty_ord <> tqty01 then do:
					message "更新失败".
					undo,leave.
				end.
				tqty01 = 0.
				unix silent value("del " + trim(fn_i)  + ".inp").
				unix silent value("del " + trim(fn_i)  + ".cim").
			end.	/* if avail sod_det and sod_qty_ord <> tqty01 */
			
			tqty01 = 0.
			for each tt1 no-lock where tt1_f6 <> sonbr,
				each xxsod_det where recid(xxsod_det) = tt1_f5 no-lock break by tt1_f6:
				
				tqty01 = tqty01 + tt1_f4.
				if last-of(tt1_f6) then do:
					
					find first so_mstr where so_nbr = tt1_f6 no-lock no-error.
					if avail so_mstr then do:
						find first sod_det where sod_nbr = tt1_f6 and sod_part = part no-lock no-error.
						if avail sod_det then do:
							if sod_qty_ord = tqty01 then next.
							OUTPUT TO VALUE(fn_i + ".inp").
							put unformat """" + trim(tt1_f6) + """" skip.
							put "-" skip.
							put "-" skip.
							put "-" skip.
							put "-" skip.
							put "-" skip.
							put "-" skip.
							put unformat string(sod_line) skip.
							put "-" skip.
							put unformat string(tqty01 + sod_qty_ord) skip.
							put "-" skip.
							put "-" skip.	
						end. /* if avail sod_det */
						else do: 
							OUTPUT TO VALUE(fn_i + ".inp").
							put unformat """" + trim(tt1_f6) + """" skip.
							put "-" skip.
							put "-" skip.
							put "-" skip.
							put "-" skip.
							put "-" skip.
							put "-" skip.
							put "-" skip. /* line*/
							put part skip.
							put "-" skip.
							put unformat string(tqty01) skip.
							put "-" skip.
							put "-" skip.
							put "-" skip.
							put "-" skip.
						end.
					end. /* if avail so_mstr then do */
					else do:
						PUT  unformat """" + trim(tt1_f6) + """"  skip.
            put  unformat """" + TRIM(cust) + """" skip.
            put  " - " SKIP.
            put  " - " SKIP.
            put  unformat SUBSTRING(tt1_f2,3,2) + substring(tt1_f2,6,2) + substring(tt1_f2,9,2).
            DO i = 1 TO 11 :
            	PUT " - " .
            END.
            PUT  unformat TRIM(xxsod_project) skip.
            put "-" SKIP.
            PUT "-" SKIP.
            PUT "-" SKIP.
            put unformat """" + part + """" SKIP.
            put "-" SKIP.
            put unformat string(tqty01) SKIP.
            put " - " SKIP.
            put " - " SKIP.
         		DO i = 1 TO 14 :
            	PUT " - " .
          	END.
          	PUT unformat substring(tt1_f2,3,2) + substring(tt1_f2,6,2) + substring(tt1_f2,9,2) skip.    
					end. /* else do: */
					
					IF v_tax = YES AND v_tax1 = YES THEN DO:
            put "-" skip.
          END.
					put "." skip.
					put "." skip.
					put "-" skip.
					put "-" skip.
					put "." skip.
					OUTPUT CLOSE .
					
					INPUT FROM VALUE(fn_i + ".inp") .
        	OUTPUT TO VALUE(fn_i + ".cim") .
        	batchrun = YES.
        	{gprun.i ""sosomt.p""}
       		batchrun = NO.
        	INPUT CLOSE .
        	OUTPUT CLOSE .
					find first sod_det where sod_nbr = tt1_f6 and sod_part = part no-lock no-error.
					if not avail sod_det or sod_qty_ord <> tqty01 then do:
						message "更新失败".
						undo,leave.
					end.
					tqty01 = 0.
					unix silent value("del " + trim(fn_i)  + ".inp").
					unix silent value("del " + trim(fn_i)  + ".cim").
				end. /* if last-of(tt1_f6)*/	
			end.
			

/* SS 090722.1 - B */
/*				
				OUTPUT TO VALUE(fn_i + ".inp").
				put unformat """" + trim(sod_nbr) + """" skip. 
				put "-" skip.
				put "-" skip.
				put "-" skip.
				put "-" skip.
				put "-" skip.
				put "-" skip.
				put unformat string(sod_line) skip.
				put "-" skip.
				put unformat string(tqty01) skip.
				put "-" skip.
				put "-" skip.
				put "." skip.
				put "." skip.
				put "-" skip.
				put "-" skip.
				put "." skip.
				OUTPUT CLOSE .
				
				INPUT FROM VALUE(fn_i + ".inp") .
        OUTPUT TO VALUE(fn_i + ".cim") .
        batchrun = YES.
        {gprun.i ""sosomt.p""}
        batchrun = NO.
        INPUT CLOSE .
        OUTPUT CLOSE .
				find first sod_det where sod_nbr = sonbr and sod_part = part no-lock no-error.
				if not avail sod_det or sod_qty_ord <> tqty01 then do:
					message "更新失败".
					undo,leave.
				end.
				unix silent value("del " + trim(fn_i)  + ".inp").
				unix silent value("del " + trim(fn_i)  + ".cim").
*/
/* SS 090722.1 - E */			
			for each tt1 no-lock:
				find first xxsod_det where recid(xxsod_det) = tt1_f5 no-error.
				if not avail xxsod_det then next.
				if tt1_f2 <> xxsod_due_date1 or tt1_f3 <> xxsod_due_time1 or tt1_f4 <> xxsod_qty_ord then do:
						xxsod_due_date1 = tt1_f2.
						xxsod_due_time1 = tt1_f3.
						xxsod_qty_ord  = tt1_f4.
						xxsod_week     = int(substring(tt1_f2,9,2)).
				end.
			end.
			
		end.
		
/* SS 090720.1 - B */
/*
		       CREATE xxsod_det.
           ASSIGN
               xxsod_type     = xx_type    
               xxsod_cust     = xx_cust    
               xxsod_project  = xx_project 
               xxsod_item     = xx_item    
               xxsod_vend     = xx_vend    
               xxsod_addr     = xx_addr    
               xxsod_part     = xx_part    
               xxsod_color    = xx_color   
               xxsod_desc     = xx_desc    
               xxsod_plan     = xx_plan    
               xxsod_due_date1 = xx_due_date
               xxsod_due_time1 = xx_due_time
               xxsod_qty_ord  = (ACCUMU TOTAL BY xx_due_time xx_qty_ord)
               xxsod_invnbr   = xx_invnbr  
               xxsod_rev      = xx_rev     
               xxsod_week     = xx_week    
               xxsod_category = xx_category
               xxsod_ship     = xx_ship    
               xxsod_rmks     = xx_rmks    
               xxsod_rmks1    = xx_rmks1 
               .
*/
/* SS 090720.1 - E */		
	
	end. /* loop1 */
	
end. /* mainloop */
