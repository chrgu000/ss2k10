DEFINE VAR dep_num AS CHAR FORMAT "X(22)".
DEFINE VAR dep_desc AS CHAR FORMAT " X(42)".
DEFINE VAR dept AS CHAR FORMAT "x(65)".
OUTPUT TO E:\inter\BMXX.TXT.
FOR EACH dpt_mstr:
    ASSIGN dep_num='"' + dpt_mstr.dpt_dept + '"'
                  dep_desc='"' + dpt_mstr.dpt_desc + '"'.
                  dept=dep_num + " " + dep_desc. 
    PUT SKIP. 
    PUT   UNFORMAT dept   .
   
END.

OUTPUT CLOSE.
