/* SS - 090908.1 By: Kaine Zhang */

do on endkey undo detailloop, retry detailloop:
    update
        xcard_seq
        xcard_status
    go-on("F5" "Ctrl-D")
    with frame c.

    if lastkey = keycode("F5") or lastkey = keycode("Ctrl-D") then do:
        b1 = no.
        {pxmsg.i &msgnum=11 &confirm=b1}
        if b1 then do:
            delete xcard_det.
            clear frame c all no-pause.
            for each xcard_det
                no-lock
                where xcard_vin = xcar_vin
            :
                display
                    xcard_seat @ sSeat
                    xcard_part
                    xcard_lot
                    xcard_status
                with frame c.
                down with frame c.
            end.
            next detailloop.
        end.
    end.
    down with frame c.
end.
