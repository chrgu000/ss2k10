/*
DEFINE VARIABLE InputDate AS DATE INIT TODAY.
InputDate = 12/23/05.
*/
DEFINE VARIABLE WeekResult AS CHAR.
DEFINE VARIABLE aa AS DATE INIT TODAY.



AA = DATE ( 1,1,YEAR(Date(V1110))) .


IF  WEEKDAY (aa) > 2 THEN   AA = aa + ( 7 - weekday(aa) ) + 2.
IF  WEEKDAY (aa) = 1 THEN aa = aa +  1.
IF Date(V1110) = aa THEN  
    WeekResult = "01" . 
    ELSE  WeekResult = string(INTEGER (( Date(V1110) - aa ) / 7 - 0.5) + 1) .


IF LENGTH(weekResult) = 1 THEN WeekResult = "0" + TRIM(WeekResult).  /* Week */

WeekResult = substring ( V1110, length(V1110) - 1 , 2) + WeekResult . /* Year + Week */

if weekday( date (V1110) ) = 1 then WeekResult = WeekResult + "7" . 
else WeekResult = WeekResult +  string (weekday( date (V1110) ) - 1 ). /* WeekDay */