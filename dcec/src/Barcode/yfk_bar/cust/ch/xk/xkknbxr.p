/*--------------------------------------------------------------------
  File         xkknbxr.p
  Description  Customization Kanban transaction logic
  Author       Yang Enping
  Created      2004-04-21
  History
     2004-06-13, Yang Enping, 0001
         1. Spec: 零件组及要货单规范V2.doc
         2. Change authorization logic.
	 3. Add procedure "GetGroupNextPLTime" to caculate next P.L.
	    release time of kanban item group.

 --------------------------------------------------------------------*/

 {mfdeclre.i}
 {kbconst.i}

{pxmaint.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* Define Handles for the ROP programs */
{pxphdef.i gpcontxr}
{pxphdef.i gplngxr}
{pxphdef.i kbknbdxr}
{pxphdef.i kbknbxr}
{pxphdef.i kbtranxr}
{pxphdef.i kbknpxr}
{pxphdef.i kbshopxr}
{pxphdef.i xkknbxr}
{pxphdef.i xkutlib}

{xkutlib.i}

   define temp-table tts
     field wd as int
     field tm as int
     field dt as date
     index wdtm is primary dt tm .


 PROCEDURE authorizeAccumulatorCards:
/*---------------------------------------------------------------------------
   Purpose:     Updating the state of the Kanban Card and associated logic.
   Exceptions:  None
   Notes:       This work bases eB2 SP4, function authorizeAccumulatorCards of 
                kbknbxr.p
   History:
       2004-06-13, Yang Enping
           1.  Authorizate kanban only bases order quantity, accumulator
	       type of the loop won't be considerated.
   Inputs:
                Buffer of knbl_det
   Outputs:
---------------------------------------------------------------------------*/
   define  parameter buffer knbl_det for knbl_det.

   define            buffer knb_mstr for knb_mstr.
   define            buffer knbd_det for knbd_det.
   define variable accumQtyEmptyCards  as decimal.
   define variable dummyConsumingSite  as character.
   define variable dummyConsumingRef   as character.
   define variable kanbanTransNbr      as integer    no-undo.
   define variable l-rowid             as rowid      no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      for first knb_mstr where knb_keyid = knbl_det.knbl_knb_keyid no-lock. end.

      for each knbd_det where knbd_knbl_keyid = knbl_keyid and
                              knbd_active and
                              knbd_status = {&KB-CARDSTATE-EMPTYACC}
                          no-lock:
         accumQtyEmptyCards = accumQtyEmptyCards + knbd_kanban_quantity.
         if accumQtyEmptyCards >= knbl_order_qty then leave.
      end.

      if accumQtyEmptyCards >= knbl_order_qty then do:
         l-rowid = rowid(knbl_det).
         find knbl_det exclusive-lock where rowid(knbl_det) = l-rowid.

         for each knbd_det where knbd_knbl_keyid = knbl_keyid and
                                 knbd_active and
                                 knbd_status = {&KB-CARDSTATE-EMPTYACC}
                                 exclusive-lock:
               {pxrun.i &PROC ='updateKanbanCardWithEvent'
                        &PROGRAM='kbknbdxr.p'
                        &HANDLE=ph_kbknbdxr
                        &PARAM="(buffer knbd_det,
                                input {&KB-CARDEVENT-AUTHORIZE},
                                input today,
                                input dummyConsumingSite,
                                input dummyConsumingRef,
                                output kanbanTransNbr)"
               }
         end. /* for each ... */
      end . /* if accumQtyEmptyCards >= knbl_order_qty */
   end. /* do on error undo, return {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE. /* authorizeAccumulatorCards */



