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
define variable ciminputfile2   as char .
define variable cimoutputfile2  as char .



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
/*  Round to 2 Decimal  Start */
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
		ciminputfile1  = ausection + ".2di".
                cimoutputfile1 = ausection + ".2do".
                {xserrlg1.i}
	   end.
	end.
/*  Round to 2 Decimal  END */

/*  BLANK THE  Inventory Expire Date Start */
        find first pt_mstr where pt_part = wpart no-lock no-error.
	find first ld_det where ld_part = wpart and ld_lot = wlot
			    and ld_ref  = wref  and ld_site = wsite
			    and ld_loc  = wloc  and ld_ref = "" no-lock no-error.

	if ( available ld_det ) and pt_shelflife <> 0 then  do:   
		ausection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
		output to value( trim(ausection) + ".iei") .
		     display 
			wsite  + " " format "x(9)" 
			wloc  + " " format "x(11)"
			wpart + " " format "x(19)" 
		         """" + wlot + """" + " " format "x(21)" """" + wref + """" format "x(10)" skip
			/* date ( V1309 ) + pt_shelflife skip  */
			? skip
			"."      skip
		     with fram finputx no-box no-labels width 200.
		output close.
		
		input from value ( ausection + ".iei") .
		output to  value ( ausection + ".ieo") .
			{gprun.i ""icldmt.p""}
		input close.
		output close.
		ciminputfile2 = ausection + ".iei".
                cimoutputfile2 = ausection + ".ieo".
                {xserrlg2.i}
	end.
/*  BLANK THE  Inventory Expire Date END */


end.