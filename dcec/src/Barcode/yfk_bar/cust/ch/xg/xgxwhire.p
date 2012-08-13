/*-------------------------------------------------------------
  File         xwxwhire.p
  Description  Restor the operation data from history
  Author       Yang Enping
  Created      2004-6-29
  History
  Modified by Tracy Zhang     2004-12-28 /*zx1228*/
  ------------------------------------------------------------*/

  {mfdtitle.i "AO"}

  def var lnr like xwo_lnr .
  def var rcvDt as date .
  def var rcvDt1 as date .
  
  form
     lnr label "信息点" colon 25
     rcvDt label "接收日期" colon 25
     rcvDt1 label "到" colon 40
     with frame a side-labels width 80 .

  def var confirm as logical .
  repeat:
     confirm = no .
     if rcvDt = low_date then rcvDt = ? .
     if rcvDt1 = hi_date then rcvDt1 = ? .
     update lnr rcvDt rcvDt1 with frame a .
     if rcvDt = ? then rcvDt = low_date .
     if rcvDt1 = ? then rcvDt1 = hi_date .

     message "确认从历史记录中恢复?" view-as alert-box question buttons yes-no update confirm .
     if not confirm then 
        next .
        
     for each xwoh_hist exclusive-lock where xwoh_lnr = lnr
        and xwoh_date >= rcvDt and xwoh_date <= rcvDt1:
        
        for each xwosdh_hist exclusive-lock where xwosdh_lnr = xwoh_lnr and 
           xwosdh_date = xwoh_date and xwosdh_fg_lot = xwoh_lot:
           create xwosd_det.
           assign xwosd_lnr          = xwosdh_lnr
                  xwosd_date         = xwosdh_date         
                  xwosd_fg_lot       = xwosdh_fg_lot       
                  xwosd_op           = xwosdh_op           
                  xwosd_part         = xwosdh_part         
                  xwosd_site         = xwosdh_site         
                  xwosd_loc          = xwosdh_loc          
                  xwosd_qty          = xwosdh_qty          
                  xwosd_bkflh        = xwosdh_bkflh        
                  xwosd_used         = xwosdh_used         
                  xwosd_use_dt       = xwosdh_use_dt       
                  xwosd_use_tm       = xwosdh_use_tm       
                  xwosd_kanban       = xwosdh_kanban       
                  xwosd_lot          = xwosdh_lot          
                  xwosd_qty_consumed = xwosdh_qty_consumed 
                  xwosd__chr01       = xwosdh__chr01       
                  xwosd__chr02       = xwosdh__chr02       
                  xwosd__dec01       = xwosdh__dec01       
                  xwosd__dec02       = xwosdh__dec02       
                  xwosd__log01       = xwosdh__log01       
                  xwosd__log02       = xwosdh__log02       
                  xwosd__dte01       = xwosdh__dte01       
                  xwosd__dte02       = xwosdh__dte02       
                  xwosd_pdnbr        = xwosdh_pdnbr .       
                  
           delete xwosdh_hist .

        end . /* for each xwosd_det*/
        
        create xwo_srt.
        assign xwo_lnr       = xwoh_lnr
               xwo_part      = xwoh_part    
               xwo_lot       = xwoh_lot     
               xwo_date      = xwoh_date    
               xwo_time      = xwoh_time    
               xwo_wrk_date  = xwoh_wrk_date
               xwo_due_date  = xwoh_due_date
               xwo_due_time  = xwoh_due_time
               xwo_site      = xwoh_site    
               xwo_loc_des   = xwoh_loc_des 
               xwo_blkflh    = xwoh_blkflh  
               xwo_wolot     = xwoh_wolot   
               xwo__chr01    = xwoh__chr01  
               xwo__chr02    = xwoh__chr02  
               xwo__dte01    = xwoh__dte01  
               xwo__log01    = xwoh__log01  
               xwo__dec01    = xwoh__dec01  
               xwo__dec02    = xwoh__dec02  
               xwo_qty_lot   = xwoh_qty_lot 
               xwo_serial    = xwoh_serial  
               xwo_loc_lnr   = xwoh_loc_lnr 
               xwo_cust      = xwoh_cust    
               xwo_wrk_time  = xwoh_wrk_time
               xwo_shift     = xwoh_shift   
               xwo_type      = xwoh_type    
               xwo_pt_desc   = xwoh_pt_desc 
               xwo_pdnbr     = xwoh_pdnbr  .
                                  
        delete xwoh_hist.
     end .
     message "恢复完成!" view-as alert-box information .
  end .
