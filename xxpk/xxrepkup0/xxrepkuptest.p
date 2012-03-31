/* GUI CONVERTED from repkupd.p (converter v1.76) Wed Dec 18 20:55:28 2002    */
/* repkupd.p - REPETITIVE PICKLIST CALCULATION                                */

define variable issue          as date.
define variable issue1         as date.
define variable site           like si_site.
define variable site1          like si_site.
define variable wkctr          like op_wkctr initial "HPS".
define variable wkctr1         like op_wkctr initial "HPS".
define variable i              as    integer.
{mfdtitle.i "Lambert Test"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{xxrepkup0.i "new"}
{xxrepkup1.i "new"}
repeat:
  update 
    issue issue1 site site1  wkctr  wkctr1 
  with frame a.
  /* SS lambert 20120311 begin */
       for each xxwd_det exclusive-lock where xxwd_date >= issue :
           if xxwd_type = "P" then  do:
             create tt1pwddet.
             assign
               tt1pwd_ladnbr    = xxwd_ladnbr    
               tt1pwd_nbr       = xxwd_nbr    
               tt1pwd_part      = xxwd_part      
               tt1pwd_site      = xxwd_site      
               tt1pwd_line      = xxwd_line      
               tt1pwd_date      = xxwd_date
               tt1pwd_time      = xxwd_time
               tt1pwd_loc       = xxwd_loc       
               tt1pwd_sn        = xxwd_sn        
               tt1pwd_lot       = xxwd_lot       
               tt1pwd_ref       = xxwd_ref       
               tt1pwd_qty_plan  = xxwd_qty_plan  
               tt1pwd_ok        = yes
             .
           end.
           if xxwd_type = "S" then  do:
             create tt1swddet.
             assign
               tt1swd_ladnbr    = xxwd_ladnbr    
               tt1swd_nbr       = xxwd_nbr    
               tt1swd_part      = xxwd_part      
               tt1swd_site      = xxwd_site      
               tt1swd_line      = xxwd_line      
               tt1swd_date      = xxwd_date
               tt1swd_time      = xxwd_time
               tt1swd_loc       = xxwd_loc       
               tt1swd_sn        = xxwd_sn        
               tt1swd_lot       = xxwd_lot       
               tt1swd_ref       = xxwd_ref       
               tt1swd_qty_plan  = xxwd_qty_plan  
               tt1swd_ok        = yes
             .
           end.       
       end.
/* SS lambert 20120311 end */

  for each xxwa_det no-lock where
            xxwa_date >= issue and xxwa_date <= issue1 and
            xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
            xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "") and
            xxwa_qty_pln > 0
            break by xxwa_date by xxwa_site by xxwa_line by xxwa_nbr
                  by xxwa_part by xxwa_rtime:
      find first tiss1 where
         tiss1_sdate    = xxwa_date     and
         tiss1_rtime    = xxwa_rtime   and
         tiss1_line     = xxwa_line     and
         tiss1_part     = xxwa_part
         no-error.
       if not avail tiss1 then do:
         create tiss1.
         assign
           tiss1_sdate    = xxwa_date   
           tiss1_nbr      = xxwa_nbr
           tiss1_pdate    = xxwa_date
           tiss1_ptime    = xxwa_pstime
           tiss1_stime    = xxwa_sstime
           tiss1_rtime    = xxwa_rtime
           tiss1_line     = xxwa_line
           tiss1_part     = xxwa_part
           tiss1_qty      = 0
         .
       end.
       tiss1_qty = tiss1_qty + xxwa_qty_pln.
  end.
  
  for each tiss1 break by tiss1_part:
    if first-of(tiss1_part) then do:
      for each ld_det no-lock where ld_site = "gsa01" and 
      		     ld_part = tiss1_part and ld_qty_oh > 0 :
        create tsupp.
        assign
          tsu_loc       =  ld_loc
          tsu_part      =  ld_part
          tsu_lot       =  ld_lot
          tsu_ref       =  ld_ref
          tsu_qty       =  ld_qty_oh
          tsu_flg       =  ""
          tsu_abc       =  ""
          tsu_lpacks    =  0
          tsu_ltrail    =  0
          tsu_bpacks    =  0
          tsu_btrail    =  0
          tsu_lit       =  0
          tsu_big       =  0
        .
      end.
    end.
  end.
  thmsg = "" .
  {gprun.i ""xxrepkupall.p""}
  if length(thmsg) > 0 then do:
    message "存在不能执行的单据".
    for each ttmsg:
      message tmsg.
    end.
  end.
  else do:
    assign i = 1.
    for each trlt1:                                                                                   
      find first xxwd_det where xxwd_nbr = trt1_nbr 
         and  xxwd_type = "S"                  
         and  xxwd_date = trt1_sdate
         and  xxwd_time = trt1_stime
         and  xxwd_part = trt1_part                                        
         and  xxwd_site = "GSA01"                                        
         and  xxwd_line = trt1_line                                        
         and  xxwd_lot  = trt1_lot                                          
         and  xxwd_ref  = trt1_ref     no-error.    
      if not avail   xxwd_det then do:
        CREATE xxwd_det.                                                  
        assign xxwd_nbr = trt1_nbr     
               /*                                    
               xxwd_ladnbr = "S"                                          
               xxwd_recid = xxwa_recid       
               */          
               xxwd_type = "S"                  
               xxwd_date = trt1_sdate
               xxwd_time = trt1_stime
               xxwd_part = trt1_part                                        
               xxwd_site = "GSA01"                                        
               xxwd_line = trt1_line                                      
               xxwd_loc = trt1_loc                                          
               xxwd_sn =  trt1_seq
               xxwd_lot = trt1_lot                                          
               xxwd_ref = trt1_ref   
               xxwd_qty_plan = 0 
               .
               
      end.                   
      xxwd_qty_plan  =  xxwd_qty_plan + trt1_qty.        
               i = i + 1.                                                                                
    end.
    assign i = 1.
    for each trlt2:                                                                                   
      find first xxwd_det where xxwd_nbr = trt2_nbr 
        and xxwd_type = "P"
        and xxwd_time = trt2_time
        and xxwd_date = trt2_date      
        and xxwd_part = trt2_part                                        
        and xxwd_site = "GSA01"                                        
        and xxwd_line = ""                                      
        and xxwd_loc = trt2_loc                                      
        and xxwd_lot = trt2_lot                                          
        and xxwd_ref = trt2_ref       no-error.
      if not avail xxwd_det then do:
        CREATE xxwd_det.                                                  
        assign xxwd_nbr = trt2_nbr                                         
               /*
               xxwd_ladnbr = "P"                                          
               xxwd_recid = xxwa_recid                                    
               */
               xxwd_type = "P"
               xxwd_time = trt2_time
               xxwd_date = trt2_date      
               xxwd_part = trt2_part                                        
               xxwd_site = "GSA01"                                        
               xxwd_line = ""                                      
               xxwd_loc = trt2_loc                                          
               xxwd_sn =  trt2_seq                                        
               xxwd_lot = trt2_lot                                          
               xxwd_ref = trt2_ref   
               xxwd_qty_plan = 0                                        
               .
      end.
               xxwd_qty_plan  = xxwd_qty_plan + trt2_qty.                      
               i = i + 1.                                                                               
    end.
  end.
  
end.