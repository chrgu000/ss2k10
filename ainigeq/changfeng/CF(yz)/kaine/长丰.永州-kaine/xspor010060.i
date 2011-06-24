/* xspor010060.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 数量 */
lp0060:
repeat on endkey undo, retry:
    hide all.
    define variable s0060             as character format "x(50)".
    define variable s0060_1           as character format "x(50)".
    define variable s0060_2           as character format "x(50)".
    define variable s0060_3           as character format "x(50)".
    define variable s0060_4           as character format "x(50)".
    define variable s0060_5           as character format "x(50)".
    define variable dec0060           as decimal no-undo.
    define variable dec0060_1         as decimal no-undo.
    
    form
        sTitle
        s0060_1
        s0060_2
        s0060_3
        s0060_4
        s0060_5
        s0060
        sMessage
    with frame f0060 no-labels no-box.

    assign
        s0060_1 = "数量?"
        s0060_2 = "料品: " + s0020
        s0060_3 = "批号: " + s0030
        s0060_4 = "库位: " + s0050
        s0060_5 = sPromptMessage
        .
    
    display
        sTitle
        s0060_1
        s0060_2
        s0060_3
        s0060_4
        s0060_5
        sMessage
    with frame f0060.
    
    s0060 = "".
    
    update
        s0060
    with frame f0060.
    
    if s0060 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    else do:
        assign
            dec0060 = decimal(s0060) 
            dec0060_1 = dec0060
            no-error
            .
        if error-status:error then do:
            display
                "数量有误" @ sMessage
            with frame f0060.
            undo, retry.
        end.
        
        if dec0060 <= 0 then do:
                display
                "必须>0" @ sMessage
            with frame f0060.
            undo, retry.
        end.
        
    end.
    
    leave lp0060.
END.

