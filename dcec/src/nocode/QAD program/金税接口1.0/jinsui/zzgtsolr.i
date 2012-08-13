/*zzgtsolr.i create 2004-09-02 10:08   									*/

/* Ð´»Øsod   															*/

/* {1}  = yes, posting													*/
/*      = no,  not post													*/


		for each wrk_var where wrk_sonbr = so_nbr:
			find first sod_det where sod_nbr = so_nbr and sod_line = wrk_line exclusive-lock no-error.
			if available sod_det then do:
				sod_sched = wrk_sched.
				sod_qty_inv = wrk_qty_inv.  /*after posting*/
				if not {1} then do:				/* not posting */
					find first xinvd where xnbr = sod_nbr and xpart = sod_part no-error.
					if available xinvd then do:
						sod_qty_inv = wrk_qty_inv + xqty.
					end.
				end.
			end.
		end.

