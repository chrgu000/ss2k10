/* xswor030070.i -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
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
        s0070_4 = "工单: " + s0020
        /* SS - 090820.1 - B
        s0070_5 = "数量: " + s0060
        SS - 090820.1 - E */
        /* SS - 090820.1 - B */
        s0070_5 = "数量: " + string(wo_qty_comp) + "/" + string(wo_qty_ord)
        /* SS - 090820.1 - E */
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
    end.
    SS - 090824.1 - E */

    /* SS - 090824.1 - B */
    s0070 = "Y".
    find first wo_mstr
        exclusive-lock
        where wo_lot = s0020
            and wo_site = s0010
            and (wo_status = "R" or wo_status = "A")
        use-index wo_lot
        no-error
        no-wait.
    if not(available(wo_mstr)) then do:
        sMessage = "工单无效或被锁定".
        undo detlp, retry detlp.
    end.
    /* SS - 090824.1 - E */

    leave lp0070.
END.

