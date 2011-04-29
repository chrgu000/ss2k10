/* xxpspm.p - 生产计划排程控制档  */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110328.1  By: Roger Xiao */ /* created */
/* SS - 110421.1  By: Roger Xiao */ /* bug fixed */
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "110421.1"}

define var site               like si_site .
define var v_time_stock       as char format "99:99" .


define var del-yn             like mfc_logical initial no.
define var v_ii               as integer .


form
    site                      colon 18  label "地点"     si_desc no-label
    skip(1)
    xxpsc_time_chg            colon 18  label "固定换线时间"  "(分钟)"
    xxpsc_time_delay          colon 18  label "班次正常延迟"  "(分钟)"
    xxpsc_time_overtime       colon 18  label "加班时间单位"  "(分钟)"
    v_time_stock              colon 18  label "理论库存时间点"  
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

    update site with frame a editing:
         if frame-field = "site" then do:
             {mfnp11.i xxpsc_ctrl  xxpsc_site xxpsc_site " input site"  }
             if recno <> ? then do:
                find first si_mstr where si_site = xxpsc_site no-lock no-error.
                if avail si_mstr then disp si_desc with frame a .
                v_time_stock = entry(1,string(xxpsc_time_stock,"hh:mm"),":") + entry(2,string(xxpsc_time_stock,"hh:mm"),":") .
                disp 
                    xxpsc_site  @ site
                    v_time_stock
                    xxpsc_time_chg       
                    xxpsc_time_delay     
                    xxpsc_time_overtime  
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
    disp si_desc with frame a .
        

    setloop:
    do on error undo ,retry on endkey undo, leave:
        find first xxpsc_ctrl where xxpsc_site = site exclusive-lock no-error .
        if not avail xxpsc_ctrl then do :
                {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} 
                create xxpsc_ctrl .
                assign xxpsc_site      = site
                       .
        end.
        else do:
            {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1} 
        end.

        v_time_stock = entry(1,string(xxpsc_time_stock,"hh:mm"),":") + entry(2,string(xxpsc_time_stock,"hh:mm"),":") .
        disp 
            xxpsc_site  @ site
            v_time_stock
            xxpsc_time_chg      
            xxpsc_time_delay    
            xxpsc_time_overtime 
        with frame a . 


        update 
            xxpsc_time_chg      
            xxpsc_time_delay    
            xxpsc_time_overtime 
            v_time_stock
        go-on (F5 CTRL-D)
        with frame a .

        if (lastkey = keycode("F5") or
            lastkey = keycode("CTRL-D"))
        then do:
            del-yn = yes.
            {mfmsg01.i 11 1 del-yn}
            if del-yn then do:
                delete xxpsc_ctrl .
                v_time_stock = "0000" .
                {pxmsg.i &MSGNUM=24 &ERRORLEVEL=3 }
                clear frame a all no-pause.
                next mainloop.
            end.
            else undo, retry.
        end. /* CTRL-D */

        if length(v_time_stock) < 4 then do:
            message "错误:时间格式有误(HH:MM),请重新输入" .
            next-prompt v_time_stock with frame a .
            undo,retry.
        end.

        if integer(substring(v_time_stock,1,2)) > 23 then do:
            message "错误:时间格式有误(小时),请重新输入" .
            next-prompt v_time_stock with frame a .
            undo,retry.
        end.

        if integer(substring(v_time_stock,3,2)) > 59 then do:
            message "错误:时间格式有误(分钟),请重新输入" .
            next-prompt v_time_stock with frame a .
            undo,retry.
        end.        

        assign  xxpsc_mod_date = today 
                xxpsc_mod_user = global_userid
                xxpsc_time_stock = integer(substring(v_time_stock,1,2)) * 60 * 60 +  integer(substring(v_time_stock,3,2)) * 60
                .

    end. /*  setloop: */
end.   /*  mainloop: */
status input.

