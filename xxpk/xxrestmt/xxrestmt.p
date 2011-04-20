/* xxrestmt.p - 生产线休息时间维护  */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110328.1  By: Roger Xiao */ /* created */
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "110328.1"}

define var site               like xxrest_site .
define var v_line             like xxrest_line  .
define var v_shift            like xxrest_shift init 1.
define var v_seq              like xxrest_seq   init 1.
define var v_start            like xxrest_start init today.
define var v_time_start       as character format "99:99" .

define var del-yn             like mfc_logical initial no.
define var v_ii               as integer .

form
    site                      colon 18  label "地点"     si_desc no-label
    v_line                    colon 18  label "生产线"   ln_desc no-label
    v_shift                   colon 18  label "班次"
    v_seq                     colon 18  label "休息时点"
    v_start                   colon 18  label "生效日期"
    xxrest_end                colon 18  label "到期日期"
    skip(1)
    v_time_start              colon 18  label "休息开始时间"
    xxrest_time_length        colon 18  label "休息时长"  "(分钟)"
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
        v_shift
        v_seq
        v_start
    with frame a editing:
         if frame-field = "site" then do:
             {mfnp11.i xxrest_det  xxrest_line xxrest_site " input site"  }
             if recno <> ? then do:
                find first si_mstr where si_site = xxrest_site no-lock no-error.
                if avail si_mstr then disp si_desc with frame a .
                disp
                    xxrest_site  @ site
                    xxrest_line  @ v_line
                    xxrest_shift @ v_shift
                    xxrest_seq   @ v_seq
                    xxrest_start @ v_start
                    xxrest_end
                    string(xxrest_time_start,"hh:mm") @  v_time_start
                    xxrest_time_length
                with frame a .
             end . /* if recno <> ? then  do: */
         end.
         else if frame-field = "v_line" then do:
             {mfnp11.i xxrest_det  xxrest_line "xxrest_site = input site and xxrest_line" "input v_line"  }
             if recno <> ? then do:
                find first ln_mstr where ln_line = xxrest_line and ln_site = xxrest_site no-lock no-error.
                if avail ln_mstr then disp ln_desc with frame a .
                disp
                    xxrest_site  @ site
                    xxrest_line  @ v_line
                    xxrest_shift @ v_shift
                    xxrest_seq   @ v_seq
                    xxrest_start @ v_start
                    xxrest_end
                    string(xxrest_time_start,"hh:mm") @  v_time_start
                    xxrest_time_length
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
        find first xxrest_det
          where xxrest_site   = site
            and xxrest_line   = v_line
            and xxrest_shift  = v_shift
            and xxrest_seq    = v_seq
            and xxrest_start  = v_start
        exclusive-lock no-error .
        if not avail xxrest_det then do :
                {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
                create xxrest_det .
                assign xxrest_site   = site
                       xxrest_line   = v_line
                       xxrest_shift  = v_shift
                       xxrest_seq    = v_seq
                       xxrest_start  = v_start
                       .
        end.
        else do:
            {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1}
        end.

        v_time_start = if xxrest_time_start <> 0 then string(xxrest_time_start,"hh:mm") else "" .

        disp
                    xxrest_site  @ site
                    xxrest_line  @ v_line
                    xxrest_shift @ v_shift
                    xxrest_seq   @ v_seq
                    xxrest_start @ v_start
                    xxrest_end
                    v_time_start
                    xxrest_time_length
        with frame a .

        update
                    xxrest_end
                    v_time_start
                    xxrest_time_length
        go-on (F5 CTRL-D)
        with frame a .

        if (lastkey = keycode("F5") or
            lastkey = keycode("CTRL-D"))
        then do:
            del-yn = yes.
            {mfmsg01.i 11 1 del-yn}
            if del-yn then do:
                delete xxrest_det .
                {pxmsg.i &MSGNUM=24 &ERRORLEVEL=3 }
                clear frame a all no-pause.
                next mainloop.
            end.
            else undo, retry.
        end. /* CTRL-D */

        if length(v_time_start) < 4 then do:
            message "错误:时间格式有误(HH:MM),请重新输入" .
            next-prompt v_time_start with frame a .
            undo,retry.
        end.

        if integer(substring(v_time_start,1,2)) > 23 then do:
            message "错误:时间格式有误(小时),请重新输入" .
            next-prompt v_time_start with frame a .
            undo,retry.
        end.

        if integer(substring(v_time_start,2,2)) > 59 then do:
            message "错误:时间格式有误(分钟),请重新输入" .
            next-prompt v_time_start with frame a .
            undo,retry.
        end.

        assign  xxrest_mod_date   = today
                xxrest_mod_user   = global_userid
                xxrest_time_start = integer(substring(v_time_start,1,2)) * 60 * 60 +  integer(substring(v_time_start,3,2)) * 60
                .

    end. /*  setloop: */
end.   /*  mainloop: */
status input.

