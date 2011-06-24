/* SS - 090904.1 By: Kaine Zhang */

do on endkey undo detailloop, retry detailloop:
    update
        xmt_reason           
        xmt_solution         
        xmt_material_cost    
        xmt_travel_expense   
        xmt_transport_expense
    go-on("F5" "Ctrl-D")
    with frame c.

    if lastkey = keycode("F5") or lastkey = keycode("Ctrl-D") then do:
        b1 = no.
        {pxmsg.i &msgnum=11 &confirm=b1}
        if b1 then do:
            delete xmt_hist.
            clear frame c.
            next detailloop.
        end.
    end.
end.
