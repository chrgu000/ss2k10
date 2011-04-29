/*xxpopc510.p ���ĳ�û�ID�Ƿ���Ȩ�޴�ӡ5.10�ļ۸�ͽ��                                              */
/* REVISION: 101020.1   Created On: 20101020   By: Softspeed Roger Xiao                               */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 101020.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}
{gplabel.i}
{pxmaint.i}

define  input parameter v_user   as char .
define output parameter v_canrun as logical .

define var v_fldname as char .
v_canrun  = no .
v_fldname = "PC-510".


mainloop:
repeat:

    /*�����˶���Ȩ��*/
    find first code_mstr 
        where code_domain   = global_domain 
        and   code_fldname  = v_fldname
        and   code_value    = "*"
    no-lock no-error.
    if avail code_mstr then do:
        v_canrun = yes.
        leave.
    end.

    /*ָ���û���Ȩ��*/
    find first code_mstr 
        where code_domain   = global_domain 
        and   code_fldname  = v_fldname
        and   code_value    = v_user
    no-lock no-error.
    if avail code_mstr then  do:
        v_canrun = yes.
        leave.
    end.

    leave .
end. /*mainloop*/