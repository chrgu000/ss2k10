  

   
  /* 当数量相等时还原 tt_qty_ord */
          
        
/*                 /* 排除放假时间*/                                            */
/*                 FIND FIRST hd_mstr WHERE hd_date = v_date NO-LOCK NO-ERROR . */
/*                 IF NOT AVAILABLE hd_mstr  THEN DO:                           */
                   
                         
                         FIND LAST sod_det WHERE sod_nbr = tt_sodnbr AND sod_line = tt_sodline NO-LOCK NO-ERROR .
                         IF AVAILABLE sod_det  THEN DO:
                             ASSIGN
                                   v_i = sod_line .
                                   v_sonbr = sod_nbr .
                                   
                            
                                   v_qty_ord = tt_qty_ord .

                          
                        
                               
                                       IF v_qty_ord < sod_qty_ship  + sod_qty_all + sod_qty_pick   THEN DO: /* 修改数量不能小于 备料+检料+发运*/
    
                                            CREATE tte .
                                                  ASSIGN 
                                                      tte_type1 = "零件" 
                                                      tte_type = "错误"
                                                      tte_cust = t1_cust
                                                      tte_part = t1_part
                                                      tte_desc = "修改数量失败，不能小于发运量+备料+检料量" + "订单:" + sod_nbr + "项次:" + STRING(sod_line) + "/" +  STRING(v_qty_ord) 
                                                      + STRING( sod_qty_ship + sod_qty_all + sod_qty_pick )
                                                      .
                                       END.
                                       ELSE DO:
                                           /* ss- 110421.1 -b
                                               {xxmdpnewl2.i} /* 覆盖修改 */
                                               ss - 110421.1 -e */
                                           /* ss - 110421.1 -b */
                                            {xxmdpnewl3.i} /*  分割覆盖不修改 sod__chr01 */
                                           /* ss - 110421.1 -e */
                                                                              
    
                                       END.


                         END.
              
               
          
    /* 从开始日期到结束日期计算订单 */
   
    
