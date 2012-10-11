/* yyppvcal.p - 当期各材料PPV差异率计算              */
/* Author: James Duan *DATE:2009-09-15*              */
/* Author: Henri Zhu  *DATE:2012-08-14*              */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
/*
{mfdtitle.i "2+ "}
*/

/* Author: Henri Zhu  *DATE:2012-08-14*              */
{mfdtitle.i "20120814"}
/* Author: Henri Zhu  *DATE:2012-08-14*              */

define variable lupdate		like mfc_logical.
define variable lupdate2	like mfc_logical initial false.
define variable theyear		like yyinvi_year format "9999".
define variable theper		like yyinvi_per format "99".

define variable part		like pt_part.
define variable part1		like pt_part.
define variable per_start	like glc_start.
define variable per_end		like glc_end.
define variable stdcost		like yywobmspt_elem_cost.
define variable varpbamt	like yypbd_mtl_var.
define variable pbqty		like yypbd_qty.
define variable pcqty		like yypbd_qty.
define variable pcrate		as decimal.
define variable povaramt	like yypbd_mtl_var.
define variable vovaramt	like yypbd_mtl_var.

define variable v_pm_code	as character.
define temp-table ttvar
	fields ttvar_part like pt_part
	fields ttvar_pm_flag as logical
	fields ttvar_povaramt like yypbd_mtl_var 
	fields ttvar_vovaramt like yypbd_mtl_var
	fields ttvar_vovaramt2 like yypbd_mtl_var 
	fields ttvar_revalued like yypbd_mtl_var
index main_index is primary unique ttvar_part.

theyear = year(today).
theper = month(today).

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

form
    ttvar_part column-label "材料"
    pt_prod_line column-label "产品类"

    varpbamt column-label "期初差异"		format "->>>,>>>,>>>,>>9.99"

    ttvar_povaramt column-label "采购价格差异"	format "->>>,>>>,>>>,>>9.99"

    ttvar_vovaramt column-label "发票价格差异"	format "->>>,>>>,>>>,>>9.99"

    ttvar_revalued column-label "重估差异"	format "->>>,>>>,>>>,>>9.99"
    pbqty column-label "期初库存数量"		format "->>>,>>>,>>>,>>9"
    pcqty column-label "当期库存数量"		format "->>>,>>>,>>>,>>9"
    pcrate column-label "差异率"		format "->>>,>>>,>>>,>>9.99"
with frame d ATTR-SPACE width 400 down.


FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
 part		colon 30
 part1		colon 60
 theyear	colon 30 label "年"
 theper		colon 60 label "期间"	
 lupdate	colon 30 label "重新计算PPV差重估差异及异率"
 lupdate2	colon 30 label "系统计算发票价格差异"
 SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = "当期各材料PPV差异率计算".
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
	IF part1 = hi_char THEN part1 = "".   
	update
	part part1 
	theyear theper 
	lupdate lupdate2
	with frame a.

	if part1 = "" then part1 = hi_char.
			
	find glc_cal where glc_domain = global_domain and glc_year = theyear and glc_per = theper no-lock no-error.

	if available glc_cal then do:
		per_start = glc_start.
		per_end = glc_end.
	end.
	else do:
		message "财务期间未定义！" view-as alert-box.
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

	theyear = glc_year.
	theper = glc_per.
	/* 初始化 */
	if lupdate then do:
		for each yycsvar_mstr where yycsvar_domain = global_domain and yycsvar_year = theyear
			and yycsvar_per = theper
			and yycsvar_part >= part
			and yycsvar_part <= part1:
			if yycsvar_pm_code = "P" then 
				assign  yycsvar_variance[13] = 0
					yycsvar_variance[14] = 0.
			assign yycsvar_variance[20] = 0
			       yycsvar_variance[21] = 0
			       yycsvar_variance[22] = 0.
			
		end. /* for each */
		for each yyvarated_det where yyvarated_domain = global_domain and yyvarated_year = theyear
			and yyvarated_per = theper
			and yyvarated_part >= part
			and yyvarated_part <= part1:
			assign yyvarated_mtl_rate = 0.
		end. /* for each yyvarated_det */

	end. /* if lupdate */
	/* 计算采购价格差异 */			
	for each prh_hist no-lock where prh_domain = global_domain and prh_rcp_date >= per_start and prh_rcp_date <= per_end
		/* and prh_site >= site and prh_site <= site1 */
		and prh_part >= part and prh_part <= part1:
	    find first ttvar where ttvar_part = prh_part no-error.
	    if not avail ttvar then do:
		create ttvar.
		assign
		    ttvar_part = prh_part.
	    end.

	    /* 标准成本 = 材料成本 or 转包成本 */
	    stdcost = 0.
	    /*****************************************************
	    find first sct_det where sct_site = prh_site 
		and sct_part = ttvar_part
		and sct_sim = v_costset no-lock no-error.
	    if available sct_det then assign stdcost = sct_mtl_ll + sct_mtl_tl.
	    *******************************************************/
	    find first pt_mstr where pt_domain = global_domain and pt_part = prh_part no-lock no-error.
	    if not avail pt_mstr then next.
	    find first code_mstr where code_domain = global_domain and code_fldname = "sub_line" and code_value = pt_prod_line no-lock no-error.
	    /* 外委 */
	    if avail code_mstr then  
		stdcost = prh_sub_std.
	    else 
		assign stdcost =  prh_mtl_std.

	    
	    ttvar_povaramt = ttvar_povaramt + prh_rcvd * (prh_pur_cost - stdcost).
       

	end. /* for each prh_hist */
	if lupdate2 then do:
		/* 计算发票价格差异 */	
		for each vph_hist no-lock where vph_domain = global_domain and vph_inv_date >= per_start and vph_inv_date <= per_end:
			find first pvo_mstr where pvo_domain = global_domain and pvo_id = vph_pvo_id no-lock no-error.
			if not avail pvo_mstr then next.
			find first prh_hist where prh_domain = global_domain and prh_receiver = pvo_internal_ref 
				and pvo_line = prh_line no-lock no-error.
			if not avail prh_hist 
			/* or (prh_site > site1 or prh_site < site) */
			or (prh_part > part1 or prh_part < part) then next.
			find first ttvar where ttvar_part = prh_part no-error.
			if not avail ttvar then do:
				create ttvar.
				assign
				    ttvar_part = prh_part.
			end.
			ttvar_vovaramt2 = ttvar_vovaramt2 + vph_inv_qty * (vph_inv_cost - prh_pur_cost).

		end. /* for each vph_hist */
	end. /* if lupdate2 */
	/* 取导入发票价格差异 */
	for each yycsvar_mstr no-lock where yycsvar_domain = global_domain and yycsvar_year = theyear
		and yycsvar_per = theper
		and yycsvar_part >= part and yycsvar_part <= part1
		and yycsvar_pm_code = "P" 
		and yycsvar_variance[15] <> 0:
	
		find first ttvar where ttvar_part = yycsvar_part no-error.
		if not avail ttvar then do:
			create ttvar.
			assign
			    ttvar_part = yycsvar_part.
		end.
		ttvar_vovaramt = yycsvar_variance[15].
	end. /* for each yycsvar_mstr */

	/* 计算重估差异 */
	for each code_mstr no-lock where code_domain = global_domain and code_fldname = "revalued_account" :
		for each gltr_hist use-index gltr_acc_ctr where gltr_domain = global_domain and gltr_acc = code_value
			and gltr_eff_dt >= per_start and gltr_eff_dt <= per_end
		   ,each trgl_det use-index trgl_ref_nbr where trgl_domain = global_domain and trgl_gl_ref = gltr_ref
		   ,each tr_hist use-index tr_trnbr where tr_domain = global_domain and tr_trnbr = trgl_trnbr no-lock:

			if tr_type = "iss-wo" then do:
				find first wo_mstr where wo_domain = global_domain and wo_lot = tr_lot no-lock no-error.
				if wo_part > part1 or wo_part < part then next.
				find first ttvar where ttvar_part = wo_part no-error.
				if not avail ttvar then do:
					create ttvar.
					assign
					    ttvar_part = wo_part
					    ttvar_pm_flag = true.
				end.
				ttvar_revalued = ttvar_revalued + gltr_amt.
			end.
			else do:
				if tr_part > part1 or tr_part < part then next.
				find first ttvar where ttvar_part = tr_part no-error.
				if not avail ttvar then do:
					create ttvar.
					assign
					    ttvar_part = tr_part
					    ttvar_pm_flag = true.
				end.
				ttvar_revalued = ttvar_revalued + gltr_amt.
			end. /* if tr_type = "iss-wo" */

		end. /* for each gltr_hist */
		
		for each gltr_hist use-index gltr_acc_ctr where gltr_domain = global_domain and gltr_acc = code_value
			and gltr_eff_dt >= per_start and gltr_eff_dt <= per_end
		   ,each opgl_det use-index opgl_ref_nbr where opgl_domain = global_domain and opgl_gl_ref = gltr_ref
		   ,each op_hist use-index op_trnbr where op_domain = global_domain and op_trnbr = opgl_trnbr no-lock:
			if op_part > part1 or op_part < part then next.
			find first ttvar where ttvar_part = op_part no-error.
			if not avail ttvar then do:
				create ttvar.
				assign
				    ttvar_part = op_part
				    ttvar_pm_flag = true.
			end.
			ttvar_revalued = ttvar_revalued + gltr_amt.
		end. /* for each gltr_hist */

	end. /* for each code_mstr */
	
	for each yypbd_det no-lock where yypbd_domain = global_domain  
	      and yypbd_year = theyear and yypbd_per = theper
        AND yypbd_part >= part AND yypbd_part <= part1:
	    IF NOT  (yypbd_part_pl begins "1" or yypbd_part_pl begins "2") THEN NEXT.
	   
		find first ttvar where ttvar_part = yypbd_part no-error.
		if avail ttvar then next.
		create ttvar.
		assign
		   ttvar_part = yypbd_part.
	end. /* for each yypbd_det */

	for each ttvar no-lock:
		
		/* 取期初库存，差异 */
		find first yypbd_det where yypbd_domain = global_domain 
		  and yypbd_year = theyear and yypbd_per  = theper
			and yypbd_part = ttvar_part no-lock no-error.
		if avail yypbd_det then 
			assign pbqty = yypbd_qty
			       varpbamt = yypbd_mtl_var.
		else 
			assign pbqty = 0
		               varpbamt = 0. 

		/* 取本期入库量 */
		find first yyinvi_mstr where yyinvi_domain = global_domain 
		  and yyinvi_year = theyear and yyinvi_per = theper
			and yyinvi_part = ttvar_part no-lock no-error.
		if avail yyinvi_mstr then assign pcqty = yyinvi_buy_qty + yyinvi_upl_qty.
		else assign pcqty = 0.

		if pbqty + pcqty = 0 then assign pcrate = (varpbamt + ttvar_povaramt + ttvar_vovaramt + ttvar_vovaramt2 + ttvar_revalued).
		else assign pcrate = (varpbamt + ttvar_povaramt + ttvar_vovaramt +  ttvar_vovaramt2 + ttvar_revalued) / (pbqty + pcqty).

		find first pt_mstr where pt_domain = global_domain and pt_part = ttvar_part no-lock no-error.
		if not avail pt_mstr then do:
			put "零件" ttvar_part "不存在" skip.
			next.
		end.
		if ttvar_pm_flag then do:
			if pt_prod_line begins "1" or pt_prod_line begins "2" then 
				assign v_pm_code = "P".
			else	assign v_pm_code = "M".
		end.
		else assign v_pm_code = "P".

		/* 显示差异 */
		display
		    ttvar_part
		    pt_prod_line
		    varpbamt         
		    ttvar_povaramt   
		    (ttvar_vovaramt + ttvar_vovaramt2) @ ttvar_vovaramt
		    ttvar_revalued
		    pbqty 
		    pcqty 
		    pcrate  
		with frame d stream-io.
		down with frame d.

		if lupdate then do:
			
			find first yycsvar_mstr where yycsvar_domain = global_domain 
			  and yycsvar_year = theyear and yycsvar_per = theper
				and yycsvar_part = ttvar_part no-error.
			if not available yycsvar_mstr then do:
				create yycsvar_mstr.
				assign 
				    yycsvar_domain = global_domain
				    yycsvar_part = ttvar_part
				    yycsvar_year = theyear
				    yycsvar_per = theper.
			end. /* if not available yycsvar_mstr */
			assign yycsvar_part_pl = pt_prod_line
			       yycsvar_pm_code = v_pm_code.	

			assign yycsvar_variance[13] = ttvar_povaramt /* PPV-采购价格差异 */
			       yycsvar_variance[14] = ttvar_vovaramt2 /* PPV-系统发票价格差异 */
			       yycsvar_variance[15] = ttvar_vovaramt /* PPV-导入发票价格差异 */
			       yycsvar_variance[20] = ttvar_revalued. /* 重估差异 */
			if can-find(first code_mstr where code_domain = global_domain and code_fldname = "sub_line" and code_value = yycsvar_part_pl no-lock) then
				assign 
				  yycsvar_variance[21] = ttvar_povaramt
				  yycsvar_variance[22] = ttvar_vovaramt2.
			/* 更新ppv差异率 */
			find first yyvarated_det where yyvarated_domain = global_domain 
			  and yyvarated_year = theyear and yyvarated_per = theper
				and yyvarated_part = ttvar_part no-error.
			if not avail yyvarated_det then do:
				create yyvarated_det.
				assign yyvarated_domain = global_domain
				    yyvarated_part = ttvar_part
				    yyvarated_year = theyear
				    yyvarated_per = theper.
			end. /* if not avail yyvarated_det */
			if avail pt_mstr then assign yyvarated_part_pl = pt_prod_line.
			if pbqty + pcqty = 0 then yyvarated_mtl_rate = (varpbamt + ttvar_povaramt + ttvar_vovaramt + ttvar_vovaramt2 + ttvar_revalued).
			else yyvarated_mtl_rate = (varpbamt + ttvar_povaramt + ttvar_vovaramt + ttvar_vovaramt2 + ttvar_revalued) / (pbqty + pcqty).

		end. /* if lupdate */
	end. /*for each ttvar */
	empty temp-table ttvar.

			
	{mfguitrl.i} /*Replace mfrtrail*/
	{mfgrptrm.i} /*Report-to-Window*/

	{wbrp04.i &frame-spec = a}
end. /* repeat */

/*GUI*/ 
{wbrp04.i &frame-spec = a}
