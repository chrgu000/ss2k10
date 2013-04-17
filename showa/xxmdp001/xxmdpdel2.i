/*  删除时间范围内的无计划订单 */
    
   
                        v_start = v_start1 .
                        v_end =   v_start1 . 
                        v_date = v_start .


                         FIND FIRST cm_mstr WHERE cm_addr = t2_cust NO-LOCK NO-ERROR .
                         IF AVAIL cm_mstr THEN v_sort = SUBSTRING(cm_sort ,1 , 2 ) . ELSE v_sort = "" .
        
                          v_year = SUBSTRING(STRING(YEAR(v_date),"9999") , 3 ).
                          IF MONTH(v_date) < 10 THEN v_month = STRING(MONTH(v_date) ,"9") . 
                          ELSE IF MONTH(v_date) = 10 THEN v_month = "A".
                          ELSE IF MONTH(v_date) = 11 THEN v_month = "B".
                          ELSE v_month = "C" .
        
                          v_sonbr = v_sort + v_year + v_month + STRING(DAY(v_date),"99") + SUBSTRING(t2_ptype,1,1) .
                         FIND LAST sod_det WHERE sod_nbr = v_sonbr AND sod_part = t2_part NO-LOCK NO-ERROR .
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
                                                      tte_cust = t2_cust
                                                      tte_part = t2_part
                                                      tte_desc = "删除失败，已经发运" + "订单:" + sod_nbr + "项次:" + STRING(sod_line) +  STRING(sod_qty_ship) 
                                                    
                                                      .
                                       END.
                                       ELSE DO:
                                           
                                               {xxmdpdell2.i} /* 删除 */
                                                                              
    
                                       END.


                         END.
              
               
             
    
   
    
