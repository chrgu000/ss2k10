     form
	danju		colon 12 label "���뵥��" format "x(12)"
	xxcer_avail	colon 50 label "����״̬"
	xxcer_req_dpt 	colon 20 label "���벿��"
	xxcer_req_user	colon 50 label "������"	
	xxcer_test_dpt	colon 20 label "���Բ���"
	xxcer_due_date	colon 50 label "Ҫ���������"
	xxcer_vend    	colon 20 label "��Ӧ�̴���"
	v_name		colon 50 label "����"
	xxcer_part    	colon 20 label "�����"
	desc1     	colon 50 label "˵��"
	xxcer_qty     	colon 20 label "��������"
	xxcer_usage   	colon 50 label "��;"
	xxcer_safety  	colon 20 label "����Ҫ��"
			"(����)���Ա�׼������                   (Ʒ��)������" at 15 
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
	xxcer_std_user		colon 39 label "���ָ����д��"
	xxcer_std_date		colon 69 label "���ָ����д����"
with frame a2 width 80 no-box side-label .
setFrameLabels(frame a2:handle).

form
	xxcer_qc_result		colon 11 label "QA������"
	xxcer_result_user	colon 39 label "��������д��"
	xxcer_result_date	colon 69 label "��������д����"
with frame a3 width 80 no-box side-label .
setFrameLabels(frame a3:handle).

form
	xxcer_dec_rmks1		colon 9 label "�ж����"
	xxcer_dec_rmks2		colon 9 no-label 
with frame a4 width 80 no-box side-label .
setFrameLabels(frame a4:handle).

form
	"�ж����:" at 1 skip 
	xxcer_dec_rmks1		at 9 no-label 
	xxcer_dec_rmks2		at 9 no-label        
	xxcer_dec_rmks3		at 9 no-label        

	xxcer_dec_result		colon 11 label "�ж����" format "x(11)"
	xxcer_pur_qty   		colon 31 label "�޹���"  format ">>>>>>>>9.9<<"     
	xxcer_dec_user  		colon 50 label "��д��"		
	xxcer_dec_date  		colon 69 label "����"
	
	xxcer_test_per  		colon 11 label "���Ը�����"     
	xxcer_test_date 		colon 30 label "����"		
	xxcer_qm_per    		colon 50 label "Ʒ�ܲ�����" 
	xxcer_qm_date   		colon 69 label "����"      
	
	xxcer_eng_per   		colon 11 label "���̲�����" 
	xxcer_eng_date  		colon 30 label "����"   
	xxcer_audit_user		colon 50 label "���������" 
	xxcer_audit_date		colon 69 label "����"   

	xxcer_effdate   		colon 50 label "��Ч����" 
	xxcer_expire    		colon 69 label "��������" 
with frame a42 width 80 /*no-box*/ side-label 				
overlay									
row 12
no-validate
no-attr-space.
setFrameLabels(frame a42:handle).