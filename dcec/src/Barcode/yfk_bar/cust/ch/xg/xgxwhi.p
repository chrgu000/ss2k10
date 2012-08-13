/*-------------------------------------------------------------
  File         xgxwhi.p
  Description  Move the operation data to history
  Author       hou
  Created      2006-2-24
  History
  
  Modify by xwh on 2006-04-10 
  description: add part and lot condition  
  ------------------------------------------------------------*/

  {mfdtitle.i "AO"}

  def var lnr like xwo_lnr .
  def var lnr1 like xwo_lnr .
  def var rcvDt as date .
  def var rcvDt1 as date .
  DEF VAR part LIKE pt_part.
  DEF VAR part1 LIKE pt_part.
  DEF VAR lot LIKE xwo_lot.
  DEF VAR lot1 LIKE xwo_lot.
  def var v_err as logical.

  
  define buffer bfxwo for xwo_srt.
  
  form
     lnr label "生产线" colon 15
     lnr1 label "到" colon 49
     rcvDt label "接收日期" colon 15
     rcvDt1 label "到" colon 49
     part LABEL "零件号" COLON 15
     part1 LABEL "到" COLON 49
     lot LABEL "批号" COLON 15
     lot1 LABEL "到" COLON 49
     with frame a side-labels width 80.

  def var confirm as logical .
  repeat:
     confirm = no .
     if rcvDt = low_date then rcvDt = ? .
     if rcvDt1 = hi_date then rcvDt1 = ? .
     IF lnr1 = hi_char THEN lnr1 = "".
     IF part1 = hi_char THEN part1 = "".
     IF lot1 = hi_char  THEN lot1 = "".
     update lnr lnr1 rcvDt rcvDt1 part part1 lot lot1 with frame a .
     if rcvDt = ? then rcvDt = low_date .
     if rcvDt1 = ? then rcvDt1 = hi_date .
     IF lnr1 = "" THEN lnr1 = hi_char.
     IF part1 = "" THEN part1 = hi_char.
     IF lot1 = ""  THEN lot1 = hi_char.

     bcdparm = "".

    {mfquoter.i lnr    }
    {mfquoter.i lnr1   }    
    {mfquoter.i part    }
    {mfquoter.i part1   }
    {mfquoter.i rcvDt   }
    {mfquoter.i rcvDt1   }
    {mfquoter.i lot     }
    {mfquoter.i lot1   }
    {mfquoter.i lnr   }


     message "确认存档?" view-as alert-box question buttons yes-no update confirm .
     if not confirm then 
        next .
     
     for each xwo_srt NO-LOCK where xwo_lnr >= lnr AND xwo_lnr <= lnr1
        and xwo_date >= rcvDt and xwo_date <= rcvDt1
        AND xwo_part >= part AND xwo_part <= part1
        AND xwo_lot >= lot AND xwo_lot <= lot1
        AND xwo_wolot <> ''
        break by xwo_lot on error undo, next:
        
        if first-of(xwo_lot) then do on error undo, leave:
           v_err = no.
           for each xwosd_det exclusive-lock where xwosd_lnr = xwo_lnr and 
              xwosd_date = xwo_date and xwosd_fg_lot = xwo_lot:
              if xwosd_qty <> xwosd_qty_consumed then do:
                 v_err = yes.
                 leave.
              end.
              
              create xwosdh_hist.
              assign xwosdh_lnr          = xwosd_lnr
                     xwosdh_date         = xwosd_date         
                     xwosdh_fg_lot       = xwosd_fg_lot       
                     xwosdh_op           = xwosd_op           
                     xwosdh_part         = xwosd_part         
                     xwosdh_site         = xwosd_site         
                     xwosdh_loc          = xwosd_loc          
                     xwosdh_qty          = xwosd_qty          
                     xwosdh_bkflh        = xwosd_bkflh        
                     xwosdh_used         = xwosd_used         
                     xwosdh_use_dt       = xwosd_use_dt       
                     xwosdh_use_tm       = xwosd_use_tm       
                     xwosdh_kanban       = xwosd_kanban       
                     xwosdh_lot          = xwosd_lot          
                     xwosdh_qty_consumed = xwosd_qty_consumed 
                     xwosdh__chr01       = xwosd__chr01       
                     xwosdh__chr02       = xwosd__chr02       
                     xwosdh__dec01       = xwosd__dec01       
                     xwosdh__dec02       = xwosd__dec02       
                     xwosdh__log01       = xwosd__log01       
                     xwosdh__log02       = xwosd__log02       
                     xwosdh__dte01       = xwosd__dte01       
                     xwosdh__dte02       = xwosd__dte02       
                     xwosdh_pdnbr        = xwosd_pdnbr .       
                     
              delete xwosd_det .
   
           end . /* for each xwosd_det*/
           if v_err then undo, LEAVE.
           
           for each bfxwo EXCLUSIVE-LOCK where bfxwo.xwo_lot = xwo_srt.xwo_lot /*and 
              bfxwo.xwo_date >= rcvDt and bfxwo.xwo_date <= rcvDt1*/ :
              create xwoh_hist.
              assign xwoh_lnr       = bfxwo.xwo_lnr
                     xwoh_part      = bfxwo.xwo_part    
                     xwoh_lot       = bfxwo.xwo_lot     
                     xwoh_date      = bfxwo.xwo_date    
                     xwoh_time      = bfxwo.xwo_time    
                     xwoh_wrk_date  = bfxwo.xwo_wrk_date
                     xwoh_due_date  = bfxwo.xwo_due_date
                     xwoh_due_time  = bfxwo.xwo_due_time
                     xwoh_site      = bfxwo.xwo_site    
                     xwoh_loc_des   = bfxwo.xwo_loc_des 
                     xwoh_blkflh    = bfxwo.xwo_blkflh  
                     xwoh_wolot     = bfxwo.xwo_wolot   
                     xwoh__chr01    = bfxwo.xwo__chr01  
                     xwoh__chr02    = bfxwo.xwo__chr02  
                     xwoh__dte01    = bfxwo.xwo__dte01  
                     xwoh__log01    = bfxwo.xwo__log01  
                     xwoh__dec01    = bfxwo.xwo__dec01  
                     xwoh__dec02    = bfxwo.xwo__dec02  
                     xwoh_qty_lot   = bfxwo.xwo_qty_lot 
                     xwoh_serial    = bfxwo.xwo_serial  
                     xwoh_loc_lnr   = bfxwo.xwo_loc_lnr 
                     xwoh_cust      = bfxwo.xwo_cust    
                     xwoh_wrk_time  = bfxwo.xwo_wrk_time
                     xwoh_shift     = bfxwo.xwo_shift   
                     xwoh_type      = bfxwo.xwo_type    
                     xwoh_pt_desc   = bfxwo.xwo_pt_desc 
                     xwoh_pdnbr     = bfxwo.xwo_pdnbr  .
         
              delete bfxwo.
               
           end.
        end. /*if first-of*/
        
     end .
     message "存档完成!" view-as alert-box information .
  end .
