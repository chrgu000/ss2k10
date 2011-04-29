/* xxshmdmt.p */
/* REVISION: eb SP5 create 09/11/03 BY: *EAS031* Apple Tam*/

    /* DISPLAY TITLE */
    {mfdtitle.i "eb sp5"}

	 define new shared variable code like custship_code.
	 define new shared variable method like custship_method.
	 define variable name1 like ad_name.
         define variable del-yn like mfc_logical initial no.

         /* DISPLAY SELECTION FORM */
         form
            code         colon 20 label "Customer"
            name1        colon 30 no-label 
	    method       colon 20 label "Shipment Method"
         with frame a side-labels width 80.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).


    mainloop:
    repeat:  
        view frame a.
      
       display code name1 method with frame a.
       update 
          code
        with frame a editing:
           {mfnp.i custship_mstr code custship_code code custship_code custship_code}
             if recno <> ? then do:
		code = custship_code.
		method = custship_method.
		find first ad_mstr where ad_addr = code no-lock no-error.
		if available ad_mstr then do:
		   name1 = ad_name.
		end.
		else do:
		   name1 = "".
		end.
	         display code name1 method with frame a.
	     end.
	end.
            find first cm_mstr where cm_addr = code no-lock no-error.
	    if not available cm_mstr then do:
                message "Customer Code does not exist,Please re-enter.".
	        undo, retry.
	    end.

	    find first custship_mstr where custship_code = code and custship_method = method no-lock no-error.
	    if available custship_mstr then do:
		code = custship_code.
		method = custship_method.
	    end.
	    else do:
	    
	    find first custship_mstr where custship_code = code no-lock no-error.
	    if available custship_mstr then do:
		code = custship_code.
		method = custship_method.
	    end.
	    else do:
		method = "".
	    end.
	    find first ad_mstr where ad_addr = code  no-lock no-error.
	    if available ad_mstr then do:
	       name1 = ad_name.
	    end.
	    else do:
	       name1 = "".
	    end.
	         display code name1 method with frame a.
	end.

/*     update
        method
	with frame a.


*/	    
	    ststatus = stline[2].
            status input ststatus.

    mainloop2:
    repeat:  

	update
	  method
	 go-on(F5 CTRL-D) with frame a.
	    find first ship_mt_mstr where ship_mt_code = method no-lock no-error.
	    if not available ship_mt_mstr then do:
                message "Shipment Method does not exist,Please re-enter.".
  	        undo, retry.
	    end.

	    if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
               del-yn = yes.
               {mfmsg01.i 11 1 del-yn}
               if del-yn then do:
	         find first custship_mstr where custship_code = code and custship_method = method no-error.
		 if available custship_mstr then do:
                  delete custship_mstr.
		 end.
                  clear frame a.
		  code = "".
		  name1 = "".
		  method = "".
	         display code name1 method with frame a.
               end.
	    end.



	       else do: /*f5*/

	         display code name1 method with frame a.

	         find first custship_mstr where custship_code = code and custship_method = method no-error.
		 if available custship_mstr then do:
		    custship_code = code.
		    custship_method = method.
	        end.
	        else do:
	         create custship_mstr.
	         assign
		    custship_code = code
		    custship_method = method.
	        end.
              end. /*f5*/
      leave.
    end. /*mainloop2*/

    end. /*mainloop*/

            status input.
