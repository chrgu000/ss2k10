FUNCTION ssDate RETURNS CHARACTER (INPUT ssDateInput1 AS DATE,INPUT ssDateInput2 AS CHARACTER).
   DEFINE VARIABLE ssDateCharacter1 AS CHARACTER.
   DEFINE VARIABLE ssDateCharacter2 AS CHARACTER.
   DEFINE VARIABLE ssDateInteger1 AS INTEGER.
   ssDateCharacter1 = "".
   ssDateCharacter2 = "".
   DO ssDateInteger1 = 1 TO LENGTH(ssDateInput2):
      IF INDEX("mdy",SUBSTRING(ssDateInput2,ssDateInteger1,1)) > 0 THEN DO:
         ssDateCharacter2 = ssDateCharacter2 + SUBSTRING(ssDateInput2,ssDateInteger1,1).
      END.
      ELSE DO:
         IF ssDateCharacter2 = "m" THEN DO:
            ssDateCharacter1 = ssDateCharacter1 + STRING(MONTH(ssDateInput1)) + SUBSTRING(ssDateInput2,ssDateInteger1,1).
         END.
         ELSE IF ssDateCharacter2 = "mm" THEN DO:
            ssDateCharacter1 = ssDateCharacter1 + STRING(MONTH(ssDateInput1),"99") + SUBSTRING(ssDateInput2,ssDateInteger1,1).
         END.
         ELSE IF ssDateCharacter2 = "d" THEN DO:
            ssDateCharacter1 = ssDateCharacter1 + STRING(DAY(ssDateInput1)) + SUBSTRING(ssDateInput2,ssDateInteger1,1).
         END.
         ELSE IF ssDateCharacter2 = "dd" THEN DO:
            ssDateCharacter1 = ssDateCharacter1 + STRING(DAY(ssDateInput1),"99") + SUBSTRING(ssDateInput2,ssDateInteger1,1).
         END.
         ELSE IF ssDateCharacter2 = "yy" THEN DO:
            ssDateCharacter1 = ssDateCharacter1 + SUBSTRING(STRING(YEAR(ssDateInput1)),3,2) + SUBSTRING(ssDateInput2,ssDateInteger1,1).
         END.
         ELSE IF ssDateCharacter2 = "yyyy" THEN DO:
            ssDateCharacter1 = ssDateCharacter1 + STRING(YEAR(ssDateInput1)) + SUBSTRING(ssDateInput2,ssDateInteger1,1).
         END.
         ssDateCharacter2 = "".
      END.
   END.

   IF ssDateCharacter2 = "m" THEN DO:
      ssDateCharacter1 = ssDateCharacter1 + STRING(MONTH(ssDateInput1)).
   END.
   ELSE IF ssDateCharacter2 = "mm" THEN DO:
      ssDateCharacter1 = ssDateCharacter1 + STRING(MONTH(ssDateInput1),"99").
   END.
   ELSE IF ssDateCharacter2 = "d" THEN DO:
      ssDateCharacter1 = ssDateCharacter1 + STRING(DAY(ssDateInput1)).
   END.
   ELSE IF ssDateCharacter2 = "dd" THEN DO:
      ssDateCharacter1 = ssDateCharacter1 + STRING(DAY(ssDateInput1),"99").
   END.
   ELSE IF ssDateCharacter2 = "yy" THEN DO:
      ssDateCharacter1 = ssDateCharacter1 + SUBSTRING(STRING(YEAR(ssDateInput1)),3,2).
   END.
   ELSE IF ssDateCharacter2 = "yyyy" THEN DO:
      ssDateCharacter1 = ssDateCharacter1 + STRING(YEAR(ssDateInput1)).
   END.

   RETURN(ssDateCharacter1).
END FUNCTION.   
