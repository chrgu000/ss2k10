/* xsworjt100040.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 100301.1 By: Roger Xiao */

/* 物料$批号 -- 批号 */
lp0040:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0040.i}
    
    s0040 = sLot.
    
    leave lp0040.
END.

