FOR EACH match_lst WHERE match_sess = mfguser NO-LOCK:

CREATE xxpo_consign.
ASSIGN
    xxpo_conid = NEXT-VALUE(xxpo_seqid)
    xxpo_condt = TODAY
    xxpo_type = 'consume'
    xxpo_nbr = match_nbr
    xxpo_line = match_line
    xxpo_part = INPUT part
    xxpo_vend = mvend
    xxpo_lot = lotser_from
    xxpo_qty = match_qty
    xxpo_price = match_price
    xxpo_disc = match_disc
    xxpo_loc = match_loc
    xxpo_cur = match_cur.

END.

FOR EACH match_lst WHERE match_sess = mfguser NO-LOCK:
    FIND FIRST xxpo_consign WHERE xxpo_conid = match_id EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE xxpo_consign THEN DO:
     ASSIGN
         xxpo_cumconsume_qty = xxpo_cumconsume_qty + match_qty.
     IF xxpo_qty - xxpo_cumconsume_qty <= 0 THEN xxpo_closed = YES.
        END.    
END.

 FOR EACH match_lst WHERE match_sess = mfguser EXCLUSIVE-LOCK:
     DELETE match_lst.
END.
