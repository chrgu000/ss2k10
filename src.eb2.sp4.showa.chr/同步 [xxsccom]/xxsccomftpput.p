/* SS - 090907.1 By: Neil Gao */

{mfdeclre.i}
{gplabel.i}

define input parameter iptf1 as char.
define output parameter optf1 as logical.
define var remoteipaddr  as char format "x(45)".
define var remoteDirName as char format "x(45)".
define var audit_trail   as char format "x(1)".
define var BackupDir     as char format "x(45)".
define var ftpFileName   as char.

 /* 发送远程文件 */
	  {gprun.i ""xxscftpPut.p"" "(
	  		input iptf1,
	  		output ftpFileName
	  )"}
	if ftpFileName <> "" then optf1 = yes.
	else optf1 = no.
