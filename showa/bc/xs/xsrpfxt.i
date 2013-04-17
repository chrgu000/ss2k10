/* Create MFG/PRO Execte File Path  START */
/*
define variable global_user_lang_dir as char format "x(40)" init "/app/mfgpro/eb2/ch/".
define shared variable global_gblmgr_handle as handle no-undo.
define variable ciminputfile   as char .
define variable cimoutputfile  as char .
*/

run pxgblmgr.p persistent set global_gblmgr_handle.
/* Create MFG/PRO Execte File Path   END  */

find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="global_user_lang_dir" no-lock no-error. /*  Update MFG/PRO Directory */
if AVAILABLE(code_mstr) Then global_user_lang_dir = trim ( code_cmmt ).
if substring(global_user_lang_dir, length(global_user_lang_dir), 1) <> "/" then 
 global_user_lang_dir = global_user_lang_dir + "/".
/* Create LOGIN MFG/PRO USER ID START */
/* Create LOGIN MFG/PRO USER ID END */
/* Create Section Variable START */

/*
define variable usection as char format "x(16)".
/* Create Section Variable END */

*/

eff_date = v1004.
eff_time = v1005.

DEFINE VARIABLE vv_ii   AS INTEGER.
/*    
 v_due_date1 = string(YEAR(eff_date),"9999") + "-" 
               + string(MONTH(eff_date),"99")
               + "-" +  string(DAY(eff_date),"99").
*/
 vv_ii = 1.
 FOR EACH xxsod_det WHERE xxsod_due_date1 = eff_date
                          AND  xxsod_due_time1 = eff_time
                          AND  xxsod_cust = V1003
                          NO-LOCK:

   FIND FIRST cp_mstr WHERE cp_cust = xxsod_cust AND cp_cust_part = xxsod_part NO-LOCK NO-ERROR.
   IF AVAIL cp_mstr THEN DO:
   
     CREATE ttsod_det.
     ASSIGN ttsod_year = SUBSTRING(eff_date,1,4)
            ttsod_month = SUBSTRING(eff_date,6,2)
            ttsod_day   = SUBSTRING(eff_date,9,2)
            ttsod_time  = eff_time
            ttsod_seq   = string(vv_ii)
            ttsod_part  = cp_part
            ttsod_qty   = STRING(xxsod_qty_ord) + "/" + STRING(xxsod__dec01)
            .
            
    vv_ii = 1 + vv_ii.    
   END.
 END.

