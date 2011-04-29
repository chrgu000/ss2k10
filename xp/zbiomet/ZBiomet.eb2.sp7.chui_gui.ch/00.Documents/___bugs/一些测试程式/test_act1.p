

define variable part like pt_part.
define variable part2 like pt_part.
define variable tot_act_run like op_act_run.
define variable site like si_site initial "1100".

define buffer womstr for wo_mstr.
define buffer woddet for wod_det.

define buffer womstr1 for wo_mstr.
define buffer woddet1 for wod_det.

define buffer womstr2 for wo_mstr.
define buffer woddet2 for wod_det.

define buffer womstr3 for wo_mstr.
define buffer woddet3 for wod_det.

define buffer womstr4 for wo_mstr.
define buffer woddet4 for wod_det.

define buffer womstr5 for wo_mstr.
define buffer woddet5 for wod_det.

define buffer womstr6 for wo_mstr.
define buffer woddet6 for wod_det.

define buffer womstr7 for wo_mstr.
define buffer woddet7 for wod_det.

define buffer womstr8 for wo_mstr.
define buffer woddet8 for wod_det.

define buffer womstr9 for wo_mstr.
define buffer woddet9 for wod_det.

define buffer womstr10 for wo_mstr.
define buffer woddet10 for wod_det.

define buffer womstr11 for wo_mstr.
define buffer woddet11 for wod_det.

define buffer womstr12 for wo_mstr.
define buffer woddet12 for wod_det.

define buffer womstr13 for wo_mstr.
define buffer woddet13 for wod_det.

