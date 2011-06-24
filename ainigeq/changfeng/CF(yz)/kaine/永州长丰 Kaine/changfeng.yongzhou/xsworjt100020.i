/* xsworjt100020.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 100301.1 By: Roger Xiao */

/* 工单ID */
lp0020:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0020.i}
    
    assign
        s0020_1 = "工单ID?"
        s0020_6 = sPromptMessage
        .
    
    display
        sTitle
        s0020_1
        s0020_2
        s0020_3
        s0020_4
        s0020_5
        s0020_6
    with frame f0020.
    
    update
        s0020
    with frame f0020
    editing:
        {xsreadkey.i}
        apply lastkey.
    end.
    
    if s0020 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    else do:
        find first wo_mstr 
            where wo_lot = s0020
                and wo_site = s0010
                and (wo_status = "R" or wo_status = "A")
            use-index wo_lot
            no-lock 
            no-error.
        if not(available(wo_mstr)) then do:
            display
                "工单ID或地点或状态无效" @ sMessage
            with frame f0020.
            undo, retry.
        end.
        if wo_qty_comp <= 0 then do:
            display
                "工单完成数量不足" wo_qty_comp  @ sMessage
            with frame f0020.
            undo, retry.
        end.
    end.
    
    leave lp0020.
END.

