/* xsshp300025.i -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 08/24/2009   By: Kaine Zhang     Eco: *ss_20090824* */


/* 发货标记 */
lp0025:
repeat on endkey undo, retry:
    hide all.
    
    /* SS - 090918.1 - B
    define variable s0025   as character format "x(50)" no-undo.
    SS - 090918.1 - E */
    /* SS - 090918.1 - B */
    define variable s0025   as character format "xx:xx" no-undo.
    /* SS - 090918.1 - E */
    define variable s0025_1 as character format "x(50)" no-undo.
    define variable s0025_2 as character format "x(50)" no-undo.
    define variable s0025_3 as character format "x(50)" no-undo.
    define variable s0025_4 as character format "x(50)" no-undo.
    define variable s0025_5 as character format "x(50)" no-undo.
    define variable s0025_6 as character format "x(50)" no-undo.
    define variable s0025_7 as character format "x(50)" no-undo.
    define variable s0025_8 as character format "x(50)" no-undo.
    
    form
        sTitle
        s0025_1
        s0025_2
        s0025_3
        s0025_4
        s0025_5
        s0025_6
        s0025
        /* SS - 090918.1 - B */
        at 1
        /* SS - 090918.1 - E */
        sMessage
        /* SS - 090918.1 - B */
        at 1
        /* SS - 090918.1 - E */
    with frame f0025 no-labels no-box.

    
    assign
        s0025_1 = "标记?"
        /* SS - 090918.1 - B */
        s0025_2 = "请输入时间"
        /* SS - 090918.1 - E */
        s0025_6 = sPromptMessage
        .
    
    display
        sTitle
        s0025_1
        s0025_2
        s0025_3
        s0025_4
        s0025_5
        s0025_6
    with frame f0025.
    
    
    update
        s0025
    with frame f0025
    editing:
        {xsreadkeyapply.i}
    end.
    
    if s0025 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    /* SS - 090918.1 - B */
    /* 090918.1, 长丰要求,限定住标记的格式.格式为时间格式 */
    else do:
        if length(s0025) <> 4 then do:
            sMessage = "时间长度不对".
            display
                sMessage
            with frame f0025.
            undo, retry.
        end.

        i = integer(s0025) no-error.
        if error-status:error then do:
            sMessage = "请输入数值时间".
            display
                sMessage
            with frame f0025.
            undo, retry.
        end.
    end.
    /* SS - 090918.1 - E */
    
    sCarNumber = s0025.
    sMessage = "".
    leave lp0025.
END.



