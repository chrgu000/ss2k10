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

usection = "TMP.xswoi13.p." + execname + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))).
output stream bf to value( trim(usection) + ".bpi") .
/*****140109.1 Start
 *         display
 * "- " + trim ( V1110 ) format "x(50)" " - " + V1203 +  " N N " format "x(50)" skip
 * trim ( V1300) format "x(50)" skip
 * trim ( V1600 ) + " - - " + trim (V1002) + " " +  trim( V1400 ) format "X(50)"  if trim( V1500 ) = "" then " - " else """" + trim(V1500) + """"  format "X(50)" skip
 * "." skip
 * "Y" skip
 * "Y" skip
 * "."
 *      with fram finput no-box no-labels width 200.
 ******140109.1 End */
put stream bf unformat '- "' trim(V1110) '" - ' v1203 ' N N' skip.
put stream bf unformat '"' trim (V1300) '"' skip.
put stream bf unformat trim(v1600) ' - - "' trim (V1002) '" "' trim(v1400) '" "' trim(v1500) '"' skip.
put stream bf unformat '.' skip.
put stream bf unformat 'Y' skip.
put stream bf unformat 'Y' skip.
put stream bf unformat '.' skip.
output stream bf close.

input from value(usection + ".bpi").
output to  value(usection + ".bpo").
batchrun = yes.
{gprun.i ""wowois.p""}
batchrun = no.
input close.
output close.
ciminputfile = usection + ".bpi".
cimoutputfile = usection + ".bpo".
{xserrlg.i}
os-delete value(usection + ".bpi").
os-delete value(usection + ".bpo").
