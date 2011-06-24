/* SS - 090904.1 By: Kaine Zhang */

update
    dteRepair
with frame c
editing:
    {xxkofmfnp2.i
        xmt_hist
        xmt_vin_date
        "xmt_vin = xcar_vin"
        xmt_date
        "input dteRepair" 
    }
    if recno <> ? then do:
        display 
            xmt_date @ dteRepair 
            xmt_reason           
            xmt_solution         
            xmt_material_cost    
            xmt_travel_expense   
            xmt_transport_expense
        with frame c.
    end.
end.

find first xmt_hist
    where xmt_vin = xcar_vin
        and xmt_date = dteRepair
    use-index xmt_vin_date
    no-error.
if not(available(xmt_hist)) then do:
    create xmt_hist.
    assign
        xmt_vin = xcar_vin
        xmt_date = dteRepair
        xmt_input_user = global_userid
        xmt_input_date = today
        .
end.

