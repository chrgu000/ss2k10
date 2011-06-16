/* SS - 090907.1 By: Neil Gao */

{mfdeclre.i}
{gplabel.i}

define input parameter iptf1 as char.
define output parameter optf1 as logical.
define var ftpfilename as char.

   /* 获得远程文件 */
	  {gprun.i ""xxscftpLocalGet.p"" "(
	  		input iptf1,
	  		output ftpFileName
	  )"}
	  
	  if ftpfilename <> "" then optf1 = yes.
	  else optf1 = no.
	  