/*
1.变量定义转移到 {xscurvar.i} 以便程式多次调用,
2.{xscurvar.i}在{xsdfsite.i}中调用,
3.本程式调用方式: {xscurr01.i &pocurr="订单币别变量" &basecurr="本位币变量" &effdate="生效日期变量"}
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
	/*if v_curr_error <> 0 then  兑换率不存在*/       
end.

