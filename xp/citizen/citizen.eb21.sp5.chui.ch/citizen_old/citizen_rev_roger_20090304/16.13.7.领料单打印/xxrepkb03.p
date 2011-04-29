/* $Revision: 1.23 $   BY: Apple Tam          DATE: 02/27/06 ECO: *SS-MIN001* */

 {mfdeclre.i}
 {gplabel.i}




 {xxrevar03.i}
 define variable p-line as integer.
 p-line = 1.

     do transaction on error undo, retry:
        for each xxld_tmp where xxld_qty <> 0:
		
		/*find first pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = xxld_part no-lock no-error.*/
	   find first xic_det where xic_det.xic_domain = global_domain and xic_nbr = rcvno and xic_line = xxld_line2 exclusive-lock no-error.
	   if not available xic_det then do:
	       create xic_det.
	       assign
	           xic_domain     = global_domain
			   xic_nbr        = rcvno
			   xic_type       = p-type
			   xic_part       = xxld_part
			   xic_ln_line    = prodline
			   xic_loc_from   = xxld_loc 
			   xic_loc_to     = prodline /*pt_loc when available pt_mstr*/
			   xic_qty_from   = xxld_qty
			   xic_um         = xxld_um
			   xic_print      = no
			   xic_flag       = no
			   xic_lot_from   = xxld_lot
			   xic_lot_to     = xxld_lot
			   xic_ref_from   = xxld_ref 
			   xic_ref_to     = xxld_ref 
			   xic_remark     = ""
			   xic_line       = xxld_line2
			   xic_date       = today
			   xic_user1      = global_userid
			   xic_site_from  = xxld_site
			   xic_site_to    = site.
           
			if recid(xic_det) = ? then .
			release xic_det.
			p-line = p-line + 1.
	   end.	    
           else do:
	       assign
		   xic_loc_from   = xxld_loc 
		   /*xic_loc_to     = pt_loc when available pt_mstr*/
		   xic_qty_from   = xxld_qty
		   xic_lot_from   = xxld_lot
		   xic_lot_to     = xxld_lot
		   xic_ref_from   = xxld_ref 
		   xic_ref_to     = xxld_ref 
		   xic_date       = today
		   xic_user1      = global_userid
		   xic_site_from  = xxld_site
		   xic_site_to    = site.
	   end.	    
	end.
     end. /*do transaction*/  

