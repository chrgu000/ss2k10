DEF VAR mfile AS CHAR FORMAT "x(40)" LABEL "文件".
DEF VAR mstr AS CHAR FORMAT "x(70)".     
DEF TEMP-TABLE minvoice FIELD mso LIKE sod_nbr
         FIELD mline LIKE sod_line
         FIELD mpart LIKE sod_part
         FIELD mserial LIKE tr_serial
         FIELD mqty AS INT.
      FORM 
    SKIP(0.5)
    mfile COLON 20
    WITH FRAME a WIDTH 80 THREE-D SIDE-LABEL.
      REPEAT:

   DO TRANSACTION ON ERROR UNDO,RETRY:
    
    UPDATE mfile WITH FRAME a.
    IF mfile = "" THEN do:
        MESSAGE "文件不能为空!" VIEW-AS ALERT-BOX BUTTON OK. 
        next-prompt mfile WITH FRAME a.
        UNDO,RETRY.
        
      END. 
    
      
     END.
   INPUT FROM VALUE(mfile).
 
   REPEAT:
 
   
  
  
 
   
    IMPORT  DELIMITER ";" mstr.
        CREATE minvoice.
       
        DISP mstr.
        
        mso = SUBSTR(mstr,1,8).
mline = integer(SUBSTR(mstr,9,4)).
mpart = SUBSTR(mstr,13,18).
mserial = SUBSTR(mstr,31,18).
mqty = integer(SUBSTR(mstr,49,1)).
  END. 
     
    FOR EACH minvoice:
        DISP minvoice.
    END.
 
 END.
