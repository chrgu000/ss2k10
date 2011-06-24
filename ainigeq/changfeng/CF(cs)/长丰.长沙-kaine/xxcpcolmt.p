/* SS - 091112.1 By: Kaine Zhang */


{mfdtitle.i "091112.1"}

define variable sColor like xcscolor_color no-undo.
define variable b1 as logical no-undo.

form
    skip(1)
    sColor colon 15 label "客户颜色"
    xcscolor_part colon 15 label "物料"
    xcscolor_desc colon 15 label "说明"
    skip(1)
with frame a side-labels width 80.
setframelabels(frame a:handle).





repeat on endkey undo, leave
    with frame a:
    set
        sColor
    editing:
        {xxkofmfnp1a.i
            xcscolor_mstr
            xcscolor_color
            xcscolor_color
            "input sColor"
        }
        if recno <> ? then
            display
                xcscolor_color @ sColor
                xcscolor_part
                xcscolor_desc
                .
    end.
    if sColor = "" then do:
        {pxmsg.i &msgnum = 40 &errorlevel = 3}
        undo, retry.
    end.

    find first xcscolor_mstr
        where xcscolor_color = sColor
        use-index xcscolor_color
        no-error.
    if not(available(xcscolor_mstr)) then do:
        {pxmsg.i &msgnum=9013}
        create xcscolor_mstr.
        xcscolor_color = sColor.
    end.
    else
        {pxmsg.i &msgnum=9014}

    update
        xcscolor_part
        xcscolor_desc
    go-on("F5" "Ctrl-D").

    if lastkey = keycode("F5") or lastkey = keycode("Ctrl-D") then do:
        b1 = no.
        {pxmsg.i &msgnum=11 &confirm=b1}
        if b1 then do:
            delete xcscolor_mstr.
            clear frame a all no-pause.
            {pxmsg.i &msgnum=9015}
            next.
        end.
    end.

    {pxmsg.i &msgnum=9999}
end.




