/* xxovtmmt.p - 生产线法定加班时间上限维护  */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110328.1  By: Roger Xiao */ /* created */
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "110328.1"}

define var site               like xxovd_site .
define var v_line             like xxovd_line  .

define var del-yn             like mfc_logical initial no.
define var v_ii               as integer .

form
    site                      colon 18  label "地点"     si_desc no-label
    v_line                    colon 18  label "生产线"   ln_desc no-label
    skip(1)
    xxovd_day                 colon 18  label "每日加班最多"  "(小时)"
    xxovd_month               colon 18  label "每日加班最多"  "(小时)"
    xxovd_last                colon 18  label "连续上班天数" 

with frame a             
side-labels              
width 80 .               

view frame a.

find icc_ctrl no-lock no-error.
site = if avail icc_ctrl then icc_site else "gsa01" .

mainloop:
repeat with frame a:
    ststatus = stline[1].
    status input ststatus.

    update 
        site
        v_line
    with frame a editing:
         if frame-field = "site" then do:
             {mfnp11.i xxovd_det  xxovd_line xxovd_site " input site"  }
             if recno <> ? then do:
                find first si_mstr where si_site = xxovd_site no-lock no-error.
                if avail si_mstr then disp si_desc with frame a .
                disp 
                    xxovd_site  @ site
                    xxovd_line  @ v_line  
                    xxovd_day  
                    xxovd_month
                    xxovd_last 
                with frame a .
             end . /* if recno <> ? then  do: */
         end.
         else if frame-field = "v_line" then do:
             {mfnp11.i xxovd_det  xxovd_line "xxovd_site = input site and xxovd_line" "input v_line"  }
             if recno <> ? then do:
                find first ln_mstr where ln_line = xxovd_line and ln_site = xxovd_site no-lock no-error.
                if avail ln_mstr then disp ln_desc with frame a .
                disp 
                    xxovd_site  @ site
                    xxovd_line  @ v_line  
                    xxovd_day  
                    xxovd_month
                    xxovd_last 
                with frame a .
             end . /* if recno <> ? then  do: */
         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* update..EDITING */

    find first si_mstr where si_site = site no-lock no-error.
    if not avail si_mstr then do:
        message "错误:无效地点,请重新输入" .
        undo,retry.
    end.

    find first ln_mstr where ln_line = v_line and ln_site = site no-lock no-error.
    if not avail ln_mstr then do:
        message "错误:无效生产线/地点,请重新输入" .
        next-prompt v_line with frame a .
        undo,retry.
    end.

    disp si_desc ln_desc with frame a .


    setloop:
    do on error undo ,retry on endkey undo, leave:
        find first xxovd_det 
          where xxovd_site   = site 
            and xxovd_line   = v_line
        exclusive-lock no-error .
        if not avail xxovd_det then do :
                {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} 
                create xxovd_det .
                assign xxovd_site   = site       
                       xxovd_line   = v_line     
                       .
        end.
        else do:
            {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1} 
        end.
        
        disp 
                xxovd_site  @ site
                xxovd_line  @ v_line  
                xxovd_day  
                xxovd_month
                xxovd_last 
        with frame a . 

        update 
                xxovd_day  
                xxovd_month
                xxovd_last 
        go-on (F5 CTRL-D)
        with frame a .

        if (lastkey = keycode("F5") or
            lastkey = keycode("CTRL-D"))
        then do:
            del-yn = yes.
            {mfmsg01.i 11 1 del-yn}
            if del-yn then do:
                delete xxovd_det .
                {pxmsg.i &MSGNUM=24 &ERRORLEVEL=3 }
                clear frame a all no-pause.
                next mainloop.
            end.
            else undo, retry.
        end. /* CTRL-D */

        if xxovd_day > xxovd_month then do:
            message "错误:每月可加班时间小于每日可加班时间" .
            undo,retry.
        end.

        if xxovd_last <= 0  then do:
            message "错误:连续上班天数必须为正数" .
            undo,retry.
        end.
        

        assign  xxovd_mod_date   = today 
                xxovd_mod_user   = global_userid
                .

    end. /*  setloop: */
end.   /*  mainloop: */
status input.

