    lp0020:
    repeat on endkey undo, retry:
        hide all.
        define variable s0020   as character format "x(50)" no-undo.
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
            s0020_6
            s0020
            smessage
        with frame f0020 no-labels no-box.

        
        assign
            s0020_1 = "采购单号?"
            s0020_6 = spromptmessage
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
        
        if s0020 = sexitflag  then do:
            undo mainloop, leave mainloop.
        end.
        else do:
            find first po_mstr where po_nbr = s0020 no-lock no-error .
            if s0020 = "" or ( not avail po_mstr ) then do:
                display
                    "无效采购单号" @ sMessage
                with frame f0020.
                undo, retry.
            end.
        end.
        
        leave lp0020.
    end. /*lp0020*/
