/*
DEFINE VARIABLE InputDate AS DATE INIT TODAY.
InputDate = 12/23/05.
*/

/*SS - BY KEN 080903.1 */

DEFINE VARIABLE WeekResult AS CHAR.
DEFINE VARIABLE aa AS DATE INIT TODAY.



DEFINE VARIABLE tmp AS DEC.




AA = DATE ( 1,1,YEAR(Date(V1115))) .

/*SS - BY KEN 080903.1 B*/
/*
tmp  = (DATE(v1115) - aa - 1 + WEEKDAY(aa) ) / 7 + 1.
*/
tmp  = (DATE(v1115) - aa  + WEEKDAY(aa) ) / 7 + 1.
/*SS - BY KEN 080903.1 E*/

IF INT(tmp) - tmp > 0 THEN
    WeekResult = STRING ( INT(tmp)  - 1 ).
ELSE WeekResult = STRING ( INT (tmp) ).

if weekday(date(v1115)) = 1 then do :
 weekresult = string( int(weekresult) - 1 ) .
end .


IF LENGTH(weekResult) = 1 THEN WeekResult = "0" + TRIM(WeekResult).  /* Week */

WeekResult = substring ( V1115, length(V1115) - 1 , 2) + WeekResult . /* Year + Week */


if weekday( date (V1115) ) = 1 then WeekResult = WeekResult + "7" . 
else WeekResult = WeekResult +  string (weekday( date (V1115) ) - 1 ). /* WeekDay */
