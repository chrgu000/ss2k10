/* Creation: eB21SP3 Chui Last Modified: 20080107 By: Davild Xu *ss-20071228.1*/
/*自动下线程序*/
{mfdtitle.i "SS"}
pause 0 .


DEFINE input  parameter vin like xxsovd_id .
DEFINE input  parameter wolot like wo_Lot .
DEFINE output parameter cimError as logi .
DEFINE VARIABLE checknumber as char .
cimError = yes .
FOR EACH  xxsovd_det where xxsovd_domain = global_domain and xxsovd_id = vin and xxsovd_wolot <> wolot :
	cimError = no .
	/*检查是否已下线
	checknumber = 1  下线检查或新增
	checknumber = 2  包装检查或新增
	checknumber = 3  入库(成品或半成品)检查或新增
	checknumber = 4  出库或发料(半成品,如机组动力)检查或新增
	*/

	checknumber = "4" .
	{gprun.i ""xxddcheckvinhist.p""
	"(input vin,
	  input xxsovd_wolot ,
	  input checknumber ,
	  output cimError)"}
 	if cimError = yes then do:		
		next .	/*已发料*/
	end.
 	message "正在发料.. " + xxsovd_part + " " + xxsovd_id  .
	/* 工单入库CIMLOAD
	{1} = 工单ID
	{2} = 入库数量
	{3} = 地点
	{4} = 库位
	{5} = 批号
	{6} = 参考
	{7} = 物料
	*/
	{xxddautowois.i
	 wolot
	 """1"""
	 """10000"""
	 """W10"""
	 xxsovd_id1
	 """ """
	 xxsovd_part
	}
	/*检测是否导入成功*/
	find last tr_hist where tr_domain = global_domain
		and tr_type = "iss-wo"
		and tr_effdate = today 
		and tr_part = xxsovd_part
		and tr_nbr = xxsovd_wonbr
		and tr_lot = wolot
		and tr_serial = xxsovd_id1
		no-lock no-error.
	if avail tr_hist then do:
		unix silent value ( "rm "  + Trim(usection) + ".i").
		unix silent value ( "rm "  + Trim(usection) + ".o"). 
		message "正在发料.. " + xxsovd_part  + " " + xxsovd_id + " 成功.".
		/*自动更新历史记录xxvind_det和汇总记录xxvin_mstr*/
		checknumber = "4" .
		{gprun.i ""xxddupdatevinhist.p""
		 "(input vin,
		   input xxsovd_wolot ,
		   input tr_loc,
		   input checknumber ,
		   output cimError)"}
	end.
	else do: 
		message "正在发料.. " + xxsovd_part  + " " + xxsovd_id + " 失败.".
		message "发料.. " + xxsovd_part  + " " + xxsovd_id + " 失败,请立即联系管理员!" view-as alert-box .
		cimError = yes .
	end.
end.
	