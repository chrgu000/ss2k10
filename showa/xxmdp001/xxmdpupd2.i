  /* �ܼƻ��ָ�Ǹ��� */  
  /* ss - 111027.1 by: jack */  /* �ָ����*/

    /* ss - 110409.1 -b
    v_start =  tt_start + 1.
   ss - 110409.1 -e */
   /* ss - 110409.1 -b */
   v_start =  tt_end + 1.
   /* ss - 110409.1 -e */
   v_end =   DATE ( MONTH ( DATE( MONTH (tt_start) , 1 , YEAR(tt_start) )  + 31 )  , 
                                                   1 ,
                                                 YEAR( DATE( MONTH (tt_start) , 1 , YEAR(tt_start) )  + 31 )   
                                                 ) - 1 . 
    v_date = v_start .


   
    n = 0 .
    v_qty_ord2 = v_qty_ord .  /* �洢ת��*/
            /* �ӿ�ʼ���ڵ��������ڼ��㶩�� */
  

            REPEAT WHILE v_date <= v_end :
        
/*                 /* �ų��ż�ʱ��*/                                            */
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
                                   
                            
                                    n = n + 1 .

                                    
                                    IF n = 1  THEN DO:
                                         v_qty_ord = v_qty_ord1 .
                                    END.
                                    ELSE
                                      v_qty_ord = v_qty_ord2 .
                                      
                                   
                                    /* ss - 111027.1 -b */
                                      IF sod__dec01 <> 0 THEN
                                     v_qty_ord = v_qty_ord + sod__Dec01 .
                                      ELSE
                                          v_qty_ord = sod_qty_ord + v_qty_ord .
                                    /* ss - 111027.1 -e */

                          
                        
                               
                                       IF v_qty_ord < sod_qty_ship  + sod_qty_all + sod_qty_pick   THEN DO: /* �޸���������С�� ����+����+����*/
    
                                            CREATE tte .
                                                  ASSIGN 
                                                      tte_type1 = "���" 
                                                      tte_type = "����"
                                                      tte_cust = t1_cust
                                                      tte_part = t1_part
                                                      tte_desc = "�޸�����ʧ�ܣ�����С�ڷ�����+����+������" + "����:" + sod_nbr + "���:" + STRING(sod_line) + "/" +  STRING(v_qty_ord) 
                                                      + STRING( sod_qty_ship + sod_qty_all + sod_qty_pick )
                                                      .
                                       END.
                                       ELSE DO:
                                           /* ss- 110421.1 -b
                                               {xxmdpnewl2.i} /* �����޸� */
                                               ss - 110421.1 -e */
                                           /* ss - 110421.1 -b */
                                            {xxmdpnewl3.i} /*  �ָ�ǲ��޸� sod__chr01 */
                                           /* ss - 110421.1 -e */
                                                                              
    
                                       END.


                         END.
              
               
               v_date = v_date + 1 .
        END.
    /* �ӿ�ʼ���ڵ��������ڼ��㶩�� */
   
    
