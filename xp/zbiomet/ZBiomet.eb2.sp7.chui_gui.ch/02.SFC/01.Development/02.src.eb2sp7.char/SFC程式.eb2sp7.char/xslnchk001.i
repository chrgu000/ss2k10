/* xslnchk001.i ���ָ�����Ȩ�� */
/* REVISION: 1.0         Last Modified: 2008/11/29   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*
1.called by xsmf002.p
2.��鵱ǰָ���Ƿ��Ƿ����,
3.��ǰ�û��Ƿ�ӵ�в���Ȩ��
4.
*/    
    
    find first xcode_mstr where xcode_fldname = v_fldname and xcode_value = v_line no-lock no-error.
    if not avail xcode_mstr then do:
        message "��Чָ��,����������" .
        undo,retry .
    end.
    if index(xcode_cmmt, "@") = 0 then do:
        message "ָ���趨����,�������趨" .
        undo,retry .            
    end.
    if entry(2,xcode_cmmt,"@") = "" then do:
        message "ָ���趨����,�������趨" .
        undo,retry .  
    end.
    if entry(2,xcode_cmmt,"@") <> "" and index(entry(2,xcode_cmmt,"@"),".p") <> 0 then do:
        if search(trim(entry(2,xcode_cmmt,"@"))) = ? then do:
            message "ָ���ʽ������,��֪ͨIT�����" .
            undo,retry .  
        end.
        /*�ļ���ȡ��ִ��Ȩ��??*/
    end.
    disp v_line entry(1,xcode_cmmt,"@") @ xcode_cmmt with frame main2.


    execname = "" .
    run checksecurity (input trim(entry(2,xcode_cmmt,"@")) , input v_user , output execname ).
    if execname = ""  then do:
        message "��Ȩ��ִ��ָ��,��ȷ��." .
        undo,retry .
    end.

    /*procedure checksecurity:  defined in xschks01.i */





