
{mfdeclre.i }
{gplabel.i}

{xxqmslmt02.i }

    do transaction
        on error undo, 
        retry with frame h2:       

        find xximp_mstr where recid(xximp_mstr) = v_recid no-error .
        if not avail xximp_mstr then leave .

            disp 
                xximp_cu_nbr    
                xximp_pre_nbr     
                xximp_dept      
                xximp_ship_via  
                xximp_ship_tool 
                xximp_bl_nbr    
                xximp_trade_mtd 
                xximp_tax_mtd   
                xximp_tax_rate  
                xximp_license   
                xximp_appr_nbr  
                xximp_contract  
                xximp_container     
                xximp_from     
                xximp_to       
                xximp_port     
                xximp_fob      
                xximp_box_num  
                xximp_box_type 
                xximp_net      
                xximp_gross    
                xximp_curr     
                xximp_amt      
                xximp_stat     
                xximp_use      
                xximp_rmks1     
                xximp_rmks2 
            with frame h2 .

            update 
                xximp_cu_nbr    
                xximp_pre_nbr 
                xximp_dept      
                xximp_ship_via  
                xximp_ship_tool 
                xximp_bl_nbr    
                xximp_trade_mtd 
                xximp_tax_mtd   
                xximp_box_type  
                xximp_license   
                xximp_appr_nbr  
                xximp_contract  
                xximp_container         
                xximp_from     
                xximp_to       
                xximp_port     
                xximp_fob      
                xximp_box_num  
                xximp_tax_rate 
                xximp_net      
                xximp_gross    
                xximp_curr     
                xximp_amt      
                xximp_stat     
                xximp_use      
                xximp_rmks1     
                xximp_rmks2 
            go-on("F5" "CTRL-D")
            with frame h2 .

            if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
            then do:
                if xximp_stat <> "" then do:
                    message "错误:报关单已结,不允许删除" .
                    undo,retry.
                end.
                for each xximpd_det where xximpd_domain = global_domain and xximpd_nbr = xximp_nbr :
                    if xximpd_stat <> "" then do:
                        message "错误:已结项次,不允许删除" .
                        undo,retry.
                    end.
                    else do:
                        find first  xxcbkd_det 
                                where xxcbkd_domain = global_domain 
                                and xxcbkd_bk_type  = v_bk_type 
                                and xxcbkd_bk_nbr   = xximp_bk_nbr
                                and xxcbkd_cu_ln    = xximpd_cu_ln 
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

                    for each xximpd_det where xximpd_domain = global_domain and xximpd_nbr = xximp_nbr :
                            find first prh_hist 
                                where prh_domain = global_domain 
                                and prh_receiver = xximpd_rct_nbr 
                                and prh_line = xximpd_rct_ln 
                            no-error.
                            if avail prh_hist then assign prh__dec01 = prh__dec01 - xximpd_rct_qty . 

                            find first xxsld_det 
                                    where xxsld_domain = global_domain
                                    and xxsld_nbr = xximp_sl_nbr 
                                    and xxsld_cu_ln = xximpd_cu_ln
                            no-error .
                            if avail xxsld_det then assign xxsld_qty_used = xxsld_qty_used - xximpd_cu_qty .

                            find first xxcbkd_det 
                                    where xxcbkd_domain = global_domain 
                                    and xxcbkd_bk_type  = v_bk_type 
                                    and xxcbkd_bk_nbr   = xximp_bk_nbr
                                    and xxcbkd_cu_ln    = xximpd_cu_ln 
                            no-error .
                            if avail xxcbkd_det then 
                                assign xxcbkd_stat = "" 
                                    xxcbkd_qty_sl = xxcbkd_qty_sl - xximpd_cu_qty .

                            find first xxcbk_mstr 
                                    where xxcbk_domain = global_domain 
                                    and xxcbk_bk_nbr = xximp_bk_nbr 
                                no-error .       
                                if avail xxcbk_mstr and xxcbk_stat <> "" then assign  xxcbk_stat = ""  .

                            delete xximpd_det .                     
                    end. /*delete*/
                    delete xximp_mstr.

                    clear frame h2 no-pause.
                    clear frame h1 no-pause.
                    next.
                end.
            end.

            if xximp_stat <> "" and index("XC",xximp_stat) = 0 then do:
                message "错误:状态仅限 未结(空),已结(C),取消(X)" .
                next-prompt xximp_stat .
                undo,retry .
            end.            

            if xximp_amt <= 0 then do:
                message "错误:无效金额,请重新输入" .
                next-prompt xximp_amt .
                undo,retry .
            end.
    end. /*do  transaction */ 
