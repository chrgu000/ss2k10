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
   INPUT 'pt_mstr'
   )"}
id = 0.
indent = 3.
for each pt_mstr where (pt_part >= iptf1 or iptf1 = "")
   and (pt_part <= iptf11 or iptf11 = "") no-lock:
   	
   idrec = RECID(pt_mstr).

   {gprun.i ""xxscpt_mstr.p"" "(
      INPUT-OUTPUT id,
      INPUT idrec,
      INPUT indent
      )"}

END.

/* </table> */
{gprun.i ""xxsccomCreateSendCommandData3e.p""}

/* </datas> */
{gprun.i ""xxsccomCreateSendCommandData2e.p""}
/* </root> */
{gprun.i ""xxsccomCreateSendCommandData1e.p""}
