/* yyppvcal.p - 当期各材料PPV差异率计算              */
/* Author: James Duan *DATE:2009-09-15*              */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

define variable lupdate		like mfc_logical.
define variable lupdate2	like mfc_logical initial false.
define variable theyear		like yyinvi_year format "9999".
define variable theper		like yyinvi_per format "99".

define variable part		like pt_part.
define variable part1		like pt_part.
define variable per_start	like glc_start.
define variable per_end		like glc_end.
define variable stdcost		like yywobmspt_elem_cost.
define variable varpbamt	like yyvarpbd_mtl_var.
define variable pbqty		like yyinvpbd_qty.
define variable pcqty		like yyinvpbd_qty.
define variable pcrate		as decimal.
define variable povaramt	like yyvarpbd_mtl_var.
define variable vovaramt	like yyvarpbd_mtl_var.
define variable v_costset	as character.
define temp-table ttvar
	fields ttvar_part like pt_part
	fields ttvar_povaramt like yyvarpbd_mtl_var
	fields ttvar_vovaramt like yyvarpbd_mtl_var
index main_index is primary unique ttvar_part.

theyear = year(today).
theper = month(today).

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

form
    ttvar_part column-label "材料"
    varpbamt column-label "期初差异"
    ttvar_povaramt column-label "采购价格差异" format "->>>,>>>,>>9.99"
    ttvar_vovaramt column-label "发票价格差异" format "->>>,>>>,>>9.99"
    pbqty column-label "期初库存数量"  
    pcqty column-label "当期库存数量" 
    pcrate column-label "差异率" format "->>>,>>>,>>9.99"
with centered overlay down frame d width 320.


FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
 part		colon 20
 part1		colon 50
 theyear	colon 20 label "年"
 theper		colon 50 label "期间"	
 lupdate	colon 20 label "重新计算PPV差异率"
 lupdate2	colon 20 label "系统计算发票价格差异"
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
			
	find glc_cal where glc_year = theyear and glc_per = theper no-lock no-error.

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
	/* 计算采购价格差异 */			
	for each prh_hist no-lock where prh_rcp_date >= per_start and prh_rcp_date <= per_end
		/* and prh_site >= site and prh_site <= site1 */
		and prh_part >= part and prh_part <= part1:
	    find first ttvar where ttvar_part = prh_part no-error.
	    if not avail ttvar then do:
		create ttvar.
		assign
		    ttvar_part = prh_part.
	    end.

	    /* 标准成本 = 材料成本 + 关税运费 */
	    stdcost = 0.
	    find first in_mstr where in_part = ttvar_part and in_site = prh_site no-lock no-error.
	    v_costset = (if available in_mstr and in_gl_set <> "" then in_gl_set else "STANDARD").
	    
	    /*****************************************************
	    find first sct_det where sct_site = prh_site 
		and sct_part = ttvar_part
		and sct_sim = v_costset no-lock no-error.
	    if available sct_det then assign stdcost = sct_mtl_ll + sct_mtl_tl.
	    *******************************************************/
	   
	    for each spt_det no-lock where spt_site = prh_site
		and spt_part = ttvar_part 
		and spt_sim = v_costset :
		if spt_element = "材料" or spt_element = "关税运费" then 
		assign stdcost = stdcost + spt_cst_tl + spt_cst_ll.
	    end. /* for each spt_det */
	    
	    ttvar_povaramt = ttvar_povaramt + prh_rcvd * (prh_pur_cost - stdcost).

	end. /* for each prh_hist */
	if lupdate2 then do:
		/* 计算发票价格差异 */	
		for each vph_hist no-lock where vph_inv_date >= per_start and vph_inv_date <= per_end:
			find first pvo_mstr where pvo_id = vph_pvo_id no-lock no-error.
			if not avail pvo_mstr then next.
			find first prh_hist where prh_receiver = pvo_internal_ref 
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
			ttvar_vovaramt = ttvar_vovaramt + vph_inv_qty * (vph_inv_cost - prh_pur_cost).

		end. /* for each vph_hist */
	end. /* if lupdate2 */

	for each ttvar no-lock:
		
		/* 取期初库存 */
		find first yyinvpbd_det where yyinvpbd_part = ttvar_part
			and yyinvpbd_year = theyear
			and yyinvpbd_per  = theper no-lock no-error.
		if avail yyinvpbd_det then assign pbqty = yyinvpbd_qty.
		else assign pbqty = 0.

		/* 取本期入库量 */
		find first yyinvi_mstr where yyinvi_part = ttvar_part
			and yyinvi_year = theyear
			and yyinvi_per = theper no-lock no-error.
		if avail yyinvi_mstr then assign pcqty = yyinvi_buy_qty.
		else assign pcqty = 0.

		/* 取期初差异 */
		find first yyvarpbd_det where yyvarpbd_part = ttvar_part
			and yyvarpbd_year = theyear
			and yyvarpbd_per  = theper no-lock no-error.
		if avail yyvarpbd_det then assign varpbamt = yyvarpbd_mtl_var.
		else assign varpbamt = 0.

		/* 取发票价格差异 */
		if not lupdate2 then do:
			find first yycsvar_mstr where yycsvar_part = ttvar_part
				and yycsvar_pm_code = "P"
				and yycsvar_year = theyear
				and yycsvar_per = theper no-error.
			if available yycsvar_mstr then do:
				ttvar_vovaramt = yycsvar_variance[14].
			end.
		end. /* if not lupdate2 */
		if pbqty + pcqty = 0 then assign pcrate = (ttvar_povaramt + ttvar_vovaramt).
		else assign pcrate = (varpbamt + ttvar_povaramt + ttvar_vovaramt) / (pbqty + pcqty).
		/* 显示差异 */
		display
		    ttvar_part
		    varpbamt         format "->>>,>>>,>>>,>>9.99"
		    ttvar_povaramt   format "->>>,>>>,>>>,>>9.99"
		    ttvar_vovaramt   format "->>>,>>>,>>>,>>9.99"
		    pbqty format "->>>,>>>,>>>,>>9"
		    pcqty format "->>>,>>>,>>>,>>9"
		    pcrate format "->>>,>>>,>>>,>>9.99"
		with frame d.
		down with frame d.				
		if lupdate then do:
			find first pt_mstr where pt_part = ttvar_part no-lock no-error.
			find first yycsvar_mstr where yycsvar_part = ttvar_part
				and yycsvar_pm_code = "P"
				and yycsvar_year = theyear
				and yycsvar_per = theper no-error.
			if not available yycsvar_mstr then do:
				create yycsvar_mstr.
				assign
				    yycsvar_part = ttvar_part
				    yycsvar_pm_code = "P"
				    yycsvar_year = theyear
				    yycsvar_per = theper.
			end. /* if not available yycsvar_mstr */
			if avail pt_mstr then assign yycsvar_part_pl = pt_prod_line.
			assign yycsvar_variance[13] = ttvar_povaramt /* PPV-采购价格差异 */
			       yycsvar_variance[14] = ttvar_vovaramt. /* PPV-发票价格差异 */

			/* 更新ppv差异率 */
			find first yyvarated_det where yyvarated_part = ttvar_part
				and yyvarated_year = theyear
				and yyvarated_per = theper no-error.
			if not avail yyvarated_det then do:
				create yyvarated_det.
				assign 
				    yyvarated_part = ttvar_part
				    yyvarated_year = theyear
				    yyvarated_per = theper.
			end. /* if not avail yyvarated_det */
			if avail pt_mstr then assign yyvarated_part_pl = pt_prod_line.
			if pbqty + pcqty = 0 then yyvarated_mtl_rate = (varpbamt + ttvar_povaramt + ttvar_vovaramt).
			else yyvarated_mtl_rate = (varpbamt + ttvar_povaramt + ttvar_vovaramt) / (pbqty + pcqty).

		end. /* if lupdate */
	end. /*for each ttvar */
	for each ttvar:
		delete ttvar.	
	end.

			
	{mfguitrl.i} /*Replace mfrtrail*/
	{mfgrptrm.i} /*Report-to-Window*/

	{wbrp04.i &frame-spec = a}
end. /* repeat */

/*GUI*/ 
{wbrp04.i &frame-spec = a}
