/* SS - 091112.1 By: Kaine Zhang */


{mfdtitle.i "091112.1"}

define variable sSerial like xcsser_serial no-undo.
define variable b1 as logical no-undo.

form
    skip(1)
    sSerial colon 15 label "客户车型代号"
    xcsser_part colon 15 label "物料"
    xcsser_desc colon 15 label "说明"
    skip(1)
with frame a side-labels width 80.
setframelabels(frame a:handle).





repeat on endkey undo, leave
    with frame a:
    set
        sSerial
    editing:
        {xxkofmfnp1a.i
            xcsser_mstr
            xcsser_serial
            xcsser_serial
            "input sSerial"
        }
        if recno <> ? then
            display
                xcsser_serial @ sSerial
                xcsser_part
                xcsser_desc
                .
    end.
    if sSerial = "" then do:
        {pxmsg.i &msgnum = 40 &errorlevel = 3}
        undo, retry.
    end.

    find first xcsser_mstr
        where xcsser_serial = sSerial
        use-index xcsser_serial
        no-error.
    if not(available(xcsser_mstr)) then do:
        {pxmsg.i &msgnum=9013}
        create xcsser_mstr.
        xcsser_serial = sSerial.
    end.
    else
        {pxmsg.i &msgnum=9014}


    update
        xcsser_part
        xcsser_desc
    go-on("F5" "Ctrl-D").

    if lastkey = keycode("F5") or lastkey = keycode("Ctrl-D") then do:
        b1 = no.
        {pxmsg.i &msgnum=11 &confirm=b1}
        if b1 then do:
            delete xcsser_mstr.
            clear frame a all no-pause.
            {pxmsg.i &msgnum=9015}
            next.
        end.
    end.

    {pxmsg.i &msgnum=9999}
end.




