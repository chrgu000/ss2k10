/*xxlogin-eb21.i  create by SoftSpeed Roger Xiao ,Used by mfmenu.p  */
/* SS - 100401.1  By: Roger Xiao */


/*
if global_userid = "mfg" then 
message 
    "程式:" trun_file + ".p" skip 
    "用户:" global_userid  skip 
    "菜单:" thismenu  skip 
    "标签:" c-menu-label
view-as alert-box.
*/


define var v_ip         as char format "x(15)" .
define var v_start_date as date .
define var v_start_time as integer .
define var v_program    as char .
define var v_menu       as char .
define var v_rec        as recid .


v_start_date = today .
v_start_time = time .
v_program    = trun_file + ".p" .


/*取菜单号****************/
v_menu = "" .
find first mnd_det 
    use-index mnd_exec
    where mnd_exec = v_program 
no-lock no-error.
if avail mnd_det then do:
    if avail mnd_det then v_menu = mnd_nbr + "."  + string(mnd_select) .
end.

/*取此进程的登录IP********/
v_ip = "".
unix silent value("who -m > " + mfguser ) .
input from value(mfguser) .
    import unformatted v_ip .
input close .
unix silent value("rm " + mfguser) .

v_ip = substring(v_ip,index(v_ip,"(") + 1 ).
v_ip = substring(v_ip,1,index(v_ip,")") - 1 ) .

do transaction:
        /*记录到表xu_hist*/
        find first xu_hist 
            where xu_domain    = global_domain 
            and xu_session     = mfguser 
            and xu_menu        = v_menu  /*标准变量为何值不对?**thismenu*/ 
            and xu_program     = v_program
            and xu_start_date  = v_start_date
            and xu_start_time  = v_start_time
        exclusive-lock no-error.
        if not avail xu_hist then do:
            create xu_hist .
            assign xu_domain     = global_domain  
                   xu_session    = mfguser
                   xu_menu       = v_menu           
                   xu_program    = v_program      
                   xu_start_date = v_start_date 
                   xu_start_time = v_start_time 
                   xu_user       = global_userid    
                   xu_ip         = v_ip 
                   .
        end.

        v_rec = recid(xu_hist) .
        release xu_hist .
end.

hide all no-pause .
