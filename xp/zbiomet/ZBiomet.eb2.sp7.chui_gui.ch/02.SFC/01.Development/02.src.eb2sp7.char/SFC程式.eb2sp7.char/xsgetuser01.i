/* xsgetuser01.i ��¼�û����ʹ�õĻ����͹���                              */
/* REVISION: 1.0         Last Modified: 2008/12/12   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*************
1.called by xsmf002.p and xschgmachine.p and xsquit.p
2.��¼���û�����ˢ���Ļ���������,��Ϊ�´ε�½ʱ��Ĭ��ֵ
3.
************/ 
do :
    find first xusrw_wkfl 
        where xusrw_key1 = v_fldname 
        and   xusrw_key2 = v_user
    no-lock no-error .
    if not avail xusrw_wkfl then do:
        create  xusrw_wkfl .
        assign  xusrw_key1 = v_fldname
                xusrw_key2 = v_user   .

        release xusrw_wkfl .
    end.

    find first xusrw_wkfl 
        where xusrw_key1 = v_fldname 
        and   xusrw_key2 = v_user
    no-error .
    if avail xusrw_wkfl then 
    assign xusrw_key3 = v_wc 
           xusrw_key4 = v_sn1 
           .
    release xusrw_wkfl .
end.
