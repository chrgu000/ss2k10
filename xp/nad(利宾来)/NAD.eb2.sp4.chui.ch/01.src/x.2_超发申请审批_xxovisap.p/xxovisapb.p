/* xxovismtb.p - 超发申请单维护子程式,检查是否有权限:新增/修改/删除  */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110121.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}

define input  parameter v_user      as char no-undo .
define input  parameter v_todo      as char no-undo .
define input  parameter v_pct       as decimal no-undo.
define input  parameter v_site      as char no-undo .
define output parameter v_error     as logical  no-undo.

v_error = no .
find first xovc_ctrl where xovc_site = v_site no-lock no-error.
if not avail xovc_ctrl then v_error = yes .
else do:
    if v_todo = "add" and index(xovc_add_user + "," , v_user + ",") = 0 then v_error = yes .
    if v_todo = "mod" and index(xovc_mod_user + "," , v_user + ",") = 0 then v_error = yes .
    if v_todo = "del" and index(xovc_del_user + "," , v_user + ",") = 0 then v_error = yes .
    if v_todo = "app" then do:
        if      index(xovc_app_user[1] + "," , v_user + ",") = 0 
            and index(xovc_app_user[2] + "," , v_user + ",") = 0 
            and index(xovc_app_user[3] + "," , v_user + ",") = 0 
            and index(xovc_app_user[4] + "," , v_user + ",") = 0 
            and index(xovc_app_user[5] + "," , v_user + ",") = 0 
        then v_error = yes .
        else if not (
                   (index(xovc_app_user[1] + "," , v_user + ",") <> 0 and xovc_app_lvl[1] >= v_pct )
                or (index(xovc_app_user[2] + "," , v_user + ",") <> 0 and xovc_app_lvl[2] >= v_pct )
                or (index(xovc_app_user[3] + "," , v_user + ",") <> 0 and xovc_app_lvl[3] >= v_pct )
                or (index(xovc_app_user[4] + "," , v_user + ",") <> 0 and xovc_app_lvl[4] >= v_pct )
                or (index(xovc_app_user[5] + "," , v_user + ",") <> 0 and xovc_app_lvl[5] >= v_pct )
                ) then v_error = yes .        
    end. /*if v_todo = "app"*/
end. /*else do:*/