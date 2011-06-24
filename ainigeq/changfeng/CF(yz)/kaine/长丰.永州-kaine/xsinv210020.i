/* xsinv210020.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 备注 */
lp0020:
repeat on endkey undo, retry:
    hide all.
    define variable s0020             as character format "x(50)".
    define variable s0020_1           as character format "x(50)".
    define variable s0020_2           as character format "x(50)".
    define variable s0020_3           as character format "x(50)".
    define variable s0020_4           as character format "x(50)".
    define variable s0020_5           as character format "x(50)".
    
    form
        sTitle
        s0020_1
        s0020_2
        s0020_3
        s0020_4
        s0020_5
        s0020
        sMessage
    with frame f0020 no-labels no-box.

    assign
        s0020_1 = "备注代码"
        s0020_5 = sPromptMessage
        .
    
    /* SS - 090916.1 - B */
    /* 在扫描枪上,没有上下键,用户输入前不明确有哪些可能.
     * 所以列表显示备注代码,供用户输入.
     */
    assign
        i = 1
        j = 0
        s1 = ""
        .
    for each code_mstr
        no-lock
        where code_fldname = "iss_unp_rmks" 
        use-index code_fldval
    :
        j = (j + 1) modulo 2.
        s1[i] = s1[i] + string(code_value + "-" + code_cmmt + ";", "x(12)").
        if j = 0 then i = i + 1.
    end.
    assign
        s0020_2 = s1[1]
        s0020_3 = s1[2]
        s0020_4 = s1[3]
        .
    /* SS - 090916.1 - E */
    
    display
        sTitle
        s0020_1
        s0020_2
        s0020_3
        s0020_4
        s0020_5
    with frame f0020.
    
    update
        s0020
    with frame f0020
    editing:
        /* SS - 090914.1 - B
        readkey.
        SS - 090914.1 - E */

        /* SS - 090914.1 - B */
        {xsreadkey.i}
        /* SS - 090914.1 - E */

        if lastkey = keycode("F10") 
            or keyfunction(lastkey) = "cursor-down"
        then do:
            if recid(code_mstr) = ? then 
                find first code_mstr 
                    where code_fldname = "iss_unp_rmks" 
                        and code_value >= input s0020
                    use-index code_fldval
                    no-lock 
                    no-error.
            else 
                find next code_mstr 
                    where code_fldname = "iss_unp_rmks"  
                        and code_value >= input s0020
                    use-index code_fldval
                    no-lock 
                    no-error.
            if available(code_mstr) then 
                display skip 
                    code_value @ s0020 
                    code_cmmt @ sMessage
                with frame f0020.
            else   
                display 
                    "" @ sMessage 
                with frame f0020.
        end.
        else if lastkey = keycode("F9") 
            or keyfunction(lastkey) = "cursor-up"
        then do:
            if recid(code_mstr) = ? then 
                find first code_mstr 
                    where code_fldname = "iss_unp_rmks" 
                        and code_value <= input s0020
                    use-index code_fldval
                    no-lock 
                    no-error.
            else 
                find prev code_mstr 
                    where code_fldname = "iss_unp_rmks"  
                        and code_value <= input s0020
                    use-index code_fldval
                    no-lock 
                    no-error.
            if available(code_mstr) then 
                display skip 
                    code_value @ s0020 
                    code_cmmt @ sMessage
                with frame f0020.
            else   
                display 
                    "" @ sMessage 
                with frame f0020.
        end.
        else do:
            apply lastkey.
        end.
        /* SS - 090914.1 - B */
        find first code_mstr 
            where code_fldname = "iss_unp_rmks" 
                and code_value = input s0020
            use-index code_fldval
            no-lock 
            no-error.
        if available(code_mstr) then
            display code_cmmt @ sMessage with frame f0020.
        else
            display "" @ sMessage with frame f0020.
        /* SS - 090914.1 - E */
    end.
    
    if s0020 = sExitFlag then do:
        undo mainloop, leave mainloop.
    end.
    else do:
        find first code_mstr 
            where code_fldname = "iss_unp_rmks"  
                and code_value = s0020
            use-index code_fldval
            no-lock 
            no-error.
        if not(available(code_mstr)) then do:
            display
                "备注代码有误" @ sMessage
            with frame f0020.
            undo, retry.
        end.
    end.
    
    leave lp0020.
END.

