/* SS - 090827.1 By: Neil Gao */
/* SS - 090915.1 By: Neil Gao */
/* SS - 100519.1 By: Kaine Zhang */

/* SS - 100507.1 - RNB
[100519.1]
2010-5-17
赵奇 09:55:44
现在四轮车接口里
把xlmd_motor里写的值
改写到xlmd_part里面去
[100519.1]
SS - 100507.1 - RNE */


/*
增加进出口接口
*/
/*
一. 箱子主信息. xlm_mstr.
字段名                标签         说明
xlm_barcode           条码号       在整个进出口系统中,唯一值.
xlm_site              收货地点     3
xlm_loc               收货库位     001
xlm_package           箱号         采购单+"*"+5位数字型字符.如数字位数不足5位,需补上前者的0.例如09010161*00045
xlm_length            长           箱子的长度,如果无法提供,暂时不填它. (但是,进出口的单证部是需要使用这些数据的,估计他们会提出需求).
xlm_width             宽           箱子的宽度,如果无法提供,暂时不填它. (但是,进出口的单证部是需要使用这些数据的,估计他们会提出需求).
xlm_height            高           箱子的高度,如果无法提供,暂时不填它. (但是,进出口的单证部是需要使用这些数据的,估计他们会提出需求).
xlm_gross_weight      毛重         箱子的毛重,如果无法提供,暂时不填它. (但是,进出口的单证部是需要使用这些数据的,估计他们会提出需求).
xlm_net_weight        净重         箱子的净重,如果无法提供,暂时不填它. (但是,进出口的单证部是需要使用这些数据的,估计他们会提出需求).
xlm_make_date         生产日期     生产日期
xlm_pack_date         包装日期     包装日期
xlm_store_date        入库日期     入库日期
xlm_vendor            供应商       SLC.
xlm_po_nbr            采购单号     进出口的采购单号码.例如09010161.
xlm_datetime          生成时间     向接口表写数据当时的时间.(datetime).(now).
xlm_import            导入         进出口是否对本箱数据进行了收货(导入).本字段初始值为No,进出口接收后,会修改它为Yes.
xlm_pack_mode         包装方式     箱子的包装方法.例如纸皮,铁皮,木箱等.如果无法提供,暂时不填它. (但是,进出口的单证部是需要使用这些数据的,估计他们会提出需求).

二. 箱子物料明细. xlmd_det.
字段名                标签         说明
xlmd_barcode          barcode      条码号.
xlmd_part             Part         物料编码(如100000-02A0-00501).注意四轮车的编码,与进出口的编码,是否一致.(例如车灯,在四轮车代码为PLM01,是否在进出口代码为PLM02).
xlmd_serial           Serial       车型代号(如LX100-14).该物料是哪个车型.
xlmd_motor            Motor        成车编码(如LX100-14-00C-5R).该物料是哪个成车.
xlmd_vin              VIN          车架号.成车有车架号,则填在这里.零件,没有车架号的,可以不填.
xlmd_engine           engine       发动机.成车有发动机,则填在这里.零件,没有发动机的,可以不填.
xlmd_qty              Quantity     数量.在本箱内,本车型代号+成车编码+物料编码的数量.如果同一零件,属于不同的车型代号,则需分别计数.
xlmd_datetime         datetime     向接口表写数据当时的时间.(datetime).(now).
xlmd_import           import       进出口是否对本条明细数据进行了收货(导入).本字段初始值为No,进出口接收后,会修改它为Yes.
xlmd_make_character01 flag         一个标记.多余的,进出口不会使用它.但是它的值在表中需要唯一,所以你必须写入它.你可以随意写一个东西进去,只要保证在表内唯一即可.
xlmd_pinpai           品牌         本物料的品牌.品牌如何定,需要向进出口,或制造公司询问.听说他们就这个问题,开过几次会.如果无法提供,暂时不填它. 
xlmd_biaozhi          标识         本物料的标识.标识如何定,需要向进出口,或制造公司询问.听说他们就这个问题,开过几次会.如果无法提供,暂时不填它. 
xlmd_xinghao          型号         本物料的型号.型号如何定,需要向进出口,或制造公司询问.听说他们就这个问题,开过几次会.如果无法提供,暂时不填它. 
*/

define shared var global_domain like pt_domain.
define input parameter iptf1 like xxvind_id.
define input parameter iptf2 like xxsovd_id.

define output parameter optf1 as logical.
	

	optf1 = yes.
	
	find first xxvind_det where xxvind_domain = global_domain 
			and xxvind_id = iptf1 and xxvind_log01 = yes no-lock no-error.
	if not avail xxvind_det then return.
	
	find first so_mstr where so_domain = global_domain and so_nbr = xxvind_nbr no-lock no-error.
	if not avail so_mstr then return.
	
	find first pt_mstr where pt_domain = global_domain and pt_part = xxvind_part no-lock no-error.
	
 	create 	qadmid.xlm_mstr.
	assign 	xlm_barcode = iptf1
					xlm_site    = "3"
					xlm_loc     = "001"
					xlm_package = if avail xxvind_det then xxvind_chr02 else ""
					xlm_make_date = xxvind_down_date
					xlm_pack_date = xxvind_pack_date
					xlm_store_date = xxvind_cuku_date
					xlm_vendor  = "SLC"
					xlm_po_nbr = so__chr03
					xlm_datetime = now
					xlm_import = no
					.
	create  qadmid.xlmd_det.
	/* SS - 100519.1 - B
	assign  xlmd_barcode = iptf1
					xlmd_part    = ""
					xlmd_serial  = if avail pt_mstr then pt_desc1 else ""
					xlmd_motor   = xxvind_part
					xlmd_vin     = iptf1
					xlmd_engine  = iptf2
					xlmd_qty     = 1
					xlmd_datetime = now
					xlmd_import = no
					xlmd_make_character01 = "SLC" + iptf1
					.
    SS - 100519.1 - E */
    /* SS - 100519.1 - B */
    assign
        xlmd_barcode = iptf1
		xlmd_part    = xxvind_part
        xlmd_serial  = if avail pt_mstr then pt_desc1 else ""
        xlmd_motor   = xxvind_part
        xlmd_vin     = iptf1
        xlmd_engine  = iptf2
        xlmd_qty     = 1
        xlmd_datetime = now
        xlmd_import = no
        xlmd_make_character01 = "SLC" + iptf1
        .
    /* SS - 100519.1 - E */
					
	optf1 = no.

/* SS 091202.1 - B */
/*	
if connected("qadmid") then do:
	disconnect qadmid.
end.
*/
/* SS 091202.1 - E */