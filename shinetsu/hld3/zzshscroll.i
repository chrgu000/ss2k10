/*zzshscroll.i  Ship Weight Preparation: Screen Scroll*/
/*Last Modify by Leo Zhou   11/28/2011 */

view frame a.

pause 0.
sub-loop:
do transaction with frame b:
       
       clear frame b all no-pause.
       view frame b.
            
       find first tt use-index {1} no-lock no-error.
       /*if not available tt then leave.*/
            
       i = 0.
       
       do while i < frame-down and available tt:
	  /*Display temp-table*/
	  {zzshdisp.i}
          
	  i = i + 1.        
          if i < frame-down then down 1.
          find next tt use-index {1} no-lock no-error.
       end. 
            
       up frame-line - 1.
       find first tt use-index {1} no-lock no-error.
       
       detail-loop:
       repeat with frame b:
	       /*Display temp-table*/
		{zzshdisp.i}
        
                pause before-hide.
                update tt_key1 tt_key2 go-on(F9 F10 CURSOR-UP CURSOR-DOWN).
                pause 0.
        
                if tt_key1 and tt_key2 then do:
		    /*Invalid Option*/
                    {pxmsg.i &MSGNUM=1 &ERRORLEVEL=3}
                    update tt_key1 tt_key2 with frame b.
                    undo, retry.
                end. 

		/*Display temp-table*/
		{zzshdisp.i} 
         
                do while lastkey = keycode("F9")
                      or lastkey = keycode("CURSOR-UP")
                      or lastkey = keycode("F10")
                      or lastkey = keycode("CURSOR-DOWN")
                      or lastkey = keycode("RETURN")
                      or keyfunction(lastkey) = "GO" 
                on endkey undo, leave detail-loop:
                    
                    if  lastkey = keycode("F9") or lastkey = keycode("CURSOR-UP") then do:
                        find prev tt use-index {1} no-error.                    
                        if available tt then up 1.
                        else find first tt use-index {1} no-error .
                    end.
                    else if lastkey = keycode("F10") 
		         or lastkey = keycode("CURSOR-DOWN") 
                         or lastkey = keycode("RETURN")
                         or keyfunction(lastkey) = "GO" then do:
                        find next tt use-index {1} no-error.                
                        if available tt then down 1.
                        else  find last tt use-index {1} no-error.
                    end.                 
        
	            /*Display temp-table*/
		    {zzshdisp.i}

		    pause before-hide.
                    update tt_key1 tt_key2 go-on(F9 F10 CURSOR-UP CURSOR-DOWN).
                    pause 0.
                
                    if tt_key1 and tt_key2 then do:
			/*Invalid Option*/
                        {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3}
                        update tt_key1 tt_key2 with frame b.
                        undo, retry.
                    end. 

		    /*Display temp-table*/
		    {zzshdisp.i}
                end.   /*do while*/                           
       end. /* end of repeat with FRAME b: detail-loop */                 
end.  /*sub-loop*/

find first tt use-index {1} no-lock no-error.
