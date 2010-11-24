/* Creation: eB21SP3 Chui Last Modified: 20080107 By: Davild Xu *ss-20071228.1*/
/*自动下线程序*/
{mfdtitle.i "SS"}
/*检查是否已下线
	checknumber = 1=上线
	checknumber = 2=下线
	checknumber = 3=检测
	checknumber = 4=包装
	checknumber = 5=入库
	checknumber = 6=装箱	loc 此时要为 装箱单号
	checknumber = 7=出库
	*/
DEFINE input  parameter vin like xxsovd_id .
DEFINE input  parameter wolot like xxsovd_wolot .
DEFINE input  parameter checknumber as char .
DEFINE output parameter cimError as logi .
pause 0 .
cimError = yes .
find first xxvind_det where xxvind_domain = global_domain 
		and xxvind_wolot = wolot and xxvind_id = vin no-error.
if avail xxvind_det then do :
	if checknumber = "1" then do:
		if xxvind_up_date = ?   then cimError = no . else cimError = yes .
	end.
	if checknumber = "2" then do:
		if xxvind_down_date = ? then cimError = no . else cimError = yes .
	end.
	if checknumber = "3" then do:
		if xxvind_check_date = ? then cimError = no . else cimError = yes .
	end.
	if checknumber = "4" then do:
		if xxvind_pack_date = ? then cimError = no . else cimError = yes .
	end.
	if checknumber = "5" then do:
		if xxvind_ruku_date = ? then cimError = no . else cimError = yes .
	end.
	if checknumber = "6" then do:
		if xxvind_zhuangxiang_date = ? then cimError = no . else cimError = yes .
	end.
	if checknumber = "7" then do:
		if xxvind_cuku_date = ? then cimError = no . else cimError = yes .
	end.	
end .
