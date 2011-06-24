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

        

        i = 0 .
        for each prh_hist 
            use-index prh_rcp_date
            where prh_rcp_date = s0030
            and   prh_nbr = s0020 
            no-lock break by prh_nbr by prh_receiver :

            if first-of(prh_receiver) then do:
                i = i + 1 .
                if i = 1 then s0040_2 = prh_receiver .
                if i = 2 then s0040_3 = prh_receiver .
                if i = 3 then s0040_4 = prh_receiver .
                if i = 4 then s0040_5 = prh_receiver .
            end.
        end.

        assign
            s0040_1 = if (s0040_2 = "" and s0040_3 = "" and s0040_4 = "" and s0040_5 = "" ) then "采购单当日无收货." else "收货单号:"
            s0040_6 = sConfirmOrExit
            s0040   = sConfirm
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
            if s0040 <> sConfirm then do:
                    display
                        "输入无效" @ sMessage
                    with frame f0040.
                    undo, retry.
            end.
            find first prh_hist 
                use-index prh_rcp_date
                where prh_rcp_date = s0030
                and   prh_nbr = s0020 
            no-lock no-error .
            if not avail prh_hist then do:
                next mainloop.
            end.
        end.
        
        leave lp0040.
    end. /*lp0040*/
