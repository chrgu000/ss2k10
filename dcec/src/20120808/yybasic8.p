TRIGGER PROCEDURE FOR ASSIGN OF xxqad_ctrl.xxqad_basic8.

if xxqad_basic8 = "1" then do:

/*Initialization*/
for each xxwc_mstr :  delete xxwc_mstr.    end.

/*wc_mstr*/
for each wc_mstr no-lock:
    find first xxwc2_mstr where xxwc2_wkctr = wc_wkctr
           and xxwc2_mch = wc_mch no-error.
    if not avail xxwc2_mstr then do:
       create xxwc_mstr.
       assign xxwc_wkctr = wc_wkctr
              xxwc_mch   = wc_mch
	      xxwc_desc  = wc_desc
	      xxwc_dept  = wc_dept
	      xxwc_chr01 = wc__chr01
	      xxwc_flg   = "A".    /*Flag: Add*/

       create xxwc2_mstr.
       assign xxwc2_wkctr = wc_wkctr
              xxwc2_mch   = wc_mch
	      xxwc2_desc  = wc_desc
	      xxwc2_dept  = wc_dept
	      xxwc2_chr01 = wc__chr01.
    end.  /*if not avail xxwc2_mstr*/
    else do:
         if xxwc2_desc  <> wc_desc or
            xxwc2_dept  <> wc_dept or
	    xxwc2_chr01 <> wc__chr01 then do:

            create xxwc_mstr.
            assign xxwc_wkctr = wc_wkctr
                   xxwc_mch   = wc_mch
	           xxwc_desc  = wc_desc
	           xxwc_dept  = wc_dept
	           xxwc_chr01 = wc__chr01
	           xxwc_flg   = "C".    /*Flag: Change*/

	    assign xxwc2_desc  = wc_desc
	           xxwc2_dept  = wc_dept
	           xxwc2_chr01 = wc__chr01.
         end.  /*Change*/
    end.  /* avail xxwc2_mstr*/
end.  /*for each wc_mstr */


find first xxwc2_mstr no-error.
repeat:
    do transaction:
    if not avail xxwc2_mstr then leave.
    find first wc_mstr where wc_wkctr = xxwc2_wkctr
           and wc_mch = xxwc2_mch no-lock no-error.
    if not avail wc_mstr then do:
       create xxwc_mstr.
       create xxwc_mstr.
       assign xxwc_wkctr = xxwc2_wkctr
              xxwc_mch   = xxwc2_mch
	      xxwc_desc  = xxwc2_desc
	      xxwc_dept  = xxwc2_dept
	      xxwc_chr01 = xxwc2_chr01.
	      xxwc_flg   = "D".    /*Flag: Delete*/

       delete xxwc2_mstr.  /*Delete*/
    end.  /*if not avail wc_mstr*/

    find next xxwc2_mstr no-error.
end.  /*for each wc_mstr */
end.  /*transaction*/

xxqad_basic8 = "2".
end.
