PROCEDURE cycletree:
 DEF INPUT PARAMETER ihnode AS HANDLE.
 DEF INPUT PARAMETER isread AS LOGICAL.
 DEF  VAR i AS INT.
IF ihnode:CHILD-NUM = 0 AND ISread THEN DO:
   ihnode:GET-ATTRIBUTE('value').
   CASE 
   END CASE.
   RETURN. 
    END.
 REPEAT i = 1 TO ihnode:CHILD-NUM BY 1:
  IF ihnode:NAME = 'supplier_data'THEN DO:
  isread = YES.
   IF i = 1 THEN  CREATE supp.
    
            
  END.
      
          
          
         
      
      
      
      
      
      
    
    RUN cycletree(ihnode:GET-CHILD(ihnode),isread).
    
    
    
    
    END'
