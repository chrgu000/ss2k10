/* xsinv410060.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 确定 */
lp0060:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0060.i}
    
    assign
        s0060_1 = "料品: " + s0030
        s0060_2 = "批号: " + s0040
        s0060_3 = "库位: " + s0020
        s0060_5 = "盘点数量: " + s0050
        s0060_6 = sConfirmOrExit
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
    s0060_4 = "原数量: " + if available(ld_det) then string(ld_qty_oh) else "0".
    
    display
        sTitle
        s0060_1
        s0060_2
        s0060_3
        s0060_4
        s0060_5
        s0060_6
    with frame f0060.
    
    s0060 = "Y".
    
    update
        s0060
    with frame f0060 editing:
        {xsreadkeyapply.i}
    end.
    
    if s0060 = sExitFlag then do:
        undo detailloop, leave detailloop.
    end.
    else do:
        if s0060 <> sConfirm then do:
            display
                sConfirmOrExit @ sMessage
            with frame f0060.
            undo, retry.
        end.
    end.
    
    leave lp0060.
END.

