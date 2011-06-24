/* xswor020080.i -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 显示信息 */
lp0080:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0080.i}
    
    find first tr_hist
        no-lock
        where tr_trnbr > iTrSeq
            and tr_type = "RCT-WO"
            and tr_site = s0010
            and tr_loc = s0050
            and tr_serial = s0040
            and tr_qty_loc = dec0060
            and tr_rmks = mfguser
        use-index tr_trnbr
        no-error.
        

    if available(tr_hist) then
        assign
            s0080_1 = "工单入库事务成功"
            s0080_2 = "事务号: " + string(tr_trnbr)
            .
    else
        assign
            s0080_1 = "工单入库事务失败"
            s0080_2 = ""
            .
    
    assign
        s0080_6 = sConfirmOrExit
        s0080 = sConfirm
        .
    
    display
        sTitle
        s0080_1
        s0080_2
        s0080_3
        s0080_4
        s0080_5
        s0080_6
    with frame f0080.
    
    
    update
        s0080
    with frame f0080
    editing:
        {xsreadkeyapply.i}
    end.
    
    if s0080 = sExitFlag then do:
        next detlp.
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

