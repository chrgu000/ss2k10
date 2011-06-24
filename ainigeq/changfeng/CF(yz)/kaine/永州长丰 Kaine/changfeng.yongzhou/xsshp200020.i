/* xsshp200020.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 销售订单 */
lp0020:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0020.i}
    
    assign
        s0020_1 = "销售订单?"
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
        apply lastkey.
    end.
    
    if s0020 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    else do:
        find first so_mstr 
            where so_nbr = s0020
                and so_conf_date <> ?
            use-index so_nbr
            no-lock 
            no-error.
        if not(available(so_mstr)) then do:
            display
                "单号无效或未确认" @ sMessage
            with frame f0020.
            undo, retry.
        end.
    end.
    
    leave lp0020.
END.

