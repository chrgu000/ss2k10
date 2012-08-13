/*----------------------------------------------------------
  File         xkgpwtmt.p
  Description  Kanban item group window time maintenance
  Author       Yang Enping
  Created      2004-06-14
  History
      2004-6-14, Yang Enping
         1. Spec: 零件组及要货单规范V2.doc
  ---------------------------------------------------------*/

  {mfdtitle.i "AO"}

  define variable grp like xkgp_group .
  define variable wdtm as char format "x(800)" view-as fill-in size 60 by 1 extent 7 .
  define variable nextDate as date .
  define variable nextTime as char .
  
  form
     grp label "组" colon 14
     xkgp_desc no-label
     skip(2)

     "窗口时间(HH:MM)"  view-as text colon 10 skip(0.5)
     "星期一" colon 3  wdtm[1] no-label colon 10 skip(0.5)
     "星期二" colon 3  wdtm[2] no-label colon 10 skip(0.5)
     "星期三" colon 3  wdtm[3] no-label colon 10 skip(0.5)
     "星期四" colon 3  wdtm[4] no-label colon 10 skip(0.5)
     "星期五" colon 3  wdtm[5] no-label colon 10 skip(0.5)
     "星期六" colon 3  wdtm[6] no-label colon 10 skip(0.5)
     "星期日" colon 3  wdtm[7] no-label colon 10
     skip(2)
     nextDate label "下次要货日期" colon 10
     nextTime label "时间" colon 40
     with frame a side-labels three-d width 80.

  {xkutlib.i}

  define var i as int .

  MainLoop:
  repeat:
     prompt-for grp  with frame a editing:
        {mfnp.i xkgp_mstr grp xkgp_group grp xkgp_group xkgp_group}

        if recno <> ? then do:
	   find first xkgp_mstr no-lock
	   where recid(xkgp_mstr) = recno .

           nextDate = xkgp_mstr.xkgp_next_date .
	   nextTime = string(xkgp_mstr.xkgp_next_time,"HH:MM") .

           display xkgp_group @ grp 
	           xkgp_desc
	           nextDate nextTime
		   with frame a.
                   
	   find first xkt_mstr no-lock
	   where xkt_group = xkgp_group 
	   no-error .

	   if available(xkt_mstr) then do:
              do i = 1 to 7:
	         wdtm[i] = xkt_mstr.xkt_time[i] .
	      end .
	   end .

	   display wdtm with frame a .
	      
        end. /* if recno <> ? */
     end. /* prompt-for */
     assign frame a grp .

     if grp = "" then do:
        {mfmsg.i 40 3} /* BLANK NOT ALLOWED */
        undo mainloop.
     end.

     find first xkgp_mstr no-lock
     where xkgp_group = grp 
     no-error .
     if not available(xkgp_mstr) then do:
        message "Kanban item group not exists, please re-entry" view-as alert-box error .
	next .
     end .

     nextDate = xkgp_mstr.xkgp_next_date .
     nextTime = string(xkgp_mstr.xkgp_next_time,"HH:MM") .

     display xkgp_group @ grp 
	     xkgp_desc
	     nextDate nextTime
     with frame a.
             
     find first xkt_mstr exclusive-lock
     where xkt_group = xkgp_group 
     no-error .

     if not available(xkt_mstr) then do:
        create xkt_mstr .
	assign xkt_mstr.xkt_group = grp .
     end .

     do i = 1 to 7:
	wdtm[i] = xkt_mstr.xkt_time[i] .
     end .

     display wdtm with frame a .

     WindowTime:
     repeat:
        update wdtm with frame a .
        do i = 1 to 7:
	   if not IsCorrectTimeEntries(wdtm[i]) then do:
              message "Incorrect time format(" + wdtm[i] + "), please try HH:MM format, 24 hours base!" view-as alert-box error .
              undo, next WindowTime .
	   end .
	   xkt_mstr.xkt_time[i] = wdtm[i] .
	end .
	leave WindowTime .
     end .

     repeat:
        update nextDate nextTime with frame a .
	if IsCorrectTime(nextTime) then do:
	   find first xkgp_mstr exclusive-lock 
	   where xkgp_group = grp 
	   no-error .

	   if not available(xkgp_mstr) then do:
	      message "Kanban item group record has been locked by other user, please retry!" view-as alert-box error .
	      next .
	   end .
	   assign xkgp_next_date = nextDate
	          xkgp_next_time = (integer(entry(1,nextTime,":")) * 60 + integer(entry(2,nextTime,":"))) * 60 .
           leave .
	end .
	else do:
	   message "Incorrect time format, please try HH:MM format, 24 hours base!" view-as alert-box error .
	   next .
	end .
     end .
  end .