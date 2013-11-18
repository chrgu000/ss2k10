/* BY: Bill Jiang DATE: 08/18/06 ECO: SS - 20060818.1 */

/* SS - 20060818.1 - B */
/*
1. 初发行版
2. 按指定的扩展名(允许为空)和文件名返回一个在系统中不存在的新文件名
3. 如果指定的文件名存在,则从1开始顺序累加
*/
/* SS - 20060818.1 - E */

DEFINE INPUT PARAMETER ext AS CHARACTER.
DEFINE INPUT-OUTPUT PARAMETER newFileName AS CHARACTER.

IF ext <> "" AND (NOT (EXT BEGINS ".")) THEN DO:
   ext = "." + ext.
END.

IF SEARCH(newFileName + ext) = ? THEN DO:
   newFileName = newFileName + ext.
   RETURN.
END.

DEFINE VARIABLE i AS INTEGER.

i = 0.
REPEAT:
   i = i + 1.
   IF SEARCH(newFileName + STRING(i) + ext) = ? THEN DO:
      newFileName = newFileName + STRING(i) + ext.
      RETURN.
   END.
END.
