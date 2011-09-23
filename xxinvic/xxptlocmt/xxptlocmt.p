/* xxptlocmt.p 料品库位容量维护    */
/* REVISION: 110316.1   Created On: 20110316   By: Softspeed Roger Xiao                               */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110316.1  By: Roger Xiao */
/* SS - 110322.1  By: Roger Xiao */ /* 拆分库位和过道库位,区分是减震器SA还是转向器PS */
/*-Revision end---------------------------------------------------------------*/


/* DISPLAY TITLE */
{mfdtitle.i "110322.1"}


define var part       like pt_part no-undo.
define var site       like pt_site no-undo.
define var loc        like pt_loc  no-undo.
define var v_loctype  as char format "x(1)" no-undo .
define var del-yn     like mfc_logical initial yes.





find first icc_ctrl no-lock no-error.
site = if avail icc_ctrl then icc_site else "GSA01" .
v_loctype = "1" .
form
    SKIP(.2)
    v_loctype                colon 18 label "库位类型"    "   (1-固定, 2-拆分, 3-临时, 4-过道)" 

    site                     colon 18
    loc                      colon 18 
    loc_Desc                 colon 52 no-label 

    part                     colon 18 
    pt_desc1                 colon 52 no-label
    pt_desc2                 colon 52 no-label

    skip(1)
    xxloc_qty                colon 18 label "容量"        "(可放置的托数)"
    xxloc_part_type              colon 18 label "部品类型(PS/SA)" 

with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

view frame a.

mainloop:
repeat with frame a:
    clear frame a no-pause .

    disp site with frame a .


    ststatus = stline[1].
    status input ststatus.

    update v_loctype loc part with frame a editing:
         if frame-field = "loc" then do:
             {mfnp11.i loc_mstr loc_loc "loc_site = site and loc_loc" "input loc" }

             if recno <> ? then do:
                    display 
                        loc_loc  @ loc 
                        loc_desc 
                    with frame a .
             end . /* if recno <> ? then  do: */
         end.
         else if frame-field = "part" then do:
             {mfnp11.i pt_mstr pt_part pt_part  "input part" }

             if recno <> ? then do:
                    display 
                        pt_part  @ part 
                        pt_desc1 
                        pt_desc2
                    with frame a .
             end . /* if recno <> ? then  do: */
         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* update...EDITING */

    if site <> "" and ( not can-find(si_mstr where si_site = site ) ) then do:
        message "错误:地点不存在,请重新输入" .
        undo , retry .
    end.

    if index("1234",v_loctype) = 0 then do:
        message "错误:无效库位类型,请重新输入" .
        next-prompt v_loctype with frame a.
        undo,retry.
    end.
    

    find first loc_mstr where loc_site = site and loc_loc = loc no-lock no-error.
    if not avail loc_mstr  then do :
        message "错误:库位不存在,请重新输入" .
        next-prompt loc  with frame a .
        undo , retry .
    end.    

    if v_loctype = "1" then do:
        find first pt_mstr where pt_part = part no-lock no-error.
        if not avail pt_mstr  then do :
            message "错误:固定库位,指定的零件号不存在,请重新输入" .
            next-prompt part  with frame a .
            undo , retry .
        end.   
        disp 
            part pt_desc1 pt_desc2 
        with frame a .
        
    end.
    else if part <> "" then do:
        message "错误:非固定库位,零件号请留空,请重新输入" .
        next-prompt part  with frame a .
        undo , retry .
    end.

    disp 
        site  
        loc loc_Desc
        v_loctype
    with frame a .

    setloop:
    do on error undo ,retry on endkey undo,leave :
        find first xxloc_det
            where xxloc_part = part 
            and   xxloc_loc  = loc
        no-error.
        if not avail xxloc_det then do:
            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} 
            create xxloc_det.
            assign xxloc_part = part
                   xxloc_loc  = loc
                   xxloc_type = v_loctype
                   xxloc_qty  = if index("123",v_loctype) > 0 then 1 else 999999
                   .
        end.
        else do:
            {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1} 
        end.

        update            
            xxloc_qty
            xxloc_part_type when (xxloc_type = "2" or xxloc_type = "4" )
        go-on ("F5" "CTRL-D") with frame a editing :
                readkey.
                if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                    {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
                    if del-yn then do :
                            delete xxloc_det.
                            next mainloop .
                    end.
                end. /*   "F5" "CTRL-D" */
                else apply lastkey.
        end. /* update ...EDITING */

        if xxloc_qty < 1 then do:
            message "错误:库存容量仅限正数,请重新输入" .
            undo,retry.
        end.

        if index("23",v_loctype) > 0 and xxloc_qty <> 1 then do:
            message "错误:此类型库位,库存容量仅限1托,请重新输入" .
            undo,retry.
        end.

        if xxloc_part_type <> "" 
            and not (xxloc_part_type <> "sa" or xxloc_part_type <> "ps")
        then do:
            message "错误:此类型库位,仅限部品类型(PS/SA),请重新输入" .
            next-prompt xxloc_part_type with frame a.
            undo,retry.
        end.

        assign xxloc_mod_date = today 
               xxloc_mod_user = global_userid 
               .

    end. /*  setloop: */



end.   /*  mainloop: */
status input.



