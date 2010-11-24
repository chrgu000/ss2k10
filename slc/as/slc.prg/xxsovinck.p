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
		nbr            COLON 12
		nbr1           LABEL {t001.i} COLON 49
		lot           COLON 12
		lot1          LABEL {t001.i} COLON 49
		vin       COLON 12 label "机号(VIN码)"
		vin1      LABEL {t001.i} COLON 49 
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


		IF c-application-mode <> 'web':u THEN
			UPDATE
				sonbr sonbr1 nbr nbr1 lot lot1 vin vin1
			WITH FRAME a.

		{wbrp06.i &command = UPDATE
			&fields = "sonbr sonbr1 nbr nbr1 lot lot1 vin vin1"
			&frm = "a"}

		IF (c-application-mode <> 'web':u) OR
			(c-application-mode = 'web':u AND
			(c-web-request begins 'data':u)) THEN DO:
			bcdparm = "".
			{mfquoter.i lot   }
			{mfquoter.i lot1  }
			{mfquoter.i sonbr  }
			{mfquoter.i sonbr1  }
			{mfquoter.i nbr    }
			{mfquoter.i nbr1   }
			{mfquoter.i vin   }
			{mfquoter.i vin1  }
			/*{mfquoter.i rel }
			{mfquoter.i rel1}
			{mfquoter.i sel}*/

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
	
	for each xxsovd_det where xxsovd_domain = global_domain 
		and xxsovd_nbr >= sonbr and xxsovd_nbr <= sonbr1
		and xxsovd_wonbr >= nbr and xxsovd_wonbr <= nbr1
		and xxsovd_wolot >= lot and xxsovd_wolot <= lot1 
		and xxsovd_id >= vin and xxsovd_id <= vin1
		and xxsovd_id <> "" no-lock :
		for each xxvind_det where xxvind_domain = global_domain and xxvind_id = xxsovd_id 
			and xxvind_wolot = xxsovd_wolot 
			/*and xxvind_down_date <> ?	/*--下线日期-Add by davild 20080107.1*/
			and xxvind_ruku_date = ?*/
			no-lock :
			find first wo_mstr where wo_domain = global_domain and wo_lot = xxsovd_wolot no-lock no-error.
			display 
				xxsovd_nbr	column-label "销售订单"
				xxsovd_wolot	column-label "工单ID"
				xxsovd_part	column-label "料号(机型)"
				xxsovd_id	column-label "机号(VIN码)"
				wo_qty_ord when (avail wo_mstr)	column-label "计划数"
				xxvind_down_date column-label "下线日期"
				xxvind_pack_date column-label "包装日期"
				xxvind_ruku_date column-label "入库日期"
				xxvind_cuku_date column-label "出库日期"
				with stream-io width 300 .
			/*
			assign xxvinimport_sel = "*"
						 xxvinimport_so = xxvind_nbr
						 xxvinimport_wonbr = xxvind_wonbr
						 xxvinimport_wolot = xxvind_wolot
						 xxvinimport_part  = xxvind_part
						 xxvinimport_qty   = xxsovd_qty
						 xxvinimport_id1   = xxsovd_id1.
			find first so_mstr where so_domain = global_domain and so_nbr = xxvind_nbr no-lock no-error.
			if avail so_mstr then xxvinimport_cust = so_cust.
			*/
		end.
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
