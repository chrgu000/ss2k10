  /* �ܼƻ�����ʱ����ʱ�ۼ� */
  /* ss - 110831.1 by: jack */ /* �²��ܷż� */

/*     v_start =  DATE(t1_month , 1 , t1_year ).                           */
/*     v_end =  DATE(MONTH(v_start + 31)  , 1 , YEAR(v_start + 31 )) - 1 . */
    v_start = t1_date .
    v_end = t1_date .
    v_date = v_start .

    n = 0 .

/*     /*  ����ϸ -bbb*/              */
    IF t1_type = "m" THEN DO:

      
                /* �ӿ�ʼ���ڵ��������ڼ��㶩�� */
              
                REPEAT WHILE v_date <= v_end :
            
                  /* ss - 110831.1 - b
                    /* �ų��ż�ʱ��*/
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
                                  v_addso = NO .
                                  FIND LAST sod_det WHERE sod_nbr = so_nbr EXCLUSIVE-LOCK NO-ERROR .
                                  IF AVAILABLE sod_det THEN
                                      v_i = sod_line .
                                  ELSE
                                      v_i = 0 .
                              END.
                              ELSE DO:
                                  v_i = 0 .
                                  v_addso = YES .
                              END.
            
                             
            
            
                               FIND FIRST sod_det WHERE sod_nbr = v_sonbr AND sod_part = t1_part NO-LOCK NO-ERROR .
                                 IF NOT AVAILABLE sod_Det THEN  DO:
                                 

                                  IF v_addso THEN DO: /* ��������*/
                                       v_i = v_i + 1 .
                                       {xxmdpnewm1.i}

                                  END.
                                  ELSE DO: /* ��ϸ����*/
                                      v_i = v_i + 1 .
                                       {xxmdpnewl1.i}

                                  END.
                                END.
                                ELSE DO:
                                         CREATE tte .
                                  ASSIGN
                                      tte_type1 = "���"
                                      tte_type = "����"
                                      tte_cust = t1_cust
                                      tte_part = t1_part
                                      tte_desc = "����Ѿ����ڶ����в�������" + sod_nbr + "/" + STRING(sod_line) 
                                      .
                                END.

                             
                           
            
                    /* ss - 110831.1 -b
                    END.
                    /* �ų��ż�ʱ��*/
                    ss - 110831.1 -e */
                  
                   v_date = v_date + 1 .
                END.
                /* �ӿ�ʼ���ڵ��������ڼ��㶩�� */
    




       

    END. /*  ����ϸ -bbb*/
    ELSE DO: /* ����ϸ -bbbb */  /*  ����ϸ���������������� ,��ʵ�ʵ���ʱ����� */
              

                    /* �ӿ�ʼ���ڵ��������ڼ��㶩�� */
                      
                        REPEAT WHILE v_date <= v_end :

                           
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
                                          v_addso = NO .
                                          FIND LAST sod_det WHERE sod_nbr = so_nbr EXCLUSIVE-LOCK NO-ERROR .
                                          IF AVAILABLE sod_det THEN
                                              v_i = sod_line .
                                          ELSE
                                              v_i = 0 .
                                      END.
                                      ELSE DO:
                                          v_i = 0 .
                                          v_addso = YES .
                                      END.

                                     FIND FIRST sod_det WHERE sod_nbr = v_sonbr AND sod_part = t1_part NO-LOCK NO-ERROR .
                                     IF NOT AVAILABLE sod_Det THEN  DO:
                                     

                                      IF v_addso THEN DO: /* ��������*/
                                           v_i = v_i + 1 .
                                           {xxmdpnewm1.i}

                                      END.
                                      ELSE DO: /* ��ϸ����*/
                                          v_i = v_i + 1 .
                                           {xxmdpnewl1.i}

                                      END.
                                    END.
                                    ELSE DO:
                                        v_i = sod_line .
                                        v_qty_ord = v_qty_ord + sod_qty_ord .
                                       
                                        {xxmdpnewl5.i}
                                        /* ss - 110704.1 -b
                                             CREATE tte .
                                      ASSIGN
                                          tte_type1 = "���"
                                          tte_type = "����"
                                          tte_cust = t1_cust
                                          tte_part = t1_part
                                          tte_desc = "����Ѿ����ڶ����в�������" + sod_nbr + "/" + STRING(sod_line) 
                                          .
                                          ss - 110704.1 -e */
                                        /* ss - 110704.1 -b */
                                        /* ss - 110704.1 -e */
                                    END.




                           

                           v_date = v_date + 1 .
                        END.
                        /* �ӿ�ʼ���ڵ��������ڼ��㶩�� */

                 
               

    END.
    /* ����ϸ -eee */



    
