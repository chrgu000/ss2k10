/* Create MFG/PRO Execte File Path  START */
{mfdeclre.i}
/* define variable global_user_lang_dir as char format "x(40)" init "/mfgpro/eb/us/". */
/* define shared variable global_gblmgr_handle as handle no-undo.                     */
define variable ciminputfile   as char .
define variable cimoutputfile  as char .
define stream bf.
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

usection = "TMP.xsinv25.p." + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))).
output stream bf to value( trim(usection) + ".bpi") .
/***
        display
trim ( V1300) format "x(50)" skip
trim ( V1600 ) + " - - " + trim(V1002) + " " +  trim( V1400 ) format "X(50)"  if trim( V1500 ) = "" then " - " else """" + trim(V1500) + """"  format "X(50)" skip
"""" + trim ( V1100 ) + """" + " - - - " + """" + trim( V1200 ) + """" format "x(50)" skip
"Y" skip
"."
     with fram finput no-box no-labels width 200.
***/
put stream bf unformat '"' trim(v1300) '"' skip.
put stream bf unformat trim(v1600) ' - - "' trim(v1002) '" "' trim(v1400) '" ' .
if trim(v1500) = "" then put stream bf unformat '-' skip.
                    else put stream bf unformat '"' trim(v1500) '"' skip.
put stream bf unformat '"' trim(v1100) '" - - - "' trim(v1200) '" - '.
find first yyrsn_ref where yyrsn_ref.yyrsn_type = v1240
               and yyrsn_ref.yyrsn_code = v1200 no-lock no-error.
if available yyrsn_ref then do:
   put stream bf unformat '"' yyrsn_ref.yy_ac_code '" "' yyrsn_ref.yy_sb_sub '" "' v1240 '"'.
end.
put stream bf unformat skip.
put stream bf unformat 'Y' skip.
output stream bf close.

input from value ( usection + ".bpi") .
output to  value ( usection + ".bpo") .
        batchrun = yes.
        {gprun.i ""icunis.p""}
        batchrun = no.
input close.
output close.
ciminputfile = usection + ".bpi".
cimoutputfile = usection + ".bpo".
{xserrlg.i}
os-delete value( trim(usection) + ".bpi") .
os-delete value( trim(usection) + ".bpo") .
