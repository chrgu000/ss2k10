/*
1.��������ת�Ƶ� {xscurvar.i} �Ա��ʽ��ε���,
2.{xscurvar.i}��{xsdfsite.i}�е���,
3.����ʽ���÷�ʽ: {xscurr01.i &pocurr="�����ұ����" &basecurr="��λ�ұ���" &effdate="��Ч���ڱ���"}
*/


v_curr_curr1 = {&pocurr} .
v_curr_curr2 = {&basecurr} .
v_curr_effdate = {&effdate}  .
v_curr_ratetype = "" .
v_curr_error = 0 .
if v_curr_curr1 <> v_curr_curr2 then do:	
        {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
			"(input v_curr_curr1,
			  input v_curr_curr2,
			  input v_curr_ratetype ,
			  input v_curr_effdate ,
			  output v_curr_r1,
			  output v_curr_r2,
			  output v_curr_seq,
			  output v_curr_error)" }
	/*if v_curr_error <> 0 then  �һ��ʲ�����*/       
end.

