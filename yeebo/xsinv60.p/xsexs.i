/*  Control Expire date in UNPLANNED ISSUED [Normal Material]
*   input paramter
*   1) LOT  NO  V1500
*   2) PART NO V1300
*   OUTPUT PARACMTER
*   1) Expire Date < Today then wPASS= "N"
*                          ELSE wPASS= "Y"
*   2) wPASS
*   3) UNPLANNEDISSUEBUFFERDAY
*   Design By Sam Song April 13 2006
*   CALL BY XSINV24.p    UNPLANNED ISSUED  , Can Issue normal Material but expired material     */


define variable wPASS as char format "x(1)" init "". /* */
define variable winavgint like in_avg_int  init 0.
define variable waddyear  as integer.
define variable waddmonth as integer.
define variable waddday   as integer.
define variable lotyear   as char format "X(4)".
define variable lotmonth  as char format "X(2)".
define variable lotday    as char format "X(2)".
define variable w         as integer.

define variable expireinv as date.
define variable wLotdate  as date.
define variable UNPLANNEDISSUEBUFFERDAY as integer init 7.

find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="UNPLANNEDISSUEBUFFERDAY" no-lock no-error. /*  Buffer Days for UNPLANNED ISSUE */
if AVAILABLE(code_mstr) Then UNPLANNEDISSUEBUFFERDAY = integer(code_cmmt).



/*
DEFINE VARIABLE V1500 AS CHAR FORMAT "x(25)" INIT "000X060303xxxxxx".
DEFINE VARIABLE V1300 LIKE pt_part INIT "10".
*/

expireinv = ?.
lotyear  = "".
lotmonth = "".
lotday   = "".
wPASS    = "N".
winavgint   =  0.

if length( trim ( V1500 ) ) >= 6 then do:

  DO w = 1 to 6.
     if index("0987654321", substring(V1500, w ,1)) = 0 then do : /* Error Format PASS */
        wPASS = "Y" .
     end.

        if w = 1 or w = 2   then lotyear    = lotyear    + substring ( V1500 , w , 1 ).
        if w = 3 or w = 4   then lotmonth = lotmonth + substring ( V1500 , w , 1 ).
        if w = 5 or w = 6   then lotday     = lotday     + substring ( V1500 , w , 1 ).
  end.

end.
else do:
   wPASS = "Y".
end.

if  lotyear = "00" or lotmonth = "00" or lotday = "00" then do:
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


find first in_mstr where in_part = V1300 and in_site = V1002 no-lock no-error.
if available in_mstr then  winavgint = in_avg_int.
if winavgint = 90 then winavgint = 0.
if winavgint = 0 then wPASS = "Y".



if wPASS = "N" then do :


        wLotdate = date (integer(lotmonth) ,integer ( lotday ) ,integer ( "20" + lotyear ) )  .
        waddyear  = 0.
  waddmonth = 0.
  waddday   = 0.

  do w = 1 to winavgint.
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

        if expireinv - UNPLANNEDISSUEBUFFERDAY > today then wPASS = "Y" .

end.
/*1301*************************************************/
for each usrw_wkfl no-lock where usrw_key1 = trim ( V1300 ) + "@" + trim (V1500)
    break by usrw_key1 by integer(usrw_key2):
    if last-of(usrw_key1) then do:
       assign expireinv = date (usrw_key3).
    end.
end.
/*1301*************************************************/
/*1301*************************************************
find last usrw_wkfl where usrw_key1 = trim ( V1300 ) + "@" + trim (V1500) no-lock no-error .
if available (usrw_wkfl) then expireinv = date (usrw_key3).
*/
/************************************************  END ************************************************************/
