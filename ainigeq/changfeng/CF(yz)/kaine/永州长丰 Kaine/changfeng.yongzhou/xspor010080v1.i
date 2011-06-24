/* xspor010080v1.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/06/2009   By: Kaine Zhang     Eco: *ss_20090706* */


hide all.

display
    sTitle
with frame f0080_1.

pause 3 before-hide no-message.
do on endkey undo, leave:
    clear frame f0080_2 all no-pause.
    for each t1_tmp no-lock:
        disp t1_nbr t1_line t1_qty t1_rct_nbr with frame f0080_2.
        down with frame f0080_2.
    end.
end.
pause 0 before-hide no-message.

do on endkey undo, retry
    on error undo, retry:
    s0080 = sConfirm.
    display
        sConfirmOrExit @ sMessage
    with frame f0080_3.
    update
        s0080
    with frame f0080_3
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
            with frame f0080_3.
            undo, retry.
        end.
    end.
end.

