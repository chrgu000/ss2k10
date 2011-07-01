/* SS - 110318.1 By: Kaine Zhang */


find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" + {2} no-lock no-error. /*  Timeout - Program Level */
if not(available(code_mstr)) then
    find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */

if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt) no-error.

