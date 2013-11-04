/* REVISION: eB21SP5       BY: Jordan lin  ECO：*SS -  20120214.1
判断指定字母在字符串中是否存在*/

FUNCTION SeekCH RETURNS logical (INPUT string1 AS CHARACTER,INPUT char1 AS CHARACTER):
   define variable i as int initial 0 .
   if string1 = ? then RETURN  FALSE .
   REPEAT i = 1 TO LENGTH(string1, "CHARACTER") by 1 :
      if char1 = SUBSTRING(string1,i,1,"CHARACTER" ) then  RETURN  TRUE .
   end. /* REPEAT i = 1 TO LENGTH(string1, "CHARACTER") by 1 :*/
   RETURN  FALSE .
END FUNCTION.


