/* xswor100060.i -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 库位 */
lp0060:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0060.i}
    
    assign
        s0060_1 = "转至库位?"
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

    s0060 = "408".
    
    update
        s0060
    with frame f0060
    editing:
        {xsreadkey.i}
        
        if lastkey = keycode("F10") 
            or keyfunction(lastkey) = "cursor-down"
        then do:
            if recid(loc_mstr) = ? then 
                find first loc_mstr 
                    where loc_site = s0010
                        and loc_loc >= input s0060
                    use-index loc_loc
                    no-lock 
                    no-error.
            else 
                find next loc_mstr 
                    where loc_site = s0010
                        and loc_loc >= input s0060
                    use-index loc_loc
                    no-lock 
                    no-error.
            if available(loc_mstr) then 
                display skip 
                    loc_loc @ s0060 
                    loc_desc @ sMessage
                with frame f0060.
            else   
                display 
                    "" @ sMessage 
                with frame f0060.
        end.
        else if lastkey = keycode("F9") 
            or keyfunction(lastkey) = "cursor-up"
        then do:
            if recid(loc_mstr) = ? then 
                find first loc_mstr 
                    where loc_site = s0010
                        and loc_loc <= input s0060
                    use-index loc_loc
                    no-lock 
                    no-error.
            else 
                find prev loc_mstr 
                    where loc_site = s0010
                        and loc_loc <= input s0060
                    use-index loc_loc
                    no-lock 
                    no-error.
            if available(loc_mstr) then 
                display skip 
                    loc_loc @ s0060 
                    loc_desc @ sMessage
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
        if s0060 = s0050 then do:
            display
                "转移库位不可相同" @ sMessage
            with frame f0060.
            undo, retry.
        end.
        
        find first loc_mstr 
            where loc_site = s0010
                and loc_loc = s0060
            no-lock 
            no-error.
        if not(available(loc_mstr)) then do:
            display
                "库位无效" @ sMessage
            with frame f0060.
            undo, retry.
        end.
    end.
    
    leave lp0060.
END.

