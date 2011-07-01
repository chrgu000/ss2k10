/* xsinmov100020.i -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* ÎïÁÏ.ÅúºÅ */
lp0020:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0020.i}
    

    assign
        s0020_1 = "ÅäÌ××ùÒÎ±àÂë?"
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
            if recid(pt_mstr) = ? then 
                find first pt_mstr 
                    where pt_part >= input s0020
                    use-index pt_part
                    no-lock 
                    no-error.
            else 
                find next pt_mstr 
                    where pt_part >= input s0020
                    use-index pt_part
                    no-lock 
                    no-error.
            if available(pt_mstr) then 
                display skip 
                    pt_part @ s0020 
                    pt_desc1 @ sMessage
                with frame f0020.
            else   
                display 
                    "" @ sMessage 
                with frame f0020.
        end.
        else if lastkey = keycode("F9") 
            or keyfunction(lastkey) = "cursor-up"
        then do:
            if recid(pt_mstr) = ? then 
                find first pt_mstr 
                    where pt_part <= input s0020
                    use-index pt_part
                    no-lock 
                    no-error.
            else 
                find next pt_mstr 
                    where pt_part <= input s0020
                    use-index pt_part
                    no-lock 
                    no-error.
            if available(pt_mstr) then 
                display skip 
                    pt_part @ s0020 
                    pt_desc1 @ sMessage
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
        find first pt_mstr
            no-lock
            where pt_part = s0020
            no-error.
        if not(available(pt_mstr)) then do:
            display
                "×ùÒÎ(¶ÀÁ¢/ÅäÌ×)±àÂëÎÞÐ§" @ sMessage
            with frame f0020.
            undo, retry.
        end.
        
        sAssemblePart = s0020.
    end.
    
    leave lp0020.
END.

