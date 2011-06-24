/* xspor010080v2.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/06/2009   By: Kaine Zhang     Eco: *ss_20090706* */


hide all.

assign
    s0080_1 = "交易提交失败"
    s0080_2 = "采购单: " + sFailNbr + "/" + string(iFailLine)
    s0080_3 = "数量:" + string(decFailQty)
    s0080_5 = sConfirmOrExit
    .
    
display
    sTitle
    s0080_1
    s0080_2
    s0080_3
    s0080_5
with frame f0080.

do on endkey undo, leave:
    s0080 = sConfirm.
    update
        s0080
    with frame f0080
    editing:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        apply lastkey.
    end.
    
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
end.
