/* xswri100060.i -- */
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
        s0060_1 = "����?"
        s0060_2 = "��Ʒ: " + s0030
        s0060_3 = "����: " + s0040
        s0060_4 = "��λ: " + s0050
        s0060_5 = "����: " + s0020
        s0060_6 = sPromptMessage
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
    
    find first wo_mstr 
        where wo_lot = s0020
            and wo_site = s0010
            and (wo_status = "R" or wo_status = "A")
        use-index wo_lot
        no-lock 
        no-error.
    s0060 = string(wo_qty_ord - wo_qty_comp).
    
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
        
        {xswri10getlist.i}
        if not(bEnoughQty) then do:
            display
                sFailPart + "��س�" + string(decFailQty) + ",���" + string(decFailStore)
                    @ sMessage
            with frame f0060.
            undo, retry.
        end.
    end.
    
    leave lp0060.
END.

