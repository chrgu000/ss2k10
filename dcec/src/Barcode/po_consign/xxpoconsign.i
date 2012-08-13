CREATE xxpo_consign.
ASSIGN
    xxpo_conid = NEXT-VALUE(xxpo_seqid)
    xxpo_condt = TODAY
    xxpo_type = 'consign'
    xxpo_nbr = nbr
    xxpo_line = mline
    xxpo_part = INPUT part
    xxpo_vend = mvend
    xxpo_lot = lotser_from
    xxpo_qty = lotserial_qty
    xxpo_price = mprice
    xxpo_disc = mdisc
    xxpo_loc = loc_from
    xxpo_cur = mcur.
