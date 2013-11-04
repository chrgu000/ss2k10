/* $Revision: eB2.1SP5 LAST MODIFIED: 02/23/12 BY: Apple Tam *SS - 20120223.1* */

FUNCTION GetField RETURNS CHARACTER (INPUT src AS CHAR, INPUT idx AS INT, INPUT deli AS CHAR).
    DEF VAR val AS CHAR.
    DEF VAR startPos AS INT.
    DEF VAR findPos AS INT.
    DEF VAR i AS INT.

    startPos = 1.
    i = 0.
    REPEAT WHILE(i <= idx):
      findPos = INDEX(src, deli, startPos).
      IF(findPos = 0 AND i < idx) THEN
        return "".

      IF(i < idx) THEN
        startPos = findPos + 1.

      i = i + 1.
    END.

    IF(findPos = 0) THEN
      val = SUBSTRING(src, startPos).
    ELSE
      val = SUBSTRING(src, startPos, findPos - startPos).

    return val.

END FUNCTION.

FUNCTION GetParam RETURNS CHAR (INPUT pname AS CHAR).
    DEF VAR str AS CHAR.
    DEF VAR str1 AS CHAR.
    DEF VAR str2 AS CHAR.
    DEF VAR i AS INT.

    i = 0.
    REPEAT WHILE TRUE:
        str = GetField(SESSION:PARAMETER, i, ";").
        IF(str = "") THEN
            RETURN "".

        str1 = GetField(str, 0, "=").
        str1 = TRIM(str1).
        IF(str1 = pname) THEN DO:
            str2 = GetField(str, 1, "=").
            TRIM(str2).
            RETURN str2.
        END.

        i = i + 1.
    END.

    RETURN "".

END FUNCTION.

FUNCTION ToDate RETURNS DATE (INPUT datestring AS CHAR).
    DEF VAR strYear AS CHAR.
    DEF VAR strMonth AS CHAR.
    DEF VAR strDay AS CHAR.
    DEF VAR findPos AS INT.

    strYear = GetField(datestring, 0, "-").
    strMonth = GetField(datestring, 1, "-").
    strDay = GetField(datestring, 2, "-").

    RETURN DATE(INTEGER(strMonth), INTEGER(strDay), INTEGER(strYear)).

END FUNCTION.
