

{mfdeclre.i}

/* INPUT PARAMETERS */
define input parameter v_nbr like so_nbr.
define input parameter v_line  like sod_line.

/* INPUT-OUTPUT PARAMETERS */
define INPUT-OUTPUT parameter open_qty like sod_qty_ord.

define variable aa like in_qty_oh.
define variable bb like pt_ord_mult.

define variable avl_qoh      like in_qty_oh  no-undo.
define variable avl_qty_ord  like in_qty_ord no-undo.
define variable avl_alloc    like in_qty_oh  no-undo.

 avl_qoh    = 0.
 avl_qty_ord  = 0.
 avl_alloc   = 0.

aa = 0. 
bb = 0.

find so_mstr
   where so_domain = global_domain
   and   so_nbr    = v_nbr
no-lock.


find sod_det
   where sod_domain = global_domain
   and   sod_nbr    = v_nbr
   and   sod_line   = v_line
no-lock.

find first ptp_det where ptp_det.ptp_domain = global_domain and   ptp_part = sod_part and ptp_site = sod_site no-lock no-error.
	if available ptp_det and ptp_ord_mult > 0 then do:
		bb = ptp_ord_mult.
	end.
	else do:
		find first pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = sod_part no-lock no-error.
			if available pt_mstr and pt_ord_mult > 0 then do:
				bb = pt_ord_mult.
			end.
	end.

find first in_mstr where in_mstr.in_domain = global_domain and in_part = sod_part and in_site = sod_site  no-lock no-error.

if bb > 0 then do:
	aa = open_qty mod bb.
	if aa > 0  then do:
	   open_qty = open_qty - aa .
	end.
	for each lad_det where lad_det.lad_domain = global_domain
					 and  lad_part = sod_part
			 and  lad_site = sod_site
			 and lad_loc = in_loc no-lock:
		avl_qoh = avl_qoh + lad_qty_pick.
	end.
	  avl_alloc = in_qty_oh - avl_qoh.
	if open_qty > 0 and avl_alloc < open_qty then do:
	   aa = avl_alloc mod bb.
	   if aa > 0 then do :
	   open_qty = avl_alloc - aa .
	   end.
	end.
	if open_qty < 0 then open_qty = 0.
end.


