/*By: Neil Gao 09/02/10 ECO: *SS 20090210* */

/* 计算 "1-10,21,24,25" 代表的数量 */

define input parameter iptf1 as char.
define output parameter optf1 as int.
define var xxf1 as char.
define var xxf2 as int.
define var xxf3 as int.
define var i as int.

if num-entries(iptf1) > 10 then do:
	message "错误: 不能超过10个段".
	return.
end.

do i = 1 to num-entries(iptf1) :
	xxf1 = entry(i,iptf1).
	if index(xxf1,"-") > 0 then do:
		xxf2 = int(entry(1,xxf1,"-")) no-error.
		xxf3 = int(entry(2,xxf1,"-")) no-error.
		optf1 = optf1 + max(0,xxf3 - xxf2 + 1).
	end.
	else do:
		xxf2 = 0.
		xxf2 = int(xxf1) no-error.
		if xxf2 > 0 then optf1 = optf1 + 1.
	end.
end.


