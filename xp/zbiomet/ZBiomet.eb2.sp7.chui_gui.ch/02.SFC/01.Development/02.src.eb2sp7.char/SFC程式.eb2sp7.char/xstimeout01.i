


wtimeout = 99999. /*�Զ��˳��ķ�����*/


find first xcode_mstr 
    where xcode_fldname = v_fldname + "-timeout"
    and xcode_value = "sfc" 
no-lock no-error.   /*  timeout - all level */
wtimeout = if available(xcode_mstr) then  60 * decimal(xcode_cmmt) else wtimeout .



find first xcode_mstr 
    where xcode_fldname = v_fldname + "-timeout"
    and xcode_value = execname 
no-lock no-error.   /*  timeout - program level */
wtimeout = if available(xcode_mstr) then  60 * decimal(xcode_cmmt) else wtimeout .






/*
1.���ȼ�:����ʽ�� > "sfc"

2.���÷�ʽ: 
update xxxx with frame a editing:
    readkey .
    apply lastkey.
end.

�滻����Ϊ��������,�˳�����뿪ĳ��ʽ(loop��ѡ�����Ҫ):

update xxxx with frame a editing:
    {xstimeout02.i "leave your_main_loop" }
    {xstimeout02.i "quit"   }
    apply lastkey.
end.


*/