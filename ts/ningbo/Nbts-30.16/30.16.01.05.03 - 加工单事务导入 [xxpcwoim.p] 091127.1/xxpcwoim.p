/* SS - 091127.1 By: Bill Jiang */

/* SS - 091127.1 - RNB
[091127.1]

输入文件顺序包括以下列:
  - 地点
  - 年份
  - 期间
  - 零件
  - 工单
  - 期末数量

以上特别说明的除外,如果使用缺省值或保留现行值,请用"-"表示

请特别留意日期类型的列,其格式应与当前用户保持一致,否则将会出错

可用问号"?"表示空的日期

如果出错,则输出错误记录及其错误描述;同时输出执行成功的记录数

导入后最好再导出并核对无误

另请参见
  - 加工单事务导出 [xxpcwoe.p]

[091127.1]

SS - 091127.1 - E */

{mfdtitle.i "091127.1"}
{pxmaint.i}

{xxcimimp.i "new"}

/* LOCAL VARIABLES */
define variable directory as character format "x(45)" no-undo.
DEFINE VARIABLE c1 AS CHARACTER.
DEFINE VARIABLE i1 AS INTEGER.
define variable infile as character format "x(55)" no-undo.

define variable update_yn like mfc_logical no-undo.

/* SELECTION FORM: FRAME A */
form
   directory     colon 30 label "Import Directory"
   log_directory     colon 30 label "Log Directory"
   remote_options     colon 30 label "Remote Options"
   temporary_directory     colon 30 label "Temporary Directory"
   file_prefix     colon 30 label "File Prefix"
   audit_trail     colon 30 label "Audit Trail"
   allow_errors     colon 30 label "Allow Errors"
   filename      colon 30 label "Import File Name"
   include_header     colon 30 label "Include Header"
   field_DELIMITER     colon 30 label "Delimiter"
   delete_options     colon 30 label "Delete Options"
   skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{gprun.i ""xxcimpwd.p"" "(
   OUTPUT current_DIRECTORY
   )"}

