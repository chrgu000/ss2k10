/* xssorjt100030.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 100301.1 By: Roger Xiao */

/* 物料.批号 */
lp0030:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0030.i}
    

    assign
        s0030_1 = "销售订单行?"
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
            if recid(sod_det) = ? then 
                find first sod_det 
                    where sod_nbr = s0020 
                    and sod_line >= integer(input s0030)
                    use-index sod_nbrln 
                    no-lock 
                    no-error.
            else 
                find next sod_det 
                    where sod_nbr = s0020 
                    and sod_line >= integer(input s0030)
                    use-index sod_nbrln 
                    no-lock 
                    no-error.
            if available(sod_det) then 
                display skip 
                    sod_line @ s0030 
                    sod_part @ sMessage
                with frame f0030.
            else   
                display 
                    "" @ sMessage 
                with frame f0030.
        end.
        else if lastkey = keycode("F9") 
            or keyfunction(lastkey) = "cursor-up"
        then do:
            if recid(sod_det) = ? then 
                find first sod_det 
                    where sod_nbr = s0020 
                    and sod_line <= integer(input s0030)
                    use-index sod_nbrln 
                    no-lock 
                    no-error.
            else 
                find next sod_det 
                    where sod_nbr = s0020 
                    and sod_line <= integer(input s0030)
                    use-index sod_nbrln 
                    no-lock 
                    no-error.
            if available(sod_det) then 
                display skip 
                    sod_line @ s0030 
                    sod_part @ sMessage
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
        undo mainloop, leave mainloop.
    end.
    else do:

        DO i = 1 to length(s0030).
            If index("0987654321", substring(s0030,i,1)) = 0 then do:
                display skip "非法字符" @ sMessage  with frame f0030.
                undo, retry.
            end.
        end.


        find first sod_det
            no-lock 
            where sod_nbr = s0020
                and sod_line = integer (s0030)
                and sod_confirm
                and sod_qty_ord < 0 
                and sod_qty_ord - sod_qty_ship < 0
            no-error.
        if not(available(sod_det)) then do:
            display
                "未发现此退货的订单行" @ sMessage
            with frame f0030.
            undo, retry.
        end.
    end.
    
    leave lp0030.
END.

