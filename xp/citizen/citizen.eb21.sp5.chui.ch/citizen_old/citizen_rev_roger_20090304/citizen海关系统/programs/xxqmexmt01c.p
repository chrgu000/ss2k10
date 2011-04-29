
{mfdeclre.i }
{gplabel.i}

{xxqmexmt01.i }
loopmstr:
do on error undo, retry :

do  transaction 
    on error undo, 
    retry with frame h2:

    find xxepr_mstr where recid(xxepr_mstr) = v_recid no-error .
    if not avail xxepr_mstr then leave .

    disp xxepr_box_num xxepr_gross xxepr_amt  xxepr_curr xxepr_dept xxepr_loc xxepr_car 
        xxepr_driver xxepr_ship_nbr xxepr_license xxepr_stat xxepr_rmks1 with frame h2.
    
    
    update
        xxepr_dept       
        xxepr_loc    
        xxepr_car     
        xxepr_driver   
        xxepr_ship_nbr  
        xxepr_license   
        xxepr_box_num 
        xxepr_gross 
        xxepr_amt 
        xxepr_stat      
        xxepr_rmks1  
     go-on ("F5" "CTRL-D") 
     with frame h2 editing :
     
                    readkey .
                    if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                        if xxepr_stat <> "" then do:
                            message "错误:非未结状态,不允许删除" . 
                            undo,retry .
                        end.
                        else do:
                            find first xxeprd_det 
                                    where xxeprd_domain = global_domain 
                                    and xxeprd_nbr = v_nbr 
                                    and (xxeprd_stat <> "" or xxeprd_used > 0)
                            no-lock no-error.
                            if avail xxeprd_det then do :
                                message "错误:明细非未结状态或已开始库存转移,不允许删除" . 
                                undo,retry .
                            end.
                            else do:
                                del-yn = yes.
                                {mfmsg01.i 11 1 del-yn}
                                if del-yn then do :
                                    for each xxeprd_det where xxeprd_domain = global_domain and xxeprd_nbr = xxepr_nbr :
                                        find first abs_mstr 
                                            where abs_domain   = global_domain 
                                            and abs_par_id     = "S" + xxeprd_iss_nbr 
                                            and abs_type       = "S"
                                            and integer(abs_line) = xxeprd_iss_ln 
                                        no-error.
                                        if avail abs_mstr then assign abs__dec02 = abs__dec02 - xxeprd_iss_qty . 

                                        find first xxcbk_mstr 
                                            where xxcbk_domain = global_domain 
                                            and xxcbk_bk_nbr = xxepr_bk_nbr 
                                        no-error .       
                                        if avail xxcbk_mstr and xxcbk_stat <> "" then assign  xxcbk_stat = ""  .

                                        find first xxcbkd_det 
                                            where xxcbkd_domain = global_domain 
                                            and xxcbkd_bk_type = v_bk_type
                                            and xxcbkd_bk_nbr = xxepr_bk_nbr 
                                            and xxcbkd_cu_ln  = xxeprd_cu_ln
                                        no-error . 
                                        if avail xxcbkd_det then 
                                            assign xxcbkd_stat = ""  
                                                   xxcbkd_qty_io = xxcbkd_qty_io - xxeprd_cu_qty  .

                                        delete xxeprd_Det.
                                    end.
                                    delete xxepr_mstr .
                                    
                                    clear frame h2 no-pause.
                                    clear frame h1 no-pause.
                                    leave loopmstr .
                                end.
                            end.
                        end.
                    end. /*   "F5" "CTRL-D" */
                    else apply lastkey .
    end.


    if xxepr_box_num <= 0 then do:
        message "错误:重量不可为零" .
        next-prompt xxepr_box_num .
        undo,retry .
    end.
    
    if xxepr_gross <= 0 then do:
        message "错误:重量不可为零" .
        next-prompt xxepr_gross .
        undo,retry .
    end.
    if xxepr_amt <= 0 then do:
        message "错误:总金额不可为零" .
        next-prompt xxepr_amt .
        undo,retry .
    end.

    if xxepr_stat <> "" and index("XC",xxepr_stat) = 0 then do:
        message "错误:状态仅限 未结(空),已结(C),取消(X)" .
        next-prompt xxepr_stat .
        undo,retry .
    end.

end. /*do  transaction*/  
end. 