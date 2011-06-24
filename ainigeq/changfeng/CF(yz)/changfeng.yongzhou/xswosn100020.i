    lp0020:
    repeat on endkey undo, retry:
        hide all.
        define variable s0020   as date  no-undo.
        define variable s0020_1 as character format "x(50)" no-undo.
        define variable s0020_2 as character format "x(50)" no-undo.
        define variable s0020_3 as character format "x(50)" no-undo.
        define variable s0020_4 as character format "x(50)" no-undo.
        define variable s0020_5 as character format "x(50)" no-undo.
        define variable s0020_6 as character format "x(50)" no-undo.
        define variable s0020_7 as character format "x(50)" no-undo.
        define variable s0020_8 as character format "x(50)" no-undo.

        form
            stitle
            s0020_1
            s0020_2
            s0020_3
            s0020_4
            s0020_5
            s0020_6 skip
            s0020   skip
            smessage
        with frame f0020 no-labels no-box.

        
        assign
            s0020_1 = "开始日期?"
            s0020_6 = spromptmessage
            s0020   = today 
            .
        
        display
            stitle
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
        
        if s0020 = ? /* sexitflag */ then do:
            undo mainloop, leave mainloop.
        end.
        else do:
            if s0020 > today then do:
                display
                    "开始日期无效" @ sMessage
                with frame f0020.
                undo, retry.
            end.
        end.
        
        leave lp0020.
    end. /*lp0020*/
