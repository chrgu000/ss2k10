/* xsshp200030.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* ����.���� */
lp0030:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0030.i}
    

    assign
        s0030_1 = "����$����?"
        s0030_6 = sPromptMessage
        .
    
    display
        sTitle
        s0030_1
        s0030_2
        s0030_3
        s0030_4
        s0030_5
        s0030_6
    with frame f0030.
    
    if not(retry) then s0030 = "".
    
    update
        s0030
    with frame f0030
    editing:
        {xsreadkey.i}
        if lastkey = keycode("F10") 
            or keyfunction(lastkey) = "cursor-down"
        then do:
            if recid(pt_mstr) = ? then 
                find first pt_mstr 
                    where pt_part >= input s0030
                    use-index pt_part
                    no-lock 
                    no-error.
            else 
                find next pt_mstr 
                    where pt_part >= input s0030
                    use-index pt_part
                    no-lock 
                    no-error.
            if available(pt_mstr) then 
                display skip 
                    pt_part @ s0030 
                    pt_desc1 @ sMessage
                with frame f0030.
            else   
                display 
                    "" @ sMessage 
                with frame f0030.
        end.
        else if lastkey = keycode("F9") 
            or keyfunction(lastkey) = "cursor-up"
        then do:
            if recid(pt_mstr) = ? then 
                find first pt_mstr 
                    where pt_part <= input s0030
                    use-index pt_part
                    no-lock 
                    no-error.
            else 
                find next pt_mstr 
                    where pt_part <= input s0030
                    use-index pt_part
                    no-lock 
                    no-error.
            if available(pt_mstr) then 
                display skip 
                    pt_part @ s0030 
                    pt_desc1 @ sMessage
                with frame f0030.
            else   
                display 
                    "" @ sMessage 
                with frame f0030.
        end.
        else do:
            apply lastkey.
        end.
    end.
    
    if s0030 = sExitFlag then do:
        undo detlp, leave detlp.
    end.
    else do:
        if s0030 begins "+" then do:
            sCarNumber = substring(s0030, 2).
            display
                sCarNumber @ sMessage
            with frame f0030.
            next.
        end.
        
        {xsgetpartlot.i
            s0030
            sPart
            sLot
            sMessage
            f0030
            "lp0030"
            sVendor
        }
        s0030 = sPart.
        find first sod_det
            no-lock 
            where sod_nbr = s0020
                and sod_part = s0030
                and sod_confirm
            no-error.
        if not(available(sod_det)) then do:
            display
                "δ������ȷ�ϵĶ�������" @ sMessage
            with frame f0030.
            undo, retry.
        end.
    end.
    
    leave lp0030.
END.

