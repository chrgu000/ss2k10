/* xxrqpochk.p      PO审核程式                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/


/* DISPLAY TITLE */
{mfdtitle.i "1+ "}


define var site   like pod_site label "地点"  .
define var part   like pod_part label "零件号".
define var part1  like pod_part label "至".
define var date   like po_ord_date label "需要日期" .
define var date1  like po_ord_date label "至" .
define var nbr    like po_nbr label "采购单号".
define var nbr1   like po_nbr label "至".
define var v_yn1   as logical label "仅未审核" initial yes.
define var v_yn2   as logical label "全部审核" format "Yes/No" .
define var choice  as logical initial no.
define var v_yn3   as logical initial no .
define var v_yn4   as logical initial yes label "执行计划" format "Y-审核后执行修改/N-仅审核修改计划" .
define var v_qty_ord	like pod_qty_ord .
define var v_qty_tmp	like pod_qty_ord .
define var v_date_tmp   like po_ord_date .


define var curr1 like po_curr .
define var curr2 like po_curr .
define var ratetype like exr_ratetype .
define var r1 like exr_rate .
define var r2 like exr_rate2.
define var seq as integer .
define var error as integer .


define var time_start as integer . 
define var v_counter  as integer .



define variable first_sw_call as logical initial true no-undo.
define variable temp_recno  as recid                no-undo.
define variable l_error       as integer              no-undo.
define variable include_cons_ent as logical           no-undo.
define variable select_all    as logical              no-undo.


define new shared temp-table temp 
	field t_select   as char  format "x(1)"   
	field t_nbr      like po_nbr              
	field t_line     like pod_line 
	field t_part     like pod_part      
	field t_date_to  like pod_need
	field t_date1    like pod_need
	field t_date     like po_ord_date            
	field t_qty      like pod_qty_ord 	
	field t_detail   as char format "x(4)"
	field t_app      as logical format "Y/N" label "审" . /*any change ,must be sync with xxmppopoca.p & xxmppopocb.p*/

define temp-table xxord
	field xord_nbr  like pod_nbr 
	field xord_part like pod_part 
	field xord_qty  like pod_qty_ord .




/*var initialized */
date = date(month(today),1,year(today)) .
date1 = today .
v_yn1 = yes .
v_yn2 = yes .

find icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if avail icc_ctrl then icc_site else "" .


define  frame a.
define  frame c.



define new shared  frame b.
form
	t_nbr       label "采购单" colon 8
	pod_part    label "零件"    colon 25
	pod_qty_ord    label "订单数量"    colon 63
	
	

	t_line      label "项次"     colon 8
	pt_desc1    label "说明"	 colon 25 	    
	pod_due_Date label "原截止日"   colon 65
	
	pt_desc2    no-label		 colon 25
	pod_need     label "需求日"    colon 65
	 
with frame b side-labels width 80 attr-space.    /*if changed here, must sync with xxmppopoca.p */


form
	site			colon 18
	part    		colon 18
	part1			colon 50
	nbr     		colon 18
	nbr1    		colon 50
	/*
	date     		colon 18
	date1   		colon 50
	
	v_yn1    		colon 25
	*/
	skip(1)
	v_yn2    		colon 25
	v_yn4           colon 25


with frame a side-labels no-underline width 80 attr-space.
/*setFrameLabels(frame a:handle). */

form
	t_select     label "选"
	t_part       label "零件"
	t_nbr        column-label "采购单" 
	t_line       column-label "项"
	t_detail     label "建议动作"
	t_date_to    column-label "建议日期"		
	t_qty        label "未结数量"	
	t_app        label "审" 

with frame c down width 80 .     




     


/* DISPLAY */
view frame a.
hide frame  c no-pause .
hide frame  b no-pause .
/*view frame c.
view frame b.*/

mainloop:
repeat with frame a:
	hide frame  c no-pause .
	hide frame  b no-pause .
	view frame a.
    clear frame a no-pause .

	choice = no .
	if part1 = hi_char then part1 = "" .
	if nbr1 = hi_char  then nbr1 = "" .

    update site part part1  nbr nbr1 /*date date1 v_yn1 */ v_yn2 v_yn4 with frame a .
	if part1 = "" then part1 = hi_char .
	if nbr1 = ""  then nbr1 = hi_char .
	if date1 = ? then date1 = today .
	if date  = ? then date = low_date .

