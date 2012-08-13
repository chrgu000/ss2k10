TRIGGER PROCEDURE FOR ASSIGN OF xxqad_ctrl.xxqad_basic7.

if xxqad_basic7 = "1" then do:

/*Initialization*/
for each xxrps_mstr:  delete xxrps_mstr.   end.

/*rps_mstr*/
for each rps_mstr no-lock:
    find first xxrps2_mstr where xxrps2_part = rps_part
           and xxrps2_site = rps_site and xxrps2_line = rps_line
	   and xxrps2_due_date = rps_due_date no-error.
    if not avail xxrps2_mstr then do:
       create xxrps_mstr.
       assign xxrps_part = rps_part
              xxrps_site = rps_site
	      xxrps_line = rps_line
	      xxrps_due_date = rps_due_date
	      xxrps_rel_date = rps_rel_date
	      xxrps_qty_req  = rps_qty_req
	      xxrps_qty_comp = rps_qty_comp
	      xxrps_flg      = "A".    /*Flag: Add*/

       create xxrps2_mstr.
       assign xxrps2_part = rps_part
              xxrps2_site = rps_site
	      xxrps2_line = rps_line
	      xxrps2_due_date = rps_due_date
	      xxrps2_rel_date = rps_rel_date
	      xxrps2_qty_req  = rps_qty_req
	      xxrps2_qty_comp = rps_qty_comp.
    end.  /*if not avail xxrps2_mstr*/
    else do:
         if xxrps2_rel_date <> rps_rel_date or
            xxrps2_qty_req  <> rps_qty_req  or
	    xxrps2_qty_comp <> rps_qty_comp then do:

            create xxrps_mstr.
            assign xxrps_part = rps_part
                   xxrps_site = rps_site
	           xxrps_line = rps_line
	           xxrps_due_date = rps_due_date
	           xxrps_rel_date = rps_rel_date
	           xxrps_qty_req  = rps_qty_req
	           xxrps_qty_comp = rps_qty_comp
	           xxrps_flg    = "C".    /*Flag: Change*/

            assign xxrps2_rel_date = rps_rel_date
	           xxrps2_qty_req  = rps_qty_req
	           xxrps2_qty_comp = rps_qty_comp.

         end.  /*Change*/
    end.  /* avail xxrps2_mstr*/
end.  /*for each rps_mstr */


find first xxrps2_mstr no-error.
repeat:
    do transaction:
    if not avail xxrps2_mstr then leave.
    find first rps_mstr where rps_part = xxrps2_part
           and rps_site = xxrps2_site and rps_line = xxrps2_line
	   and rps_due_date = xxrps2_due_date no-lock no-error.
    if not avail rps_mstr then do:
       create xxrps_mstr.
       assign xxrps_part = xxrps2_part
              xxrps_site = xxrps2_site
	      xxrps_line = xxrps2_line
	      xxrps_due_date = xxrps2_due_date
	      xxrps_rel_date = xxrps2_rel_date
	      xxrps_flg      = "D".    /*Flag: Delete*/

       delete xxrps2_mstr.  /*Delete*/
    end.  /*if not avail rps_mstr*/

    find next xxrps2_mstr no-error.
end.  /*repeat*/
end.  /*transaction*/

xxqad_basic7 = "2".
end.
