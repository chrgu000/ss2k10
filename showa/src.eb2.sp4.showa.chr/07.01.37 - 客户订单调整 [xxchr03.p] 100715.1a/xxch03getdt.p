define input parameter sonbr like so_nbr no-undo.
define output parameter due_req_per as date no-undo.
due_req_per = today .
def variable wyear  as integer.
def variable wmonth as integer.
def variable wday   as integer .

   wyear =  2010 + integer ( substring(sonbr ,index(sonbr,"M") - 2 ,1)) .  /*Year*/

      if  substring(sonbr ,index(sonbr,"M") - 1 ,1) = "A"  then wmonth = 10.
         else  if  substring(sonbr ,index(sonbr,"M") - 1 ,1) = "B"  then wmonth = 11.
            else  if  substring(sonbr ,index(sonbr,"M") - 1 ,1) = "C"  then wmonth =12.
      else  wmonth = integer(substring(sonbr ,index(sonbr,"M") - 1 ,1)).

      wday = integer ( substring(sonbr ,index(sonbr,"M") + 1 ,2) ).  /*Day*/

      due_req_per = date(wmonth,wday,wyear).


