/* SS - 101130.1 By: Kaine Zhang */

find first tr_hist
    no-lock
    where tr_domain = global_domain
        and tr_date >= dteTrDate
        and tr_trnbr > iTrSeq
        and tr_type = "RJCT-WO"
        and tr_lot = sWoLot
        and tr_site = sSite
        and tr_rmks = mfguser
        and tr_qty_short = decReject
    use-index tr_trnbr
    no-error.

iCimMsgNum = if available(tr_hist) then 30045 else 30046.
{pxmsg.i &msgnum = iCimMsgNum}

do on endkey undo, retry:
    pause 1 no-message.
end.

