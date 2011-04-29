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

usection = "inv42" + '-' + "pitcmt1.p" + '-' + substring(string(year(TODAY)),3,2) + string(MONTH(TODAY),'99') + string(DAY(TODAY),'99') + '-' + entry(1,STRING(TIME,'hh:mm:ss'),':') + entry(2,STRING(TIME,'hh:mm:ss'),':') + entry(3,STRING(TIME,'hh:mm:ss'),':') + '-' + trim(string(RANDOM(1,100)))  .
output to value( trim(usection) + ".i") .
              If V1605 = "" THEN put  trim ( V1607)    format "x(50)" skip .
      Else put  trim ( V1605)    format "x(50)" skip .
         
      If V1605 = "" OR ( V1605 <> "" AND  V1608 = "B" ) then do:
         Find first pt_mstr where pt_part = V1300  no-lock no-error.
         Put trim(V1002) skip .
	 Put trim(V1200) skip .
	 Put trim(V1300) + " "  + """"  + trim (V1500)  +  """" format "x(60)" skip .
      End.
      
      
      Put trim ( V1620 ) format "x(18)" skip .
      Put " - " + userid(sdbname('qaddb')) + " " + string ( today )  + " RF-INT-COUNT " format "x(40)" skip .
      Put "." .
output close.

input from value ( usection + ".i") .
output to  value ( usection + ".o") .
        {gprun.i ""pitcmt1.p""}
input close.
output close.
ciminputfile = usection + ".i".
cimoutputfile = usection + ".o".
{xserrlg.i}
if v_cimload_ok = yes then do:
    unix silent value ( "rm -f "  + Trim(usection) + ".i").
    unix silent value ( "rm -f "  + Trim(usection) + ".o").
end.
