       V1500 = "".
       V1500 = substring(string(year(Date ( V1309 ))),3,2).   /* year - 2 character*/

	if  length(string(month(Date ( V1309 )))) = 1 then 
	    V1500 = V1500 + "0" + string(month(Date ( V1309 ))).   /* month - 2 character*/
	else
	    V1500 = V1500 + string(month(Date ( V1309 ))) .  

	if  length(string(day(Date ( V1309 )))) = 1 then 
	     V1500 = V1500 + "0" + string(day(Date ( V1309 ))).     /* day - 2 character*/
	else
	    V1500 = V1500 + string(day(Date ( V1309 ))) .

        V1500 = V1500 + trim(V1108).
	if length(V1500) > 18 then V1500 = substring( V1500 ,1,18).
	