DIRECTORY = "".
{xxcimcode.i ""CIM_Remote_Options"" remote_options ""N""}
IF REMOTE_options = "Y" THEN DO:
   {xxcimcode.i ""CIM_FTP_Get_Directory"" DIRECTORY """"}
   {xxcimcode.i ""CIM_FTP_Put_Directory"" log_DIRECTORY """"}
END.
ELSE DO:
   {xxcimcode.i ""CIM_Import_Directory"" DIRECTORY CURRENT_directory}
   {xxcimcode.i ""CIM_Log_Directory"" log_DIRECTORY CURRENT_directory}
END.
{xxcimcode.i ""CIM_Temporary_Directory"" temporary_DIRECTORY CURRENT_directory}
{xxcimcode.i ""CIM_File_Prefix"" FILE_prefix ""TMPCIM""}
{xxcimcode.i ""CIM_Audit_Trail"" audit_trail ""E""}
{xxcimcode.i ""CIM_Allow_Errors"" allow_errors ""N""}
{xxcimcode.i ""CIM_Delete_Options"" delete_options ""A""}
{xxcimcode.i ""CIM_Include_Header"" include_header ""Y""}
{xxcimcode.i ""CIM_Delimiter"" FIELD_delimiter ""T""}

repeat:

   empty temp-table tt1 no-error.

   update
      directory
      log_directory
      remote_options
      temporary_directory
      file_prefix
      audit_trail
      allow_errors
      filename
      include_header
      field_delimiter
      delete_options
   with frame a.

   /* DETERMINE INPUT DIRECTORY AND FILENAME */
   {gpdirpre.i}
   if directory <> "" and
      substring(directory,length(directory),1) = dir_prefix THEN DO:
      DIRECTORY = substring(directory,1,length(directory) - 1).
      DISPLAY DIRECTORY WITH FRAME a.
   END.
   if log_directory <> "" and
      substring(log_directory,length(log_directory),1) = dir_prefix THEN DO:
      log_DIRECTORY = substring(log_directory,1,length(log_directory) - 1).
      DISPLAY log_DIRECTORY WITH FRAME a.
   END.
   if temporary_directory <> "" and
      substring(temporary_directory,length(temporary_directory),1) = dir_prefix THEN DO:
      temporary_DIRECTORY = substring(temporary_directory,1,length(temporary_directory) - 1).
      DISPLAY temporary_DIRECTORY WITH FRAME a.
   END.

   /* 获得远程文件 */
   IF remote_options = "Y" THEN DO:
      {gprun.i ""xxcimget.p"" "(
         INPUT FILENAME,
         INPUT DIRECTORY,
         INPUT temporary_directory,
         OUTPUT ftp_filename
         )"}

      IF ftp_filename = "" THEN DO:
         next-prompt filename with frame a.
         undo, retry.
      END.

      /* 不保存审计线索 */
      IF INDEX("N",audit_trail) <> 0 THEN DO:
         OS-DELETE VALUE(ftp_filename).
         OS-DELETE VALUE(ftp_filename + ".log").
      END.

      /* 如果发现错误,则保存审计线索 - 在远程 */
      ELSE IF INDEX("E",audit_trail) <> 0 THEN DO:
         IF temporary_directory <> "" THEN DO:
            c1 = temporary_directory + DIR_prefix + FILENAME.
         END.
         ELSE DO:
            c1 = FILENAME.
         END.

         IF SEARCH(c1) <> ? THEN DO:
            OS-DELETE VALUE(ftp_filename).
            OS-DELETE VALUE(ftp_filename + ".log").
         END.
         ELSE DO:
            {gprun.i ""xxcimput.p"" "(
               INPUT ftp_filename,
               INPUT LOG_directory,
               INPUT temporary_directory,
               INPUT audit_trail
               )"}
            {gprun.i ""xxcimput.p"" "(
               INPUT (ftp_filename + '.log'),
               INPUT LOG_directory,
               INPUT temporary_directory,
               INPUT audit_trail
               )"}

            /* 删除临时文件 */
            OS-DELETE VALUE(ftp_filename).
            OS-DELETE VALUE(ftp_filename + ".log").
         END.
      END. /* ELSE IF INDEX("E",audit_trail) <> 0 THEN DO: */

      /* 始终保存审计线索 - 在远程 */
      ELSE DO:
         {gprun.i ""xxcimput.p"" "(
            INPUT ftp_filename,
            INPUT LOG_directory,
            INPUT temporary_directory,
            INPUT audit_trail
            )"}
         {gprun.i ""xxcimput.p"" "(
            INPUT (ftp_filename + '.log'),
            INPUT LOG_directory,
            INPUT temporary_directory,
            INPUT audit_trail
            )"}

         /* 删除临时文件 */
         OS-DELETE VALUE(ftp_filename).
         OS-DELETE VALUE(ftp_filename + ".log").
      END. /* ELSE DO: */
      infile = temporary_directory + dir_prefix + FILENAME.
   END. /* IF remote_options = "Y" THEN DO: */
   ELSE DO:
      infile = directory + dir_prefix + filename.
   END.

   HIDE ALL NO-PAUSE.
   VIEW FRAME dtitle.

   if search (infile) = ? then do:
      /* FILE DOES NOT EXIST */
      {pxmsg.i &MSGNUM=53 &ERRORLEVEL={&APP-ERROR-RESULT}}
      next-prompt filename with frame a.
      undo, retry.
   end.

   {xxSoftspeedLic.i "SoftspeedPC.lic" "SoftspeedPC"}

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   {mfphead.i}

   EMPTY TEMP-TABLE tt1.

   /* LOAD THE TEMP TABLE */

   input from value(search(infile)).

   /* PROCESS IMPORT FILE */
   i1 = 1.
   repeat:
      CREATE tt1.
      IF FIELD_delimiter = "T" THEN DO:
         import delimiter "~011" tt1 NO-ERROR.
      END.
      ELSE IF FIELD_delimiter = "," THEN DO:
         import delimiter "," tt1 NO-ERROR.
      END.
      ELSE IF FIELD_delimiter = ";" THEN DO:
         import delimiter ";" tt1 NO-ERROR.
      END.
      ELSE DO:
         import delimiter " " tt1 NO-ERROR.
      END.

      ASSIGN
         tt1_line = i1
         i1 = i1 + 1
         .

      /*ORACLE STD */
      if recid(tt1) = -1 then .
   end.  /* repeat */

   INPUT CLOSE.
   EMPTY TEMP-TABLE tt0.
   input from value(search(infile)).
   i1 = 1.
   REPEAT:
      CREATE tt0.
      IMPORT UNFORMATTED tt0_c1 NO-ERROR.
      ASSIGN
         tt0_line = i1
         i1 = i1 + 1
         .
      /*ORACLE STD */
      if recid(tt1) = -1 then .
   END.
   INPUT CLOSE.

   /* 导入 */
   if can-find (first tt1) then do:
      cim_filename = SUBSTRING(execname, 1, LENGTH(execname) - LENGTH(".p")) + "a.p".
      {gprun.i cim_filename}.
   end.

   /* 始终删除源文件 */
   IF delete_options = "Y" THEN DO:
      OS-DELETE VALUE(infile).
   END.
   /* 如果没有发现错误,则删除源文件 */
   ELSE IF delete_options = "A" THEN DO:
      FIND FIRST tt0 WHERE tt0_error <> "" NO-LOCK NO-ERROR.
      IF NOT AVAILABLE tt1 THEN DO:
         OS-DELETE VALUE(infile).
      END.
   END.

   {mfrtrail.i}.
end. /* REPEAT */
