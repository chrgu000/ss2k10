find first xxcer_mstr where xxcer_nbr = danju no-error .
if not avail xxcer_mstr then do:
	message "�����뵥�Ų�����,����������." view-as alert-box .
	next .
end.
else do:
	{xxcerdisp1.i}	
end.

	pause 0 .
repeat on endkey undo, leave:
	/*display xxcer_dec_rmks1
	xxcer_dec_rmks2
	xxcer_dec_rmks3 with frame a42 .*/
	update
	xxcer_dec_rmks1
	xxcer_dec_rmks2
	xxcer_dec_rmks3
	xxcer_dec_result
	xxcer_pur_qty   
	xxcer_dec_user  
	xxcer_dec_date  
	xxcer_test_per  
	xxcer_test_date 
	xxcer_qm_per    
	xxcer_qm_date   
	xxcer_eng_per   
	xxcer_eng_date  
	xxcer_audit_user
	xxcer_audit_date
	xxcer_effdate   validate(input xxcer_effdate <> ? ,"��Ч���ڲ���Ϊ��")
	xxcer_expire    /*validate(input xxcer_expire <> ? ,"�������ڲ���Ϊ��")*/
	with frame a42 editing:
		if frame-field = "xxcer_dec_result" then do:			
			{mfnp01.i code_mstr xxcer_dec_result code_value 'xxcer_dec_result' code_fldname  code_fldval}
			if recno <> ? then do:
				display code_value @ xxcer_dec_result with frame a42.
			end.			
		end.
		else do:
			status input.
			readkey.
			apply lastkey.
		end.
	end.

	find first code_mstr where code_fldname = "xxcer_dec_result" and code_value = xxcer_dec_result no-lock no-error.
	if not avail code_mstr then do:
		message "ͨ�ô����в����QA������,����������."  .
		next-prompt xxcer_dec_result with frame a42 .
		/*undo,retry .*/
		next .
	end.
	if xxcer_expire <> ? then do:
	if xxcer_expire < xxcer_effdate then do:
		message "�������ڲ���С����Ч����,����������."  .
		next-prompt xxcer_expire with frame a42 .
		next .
	end.
	end.
	
	/*******����Ƿ����޸�ԭ��¼����û�б��޸Ĺ������޸Ĺ������¼�¼xxcer_mod_date = today
		  xxcer_mod_user = global_userid
	BEGIN	  .*/
		if 
		   (old_xxcer_dec_rmks1		<> old_xxcer_dec_rmks1 	)
		or (old_xxcer_dec_rmks2		<> old_xxcer_dec_rmks2 	)
		or (old_xxcer_dec_rmks3		<> old_xxcer_dec_rmks3 	)
		or (old_xxcer_dec_result	<> old_xxcer_dec_result	)
		or (old_xxcer_pur_qty		<> old_xxcer_pur_qty   	)
		or (old_xxcer_ord_qty		<> old_xxcer_ord_qty   	)
		or (old_xxcer_dec_user		<> old_xxcer_dec_user  	)
		or (old_xxcer_dec_date		<> old_xxcer_dec_date  	)
		or (old_xxcer_test_per  	<> old_xxcer_test_per  	)
		or (old_xxcer_test_date 	<> old_xxcer_test_date 	)
		or (old_xxcer_qm_per    	<> old_xxcer_qm_per    	)
		or (old_xxcer_qm_date   	<> old_xxcer_qm_date   	)
		or (old_xxcer_eng_per   	<> old_xxcer_eng_per   	)
		or (old_xxcer_eng_date  	<> old_xxcer_eng_date  	)
		or (old_xxcer_audit_user	<> old_xxcer_audit_user	)
		or (old_xxcer_audit_date	<> old_xxcer_audit_date	)
		or (old_xxcer_effdate   	<> old_xxcer_effdate   	)
		or (old_xxcer_expire    	<> old_xxcer_expire    	)
		then do:
			assign
			xxcer_mod_date = today 
			xxcer_mod_user = global_userid .
		end.
	/*******����Ƿ����޸�ԭ��¼����û�б��޸Ĺ������޸Ĺ������¼�¼xxcer_mod_date = today
		  xxcer_mod_user = global_userid
	END	  .*/

	/*---Add Begin by davild 20080707.1*/
	del-yn = yes .
	if xxcer_avail = no then do:
		message "�Ƿ񼤻��CER���뵥��: " + danju + " (Yes/No)." update del-yn .
		if del-yn then do:
			/***ͬһ�����ͬһ��Ӧ�̣����ܴ���OK/QTY/ALLOC�������͵�CER��Ч�����ص��������
			 BEGIN  �ڱ���ʱ��һ����Ҫ����б������****/
			 pause 0 .
			{gprun.i ""xxcecheckeffdate.p""
			"(input danju,
			  input xxcer_part,
			  input xxcer_vend,
			  input xxcer_dec_result,
			  input xxcer_effdate,
			  input xxcer_expire,
			  output checkEffdateError
			)"}
			if checkEffdateError then do:
				next-prompt xxcer_effdate with frame a42 .
				undo,retry .
			end.
			/***ͬһ�����ͬһ��Ӧ�̣����ܴ���OK/QTY/ALLOC�������͵�CER��Ч�����ص��������
			 END  �ڱ���ʱ��һ����Ҫ����б������****/
			else
			assign xxcer_avail = yes .
		end.
	end.
	else do:
		message "����:�Ƿ�ȡ�������CER���뵥��: " + danju + " (Yes/No)." update del-yn .
		if del-yn then assign xxcer_avail = no .
	end.
	/*---Add End   by davild 20080707.1*/

	leave .
end.


