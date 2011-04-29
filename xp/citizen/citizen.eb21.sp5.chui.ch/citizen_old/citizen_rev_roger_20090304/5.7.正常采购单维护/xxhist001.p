/* $CREATED BY: softspeed Roger Xiao         DATE: 2008/01/12  ECO: *xp002*  */  /*��ʷ��¼*/
/*-Revision end---------------------------------------------------------------*/


{mfdeclre.i}

define input parameter v_module as char  .          /*module:=PO,SO,...*/
define input parameter v_nbr    as char  .          /*nbr:���ݺ�*/
define input parameter v_todo   as integer  .       /*todo: 1.����ǰ����, 2.��ʽ���� 3.���ݷ��м�¼ 4.��ʽ��ֹɾ������ */
define output parameter v_hist  like mfc_logical  . /*�Ƿ������޸�,�������������Ƿ��ѷ���(���Ƿ�����ӡ)*/


define var v_yn  like mfc_logical.
define var v_rls like mfc_logical.
define var v_time as integer .


histloop:
do on error undo, leave:
/*part1: ********************************************************************************************/
find first xrevc_ctrl where xrevc_domain = global_domain no-error .
if not avail xrevc_ctrl then do :
	create xrevc_ctrl . 
	xrevc_ctrl.xrevc_domain = global_domain .
	release xrevc_ctrl . 
end.
find first xrevc_ctrl where xrevc_domain = global_domain no-lock no-error .
v_yn  = xrevc_yn.
v_rls = xrevc_release .
v_hist = no .
v_time = 0 .

if v_yn = no then do:
	message "����:�����޸Ĺ���δ����." .
	leave .
end.
if v_rls = yes then do:
	message "����:����¼�ѷ��еĵ���." .
end.

/*part2: ********************************************************************************************/

if v_todo = 1 then do: /*todo:1����ǰ����*/
	if v_module = "PO" then do:
		find first po_mstr where po_domain = global_domain and po_nbr = v_nbr no-lock no-error.
		if not avail po_mstr then do:
			message "��������¼:" v_nbr . leave .
		end.
		else do:
			find first pod_det where pod_domain = global_domain and pod_nbr = v_nbr no-lock no-error.
			if not avail pod_det then do:
				message "����ϸ����¼:" v_nbr. leave .
			end.
		end.
		
		if po__chr01 = "" and v_rls then do :
			message "������δ����.". leave .
		end.

		for each po_mstr where po_domain = global_domain and po_nbr = v_nbr no-lock,
			each pod_Det where pod_domain = global_domain and pod_nbr = po_nbr no-lock 
			break by pod_nbr by pod_line :
			find first xrev_hist 
					where xrev_domain = global_domain 
					and  xrev_key1 = v_module
					and  xrev_key2 = v_nbr 
					and  xrev_key3 = string(pod_line) 
					/**/
					and  xrev_chr01  = po_vend
					and  xrev_chr02  = po_ship
					and  xrev_chr03  = pod_part
					and  xrev_chr04  = pod_rev
					and  xrev_int01  = po_rev
					and  xrev_dec01  = pod_qty_ord
					and  xrev_dec02  = pod_pur_cost
					and  xrev_dte01  = pod_due_date
					and  xrev_dte02  = pod_need
					and  xrev_dte03  = pod_per_date
					and  xrev_dte04  = po_due_date
					
			no-error .
			if not avail xrev_hist then do:
				create xrev_hist.
				assign 
					xrev_domain = global_domain 
					 xrev_key1 = v_module
					 xrev_key2 = v_nbr 
					 xrev_key3 = string(pod_line) 
					 /**/
					 xrev_chr01  = po_vend
					 xrev_chr02  = po_ship
					 xrev_chr03  = pod_part
					 xrev_chr04  = pod_rev
					 xrev_int01  = po_rev
					 xrev_dec01  = pod_qty_ord
					 xrev_dec02  = pod_pur_cost
					 xrev_dte01  = pod_due_date
					 xrev_dte02  = pod_need
					 xrev_dte03  = pod_per_date
					 xrev_dte04  = po_due_date
					  .
				assign xrev_user1 = global_userid 
					   xrev_user2 = mfguser
					   xrev_date1 = today 
					   xrev_time1 = time 
					   xrev_release = if po__chr01 = "R" then yes else no .
				{mfrnseq.i xrev_hist xrev_hist.xrev_idx kbtr_sq01}   
			end.
								 
		end.  /*for each po_mstr*/		
	end.  /*if v_module = "PO" then*/
