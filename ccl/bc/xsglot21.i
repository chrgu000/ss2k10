/* V1203  Create LOT Date   Today = Date ( V1203 )      */


/* ss - 110926.1 -b */
DEFINE VAR vv1500 AS CHAR .
DEFINE VAR v_go AS LOGICAL INITIAL YES .
DEFINE VAR v_date AS DATE .
DEFINE VAR v_m AS INT .
DEFINE VAR v_y AS INT .
DEFINE VAR v_d AS INT .
find first pod_det where pod_nbr =  trim ( V1100 ) and pod_line = integer ( V1205 ) no-lock  .
find first po_mstr where po_nbr = trim ( V1100 ) no-lock .
if available(pod_det) and available(po_mstr) then do: 
       if length(trim(pod_rev)) < 2 then   /* version no  - 2 character */
	   vv1500 =  fill("0",2 - length(trim(pod_rev)))+ trim(pod_rev) .
       else
	  vv1500 = substring(trim(pod_rev),1,2).

      


    vv1500 = vv1500 + substring(string(year(Date ( V1203 ))),4,1).   /* year - 1 character*/


     

 if  length(string(month(Date ( V1203 )))) = 1 then 
     vv1500 = vv1500 +  string(month(Date ( V1203 ))).   /* month - 1 character*/
 ELSE DO:
     v_month = string(month(Date ( V1203 ))) .

      IF INT(v_month) = 10 THEN v_month = "A".
       ELSE IF INT(v_month) = 11 THEN v_month = "B".
       ELSE IF INT(v_month) = 12 THEN v_month = "C".
     vv1500 = vv1500 + v_month .  
 END.
     

 if  length(string(day(Date ( V1203 )))) = 1 then 
      vv1500 = vv1500 + "0" + string(day(Date ( V1203 ))).     /* day - 2 character*/
 else
     vv1500 = vv1500 + string(day(Date ( V1203 ))) .

 if  length(trim(po_vend)) >=6 then 
     vv1500 = vv1500 + substring(trim(po_vend),2,5).    /* vendor - 2 character ( 2th / 6th) */
 else
     vv1500 = vv1500 + fill("0",4 - length(po_vend)) + trim(po_vend) .
     
     /* ss - 110926.2 -b */
       IF v_vat  THEN
     vv1500 = vv1500  + "V".
     ELSE
      vv1500 = vv1500  + "F".
     /* ss - 110926.2 -e */

end.

  
IF LENGTH(v1500) <> 12 THEN  DO:
    v_go = NO .
END. 
ELSE DO:

    IF SUBSTRING(v1500 , 1 , 2 ) <> SUBSTRING(vv1500 , 1 , 2 )
        OR  SUBSTRING(v1500 , 7 , 5 ) <> SUBSTRING(vv1500 , 7 , 5 )
        OR SUBSTRING(v1500 , 12 , 1 ) <> SUBSTRING(vv1500 , 12 , 1 ) 
        OR INDEX("0987654321", substring(V1500, 3 , 1) ) = 0 
        OR INDEX("0987654321", substring(V1500, 5 , 1) ) = 0 
         OR INDEX("0987654321", substring(V1500, 6 , 1) ) = 0 
        OR INDEX("0987654321abc", substring(V1500, 4 , 1) ) = 0  THEN
        v_go = NO  .
    ELSE DO:
         
        v_y = int(SUBSTRING(v1500 , 3 , 1 )) .

        IF SUBSTRING(v1500 , 4 , 1 ) = "a"   THEN
            v_m = 10 .
        ELSE IF SUBSTRING(v1500 , 4 , 1 ) = "b" THEN
            v_m = 11 .
         ELSE IF SUBSTRING(v1500 , 4 , 1 ) = "c" THEN
             v_m = 12 .
        ELSE 
              v_m =  INT ( SUBSTRING(v1500 , 4 , 1 ) ) .
           

         v_d = int(SUBSTRING(v1500 , 5 , 2 )) .


         v_date = DATE(v_m , v_d , v_y) .  

         IF Date ( V1203 ) - v_date > 30  THEN
             v_go = NO .

        
    END.

END.



    
    
