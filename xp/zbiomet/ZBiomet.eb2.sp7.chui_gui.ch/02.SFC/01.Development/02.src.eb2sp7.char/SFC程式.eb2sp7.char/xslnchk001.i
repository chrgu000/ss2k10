/* xslnchk001.i 检查指令操作权限 */
/* REVISION: 1.0         Last Modified: 2008/11/29   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*
1.called by xsmf002.p
2.检查当前指令是否是否存在,
3.当前用户是否拥有操作权限
4.
*/    
    
    find first xcode_mstr where xcode_fldname = v_fldname and xcode_value = v_line no-lock no-error.
    if not avail xcode_mstr then do:
        message "无效指令,请重新输入" .
        undo,retry .
    end.
    if index(xcode_cmmt, "@") = 0 then do:
        message "指令设定有误,请重新设定" .
        undo,retry .            
    end.
    if entry(2,xcode_cmmt,"@") = "" then do:
        message "指令设定有误,请重新设定" .
        undo,retry .  
    end.
    if entry(2,xcode_cmmt,"@") <> "" and index(entry(2,xcode_cmmt,"@"),".p") <> 0 then do:
        if search(trim(entry(2,xcode_cmmt,"@"))) = ? then do:
            message "指令程式不存在,请通知IT部检查" .
            undo,retry .  
        end.
        /*文件读取和执行权限??*/
    end.
    disp v_line entry(1,xcode_cmmt,"@") @ xcode_cmmt with frame main2.


    execname = "" .
    run checksecurity (input trim(entry(2,xcode_cmmt,"@")) , input v_user , output execname ).
    if execname = ""  then do:
        message "无权限执行指令,请确认." .
        undo,retry .
    end.

    /*procedure checksecurity:  defined in xschks01.i */





