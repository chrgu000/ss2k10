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

usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "inv42" .
output to value( trim(usection) + ".i") .
              If V1605 = "" THEN put  trim ( V1607)    format "x(50)" skip .
      Else put  trim ( V1605)    format "x(50)" skip .
         
      If V1605 = "" OR ( V1605 <> "" AND  V1608 = "B" ) then do:
         Find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
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
        {gprun.i ""pitcmt9.p""}
input close.
output close.
ciminputfile = usection + ".i".
cimoutputfile = usection + ".o".
{xserrlg.i}
unix silent value ( "rm -f "  + Trim(usection) + ".i").
unix silent value ( "rm -f "  + Trim(usection) + ".o").
