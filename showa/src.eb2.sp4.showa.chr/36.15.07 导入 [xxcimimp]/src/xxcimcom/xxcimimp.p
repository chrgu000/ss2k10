/* kbsmwbim.p - DATA IMPORT OF A DELIMITED FILE FROM SUPERMARKET WORKBENCH    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.11 $                                                          */
/*                                                                            */
/*----------------------------------------------------------------------------
  Purpose:  This program is used to import kanban loop data that has been
            maniputated from an outside application.  This program is
            expecting a comma-delimited file.  The program updates the
            kanban tables.

  Notes:
------------------------------------------------------------------------------*/
/*                                                                            */
/* Revision: 1.6  BY: Patrick Rowan DATE: 11/20/02 ECO: *P0M4* */
/* Revision: 1.8  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/* Revision: 1.9  BY: Julie Milligan     DATE: 03/17/04  ECO: *P1TM* */
/* Revision: 1.10    BY: Sukhad Kulkarni   DATE: 09/06/04   ECO: *P2J8* */
/* $Revision: 1.11 $   BY: Shoma Salgaonkar  DATE: 09/30/04   ECO: *P2MJ* */
/*-Revision end---------------------------------------------------------------*/

/*                                                                            */
/*V8:ConvertMode=Report                                                       */
/*                                                                            */

/* SS - 081222.1 By: Bill Jiang */

/* SS - 081222.1 - B */
/*
CIM Data Load
*/
/* SS - 081222.1 - E */

/*
{mfdtitle.i "1+ "}
*/
{mfdtitle.i "081222.1"}

/* PREPROCESSOR USED FOR REPORT'S WITH SIMULATION OPTION */
&SCOPED-DEFINE simulation true

{pxmaint.i}

/* LOCAL VARIABLES */
define variable directory as character format "x(45)" no-undo.
/* SS - 081222.1 - B */
/*
define variable filename as character format "x(20)" no-undo.
*/
DEFINE VARIABLE c1 AS CHARACTER.
DEFINE VARIABLE i1 AS INTEGER.
/* SS - 081222.1 - E */
define variable update_yn like mfc_logical no-undo.
define variable continue_yn as logical no-undo.
define variable bSupermarketWB_directory as character format "x(45)" no-undo.
define variable infile as character format "x(55)" no-undo.
define variable dummy_output as character no-undo.
define variable header_code as character initial "Supermarket Workbench"
                                         no-undo.
define stream datain.
{kbsmwb.i}

/* IMPORT FILE */
define variable input_knb_primary_key as character format "x(20)" no-undo.
define variable input_buffer_maximum as character format "x(20)" no-undo.

/* CONSTANTS */
{kbconst.i}

/* HANDLES */
{pxphdef.i gplngxr}

/* SS - 081222.1 - B */
{xxcimimp.i "new"}
/* SS - 081222.1 - E */

/* FUNCTIONS */
FUNCTION ConvStringDec RETURNS DECIMAL
            (input decimal-in as character) forward.

/* SELECTION FORM: FRAME A */
form
   directory     colon 30 label "Import Directory"
   log_directory     colon 30 label "Log Directory"
   /* SS - 081222.1 - B */
   remote_options     colon 30 label "Remote Options"
   temporary_directory     colon 30 label "Temporary Directory"
   file_prefix     colon 30 label "File Prefix"
   audit_trail     colon 30 label "Audit Trail"
   allow_errors     colon 30 label "Allow Errors"
   /* SS - 081222.1 - E */
   filename      colon 30 label "Import File Name"
   /* SS - 081222.1 - B */
   include_header     colon 30 label "Include Header"
   field_DELIMITER     colon 30 label "Delimiter"
   delete_options     colon 30 label "Delete Options"
   /* SS - 081222.1 - E */
   skip(1)
   /* SS - 081222.1 - B */
   /*
   update_yn     colon 30 label "Update"
   */
   /* SS - 081222.1 - E */
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


for first kbc_ctrl  no-lock:
   directory  = kbc_import_directory.
end.

/* SS - 081222.1 - B */
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
/* SS - 081222.1 - E */

