/* xsshp300080.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 显示收货信息 */
lp0080:
repeat on endkey undo, retry:
    hide all.

    find first tr_hist
        where tr_trnbr > iTrSeq
            and tr_type = "ISS-SO"
            and tr_site = s0010
            and tr_loc = s0050
            and tr_part = s0030
            and tr_serial = s0040
            and tr_nbr = s0020
            and tr_line = iSodLine
        use-index tr_trnbr
        no-error.
    if available(tr_hist) then do:
        assign
            sMessage = s0040 + "发运成功,事务" + string(tr_trnbr)
            tr__chr01 = sCarNumber
            .
    end.
    else do:
        sMessage = s0030 + "座椅发运失败".
    end.

    leave lp0080.
END.

