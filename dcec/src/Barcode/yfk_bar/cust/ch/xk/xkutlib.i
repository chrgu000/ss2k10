/*----------------------------------------------
  File         xkutlib.i
  Description  Utility library include file
  Author       Yang Enping
  Create       2004-06-14
  ---------------------------------------------*/

function IsCorrectTime returns logical
(input timeStr as char) .
/*---------------------------------------------------------------------------
   Purpose:     Check if the specified time string is a qualified time(24 hours bases)
   Exceptions:  None
   Notes:       
                
   History:
   Inputs:
                timeStr, time string.
   Outputs:

---------------------------------------------------------------------------*/

   def var hhstr as char .
   def var mmstr as char .
   define var hh as int .
   define var mm as int .
   def var i as int .

   if num-entries(timeStr,":") <> 2 then 
      return false .

   hhstr = entry(1,timeStr,":") .
   if length(hhstr) <> 1 and length(hhstr) <> 2 then
      return false .

   do i = 1 to length(hhstr):
      if substring(hhstr,i,1) < "0" and substring(hhstr,i,1) > "9" then
         return false .
   end .

   hh = integer(hhstr) .
   if hh < 0 or hh > 23 then
      return false .

   mmstr = entry(2,timeStr,":") .
   if length(mmstr) <> 2 then
      return false .
   do i = 1 to length(mmstr):
      if substring(mmstr,i,1) < "0" and substring(mmstr,i,1) > "9" then
         return false .
   end .
   mm = integer(mmstr) .
   if mm < 0 or mm > 59 then
      return false .

   return true .
end function .


function IsCorrectTimeEntries return logical
(input timeEntries as char) .
/*---------------------------------------------------------------------------
   Purpose:     Check the qualification a time string, the string should in 
                format of "HH:MM,HH,MM,...".

   Exceptions:  None
   Notes:       
                
   History:
   Inputs:
                timeStr, time string.
   Outputs:

---------------------------------------------------------------------------*/

   def var i as int .

   do i = 1 to num-entries(timeEntries,","):
      if not IsCorrectTime(entry(i, timeEntries, ",")) then
         return false .
   end .

   return true .
end .


function GetWeekDayName return char
(input weekDayIndex as int) .
/*---------------------------------------------------------------------------
   Purpose:     Get the week day name

   Exceptions:  None
   Notes:       
                
   History:
   Inputs:
                weekDayIndex
   Outputs:

---------------------------------------------------------------------------*/
   case weekDayIndex:
      when 1 then return "星期一" .
      when 2 then return "星期二" .
      when 3 then return "星期三" .
      when 4 then return "星期四" .
      when 5 then return "星期五" .
      when 6 then return "星期六" .
      when 7 then return "星期天" .
      otherwise return "错误" .
   end case .


end .