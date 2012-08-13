		
		
		find first sch_mstr where sch_type = 4
				      and sch_nbr = ponbr 
				      and sch_line = poline
				      and sch_rlse_id = pod_curr_rlse_id[1] exclusive-lock.
		
		find pod_det where pod_nbr = ponbr and pod_line = poline no-lock.
		
		/*J0J6 CHANGED ALL OCCURANCES OF EXCLUSIVE TO EXCLUSIVE-LOCK*/
		
		for each schd_det exclusive-lock where schd_type = 4
		and schd_nbr = ponbr
		and schd_line = poline
		and schd_rlse_id = sch_rlse_id:
		   if sch_cumulative then do:
		      schd_upd_qty = schd_cum_qty.
		   end.
		   else do:
		      schd_upd_qty = schd_discr_qty.
		   end.
		end.
		

		find first schd_det where
		schd_type = sch_type
		and schd_nbr = sch_nbr
		and schd_line = sch_line
		and schd_rlse_id = sch_rlse_id
		and schd_date = schdate
		and schd_interval = ""
		exclusive-lock no-error.

		if not available schd_det then do:
			create schd_det.
			
			assign
			schd_type = sch_type
			schd_nbr = sch_nbr
			schd_line = sch_line
			schd_rlse_id = sch_rlse_id
			schd_date = schdate
			schd_interval = ""
	        schd_fc_qual = "P".
		end.
		schd_upd_qty = schqty.


		prior_cum_qty = sch_pcr_qty.

		for each schd_det exclusive-lock where schd_type = sch_type
		and schd_nbr = sch_nbr
		and schd_line = sch_line
		and schd_rlse_id = sch_rlse_id:
/*GUI*/ if global-beam-me-up then undo, leave.

			if sch_cumulative then do:
		/*		if schd_upd_qty < prior_cum_qty then do:
					{mfmsg.i 6009 3}
					undo mainloop, retry mainloop.
				end.
		*/		
				schd_cum_qty = schd_upd_qty.
				schd_discr_qty = schd_cum_qty - prior_cum_qty.
				prior_cum_qty = prior_cum_qty + schd_discr_qty.
			end.
  			else do:
				schd_discr_qty = schd_upd_qty.
				prior_cum_qty = prior_cum_qty + schd_discr_qty.
				schd_cum_qty = prior_cum_qty.
			end.
		end.

