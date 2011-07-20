/* Create MFG/PRO Execte File Path  START */
/* Modify by ken chen 08/09/05   ECO:080908.1*/
/*SS - 080908.1
define variable global_user_lang_dir as char format "x(40)" init "/app/mfgpro/eb2/ch/".

define shared variable global_gblmgr_handle as handle no-undo.
*/
define variable ciminputfile   as char .
define variable cimoutputfile  as char .
run pxgblmgr.p persistent set global_gblmgr_handle.
/* Create MFG/PRO Execte File Path   END  */

find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="global_user_lang_dir" no-lock no-error. /*  Update MFG/PRO Directory */
if AVAILABLE(code_mstr) Then global_user_lang_dir = trim ( code_cmmt ).
if substring(global_user_lang_dir, length(global_user_lang_dir), 1) <> "/" then 
 global_user_lang_dir = global_user_lang_dir + "/".
/* Create LOGIN MFG/PRO USER ID START */
/* Create LOGIN MFG/PRO USER ID END */
/* Create Section Variable START */
define variable usection as char format "x(16)".
/* Create Section Variable END */

usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "soi11" .
output to value( trim(usection) + ".i") .
        display 
trim ( V1551 ) format "x(50)" " - N N " format "x(50)" skip
trim (V1555) format "x(50)"  skip
trim ( V1600 ) + " " + trim (V1002) + " " +  trim( V1400 ) format "X(50)"  if trim( V1500 ) = "" then " - " else """" + trim(V1500) + """"  format "X(50)" skip
"." skip
"Y" skip
"Y" skip
"-" skip
"-" skip
"."
     with fram finput no-box no-labels width 200.
output close.

input from value ( usection + ".i") .
output to  value ( usection + ".o") .
        {gprun.i ""sosois.p""}
input close.
output close.
ciminputfile = usection + ".i".
cimoutputfile = usection + ".o".
{xserrlg.i}
unix silent value ( "rm -f "  + Trim(usection) + ".i").
unix silent value ( "rm -f "  + Trim(usection) + ".o").
