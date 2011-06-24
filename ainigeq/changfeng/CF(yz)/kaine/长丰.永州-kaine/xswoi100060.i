/* xswoi100060.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 数量 */
lp0060:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0060.i}
    
    define variable dec0060           as decimal no-undo.
    
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
    
    find first wod_det
        no-lock
        where wod_lot = s0020
            and wod_part = s0030
            and wod_op = 0
        no-error.
    if available(wod_det) then s0060 = string(max(wod_qty_req - wod_qty_iss, 0)).
    
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
    end.
    
    leave lp0060.
END.

