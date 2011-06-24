/* xscars010030.i -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 090903.1 By: Kaine Zhang */

/* 座椅号 */
lp0030:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0030.i}
    
    assign
        s0030_1 = "座椅条码?"
        s0030_2 = "车架号: " + s0020
        s0030_6 = sPromptMessage
        .
    
    for each xcard_det
        no-lock
        where xcard_vin = s0020
    :
        accumulate xcard_vin (count).
    end.
    s0030_3 = "座椅数: " + string(accum count xcard_vin).

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
        apply lastkey.
    end.
    
    if s0030 = sExitFlag then do:
        undo lp0030, leave lp0030.
    end.
    else do:
        {xsgetpartlotkeepbc.i
            s0030
            sPart
            sLot
            sMessage
            f0030
            "lp0030"
        }

        find first xcard_det
            where xcard_seat = s0030
            use-index xcard_seat
            no-error.
        if available(xcard_det) then do:
            sMessage = xcard_vin + "已经存在本座椅".
            display
                sMessage
            with frame f0030.
            undo, retry.
        end.
        
        for each xcard_det
            no-lock
            where xcard_vin = s0020
            use-index xcard_vin_seat
        :
            accumulate xcard_seq (max).
        end.
        /* if no xcard_det, then accum max will equal ?(null),  and 0 > ? */
        i = max(0, accum max xcard_seq) + 1.
            
        create xcard_det.
        assign
            xcard_vin = s0020
            xcard_seat = s0030
            xcard_seq = i
            xcard_part = sPart
            xcard_lot = sLot
            xcard_input_date = today
            xcard_input_time = time
            xcard_input_user = global_userid
            .
        for first pt_mstr
            no-lock
            where pt_part = xcard_part
        :
        end.
        if available(pt_mstr) then xcard_seq = integer(pt_drwg_size) no-error.

        sMessage = sLot + "关联成功".
        display
            sMessage
        with frame f0030.
    end.
END.

