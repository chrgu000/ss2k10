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
	define variable yn1 as logical.
	define variable oldname like pt_desc1.

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
sel = 4 .
	FORM
		nbr            COLON 18
		nbr1           LABEL {t001.i} COLON 49
		lot           COLON 18
		lot1          LABEL {t001.i} COLON 49
		status1           COLON 18
		status2          LABEL {t001.i} COLON 49
		line           COLON 18
		line1          LABEL {t001.i} COLON 49
		rel       COLON 18
		rel1      LABEL {t001.i} COLON 49
		yn1       label "是否显示成品描述" colon 18 skip(1)
		sel	colon 18 label "选择" format ">9"	skip
		"1. 完  工" colon 18
		"2. 未完工" colon 18
		"3. 未上线" colon 18
		"4. 全  部" colon 18	skip (1)
	WITH FRAME a SIDE-LABELS WIDTH 80 attr-space .
	setFrameLabels(FRAME a:HANDLE).

	{wbrp01.i}
	REPEAT ON ENDKEY UNDO, LEAVE:
hide all no-pause .
view frame dtitle .
	   /*输入参数的初始化-BEGIN*/
		IF lot1	= hi_char	THEN lot1	= "".
		IF line1	= hi_char	THEN line1	= "".
		IF nbr1		= hi_char	THEN nbr1	= "".
		IF rel	= low_date	THEN rel	= ?.
		IF rel1	= hi_date	THEN rel1	= ?.
		IF status2	= hi_char	THEN status2	= "".


		IF c-application-mode <> 'web':u THEN
			UPDATE
				nbr nbr1 lot lot1 status1 status2 line line1 rel rel1 sel yn1
			WITH FRAME a.

		{wbrp06.i &command = UPDATE
			&fields = "nbr nbr1 lot lot1 status1 status2 line line1 rel rel1 sel yn1"
			&frm = "a"}

		IF (c-application-mode <> 'web':u) OR
			(c-application-mode = 'web':u AND
			(c-web-request begins 'data':u)) THEN DO:
			bcdparm = "".
			{mfquoter.i lot   }
			{mfquoter.i lot1  }
			{mfquoter.i status2  }
			{mfquoter.i status1  }
			{mfquoter.i nbr    }
			{mfquoter.i nbr1   }
			{mfquoter.i line   }
			{mfquoter.i line1  }
			{mfquoter.i rel }
			{mfquoter.i rel1}
			{mfquoter.i sel}
			{mfquoter.i yn1}

			IF lot1		= ""	THEN lot1	= hi_char.
			IF status2	= ""	THEN status2	= hi_char.
			IF line1	= ""	THEN line1	= hi_char.
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
	
	FOR EACH  xxwo_mstr :
		delete xxwo_mstr .
	END.
	FOR EACH wo_mstr  where wo_domain = global_domain
		and wo_nbr >= nbr and wo_nbr <= nbr1
		and wo_lot >= lot and wo_lot <= lot1
		and wo_status >= status1 and wo_status <= status2
		and wo_rel_date >= rel and wo_rel_date <= rel1
		and wo_vend >= line and wo_vend <= line1
		and (wo_status = "a" or wo_status = "r" or wo_status = "c")
		
		NO-LOCK
		break by wo_vend by wo_rel_date:

		tmp_char = "" .
		find first cd_det where cd_domain = wo_domain
			and cd_ref = wo_part
			and cd_type = "SC"
			and cd_lang = "CH"
			and cd_seq  = 0
			no-lock no-error.
		if avail cd_det then do:
			do i = 1 to 15 :
				if trim(cd_cmmt[i]) <> "" then
				assign tmp_char = tmp_char + trim(cd_cmmt[i]) .
			end.			
		end.
		/*20071223李总要求--状态说明+销售说明--BEGIN*/
		find first sod_det where sod_domain = wo_domain and sod_nbr = substring(wo_nbr,1,8) 
					and sod_line = inte(substring(wo_nbr,9,3)) no-lock no-error.
		if avail sod_det then do:
			
			find first cmt_det where cmt_domain = wo_domain and cmt_indx = sod_cmtindx 
				and cmt_seq = 0		/*用户看到的是1 ,但系统存的0*/
				no-lock no-error.
			if avail cmt_det then do:
				do i = 1 to 15 :
					if trim(cmt_cmmt[i]) <> "" then do:
						if i = 1 then assign tmp_char = tmp_char + "(" .
						
						assign tmp_char = tmp_char + trim(cmt_cmmt[i]) .
					end.
					else do: 
						if i > 1 then assign tmp_char = tmp_char + ")" . 
						leave . 
					end .
				end.
			end.
		end.
		/*20071223状态说明+销售说明--END*/
		k = 1 .
		run getstring(input tmp_char ,input 108, output tmp_char ,output k) .
		
		if substring(wo_nbr,1,1) = "1" then assign tmp_plan_type = "国贸" .
		else if substring(wo_nbr,1,1) = "2" then assign tmp_plan_type = "营销" .
		else if substring(wo_nbr,1,1) = "3" then assign tmp_plan_type = "技术" .
		else assign tmp_plan_type = "" .
		tmp_qty_ord = wo_qty_ord .
		find first so_mstr where so_domain = wo_domain and so_nbr = wo_so_job no-lock no-error.
		
		/*派工日期+生产线3+序号+成品状态码+派工量+状态描述+派工号+派工单号+完成量+计划类型+业务员 
		Sort by 生产线3+序号*/		/*李总20071218要求---Remark by davild 20071218.1*/


		/*报表只看 派工日期+生产线+序号（2位）
		 +成品状态码+派工量（3位整数）
		 +派工号+状态描述（40位换行）+业务员*/	/*李总20071219要求---Add by davild 20071219.1*/
		if avail so_mstr then do:
			find first ad_mstr where ad_domain = so_domain and ad_addr = so_slspsn[1] no-lock no-error.
		end.
		
		create xxwo_mstr .
		assign 
			xxwo_rel_date	=	wo_rel_date	
			xxwo_vend	=	wo_vend		
			/*xxwo_seq	=	2 /*tmp_seq*/ 	  	*/	/*---Remark by davild 20071214.1*/
			xxwo_part	=	wo_part		
			xxwo_qty_ord	=	wo_qty_ord	
			/*xxwo_char	=	tmp_char*/	
			xxwo_lot	=	wo_lot		
			xxwo_nbr	=	wo_nbr		
				
			xxwo_time	=	wo__dec01	/*-Data from neil--Add by davild 20071220.1*/	
			xxwo_plan_type	=	tmp_plan_type	
			xxwo_so_saler	=	if avail ad_mstr then ad_name else "" 
			.
			
			/*FOR EACH  tr_hist where tr_domain =  global_domain 				
				and tr_part = wo_part
				/*and tr_nbr = wo_nbr 
				and tr_lot = lot */
				and tr_type = "iss-tr" 
				and substr(tr_loc,1,1) = "w"	/*生产线仓位--SIMON*/
				NO-LOCK:
				/*批序号= VIN码 --SIMON 但系统流程不一定是这样做20071225--*/
				find first xxsovd_det where xxsovd_domain = global_domain 
					and xxsovd_id1 = tr_serial no-lock no-error.
				if avail xxsovd_det and xxsovd_wolot = xxwo_lot then
				assign xxwo_qty_comp	= xxwo_qty_comp + (0 - tr_qty_chg) .		/*完工＝生产仓转成品合格仓数量之和*/
			END.
			*/
			/*---Add Begin by Billy 20081227*/
			  /*
			  input wolot 工单ID
			  output qty_pack 上线量
			  output qty_line 下线量
			  output qty_ruku 入库量
			  output qty_cuku 出库量
			  */
			 {gprun.i ""xxddgetxxsovdqty.p"" 
   			"(input wo_lot,
   				output qty_pack,
   				output qty_line,
   				output qty_ruku,
   				output qty_cuku)"
   				}

			/*---Add End   by davild 20080107.1*/
			do i = 1 to k:
				assign xxwo_char[i] = ENTRY(i, tmp_char, "^") .
			end.
			/*---Add Begin by davild 20071214.1*/
			find first sod_det where sod_domain = wo_domain and sod_nbr = wo_so_job and sod_part = wo_part no-lock no-error.
			assign
			xxwo_qty_line	= qty_pack		/*下线数量＝工单入库数量之和*/
			xxwo_qty_pack	= qty_line
			xxwo_qty_rct	= qty_ruku
			xxwo_qty_comp   = qty_ruku
			xxwo_sod_qty_ord = if avail sod_det then sod_qty_ord else 0 .

			/*---Add End   by davild 20071214.1*/

	END.
	
	/*程序输出部分--BEGIN*/
	FOR EACH  xxwo_mstr  
		NO-LOCK break by xxwo_rel_date by xxwo_vend by xxwo_time :
		if first-of(xxwo_vend) then k = 1.
		assign xxwo_seq = k .
			
			/*表头FORM--BEGIN*/
			FORM  HEADER
			        skip(1)
                        "派工单下达查询报表" AT 50
			        "打印时间:" AT 80 TODAY STRING(TIME,"HH:MM") skip
	                  SKIP(1) 
			WITH STREAM-IO FRAME phead PAGE-TOP WIDTH 132 NO-BOX.
			VIEW FRAME phead.
			/*VIEW FRAME pbottomc.*/
			/*表头FORM--END*/
		/*1.有专批的订单要有标记--*--begin*/
		find first xxsob_det where xxsob_domain = global_domain and xxsob_nbr = substring(xxwo_nbr,1,8)
			and xxsob_line = integer(substring(xxwo_nbr,9,3)) and xxsob_user2 <> "" no-lock no-error.
		if avail xxsob_det then assign xxwo_lot = "*" + xxwo_lot .
		/*1.有专批的订单要有标记--*--end*/

		/*2.完工＝生产仓转成品合格仓数量之和，下线数量＝工单入库数量之和--begin*/

		/*2.完工＝生产仓转成品合格仓数量之和，下线数量＝工单入库数量之和--end*/
		if sel = 1 and xxwo_qty_ord <> xxwo_qty_comp then next .	/*完工*/
		if sel = 2 and xxwo_qty_ord = xxwo_qty_comp then next .		/*未完工*/
		if sel = 3 and xxwo_qty_line <> 0 then next.
		
		find first pt_mstr where pt_domain = global_domain and pt_part = xxwo_part no-lock no-error.
		if avail pt_mstr then
			oldname = pt_desc1.
    
    if yn1 then 
    	do:
				display 
					xxwo_rel_date	column-label "派工日期"              
					xxwo_vend	column-label "线"	format "x(3)"
					string(xxwo_time,"HH:MM")	column-label "时间"  
					xxwo_part	column-label "成品"            
					oldname   column-label "老机型"   
					xxwo_sod_qty_ord column-label "销单!量"  format ">>>9"	/*---Add by davild 20071221.1*/
					xxwo_qty_ord	column-label "派工!量"   format ">>>9"
					/*xxwo_char[1]	column-label "状态描述"              */		
					/*--状态描述在第二行打80列分行-Remark by davild 20071228.1*/             
					xxwo_lot	column-label "派工号"      format "x(9)"          
					xxwo_nbr	column-label "派工单号"	             
					xxwo_qty_line	column-label "绑定!上线"  format ">>>9" 
					xxwo_qty_pack	column-label "下线"  format ">>>9" 
					xxwo_qty_rct	column-label "入库"  format ">>>9" 					
					xxwo_plan_type	column-label "计划!类型"	format "x(4)"
					xxwo_so_saler	column-label "业务员"  
					with stream-io width 300.
		
				/*---Add Begin by davild 20071219.1*/
				k = k + 1 .
				do i = 1 to 15 :
					if trim(xxwo_char[i]) <> "" then do:			
						PUT xxwo_char[i] AT 1  .				
					end.			
				end.
				put skip (1).
			end.
		else
			do:
				display 
					xxwo_rel_date	column-label "派工日期"              
					xxwo_vend	column-label "线"	format "x(3)"
					string(xxwo_time,"HH:MM")	column-label "时间"
					xxwo_part	column-label "成品"            
					oldname   column-label "老机型"   
					xxwo_sod_qty_ord column-label "销单!量"  format ">>>9"	/*---Add by davild 20071221.1*/
					xxwo_qty_ord	column-label "派工!量"   format ">>>9"
					/*xxwo_char[1]	column-label "状态描述"              */		
					/*--状态描述在第二行打80列分行-Remark by davild 20071228.1*/             
					xxwo_lot	column-label "派工号"      format "x(9)"          
					xxwo_nbr	column-label "派工单号"	             
					xxwo_qty_line	column-label "绑定!上线"  format ">>>9" 
					xxwo_qty_pack	column-label "下线"  format ">>>9" 
					xxwo_qty_rct	column-label "入库"  format ">>>9" 					
					xxwo_plan_type	column-label "计划!类型"	format "x(4)"
					xxwo_so_saler	column-label "业务员"  
					with stream-io width 300.
		  end.		
		
		
		/*---Add End   by davild 20071219.1*/

		/*---Add Begin by davild 20071228.1*/
		/*按生产线日期小计*/
		accumulate xxwo_qty_ord (total by xxwo_vend by xxwo_rel_date) .
		if last-of(xxwo_rel_date) then do:
			/*down 1.*/
			underline xxwo_rel_date xxwo_vend xxwo_part xxwo_qty_ord .
			down 1.
			display 
				xxwo_rel_date @ xxwo_rel_date
				xxwo_vend @ xxwo_vend
				"小  计:" @ xxwo_part
				(accum total by xxwo_rel_date xxwo_qty_ord ) @ xxwo_qty_ord .
			down 1 .
		end.
		/*---Add End   by davild 20071228.1*/
	END.
	/*程序输出部分--END*/
	
	{mfreset.i}
	{mfgrptrm.i}

	END.

	{wbrp04.i &frame-spec = a}


PROCEDURE getstring:
		define input  parameter iptstring as char.
		define input  parameter iptlength as int.
		define output parameter optstring as char.
		define output parameter xxk as int.	/*---Add by davild 20071220.1*/
		define var xxs as char.
		define var xxss as char.
		define var xxi as int.
		define var xxj as int.
		
		optstring = "".
		xxss = "".
		xxi = 1.
		
		if iptlength < 2 then return.
		
		repeat while xxi <= length(iptstring,"RAW") :
			xxs = substring(iptstring,xxi,1).
			if length( xxss + xxs , "RAW") > iptlength then do:
				optstring = optstring + xxss + "^".
				xxss = "".
				next.
			end.
			xxi = xxi + 1.
			xxss = xxss + xxs.
		end.
		optstring = optstring + xxss.

		/*---Add Begin by davild 20071220.1*/
		xxk = 1 .
		do xxj = 1 to length(optstring):
			if substring(optstring,xxj,1) = "^" then assign xxk = xxk + 1.
		end.
		/*---Add End   by davild 20071220.1*/
END PROCEDURE.