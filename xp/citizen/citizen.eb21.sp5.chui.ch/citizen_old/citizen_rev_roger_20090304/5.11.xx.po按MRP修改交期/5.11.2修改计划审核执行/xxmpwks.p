define input parameter  v_date as date .
define output parameter v_wk   as char .


/*define var v_date as date .
v_date  = 03/05/07 .
define var v_wk as char . */

define var a as integer .
define var b as integer .
define var c as integer .



a = ( v_date + 1 )
    -  date(1,1,year(v_date))  
    + (weekday(date(1,1,year(v_date))) - 1 ) . 

b = 0 .
c = 0 .

if a <= 7 then do:
    c = 1 .
end.
else do:
    b = a mod 7 . 
    c = if b > 0 then (( a - b ) / 7 + 1 ) 
                 else ( a / 7 ) .
end.


v_wk = string(year(v_date)) + string(c ,"99") .

