/* xsinv220080.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 打印条码? */
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
            and tr_type = "RCT-UNP"
            and tr_part = s0030
            and tr_site = s0010
            and tr_loc = s0050
            and tr_serial = s0040
            and tr_qty_loc = dec0060
        use-index tr_trnbr
        no-error.
        
    if available(tr_hist) then
        assign
            s0080_1 = "事务成功完成"
            s0080_2 = "事务号: " + string(tr_trnbr)
            s0080_5 = "输入Y或按E退出"
            .
    else
        assign
            s0080_1 = "入库事务未完成"
            s0080_2 = ""
            s0080_5 = "输入Y或按E退出"
            .
            
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
                "请输入" + sConfirm + "或" + sExitFlag @ sMessage
            with frame f0080.
            undo, retry.
        end.
    end.
    
    leave lp0080.
END.

