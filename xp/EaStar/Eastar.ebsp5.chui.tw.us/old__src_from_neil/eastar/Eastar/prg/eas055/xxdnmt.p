/* xxdnmt.p */
/* REVISION: eb SP5 create 08/16/06 BY: *SS-EAS055* Apple Tam*/

    /* DISPLAY TITLE */
    {mfdtitle.i "eb sp5"}

	 define new shared variable p-code    like xxdn_code     .
	 define new shared variable p-nbr     like xxdn_nbr     format "99999"  .
	 define new shared variable p-year    like xxdn_year    format "9999"    .
	 define new shared variable p-value   like xxdn_value     .
         define variable del-yn like mfc_logical initial no.

         /* DISPLAY SELECTION FORM */
         form
            p-code        colon 30 label "Code"
            p-nbr         colon 30 label "Sequence Number"
            p-year        colon 30 label "Year"
	    p-value       colon 30 label "Value"
         with frame a side-labels width 80.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).


    mainloop:
    repeat:  
        view frame a.
          p-code      = "" .
          p-nbr        = "00001" .
          p-year       = "" .
          p-value      = "".

       display 
           p-code    
           p-nbr     
           p-year    
           p-value    
       with frame a.

       update 
          p-code
        with frame a editing:
	        {mfnp.i xxdn_ctrl p-code xxdn_code p-code xxdn_code xxdn_code}
             if recno <> ? then do:
                assign
                p-code    =  xxdn_code   
                p-nbr     =  xxdn_nbr   
                p-year    =  xxdn_year   
                p-value   =  xxdn_value    .
                
	            display 
                    p-code  
                    p-nbr   
                    p-year  
                    p-value   
                with frame a.
	         end. /*recno <> ? */
	    end. /*editing*/

        if p-code = "" then do:
           message "Error: Invalid Code.Please re-enter.".
           undo, retry.
        end.
        find first xxdn_ctrl where xxdn_code = p-code no-lock no-error.
	            display 
                    p-code
                    p-nbr 
                    p-year                  
                    p-value   
                with frame a.

	    ststatus = stline[2].
            status input ststatus.
    mainloop2:
    repeat:  
     update
          p-nbr  
	  p-year  
          p-value   
	 go-on(F5 CTRL-D) with frame a.

        if p-year = "" then do:
           message "Error: Invalid Year.Please re-enter.".
           undo, retry.
        end.
        if p-nbr = "" then do:
           message "Error: Invalid Sequence Number.Please re-enter.".
           undo, retry.
        end.
        if p-value = "" then do:
           message "Error: Invalid Value.Please re-enter.".
           undo, retry.
        end.
        find first xxdn_ctrl where xxdn_code = p-code and xxdn_value = p-value no-lock no-error.
        if available xxdn_ctrl then do:
                assign
                p-code     =  xxdn_code 
             /*   p-nbr      =  xxdn_nbr 
                p-year     =  xxdn_year */
                p-value    =  xxdn_value. 
        end.
	            display 
                     p-code   
                     p-nbr    
                     p-year  
                     p-value 
                with frame a.
	
	    if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
           del-yn = yes.
           {mfmsg01.i 11 1 del-yn}
           if del-yn then do:
               find first xxdn_ctrl where xxdn_code = p-code and xxdn_value = p-value no-error.
		     if available xxdn_ctrl then do:
                       delete xxdn_ctrl.
		     end.
                  clear frame a.
                p-code      = "" .     
                p-nbr        = "00001" .    
                p-year       = "" .    
                p-value      = "".
                
	           display
		      p-code  
		      p-nbr   
		      p-year  
		      p-value 
                   with frame a.
            end.
	    end.
	       else do: /*f5*/

	           display
		      p-code  
		      p-nbr   
		      p-year  
		      p-value 
                   with frame a.

               find first xxdn_ctrl where xxdn_code = p-code and xxdn_value = p-value no-error.
		     if available xxdn_ctrl then do:
	         assign
                 xxdn_nbr    = p-nbr 
                 xxdn_year   = p-year .
	     end.
	     else do:
	         create xxdn_ctrl.
	         assign
                 xxdn_code   = p-code 
                 xxdn_nbr    = p-nbr 
                 xxdn_year   = p-year 
                 xxdn_value  = p-value.
	     end.
         end. /*f5*/
         leave.
    end. /*mainloop2*/

    end. /*mainloop*/

            status input.
