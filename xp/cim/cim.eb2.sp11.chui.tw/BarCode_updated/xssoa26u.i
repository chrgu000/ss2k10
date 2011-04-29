/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090630.1 By: Roger Xiao */


/* Create MFG/PRO Execte File Path  START */
define variable global_user_lang_dir as char format "x(40)" init "/mfgpro/eb/us/".
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

/* SS - 090630.1 - B */
find first ld_det 
	where ld_site = v1002
	and   ld_loc  = v1400
	and   ld_part = v1300
	and   ld_lot  = v1500
	and   ld_ref  = ""
no-error.
if not available ld_det then do:
create ld_det.
assign
ld_site = v1002  
ld_loc  = v1400  
ld_part = v1300  
ld_lot  = v1500  
ld_ref  = ""    
ld_qty_oh = 0 .

find first loc_mstr where loc_site = v1002 and loc_loc = v1400 no-lock no-error .
if avail loc_mstr then ld_status = loc_status.


end. /*if not available ld_det*/
/* SS - 090630.1 - E */

usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "soa26" .
output to value( trim(usection) + ".i") .
        display 
trim ( V1300) format "x(50)" skip
trim ( V1600 ) + " - " + """" + trim ( V1100 ) + """" format "x(50)" skip
/* "Y T N SO-ALLOC" format "x(50)" skip */
"Y T Y  " format "x(50)" skip
trim(V1002) + " " +  trim( V1400 ) format "X(50)"  if trim( V1500 ) = "" then " - " else """" + trim(V1500) + """"   format "X(40)" skip
trim(V1002) + " " +  trim( V1400 ) format "X(50)"  if trim( V1500 ) = "" then " - " else """" + trim(V1500) + """"   format "X(40)" """" + trim ( V1003) + """" format "x(20)" skip
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
unix silent value ( "rm -f "  + Trim(usection) + ".i").
unix silent value ( "rm -f "  + Trim(usection) + ".o").

