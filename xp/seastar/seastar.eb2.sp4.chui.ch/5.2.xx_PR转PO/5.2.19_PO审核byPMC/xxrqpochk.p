/* xxrqpochk.p      PO��˳�ʽ                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/


/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

define variable isAuthorized        as integer initial 0  .
define var v_site like po_site label "�ص�" .
define var vend like po_vend label "��Ӧ��" .
define var date like po_ord_date label "��" .
define var date1  like po_ord_date label "ֹ" .
define var nbr    like po_nbr label "�ɹ�����".
define var nbr1   like po_nbr label "��".
define var v_app  as logical label "��δ���" initial yes.
define var v_yn   as logical label "ȫ�����" .
define var choice as logical initial no .


define variable first_sw_call as logical initial true no-undo.
define variable temp_recno  as recid                no-undo.
define variable l_error       as integer              no-undo.
define variable include_cons_ent as logical           no-undo.
define variable select_all    as logical              no-undo.


define new shared var v_lt   as logical label "����LT" .
define new shared temp-table temp 
	field t_select   as char  format "x(1)"   
	field t_nbr      like po_nbr              
	field t_line     like pod_line       
	field t_podline     like pod_line  
	field t_date     like po_ord_date         
	field t_part     like pod_part            
	field t_qty      like pod_qty_ord         
	field t_price    like pod_pur_cost        
	field t_app      as logical  format "Yes/No" 
	field t_rmks     as char format "x(60)"      . 



/*var initialized */
date = date(month(today),1,year(today)) .
date1 = today .
v_app = yes .
v_yn = no .
v_site = "10000" . 
global_site = v_site .


define  frame a.
define  frame c.
define new shared  frame b.

/* DISPLAY SELECTION FORM */
form
	v_site  column-label "�ص�"
	vend    column-label "��Ӧ��"
	date    column-label "��" 
	date1   column-label "��"
	nbr     column-label "�ɹ�����"
	nbr1    column-label "��"
	v_app   column-label "��δ���" 
	v_yn    column-label "ȫ�����"


with frame a  no-underline width 80 attr-space.
/*setFrameLabels(frame a:handle). */

form
	t_select  label "ѡ"
	t_nbr     column-label "�ɹ���" 
	t_line    column-label "��" 
	t_date    column-label "��������"
	t_part    label "���"
	t_qty     label "��������"
	t_price   label "�۸�" 
	t_app     label "���"

with frame c down width 80 .     




form
	t_nbr       label "�ɹ���" 
	pod_part    no-label 	    colon 18
	po_cr_terms label "֧����ʽ" colon 50
	pod_need    label "������"   colon 68

	t_line      label "���"    colon 5
	pt_desc1    no-label		colon 18
	po_curr     label "�ұ�"	    colon 50
	pt_pur_lead label "�ɹ���ǰ" colon 68

	t_app       label "���"    colon 5
	pt_desc2    no-label		colon 18
    v_lt        label "����LT"  colon 68

	t_rmks      label "��ע"  colon 5
with frame b side-labels width 80 attr-space.         


/* DISPLAY */
view frame a.
view frame c.
view frame b.

