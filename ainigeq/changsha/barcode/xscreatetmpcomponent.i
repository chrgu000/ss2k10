/* xscreatecomponent.i ---- */
/* Copyright 2011 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 110321.1 By: Kaine Zhang */



find first xbcass_det
    where xbcass_part = {1}
        and xbcass_lot = {2}
        and xbcass_type = {3}
        and xbcass_order = {4}
        and xbcass_line = {5}
    no-error.

if not(available(xbcass_det)) then do:
    create xbcass_det.
    assign
        xbcass_part             = {1}
        xbcass_lot              = {2}
        xbcass_type             = {3}
        xbcass_order            = {4}
        xbcass_line             = {5}
        .
end.
assign
    xbcass_is_assembled     = no
    xbcass_date             = today
    xbcass_time             = time
    xbcass_flag             = ""
    xbcass_qad_trnbr        = 0
    xbcass_is_temp          = yes
    .








