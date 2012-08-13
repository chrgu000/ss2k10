{mfdtitle.i}
DEF VAR hdoc AS HANDLE.
DEF VAR hroot AS HANDLE.
DEF VAR pass AS LOGICAL.
DEF VAR iscim AS LOGICAL.
DEF VAR hcurr AS HANDLE.
DEF VAR htemp AS HANDLE.
DEF VAR mqty LIKE pod_qty_ord.
DEF VAR mamt LIKE pod_pur_cost.
DEF VAR meffdt as CHAR FORMAT "x(8)".
DEF VAR m_po_code AS CHAR.
DEF VAR mcount AS INT.
DEF VAR mstr AS CHAR FORMAT "x(16)" EXTENT 15 INITIAL "0 0 ".
DEF VAR pre AS CHAR  .
DEF VAR iserror AS LOGICAL.
DEF VAR m_str1 AS CHAR.
DEF VAR m_str2 AS CHAR.
DEF VAR emptystr AS CHAR FORMAT "x(50)".
DEF VAR mutiple AS INT.
DEF VAR mutiple1 AS INT.
DEF VAR msub AS INT.
DEF VAR mdouble AS LOGICAL.
DEF VAR ismatched AS LOGICAL.
DEF VAR n AS INT.
DEF VAR temp AS CHAR.
DEF VAR s AS INT.
DEF VAR tempstr AS CHAR.
DEF TEMP-TABLE price
    FIELD t_po_code AS CHAR  FORMAT "x(8)"
    FIELD t_po_type AS CHAR FORMAT "x(1)"
    FIELD t_po_paymentterm AS CHAR 
    FIELD t_po_effectivedate AS CHAR FORMAT "x(8)"
    FIELD t_po_inactivedate AS CHAR FORMAT "x(8)"
    FIELD t_po_createdate AS CHAR 
    FIELD t_po_status AS cHAR 
    FIELD t_po_opflag AS CHAR 
    FIELD t_sup_code AS CHAR 
    FIELD t_sup_cname AS CHAR .
    
DEF TEMP-TABLE price_part
    FIELD t_part_po_code AS CHAR 
    FIELD t_part_code AS CHAR FORMAT "x(18)" 
    FIELD t_part_name AS CHAR
    FIELD t_part_nontaxprice AS CHAR 
    FIELD t_part_taxprice AS CHAR 
    FIELD t_part_qtybetween AS CHAR
    FIELD t_part_qtybetween1 AS CHAR
    FIELD t_part_po_effectivedate AS CHAR FORMAT "x(8)"
    FIELD t_part_po_inactivedate AS CHAR FORMAT "x(8)".
DEF VAR path AS CHAR FORMAT "x(40)" LABEL "Input".
DEF VAR isgood AS LOGICAL .
DEF VAR qty AS CHAR.
DEF VAR qty1 AS CHAR.
DEF VAR price AS CHAR.
DEF VAR m AS INT.
DEF VAR ismodimatch AS LOGICAL.
DEF NEW SHARED VAR lang AS CHAR.
DEF VAR tempstr1 AS CHAR.
DEF VAR tempstr2 AS CHAR.
DEF TEMP-TABLE t_error
    FIELD t_er_pricecode AS CHAR FORMAT "x(18)"
    FIELD t_er_xmlfield AS CHAR FORMAT "x(10)"
    FIELD t_er_QADfield AS CHAR FORMAT "x(10)"
    FIELD t_er_mess AS CHAR FORMAT "x(50)".
lang = 'en'.
DEF FRAME a
    
    SKIP(0.5)
    path COLON 15
    WITH WIDTH 80 SIDE-LABELS THREE-D.
REPEAT:
FOR EACH price:
    DELETE price.
END.
FOR EACH price_part:
    DELETE price_part.
END.
UPDATE  path WITH FRAME a.
IF path = '' THEN DO: MESSAGE "The path is empty!" VIEW-AS ALERT-BOX.
    UNDO,RETRY.
END.




CREATE X-DOCUMENT hdoc.
 create x-noderef  hRoot.

isgood = hdoc:LOAD('FILE', path , FALSE) no-error.
IF NOT isgood THEN DO:
MESSAGE "The XML file is error!" VIEW-AS ALERT-BOX.
    UNDO,RETRY.
    END.
