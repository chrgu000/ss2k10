/* xgxwosdo.i    建立点击历史明细记录                */
/* create by hou    2006.03.21                       */

create xwosdo_det.
assign xwosdo_lnr           = xwosd_lnr           
       xwosdo_date          = today          
       xwosdo_fg_lot        = xwosd_fg_lot        
       xwosdo_op            = xwosd_op            
       xwosdo_part          = xwosd_part          
       xwosdo_site          = xwosd_site          
       xwosdo_loc           = xwosd_loc           
       xwosdo_qty           = {1}           
       xwosdo_bkflh         = xwosd_bkflh         
       xwosdo_used          = xwosd_used          
       xwosdo_use_dt        = today        
       xwosdo_use_tm        = time        
       xwosdo_kanban        = xwosd_kanban        
       xwosdo_lot           = xwosd_lot           
       xwosdo_qty_consumed  = xwosd_qty_consumed  
       xwosdo__chr01        = xwosd__chr01        
       xwosdo__chr02        = xwosd__chr02        
       xwosdo__dec01        = xwosd__dec01        
       xwosdo__dec02        = xwosd__dec02        
       xwosdo__log01        = xwosd__log01        
       xwosdo__log02        = xwosd__log02        
       xwosdo__dte01        = xwosd__dte01        
       xwosdo__dte02        = xwosd__dte02        
       xwosdo_pdnbr         = xwosd_pdnbr      .
   