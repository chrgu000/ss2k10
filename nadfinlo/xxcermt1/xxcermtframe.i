     form
	danju		colon 12 label "申请单号" format "x(12)"
	xxcer_avail	colon 50 label "激活状态"
	xxcer_req_dpt 	colon 20 label "申请部门"
	xxcer_req_user	colon 50 label "申请人"	
	xxcer_test_dpt	colon 20 label "测试部门"
	xxcer_due_date	colon 50 label "要求完成日期"
	xxcer_vend    	colon 20 label "供应商代码"
	v_name		colon 50 label "名称"
	xxcer_part    	colon 20 label "零件号"
	desc1     	colon 50 label "说明"
	xxcer_qty     	colon 20 label "供办数量"
	xxcer_usage   	colon 50 label "用途"
	xxcer_safety  	colon 20 label "安规要求"
			"(工程)测试标准及内容                   (品管)检测情况" at 15 
	xxcer_std1	at 3	no-label	
	xxcer_result1	at 45	no-label
	xxcer_std2	at 3	no-label	
	xxcer_result2	at 45	no-label
	xxcer_std3	at 3	no-label	
	xxcer_result3	at 45	no-label
	xxcer_std4	at 3	no-label	
	xxcer_result4	at 45	no-label
	xxcer_std5	at 3	no-label	
	xxcer_result5	at 45	no-label
	xxcer_std6	at 3	no-label	
	xxcer_result6	at 45	no-label
	xxcer_std7	at 3	no-label	
	xxcer_result7	at 45	no-label
	xxcer_std8	at 3	no-label	
	xxcer_result8	at 45	no-label
	
with frame a width 80 side-label.
setFrameLabels(frame a:handle).

form
	xxcer_std_user		colon 39 label "检查指标填写人"
	xxcer_std_date		colon 69 label "检查指标填写日期"
with frame a2 width 80 no-box side-label .
setFrameLabels(frame a2:handle).

form
	xxcer_qc_result		colon 11 label "QA检验结果"
	xxcer_result_user	colon 39 label "检验结果填写人"
	xxcer_result_date	colon 69 label "检验结果填写日期"
with frame a3 width 80 no-box side-label .
setFrameLabels(frame a3:handle).

form
	xxcer_dec_rmks1		colon 9 label "判定结果"
	xxcer_dec_rmks2		colon 9 no-label 
with frame a4 width 80 no-box side-label .
setFrameLabels(frame a4:handle).

form
	"判定结果:" at 1 skip 
	xxcer_dec_rmks1		at 9 no-label 
	xxcer_dec_rmks2		at 9 no-label        
	xxcer_dec_rmks3		at 9 no-label        

	xxcer_dec_result		colon 11 label "判定结果" format "x(11)"
	xxcer_pur_qty   		colon 31 label "限购量"  format ">>>>>>>>9.9<<"     
	xxcer_dec_user  		colon 50 label "填写人"		
	xxcer_dec_date  		colon 69 label "日期"
	
	xxcer_test_per  		colon 11 label "测试负责人"     
	xxcer_test_date 		colon 30 label "日期"		
	xxcer_qm_per    		colon 50 label "品管部主管" 
	xxcer_qm_date   		colon 69 label "日期"      
	
	xxcer_eng_per   		colon 11 label "工程部主管" 
	xxcer_eng_date  		colon 30 label "日期"   
	xxcer_audit_user		colon 50 label "最后审批人" 
	xxcer_audit_date		colon 69 label "日期"   

	xxcer_effdate   		colon 50 label "生效日期" 
	xxcer_expire    		colon 69 label "结束日期" 
with frame a42 width 80 /*no-box*/ side-label 				
overlay									
row 12
no-validate
no-attr-space.
setFrameLabels(frame a42:handle).