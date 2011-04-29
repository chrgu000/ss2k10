/* xxlogrp002.p - user logs save and delete                                 */
/*----rev history-------------------------------------------------------------------------------------*/
/* REVISION: 1.0      Created : 20100519   BY: Roger Xiao     */
/* SS - 100401.1  By: Roger Xiao */



{mfdtitle.i "100519.1"}

define var v_date      as date .
define var v_date1     as date .
define var v_menu      as char format "x(18)" .
define var v_menu1     as char format "x(18)" .
define var v_user      like usr_userid .
define var v_user1     like usr_userid .
define var v_yn        as logical format "S)汇总 /D)明细" .
define var v_del       as logical format "Y)删除 /N)不删除".
define var v_filename  as char format "x(30)".
define var v_filedft  as char format "x(30)".

define var v_user_name like usr_name  .
define var v_menu_label like mnt_label .

define frame a .
form
    SKIP(.2)
    skip(1)
    v_del                 colon 18 label "从数据库删除Y/N" 
    v_filename            colon 18 label "备份文件名"
    skip(1)
    v_user                colon 18  label "用户ID"
    v_user1               colon 53  label "至"
    v_menu                colon 18  label "菜单"
    v_menu1               colon 53  label "至"
    v_date                colon 18  label "日期"
    v_date1               colon 53  label "至"
    v_yn                  colon 18  label "S)汇总/D)明细"

skip(2) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

v_filedft = "User-Log-to-" + string(year(today)) + string(month(today),"99") + string(day(today),"99") + ".txt".
v_date1   = today - 1 .

{wbrp01.i}
repeat:
    if v_date     = low_date then v_date  = ? .
    if v_date1    = hi_date  then v_date1 = ? .
    if v_menu1    = hi_char  then v_menu1 = "" .
    if v_user1    = hi_char  then v_user1 = "" .
    if v_filename = "" then v_filename = v_filedft.

    update 
        v_del
        v_filename

        v_user     
        v_user1    
        v_menu     
        v_menu1    
        v_date     
        v_date1
        v_yn
    with frame a.

    if v_date     = ?  then v_date      =  low_date.
    if v_date1    = ?  then v_date1     =  hi_date .
    if v_menu1    = "" then v_menu1     =  hi_char .
    if v_user1    = "" then v_user1     =  hi_char .

    if v_del = yes then do:
        if v_filename = "" then v_filename = v_filedft .
    end.

    /* PRINTER SELECTION */
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = " "
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}
mainloop: 
do on error undo, return error on endkey undo, return error:                    
{mfphead.i}


for each xu_hist 
    where xu_domain = global_domain 
    and xu_user >= v_user and xu_user <= v_user1 
    and xu_menu >= v_menu and xu_menu <= v_menu1 
    and xu_start_date >= v_date  and xu_start_date <= v_date1 
    no-lock 
    break by xu_domain by xu_user by xu_menu  by xu_program by xu_start_date desc  
    with frame x1 width 200 :

    if xu_program = "xxcomp.p" or xu_program = "ddcomp.p" then next .

    if first-of(xu_user) then do:
        find first usr_mstr where usr_userid = xu_user no-lock no-error .
        v_user_name = if avail usr_mstr then usr_name else "".
    end.

    if first-of(xu_menu) then do:
        find first mnt_det  
            where ( mnt_nbr + "." + string(mnt_select)) = xu_menu 
            and mnt_lang = global_user_lang
        no-lock no-error .
        v_menu_label = if avail mnt_det then mnt_label else "" .
    end.

    if v_yn = no then do:
        disp 
            xu_user          label "用户ID"
            v_user_name      label "用户名"
            xu_menu          label "菜单"
            v_menu_label     label "菜单名"
            xu_program       label "程式名"
            xu_start_date                     label "开始日期"
            string(xu_start_time, "HH:MM:SS") label "开始时间"
            string(xu_end_time ,"HH:MM:SS")   label "结束时间" when xu_end_date <> ? 
            xu_end_date                       label "结束日期"
            xu_ip                             label "登录IP"
        with frame x1 .
    end.
    else do:
        if last-of(xu_program) then 
            disp 
                xu_user          label "用户ID"  
                v_user_name      label "用户名"  
                xu_menu          label "菜单"    
                v_menu_label     label "菜单名"  
                xu_program       label "程式名"  
            with frame x1 .
    end.
    

end. /*for each xu_hist*/
end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */

    if v_del then do:  /*删除*/
        output to value(v_filename) append.
        put "==================================================================================" skip.
        put "UserLog Deleted From (" sdbname(1) ") and Saved By " global_userid " On Date " today " Time " string(time,"HH:MM") skip .
        put skip(2) .

        for each xu_hist 
            where xu_domain = global_domain 
            and xu_user >= v_user and xu_user <= v_user1 
            and xu_menu >= v_menu and xu_menu <= v_menu1 
            and xu_start_date >= v_date  and xu_start_date <= v_date1 
            exclusive-lock 
            break by xu_domain by xu_user by xu_menu  by xu_program by xu_start_date desc  
            with frame x2 width 200 :

            if first-of(xu_user) then do:
                find first usr_mstr where usr_userid = xu_user no-lock no-error .
                v_user_name = if avail usr_mstr then usr_name else "".
            end.

            if first-of(xu_menu) then do:
                find first mnt_det  
                    where ( mnt_nbr + "." + string(mnt_select)) = xu_menu 
                    and mnt_lang = global_user_lang
                no-lock no-error .
                v_menu_label = if avail mnt_det then mnt_label else "" .
            end.

            if v_yn = no then do:
                disp 
                    xu_user          label "用户ID"
                    v_user_name      label "用户名"
                    xu_menu          label "菜单"
                    v_menu_label     label "菜单名"
                    xu_program       label "程式名"
                    xu_start_date                     label "开始日期"
                    string(xu_start_time, "HH:MM:SS") label "开始时间"
                    string(xu_end_time ,"HH:MM:SS")   label "结束时间" when xu_end_date <> ? 
                    xu_end_date                       label "结束日期"
                    xu_ip                             label "登录IP"
                with frame x2 .
            end.
            else do:
                if last-of(xu_program) then 
                    disp 
                        xu_user          label "用户ID"  
                        v_user_name      label "用户名"  
                        xu_menu          label "菜单"    
                        v_menu_label     label "菜单名"  
                        xu_program       label "程式名"  
                    with frame x2 .
            end.
            
            delete xu_hist .
        end. /*for each xu_hist*/   
        
        output close .
        message "删除结束" .
    end. /*删除*/

end.  /* REPEAT */
{wbrp04.i &frame-spec = a}

