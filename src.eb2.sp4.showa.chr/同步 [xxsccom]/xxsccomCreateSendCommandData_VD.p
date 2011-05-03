/* SS - 090917.1 By: Bill Jiang */
/* SS - 090917.1 By: Neil Gao */

{mfdeclre.i}

DEFINE INPUT PARAMETER iptf1 AS CHARACTER.
DEFINE INPUT PARAMETER iptf11 AS CHARACTER.
DEFINE INPUT PARAMETER functionName AS CHARACTER.
DEFINE INPUT-OUTPUT PARAMETER requestFileName AS CHARACTER.

DEFINE VARIABLE id AS INTEGER.
DEFINE VARIABLE idrec AS RECID.
DEFINE VARIABLE indent AS INTEGER.

IF requestFileName = "" THEN DO:
   {gprun.i ""xxsccomGetRequestFileName.p"" "(
      OUTPUT requestFileName
      )"}
END.

OUTPUT TO VALUE(requestFileName).

/* <root> */
{gprun.i ""xxsccomCreateSendCommandData1b.p""}
/* <datas> */
{gprun.i ""xxsccomCreateSendCommandData2b.p""}

/* <table> */
{gprun.i ""xxsccomCreateSendCommandData3b.p"" "(
   INPUT 'vd_mstr'
   )"}
id = 0.
indent = 3.
for each vd_mstr where (vd_addr >= iptf1 or iptf1 = "")
   and (vd_addr <= iptf11 or iptf11 = "") no-lock:
   	
   idrec = RECID(vd_mstr).

   {gprun.i ""xxscvd_mstr.p"" "(
      INPUT-OUTPUT id,
      INPUT idrec,
      INPUT indent
      )"}

END.

/* </table> */
{gprun.i ""xxsccomCreateSendCommandData3e.p""}

/* <table> */
{gprun.i ""xxsccomCreateSendCommandData3b.p"" "(
   INPUT 'ad_mstr'
   )"}
id = 0.
indent = 3.
for each vd_mstr where (vd_addr >= iptf1 or iptf1 = "")
   and (vd_addr <= iptf11 or iptf11 = "") no-lock:

   FOR EACH ad_mstr NO-LOCK
      WHERE ad_addr  = vd_addr
      :
   
      idrec = RECID(ad_mstr).

      {gprun.i ""xxscad_mstr.p"" "(
         INPUT-OUTPUT id,
         INPUT idrec,
         INPUT indent
         )"}
   END.
END.
/* </table> */
{gprun.i ""xxsccomCreateSendCommandData3e.p""}

/* </datas> */
{gprun.i ""xxsccomCreateSendCommandData2e.p""}
/* </root> */
{gprun.i ""xxsccomCreateSendCommandData1e.p""}
