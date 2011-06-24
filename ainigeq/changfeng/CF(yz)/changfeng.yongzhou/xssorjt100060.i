/* xssorjt100060.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 100301.1 By: Roger Xiao */

/* ���� */
lp0060:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0060.i}

    define variable dec0060           as decimal no-undo.
    define variable dec0060_1         as decimal no-undo.

    assign
        s0060_1 = "�˻�����?"
        s0060_2 = "��Ʒ: " + s0040
        s0060_3 = "����: " + s0041
        s0060_4 = "��λ: " + s0050
        s0060_5 = "����: " + s0020
        s0060_6 = "������:" + s0030
        sMessage = sPromptMessage
        .

    if not(retry) then s0060 = "0".

    display
        sTitle
        s0060_1
        s0060_2
        s0060_3
        s0060_4
        s0060_5
        s0060_6
    with frame f0060.

    update
        s0060
    with frame f0060 editing:
        {xsreadkeyapply.i}
    end.

    if s0060 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    else do:
        if s0060 = "" then do:
            display
                "��������" @ sMessage
            with frame f0060.
            undo, retry.
        end.

        dec0060 = decimal(s0060) no-error.
        if error-status:error then do:
            display
                "��������" @ sMessage
            with frame f0060.
            undo, retry.
        end.
        if dec0060 <= 0 then do:
            display
                "��������>0" @ sMessage
            with frame f0060.
            undo, retry.
        end.

        /* ��������Ƿ��㹻? 
        find first ld_det
            no-lock
            where ld_site = s0010
                and ld_loc = s0050
                and ld_part = s0030
                and ld_lot = s0040
                and ld_ref = ""
            no-error.
        if not(available(ld_det)) then do:
            display
                "�������0" @ sMessage
            with frame f0060.
            undo, retry.
        end.
        if ld_qty_oh < dec0060 then do:
            display
                "���" + string(ld_qty_oh) + "<" + s0060
                    @ sMessage
            with frame f0060.
            undo, retry.
        end.
        */

        /* �˻����������Ƿ��㹻? */
        find first sod_det
              where sod_nbr  = s0020
                and sod_line = integer(s0030)
                and sod_part = s0040
                and sod_confirm
                and sod_qty_ord < 0
                and sod_qty_ord - sod_qty_ship < 0
        no-lock no-error .
        if avail sod_det then do:
            if -( sod_qty_ord - sod_qty_ship) <  dec0060 then do:
                display
                    "δ�ᶩ������" + string(-(sod_qty_ord - sod_qty_ship)) + "<" + s0060
                        @ sMessage
                with frame f0060.
                undo, retry.
            end.
        end.

        dec0060_1 = - dec0060.
    end.
    
    leave lp0060.
END.

