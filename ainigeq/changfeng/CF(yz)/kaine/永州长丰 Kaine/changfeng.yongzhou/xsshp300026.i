/* xsshp300026.i -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 08/24/2009   By: Kaine Zhang     Eco: *ss_20090824* */


/* 对比用的,物料编码 */
lp0026:
repeat on endkey undo, retry:
    hide all.
    
    define variable s0026   as character format "x(50)" no-undo.
    define variable s0026_1 as character format "x(50)" no-undo.
    define variable s0026_2 as character format "x(50)" no-undo.
    define variable s0026_3 as character format "x(50)" no-undo.
    define variable s0026_4 as character format "x(50)" no-undo.
    define variable s0026_5 as character format "x(50)" no-undo.
    define variable s0026_6 as character format "x(50)" no-undo.
    define variable s0026_7 as character format "x(50)" no-undo.
    define variable s0026_8 as character format "x(50)" no-undo.
    
    form
        sTitle
        s0026_1
        s0026_2
        s0026_3
        s0026_4
        s0026_5
        s0026_6
        s0026
        sMessage
    with frame f0026 no-labels no-box.

    
    assign
        s0026_1 = "物料编码标准?"
        s0026_6 = sPromptMessage
        .
    
    display
        sTitle
        s0026_1
        s0026_2
        s0026_3
        s0026_4
        s0026_5
        s0026_6
        sMessage
    with frame f0026.
    
    
    update
        s0026
    with frame f0026
    editing:
        {xsreadkeyapply.i}
    end.
    
    if s0026 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    else do:
        {xsgetpartlot.i
            s0026
            sPart
            sLot
            sMessage
            f0026
            "lp0026"
            sVendor
        }
        s0026 = sPart.
        find first sod_det
            exclusive-lock
            where sod_part = s0026
                and sod_nbr = s0020
                and sod_confirm
                and sod_qty_ord > 0
                and sod_qty_ord - sod_qty_ship >= 1
            use-index sod_part
            no-error.
        if not(available(sod_det)) then do:
            sMessage = "未发现已确认的订单物料".
            undo, retry.
        end.
        /* *ss_20090826* block.001.start # 初始化扫描信息,待显示信息 */
        assign
            sSodNbr = s0020
            iSodLine = sod_line
            sSodPart = sod_part
            decOpenQty = sod_qty_ord - sod_qty_ship
            iScanQty = 0
            .
        find first pt_mstr
            no-lock
            where pt_part = sod_part
            no-error.
        if not(available(pt_mstr)) then do:
            sMessage = "未发现物料编码".
            undo, retry.
        end.
        assign
            sPartDesc = pt_desc1 + pt_desc2
            .
        empty temp-table t1_tmp.
        /* *ss_20090826* block.001.finish # 初始化扫描信息,待显示信息 */
    end.
    
    sMessage = "".
    leave lp0026.
END.



