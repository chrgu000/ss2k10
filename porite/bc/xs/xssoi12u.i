/* Create MFG/PRO Execte File Path  START */
define variable global_user_lang_dir as char format "x(40)" init "/app/mfgpro/eb2/us/".
define shared variable global_gblmgr_handle as handle no-undo.
define variable ciminputfile   as char .
define variable cimoutputfile  as char .
define variable olddtfmt as char.
define stream bf1.
run pxgblmgr.p persistent set global_gblmgr_handle.
/* Create MFG/PRO Execte File Path   END  */
olddtfmt = session:date-format.
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="global_user_lang_dir" no-lock no-error. /*  Update MFG/PRO Directory */
if AVAILABLE(code_mstr) Then global_user_lang_dir = trim ( code_cmmt ).
if substring(global_user_lang_dir, length(global_user_lang_dir), 1) <> "/" then 
 global_user_lang_dir = global_user_lang_dir + "/".
/* Create LOGIN MFG/PRO USER ID START */
/* Create LOGIN MFG/PRO USER ID END */
/* Create Section Variable START */
define variable usection as char format "x(16)".
/* Create Section Variable END */
session:date-format = 'mdy'.
/************
usection = "TMP_xssoi12.p_" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + ".prn" .
output to value( trim(usection) + ".i") .
        mfguser = v1300.
        put unformat '"' V1100 '" ' V1010 skip.
        put unformat V1110 skip.
        put unformat '- - "' V1003 '" - - Y' skip.
        for each tmplot no-lock:
            put unformat '- "' V1003 '" "' tmplot.lot '"' skip.
            put unformat trim(string(tmplot.qty)) skip.
        end.
        put unformat '.' skip '.' skip '.' skip 'n' skip 'y' skip '-' skip '-' skip '.' skip.
output close.

input from value ( usection + ".i") .
output to  value ( usection + ".o") .
        {gprun.i ""sosois.p""}
input close.
output close.
************/

for each tmplot no-lock:
usection = "TMP_xssoi12.p_" + trim(string(tmplot.sn)) + "_" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + ".prn" .
output stream bf1 to value(trim(usection) + ".i") .
put stream bf1 unformat '"' V1100 '" ' V1010 skip.
put stream bf1 unformat V1110 skip.
put stream bf1 unformat trim(string(tmplot.qty)) ' - "' V1003 '" "' tmplot.lot '"' skip.
put stream bf1 unformat '.' skip 'n' skip 'y' skip '-' skip '-' skip '.' skip.
output stream bf1 close.
input from value ( usection + ".i") .
output to  value ( usection + ".o") .
        {gprun.i ""sosois.p""}
input close.
output close.
os-delete value ( usection + ".i").
os-delete value ( usection + ".o").
end.
session:date-format = olddtfmt.
/*
for each tmplot exclusive-lock:
    find first tr_hist no-lock use-index (tr_part_trn )
         where tr_domain = V1001 and tr_part = ENTRY(1, V1200, "@") and tr_trnbr   > integer(trrecid)
           and tr_type = "iss-so" and tr_serial = tmplot.lot and tr_qty_loc = -1 * tmplot.qty no-error.
    if available tr_hist then do:
       assign tmplot.trnbr = tr_trnbr.
    end.
end.
*/


