/* xsinmov10movevalid.i ---- */
/* Copyright 2011 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 110321.1 By: Kaine Zhang */


find first tr_hist
    no-lock
    where tr_trnbr > iTrSeq
        and tr_type = "ISS-SO"
        and tr_part = sAssemblePart
        and tr_site = s0010
        and tr_loc = s0050
        and tr_qty_loc = -1
        and tr_nbr = s0020
    use-index tr_trnbr
    no-error.

if not(available(tr_hist)) then do on endkey undo, retry:
    hide all.
    display "销售发运失败" format "x(40)" with no-box.
    pause.
    undo detlp, retry detlp.
end.

    