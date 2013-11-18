/* SS - 091127.1 By: Bill Jiang */

ASSIGN
   errcount = errcount + 1
   .

/* ²»ÔÊÐí³ö´í */
IF allow_errors =  "N" THEN DO:
   LEAVE.
END.
ELSE DO:
   NEXT.
END.
