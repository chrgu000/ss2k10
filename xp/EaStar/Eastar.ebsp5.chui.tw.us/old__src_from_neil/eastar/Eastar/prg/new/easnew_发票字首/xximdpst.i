        message "Invoice posting...".
        FOR EACH xcim_sod_det:
        	delete xcim_sod_det.
        END.
        inv_post = no.
        for each shad_det  where shad_sanbr >= sanbr and shad_sanbr <= sanbr1 and shad_line > 0 
        and shad_inv_qty <> 0 and shad_ii_nbr <> ""
        EXCLUSIVE-LOCK break by shad_ii_nbr by shad_part:
            inv_post = yes.
            to_inv_qty = shad_inv_qty.
            shad_qty_inv = shad_qty_inv + shad_inv_qty.
            shad_inv_qty = 0.
            if last-of(shad_ii_nbr) then do:
                FOR EACH sod_det where sod_nbr = shad_so_nbr and sod_part <> shad_part exclusive-lock:
                	assign sod__chr10 = "east"
                           sod__dec02 = sod_qty_inv
                           sod__dec01 = sod_qty_ship
                           sod_qty_inv = 0
                           sod_qty_ship = 0.

                END.
                find so_mstr where so_nbr = shad_so_nbr exclusive-lock no-error.
                if available so_mstr then do:
                assign so_inv_nbr = shad_ii_nbr so_invoiced = yes so_to_inv = no.
                create xcim_sod_det.
                assign xcim_sod_nbr		    = so_nbr
                       /*xcim_sod_inv_date    = today*/
                       xcim_sod_inv_date    = if shad_dte01 = ? then today else shad_dte01  /*add-by-davild20051128*/
                       /*xcim_sod_line	    = 
                       xcim_sod_qty_ship    = min(to_inv_qty,sod_qty_inv)*/
/*                       xcim_sod_site	    = "EAST"
                       xcim_sod_loc		    
                       xcim_sod_lot		
                       xcim_sod_ref		
                       xcim_sod_rmks	*/
                       xcim_sod_inv_nbr	    = shad_ii_nbr
/*                       xcim_sod_qty_ship_old
                       xcim_sod_qty_inv_old 
                       xcim_ship_successful 
                       xcim_post_successful */
                        .

                        {gprun.i ""xxciivps.p"" "(output vchr_status)"}
                        IF vchr_status = 1 THEN DO:
                            MESSAGE "Invoice can not be posted." VIEW-AS ALERT-BOX.
                            UNDO mainloop,LEAVE mainloop.  
                        END.
                        FOR EACH xcim_sod_det:
                            delete xcim_sod_det.
                        END.
                end.
                FOR EACH sod_det where sod_nbr = shad_so_nbr and sod_part <> shad_part and sod__chr10 = "east" exclusive-lock:
                	assign sod__chr10 = ""
                           sod_qty_inv = sod__dec02 
                           sod_qty_ship = sod__dec01
                           sod__dec01 = 0.
                           sod__dec02 = 0.
                END.

            end.
            shad_qty_inv = shad_qty_inv + shad_inv_qty.
            shad_inv_qty = 0.
            shad_ii_nbr = "".
        end.
        if not inv_post then message "No invoice to post".
        else message "Invoice posted".
