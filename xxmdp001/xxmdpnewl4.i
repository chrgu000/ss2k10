 
/* ss - 110422.1 by: jack */  /* sp���ܶ�������ʱ sod__chr01 = "2" */
 /* ����-��ϸ��Ϊ������ʽ  */



 
  /* �ļ�����������:SOyyyymmdd99 */

/*   REPEAT :                                               */
/*       fn_i = "SO" + STRING(YEAR(TODAY))            +     */
/*              SUBSTRING(STRING(100 + MONTH(TODAY)),2,2) + */
/*              SUBSTRING(STRING(100 + DAY(TODAY)),2,2)   + */
/*              SUBSTRING(STRING(k),2,2).                   */
/*       IF SEARCH(fn_i + ".inp") = ? THEN DO:              */
/*           LEAVE.                                         */
/*       END.                                               */
/*       k = k + 1.                                         */
/*   END.                                                   */
  

fn_i = "xxso" +  STRING(YEAR(TODAY),"9999")
    + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + STRING(TIME,"99999") +  global_userid + STRING(RANDOM(1,9999),"9999") .
 


  /*
  MESSAGE "���ڵ�������,��ȴ�......" . 
    */

  
  v_flag = YES.

     
     /* ss - 090909.1 -b */ /* �۸񵥿��� */
      find first cm_mstr where cm_addr =  t1_cust no-lock no-error .
      if available cm_mstr then
      v_curr = cm_curr .
      else
      v_curr = "" .

     
    
      find first pt_mstr where pt_part = t1_part no-lock no-error .
      if available pt_mstr then
      v_um = pt_um .
      else 
      v_um = "" .
      
   
      find first pi_mstr where pi_list = t1_cust and pi_cs_type = "9"
       and pi_cs_code = t1_cust and pi_part_type = "6" and pi_part_code = t1_part
       and pi_curr = v_curr and pi_um = v_um and ((pi_start <= v_date ) and (pi_expire >= v_date or pi_expire = ?)) no-lock no-error .
       if not available pi_mstr then do:
        CREATE tte .
          ASSIGN 
              tte_type1 = "���" 
              tte_type = "����"
              tte_cust = t1_cust
              tte_part = t1_part
              tte_desc = "�ͻ����δ�ҵ�������Ϣ������(1.10.1.1.3)�˵�����ά����"
              .
         
        END.


   
     
          

       /* MESSAGE "aaa" + "---" + v_sonbr  VIEW-AS ALERT-BOX. */
       OUTPUT TO VALUE(fn_i + ".inp") .
     
                 FIND FIRST pt_mstr WHERE pt_part = t1_part NO-LOCK NO-ERROR.
                 IF AVAIL pt_mstr THEN v_tax = pt_taxable .
    
                
                   find first cm_mstr where cm_addr =  t1_cust no-lock no-error .
                      if available cm_mstr then
                      v_curr = cm_curr .
                      else
                      v_curr = "" .
        
                /*  MESSAGE "bbb" + "---" + v_sonbr VIEW-AS ALERT-BOX. */
     
                  PUT             """" + trim(v_sonbr) + """"      FORMAT "x(11)"    
                                  SKIP
                                  """" + TRIM(t1_cust) + """"    FORMAT "x(11)"
                                  SKIP
                                  " - " 
                                  SKIP
                                  " - "
                                  SKIP
                                  .    
                 /* ss - 110325.1 -b
                  DO i = 1 TO 11 :
                      PUT " - " .
                  END.
                  PUT """" + TRIM(t1_ptype) + "P" + """" FORMAT "x(11)"  .
                  DO i = 1 TO 9:
                      PUT " - " .
                  END.
                  PUT SKIP.
    
                
                  IF v_curr <> base_curr THEN
                      PUT   "-"  SPACE "-" SKIP .
                 ss - 110325.1 -e */

                  /* ������ϸ���� */
                  PUT SKIP(1) . /* ss - 110330.1 -b */
                                 
                  DO i = 1 TO 5 :
                      PUT " - ".
                  END.
                  PUT SKIP.
        
                  DO i = 1 TO 13 :
                      PUT " - ".
                  END.
                  PUT SKIP.
             
    
                  PUT  v_i  
                  SKIP
                  """" + TRIM(t1_part) + """"  FORMAT "x(23)"           /* part */
                  SKIP
                  " - "   /* �ص� */
                  SKIP
                  """" + TRIM(string(v_qty_ord)) + """"  FORMAT "x(14)"  /* ���� */
                  " - "                                /* ��λ */
                  SKIP
                  " - "                                /* �۸� */
                  SKIP
              
                  " - "  /* �ۿ� */
                  SKIP 
    	    
    	         .
    
                  DO i = 1 TO 14 :
                      PUT " - " .
                  END.
        
                  /* ��ֹ���� */
                  PUT  v_date 
                      /* """" + substring(entry(1,tt_due_date,"-"),3,2) + string(int(entry(2,tt_due_date,"-" )),"99") + string(int(entry(3,tt_due_date,"-")),"99") + """" FORMAT "x(11)" */ 
                      .
          
    
    	   
        	      DO i = 1 TO 6:
                      PUT " - " .
                  END.
         
          
        
                  put v_tax space .
                 
                       
            	   DO i =  1 to 4 :
            	   put "-" SPACE .
            	   end .
            	 
            	  PUT SKIP .
             
    	 
       
        	      IF v_tax = YES  THEN DO:
                      DO i = 1 TO 5 :
                          PUT " - " .
                      END.
                      PUT SKIP.
                  END.
    
    	
    
            
               /*   MESSAGE "last" + "---" + v_sonbr VIEW-AS ALERT-BOX. */
                 /* ss - 110330.1 -b 
                 PUT "." 
                     "."
                     .
                     ss - 110330.1 -e */
                  /* ss - 110330.1 -b */
                  PUT "." SKIP 
                      "." SKIP 
                      .
                  /* ss - 110330.1 -e */

                 DO i = 1 TO 8:
                     PUT " - " .
                 END.
                 PUT SKIP.
    
                 DO i = 1 TO 17:
                     PUT " - " .
                 END.
                 PUT SKIP.
                 PUT "." SKIP.

        OUTPUT CLOSE .
         
     

    
         INPUT FROM VALUE( fn_i + ".inp") .
         OUTPUT TO VALUE(fn_i + ".cim") .
                 
         batchrun = YES.
	
         {gprun.i ""xxsosomt.p""}
	 
	     batchrun = NO.
         INPUT CLOSE .
         OUTPUT CLOSE .

         /* �������ȼ���*/
         FIND FIRST sod_det WHERE sod_nbr = v_sonbr AND sod_line = v_i EXCLUSIVE-LOCK NO-ERROR .
          IF AVAILABLE sod_det  THEN DO: 
             
                 sod__chr01 = "2" .
             
         END.

         j = j + 1.
         CREATE tto.
         ASSIGN 
             tto_nbr = v_sonbr 
             .
    
        /* ss - 110422.1 -b */
         FIND FIRST sod_det WHERE sod_nbr = v_sonbr AND sod_line = v_i AND sod_part = t1_part NO-LOCK NO-ERROR .
         IF NOT AVAILABLE sod_det  THEN DO:
               CREATE ttem.
         ASSIGN
             ttem_type1 = "���"
             ttem_type = "����" 
             ttem_cust = t1_cust
             ttem_part = t1_cust_part
             ttem_desc = "ϵͳ����û��ת�������ֶ���7.1.1.2�в�������" + " " + "����" + v_sonbr + "���" + STRING(v_i) 
             .
         END.
         /* ss - 110422.1 -e */
 
    
   
      unix silent value("rm -f " + trim(fn_i)  + ".*").

      
     

     

    
