
V1500 =  substring(string(year(Date ( V1203 ))),3,2).   /* year - 2 character */

	if  length(string(month(Date ( V1203 )))) = 1 then 
	    V1500 = V1500 + "0" + string(month(Date ( V1203 ))).   /* month - 2 character*/
	else
	    V1500 = V1500 + string(month(Date ( V1203 ))) .  

	if  length(string(day(Date ( V1203 )))) = 1 then 
	     V1500 = V1500 + "0" + string(day(Date ( V1203 ))).     /* day - 2 character*/
	else
	    V1500 = V1500 + string(day(Date ( V1203 ))) .

        find last tr_hist where tr_serial > V1500 + "00"  and tr_serial <= V1500 + "ZZ" and tr_part = V1300  use-index  tr_serial  no-lock no-error.
	if available(tr_hist) then do:

	   if substring(trim(tr_serial),length(trim(tr_serial)) - 1 , 2) >= "99"  then     V1500 = V1500  + "XX".
	   else do:
	       if index("12345678" , substring(trim(tr_serial),length(trim(tr_serial)),1)) = 0 then
		   V1500 = V1500  + "XX".  
	       else do: 

		 if  integer(substring(trim(tr_serial),length(trim(tr_serial)) - 1 ,2)) + 1  <= 9 then
   	             V1500 = V1500  +  "0" + string( integer(substring(trim(tr_serial),length(trim(tr_serial)) - 1 ,2)) + 1 ).
		 else
		     V1500 = V1500  +  string( integer(substring(trim(tr_serial),length(trim(tr_serial)) - 1 ,2)) + 1 ).
                end.
	   end.
	end.
	else  do:
	    V1500 = V1500  + "01".
	end. 