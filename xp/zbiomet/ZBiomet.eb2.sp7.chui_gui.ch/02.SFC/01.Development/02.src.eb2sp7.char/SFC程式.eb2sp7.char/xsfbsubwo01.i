/* xsfbsubwo01.i ��Э���������ͼ쵥��                                      */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/




form
    skip(1)
    "      ��Э����,�������ͼ쵥��." skip
    "      �ɹ�����:" v_sub_ponbr no-label  skip 
    "      �ͼ쵥��:" v_sub_nbr no-label 
    skip(1)
with frame sub 
title color normal ""
side-labels width 50 
row 8 centered overlay .   
        
        
if v_sub then do on error undo , retry :
    view frame sub .
    disp v_sub_ponbr with frame sub .
    update v_sub_nbr with frame sub .

    if not v_sub_nbr begins v_sub_ponbr then do:
        message "�ͼ쵥�Ÿ�ʽ����" .
        undo,retry.
    end.

    find first xpod_det where xpod_nbr = v_sub_ponbr and xpod_part = v_part and xpod_wo_lot = v_wolot and xpod_op = v_op no-lock no-error .
    if not avail xpod_det then do:
        message "�ɹ���(" v_sub_ponbr ")���Ҳ�������Э����." .
        undo,retry.
    end.




    /* ��Э�ͼ쵥������xsj_hist,����У��*
    *
    find first xsj_hist where xsj_nbr = v_sub_nbr and xsj_part = v_part no-lock no-error .
    if not avail xsj_hist then do:
        message "��Ч�ͼ쵥��,����������." .
        undo,retry .
    end. 
    else do:
        find first xpod_det where xpod_nbr = xsj_ponbr and xpod_part = v_part and xpod_wo_lot = v_wolot and xpod_op = v_op no-lock no-error .
        if not avail xpod_det then do:
            message "�ɹ���(" xsj_ponbr ")���Ҳ�������Э����." .
            undo,retry.
        end.
    end. 
    */

    hide frame sub no-pause.
end.
hide frame sub no-pause.