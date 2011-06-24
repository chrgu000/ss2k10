/* xssorjt100080v2.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 100301.1 By: Roger Xiao */


hide all.

assign
    s0080_1 = "�����ύʧ��"
    s0080_2 = "����: " + s0020 + "/" + string(iFailLine)
    s0080_3 = "����:" + string(decFailQty)
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
        {xsreadkeyapply.i}
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
