/* xsinv410070.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 显示信息 */
lp0070:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0070.i}
    
    find first tr_hist
        no-lock
        where tr_trnbr > iTrSeq
            and tr_type = "CYC-RCNT"
            and tr_site = s0010
            and tr_loc = s0020
            and tr_part = s0030
            and tr_serial = s0040
            and tr_rmks = mfguser
        use-index tr_trnbr
        no-error.
        
    if available(tr_hist) then
        assign
            s0070_1 = "盘点事务成功"
            s0070_2 = "事务号: " + string(tr_trnbr)
            .
    else
        assign
            s0070_1 = "盘点事务失败"
            s0070_2 = ""
            .
    
    assign
        s0070_6 = sConfirmOrExit
        s0070 = sConfirm
        .
    
    display
        sTitle
        s0070_1
        s0070_2
        s0070_3
        s0070_4
        s0070_5
        s0070_6
    with frame f0070.
    
    
    update
        s0070
    with frame f0070
    editing:
        {xsreadkeyapply.i}
    end.
    
    if s0070 = sExitFlag then do:
        next detailloop.
    end.
    else do:
        if s0070 <> sConfirm then do:
            display
                sConfirmOrExit @ sMessage
            with frame f0070.
            undo, retry.
        end.
    end.
    
    leave lp0070.
END.

