/* V1203  Create LOT Date   Today = Date ( V1203 )      */
/* ss - 110926.1 by: jack */  /* modify lot */
/* ss - 110926.1 -b
find first pod_det where pod_nbr =  trim ( V1100 ) and pod_line = integer ( V1205 ) no-lock  .
find first po_mstr where po_nbr = trim ( V1100 ) no-lock .
if available(pod_det) and available(po_mstr) then do: 
       if length(trim(pod_rev)) < 4 then   /* version no  - 4 character */
	   V1500 =  fill("0",4 - length(trim(pod_rev)))+ trim(pod_rev) .
       else
	  V1500 = substring(trim(pod_rev),1,4).

       V1500 = V1500 + substring(string(year(Date ( V1203 ))),3,2).   /* year - 2 character*/

	if  length(string(month(Date ( V1203 )))) = 1 then 
	    V1500 = V1500 + "0" + string(month(Date ( V1203 ))).   /* month - 2 character*/
	else
	    V1500 = V1500 + string(month(Date ( V1203 ))) .  

	if  length(string(day(Date ( V1203 )))) = 1 then 
	     V1500 = V1500 + "0" + string(day(Date ( V1203 ))).     /* day - 2 character*/
	else
	    V1500 = V1500 + string(day(Date ( V1203 ))) .

	if  length(trim(po_vend)) >=2 then 
	    V1500 = V1500 + substring(trim(po_vend),2,1) + "9".    /* vendor - 2 character ( 2th / 3th) */
	else
	    V1500 = V1500 + fill("0",2 - length(po_vend)) + trim(po_vend) .
        /*
	find last tr_hist where tr_serial > V1500 + "0"  and tr_serial <= V1500 + "z" and tr_part = pod_part  use-index  tr_serial  no-lock no-error.
	if available(tr_hist) then do:

	   if substring(trim(tr_serial),length(trim(tr_serial)),1) >= "9"  then     V1500 = V1500  + "X".
	   else do:
	       if index("12345678" , substring(trim(tr_serial),length(trim(tr_serial)),1)) = 0 then
		   V1500 = V1500  + "X".  
	       else 
	       V1500 = V1500  +  string( integer(substring(trim(tr_serial),length(trim(tr_serial)),1)) + 1 ).
	   end.
	end.
	else  do:
	    V1500 = V1500  + "1".
	end. 
	*/
        V1500 = V1500  + "1".
end.
ss - 110926.1 -e */

/* ss - 110926.1 -b */
DEFINE VAR v_month AS CHAR .
find first pod_det where pod_nbr =  trim ( V1100 ) and pod_line = integer ( V1205 ) no-lock  .
find first po_mstr where po_nbr = trim ( V1100 ) no-lock .
if available(pod_det) and available(po_mstr) then do: 
       if length(trim(pod_rev)) < 2 then   /* version no  - 2 character */
	   V1500 =  fill("0",2 - length(trim(pod_rev)))+ trim(pod_rev) .
       else
	  V1500 = substring(trim(pod_rev),1,2).

      


    V1500 = V1500 + substring(string(year(Date ( V1203 ))),4,1).   /* year - 1 character*/


     

 if  length(string(month(Date ( V1203 )))) = 1 then 
     V1500 = V1500 +  string(month(Date ( V1203 ))).   /* month - 1 character*/
 ELSE DO:
     v_month = string(month(Date ( V1203 ))) .

      IF INT(v_month) = 10 THEN v_month = "A".
       ELSE IF INT(v_month) = 11 THEN v_month = "B".
       ELSE IF INT(v_month) = 12 THEN v_month = "C".
     V1500 = V1500 + v_month .  
 END.
     

 if  length(string(day(Date ( V1203 )))) = 1 then 
      V1500 = V1500 + "0" + string(day(Date ( V1203 ))).     /* day - 2 character*/
 else
     V1500 = V1500 + string(day(Date ( V1203 ))) .

 if  length(trim(po_vend)) >=6 then 
     V1500 = V1500 + substring(trim(po_vend),2,5).    /* vendor - 2 character ( 2th / 6th) */
 else
     V1500 = V1500 + fill("0",4 - length(po_vend)) + trim(po_vend) .
     /*
 find last tr_hist where tr_serial > V1500 + "0"  and tr_serial <= V1500 + "z" and tr_part = pod_part  use-index  tr_serial  no-lock no-error.
 if available(tr_hist) then do:

    if substring(trim(tr_serial),length(trim(tr_serial)),1) >= "9"  then     V1500 = V1500  + "X".
    else do:
        if index("12345678" , substring(trim(tr_serial),length(trim(tr_serial)),1)) = 0 then
        V1500 = V1500  + "X".  
        else 
        V1500 = V1500  +  string( integer(substring(trim(tr_serial),length(trim(tr_serial)),1)) + 1 ).
    end.
 end.
 else  do:
     V1500 = V1500  + "1".
 end. 
 */
     /* ss - 110926.2 -b */
       IF v_vat  THEN
     V1500 = V1500  + "V".
     ELSE
      V1500 = V1500  + "F".
     /* ss - 110926.2 -e */

end.

      /* ss - 110926.1 -e */
