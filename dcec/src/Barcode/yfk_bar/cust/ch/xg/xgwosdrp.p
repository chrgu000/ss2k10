/* xgwosdrp.p  看板数据调整查询                                             */
/* Copy From xwosdrp.p  2005.12.28                                          */
/* Last Modified: hou              2006.03.13                        *H01*  */

/*H01*/
function gettime return integer
   (input s_time  as char).
   return integer(substr(s_time,1,index(s_time,":") - 1)) * 3600
          + integer(substr(s_time,index(s_time,":") + 1)) * 60.
end function.

{mfdtitle.i "f "} 

define variable Lnr like xwosd_lnr initial "M100" no-undo .

define variable site like pt_site .
define variable site1 like pt_site.
define variable loc like pt_loc .
define variable loc1 like pt_loc.

define variable part like pt_part .
define variable part1 like pt_part .
define variable xdate as date initial today label "操作日期".
define variable xdate1 as date initial today.
define variable xwQty like xwosd_qty column-label "数量".
/*H01*/
define variable stime  as   char label "使用时间".
define variable stime1 as  char.
define variable xtime like xwosd_use_tm.
define variable xtime1 like xwosd_use_tm.

/*H01*/
{xkutlib.i}
  
         /* SELECT FORM */
         form
	    Lnr		   colon 15
            xdate         colon 15
            xdate1         colon 49 label {t001.i}
/*H01*/     stime         colon 15
/*H01*/     stime1        colon 49  label {t001.i}
            site           colon 15
            site1          colon 49 label {t001.i}
            loc           colon 15
            loc1          colon 49 label {t001.i}
            part          colon 15
            part1         colon 49 label {t001.i}
            skip(1)
            
         with frame a side-labels width 80 attr-space.
	setFrameLabels(frame a:handle).

	 mainloop: repeat:
	    if site1 = hi_char then site1 = "".
	    if loc1 = hi_char then loc1 = "".
	    if part1 = hi_char then part1 = "".
	    if xdate = low_date then xdate = ?.
	    if xdate1 = hi_date then xdate1 = ?.

            update  lnr xdate xdate1 stime stime1 site site1 loc loc1 part part1  with frame a.
       
/*H01*/    if stime <> "" and not IsCorrectTime(stime) or
/*H01*/       stime1 <> "" and not IsCorrectTime(stime1) then do:
/*H01*/       message "请输入正确的时间"view-as alert-box error.
/*H01*/       undo , retry .
/*H01*/     end.

            bcdparm = "".
            {mfquoter.i site         }
            {mfquoter.i site1        }
            {mfquoter.i stime        }
            {mfquoter.i stime1       }
            {mfquoter.i loc         }
            {mfquoter.i loc1        }
            {mfquoter.i part        }
            {mfquoter.i part1       }

            if site1 = "" then site1 = hi_char.
            if loc1 = "" then loc1 = hi_char.
            if part1 = "" then part1 = hi_char .
	    if xdate = ? then xdate = low_date .
	    if xdate1 = ? then xdate1 = hi_date.
       xtime = gettime(stime).
       xtime1 = gettime(stime1).
       
       if xtime1 = 0 then xtime1 = 86400.
       
/*          {mfmsg.i 3039 2} */

            /* PRINTER SELECTION */
            {mfselbpr.i "printer" 132}
            {mfphead.i}

       for each xwosd_det where xwosd_lnr = lnr
/*H01*    and xwosd_date >= xdate and xwosd_date <= xdate1  */
/*H01*/   and (xwosd_date > xdate or 
/*H01*/        xwosd_date = xdate and xwosd_use_tm >= xtime)
/*H01*/   and (xwosd_date < xdate1 or 
/*H01*/        xwosd_date = xdate1 and xwosd_use_tm <= xtime1)
	       and xwosd_site >= site and xwosd_site <= site1
	       and xwosd_loc >= loc and xwosd_loc <= loc1
               and xwosd_part >= part and xwosd_part <= part1 
               no-lock BY xwosd_lnr BY xwosd_date BY xwosd_use_tm with frame e width 180 stream-io.
		xwQty =  xwosd_qty.
            display xwosd_lnr 
		    xwosd_date 
		    xwosd_site 
		    xwosd_loc
		    xwosd_part
	    	    xwQTY
		    xwosd__chr01 column-label "操作人"
		    xwosd_use_dt column-label "操作日期"
		    string(xwosd_use_tm,"HH:MM:SS") column-label "时间"
		    xwosd__chr02 column-label "操作备注" format "x(60)"
		    with frame e .
            
           end.
        

         /* REPORT TRAILER  */
            
/*          {mfrtrail.i} */

            {mfreset.i}

         end.   
