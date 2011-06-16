/*
BBSˮľ�廪վ�þ�����
������: netadmin (�����л�), ����: Unix 
��  ��: Re: �ܲ���д����FTP�Զ�ִ�е�SCRIPT? 
����վ: BBS ˮľ�廪վ (Thu Apr  6 09:27:21 2000) WWW-POST 
 
    ��ʱ�û���Ҫ��FTP���������ļ�����ʱ�����¼����������һ�ش����ļ������� 
ֻ���ڵȴ�һ���ļ�������Ϻ���������������һ���ļ��������û��軨�Ѻܳ�ʱ�� 
�غ����ն�ǰ�ȴ�ÿһ���ļ����������Ϊ�˼����������������UNIXƽ̨�ϵ�FTPʵ 
�ֶ�֧�ַ����ߵ�FTP���䣬�û�ֻ���Ҫ���������������д��Shell�ű��У�FTP���� 
��������д�õĽű����Զ��ؽ��С�  
    ������ʵ�ַ����ߵ�FTP�Ự����Ҫ�Ĳ��裺  
    ʹ��vi�������ı��༭������һ�������û���ʹ�õ�FTP����Ľű���������һ���� 
���ű������ӣ�  
#This file��s name is scriptname  
open ftpservername  
user myname mypassword  
binary  
cd /incoming  
put myfilename  
bye  
    �ýű��а����˽��ļ���������ftpservername��/incomingĿ¼����������в����� 
��������open����ָ�������Ŀ¼������������ʹ��ftp��user����û����û��� 
(myname)�Ϳ���(mypassword)�͸������������֤����֤ͨ����binary�������ö����� 
�Ĵ���ģʽ����/incoming���óɵ�ǰĿ¼��Ȼ����put������ļ�myfilename���������� 
�������ʹ��bye����ر����ӡ����ڽű����г���˳�򽫶Դ����Ƿ���Գɹ��кܴ� 
Ӱ�죬���ܵĻ�����ʹ������з����ߴ���֮ǰ��Ҫ�Խű�������ϸ�ļ�顣  
    ����֤�ű���ʹ����������ɼ���FTP����������û���û���Ԥ��������Զ�ִ�У� 
 
    $ ftp �Cvni <scriptname  
    ���У�  
    -v  ���û���ʾFTP�ͻ��ͷ�������ĶԻ����̣��������ڽű��ĵ��ԡ�  
    -n  �ر��Զ���¼�Ĺ��ܣ�����ʹ�ø�ѡ���ôftp��ʹ���û�homeĿ¼�еġ� 
.netrc���ļ����û���ǰϵͳ�е��û��������Զ���¼��������ͽű���ʹ�õĵ�¼���� 
���ͻ���Ӷ����»Ự��ʧ�ܡ�  
    -i  �ڶ���ļ������йرս���ʽ������ģʽ��  
    scriptname  ����ftp�ű����ļ�����  
    ������֤�˸ýű��Ժ󣬿���ʹ��at��cron������ָ����ʱ����������У�ִ��ʱҲ 
���Բ�ʹ��-vѡ���ִ�иýű���cron��Ϊ��  
    ftp �Cin </pathname/ftpscript  
    �û���ý�-vѡ��򿪲���������ض���һ����־�ļ��С�����һ���Ựʧ�ܣ��� 
���ɶ���־�ļ����з������ҵ�����ĸ�Դ����������ɽ�ftp����ִ��ʱ����ϸ��Ϣ�� 
¼����־�ļ��У�  
    ftp �Cinv </pathname/ftpscript >/pathname/logfile  
    ���������ߴ�������������似������ʹ�ã���ô����Ա�������ڷ����ߵ��������� 
����������֮�䴫���ļ���Ҳ�����������е��κ���̨�����䴫���ļ���  
 
 
 
�� �� VisualC (ѧϰVC��򵹱�Լ) �Ĵ������ᵽ: ��  
�� �����ܹ���FTP���������Ҫ��¼��SERVER����,�Զ�֪���ҵĵ�¼�û���  
�� ������,�Լ��Զ�ִ��cd,bin,put/get֮��������FTP����.  
�� ������SCRIPT�����������ض���İ취�㲻����˵...:(  
 
 
-- 
�� ��Դ:��BBS ˮľ�廪վ smth.org��[FROM: 210.42.146.3]  

BBSˮľ�廪վ�þ�����
*/



