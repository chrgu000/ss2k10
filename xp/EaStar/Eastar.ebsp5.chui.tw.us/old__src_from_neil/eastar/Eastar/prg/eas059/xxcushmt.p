/* xxshmdmt.p */
/* REVISION: eb SP5 create 09/11/03 BY: *EAS031* Apple Tam*/
/* REVISION: eb SP5 Modified on 09/11/03 BY: *EAS031A1* Ricky Ho*/

    /* DISPLAY TITLE */
    {mfdtitle.i "eb sp5"}

	 define new shared variable code like custship_code.
	 define new shared variable method like custship_method.
	 define variable name1 like ad_name.
         define variable del-yn like mfc_logical initial no.
/*EAS031A1*/ define variable v_default like custship_default init no.
/*EAS031A1*/ define buffer custship_mstr_buffer for custship_mstr.

         /* DISPLAY SELECTION FORM */
         form
            code         colon 20 label "Customer"
            name1        colon 30 no-label 
	    method       colon 20 label "Shipment Method"
/*EAS031A1*/ v_default	colon 20
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
/*EAS031A1*/ v_default = custship_default.
		find first ad_mstr where ad_addr = code no-lock no-error.
		if available ad_mstr then do:
		   name1 = ad_name.
		end.
		else do:
		   name1 = "".
		end.
	         display code name1 method /*EAS031A1*/ v_default with frame a.
	     end.
	end.
/*apple            find first cm_mstr where cm_addr = code no-lock no-error.
	    if not available cm_mstr then do:
/*@@@@@@@                 message "Customer Code does not exist,Please re-enter.". */
/*@@@@@@@*/ {mfmsg.i 2786 1}			
	        undo, retry.
	    end.
*/

/*apple*/            find first ad_mstr where ad_addr = code /*and ad_type = "ship-to"*/ no-lock no-error.
	    if not available ad_mstr then do:
/*@@@@@@@                 message "Customer Code does not exist,Please re-enter.". */
/*@@@@@@@*/ {mfmsg.i 2786 1}			
	        undo, retry.
	    end.

	    find first custship_mstr where custship_code = code and custship_method = method no-lock no-error.
	    if available custship_mstr then do:
		code = custship_code.
		method = custship_method.
/*EAS031A1*/ v_default = custship_default.
	    end.
	    else do:
	    
	    find first custship_mstr where custship_code = code no-lock no-error.
	    if available custship_mstr then do:
		code = custship_code.
		method = custship_method.
/*EAS031A1*/ v_default = custship_default.
	    end.
	    else do:
		method = "".
/*EAS031A1*/ v_default = no.
	    end.
	    find first ad_mstr where ad_addr = code  no-lock no-error.
	    if available ad_mstr then do:
	       name1 = ad_name.
	    end.
	    else do:
	       name1 = "".
	    end.
	         display code name1 method /*EAS031A1*/ v_default with frame a.
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
	  method /*EAS031A1*/ v_default
	 go-on(F5 CTRL-D) with frame a.
	    find first ship_mt_mstr where ship_mt_code = method no-lock no-error.
	    if not available ship_mt_mstr then do:
			if global_user_lang = "tw" then
				message "�˹B�覡���s�b�M�Э��s��J�C".
            else    message "Shipment Method does not exist,Please re-enter.".
			
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
/*EAS031A1*/ v_default = no.
	         display code name1 method /*EAS031A1*/ v_default with frame a.
               end.
	    end.



	       else do: /*f5*/

	         display code name1 method /*EAS031A1*/ v_default with frame a.

	         find first custship_mstr where custship_code = code and custship_method = method no-error.
		 if available custship_mstr then do:
		    custship_code = code.
		    custship_method = method.
/*EAS031A1 add begin */
			IF v_default THEN
			DO:
				FOR EACH custship_mstr_buffer where custship_code = code exclusive-LOCK:
					assign custship_default = no.
				END.
			END.
/*EAS031A1 add end */ 
/*EAS031A1*/ custship_default = v_default.
	        end.
	        else do:
	         create custship_mstr.
	         assign
		    custship_code = code
		    custship_method = method.
/*EAS031A1 add begin */
			IF v_default THEN
			DO:
				FOR EACH custship_mstr_buffer where custship_code = code exclusive-LOCK:
					assign custship_default = no.
				END.
			END.
/*EAS031A1 add end */ 
/*EAS031A1*/ custship_default = v_default.
			end.
              end. /*f5*/
      leave.
    end. /*mainloop2*/

    end. /*mainloop*/

            status input.
