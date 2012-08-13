TRIGGER PROCEDURE FOR ASSIGN OF xxqad_ctrl.xxqad_basic9.

if xxqad_basic9 = "1" then do:

/*Initialization*/
for each xxpp_mstr :  delete xxpp_mstr.    end.

for each xxptmp_mstr no-lock:
    
    find first xxpp2_mstr where xxpp2_par = xxptmp_par
           and xxpp2_comp = xxptmp_comp and xxpp2_site = xxptmp_site no-error.
    if not avail xxpp2_mstr then do:
       create xxpp_mstr.
       assign xxpp_par   = xxptmp_par
              xxpp_comp  = xxptmp_comp
	      xxpp_site  = xxptmp_site
	      xxpp_cust  = xxptmp_cust
	      xxpp_vend  = xxptmp_vend
	      xxpp_qty_per = xxptmp_qty_per
	      xxpp_rmks    = xxptmp_rmks
	      xxpp_flg     = "A".    /*Flag: Add*/

       create xxpp2_mstr.
       assign xxpp2_par   = xxptmp_par
              xxpp2_comp  = xxptmp_comp
	      xxpp2_site  = xxptmp_site
	      xxpp2_cust  = xxptmp_cust
	      xxpp2_vend  = xxptmp_vend
	      xxpp2_qty_per = xxptmp_qty_per
	      xxpp2_rmks    = xxptmp_rmks.
    end.  /*if not avail xxwc2_mstr*/
    else do:
         if xxpp2_cust    <> xxptmp_cust or
            xxpp2_vend    <> xxptmp_vend or
	    xxpp2_qty_per <> xxptmp_qty_per or
	    xxpp2_rmks    <> xxptmp_rmks then do:

            create xxpp_mstr.
            assign xxpp_par   = xxptmp_par
                   xxpp_comp  = xxptmp_comp
	           xxpp_site  = xxptmp_site
	           xxpp_cust  = xxptmp_cust
	           xxpp_vend  = xxptmp_vend
	           xxpp_qty_per = xxptmp_qty_per
	           xxpp_rmks    = xxptmp_rmks
	           xxpp_flg     = "C".    /*Flag: Change*/

	    assign xxpp2_cust  = xxptmp_cust
	           xxpp2_vend  = xxptmp_vend
	           xxpp2_qty_per = xxptmp_qty_per
	           xxpp2_rmks    = xxptmp_rmks.
         end.  /*Change*/
    end.  /* avail xxpp2_mstr*/
end.  /*for each xxptmp_mstr */


find first xxpp2_mstr no-error.
repeat:
    do transaction:
    if not avail xxpp2_mstr then leave.

    find first xxptmp_mstr where xxptmp_par = xxpp2_par
           and xxptmp_comp = xxpp2_comp
	   and xxptmp_site = xxpp2_site no-lock no-error.
    if not avail xxptmp_mstr then do:
       create xxpp_mstr.
       assign xxpp_par   = xxpp2_par
              xxpp_comp  = xxpp2_comp
	      xxpp_site  = xxpp2_site
	      xxpp_cust  = xxpp2_cust
	      xxpp_vend  = xxpp2_vend
	      xxpp_qty_per = xxpp2_qty_per
	      xxpp_rmks    = xxpp2_rmks
	      xxpp_flg     = "D".    /*Flag: Delete*/

       delete xxpp2_mstr.  /*Delete*/
    end.  /*if not avail xxptmp_mstr*/

    find next xxpp2_mstr no-error.
end.  /*repeat*/
end.  /*transaction*/

xxqad_basic9 = "2".
end.
