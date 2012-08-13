/*-------------------------------------------------------------
  File         xgxwckbk.p
  Description  Move xwck_mstr data to xwckh_hist
  Author       hou
  Created      2006-2-24
  History

  ------------------------------------------------------------*/

  {mfdtitle.i "AO"}

  def var lnr like xwckh_lnr .
  def var rcvDt as date .
  def var rcvDt1 as date .
  
  form
     lnr label "生产线" colon 25
     rcvDt label "审核日期" colon 25
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

     message "确认存档?" view-as alert-box question buttons yes-no update confirm .
     if not confirm then 
        next .
     
     for each xwck_mstr exclusive-lock where xwck_lnr = lnr
        and xwck_date >= rcvDt and xwck_date <= rcvDt1
        and xwck_blkflh:
        
        create xwckh_hist.
        assign xwckh_lnr       = xwck_lnr      
               xwckh_part      = xwck_part     
               xwckh_lot       = xwck_lot      
               xwckh_date      = xwck_date     
               xwckh_time      = xwck_time     
               xwckh_qty_chk   = xwck_qty_chk  
               xwckh_stat      = xwck_stat     
               xwckh_type      = xwck_type     
               xwckh_blkflh    = xwck_blkflh   
               xwckh_prd_date  = xwck_prd_date 
               xwckh_prd_time  = xwck_prd_time 
               xwckh_pallet    = xwck_pallet   
               xwckh_shipper   = xwck_shipper  
               xwckh_cust      = xwck_cust     
               xwckh_loc_des   = xwck_loc_des  
               xwckh_tr        = xwck_tr       
               xwckh_wolot     = xwck_wolot    
               xwckh_shp_ret   = xwck_shp_ret  .

        delete xwck_mstr.
     end .
     message "存档完成!" view-as alert-box information .
  end .
