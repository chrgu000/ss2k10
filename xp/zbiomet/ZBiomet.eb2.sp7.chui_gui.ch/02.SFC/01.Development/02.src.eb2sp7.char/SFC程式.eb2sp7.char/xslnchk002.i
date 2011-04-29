/* xslnchk002.i ����ָ���߼���� */
/* REVISION: 1.0         Last Modified: 2008/11/29   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*
1.called by xsmf002.p �� xsdowntime.p
2.��鵱ǰָ���Ƿ�Ӧ�ñ�ִ��(ǰ��ָ���ν�)
3.ָ���ж��߼�����
*/    

/*
ָ���ж��߼�����:
1.���û��ͻ�������ǰһ�ʽ���
2.
*/



if  (
    v_line = v_line_prev[1]  /*׼��ʱ��*/  
or  v_line = v_line_prev[2]  /*����ʱ��*/  
or  v_line = v_line_prev[3]  /*�ϸ���*/  
or  v_line = v_line_prev[4]  /*���Ϸ���*/  
or  v_line = v_line_prev[5]  /*��������*/  
or  v_line = v_line_prev[18] /*ͣ��ʱ��*/  
or  v_line = v_line_prev[19] /*����ά��*/  
or  v_line = v_line_prev[20] /*����ʱ��*/  
or  v_line = v_line_prev[21] /*�Է�ʱ��*/  
or  v_line = v_line_prev[23] /*����ͣ��*/  
or  v_line = v_line_prev[24] /*����ͣ��*/  
    ) 
then do:
    /*ͬһʱ��,һ����������(wo+op)ֻ�ܱ�һ̨��������,(�ɶ���)
    if v_wolot <> "" then do:
        find first xxfb_hist  
                where xxfb_wolot  = v_wolot 
                and xxfb_op       = v_op
                and xxfb_date_end = ? 
                and xxfb_wc       <> v_wc 
        no-lock no-error.
        if avail xxfb_hist then do:
            message "�˹����������ڱ�(�û�" xxfb_user "/���� " xxfb_wc ")ʹ��" .
            undo,retry .
        end.
    end.*/

    if v_tail_wc = no then do:
        /*ͬһʱ��,һ̨����ֻ�ܱ�һ����ʹ��*/
        find first xxfb_hist  
                where xxfb_wc = v_wc and xxfb_date_end = ? 
                and xxfb_user <> v_user
        no-lock no-error.
        if avail xxfb_hist then do:
            message "�������ڱ�(�û�" xxfb_user ")ʹ��" .
            undo,retry .
        end.


        /*ͬһʱ��,һ����������(wo+op)ֻ�ܱ�(һ����+һ̨����)����*/
        if v_wolot <> "" then do:
            find first xxfb_hist  
                    where xxfb_wolot = v_wolot 
                    and xxfb_op      = v_op
                    and xxfb_date_end = ? 
                    and (xxfb_user <> v_user or xxfb_wc <> v_wc )
            no-lock no-error.
            if avail xxfb_hist then do:
                message "�˹����������ڱ�(�û�" xxfb_user "/���� " xxfb_wc ")ʹ��" .
                undo,retry .
            end.
        end.    
    end. /*�Ǻ�����Ļ���*/



end. /*if v_line <> v_line_prev[13]*/



/*�����һ��δ��xxfb_hist*/
v_recno = ? .
for each xxfb_hist  
        use-index xxfb_userwc 
        where xxfb_user = v_user and xxfb_wc = v_wc 
        and xxfb_date_end = ? 
        and ((xxfb_wolot = v_wolot and xxfb_op = v_op) 
            or xxfb_wolot = "" )
        no-lock 
        break by xxfb_user by xxfb_wc by xxfb_trnbr :

        if last(xxfb_user) then v_recno = recid(xxfb_hist) .
end.

find xxfb_hist where recid(xxfb_hist) = v_recno  no-lock no-error .
if avail xxfb_hist and xxfb_date_end = ? then do: /*֮ǰ��ָ��,����δ��ָ��,��ִ�б��γ�ʽ */

    if (v_line = v_line_prev[1] and xxfb_wolot = v_wolot and xxfb_op = v_op ) or 
       (v_line = v_line_prev[2] and xxfb_wolot = v_wolot and xxfb_op = v_op ) or
       v_line = v_line_prev[19] or
       v_line = v_line_prev[20] or
       v_line = v_line_prev[21] or
       v_line = v_line_prev[23] or
       v_line = v_line_prev[24]
    then do:
        if xxfb_type = v_line then do:
            message "ָ������ִ��,�����ظ�ˢ��." .
            undo,retry .
        end.
    end. /*if v_line = v_line_prev[1]*/

end.  /*if avail xxfb_hist*/



/* ָ��,ѭ����ϵ�ж�: */


/*�ϸ���,���Ϸ���,�������� : ����Э������,��֮ǰ������׼��������ʱ��*/
if v_line = v_line_prev[3] 
or v_line = v_line_prev[4] 
or v_line = v_line_prev[5]  
then do:
    find first xxwrd_det 
        where xxwrd_wolot = v_wolot 
        and xxwrd_op = v_op 
        and (xxwrd_status = "" or xxwrd_status  = "N" )
        and xxwrd_close = no 
    no-lock no-error .
    if avail xxwrd_det then do:
        find first xpod_det
            use-index xpod_part
            where xpod_part = xxwrd_part 
            and xpod_wo_lot = xxwrd_wolot
            and xpod_op     = xxwrd_op
        no-lock no-error .
        if not avail xpod_det then do:
            find first xxfb_hist use-index xxfb_wolot 
                where xxfb_wolot = v_wolot 
                and   xxfb_op    = v_op 
                and  (xxfb_type  = v_line_prev[2]   /*����ʱ��*/
                    or xxfb_type = v_line_prev[1]   /*׼��ʱ��*/)
            no-lock no-error .
            if not avail xxfb_hist then do:
                message "ָ���޷�ִ��:����Э��������,����δ׼��������" .
                undo,retry .
            end. /*if avail xxfb_hist*/
        end.
    end.

end. /*if v_line = v_line_prev[3]*/

