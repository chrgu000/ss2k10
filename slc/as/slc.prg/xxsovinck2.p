/* Creation: eB21SP3 Chui Last Modified: 20071214 By: Davild Xu *ss-20071214.1*/
/*派工计划报表
1.  有专批的订单要有标记--*--在ID前	20071225
2. 报表输入界面增加筛选条件（已完工+未完工/已完工/未完工）
完工＝生产仓转成品合格仓数量之和，下线数量＝工单入库数量之和

*/
    {mfdtitle.i "b+ "}
 	DEFINE VARIABLE lot       LIKE wo_lot       no-UNDO.
	DEFINE VARIABLE lot1      LIKE wo_lot       NO-UNDO.
	DEFINE VARIABLE nbr       LIKE wo_nbr        NO-UNDO .
	DEFINE VARIABLE nbr1      LIKE wo_nbr        NO-UNDO .
	DEFINE VARIABLE sonbr      LIKE so_nbr        NO-UNDO .
	DEFINE VARIABLE sonbr1      LIKE so_nbr        NO-UNDO .
	DEFINE VARIABLE sodline      LIKE sod_line    format ">>9"    NO-UNDO .
	DEFINE VARIABLE sodline1      LIKE sod_line   format ">>9"     NO-UNDO .
	DEFINE VARIABLE vin like xxsovd_id .
	DEFINE VARIABLE vin1 like xxsovd_id .
	DEFINE VARIABLE status2    as char.
	DEFINE VARIABLE status1   as char .
	DEFINE VARIABLE rel   like wo_rel_date.
	DEFINE VARIABLE rel1  like wo_rel_date.
	DEFINE VARIABLE line  LIKE pt_prod_line .
	DEFINE VARIABLE line1 LIKE pt_prod_line .
	DEFINE VARIABLE tmp_char as char format "x(76)" label "状态说明" .
	DEFINE VARIABLE tmp_plan_type as char format "x(8)" .
	DEFINE VARIABLE tmp_qty_ord like wo_qty_ord .
	DEFINE VARIABLE i as integer .
	DEFINE VARIABLE k as integer .
	DEFINE VARIABLE tmp_seq as integer .

define temp-table xxwo_mstr
	field 	xxwo_rel_date	like wo_rel_date	
	field 	xxwo_vend	like wo_vend	
	field 	xxwo_seq	as inte 	
	field 	xxwo_part	like wo_part	
	field 	xxwo_qty_ord	like wo_qty_ord	
	field 	xxwo_char	as char format "x(108)" extent 30 
	field 	xxwo_lot	like wo_lot	
	field 	xxwo_nbr	like wo_nbr	
	field 	xxwo_qty_comp	like wo_qty_comp	
	field 	xxwo_plan_type	as char 
	field 	xxwo_so_saler	as char 
	field 	xxwo_time	as inte
	field 	xxwo_qty_line	like wo_qty_comp
	field 	xxwo_qty_pack	like wo_qty_comp
	field 	xxwo_qty_rct	like wo_qty_comp
	field 	xxwo_sod_qty_ord like wo_qty_comp
	index xxdatetime xxwo_vend xxwo_rel_date xxwo_time
	
	.
DEFINE VARIABLE sel as inte .
def var	ynprint_vin	as logi .
def var	yncomp_down	as logi .
def var	yncomp_cuku	as logi .
def var	ynpar_down 	as logi .
def var	ynpar_pack 	as logi .
def var	ynpar_ruku 	as logi .
def var	ynpar_cuku 	as logi .

{xxddiqvindet.i "new"}	/*定义共享表xxddiqvindet_mstr*/

