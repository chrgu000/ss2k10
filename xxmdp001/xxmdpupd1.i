    /* 周覆盖-带有删除和更新功能*/   
    /* 110831.1 by: jack 月计划不管放假时间*/ 


    v_start =  t1_date.
    v_end =  t1_date .
    v_date = v_start .


    /* 数量不为0 */
   IF v_qty_ord <> 0 THEN DO: 
            n = 0 .
            
            v_qty_ord2 = v_qty_ord .  /* 存储转化*/
                    /* 从开始日期到结束日期计算订单 */
            IF t1_type = "m" THEN DO:  /* 月计划更新 */
        
                    REPEAT WHILE v_date <= v_end :
                
                        /* ss - 110831.1 -b
                        /* 排除放假时间*/
                        FIND FIRST hd_mstr WHERE hd_date = v_date NO-LOCK NO-ERROR .
                        IF NOT AVAILABLE hd_mstr  THEN DO:
                        ss - 110831.1 -e */
                            n = n + 1 .
                                 FIND FIRST cm_mstr WHERE cm_addr = t1_cust NO-LOCK NO-ERROR .
                                 IF AVAIL cm_mstr THEN v_sort = SUBSTRING(cm_sort ,1 , 2 ) . ELSE v_sort = "" .
                
                                  v_year = SUBSTRING(STRING(YEAR(v_date),"9999") , 3 ).
                                  IF MONTH(v_date) < 10 THEN v_month = STRING(MONTH(v_date) ,"9") . 
                                  ELSE IF MONTH(v_date) = 10 THEN v_month = "A".
                                  ELSE IF MONTH(v_date) = 11 THEN v_month = "B".
                                  ELSE v_month = "C" .
                
                                  v_sonbr = v_sort + v_year + v_month + STRING(DAY(v_date),"99") + SUBSTRING(t1_ptype,1,1) .
                                  FIND FIRST so_mstr WHERE so_nbr = v_sonbr NO-ERROR .
                                  IF AVAILABLE so_mstr  THEN DO:
                                     
                                      FIND LAST sod_det WHERE sod_nbr = so_nbr AND sod_part = t1_part EXCLUSIVE-LOCK NO-ERROR .
                                      IF AVAILABLE sod_det THEN
                                          ASSIGN
                                                v_i = sod_line
                                                v_addsod = YES 
                                                v_addso = NO 
                                          .
                                      ELSE  DO:
                                     
                                          FIND LAST sod_Det WHERE sod_nbr = so_nbr EXCLUSIVE-LOCK NO-ERROR .
                                          IF AVAILABLE sod_det THEN
                                              ASSIGN
                                                    v_i = sod_line
                                                    v_addsod = YES 
                                                    v_addso = YES 
                                              .
            
                                           ELSE DO:
                                          
                                          ASSIGN
                                                v_i = 0
                                                v_addsod = YES
                                                v_addso = YES
                                               .
                                          END.
                                     END.
                                  END.
                                  ELSE DO:
                                      v_i = 0 .
                                      v_addsod = NO .
                                      v_addso = YES .
                                  END.
        
/*                                    IF n = 1  THEN DO:          */
/*                                       v_qty_ord = v_qty_ord1 . */
/*                                   END.                         */
/*                                   ELSE                         */
/*                                       v_qty_ord = v_qty_ord2 . */
        
                                  IF v_addso THEN DO: /* 新增*/
                                     
                                       v_i = v_i + 1 .
                                       IF v_addsod = NO THEN DO:  /* 新增主档 */
                                     
                                       
                                        {xxmdpnewm1.i} 
                                       END.
                                     
                                       ELSE DO:
                                     
                                        {xxmdpnewl1.i} /* 新增明细 */
                                       END.
                
                                  END.
                                  ELSE DO: /* 覆盖*/
                                      IF v_addsod THEN DO:
                                     
                                    
                                       FIND LAST sod_det WHERE sod_nbr = v_sonbr AND sod_line = v_i NO-LOCK NO-ERROR .
                                       IF AVAILABLE sod_Det THEN DO:
                                           IF v_qty_ord < sod_qty_ship   + sod_qty_all + sod_qty_pick  THEN DO: /* 修改数量不能小于 备料+检料+发运*/
        
                                                CREATE tte .
                                                      ASSIGN 
                                                          tte_type1 = "零件" 
                                                          tte_type = "错误"
                                                          tte_cust = t1_cust
                                                          tte_part = t1_part
                                                          tte_desc = "修改数量失败，不能小于发运量+ 备料量 + 检料量" + "订单:" + sod_nbr + "项次:" + STRING(sod_line) + "/" +  STRING(v_qty_ord) 
                                                          + STRING( sod_qty_ship + sod_qty_all + sod_qty_pick )
                                                          .
                                           END.
                                           ELSE DO:
                                              
                                            
                                                
                                               IF sod__chr01 = "3"  THEN DO:
        
                                                    CREATE tte .
                                                      ASSIGN 
                                                          tte_type1 = "零件" 
                                                          tte_type = "错误"
                                                          tte_cust = t1_cust
                                                          tte_part = t1_part
                                                          tte_desc = "订单数据已经被周计划更新，不能越级更新" + "订单:" + sod_nbr + "项次:" + STRING(sod_line) 
                                                          .
        
                                               END.
                                               ELSE DO:
                                                   {xxmdpnewl2.i} /* 覆盖修改 */
                                               END.
        
                                             
        
                                               
        
                                           END.
                                       END.
                                    END.
                                       
                                     
                                  END.
                                 
                                  
                
                       /* ss - 110831.1 -b
                        END.
                        /* 排除放假时间*/
                        ss - 110831.1 -e */
                       
                       v_date = v_date + 1 .
                END.
            /* 从开始日期到结束日期计算订单 */
            END . /* 月计划更新 */
            ELSE DO: /* 周计划更新 不根据假期控制 */
        
                     REPEAT WHILE v_date <= v_end :
                