/* SS - 081222.1 By: Bill Jiang */

/* SS - 081222.1 - B */
/*
1. ����ͨ��FTP����������������ļ�������
2. �ı��˵�ǰĿ¼
*/
/* SS - 081222.1 - E */

{mfdeclre.i}

{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* DETERMINE INPUT DIRECTORY AND FILENAME */
{gpdirpre.i}

DEFINE INPUT PARAMETER sourceFileName AS CHARACTER.
DEFINE INPUT PARAMETER remoteDirName AS CHARACTER.
DEFINE INPUT PARAMETER localDirName AS CHARACTER.
DEFINE INPUT-OUTPUT PARAMETER ftpFileName AS CHARACTER.

DEFINE VARIABLE i1 AS INTEGER.
DEFINE VARIABLE c1 AS CHARACTER.

{gprun.i ""xxcimright.p"" "(
   INPUT-OUTPUT sourceFileName,
   INPUT DIR_prefix
   )"}

IF ftpFileName = "" THEN DO:
   ftpFileName = sourceFileName + ".ftp".
   IF localDirName <> "" THEN DO:
      IF INDEX(ftpFileName, DIR_prefix) = 0 THEN DO:
         ftpFileName = localDirName + DIR_prefix + ftpFileName.
      END.
   END.
END.

/* ɾ�����ܴ��ڵ�ͬ���ļ� */
{gprun.i ""xxcimgetDel.p"" "(
   INPUT-OUTPUT ftpFileName
   )"}

/* ɾ��ʧ��,�˳� */
IF ftpFileName = "" THEN DO:
   RETURN.
END.

DEFINE STREAM s_ftp.
OUTPUT STREAM s_ftp TO VALUE(ftpFileName).

{xxcimcode.i ""CIM_FTP_Open"" c1 """"}
IF c1 = "" THEN DO:
   /* Mandatory control field has not been set: */
   {pxmsg.i &MSGNUM=4408 &ERRORLEVEL=3}
   ftpFileName = "".
   OUTPUT STREAM s_ftp CLOSE.
   RETURN.
END.
PUT STREAM s_ftp UNFORMATTED "open " c1 SKIP.

{xxcimcode.i ""CIM_FTP_User"" c1 """"}
IF c1 = "" THEN DO:
   /* Mandatory control field has not been set: */
   {pxmsg.i &MSGNUM=4408 &ERRORLEVEL=3}
   ftpFileName = "".
   OUTPUT STREAM s_ftp CLOSE.
   RETURN.
END.
PUT STREAM s_ftp UNFORMATTED "user """ c1 """ ".

{xxcimcode.i ""CIM_FTP_Password"" c1 """"}
IF c1 = "" THEN DO:
   /* Mandatory control field has not been set: */
   {pxmsg.i &MSGNUM=4408 &ERRORLEVEL=3}
   ftpFileName = "".
   OUTPUT STREAM s_ftp CLOSE.
   RETURN.
END.
PUT STREAM s_ftp UNFORMATTED c1 SKIP.

PUT STREAM s_ftp UNFORMATTED "ascii" SKIP.

/* ����Զ�̼�����ϵĹ���Ŀ¼��Ĭ������£�����Ŀ¼�� ftp �ĸ�Ŀ¼��*/
IF remoteDirName <> "" THEN DO:
   PUT STREAM s_ftp UNFORMATTED "cd /".
   PUT STREAM s_ftp UNFORMATTED remoteDirName SKIP.
END.

/* ���ı��ؼ�����ϵĹ���Ŀ¼��Ĭ������£�����Ŀ¼������ ftp ��Ŀ¼��*/
IF localDirName <> "" THEN DO:
   PUT STREAM s_ftp UNFORMATTED "lcd ".
   PUT STREAM s_ftp UNFORMATTED localDirName SKIP.
END.

PUT STREAM s_ftp UNFORMATTED "get ".
PUT STREAM s_ftp UNFORMATTED sourceFileName SKIP.

PUT STREAM s_ftp UNFORMATTED "bye" SKIP.
OUTPUT STREAM s_ftp CLOSE.

IF SEARCH(ftpFileName) = ? THEN DO:
   ftpFileName = "".
   RETURN.
END.
