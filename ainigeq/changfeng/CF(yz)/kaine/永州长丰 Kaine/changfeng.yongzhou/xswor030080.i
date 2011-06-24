/* xswor030080.i -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 显示信息 */
lp0080:
repeat on endkey undo, retry:
    find first tr_hist
        no-lock
        where tr_trnbr > iTrSeq
            and tr_type = "RCT-WO"
            and tr_site = s0010
            and tr_loc = s0050
            and tr_serial = s0040
            and tr_qty_loc = dec0060
            and tr_rmks = mfguser
        use-index tr_trnbr
        no-error.
        

    if available(tr_hist) then
        assign
            sMessage = "工单入库事务成功," + string(tr_trnbr)
            .
    else
        assign
            sMessage = "工单入库事务失败"
            .
    
    leave lp0080.
END.

