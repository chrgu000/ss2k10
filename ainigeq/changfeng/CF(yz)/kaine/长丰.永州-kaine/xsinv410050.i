/* xsinv410050.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 数量 */
lp0050:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0050.i}
    
    define variable dec0050           as decimal no-undo.
    
    assign
        s0050_1 = "数量?"
        s0050_2 = "料品: " + s0030
        s0050_3 = "批号: " + s0040
        s0050_4 = "库位: " + s0020
        s0050_6 = sPromptMessage
        .
    find first ld_det
        no-lock
        where ld_site = s0010
            and ld_loc = s0020
            and ld_part = s0030
            and ld_lot = s0040
            and ld_ref = ""
        use-index ld_loc_p_lot
        no-error.
    s0050_5 = "库存数量: " + if available(ld_det) then string(ld_qty_oh) else "0".
    if not(retry) then s0050 = (if available(ld_det) then string(ld_qty_oh) else "0").
    
    display
        sTitle
        s0050_1
        s0050_2
        s0050_3
        s0050_4
        s0050_5
        s0050_6
    with frame f0050.
    
    update
        s0050
    with frame f0050 editing:
        {xsreadkeyapply.i}
    end.
    
    if s0050 = sExitFlag then do:
        undo detailloop, leave detailloop.
    end.
    else do:
        if s0050 = "" then do:
            display
                "不可留空" @ sMessage
            with frame f0050.
            undo, retry.
        end.
        
        dec0050 = decimal(s0050) no-error.
        if error-status:error then do:
            display
                "数量有误" @ sMessage
            with frame f0050.
            undo, retry.
        end.
    end.
    
    leave lp0050.
END.

