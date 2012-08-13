TRIGGER PROCEDURE FOR ASSIGN OF xxqad_ctrl.xxqad_basic5.

if xxqad_basic5 = "1" then do:

/*Initialization*/
for each xxptp_det :  delete xxptp_det.    end.

/*ptp_det*/
for each ptp_det no-lock:
    find first xxptp2_det where xxptp2_part = ptp_part 
           and xxptp2_site = ptp_site no-error.
    if not avail xxptp2_det then do:
       create xxptp_det.
       assign xxptp_part  = ptp_part
              xxptp_site  = ptp_site
	      xxptp_bom_code = ptp_bom_code
	      xxptp_routing  = ptp_routing
	      xxptp_ord_mult = ptp_ord_mult
	      xxptp_phantom  = ptp_phantom
	      xxptp_flg      = "A".    /*Flag: Add*/

       create xxptp2_det.
       assign xxptp2_part  = ptp_part
              xxptp2_site  = ptp_site
	      xxptp2_bom_code = ptp_bom_code
	      xxptp2_routing  = ptp_routing
	      xxptp2_ord_mult = ptp_ord_mult
	      xxptp2_phantom  = ptp_phantom.
    end.  /*if not avail xxptp2_det*/
    else do:
         if xxptp2_bom_code <> ptp_bom_code or
	    xxptp2_routing  <> ptp_routing  or
	    xxptp2_ord_mult <> ptp_ord_mult or
	    xxptp2_phantom  <> ptp_phantom then do:

            create xxptp_det.
            assign xxptp_part  = ptp_part
                   xxptp_site  = ptp_site
	           xxptp_bom_code = ptp_bom_code
	           xxptp_routing  = ptp_routing
	           xxptp_ord_mult = ptp_ord_mult
	           xxptp_phantom  = ptp_phantom
	           xxptp_flg      = "C".    /*Flag: Change*/

            assign xxptp2_bom_code = ptp_bom_code
	           xxptp2_routing  = ptp_routing
	           xxptp2_ord_mult = ptp_ord_mult
	           xxptp2_phantom  = ptp_phantom.
         end.  /*Change*/
    end.  /* avail xxptp2_det*/
end.  /*for each ptp_det */


find first xxptp2_det no-error.
repeat:
    do transaction:
    if not avail xxptp2_det then leave.
    find first ptp_det where ptp_part = xxptp2_part 
           and ptp_site = xxptp2_site no-lock no-error.
    if not avail ptp_det then do:
       create xxptp_det.
       create xxptp_det.
       assign xxptp_part  = xxptp2_part
              xxptp_site  = xxptp2_site
	      xxptp_bom_code = xxptp2_bom_code
	      xxptp_routing  = xxptp2_routing
	      xxptp_ord_mult = xxptp2_ord_mult
	      xxptp_phantom  = xxptp2_phantom
	      xxptp_flg = "D".    /*Flag: Delete*/

       delete xxptp2_det.  /*Delete*/
    end.  /*if not avail ptp_mstr*/

    find next xxptp2_det no-error.
end.  /*for each ptp_mstr */
end.  /*transaction*/

xxqad_basic5 = "2".
end.
