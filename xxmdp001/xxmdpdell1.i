/* ss - 110330.1 -b */  /* 周计划删除-明细档*/



 
  /* 文件的命名规则:SOyyyymmdd99 */

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
  

fn_i =  "xxso" +  STRING(YEAR(TODAY),"9999")
    + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + STRING(TIME,"99999") + global_userid + STRING(RANDOM(1,9999),"9999") .
 
 
 

  /*
  MESSAGE "正在导入数据,请等待......" . 
    */

  
  v_flag = YES.

     
     /* ss - 090909.1 -b */ /* 价格单控制 */
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

                  /* 主档明细跳过 */
                  PUT SKIP(1) .  /* ss - 110330.1 -b */
                                 
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
/*                   """" + TRIM(t1_part) + """"  FORMAT "x(23)"           /* part */ */
/*                   SKIP                                                             */
                  " - " "x"  /* 地点 删除 */
                  SKIP
                 
                .
    
                  PUT SKIP(1) . /* ss - 110330.1 -b */
            	 
                 
    
            
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

         /* ss - 110422.1 -b */
         FIND FIRST sod_det WHERE sod_nbr = v_sonbr AND sod_line = v_i AND sod_part = t1_part NO-LOCK NO-ERROR .
         IF AVAILABLE sod_det  THEN DO:
               CREATE ttem.
         ASSIGN
             ttem_type1 = "零件"
             ttem_type = "错误" 
             ttem_cust = t1_cust
             ttem_part = t1_cust_part
             ttem_desc = "系统错误没有删除，请手动在7.1.1.2中测试问题" + " " + "订单" + v_sonbr + "项次" + STRING(v_i) 
             .
         END.
         /* ss - 110422.1 -e */

/*                                */
/*          j = j + 1.            */
/*          CREATE tto.           */
/*          ASSIGN                */
/*              tto_nbr = v_sonbr */
/*              .                 */
    

 
    
   
      unix silent value("rm -f " + trim(fn_i)  + ".*").

      
     

     

    
