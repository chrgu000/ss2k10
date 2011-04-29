def var stdrun as deci.
def var stdsetup as deci.
def var actsetup as deci.
def var actrun as deci.
def buffer aa for op_hist.

output to 19.prn.
for each op_hist where op_date >= 01/01/07 and op_date <= 09/30/07
and (op_act_setup <> 0 or op_std_setup <> 0 OR
             op_act_run <> 0 OR op_std_run <> 0)
no-lock:
find first wc_mstr where wc_wkctr = op_wkctr no-lock no-error.

disp op_date op_trnbr op_part op_type
 op_wkctr wc_desc when avail wc_mstr
 op_std_setup   format "->>>,>>>,>>9.9<"  
 op_act_setup format "->>>,>>>,>>9.9<" 
 op_std_run * op_qty_comp label "std run" format "->>>,>>>,>>9.9<"
  op_act_run format "->>>,>>>,>>9.9<"
   with width 500 stream-io.
  

stdrun = stdrun + op_std_run * op_qty_comp.
actrun = actrun + op_act_run.
stdsetup = stdsetup + op_std_setup.
actsetup = actsetup + op_act_setup.

/*find first aa where aa.op_wkctr = op_hist.op_wkctr
and aa.op_type  = "labor" use-index op_type no-lock no-error.
if avail aa then disp aa.op_date.  */
  

end.
disp stdrun actrun stdsetup actsetup. 