/*---Add Begin by davild 20080107.1*/
DEFINE VARIABLE qty_pack like ld_qty_oh .
DEFINE VARIABLE qty_line like ld_qty_oh .
DEFINE VARIABLE qty_ruku like ld_qty_oh .
DEFINE VARIABLE qty_cuku like ld_qty_oh .
/*---Add End   by davild 20080107.1*/
sel = 3 .
	FORM
		sonbr          COLON 12
		sonbr1         LABEL {t001.i} COLON 49
		sodline         COLON 12 label "项次"
		sodline1         LABEL {t001.i} COLON 49
		nbr            COLON 12
		nbr1           LABEL {t001.i} COLON 49
		/*lot           COLON 12
		lot1          LABEL {t001.i} COLON 49*/
		vin       COLON 12 label "机号(VIN码)"
		vin1      LABEL {t001.i} COLON 49 
		skip(1)
		ynprint_vin colon 25 label "VIN 码未打印"
		yncomp_down colon 25 label "半成品(机组动力)未下线"
		yncomp_cuku colon 25 label "半成品(机组动力)未发料"
		ynpar_down  colon 25 label "(机组或单机动力)未下线"
		ynpar_pack  colon 25 label "(机组或单机动力)未包装"
		ynpar_ruku  colon 25 label "(机组或单机动力)未入库"
		ynpar_cuku  colon 25 label "(机组或单机动力)未出库"
		/*sel	colon 14 label "选择" format ">9"	skip
		"1. 完  工" colon 14
		"2. 未完工" colon 14
		"3. 全  部" colon 14*/	skip (1)
	WITH FRAME a SIDE-LABELS WIDTH 80 attr-space .
	setFrameLabels(FRAME a:HANDLE).

	{wbrp01.i}
	REPEAT ON ENDKEY UNDO, LEAVE:
