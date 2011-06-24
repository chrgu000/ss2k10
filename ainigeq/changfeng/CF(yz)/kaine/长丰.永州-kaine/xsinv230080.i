/* xsinv230080.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 显示事务信息 */
lp0080:
repeat on endkey undo, retry:
    hide all.
    define variable s0080             as character format "x(50)".
    define variable s0080_1           as character format "x(50)".
    define variable s0080_2           as character format "x(50)".
    define variable s0080_3           as character format "x(50)".
    define variable s0080_4           as character format "x(50)".
    define variable s0080_5           as character format "x(50)".
    
    form
        sTitle
        s0080_1
        s0080_2
        s0080_3
        s0080_4
        s0080_5
        s0080
        sMessage
    with frame f0080 no-labels no-box.
    
    find first tr_hist
        no-lock
        where tr_trnbr > iTrSeq
            and tr_type = "ISS-TR"
            and tr_part = s0020
            and tr_site = s0010
            and tr_loc = s0040
            and tr_serial = s0030
            and tr_qty_loc = (- dec0060)
        use-index tr_trnbr
        no-error.
        
    if available(tr_hist) then
        assign
            s0080_1 = "事务成功完成"
            s0080_2 = "事务号: " + string(tr_trnbr)
            s0080_5 = "按" + sConfirm + "或"+ sExitFlag + "退出"
            .
    else
        assign
            s0080_1 = "转仓事务未完成"
            s0080_2 = ""
            s0080_5 = "按" + sConfirm + "或"+ sExitFlag + "退出"
            .
    
    /* SS - 090710.1 - B
    find first ld_det
        no-lock
        where ld_site = s0010
            and ld_loc = s0040
            and ld_part = s0020
            and ld_lot = s0030
            and ld_ref = ""
        use-index ld_loc_p_lot
        no-error.
    if available(ld_det) then
        s0080_3 = "库位" + s0040 + ": " + string(ld_qty_oh).
    else
        s0080_3 = "库位" + s0040 + ": 0".
    
        
    find first ld_det
        no-lock
        where ld_site = s0010
            and ld_loc = s0050
            and ld_part = s0020
            and ld_lot = s0030
            and ld_ref = ""
        use-index ld_loc_p_lot
        no-error.
    if available(ld_det) then
        s0080_4 = "库位" + s0050 + ": " + string(ld_qty_oh).
    else
        s0080_4 = "库位" + s0050 + ": 0".
    SS - 090710.1 - E */
    
    /* SS - 090710.1 - B */
    for each ld_det
        no-lock
        where ld_site = s0010
            and ld_loc = s0040
            and ld_part = s0020
        use-index ld_loc_p_lot
    :
        accumulate ld_qty_oh (total).
    end.
    s0080_3 = "库位" + s0040 + ": " + string(accum total ld_qty_oh).
    
    for each ld_det
        no-lock
        where ld_site = s0010
            and ld_loc = s0050
            and ld_part = s0020
        use-index ld_loc_p_lot
    :
        accumulate ld_qty_oh (total).
    end.
    s0080_4 = "库位" + s0050 + ": " + string(accum total ld_qty_oh).
    /* SS - 090710.1 - E */
        
    display
        sTitle
        s0080_1
        s0080_2
        s0080_3
        s0080_4
        s0080_5
    with frame f0080.
    
    
    s0080 = sConfirm.
    
    update
        s0080
    with frame f0080.
    
    if s0080 = sExitFlag then do:
        next mainloop.
    end.
    else do:
        if s0080 <> sConfirm then do:
            display
                sConfirmOrExit @ sMessage
            with frame f0080.
            undo, retry.
        end.
    end.
    
    leave lp0080.
END.

