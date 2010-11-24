/* Copyright 2010 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 100505.1 By: Kaine Zhang */

{mfdtitle.i "100505.1"}


define variable b1 as logical no-undo.

form
    skip(1)
    xrate_rate      colon 15    label "比例"
    xrate_desc      colon 15    label "说明"
    skip(1)
with frame a side-labels width 80.
setframelabels(frame a:handle).




find first xrate_ctrl
    where xrate_domain = global_domain
    no-error.
if available(xrate_ctrl) then display xrate_rate xrate_desc with frame a.

mainloop:
repeat on endkey undo, leave
    with frame a:
    prompt-for
        xrate_rate
    with frame a
    editing:
        {xxkofmfnp2.i
            xrate_ctrl
            xrate_rate
            "xrate_domain = global_domain"
            xrate_rate
            "input xrate_rate"
        }
        if recno <> ? then do:
            display
                xrate_rate
                xrate_desc
                .
        end.
    end.
    

    find first xrate_ctrl
        where xrate_domain = global_domain
        use-index xrate_rate
        no-error.
    if not(available(xrate_ctrl)) then do:
        message "创建新记录".
        create xrate_ctrl.
        assign
            xrate_domain = global_domain
            .
    end.
    else do with frame a:
        message "修改记录".
    end.

    assign
        xrate_rate
        .
    display
        xrate_desc
        .
            
    detailloop:
    do on endkey undo mainloop, retry mainloop
        on error undo, leave
        with frame a:
        set
            xrate_desc
        go-on("F5" "Ctrl-D").

        if lastkey = keycode("F5") or lastkey = keycode("Ctrl-D") then do on endkey undo detailloop, retry detailloop:
            b1 = no.
            {pxmsg.i &msgnum=11 &confirm=b1}
            if b1 then do:
                delete xrate_ctrl.
                clear frame a all no-pause.
                {pxmsg.i &msgnum=39998}
                next mainloop.
            end.
            else
                undo, retry.
        end.
    end.

    message "操作完成".

end.


