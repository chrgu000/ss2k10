/* Create MFG/PRO Execte File Path  START */
define variable ciminputfile   as char .
define variable cimoutputfile  as char .
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

usection = "inv23" + '-' + "iclotr04.p" + '-' + substring(string(year(TODAY)),3,2) + string(MONTH(TODAY),'99') + string(DAY(TODAY),'99') + '-' + entry(1,STRING(TIME,'hh:mm:ss'),':') + entry(2,STRING(TIME,'hh:mm:ss'),':') + entry(3,STRING(TIME,'hh:mm:ss'),':') + '-' + trim(string(RANDOM(1,100)))  .
output to value( trim(usection) + ".i") .
        display 
trim ( V1300) format "x(50)" skip
trim ( V1600 ) + " - " + """" + trim ( V1100 ) + """" format "x(50)" skip
"Y T Y" format "x(50)" skip
trim(V1002) + " " +  trim( V1510 ) format "X(50)"  if trim( V1500 ) = "" then " - " else """" + trim(V1500) + """"  format "X(50)" skip
trim(V1002) + " "  + trim( V1520 ) format "x(50)" skip
"Y" skip
"." skip
"."
     with fram finput no-box no-labels width 200.
output close.

input from value ( usection + ".i") .
output to  value ( usection + ".o") .
        {gprun.i ""iclotr04.p""}
input close.
output close.
ciminputfile = usection + ".i".
cimoutputfile = usection + ".o".
{xserrlg.i}
if v_cimload_ok = yes then do:
    unix silent value ( "rm -f "  + Trim(usection) + ".i").
    unix silent value ( "rm -f "  + Trim(usection) + ".o").
end.
