  

   
  /* ���������ʱ��ԭ tt_qty_ord */
          
        
/*                 /* �ų��ż�ʱ��*/                                            */
/*                 FIND FIRST hd_mstr WHERE hd_date = v_date NO-LOCK NO-ERROR . */
/*                 IF NOT AVAILABLE hd_mstr  THEN DO:                           */
                   
                         
                         FIND LAST sod_det WHERE sod_nbr = tt_sodnbr AND sod_line = tt_sodline NO-LOCK NO-ERROR .
                         IF AVAILABLE sod_det  THEN DO:
                             ASSIGN
                                   v_i = sod_line .
                                   v_sonbr = sod_nbr .
                                   
                            
                                   v_qty_ord = tt_qty_ord .

                          
                        
                               
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
              
               
          
    /* �ӿ�ʼ���ڵ��������ڼ��㶩�� */
   
    
