  /* 110422.1  sp���ܶ��������򸲸�  */
      

  
    v_start = t1_end + 1 .
    v_last_end = DATE ( MONTH ( DATE( MONTH (t1_date) , 1 , YEAR(t1_date) )  + 31 )  , 
                                               1 ,
                                             YEAR( DATE( MONTH (t1_date) , 1 , YEAR(t1_date) )  + 31 )   
                                             ) .

    v_end =   DATE ( MONTH ( DATE( MONTH (v_last_end) , 1 , YEAR(v_last_end) )  + 31 )  , 
                                               1 ,
                                             YEAR( DATE( MONTH (v_last_end) , 1 , YEAR(v_last_end) )  + 31 )   
                                             ) - 1 . 
    
    v_date = v_start .


    /* ������Ϊ0 */
   IF v_qty_ord <> 0 THEN DO: 
            n = 0 .
      

                                       v_qty_ord2 = v_qty_ord .  /* �洢ת��*/
                                        /* �ӿ�ʼ���ڵ��������ڼ��㶩�� */
                                        v_last_date = ? .
                                        REPEAT WHILE v_date <= v_end :
                                    
                                            /* �ų��ż�ʱ��,���ҵ������ں��һ�����۵���û�д�����Ķ������˳���Ŀ���ǽ�����ŵ���֮��ĵ�һ�������ն�����*/
                                            FIND FIRST hd_mstr WHERE hd_date = v_date NO-LOCK NO-ERROR .
                                            IF NOT AVAILABLE hd_mstr  THEN DO:
                                               
                                               v_last_date = v_date .   

                                                 FIND FIRST cm_mstr WHERE cm_addr = t1_cust NO-LOCK NO-ERROR .
                                                IF AVAIL cm_mstr THEN v_sort = SUBSTRING(cm_sort ,1 , 2 ) . ELSE v_sort = "" .
                
                                                 v_year = SUBSTRING(STRING(YEAR(v_last_date),"9999") , 3 ).
                                                 IF MONTH(v_last_date) < 10 THEN v_month = STRING(MONTH(v_last_date) ,"9") . 
                                                 ELSE IF MONTH(v_last_date) = 10 THEN v_month = "A".
                                                 ELSE IF MONTH(v_last_date) = 11 THEN v_month = "B".
                                                 ELSE v_month = "C" .
            
                                                 v_sonbr = v_sort + v_year + v_month + STRING(DAY(v_last_date),"99") + SUBSTRING(t1_ptype,1,1) .

                                                 FIND FIRST sod_det WHERE sod_nbr = v_sonbr AND sod_part = t1_part NO-LOCK NO-ERROR .
                                                 IF NOT AVAILABLE sod_det THEN
                                                     LEAVE .
                                    
                                    
                                            END.
                                            /* �ų��ż�ʱ��*/
                                           
                                           v_date = v_date + 1 .
                                        END.
                                    /* �ӿ�ʼ���ڵ��������ڼ��㶩�� */

                                        v_date = v_last_date .

                                   /* ���Ҹ��¶��� */  /* �����һ����������ʱ��������*/

                                       
                   
/*                                     FIND FIRST cm_mstr WHERE cm_addr = t1_cust NO-LOCK NO-ERROR .                                    */
/*                                     IF AVAIL cm_mstr THEN v_sort = SUBSTRING(cm_sort ,1 , 2 ) . ELSE v_sort = "" .                   */
/*                                                                                                                                      */
/*                                      v_year = SUBSTRING(STRING(YEAR(v_last_date),"9999") , 3 ).                                      */
/*                                      IF MONTH(v_last_date) < 10 THEN v_month = STRING(MONTH(v_last_date) ,"9") .                     */
/*                                      ELSE IF MONTH(v_last_date) = 10 THEN v_month = "A".                                             */
/*                                      ELSE IF MONTH(v_last_date) = 11 THEN v_month = "B".                                             */
/*                                      ELSE v_month = "C" .                                                                            */
/*                                                                                                                                      */
/*                                      v_sonbr = v_sort + v_year + v_month + STRING(DAY(v_last_date),"99") + SUBSTRING(t1_ptype,1,1) . */
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


    
                                     IF v_addso THEN DO: /* ����*/
    
                                          v_i = v_i + 1 .
                                          IF v_addsod = NO THEN DO:  /* �������� */
    
                                                               
                                           {xxmdpnewm2.i} /* �����Ķ�Ϊsod__chr01 = "2" */ 
                                          END.
    
                                          ELSE DO:
    
                                           {xxmdpnewl4.i} /* ������ϸ */  /* �����Ķ�Ϊsod__chr01 = "2" */
                                          END.
    
                                     END.
                                     ELSE DO:
                                          CREATE tte .
                                                         ASSIGN 
                                                             tte_type1 = "���" 
                                                             tte_type = "����"
                                                             tte_cust = t1_cust
                                                             tte_part = t1_part
                                                             tte_desc = "�Ѿ�����������������ܸ���" + "����:" + sod_nbr + "���:" + STRING(sod_line) 
                                                             .
                                     END.
                                 
                               

                /*  ���Ҹ��¶��� */
           
           
   END . 
  
    
