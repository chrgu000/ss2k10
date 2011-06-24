/* xsinv230050.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 库位 */
lp0050:
repeat on endkey undo, retry:
    hide all.
    define variable s0050             as character format "x(50)".
    define variable s0050_1           as character format "x(50)".
    define variable s0050_2           as character format "x(50)".
    define variable s0050_3           as character format "x(50)".
    define variable s0050_4           as character format "x(50)".
    define variable s0050_5           as character format "x(50)".
    
    form
        sTitle
        s0050_1
        s0050_2
        s0050_3
        s0050_4
        s0050_5
        s0050
        sMessage
    with frame f0050 no-labels no-box.

    assign
        s0050_1 = "转入库位?"
        s0050_5 = sPromptMessage
        .
    
    /* SS - 090903.1 - B */
    find first pt_mstr no-lock where pt_part = s0020 no-error.
    if available(pt_mstr) then
        assign
            s0050_2 = pt_part
            s0050_3 = pt_desc1
            .
    s0050 = if available(pt_mstr) then pt_article else "".

    s0050_4 = s0040 + ": ".
    find first ld_det 
        no-lock 
        where ld_site = s0010 
            and ld_loc = s0040 
            and ld_part = s0020 
            and ld_lot = s0030 
            and ld_ref = "" 
        use-index ld_loc_p_lot 
        no-error.
    s0050_4 = s0050_4 + if available(ld_det) then string(ld_qty_oh) else "0".
    for each ld_det
        no-lock 
        where ld_site = s0010 
            and ld_loc = s0040 
            and ld_part = s0020
        use-index ld_loc_p_lot
    :
        accumulate ld_qty_oh (total).
    end.
    s0050_4 = s0050_4 + " |" + string(accum total ld_qty_oh).
    /* SS - 090903.1 - E */

    display
        sTitle
        s0050_1
        s0050_2
        s0050_3
        s0050_4
        s0050_5
    with frame f0050.
    
    update
        s0050
    with frame f0050
    editing:
        readkey.
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
            display
                "库位无效" @ sMessage
            with frame f0050.
            undo, retry.
        end.
    end.
    
    leave lp0050.
END.

