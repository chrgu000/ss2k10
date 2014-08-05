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
find first code_mstr where code_fldname = "BARCODEDEFSITE" and code_value = "*" 
and code_domain = "PDC"
no-lock no-error.
if AVAILABLE(code_mstr) Then wDefSite = string (code_cmmt).
/*****Default SITE for ALL USER END  **************/


/*****Default SITE for UUSER START **************/
find first code_mstr where code_fldname = "BARCODEDEFSITE" and code_value =  userid(sdbname('qaddb')) 
and code_domain = "PDC"
no-lock no-error. 
if AVAILABLE(code_mstr) Then wDefSite = string (code_cmmt).
/*****Default SITE for UUSER END ****************/


/*****ONLY ONE SITE in DB  START **************/
find first si_mstr where si_domain = V1001  no-lock no-error.
xdefsite = si_site.
find last si_mstr where si_domain = V1001  no-lock no-error.
if xdefsite = si_site then wDefsite = si_site.
/*****ONLY ONE SITE in DB  END **************/



/*****ACCESS SITE START **************/

/* FOR USER LEVEL */
find first CODE_MSTR where  code_fldname = "BARCODEACCESSSITE" and code_value = userid(sdbname('qaddb'))  
and code_domain = "PDC"
no-lock no-error.
IF NOT AVAILABLE CODE_MSTR then DO:

   find first CODE_MSTR where code_fldname = "BARCODEACCESSSITE" and code_value =  "*" 
   and code_domain = "PDC"
   no-lock no-error.
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
   find first si_mstr where si_domain = V1001 and si_site = wDefSite  no-error .
   if available (si_mstr ) then do :
      if index ( si_canrun ,trim ( userid(sdbname('qaddb')) ) ) = 0 then do:
         if si_canrun = ""  then si_canrun = trim ( userid(sdbname('qaddb'))) .
	 else                    si_canrun = si_canrun + "," + trim ( userid(sdbname('qaddb'))). 
         
      end.
   end.
   release si_mstr .
   /***UPDATE STD SITE SECRITY END ***/
 
end.

if wDefsite = "" then aPASS = "N".

/************************************************  END ************************************************************/
