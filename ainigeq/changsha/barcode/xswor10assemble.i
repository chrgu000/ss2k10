/* xswor10assemble.i ---- */
/* Copyright 2011 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 110321.1 By: Kaine Zhang */

/*
 * {1} Parent part
 * {2} Ps date
 * {3} Transaction Type
 * {4} Order
 * {5} Line
 * {6} Assemble Flag
 * {7} Assemble succeed / failed
 * {8} Loop flag
 */

{7} = no.

{8}:
do on error undo, leave:
    for each ps_mstr
        no-lock
        where ps_par = {1}
            and (ps_start <= {2} or ps_start = ?)
            and (ps_end >= {2} or ps_end = ?)
            and ps_ps_code = "X"
            and ps_qty_per > 0
        use-index ps_parcomp
        break
        by ps_comp
    :
        for each xbcass_det
            where xbcass_type = {3}
                and xbcass_order = {4}
                and xbcass_line = {5}
                and xbcass_part = ps_comp
                and not(xbcass_is_assembled)
            use-index xbcass_type_order_part
            break
            by xbcass_date
            by xbcass_time
        :
            assign
                xbcass_is_assembled = yes.
                xbcass_flag = {6}
                .
            accumulate xbcass_part (count).
            if (accum count xbcass_part) >= ps_qty_per then leave.
        end.
        
        if (accum count xbcass_part) < ps_qty_per then do:
            undo {8}, leave {8}.
        end.
    end.
    
    {7} = yes.
end.

