/* xxrqpochk.p      PO审核程式                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/


/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

define variable isAuthorized        as integer initial 0  .
define var site   like pod_site label "地点" initial "10000" .
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
define var v_yn4   as logical initial yes label "执行计划" format "Y-计划审核后执行拆分/N-仅审核拆分计划" .
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
	field t_detail2  as char format "X(2)"
	field t_id       as integer 
	field t_app      as logical format "Y/N" label "审" . 

define temp-table xxord
	field xord_nbr  like pod_nbr 
	field xord_part like pod_part 
	field xord_qty  like pod_qty_ord .


define var v_counter  as integer .



/*var initialized */
date = date(month(today),1,year(today)) .
date1 = today .
v_yn1 = no .
v_yn2 = yes .


define  frame a.
define  frame c.
define new shared  frame b.
define var v_shipcode as char format "x(1)" label "周期" .  /*frame b*/
define var v_lt like pt_pur_lead column-label "L/T" .        /*frame b*/
define var v_qty_open like pod_qty_ord  label "未结数量".  /*frame b*/
define var v_cwin    like vp__chr01 label "Cancel_Window" . /*frame b*/
form
	t_nbr       label "采购单" 
	t_line      label "项" 
	po_vend      label "供应商"
	v_cwin      label "CW"
	pod_due_Date label "原截止日"   colon 68

	pod_part     label "零件" 
	v_shipcode   label "交货方式"     colon 35
	v_lt	     label "采购提前期"	
	pod_need     label "需求日期"  colon 68

	pt_desc1    no-label 
	pod_qty_ord   label "原订购量"   colon 35
	po_ord_date  label "下单日期"  colon 68


	pt_desc2    no-label 
	pod_qty_rcvd  label "已收货量"    colon 35
	v_qty_open    label "未结数量"    colon 63
/*
t_nbr t_line 
v_shipcode v_lt	pt_desc1 pt_desc2 
po_ord_date po_vend v_cwin
pod_need  pod_due_Date pod_part pod_qty_ord  pod_qty_rcvd v_qty_open  
*/

with frame b side-labels width 80 attr-space.  /*frame b 须与xxmppomca.p同时修改*/






/* DISPLAY SELECTION FORM */
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
	t_nbr        column-label "采购单" 
	t_line       column-label "项"
	t_part       label "零件"
	t_date_to    column-label "建议日期"	
	t_detail     label "动作"
	t_qty        label "建议数量"
	
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

	find first si_mstr where si_site = site no-lock no-error .
	if avail si_mstr then do:

		  {gprun.i ""gpsiver.p"" 
			 "(input site,
			   input ?,
			   output isAuthorized)"}

		  if isAuthorized = 0 then do:
				/* MESSAGE #725 - USER DOES NOT HAVE ACCESS TO THIS SITE. */
				message "用户没有这个地点的存取权限" view-as alert-box .
				undo,retry .
		  end.
	end.
	else do:
		message "地点:" site "无效,请重新输入." view-as alert-box.
		undo,retry .
	end.



