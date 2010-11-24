/* xxfindso01.i -- */
/* Copyright 201003 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 100619.1 By: Kaine Zhang */


update
    sSoNbr
with frame a
editing:
    {xxkofmfnp2.i
        so_mstr
        so_nbr
        "so_domain = global_domain"
        so_nbr
        "input sSoNbr"
    }
    if recno <> ? then do:
        display
            so_nbr @ sSoNbr
            so_cust
            so__dte01
        with frame a.
    end.
end.

find first so_mstr
    where so_domain = global_domain
        and so_nbr = sSoNbr
    no-error.
if not(available(so_mstr)) then do:
    {pxmsg.i &msgnum = 609 &errorlevel = 3}
    undo, retry.
end.
display
    so_nbr @ sSoNbr
    so_cust
    so__dte01
with frame a.

