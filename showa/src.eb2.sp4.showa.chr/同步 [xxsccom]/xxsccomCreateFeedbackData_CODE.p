/* SS - 090917.1 By: Bill Jiang */
/* SS - 090917.1 By: Neil Gao */

{mfdeclre.i}

DEFINE INPUT PARAMETER nbr AS CHARACTER.
DEFINE INPUT PARAMETER nbr1 AS CHARACTER.

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
{gprun.i ""xxsccomCreateFeedbackData2b.p""}

/* <table> */
{gprun.i ""xxsccomCreateSendCommandData3b.p"" "(
   INPUT 'code_mstr'
   )"}
id = 0.
indent = 3.

for each code_mstr where (code_fldname >= nbr or nbr = "")
   and (code_fldname <= nbr1 or nbr1 = "") no-lock:
   
   idrec = RECID(code_mstr).

   {gprun.i ""xxsccode_mstr.p"" "(
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
