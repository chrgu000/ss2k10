/* xgwosdrp2.p  待冲看板数量报表                                             */
/* Copy From xwosdrp2.p  2005.12.28                                         */

{mfdtitle.i "f "} 

define variable Lnr like xwosd_lnr initial "M100" no-undo .

define variable site like pt_site .
define variable site1 like pt_site.
define variable loc like pt_loc .
define variable loc1 like pt_loc.

define variable part like pt_part .
define variable part1 like pt_part .
define variable xdate as date initial today label "递延日期".
define variable xdate1 as date initial today.
define variable xwTotQty like xwosd_qty .
define variable xwConsumeQty like xwosd_qty column-label "待冲看板".
define variable isTotal like mfc_logic initial "no" label "汇总".

         /* SELECT FORM */
         form
	    Lnr		   colon 15
            part          colon 15
            part1         colon 49 label {t001.i}
            xdate         colon 15
            xdate1         colon 49 label {t001.i}
            site           colon 15
            site1          colon 49 label {t001.i}
            loc           colon 15
            loc1          colon 49 label {t001.i}
	    isTotal       colon 15 
            skip(1)
            
         with frame a side-labels width 80 attr-space.
	setFrameLabels(frame a:handle).

	 mainloop: repeat:
	    if site1 = hi_char then site1 = "".
	    if loc1 = hi_char then loc1 = "".
	    if part1 = hi_char then part1 = "".
	    if xdate = low_date then xdate = ?.
	    if xdate1 = hi_date then xdate1 = ?.

            update  lnr part part1 xdate xdate1 site site1 loc loc1 isTotal  with frame a.

            bcdparm = "".
            {mfquoter.i site         }
            {mfquoter.i site1        }
            {mfquoter.i loc         }
            {mfquoter.i loc1        }
            {mfquoter.i part        }
            {mfquoter.i part1       }

            if site1 = "" then site1 = hi_char.
            if loc1 = "" then loc1 = hi_char.
            if part1 = "" then part1 = hi_char .
	    if xdate = ? then xdate = low_date .
	    if xdate1 = ? then xdate1 = hi_date.

/*          {mfmsg.i 3039 2} */

            /* PRINTER SELECTION */
            {mfselbpr.i "printer" 132}
            {mfphead.i}

           for each xwosd_det where xwosd_lnr = lnr
	       and xwosd_used 
	       and xwosd_site >= site and xwosd_site <= site1
	       and xwosd_loc >= loc and xwosd_loc <= loc1
               and xwosd_part >= part and xwosd_part <= part1 
	       and (xwosd_qty - xwosd_qty_consume <> 0 )
	       and xwosd_use_dt >= xdate and xwosd_use_dt <= xdate1
               no-lock 
	       use-index xwosd_kb
	       break by xwosd_part 
	       with frame e width 180 stream-io.
	       IF first-of(xwosd_part) THEN xwTotQty = 0.
	        xwConsumeQty = xwosd_qty - xwosd_qty_consume.
	        xwTotQty = xwTotQty + xwConsumeQty.
           
	    if not isTotal then 
	    display xwosd_lnr 
		    xwosd_fg_lot
		    xwosd_op column-label "工序"
		    xwosd_use_dt 
		    xwosd_site 
		    xwosd_loc
		    xwosd_part
		    xwConsumeQty
		    with frame e .
            IF last-of(xwosd_part) THEN
            DO:
		down with frame e.
		 display xwosd_lnr 
			    "Sub-Total" @ xwosd_use_dt
			    xwosd_site 
			    xwosd_loc
			    xwosd_part
			    xwTotQty @ xwConsumeQty
			    with frame e .
           	
            END.
           end. /*xwosd_det */
        

         /* REPORT TRAILER  */
            
          {mfrtrail.i} 

/*            {mfreset.i} */

         end.   
