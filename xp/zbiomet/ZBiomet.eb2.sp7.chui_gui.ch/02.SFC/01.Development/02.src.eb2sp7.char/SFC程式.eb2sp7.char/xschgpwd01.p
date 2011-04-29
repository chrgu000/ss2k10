/* xschgpwd01.p  密码修改                                                 */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */


define var v_pwd_old  as char format "x(16)" .
define var v_pwd_new1 as char format "x(16)" .
define var v_pwd_new2 as char format "x(16)" .



form
    skip(1)
    v_user           colon 25 label "用户"  
    xemp_lname        no-label
    v_pwd_old        colon 25 label "旧密码"
    skip(1)
    v_pwd_new1       colon 25 label "新密码" 
    v_pwd_new2       colon 25 label "确认新密码"  
with frame a 
title color normal "密码修改"
side-labels width 80 .   



hide all no-pause .
view frame a .

v_pwd_old   = "" . 
v_pwd_new1  = "" .
v_pwd_new2  = "" .

mainloop:
repeat :
    
       clear frame a no-pause .
        

        find first xemp_mstr where xemp_addr = v_user no-lock no-error .
        if not avail xemp_mstr then do:
            message "无效用户,请重新输入.".
            undo,leave .
        end.
        disp v_user xemp_lname with frame a .

        update v_pwd_old  v_pwd_new1  v_pwd_new2 with frame a .
        assign v_pwd_old  = caps(v_pwd_old) 
               v_pwd_new1 = caps(v_pwd_new1) 
               v_pwd_new2 = caps(v_pwd_new2) .


        if v_pwd_old = ""  then do:
            message "不允许空密码" .
            next-prompt v_pwd_old with frame a .
            undo,retry .
        end.

        if xemp__chr01 <> encode(v_pwd_old) then do:
            message "请正确输入旧密码".
            next-prompt v_pwd_old with frame a .
            undo,retry .
        end.




        if v_pwd_new1 = ""  then do:
            message "不允许空密码" .
            next-prompt v_pwd_new1 with frame a .
            undo,retry .
        end.

        if v_pwd_new2 = "" then do:
            message "不允许空密码" .
            next-prompt v_pwd_new2 with frame a .
            undo,retry .
        end.

        if v_pwd_new1 <> v_pwd_new2 then do:
            message "两次输入的新密码不一致,请重新输入".
            next-prompt v_pwd_old with frame a .
            undo,retry .
        end.

        if encode(v_pwd_new1) = xemp__chr01 then do:
            message "新旧密码不可一致,请重新输入".
            next-prompt v_pwd_new1 with frame a .
            undo,retry .
        end.
        
        find first xemp_mstr where xemp_addr = v_user no-error .
        if avail xemp_mstr then do:
            assign xemp__chr01 = encode(v_pwd_new1) .
        end.
        
        v_msgtxt = "" .
        message "密码修改成功." .

leave .
end. /*mainloop:*/

hide frame a no-pause .
