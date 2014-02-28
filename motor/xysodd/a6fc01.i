          assign j = 1 i = 1 .
	 /*提取抵扣追溯数据*/
	 for each xxsoh_hist where xxsoh_hist.soh_domain = sod_det.sod_domain
			  and xxsoh_hist.soh_site = sod_det.sod_site
			  and xxsoh_hist.soh_nbr = sod_det.sod_nbr
			  and xxsoh_hist.soh_line = sod_det.sod_line 
			  use-index soh_nbr :
                           assign i = 1 j = 1 .
			  IF ( NOT a6frc_seri ) OR ( a6frc_seri AND (a6frc_beg = 0 OR a6frc_flow = 0) )THEN DO :    
		               FOR  EACH  a6fcs_sum WHERE a6fcs_domain = sod_det.sod_domain  AND  a6fcs_site = sod_det.sod_site AND  a6fcs_part = sod_det.sod_part   EXCLUSIVE-LOCK :
			           repeat :

                                        if i > 5 then leave .
					if ( a6fcs_star[1] <= soh_fst_week [i]  and a6fcs_star[52] >= soh_fst_week [i] ) or soh_fst_qty [i] <> 0 then 
					do:
					   repeat :
					    if j > 52 then leave .
					    if a6fcs_star[j] = soh_fst_week[i] then a6fcs_sold_qty [j] = a6fcs_sold_qty [j] - soh_fst_qty [i]  .
					    assign j = j + 1 .
                                           end.

                                            assign j = 1 .
					end.
					assign i = i + 1 .
				   end.
			       End.

		           End.
			   Else  do:
			      assign j = 1  i = 1 .
		               FOR  EACH    a6fcs_sum WHERE a6fcs_domain = sod_det.sod_domain AND  a6fcs_site= sod_det.sod_site 
			                                AND  SUBSTRING(a6fcs_part,a6frc_beg,a6frc_flow) = SUBSTRING(sod_det.sod_part,a6frc_beg,a6frc_flow)  EXCLUSIVE-LOCK :
			           repeat :
                                        if i > 5 then leave .
					if ( a6fcs_star[1] <= soh_fst_week [i]  and a6fcs_star[52] >= soh_fst_week [i] ) or soh_fst_qty [i] <> 0 then 
					do:
					   repeat :
					    if j > 52 then leave .
					    if a6fcs_star[j] = soh_fst_week[i] then a6fcs_sold_qty [j] = a6fcs_sold_qty [j] - soh_fst_qty [i]  .
					    assign j = j + 1 .
					     
                                           end.
                                             assign j = 1 .
					end.
					assign i = i + 1.
				   end.
			       End.
                           End .     
			 delete xxsoh_hist .  
         end. 

