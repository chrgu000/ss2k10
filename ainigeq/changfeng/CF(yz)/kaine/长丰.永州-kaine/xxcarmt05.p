/* xxcarmt05.p -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 090904.1 By: Kaine Zhang */

{mfdtitle.i "090904.1"}

define variable sVin like xcar_vin no-undo.

form
    sVin            colon 15    label "VIN"
    xcar_type       colon 15    label "Type"
    xcar_ship_to    colon 15    label "ShipTo"
    xcar_sale_date  colon 15    label "Date"
    xcar_company    colon 15    label "Company"
    xcar_name       colon 15    label "Name"
with frame a side-labels width 80.
setframelabels(frame a:handle).




mainloop:
repeat on endkey undo, leave
    with frame a:
    set
        sVin
    editing:
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
                xcar_type     
                xcar_ship_to  
                xcar_sale_date
                xcar_company  
                xcar_name     
                .
        end.
    end.

    find first xcar_mstr
        where xcar_vin = sVin
        no-error.
    if not(available(xcar_mstr)) then do:
        {pxmsg.i &msgnum=9007 &errorlevel=3}
        undo, retry.
    end.

    do on endkey undo mainloop, retry mainloop
        on error undo, retry:
        update
            xcar_type     
            xcar_ship_to  
            xcar_sale_date
            xcar_company  
            xcar_name     
            .
    end.
    {pxmsg.i &msgnum=9999}
end.

