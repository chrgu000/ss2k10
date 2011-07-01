/* xsbctrhist.i ---- */
/* Copyright 2011 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 110318.1 By: Kaine Zhang */


create xbctr_hist.
{xxfromsequence2unique.i xbctr_sq01 xbctr_seq}
assign
    xbctr_site      = {1}
    xbctr_loc       = {2}
    xbctr_part      = {3}
    xbctr_lot       = {4}
    xbctr_qty_chg   = {5}
    xbctr_refloc    = {6}
    xbctr_type      = {7}
    xbctr_userid    = global_userid
    xbctr_date      = today
    xbctr_time      = time
    xbctr_program   = execname
    xbctr_ref_seq   = {8}
    xbctr_order_nbr = {9}
    xbctr_order_id  = {10}
    xbctr_bc_type   = {11}
    .



