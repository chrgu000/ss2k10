/* xsshp300030.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 物料.批号 */
lp0030:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0030.i}


    assign
        s0030_1 = "物料$批号?"
        s0030_2 = "单号/物料: " + sSodNbr + "/" + string(iSodLine) + "/" + sSodPart
        s0030_3 = "扫描/待发: " + string(iScanQty) + "/" + string(decOpenQty)
        s0030_4 = "库位/标记: " + s0050 + "/" + string(s0025, "xx:xx")
        s0030_5 = "说明: " + sPartDesc
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
        
        /* *ss_20090826* 物料编码判断 */
        if s0030 <> sSodPart then do:
            sMessage = "非本次扫描物料".
            undo, retry.
        end.
        /* *ss_20090826* 检查是否重复扫描 */
        if can-find(first t1_tmp no-lock where t1_lot = sLot) then do:
            sMessage = "已经扫描的条码".
            undo, retry.
        end.
        /* *ss_20090826* 扫描是否超出未完数量 */
        if iScanQty + iQty1 > decOpenQty then do:
            sMessage = "已超出待发运数量".
            undo, retry.
        end.
        /* 库存数量是否足够? */
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
            sMessage = "库存数量0".
            undo, retry.
        end.
        if ld_qty_oh < iQty1 then do:
            sMessage = "库存" + string(ld_qty_oh) + "<" + string(iQty1).
            undo, retry.
        end.
        /* 将本条码的批号写入临时表 */
        create t1_tmp.
        t1_lot = sLot.
        iScanQty = iScanQty + iQty1.
        sMessage = sLot.
    end.
    
    /* *ss_20090826* leave lp0030. */
END.

