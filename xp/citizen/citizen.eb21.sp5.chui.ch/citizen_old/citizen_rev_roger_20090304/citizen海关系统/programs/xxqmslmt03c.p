
{mfdeclre.i }
{gplabel.i}

{xxqmslmt03.i }


    do transaction
        on error undo, 
        retry with frame h2:       

        find xxexp_mstr where recid(xxexp_mstr) = v_recid no-error .
        if not avail xxexp_mstr then leave .

            disp 
                xxexp_cu_nbr    
                xxexp_pre_nbr     
                xxexp_dept      
                xxexp_ship_via  
                xxexp_ship_tool 
                xxexp_bl_nbr    
                xxexp_trade_mtd 
                xxexp_tax_mtd   
                xxexp_tax_rate  
                xxexp_license   
                xxexp_appr_nbr  
                xxexp_contract  
                xxexp_container     
                xxexp_from     
                xxexp_to       
                xxexp_port     
                xxexp_fob      
                xxexp_box_num  
                xxexp_box_type 
                xxexp_net      
                xxexp_gross    
                xxexp_curr     
                xxexp_amt      
                xxexp_stat     
                xxexp_use      
                xxexp_rmks1     
                xxexp_rmks2 
            with frame h2 .

            update 
                xxexp_cu_nbr    
                xxexp_pre_nbr 
                xxexp_dept      
                xxexp_ship_via  
                xxexp_ship_tool 
                xxexp_bl_nbr    
                xxexp_trade_mtd 
                xxexp_tax_mtd   
                xxexp_box_type  
                xxexp_license   
                xxexp_appr_nbr  
                xxexp_contract  
                xxexp_container         
                xxexp_from     
                xxexp_to       
                xxexp_port     
                xxexp_fob      
                xxexp_box_num  
                xxexp_tax_rate 
                xxexp_net      
                xxexp_gross    
                xxexp_curr     
                xxexp_amt      
                xxexp_stat     
                xxexp_use      
                xxexp_rmks1     
                xxexp_rmks2 
            go-on("F5" "CTRL-D")
            with frame h2 .

            if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
            then do:
                if xxexp_stat <> "" then do:
                    message "错误:报关单已结,不允许删除" .
                    undo,retry.
                end.
                for each xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = xxexp_nbr :
                    if xxexpd_stat <> "" then do:
                        message "错误:已结项次,不允许删除" .
                        undo,retry.
                    end.
                    else do:
                        find first  xxcbkd_det 
                                where xxcbkd_domain = global_domain 
                                and xxcbkd_bk_type  = v_bk_type 
                                and xxcbkd_bk_nbr   = xxexp_bk_nbr
                                and xxcbkd_cu_ln    = xxexpd_cu_ln 
                        no-error .
                        if xxcbkd_stat <> "" then do:
                            message "错误:手册项次已结,不允许删除" .
                            undo,retry.
                        end.
                        else do:
                            /*nothing*/
                        end.
                    end.                        
                end. /*check*/                
            
                {mfmsg01.i 11 1 del-yn}

                if not del-yn then undo, retry.

                if del-yn then do:

                    for each xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = xxexp_nbr :
                                        find first abs_mstr 
                                            where abs_domain   = global_domain 
                                            and abs_par_id     = "S" + xxexpd_iss_nbr 
                                            and abs_type       = "S"
                                            and integer(abs_line) = xxexpd_iss_ln 
                                        no-error.
                                        if avail abs_mstr then assign abs__dec02 = abs__dec02 - xxexpd_iss_qty . 

                                        find first xxsld_det 
                                                where xxsld_domain = global_domain
                                                and xxsld_nbr = xxexp_sl_nbr 
                                                and xxsld_cu_ln = xxexpd_cu_ln
                                        no-error .
                                        if avail xxsld_det then assign xxsld_qty_used = xxsld_qty_used - xxexpd_cu_qty .

                                        find first xxcbk_mstr 
                                            where xxcbk_domain = global_domain 
                                            and xxcbk_bk_nbr = xxexp_bk_nbr 
                                        no-error .       
                                        if avail xxcbk_mstr and xxcbk_stat <> "" then assign  xxcbk_stat = ""  .

                                        find first xxcbkd_det 
                                            where xxcbkd_domain = global_domain 
                                            and xxcbkd_bk_type = v_bk_type
                                            and xxcbkd_bk_nbr = xxexp_bk_nbr 
                                            and xxcbkd_cu_ln  = xxexpd_cu_ln
                                        no-error . 
                                        if avail xxcbkd_det then 
                                            assign xxcbkd_stat = ""  
                                                   xxcbkd_qty_sl = xxcbkd_qty_sl - xxexpd_cu_qty  .
                                        
                                        delete xxexpd_det .                   
                    end. /*delete*/
                    delete xxexp_mstr.

                    clear frame h2 no-pause.
                    clear frame h1 no-pause.
                    next.
                end.
            end.

            if xxexp_stat <> "" and index("XC",xxexp_stat) = 0 then do:
                message "错误:状态仅限 未结(空),已结(C),取消(X)" .
                next-prompt xxexp_stat .
                undo,retry .
            end.            

            if xxexp_amt <= 0 then do:
                message "错误:无效金额,请重新输入" .
                next-prompt xxexp_amt .
                undo,retry .
            end.
    end. /*do  transaction */ 
