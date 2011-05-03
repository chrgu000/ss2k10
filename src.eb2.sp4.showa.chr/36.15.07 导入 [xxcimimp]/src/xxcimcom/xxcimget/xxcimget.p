/* SS - 081222.1 By: Bill Jiang */

/* SS - 081222.1 - B */
/*
1. 生成通过FTP向服务器传输请求文件的命令
2. 改变了当前目录
*/
/* SS - 081222.1 - E */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

DEFINE INPUT PARAMETER sourceFileName AS CHARACTER.
DEFINE INPUT PARAMETER remoteDirName AS CHARACTER.
DEFINE INPUT PARAMETER localDirName AS CHARACTER.
DEFINE OUTPUT PARAMETER ftpFileName AS CHARACTER.

DEFINE VARIABLE comm-line AS CHARACTER.

DEFINE VARIABLE interval AS INTEGER.

/* 生成FTP文件 */
{gprun.i ""xxcimgetCreate.p"" "(
   INPUT sourceFileName,
   INPUT remoteDirName,
   INPUT localDirName,
   INPUT-OUTPUT ftpFileName
   )"}
IF ftpFileName = "" THEN DO:
   LEAVE.
END.

/* 生成响应文件 */
comm-line = "ftp -inv < " + ftpFileName + " > " + ftpFileName + ".log".
/*
FIND FIRST mfc_ctrl WHERE mfc_field = "softspeed_ftp_interval" NO-LOCK NO-ERROR.
IF NOT AVAILABLE mfc_ctrl THEN DO:
   /* Mandatory control field has not been set: */
   {pxmsg.i &MSGNUM=4408 &ERRORLEVEL=3}
   LEAVE.
END.
interval = mfc_integer.

FOR FIRST mfc_ctrl EXCLUSIVE-LOCK 
   WHERE mfc_field = "softspeed_ftp_lasttime":
   REPEAT:
      IF (TIME - mfc_integer) > interval THEN DO:
         LEAVE.
      END.
   END.
   mfc_integer = TIME.
END.
IF NOT AVAILABLE mfc_ctrl THEN DO:
   /* Mandatory control field has not been set: */
   {pxmsg.i &MSGNUM=4408 &ERRORLEVEL=3}
    LEAVE.
END.
*/
os-command silent value(comm-line).

/*
OS-DELETE VALUE(ftpFileName).
OS-DELETE VALUE(ftpFileName + ".log").
*/
