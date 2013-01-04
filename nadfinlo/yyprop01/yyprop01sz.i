            assign
               tot_std_man = 0.0
         		tot_act_man = 0.0
         		tot_sum_wt = 0.0
         		tot_ac_qty = 0.0
         		tot_rj_qty = 0.0
         		tot_open_qty = 0.0
         		tot_act_setup = 0.0
               tot_st01 = 0
               tot_st02 = 0
               tot_st03 = 0
         		tot_std_run = 0.0
         		tot_act_run = 0.0
         		tot_dt01 = 0.0
         		tot_dt02 = 0.0
         		tot_dt03 = 0.0
         		tot_it01 = 0.0
               tot_rj_rate = 0.0
               tot_rj_cnt = 0

                tot_act_dout = 0
                  tot_v_mol = 0
                  tot_qty_comp = 0
                  tot_qty_rjct = 0 
               tot_v_var = 0
               tot_v_var_time = 0
               .						

            FOR EACH tt BREAK BY tt_emp BY tt_shift BY tt_act_man DESCENDING :
              IF FIRST-OF(tt_shift) THEN DO:
                 FIND FIRST tt1 WHERE tt1_shift = tt_shift NO-LOCK NO-ERROR.
                 IF NOT AVAIL tt1 THEN DO:
                    CREATE tt1.
                    ASSIGN
                       tt1_shift = tt_shift
                       tt1_std_man = tt_std_man
                       tt1_act_man = tt_act_man
                       .
                 END.
                 ELSE DO:
                    ASSIGN
                       tt1_std_man = tt1_std_man + tt_std_man
                       tt1_act_man = tt1_act_man + tt_act_man
                       .
                 END.
              END.
            END.

            i = 0.
            for each tmp_sum,
               EACH tt1 WHERE tt1_shift = tmp_shift
               break by tmp_shift:	

               assign
                   v_var = 0 
                  v_var_time = 0
                  rjct_rate = 0.0
		            prate = 0.0
	               comp_rate = 0.0
	               rate_ks = 0.0.
         
         	   if (tmp_ac_qty + tmp_rj_qty) <> 0 
         	   then rjct_rate = (tmp_rj_qty /(tmp_rj_qty + tmp_ac_qty)) * 100.
         	   else rjct_rate = 0.00.
         
         	   if (tmp_act_run) <> 0 
         	   then comp_rate = (tmp_std_run / tmp_act_run) * 100.
         	   else comp_rate = 0.00.
         	
         	   if (tmp_act_run + tmp_act_setup + tmp_dt01 + tmp_dt02 + tmp_dt03 + tmp_it01) <> 0 
         	   then prate = (tmp_std_run /(tmp_act_run + tmp_act_setup + tmp_dt01 + tmp_dt02 + tmp_dt03 + tmp_it01 )) * 100.
         	   else prate = 0.00.
         
         	   if (tmp_act_run + tmp_act_setup + tmp_dt01 + tmp_dt02 + tmp_dt03) <> 0 
         	   then rate_ks = (tmp_std_run /(tmp_act_run + tmp_act_setup + tmp_dt01 + tmp_dt02 + tmp_dt03)) * 100.
         	   else rate_ks = 0.00.
			
               /*
               IF tmp_act_dout * tmp_act_run = 0 THEN v_var = 0.
               ELSE v_var = ((tmp_qty_comp + tmp_qty_rjct) / (tmp_act_dout * tmp_act_run)) * tmp_v_mol * 100 .
                 */
               v_var = tmp_v_var / tmp_i1 .
               v_var_time = tmp_v_var_time / tmp_i.

               PUT "班次:" format "x(8)" ","
                  tmp_shift FORMAT "x(2)" ","
                  "" ","
                  "" "," 
                  "" ","
                  "" ","
                  "" ","
                  "" ","
                  "" ","
                  tt1_std_man format ">>>>>9.9" "," 
                  tt1_act_man format "->>>>9.9" ","
                  "" ","
                  "" ","
                  "" ","
                  v_var_time "," 
                  "" ","
                  tmp_sum_wt format "->>>>>9.9" ","
                  tmp_ac_qty format "->>>>>>9" ","
                  tmp_rj_qty format "->>>>9" ","
                  (tmp_rj_rate / (if tmp_rj_cnt = 0 then 1 else tmp_rj_cnt)) format "->>9.9%" ","
                  prate format "->>>9.9%" ","
                  comp_rate format "->>>9.9%" ","
                  rate_ks format "->>>9.9%" "," 	
                  v_var "," /* P4 */
                  tmp_open_qty format "->>>>>>9" ","
                  "" ","
                  /*tmp_act_setup format "->>>>9.99" ","*/
                  tmp_st01 FORMAT "->>>>9.99" ","
                  tmp_st02 FORMAT "->>>>9.99" ","
                  tmp_st03 FORMAT "->>>>9.99" ","
                  tmp_act_run format "->>>>9.99" ","
                  tmp_dt01 format "->>>>9.99" ","
                  tmp_dt02 format "->>>>9.99" ","
                  tmp_dt03 format "->>>>9.99" ","
                  tmp_it01 format "->>>>9.99" ","
                  "" 
                  SKIP.  

	            assign
                  tot_std_man = tot_std_man + tt1_std_man
                  tot_act_man = tot_act_man + tt1_act_man
                  tot_sum_wt = tot_sum_wt + tmp_sum_wt
                  tot_ac_qty = tot_ac_qty + tmp_ac_qty
                  tot_rj_qty = tot_rj_qty + tmp_rj_qty
                  tot_open_qty = tot_open_qty + tmp_open_qty
                  tot_act_setup = tot_act_setup + tmp_act_setup
                  tot_st01 = tot_st01 + tmp_st01
                  tot_st02 = tot_st02 + tmp_st02
                  tot_st03 = tot_st03 + tmp_st03
                  tot_std_run = tot_std_run + tmp_std_run
                  tot_act_run = tot_act_run + tmp_act_run
                  tot_dt01 = tot_dt01 + tmp_dt01
                  tot_dt02 = tot_dt02 + tmp_dt02
                  tot_dt03 = tot_dt03 + tmp_dt03
                  tot_it01 = tot_it01 + tmp_it01

                  tot_act_dout = tot_act_dout + tmp_act_dout
                  tot_v_mol = tot_v_mol + tmp_v_mol
                  tot_qty_comp = tot_qty_comp + tmp_qty_comp
                  tot_qty_rjct = tot_qty_rjct + tmp_qty_rjct 

                  tot_rj_rate = tot_rj_rate + tmp_rj_rate
                  tot_rj_cnt = tot_rj_cnt + tmp_rj_cnt
                  tot_v_var = tot_v_var + v_var
                  tot_v_var_time = tot_v_var_time + v_var_time
                  .

               i = i + 1.
               if last(tmp_shift) then do:
                  assign
                     v_m1 = 0
                     v_m2 = 0
                     v_m3 = 0
                     v_var = 0
                     v_var_time = 0
                     rjct_rate = 0.0
		               prate = 0.0
                     comp_rate = 0.0
                     rate_ks = 0.0.		        	
		
		            tot_hour = tot_act_run + tot_act_setup + tot_dt01 + tot_dt02 + tot_dt03 + tot_it01.
		
                  if (tot_ac_qty + tot_rj_qty) <> 0 
                  then rjct_rate = (tot_rj_qty /(tot_rj_qty + tot_ac_qty)) * 100.
                  else rjct_rate = 0.00.
                  
                  if (tot_act_run) <> 0 
                  then comp_rate = (tot_std_run / tot_act_run) * 100.
                  else comp_rate = 0.00.
                  
                  if (tot_hour) <> 0 
                  then prate = (tot_std_run / tot_hour) * 100.
                  else prate = 0.00.
                  
                  if (tot_hour - tot_it01) <> 0 
                  then rate_ks = (tot_std_run /(tot_hour - tot_it01)) * 100.
                  else rate_ks = 0.00.
                 
                  /*
                  IF tot_act_dout * tot_act_run = 0 THEN v_var = 0.
                  ELSE v_var = ((tot_qty_comp + tot_qty_rjct) / (tot_act_dout * tot_act_run)) * tot_v_mol * 100 .
                    */
                  v_var = tot_v_var / i .
                  v_var_time = tot_v_var_time / i .
                  
                  v_m1 = 0.
                  IF tot_emp = 0 THEN v_m1 = 0.
                  ELSE IF tot_act_man = 0 THEN v_m1 = 0.
                  ELSE v_m1 = (((tot_act_run / (tot_emp * 24)) * tot_std_man) / tot_act_man) * 100 .

                  v_m2 = 0.
                  IF tot_emp = 0 THEN v_m2 = v_m1 + 0.
                  ELSE IF tot_act_man = 0 THEN v_m2 = v_m1 + 0.
                  ELSE v_m2 = v_m1 + (tot_act_setup / (tot_emp * 24)) * 100.

                  v_m3 = 0.
                  IF tot_hour = 0 THEN v_m3 = 0.
                  ELSE IF tot_act_man = 0 THEN v_m3 = 0.
                  ELSE v_m3 = (((tot_act_run / tot_hour) * tot_std_man) / tot_act_man) * 100 .
                       
                  PUT 
                     "合计:" format "x(8)" ","
                     ""  ","
                     "机台总数为:" + "" + string(tot_emp) FORMAT "x(18)" ","
                     "" ","
                     "" ","
                     "" ","
                     "" ","
                     "" ","
                     "" ","
                     tot_std_man format ">>>>>9.9" ","
                     tot_act_man format "->>>>9.9" ","
                     "" ","
                     "" ","
                     "" ","
                     v_var_time ","
                     "" ","
                     tot_sum_wt format "->>>>>9.9" ","
                     tot_ac_qty format "->>>>>>9" ","
                     tot_rj_qty format "->>>>9" ","
                     (tot_rj_rate / (if tot_rj_cnt = 0 then 1 else tot_rj_cnt)) format "->>9.9%" ","
                     prate format "->>>9.9%" ","
                     comp_rate format "->>>9.9%" ","
                     rate_ks format "->>>9.9%" "," 	
                     v_var "," /* 效率4 */
                     tot_open_qty format "->>>>>>9" ","
                     "" ","
                     /*tot_act_setup format "->>>>9.99" ","*/
                     tot_st01 FORMAT "->>>>9.99" ","
                     tot_st02 FORMAT "->>>>9.99" ","
                     tot_st03 FORMAT "->>>>9.99" ","
                     tot_act_run format "->>>>9.99" ","
                     tot_dt01 format "->>>>9.99" ","
                     tot_dt02 format "->>>>9.99" ","
                     tot_dt03 format "->>>>9.99" ","
                     tot_it01 format "->>>>9.99" ","
                     "机台总时间: " + string(tot_emp * 24.0,"->>>>9.9") format "x(20)" 
                     SKIP. 			

                  PUT 
                     "" ","
                     "" ","
                     "生产时间比率:" ","
                     "M1:" + STRING(round(v_m1,2)) + "%" FORMAT "x(10)" "," 
                     "M2:" + STRING(round(v_m2,2)) + "%" FORMAT "x(10)" "," 
                     "M3:" + STRING(round(v_m3,2)) + "%" FORMAT "x(10)" ","                      
                     "" "," "" "," "" "," "" "," "" "," "" "," "" "," "" ","
                     "" "," "" "," "" "," "" "," "" "," "" "," "" "," "" "," "" "," "" "," "" "," "" ","
                     /*round((tot_act_setup / tot_hour) * 100.0,2) format "->>9.99%" ","*/
                     round((tot_st01 / tot_hour) * 100.0,2) format "->>9.99%" ","
                     round((tot_st02 / tot_hour) * 100.0,2) format "->>9.99%" ","
                     round((tot_st03 / tot_hour) * 100.0,2) format "->>9.99%" ","
                     round((tot_act_run / tot_hour) * 100.0,2) format "->>9.99%" ","
                     round((tot_dt01 / tot_hour) * 100.0,2) format "->9.99%" ","
                     round((tot_dt02 / tot_hour) * 100.0,2) format "->9.99%" ","
                     round((tot_dt03 / tot_hour) * 100.0,2) format "->9.99%" ","
                     round((tot_it01 / tot_hour) * 100.0,2) format "->9.99%" ","
                     "汇报总时间: " + string(tot_hour,"->>>>9.9") format "x(20)" 
                     SKIP.

               end. /*if last(tmp_shift)...*/	
            end. /*if each tmp_sum ... */
