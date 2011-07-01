/* xsbcldtrans.i ---- */
/* Copyright 2011 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 110318.1 By: Kaine Zhang */


find first xbcld_det
    where xbcld_site     = {1}
        and xbcld_loc    = {2}
        and xbcld_part   = {3}
        and xbcld_lot    = {4}
    no-error.
if not(available(xbcld_det)) then do:
    create xbcld_det.
    assign
        xbcld_site  = {1}
        xbcld_loc   = {2}
        xbcld_part  = {3}
        xbcld_lot   = {4}
        xbcld_date  = today
        .
end.
    assign
        xbcld_qty_oh = xbcld_qty_oh + {5}
        xbcld_refloc = {6}
        .



