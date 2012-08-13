TRIGGER PROCEDURE FOR ASSIGN OF xxqad_ctrl.xxqad_basic4.

if xxqad_basic4 = "1" then do:

/*Initialization*/
for each xxopm_mstr:  delete xxopm_mstr.   end.

/*opm_mstr*/
for each opm_mstr no-lock:
    find first xxopm2_mstr where xxopm2_std_op = opm_std_op no-error.
    if not avail xxopm2_mstr then do:
       create xxopm_mstr.
       assign xxopm_std_op = opm_std_op
              xxopm_desc   = opm_desc
	      xxopm_wkctr  = opm_wkctr
	      xxopm_chr01  = opm__chr01
	      xxopm_flg    = "A".    /*Flag: Add*/

       create xxopm2_mstr.
       assign xxopm2_std_op = opm_std_op
              xxopm2_desc   = opm_desc
	      xxopm2_wkctr  = opm_wkctr
	      xxopm2_chr01  = opm__chr01.
    end.  /*if not avail xxopm2_mstr*/
    else do:
         if xxopm2_desc  <> opm_desc   or
	    xxopm2_wkctr <> opm_wkctr  or
	    xxopm2_chr01 <> opm__chr01 then do:

            create xxopm_mstr.
	    assign xxopm_std_op = opm_std_op
                   xxopm_desc   = opm_desc
	           xxopm_wkctr  = opm_wkctr
	           xxopm_chr01  = opm__chr01
	           xxopm_flg    = "C".    /*Flag: Change*/

            assign xxopm2_desc  = opm_desc
	           xxopm2_wkctr = opm_wkctr
	           xxopm2_chr01 = opm__chr01.
         end.  /*Change*/
    end.  /* avail xxopm2_mstr*/
end.  /*for each opm_mstr */


find first xxopm2_mstr no-error.
repeat:
    do transaction:
    if not avail xxopm2_mstr then leave.
    find first opm_mstr where opm_std_op = xxopm2_std_op no-lock no-error.
    if not avail opm_mstr then do:
       create xxopm_mstr.
       assign xxopm_std_op = xxopm2_std_op
              xxopm_desc   = xxopm2_desc
	      xxopm_wkctr  = xxopm2_wkctr
	      xxopm_chr01  = xxopm2_chr01
	      xxopm_flg    = "D".    /*Flag: Delete*/

       delete xxopm2_mstr.  /*Delete*/
    end.  /*if not avail opm_mstr*/
    
    find next xxopm2_mstr no-error.
end.  /*for each opm_mstr */
end.  /*transaction*/

xxqad_basic4 = "2".
end.
