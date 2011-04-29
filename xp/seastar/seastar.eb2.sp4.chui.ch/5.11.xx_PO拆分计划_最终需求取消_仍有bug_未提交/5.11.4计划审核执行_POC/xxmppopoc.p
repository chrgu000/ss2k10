/* xxrqpochk.p      PO��˳�ʽ                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/


/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

define variable isAuthorized        as integer initial 0  .
define var site   like pod_site label "�ص�" initial "10000" .
define var part   like pod_part label "�����".
define var part1  like pod_part label "��".
define var date   like po_ord_date label "��Ҫ����" .
define var date1  like po_ord_date label "��" .
define var nbr    like po_nbr label "�ɹ�����".
define var nbr1   like po_nbr label "��".
define var v_yn1   as logical label "��δ���" initial yes.
define var v_yn2   as logical label "ȫ�����" format "Yes/No" .
define var choice  as logical initial no.
define var v_yn3   as logical initial no .
define var v_yn4   as logical initial yes label "ִ�мƻ�" format "Y-�ƻ���˺�ִ�в��/N-����˲�ּƻ�" .
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
	field t_app      as logical format "Y/N" label "��" . 

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
define var v_shipcode as char format "x(1)" label "����" .  /*frame b*/
define var v_lt like pt_pur_lead column-label "L/T" .        /*frame b*/
define var v_qty_open like pod_qty_ord  label "δ������".  /*frame b*/
define var v_cwin    like vp__chr01 label "Cancel_Window" . /*frame b*/
form
	t_nbr       label "�ɹ���" 
	t_line      label "��" 
	po_vend      label "��Ӧ��"
	v_cwin      label "CW"
	pod_due_Date label "ԭ��ֹ��"   colon 68

	pod_part     label "���" 
	v_shipcode   label "������ʽ"     colon 35
	v_lt	     label "�ɹ���ǰ��"	
	pod_need     label "��������"  colon 68

	pt_desc1    no-label 
	pod_qty_ord   label "ԭ������"   colon 35
	po_ord_date  label "�µ�����"  colon 68


	pt_desc2    no-label 
	pod_qty_rcvd  label "���ջ���"    colon 35
	v_qty_open    label "δ������"    colon 63
/*
t_nbr t_line 
v_shipcode v_lt	pt_desc1 pt_desc2 
po_ord_date po_vend v_cwin
pod_need  pod_due_Date pod_part pod_qty_ord  pod_qty_rcvd v_qty_open  
*/

with frame b side-labels width 80 attr-space.  /*frame b ����xxmppomca.pͬʱ�޸�*/






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
	t_select     label "ѡ"
	t_nbr        column-label "�ɹ���" 
	t_line       column-label "��"
	t_part       label "���"
	t_date_to    column-label "��������"	
	t_detail     label "����"
	t_qty        label "��������"
	
	t_app        label "��" 

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
				message "�û�û������ص�Ĵ�ȡȨ��" view-as alert-box .
				undo,retry .
		  end.
	end.
	else do:
		message "�ص�:" site "��Ч,����������." view-as alert-box.
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


		/*****���:�ڼƻ������� ,�ɹ����Ƿ������ɾ����*******/
		find first pod_det where pod_nbr = c_nbr and pod_line = c_line and pod_part = c_part and pod_statu = "" no-lock no-error.
		if not avail pod_det then do:
			message "����:����" c_nbr "/��" c_line "���޸�,�ƻ�������ִ��." view-as alert-box.
			undo mainloop, retry .
		end.


		/*****���:�ڼƻ������� ,�ɹ����Ƿ��������޸Ĺ�*******/
		v_qty_ord = v_qty_ord + c_qty_to .
		if last-of(c_part) then do:
			find first xxord where xord_nbr = c_nbr and xord_part = c_part no-lock no-error .
			if avail xxord then do:
				if xord_qty <> v_qty_ord then do :
					message "����:�ɹ���:" xord_nbr "���:" xord_part "��δ�����ı�,�ƻ�������ִ��." .
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
				t_detail  = if (c_detail = "XX" or c_detail = "XR" or c_detail = "XN") then "ȡ��" 
					   else if ( c_detail = "CN" or  c_detail = "CR" )  and c_date_to <> date(01,01,year(today) + 2 ) then "����"
					   else if ( c_detail = "CN" or  c_detail = "CR" )  and c_date_to =  date(01,01,year(today) + 2 ) then "ȡ-L"
					   else "" .
				t_app     = if v_yn2 = yes then yes 
							else if c_stat02 = yes then yes 
								 else no .
		end.
	end. /*for each xchg_Det*/


	find first temp no-lock no-error.
	if not avail temp then  do:
		message "��δ��˵��޸ļƻ�." .
		undo, retry .
	end.

	hide frame a no-pause.
	view frame c .
	view frame b .
	if v_counter >= 20 then message "ÿ�������ʾ20������" .

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
			v_yn3 = no . /*v_yn3 = yes �򲻿����˳� */
			for each temp where t_app = yes  
				no-lock break by t_nbr by t_part  :

				if first-of(t_part) then v_qty_ord = 0 .
				v_qty_ord = v_qty_ord + t_qty .

				if last-of(t_part) then do:
					find first xxord where xord_nbr = t_nbr and xord_part = t_part no-lock no-error .
					if avail xxord then do:
						if xord_qty <> v_qty_ord then do :
							v_yn3 = yes .
							message "�ɹ���:" xord_nbr "���:" xord_part "�޸ĺ��ܶ������仯" .
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
					message "����:�Ѵ���ָ�����޸ļƻ�:�ɹ���/���/���/��������/����" .
					pause .
					t_date_to = v_date_tmp .
					undo,retry . 
				end.

				/*
				if t_qty < 0 then do:
					message "����:����������Ϊ��" .
					t_qty = v_qty_tmp .
					undo, retry . 
				end.

				find first pod_Det use-index pod_nbrln 
								where pod_nbr = t_nbr 
								and pod_line = t_line 
				no-lock no-error .
				if avail pod_det then do :
					if t_qty > pod_qty_ord  then do:
						message "����:���ó����ɹ���" t_nbr "/��"  t_line "��ԭ������".
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
						/* create ? no,��ʱδ������/ɾ���ƻ����� */
					end .					
			end .   /*for each temp */
			
			if v_yn4 then do :
			/*�ɹ������,ִ�п�ʼ*/
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
							message "����:�ƻ�δִ��." curr1 "�һ��ʲ�����" .
							v_yn4 = no .
							leave .
						end.
					end. /*if first-of(t_nbr) */
				end. /*for each temp*/

				if v_yn4 then do:
					message "...��ʼִ�мƻ�..."  .
					{gprun.i ""xxmppopocb.p"" }

					pause 2 .
					hide message no-pause .
				end.

			/*�ɹ������,ִ�н���*/
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