v_counter  = 0 .


	for each temp:
		delete temp.
	end.	
	for each xxord:
		delete xxord.
	end.	
    clear frame c all no-pause .
	clear frame b no-pause .

	for each xchg_Det no-lock where c_site = site 
			and c_part >= part and c_part <= part1
			and c_nbr >= nbr and c_nbr <= nbr1 
			and c_stat01 = yes 
			break by c_nbr by c_part by c_line :
		if first-of(c_nbr) then do:
			v_counter = v_counter + 1 .
			if v_counter > 20 then leave . 
			v_qty_ord = 0 .
		end.	/*if first-of(c_nbr)*/

		if first-of(c_part) then do:
			v_qty_ord = 0 .
			for each pod_det fields( pod_nbr pod_line pod_part pod_stat pod_qty_ord pod_qty_rcvd )
					where pod_nbr = c_nbr 
					and pod_part = c_part 
					and pod_stat = "" 
					no-lock :
				v_qty_ord = v_qty_ord + pod_qty_ord - pod_qty_rcvd .
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
		end.	/*if first-of*/


		/*****检查:在计划产生后 ,采购单是否有项次删除过*******/
		find first pod_det where pod_nbr = c_nbr and pod_line = c_line and pod_part = c_part and pod_statu = "" no-lock no-error.
		if not avail pod_det then do:
			message "错误:订单" c_nbr "/项" c_line "已修改,计划不能再执行." view-as alert-box.
			undo mainloop, retry .
		end.


		/*****检查:在计划产生后 ,采购单是否有数量修改过*******/
		v_qty_ord = v_qty_ord + c_qty_to .
		if last-of(c_part) then do:
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
				  and t_date_to = c_date_to 
				  and t_detail2 = c_detail 
		exclusive-lock no-error .
		if not avail temp then do:
			find first po_mstr where po_nbr = c_nbr no-lock no-error .
			create temp .
			assign  t_nbr  = c_nbr 
				t_line = c_line 
				t_part = c_part 
				t_date = if avail po_mstr then po_ord_date else ? 
				t_date_to = c_date_to
				t_date1   = c_date_to
				t_qty     = c_qty_to
				t_detail2 = c_detail 
				t_id      = c_id
				t_detail  = if (c_detail = "XX" or c_detail = "XR" or c_detail = "XN") then "取消" 
					   else if ( c_detail = "CN" or  c_detail = "CR" )  and c_date_to <> date(01,01,year(today) + 2 ) then "调整"
					   else if ( c_detail = "CN" or  c_detail = "CR" )  and c_date_to =  date(01,01,year(today) + 2 ) then "取-L"
					   else "" .
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
	if v_counter >= 20 then message "每次最多显示20个订单" .

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
			&display2     = t_nbr
			&display3     = t_line
            &display4     = t_part
			&display5     = t_date_to
			&display6     = t_detail
			&display7     = t_qty
			&display8     = t_app
			&ext01        = t_id
			&exitlabel    = sw_block
			&exit-flag    = first_sw_call
			&record-id    = temp_recno
			
		}  /*&include2     = " update t_date_to t_qty . "*/
		if keyfunction(lastkey) = "end-error"
			or lastkey = keycode("F4")
			or lastkey = keycode("ESC")
		then do:
				{pxmsg.i &MSGNUM     = 36 &ERRORLEVEL = 1 &CONFIRM = choice }
				if choice then do :
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
				
				find first po_mstr where po_nbr   = t_nbr no-lock no-error.
				if avail po_mstr then do:
					find first vp_mstr where vp_vend = po_vend and vp_part = t_part and vp_vend_part = "" no-lock no-error .
					v_cwin = if avail vp_mstr then vp__chr01 else "" .
					disp po_ord_date po_vend v_cwin with frame b .
				end.

				find first pod_det where pod_nbr  = t_nbr and pod_line = t_line no-lock no-error .
				v_qty_open = if avail pod_det then ( pod_qty_ord - pod_qty_rcvd ) else 0 .
				if avail pod_det then do:
					disp pod_part pod_need pod_due_date pod_qty_ord pod_qty_rcvd v_qty_open with frame b .
				end.

				find first pt_mstr where pt_part = t_part no-lock  no-error .
				if avail pt_mstr then do:
					v_shipcode = if avail pt_mstr then pt__chr02 else "" .
					v_lt = if avail pt_mstr then pt_pur_lead else 0 .
					disp pt_desc1 pt_desc2 v_shipcode v_lt with frame b .
				end.		
				

				
				v_date_tmp = t_date_to .
				v_qty_tmp = t_qty . /**/
				update t_date_to /*t_qty*/ with frame c .

				/* validate here */

				find first xchg_det where c_nbr = t_nbr 
						and c_line = t_line 
						and c_date_to = t_date_to 
						and c_qty_to = v_qty_tmp 
						and c_detail = t_detail2 
						and c_id <> t_id  
				no-lock no-error.
				if avail xchg_Det then do:
					message "警告:已存在指定的修改计划:采购单/项次/零件/建议日期/动作" .
					pause .
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
					find first xchg_det where c_nbr = t_nbr 
										and c_line = t_line 
										and c_date_to = t_date1 
										and c_detail = t_detail2 
										and c_id = t_id 
					exclusive-lock no-error .
					if avail xchg_Det then do:
							assign  c_date_to = t_date_to 
									c_qty_to  = t_qty 
									c_user02  = global_userid
									c_date02  = today
									c_stat02  = t_app .
					end.
					else do:
						/* create ? no,暂时未加新增/删除计划功能 */
					end .					
			end .   /*for each temp */
			
			if v_yn4 then do :
			/*采购单拆分,执行开始*/
				for each temp no-lock break by t_nbr :
					if first-of(t_nbr) then do:
						find first po_mstr where po_nbr = t_nbr no-lock no-error .
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
					end. /*if first-of(t_nbr) */
				end. /*for each temp*/

				if v_yn4 then do:
					message "...开始执行计划..."  .
					{gprun.i ""xxmppopocb.p"" }

					pause 2 .
					hide message no-pause .
				end.

			/*采购单拆分,执行结束*/
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
