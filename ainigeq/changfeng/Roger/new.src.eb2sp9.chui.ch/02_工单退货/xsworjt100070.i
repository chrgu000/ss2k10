/* xsworjt100070.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 100301.1 By: Roger Xiao */

/* 确定 */
lp0070:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0070.i}

    assign
        s0070_1 = "料品: " + s0030
        s0070_2 = "批号: " + s0040
        s0070_3 = "库位: " + s0050
        s0070_4 = "工单: " + s0020
        s0070_5 = "数量: " + s0060
        s0070_6 = sConfirmOrExit
        .

    display
        sTitle
        s0070_1
        s0070_2
        s0070_3
        s0070_4
        s0070_5
        s0070_6
    with frame f0070.

    s0070 = "Y".

    update
        s0070
    with frame f0070 editing:
        {xsreadkeyapply.i}
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

        find first wo_mstr
            exclusive-lock
            where wo_lot = s0020
                and wo_site = s0010
                and (wo_status = "R" or wo_status = "A")
            use-index wo_lot
            no-error
            no-wait.
        if not(available(wo_mstr)) then do:
            display
                "工单无效或被锁定" @ sMessage
            with frame f0070.
            undo, retry.
        end.

        if wo_qty_comp <= dec0060  then do:
            display
                "工单完成数量不足" wo_qty_comp  @ sMessage
            with frame f0070.
            undo, retry.
        end.

        find first ld_det
            where  ld_site = s0010
            and ld_loc = s0050
            and ld_part = s0030
            and ld_lot = s0040
            and ld_ref = ""
        exclusive-lock no-error no-wait.
        if not(available(ld_det)) then do:
            display
                "库存无效或被锁定" @ sMessage
            with frame f0070.
            undo, retry.
        end.
    end.

    leave lp0070.
END.