hdoc:GET-DOCUMENT-ELEMENT(hroot).

RUN cycletree(hroot,NO,NO,'').
iscim = NO.


   

 



 OUTPUT TO 'c:\price_error_log.txt' . 


FOR EACH price:
  
    
    
   
        pre = ''.
      FOR EACH price_part WHERE price_part.t_part_po_code = price.t_po_code NO-LOCK BY price_part.t_part_code BY price_part.t_part_po_effectivedate BY price_part.t_part_po_inactivedate:
          pass = YES.
          RUN fieldcheck. 
        IF pass THEN DO:
        
              IF  pre <> price_part.t_part_code + price_part.t_part_po_effectivedate + price_part.t_part_po_inactivedate
 THEN DO:
         /* msub = 0.
          mcount = 1.
          mstr = ''.
          m_str = ''.
          emptystr = '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - '.
         /* mcount = 0. */ 
         /* mstr = '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -'.*/
         /* FOR EACH pricepart WHERE pricepart.t_part_po_code = price_part.t_part_po_code AND pricepart.t_part_code = price_part.t_part_code AND pricepart.t_part_po_effectivedate 
                = price_part.t_part_po_effectivedate AND pricepart.t_part_po_inactivedate = price_part.t_part_po_inactivedate NO-LOCK:
   mcount = mcount + 1.
            END.*/*/
 DO m = 1 TO 15:
          mstr[m] = "0 0 ".
           
           END.
     

   FIND FIRST pc_mstr WHERE pc_list = price_part.t_part_po_code AND pc_part = price_part.t_part_code AND pc_start = date(price_part.t_part_po_effectivedate) AND pc_expire = date(price_part.t_part_po_inactivedate) NO-LOCK NO-ERROR.
   IF AVAILABLE pc_mstr THEN  DO:
       
       DO m = 1 TO 15:
         IF pc_min_qty[m] <> 0 THEN mstr[m] = STRING(pc_min_qty[m]) + ' ' + STRING(pc_amt[m]) + ' '.
           
           END.
       
       
       
       
       
       END.
            
            END.
        
       

   IF  price_part.t_part_qtybetween <> '' AND price_part.t_part_qtybetween1 <> '' THEN do:
         price_part.t_part_qtybetween1 = string(INTEGER(price_part.t_part_qtybetween1) + 1).
         price = '0'.

     m_str1 = price_part.t_part_qtybetween + ' ' + price_part.t_part_nontaxprice + ' '.
    m_str2 =  price_part.t_part_qtybetween1 +  ' ' + price + ' '.

             END.

 IF  price_part.t_part_qtybetween = ''  OR price_part.t_part_qtybetween1 = '' THEN DO: 
    IF price_part.t_part_qtybetween <> '' THEN  m_str1 = price_part.t_part_qtybetween + ' ' + price_part.t_part_nontaxprice + ' '.

    IF price_part.t_part_qtybetween1 <> '' THEN  m_str1 = price_part.t_part_qtybetween1 + ' ' + price_part.t_part_nontaxprice + ' '.




 END.

 ismatched = NO.
 ismodimatch = NO.
 IF m_str1 <> '' AND m_str2 <> '' THEN mdouble = YES.
     ELSE mdouble = NO.
          tempstr1 = ''. 
          DO s = 1 TO LENGTH(m_str1):
              
         
              IF SUBSTR(m_str1,s,1) = ' ' THEN LEAVE.
              tempstr1 = tempstr1 + SUBSTR(m_str1,s,1).
          END.
           tempstr2 = ''.
              DO s = 1 TO LENGTH(m_str2):
              
         
              IF SUBSTR(m_str2,s,1) = ' ' THEN LEAVE.
              tempstr2 = tempstr2 + SUBSTR(m_str2,s,1).
          END.
          DO m = 1 TO 15:
              tempstr = ''.
              DO s = 1 TO LENGTH(mstr[m]):
              
         
              IF SUBSTR(mstr[m],s,1) = ' ' THEN LEAVE.
              tempstr = tempstr + SUBSTR(mstr[m],s,1).
          END.
          
             
              IF tempstr = tempstr1 THEN do:
              mstr[m] = m_str1.
              m_str1 = ''.
              ismodimatch = YES.
              END.
          IF tempstr = tempstr2 THEN do:
              mstr[m] = m_str2.
              m_str2 = ''.
              ismodimatch = YES.
          END.
              
              
              
              END.
          DO m = 1 TO 15:
      IF mdouble  THEN DO:
     
      IF mstr[m] = '0 0 ' AND m_str1 <> ''  THEN  do:
          mstr[m] = m_str1.
          m_str1 = ''.
      END.
          
      IF mstr[m] = '0 0 ' AND m_str2 <> ''  THEN  do:
          mstr[m] = m_str2.
          m_str2 = ''.
      END.
      IF m_str1 = '' AND m_str2 = '' THEN ismatched = YES.
      END.
      ELSE DO:
       IF mstr[m] = '0 0 ' AND m_str1 <> ''  THEN  do:
          mstr[m] = m_str1.
          m_str1 = ''.
          ismatched = YES.
          END.
     
          
          
          
          
          
          END.
          
          END.

          DO m= 1 TO 15:
         IF mstr[m] = '0 0 ' THEN mstr[m] = '999999 999999 '.


          END.
          
          
          REPEAT m = 1 TO 15:
              tempstr1 = ''.
              DO s = 1 TO LENGTH(mstr[m]):
              
         
              IF SUBSTR(mstr[m],s,1) = ' ' THEN LEAVE.
              tempstr1 = tempstr1 + SUBSTR(mstr[m],s,1).
          END.
           
          REPEAT n = m + 1 TO 15:
             
               tempstr2 = ''.
                   DO s = 1 TO LENGTH(mstr[n]):
              IF SUBSTR(mstr[n],s,1) = ' ' THEN LEAVE.
              tempstr2 = tempstr2 + SUBSTR(mstr[n],s,1).
          END.
       
              IF integer(tempstr1) > integer(tempstr2) THEN DO:
      
             temp = mstr[m].
            mstr[m] = mstr[n].
            mstr[n] = temp.
            tempstr1 = ''.
              DO s = 1 TO LENGTH(mstr[m]):
              
         
              IF SUBSTR(mstr[m],s,1) = ' ' THEN LEAVE.
              tempstr1 = tempstr1 + SUBSTR(mstr[m],s,1).
          END.
           tempstr2 = ''.
                   DO s = 1 TO LENGTH(mstr[n]):
              IF SUBSTR(mstr[n],s,1) = ' ' THEN LEAVE.
              tempstr2 = tempstr2 + SUBSTR(mstr[n],s,1).
          END.

        END.
              END.
          
      END.
  DO m = 1 TO 15:
      IF mstr[m] = '999999 999999 ' THEN mstr[m] = '0 0 '.
  END.
  /*REPEAT m = 1 TO 15:
      DISP mstr[m].
  END.*/
            IF NOT ismodimatch AND NOT ismatched THEN DO:
             pass = NO.

              CREATE t_error.
                      t_er_pricecode = price.t_po_code + ' ' + price_part.t_part_code.
                       t_er_xmlfield = ''.
                           t_er_qadfield = ''.
                       t_er_mess = 'The price is full!'.



            END.  
        mstr[15] = RIGHT-TRIM(mstr[15]).
        
            END.
 
 IF pass THEN DO:
   iscim = YES.
      
      OUTPUT TO 'cim.txt'.
       PUT "@@batchload pppcmt.p".
       PUT SKIP.
       PUT '"'.
       PUT UNFORMAT price_part.t_part_po_code.
       PUT '"'.
       PUT SPACE(1).
       PUT '-'.
       PUT SPACE(1).
       PUT '-'.
           PUT SPACE(1).
       
       
       
       PUT '"'.
       PUT UNFORMAT price_part.t_part_code.
       PUT '"'.
       PUT SPACE(1).
       PUT '-'.
       PUT SPACE(1).
    IF price_part.t_part_po_effectivedate <> '' THEN
       PUT  UNFORMAT string(date(INTEGER(SUBSTR(price_part.t_part_po_effectivedate,6,2)),INTEGER(SUBSTR(price_part.t_part_po_effectivedate,9,2)),INTEGER(SUBSTR(price_part.t_part_po_effectivedate,1,4)))) .
       ELSE
           PUT '-'.
    PUT SKIP.
       IF price_part.t_part_po_inactivedate <>'' THEN
       PUT  UNFORMAT string(date(INTEGER(SUBSTR(price_part.t_part_po_inactivedate,6,2)),INTEGER(SUBSTR(price_part.t_part_po_inactivedate,9,2)),INTEGER(SUBSTR(price_part.t_part_po_inactivedate,1,4)))) .
       ELSE
           PUT '-'.
       PUT SPACE(1).

 PUT '"'.
       PUT UNFORMAT 'p'.
       PUT '"'.
      PUT SKIP.
     
    
       DO m= 1 TO 15:
   PUT UNFORMAT mstr[m].
       END.
   
       
       PUT SKIP.
      
        PUT '@@end'.
        OUTPUT CLOSE.

       
   mcount = mcount + 1.
       
       pre = price_part.t_part_code + price_part.t_part_po_effectivedate + price_part.t_part_po_inactivedate.
      RUN bdrunmfg.p(OUTPUT iserror).
      
       FIND FIRST pc_mstr  WHERE pc_list = price_part.t_part_po_code NO-LOCK NO-ERROR.
  
        IF NOT AVAILABLE pc_mstr THEN DO:
            
           PUT SKIP.
         PUT price_part.t_part_po_code.
         PUT SPACE(1).
         PUT price_part.t_part_code.
         PUT SPACE(1).
          PUT 'load failed!'.
            
            
            END.
            ELSE DO:
           
            IF iserror THEN DO:
                 PUT SKIP.
         PUT price_part.t_part_po_code.
         PUT SPACE(1).
         PUT price_part.t_part_code.
         PUT SPACE(1).
                PUT 'ERROR!'.
            
            
            
            
            
            
            END.
       END.
