/*-----------------------------------------------------------------------
  File         xkwobk01.p
  Description  Sub procedure of work order backflush component consume
  Author       Yang Enping
  Created      2004-04-20
  Parameters
     Input

     Output


------------------------------------------------------------------------*/

{kbconst.i}

/*--------------------------------------------------------------
  Main Procedure
  --------------------------------------------------------------*/


define temp-table txwosd
   field ln as int
   field recordID as recid
   field qty like xwosd_qty
   field qtyToConsume like xwosd_qty
   index ln ln descending.

def var nextln as int .
def var to_consume_qty like xwosd_qty .
def var availableKanbanQty like xwosd_qty .
def var reduceQty like xwosd_qty .

define buffer processXwosd for xwosd_det .

/*xwh060404*/
DEFINE BUFFER bf_knbddet FOR knbd_det.


for each xwosd_det no-lock
use-index xwosd_dttm
where xwosd_used
and xwosd_qty - xwosd_qty_consumed <> 0
break by xwosd_site 
by xwosd_loc
BY xwosd_lnr
by xwosd_part:

   if first-of(xwosd_part) then do:
      for each txwosd:
         delete txwosd .
      end .
      assign nextln = 1 
             to_consume_qty = 0 
	     availableKanbanQty = 0
	     reduceQty = 0 .
   end .

   create txwosd .
   assign txwosd.ln = nextln
          txwosd.recordID = recid(xwosd_det)
	  txwosd.qty = xwosd_qty
	  txwosd.qtyToConsume = xwosd_qty - xwosd_qty_consumed .

   assign nextln = nextln + 1 
          to_consume_qty = to_consume_qty + txwosd.qtyToConsume .

   if last-of(xwosd_part) then do on error undo,next:
      if to_consume_qty = 0 then
         next .

      availableKanbanQty = 0 .

      for each knbi_mstr no-lock
      where knbi_part = xwosd_part,

      each knb_mstr no-lock
      where knb_knbi_keyid = knbi_keyid,

      each knbsm_mstr no-lock
      where knbsm_keyid = knb_knbsm_keyid
      and knbsm_inv_loc_type = {&KB-SUPERMARKETTYPE-INVENTORY}
      and knbsm_site = xwosd_site
      and knbsm_supermarket_id = xwosd_lnr
      and knbsm_inv_loc = xwosd_loc,

      each knbl_det no-lock
      where knbl_knb_keyid = knb_keyid
      and knbl_card_type = {&KB-CARDTYPE-REPLENISHMENT} ,

      each knbd_det NO-LOCK
      where knbd_knbl_keyid = knbl_keyid
      and knbd_active
      and (if to_consume_qty > 0 then knbd_status = {&KB-CARDSTATE-FULL}
                                 else (   knbd_status = {&KB-CARDSTATE-EMPTYACC} 
				       or (    knbd_status = {&KB-CARDSTATE-EMPTYAUTH} 
				           and knbd_print_dispatch
					   )
				      )
	  )
      break by knbd_status:
                                      
         if availableKanbanQty + knbd_kanban_quantity > absolute(to_consume_qty) then
            leave .
    
         availableKanbanQty = availableKanbanQty + knbd_kanban_quantity .
/*xwh060404 avoid to be locked and exited by another program*/
         REPEAT:
             FIND FIRST bf_knbddet where recid(bf_knbddet) = RECID(knbd_det) EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
             IF NOT AVAILABLE bf_knbddet THEN DO:
                 MESSAGE "knbd LOCK BY ANOTHER USER AT " + STRING(TIME,"HH:MM").
                 PAUSE 1.
                 NEXT.
             END.            
/*xwh060404*/                
             if to_consume_qty > 0 then do:
        	    assign bf_knbddet.knbd_status = {&KB-CARDSTATE-EMPTYACC} /*xwh060422*/   bf_knbddet.knbd_print_dispatch = YES.
                    if bf_knbddet.knbd_active and bf_knbddet.knbd_active_code = {&KB-CARD-ACTIVE-CODE-CLOSE} then 
                       assign bf_knbddet.knbd_active = no 
                         /*xwh060314*/   bf_knbddet.knbd_print_dispatch = YES.
                    
              end .
        	  else
        	  assign bf_knbddet.knbd_status = {&KB-CARDSTATE-FULL} .
/*xwh060404*/
              RELEASE bf_knbddet.
              LEAVE.
         END. /*repeat:*/

        end . /*for each knbi_mstr*/

      reduceQty = absolute(to_consume_qty) - availableKanbanQty .

      if to_consume_qty < 0 then
         reduceQty = 0 - reduceQty .

      for each txwosd use-index ln:
	 if reduceQty = 0 then 
	    leave .

         if (txwosd.qtyToConsume > 0 and reduceQty < 0)
	 or (txwosd.qtyToConsume < 0 and reduceQty > 0)
	 then 
	    next .
	 
         if absolute(txwosd.qtyToConsume) <= absolute(reduceQty) then do:
	    reduceQty = reduceQty - txwosd.qtyToConsume .
	    delete txwosd .
	 end .
	 else do:
	    txwosd.qtyToConsume = txwosd.qtyToConsume - reduceQty .
	    reduceQty = 0 .
	    leave .
         end .
      end .

      for each txwosd use-index ln:
/*xwh060404 add repeat to avoid lock*/
        REPEAT:
             find first processXwosd exclusive-lock
        	 where recid(processXwosd) = txwosd.recordID
        	 NO-WAIT no-error .
             IF NOT AVAILABLE processXwosd THEN DO:
                 MESSAGE "xwosd LOCK BY ANOTHER USER AT " + STRING(TIME,"HH:MM").
                 PAUSE 1.
                 NEXT.
             END.
             assign processXwosd.xwosd_qty_consumed = processXwosd.xwosd_qty_consumed + txwosd.qtyToConsume .
             RELEASE processXwosd.
             LEAVE.
        END. /*repeat:*/
      end .
      
   end . /* last of xwosd_part */

end .


   
