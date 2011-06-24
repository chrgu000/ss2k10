    define var v_recno as recid . /*for roll bar*/

    lp0060:
    repeat on endkey undo, retry:
        hide all.
        define variable s0060   as character format "x(50)" no-undo.
        define variable s0060_1 as character format "x(50)" no-undo.
        define variable s0060_2 as character format "x(50)" no-undo.
        define variable s0060_3 as character format "x(50)" no-undo.
        define variable s0060_4 as character format "x(50)" no-undo.
        define variable s0060_5 as character format "x(50)" no-undo.
        define variable s0060_6 as character format "x(50)" no-undo.
        define variable s0060_7 as character format "x(50)" no-undo.
        define variable s0060_8 as character format "x(50)" no-undo.

        form
            stitle
            s0060_1
            s0060_2
            s0060_3
            s0060_4
            s0060_5
            s0060_6
            s0060
            smessage
        with frame f0060 no-labels no-box.

        
        assign
            s0060_1 = "打印机?"
            s0060_6 = spromptmessage
            .

        find first upd_det where upd_nbr = "xsposn10" and upd_select = 99 no-lock no-error.
        s0060 = if available ( upd_det ) then upd_dev else "" . /*默认打印机*/       

        display
            stitle
            s0060_1
            s0060_2
            s0060_3
            s0060_4
            s0060_5
            s0060_6
        with frame f0060.
        
        update
            s0060
        with frame f0060
        editing:
            {xsreadkey.i}
            v_recno = ? .
            display  "" @ smessage with frame f0060.
            if lastkey = keycode("f10") or keyfunction(lastkey) = "cursor-down"
            then do:
               if v_recno = ? then
                  find first prd_det where 
                              prd_dev >  input s0060
                   no-lock no-error.
               else
                  find next prd_det where 
                   no-lock no-error.
                  if not available prd_det then do: 
                      if v_recno <> ? then 
                          find prd_det where recid(prd_det) = v_recno no-lock no-error .
                      else 
                          find last prd_det where 
                          no-lock no-error.
                  end. 
                  v_recno = recid(prd_det) .
                  if available prd_det then display skip 
                         prd_dev @ s0060 prd_desc @ smessage no-label with frame f0060.
                  else   display "" @ smessage with frame f0060.
            end.
            if lastkey = keycode("f9") or keyfunction(lastkey) = "cursor-up"
            then do:
               if v_recno = ? then
                  find last prd_det where 
                              prd_dev <  input s0060
                  no-lock no-error.
               else 
                  find prev prd_det where 
                  no-lock no-error.
                  if not available prd_det then do: 
                      if v_recno <> ? then 
                          find prd_det where recid(prd_det) = v_recno no-lock no-error .
                      else 
                          find first prd_det where 
                          no-lock no-error.
                  end. 
                  v_recno = recid(prd_det) .
                  if available prd_det then display skip 
                         prd_dev @ s0060 prd_desc @ smessage no-label with frame f0060.
                  else   display  "" @ smessage with frame f0060.
            end.
            apply lastkey.
        end.
        

        if s0060 = sexitflag then do:
            undo mainloop, leave mainloop.
        end.
        else do:
            find first prd_det where prd_dev = s0060  no-lock no-error.
            if not available prd_det then do:
                    display "无效打印机" @ smessage no-label with frame f0060.
                    undo, retry.
            end.            
        end.
        
        leave lp0060.
    end. /*lp0060*/
