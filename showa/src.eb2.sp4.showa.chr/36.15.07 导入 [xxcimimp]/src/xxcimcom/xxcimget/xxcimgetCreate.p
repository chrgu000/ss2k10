/*
BBS水木清华站∶精华区
发信人: netadmin (爱我中华), 信区: Unix 
标  题: Re: 能不能写个给FTP自动执行的SCRIPT? 
发信站: BBS 水木清华站 (Thu Apr  6 09:27:21 2000) WWW-POST 
 
    有时用户需要用FTP传输许多大文件。这时必须登录服务器并逐一地传输文件。而且 
只有在等待一个文件传送完毕后才能输入命令传输下一个文件。这样用户需花费很长时间 
守候在终端前等待每一个文件传输结束。为了简化上述工作，大多数UNIX平台上的FTP实 
现都支持非在线的FTP传输，用户只需把要输入的命令逐条地写在Shell脚本中，FTP传输 
根据事先写好的脚本会自动地进行。  
    下面是实现非在线的FTP会话所需要的步骤：  
    使用vi或其他文本编辑器创建一个包含用户所使用的FTP命令的脚本，下面是一个简 
单脚本的例子：  
#This file’s name is scriptname  
open ftpservername  
user myname mypassword  
binary  
cd /incoming  
put myfilename  
bye  
    该脚本中包含了将文件传到主机ftpservername上/incoming目录中所需的所有操作。 
首先是用open命令指定传输的目录主机名，接着使用ftp的user命令将用户的用户名 
(myname)和口令(mypassword)送给主机做身份验证。验证通过后，binary命令设置二进制 
的传输模式，将/incoming设置成当前目录，然后用put命令把文件myfilename传到主机上 
。传输后，使用bye命令关闭连接。由于脚本中列出的顺序将对传输是否可以成功有很大 
影响，可能的话，在使用其进行非在线传输之前，要对脚本进行仔细的检查。  
    ·验证脚本，使用下面命令可激活FTP并且让其在没有用户干预的情况下自动执行： 
 
    $ ftp –vni <scriptname  
    其中：  
    -v  向用户显示FTP客户和服务器间的对话过程，这有助于脚本的调试。  
    -n  关闭自动登录的功能，若不使用该选项，那么ftp将使用用户home目录中的“ 
.netrc”文件或用户当前系统中的用户名进行自动登录。这样会和脚本中使用的登录命令 
相冲突，从而导致会话的失败。  
    -i  在多个文件传输中关闭交互式操作的模式。  
    scriptname  包含ftp脚本的文件名。  
    ·当验证了该脚本以后，可以使用at或cron工具在指定的时间调度其运行，执行时也 
可以不使用-v选项，如执行该脚本的cron项为：  
    ftp –in </pathname/ftpscript  
    用户最好将-v选项打开并把其输出重定向到一个日志文件中。这样一旦会话失败，用 
户可对日志文件进行分析以找到出错的根源。下述命令可将ftp命令执行时的详细信息记 
录到日志文件中：  
    ftp –inv </pathname/ftpscript >/pathname/logfile  
    若将非在线传输与第三方传输技术联合使用，那么管理员不但可在非在线的其主机和 
其他服务器之间传递文件，也可以在网络中的任何两台主机间传递文件。  
 
 
 
【 在 VisualC (学习VC★打倒北约) 的大作中提到: 】  
∶ 就是能够让FTP程序根据我要登录的SERVER名字,自动知道我的登录用户名  
∶ 及口令,以及自动执行cd,bin,put/get之类这样的FTP命令.  
∶ 这样的SCRIPT好象用输入重定向的办法搞不定的说...:(  
 
 
-- 
※ 来源:·BBS 水木清华站 smth.org·[FROM: 210.42.146.3]  

BBS水木清华站∶精华区
*/



/* SS - 081222.1 By: Bill Jiang */

/* SS - 081222.1 - B */
/*
1. 生成通过FTP向服务器传输请求文件的命令
2. 改变了当前目录
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

/* 删除可能存在的同名文件 */
{gprun.i ""xxcimgetDel.p"" "(
   INPUT-OUTPUT ftpFileName
   )"}

/* 删除失败,退出 */
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

/* 更改远程计算机上的工作目录。默认情况下，工作目录是 ftp 的根目录。*/
IF remoteDirName <> "" THEN DO:
   PUT STREAM s_ftp UNFORMATTED "cd /".
   PUT STREAM s_ftp UNFORMATTED remoteDirName SKIP.
END.

/* 更改本地计算机上的工作目录。默认情况下，工作目录是启动 ftp 的目录。*/
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
