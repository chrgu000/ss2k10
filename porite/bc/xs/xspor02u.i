/* Create MFG/PRO Execte File Path  START */
define variable global_user_lang_dir as char format "x(40)" init "/app/mfgpro/eb21sp5/ch/".
define shared variable global_gblmgr_handle as handle no-undo.
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

usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "por02" .
output to value( trim(usection) + ".i") .
        PUT  UNFORMATTED   trim ( V1100 )  format "x(50)"  skip .

PUT  UNFORMATTED """" + trim ( V1200 ) + """"  format "x(50)" " - " + V1203 +  " N N N " format "x(50)" skip .

If trim( V1101 ) <> trim ( V1102 ) and V1103 = "N"  then put UNFORMATTED skip(1) .
Put "-" skip .
PUT  UNFORMATTED trim ( V1205 )  format "x(50)" skip .
PUT  UNFORMATTED trim ( V1600 ) + " - N - - - " trim (V1002) + " " + trim( V1400 )  format "X(50)"  .
If trim( V1500 ) = "" then PUT  UNFORMATTED " - " skip . 
Else PUT  UNFORMATTED """" + trim(V1500) + """" + " - - N N N "  format "X(50)" skip .

Find first wr_rout where wr_domain = V1001 and wr_lot  = V1302 and string ( wr_op ) = V1303 no-lock no-error.
If NOT AVAILABLE (wr_rout) then Put "N" skip.

PUT  UNFORMATTED "." skip .
PUT  UNFORMATTED "Y" skip .
PUT  UNFORMATTED "Y" skip .
PUT  UNFORMATTED "." .
output close.

input from value ( usection + ".i") .
output to  value ( usection + ".o") .
        {gprun.i ""poporc.p""}
input close.
output close.
ciminputfile = usection + ".i".
cimoutputfile = usection + ".o".
{xserrlg.i}
unix silent value ( "rm -f "  + Trim(usection) + ".i").
unix silent value ( "rm -f "  + Trim(usection) + ".o").
