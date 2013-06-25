find first vd_mstr where vd_addr = xxcer_vend no-lock no-error.
if not avail vd_mstr then do:
	message "不正确的供应商代码."  .
end. 
else do :	
	v_name = vd_sort .
	display v_name with frame a.
end.
find first pt_mstr where pt_part = xxcer_part no-lock no-error.
if not avail pt_mstr then do:
	message "不正确的零件编号."  .
end.
else do:
	desc1 = pt_desc1 .
	desc2 = pt_desc2 .
	display desc1 with frame a.
end.
display 
xxcer_avail
xxcer_req_dpt 	
xxcer_req_user	
xxcer_test_dpt	
xxcer_due_date	
xxcer_vend    	
v_name		
xxcer_part    	
desc1     	
xxcer_qty     	
xxcer_usage   	
xxcer_safety  			
xxcer_std1	
xxcer_result1	
xxcer_std2	
xxcer_result2	
xxcer_std3	
xxcer_result3	
xxcer_std4	
xxcer_result4	
xxcer_std5	
xxcer_result5	
xxcer_std6	
xxcer_result6	
xxcer_std7	
xxcer_result7	
xxcer_std8	
xxcer_result8	
with frame a .

assign 
old_xxcer_req_dpt 	= xxcer_req_dpt  
old_xxcer_req_user	= xxcer_req_user 
old_xxcer_test_dpt	= xxcer_test_dpt 
old_xxcer_due_date	= xxcer_due_date 
old_xxcer_vend    	= xxcer_vend     
old_xxcer_part    	= xxcer_part     
old_xxcer_qty     	= xxcer_qty      
old_xxcer_usage   	= xxcer_usage    
old_xxcer_safety  	= xxcer_safety   	
old_xxcer_std1		= xxcer_std1	 
old_xxcer_result1	= xxcer_result1	 
old_xxcer_std2		= xxcer_std2	 
old_xxcer_result2	= xxcer_result2	 
old_xxcer_std3		= xxcer_std3	 
old_xxcer_result3	= xxcer_result3	 
old_xxcer_std4		= xxcer_std4	 
old_xxcer_result4	= xxcer_result4	 
old_xxcer_std5		= xxcer_std5	 
old_xxcer_result5	= xxcer_result5	 
old_xxcer_std6		= xxcer_std6	 
old_xxcer_result6	= xxcer_result6	 
old_xxcer_std7		= xxcer_std7	 
old_xxcer_result7	= xxcer_result7	 
old_xxcer_std8		= xxcer_std8	 
old_xxcer_result8	= xxcer_result8  
old_xxcer_std_user	= xxcer_std_user  
old_xxcer_std_date	= xxcer_std_date  
old_xxcer_qc_result	= xxcer_qc_result		  
old_xxcer_result_user	= xxcer_result_user  
old_xxcer_result_date	= xxcer_result_date 

old_xxcer_dec_rmks1	= xxcer_dec_rmks1 
old_xxcer_dec_rmks2	= xxcer_dec_rmks2 
old_xxcer_dec_rmks3	= xxcer_dec_rmks3
old_xxcer_dec_result	= xxcer_dec_result 
old_xxcer_pur_qty   	= xxcer_pur_qty    
old_xxcer_ord_qty   	= xxcer_ord_qty    
old_xxcer_dec_user  	= xxcer_dec_user   
old_xxcer_dec_date  	= xxcer_dec_date   
old_xxcer_test_per  	= xxcer_test_per   
old_xxcer_test_date 	= xxcer_test_date  
old_xxcer_qm_per    	= xxcer_qm_per     
old_xxcer_qm_date   	= xxcer_qm_date    
old_xxcer_eng_per   	= xxcer_eng_per    
old_xxcer_eng_date  	= xxcer_eng_date   
old_xxcer_audit_user	= xxcer_audit_user 
old_xxcer_audit_date	= xxcer_audit_date 
old_xxcer_effdate   	= xxcer_effdate    
old_xxcer_expire    	= xxcer_expire    
.
/*物料测试表检查标准维护*/
if execname begins "xxcermt2" then do:
display xxcer_std_user
	xxcer_std_date
	with frame a2 .

end.
/*物料检查表检查结果维护*/
if execname begins "xxcermt3" then do:
display xxcer_qc_result	
	xxcer_result_user
	xxcer_result_date
	with frame a3 .
end.
/*物料检查表最后判定维护*/
if execname begins "xxcermt4" then do:
display xxcer_dec_rmks1
	xxcer_dec_rmks2
	with frame a4 .
end.