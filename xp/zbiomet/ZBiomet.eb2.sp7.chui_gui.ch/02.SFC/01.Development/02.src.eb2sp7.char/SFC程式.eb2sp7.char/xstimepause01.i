

/*所有工序的用户,暂停后都*/
find first xxpause_det 
    where xxpause_user = v_user 
no-lock no-error .
if avail xxpause_det then do:
    message "本用户已暂停所有作业,请先恢复生产"  view-as alert-box title ""  .
    undo,leave .
end.


if v_tail_wc = no then do:
    find first xxpause_det 
        where xxpause_wc = v_wc 
    no-lock no-error .
    if avail xxpause_det then do:
        message "此机器已被用户" xxpause_user "暂停,请先恢复生产"  view-as alert-box title ""  .
        undo,leave .
    end.

    find first xxpause_det 
        where xxpause_wolot = v_wolot
        and   xxpause_op    = v_op
    no-lock no-error .
    if avail xxpause_det then do:
        message "此工单条码已被用户" xxpause_user "/机器" xxpause_wc "暂停,请先恢复生产"  view-as alert-box title ""  .
        undo,leave .
    end.
end. /*if v_tail_wc = no*/

