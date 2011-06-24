/* xscars010020.i -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 090903.1 By: Kaine Zhang */

/* �ɳ�����VIN */
lp0020:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0020.i}
    
    assign
        s0020_1 = "����VIN?"
        s0020_6 = sPromptMessage
        .
    
    display
        sTitle
        s0020_1
        s0020_2
        s0020_3
        s0020_4
        s0020_5
        s0020_6
        sMessage
    with frame f0020.
    
    if not(retry) then s0020 = "".
    update
        s0020
    with frame f0020
    editing:
        {xsreadkey.i}
        apply lastkey.
    end.
    
    if s0020 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    else do:
        /* �����жϱ�׼ */
        if length(s0020) <> 17 then do:
            sMessage = "VIN���ȴ���".
            undo, retry.
        end.

        find first xcar_mstr
            where xcar_vin = s0020
            no-error.
        if available(xcar_mstr) then do:
            sMessage = "�Ѵ��ڵĳ���,������������κ�".
        end.
        else do:
            sMessage = "�³��ܺ�,������������κ�".
            create xcar_mstr.
            assign
                xcar_vin = s0020
                xcar_scan_user = global_userid
                xcar_scan_date = today
                .
        end.
    end.
    
    leave lp0020.
END.

