UpdBlock1:
do on error undo, retry:

    find first ttfg 
    exclusive-lock 
    where recid(ttfg) = w-rid[Frame-line(f)]
    and ttfg_flag no-error.
    
    if not available ttfg then do:
       undo, leave .
    end .

    prompt-for
       ttfg_cust
       ttfg_dloc
       ttfg_nbr
    with frame f .
    
    find first cm_mstr where cm_addr = input ttfg_cust no-lock no-error.
    if not avail cm_mstr then do:
       message "无此客户"
       view-as alert-box error.
       undo, retry.
    end.
    
    find first loc_mstr where loc_loc = input ttfg_dloc no-lock no-error.
    if not avail loc_mstr then do:
       message "无此库位"
       view-as alert-box error.
       undo, retry.
    end.
    
    if input ttfg_nbr <> "" then do:
       find first xpd_mstr where xpd_nbr = input ttfg_nbr and 
       xpd_part = ttfg_part and xpd_lnr = ttfg_line and xpd_stat = "" 
       no-lock no-error.
       if not avail xpd_mstr then do:
          message "未发现该生产单"
          view-as alert-box error.
          undo, retry.
       end.
       
       find first xwo_srt where xwo_lnr = ttfg_line and xwo_part = ttfg_part 
       and xwo_lot = tmplot and xwo_pdnbr = input ttfg_nbr no-lock no-error.
       if avail xwo_srt then do:
          ttfg_cnt = xwo_qty_lot / xpal_sub_qty.
          ttfg_note = "未结".
       end.
    end.
    
    assign frame f ttfg_cust ttfg_dloc ttfg_nbr.

end.
