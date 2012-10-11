/* Last modified by jjz_mfg at 12:12:41 on 2 Aug, 2000 */
/* Last modified by jjz at 10:56:07 on 26 Nov, 1999 */
/* yyscim.p */
/* CIM file */
/* Limitation - record size of input file cannot greater than 1000 char */
/* Last modified by henri 15/8/2012 */
{mfdeclre.i}

{mf1.i }
{yyglcim.i  }
def var lang_flag as logical.

if global_user_lang = "us" then lang_flag = false.
else lang_flag = true.

if lang_flag then assign
	global_user_lang_dir = "us\"
	global_user_lang = "us".

define input parameter cimfile as char format "x(70)" no-undo.
define input parameter ofile as char no-undo.
define output parameter haserror as log no-undo.
define output parameter errmsg as char no-undo.

define var cerrmsg as char no-undo.
define var allmsg as char no-undo.
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
define var lDebug as log no-undo. lDebug = no.
define var op_open as log no-undo.

define var i as integer.

if search(cimfile) = ? then do:
    errmsg = "Input cim file does not exists..." .
    haserror = true.
    return.
end.

old_batchrun = batchrun.                                              /*D16JJ*/
batchrun     = yes.                                                   /*D16JJ*/


tempfile = cimfile + ".tmp".
logfile = ofile.
tempout = cimfile + ".out".
/* cimfile = cimfile + ".q". */

input stream ip from value(cimfile) no-echo.
output stream lg to value(logfile)  append.
repeat:

    import stream ip temp_line.

    if trim(temp_line) = "" then temp_line = "-".
    if temp_line begins "@@batchload" then do:
	prog_id = trim(substring(temp_line,12)).
	output stream op to value(tempfile).
        op_open = yes.
	i = 0.
	next.
    end.

    i = i + 1.

    if temp_line begins "@@end" then do:
	output stream op close.
        op_open = no.
	/* run update program */
	input from value(tempfile).
	output to value(tempout).
	    find first mnd_det where mnd_exec = prog_id no-lock no-error.
	    if avail mnd_det then do:
		thismenu =  mnd_nbr + "." + string(mnd_select).
		thisselection = mnd_select.
		{mfprdef.i thismenu}
	    end.
	    if printdefault = "" or printdefault = "terminal" or
	       printdefault = "page" or printdefault = "window"
	       then printdefault = "outfile".
	    {gprun.i prog_id}.
	output close.
	input close.

/*
	unix silent grep -e 'ERROR' -e 'WARN' -e '~\^~*' value(tempout) >> value(logfile).

*/
                errmsg = "".
                define stream s_error.
                input stream s_error from value(tempout) no-echo.
                repeat:
                        import stream s_error unformatted cerrmsg.
			if index(cerrmsg,"Error") > 0 then do:
				errmsg = errmsg + " " + cerrmsg.
				put stream lg cerrmsg format "x(100)" skip.
			end.
			if index(cerrmsg,"Warning") > 0 then do:
				put stream lg cerrmsg format "x(100)" skip.
			end.
                        if length(errmsg) >= 1000 then leave.
                end.

                input stream s_error close.
                errmsg = trim(errmsg).
                if errmsg <> "" then ierror = 0.
                else ierror = 1.
	
	next.
    end.

    if op_open then
    put stream op unformat temp_line skip.
end.

if lang_flag then assign
	global_user_lang_dir = "ch\"
	global_user_lang = "ch".

display stream lg "#### JOB END ####" with frame yy
	no-box no-label.
output stream lg close.

batchrun = old_batchrun.                                              /*D16JJ*/

if not lDebug then do:
	dos silent del /F value(tempfile).
end.

if ierror <> 0 then haserror = no.
else haserror = yes.
