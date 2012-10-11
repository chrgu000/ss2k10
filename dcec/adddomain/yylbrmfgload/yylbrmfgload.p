/*yylbrmfgload.p   人工、制造费用差异导入                                             */
/* Copyright 2009-2010 QAD Inc., Shanghai CHINA.                        */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0    LAST MODIFIED: 08/26/2009     BY: Jame Duan     *GYD*/
/* REVISION: 2.0    LAST MODIFIED: 08/16/2012     BY: Henri Zhu         */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
/*
{mfdtitle.i "2+ "} */
{mfdtitle.i "20120816"}

def var v_part	 like pt_part.
def var v_file   as char format "x(46)".
def var v_txt    as char format "x(80)".
def var v_year   as int  format "9999".
def var v_period as int  format ">9".
def var v_line   as int.
def var v_update as logical init "no".

DEFINE VARIABLE per_start	LIKE glc_start.
DEFINE VARIABLE per_end		LIKE glc_end.
DEFINE VARIABLE v_ok		AS LOGICAL.
define variable v_version	like yywobmspt_version.
define variable v_site		like yywobmspt_site.
define variable v_pbqty		as int.
define variable v_pcqty		as int.
define variable v_pblbr_amt	as decimal.
define variable v_pbmfg_amt	as decimal.
define variable v_prod_line	like pt_prod_line.
define variable tot_lbr_amt	as decimal.
define variable tot_mfg_amt	as decimal.

def temp-table td
    field td_line	like v_line
    field td_part	like pt_part
    field td_prod_line	like pt_prod_line
    field td_cc		like glt_cc
    field td_qty	as int
    field td_lbr_in	as decimal
    field td_lbr_cost   as decimal
    field td_lbr_var	as decimal
    field td_mfg_in	as decimal
    field td_mfg_cost	as decimal
    field td_mfg_var	as decimal
    field td_reason	as char.

form
  td_line	column-label "行数"
  " "
  td_part	column-label "零件"
  td_prod_line	column-label "产品类"
  td_cc		column-label "成本中心"
  td_qty	column-label "入库数量"
  td_lbr_cost	column-label "人工成本" format "->>>,>>>,>>9.99"
  td_lbr_in	column-label "导入人工费用" format "->>>,>>>,>>9.99"
  td_lbr_var	column-label "人工差异" format "->>>,>>>,>>9.99"
  td_mfg_cost	column-label "制造成本" format "->>>,>>>,>>9.99"
  td_mfg_in	column-label "导入制造费用" format "->>>,>>>,>>9.99"
  td_mfg_var	column-label "制造费用差异" format "->>>,>>>,>>9.99"
  td_reason	column-label "状态" format "x(20)"
with frame d width 320 down.

form
  yylbrmfg_part	column-label "零件"
  yylbrmfg_prod_line column-label "产品类"
  v_pbqty	column-label "期初库存"
  v_pcqty	column-label "本期入库"
  v_pblbr_amt column-label "期初人工差异" format "->>>,>>>,>>9.99"
  yycsvar_variance[16] column-label "低层人工差异" format "->>>,>>>,>>9.99"
  yycsvar_variance[17] column-label "本层人工差异" format "->>>,>>>,>>9.99"
  yyvarated_lbr_rate column-label "人工差异率" format "->>>,>>>,>>9.99"
  v_pbmfg_amt column-label "期初费用差异" format "->>>,>>>,>>9.99"
  yycsvar_variance[18] column-label "低层费用差异" format "->>>,>>>,>>9.99"
  yycsvar_variance[19] column-label "本层费用差异" format "->>>,>>>,>>9.99"
  yyvarated_mfg_rate column-label "费用差异率" format "->>>,>>>,>>9.99"
with frame e width 320 down.

v_year = year(today).
v_period = month(today).
v_update = no.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
     v_year   colon 15 label "年份"
     v_period colon 50 label "期间"
     v_file   colon 15 label "文件名"
     v_update colon 15 label "更新已存在数据"
 SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = "人工、制造费用差异导入".
RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
                 FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
                 RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", 
                 RECT-FRAME-LABEL:FONT).
RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   update 
   v_year v_period 
   v_file 
   v_update
   with frame a.

   find first glc_cal where glc_domain = global_domain and glc_year = v_year and glc_per = v_period no-lock no-error.
   if not avail glc_cal then do:
      message "**财务期间不存在，请检查后重新输入. " view-as alert-box.
      next.
   end.

   if search(v_file) = ? then do:
      message "**文件不存在. 请检查后重新输入." view-as alert-box.
      next.
   end.
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
		       &printWidth = 80
		       &pagedFlag = " "
		       &stream = " "
		       &appendToFile = " "
		       &streamedOutputToTerminal = " "
		       &withBatchOption = "no"
		       &displayStatementType = 1
		       &withCancelMessage = "yes"
		       &pageBottomMargin = 6
		       &withEmail = "yes"
		       &withWinprint = "yes"
		       &defineVariables = "yes"}
   /*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

   /*GUI*/ 
   {mfguichk.i } /*Replace mfrpchk*/
   empty temp-table td.
   v_line = 0.
   per_start = glc_start.
   per_end = glc_end.

	input from value(v_file) no-echo.
	repeat:
		v_line = v_line + 1.
		import unformatted v_txt.
		if v_line = 1 then next.
		if num-entries(v_txt,",") < 5 then do:
			put "第：" v_line "行数据不足" skip.
			next.
		end.
		v_part = trim(entry(2,v_txt,",")).
		find first pt_mstr where pt_domain = global_domain and pt_part = v_part no-lock no-error.
		find first td where td_cc = trim(entry(1,v_txt,",")) and td_part = v_part no-error.
		if not avail td then do:
			create td.
			assign 
			   td_line = v_line
			   td_part = v_part
			   td_prod_line = pt_prod_line
			   td_cc = trim(entry(1,v_txt,","))
			   td_qty = int(trim(entry(3,v_txt,",")))
			   td_lbr_in = deci(trim(entry(4,v_txt,",")))
			   td_mfg_in = deci(trim(entry(5,v_txt,","))).
			if not avail pt_mstr then do:
				assign td_reason = "零件不存在".
				next.
			end.
			/* 取标准成本 */
			/*
			find first code_mstr where code_fldname = "so site" and pt_part begins code_value no-lock no-error.
			if avail code_mstr then v_site = code_cmmt.
			else assign v_site = "dcec-c".
			*/
			find last tr_hist use-index tr_part_eff 
		  where tr_domain = global_domain 
			  and tr_part = td_part
				and tr_effdate >= glc_start
				and tr_effdate <= glc_end
				and tr_type = "RCT-WO" no-lock no-error.
			if avail tr_hist then assign v_site = tr_site.
			else assign v_site = "dcec-c".	

			find last yywobmspt_mstr where yywobmspt_domain = global_domain 
			  and yywobmspt_site = v_site
				and yywobmspt_part = td_part
				and (year(yywobmspt_mod_date) < v_year or
				     (year(yywobmspt_mod_date) = v_year 
				       and month(yywobmspt_mod_date)<= v_period))  no-lock no-error.
			if not avail yywobmspt_mstr then do:
				find last yywobmspt_mstr where yywobmspt_domain = global_domain 
			    and yywobmspt_site = v_site
					and yywobmspt_part = td_part no-lock no-error.
				if not avail yywobmspt_mstr then do:
					find last yywobmspt_mstr where yywobmspt_domain = global_domain 
			       and yywobmspt_part = td_part no-lock no-error.
					if not avail yywobmspt_mstr then do:
						assign td_reason = "未镜像，无标准成本".
						next.
					end. /*if not avail yywobmspt_mstr */
				end. /* if not avail yywobmspt_mstr */
			end. /* if not avail yywobmspt_mstr */
			assign v_site = yywobmspt_site
			       v_version = yywobmspt_version.

			find first yywobmspt_mstr where yywobmspt_domain = global_domain 
			  and yywobmspt_site = v_site
				and yywobmspt_part = td_part
				and yywobmspt_version = v_version 
				and yywobmspt_elem = "直接人工" no-lock no-error.
			if avail yywobmspt_mstr then assign 
				td_lbr_cost = td_qty * yywobmspt_elem_tl_cost.
			

			find first yywobmspt_mstr where yywobmspt_domain = global_domain 
			  and yywobmspt_site = v_site
				and yywobmspt_part = td_part
				and yywobmspt_version = v_version 
				and yywobmspt_elem = "制造费用" no-lock no-error.
			if avail yywobmspt_mstr then assign 
				td_mfg_cost = td_qty * yywobmspt_elem_tl_cost.
			/***********************************去掉低层成本 
			for each yywobmsptd_det no-lock where yywobmsptd_site = v_site
				and yywobmsptd_part = td_part
				and yywobmsptd_version = v_version :
				if yywobmsptd_elem = "直接人工" then 
					assign td_lbr_cost = td_lbr_cost - td_qty * yywobmsptd_unit_qty * yywobmsptd_elem_cost.
				else if yywobmsptd_elem = "制造费用" then  
					assign td_mfg_cost = td_mfg_cost - td_qty * yywobmsptd_unit_qty * yywobmsptd_elem_cost.
			end. 
			******************************/
				
			
			assign td_reason = "成功".
		end. /* if not avail td  */
		
	

	end. /* repeat */
	input close.
	put "导入数据明细" skip.
	for each td :	
		td_lbr_var = td_lbr_in - td_lbr_cost.
		td_mfg_var = td_mfg_in - td_mfg_cost.
		disp 
		   td
		with frame d stream-io.
		down with frame d.
	end. /* for each td */	

	if v_update then do:
		/* 清空数据 */
		for each yylbrmfg_det where yylbrmfg_domain = global_domain and yylbrmfg_year = v_year
			and yylbrmfg_per = v_period:
			delete yylbrmfg_det.
		end. /* for each yylbrmfg_det */
		for each yyvarated_det where yyvarated_domain = global_domain and yyvarated_year = v_year
			and yyvarated_per = v_period:
			assign yyvarated_lbr_rate = 0
			       yyvarated_mfg_rate = 0.    
		end. /* for each yyvarated_det */	
		for each td no-lock:
			find first yylbrmfg_det where yylbrmfg_domain = global_domain and yylbrmfg_year = v_year
				and yylbrmfg_per = v_period
				and yylbrmfg_cc = td_cc
				and yylbrmfg_part = td_part no-error.
			if not avail yylbrmfg_det then do:
				create yylbrmfg_det.
				assign 
				   yylbrmfg_domain = global_domain
				   yylbrmfg_year = v_year
				   yylbrmfg_per = v_period
				   yylbrmfg_cc = td_cc
				   yylbrmfg_part = td_part
				   yylbrmfg_prod_line = td_prod_line.
			end. /* if not avial */
			yylbrmfg_lbr_tl = td_lbr_in - td_lbr_cost.
			yylbrmfg_lbr_std = td_lbr_cost.
			yylbrmfg_mfg_tl = td_mfg_in - td_mfg_cost.
			yylbrmfg_mfg_std = td_mfg_cost.
			
		end. /* for each td */	
		for each yypbd_det no-lock where yypbd_domain = global_domain and yypbd_year = v_year
			and yypbd_per = v_period
			and (yypbd_lbr_var <> 0 or yypbd_mfg_var <> 0):
			find first  yylbrmfg_det where yylbrmfg_domain = global_domain and yylbrmfg_year = v_year
				and yylbrmfg_per = v_period
				and yylbrmfg_part = yypbd_part no-error.
			if not avail yylbrmfg_det then do:
				create yylbrmfg_det.
				assign 
				   yylbrmfg_domain = global_domain 
				   yylbrmfg_year = v_year
				   yylbrmfg_per = v_period
				   yylbrmfg_part = yypbd_part
				   yylbrmfg_prod_line = yypbd_part_pl. 
			end. /* if not avail yylbrmfg_det */

		end. /* for each yypbd_det */
		/* 依次计算产品类为6、5、7、8的工费分摊率 */
		run yypro-cal-var("6",output v_ok). 
		run yypro-cal-var("5",output v_ok). 
		run yypro-cal-var("7",output v_ok). 
		run yypro-cal-var("8",output v_ok). 
	end. /* if v_update */

   empty temp-table td.

				
    /*GUI*/ 
   {mfguitrl.i} /*Replace mfrtrail*/
   {mfgrptrm.i} /*Report-to-Window*/

  {wbrp04.i &frame-spec = a}

