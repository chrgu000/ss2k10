/* REVISION: 9.1      LAST MODIFIED: 09/12/05 BY: *SS - 20050912* Bill Jiang      */

/* SS - 20050912 - B */
PUT UNFORMATTED "ExecutionFile" ";" "{&ExecutionFile}" SKIP.
PUT UNFORMATTED "ExcelFile" ";" "{&ExcelFile}" SKIP.
PUT UNFORMATTED "SaveFile" ";" "{&SaveFile}" SKIP.
IF "{&CenterHeader1}" <> "" THEN
    PUT UNFORMATTED "CenterHeader" ";" "{&CenterHeader1}" SKIP.
IF "{&CenterHeader2}" <> "" THEN
    PUT UNFORMATTED "CenterHeader" ";" "{&CenterHeader2}" SKIP.
IF "{&CenterHeader3}" <> "" THEN
    PUT UNFORMATTED "CenterHeader" ";" "{&CenterHeader3}" SKIP.
PUT UNFORMATTED "PrintPreview" ";" "{&PrintPreview}" SKIP.
PUT UNFORMATTED "ActiveSheet" ";" "{&ActiveSheet}" SKIP.
PUT UNFORMATTED "Format" ";" "{&Format}" SKIP.
/* SS - 20050912 - E */
