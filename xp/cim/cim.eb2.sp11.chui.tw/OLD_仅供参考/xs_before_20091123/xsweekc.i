
/*
DEFINE VARIABLE InputDate AS DATE INIT TODAY.
InputDate = 12/23/05.
*/
DEFINE VARIABLE WeekResult AS CHAR.
DEFINE VARIABLE aa AS DATE INIT TODAY.
DEFINE VARIABLE tmp AS DEC.




AA = DATE ( 1,1,YEAR(Date(V1110))) .


tmp  = (DATE(v1110) - aa - 1 + WEEKDAY(aa) ) / 7 + 1.
IF INT(tmp) - tmp > 0 THEN
    WeekResult = STRING ( INT(tmp)  - 1 ).
ELSE WeekResult = STRING ( INT (tmp) ).


IF LENGTH(weekResult) = 1 THEN WeekResult = "0" + TRIM(WeekResult).  /* Week */

WeekResult = substring ( V1110, length(V1110) - 1 , 2) + WeekResult . /* Year + Week */

if weekday( date (V1110) ) = 1 then WeekResult = WeekResult + "7" . 
else WeekResult = WeekResult +  string (weekday( date (V1110) ) - 1 ). /* WeekDay */
