/* SS - 090910.1 By: Bill Jiang */

/* SS - 090910.1 - RNB
[090910.1]

TMP.SoftspeedSCM.YYYYMMDDHHMMSS.999999999

[090910.1]

SS - 090910.1 - RNE */

{mfdeclre.i}
{gplabel.i}

DEFINE OUTPUT PARAMETER ofilename AS CHARACTER.

/* 临时文件前缀 */
FIND FIRST mfc_ctrl
   WHERE mfc_field = "SoftspeedSCM_Request_Prefix"
   NO-LOCK NO-ERROR.
IF NOT AVAILABLE mfc_ctrl THEN DO:
   CREATE mfc_ctrl.
   ASSIGN
      mfc_field = "SoftspeedSCM_Request_Prefix"
      mfc_module = "SoftspeedSCM_Request_Prefix"
      mfc_seq = 1
      mfc_char = "TMP.SoftspeedSCM"
      .
   RELEASE mfc_ctrl.
END.

ofilename = mfc_char.
ofilename = ofilename + "." + STRING(YEAR(TODAY),"9999").
ofilename = ofilename + STRING(MONTH(TODAY),"99").
ofilename = ofilename + STRING(MONTH(TODAY),"99").
ofilename = ofilename + REPLACE(STRING(TIME,"hh:mm:ss"),":","").

/* 临时文件序号 */
FIND FIRST mfc_ctrl
   WHERE mfc_field = "SoftspeedSCM_Request_Next"
   EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE mfc_ctrl THEN DO:
   CREATE mfc_ctrl.
   ASSIGN
      mfc_field = "SoftspeedSCM_Request_Next"
      mfc_module = "SoftspeedSCM_Request_Next"
      mfc_seq = 1
      mfc_integer = 1
      .
END.

ofilename = ofilename + "." + STRING(100000000 + mfc_integer).

ASSIGN
   mfc_integer = mfc_integer + 1
   .
RELEASE mfc_ctrl.

ofilename = ofilename + ".xml".
