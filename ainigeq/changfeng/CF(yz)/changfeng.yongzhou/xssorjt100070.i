/* xssorjt100070.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 100301.1 By: Roger Xiao */

/* 确定 */
lp0070:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0070.i}

    assign
        s0070_1 = "料品: " + s0040
        s0070_2 = "批号: " + s0041
        s0070_3 = "库位: " + s0050
        s0070_4 = "订单: " + s0020
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

        find first so_mstr
            exclusive-lock
            where so_nbr = s0020
                and so_conf_date <> ?
            use-index so_nbr
            no-error
            no-wait.
        if not(available(so_mstr)) then do:
            display
                "订单无效或被锁定" @ sMessage
            with frame f0070.
            undo, retry.
        end.

        empty temp-table t1_tmp.

        for each sod_det
            where   sod_nbr = s0020
                and sod_line = integer(s0030)
                and sod_confirm
                and sod_qty_ord < 0
                and sod_qty_ord - sod_qty_ship < 0
            no-lock:

            create t1_tmp.
            assign
                t1_line = sod_line
                t1_qty = max(dec0060_1, (sod_qty_ord - sod_qty_ship))
                .
        end.

    end.

    leave lp0070.
END.

