    {mfdeclre.i}
    DEFINE var bkflh_file as char format "x(50)".

    find first usrw_wkfl where usrw_domain = global_domain and
               usrw_key1 = "BKFLH-CTRL" no-lock no-error.
    if available usrw_wkfl then do:
    	 assign bkflh_file = usrw_charfld[14] + "bkflh_file.in".
		end.
		
    input close.
    batchrun = yes.
    input from value(bkflh_file).
    output to value(bkflh_file + ".out") keep-messages.
       
    hide message no-pause.
       
    {gprun.i ""yyrebkfl.p""}
       
    hide message no-pause.
      
    output close.
    input close.
    batchrun = no.
    
