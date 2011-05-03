/* SS - 090906.1 By: Bill Jiang */

{mfdeclre.i}

DEFINE INPUT PARAMETER VALUE_code LIKE CODE_value.
DEFINE OUTPUT PARAMETER FIND_can AS LOGICAL.

FIND FIRST code_mstr
   WHERE code_mstr.CODE_fldname = "SoftspeedSCM.XML"
   AND CODE_cmmt = VALUE_code
   NO-LOCK NO-ERROR.
find_can = AVAILABLE code_mstr.
