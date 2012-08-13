/*-------------------------------------------------------------
  File         xgxwckrs.p
  Description  Move the xwckh_hist data to xwck_mstr
  Author       hou
  Created      2006-2-24
  History

  ------------------------------------------------------------*/

  {mfdtitle.i "AO"}

  def var lnr like xwckh_lnr .
  def var rcvDt as date .
  def var rcvDt1 as date .
  
  form
     lnr label "信息点" colon 25
     rcvDt label "接收日期" colon 25
     rcvDt1 label "到" colon 40
     with frame a side-labels width 80.

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
     
     for each xwckh_hist exclusive-lock where xwckh_lnr = lnr
        and xwckh_date >= rcvDt and xwckh_date <= rcvDt1:
        
        create xwck_mstr.
        assign xwck_lnr       = xwckh_lnr      
               xwck_part      = xwckh_part     
               xwck_lot       = xwckh_lot      
               xwck_date      = xwckh_date     
               xwck_time      = xwckh_time     
               xwck_qty_chk   = xwckh_qty_chk  
               xwck_stat      = xwckh_stat     
               xwck_type      = xwckh_type     
               xwck_blkflh    = xwckh_blkflh   
               xwck_prd_date  = xwckh_prd_date 
               xwck_prd_time  = xwckh_prd_time 
               xwck_pallet    = xwckh_pallet   
               xwck_shipper   = xwckh_shipper  
               xwck_cust      = xwckh_cust     
               xwck_loc_des   = xwckh_loc_des  
               xwck_tr        = xwckh_tr       
               xwck_wolot     = xwckh_wolot    
               xwck_shp_ret   = xwckh_shp_ret  .

        delete xwckh_hist.
     end .
     message "恢复完成!" view-as alert-box information .
  end .
