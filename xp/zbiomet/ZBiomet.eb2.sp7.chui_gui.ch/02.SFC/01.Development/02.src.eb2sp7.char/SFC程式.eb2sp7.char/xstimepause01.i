

/*���й�����û�,��ͣ��*/
find first xxpause_det 
    where xxpause_user = v_user 
no-lock no-error .
if avail xxpause_det then do:
    message "���û�����ͣ������ҵ,���Ȼָ�����"  view-as alert-box title ""  .
    undo,leave .
end.


if v_tail_wc = no then do:
    find first xxpause_det 
        where xxpause_wc = v_wc 
    no-lock no-error .
    if avail xxpause_det then do:
        message "�˻����ѱ��û�" xxpause_user "��ͣ,���Ȼָ�����"  view-as alert-box title ""  .
        undo,leave .
    end.

    find first xxpause_det 
        where xxpause_wolot = v_wolot
        and   xxpause_op    = v_op
    no-lock no-error .
    if avail xxpause_det then do:
        message "�˹��������ѱ��û�" xxpause_user "/����" xxpause_wc "��ͣ,���Ȼָ�����"  view-as alert-box title ""  .
        undo,leave .
    end.
end. /*if v_tail_wc = no*/

