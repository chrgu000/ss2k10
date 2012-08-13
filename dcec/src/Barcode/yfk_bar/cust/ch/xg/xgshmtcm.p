/*************************************************
** Program: xgshmtcm.p
** Author : Li Wei , AtosOrigin
** Date   : 2005-8-18
** Description: CimLoad Format Control
*************************************************/


{mfdeclre.i}

DEFINE VAR qt AS CHARACTER INIT '"'.
DEFINE VAR spc AS CHARACTER INIT " ".

DEFINE INPUT PARAMETER flname AS CHARACTER format "x(80)".
DEFINE INPUT PARAMETER shipfrom AS CHARACTER .
DEFINE INPUT PARAMETER ship AS CHARACTER .
DEFINE INPUT PARAMETER shipto AS CHARACTER .
DEFINE INPUT PARAMETER part AS CHARACTER .
DEFINE INPUT PARAMETER qty AS DECIMAL.
DEFINE INPUT PARAMETER site AS CHARACTER .
DEFINE INPUT PARAMETER loc AS CHARACTER.

output to value(flname) append.
PUT UNFORMATTED "@@batchload rcshmt.p" SKIP.
PUT UNFORMATTED qt shipfrom qt spc
                qt ship qt spc
                qt shipto qt spc
                "- " spc skip
                "- No - - - - '' - - - No"
                skip
                "." 
                skip
                qt part qt spc "-" 
                skip
                qt qty qt spc
                "- - "
                qt site qt spc
                qt loc  qt spc
                "- - No No"
                skip
                "."
                skip
                "-"
                skip
                "." 
                skip .
PUT UNFORMATTED "." SKIP.
PUT UNFORMATTED "@@END" SKIP .
output close.

