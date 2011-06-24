    lp0050:
    repeat on endkey undo, retry:
        hide all.
        define variable s0050   as integer   format ">>>>9" no-undo.
        define variable s0050_1 as character format "x(50)" no-undo.
        define variable s0050_2 as character format "x(50)" no-undo.
        define variable s0050_3 as character format "x(50)" no-undo.
        define variable s0050_4 as character format "x(50)" no-undo.
        define variable s0050_5 as character format "x(50)" no-undo.
        define variable s0050_6 as character format "x(50)" no-undo.
        define variable s0050_7 as character format "x(50)" no-undo.
        define variable s0050_8 as character format "x(50)" no-undo.

        form
            stitle
            s0050_1
            s0050_2
            s0050_3
            s0050_4
            s0050_5
            s0050_6 skip
            s0050   skip
            smessage
        with frame f0050 no-labels no-box.

        
        assign
            s0050_1 = "每张条码打印张数?"
            s0050_6 = spromptmessage
            s0050   = 1 
            .
        
        display
            stitle
            s0050_1
            s0050_2
            s0050_3
            s0050_4
            s0050_5
            s0050_6
        with frame f0050.
        
        update
            s0050
        with frame f0050
        editing:
            {xsreadkey.i}
            apply lastkey.
        end.
        
        if s0050 = 0 then do:
            undo mainloop, leave mainloop.
        end.
        
        leave lp0050.
    end. /*lp0050*/