end. /* repeat */

/*GUI*/ 
{wbrp04.i &frame-spec = a}

/***********************************/
PROCEDURE yypro-cal-var:  
    define input parameter  p_line as char.
    define output parameter p_ok as logical.
	/* 计算自制件 */
	if p_line = "6" then do:
		put "计算产品以6开头分摊率" skip.
		put "----------------------------------------------------" skip.
		for each yylbrmfg_det where yylbrmfg_year = v_year
			and yylbrmfg_per = v_period
			and yylbrmfg_prod_line begins "6"
			use-index yylbrmfg_pl
			group by yylbrmfg_part:
			
			tot_lbr_amt = tot_lbr_amt + yylbrmfg_lbr_tl + yylbrmfg_lbr_ll.
			tot_mfg_amt = tot_mfg_amt + yylbrmfg_mfg_tl + yylbrmfg_mfg_ll.
			

			if last-of( yylbrmfg_part) then do:
				find first  yyvarated_det where yyvarated_domain = global_domain and yyvarated_part = yylbrmfg_part
					and yyvarated_year = v_year
					and yyvarated_per = v_period no-error.
				if not avail yyvarated_det then do:
					create yyvarated_det.
					assign 
					   yyvarated_domain = global_domain
					   yyvarated_year = v_year
					   yyvarated_per = v_period
					   yyvarated_part = yylbrmfg_part
					   yyvarated_part_pl = yylbrmfg_prod_line.
				end.
				find first yyinvi_mstr where yyinvi_domain = global_domain and yyinvi_year = v_year
				and yyinvi_per = v_period
				and yyinvi_part = yylbrmfg_part no-lock no-error.
				if avail yyinvi_mstr then do:
					if can-find(first code_mstr where code_domain = global_domain and code_fldname = "sub_line" and code_value = yyinvi_part_pl no-lock)then
					assign v_pcqty = min(yyinvi_mfg_qty, yyinvi_buy_qty) + yyinvi_upl_qty.
					else assign v_pcqty = yyinvi_mfg_qty + yyinvi_upl_qty + yyinvi_buy_qty.
				end.
				else
					assign v_pcqty = 0.
				/* 期初库存与期初工费差异 */
				find first yypbd_det where yypbd_domain = global_domain and yypbd_year = v_year
					and yypbd_per = v_period
					and yypbd_part = yylbrmfg_part no-lock no-error.
				if avail yypbd_det then 
					assign v_pbqty = yypbd_qty
					       v_pblbr_amt = yypbd_lbr_var
					       v_pbmfg_amt = yypbd_mfg_var.
				else 
					assign v_pbqty = 0
					       v_pblbr_amt = 0
					       v_pbmfg_amt = 0.
				
				if (v_pbqty + v_pcqty) <> 0 then assign 
					yyvarated_lbr_rate = (v_pblbr_amt + tot_lbr_amt) / (v_pbqty + v_pcqty)
					yyvarated_mfg_rate = (v_pbmfg_amt + tot_mfg_amt) / (v_pbqty + v_pcqty).
				else assign 
					yyvarated_lbr_rate = (v_pblbr_amt + tot_lbr_amt)
					yyvarated_mfg_rate = (v_pbmfg_amt + tot_mfg_amt).
				find first yycsvar_mstr where yycsvar_domain = global_domain and yycsvar_year = v_year
					and yycsvar_per = v_period
					and yycsvar_part = yylbrmfg_part no-error.
				if not avail yycsvar_mstr then do:
					create yycsvar_mstr.
					assign 
					   yycsvar_domain = global_domain
					   yycsvar_year = v_year
					   yycsvar_per = v_period
					   yycsvar_part = yylbrmfg_part
					   yycsvar_part_pl = yylbrmfg_prod_line.

				end.
				assign
				   yycsvar_variance[16] = 0
				   yycsvar_variance[17] = tot_lbr_amt
				   yycsvar_variance[18] = 0
				   yycsvar_variance[19] = tot_mfg_amt.
				tot_lbr_amt = 0.
				tot_mfg_amt = 0.
				
				disp 
				  yylbrmfg_part
				  yylbrmfg_prod_line
				  v_pbqty
				  v_pcqty
				  v_pblbr_amt
				  yycsvar_variance[16]
				  yycsvar_variance[17]
				  yyvarated_lbr_rate
				  v_pbmfg_amt
				  yycsvar_variance[18]
				  yycsvar_variance[19]
				  yyvarated_mfg_rate
				with frame e down stream-io.
				down with frame e.

			end. /* if last-of */
		end. /* for each yylbrmfg_det */  
		p_ok = true. 
	end. /* if p_line = "6" */
	else do:
		if p_line = "5" then
			put skip(1) "计算产品类以5开头分摊率" skip.
		else if p_line = "7" then
			put skip(1) "计算产品类以7开头分摊率" skip.
		else if p_line = "8" then
			put skip(1) "计算产品类以8开头分摊率" skip.

		put "----------------------------------------------------" skip.
		for each yycsvar_mstr where yycsvar_domain = global_domain and yycsvar_part_pl begins p_line
			and yycsvar_year = v_year
			and yycsvar_per = v_period
			use-index yycsvar_part:
			assign yycsvar_variance[16] = 0
			       yycsvar_variance[17] = 0
			       yycsvar_variance[18] = 0 
			       yycsvar_variance[19] = 0.
		end. /* for each yycsvard_det */
		for each yycsvard_det where yycsvard_domain = global_domain and yycsvard_year = v_year
			and yycsvard_per = v_period
			and yycsvard_part_pl begins p_line
			use-index yycsvard_pl_y:
			assign yycsvard_variance[16] = 0
			       yycsvard_variance[18] = 0.
		end. /* for each yycsvard_det */
		wo_loop:
		for each wo_mstr no-lock where wo_domain = global_domain and wo_status = "C"
			and ( wo_type = "C" or wo_type = "E")
			and  (wo_due_date >= per_start and wo_due_date <= per_end):
			
			find first pt_mstr where pt_domain = global_domain and pt_part = wo_part no-lock no-error.
			if not (avail pt_mstr and pt_prod_line begins p_line) then next.
			assign v_prod_line = pt_prod_line.

			wod_loop:
			for each wod_det no-lock where wod_domain = global_domain and wod_lot = wo_lot
				and wod_qty_iss <> 0:
				/* 不重复计算自己改制自己 */
				if wo_type = "E" and wo_part = wod_part then next.

				find first pt_mstr where pt_domain = global_domain and pt_part = wod_part no-lock no-error.
				if not avail pt_mstr then next.
				find first ptp_det where ptp_domain = global_domain and ptp_part = wod_part and ptp_site = wod_site no-lock no-error.
				/*
				if avail ptp_det and ptp_pm_code <> "M" then next.
				else if not avail ptp_det and pt_pm_code <> "M" then next.
				*/
				find first yyvarated_det where yyvarated_domain = global_domain and yyvarated_year = v_year
					and yyvarated_per = v_period
					and yyvarated_part = wod_part no-lock no-error.
				if not avail yyvarated_det then next.
				find first yylbrmfg_det where yylbrmfg_domain = global_domain and yylbrmfg_year = v_year
					and yylbrmfg_per = v_period
					and yylbrmfg_part = wo_part no-error.
				if not avail yylbrmfg_det then do:
					create yylbrmfg_det.
					assign 
					   yylbrmfg_domain = global_domain
					   yylbrmfg_year = v_year
					   yylbrmfg_per = v_period
					   yylbrmfg_part = wo_part
					   yylbrmfg_prod_line = v_prod_line.
				end.
				yylbrmfg_lbr_ll = yylbrmfg_lbr_ll + wod_qty_iss * yyvarated_lbr_rate.
				yylbrmfg_mfg_ll = yylbrmfg_mfg_ll + wod_qty_iss * yyvarated_mfg_rate.
				
				find first yycsvard_det where yycsvard_domain = global_domain and yycsvard_year = v_year
					and yycsvard_per = v_period
					and yycsvard_part = yylbrmfg_part
					and yycsvard_comp = wod_part no-error.
				if not avail yycsvard_det then do:
					create yycsvard_det.
					assign 
					   yycsvard_domain = global_domain
					   yycsvard_year = v_year
					   yycsvard_per = v_period
					   yycsvard_part = yylbrmfg_part
					   yycsvard_part_pl = yylbrmfg_prod_line
					   yycsvard_comp_pl = pt_prod_line.
				end. /* if not avail yycsvard_det */
				yycsvard_variance[16] = yycsvard_variance[16] + wod_qty_iss * yyvarated_lbr_rate.
				yycsvard_variance[18] = yycsvard_variance[18] + wod_qty_iss * yyvarated_mfg_rate.
			end. /* for each wod_det */
		end. /* for each wo_mstr */

		for each yylbrmfg_det where yylbrmfg_domain = global_domain 
		  and yylbrmfg_year = v_year
			and yylbrmfg_per = v_period
			and yylbrmfg_prod_line begins p_line 
			use-index yylbrmfg_pl:

			find first yyinvi_mstr where yyinvi_domain = global_domain 
			  and yyinvi_year = v_year
				and yyinvi_per = v_period
				and yyinvi_part = yylbrmfg_part no-lock no-error.
			if avail yyinvi_mstr then do:
				if can-find(first code_mstr where code_domain = global_domain and code_fldname = "sub_line" and code_value = yyinvi_part_pl no-lock)then
				assign v_pcqty = min(yyinvi_mfg_qty, yyinvi_buy_qty) + yyinvi_upl_qty.
				else assign v_pcqty = yyinvi_mfg_qty + yyinvi_upl_qty + yyinvi_buy_qty.
			end.
			else
				assign v_pcqty = 0.
			/* 期初库存,期初工费差异 */
			find first yypbd_det where yypbd_domain = global_domain 
			  and yypbd_year = v_year
				and yypbd_per = v_period
				and yypbd_part = yylbrmfg_part no-lock no-error.
			if avail yypbd_det then 
				assign v_pbqty = yypbd_qty
				       v_pblbr_amt = yypbd_lbr_var
				       v_pbmfg_amt = yypbd_mfg_var.
			else
				assign v_pbqty = 0
				       v_pblbr_amt = 0
				       v_pbmfg_amt = 0.
			
			find first  yyvarated_det where yyvarated_domain = global_domain 
			  and yyvarated_part = yylbrmfg_part
				and yyvarated_year = v_year
				and yyvarated_per = v_period no-error.
			if not avail yyvarated_det then do:
				create yyvarated_det.
				assign 
				   yyvarated_domain = global_domain 
				   yyvarated_year = v_year
				   yyvarated_per = v_period
				   yyvarated_part = yylbrmfg_part
				   yyvarated_part_pl = yylbrmfg_prod_line.
			end.
			if (v_pbqty + v_pcqty) <> 0 then assign 
				yyvarated_lbr_rate = (v_pblbr_amt + yylbrmfg_lbr_tl + yylbrmfg_lbr_ll) / (v_pbqty + v_pcqty)
				yyvarated_mfg_rate = (v_pbmfg_amt + yylbrmfg_mfg_tl + yylbrmfg_mfg_ll) / (v_pbqty + v_pcqty).
			else assign 
				yyvarated_lbr_rate = (v_pblbr_amt + yylbrmfg_lbr_tl + yylbrmfg_lbr_ll)
				yyvarated_mfg_rate = (v_pbmfg_amt + yylbrmfg_mfg_tl + yylbrmfg_mfg_ll).
			find first yycsvar_mstr where yycsvar_domain = global_domain 
			  and yycsvar_year = v_year
				and yycsvar_per = v_period
				and yycsvar_part = yylbrmfg_part no-error.
			if not avail yycsvar_mstr then do:
				create yycsvar_mstr.
				assign 
				   yycsvar_domain = global_domain
				   yycsvar_year = v_year
				   yycsvar_per = v_period
				   yycsvar_part = yylbrmfg_part
				   yycsvar_part_pl = yylbrmfg_prod_line.

			end.
			assign
			   yycsvar_variance[16] = yylbrmfg_lbr_ll
			   yycsvar_variance[17] = yylbrmfg_lbr_tl
			   yycsvar_variance[18] = yylbrmfg_mfg_ll
			   yycsvar_variance[19] = yylbrmfg_mfg_tl.
			disp 
			  yylbrmfg_part
			  yylbrmfg_prod_line
			  v_pbqty
			  v_pcqty
			  v_pblbr_amt
			  yycsvar_variance[16]
			  yycsvar_variance[17]
			  yyvarated_lbr_rate
			  v_pbmfg_amt
			  yycsvar_variance[18]
			  yycsvar_variance[19]
			  yyvarated_mfg_rate
			with frame e down stream-io.
			down with frame e.   
		end. /* for each yylbrmfg_det */
		p_ok = true.
	end. /* else if p_line = "6" */
	
END PROCEDURE.
