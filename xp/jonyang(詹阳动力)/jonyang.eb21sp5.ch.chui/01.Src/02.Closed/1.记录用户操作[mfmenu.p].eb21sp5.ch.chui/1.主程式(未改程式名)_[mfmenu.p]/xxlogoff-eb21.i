/*xxlogoff-eb21.i  create by SoftSpeed Roger Xiao ,Used by mfmenu.p  */
/* SS - 100401.1  By: Roger Xiao */

do transaction:
        find first xu_hist 
            where recid(xu_hist) = v_rec 
        exclusive-lock no-error.
        if not avail xu_hist then do:
            create xu_hist .
            assign xu_domain     = global_domain  
                   xu_session    = mfguser
                   xu_menu       = v_menu           
                   xu_program    = v_program      
                   xu_start_date = v_start_date 
                   xu_start_time = v_start_time 
                   xu_user       = global_userid    
                   xu_ip         = v_ip 
                   .
        end.

        xu_end_date = today .
        xu_end_time = time .
        release xu_hist .
end.