/*the last version update by softspeed julie huang 08/11/26 */
/* Create MFG/PRO Execte File Path  START */
/* Create MFG/PRO Execte File Path   END  */

/* Create Section Variable START */
define variable ausection as char format "x(16)".
/* Create Section Variable END */
define variable wpart like tr_part.
define variable wlot  like tr_serial.
define variable wref  like tr_ref.
define variable wsite like tr_site.
define variable wloc  like tr_loc.
define variable ciminputfile1   as char .
define variable cimoutputfile1  as char .
define variable ciminputfile2   as char .
define variable cimoutputfile2  as char .
define variable olad_qty_pick like lad_qty_pick.  /* SAME ITEM IN ONE SO*/
define variable olad_qty_all  like lad_qty_all.   /* OTHER LINE ALLOCATION QTY */
define variable tlad_qty_pick like lad_qty_pick.  /* THIS  LINE ALLOCATION QTY */
define variable wlad_qty_pick like lad_qty_pick.  
define variable wlad_qty_all  like lad_qty_all.   

olad_qty_pick = 0.
olad_qty_all  = 0.
tlad_qty_pick = 0. 
wlad_qty_pick = 0.
wlad_qty_all  = 0.

find last tr_hist   where 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
tr_nbr  = V1100     and  tr_type = "RCT-TR"  and  tr_part = V1300     and tr_serial = V1500    
use-index tr_date_trn no-lock no-error.
if available tr_hist then do:
   wpart = tr_part.
   wlot  = tr_serial.
   wref  = tr_ref.
   wsite = tr_site.
   wloc  = tr_loc.

	find first ld_det where ld_part = wpart and ld_lot = wlot
			    and ld_ref  = wref  and ld_site = wsite
			    and ld_loc  = wloc  and ld_ref = wref no-lock no-error.

	if available ld_det then  do:   


		ausection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
		output to value( trim(ausection) + ".isi") .
		     display 
			wsite  + " " format "x(9)" 
			wloc  + " " format "x(11)"
			wpart + " " format "x(19)" 
		         """" + wlot + """" + " " format "x(21)" """" + wref + """" format "x(10)" skip
			"? - - SO-ALLOC" skip
			"."      skip
		     with fram finput2 no-box no-labels width 200.
		output close.
		
		input from value ( ausection + ".isi") .
		output to  value ( ausection + ".iso") .
			{gprun.i ""icldmt.p""}
		input close.
		output close.
		ciminputfile2  = ausection + ".isi".
		cimoutputfile2 = ausection + ".iso".
		{xserrlg2.i}



           
	   for each  lad_det where lad_dataset = "SOD_DET" 
	                        and lad_nbr = V1100 
				and lad_line <> V1305 
				and lad_site = wsite
				and lad_loc  = wloc
				and lad_part = wpart
				and lad_lot  = wlot
				and lad_ref  = wref  no-lock  :

                 olad_qty_pick = olad_qty_pick + lad_qty_pick .
		 olad_qty_all  = olad_qty_all  + lad_qty_all.

           end.			
	   for each  lad_det where lad_dataset = "SOD_DET" 
	                        and lad_nbr = V1100 
				and lad_site = wsite
				and lad_part = wpart
				and lad_line = V1305
                                /* SS - 090630.1 - B 
				and lad_ref  = wref no-lock  :
                                if lad_lot <> wlot or lad_loc <> wloc then do : 
                                 SS - 090630.1 - E */
                                /* SS - 090630.1 - B */
                                 no-lock  :
                                 if lad_lot <> wlot or lad_loc <> wloc or lad_ref  <> wref then do : 
                                /* SS - 090630.1 - E */
                 
                    wlad_qty_pick = wlad_qty_pick + lad_qty_pick .
		    wlad_qty_all  = wlad_qty_all  + lad_qty_all.
		 end.

           end.			
           find first lad_det where lad_dataset = "SOD_DET" 
	                        and lad_nbr = V1100 
				and lad_line = V1305 
				and lad_site = wsite
				and lad_loc  = wloc
				and lad_part = wpart
				and lad_lot  = wlot
				and lad_ref  = wref  no-lock no-error.
                    
           if available lad_det then tlad_qty_pick = lad_qty_pick .
	                                  
		ausection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
        	find first ld_det where ld_part = wpart and ld_lot = wlot
		                    and ld_ref  = wref  and ld_site = wsite
			            and ld_loc  = wloc  and ld_ref = wref no-lock no-error.
                find first sod_det where sod_nbr = V1100 and string ( sod_line ) = V1305 no-lock no-error.

		output close.
		output to value( trim(ausection) + ".sai") .
		 /*    display 
			trim ( V1100 ) + " " + trim (V1002) format "x(50)"  skip
			"N Y - N" format "x(50)" skip
			trim ( V1305 ) format "x(50)" skip
			"0 0 Y" skip
			trim ( V1400 ) + " " + """" + wlot + """" + " " + trim ( V1100 ) format "x(50)" skip
			
			string ( ld_qty_oh - tlad_qty_pick - olad_qty_pick - olad_qty_all )  +   " "   + string ( tlad_qty_pick ) format "x(50)" skip

			"Y" skip
			"." skip
			"." skip
		     with fram finput1 no-box no-labels width 200.
		     */
		     put UNFORMATTED trim ( V1100 ) + " " + trim (V1002) format "x(50)"  skip .
		     put UNFORMATTED "N Y - N" format "x(50)" skip.
		     put UNFORMATTED trim ( V1305 ) format "x(50)" skip.
		     put UNFORMATTED "0 0 Y" skip.
		     put UNFORMATTED trim ( V1400 ) + " " + """" + wlot + """" + " " + trim ( V1003 ) format "x(50)" skip. /*julie huang 08/11/26 v1100-->v1003*/
			
		     put UNFORMATTED string ( ld_qty_oh - tlad_qty_pick - olad_qty_pick - olad_qty_all )  +   " "   + string ( tlad_qty_pick ) format "x(50)" skip.
                

                     if  sod_qty_ord - sod_qty_ship - sod_qty_pick  <>  wlad_qty_pick + wlad_qty_all + ( ld_qty_oh - olad_qty_pick - olad_qty_all )  then 
		     put UNFORMATTED "." skip .

		     put UNFORMATTED "Y" skip .
		     put UNFORMATTED "." skip .
		     put UNFORMATTED "." skip .

		output close.
		
		input from value ( ausection + ".sai") .
		output to  value ( ausection + ".sao") .
			{gprun.i ""sosoal.p""}
		input close.
		output close.
		ciminputfile1 = ausection + ".sai".
                cimoutputfile1 = ausection + ".sao".
                {xserrlg1.i}
           
	   end.

           
end.