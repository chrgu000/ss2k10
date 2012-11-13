/* SS - 101201.1 By: Kaine Zhang */

find last tr_hist
    no-lock
    where tr_domain = global_domain
        and tr_date >= today
    use-index tr_date_trn
    no-error.
if available(tr_hist) then
    assign
        dteTrDate = tr_date
        iTrSeq = tr_trnbr
        .

