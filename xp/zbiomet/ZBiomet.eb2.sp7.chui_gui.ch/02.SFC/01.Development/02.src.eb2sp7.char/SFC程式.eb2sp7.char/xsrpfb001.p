/* xsrpfb001.p 反馈交易记录查询                                            */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */




define var v_fbnbr like xxfb_trnbr .



form
skip(1)                
v_fbnbr                         colon 12 label "交易号"
xxfb_type                       colon 12 label "交易类型"     
xxfb_type2                      no-label                  xxfb_nbr                        colon 50 label "单据号"       
xxfb_date                       colon 12 label "执行日期" xxfb_program                    colon 50 label "程式"    format "x(24)"          
xxfb_time                       colon 12 label "执行时间" xxfb_user                       colon 50 label "用户"       
xxfb_part                       colon 12 label "项目号"   xpt_desc1                        colon 50 label "品名"
xpt_um                           colon 12 label "单位"     xpt_desc2                        colon 50 label "规格"
skip(1)
xxfb_wonbr                      colon 12 label "工单号"    xxfb_wolot                      colon 50 label "工单标志"
xxfb_op                         colon 12 label "工序"      xxfb_wc                         colon 50 label "机器"
xxfb_date_start                 colon 12 label "开始日期"  xxfb_qty_fb                     colon 50 label "数量"    
xxfb_time_start                 colon 12 label "开始时间"  xxfb_wotype                     colon 50 label "工单类型"  
xxfb_date_end                   colon 12 label "结束日期"  xxfb_rsn_code                   colon 50 label "原因"    
xxfb_time_end                   colon 12 label "结束时间"  xxfb_rmks                       colon 50 label "备注"    
xxfb_update                     colon 12 label "已更新" 


with frame a 
title color normal "交易记录查询"
side-labels width 80 .   


hide all no-pause .
view frame a .

find last xxfb_hist no-lock no-error .
v_fbnbr = if avail xxfb_hist then xxfb_trnbr else 0.

mainloop:
repeat :

    update v_fbnbr with frame a editing:
        {xstimeout02.i " quit "    } 
        {xsmfnp11.i xxfb_hist xxfb_trnbr xxfb_trnbr "input v_fbnbr" }
        IF recno <> ?  THEN DO:
            DISP 
                xxfb_trnbr @ v_fbnbr   
                xxfb_type       
                xxfb_type2      
                xxfb_nbr        
                xxfb_user       
                xxfb_date       
                xxfb_program    
                xxfb_part            
                xxfb_wonbr      
                xxfb_wolot      
                xxfb_op         
                xxfb_wc         
                xxfb_date_start 
                xxfb_date_end   
                string(xxfb_time,"hh:mm")       @ xxfb_time       
                string(xxfb_time_start,"hh:mm") @ xxfb_time_start 
                string(xxfb_time_end,"hh:mm")   @ xxfb_time_end  
                xxfb_qty_fb     
                xxfb_rsn_code   
                xxfb_rmks       
                xxfb_update     
                xxfb_wotype     

            with frame a.

            find first xpt_mstr where xpt_part = xxfb_part no-lock no-error.
            if avail xpt_mstr then disp xpt_desc1 xpt_desc2 xpt_um with frame a  .
        END.  /*if recno<> ?*/
    end.
    assign v_fbnbr .

    {xserr001.i "v_fbnbr" } /*检查数量栏位是否输入了问号*/

    find first xxfb_hist 
        use-index xxfb_trnbr 
        where xxfb_trnbr = v_fbnbr 
    no-lock no-error .
    if not avail xxfb_hist then do:
        message "无效交易号,请重新输入" .
        undo,retry .
    end.
    else do: /*avail*/
            DISP 
                xxfb_trnbr @ v_fbnbr   
                xxfb_type       
                xxfb_type2      
                xxfb_nbr        
                xxfb_user       
                xxfb_date       
                xxfb_program    
                xxfb_part            
                xxfb_wonbr      
                xxfb_wolot      
                xxfb_op         
                xxfb_wc         
                xxfb_date_start 
                xxfb_date_end   
                string(xxfb_time,"hh:mm")       @ xxfb_time       
                string(xxfb_time_start,"hh:mm") @ xxfb_time_start 
                string(xxfb_time_end,"hh:mm")   @ xxfb_time_end  
                xxfb_qty_fb     
                xxfb_rsn_code   
                xxfb_rmks       
                xxfb_update     
                xxfb_wotype     

            with frame a.

            find first xpt_mstr where xpt_part = xxfb_part no-lock no-error.
            if avail xpt_mstr then disp xpt_desc1 xpt_desc2 xpt_um with frame a  .

    end. /*avail*/



end. /*mainloop*/
hide frame a no-pause .