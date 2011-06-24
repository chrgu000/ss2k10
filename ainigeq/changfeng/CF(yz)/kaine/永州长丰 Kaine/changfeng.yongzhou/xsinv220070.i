/* xsinv220070.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 确认 */
lp0070:
repeat on endkey undo, retry:
    hide all.
    define variable s0070             as character format "x(50)".
    define variable s0070_1           as character format "x(50)".
    define variable s0070_2           as character format "x(50)".
    define variable s0070_3           as character format "x(50)".
    define variable s0070_4           as character format "x(50)".
    define variable s0070_5           as character format "x(50)".
    
    form
        sTitle
        s0070_1
        s0070_2
        s0070_3
        s0070_4
        s0070_5
        s0070
        sMessage
    with frame f0070 no-labels no-box.

    assign
        s0070_1 = "备注: " + s0020
        s0070_2 = "料品: " + s0030
        s0070_3 = "批号: " + s0040
        s0070_4 = "库位: " + s0050 + "/" + s0060
        s0070_5 = "确认提交,或按E退出"
        .
    
    display
        sTitle
        s0070_1
        s0070_2
        s0070_3
        s0070_4
        s0070_5
    with frame f0070.
    
    s0070 = sConfirm.
    
    update
        s0070
    with frame f0070.
    
    if s0070 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    else do:
        if s0070 <> sConfirm then do:
            display
                "请输入" + sConfirm + "或" + sExitFlag @ sMessage
            with frame f0070.
            undo, retry.
        end.
    end.
    
    leave lp0070.
END.

