    lp0030:
    repeat on endkey undo, retry:
        hide all.
        define variable s0030   as date  no-undo.
        define variable s0030_1 as character format "x(50)" no-undo.
        define variable s0030_2 as character format "x(50)" no-undo.
        define variable s0030_3 as character format "x(50)" no-undo.
        define variable s0030_4 as character format "x(50)" no-undo.
        define variable s0030_5 as character format "x(50)" no-undo.
        define variable s0030_6 as character format "x(50)" no-undo.
        define variable s0030_7 as character format "x(50)" no-undo.
        define variable s0030_8 as character format "x(50)" no-undo.

        form
            stitle
            s0030_1
            s0030_2
            s0030_3
            s0030_4
            s0030_5
            s0030_6 skip 
            s0030 skip
            smessage
        with frame f0030 no-labels no-box.

        
        assign
            s0030_1 = "收货日期?"
            s0030_6 = spromptmessage
            s0030   = if s0030 = ? then today else s0030 
            .
        
        display
            stitle
            s0030_1
            s0030_2
            s0030_3
            s0030_4
            s0030_5
            s0030_6
        with frame f0030.
        
        update
            s0030
        with frame f0030
        editing:
            {xsreadkey.i}
            apply lastkey.
        end.
        
        if s0030 = ? /* sexitflag */ then do:
            undo mainloop, leave mainloop.
        end.
        else do:
            if s0030 > today  then do:
                display
                    "收货日期无效" @ sMessage
                with frame f0030.
                undo, retry.
            end.
        end.
        
        leave lp0030.
    end. /*lp0030*/
