/* xspor010020.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 物料$批号 - 物料 */
lp0020:
repeat on endkey undo, retry:
    hide all.
    define variable s0020             as character format "x(50)".
    define variable s0020_1           as character format "x(50)".
    define variable s0020_2           as character format "x(50)".
    define variable s0020_3           as character format "x(50)".
    define variable s0020_4           as character format "x(50)".
    define variable s0020_5           as character format "x(50)".
    
    form
        sTitle
        s0020_1
        s0020_2
        s0020_3
        s0020_4
        s0020_5
        s0020
        sMessage
    with frame f0020 no-labels no-box.

    assign
        s0020_1 = "物料$批号?"
        s0020_5 = sPromptMessage
        .
    
    display
        sTitle
        s0020_1
        s0020_2
        s0020_3
        s0020_4
        s0020_5
    with frame f0020.
    
    if not(retry) then s0020 = "".
    
    update
        s0020
    with frame f0020
    editing:
        readkey.
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
        {xsgetpartlot.i
            s0020
            sPart
            sLot
            sMessage
            f0020
            "lp0020"
            sVendor
        }
        s0020 = sPart.
    end.
    
    leave lp0020.
END.

