/* SS - 100512.1 By: Kaine Zhang */


for first tr_hist
    no-lock
    where tr_serial = sLot
        and tr_type = "RCT-WO"
        and tr_part = sWoPart
    use-index tr_serial
:
end.
if available(tr_hist) then do:
    for first wo_mstr
        no-lock
        where wo_nbr = tr_nbr
            and wo_lot = tr_lot
        use-index wo_nbr
    :
    end.
    if available(wo_mstr) then
        assign
            sWoNbr = wo_nbr
            sWoLot = wo_lot
            decWoQtyOrder = wo_qty_ord
            .
    else
        assign
            sWoNbr = ""
            sWoLot = ""
            decWoQtyOrder = 0
            .
end.

put
    unformatted
    "工单:" at 1  space(1)
    sWoNbr        space(1)
    "ID:" at 32   space(1)
    sWoLot        space(1)
    "需求数量:" at 57  space(1)
    string(decWoQtyOrder)
    .

if sWoLot <> "" then do:
    put
        "本工单使用物料:" at 1
        "物料               地点     库位     批号                     数量 说明" at 1
        .

    for each tr_hist
        no-lock
        where tr_nbr = sWoNbr
            and tr_lot = sWoLot
            and tr_type = "ISS-WO"
        use-index tr_nbr_eff
        ,
    first pt_mstr
        no-lock
        where pt_part = tr_part
        break
        by tr_date
        by tr_trnbr
    :
        put
            tr_part at 1                                space(1)
            tr_site                                     space(1)
            tr_loc                                      space(1)
            tr_serial                                   space(1)
            (- tr_qty_loc) format "->>>,>>9.9<<"        space(1)
            pt_desc1
            .
        create t1_tmp.
        assign
            t1_seq = tr_trnbr
            t1_part = tr_part
            t1_lot = tr_serial
            t1_ref = tr_ref
            t1_qty = - tr_qty_loc
            .
    end.
    put skip(1).
end.

