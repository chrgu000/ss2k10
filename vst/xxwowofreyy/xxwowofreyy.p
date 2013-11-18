/* wowofre.p - invoke program wowoisrcxx.p BACKFLUSH OPERATION FOR DAILY PRODUCTION   */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.
   reference program wowoisrcxx.p woworcaxx.p xxictrans.i woisrc02xx.p
   04/20/04        modify by He Shi Yu                                      */
/* A-flag ***20100729 not allow issue over the wod req qty*/

/*ss - 20121225.1 by Steven */
/*ss - 131023.1 by zy  婓給喳奀祥埰勍党蜊踱弇     1887252                   */

{mfdtitle.i "131023.1"}

define new shared variable v_time as integer format "9" init 1.
define new shared variable v_effdate like glt_effdate.
define new shared variable v_timestr as char format "x(11)".

     form
        v_time      colon 18 label "班別" /*"Time range"*/
        "(1--白班,2--夜班)" /*"(1- 7:30am--3:00pm, 2- 3:00pm--11:00pm, 3- 11:00pm--7:30am"*/ colon 18
 /*       " 4- 7:00am--8:00pm, 5- 8:00pm--5:00am)" colon 18 skip */
        v_effdate   colon 18  label "生效日期"
     with frame a1 side-labels width 80 attr-space.

     /* SET EXTERNAL LABELS */
     setFrameLabels(frame a1:handle).
     {wbrp01.i}

     repeat on error undo, retry with frame a1:
         v_effdate = today.
         if c-application-mode <> 'web' then
            update v_time v_effdate with frame a1.

         {wbrp06.i &command = update &fields = " v_time v_effdate "}

         if v_time > 2 or v_time < 1 then do:
            {mfmsg03.i 2685 3 """班別必須是 1 或 2""" """" """"}
            undo,retry.
         end.
         case v_time:
            when  1 then v_timestr = "白班"  /*"7:30am-3pm"*/ .
            when  2 then v_timestr = "夜班" /* "3pm-11pm"*/ .
/*            when  3 then v_timestr = "11pm-7:30am".
            when  4 then v_timestr = "7am-8pm".
            when  5 then v_timestr = "8pm-5am".*/
         end case.
         if v_effdate = ? then v_effdate = today.
         leave.
     end.
         hide frame a1.
         {mfrpexit.i}
         /*{gprun.i ""wowoisrcyyy.p""} **ss-20121225.1*/ /*A-flag*/
         {gprun.i ""xxwowoisrcyyy.p""} /*ss-20121225.1*/