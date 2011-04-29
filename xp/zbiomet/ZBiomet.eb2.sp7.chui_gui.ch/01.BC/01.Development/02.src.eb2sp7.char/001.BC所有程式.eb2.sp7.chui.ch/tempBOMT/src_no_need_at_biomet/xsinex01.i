/*  Ouput Inventory Expire Date
*   input paramter
*   1) LOT  NO  V1500
*   2) PART NO V1300
*   OUTPUT PARACMTER
*   1) Expire Date > Today then wPASS= "Y"    
*                          ELSE wPASS= "N"
*   2) expireinv  ---- Inventory expire date
*      IF Error Format For LOT expireinv = ?
*   Design By Sam Song April 13 2006 
*   CALL BY xsinexrp.p  INVENTORY EXPIRE REPORT  */


define variable wPASS as char format "x(1)" init "". /* */
define variable wptavgint like pt_avg_int  init 0.
define variable waddyear  as integer.
define variable waddmonth as integer.
define variable waddday   as integer.
define variable lotyear   as char format "X(4)".
define variable lotmonth  as char format "X(2)".
define variable lotday    as char format "X(2)".
define variable w         as integer.

define variable expireinv as date.
define variable wLotdate  as date.

/*
DEFINE VARIABLE V1500 AS CHAR FORMAT "x(25)" INIT "000X060303xxxxxx".
DEFINE VARIABLE V1300 LIKE pt_part INIT "10".
*/

expireinv = ?.
lotyear  = "".
lotmonth = "".
lotday   = "".
wPASS    = "N".
wptavgint   =  0.

if length( trim ( V1500 ) ) >= 10 then do:

	DO w = 5 to 10.
	   if index("0987654321", substring(V1500, w ,1)) = 0 then do : /* Error Format PASS */
	      wPASS = "Y" .
	   end.
	   
	      if w = 5 or w = 6   then lotyear    = lotyear    + substring ( V1500 , w , 1 ).
	      if w = 7 or w = 8   then lotmonth = lotmonth + substring ( V1500 , w , 1 ).
	      if w = 9 or w = 10  then lotday     = lotday     + substring ( V1500 , w , 1 ).
	end.

end.
else do:
   wPASS = "Y".
end.

if wPASS = "N" and ( lotyear <> "" or lotmonth <> "" or lotday <> "" ) then do: 

      if integer ( lotmonth ) <= 12 then do:

	if  integer ( lotday ) > day ( date (
	                                      ( if lotmonth = "12" then 1 else  integer(lotmonth) + 1  ),
					        1 , 
				              ( if lotmonth = "12" then 1 + integer ( "20" + lotyear ) else  integer ( "20" + lotyear )  )
					    )  - 1 )  then do:
	   wPASS = "Y".
	   lotday = "01".
	   lotmonth = "01".
	end.

      end.
      else do:
	   wPASS = "Y".
	   lotday = "01".
	   lotmonth = "01".

      end.



end.

/*
find first pt_mstr where pt_part = V1300 no-lock no-error.
if available pt_mstr then  wptavgint = pt_avg_int.
*/
wptavgint = pt_avg_int.

if wptavgint = 90 then wptavgint = 0. 
if wptavgint = 0 then wPASS = "Y".



if wPASS = "N" then do :


        wLotdate = date (integer(lotmonth) ,integer ( lotday ) ,integer ( "20" + lotyear ) )  . 
        waddyear  = 0.
	waddmonth = 0.
	waddday   = 0.

	do w = 1 to wptavgint.
	   waddmonth = waddmonth + 1.
	   if waddmonth = 12 then do:
	      waddmonth = 0.
	      waddyear = waddyear + 1.
	   end.
	end.

	if day ( wLotdate ) > 28 then do:

	    if day ( date (  
	                     (  if ( month  ( wLotdate ) + waddmonth  + 1 <= 12 ) 
			          then month  ( wLotdate ) + waddmonth + 1  
				  else  ( month  ( wLotdate ) + waddmonth + 1 - 12 )
			      ) ,
			    1 , 

			     ( if ( month  ( wLotdate ) + waddmonth  + 1 <= 12 ) 
			       then year ( wLotdate ) + waddyear  
			       else  year ( wLotdate ) + waddyear + 1  
                             )
			  ) - 1 
	           ) < day ( wLotdate ) then do:









	       waddday = day ( wLotdate ) - day ( date ( 
	                                                if month  ( wLotdate ) + waddmonth + 1 <= 12 
							   then month  ( wLotdate ) + waddmonth + 1 
							   else month  ( wLotdate ) + waddmonth + 1 - 12 ,
							1 ,
							if month  ( wLotdate ) + waddmonth + 1 <= 12 
							   then year ( wLotdate ) + waddyear 
							   else year ( wLotdate ) + waddyear + 1 
							) 
					          - 1 ) .
	    end.
	    
	end.

	if day ( wLotdate ) > 28 and 
	   day ( date ( 
	                if month ( wLotdate ) + waddmonth + 1 <= 12 
			then month ( wLotdate ) + waddmonth + 1 
		        else month ( wLotdate ) + waddmonth + 1 - 12 ,
			1 ,
			if month ( wLotdate ) + waddmonth + 1 <= 12 
			then year (wLotdate ) + waddyear  
 		        else year (wLotdate ) + waddyear + 1  

	               )  - 1  ) < day ( wLotdate )  then do:

	   expireinv = date ( 
	                     if month ( wLotdate )   + waddmonth + 1 <= 12 
			     then month ( wLotdate ) + waddmonth + 1 
			     else month ( wLotdate ) + waddmonth + 1 - 12 ,
			     1 , 
			     if month ( wLotdate )   + waddmonth + 1 <= 12 
			     then year (wLotdate ) + waddyear
			     else year (wLotdate ) + waddyear  + 1
			     ) - 1.
           

	   expireinv = expireinv + waddday  .


	end.
	else do:

	expireinv = date ( 
	                     if month ( wLotdate )   + waddmonth  <= 12 
			     then month ( wLotdate ) + waddmonth  
			     else month ( wLotdate ) + waddmonth  - 12 ,
			     day ( wLotdate ) , 
			     if month ( wLotdate )   + waddmonth  <= 12 
			     then year (wLotdate ) + waddyear
			     else year (wLotdate ) + waddyear  + 1
			     ) .
           
	
	end.

        if expireinv >= today then wPASS = "Y" .

end.
/************************************************  END ************************************************************/
