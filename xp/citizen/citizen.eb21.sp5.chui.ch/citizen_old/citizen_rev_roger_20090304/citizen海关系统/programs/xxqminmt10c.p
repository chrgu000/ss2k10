
{mfdeclre.i }
{gplabel.i}

{xxqminmt10.i }
loopmstr :
do on error undo, retry :
do  transaction 
    on error undo, 
    retry with frame h2:

    find xxipr_mstr where recid(xxipr_mstr) = v_recid no-error .
    if not avail xxipr_mstr then leave .

    disp xxipr_box_num xxipr_gross xxipr_amt  xxipr_curr xxipr_dept xxipr_loc xxipr_car 
        xxipr_driver xxipr_ship_nbr xxipr_license xxipr_stat xxipr_rmks1 with frame h2.
    
    
    update
        xxipr_dept       
        xxipr_loc    
        xxipr_car     
        xxipr_driver   
        xxipr_ship_nbr  
        xxipr_license   
        xxipr_box_num 
        xxipr_gross 
        xxipr_amt 
        xxipr_stat      
        xxipr_rmks1  
        go-on ("F5" "CTRL-D") 
     with frame h2 editing :
                    readkey .
                    if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                        if xxipr_stat <> "" then do:
                            message "错误:非未结状态,不允许删除" . 
                            undo,retry .
                        end.
                        else do:
                            find first xxiprd_det 
                                    where xxiprd_domain = global_domain 
                                    and xxiprd_nbr = v_nbr 
                                    and (xxiprd_stat <> "" or xxiprd_used > 0)
                            no-lock no-error.
                            if avail xxiprd_det then do :
                                message "错误:明细非未结状态或已开始库存转移,不允许删除" . 
                                undo,retry .
                            end.
                            else do:
                                del-yn = yes.
                                {mfmsg01.i 11 1 del-yn}
                                if del-yn then do :
                                    for each xxiprd_det where xxiprd_domain = global_domain and xxiprd_nbr = xxipr_nbr :
                                        find first prh_hist 
                                            where prh_domain = global_domain 
                                            and prh_receiver = xxiprd_rct_nbr 
                                            and prh_line = xxiprd_rct_ln 
                                        no-error.
                                        if avail prh_hist then assign prh__dec01 = prh__dec01 - xxiprd_rct_qty . 

                                        find first xxcbk_mstr 
                                            where xxcbk_domain = global_domain 
                                            and xxcbk_bk_nbr = xxipr_bk_nbr 
                                        no-error .       
                                        if avail xxcbk_mstr and xxcbk_stat <> "" then assign  xxcbk_stat = ""  .

                                        find first xxcbkd_det 
                                            where xxcbkd_domain = global_domain 
                                            and xxcbkd_bk_type = v_bk_type
                                            and xxcbkd_bk_nbr = xxipr_bk_nbr 
                                            and xxcbkd_cu_ln  = xxiprd_cu_ln
                                        no-error . 
                                        if avail xxcbkd_det then 
                                            assign xxcbkd_stat = ""  
                                                   xxcbkd_qty_io = xxcbkd_qty_io - xxiprd_cu_qty  .

                                        delete xxiprd_Det.
                                    end.
                                    delete xxipr_mstr .
                                    clear frame h2 no-pause.
                                    clear frame h1 no-pause.
                                    leave  loopmstr.
                                end.
                            end.
                        end.
                    end. /*   "F5" "CTRL-D" */
                    else apply lastkey .
     end.



    if xxipr_box_num <= 0 then do:
        message "错误:重量不可为零" .
        next-prompt xxipr_box_num .
        undo,retry .
    end.
    
    if xxipr_gross <= 0 then do:
        message "错误:重量不可为零" .
        next-prompt xxipr_gross .
        undo,retry .
    end.
    if xxipr_amt <= 0 then do:
        message "错误:总金额不可为零" .
        next-prompt xxipr_amt .
        undo,retry .
    end.

    if xxipr_stat <> "" and index("XC",xxipr_stat) = 0 then do:
        message "错误:状态仅限 未结(空),已结(C),取消(X)" .
        next-prompt xxipr_stat .
        undo,retry .
    end.

end. /*do  transaction*/  
end.