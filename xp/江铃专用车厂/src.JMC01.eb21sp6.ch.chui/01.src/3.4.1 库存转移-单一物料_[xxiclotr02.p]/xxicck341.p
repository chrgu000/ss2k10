/*xxicck341.p 检查本用户是否有权限从指定库位转出库存                                                  */
/* REVISION: 101022.1   Created On: 20101022   By: Softspeed Roger Xiao                               */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 101022.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}
{gplabel.i}
{pxmaint.i}

define  input parameter v_loc    as char .
define output parameter v_canrun as logical .

define var v_fldname as char .
v_canrun  = no .
v_fldname = "ISS-341".


mainloop:
repeat:

   
    find first code_mstr 
        where code_domain   = global_domain 
        and   code_fldname  = v_fldname
        and   code_value    = v_loc
    no-lock no-error.
    if not avail code_mstr then do:
        v_canrun = yes.  /*库位未维护,则不受限*/
        leave.
    end.
    else do:
        if code_cmmt = "*" then do:
            v_canrun = yes.
            leave.
        end.
        
        /*防止A用户名,是B用户名的一部分,用户名前后加逗号*/
        if index("," + code_cmmt + ",", "," + global_userid + ",") <> 0 then do:
            v_canrun = yes.
            leave.
        end.    
    end. /*avail*/

    leave .
end. /*mainloop*/