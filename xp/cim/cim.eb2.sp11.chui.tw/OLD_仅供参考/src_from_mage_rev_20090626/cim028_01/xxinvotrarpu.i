/* {xxinvotraa.i} */

/* define variable global_user_lang_dir as char format "x(40)" init "/app/mfgpro/eb2/". */
define variable usection as char format "x(16)". 


/* ********************Kaine B Del*******************
 *  usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "invotr" .
 *  output to value( trim(usection) + ".i") .
 *  	for each tm1mstr no-lock :
 *  		display 
 *  		    trim(tm1_part) format "x(18)" skip
 *  		    trim(String(tm1_qty))	 format "x(40)" skip
 *  		    trim(site_from) format "x(12)" if trim(loc_from) = "" then """""" else """" + trim(loc_from) + """" format "x(12)" skip
 *  		    trim(site_to)	format "x(12)" if trim(loc_to)	= "" then  """""" else """" + trim(loc_to) + """" format "x(12)"	 skip
 *  		    "y"	skip
 *  		    ". " 
 *  		with fram finput no-box no-labels width 200.
 *  	end.
 *  output close.
 *  
 *  input from value ( usection + ".i") .
 *  output to  value ( usection + ".o") .
 *      {gprun.i ""iclotr02.p""}
 *  input close.
 *  output close.
 *  
 *  UNIX silent value ( "rm "  + Trim(usection) + ".i").
 *  unix silent value ( "rm "  + Trim(usection) + ".o"). 
 * ********************Kaine E Del*******************/

    
    /* ***********************Kaine B Add********************** */
    for each tm1mstr no-lock :
        usection = TRIM(string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))
            + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "invotr" 
            .

		output to value( trim(usection) + ".i") .
		
		PUT
		    "~"" AT 1
		    trim(tm1_part) format "x(18)"
		    "~""
		    SKIP
		    
		    trim(String(tm1_qty)) FORMAT "x(40)"    " "
		    "- - - "
		    "~""
		    invno
		    "~""
		    SKIP
		    
		    trim(site_from) format "x(12)"
		    if trim(loc_from) = "" then """""" else ("""" + trim(loc_from) + """") format "x(12)"
		    SKIP
		    
		    trim(site_to)	format "x(12)"
		    if trim(loc_to)	= "" then  """""" else ("""" + trim(loc_to) + """") format "x(12)"	 
		    SKIP
		    "y"	SKIP
		    "y"	SKIP
		    ". " 
		.
		
		OUTPUT CLOSE.
		
		input from value ( usection + ".i") .
        output to  value ( usection + ".o") .
        batchrun = YES.
        {gprun.i ""iclotr02.p""}
        batchrun = NO.
        input close.
        output close.
        
        UNIX silent value ( "rm "  + Trim(usection) + ".i").
        UNIX silent value ( "rm "  + Trim(usection) + ".o").
	end.
	/* ***********************Kaine E Add********************** */
	