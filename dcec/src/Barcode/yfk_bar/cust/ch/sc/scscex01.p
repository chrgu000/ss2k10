DEFINE VARIABLE weeklist AS CHARACTER.
DEFINE VARIABLE hourlist AS CHARACTER.

DEFINE VARIABLE i AS INT.
DEFINE VARIABLE j AS INT.






i = WEEKDAY(TODAY).
FOR EACH bsch_det WHERE bsch_week[i] = YES:
   i = 1.
   j= 0.
   hourlist = "".
   DO WHILE i <=24:
      IF bsch_hour[(i)] = YES THEN
            hourlist = hourlist + ";" + STRING(j).
      i = i + 1.
      j = j + 3600.
   END.
END.


MESSAGE hourlist VIEW-AS ALERT-BOX.
MAIN:
REPEAT :
    IF LOOKUP(STRING(TIME),hourlist,";") > 0 THEN
    LEAVE main.
END.
MESSAGE "ok" VIEW-AS ALERT-BOX.


