/*----------------------------------------------------------
  File         xkgpwtrp.p
  Description  Kanban item group window time report
  Author       Yang Enping
  Created      2004-06-16
  History
       2004-6-16, Yang Enping
           1. Spec: 零件组及要货单规范V2.doc
  ---------------------------------------------------------*/


{mfdtitle.i "AO"}

define var grp like xkgp_group .
define var grp1 like xkgp_group .
define var dt as date .
define var dt1 as date .


FORM 
    space(1)
    grp label "看板零件组" colon 14
    grp1 label "到" colon 34
    dt label "开始时间" colon 14
    dt1 label "到" colon 34
    skip(2)
with frame a side-labels width 80 attr-space THREE-D /*GUI*/.

{wbrp01.i}

{xkutlib.i}

def var dispDt as date .
def var dispWeekDay as char .
def var dispRef as char format "x(12)".
def var dispTm as char format "x(60)".

form
   space(3)
   xkgp_group label "零件组"
   dispWeekDay no-label 
   dispDt label "日期"
   dispRef label "参考"
   dispTm label "窗口时间"
   with frame c down stream-io width 130.

define temp-table tts
  field tm as int
  index tm is primary tm .

def var i as int .
def var j as int .
def var k as int .
def var timeCount as int .
def var currentWeekDay as int .

repeat:
   if grp1 = hi_char then grp1 = "".
   if dt = low_date then dt = ? .
   if dt1 = hi_date then dt1 = ? .

   if c-application-mode <> 'web' then
      update grp grp1 dt dt1 with frame a.

   {wbrp06.i &command = update &fields = " grp grp1 dt dt1 " &frm = "a"}

   if (c-application-mode <> 'web') or
   (c-application-mode = 'web' and
   (c-web-request begins 'data')) then do:
           /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {mfquoter.i grp   }
      {mfquoter.i grp1  }
      {mfquoter.i dt   }
      {mfquoter.i dt1  }

      if grp1 = "" then grp1 = hi_char.
      if dt = ? then dt = today .
      if dt1 = ? then dt1 = today + 7 .
   end.
            /* SELECT PRINTER */
   {mfselbpr.i "printer" 132}

   {mfphead.i} 

   for each xkgp_mstr no-lock
   where xkgp_group >= grp
   and xkgp_group <= grp1,

   each xkt_mstr no-lock 
   where xkt_group = xkgp_group
   
   break by xkt_group :
      
      do i = 1 to dt1 - dt + 1 with frame c:
         dispDt = dt + i - 1 .

	 currentWeekDay = weekday(dispDt) - 1 .
	 if currentWeekDay = 0 then currentWeekDay = 7 .

         dispWeekDay = GetWeekDayName(currentWeekDay) .

	 find first cal_det no-lock
	 where cal_site = ""
	 and cal_wkctr = xkgp_wkctr
	 and cal_mch = ""
	 and cal_ref = ""
	 and cal_start <= dispDt
	 and cal_end >= dispDt
	 no-error .

	 if not available(cal_det) then
	    dispRef = "" .
	 else
	    dispRef = "  SHUTDOWN" .

         display xkgp_group when i = 1
	         dispWeekDay dispDt with frame c .


         for each tts:
	    delete tts .
         end .

         timeCount = 0 .
	 do j = 1 to num-entries(xkt_time[currentWeekDay],","):
	    if not IsCorrectTime(entry(j,xkt_time[currentWeekDay],",")) then 
	       next .
            create tts .
	    assign tts.tm = (integer(entry(1,entry(j,xkt_time[currentWeekDay],","),":")) * 60
	                     + integer(entry(2,entry(j,xkt_time[currentWeekDay],","),":"))) * 60 .
            timeCount = timeCount + 1 .
         end .

	 find first tts no-error .

	 if not available(tts) then do with frame c:
	    down .
	    next .
         end .

         do j = 1 to timeCount by 8 with frame c:

            dispTm = "" .
	    do k = 1 to 8:
               if j + k - 1 > timeCount then
	          leave .
	       if not available(tts) then
	          leave .
	       if k = 1 then 
	          dispTm = string(tts.tm,"HH:MM") .
	       else
	          dispTm = dispTm + "," + string(tts.tm,"HH:MM") .
	       find next tts no-error .
	    end .

            display dispRef dispTm .
	    down .
	 end .

      end .

      down 2 with frame c .

      {mfrpexit.i}
   end.

           /* REPORT TRAILER  */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
