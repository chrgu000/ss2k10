                find first err_det
                    where err_part = {&err-part} 
                    and   err_site = {&err-site}
                    and   err_type = {&err-type}
                no-lock no-error.
                if not avail err_det then do:
                    create err_det .
                    assign err_part = {&err-part}
                           err_site = {&err-site}
                           err_type = {&err-type}
                           err_desc = {&err-desc}
                           .
                end.
