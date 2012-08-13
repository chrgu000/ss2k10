/* yyinvo.p - 计算材料、半成品/成品下个期间期初库存和期初差异 */
/*  Author: James Duan *DATE:2009-09-24*                      */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

define variable lupdate		like mfc_logical.
define variable ldetail		like mfc_logical.

define variable theyear		like yyinvpbd_year format "9999".
define variable theper		like yyinvpbd_per format "99".
define variable nxtyear		like yyinvi_year.
define variable nxtper		like yyinvi_per.
define variable v_flag		as   logical.
define variable per_start	like glc_start.
define variable per_end		like glc_end.
define variable bomversion	like yyinvpbd_std_bom.	
define temp-table ttpbd_det
	fields ttpbd_part	like yyinvpbd_part  
	fields ttpbd_prod_line  like pt_prod_line   
	fields ttpbd_amt	like yyvarpbd_mtl_var 
	fields ttpbd_qty	like yyinvpbd_qty	
	fields ttpbd_commt	as char format "x(20)"
index ttpbd_part IS PRIMARY UNIQUE ttpbd_part.

form
   nxtyear column-label "年"
   nxtper column-label "期间"
   ttpbd_part column-label "零件"
   ttpbd_prod_line column-label "产品类"
   ttpbd_amt column-label "期初差异"
   ttpbd_qty column-label "期初库存"
   ttpbd_commt column-label "备注"
with frame d width 320 down.

theyear = YEAR(TODAY).
theper = MONTH(TODAY).

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   theyear     colon 15 label "年份"
   theper       colon 50 label "期间"
   lupdate	    colon 15 label "更新"
   ldetail	    colon 15 label "显示无差异零件"
 SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = "下期期初库存及差异计算".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat :
	update 
	  theyear
	  theper
	  lupdate
	  ldetail
	with frame a.

	find first glc_cal where glc_year = theyear and glc_per = theper no-lock no-error.

	if available glc_cal then do:
		per_start = glc_start.
		per_end = glc_end.
	end.
	else do:
		message "财务期间未定义!" view-as alert-box.
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
	/* 取本期期初库存 */
	for each yyinvpbd_det no-lock where yyinvpbd_year = theyear
		and yyinvpbd_per = theper:
		find first ttpbd_det where ttpbd_part = yyinvpbd_part no-error.
		if not avail ttpbd_det then do:
			create ttpbd_det.
			assign
			    ttpbd_part = yyinvpbd_part
			    ttpbd_prod_line = yyinvpbd_part_pl.
		end. /* if not avail ttpbd_det */
		assign ttpbd_qty = ttpbd_qty + yyinvpbd_qty.
	end. /* for each yyinvpbd_det */

	/* 取本期入库库存 */
	for each yyinvi_mstr no-lock where yyinvi_year = theyear
		and yyinvi_per = theper:
		find first ttpbd_det where ttpbd_part = yyinvi_part no-error.
		if not avail ttpbd_det then do:
			create ttpbd_det.
			assign
			    ttpbd_part = yyinvi_part
			    ttpbd_prod_line = yyinvi_part_pl.
		end. /* if not avail ttpbd_det */
		assign ttpbd_qty = ttpbd_qty + yyinvi_mfg_qty + yyinvi_upl_qty + yyinvi_buy_qty.
	end. /* for each yyinvi_mstr */

	/*取本期出库库存*/
	for each yyinvo_mstr no-lock where yyinvo_year = theyear
		and yyinvo_per = theper:
		find first ttpbd_det where ttpbd_part = yyinvo_part no-error.
		if not avail ttpbd_det then do:
			create ttpbd_det.
			assign
			    ttpbd_part = yyinvo_part
			    ttpbd_prod_line = yyinvo_part_pl.
		end. /* if not avail ttpbd_det */
		assign ttpbd_qty = ttpbd_qty - yyinvo_qty.
	end. /* for each yyinvo_mstr */
	
	/* 计算下个期间 */
	nxtper = (if theper = 12 then 1 else (theper + 1)).
	nxtyear = (if theper = 12 then theyear + 1 else theyear).

	/* 显示下期期初库存和差异 */
	for each ttpbd_det :
		v_flag = false.
		/* 取期初差异 */
		find first yyvarpbd_det where yyvarpbd_year = theyear
			and yyvarpbd_per = theper
			and yyvarpbd_part = ttpbd_part no-lock no-error.
		if avail yyvarpbd_det then v_flag = true.	
		find first yycsvar_mstr where yycsvar_year = theyear
			and yycsvar_per = theper
			and yycsvar_part = ttpbd_part no-lock no-error.
		if avail yycsvar_mstr then v_flag = true.
		/* 取出本期材料料差 */
		find first yyvarated_det where yyvarated_year = theyear
			and yyvarated_per = theper
			and yyvarated_part = ttpbd_part no-lock no-error.
		if not v_flag then 
			assign ttpbd_commt = "无差异".
		else if v_flag and not avail yyvarated_det then 
			assign ttpbd_commt = "本期料差未计算". 
		else if avail yyvarated_det then
			assign ttpbd_amt = ttpbd_qty * yyvarated_mtl_rate.
		if not ldetail and ttpbd_commt = "无差异" then next.
		display
		   nxtyear
		   nxtper
		   ttpbd_part
		   ttpbd_prod_line
		   ttpbd_amt
		   ttpbd_qty
		   ttpbd_commt 
		with frame d.
		down with frame d.
	end.

	if lupdate then do:
		
		for each ttpbd_det no-lock where ttpbd_commt = "":
			
			bomversion = 0.
			find first pt_mstr where pt_part = ttpbd_part no-lock no-error.
			if not avail pt_mstr then next.
						
			/* 下期期初库存 */
			find first yyinvpbd_det where yyinvpbd_part = ttpbd_part
				and yyinvpbd_year = nxtyear
				and yyinvpbd_per = nxtper no-error.
			if not avail yyinvpbd_det then do:
				create yyinvpbd_det.
				assign 
				    yyinvpbd_part = ttpbd_part
				    yyinvpbd_year = nxtyear
				    yyinvpbd_per = nxtper.
			end. /* if not avail yyinvpbd_det */
			assign 
			    yyinvpbd_part_pl = pt_prod_line 
			    yyinvpbd_qty = ttpbd_qty.
			/* 取当前bom版本 */
			find last xxwobmfm_mstr where xxwobmfm_part = ttpbd_part
				use-index xxwobmfm_idx1 no-lock no-error.
			if avail xxwobmfm_mstr then assign yyinvpbd_std_bom = xxwobmfm_version.
			
			/* 下期期初差异 */
			find first yyvarpbd_det where yyvarpbd_part = ttpbd_part
				and yyvarpbd_year = nxtyear
				and yyvarpbd_per = nxtper no-error.
			if not avail yyvarpbd_det then do:
				create yyvarpbd_det.
				assign
				    yyvarpbd_part = ttpbd_part
				    yyvarpbd_year = nxtyear
				    yyvarpbd_per = nxtper.
			end. /* if not avail yyvarpbd_det */
			assign yyvarpbd_part_pl = pt_prod_line.
			assign 
			    yyvarpbd_mtl_var = ttpbd_amt.
		end. /*for each ttpbd_det */
		
	end. /* if lupdate */

	empty temp-table ttpbd_det.

			
	/*GUI*/ 
	{mfguitrl.i} /*Replace mfrtrail*/
	{mfgrptrm.i} /*Report-to-Window*/
	{wbrp04.i &frame-spec = a}
end. /* repeat */

/*GUI*/ 
{wbrp04.i &frame-spec = a}

