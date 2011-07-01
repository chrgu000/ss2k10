/* xssoiss100020.i ---- */
/* Copyright 2011 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 110321.1 By: Kaine Zhang */

/* 销售订单 */
lp0020:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0020.i}
    

    assign
        s0020_1 = "销售订单编码?"
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
    with frame f0020.
    
    if not(retry) then s0020 = "".
    
    update
        s0020
    with frame f0020
    editing:
        {xsreadkey.i}
        if lastkey = keycode("F10") 
            or keyfunction(lastkey) = "cursor-down"
        then do:
            if recid(so_mstr) = ? then 
                find first so_mstr 
                    where so_nbr >= input s0020
                    use-index so_nbr
                    no-lock 
                    no-error.
            else 
                find next so_mstr 
                    where so_nbr >= input s0020
                    use-index so_nbr
                    no-lock 
                    no-error.
            if available(so_mstr) then 
                display skip 
                    so_nbr @ s0020 
                    so_cust @ sMessage
                with frame f0020.
            else   
                display 
                    "" @ sMessage 
                with frame f0020.
        end.
        else if lastkey = keycode("F9") 
            or keyfunction(lastkey) = "cursor-up"
        then do:
            if recid(so_mstr) = ? then 
                find first so_mstr 
                    where so_nbr <= input s0020
                    use-index so_nbr
                    no-lock 
                    no-error.
            else 
                find next so_mstr 
                    where so_nbr <= input s0020
                    use-index so_nbr
                    no-lock 
                    no-error.
            if available(so_mstr) then 
                display skip 
                    so_nbr @ s0020 
                    so_cust @ sMessage
                with frame f0020.
            else   
                display 
                    "" @ sMessage 
                with frame f0020.
        end.
        else do:
            apply lastkey.
        end.
    end.
    
    if s0020 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    else do:
        find first so_mstr
            no-lock
            where so_nbr = s0020
            no-error.
        if not(available(so_mstr)) then do:
            display
                "销售订单编码无效" @ sMessage
            with frame f0020.
            undo, retry.
        end.
        
    end.
    
    leave lp0020.
END.

