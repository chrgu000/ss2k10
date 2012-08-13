/*DEF INPUT PARAMETER mfile AS CHAR.*/
DEF TEMP-TABLE filter 
    FIELD fil_str AS CHAR FORMAT "x(10000)".
DEF VAR out AS CHAR.
DEF VAR isfirst AS LOGICAL.
OUTPUT TO c:\ppo0.xml APPEND.
PUT ':;%&/?' .
OUTPUT CLOSE.
INPUT FROM c:\ppo0.xml.
DEF VAR mcnt AS INT.

DEF VAR str AS CHAR.
DEF VAR i AS INT.

mcnt = 1.

REPEAT:

  CREATE filter.
  IMPORT DELIMITER ":;%&/?" fil_str.
IF mcnt = 2 THEN do:
    fil_str = SUBSTR(fil_str,26,LENGTH(fil_str)).
    fil_str = REPLACE(fil_str,":;%&/?","").
END.
  mcnt = mcnt + 1.
END.


  isfirst = YES.
    
   OUTPUT TO c:\ppo0.xml.
   
mcnt = 1.
  FOR EACH filter:
      DO i = 1 TO LENGTH(fil_str):
          
              
          
      PUT UNFORMAT substr(fil_str,i,1).
      IF mcnt = 1 AND substr(fil_str,i,1) = '>' THEN PUT SKIP.
    IF mcnt = 2 AND substr(fil_str,i,1) = '>' AND  i < LENGTH(fil_str) THEN PUT SKIP.
      
      
      END.
    
      mcnt = mcnt + 1.
  END.

   OUTPUT CLOSE.
/*OUTPUT TO c:\ppo.xml.
EXPORT fil_str.
OUTPUT CLOSE.*/
