/* BY: BILL JIANG DATE: 09/10/06 ECO: 20060910.1 */

/*
1. ¼ÓÃÜ×Ö½Ú
*/

DEFINE INPUT PARAMETER ci AS CHARACTER.
DEFINE OUTPUT PARAMETER co AS CHARACTER.

DEFINE VARIABLE mptr AS MEMPTR.
DEFINE VARIABLE cnt  AS INTEGER.
DEFINE VARIABLE i1 AS INTEGER.
DEFINE VARIABLE i2 AS INTEGER.
DEFINE VARIABLE c1 AS CHARACTER.

SET-SIZE(mptr) = LENGTH(ci,"RAW") + 1.
PUT-STRING(mptr, 1) = ci.

c1 = "".
REPEAT cnt = 1 TO LENGTH(ci,"RAW"):  
   i1 = (cnt MOD 3).
   IF i1 = 1 THEN DO:
      i2 = 27.
   END.
   ELSE IF i1 = 2 THEN DO:
      i2 = 17.
   END.
   ELSE DO:
      i2 = 7.
   END.
   c1 = c1 + STRING(GET-BYTE(mptr, cnt) + (cnt MOD i2) * (cnt MOD i2)  + i1, "999").
END.

co = "".
DO cnt = 1 TO LENGTH(c1,"RAW"):
   co = co + STRING(RANDOM(0,9)) + SUBSTRING(c1,cnt,1).
END.
