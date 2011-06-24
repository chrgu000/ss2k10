/* xsworjt100060.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 100301.1 By: Roger Xiao */

/* 数量 */
lp0060:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0060.i}
    
    define variable dec0060           as decimal no-undo.
    define variable dec0061           as decimal no-undo.
    
    assign
        s0060_1 = "数量?"
        s0060_2 = "料品: " + s0030
        s0060_3 = "批号: " + s0040
        s0060_4 = "库位: " + s0050
        s0060_5 = "工单: " + s0020
        s0060_6 = sPromptMessage
        .
    
    if not(retry) then s0060 = "0".
    
    display
        sTitle
        s0060_1
        s0060_2
        s0060_3
        s0060_4
        s0060_5
        s0060_6
    with frame f0060.
    
    find first wo_mstr 
        where wo_lot = s0020
            and wo_site = s0010
            and (wo_status = "R" or wo_status = "A")
        use-index wo_lot
        no-lock 
        no-error.
    s0060 = string(wo_qty_comp).
    
    update
        s0060
    with frame f0060 editing:
        {xsreadkeyapply.i}
    end.
    
    if s0060 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    else do:
        if s0060 = "" then do:
            display
                "不可留空" @ sMessage
            with frame f0060.
            undo, retry.
        end.
        
        dec0060 = decimal(s0060) no-error.
        if error-status:error then do:
            display
                "数量有误" @ sMessage
            with frame f0060.
            undo, retry.
        end.
        if dec0060 <= 0 then do:
            display
                "数量不可<=0" @ sMessage
            with frame f0060.
            undo, retry.
        end.

        /* 库存数量是否足够? */
        find first ld_det
            where  ld_site = s0010
            and ld_loc = s0050
            and ld_part = s0030
            and ld_lot = s0040
            and ld_ref = ""
        no-lock no-error.
        if not(available(ld_det)) then do:
            display
                "库存数量0" @ sMessage
            with frame f0060.
            undo, retry.
        end.
        if ld_qty_oh < dec0060 then do:
            display
                "库存" + string(ld_qty_oh) + "<" + s0060
                    @ sMessage
            with frame f0060.
            undo, retry.
        end.

        dec0061 = - dec0060 .
        


    end.
    
    leave lp0060.
END.

