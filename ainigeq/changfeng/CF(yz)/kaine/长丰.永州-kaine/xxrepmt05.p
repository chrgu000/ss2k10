/* xxrepmt05.p -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 090904.1 By: Kaine Zhang */

{mfdtitle.i "090904.1"}

define variable sVin like xcar_vin no-undo.
define variable i as integer no-undo.
define variable b as logical no-undo.
define variable b1 as logical no-undo.
define variable sBarcode like xcard_seat extent 8 no-undo.
define variable dteRepair as date no-undo.

form
    sVin            colon 10    label "VIN"
    sBarcode[1]     colon 10    label "Seat"
    sBarcode[2]     no-labels
    sBarcode[3]     colon 10    label "Seat"
    sBarcode[4]     no-labels
    sBarcode[5]     colon 10    label "Seat"
    sBarcode[6]     no-labels
    sBarcode[7]     colon 10    label "Seat"
    sBarcode[8]     no-labels
with frame a side-labels width 80 title gettermlabel("ss_zlgl_000018", 20).
setframelabels(frame a:handle).

form
    xcar_type       colon 10    label "Type"
    xcar_ship_to    colon 10    label "ShipTo"
    xcar_sale_date  colon 10    label "Date"
    xcar_company    colon 10    label "Company"
    xcar_name       colon 10    label "Name"
with frame b side-labels width 80 title gettermlabel("ss_zlgl_000016", 20).
setframelabels(frame b:handle).

form
    dteRepair               colon 10    label "Date"
    xmt_reason              colon 10    label "Reason"
    xmt_solution            colon 10    label "Solution"
    xmt_material_cost       colon 10    label "Material"
    xmt_travel_expense      colon 10    label "Travel"
    xmt_transport_expense   colon 10    label "Transport"
with frame c side-labels width 80 title gettermlabel("ss_zlgl_000017", 20).
setframelabels(frame c:handle).



mainloop:
repeat on endkey undo, leave:
    view frame a.
    view frame b.

    set
        sVin
        sBarcode[1]
    with frame a
    editing:
        if frame-field = "sVin" then do:
            {mfnp.i
                xcar_mstr
                sVin
                xcar_vin
                sVin
                xcar_vin
                xcar_vin
            }
            if recno <> ? then do:
                display
                    xcar_vin @ sVin
                with frame a.
                display
                    xcar_type     
                    xcar_ship_to  
                    xcar_sale_date
                    xcar_company  
                    xcar_name     
                with frame b.
                {xxrepmt05viewbc.i}
            end.
        end.
        else if frame-field = "sBarcode[1]" then do:
            {mfnp.i
                xcard_det
                sBarcode[1]
                xcard_seat
                sBarcode[1]
                xcard_seat
                xcard_seat
            }
            if recno <> ? then do:
                find first xcar_mstr no-lock where xcar_vin = xcard_vin no-error.
                if available(xcar_mstr) then do:
                    display
                        xcar_vin @ sVin
                    with frame a.

                    display
                        xcar_type     
                        xcar_ship_to  
                        xcar_sale_date
                        xcar_company  
                        xcar_name     
                    with frame b.
                    {xxrepmt05viewbc.i}
                end.
            end.
        end.
        else do:
            readkey.
            apply lastkey.
        end.
    end.

    /* block.001.start # check input data. validate */
    if sVin = "" and sBarcode[1] = "" then do:
        {pxmsg.i &msgnum=9008 &errorlevel=3}
        undo, retry.
    end.
    else if sVin = "" and sBarcode[1] <> "" then do:
        find first xcard_det
            no-lock
            where xcard_seat = sBarcode[1]
            use-index xcard_seat
            no-error.
        if not(available(xcard_det)) then do:
            {pxmsg.i &msgnum=9009 &errorlevel=3}
            next-prompt sBarcode[1] with frame a.
            undo, retry.
        end.
        if xcard_status <> "" then do:
            {pxmsg.i &msgnum=9010 &errorlevel=3}
            next-prompt sBarcode[1] with frame a.
            undo, retry.
        end.

        find first xcar_mstr
            no-lock
            where xcar_vin = xcard_vin
            no-error.
        if not(available(xcar_mstr)) then do:
            {pxmsg.i &msgnum=9007 &errorlevel=3}
            undo, retry.
        end.
        sVin = xcar_vin.
    end.
    else if sVin <> "" and sBarcode[1] = "" then do:
        find first xcar_mstr
            no-lock
            where xcar_vin = sVin
            no-error.
        if not(available(xcar_mstr)) then do:
            {pxmsg.i &msgnum=9007 &errorlevel=3}
            undo, retry.
        end.
    end.
    else do:
        find first xcar_mstr
            no-lock
            where xcar_vin = sVin
            no-error.
        if not(available(xcar_mstr)) then do:
            {pxmsg.i &msgnum=9007 &errorlevel=3}
            undo, retry.
        end.

        find first xcard_det
            no-lock
            where xcard_seat = sBarcode[1]
            use-index xcard_seat
            no-error.
        if not(available(xcard_det)) then do:
            {pxmsg.i &msgnum=9009 &errorlevel=3}
            next-prompt sBarcode[1] with frame a.
            undo, retry.
        end.
        if xcard_status <> "" then do:
            {pxmsg.i &msgnum=9010 &errorlevel=3}
            next-prompt sBarcode[1] with frame a.
            undo, retry.
        end.

        if xcard_vin <> xcar_vin then do:
            {pxmsg.i &msgnum = 9011 &errorlevel=3}
            undo, retry.
        end.
    end.
    
    display
        sVin
    with frame a.
    display
        xcar_type     
        xcar_ship_to  
        xcar_sale_date
        xcar_company  
        xcar_name     
    with frame b.
    {xxrepmt05viewbc.i} /* show information */
    /* block.001.finish # check input data. validate */

    b = yes.
    {pxmsg.i &msgnum=12 &Confirm=b}

    if b then do:
        hide frame b no-pause.
        clear frame c all no-pause.
        view frame c.

        dteRepair = today.
    end.

    if b then 
    detailloop:
    repeat on endkey undo, leave
        on error undo, retry:
        {xxrepmt05updatedate.i}

        {xxrepmt05updaterepair.i}
    end.
    hide frame c no-pause.

    {pxmsg.i &msgnum=9999}
end.

