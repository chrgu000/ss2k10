/* SS - 091127.1 By: Bill Jiang */

ASSIGN
   errcount = errcount + 1
   .

/* ��������� */
IF allow_errors =  "N" THEN DO:
   LEAVE.
END.
ELSE DO:
   NEXT.
END.
