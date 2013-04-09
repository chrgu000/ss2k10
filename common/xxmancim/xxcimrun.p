/* Last modified by jjz_mfg at 12:12:41 on 2 Aug, 2000 */
/* Last modified by jjz at 10:56:07 on 26 Nov, 1999 */
/* xxscim.p */
/* CIM file */
/* Limitation - record size of input file cannot greater than 1000 char */
/* JJ modify from xxscim2.p  */

{mfdeclre.i}
{mf1.i }

define input parameter cimfile as char format "x(70)" no-undo.
define input parameter ofile as char no-undo.
define input parameter uDebug as logical no-undo.
define output parameter haserror as log no-undo.
define output parameter v_ermsg as char no-undo.
 

define var cerrmsg as char no-undo.
define var ierror as int initial -99 no-undo.

define stream ip.
define stream op.
define stream lg.

define var tempfile as char format "x(70)".
define var tempout as char format "x(70)".
define var logfile as char format "x(70)".
define var tempext as char format "999".
define var temp_line as char format "x(1000)".
define var prog_id as char format "x(20)".
define var old_batchrun like batchrun.                                /*D29JJ*/
define var thismenu as char.                                          /*D29JJ*/
define var thisselection as integer.
define var lDebug as log no-undo. 
define var op_open as log no-undo.
define var err_num as int.
define var rcd_total as int.
define var i as integer.
define var v_line as int.
define var errmsg as char .
define var old_err as char.

lDebug = uDebug.

if search(cimfile) = ? then do:
    message "Input cim file does not exists...".
    return.
end.

old_batchrun = batchrun.                                              /*D16JJ*/
batchrun     = yes.                                                   /*D16JJ*/
/*
tempfile = substring(cimfile,1,r-index(cimfile,"/")) + "xxscim.".
i = 0.
repeat:
    tempext = string(i,"999").
    if search(tempfile + tempext) = ? then do:
	tempfile = tempfile + tempext.
	leave.
    end.
    i = i + 1.
end.
*/

unix silent quoter value(cimfile) > value(cimfile + ".q").
tempfile = cimfile + ".tmp".
logfile = cimfile + ".log".
tempout = cimfile + ".out".
cimfile = cimfile + ".q".

if search(logfile) <> ? then do:

   unix silent rm -f value(logfile).
end.

tempout = ofile.

input stream ip from value(cimfile) no-echo.
output stream lg to value(logfile) /*append*/ .
repeat:

    import stream ip temp_line.

    if trim(temp_line) = "" then temp_line = "-".
    if temp_line begins "@@batchload" then do:
	prog_id = trim(substring(temp_line,12)).
	output stream op to value(tempfile).
        op_open = yes.
	rcd_total = rcd_total + 1.


	i = 0.
	next.
    end. 

    i = i + 1.

    if i = 1 then
    display stream lg today string(time,"HH:MM:SS") rcd_total prog_id  
	    temp_line format "x(50)"
	    with frame y width 300 no-label no-box no-attr-space.


    if temp_line begins "@@end" then do:
	output stream op close.
        op_open = no.
	/* run update program */
	input from value(tempfile).
	
	if search(tempout) <> ? then do:

		unix silent rm -f value(tempout).
	end.
        
	output to value(tempout) .
	    find first mnd_det where mnd_exec = prog_id no-lock no-error.
	    if avail mnd_det then do:
		thismenu =  mnd_nbr + "." + string(mnd_select).
		thisselection = mnd_select.
		{mfprdef.i thismenu}
	    end.
	    if printdefault = "" or printdefault = "terminal" or
	       printdefault = "page"
	       then printdefault = "outfile".
	    {gprun.i prog_id}.
	output close.
	input close.

	/* check error */
	output stream lg close.
/*
	unix silent grep -e 'ERROR' -e 'WARN' -e '~\^~*' value(tempout) >> value(logfile).
*/
	errmsg = "".
	output stream lg to value(logfile) append.
     /*   if ierror <> 0 then do:*/
                
                define stream s_error.
                input stream s_error through grep -e 'ERROR' -e  '~\^~*' value(tempout) 2> /dev/null  no-echo.
                repeat:
                        import stream s_error unformatted cerrmsg.
                        if length(errmsg) + length(cerrmsg) >= 500 then leave.
			if old_err <> cerrmsg then do:
			   errmsg = errmsg + " " + cerrmsg.
			   old_err = cerrmsg .
			end.
                        
                end.
/*
                set stream s_error ierror.
*/
                input stream s_error close.
                errmsg = trim(errmsg).
                if errmsg <> "" then ierror = 0.
                else ierror = 1.
	        
		if errmsg <> "" then do:
		   display stream lg errmsg format "x(300)"  with frame y2 width 320 no-label no-box. 
		  /* output stream lg close.*/
		   v_ermsg = "Have Error!".
		   err_num = err_num + 1.
		end.

       /* end. */
	next.
    end.
    
    if op_open then
    put stream op unformat temp_line skip.
end.
display stream lg "Total Record:" string(rcd_total) no-label.
display stream lg "ERROR Number:" string(err_num) no-label.

display stream lg "#### JOB END ####" with frame yy
	no-box no-label.
output stream lg close.

batchrun = old_batchrun.                                              /*D16JJ*/

if not lDebug then do:
	/*
	unix silent rm -f value(tempfile) value(tempout) value(cimfile) value(logfile). 
	*/
	unix silent rm -f value(tempfile) value(cimfile) .
end.

if v_ermsg <> "" then haserror = no.
else haserror = yes.
