

define variable part like pt_part.
define variable part2 like pt_part.
define variable tot_act_run like op_act_run.
define variable site like si_site initial "1100".
define variable lot like wo_lot.

define temp-table temp1
        field t1_lot like wo_lot
	field t1_nbr like wo_nbr
	field t1_part like wod_part.

define temp-table temp2
        field t2_lot like wo_lot
	field t2_nbr like wo_nbr
	field t2_part like wod_part.

define temp-table temp3
        field t3_lot like wo_lot
	field t3_nbr like wo_nbr
	field t3_part like wod_part.

define temp-table temp4
        field t4_lot like wo_lot
	field t4_nbr like wo_nbr
	field t4_part like wod_part.

define temp-table temp5
        field t5_lot like wo_lot
	field t5_nbr like wo_nbr
	field t5_part like wod_part.

define temp-table temp6
        field t6_lot like wo_lot
	field t6_nbr like wo_nbr
	field t6_part like wod_part.

define temp-table temp7
        field t7_lot like wo_lot
	field t7_nbr like wo_nbr
	field t7_part like wod_part.

define temp-table temp8
        field t8_lot like wo_lot
	field t8_nbr like wo_nbr
	field t8_part like wod_part.

define temp-table temp9
        field t9_lot like wo_lot
	field t9_nbr like wo_nbr
	field t9_part like wod_part.

define temp-table temp10
        field t10_lot like wo_lot
	field t10_nbr like wo_nbr
	field t10_part like wod_part.

