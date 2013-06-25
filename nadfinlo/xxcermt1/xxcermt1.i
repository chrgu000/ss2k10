/* Creation: eB21SP3 Chui Last Modified: 20080421 By: Davild Xu *ss-20080421.1*/
/*物料测试表申请*/
new_order = no .
/*1.自动产生单号--BEGIN*/

if danju = "" then do: 
	do transaction:
		{xxcerautodanhao.i}	/*自动产生*/
	end.	
	release rqf_ctrl .
	new_order = yes .
	message "加入新记录." .
end .
else do:
	find first xxcer_mstr where xxcer_nbr = danju no-error .
	if avail xxcer_mstr then do:
		{xxcerdisp1.i}
	end.
	else do:
		/*message "此申请单号不存在,请重新输入或置空自动产生." view-as alert-box .
		next .*/
		new_order = yes .
		message "加入新记录." .
	end.
end.

del-yn = no .
repeat on endkey undo, leave:
	if new_order then do:
	   create xxcer_mstr .
	   assign xxcer_nbr = danju .
	   assign xxcer_add_date = today
		  xxcer_user     = global_userid
		  xxcer_mod_date = today
		  xxcer_mod_user = global_userid
		  .
	end.
	status default "F1-执行 F2-提示 F3-插入 F4-结束 F5-删除 F7-重复 F8-清除" .
	update 
	       xxcer_req_dpt 	validate(input xxcer_req_dpt <> "","申请部门不能为空")
	       xxcer_req_user	validate(input xxcer_req_user <> "","申请人不能为空")
	       xxcer_test_dpt	validate(input xxcer_test_dpt <> "","测试部门不能为空")
	       xxcer_due_date	validate(input xxcer_due_date <> ? ,"要求完成日期不能为空")
	       xxcer_vend    validate(input xxcer_vend <> "","供应商代码不能为空")
	       xxcer_part    validate(input xxcer_part <> "","零件号不能为空")
	       xxcer_qty     	
	       xxcer_usage   	validate(input xxcer_usage <> "","用途不能为空")
	       xxcer_safety  
		WITH FRAME a editing:
		status default "F1-执行 F2-提示 F3-插入 F4-结束 F5-删除 F7-重复 F8-清除" .
		/*---Add Begin by davild 20080421.1*/
		if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
		       then do:
			  del-yn = yes.
			  /* 11 - PLEASE CONFIRM DELETE */
			  {pxmsg.i &MSGNUM     = 11
				   &ERRORLEVEL = 1
				   &CONFIRM    = del-yn
			  }
			  if del-yn then leave .			  
		end. /* IF ppform = "" AND ... */
		else
		/*---Add End   by davild 20080421.1*/
		      

		if frame-field = "xxcer_req_dpt" then do:
			{mfnp.i dpt_mstr xxcer_req_dpt dpt_dept xxcer_req_dpt dpt_dept dpt_dept}
			if recno <> ? then display dpt_dept @ xxcer_req_dpt with frame a.
		end.
		else if frame-field = "xxcer_test_dpt" then do:
			{mfnp.i dpt_mstr xxcer_test_dpt dpt_dept xxcer_test_dpt dpt_dept dpt_dept}
			if recno <> ? then display dpt_dept @ xxcer_test_dpt with frame a .
		end.
		else if frame-field = "xxcer_vend" then do:
			/*status input.
			readkey.
			apply lastkey.*/
			{mfnp.i vd_mstr xxcer_vend vd_addr xxcer_vend vd_addr vd_addr}
			if recno <> ? then do:
				v_name = vd_sort .
				xxcer_vend = vd_addr .
				display v_name xxcer_vend with frame a.
			end.
		end.
		else if frame-field = "xxcer_part" then do:
			{mfnp.i pt_mstr xxcer_part pt_part xxcer_part pt_part pt_part}
			if recno <> ? then do:
				desc1 = pt_desc1 .
				desc2 = pt_desc2 .
				display desc1 pt_part @ xxcer_part with frame a.
			end.			
		end.
		else if frame-field = "xxcer_usage" then do:
			{mfnp01.i code_mstr xxcer_usage code_value 'xxcer_usage' code_fldname  code_fldval}
			if recno <> ? then do:
				display code_value @ xxcer_usage with frame a.
			end.			
		end.		
		
		else do:
			status input.
			readkey.
			apply lastkey.
		end.
		
	end.
	/*检验数据--BEGIN*/
	find first dpt_mstr where dpt_dept = xxcer_req_dpt no-lock no-error.
	if not avail dpt_mstr then do:
		message "不正确的部门,请重新输入."  .
		next-prompt xxcer_req_dpt with frame a .
		next .
	end.
	find first dpt_mstr where dpt_dept = xxcer_test_dpt no-lock no-error.
	if not avail dpt_mstr then do:
		message "不正确的部门,请重新输入."  .
		next-prompt xxcer_test_dpt with frame a .
		next .
	end.
	find first vd_mstr where vd_addr = xxcer_vend no-lock no-error.
	if not avail vd_mstr then do:
		message "不正确的供应商代码,请重新输入."  .
		next-prompt xxcer_vend with frame a .
		next .
	end. 
	else do :	
		v_name = vd_sort .
		display v_name with frame a.
	end.
	find first pt_mstr where pt_part = xxcer_part no-lock no-error.
	if not avail pt_mstr then do:
		message "不正确的零件编号,请重新输入."  .
		next-prompt xxcer_part with frame a .
		next .
	end.
	else do:
		desc1 = pt_desc1 .
		desc2 = pt_desc2 .
		assign xxcer_site = pt_site .
		display desc1 with frame a.
	end.
	find first code_mstr where code_fldname = "xxcer_usage" and code_value = xxcer_usage no-lock no-error.
	if not avail code_mstr then do:
		message "通用代码中不存此用途,请重新输入."  .
		next-prompt xxcer_usage with frame a .
		next .
	end.

	/*检验数据--END*/

	/*******检查是否是修改原记录且有没有被修改过，若修改过则重新记录xxcer_mod_date = today
		  xxcer_mod_user = global_userid
	BEGIN	  .*/
	if new_order = no then do:
		if (old_xxcer_req_dpt 	<> xxcer_req_dpt	)
		or (old_xxcer_req_user	<> xxcer_req_user 	)
		or (old_xxcer_test_dpt	<> xxcer_test_dpt 	)
		or (old_xxcer_due_date	<> xxcer_due_date 	)
		or (old_xxcer_vend    	<> xxcer_vend     	)
		or (old_xxcer_part    	<> xxcer_part     	)
		or (old_xxcer_qty     	<> xxcer_qty      	)
		or (old_xxcer_usage   	<> xxcer_usage    	)
		or (old_xxcer_safety  	<> xxcer_safety   	)
		or (old_xxcer_std1		<> xxcer_std1	) 
		or (old_xxcer_result1	<> xxcer_result1	) 
		or (old_xxcer_std2		<> xxcer_std2	) 
		or (old_xxcer_result2	<> xxcer_result2	) 
		or (old_xxcer_std3		<> xxcer_std3	) 
		or (old_xxcer_result3	<> xxcer_result3	) 
		or (old_xxcer_std4		<> xxcer_std4	) 
		or (old_xxcer_result4	<> xxcer_result4	) 
		or (old_xxcer_std5		<> xxcer_std5	) 
		or (old_xxcer_result5	<> xxcer_result5	) 
		or (old_xxcer_std6		<> xxcer_std6	) 
		or (old_xxcer_result6	<> xxcer_result6	) 
		or (old_xxcer_std7		<> xxcer_std7	) 
		or (old_xxcer_result7	<> xxcer_result7	) 
		or (old_xxcer_std8		<> xxcer_std8	) 
		or (old_xxcer_result8	<> xxcer_result8	)
		then do:
			assign
			xxcer_mod_date = today 
			xxcer_mod_user = global_userid .
		end.
	end.
	/*******检查是否是修改原记录且有没有被修改过，若修改过则重新记录xxcer_mod_date = today
		  xxcer_mod_user = global_userid
	END	  .*/
	leave .
	new_order = no .
end.
if del-yn then do:
  if xxcer_avail then do:
	hide message no-pause .
	message "此CER处于激活状态,不能删除." .
	.
  end.
  else do:
  {gprun.i ""xxcerdelete.p"" "(input danju)"}
  message "CER申请单号 " + danju + " 成功被删除." .
  danju = "" .
  display danju with frame a .
  end.
end.