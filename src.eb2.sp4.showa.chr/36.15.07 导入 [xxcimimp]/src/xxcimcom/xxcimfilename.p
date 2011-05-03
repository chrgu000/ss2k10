/* BY: Bill Jiang DATE: 08/18/06 ECO: SS - 20060818.1 */

/* SS - 20060818.1 - B */
/*
1. �����а�
2. ��ָ������չ��(����Ϊ��)���ļ�������һ����ϵͳ�в����ڵ����ļ���
3. ���ָ�����ļ�������,���1��ʼ˳���ۼ�
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
