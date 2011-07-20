/* V1309  Create LOT Date   Today = Date ( V1309 )      */


find first pod_det where pod_nbr =  trim ( V1100 ) and pod_line = integer ( V1205 ) no-lock  .
find first po_mstr where po_nbr = trim ( V1100 ) no-lock .
if available(pod_det) and available(po_mstr) then do: 
       

       V1500 = substring(string(year(Date ( V1309 ))),3,2).   /* year - 2 character*/

	if  length(string(month(Date ( V1309 )))) = 1 then 
	    V1500 = V1500 + "0" + string(month(Date ( V1309 ))).   /* month - 2 character*/
	else
	    V1500 = V1500 + string(month(Date ( V1309 ))) .  

	if  length(string(day(Date ( V1309 )))) = 1 then 
	     V1500 = V1500 + "0" + string(day(Date ( V1309 ))).     /* day - 2 character*/
	else
	    V1500 = V1500 + string(day(Date ( V1309 ))) .

	find first vd_mstr where vd_addr = po_vend no-lock no-error.
	if avail vd_mstr then V1500 = V1500 + 
	   fill("0", 4 - length(trim( substring(trim(vd_sort),1,4,"RAW") ),"raw" )) + trim( substring(trim(vd_sort),1,4,"raw") ).
	else V1500 = V1500 + "0000" .

	V1500 = V1500  + "01".
	

	/*find last tr_hist where tr_serial > V1500 + "00"  and tr_serial <= V1500 + "zz" and tr_part = pod_part  use-index  tr_serial  no-lock no-error.
	if available(tr_hist) then do:

	   if substring(trim(tr_serial), (length(trim(tr_serial)) - 1),2) >= "99"  then     V1500 = V1500  + "XX".
	   else do:
	       /*if index("12345678" , substring(trim(tr_serial), (length(trim(tr_serial)) - 1 ),2)) = 0 then
		   V1500 = V1500  + "X".  
	       else */
	       if integer(substring(trim(tr_serial),length(trim(tr_serial)) - 1,2)) + 1 >= 10 then
	          V1500 = V1500  +  string( integer(substring(trim(tr_serial),length(trim(tr_serial)) - 1 ,2)) + 1 ).
		else V1500 = V1500 + "0" + string( integer(substring(trim(tr_serial),length(trim(tr_serial)) - 1 ,2)) + 1 ) .
	       
	       
	   end.
	end.
	else  do:
	    V1500 = V1500  + "01".
	end. */ 
end.