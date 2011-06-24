/* xsshp300030.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* ����.���� */
lp0030:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0030.i}


    assign
        s0030_1 = "����$����?"
        s0030_2 = "����/����: " + sSodNbr + "/" + string(iSodLine) + "/" + sSodPart
        s0030_3 = "ɨ��/����: " + string(iScanQty) + "/" + string(decOpenQty)
        s0030_4 = "��λ/���: " + s0050 + "/" + string(s0025, "xx:xx")
        s0030_5 = "˵��: " + sPartDesc
        s0030_6 = sPromptMessage
        .
    
    display
        sTitle
        s0030_1
        s0030_2
        s0030_3
        s0030_4
        s0030_5
        s0030_6
        sMessage
    with frame f0030.

    if not(retry) then s0030 = "".

    update
        s0030
    with frame f0030
    editing:
        {xsreadkey.i}
        if lastkey = keycode("F10")
            or keyfunction(lastkey) = "cursor-down"
        then do:
            if recid(pt_mstr) = ? then
                find first pt_mstr
                    where pt_part >= input s0030
                    use-index pt_part
                    no-lock
                    no-error.
            else
                find next pt_mstr
                    where pt_part >= input s0030
                    use-index pt_part
                    no-lock
                    no-error.
            if available(pt_mstr) then
                display skip
                    pt_part @ s0030
                    pt_desc1 @ sMessage
                with frame f0030.
            else
                display
                    "" @ sMessage
                with frame f0030.
        end.
        else if lastkey = keycode("F9")
            or keyfunction(lastkey) = "cursor-up"
        then do:
            if recid(pt_mstr) = ? then
                find first pt_mstr
                    where pt_part <= input s0030
                    use-index pt_part
                    no-lock
                    no-error.
            else
                find next pt_mstr
                    where pt_part <= input s0030
                    use-index pt_part
                    no-lock
                    no-error.
            if available(pt_mstr) then
                display skip
                    pt_part @ s0030
                    pt_desc1 @ sMessage
                with frame f0030.
            else
                display
                    "" @ sMessage
                with frame f0030.
        end.
        else do:
            apply lastkey.
        end.
    end.

    if s0030 = sExitFlag then do:
        s0030 = sSodPart.
        sMessage = "".
        leave lp0030.
    end.
    else if s0030 = sSpecialExitFlag then do:
        sMessage = "".
        undo mainloop, retry mainloop.
    end.
    else do:
        {xsgetpartlot.i
            s0030
            sPart
            sLot
            sMessage
            f0030
            "lp0030"
            sVendor
        }
        s0030 = sPart.
        
        /* *ss_20090826* ���ϱ����ж� */
        if s0030 <> sSodPart then do:
            sMessage = "�Ǳ���ɨ������".
            undo, retry.
        end.
        /* *ss_20090826* ����Ƿ��ظ�ɨ�� */
        if can-find(first t1_tmp no-lock where t1_lot = sLot) then do:
            sMessage = "�Ѿ�ɨ�������".
            undo, retry.
        end.
        /* *ss_20090826* ɨ���Ƿ񳬳�δ������ */
        if iScanQty + iQty1 > decOpenQty then do:
            sMessage = "�ѳ�������������".
            undo, retry.
        end.
        /* ��������Ƿ��㹻? */
        find first ld_det
            no-lock
            where ld_site = s0010
                and ld_loc = s0050
                and ld_part = s0030
                and ld_lot = sLot
                and ld_ref = ""
            use-index ld_loc_p_lot
            no-error.
        if not(available(ld_det)) then do:
            sMessage = "�������0".
            undo, retry.
        end.
        if ld_qty_oh < iQty1 then do:
            sMessage = "���" + string(ld_qty_oh) + "<" + string(iQty1).
            undo, retry.
        end.
        /* �������������д����ʱ�� */
        create t1_tmp.
        t1_lot = sLot.
        iScanQty = iScanQty + iQty1.
        sMessage = sLot.
    end.
    
    /* *ss_20090826* leave lp0030. */
END.

