/* xsshp300020.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* SS - 090828.1 - B */
/* 默认显示订单的前2位字符为SO,并将光标移到O的后面 */
/* SS - 090828.1 - E */

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
        sMessage
    with frame f0020.
    
    /* SS - 090828.1 - B */
    assign
        b = yes
        .
    /* SS - 090828.1 - E */

    /* SS - 091030.1 - B */
    if s0020 = "" then do:
        for first code_mstr
            no-lock
            where code_fldname = "ss_shipper_default_so"
                and code_value = "ss_shipper_default_so"
        :
        end.
        if available(code_mstr) then s0020 = code_cmmt.
    end.
    if s0020 = "" then s0020 = "SO".
    /* SS - 091030.1 - E */

    update
        s0020
    with frame f0020
    editing:
        /* SS - 090828.1 - B */
        if b then do:
            b = no.
            do i = 1 to length(s0020):
                apply keycode("CURSOR-RIGHT").
            end.
        end.
        /* SS - 090828.1 - E */
        
        {xsreadkey.i}
        apply lastkey.
    end.
    
    if s0020 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    else do:
        find first so_mstr 
            exclusive-lock
            where so_nbr = s0020
                and so_conf_date <> ?
            use-index so_nbr
            no-error.
        if not(available(so_mstr)) then do:
            sMessage = "单号无效或未确认".
            undo, retry.
        end.
    end.
    
    sMessage = "".
    leave lp0020.
END.

