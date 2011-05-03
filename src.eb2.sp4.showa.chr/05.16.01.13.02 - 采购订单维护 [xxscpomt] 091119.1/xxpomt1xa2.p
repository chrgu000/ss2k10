/* SS - 090907.1 By: Neil Gao */

{mfdeclre.i}
{gplabel.i}

/*
增加修改SCM同步数据
usrw_key1 : 类型(scmftphist)
usrw_key2 : 处理文件名
usrw_charfld[1]: 提交用户
usrw_datefld[1]: 建立日期  usrw_decfld[1]: 建立时间
usrw_datefld[2]: 修改日期  usrw_decfld[2]: 修改时间
usrw_datefld[3]: 处理日期  usrw_decfld[3]: 处理时间
usrw_datefld[4]: 完成日期  usrw_decfld[4]: 完成时间
*/

define input parameter iptf1 as char.
define input parameter iptf2 as char.

find first usrw_wkfl where usrw_key1 = "scmftphist" and usrw_key2 = iptf1 no-error.
if not avail usrw_wkfl then do:
	create 	usrw_wkfl.
	assign 	usrw_key1 = "scmftphist"
					usrw_key2 = iptf1
					usrw_key3 = iptf2
					usrw_charfld[1] = global_userid
					usrw_datefld[1] = today
					usrw_decfld[1]  = time
					. 
end.
	
	usrw_datefld[2] = today.
	usrw_decfld[2]  = time.
