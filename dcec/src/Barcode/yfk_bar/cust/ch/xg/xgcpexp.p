DEF VAR f1 AS CHAR FORMAT "x(48)".
f1 = "\\web\software\FTPQAD\export\" + STRING(year(TODAY)) + STRING(MONTH(TODAY)) + STRING(DAY(TODAY))
     + SUBstring(STRING(TIME,"hh:mm:ss"),1,2) + SUBstring(STRING(TIME,"hh:mm:ss"),4,2) + SUBstring(STRING(TIME,"hh:mm:ss"),7,2).
OUTPUT TO VALUE(f1).
FOR EACH cp_mstr NO-LOCK:
    PUT cp_cust.
    PUT CONTROL CHR(9).
    FIND FIRST ad_mstr WHERE ad_addr = cp_cust NO-LOCK NO-ERROR.
    IF AVAILABLE ad_mstr THEN PUT ad_name.
    PUT CONTROL chr(9).
    PUT  cp_part.
    PUT CONTROL CHR(9).
    FIND FIRST pt_mstr WHERE pt_part = cp_part  NO-LOCK NO-ERROR.
    IF AVAILABLE pt_mstr THEN PUT pt_desc1.
    PUT CONTROL CHR(9).
    PUT cp_cust_part.
    PUT SKIP.
END.
OUTPUT CLOSE.
