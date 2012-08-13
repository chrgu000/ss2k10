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
DEF VAR path1 AS CHAR.
/*DEF TEMP-TABLE price
    FIELD t_po_code AS CHAR  FORMAT "x(8)"
    FIELD t_po_type AS CHAR FORMAT "x(1)"
    FIELD t_po_paymentterm AS CHAR 
    FIELD t_po_effectivedate AS CHAR FORMAT "x(8)"
    FIELD t_po_inactivedate AS CHAR FORMAT "x(8)"
    FIELD t_po_createdate AS CHAR 
    FIELD t_po_status AS cHAR 
    FIELD t_po_opflag AS CHAR 
    FIELD t_sup_code AS CHAR 
    FIELD t_sup_cname AS CHAR .*/
    
DEF TEMP-TABLE price_part
    FIELD t_part_po_code AS CHAR 
    FIELD t_part_code AS CHAR FORMAT "x(18)" 
    FIELD t_part_name AS CHAR
    FIELD T_PART_PROD_LINE AS CHAR
    FIELD T_PART_UM AS CHAR
    FIELD T_PART_CURR AS CHAR
    FIELD t_part_nontaxprice AS CHAR 
    FIELD t_part_taxprice AS CHAR 
    FIELD t_part_qtybetween AS CHAR
    FIELD t_part_qtybetween1 AS CHAR
    FIELD T_PART_AMTTYP AS CHAR
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

FOR EACH price_part:
    DELETE price_part.
END.
UPDATE  path WITH FRAME a.
IF path = '' THEN DO: MESSAGE "The path is empty!" VIEW-AS ALERT-BOX.
    UNDO,RETRY.
END.
FIND CODE_mstr WHERE CODE_fldname = 'srmpath' NO-LOCK NO-ERROR.
path1 = CODE_cmmt.
INPUT FROM VALUE(PATH).
 REPEAT:
     CREATE PRICE_part.
     IMPORT DELIMITER ";" T_PART_PO_CODE T_PART_PROD_LINE T_PART_CODE T_PART_UM
         T_PART_CURR T_PARt_AMTTYP T_PArT_nontaxPRICE T_PART_QTYBETWEEN T_PART_PO_EFFECTIVEDATE
         T_PART_PO_INACTIVEDATE.
          
     DEF VAR o AS INT.
                DEF VAR isfront AS LOGICAL.
        DEF VAR str1 AS CHAR.
        DEF VAR str2 AS CHAR.
       
               

                isfront = YES.
                str1 = ''.
                str2 = ''.
                    DO o = 1 TO LENGTH(t_part_qtybetween):
           IF SUBSTR(t_part_qtybetween,o,1) = '-' THEN isfront = NO.
      IF SUBSTR(t_part_qtybetween,o,1) <> '-' AND isfront THEN 
      str1 = str1 + SUBSTR(t_part_qtybetween,o,1).
      IF SUBSTR(t_part_qtybetween,o,1) <> '-' AND NOT isfront THEN 
      str2 = str2 + SUBSTR(t_part_qtybetween,o,1).

          END.
                    
                    t_part_qtybetween =  str1.
                       t_part_qtybetween1 =  str2.
         
         END.



iscim = NO.


   

FOR EACH price_part WHERE price_part.t_part_po_code = '':
DELETE price_part.
END.



 OUTPUT TO value(path1 + '\log\price_error_log.txt'). 



 
    
   
        pre = ''.
      FOR EACH price_part  NO-LOCK BY price_part.t_part_po_code BY price_part.t_part_code BY price_part.t_part_prod_line BY price_part.t_part_um BY price_part.t_part_amttyp BY price_part.t_part_po_effectivedate BY price_part.t_part_po_inactivedate:
        
             pass = YES.
         RUN fieldcheck. 
         /* MESSAGE price_part.t_part_po_inactivedate VIEW-AS ALERT-BOX.*/
          
        IF pass THEN DO:
        
              IF  pre <> price_part.t_part_po_code + price_part.t_part_code + price_part.t_part_prod_line + price_part.t_part_um + price_part.t_part_amttyp + price_part.t_part_po_effectivedate + price_part.t_part_po_inactivedate
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
     

   FIND FIRST pc_mstr WHERE pc_list = price_part.t_part_po_code AND pc_part = price_part.t_part_code AND pc_prod_line = price_part.t_part_prod_line AND pc_um = price_part.t_part_um AND pc_amt_type = price_part.t_part_amttyp AND pc_start = date(price_part.t_part_po_effectivedate) AND pc_expire = date(price_part.t_part_po_inactivedate) NO-LOCK NO-ERROR.
   IF AVAILABLE pc_mstr THEN  DO:
       
       DO m = 1 TO 15:
         IF pc_min_qty[m] <> 0 THEN mstr[m] = STRING(pc_min_qty[m]) + ' ' + STRING(pc_amt[m]) + ' '.
           
           END.
       
       
       
       
       
       END.
            
            END. /*pre*/
        
        pre = price_part.t_part_code + price_part.t_part_prod_line + price_part.t_part_um + price_part.t_part_po_effectivedate + price_part.t_part_po_inactivedate.

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
          
          /*sort*/
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
                      t_er_pricecode = price_part.t_part_po_code + ' ' + price_part.t_part_code.
                       t_er_xmlfield = ''.
                           t_er_qadfield = ''.
                       t_er_mess = 'The price is full!'.



            END.  
        mstr[15] = RIGHT-TRIM(mstr[15]).
        
            END. /*pass*/
 
 IF pass THEN DO:
   iscim = YES.
     
      OUTPUT TO 'cim.txt'.
       PUT "@@batchload pppcmt.p".
       PUT SKIP.
       PUT '"'.
       PUT UNFORMAT price_part.t_part_po_code.
       PUT '"'.
       PUT SPACE(1).
       PUT '"'.
       PUT UNFORMAT price_part.t_part_curr.
       PUT '"'.
       PUT SPACE(1).
       PUT '-'.
           PUT SPACE(1).
       
       
       
       PUT '"'.
       PUT UNFORMAT price_part.t_part_code.
       PUT '"'.
       PUT SPACE(1).
       PUT '"'.
       PUT UNFORMAT price_part.t_part_um.
       PUT '"'.
       PUT SPACE(1).
    IF price_part.t_part_po_effectivedate <> '' THEN
       PUT  UNFORMAT string(date(INTEGER(SUBSTR(price_part.t_part_po_effectivedate,6,2)),INTEGER(SUBSTR(price_part.t_part_po_effectivedate,9,2)),INTEGER(SUBSTR(price_part.t_part_po_effectivedate,1,4)))) .
       ELSE
           PUT '-'.
    PUT SKIP.
       IF price_part.t_part_po_inactivedate <> '' THEN
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

