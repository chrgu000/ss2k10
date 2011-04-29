    update 
        site
        v_week 
        v_month
        v_sortby
    with frame a.

    find first si_mstr 
        where si_site  = site 
    no-lock no-error.
    if not avail si_mstr then do:
        message "错误:无效地点,请重新输入".
        undo,retry.    
    end.

    find first xxpsc_ctrl where xxpsc_site  = site no-lock no-error .
    if not avail xxpsc_ctrl then do:
        message "错误:该地点未设定排程参数,请重新输入".
        undo,retry.    
    end.
    
    if v_week = ? or index("01234",string(v_week)) = 0 then do:
        message "错误:无效周别,请重新输入".
        next-prompt v_week with frame a .
        undo,retry.
    end.

    if v_month = ? or index("123456789",string(v_month)) = 0 then do:
        message "错误:无效月份,请重新输入".
        next-prompt v_month with frame a .
        undo,retry.
    end.

    if v_sortby = ? or index("12",string(v_sortby)) = 0 then do:
        message "错误:无效月份,请重新输入".
        next-prompt v_sortby with frame a .
        undo,retry.
    end.

    printerloop:
    do on error undo , retry:
        if dev = "" then do:
            if can-find(prd_det where prd_dev = "printer1") then   dev = "printer1".
            else do:
                find last prd_det where prd_path <> "terminal" and prd_dev <> "terminal" no-lock no-error.
                if available prd_det then dev = prd_dev.
                else dev = "printer".
            end.
        end.
        display dev to 77  with frame a.
        set dev with frame a editing:
            if frame-field = "dev" then do:
                {mfnp05.i prd_det prd_dev "yes" prd_dev "input dev"}
                if recno <> ? then do:
                    dev = prd_dev.
                    display dev with frame a.
                end.
            end.
        end.
        if not can-find(first prd_det where prd_dev = dev) then do:
            {mfmsg.i 34 3}
            undo,retry.
        end.        
    end. /*printerloop:*/

  
    /*临时表,变量等初始化*/
    for each nr_det    where nr_site    = site : delete nr_det     . end. 
    for each kc_det    where kc_site    = site : delete kc_det     . end. 
    for each err_det   where err_site   = site : delete err_det    . end.
    for each xrq_det   where xrq_site   = site : delete xrq_det    . end.
    for each xln_det   where xln_site   = site : delete xln_det    . end.
    for each ttemp1    where tt1_site   = site : delete ttemp1     . end.
    for each ttemp2    where tt2_site   = site : delete ttemp2     . end.
    for each xcn_det   where xcn_site   = site : delete xcn_det    . end.

    v_time_stock = if avail xxpsc_ctrl then xxpsc_time_stock else 0 . /*暂未使用*/
    v_days       = 30 * v_month . /*排程,往日后考虑的总天数*/
    if v_days = 0  then v_days = 180 .
