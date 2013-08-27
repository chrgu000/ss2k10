/* xxgetspec.i - INCLUDE FILE TO CONCAT ITEM SPECIFICATION TO A STRING */

/* ADM: 1.0       CREATED: 11/14/02       BY: Ivan Tse     */
/*
PURPOSE:
	TO CONCAT ITEM SPECIFICATION TO A STRING	
*/

/* Parameters: */
/*    {&1}            Item Number       ,String  */
/*    {&2}            Max char per line ,Integer */
/*    {&3}            Return Value      ,String[]*/
/*    {&4}            Size of Array     ,Integer */
/*    {&5}            Start Effective   ,Date    */
/*    {&6}            End Effective     ,Date    */

/*{3}[1] = "xxx".*/
	&if defined(xxgetspec) = 0 &then
     	&global-define xxgetspec
		define var xxgetspec_ipdtol as char.
		define var xxgetspec_i      as integer.
		define var xxgetspec_length as integer.
		define var xxgetspec_startdate as date.
		define var xxgetspec_enddate as date.		
	&endif
		
	   if {5}=? then	   
	   	xxgetspec_startdate = low_date.
	   else
	   	xxgetspec_startdate = {5}.
	   	
	   if {6}=? then
	   	xxgetspec_enddate = hi_date.
	   else
	   	xxgetspec_enddate = {6}.
	   
	   do xxgetspec_i=1 to {4}:
       		{3}[xxgetspec_i]= "".
       end.
       
       xxgetspec_i = 1.
       
       /* Assign {2} = "". */
       GREP:
       for each ipd_det where ipd_part={1} and ipd_routing = 'ITEMSPEC' and 
       	(ipd_end >= xxgetspec_startdate or ipd_end = ?) and (xxgetspec_enddate >= ipd_start or ipd_start = ?) no-lock:
       	
       	xxgetspec_ipdtol = trim(ipd_det.ipd_tol).
       	if xxgetspec_ipdtol <> "" then do:
       		if {3}[xxgetspec_i]="" then do:
       			{3}[xxgetspec_i] = xxgetspec_ipdtol.
       		end.
       		else do:
       			xxgetspec_length = length(xxgetspec_ipdtol, "RAW") + length({3}[xxgetspec_i], "RAW").
	       		if (xxgetspec_length) <{2} then do:
	    	   		{3}[xxgetspec_i] = {3}[xxgetspec_i] + " " + xxgetspec_ipdtol.
		       	end.
	    	   	else do:
	       			{3}[xxgetspec_i] = {3}[xxgetspec_i]. /* + " L=" + String(xxgetspec_length) . */
	       			xxgetspec_i = xxgetspec_i + 1.
	       			if xxgetspec_i>{4} then leave GREP.
	       			{3}[xxgetspec_i] = xxgetspec_ipdtol.
	       		end.
	       	end.
	   		/* {2} = {2} + " " + TRIM(ipd_det.ipd_tol). */
	    end.
	    if xxgetspec_i>{4} then leave.       
       end.


