  /* 周计划分割覆盖更新 */  

    
    /* ss - 110409.1 -b
    v_start =  tt_start + 1.
   ss - 110409.1 -e */
   /* ss - 110409.1 -b */
   v_start =  tt_end + 1.
   /* ss - 110409.1 -e */

    v_end =   DATE ( MONTH ( DATE( month(tt_start) , 1 , YEAR(tt_start) )  + 31 )  , 
                     1 ,  
                     YEAR(DATE( month(tt_start) , 1 , YEAR(tt_start) )  + 31 )  
                   )  - 1 . 
    v_date = v_start .


   
/*     n = 0 .                                 */
/*     v_qty_ord2 = v_qty_ord .  /* 存储转化*/ */
            /* 从开始日期到结束日期计算订单 */
  

            REPEAT WHILE v_date <= v_end :
        
/*                 /* 排除放假时间*/                                            */
/*                 FIND FIRST hd_mstr WHERE hd_date = v_date NO-LOCK NO-ERROR . */
/*                 IF NOT AVAILABLE hd_mstr  THEN DO:                           */
                   
                         FIND FIRST cm_mstr WHERE cm_addr = t1_cust NO-LOCK NO-ERROR .
                         IF AVAIL cm_mstr THEN v_sort = SUBSTRING(cm_sort ,1 , 2 ) . ELSE v_sort = "" .
        
                          v_year = SUBSTRING(STRING(YEAR(v_date),"9999") , 3 ).
                          IF MONTH(v_date) < 10 THEN v_month = STRING(MONTH(v_date) ,"9") . 
                          ELSE IF MONTH(v_date) = 10 THEN v_month = "A".
                          ELSE IF MONTH(v_date) = 11 THEN v_month = "B".
                          ELSE v_month = "C" .
        
                          v_sonbr = v_sort + v_year + v_month + STRING(DAY(v_date),"99") + SUBSTRING(t1_ptype,1,1) .
                         FIND LAST sod_det WHERE sod_nbr = v_sonbr AND sod_part = t1_part NO-LOCK NO-ERROR .
                         IF AVAILABLE sod_det  THEN DO:
                             ASSIGN
                                   v_i = sod_line .
                                   
/*                                     n = n + 1 .                   */
/*                                                                   */
/*                                     IF n = 1  THEN DO:            */
/*                                          v_qty_ord = v_qty_ord1 . */
/*                                     END.                          */
/*                                     ELSE                          */
/*                                       v_qty_ord = v_qty_ord2 .    */

                         
                        
                             
                            
                                   
                                   
                                       IF  sod_qty_ship <> 0  THEN DO: /* 数量发运*/
    
                                            CREATE tte .
                                                  ASSIGN 
                                                      tte_type1 = "零件" 
                                                      tte_type = "错误"
                                                      tte_cust = t1_cust
                                                      tte_part = t1_part
                                                      tte_desc = "删除失败，已经发运" + "订单:" + sod_nbr + "项次:" + STRING(sod_line) +  STRING(sod_qty_ship) 
                                                    
                                                      .
                                       END.
                                       ELSE DO:
                                           
                                               {xxmdpdell1.i} /* 删除 */
                                                                              
    
                                       END.


                         END.
              
               
               v_date = v_date + 1 .
        END.
    /* 从开始日期到结束日期计算订单 */
   
    
