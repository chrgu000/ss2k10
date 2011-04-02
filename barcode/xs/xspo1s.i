/* Create MFG/PRO Execte File Path  START */
/* Create MFG/PRO Execte File Path   END  */

/* Create Section Variable START */
define variable ausection as char format "x(16)".
/* Create Section Variable END */
DEFINE variable roundto2 AS DECIMAL DECIMALS 2.
define variable wpart like tr_part.
define variable wlot  like tr_serial.
define variable wref  like tr_ref.
define variable wsite like tr_site.
define variable wloc  like tr_loc.
define variable ciminputfile1   as char .
define variable cimoutputfile1  as char .


find last tr_hist   where 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
tr_nbr  = V1100     and  tr_type = "RCT-PO"  and  tr_part = V1300     and tr_serial = V1500    
use-index tr_date_trn no-lock no-error.
if available tr_hist then do:
   wpart = tr_part.
   wlot  = tr_serial.
   wref  = tr_ref.
   wsite = tr_site.
   wloc  = tr_loc.

	find first ld_det where ld_part = wpart and ld_lot = wlot
			    and ld_ref  = wref  and ld_site = wsite
			    and ld_loc  = wloc  and ld_ref = "" no-lock no-error.

	if available ld_det then  do:   
	   roundto2 = ld_qty_oh.      
	   if ld_qty_oh <> roundto2  then do:
		ausection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
		output to value( trim(ausection) + ".2di") .
		     display 
			"R"  skip
			wpart format "x(18)" skip
			wsite + " " format "x(9)" wloc + " " format "x(11)" """" + wlot + """" + " " format "x(21)" """" + wref + """" format "x(10)" skip
			roundto2 skip
			"RECADJ" skip
			"yes"    skip
			"."      skip
			"."      skip
		     with fram finput1 no-box no-labels width 200.
		output close.
		
		input from value ( ausection + ".2di") .
		output to  value ( ausection + ".2do") .
			{gprun.i ""icccaj.p""}
		input close.
		output close.
		ciminputfile1 = ausection + ".2di".
                cimoutputfile1 = ausection + ".2do".
                {xserrlg1.i}

	   end.
	end.

end.