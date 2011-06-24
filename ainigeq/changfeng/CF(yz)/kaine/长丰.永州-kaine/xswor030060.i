/* xswor100060.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 数量 */
lp0060:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0060.i}
    
    define variable dec0060           as decimal no-undo.
    
    find first wo_mstr 
        where wo_lot = s0020
            and wo_site = s0010
            and (wo_status = "R" or wo_status = "A")
        use-index wo_lot
        no-lock 
        no-error.
    if not(available(wo_mstr)) then do:
        sMessage = "单号或地点或状态无效".
        undo mainloop, retry mainloop.
    end.
    
    s0060 = "1".
    dec0060 = 1.
    
    /* *ss_20090824* 超收判断 */
    {xswor030060i01.i}
    
    leave lp0060.
END.