repeat:
    update part with frame a.

     tot_act_run = 0.
     for each temp1. delete temp1.  end.

     for each temp2. delete temp2.  end.
          for each temp3. delete temp3.  end.
	       for each temp4. delete temp4.  end.
	            for each temp5. delete temp5.  end.
		         for each temp6. delete temp6.  end.
			      for each temp7. delete temp7.  end.

	       for each temp8. delete temp8.  end.
	            for each temp9. delete temp9.  end.
		         for each temp10. delete temp10.  end.


    for each wo_mstr no-lock 
       where wo_part = part 
         and wo_site = "1100"
         and wo_status = "C" break by wo_qty_comp desc by wo_lot:

        if first(wo_lot) then 
        for each wod_det where wod_lot = wo_lot no-lock:          
           for each op_hist no-lock
              where op_wo_lot = wo_mstr.wo_lot
                and op_wo_nbr = wo_mstr.wo_nbr
	        and op_act_run <> 0:
              tot_act_run = tot_act_run + op_act_run.
           end.

           create temp1.
           t1_lot = wo_lot.
           t1_nbr = wo_nbr.
           t1_part = wod_part.
	end.
    end.

    for each temp1 no-lock:
        for each wo_mstr no-lock
	   where wo_part = t1_part
	     and wo_site = "1100"
	     break by wo_qty_comp desc by wo_lot :

           if first(wo_lot) then 
	   for each wod_det no-lock
	      where wod_lot = wo_lot:
            
              for each op_hist no-lock
                 where op_wo_lot = wo_mstr.wo_lot
                   and op_wo_nbr = wo_mstr.wo_nbr
	           and op_act_run <> 0:
                 tot_act_run = tot_act_run + op_act_run.
              end.

             create temp2.
             t2_lot = wo_lot.
             t2_nbr = wo_nbr.
             t2_part = wod_part.
           end.
	end.
    end.

   
    for each temp2 no-lock:
        for each wo_mstr no-lock
	   where wo_part = t2_part
	     and wo_site = "1100" 
	     break by wo_qty_comp desc by wo_lot :

	   if first(wo_lot) then 
	   for each wod_det no-lock
	   where wod_lot = wo_lot:
            
              for each op_hist no-lock
                 where op_wo_lot = wo_mstr.wo_lot
                   and op_wo_nbr = wo_mstr.wo_nbr
	           and op_act_run <> 0:
                 tot_act_run = tot_act_run + op_act_run.
              end.

             create temp3.
             t3_lot = wo_lot.
             t3_nbr = wo_nbr.
             t3_part = wod_part.
	   end.
        end.
    end.
    
    for each temp3 no-lock:
        for each wo_mstr no-lock
	   where wo_part = t3_part
	     and wo_site = "1100" 
	     break by wo_qty_comp desc by wo_lot :
           
           if first(wo_lot) then
	   for each wod_det no-lock
	      where wod_lot = wo_lot:
            
              for each op_hist no-lock
                 where op_wo_lot = wo_mstr.wo_lot
                   and op_wo_nbr = wo_mstr.wo_nbr
	           and op_act_run <> 0:
                 tot_act_run = tot_act_run + op_act_run.
              end.

             create temp4.
             t4_lot = wo_lot.
             t4_nbr = wo_nbr.
             t4_part = wod_part.
	    end.
        end.
    end.

    for each temp4 no-lock:
        for each wo_mstr no-lock
	   where wo_part = t4_part
	     and wo_site = "1100" 
	     break by wo_qty_comp desc by wo_lot :

           if first(wo_lot) then 
	   for each wod_det no-lock
	   where wod_lot = wo_lot:
            
              for each op_hist no-lock
                 where op_wo_lot = wo_mstr.wo_lot
                   and op_wo_nbr = wo_mstr.wo_nbr
	           and op_act_run <> 0:
                 tot_act_run = tot_act_run + op_act_run.
              end.

             create temp5.
             t5_lot = wo_lot.
             t5_nbr = wo_nbr.
             t5_part = wod_part.
	   end.
        end.
    end.

    for each temp5 no-lock:
        for each wo_mstr no-lock
	   where wo_part = t5_part
	     and wo_site = "1100" 
	     break by wo_qty_comp desc by wo_lot :

           if first(wo_lot) then 
	   for each wod_det no-lock
	   where wod_lot = wo_lot:
            
              for each op_hist no-lock
                 where op_wo_lot = wo_mstr.wo_lot
                   and op_wo_nbr = wo_mstr.wo_nbr
	           and op_act_run <> 0:
                 tot_act_run = tot_act_run + op_act_run.
              end.

             create temp6.
             t6_lot = wo_lot.
             t6_nbr = wo_nbr.
             t6_part = wod_part.
	    end.
        end.
    end.

    for each temp6 no-lock:
        for each wo_mstr no-lock
	   where wo_part = t6_part
	     and wo_site = "1100" 
	     break by wo_qty_comp desc by wo_lot :

            if first(wo_lot) then
	   for each wod_det no-lock
	   where wod_lot = wo_lot:
            
              for each op_hist no-lock
                 where op_wo_lot = wo_mstr.wo_lot
                   and op_wo_nbr = wo_mstr.wo_nbr
	           and op_act_run <> 0:
                 tot_act_run = tot_act_run + op_act_run.
              end.

             create temp7.
             t7_lot = wo_lot.
             t7_nbr = wo_nbr.
             t7_part = wod_part.
	   end.
        end.
    end.

    for each temp7 no-lock:
        for each wo_mstr no-lock
	   where wo_part = t7_part
	     and wo_site = "1100"
	     break by wo_qty_comp desc by wo_lot :

           if first(wo_lot) then
	   for each wod_det no-lock
	   where wod_lot = wo_lot:
            
              for each op_hist no-lock
                 where op_wo_lot = wo_mstr.wo_lot
                   and op_wo_nbr = wo_mstr.wo_nbr
	           and op_act_run <> 0:
                 tot_act_run = tot_act_run + op_act_run.
              end.

             create temp8.
             t8_lot = wo_lot.
             t8_nbr = wo_nbr.
             t8_part = wod_part.
	   end.
        end.
    end.


    for each temp8 no-lock:
        for each wo_mstr no-lock
	   where wo_part = t8_part
	     and wo_site = "1100" 
	     break by wo_qty_comp desc by wo_lot :

           if first(wo_lot) then
	   for each wod_det no-lock
	   where wod_lot = wo_lot:
            
              for each op_hist no-lock
                 where op_wo_lot = wo_mstr.wo_lot
                   and op_wo_nbr = wo_mstr.wo_nbr
	           and op_act_run <> 0:
                 tot_act_run = tot_act_run + op_act_run.
              end.

             create temp9.
             t9_lot = wo_lot.
             t9_nbr = wo_nbr.
             t9_part = wod_part.
	   end.
        end.
    end.


    for each temp9 no-lock:
        for each wo_mstr no-lock
	   where wo_part = t9_part
	     and wo_site = "1100" 
	     break by wo_qty_comp desc by wo_lot :

           if first(wo_lot) then
	   for each wod_det no-lock
	   where wod_lot = wo_lot:
            
              for each op_hist no-lock
                 where op_wo_lot = wo_mstr.wo_lot
                   and op_wo_nbr = wo_mstr.wo_nbr
	           and op_act_run <> 0:
                 tot_act_run = tot_act_run + op_act_run.
              end.

             create temp10.
             t10_lot = wo_lot.
             t10_nbr = wo_nbr.
             t10_part = wod_part.
	   end.
        end.
    end.


    for each temp10 no-lock:
        for each wo_mstr no-lock
	   where wo_part = t10_part
	     and wo_site = "1100" 
	     break by wo_qty_comp desc by wo_lot :

           if first(wo_lot) then
	   for each wod_det no-lock
	   where wod_lot = wo_lot:
            
              for each op_hist no-lock
                 where op_wo_lot = wo_mstr.wo_lot
                   and op_wo_nbr = wo_mstr.wo_nbr
	           and op_act_run <> 0:
                 tot_act_run = tot_act_run + op_act_run.
              end.
/*
             create temp10.
             t10_lot = wo_lot.
             t10_nbr = wo_nbr.
             t10_part = wod_part.
*/
	   end.
        end.
    end.

      display tot_act_run  format "->>>,>>>,>>9.99<<<" with frame b.
   end.