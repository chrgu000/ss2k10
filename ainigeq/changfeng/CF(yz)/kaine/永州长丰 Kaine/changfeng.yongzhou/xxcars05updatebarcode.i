/* SS - 090908.1 By: Kaine Zhang */

update
    sSeat
with frame c
editing:
    {xxkofmfnp2.i
        xcard_det
        xcard_vin_seat
        "xcard_vin = xcar_vin"
        xcard_seat
        "input sSeat"
    }
    if recno <> ? then do:
        display 
            xcard_seat @ sSeat
            xcard_part
            xcard_lot
            xcard_seq
        with frame c.
    end.
end.

if sSeat = "" then do:
    {pxmsg.i &msgnum=9014 &errorlevel=3}
    undo, retry.
end.


find first xcard_det
    where xcard_seat = sSeat
    use-index xcard_seat
    no-error.
if not(available(xcard_det)) then do:
    /* +标记判断 */
    if substring(sSeat, length(sSeat, "RAW"), 1) <> "+" then do:
        {pxmsg.i &msgnum=9015 &errorlevel=3}
        undo, retry.
    end.
    
    /* -标记判断 */
    assign
        sPart = ""
        sLot = ""
        .
    
    assign    
        sPart = entry(1, sSeat, "-")
        sLot = entry(2, sSeat, "-")
        no-error
        .
        
    if error-status:error then do:
        {pxmsg.i &msgnum=9016 &errorlevel=3}
        undo, retry.
    end.
    
    /* 003标记判断. (003是长丰沙发作为股份公司供应商的代码) */
    if substring(sPart, 1, 3) <> "003" then do:
        {pxmsg.i &msgnum=9017 &errorlevel=3}
        undo, retry.
    end.
    
    substring(sPart, 1, 3) = "".
    substring(sLot, length(sLot), 1) = "".

    {pxmsg.i &msgnum=9012}

    create xcard_det.
    assign
        xcard_vin = xcar_vin
        xcard_seat = sSeat
        xcard_part = sPart
        xcard_lot = sLot
        xcard_input_date = today
        xcard_input_time = time
        xcard_input_user = global_userid
        .
    for first pt_mstr
        no-lock
        where pt_part = xcard_part
    :
    end.
    if available(pt_mstr) then xcard_seq = integer(pt_drwg_size) no-error.
end.

if xcard_vin <> xcar_vin then do:
    {pxmsg.i &msgnum = 9018 &errorlevel=3 &msgarg1=xcard_vin}
    undo, retry.
end.

display
    xcard_part
    xcard_lot
    xcard_status
with frame c.
