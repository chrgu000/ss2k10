/****************************************/
/* Syn Data for Multi-Domain            */
/* 20110711     Begin                  */
/* 20110725     Add More Paramter      */
/* 20110726     Add Schedule By SamSong      */

/****************************************/



{mfdtitle.i}
define variable wprogram as char.
define variable wglobal_domain like so_domain.
define variable usection as char format "x(16)".
wglobal_domain = global_domain .

repeat :
	for each syt_mstr where syt_active = yes          and  syt_havedomain = yes	
	                    and (today - syt_lupddate ) * 24 * 60 * 60   + time - syt_lupdtime  >= syt_updint    /*   and syt_Tdomain  = global_domain */ ,
	    each sytd_det where sytd_nbr = syt_nbr	   and sytd_program = syt_program 
			    and sytd_Sdomain = syt_Sdomain and sytd_Tdomain = syt_Tdomain  
			    break by syt_runseq by syt_nbr by syt_program by syt_Sdomain by syt_Tdomain  by sytd_seq:




	    if first-of (syt_Tdomain) then do:

	       wprogram = trim(syt_nbr) + substring ( syt_program  , 1 , index (syt_program ,".") - 1 ) + trim(sytd_Sdomain) + trim(sytd_Tdomain)  + ".p". 
	       output to value( trim(wprogram) ) .
			PUT  unformat  "~{mfdtitle.i" + "~}" skip .
			PUT  unformat "define variable usection as char format " + """" + "x(16)" + """" + "."  skip .
			PUT  unformat "repeat : " skip.
			PUT  unformat "find first " + syt_table + " where " + substring ( syt_table  , 1 , index (syt_table ,"_")  ) + "domain = " + """" + syt_Sdomain + """"  .
			PUT  unformat " and " + syt_tagfield + " = " + """" + trim(syt_fromval) + """" .
			if   ( syt_condition1 <> ""  or  syt_condition2 <> "" ) then PUT unformat " and " + syt_condition1 + syt_condition2.
			PUT  unformat  " no-error no-wait ."  skip.
			PUT  unformat "    IF AVAILABLE (" + syt_table + ") then do:" skip.
			PUT  unformat "usection = " + """" + substring ( syt_program  , 1 , index (syt_program ,".") - 1 ) + """" + " + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100)))." at 5 skip .
			PUT  unformat "output to value( trim(usection) + " + """" + ".i" + """" + ") append." at 5 skip.
		output close.
	    end.
	    output to value( trim(wprogram) ) append.
			if sytd_condition1 <> "" then PUT unformat sytd_condition1  at 10 skip.
			if sytd_condition2 <> "" then PUT unformat sytd_condition2  at 10 skip.
			
			PUT unformat  "PUT unformat " + """" + " " + """" + " "  at 10 .
			if sytd_ischar = yes then PUT unformat   """" + """"  + """" + """" + " + trim(" + sytd_SData + ") + " + """" + """"+ """"+ """".
			else PUT unformat   sytd_SData .
			PUT unformat " . /*"  + sytd_TData + "*/"  skip.
			if sytd_action  then PUT unformat "PUT unformat skip ." at 10 skip.

	    output close.

	    if last-of(syt_Tdomain) then do:
	       output to value( trim(wprogram) ) append.
			PUT  unformat "output close." at 5 skip.
			PUT unformat "batchrun  = yes." at 5 skip.
			PUT unformat "global_userid = " + """" + syt_updname + """" + ".".
			PUT unformat "input from value ( usection + " + """" + ".i" + """" + ") ." at 5 skip.
			PUT unformat "output to  value ( usection + " + """" + ".o" + """" + ") keep-messages ." at 5 skip.
         		PUT unformat "hide message no-pause." at 5 skip.
			PUT unformat "~{" + "gprun.i " +  """" + """" + trim(syt_program) + """" + """" + "~}" at 5 skip.     
         		PUT unformat "hide message no-pause." at 5 skip.
			PUT unformat "input close." at 5 skip.
			PUT unformat "output close." at 5 skip.
			PUT unformat "batchrun  = yes." at 5 skip.    
			PUT unformat syt_tagfield + " = " + """" + trim(syt_sucval) + """" + " ."  at 5 skip.     
			PUT unformat syt_errorfield + " = usection  ."  at 5 skip.     
			PUT unformat "end." at 5 skip.
			PUT unformat "else leave." at 5 skip.
			PUT  unformat "find next " + syt_table + " where " + substring ( syt_table  , 1 , index (syt_table ,"_")  ) + "domain = " + """" + syt_Sdomain + """"  .
			PUT  unformat " and " + syt_tagfield + " = " + """" + trim(syt_fromval) + """" .
			if   ( syt_condition1 <> ""  or  syt_condition2 <> "" ) then PUT unformat " and " + syt_condition1 + syt_condition2.
			PUT  unformat  " no-error no-wait ."  skip.


			PUT unformat "end." skip.

		output close.

                if last-of(syt_Tdomain) then do:
                   if global_domain <> syt_Tdomain then do:
     		      usection = "SynChangeDomain" +  trim(syt_Tdomain).
		      output to value( trim(usection) + ".ichangedomain") .
			 put unformat syt_Tdomain skip.   /* Line */
			 put unformat "." skip.   /* S */
			 put unformat "." skip.   /* Summary */
		      output close.
                      /* Change the Domain */ 
			batchrun = yes.
			input from value ( usection + ".ichangedomain") .
			output to  value ( usection + ".ochangedomain") .
			{gprun.i ""mgdomchg.p""}     
			input close.
			output close.
			batchrun = no.
                    end.
                end.
                

		batchrun  = yes.
		hide message no-pause.
		
		output to "RunSynProgram-ToBeDelete".
		run value(wprogram) .  
		output close.
		hide all no-pause .
		hide message no-pause.
		syt_lupddate = today.
		syt_lupdtime = time.
/*
		if   syt_updtimereset = yes then syt_lupdtime = 0 .
		else syt_lupdtime = time.
*/
	    end.   /* last-of(syt_Tdomain) then do: */



	end. /* for each syt_mstr where syt_active = yes	   and syt_Tdomain  = global_domain no-lock, */
        pause 2 .  

end.  /* repeat :*/
if wglobal_domain <> global_domain then do:
      usection = "SynresetDomain" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
      output to value( trim(usection) + ".iresetdomain") .
	 put unformat wglobal_domain skip.   /* Line */
	 put unformat "." skip.   /* S */
	 put unformat "." skip.   /* Summary */
      output close.
      /* Reset the Domain */ 
	batchrun = yes.
	input from value ( usection + ".iresetdomain") .
	output to  value ( usection + ".oresetdomain") .
	{gprun.i ""mgdomchg.p""}     
	input close.
	output close.
	batchrun = no.
end.


/************************/
/*
def variable odate as date .
def variable otime as integer.

odate = today .
otime = 52740 .

display (today - odate ) * 24 * 60 * 60   + time - otime >= 30

*/
/************************/