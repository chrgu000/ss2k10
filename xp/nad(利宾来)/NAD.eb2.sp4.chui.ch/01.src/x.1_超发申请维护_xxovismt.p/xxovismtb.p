/* xxovismtb.p - 超发申请单维护子程式,检查是否有权限:新增/修改/删除  */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110120.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}

define input  parameter v_user      as char no-undo .
define input  parameter v_todo      as char no-undo .
define input  parameter v_site      as char no-undo .
define output parameter v_error     as logical  no-undo.

v_error = no .
find first xovc_ctrl where xovc_site = v_site no-lock no-error.
if not avail xovc_ctrl then v_error = yes .
else do:
    if v_todo = "add" and index(xovc_add_user + "," , v_user + ",") = 0 then v_error = yes .
    if v_todo = "mod" and index(xovc_mod_user + "," , v_user + ",") = 0 then v_error = yes .
    if v_todo = "del" and index(xovc_del_user + "," , v_user + ",") = 0 then v_error = yes .
end.