output to /home/public/test_act1.prn.

     tot_act_run = 0.
    for each wo_mstr no-lock 
       where wo_site = "1100"
         and wo_status = "C"
      , each pt_mstr no-lock where pt_part = wo_part 
         and (pt_pm_code = "" or pt_pm_code = "M")
    ,   each wod_det no-lock where wod_lot = wo_lot:
           
               for each op_hist no-lock
                  where op_wo_lot = wo_mstr.wo_lot
                    and op_wo_nbr = wo_mstr.wo_nbr:
                  tot_act_run = tot_act_run + op_act_run.
               end.

	       part2 = wod_det.wod_part.

	       for each womstr no-lock where womstr.wo_part = part2
                    and womstr.wo_status = "C"
                    and womstr.wo_site = site
                 , each woddet no-lock 
                  where woddet.wod_nbr = womstr.wo_nbr 
		    and woddet.wod_lot = womstr.wo_lot :
                        
                  for each op_hist no-lock
                     where op_wo_lot = woddet.wod_lot
                       and op_wo_nbr = woddet.wod_nbr:
                      tot_act_run = tot_act_run + op_act_run.
                  end.

		  part2 = woddet.wod_part.

	          for each womstr1 no-lock where womstr1.wo_part = part2
                       and womstr1.wo_status = "C"
                       and womstr1.wo_site = site
                    , each woddet1 no-lock 
                     where woddet1.wod_nbr = womstr1.wo_nbr 
		       and woddet1.wod_lot = womstr1.wo_lot :
                        
                     for each op_hist no-lock
                        where op_wo_lot = woddet1.wod_lot
                          and op_wo_nbr = woddet1.wod_nbr:
                         tot_act_run = tot_act_run + op_act_run.
                     end.

		     part2 = woddet1.wod_part.

	             for each womstr2 no-lock where womstr2.wo_part = part2
                          and womstr2.wo_status = "C"
                          and womstr2.wo_site = site
                       , each woddet2 no-lock 
                        where woddet2.wod_nbr = womstr2.wo_nbr 
		          and woddet2.wod_lot = womstr2.wo_lot :
                        
                        for each op_hist no-lock
                           where op_wo_lot = woddet2.wod_lot
                             and op_wo_nbr = woddet2.wod_nbr:
                           tot_act_run = tot_act_run + op_act_run.
                        end.

            	        part2 = woddet2.wod_part.
	                for each womstr3 no-lock where womstr3.wo_part = part2
                             and womstr3.wo_status = "C"
                             and womstr3.wo_site = site
                          , each woddet3 no-lock 
                           where woddet3.wod_nbr = womstr3.wo_nbr 
		             and woddet3.wod_lot = womstr3.wo_lot :
                        
                           for each op_hist no-lock
                              where op_wo_lot = woddet3.wod_lot
                                and op_wo_nbr = woddet3.wod_nbr:
                              tot_act_run = tot_act_run + op_act_run.
                           end.

            	           part2 = woddet3.wod_part.

	                   for each womstr4 no-lock where womstr4.wo_part = part2
                                and womstr4.wo_status = "C"
                                and womstr4.wo_site = site
                             , each woddet4 no-lock 
                              where woddet4.wod_nbr = womstr4.wo_nbr 
		                and woddet4.wod_lot = womstr4.wo_lot :
                        
                              for each op_hist no-lock
                                 where op_wo_lot = woddet4.wod_lot
                                   and op_wo_nbr = woddet4.wod_nbr:
                                 tot_act_run = tot_act_run + op_act_run.
                              end.

            	              part2 = woddet4.wod_part.

	                      for each womstr5 no-lock where womstr5.wo_part = part2
                                   and womstr5.wo_status = "C"
                                   and womstr5.wo_site = site
                                , each woddet5 no-lock 
                                 where woddet5.wod_nbr = womstr5.wo_nbr 
		                   and woddet5.wod_lot = womstr5.wo_lot :
                        
                                 for each op_hist no-lock
                                    where op_wo_lot = woddet5.wod_lot
                                      and op_wo_nbr = woddet5.wod_nbr:
                                    tot_act_run = tot_act_run + op_act_run.
                                 end.

            	                 part2 = woddet5.wod_part.

	                         for each womstr6 no-lock where womstr6.wo_part = part2
                                      and womstr6.wo_status = "C"
                                      and womstr6.wo_site = site
                                   , each woddet6 no-lock 
                                    where woddet6.wod_nbr = womstr6.wo_nbr 
		                      and woddet6.wod_lot = womstr6.wo_lot :
                        
                                    for each op_hist no-lock
                                       where op_wo_lot = woddet6.wod_lot
                                      and op_wo_nbr = woddet6.wod_nbr:
                                       tot_act_run = tot_act_run + op_act_run.
                                    end.

            	                    part2 = woddet6.wod_part.

	                            for each womstr7 no-lock where womstr7.wo_part = part2
                                         and womstr7.wo_status = "C"
                                         and womstr7.wo_site = site
                                      , each woddet7 no-lock 
                                       where woddet7.wod_nbr = womstr7.wo_nbr 
		                         and woddet7.wod_lot = womstr7.wo_lot :
                        
                                       for each op_hist no-lock
                                          where op_wo_lot = woddet7.wod_lot
                                            and op_wo_nbr = woddet7.wod_nbr:
                                          tot_act_run = tot_act_run + op_act_run.
                                       end.

            	                       part2 = woddet7.wod_part.

	                               for each womstr8 no-lock where womstr8.wo_part = part2
                                            and womstr8.wo_status = "C"
                                            and womstr8.wo_site = site
                                         , each woddet8 no-lock 
                                          where woddet8.wod_nbr = womstr8.wo_nbr 
		                            and woddet8.wod_lot = womstr8.wo_lot :
                        
                                          for each op_hist no-lock
                                             where op_wo_lot = woddet8.wod_lot
                                               and op_wo_nbr = woddet8.wod_nbr:
                                             tot_act_run = tot_act_run + op_act_run.
                                          end.


					  part2 = woddet8.wod_part.
	                                  for each womstr9 no-lock where womstr9.wo_part = part2
                                               and womstr9.wo_status = "C"
                                               and womstr9.wo_site = site
                                            , each woddet9 no-lock 
                                             where woddet9.wod_nbr = womstr9.wo_nbr 
		                               and woddet9.wod_lot = womstr9.wo_lot :
                        
                                             for each op_hist no-lock
                                                where op_wo_lot = woddet9.wod_lot
                                                  and op_wo_nbr = woddet9.wod_nbr:
                                                tot_act_run = tot_act_run + op_act_run.
                                             end.

            	                             part2 = woddet9.wod_part.

	                                     for each womstr10 no-lock where womstr10.wo_part = part2
                                                  and womstr10.wo_status = "C"
                                                  and womstr10.wo_site = site
                                               , each woddet10 no-lock 
                                                where woddet10.wod_nbr = womstr10.wo_nbr 
		                                  and woddet10.wod_lot = womstr10.wo_lot :
                        
                                                for each op_hist no-lock
                                                   where op_wo_lot = woddet10.wod_lot
                                                     and op_wo_nbr = woddet10.wod_nbr:
                                                   tot_act_run = tot_act_run + op_act_run.
                                                end.


            	                                part2 = woddet10.wod_part.

	                                        for each womstr11 no-lock where womstr10.wo_part = part2
                                                     and womstr11.wo_status = "C"
                                                     and womstr11.wo_site = site
                                                  , each woddet11 no-lock 
                                                   where woddet11.wod_nbr = womstr11.wo_nbr 
		                                     and woddet11.wod_lot = womstr11.wo_lot :
                        
                                                   for each op_hist no-lock
                                                      where op_wo_lot = woddet11.wod_lot
                                                        and op_wo_nbr = woddet11.wod_nbr:
                                                      tot_act_run = tot_act_run + op_act_run.
                                                   end.

						   part2 = woddet11.wod_part.

	                                           for each womstr12 no-lock where womstr12.wo_part = part2
                                                        and womstr12.wo_status = "C"
                                                        and womstr12.wo_site = site
                                                     , each woddet12 no-lock 
                                                      where woddet12.wod_nbr = womstr12.wo_nbr 
		                                        and woddet12.wod_lot = womstr12.wo_lot :
                        
                                                      for each op_hist no-lock
                                                         where op_wo_lot = woddet12.wod_lot
                                                           and op_wo_nbr = woddet12.wod_nbr:
                                                         tot_act_run = tot_act_run + op_act_run.
                                                      end.
            	                                      part2 = woddet12.wod_part.

	                                              for each womstr13 no-lock where womstr12.wo_part = part2
                                                           and womstr13.wo_status = "C"
                                                           and womstr13.wo_site = site
                                                        , each woddet13 no-lock 
                                                         where woddet13.wod_nbr = womstr13.wo_nbr 
		                                           and woddet13.wod_lot = womstr13.wo_lot :
                        
                                                         for each op_hist no-lock
                                                            where op_wo_lot = woddet13.wod_lot
                                                              and op_wo_nbr = woddet13.wod_nbr:
                                                            tot_act_run = tot_act_run + op_act_run.
                                                         end.

            	                                         part2 = woddet13.wod_part.

                                                      end.
	       part2 = "".
						   end.  /*womstr12*/

	       part2 = "".
                                                end.  /*womstr11*/

	       part2 = "". 
					     end. /* womstr10 */

	       part2 = "". 
                                          end. /* womstr9*/


              part2 = "". 
                                       end. /* womstr8*/

	       part2 = "". 
				    end. /* womstr7*/


	       part2 = "". 
                                 end. /* womstr6*/

	       part2 = "".
                              end. /*womstr5*/

	       part2 = "".
                           end. /* womstr4*/

	       part2 = "".
			end. /* womstr3*/

	       part2 = "".
                     end. /* womstr2*/

	       part2 = "".
	          end.  /* womstr1*/

	       part2 = "".
               end. /* womstr*/
	   
	       display wo_mstr.wo_part tot_act_run  format "->>>,>>>,>>9.99<<<" with down frame b width 132.

           end.


