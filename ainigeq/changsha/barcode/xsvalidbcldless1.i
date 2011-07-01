/* xsvalidbcld.i ----                                                        */
/* Copyright 2011 SoftSpeed gz                                               */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* SS - 110318.1 By: Kaine Zhang                                             */

find first xbcld_det
    no-lock
    where xbcld_site = {1}
        and xbcld_loc = {2}
        and xbcld_part = {3}
        and xbcld_lot = {4}
    no-error.
if not(available(xbcld_det))
    or xbcld_qty_oh < 1
then do:
    display
        "���������" @ {5}
    with frame {6}.
    undo {7}, retry {7}.
end.
