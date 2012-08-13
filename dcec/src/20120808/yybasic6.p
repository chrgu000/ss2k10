TRIGGER PROCEDURE FOR ASSIGN OF xxqad_ctrl.xxqad_basic6.

if xxqad_basic6 = "1" then do:

/*Initialization*/
for each xxpt_mstr :  delete xxpt_mstr.    end.

/*pt_mstr*/
for each pt_mstr no-lock:
    find first xxpt2_mstr where xxpt2_part = pt_part no-error.
    if not avail xxpt2_mstr then do:
       create xxpt_mstr.
       assign xxpt_part  = pt_part
              xxpt_desc1 = pt_desc1
	      xxpt_desc2 = pt_desc2
	      xxpt_group = pt_group
	      xxpt_part_type = pt_part_type
	      xxpt_status  = pt_status
	      xxpt_phantom = pt_phantom
	      xxpt_article = pt_article
	      xxpt_prod_line = pt_prod_line
	      xxpt_flg   = "A".    /*Flag: Add*/

       create xxpt2_mstr.
       assign xxpt2_part  = pt_part
              xxpt2_desc1 = pt_desc1
	      xxpt2_desc2 = pt_desc2
	      xxpt2_group = pt_group
	      xxpt2_part_type = pt_part_type
	      xxpt2_status  = pt_status
	      xxpt2_phantom = pt_phantom
	      xxpt2_article = pt_article
	      xxpt2_prod_line = pt_prod_line.
    end.  /*if not avail xxpt2_mstr*/
    else do:
         if xxpt2_desc1 <> pt_desc1 or
	    xxpt2_desc2 <> pt_desc2 or
	    xxpt2_group <> pt_group or
	    xxpt2_part_type <> pt_part_type or
	    xxpt2_status  <> pt_status or
	    xxpt2_phantom <> pt_phantom or
	    xxpt2_article <> pt_article or
	    xxpt2_prod_line <> pt_prod_line then do:

            create xxpt_mstr.
	    assign xxpt_part  = pt_part
              xxpt_desc1 = pt_desc1
	      xxpt_desc2 = pt_desc2
	      xxpt_group = pt_group
	      xxpt_part_type = pt_part_type
	      xxpt_status  = pt_status
	      xxpt_phantom = pt_phantom
	      xxpt_article = pt_article
	      xxpt_prod_line = pt_prod_line
	      xxpt_flg   = "C".    /*Flag: Change*/

            assign xxpt2_desc1 = pt_desc1
	      xxpt2_desc2 = pt_desc2
	      xxpt2_group = pt_group
	      xxpt2_part_type = pt_part_type
	      xxpt2_status  = pt_status
	      xxpt2_phantom = pt_phantom
	      xxpt2_article = pt_article
	      xxpt2_prod_line = pt_prod_line.

         end.  /*Change*/
    end.  /* avail xxpt2_mstr*/
end.  /*for each pt_mstr */


find first xxpt2_mstr no-error.
repeat:
    do transaction:
    if not avail xxpt2_mstr then leave.
    find first pt_mstr where pt_part = xxpt2_part no-lock no-error.
    if not avail pt_mstr then do:
       create xxpt_mstr.
       assign xxpt_part = xxpt2_part
	      xxpt_flg = "D".    /*Flag: Delete*/

       delete xxpt2_mstr.  /*Delete*/
    end.  /*if not avail pt_mstr*/

    find next xxpt2_mstr no-error.
end.  /*for each pt_mstr */
end.  /*transaction*/

xxqad_basic6 = "2".
end.
