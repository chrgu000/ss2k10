/*  ---- */
/* Copyright 2010 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 100412.1 By: Kaine Zhang */

/* *ss_20100412* 按期间指定供应商类型. */

{mfdtitle.i "100412.1"}

define variable bCanCreateXvd as logical.
define variable rcdXvd as recid.

form
    xvd_addr            colon 15
    ad_name             no-labels
    xvd_start_year      colon 15
    xvd_start_month     colon 15
    xvd_finish_year     colon 15
    xvd_finish_month    colon 15
    xvd_type            colon 15
with frame a side-labels width 80.
setframelabels(frame a:handle).



mainloop:
repeat with frame a:
    prompt-for
        xvd_addr
        xvd_start_year
        xvd_start_month
        .
        
    find first xvd_mstr
        where xvd_domain = global_domain
            and xvd_addr = input xvd_addr
            and xvd_start_year = input xvd_start_year
            and xvd_start_month = input xvd_start_month
        use-index xvd_addr_date
        no-error.
    if not(available(xvd_mstr)) then do:
        bCanCreateXvd = no.
        find last xvd_mstr
            no-lock
            where xvd_domain = global_domain
                and xvd_addr = input xvd_addr
                and xvd_start_year * 100 + xvd_start_month < (input xvd_start_year) * 100 + (input xvd_start_month)
            use-index xvd_addr_date
            no-error.
        if available(xvd_mstr) then do:
            if xvd_finish_year * 100 + xvd_finish_month < (input xvd_start_year) * 100 + (input xvd_start_month) then bCanCreateXvd = yes.
        end.
        else
            bCanCreateXvd = yes.
        
        if not(bCanCreateXvd) then do:
            message "期间范围重复".
            undo, retry.
        end.
        
        message "创建新记录".
        create xvd_mstr.
        assign
            xvd_domain      = global_domain
            xvd_addr        = input xvd_addr       
            xvd_start_year  = input xvd_start_year 
            xvd_start_month = input xvd_start_month
            .
    end.
    
    do on endkey undo mainloop, retry mainloop
        on error undo, retry
    :
        update
            xvd_finish_year
            xvd_finish_month
            xvd_type
            .
        
        rcdXvd = recid(xvd_mstr).
        {gprun.i ""xxcheckvdyearmonth.p"" "(input rcdXvd, output bCanCreateXvd)"}
        if bCanCreateXvd then do:
            message "操作完成".
        end.
        else do:
            message "期间范围重复".
            undo, retry.
        end.
    end.
end.

