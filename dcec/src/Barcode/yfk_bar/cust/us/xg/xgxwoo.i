/* xgxwoo.i      建立点击历史主记录                */
/* create by hou    2006.03.21                     */

create xwoo_srt.
assign xwoo_lnr       = xwo_lnr       
       xwoo_part      = xwo_part      
       xwoo_lot       = string(YEAR(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)) + STRING(TIME)
       xwoo_date      = today      
       xwoo_time      = time      
       xwoo_wrk_date  = xwo_wrk_date  
       xwoo_due_date  = xwo_due_date  
       xwoo_due_time  = xwo_due_time  
       xwoo_site      = xwo_site      
       xwoo_loc_des   = xwo_loc_des   
       xwoo_blkflh    = xwo_blkflh    
       xwoo_wolot     = xwo_wolot     
       xwoo__chr01    = xwo__chr01    
       xwoo__chr02    = xwo__chr02    
       xwoo__dte01    = xwo__dte01    
       xwoo__log01    = xwo__log01    
       xwoo__dec01    = xwo__dec01    
       xwoo__dec02    = xwo__dec02    
       xwoo_qty_lot   = {2}   
       xwoo_serial    = xwo_serial    
       xwoo_loc_lnr   = xwo_loc_lnr   
       xwoo_cust      = xwo_cust      
       xwoo_wrk_time  = xwo_wrk_time  
       xwoo_shift     = xwo_shift     
       xwoo_type      = xwo_type      
       xwoo_pt_desc   = xwo_pt_desc   
       xwoo_pdnbr     = xwo_pdnbr     .
       
