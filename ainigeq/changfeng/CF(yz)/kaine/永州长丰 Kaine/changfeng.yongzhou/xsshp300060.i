/* xsshp300060.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* ���� */
lp0060:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0060.i}

    define variable dec0060           as decimal no-undo.

    
    assign
        s0060 = "1"
        dec0060 = 1
        .

    /* ��������Ƿ��㹻? */
    find first ld_det
        no-lock
        where ld_site = s0010
            and ld_loc = s0050
            and ld_part = s0030
            and ld_lot = s0040
            and ld_ref = ""
        use-index ld_loc_p_lot
        no-error.
    if not(available(ld_det)) then do:
        sMessage = "�������0".
        undo detlp, retry detlp.
    end.
    if ld_qty_oh < dec0060 then do:
        sMessage = "���" + string(ld_qty_oh) + "<" + s0060.
        undo detlp, retry detlp.
    end.

    /* δ�궩�������Ƿ��㹻? */
    find first sod_det
        exclusive-lock
        where sod_part = s0030
            and sod_nbr = s0020
            and sod_confirm
            and sod_qty_ord > 0
            and sod_qty_ord - sod_qty_ship >= dec0060
        use-index sod_part
        no-error.
    if not(available(sod_det)) then do:
        sMessage = "δ�����㹻��������ȷ�ϵĶ������".
        undo detlp, retry detlp.
    end.
    iSodLine = sod_line.

    leave lp0060.
END.