END.
END.
END.
OUTPUT CLOSE.
OUTPUT TO 'c:\price_check_log.txt'.
    FOR EACH t_error:
        PUT SKIP.
        PUT t_er_pricecode.
        PUT SPACE(1).
        PUT t_er_xmlfield.
        PUT SPACE(1).
        PUT t_er_qadfield.
        PUT SPACE(1).
        PUT t_er_mess.
        DELETE t_error.
    END.
    
    OUTPUT CLOSE.
    MESSAGE 'Load complete!' VIEW-AS ALERT-BOX.
END.

PROCEDURE fieldcheck:
    
             
           IF price.t_po_code = '' THEN do:
               pass = NO.
              CREATE t_error.
         t_er_pricecode = price.t_po_code + ' ' + price_part.t_part_code.
          t_er_xmlfield = 'po_code'.
              t_er_qadfield = 'pc_list'.
          t_er_mess = 'Please check po_code!'.
  
           END.
            FIND pt_mstr WHERE pt_part = price_part.t_part_code NO-LOCK NO-ERROR.  
           IF NOT AVAILABLE pt_mstr THEN do:
                     pass = NO.
                    CREATE t_error.
               t_er_pricecode = price.t_po_code + ' ' + price_part.t_part_code.
                t_er_xmlfield = 'part_code'.
                    t_er_qadfield = 'pc_part'.
                t_er_mess = 'Please check part_code!'.

                 END.
     FIND FIRST CODE_mstr WHERE CODE_fldname = 'pc_um' NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
       
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'pc_um' AND CODE_value = '' NO-LOCK NO-ERROR.
              IF NOT AVAILABLE code_mstr THEN DO:
              
                    pass = NO.
                    CREATE t_error.
               t_er_pricecode = price.t_po_code + ' ' + price_part.t_part_code.
                t_er_xmlfield = ''.
                    t_er_qadfield = 'pc_um'.
                t_er_mess = 'Please check UM!'.
                  
                  END.
           
           
           END.
           
   /* IF price.t_po_type <> 'p' THEN DO:
         pass = NO.
                    CREATE t_error.
               t_er_pricecode = price.t_po_code + ' ' + price_part.t_part_code.
                t_er_xmlfield = 'po_type'.
                    t_er_qadfield = 'pc_amt_type'.
                t_er_mess = 'Please check po_type!'.
        
        END.*/
        IF price_part.t_part_qtybetween = '' AND price_part.t_part_qtybetween1 = '' THEN DO:
        
             CREATE t_error.
               t_er_pricecode = price.t_po_code + ' ' + price_part.t_part_code.
                t_er_xmlfield = 'part_qtybetween'.
                    t_er_qadfield = 'pc_amt_type'.
                t_er_mess = 'Please check part_qtybetween!'.
            
            
            
            END.
    
   RUN strcheck('part_po_effectivedate','pc_start',price_part.t_part_po_effectivedate,YES).
          
           RUN strcheck('part_po_inactivedate','pc_expire',price_part.t_part_po_inactivedate,YES). 
            RUN strcheck('part_nontaxprice','pc_amt',price_part.t_part_nontaxprice,NO).
           RUN strcheck('part_qtybetween','pc_min_qty',price_part.t_part_qtybetween,NO).
          RUN strcheck('part_qtybetween','pc_min_qty',price_part.t_part_qtybetween1,NO).
          END.

  
          PROCEDURE strcheck:
    DEF INPUT PARAMETER mxmlfield AS CHAR.
    DEF INPUT PARAMETER mqadfield AS CHAR.
    DEF INPUT PARAMETER estr AS CHAR.
    DEF INPUT PARAMETER isdate AS LOGICAL.
    DEF VAR i AS INT.
    IF isdate AND LENGTH(estr) <> 10 AND LENGTH(estr) <> 0 THEN DO:
        pass = NO.
        CREATE t_error.

          t_er_pricecode = price.t_po_code + ' ' + price_part.t_part_code.
                t_er_xmlfield = mxmlfield.
                    t_er_qadfield = mqadfield.
                t_er_mess = 'Please check '+ mxmlfield + '!'.
                RETURN.
        
        
        END.
    DO i = 1 TO LENGTH(estr):
    IF isdate THEN DO:
      IF SUBSTR(estr,i,1) <> '-' AND  SUBSTR(estr,i,1) <> '/' THEN
        IF SUBSTR(estr,i,1) < '0' OR SUBSTR(estr,i,1) > '9' THEN  DO:
    pass = NO.
      CREATE t_error.

          t_er_pricecode = price.t_po_code + ' ' + price_part.t_part_code.
                t_er_xmlfield = mxmlfield.
                    t_er_qadfield = mqadfield.
                t_er_mess = 'Please check '+ mxmlfield + '!'.
                RETURN.
        
        END.
        
        END.
     ELSE DO:  
          IF SUBSTR(estr,i,1) < '0' OR SUBSTR(estr,i,1) > '9' THEN  DO:
    pass = NO.
      CREATE t_error.

          t_er_pricecode = price.t_po_code + ' ' + price_part.t_part_code.
                t_er_xmlfield = mxmlfield.
                    t_er_qadfield = mqadfield.
                t_er_mess = 'Please check '+ mxmlfield + '!'.
                RETURN.
        
        END.
        
         END.
        
        END.
    
    
    
    
    
    
    
    
    
    
    
    
   
       END. 
  PROCEDURE cycletree:
 DEF INPUT PARAMETER ihnode AS HANDLE .
 DEF INPUT PARAMETER isread AS LOGICAL .
 DEF INPUT PARAMETER iscreate AS LOGICAL .
