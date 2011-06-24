/* xswoi100020.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 工单ID */
lp0020:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0020.i}
    
    assign
        s0020_1 = "工单ID?"
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
    
    update
        s0020
    with frame f0020
    editing:
        {xsreadkey.i}
        /* todo!!!!
        if lastkey = keycode("F10") 
            or keyfunction(lastkey) = "cursor-down"
        then do:
            if recid(wo_mstr) = ? then 
                find first wo_mstr 
                    where loc_site = s0010
                        and loc_loc >= input s0020
                    use-index loc_loc
                    no-lock 
                    no-error.
            else 
                find next loc_mstr 
                    where loc_site = s0010
                        and loc_loc >= input s0020
                    use-index loc_loc
                    no-lock 
                    no-error.
            if available(loc_mstr) then 
                display skip 
                    loc_loc @ s0020 
                    loc_desc @ sMessage
                with frame f0020.
            else   
                display 
                    "" @ sMessage 
                with frame f0020.
        end.
        else if lastkey = keycode("F9") 
            or keyfunction(lastkey) = "cursor-up"
        then do:
            if recid(loc_mstr) = ? then 
                find first loc_mstr 
                    where loc_site = s0010
                        and loc_loc <= input s0020
                    use-index loc_loc
                    no-lock 
                    no-error.
            else 
                find prev loc_mstr 
                    where loc_site = s0010
                        and loc_loc <= input s0020
                    use-index loc_loc
                    no-lock 
                    no-error.
            if available(loc_mstr) then 
                display skip 
                    loc_loc @ s0020 
                    loc_desc @ sMessage
                with frame f0020.
            else   
                display 
                    "" @ sMessage 
                with frame f0020.
        end.
        else do:
            apply lastkey.
        end.
        */
        /* SS - 090710.1 - B
        todo!!!!
        SS - 090710.1 - E */ apply lastkey.
    end.
    
    if s0020 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    else do:
        find first wo_mstr 
            where wo_lot = s0020
                and wo_site = s0010
                and (wo_status = "R" or wo_status = "A")
            use-index wo_lot
            no-lock 
            no-error.
        if not(available(wo_mstr)) then do:
            display
                "单号或地点或状态无效" @ sMessage
            with frame f0020.
            undo, retry.
        end.
    end.
    
    leave lp0020.
END.

