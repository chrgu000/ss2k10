/* Create MFG/PRO Execte File Path  START */
define variable global_user_lang_dir as char format "x(40)" init "/app/mfgpro/eb2/ch/".
define shared variable global_gblmgr_handle as handle no-undo.
define variable ciminputfile   as char .
define variable cimoutputfile  as char .
define variable vv_loc_status as character.
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
/* 不可用库存如果检验合格的话库存调拨时修改为可用状态。 */
assign vv_loc_status = 'Y - N '.
find first ld_det no-lock where ld_site = V1002 and ld_loc = V1510 and ld_part = V1300 and ld_lot = V1500 no-error.
if availabl ld_det then do:
   find first is_mstr no-lock where is_status = ld_status no-error.
   if available is_mstr and is_avail = no then do:
      find first xxmqc_det no-lock where xxmqc_part = ld_part and xxmqc_serial = ld_lot and xxmqc_status = "1" no-error.
      if available xxmqc_det then do:
         assign vv_loc_status = "Y-Y-N".
      end.
      else do:
         assign vv_loc_status = ld_status.
      end.
   end.
   else do:
         assign vv_loc_status = ld_status.
   end.
end. /* if availabl ld_det then do: */
usection ="xsictr68." + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))).
output to value( trim(usection) + ".bpi") .
        display
"""" + trim ( V1300) + """" format "x(50)" skip
trim ( V1600 ) + " - " + """" + trim ( V1100 ) + """"  + " - " + """" + trim ( V1305 ) + """"   format "x(50)" skip
vv_loc_status format "x(50)" skip
trim(V1002) + " " +  trim( V1510 ) format "X(50)"  if trim( V1500 ) = "" then " - " else """" + trim(V1500) + """"  format "X(50)" skip
trim(V1002) + " "  + trim( V1520 ) format "x(50)" skip
"Y" skip
"." skip
"."
     with fram finput no-box no-labels width 200.
output close.

input from value ( usection + ".bpi") .
output to  value ( usection + ".bpo") .
        {gprun.i ""iclotr04.p""}
input close.
output close.
ciminputfile = usection + ".bpi".
cimoutputfile = usection + ".bpo".
{xserrlg.i}
/* ss - 090910.1 -b
unix silent value ( "rm -f "  + Trim(usection) + ".i").
unix silent value ( "rm -f "  + Trim(usection) + ".o").
 ss - 0900910.1 -e */