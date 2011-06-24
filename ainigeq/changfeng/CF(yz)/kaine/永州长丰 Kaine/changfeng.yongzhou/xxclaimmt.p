/* SS - 090904.1 By: Kaine Zhang */

{mfdtitle.i "090904.1"}

define variable dteClaim as date no-undo.

form
    dteClaim                colon 15    label "Date"
    xclaim_claim            colon 15    label "Claim"
    xclaim_travel_expense   colon 15    label "Travel"
with frame a side-labels width 80.
setframelabels(frame a:handle).

dteClaim = today.




mainloop:
repeat on endkey undo, leave
    with frame a:
    update dteClaim
    editing:
        {xxkofmfnp1a.i
            xclaim_det
            xclaim_date
            xclaim_date
            dteClaim
        }
        if recno <> ? then do:
            display
                xclaim_date @ dteClaim
                xclaim_claim
                xclaim_travel_expense
                .
        end.
    end.

    find first xclaim_det
        where xclaim_date = dteClaim
        no-error.
    if not(available(xclaim_det)) then do:
        create xclaim_det.
        assign
            xclaim_date = dteClaim
            xclaim_input_user = global_userid
            xclaim_input_date = today
            .
    end.

    do on endkey undo mainloop, retry mainloop
        on error undo, retry:
        update
            xclaim_claim
            xclaim_travel_expense
            .
    end.
end.
