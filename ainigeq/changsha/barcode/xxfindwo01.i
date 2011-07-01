/* xxfindwo01.i -- */
/* Copyright 201002 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */

define variable sTempX20100225WoNbr as character no-undo.
define variable sTempX20100225WoLot as character no-undo.

prompt-for wo_nbr wo_lot
editing:
    if frame-field = "wo_nbr" then do:
        /* FIND NEXT/PREVIOUS RECORD */
        {mfnp.i
            wo_mstr
            wo_nbr
            wo_nbr
            wo_nbr
            wo_nbr
            wo_nbr
        }
        sTempX20100225WoNbr = input wo_nbr.
    end.
    else if frame-field = "wo_lot" then do:
        /* FIND NEXT/PREVIOUS RECORD */
        if sTempX20100225WoNbr = "" then do:
            {mfnp.i
                wo_mstr
                wo_lot
                wo_lot
                wo_nbr
                wo_nbr
                wo_lot
            }
        end.
        else do:
            {mfnp01.i
                wo_mstr
                wo_lot
                wo_lot
                sTempX20100225WoNbr
                wo_nbr
                wo_nbr
            }
        end.
    end.
    else do:
        readkey.
        apply lastkey.
    end.

    if recno <> ? then do:
        find first pt_mstr  where  pt_part = wo_part no-lock no-error.
        display
            wo_nbr
            wo_lot
            wo_part
            (if available(pt_mstr) then pt_desc1 else "") @ pt_desc1
            (if available(pt_mstr) then pt_desc2 else "") @ pt_desc2
            wo_site
            wo_status
            wo_qty_ord
            wo_qty_comp
            wo_qty_rjct
            .
    end.
end. /* EDITING */

sTempX20100225WoNbr = input wo_nbr.
sTempX20100225WoLot = input wo_lot.

if sTempX20100225WoNbr = "" and sTempX20100225WoLot = "" then undo, retry.

if sTempX20100225WoNbr <> "" and sTempX20100225WoLot <> "" then
    find first wo_mstr
        no-lock
        use-index wo_lot
        using wo_lot and wo_nbr
        no-error.
else if sTempX20100225WoNbr = "" and sTempX20100225WoLot <> "" then
    find first wo_mstr
        no-lock
        use-index wo_lot
        using wo_lot
        no-error.
else if sTempX20100225WoNbr <> "" and sTempX20100225WoLot = "" then
    find first wo_mstr
        no-lock
        use-index wo_nbr
        using wo_nbr
        no-error.

if not(available(wo_mstr)) then do:
    if sTempX20100225WoNbr <> "" and sTempX20100225WoLot <> "" then
        if can-find(first wo_mstr no-lock using wo_lot) then do:
            /* LOT NUMBER ENTERED BELONGS TO DIFFERENT WORK ORDER. */
            {pxmsg.i &MSGNUM=508 &ERRORLEVEL=3}
            next-prompt wo_lot.
            undo, retry.
        end.

    if sTempX20100225WoNbr <> "" then
        if not(can-find(first wo_mstr using wo_nbr )) then do:
            /* WORK ORDER NUMBER DOES NOT EXIST. */
            {pxmsg.i &MSGNUM=503 &ERRORLEVEL=3}
            undo, retry.
        end.

    if sTempX20100225WoLot <> "" then
        if can-find(first wo_mstr no-lock using wo_lot ) then do:
            /* LOT NUMBER DOES NOT EXIST. */
            {pxmsg.i &MSGNUM=509 &ERRORLEVEL=3}
            undo, retry.
        end.

    /* WORK ORDER DOES NOT EXIST. */
    {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3}
    undo, retry.
end.

if wo_type = "C" and wo_nbr = "" then do:
    {pxmsg.i &MSGNUM=5123 &ERRORLEVEL=3}
    undo, retry.
end.

/* Word Order type is flow */
if wo_type = "w" then do:
    {pxmsg.i &MSGNUM=5285 &ERRORLEVEL=3}
    undo, retry.
end.

/* DO NOT ALLOW SPLIT OF PROJECT ACTIVITY REC. WORK ORDERS */
if wo_fsm_type = "PRM" then do:
    /* CONTROLLED BY PRM MODULE */
    {pxmsg.i &MSGNUM=3426 &ERRORLEVEL=3}
    undo, retry.
end.

if wo_status = "C" then do:
    /* STATUS IS CLOSED */
    {pxmsg.i &MSGNUM=176 &ERRORLEVEL=3}
    undo, retry.
end.

/* DO NOT ALLOW SPLIT OF CALL ACTIVITY REC. WORK ORDERS */
if wo_fsm_type = "FSM-RO" then do:
    /* FIELD SERVICE CONTROLLED */
    {pxmsg.i &MSGNUM=7492 &ERRORLEVEL=3}
    undo, retry.
end.

{gprun.i
    ""gpsiver.p""
    "(
        input wo_site,
        input ?,
        output return_int
    )"
}
if return_int = 0 then do:
    /* USER DOES NOT HAVE ACCESS TO SITE XXXX */
    {pxmsg.i &MSGNUM=2710 &ERRORLEVEL=3 &MSGARG1=wo_site}
    undo, retry.
end.

find first pt_mstr  where pt_part = wo_part no-lock no-error.
display
    wo_nbr
    wo_lot
    wo_part
    (if available(pt_mstr) then pt_desc1 else "") @ pt_desc1
    (if available(pt_mstr) then pt_desc2 else "") @ pt_desc2
    wo_site
    wo_status
    wo_qty_ord
    wo_qty_comp
    wo_qty_rjct
    .

