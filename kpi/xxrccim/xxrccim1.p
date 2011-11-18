/*V8:ConvertMode=Report                                                       */

{mfdeclre.i}
{xxrccim.i}

DEFINE STREAM bb  .
DEFINE STREAM dd  .
DEFINE STREAM ee  .
define variable fn as character format "x(20)".
define variable i as integer.
assign fn = "xxrccim" + string(time) + ".cim".
OUTPUT to value(fn).
  for each xsch_mstr no-lock where xsch_lrdate <> ? and xsch_lrqty <> 0 
  			   break by xsch_order by xsch_line by xsch_rlseid:
  		if first-of(xsch_rlseid) then do:   /*
  			 put "@@batchload xxrcssmt.p" skip.  */
  			 put unformat '"" "" "" "" "" "" "' xsch_order '" ' xsch_line skip.
  			 put unformat '"' xsch_rlseid '"' skip.
  			 put unformat 'NO - - - - - ' xsch_pcsdate ' NO' ' NO '  TODAY ' -'skip.
  	  end.
  	  	 put unformat '"' xsch_lrasn '" ' xsch_lrdate ' ' xsch_lrtime ' ' xsch_lrqty ' ' xsch_lrcum skip.
  	  if last-of(xsch_rlseid) then do:
  	  	 put "." skip.
  	  	 for each xschd_det no-lock where xschd_order = xsch_order and 
  	  	 				  xschd_line = xsch_line and xschd_rlseid = xsch_rlseid:
  	  	 		 put unformat xschd_date ' ' xschd_time ' ' xschd_interval ' "' xschd_ref '"' skip.
  	  	 		 put unformat xschd_updqty ' ' xschd_fcqual ' NO NO' skip.
  	  	 end.
  	  	 put "." skip.
  	  	 put "." skip.  /*
  	  	 put "@@end" skip.  */
  	  end.
  end.                 
OUTPUT close.      

batchrun  = yes.
    input from value(fn).
    output to value(fn + ".out") keep-messages.
    hide message no-pause.
    {gprun.i ""xxrcssmt.p""}
    hide message no-pause.
    output close.
    input close.
    batchrun  = no.


display fn.
                        
for each xsch_mstr exclusive-lock:
    find first schd_det where schd_reference = xsch_ref  and
       schd_date = xsch_date and schd_time = xsch_time and
       schd_rlse_id = xsch_rlseid no-error.
    if available schd_det then do:
      		if schd_upd_qty = ? then next.
          if schd_upd_qty <> xsch_updqty then do:
             assign xsch_error = "error".
          end.
    end.
end.

