/* date-us.i                                         */
/* para - c_date for date value                      */
/*      - p for para name                            */
/* change the date is us format to character date_us */

tmp_date = {&c_date}.

dd = string(day(tmp_date)).
mm = month(tmp_date).
yy = string(year(tmp_date)).

if mm = 1 then
    str_mm = "Jan ".    
else if mm = 2 then
    str_mm = "Feb ".
else if mm = 3 then
    str_mm = "Mar ".
else if mm = 4 then
    str_mm = "Apr ".
else if mm = 5 then
    str_mm = "May ".
else if mm = 6 then
    str_mm = "Jun ".
else if mm = 7 then
    str_mm = "Jul ".
else if mm = 8 then
    str_mm = "Aug ".
else if mm = 9 then
    str_mm = "Sept ".
else if mm = 10 then
    str_mm = "Oct ".
else if mm = 11 then
    str_mm = "Nov ".
else if mm = 12 then
    str_mm = "Dec ".
    
    
{&p} = str_mm + dd + ", " + yy.