repeat:

   /* HOUSEKEEPING - DELETE WORK TABLES */
   empty temp-table bSupermarketWB no-error.

   /* SS - 081222.1 - B */
   empty temp-table tt1 no-error.
   /* SS - 081222.1 - E */

   update
      directory
      /* SS - 081222.1 - B */
      log_directory
      remote_options
      temporary_directory
      file_prefix
      audit_trail
      allow_errors
      /* SS - 081222.1 - E */
      filename
      /* SS - 081222.1 - B */
      include_header
      field_delimiter
      delete_options
      /*
      update_yn
      */
      /* SS - 081222.1 - E */
   with frame a.


   /* DETERMINE INPUT DIRECTORY AND FILENAME */
   {gpdirpre.i}
   /* SS - 081222.1 - B */
   /*
   if directory <> "" and
      substring(directory,length(directory),1) <> dir_prefix then
         bSupermarketWB_directory = directory + dir_prefix.
   else
         bSupermarketWB_directory = directory.
         
   infile = directory + filename.
   */
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
   /* SS - 081222.1 - E */

   if search (infile) = ? then do:
      /* FILE DOES NOT EXIST */
      {pxmsg.i &MSGNUM=53 &ERRORLEVEL={&APP-ERROR-RESULT}}
      next-prompt filename with frame a.
      undo, retry.
   end.

   /* SS - 081222.1 - B */
   /*
   input from value(search(infile)).

   /* VALIDATE HEADER OF IMPORT FILE */
   import delimiter ","
       input_knb_primary_key
       input_buffer_maximum.

   if input_knb_primary_key <> header_code then do:
      /* UNRECOGNIZED DATA IN INPUT FILE */
      {pxmsg.i &MSGNUM=2952 &ERRORLEVEL={&APP-ERROR-RESULT}}
      next-prompt filename with frame a.
      input close.
      undo, retry.
   end.

   input close.
   */
   /* SS - 081222.1 - E */

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

   /* SS - 081222.1 - B */
   EMPTY TEMP-TABLE tt1.
   /* SS - 081222.1 - E */

   /* LOAD THE TEMP TABLE */

   input from value(search(infile)).

   /* PROCESS IMPORT FILE */
   /* SS - 081222.1 - B */
   i1 = 1.
   /* SS - 081222.1 - E */
   repeat:
      /* SS - 081222.1 - B */
      /*
      assign
         input_knb_primary_key  = ""
         input_buffer_maximum   = "".

      import delimiter ","
         input_knb_primary_key
         input_buffer_maximum.

      if input_knb_primary_key = "" or
         input_knb_primary_key = header_code then
            next.

      create bSupermarketWB.

      bSupermarketWB.knb_primary_key =  ConvStringDec(input_knb_primary_key).
      bSupermarketWB.buffer_maximum_revised =
                                        ConvStringDec(input_buffer_maximum).

      /*ORACLE STD */
      if recid(bSupermarketWB) = -1 then .
      */
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
      /* SS - 081222.1 - E */
   end.  /* repeat */

   /* SS - 081222.1 - B */
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
   /*
   /* COMPARE THE REVISED VALUES TO THE DATABASE VALUES AND */
   /* UPDATE THE DATABASE ONLY WHEN A USER ASKS TO UPDATE.  */
   if can-find (first bSupermarketWB) then do:
      {gprun.i ""kbsmwbi1.p""
            "(input-output table tt_smwbfile,
              input-output table tt_reactivate,
              input update_yn,
              output continue_yn)"}.
   end.
   */

   /* 执行CIM数据装入 */
   if can-find (first tt1) then do:
      cim_filename = SUBSTRING(execname, 1, LENGTH(execname) - LENGTH(".p")) + "a.p".
      {gprun.i cim_filename "(
              output continue_yn
         )"}.
   end.

   /* 始终删除源文件 */
   IF delete_options = "Y" THEN DO:
      OS-DELETE VALUE(infile).
   END.
   /* 如果没有发现错误,则删除源文件 */
   ELSE IF delete_options = "A" THEN DO:
      FIND FIRST tt1 WHERE tt1_error <> "" NO-LOCK NO-ERROR.
      IF NOT AVAILABLE tt1 THEN DO:
         OS-DELETE VALUE(infile).
      END.
   END.
   /* SS - 081222.1 - E */

   /* CREATE A REPORT. */
   /* SS - 081222.1 - B */
   /*
   if continue_yn then

      {gprun.i ""kbsmwbi2.p""
            "(input-output table tt_smwbfile,
              input-output table tt_reactivate,
              output continue_yn)"}.
   */
   /* SS - 081222.1 - E */

   {mfrtrail.i}.


   /* ERROR FOUND */
   /* SS - 081222.1 - B */
   /*
   if continue_yn = no then
      undo, retry.
   */
   /* SS - 081222.1 - E */

end. /* REPEAT */


/* ========================================================================= */
/* ***************************** FUNCTIONS ********************************* */
/* ========================================================================= */

/* ========================================================================= */
FUNCTION ConvStringDec RETURNS DECIMAL (input decimal-in as character).
/* -------------------------------------------------------------------------
Purpose:      This function accepts a character string and converts the
              value to a decimal number.
Exceptions:   None
Conditions:
Pre:
Post:
Notes:        If the string is not a valid decimal, then ? is returned.
History:
 --------------------------------------------------------------------------- */

         define variable ii as integer no-undo.
         define variable comma as character initial "," no-undo.
         define variable period as character initial "." no-undo.
         define variable decimal-point as character no-undo.
         define variable thousands as character no-undo.

         if decimal-in = "" then return 0.0.

         if num-entries (decimal-in,"+") - 1 > 1 then return ?.
         if num-entries (decimal-in,"-") - 1 > 1 then return ?.

         assign thousands = comma
            decimal-point = period.

         if session:numeric-format = "european"
         then assign thousands = period
                 decimal-point = comma.

         decimal-in = trim(replace(decimal-in,thousands,"")).
         if num-entries (decimal-in,decimal-point) - 1 > 1 then return ?.

         do ii = 1 to length(decimal-in):

            if can-do("+,-",substring(decimal-in,ii,1))
            and ii <> 1 and ii <> length(decimal-in)
            then return ?.

            if not can-do("0,1,2,3,4,5,6,7,8,9",substring(decimal-in,ii,1))
            and not can-do("+,-",substring(decimal-in,ii,1))
            and substring(decimal-in,ii,1) <> decimal-point
            then return ?.
         end.

         return decimal(decimal-in).

END FUNCTION. /* ConvStringDec */
