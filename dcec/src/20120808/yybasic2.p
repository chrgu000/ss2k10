TRIGGER PROCEDURE FOR ASSIGN OF xxqad_ctrl.xxqad_basic2.

if xxqad_basic2 = "1" then do:


/*Initialization*/
for each xxbom_mstr:  delete xxbom_mstr.   end.

/*bom_mstr*/
for each bom_mstr no-lock:
    find first xxbom2_mstr where xxbom2_parent = bom_parent no-error.
    if not avail xxbom2_mstr then do:
       create xxbom_mstr.
       assign xxbom_parent = bom_parent
              xxbom_chr01  = bom__chr01
	      xxbom_flg    = "A".    /*Flag: Add*/

       create xxbom2_mstr.
       assign xxbom2_parent = bom_parent
	      xxbom2_chr01  = bom__chr01.
    end.  /*if not avail xxbom2_mstr*/
    else do:
         if xxbom2_chr01 <> bom__chr01 then do:

            create xxbom_mstr.
	    assign xxbom_parent = bom_parent
                   xxbom_chr01  = bom__chr01
	           xxbom_flg    = "C".    /*Flag: Change*/

            assign xxbom2_chr01 = bom__chr01.
         end.  /*Change*/
    end.  /* avail xxbom2_mstr*/
end.  /*for each bom_mstr */

find first xxbom2_mstr no-error.
repeat:
    do transaction:
    if not avail xxbom2_mstr then leave.
    find first bom_mstr where bom_parent = xxbom2_parent no-lock no-error.
    if not avail bom_mstr then do:
       create xxbom_mstr.
       assign xxbom_parent = xxbom2_parent
              xxbom_chr01  = xxbom2_chr01
	      xxbom_flg   = "D".    /*Flag: Delete*/

       delete xxbom2_mstr.  /*Delete*/
    end.  /*if not avail bom_mstr*/

    find next xxbom2_mstr no-error.
end.  /*repeat*/
end.  /*transaction*/

xxqad_basic2 = "2".
end. 
