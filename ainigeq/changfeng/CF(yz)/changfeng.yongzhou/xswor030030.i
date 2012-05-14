/* xswor020030.i -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* ����.���� */
lp0030:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0030.i}
    
    find first wo_mstr 
        where wo_lot = s0020
            and wo_site = s0010
            and (wo_status = "R" or wo_status = "A")
        use-index wo_lot
        no-lock 
        no-error.
    if not(available(wo_mstr)) then do:
        sMessage = "���Ż�ص��״̬��Ч".
        undo mainloop, retry mainloop.
    end.

    assign
        s0030_1 = "����$����?"
        s0030_2 = "����: " + string(wo_qty_comp) + "/" + string(wo_qty_ord)
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
        sMessage
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
        
        if s0030 <> sWoPart then do:
            display
                "�������빤������Ӧ" @ sMessage
            with frame f0030.
            undo, retry.
        end.
    end.
    
    leave lp0030.
END.
