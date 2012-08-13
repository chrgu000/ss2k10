TRIGGER PROCEDURE FOR ASSIGN OF xxqad_ctrl.xxqad_basic3.

if xxqad_basic3 = "1" then do:


/*Initialization*/
for each xxin_mstr :  delete xxin_mstr.    end.

/*in_mstr*/
for each in_mstr no-lock:
    find first xxin2_mstr where xxin2_part = in_part
           and xxin2_site = in_site no-error.
    if not avail xxin2_mstr then do:
       create xxin_mstr.
       assign xxin_part   = in_part
              xxin_site   = in_site
	      xxin_user1  = in_user1
	      xxin_qadc01 = in__qadc01
	      xxin_flg    = "A".    /*Flag: Add*/

       create xxin2_mstr.
       assign xxin2_part   = in_part
              xxin2_site   = in_site
	      xxin2_user1  = in_user1
	      xxin2_qadc01 = in__qadc01.
    end.  /*if not avail xxin2_mstr*/
    else do:
         if xxin2_user1  <> in_user1 or
	    xxin2_qadc01 <> in__qadc01 then do:

            create xxin_mstr.
	    assign xxin_part = in_part
                   xxin_site  = in_site
	           xxin_user1 = in_user1
	           xxin_qadc01 = in__qadc01
	           xxin_flg   = "C".    /*Flag: Change*/

	    assign xxin2_user1  = in_user1
	           xxin2_qadc01 = in__qadc01.

         end.  /*Change*/
    end.  /* avail xxin2_mstr*/
end.  /*for each in_mstr */


find first xxin2_mstr no-error.
repeat:
    do transaction:
    if not avail xxin2_mstr then leave.
    find first in_mstr where in_part = xxin2_part no-lock no-error.
    if not avail in_mstr then do:
       create xxin_mstr.
       assign xxin_part   = xxin2_part
              xxin_site   = xxin2_site
	      xxin_user1  = xxin2_user1
	      xxin_qadc01 = xxin2_qadc01
	      xxin_flg    = "D".    /*Flag: Delete*/

       delete xxin2_mstr.  /*Delete*/
    end.  /*if not avail in_mstr*/

    find next xxin2_mstr no-error.
    end.  /*transaction*/
end.  /*for each in_mstr */


xxqad_basic3 = "2".
end.
