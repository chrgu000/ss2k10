    lp0040:
    repeat on endkey undo, retry:
        hide all.
        define variable s0040   as character format "x(50)" no-undo.
        define variable s0040_1 as character format "x(50)" no-undo.
        define variable s0040_2 as character format "x(50)" no-undo.
        define variable s0040_3 as character format "x(50)" no-undo.
        define variable s0040_4 as character format "x(50)" no-undo.
        define variable s0040_5 as character format "x(50)" no-undo.
        define variable s0040_6 as character format "x(50)" no-undo.
        define variable s0040_7 as character format "x(50)" no-undo.
        define variable s0040_8 as character format "x(50)" no-undo.

        form
            stitle
            s0040_1
            s0040_2
            s0040_3
            s0040_4
            s0040_5
            s0040_6
            s0040
            smessage
        with frame f0040 no-labels no-box.

        
        assign
            s0040_1 = "计划员?"
            s0040_6 = spromptmessage
            .
        
        display
            stitle
            s0040_1
            s0040_2
            s0040_3
            s0040_4
            s0040_5
            s0040_6
        with frame f0040.
        
        update
            s0040
        with frame f0040
        editing:
            {xsreadkey.i}
            apply lastkey.
        end.
        
        if s0040 = sexitflag then do:
            undo mainloop, leave mainloop.
        end.
        else do:
            find first code_mstr where code_fldname = "pt_buyer" no-lock no-error .
            if avail code_mstr then do:
                find first code_mstr where code_fldname = "pt_buyer" and code_value = s0040 no-lock no-error .   
                if not avail code_mstr then do:
                    display
                        "计划员无效" @ sMessage
                    with frame f0040.
                    undo, retry.
                end.
            end.

        end.
        
        leave lp0040.
    end. /*lp0040*/
