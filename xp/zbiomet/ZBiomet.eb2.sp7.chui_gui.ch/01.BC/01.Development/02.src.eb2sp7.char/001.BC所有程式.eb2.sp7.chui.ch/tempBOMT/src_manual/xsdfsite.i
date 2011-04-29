/*xsdfsite.i 与 xsdfsite02.i 的区别只在于,这里不检查总帐是否已开  eco: *xp-gl-chk* */












/*  GET Default Site
*   INPUT Paramter
*   1) Userid
*   OUTPUT PARACMTER
*   1) wDefSite    
*              
*   2) aPASS - without Default Site 

*   Design By Sam Song April 13 2006 
*   CALL BY ALL Program    */


define variable aPASS as char format "x(1)" init "".


define variable xdefsite like si_site. 
define variable wDefSite like si_site. 

aPASS    = "Y".


/*****Default SITE for ALL USER START **************/
find first code_mstr where code_fldname = "BARCODEDEFSITE" and code_value = "*"  no-lock no-error.
if AVAILABLE(code_mstr) Then wDefSite = string (code_cmmt).
/*****Default SITE for ALL USER END  **************/


/*****Default SITE for UUSER START **************/
find first code_mstr where code_fldname = "BARCODEDEFSITE" and code_value =  userid(sdbname('qaddb'))  no-lock no-error. 
if AVAILABLE(code_mstr) Then wDefSite = string (code_cmmt).
/*****Default SITE for UUSER END ****************/


/*****ONLY ONE SITE in DB  START **************/
find first si_mstr no-lock no-error.
xdefsite = si_site.
find last si_mstr no-lock no-error.
if xdefsite = si_site then wDefsite = si_site.
/*****ONLY ONE SITE in DB  END **************/


/*****ACCESS SITE START **************/

/* FOR USER LEVEL */
find first CODE_MSTR where code_fldname = "BARCODEACCESSSITE" and code_value = userid(sdbname('qaddb'))  no-lock no-error.
IF NOT AVAILABLE CODE_MSTR then DO:

   find first CODE_MSTR where code_fldname = "BARCODEACCESSSITE" and code_value =  "*" no-lock no-error.
   IF NOT AVAILABLE CODE_MSTR THEN aPASS = "N".
   ELSE DO:
      if index ( trim(code_cmmt) , wDefsite ) = 0  then aPASS = "N" .
                                                   else aPASS = "Y" .
   
   END.
END.
ELSE do:
 if  index ( trim(code_cmmt) , wDefsite ) = 0 then aPASS = "N".
                                              else aPASS = "Y".
end.





/*****ACCESS SITE START **************/

if aPASS = "Y" and wDefSite <> "" then do:
   /***UPDATE STD SITE SECRITY START ***/
   find first si_mstr where si_site = wDefSite  .
   if available (si_mstr ) then do :
      if index ( si_canrun ,trim ( userid(sdbname('qaddb')) ) ) = 0 then do:
         if si_canrun = ""  then si_canrun = trim ( userid(sdbname('qaddb'))) .
         else                    si_canrun = si_canrun + "," + trim ( userid(sdbname('qaddb'))). 
         
      end.
   end.
   release si_mstr .
   /***UPDATE STD SITE SECRITY END ***/
 
   /*
   find first code_mstr where code_fldname = "BARCODEDEFSITE" and code_value =  userid(sdbname('qaddb'))  no-error. 
   if NOT AVAILABLE ( code_mstr ) then do:
      create code_mstr.
      code_fldname = "BARCODEDEFSITE" .
      code_value   = "userid(sdbname('qaddb'))".
   end.
   code_cmmt = V1002.
   */
end.


/*xp-gl-chk*/
/*
if wDefsite <> "" and apass = "Y" then do:
    define var v_entity like glcd_entity  .
    find first si_mstr where si_site = wDefsite no-lock no-error.
    v_entity = if avail si_mstr then si_entity else wDefsite .
    {xsglef01.i  &entity ="v_entity" &effdate="today" &module=""IC""}
end.
if wDefsite = "" then aPASS = "N".
*/
{xscurvar.i}
/************************************************  END ************************************************************/
