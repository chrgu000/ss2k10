/* xswor100060.i -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 项次 */
lp0060:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0060.i}
    define variable i0060 as integer no-undo.
    
    assign
        s0060_1 = "项次?"
        s0060_6 = sPromptMessage
        .
    
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
    with frame f0060
    editing:
        {xsreadkey.i}
        
        if lastkey = keycode("F10") 
            or keyfunction(lastkey) = "cursor-down"
        then do:
            if recid(sod_det) = ? then 
                find first sod_det 
                    where sod_nbr = s0020
                        and sod_line >= integer(input s0060)
                    use-index sod_nbrln
                    no-lock 
                    no-error.
            else 
                find next sod_det 
                    where sod_nbr = s0020
                        and sod_line >= integer(input s0060)
                    use-index sod_nbrln
                    no-lock 
                    no-error.
            if available(sod_det) then 
                display skip 
                    string(sod_line) @ s0060 
                    sod_part @ sMessage
                with frame f0060.
            else   
                display 
                    "" @ sMessage 
                with frame f0060.
        end.
        else if lastkey = keycode("F9") 
            or keyfunction(lastkey) = "cursor-up"
        then do:
            if recid(sod_det) = ? then 
                find first sod_det 
                    where sod_nbr = s0020
                        and sod_line <= integer(input s0060)
                    use-index sod_nbrln
                    no-lock 
                    no-error.
            else 
                find prev sod_det 
                    where sod_nbr = s0020
                        and sod_line <= integer(input s0060)
                    use-index sod_nbrln
                    no-lock 
                    no-error.
            if available(sod_det) then 
                display skip 
                    string(sod_line) @ s0060 
                    sod_part @ sMessage
                with frame f0060.
            else   
                display 
                    "" @ sMessage 
                with frame f0060.
        end.
        else do:
            apply lastkey.
        end.
    end.
    
    if s0060 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    else do:
        i0060 = 0.
        i0060 = integer(s0060) no-error.
        find first sod_det 
            where sod_nbr = s0020
                and sod_line = i0060
                and sod_confirm
                and sod_qty_ord > 0
                and sod_qty_ord - sod_qty_ship > 0
            no-lock 
            no-error.
        if not(available(sod_det)) then do:
            display
                "订单项次无效或未确认或已运完" @ sMessage
            with frame f0060.
            undo, retry.
        end.
        
        sAssemblePart = sod_part.
    end.
    
    leave lp0060.
END.

