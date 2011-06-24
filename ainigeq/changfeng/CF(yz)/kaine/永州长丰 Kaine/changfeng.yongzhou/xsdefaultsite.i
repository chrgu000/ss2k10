/* xsdefaultsite.i -- */
/* Copyright 200906 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 06/30/2009   By: Kaine Zhang     Eco: *ss_20090630* */


find first code_mstr 
    where code_fldname = "BARCODEDEFSITE" 
        and code_value = userid(sdbname('qaddb'))  
    no-lock 
    no-error. 
if not(available(code_mstr)) then do:
    find first code_mstr 
        where code_fldname = "BARCODEDEFSITE" 
            and code_value = "*"  
        no-lock 
        no-error.
end.

if available(code_mstr) then do:
    {1} = string(code_cmmt).
end.
else do:
    {1} = "".
end.

if {1} <> "" then do:
    find first si_mstr
        where si_site = {1}
        no-lock
        no-error.
    if available(si_mstr) then do:
        {2} = si_desc.
    end.
    else do:
        {2} = "Error: Not Available Site".
    end.
end.
