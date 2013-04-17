

procedure gett1:
define input parameter iDate as date.
define input parameter iDate1 as date.
define input parameter isite like si_site.
define input parameter isite1 like si_site.
define input parameter iline like ln_line.
define input parameter iline1 like ln_line.

define variable v_rstMin as integer.
for each rps_mstr no-lock where rps_rel_date >= idate
     and rps_rel_date <= idate1
     and rps_line >= iLine
     and rps_line <= iline1
     AND rps_qty_req - rps_qty_comp > 0,
    last lnd_det no-lock where lnd_line = rps_line
     and lnd_site = rps_site and
        lnd_part = rps_part and lnd_start <= idate,
     each shft_det no-lock where shft_site = rps_site and shft_wkctr = rps_line
      and shft_day = weekday(rps_rel_date)
 BREAK  BY rps_rel_date BY rps_site BY rps_line by integer(rps_user1):
   assign v_rstmin = 0.    
/*   for each xxlr_det no-lock where xxlr_site = rps_site and                 */
/*            xxlr_line = rps_line:                                           */
/*       assign v_rstMin = v_rstMin + xxlr_minutes.                           */
/*   end.                                                                     */
   display rps_part rps_rel_date rps_qty_req  
           integer(shft_start1 * 3600) column-label "startTime"
           shft_load1 
           integer(shft_start2 * 3600) column-label "startTime2"
           shft_load2 
           lnd_rate 
           (lnd_rate * shft_load1 / 100 ) / 60 column-label "rate/Min"
           truncate(rps_qty_req * 60 / ((lnd_rate * shft_load1 / 100) / 60) ,0) 
           .
end. 

end procedure.


run gett1(input today,input today + 3,input "gsa01", input "gsa01",
          input "hps",input "hps").
