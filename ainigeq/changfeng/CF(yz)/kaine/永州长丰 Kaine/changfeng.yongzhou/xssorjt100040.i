/* xssorjt100040.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 100301.1 By: Roger Xiao */

define var s0041 as char format "x(50)" no-undo .

/* ����.���� */
lp0040:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0040.i}
    

    assign
        s0040_1 = "����$����?"
        s0040_6 = sPromptMessage
        .
    
    display
        sTitle
        s0040_1
        s0040_2
        s0040_3
        s0040_4
        s0040_5
        s0040_6
    with frame f0040.
    
    if not(retry) then s0040 = "".
    
    update
        s0040
    with frame f0040
    editing:
        {xsreadkey.i}
        apply lastkey.
    end.
    
    if s0040 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    else do:
        {xsgetpartlot.i
            s0040
            sPart
            sLot
            sMessage
            f0040
            "lp0040"
            sVendor
        }
        s0040 = sPart.
        s0041 = sLot.
        find first sod_det
            no-lock 
            where sod_nbr = s0020
                and sod_line = integer(s0030)
                and sod_confirm
            no-error.
        if not(available(sod_det)) then do:
            display
                "δ������ȷ�ϵĶ�����" @ sMessage
            with frame f0040.
            undo, retry.
        end.
        else do:
            if sod_part <> s0040 then do:
                display
                    "�ö����в��Ǵ�����" @ sMessage
                with frame f0040.
                undo, retry.
            end.
        end.
    end.
    
    leave lp0040.
END.

