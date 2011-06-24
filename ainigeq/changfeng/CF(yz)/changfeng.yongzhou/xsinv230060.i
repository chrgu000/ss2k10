/* xsinv210060.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 数量 */
lp0060:
repeat on endkey undo, retry:
    hide all.
    define variable s0060             as character format "x(50)".
    define variable s0060_1           as character format "x(50)".
    define variable s0060_2           as character format "x(50)".
    define variable s0060_3           as character format "x(50)".
    define variable s0060_4           as character format "x(50)".
    define variable s0060_5           as character format "x(50)".
    define variable dec0060           as decimal no-undo.
    
    form
        sTitle
        s0060_1
        s0060_2
        s0060_3
        s0060_4
        s0060_5
        s0060
        sMessage
    with frame f0060 no-labels no-box.

    assign
        s0060_1 = "数量?"
        s0060_2 = "料品: " + s0020
        s0060_3 = "批号: " + s0030
        s0060_4 = "库位: " + s0040 + "-->" + s0050
        s0060_5 = sPromptMessage
        .
    
    /* SS - 090903.1 - B */
    /* 增加显示信息 # 本批物料库存数量,本库位物料数量 */
    find first pt_mstr no-lock where pt_part = s0020 no-error.
    if available(pt_mstr) then s0060_2 = s0060_2 + " |" + pt_desc1.
    find first ld_det 
        no-lock 
        where ld_site = s0010 
            and ld_loc = s0040 
            and ld_part = s0020 
            and ld_lot = s0030 
            and ld_ref = "" 
        use-index ld_loc_p_lot 
        no-error.
    s0060_4 = s0060_4 + " |" + if available(ld_det) then string(ld_qty_oh) else "0".
    for each ld_det
        no-lock 
        where ld_site = s0010 
            and ld_loc = s0040 
            and ld_part = s0020
        use-index ld_loc_p_lot
    :
        accumulate ld_qty_oh (total).
    end.
    s0060_4 = s0060_4 + " |" + string(accum total ld_qty_oh).
    /* SS - 090903.1 - E */

    display
        sTitle
        s0060_1
        s0060_2
        s0060_3
        s0060_4
        s0060_5
    with frame f0060.
    
    s0060 = "".
    
    update
        s0060
    with frame f0060.
    
    if s0060 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    else do:
        dec0060 = decimal(s0060) no-error.
        if error-status:error then do:
            display
                "数量有误" @ sMessage
            with frame f0060.
            undo, retry.
        end.
        
        if dec0060 = 0 then do:
                display
                "不可转移0数量" @ sMessage
            with frame f0060.
            undo, retry.
        end.
        
        find first ld_det
            no-lock
            where ld_site = s0010
                and ld_loc = s0040
                and ld_part = s0020
                and ld_lot = s0030
                and ld_ref = ""
            no-error.
        if not(available(ld_det)) or ld_qty_oh < dec0060 then do:
            display
                "库存量<" + s0060 @ sMessage
            with frame f0060.
            undo, retry.
        end.
    end.
    
    leave lp0060.
END.

