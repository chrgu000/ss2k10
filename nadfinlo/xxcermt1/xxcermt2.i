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
	xxcer_std1
	xxcer_std2
	xxcer_std3
	xxcer_std4
	xxcer_std5
	xxcer_std6
	xxcer_std7
	xxcer_std8
	with frame a .

	update
	xxcer_std_user
	xxcer_std_date
	with frame a2 .

	/*******����Ƿ����޸�ԭ��¼����û�б��޸Ĺ������޸Ĺ������¼�¼xxcer_mod_date = today
		  xxcer_mod_user = global_userid
	BEGIN	  .*/
		if 
		   (old_xxcer_std1	<> xxcer_std1		)
		or (old_xxcer_std2	<> xxcer_std2		)
		or (old_xxcer_std3	<> xxcer_std3		)
		or (old_xxcer_std4	<> xxcer_std4		)
		or (old_xxcer_std5	<> xxcer_std5		)
		or (old_xxcer_std6	<> xxcer_std6		)
		or (old_xxcer_std7	<> xxcer_std7		)
		or (old_xxcer_std8	<> xxcer_std8		)
		or (old_xxcer_std_user	<> xxcer_std_user	)
		or (old_xxcer_std_date	<> xxcer_std_date	)
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


