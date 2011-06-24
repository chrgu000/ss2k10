/* xspor010070.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* ȷ�� */
lp0070:
repeat on endkey undo, retry:
    hide all.
    define variable s0070             as character format "x(50)".
    define variable s0070_1           as character format "x(50)".
    define variable s0070_2           as character format "x(50)".
    define variable s0070_3           as character format "x(50)".
    define variable s0070_4           as character format "x(50)".
    define variable s0070_5           as character format "x(50)".
    define variable s0070_6           as character format "x(50)".

    form
        sTitle
        s0070_1
        s0070_2
        s0070_3
        s0070_4
        s0070_5
        s0070_6
        s0070
        sMessage
    with frame f0070 no-labels no-box.

    assign
        s0070_1 = "��Ʒ: " + s0020
        s0070_2 = "����: " + s0030
        s0070_3 = "��λ: " + s0050
        s0070_5 = "�ջ�����: " + s0060
        s0070_6 = sConfirmOrExit
        .
    /* SS - 090710.1 - B
    find first ld_det
        no-lock
        where ld_site = s0010
            and ld_loc = s0050
            and ld_part = s0020
            and ld_lot = s0030
            and ld_ref = ""
        use-index ld_loc_p_lot
        no-error.
    s0070_4 = "���: " + if available(ld_det) then string(ld_qty_oh) else "0".
    SS - 090710.1 - E */
    
    /* SS - 090710.1 - B */
    for each ld_det
        no-lock
        where ld_site = s0010
            and ld_loc = s0050
            and ld_part = s0020
        use-index ld_loc_p_lot
    :
        accumulate ld_qty_oh (total).
    end.
    s0070_4 = "���: " + string(accum total ld_qty_oh).
    /* SS - 090710.1 - E */
    
    
    display
        sTitle
        s0070_1
        s0070_2
        s0070_3
        s0070_4
        s0070_5
        s0070_6
    with frame f0070.

    s0070 = sConfirm.

    update
        s0070
    with frame f0070
    editing:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        apply lastkey.
    end.

    if s0070 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    else do:
        if s0070 <> sConfirm then do:
            display
                sConfirmOrExit @ sMessage
            with frame f0070.
            undo, retry.
        end.
    end.
    
    /* *ss_20090706* block.001.start # ����Ƿ񳬹�δ������,���ֽ�Ϊһ�����Ĵ��ջ���ʱ�� */
    sMessage = "".
    empty temp-table t1_tmp.
    for each po_mstr
        no-lock
        where po_vend = s0040
            and po_stat = ""
        use-index po_vend
        ,
    each pod_det
        no-lock
        where pod_nbr = po_nbr
            and pod_part = s0020
            and pod_status = ""
            and pod_qty_ord > 0
            and pod_qty_ord - pod_qty_rcvd > 0
        use-index pod_nbrln
    :
        create t1_tmp.
        assign
            t1_nbr = pod_nbr
            t1_line = pod_line
            t1_qty = min((pod_qty_ord - pod_qty_rcvd), dec0060_1)
            .
        dec0060_1 = dec0060_1 - t1_qty.
        if dec0060_1 <= 0 then leave.
    end.
    
    
    if dec0060_1 > 0 then do:
        sMessage = "��������<" + s0060.
        display
            "��������<" + s0060 @ sMessage
        with frame f0070.
        undo lp-qty-yn, retry lp-qty-yn.
    end.
    
    /*
     * �����ɹ���ʱ,��ʾ�û�.����,�����ҵ�һ���ɹ����Ƿ�ʹ��.
     * ��Ϊ����,�ȿ��Ա���󲿷ֵ��������,�ֲ���ʹ�úܷ������ж��ֶ�.
     */
    find first t1_tmp no-lock no-error.
    if not(available(t1_tmp)) then do:
        display
            "û�д��ջ��Ĳɹ�����ɹ�������" @ sMessage
        with frame f0070.
        undo lp-qty-yn, retry lp-qty-yn.
    end.
    
    find first po_mstr
        exclusive-lock
        where po_nbr = t1_nbr
        no-error.
    if not(available(po_mstr)) then do:
        display
            "�ɹ���" + t1_nbr + "����" @ sMessage
        with frame f0070.
        undo lp-qty-yn, retry lp-qty-yn.
    end.
    /* *ss_20090706* block.001.finish # ����Ƿ񳬹�δ������,���ֽ�Ϊһ�����Ĵ��ջ���ʱ�� */
    
    leave lp0070.
END.