OUTPUT CLOSE.
OUTPUT TO value(path1 + '\log\price_check_log.txt').
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
    
           /* MESSAGE  price_part.t_part_po_code VIEW-AS ALERT-BOX.*/
           IF price_part.t_part_po_code = '' THEN do:
               pass = NO.
              CREATE t_error.
         t_er_pricecode = price_part.t_part_po_code + ' ' + price_part.t_part_code.
          t_er_xmlfield = 'po_code'.
              t_er_qadfield = 'pc_list'.
          t_er_mess = 'Please check po_code!'.
  
           END.
           FIND FIRST cu_mstr WHERE cu_curr = price_part.t_part_curr NO-LOCK NO-ERROR.
           IF NOT AVAILABLE cu_mstr THEN DO:
                pass = NO.
              CREATE t_error.
         t_er_pricecode = price_part.t_part_po_code + ' ' + price_part.t_part_curr.
          t_er_xmlfield = 'part_curr'.
              t_er_qadfield = 'pc_curr'.
          t_er_mess = 'Please check part_curr!'.
           END.
           FIND pt_mstr WHERE pt_part = price_part.t_part_code NO-LOCK NO-ERROR.  
           IF NOT AVAILABLE pt_mstr THEN do:
                     pass = NO.
                    CREATE t_error.
               t_er_pricecode = price_part.t_part_po_code + ' ' + price_part.t_part_code.
                t_er_xmlfield = 'part_code'.
                    t_er_qadfield = 'pc_part'.
                t_er_mess = 'Please check part_code!'.

                 END.
          
          
                /* 
                 FIND FIRST pt_mstr WHERE pt_part = price_part.t_part_code AND pt_prod_line = price_part.t_part_prod_line NO-LOCK NO-ERROR.
                 IF NOT AVAILABLE pt_mstr THEN DO:

                     pass = NO.
                    CREATE t_error.
               t_er_pricecode = price_part.t_part_po_code + ' ' + price_part.t_part_prod_line.
                t_er_xmlfield = 'part_prod_line'.
                    t_er_qadfield = 'pt_prod_line'.
                t_er_mess = 'Please check part_prod_line!'.

                 END.*/
           IF price_part.t_part_prod_line <> '' THEN DO:

               pass = NO.
                       CREATE t_error.
                  t_er_pricecode = price_part.t_part_po_code + ' ' + price_part.t_part_prod_line.
                   t_er_xmlfield = 'part_prod_line'.
                       t_er_qadfield = 'pt_prod_line'.
                   t_er_mess = 'The prod_line must be empty!'.


           END.
                 
                 FIND FIRST um_mstr WHERE um_part = price_part.t_part_code AND um_alt_um = price_part.t_part_um NO-LOCK NO-ERROR.
                 IF NOT AVAILABLE um_mstr THEN DO:
               
                 FIND FIRST CODE_mstr WHERE CODE_fldname = 'pc_um' NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN DO:
       
           FIND FIRST CODE_mstr WHERE CODE_fldname = 'pc_um' AND CODE_value = t_part_um NO-LOCK NO-ERROR.
              IF NOT AVAILABLE code_mstr THEN DO:
                
                    pass = NO.
                    CREATE t_error.
               t_er_pricecode = price_part.t_part_po_code + ' ' + price_part.t_part_um.
                t_er_xmlfield = 'part_um'.
                    t_er_qadfield = 'pc_um'.
                t_er_mess = 'Please check UM!'.
                  
                  END.
           
           
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
               t_er_pricecode = price_part.t_part_po_code + ' ' + price_part.t_part_code.
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

          t_er_pricecode = price_part.t_part_po_code + ' ' + price_part.t_part_code.
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

          t_er_pricecode = price_part.t_part_po_code + ' ' + price_part.t_part_code.
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

          t_er_pricecode = price_part.t_part_po_code + ' ' + price_part.t_part_code.
                t_er_xmlfield = mxmlfield.
                    t_er_qadfield = mqadfield.
                t_er_mess = 'Please check '+ mxmlfield + '!'.
                RETURN.
        
        END.
        
         END.
        
        END.
    
    
    
    
    
    
    
    
    
    
    
    
   
      
  END.
