/*xxicck341.p ��鱾�û��Ƿ���Ȩ�޴�ָ����λת�����                                                  */
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
        v_canrun = yes.  /*��λδά��,������*/
        leave.
    end.
    else do:
        if code_cmmt = "*" then do:
            v_canrun = yes.
            leave.
        end.
        
        /*��ֹA�û���,��B�û�����һ����,�û���ǰ��Ӷ���*/
        if index("," + code_cmmt + ",", "," + global_userid + ",") <> 0 then do:
            v_canrun = yes.
            leave.
        end.    
    end. /*avail*/

    leave .
end. /*mainloop*/