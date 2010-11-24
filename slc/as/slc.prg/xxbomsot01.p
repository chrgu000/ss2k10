/*By: Neil Gao 09/03/05 ECO: *SS 20090305* */
/* SS - 090627.1 By: Neil Gao */

{mfdeclre.i}

define input  parameter iptf1 as char.
define input  parameter iptf2 as char.
define input  parameter iptf7 as int.
define input  parameter iptf3 as char.
define input  parameter iptf4 as int.
define input  parameter iptf5 as char.
define input  parameter iptf6 as int.
define output parameter optf1 as logical.
define var tint as int.
define var tvin as char format "x(18)".
define var tlog as logical.

tint = iptf6.
if tint < 1 then return.
do tint = tint to 1 by -1 :
	{gprun.i ""xxwovintgetvin.p"" 
					"(input iptf1, 
					input iptf2 ,
					input iptf7, 
					output tvin)"}
	if tvin = "" then do:
		message "错误: 规则有误，请重新更改规则再试" view-as alert-box .
		optf1 = no.
		return.
	end.
	if tint = iptf6 then do:
		message "VIN码起始号:" tvin  "是否确认" update tlog .
		if not tlog then do:
			optf1 = no.
			return.
		end.
	end.
	find first xxsovd_det where xxsovd_domain = global_domain and xxsovd_id = tvin no-error.
	if avail xxsovd_det then do:
		message "错误: VIN码 " + xxsovd_id + " 已经存在,请修改规则".
		optf1 = no.
		return.
	end.
	else do:
		create xxsovd_det.
		assign xxsovd_domain = global_domain
				 xxsovd_nbr  = iptf3
				 xxsovd_line = iptf4
				 xxsovd_part = iptf5
				 xxsovd_id  = tvin
				 xxsovd_id1 = tvin		/*批号 = VIN码*/
				 xxsovd_qty = 1.
	end.
	if iptf7 > 0 then iptf7 = iptf7 + 1.
end.
optf1 = yes.


