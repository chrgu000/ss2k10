{mfdtitle.i}
 DEFINE VAR cust LIKE so_cust.
DEFINE VAR cust1 LIKE so_cust.
DEFINE VAR ord LIKE so_nbr.
DEFINE VAR ord1 LIKE so_nbr.
DEFINE VAR sotot_qty LIKE sod_qty_ship.
DEFINE VAR OPEN_qty LIKE sod_qty_ship.
DEFINE VAR mcost AS DECIMAL  FORMAT "->>,>>>,>>>,>>9.99".
DEFINE VAR cutot_qty LIKE sotot_qty.
DEFINE VAR cuship_qty LIKE sod_qty_ship.
DEFINE VAR cuopen_qty LIKE OPEN_qty.
DEFINE VAR cucost LIKE mcost.
define var soship_qty like sod_qty_ship.
define var mprice like sod_price.
define buffer absmstr for abs_mstr.
DEFINE VAR isdisp AS logical.
    FORM 
    skip(0.5)
    cust COLON 12 LABEL "销往"

    cust1 COLON 35 LABEL "至"
    SKIP(0.5)
    ord COLON 12 LABEL "订单号"
    ord1 COLON 35 LABEL "至"
    WITH FRAME a WIDTH 80 THREE-D SIDE-LABEL.
DEFINE FRAME c
ad_addr colon 12 COLUMN-LABEL "销往"  SKIP(0.5)

  AD_SORT colon 12 COLUMN-LABEL "客户名称"
    WITH WIDTH 150 STREAM-IO SIDE-LABEL.
DEFINE FRAME b
  
  sod_nbr  COLON 12 column-LABEL "订单号"
  sod_line  column-label "行号"
    sod_part  column-LABEL "零件号"
   PT_DESC1 COLUMN-LABEL "零件描述"
    mprice COLUMN-LABEL "单价"
    sotot_qty  column-LABEL "发运数量"
     soship_qty   column-LABEL "已开票数量"  SPACE(1.5)
    OPEN_qty     column-LABEL "待开票数量"
    mcost COLUMN-LABEL "待开金额"
    WITH WIDTH 150 STREAM-IO DOWN  .
REPEAT :

    do with frame a:
               SET cust cust1 EDITING:
               IF FRAME-FIELD = "cust" THEN DO:
              
                    {mfnp.i so_mstr cust so_cust cust so_cust so_cust
                       }
                IF recno <> ? THEN do:
               cust = so_cust.
               
                DISPLAY cust WITH FRAME a.
                
                
                 end.
                    
                    
                    END.
                  IF FRAME-FIELD = "cust1" THEN DO:
              
                    {mfnp.i so_mstr cust1 so_cust cust1 so_cust so_cust
                       }
                IF recno <> ? THEN do:
               cust1 = so_cust.
               
                DISPLAY cust1 WITH FRAME a.
                
                
                 end.
                    
                     
                    END.



                   END.
                SET ord ord1 EDITING:

                      IF FRAME-FIELD = "ord" THEN DO:
              
                    {mfnp.i so_mstr ord so_nbr ord so_nbr so_nbr
                       }
                IF recno <> ? THEN do:
               ord = so_nbr.
               
                DISPLAY ord WITH FRAME a.
                
                
                 end.
                    
                    
                    END.
                  IF FRAME-FIELD = "ord1" THEN DO:
              
                    {mfnp.i so_mstr ord1 so_nbr ord1 so_nbr so_nbr
                       }
                IF recno <> ? THEN do:
               ord1 = so_nbr.
               
                DISPLAY ord1 WITH FRAME a.
                
                
                 end.
                    
                     
                    END.
                   
                   END.
                   END.

          {mfselbpr.i "printer" 80} 

             IF cust1 = "" THEN cust1 = hi_char.
              IF ord1 = "" THEN ord1 = hi_char.
             {mfphead.i}
                   FOR EACH ad_mstr WHERE ad_addr >= cust and ad_addr <= cust1 and (ad_type = 'ship-to' OR ad_type = 'customer') NO-LOCK :
               cutot_qty  = 0.
               cuship_qty = 0.
               cucost = 0.
                cuopen_qty = 0.
       
                  isdisp = NO. 
          find first abs_mstr where ABS_mstr.ABS_shipto = ad_addr no-lock no-error.
          find first absmstr where absmstr.abs_par_id = abs_mstr.abs_id no-lock no-error.
           IF AVAILABLE abs_mstr /*and available absmstr*/  THEN  DO:
             if page-size - line-counter < 2 then page.
             disp ad_addr ad_sort with frame c.
           FOR EACH so_mstr WHERE so_cust = ABS_mstr.ABS_shipto  AND so_nbr >= ord AND so_nbr <= ord1  no-lock:

  
   
