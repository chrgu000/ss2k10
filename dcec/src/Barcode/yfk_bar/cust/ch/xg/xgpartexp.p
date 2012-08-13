DEF VAR f1 AS CHAR FORMAT "x(48)".
f1 = "\\web\software\FTPQAD\export\" + STRING(year(TODAY)) + STRING(MONTH(TODAY)) + STRING(DAY(TODAY))
     + SUBstring(STRING(TIME,"hh:mm:ss"),1,2) + SUBstring(STRING(TIME,"hh:mm:ss"),4,2) + SUBstring(STRING(TIME,"hh:mm:ss"),7,2) + '.txt'.
OUTPUT TO VALUE(f1).
FOR EACH pt_mstr NO-LOCK:
    PUT UNFORMAT pt_part.
    PUT CONTROL CHR(9).
    PUT UNFORMAT pt_desc1.
    PUT CONTROL CHR(9).
    PUT UNFORMAT pt_article.
    PUT SKIP.
END.
OUTPUT CLOSE.

