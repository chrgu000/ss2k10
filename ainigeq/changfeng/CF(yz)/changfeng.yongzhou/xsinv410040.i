/* xsinv410040.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 物料$批号 -- 批号 */
lp0040:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0040.i}
    
    s0040 = sLot.
    
    leave lp0040.
END.

