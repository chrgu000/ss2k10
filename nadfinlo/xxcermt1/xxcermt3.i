find first xxcer_mstr where xxcer_nbr = danju no-error .
if not avail xxcer_mstr then do:
	message "�����뵥�Ų�����,����������." view-as alert-box .
	next .
end.
else do:
	{xxcerdisp1.i}	
end.
repeat on endkey undo, leave:
	update
	xxcer_result1
	xxcer_result2
	xxcer_result3
	xxcer_result4
	xxcer_result5
	xxcer_result6
	xxcer_result7
	xxcer_result8
	with frame a .

	repeat :
		update
		xxcer_qc_result  validate(input xxcer_qc_result <> "","QA����������Ϊ��")
		xxcer_result_user
		xxcer_result_date
		with frame a3 editing:
			if frame-field = "xxcer_qc_result" then do:				
				{mfnp01.i code_mstr xxcer_qc_result code_value 'xxcer_qc_result' code_fldname  code_fldval}
				if recno <> ? then do:
					display code_value @ xxcer_qc_result with frame a3.
				end.			
			end.
			else do:
				status input.
				readkey.
				apply lastkey.
			end.
		end.
		find first code_mstr where code_fldname = "xxcer_qc_result" and code_value = xxcer_qc_result no-lock no-error.
		if not avail code_mstr then do:
			message "ͨ�ô����в����QA������,����������."  .
			next-prompt xxcer_qc_result with frame a3 .
			undo,retry .
		end.
		leave.
	end.
	/*******����Ƿ����޸�ԭ��¼����û�б��޸Ĺ������޸Ĺ������¼�¼xxcer_mod_date = today
		  xxcer_mod_user = global_userid
	BEGIN	  .*/
		if 
		   (old_xxcer_result1	<> xxcer_result1		)
		or (old_xxcer_result2	<> xxcer_result2		)
		or (old_xxcer_result3	<> xxcer_result3		)
		or (old_xxcer_result4	<> xxcer_result4		)
		or (old_xxcer_result5	<> xxcer_result5		)
		or (old_xxcer_result6	<> xxcer_result6		)
		or (old_xxcer_result7	<> xxcer_result7		)
		or (old_xxcer_result8	<> xxcer_result8		)
		or (old_xxcer_qc_result  	<> xxcer_qc_result  	)
		or (old_xxcer_result_user	<> xxcer_result_user	)
		or (old_xxcer_result_date	<> xxcer_result_date	)
		then do:
			assign
			xxcer_mod_date = today 
			xxcer_mod_user = global_userid .
		end.
	/*******����Ƿ����޸�ԭ��¼����û�б��޸Ĺ������޸Ĺ������¼�¼xxcer_mod_date = today
		  xxcer_mod_user = global_userid
	END	  .*/
	leave .
end.