FOR EACH sod_det WHERE sod_det.sod_nbr = so_mstr.so_nbr NO-LOCK:
         sotot_qty = 0. 
        
        
         FOR EACH ABS_mstr WHERE ABS_mstr.ABS_par_id <> "" AND abs_mstr.abs_ord = sod_nbr AND abs_mstr.abs_line = string(sod_line) AND ABS_mstr.ABS_item = sod_part AND abs_mstr.abs_loc = '8888' NO-LOCK:
          
              sotot_qty = sotot_qty + ABS_mstr.ABS_qty.
              
                isdisp = YES.
              
              END.
              
              FIND FIRST pt_mstr WHERE pt_part = sod_part NO-LOCK NO-ERROR.
/* FIND ad_mstr WHERE ad_addr = SO_MSTR.SO_CUST AND (ad_type = 'ship-to' OR ad_type = 'customer') NO-LOCK NO-ERROR.*/
    for LAST sct_det where sct_part = sod_part and sct_sim = 'standard' by sct_cst_date :
   
   
 IF sotot_qty <> 0 THEN DO:  
      soship_qty = 0. 
       FOR EACH tr_hist WHERE (IF tr_type = 'iss-so' THEN tr_nbr = sod_nbr ELSE YES) AND tr_loc = '8888' AND (tr_type = 'iss-so' OR tr_type = 'iss-tr')   AND tr_part = sod_part NO-LOCK:
     
         soship_qty = soship_qty + tr_qty_loc.
       
         END.
     mprice = 0.
     cutot_qty = cutot_qty + sotot_qty.    
     mcost = (sotot_qty + soship_qty) * sct_cst_tot .
   
    
        open_qty = sotot_qty + soship_qty.
        cuopen_qty = cuopen_qty + open_qty.
          cucost = cucost + mcost.
           cuship_qty = cuship_qty + soship_qty.
         
           if page-size - line-counter < 2 then page.
                     if sod_price <> 0 or sod_list_pr <> 0 THEN mprice = if sod_price <> 0 then sod_price else sod_list_pr.
                                     else DO:
              FIND FIRST scx_ref WHERE scx_ord = so_nbr NO-LOCK NO-ERROR.
               IF AVAILABLE scx_ref THEN DO:
             
                
                
                if sod_pr_list <> '' then do:
            
              find last pc_mstr where pc_list = sod_pr_list AND pc_amt_type = 'p' and pc_part = sod_part and sod_um = pc_um and pc_start <> ? and  pc_start <= today and IF pc_expire = ? THEN YES ELSE pc_expire >= today and so_curr = pc_curr    no-lock no-error.
             /* disp sod_pr_list pc_list sod_um pc_um pc_part sod_part so_curr pc_curr.*/
           if available pc_mstr then 
             /*  DISP pc_amt[1]. */
               mprice = pc_amt[1].
                  END.
                end.
               ELSE DO:
                
                     FIND LAST pi_mstr WHERE pi_list = sod_pr_list AND pi_amt_type = '1' AND pi_cs_code = so_cust AND pi_part_code = sod_part AND sod_um = pi_um AND so_curr = pi_curr AND pi_start <> ? and pi_start <= TODAY AND IF pi_expire = ? THEN YES ELSE pi_expire >= TODAY NO-LOCK NO-ERROR.
                  
                
                               if available pi_mstr  then  mprice = pi_list_price.
                  
                                   END.
                  
                  END.
                 
                
                
               DISPLAY  sod_nbr sod_line sod_part pt_desc1  mprice sotot_qty abs(soship_qty) @ soship_qty  OPEN_qty  mcost  WITH FRAME b.
            if pt_desc2 <> '' then do:
                     down 1 .
                    put space(46).
                    put pt_desc2.
                   
                 end.
       
       
       END.
    END.
              
              END. /*sod end*/
             


           END.   /*so_mstr end*/
 IF isdisp THEN do: 
    /* cucost = abs(cucost).  */       
            cuship_qty = abs(cuship_qty).
              put skip(1). 
PUT SPACE(82). put "合计". put space(2).
PUT '-------------'.
PUT SPACE(1).
PUT '-------------'.
PUT SPACE(1).
PUT '-------------'.
PUT SPACE(1).
PUT '---------------'.
put skip.
PUT SPACE(88). 
PUT cutot_qty. 
PUT SPACE(1).
PUT cuship_qty.
PUT SPACE(1).
PUT cuopen_qty.
PUT SPACE(1).
PUT cucost.
  END.
end.  /*available end*/
 END.
 {mftrl080.i} 

 END.