procedure GetGroupNextPLTime:
/*---------------------------------------------------------------------------
   Purpose:     Caculate next P.L. release date and time of kanban item group.
   Exceptions:  None
   Notes:       
                
   History:
     2004-7-5, Yang Enping, 0009
           Add check date and check time to avoid miss P.L.
	   because of slow system

   Inputs:
                grp: kanban item group
   Outputs:
		nextDate: next P.L. release date, if next P.L. release date 
		          not found, return null value.
		nextTime: next P.L. release time

---------------------------------------------------------------------------*/

   define input parameter grp like xkgp_group .
   /*0009*----*/
   define input parameter checkDate as date .
   define input parameter checkTime as int .
   /*----*0009*/
   define output parameter nextDate as date initial ? .
   define output parameter nextTime as int .

   for each tts:
      delete tts .
   end .

   def var i as int .
   def var j as int .
   def var timeStr as char .
   def var hh as int .
   def var mm as int .

   define buffer xkgpNextPLTime for xkgp_mstr .

   define variable currentWeekDay as int .
   define variable leadTime as int .

   define variable deliveryDate as date .
   define variable deliveryTime as int .

/*0009*   currentWeekDay = weekday(today) - 1 . */
/*0009*/   currentWeekDay = weekday(checkDate) - 1 .
   if currentWeekDay = 0 then
      currentWeekDay = 7 .

   find first xkt_mstr no-lock
   where xkt_group = grp 
   no-error .

   if not available(xkt_mstr) then 
      return .

   find first xkgpNextPLTime no-lock
   where xkgpNextPLTime.xkgp_group = grp .

   leadTime = xkgpNextPLTime.xkgp_lead_time * 60 * 60 .

   do i = 1 to 7:
      do j = 1 to num-entries(xkt_time[i],",") with down :
         timeStr = entry(j,xkt_time[i],",") .
         if not IsCorrectTime(timeStr) then 
	    next .
         hh = integer(entry(1,timeStr,":")) .
         mm = integer(entry(2,timeStr,":")) .
         create tts .
	 assign tts.wd = i 
/*0009*         tts.dt = today + i - currentWeekDay */
/*0009*/        tts.dt = checkDate + i - currentWeekDay
		tts.tm = (hh * 60 + mm) * 60 .

	 assign deliveryDate = tts.dt
	        deliveryTime = tts.tm .

         {pxrun.i &PROC ='calculateMinusDateTime'
                  &PROGRAM='xkutlib.p'
                  &HANDLE=ph_xkutlib
                  &PARAM="(
                              input-output deliveryDate,
                              input-output deliveryTime,
			      input leadTime
			  )"
         }


	 assign tts.dt = deliveryDate
	        tts.tm = deliveryTime .

      end .
   end .

   find first tts no-lock no-error .

   if not available(tts) then return .

   release tts .

   def var weekStep as int .
   weekStep = 0 .
   repeat:
      /*0009*----
      find first tts no-lock
      where (   (tts.dt + weekStep = today and tts.tm > time)
             or tts.dt + weekStep > today
	    )
      and not can-find(first cal_det no-lock
                       where cal_wkctr = xkgpNextPLTime.xkgp_wkctr 
                       and cal_mch = ""
                       and cal_ref = ""
		       and cal_start <= tts.dt + weekStep
		       and cal_end >= tts.dt + weekStep
		       )
      no-error .
      ----*0009*/
      /*0009*----*/
      find first tts no-lock
      where (   (tts.dt + weekStep = checkDate and tts.tm > checkTime)
             or tts.dt + weekStep > checkDate
	    )
      and not can-find(first cal_det no-lock
                       where cal_wkctr = xkgpNextPLTime.xkgp_wkctr 
                       and cal_mch = ""
                       and cal_ref = ""
		       and cal_start <= tts.dt + weekStep
		       and cal_end >= tts.dt + weekStep
		       )
      no-error .
      /*----*0009*/
      if available(tts) then do:
         assign nextDate = tts.dt + weekStep
	        nextTime = tts.tm .
         leave .
      end .
      else do:
         weekStep = weekStep + 7 .
         if weekStep >= 365 then
	    leave .
      end .
   end .


end procedure .