DEF INPUT PARAMETER parent_node AS CHAR.

DEF VAR ihchild AS HANDLE.
 
DEF  VAR i AS INT.
   CREATE X-NODEREF ihchild. 
 IF ihnode:NUM-CHILDREN = 0  THEN DO:
     IF NOT isread THEN RETURN.
     IF iscreate THEN DO: 
        IF  PARENT_node = 'po_release_header' THEN CREATE price.
     IF parent_node = 'po_part_detail' AND m_po_code <> '' THEN do:
         CREATE price_part.
         t_part_po_code = m_po_code.
         
     END.
     END.
   IF PARENT_node = 'po_release_header' THEN DO: 
        CASE ihnode:NAME:
   
   
       when "po_code" THEN DO:
         
          t_po_code =  ihnode:GET-ATTRIBUTE('value').
         m_po_code = t_po_code.
          END.
        when "po_type" THEN DO:
         t_po_type =  ihnode:GET-ATTRIBUTE('value').
           END.
       
        when "po_paymentterm" THEN DO:
         t_po_paymentterm =  ihnode:GET-ATTRIBUTE('value').
           END.
       
        when "po_effectivedate" THEN DO:
         t_po_effectivedate =  ihnode:GET-ATTRIBUTE('value').
           END.
        when "po_inactivedate" THEN DO:
         t_po_inactivedate =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "po_createdate" THEN DO:
         t_po_createdate =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "po_status" THEN DO:
         t_po_status =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "po_opflag" THEN DO:
         t_po_opflag =  ihnode:GET-ATTRIBUTE('value').
           END.
        when "sup_code" THEN DO:
         t_sup_code =  ihnode:GET-ATTRIBUTE('value').
           END.
            when "sup_cname" THEN DO:
         t_sup_cname =  ihnode:GET-ATTRIBUTE('value').
           END.
   
 

       END CASE.
   END.
   IF PARENT_node = 'po_part_detail' THEN DO:
   
       
       CASE ihnode:NAME:
       
           WHEN "part_code" THEN DO:
            t_part_code =  ihnode:GET-ATTRIBUTE('value').
            
               END.
                WHEN "part_name" THEN DO:
            t_part_name =  ihnode:GET-ATTRIBUTE('value').
            
               END.
                WHEN "part_nontaxprice" THEN DO:
            t_part_nontaxprice =  ihnode:GET-ATTRIBUTE('value').
            
               END.
                WHEN "part_taxprice" THEN DO:
            t_part_taxprice =  ihnode:GET-ATTRIBUTE('value').
            
               END.
                WHEN "part_qtybetween" THEN DO:
                    DEF VAR j AS INT.
                    DEF VAR isfront AS LOGICAL.
            DEF VAR str1 AS CHAR.
            DEF VAR str2 AS CHAR.
            DEF VAR m_qtybetween AS CHAR FORMAT "x(10)".
                    m_qtybetween = ihnode:GET-ATTRIBUTE('value').
                    
                    isfront = YES.
                    str1 = ''.
                    str2 = ''.
                        DO j = 1 TO LENGTH(m_qtybetween):
               IF SUBSTR(m_qtybetween,j,1) = '-' THEN isfront = NO.
          IF SUBSTR(m_qtybetween,j,1) <> '-' AND isfront THEN 
          str1 = str1 + SUBSTR(m_qtybetween,j,1).
          IF SUBSTR(m_qtybetween,j,1) <> '-' AND NOT isfront THEN 
          str2 = str2 + SUBSTR(m_qtybetween,j,1).
          
          
          END.
                    
                    t_part_qtybetween =  str1.
                       t_part_qtybetween1 =  str2.
            
               END.
                WHEN "part_po_effectivedate" THEN DO:
            t_part_po_effectivedate =  ihnode:GET-ATTRIBUTE('value').
            
               END.
                WHEN "part_po_inactivedate" THEN DO:
            t_part_po_inactivedate =  ihnode:GET-ATTRIBUTE('value').
            
               END.
           
           
           
           
           
           
           
           
           
           
           END CASE.
       
       
       
       
       
       
       
       
       END.
   RETURN.
    END.
   
    REPEAT i = 1 TO ihnode:NUM-CHILDREN BY 1:
  IF ihnode:NAME = 'po_release_header' OR ihnode:NAME = 'po_part_detail' THEN DO:
  isread = YES.
  
   IF  i = 1 THEN  iscreate = YES.
       ELSE iscreate = NO.
          IF ihnode:NAME = 'po_release_header' THEN PARENT_node = 'po_release_header'.
          IF ihnode:NAME = 'po_part_detail' THEN PARENT_node = 'po_part_detail'.
  
          
          END.

       ihnode:GET-CHILD(ihchild,i).
        
       RUN cycletree(ihchild,isread,iscreate,PARENT_node).
    
    
    
 END.
 RETURN.
 END.
