


wtimeout = 99999. /*自动退出的分钟数*/


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
1.优先级:各程式名 > "sfc"

2.调用方式: 
update xxxx with frame a editing:
    readkey .
    apply lastkey.
end.

替换上文为下面内容,退出或仅离开某程式(loop的选择很重要):

update xxxx with frame a editing:
    {xstimeout02.i "leave your_main_loop" }
    {xstimeout02.i "quit"   }
    apply lastkey.
end.


*/