/*  GET Default Domain
*   INPUT Paramter
*   1) Userid
*   OUTPUT PARACMTER
*   1) wDefDomain    
*              
*   2) dPASS - without Default Domain 

*   Design By Sam Song Dec 01 2006 
*   CALL BY ALL Program    */


define variable dPASS as char format "x(1)" init "".


define variable xdefDomain like si_domain. 
define variable wDefDomain like si_domain. 

dPASS    = "Y".



find first code_mstr where code_fldname = "BARCODEDEFDOMAIN" and code_value = "*" 
and code_domain = "PDC"
no-lock no-error .
if available code_mstr then wDefDomain = code_cmmt.

find first code_mstr where code_fldname = "BARCODEDEFDOMAIN" and code_value = userid(sdbname('qaddb')) 
and code_domain = "PDC"
no-lock no-error .
if available code_mstr then wDefDomain = code_cmmt.

if wDefDomain = "" then dPASS = "N".

/************************************************  END ************************************************************/
