            find first xbm_mstr 
                where xbm_domain = global_domain 
                and   xbm_lot    = {&lot} 
                /*
                and   xbm_part   = {&part}
                and   xbm_wolot  = {&wolot}*/
            exclusive-lock no-error.
            if not avail xbm_mstr then do:
                create xbm_mstr.
                assign  xbm_domain   = global_domain 
                        xbm_lot      = {&lot}   
                        xbm_part     = {&part}  
                        xbm_wonbr    = {&wonbr}
                        xbm_wolot    = {&wolot}  

                        xbm_date_crt = today  
                        xbm_time_crt = time  
                        xbm_user_crt = global_userid  
                        xbm_mthd_crt = "Create" 
                        .
            end.
            else do:
                message {&error} view-as alert-box.
            end.
