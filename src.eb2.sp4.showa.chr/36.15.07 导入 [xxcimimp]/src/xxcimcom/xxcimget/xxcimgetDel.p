/* SS - 20081020.1 By: Bill Jiang */

/* SS - 20081020.1 - B */
/*
1. 删除指定的文件
2. 如果失败,则返回空
*/
/* SS - 20081020.1 - E */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

DEFINE INPUT-OUTPUT PARAMETER delfilename AS CHARACTER.

IF SEARCH(delfilename) <> ? THEN DO:
   OS-DELETE VALUE(delfilename).
   IF OS-ERROR <> 0 THEN DO:
      /* Error occurred while deleting file: #, error number: */
      {pxmsg.i &MSGNUM=4765 &ERRORLEVEL=3 &MSGARG1=delfilename}
      delfilename = "".
      RETURN.
   END.
END.
