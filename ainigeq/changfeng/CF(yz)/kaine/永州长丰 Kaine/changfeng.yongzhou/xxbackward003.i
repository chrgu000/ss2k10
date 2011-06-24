/* SS - 100512.1 By: Kaine Zhang */

if sWoLot <> "" then do:
    assign
        decWoQtyBefore = 0
        decWoQtyThisLot = 0
        .
    for each tr_hist
        no-lock
        where tr_nbr = sWoNbr
            and tr_lot = sWoLot
            and tr_type = "RCT-WO"
        use-index tr_nbr_eff
        break
        by tr_date
        by tr_trnbr
    :
        if tr_serial = sLot then do:
            decWoQtyThisLot = tr_qty_loc.
            leave.
        end.
        decWoQtyBefore = decWoQtyBefore + tr_qty_loc.
    end.
    
    put
        unformatted
        "��Ʒ����:" at 1      space(1)
        sLot                  space(1)
        "ǰ������:" at 26     space(1)
        string(decWoQtyBefore)   space(1)
        "��������:" at 57          space(1)
        string(decWoQtyThisLot)
        "����Ʒʹ������:" at 1
        "����               ����                     ���� ˵��" at 1
        .

    /* 
     *  block.001.start # 
     *  �����Ͻ��зֽ�,׷��.
     *  ����в�ͬ���������,�Ƚ���ͬ�������ͬ���Ϻϲ�.
     */
    if decWoQtyBefore >= 0 and decWoQtyThisLot > 0 then do:
        for each wod_det
            no-lock
            where wod_lot = sWoLot
            break
            by wod_part
        :
            accumulate wod_qty_req (total by wod_part).
            if last-of(wod_part) then do:
                assign
                    decWodQtyBefore = (accum total by wod_part wod_qty_req) * decWoQtyBefore / decWoQtyOrder
                    decWodQtyThisLot = (accum total by wod_part wod_qty_req) * decWoQtyThisLot / decWoQtyOrder
                    .

                for first pt_mstr
                    no-lock
                    where pt_part = wod_part
                :
                end.
                sWodPtDesc = if available(pt_mstr) then pt_desc1 else "".

                /* ��������֮ǰ��������õĲ���,�۳� */
                for each t1_tmp
                    where t1_part = wod_part
                    break
                    by t1_seq
                :
                    assign
                        dec1 = min(t1_qty, decWodQtyBefore)
                        t1_qty = t1_qty - dec1
                        decWodQtyBefore = decWodQtyBefore - dec1
                        .
                    if decWodQtyBefore <= 0 then leave.
                end.

                /* ��ʾ�������õĲ��� */
                for each t1_tmp
                    where t1_part = wod_part
                        and t1_qty > 0
                    break
                    by t1_seq
                :
                    assign
                        dec1 = min(t1_qty, decWodQtyThisLot)
                        .

                    put
                        t1_part at 1 space(1)
                        t1_lot space(1)
                        dec1 space(1)
                        sWodPtDesc
                        .

                    assign
                        t1_qty = t1_qty - dec1
                        decWodQtyThisLot = decWodQtyThisLot - dec1
                        .
                    if decWodQtyThisLot <= 0 then leave.
                end.
            end.
        end.
    end.
    /*  block.001.finish # */

end.