/*                         /* 排除放假时间*/                                            */
/*                         FIND FIRST hd_mstr WHERE hd_date = v_date NO-LOCK NO-ERROR . */
/*                         IF NOT AVAILABLE hd_mstr  THEN DO:                           */
                            n = n + 1 .
                                 FIND FIRST cm_mstr WHERE cm_addr = t1_cust NO-LOCK NO-ERROR .
                                 IF AVAIL cm_mstr THEN v_sort = SUBSTRING(cm_sort ,1 , 2 ) . ELSE v_sort = "" .
                
                                  v_year = SUBSTRING(STRING(YEAR(v_date),"9999") , 3 ).
                                  IF MONTH(v_date) < 10 THEN v_month = STRING(MONTH(v_date) ,"9") . 
                                  ELSE IF MONTH(v_date) = 10 THEN v_month = "A".
                                  ELSE IF MONTH(v_date) = 11 THEN v_month = "B".
                                  ELSE v_month = "C" .
                
                                  v_sonbr = v_sort + v_year + v_month + STRING(DAY(v_date),"99") + SUBSTRING(t1_ptype,1,1) .
                                  FIND FIRST so_mstr WHERE so_nbr = v_sonbr NO-ERROR .
                                  IF AVAILABLE so_mstr  THEN DO:
                                     
                                      FIND LAST sod_det WHERE sod_nbr = so_nbr AND sod_part = t1_part EXCLUSIVE-LOCK NO-ERROR .
                                      IF AVAILABLE sod_det THEN
                                          ASSIGN
                                                v_i = sod_line
                                                v_addsod = YES 
                                                v_addso = NO 
                                          .
                                      ELSE  DO:
                                     
                                          FIND LAST sod_Det WHERE sod_nbr = so_nbr EXCLUSIVE-LOCK NO-ERROR .
                                          IF AVAILABLE sod_det THEN
                                              ASSIGN
                                                    v_i = sod_line
                                                    v_addsod = YES 
                                                    v_addso = YES 
                                              .
            
                                           ELSE DO:
                                          
                                          ASSIGN
                                                v_i = 0
                                                v_addsod = YES
                                                v_addso = YES
                                               .
                                          END.
                                     END.
                                  END.
                                  ELSE DO:
                                      v_i = 0 .
                                      v_addso = YES .
                                      v_addsod = NO .
                                  END.
/*                                                                */
/*                                    IF n = 1  THEN DO:          */
/*                                       v_qty_ord = v_qty_ord1 . */
/*                                   END.                         */
/*                                   ELSE                         */
/*                                       v_qty_ord = v_qty_ord2 . */

                                
        
                                  IF v_addso THEN DO: /* 新增*/
                                     
                                       v_i = v_i + 1 .
                                       IF v_addsod = NO THEN DO:  /* 新增主档 */
                                     
                                       
                                        {xxmdpnewm1.i} 
                                       END.
                                     
                                       ELSE DO:
                                     
                                        {xxmdpnewl1.i} /* 新增明细 */
                                       END.
                
                                  END.
                                  ELSE DO: /* 覆盖*/
                                     
                                      
                                    IF v_addsod  THEN DO:
                               
                                       FIND LAST sod_det WHERE sod_nbr = v_sonbr AND sod_line = v_i NO-LOCK NO-ERROR .
                                       IF AVAILABLE sod_Det THEN DO:
                                           IF v_qty_ord < sod_qty_ship + sod_qty_all + sod_qty_pick  THEN DO: /* 修改数量不能小于 备料+检料+发运*/
        
                                                CREATE tte .
                                                      ASSIGN 
                                                          tte_type1 = "零件" 
                                                          tte_type = "错误"
                                                          tte_cust = t1_cust
                                                          tte_part = t1_part
                                                          tte_desc = "修改数量失败，不能小于备料+检料+ 发运量" + "订单:" + sod_nbr + "项次:" + STRING(sod_line) + "/" + STRING(v_qty_ord) 
                                                          + STRING( sod_qty_ship + sod_qty_all + sod_qty_pick )
                                                          .
                                           END.
                                           ELSE DO:
                                                   {xxmdpnewl2.i} /* 覆盖修改 */
        
                                           END.
                                       END.
                                    END.  
                                     
                                  END.
                                 
                                  
                
                
/*                         END.              */
/*                         /* 排除放假时间*/ */
                       
                       v_date = v_date + 1 .
                END.
            /* 从开始日期到结束日期计算订单 */
        
        
              
           END.
   END . 
   ELSE DO : /* v_qty_ord = 0 */

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



                                    IF  sod_qty_ship <> 0    THEN DO: /* 修改数量不能小于 备料+检料+发运*/

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

   END.
    
    
