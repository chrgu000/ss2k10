/* xxldprtfg.p - FG location print                                      */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 1.20          Created: 11/17/2008    BY: xie yu lin        */

         {mfdtitle.i "1.0 "} 

	 define variable part like pt_part label "零件号".
         define variable part1  like pt_part.
	 define variable loc like loc_loc label "库位".
         define variable loc1  like loc_loc.
	 define variable lot like ld_lot label "批号".
         define variable lot1  like ld_lot.
         define variable serial as char format "x(4)" label "起始序号".

	 define variable wsection as char format "x(16)".
         define variable ts9130 AS CHARACTER FORMAT "x(100)".
         define variable av9130 AS CHARACTER FORMAT "x(100)".
         define variable serial1 as integer no-undo.

         FORM 
 	    part        colon 20
            part1         label {t001.i} colon 49 skip
	    loc         colon 20
            loc1          label {t001.i} colon 49 skip
 	    lot         colon 20
            lot1          label {t001.i} colon 49 skip
	    skip(1)
	    serial      colon 20
	    skip(1)
         with frame a attr-space side-labels width 80.

         {wbrp01.i}
         repeat:
	    if part1 = hi_char then part1  = "".
	    if loc1 = hi_char then loc1  = "".
	    if lot1 = hi_char then lot1  = "".

            if c-application-mode <> 'web' then
            update part part1 loc loc1 lot lot1 serial with frame a.


            {wbrp06.i &command = update
                      &fields = " loc loc1 lot lot1 serial"
                      &frm = "a"}

            if (c-application-mode <> 'web') or
               (c-application-mode = 'web' and
               (c-web-request begins 'data')) 
	    then do:
               bcdparm = "".
	       {mfquoter.i part     }
               {mfquoter.i part1    }
	       {mfquoter.i loc      }
               {mfquoter.i loc1     }
	       {mfquoter.i lot      }
               {mfquoter.i lot1     }

	       if part1 = "" then part1 = hi_char.
	       if loc1 = "" then loc1 = hi_char.
	       if lot1 = "" then lot1 = hi_char.
            end.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 80}
            {mfphead.i}

            serial1 = integer(serial).

	    for each ld_det no-lock
	       where ld_part >= part and ld_part <= part1
	         and ld_loc >= loc and ld_loc <= loc1
	         and ld_lot >= lot and ld_lot <= lot1
		 and ld_qty_oh <> 0
	    break by substring(ld_loc,2,length(ld_loc)) by ld_part:

               find first pt_mstr where pt_part = ld_part no-lock no-error.

	       if available pt_mstr then do:         
	          if pt_prod_line >= "FG01" and pt_prod_line <= "FG19" then do:

		     run prt_lbl(input pt_break_cat, input pt_part, input pt_draw, input pt_desc1, input pt_desc2, input ld_lot, input ld_qty_oh).

                     serial1 = serial1 + 1.
		     
                  end.
               end.

               {mfrpexit.i}
	    end.

            Procedure prt_lbl:
	       DEFINE INPUT PARAMETER i_break_cat like pt_break_cat. 
	       DEFINE INPUT PARAMETER i_part like pt_part.
	       DEFINE INPUT PARAMETER i_draw like pt_drwg_loc.
               DEFINE INPUT PARAMETER i_desc1 like pt_desc1.
               DEFINE INPUT PARAMETER i_desc2 like pt_desc2.
	       DEFINE INPUT PARAMETER i_lot like ld_lot.
               DEFINE INPUT PARAMETER i_qty_oh like ld_qty_oh.
	       
               if serial = "" then do:
	          INPUT FROM VALUE("/mfgeb2/script_bc/labels/tfg.txt").
               end.
               else do:
	          INPUT FROM VALUE("/mfgeb2/script_bc/labels/tfg_ser.txt").
               end.

	       wsection = string(MONTH(TODAY)) + string(DAY(TODAY))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) . 

               output to value( trim(wsection) + "l.l") .

               repeat:
                  IMPORT UNFORMATTED ts9130.

		  if INDEX(ts9130, "$x") <> 0 THEN DO:
                     av9130 = i_break_cat.
                     TS9130 = substring(TS9130, 1, Index(TS9130 , "$x") - 1) + av9130 
                            + SUBSTRING( ts9130 , index(ts9130 ,"$x") 
		            + length("$x"), LENGTH(ts9130) - ( index(ts9130 , "$x") + length("$x") - 1 ) ).
	          END.

                  if INDEX(ts9130, "$p") <> 0 THEN DO:
                     av9130 = i_part.
                     TS9130 = substring(TS9130, 1, Index(TS9130 , "$p") - 1) + av9130 
                            + SUBSTRING( ts9130 , index(ts9130 ,"$p") 
		            + length("$p"), LENGTH(ts9130) - ( index(ts9130 , "$p") + length("$p") - 1 ) ).
	          END.

                  if INDEX(ts9130, "$t") <> 0 THEN DO:
                     av9130 = i_draw.
                     TS9130 = substring(TS9130, 1, Index(TS9130 , "$t") - 1) + av9130 
                            + SUBSTRING( ts9130 , index(ts9130 ,"$t") 
		            + length("$t"), LENGTH(ts9130) - ( index(ts9130 , "$t") + length("$t") - 1 ) ).
	          END.

                  if INDEX(ts9130, "$f") <> 0 THEN DO:
                     av9130 = i_desc1.
                     TS9130 = substring(TS9130, 1, Index(TS9130 , "$f") - 1) + av9130 
                            + SUBSTRING( ts9130 , index(ts9130 ,"$f") 
		            + length("$f"), LENGTH(ts9130) - ( index(ts9130 , "$f") + length("$f") - 1 ) ).
	          END.

                  if INDEX(ts9130, "$e") <> 0 THEN DO:
                     av9130 = i_desc2.
                     TS9130 = substring(TS9130, 1, Index(TS9130 , "$e") - 1) + av9130 
                            + SUBSTRING( ts9130 , index(ts9130 ,"$e") 
		            + length("$e"), LENGTH(ts9130) - ( index(ts9130 , "$e") + length("$e") - 1 ) ).
	          END.

                  if INDEX(ts9130, "$l") <> 0 THEN DO:
                     av9130 = "ZB" + i_lot.
                     TS9130 = substring(TS9130, 1, Index(TS9130 , "$l") - 1) + av9130 
                            + SUBSTRING( ts9130 , index(ts9130 ,"$l") 
		            + length("$l"), LENGTH(ts9130) - ( index(ts9130 , "$l") + length("$l") - 1 ) ).
	          END.

		  if INDEX(ts9130, "$q") <> 0 THEN DO:
                     av9130 = string(i_qty_oh).
                     TS9130 = substring(TS9130, 1, Index(TS9130 , "$q") - 1) + av9130 
                            + SUBSTRING( ts9130 , index(ts9130 ,"$q") 
		            + length("$q"), LENGTH(ts9130) - ( index(ts9130 , "$q") + length("$q") - 1 ) ).
	          END.

	          if serial <> "" then do:
		     if INDEX(ts9130, "$s") <> 0 THEN DO:
                        av9130 = string(serial1,"9999").

                        TS9130 = substring(TS9130, 1, Index(TS9130 , "$s") - 1) + av9130 
                               + SUBSTRING( ts9130 , index(ts9130 ,"$s") 
		               + length("$s"), LENGTH(ts9130) - ( index(ts9130 , "$s") + length("$s") - 1 ) ).
	             end.
	          END.
		  else do:
		     if INDEX(ts9130, "$s") <> 0 THEN DO:
                        av9130 = "".

                        TS9130 = substring(TS9130, 1, Index(TS9130 , "$s") - 1) + av9130 
                               + SUBSTRING( ts9130 , index(ts9130 ,"$s") 
		               + length("$s"), LENGTH(ts9130) - ( index(ts9130 , "$s") + length("$s") - 1 ) ).
	             end.
		  end.
                  

		  if INDEX(ts9130, "&b") <> 0 THEN DO:
                     av9130 = "*" + i_part + "@" + i_lot.

                     TS9130 = substring(TS9130, 1, Index(TS9130 , "&b") - 1) + av9130 
                            + SUBSTRING( ts9130 , index(ts9130 ,"&b") 
		            + length("&b"), LENGTH(ts9130) - ( index(ts9130 , "&b") + length("&b") - 1 ) ).
	          END.

                  put unformatted ts9130 skip.
               END.

               INPUT CLOSE.
               OUTPUT CLOSE.

               output to value("prt1.prn") .
               unix silent value ("chmod 777  " + trim(wsection) + "l.l").

               find first prd_det where prd_dev = trim(dev) no-lock no-error.
               IF AVAILABLE prd_det then do:
                  unix silent value (trim(prd_path) + trim(wsection) + "l.l").
               end.
               OUTPUT CLOSE.
            end.

            {mfreset.i}
         end. /* REPEAT */