mainloop:
repeat with frame a:
    clear frame a no-pause .
    clear frame c all no-pause .
	clear frame b no-pause .
	choice = no .
	v_site = global_site .

    update v_site vend date date1 nbr nbr1 v_app v_yn with frame a .

	find first si_mstr where si_site = v_site no-lock no-error .
	if avail si_mstr then do:

		  {gprun.i ""gpsiver.p"" 
			 "(input v_site,
			   input ?,
			   output isAuthorized)"}

		  if isAuthorized = 0 then do:
				/* MESSAGE #725 - USER DOES NOT HAVE ACCESS TO THIS SITE. */
				message "�û�û������ص�Ĵ�ȡȨ��" view-as alert-box .
				undo,retry .
		  end.
	end.
	else do:
		message "�ص�:" v_site "��Ч,����������." view-as alert-box.
		undo,retry .
	end.

	if vend = "" then do:
		message "��Ӧ�̲���Ϊ��" .
		undo ,retry .
	end.

	for each temp:
		delete temp.
	end.	
    clear frame c all no-pause .
	clear frame b no-pause .

	for each po_mstr use-index po_vend 
		where po_vend = vend 
		and po_site = v_site 
		and po_nbr >= nbr and (po_nbr <= nbr1 or nbr1 = "")
		and po_ord_date >= date and po_ord_date <= date1 
		and (po__chr01 = "" /*δ���or���δ�� or v_app = no */)
		and po_stat = "" 
		/*and po__chr02 = "A" PR�Զ�ת����*/
		exclusive-lock break by po_nbr:
		
	
			/*find first pod_det where pod_nbr = po_nbr and pod__chr01 = "" no-lock no-error .
			if avail pod_Det then do  :	
				if po__chr01 = "A" then do: 
					po__chr01 = "" .
						po__chr03 = global_userid .
						po__dte01 = today .
				end.
			end.*/


			for each pod_det where pod_nbr = po_nbr 
				and (pod__chr01 = "" /*δ���or���δ�� */ or v_app = no )
				/*and (pod__chr02 = "" /*δ���*/ ) */
				no-lock:
				
				find first temp where t_nbr = pod_nbr and t_line = pod_line no-lock no-error.
				if not avail temp then do:
					create temp .
					assign  t_nbr = pod_nbr 
							t_line = pod_line 
							t_podline = pod_line
							t_part = pod_part 
							t_date = po_ord_date
							t_qty = pod_qty_ord
							t_price = pod_pur_cost
							t_app = if v_yn = yes then yes else no
							t_select = ""
							t_rmks = pod__chr02 .
				end. /*if not avail temp*/
			end. /*for each pod_det*/
	end. /*for each po_mstr*/

	find first temp no-lock no-error.
	if not avail temp then  do:
		message "��δ��˵Ĳɹ���." .
		undo, retry .
	end.

	sw_block:
	repeat :
		/*find first temp no-lock no-error .
		if not avail temp then leave .*/
		for first temp no-lock:
		end.		
		{xxswslxp.i
			&detfile      = temp
			&scroll-field = t_nbr
			&framename    = "c"
			&framesize    = 6
			&sel_on       = ""*""
			&sel_off      = """"
			&display1     = t_select
			&display2     = t_nbr
			&display3     = t_line
            &display4     = t_date
			&display5     = t_part
			&display6     = t_qty
			&display7     = t_price
			&display8     = t_app
			&exitlabel    = sw_block
			&exit-flag    = first_sw_call
			&record-id    = temp_recno
			&include2       = " update t_app . "
		}
		if keyfunction(lastkey) = "end-error"
			or lastkey = keycode("F4")
			or lastkey = keycode("ESC")
		then do:
				for each temp exclusive-lock:
					delete temp.
				end.
				clear frame c all no-pause .
				clear frame b no-pause .
				undo,leave .
		end.  /*if keyfunction(lastkey)*/  
		
		if keyfunction(lastkey) = "go"
		then do:
			choice = yes .
			leave .
		end.  /*if keyfunction(lastkey)*/  

		for first temp where t_select = "*" exclusive-lock with frame b :
			assign t_select = "" .
			clear frame b no-pause .

			find first pt_mstr where pt_part = t_part no-lock no-error .
			find first po_mstr where po_nbr = t_nbr no-lock no-error .
			find first pod_det where pod_nbr = t_nbr and pod_line  = t_line no-lock no-error .

			v_lt = no .
			if avail pt_mstr and avail pod_det then do :
				if pod_need - pt_pur_lead >= today then v_lt = yes .
			end.

			disp t_nbr t_line t_app t_rmks v_lt  with frame b .
			if avail pt_mstr then disp pt_desc1 pt_desc2 pt_pur_lead  with frame b .
			if avail pod_det then disp po_Curr po_cr_terms with frame b .
			if avail pod_det then disp pod_part pod_need with frame b .

			if t_app = no then do :

				update t_rmks with fram b .
				if t_rmks = "" then do:
					message "���δ������α���ά����ע." .
					pause  .
					undo ,retry .
				end.

			end.
			
		end. /*for first temp*/

		temp_recno = recid(temp) .

		find next temp no-lock no-error.
		if available temp then do:
			temp_recno = recid(temp) .
		end.

	end.	/*sw_block:*/

	if choice then do :

			{pxmsg.i &MSGNUM     = 12 &ERRORLEVEL = 1 &CONFIRM = choice }
			if choice then do :
 				for each temp no-lock:
				    for each pod_det where pod_nbr = t_nbr and pod_line = t_line exclusive-lock :
						assign pod__chr01 = if t_app then "A" else "" 
							   pod__chr02 = t_rmks 
							   pod__chr03 = global_userid
							   pod__dte01 = today 
							   pod__dec01 = time .

						find first rqd_det where rqd_nbr = pod_req_nbr and rqd_line = pod_req_line exclusive-lock no-error .
						if avail rqd_det then do: 
							rqd__chr01 = t_rmks.
						end.

				    end.
						/*����PO��Ϊδ���*/ /*
						find first pod_det where pod_nbr = t_nbr and pod__chr01 = "" no-lock no-error.
						if avail pod_det then do : 
							find first po_mstr where po_nbr = t_nbr exclusive-lock no-error .
							if avail po_mstr then do:
								if po__chr01 = "A" then do: 
									po__chr01 = "" .
										po__chr03 = global_userid .
										po__dte01 = today .
								end. 
							end.
						end.*/
					
				end .   /*for each temp */

				for each temp exclusive-lock:
					delete temp.
				end.
				clear frame c all no-pause .
				clear frame b no-pause .

			end.  /*if choice then*/
			else do:
				for each temp exclusive-lock:
					delete temp.
				end.
				clear frame c all no-pause .
				clear frame b no-pause .
			end.

	end.  /*if choice then*/

	global_site = v_site .
end.   /*  mainloop: */

status input.
