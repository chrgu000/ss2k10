/* BY: Bill Jiang DATE: 08/18/06 ECO: SS - 20060818.1 */

/* SS - 20060818.1 - B */
/*
1. 初发行版
2. 按以下格式返回系统当前时间:YYYYMMDDHHMMSS
*/
/* SS - 20060818.1 - E */

DEFINE OUTPUT PARAMETER todayTime AS CHARACTER.

todayTime 
   = STRING(YEAR(TODAY)) 
   + STRING(MONTH(TODAY),"99") 
   + STRING(DAY(TODAY),"99")
   + STRING(TIME,"hh:mm:ss")
   .
todayTime 
   = SUBSTRING(todayTime,1,10) 
   + SUBSTRING(todayTime,12,2) 
   + SUBSTRING(todayTime,15,2)
   .

RETURN.