hide all no-pause .
view frame dtitle .
	   /*输入参数的初始化-BEGIN*/
		IF lot1	= hi_char	THEN lot1	= "".
		IF sonbr1	= hi_char	THEN sonbr1	= "".
		IF nbr1		= hi_char	THEN nbr1	= "".
		IF vin1		= hi_char	THEN vin1	= "".
		IF rel	= low_date	THEN rel	= ?.
		IF rel1	= hi_date	THEN rel1	= ?.
		IF status2	= hi_char	THEN status2	= "".
		IF sodline1	= 999	THEN sodline1	= 0 .


		IF c-application-mode <> 'web':u THEN
			UPDATE
				sonbr sonbr1 
				sodline
				sodline1
				nbr nbr1 /*lot lot1*/ vin vin1 
				ynprint_vin
				yncomp_down
				yncomp_cuku
				ynpar_down 
				ynpar_pack 
				ynpar_ruku 
				ynpar_cuku 

			WITH FRAME a.

		{wbrp06.i &command = UPDATE
			&fields = "sonbr sonbr1 sodline sodline1 nbr nbr1 vin vin1 
				ynprint_vin
				yncomp_down
				yncomp_cuku
				ynpar_down 
				ynpar_pack 
				ynpar_ruku 
				ynpar_cuku "
			&frm = "a"}

		IF (c-application-mode <> 'web':u) OR
			(c-application-mode = 'web':u AND
			(c-web-request begins 'data':u)) THEN DO:
			bcdparm = "".
			{mfquoter.i lot   }
			{mfquoter.i lot1  }
			{mfquoter.i sonbr  }
			{mfquoter.i sonbr1  }
			{mfquoter.i sodline  }
			{mfquoter.i sodline1  }
			{mfquoter.i nbr    }
			{mfquoter.i nbr1   }
			{mfquoter.i vin   }
			{mfquoter.i vin1  }
			/*{mfquoter.i rel }
			{mfquoter.i rel1}
			{mfquoter.i sel}*/

			IF sodline1		= 0	THEN sodline1	= 999.
			IF lot1		= ""	THEN lot1	= hi_char.
			IF vin1	= ""	THEN vin1	= hi_char.
			IF sonbr1	= ""	THEN sonbr1	= hi_char.
			IF nbr1		= ""	THEN nbr1	= hi_char.
			IF rel	= ?	THEN rel	= low_date.
			IF rel1	= ?	THEN rel1	= hi_date.
		END.
          /*输入参数的初始化-END*/
          /*{mfselprt.i "printer" 132}*/	/*---Remark by davild 20071214.1*/
        {gpselout.i
            &printType = "printer"
            &printWidth = 132
            &pagedFlag = " "
            &stream = " "
            &appendToFile = " "
            &streamedOutputToTerminal = " "
            &withBatchOption = "yes"
            &displayStatementType = 1
            &withCancelMessage = "yes"
            &pageBottomMargin = 6
            &withEmail = "yes"
            &withWinprint = "yes"
            &defineVariables = "yes"
        }
	for each xxddiqvindet_mstr :
	delete   xxddiqvindet_mstr .
	end.
	for each xxsovd_det where xxsovd_domain = global_domain 
		and xxsovd_nbr >= sonbr and xxsovd_nbr <= sonbr1
		and xxsovd_line >= sodline and xxsovd_line <= sodline1
		and xxsovd_wonbr >= nbr and xxsovd_wonbr <= nbr1
		/*and xxsovd_wolot >= lot and xxsovd_wolot <= lot1 */
		and xxsovd_id >= vin and xxsovd_id <= vin1
		and xxsovd_id <> "" no-lock :

		/*---Add Begin by davild 20080220.1*/

		 {gprun.i ""xxddiqvindet.p"" 
		"(input xxsovd_id)"
			}	/*得到VIN码信息*/

		/*---Add End   by davild 20080220.1*/

		
	end.
	for each xxddiqvindet_mstr :
		if	ynprint_vin	= yes and xxddiqvindet_print_vin_date <> ? then next .
		if	yncomp_down	= yes and xxddiqvindet_comp_down_date <> ? then next .
		if	yncomp_cuku	= yes and xxddiqvindet_comp_cuku_date <> ? then next .
		if	ynpar_down 	= yes and xxddiqvindet_par_down_date <> ? then next .
		if	ynpar_pack 	= yes and xxddiqvindet_par_pack_date <> ? then next .
		if	ynpar_ruku 	= yes and xxddiqvindet_par_ruku_date <> ? then next .
		if	ynpar_cuku 	= yes and xxddiqvindet_par_cuku_date <> ? then next .

		display 
			xxddiqvindet_nbr		column-label "销售单"
			xxddiqvindet_line		column-label "项" format ">>9"			
			xxddiqvindet_sod_qty_ord	column-label "销单数量" format ">>>>>9"
			xxddiqvindet_id			column-label "VIN码(机号)"
			xxddiqvindet_print_vin_date	column-label "打印日期"
			xxddiqvindet_print_vin_time	column-label "打印时间"

			xxddiqvindet_comp_part		column-label "半成品(机组动力)"      
			xxddiqvindet_comp_wolot		column-label "工单ID"		
			xxddiqvindet_comp_prod_line	column-label "产品线"    
			xxddiqvindet_comp_down_date	column-label "下线日期" 
			xxddiqvindet_comp_down_time	column-label "下线时间"    
			/*xxddiqvindet_comp_pack_date	column-label "包装日期"      
			xxddiqvindet_comp_pack_time	column-label "包装时间"		
			xxddiqvindet_comp_ruku_date	column-label "入库日期"    
			xxddiqvindet_comp_ruku_time	column-label "入库时间"*/ 
			xxddiqvindet_comp_cuku_date	column-label "发料日期"    
			xxddiqvindet_comp_cuku_time	column-label "发料时间" 

			xxddiqvindet_par_part		column-label "机组/单机动力"   
			xxddiqvindet_par_wolot		column-label "工单ID"	
			xxddiqvindet_par_prod_line	column-label "产品线"   
			xxddiqvindet_par_down_date	column-label "下线日期" 
			xxddiqvindet_par_down_time	column-label "下线时间" 
			xxddiqvindet_par_pack_date	column-label "包装日期" 
			xxddiqvindet_par_pack_time	column-label "包装时间"	
			xxddiqvindet_par_ruku_date	column-label "入库日期" 
			xxddiqvindet_par_ruku_time	column-label "入库时间" 
			xxddiqvindet_par_cuku_date	column-label "出库日期" 
			xxddiqvindet_par_cuku_time	column-label "出库时间" 
		with width 300 stream-io .
	end.
	/*---Add Begin by davild 20080107.1*/
	  /*
	  input wolot 工单ID
	  output qty_pack 包装量
	  output qty_line 下线量
	  output qty_ruku 入库量
	  output qty_cuku 出库量
	  */
	/*
	 {gprun.i ""xxddgetxxsovdqty.p"" 
	"(input wo_lot,
		output qty_pack,
		output qty_line,
		output qty_ruku,
		output qty_cuku)"
		}
*/	/*---Remark by davild 20080107.1*/

	
	{mfreset.i}
	{mfgrptrm.i}

	END.

	{wbrp04.i &frame-spec = a}
