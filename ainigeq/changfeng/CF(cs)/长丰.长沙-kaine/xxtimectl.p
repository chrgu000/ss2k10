/* SS - 091112.1 By: Kaine Zhang */


{mfdtitle.i "091112.1"}

define variable sTime as character format "99:99:99" no-undo.
define variable i as integer no-undo.
define variable b1 as logical no-undo.

function time2integer return integer(input s as character) forward.

form
    skip(1)
    sTime colon 15 label "时间"
    xgetdata_seq colon 15 label "顺序"
    xgetdata_trans colon 15 label "转工单"
    skip(1)
with frame a side-labels width 80.
setframelabels(frame a:handle).





repeat on endkey undo, leave
    with frame a:
    set
        sTime
    editing:
        {xxkofmfnp1a.i
            xgetdata_ctrl
            xgetdata_time
            "string(xgetdata_time, 'HH:MM:SS')"
            "input frame a sTime"
        }
        if recno <> ? then
            display
                replace(string(xgetdata_time, "HH:MM:SS"), ":", "") @ sTime
                xgetdata_seq
                xgetdata_trans
                .
    end.
    if sTime = "" then do:
        {pxmsg.i &msgnum = 40 &errorlevel = 3}
        undo, retry.
    end.

    find first xgetdata_ctrl
        where xgetdata_time = time2integer(sTime)
        use-index xgetdata_time
        no-error.
    if not(available(xgetdata_ctrl)) then do:
        {pxmsg.i &msgnum=9013}
        create xgetdata_ctrl.
        xgetdata_time = time2integer(sTime).
    end.
    else
        {pxmsg.i &msgnum=9014}


    update
        xgetdata_seq
        xgetdata_trans
    go-on("F5" "Ctrl-D").

    if lastkey = keycode("F5") or lastkey = keycode("Ctrl-D") then do:
        b1 = no.
        {pxmsg.i &msgnum=11 &confirm=b1}
        if b1 then do:
            delete xgetdata_ctrl.
            clear frame a all no-pause.
            {pxmsg.i &msgnum=9015}
            next.
        end.
    end.

    {pxmsg.i &msgnum=9999}
end.



function time2integer return integer:
    define variable i1 as integer no-undo.
    define variable i2 as integer no-undo.
    define variable i3 as integer no-undo.
    define variable iFuncReturn as integer no-undo.

    assign
        i1 = integer(substring(s, 1, 2))
        i2 = integer(substring(s, 3, 2))
        i3 = integer(substring(s, 5, 2))
        no-error.

    iFuncReturn = i1 * 3600 + i2 * 60 + i3.

    return iFuncReturn.
end function.


