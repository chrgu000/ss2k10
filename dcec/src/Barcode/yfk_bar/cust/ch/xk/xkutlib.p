/*----------------------------------------------
  File         xkutlib.p
  Description  Utility library 
  Author       Yang Enping
  Create       2004-06-17
  Modified     by XiangWH 2004-10-25 modify the procedure
	       calculatePlusDateTime
  Modified     by XiangWH 2005-03-10 modify the procedure
	      getItemPackQty,change packQty "like" from pt_ord_mult to 
          knbism_pack_qty xwh0310
  ---------------------------------------------*/
  {kbconst.i}
  {xkutlib.i}

  procedure calculatePlusDateTime:
     define input-output parameter dt as date.
     define input-output parameter tm as int .
     define input parameter addTime as int .

     tm = tm + addTime .

/*xwh1025---     if tm >= 24 * 60 * 60 then do:*/
     do while tm >= 24 * 60 * 60:
/*---xwh1025 */
        tm = tm - 24 * 60 * 60 .
	dt = dt + 1 .
     end .

  end .

  procedure calculateMinusDateTime:
     define input-output parameter dt as date.
     define input-output parameter tm as int .
     define input parameter minusSecond as int .
     
     define var smallSecond as int .
     def var minusDays as int .

     smallSecond = minusSecond mod (24 * 60 * 60) .

     minusDays = (minusSecond - smallSecond) / (24 * 60 * 60) .

     dt = dt - minusDays .

     if smallSecond <= tm then
        tm = tm - smallSecond .
     else do:
        tm = 24 * 60 * 60 - (smallSecond - tm) .
	dt = dt - 1 .
     end .
  end .

  procedure getItemPackQty:
/*---------------------------------------------------------------------------
   Purpose:     Get pack quantity of item
   Exceptions:  None
   Notes:       
   History:
       2004-06-17, Yang Enping
           1.  For kanban item, input kanban ID, fetch the pack quantity of
	       kanban loop supermarket master.
	   2.  For no-kanban control item, input item ID, fetch the multiply
	       quantity of item master.
	   3.  If failed to got the pack quantity, the return value is -1.
   Inputs:
           isKanbanItem - If this is a kanban item calculate
	   kanbanID     - Kanban card ID, required for kanban item calculating
	   itemID       - Item ID, required for no-kanban control item caculating.
   Outputs:
           packQty      - Pack quantity, -1 means failed to got.
---------------------------------------------------------------------------*/

     define input parameter isKanbanItem as logical .
     define input parameter kanbanID like knbd_id .
     define input parameter itemID like pt_part .
     define output parameter packQty like knbism_pack_qty .

     packQty = -1 .
     if isKanbanItem then do:
        
        for first knbd_det no-lock
	where knbd_id = kanbanID,

	first knbl_det no-lock
	where knbl_keyid = knbd_knbl_keyid 
        and knbl_card_type = {&KB-CARDTYPE-REPLENISHMENT},

	first knb_mstr no-lock
	where knb_keyid = knbl_knb_keyid,

	first knbism_det no-lock
	where knbism_knbi_keyid = knb_knbi_keyid
	and knbism_knbsm_keyid = knb_knbsm_keyid:
           packQty = knbism_pack_qty .
	end .

     end .
     else do:
        find first pt_mstr no-lock
	where pt_part = itemID
	no-error .

	if available(pt_mstr) then
	   packQty = pt_ord_mult .
     end .

  end .

  procedure getWindowTime:
/*---------------------------------------------------------------------------
   Purpose:     Get window time
   Exceptions:  None
   Notes:       
   History:
       2004-06-17, Yang Enping
           1.  For kanban item, we calculate the window date and time base
	       the group definition.
	   2.  For no-kanban control item, the window date and time should
	       fetch from the specified PO.
	   3.  If failed to got the window time, the output date is value ?.
   Inputs:
           isKanbanItem - If this is a kanban item calculate
	   groupID      - Kanban item group ID, required for kanban item .
	   isUrgency    - If calculate the urgent window time, required for
	                  kanban item.
	   ponbr        - PO number, required for no-kanban item.
   Outputs:
           windowDate   - Window date, ? means failed to got.
	   windowTime   - Window time.
---------------------------------------------------------------------------*/

     define input parameter isKanbanItem as logical .
     define input parameter groupID like xkgp_group .
     define input parameter isUrgency as logical .
     define input parameter ponbr like po_nbr .
     define output parameter windowDate as date .
     define output parameter windowTime as int .

     windowDate = ? .
     if isKanbanItem then do:
        find first xkgp_mstr no-lock
	where xkgp_group = groupID
	no-error .

	if available(xkgp_mstr) then do:
           windowDate = today .
	   windowTime = time .

	   run calculatePlusDateTime(input-output windowDate,
	                             input-output windowTime,
				     (if isUrgency then xkgp_urg_time
				      else xkgp_lead_time
				     ) * 60 * 60
                                    ) .

	end .

     end .
     else do:
        find first po_mstr no-lock
	where po_nbr = ponbr no-error .

	if available(po_mstr) then do:
	   if isCorrectTime(po_contact) then 
	      assign windowDate = po_ord_date 
	             windowTime = (integer(entry(1,po_contact,":")) * 60 + integer(entry(2,po_contact,":"))) * 60 .
        end .
      
     end .

  end .


  procedure createPLUrgentFlag:
     define input parameter plnbr as char .

     for each usrw_wkfl where usrw_key1 = "KANBAN" and
         usrw_key2 = plnbr exclusive-lock:
        delete usrw_wkfl.
     end.
     create usrw_wkfl .
     assign usrw_key1 = "KANBAN"
            usrw_key2 = plnbr .

  end procedure.


  