time_start = time .
v_counter  = 0 .

	for each temp:
		delete temp.
	end.	
	for each xxord:
		delete xxord.
	end.	
    clear frame c all no-pause .
	clear frame b no-pause .

	for each xchg_Det 
			use-index c_part no-lock 
			where c_domain = global_domain and c_site = site 
			and c_part >= part and c_part <= part1
			and c_nbr >= nbr and c_nbr <= nbr1 
			break by c_part  by c_nbr by c_line :
		if first-of(c_part) then do:
			v_counter = v_counter + 1 .
			if v_counter > 20 then leave . 
			v_qty_ord = 0 .
		end.	/*if first-of(c_part)*/

		if first-of(c_nbr) then do:
			v_qty_ord = 0 .
			for each pod_det no-lock where pod_domain = global_domain 
									and pod_nbr = c_nbr 
									and pod_part = c_part 
									and pod_stat = "" :
				v_qty_ord = v_qty_ord + round( pod_qty_ord - pod_qty_rcvd ,2)  .
			end.
			find first xxord where xord_nbr = c_nbr and xord_part = c_part exclusive-lock no-error .
			if not avail xxord then do :
				create  xxord.
				assign  xord_nbr = c_nbr
						xord_part = c_part 
						xord_qty  = v_qty_ord .
			end.
			else xord_qty = xord_qty + v_qty_ord .

			v_qty_ord = 0 .
		end.	/*if first-of(c_part)*/

		/*****检查:在计划产生后 ,采购单是否有项次删除过*******/
		find first pod_det where pod_nbr = c_nbr and pod_line = c_line and pod_part = c_part and pod_statu = "" no-lock no-error.
		if not avail pod_det then do:
			message "错误:订单" c_nbr "/项" c_line "已修改,计划不能再执行." view-as alert-box.
			undo mainloop, retry .
		end.


		/*****检查:在计划产生后 ,采购单是否有数量修改过*******/
		v_qty_ord = v_qty_ord + c_qty_to .
		if last-of(c_nbr) then do:
			find first xxord where xord_nbr = c_nbr and xord_part = c_part no-lock no-error .
			if avail xxord then do:
				if xord_qty <> v_qty_ord then do :
					message "错误:采购单:" xord_nbr "零件:" xord_part "总未结量改变,计划不能再执行." .
					undo mainloop, retry .
				end.
			end.
		end.


		find first temp where t_part = c_part 
						  and t_nbr  = c_nbr 
						  and t_line = c_line 						  
		exclusive-lock no-error .
		if not avail temp then do:
			find first po_mstr where po_domain = global_domain and po_nbr = c_nbr no-lock no-error .
			create temp .
			assign  t_nbr  = c_nbr 
					t_line = c_line 
					t_part = c_part 
					t_date = if avail po_mstr then po_ord_date else ? 
					t_date_to = c_date_to
					t_date1   = c_date_to
					t_qty     = c_qty_to
					t_detail  = if c_detail = "X" then "取消"
								else if c_detail = "C" then 
										(if c_date_to > c_date_from then "延后" else "提前")
								else "" 
					t_app     = if v_yn2 = yes then yes 
								else if c_stat02 = yes then yes 
									 else no .
		end.
	end. /*for each xchg_Det*/

	find first temp no-lock no-error.
	if not avail temp then  do:
		message "无未审核的修改计划." .
		undo, retry .
	end.

	hide frame a no-pause.
	view frame c .
	view frame b .
		/*message "timeused:" string(time - time_start , "hh:mm:ss") view-as alert-box.*/
		if v_counter >= 20 then message "每次最多显示20个零件" .
	sw_block:
	repeat :
		/*find first temp no-lock no-error .
		if not avail temp then leave .*/
		for first temp no-lock:
		end.		
		{xxswslxp03.i
			&detfile      = temp
			&scroll-field = t_nbr
			&framename    = "c"
			&framesize    = 8
			&sel_on       = ""*""
			&sel_off      = """"
			&display1     = t_select
			&display3     = t_nbr
			&display4     = t_line
            &display2     = t_part
			&display5     = t_detail
			&display6     = t_date_to
			&display7     = t_qty
			&display8     = t_app
			&ext01        = t_date1
			&exitlabel    = sw_block
			&exit-flag    = first_sw_call
			&record-id    = temp_recno
			
		}  /*&include2     = " update t_date_to t_qty . "*/
		if keyfunction(lastkey) = "end-error"
			or lastkey = keycode("F4")
			or lastkey = keycode("ESC")
		then do:
				{pxmsg.i &MSGNUM     = 36 &ERRORLEVEL = 1 &CONFIRM = choice }
				if choice = yes then do :
					for each temp exclusive-lock:
						delete temp.
					end.
					clear frame c all no-pause .
					clear frame b no-pause .
					choice = no .
					leave .
				end.

		end.  /*if keyfunction(lastkey)*/  
		
		if keyfunction(lastkey) = "go"
		then do:
			v_yn3 = no . /*v_yn3 = yes 则不可以退出 */
			for each temp where t_app = yes  
				no-lock break by t_nbr by t_part  :

				if first-of(t_part) then v_qty_ord = 0 .
				v_qty_ord = v_qty_ord + t_qty .

				if last-of(t_part) then do:
					find first xxord where xord_nbr = t_nbr and xord_part = t_part no-lock no-error .
					if avail xxord then do:
						if xord_qty <> v_qty_ord then do :
							v_yn3 = yes .
							message "采购单:" xord_nbr "零件:" xord_part "修改后总订单量变化" .
							pause .
							leave .
						end.
					end.
					else v_yn3 = yes.
				end.					
			end .   /*for each temp */

			if v_yn3 = no then do :
				{pxmsg.i &MSGNUM     = 12 &ERRORLEVEL = 1 &CONFIRM = choice }
				if choice then 	leave .
			end. 

		end.  /*if keyfunction(lastkey)*/  

		for first temp where t_select = "*" exclusive-lock with frame b :
				assign t_select = "" .
				clear frame b no-pause .

				disp t_nbr t_line  with frame b .

				find first pod_det where pod_domain = global_domain and pod_nbr  = t_nbr and pod_line = t_line no-lock no-error .
				if avail pod_det then do:
					disp pod_part pod_need pod_due_date pod_qty_ord with frame b .
				end.

				find first pt_mstr where pt_domain = global_domain and pt_part = t_part no-lock  no-error .
				if avail pt_mstr then do:
					disp pt_desc1 pt_desc2 with frame b .
				end.		
				
				
				v_date_tmp = t_date_to .
				v_qty_tmp = t_qty .
				update t_date_to /*t_qty*/ with frame c .

				/* validate here */
				find first xchg_det where c_domain = global_domain and c_nbr = t_nbr 
									and c_line = t_line 
									and c_date_to = t_date_to 
									and c_qty_to <> v_qty_tmp 
				no-lock no-error.
				if avail xchg_Det then do:
					message "警告:已存在指定的修改计划:采购单/项次/零件/建议日期" .
					t_date_to = v_date_tmp .
					undo,retry . 
				end.
				/*
				if t_qty < 0 then do:
					message "警告:数量不允许为负" .
					t_qty = v_qty_tmp .
					undo, retry . 
				end.

				find first pod_Det use-index pod_nbrln 
								where pod_nbr = t_nbr 
								and pod_line = t_line 
				no-lock no-error .
				if avail pod_det then do :
					if t_qty > pod_qty_ord  then do:
						message "警告:不得超过采购单" t_nbr "/项"  t_line "的原订购量".
						t_qty = v_qty_tmp .
						undo,retry .
					end.
				end.
				*/
				/* validate here */
				
				update t_app with fram c .
				
			
		end. /*for first temp*/

		temp_recno = recid(temp) .

		find next temp no-lock no-error.
		if available temp then do:
			temp_recno = recid(temp) .
		end.

	end.	/*sw_block:*/
	if choice then do :
		{pxmsg.i &MSGNUM     = 32 &ERRORLEVEL = 1 &CONFIRM = choice }
		if choice then do :
			for each temp no-lock 
				break by t_nbr by t_part by t_line :
					find first xchg_det where c_domain = global_domain 
										and c_nbr = t_nbr 
										and c_line = t_line 
										and c_date_to = t_date1 
					exclusive-lock no-error .
					if avail xchg_Det then do:
							assign  c_date_to = t_date_to 
									/*c_qty_to  = t_qty */
									c_user02  = global_userid
									c_date02  = today
									c_stat02  = t_app .
					end.
					else do:
						/* create ? no,未加新增/删除计划功能 */
					end .					
			end .   /*for each temp */
			
			if v_yn4 then do :
			/*采购单调整,执行开始*/
				for each temp no-lock break by t_nbr :
					if first-of(t_nbr) then do:
						find first po_mstr where po_domain = global_domain and po_nbr = t_nbr no-lock no-error .
						curr1 = if avail po_mstr then po_curr else  "" .
						curr2 = base_curr .
						ratetype = "" .

						{gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
											"(input curr1,
											  input curr2,
											  input ratetype ,
											  input today ,
											  output r1,
											  output r2,
											  output seq,
											  output error)"}
						if error <> 0 then do:
							message "错误:计划未执行." curr1 "兑换率不存在" .
							v_yn4 = no .
							leave .
						end.
					end.
				end.

				if v_yn4 then do:
					message "...正在执行计划..."  .
					{gprun.i ""xxmppopocb.p"" }

					pause 2.
					hide message no-pause .
				end.

			/*采购单调整,执行结束*/
			end.

			for each temp exclusive-lock:
				delete temp.
			end.
			clear frame c all no-pause .
			clear frame b no-pause .

		end.  /*if choice then*/
		else do:  /*if not choice then*/
			for each temp exclusive-lock:
				delete temp.
			end.
			clear frame c all no-pause .
			clear frame b no-pause .
			hide frame  c no-pause .
			hide frame  b no-pause .

		end. /*if not choice then*/
	end.  /*if choice then*/

end.   /*  mainloop: */

status input.
