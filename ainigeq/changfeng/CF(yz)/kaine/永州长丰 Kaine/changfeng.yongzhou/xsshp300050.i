/* xsshp300050.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 库位 */
lp0050:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0050.i}
    
    assign
        s0050_1 = "库位?"
        s0050_6 = sPromptMessage
        .
    
    display
        sTitle
        s0050_1
        s0050_2
        s0050_3
        s0050_4
        s0050_5
        s0050_6
        sMessage
    with frame f0050.
    
    find first code_mstr
        no-lock
        where code_fldname = "bc_shipper_default_location"
            and code_value = "bc_shipper_default_location"
        no-error.
    if available(code_mstr) then s0050 = code_cmmt.
    
    update
        s0050
    with frame f0050
    editing:
        {xsreadkey.i}
        
        if lastkey = keycode("F10") 
            or keyfunction(lastkey) = "cursor-down"
        then do:
            if recid(loc_mstr) = ? then 
                find first loc_mstr 
                    where loc_site = s0010
                        and loc_loc >= input s0050
                    use-index loc_loc
                    no-lock 
                    no-error.
            else 
                find next loc_mstr 
                    where loc_site = s0010
                        and loc_loc >= input s0050
                    use-index loc_loc
                    no-lock 
                    no-error.
            if available(loc_mstr) then 
                display skip 
                    loc_loc @ s0050 
                    loc_desc @ sMessage
                with frame f0050.
            else   
                display 
                    "" @ sMessage 
                with frame f0050.
        end.
        else if lastkey = keycode("F9") 
            or keyfunction(lastkey) = "cursor-up"
        then do:
            if recid(loc_mstr) = ? then 
                find first loc_mstr 
                    where loc_site = s0010
                        and loc_loc <= input s0050
                    use-index loc_loc
                    no-lock 
                    no-error.
            else 
                find prev loc_mstr 
                    where loc_site = s0010
                        and loc_loc <= input s0050
                    use-index loc_loc
                    no-lock 
                    no-error.
            if available(loc_mstr) then 
                display skip 
                    loc_loc @ s0050 
                    loc_desc @ sMessage
                with frame f0050.
            else   
                display 
                    "" @ sMessage 
                with frame f0050.
        end.
        else do:
            apply lastkey.
        end.
    end.
    
    if s0050 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    else do:
        find first loc_mstr 
            where loc_site = s0010
                and loc_loc = s0050
            no-lock 
            no-error.
        if not(available(loc_mstr)) then do:
            sMessage = "库位无效".
            undo, retry.
        end.
    end.
    
    sMessage = "".
    
    leave lp0050.
END.

