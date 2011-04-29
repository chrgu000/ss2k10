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

usection = "por02" + '-' + "poporc.p" + '-' + substring(string(year(TODAY)),3,2) + string(MONTH(TODAY),'99') + string(DAY(TODAY),'99') + '-' + entry(1,STRING(TIME,'hh:mm:ss'),':') + entry(2,STRING(TIME,'hh:mm:ss'),':') + entry(3,STRING(TIME,'hh:mm:ss'),':') + '-' + trim(string(RANDOM(1,100)))  .
output to value( trim(usection) + ".i") .
        PUT  UNFORMATTED   trim ( V1100 )  format "x(50)"  skip .

PUT  UNFORMATTED """" + trim ( V1050 ) + """"  format "x(50)" " - " + V1203 +  " N N N " format "x(50)" skip .

If trim( V1101 ) <> trim ( V1102 ) and V1103 = "N"  then put UNFORMATTED skip(1) .

For each usrw_wkfl where usrw_key1 = V1105 and usrw_charfld[3] <> "0"  :

PUT  UNFORMATTED trim ( usrw_key2 )  format "x(50)" skip .
PUT  UNFORMATTED trim ( usrw_charfld[3] ) + " - N - - - " + trim (V1002) + " " +  trim( usrw_charfld[2] )  format "X(50)"  .
If trim( usrw_charfld[4] ) = "" then PUT  UNFORMATTED " - " skip . 
Else PUT  UNFORMATTED """" + trim( usrw_charfld[8] ) + """" + " - - N N N "  format "X(50)" skip .

If usrw_charfld[5] <> "" then do: /* Subcontract PO */
Find first wr_rout where wr_lot  = usrw_charfld[5] and string ( wr_op ) = usrw_charfld[6] no-lock no-error.
If NOT AVAILABLE (wr_rout) then Put "N" skip.
End.

End.
PUT  UNFORMATTED "." skip .
PUT  UNFORMATTED "." .
{xspocmt02.i}
Batchrun = yes .
output close.

input from value ( usection + ".i") .
output to  value ( usection + ".o") .
        {gprun.i ""poporc.p""}
input close.
output close.
ciminputfile = usection + ".i".
cimoutputfile = usection + ".o".
{xserrlg.i}
if v_cimload_ok = yes then do:
    unix silent value ( "rm -f "  + Trim(usection) + ".i").
    unix silent value ( "rm -f "  + Trim(usection) + ".o").
end.
