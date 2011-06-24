/* xsshp300070.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 确定 */
lp0070:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0070.i}

    /* SS - 090824.1 - B
    assign
        s0070_1 = "料品: " + s0030
        s0070_2 = "批号: " + s0040
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
        undo detlp, leave detlp.
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

        find first sod_det
            exclusive-lock
            where sod_part = s0030
                and sod_nbr = s0020
                and sod_confirm
                and sod_qty_ord > 0
                and sod_qty_ord - sod_qty_ship >= dec0060
            use-index sod_part.
        if not(available(sod_det)) then do:
            sMessage = "未发现足够数量且已确认的订单项次!".
            undo detlp, retry detlp.
        end.
        iSodLine = sod_line.
    end.
    SS - 090824.1 - E */

    /* SS - 090824.1 - B */
    s0070 = "Y".

    find first sod_det
        exclusive-lock
        where sod_part = s0030
            and sod_nbr = s0020
            and sod_confirm
            and sod_qty_ord > 0
            and sod_qty_ord - sod_qty_ship >= dec0060
        use-index sod_part.
    if not(available(sod_det)) then do:
        sMessage = "未发现足够数量且已确认的订单项次!".
        undo detlp, retry detlp.
    end.
    iSodLine = sod_line.
    /* SS - 090824.1 - E */

    leave lp0070.
END.