end. /*todo:1����ǰ����*/
else if v_todo = 2 then do: /*todo:2��ʽ����*/
	if v_module = "PO" then do:
		find first po_mstr where po_domain = global_domain and po_nbr = v_nbr no-lock no-error.
		if not avail po_mstr then do:
			message "��������¼:" v_nbr . leave .
		end.
		else do:
			find first pod_det where pod_domain = global_domain and pod_nbr = v_nbr no-lock no-error.
			if not avail pod_det then do:
				message "����ϸ����¼:" v_nbr. leave .
			end.
		end.
		
		
		find last xrev_hist 
					where xrev_domain = global_domain
					and  xrev_key1 = v_module
					and  xrev_key2 = v_nbr 
					and xrev_user2 = mfguser
					and xrev_date1 = today 
		no-lock no-error .
		v_time = if avail xrev_hist then (xrev_time1 - 5 ) else 0 .

		for each xrev_hist 
					where xrev_domain = global_domain
					and  xrev_key1 = v_module
					and  xrev_key2 = v_nbr 
					and xrev_user2 = mfguser
					and xrev_date1 = today
					and xrev_time1 >= v_time  no-lock:

			find first pod_Det 
					where pod_domain = global_domain 
					and pod_nbr = xrev_key2
					and string(pod_line) = xrev_key3
			no-lock no-error .
			if not avail pod_det then do: /*record deleted*/ 
				if v_rls = yes then do:
					if po__chr01 = "R" then v_hist = yes . 
				end.
				else  v_hist = yes . 
			end.
			else do: /*old*/
				if not ( xrev_chr03  = pod_part
					and  xrev_chr04  = pod_rev
					and  xrev_dec01  = pod_qty_ord
					and  xrev_dec02  = pod_pur_cost
					and  xrev_dte01  = pod_due_date
					and  xrev_dte02  = pod_need
					and  xrev_dte03  = pod_per_date	
				   )
				then  do: /*���޸�*/
					if v_rls = yes then do:
						if po__chr01 = "R" then v_hist = yes . 
					end.
					else  v_hist = yes . 																
				end. /*���޸�*/
			end. /*old*/		
		
		end. /*for each xrev_hist*/


		for each po_mstr where po_domain = global_domain and po_nbr = v_nbr no-lock,
			each pod_Det where pod_domain = global_domain and pod_nbr = po_nbr no-lock 
			break by pod_nbr by pod_line :
			find last xrev_hist 
					where xrev_domain = global_domain 
					and  xrev_key1 = v_module
					and  xrev_key2 = v_nbr 
					and  xrev_key3 = string(pod_line) 
					and xrev_user2 = mfguser
			no-error .
			if not avail xrev_hist then do:
				/*���������,û���޸ļ�¼*/
					if v_rls = yes then do:
						if po__chr01 = "R" then v_hist = yes . 
					end.
					else  v_hist = yes . 
			end.
			else do: /*old*/					
					if  /**/
						     xrev_chr01  = po_vend
						and  xrev_chr02  = po_ship
						and  xrev_dte04  = po_due_date 

						and  xrev_chr03  = pod_part
						and  xrev_chr04  = pod_rev

						and  xrev_dec01  = pod_qty_ord
						and  xrev_dec02  = pod_pur_cost

						and  xrev_dte01  = pod_due_date
						and  xrev_dte02  = pod_need
						and  xrev_dte03  = pod_per_date
						
					then do:
						delete xrev_hist . /*δ�޸Ĺ�ע���ֶ�,����¼*/
						
					end.
					else do: /*���޸�*/
						/*message  "nbr/line:" pod_nbr pod_line
						skip  "1_vender_shipto_due_rev:"  xrev_chr01  = po_vend xrev_chr02  = po_ship  xrev_dte04  = po_due_date xrev_int01 = po_rev
						skip  "2_part_partrev_qty_price:"   xrev_chr03  = pod_part xrev_chr04  = pod_rev xrev_dec01  = pod_qty_ord xrev_dec02 = pod_pur_cost 
						skip  "3_date_need_due_per:"  xrev_dte02  = pod_need xrev_dte01  = pod_due_date  xrev_dte03  = pod_per_date
						skip "4_(just-rls)_(rls-or-not):"   v_rls xrev_release
						view-as alert-box .
						*/
						 
								
						if v_rls = yes and xrev_release = no then do:
							delete xrev_hist . /*������δ���� & ����¼�ѷ��еĵ���.*/
						end.
						else do:
							assign xrev_user1 = global_userid 
								   xrev_date1 = today 
								   xrev_time1 = time .
								   v_hist = yes .
						end.											
					end. /*���޸�*/

			end.  /*old*/									 
		end. /*for each po_mstr*/		
	end.  /*if v_module = "PO" then*/


