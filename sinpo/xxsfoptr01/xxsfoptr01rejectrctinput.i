/* SS - 101130.1 By: Kaine Zhang */

define variable sSite like loc_site no-undo.
define variable sLoc like loc_loc no-undo.


assign
    sSite = global_site
    sLoc = global_loc
    .

form
    total_rej       colon 15    label "废品"
    sSite           colon 15    label "地点"
    sLoc            colon 15    label "库位"
with frame frmReject overlay center width 60 side-labels.
setframelabels(frame frmReject:handle).

view frame frmReject.
display
    total_rej
    sSite
    sLoc
with frame frmReject.

do on error undo, retry:
    update
        sSite
        sLoc
    with frame frmReject.

    for first loc_mstr
        no-lock
        where loc_domain = global_domain
            and loc_site = sSite
            and loc_loc = sLoc
    :
    end.
    if not(available(loc_mstr)) then do:
        {pxmsg.i &msgnum = 229}
        undo, retry.
    end.
end.


hide frame frmReject no-pause.