end. /*todo:2��ʽ����*/
else if v_todo = 3 then do: /*todo:3���ݷ��м�¼ */
/*********
	/*Ҫ(������ʽor here)����һ��v_todo = 1�Ķ���,��������=3�Ķ���*/
	if v_module = "PO" then do:
		find first po_mstr where po_domain = global_domain and po_nbr = v_nbr no-lock no-error.
		if not avail po_mstr then do:
			message "��������¼:" v_nbr . leave .
		end.
		else do:
			find first pod_det where pod_domain = global_domain and pod_nbr = v_nbr no-lock no-error.
			if not avail pod_det then do:
				message "����ϸ����¼:" v_nbr. leave .
			end.
		end.
		
		for each po_mstr where po_domain = global_domain and po_nbr = v_nbr no-lock,
			each pod_Det where pod_domain = global_domain and pod_nbr = po_nbr no-lock 
			break by pod_nbr by pod_line :
			find first xrev_hist 
					where xrev_domain = global_domain 
					and  xrev_key1 = v_module
					and  xrev_key2 = v_nbr 
					and  xrev_key3 = string(pod_line) 
					/**/
					and  xrev_chr01  = po_vend
					and  xrev_chr02  = po_ship
					and  xrev_chr03  = pod_part
					and  xrev_chr04  = pod_rev
					and  xrev_int01  = po_rev
					and  xrev_dec01  = pod_qty_ord
					and  xrev_dec02  = pod_pur_cost
					and  xrev_dte01  = pod_due_date
					and  xrev_dte02  = pod_need
					and  xrev_dte03  = pod_per_date
					and  xrev_dte04  = po_due_date
					
			no-error .
			if not avail xrev_hist then do:
				create xrev_hist.
				assign 
					xrev_domain = global_domain 
					 xrev_key1 = v_module
					 xrev_key2 = v_nbr 
					 xrev_key3 = string(pod_line) 
					 /**/
					 xrev_chr01  = po_vend
					 xrev_chr02  = po_ship
					 xrev_chr03  = pod_part
					 xrev_chr04  = pod_rev
					 xrev_int01  = po_rev
					 xrev_dec01  = pod_qty_ord
					 xrev_dec02  = pod_pur_cost
					 xrev_dte01  = pod_due_date
					 xrev_dte02  = pod_need
					 xrev_dte03  = pod_per_date
					 xrev_dte04  = po_due_date
					  .
				assign xrev_user1 = global_userid 
					   xrev_date1 = today 
					   xrev_time1 = time .
				{mfrnseq.i xrev_hist xrev_hist.xrev_idx kbtr_sq01}   
			end.
			/***************************����Ϊv_todo = 1�Ķ���*/
			assign xrev_user2 = global_userid 
				   xrev_date2 = today 
				   xrev_time2 = time 
				   xrev_release =  yes 
				   v_hist = yes.

							 
		end.  /*for each po_mstr*/		
	end.  /*if v_module = "PO" then*/

********/
v_hist = yes .


end. /*todo:3���ݷ��м�¼ */
else if v_todo = 4 then do: /*todo:4��ʽ��ֹɾ������*/

	if v_module = "PO" then do:
		find first po_mstr where po_domain = global_domain and po_nbr = v_nbr no-lock no-error.
		if not avail po_mstr then do:
			message "��������¼:" v_nbr . leave .
		end.
		else do:
			find first pod_det where pod_domain = global_domain and pod_nbr = v_nbr no-lock no-error.
			if not avail pod_det then do:
				message "����ϸ����¼:" v_nbr. leave .
			end.
		end.
		

		for each po_mstr where po_domain = global_domain  and po_nbr = v_nbr no-lock,
			each pod_Det where pod_domain = global_domain and pod_nbr = po_nbr no-lock 
			break by pod_nbr by pod_line :
			find last xrev_hist 
					where xrev_domain = global_domain 
					and  xrev_key1 = v_module
					and  xrev_key2 = v_nbr 
					and  xrev_key3 = string(pod_line) 					
			no-error .
			if not avail xrev_hist then do:
				/*���������,û���޸ļ�¼*/
			end.
			else do: /*old*/					
					if  /**/
						     xrev_chr01  = po_vend
						and  xrev_chr02  = po_ship
						and  xrev_chr03  = pod_part
						and  xrev_chr04  = pod_rev
						and  xrev_int01  = po_rev
						and  xrev_dec01  = pod_qty_ord
						and  xrev_dec02  = pod_pur_cost
						and  xrev_dte01  = pod_due_date
						and  xrev_dte02  = pod_need
						and  xrev_dte03  = pod_per_date
						and  xrev_dte04  = po_due_date 
					then do:
						delete xrev_hist . /*δ�޸Ĺ�ע���ֶ�,����¼*/
						
					end.
					else do:
						/*���Ǵ˴ζ��������*/
					end.

					v_hist = yes .
			end.  /*old*/									 
		end. /*for each po_mstr*/		
	end.  /*if v_module = "PO" then*/	

end.  /*todo:4��ʽ��ֹɾ������*/
else do:  /*todo:���� */
	leave.
end.  /*todo:���� */







end. /*histloop:*/



