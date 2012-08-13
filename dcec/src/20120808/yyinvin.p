/*yyinvin.p - 当期材料入库，半成品/成品计划外入库计算 */
/*				  只算RCT-PO和RCT-UNP */
/* Author: James Duan *DATE:2009-09-10*               */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

define variable lupdate		like mfc_logical.

define variable theyear		like yyinvi_year.
define variable theper		like yyinvi_per.

define variable per_start	like glc_start.
define variable per_end		like glc_end.
define variable bomversion	like yyinvpbd_std_bom.	
define variable v_pmcode	like pt_pm_code. 
define temp-table ttinvi_mstr
	fields ttinvi_part like yyinvi_part label "零件"
	fields ttinvi_part_pl like yyinvi_part_pl  label "产品类"
	fields ttinvi_year like yyinvi_year label "年"
	fields ttinvi_per like yyinvi_per label "期间"
	fields ttinvi_upl_qty like yyinvi_upl_qty label "计划外入库"
	fields ttinvi_buy_qty like yyinvi_buy_qty label "采购入库"
	index ttinvi_part IS PRIMARY UNIQUE ttinvi_part.

theyear = year(today).
theper = month(today).
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   theyear     colon 15 label "年"
   theper      colon 15 label "期间"
   lupdate     colon 15 label "更新"
 SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = "当期材料入库，半成品/成品计划外入库计算".
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
	theyear theper lupdate
	with frame a.

	find glc_cal where glc_year = theyear and glc_per = theper no-lock no-error.

	if available glc_cal then do:
		per_start = glc_start.
		per_end = glc_end.
	end.
	else do:
		message "财务期间未定义!" view-as alert-box.
		next.
	end. /* if not avail glc_cal */
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

	for each tr_hist no-lock where 
		(tr_type = "RCT-PO" or tr_type = "RCT-UNP") and 
		tr_effdate >= per_start and
		tr_effdate <= per_end 
		use-index tr_type:

		find ttinvi_mstr where 
			ttinvi_part = tr_part and
			ttinvi_year = theyear and
			ttinvi_per = theper
			no-lock no-error.

		if available ttinvi_mstr then do:
			if tr_type = "RCT-PO" then do:
				ttinvi_buy_qty = ttinvi_buy_qty + tr_qty_chg.
			end.
			if tr_type = "RCT-UNP" then do:
				ttinvi_upl_qty = ttinvi_upl_qty + tr_qty_chg.
			end.
		end. /* if avail ttinvi_mstr */
		else do:
			create ttinvi_mstr.
			assign  ttinvi_part = tr_part
				ttinvi_year = theyear
				ttinvi_per  = theper
				ttinvi_part_pl = tr_prod_line.
			if tr_type = "RCT-PO" then do:
				ttinvi_buy_qty = tr_qty_chg.
			end.
			if tr_type = "RCT-UNP" then do:
				ttinvi_upl_qty = tr_qty_chg.
			end.
		end. /* if not avail ttinvi_mstr */

	end. /* for each tr_hist */

	for each ttinvi_mstr no-lock:
		display 
			ttinvi_mstr
		with width 132 STREAM-IO /*GUI*/ .
	end.

	if lupdate then do:

		for each ttinvi_mstr no-lock:
			find first ptp_det where ptp_part = ttinvi_part no-lock no-error.
			find first pt_mstr where pt_part = ttinvi_part no-lock no-error.
			if avail ptp_det then assign v_pmcode = ptp_pm_code.
			else if avail pt_mstr then assign v_pmcode = pt_pm_code.
			else next.
			if v_pmcode = "M" then do:
				find last yywobmspt_mstr where yywobmspt_part = ttinvi_part no-lock no-error.
				if not avail yywobmspt_mstr then do:
					put ttinvi_part "必须先做镜像！" skip.
					next.
				end.
				assign bomversion = yywobmspt_version. 
			end.
			
			find first yyinvi_mstr where yyinvi_year = ttinvi_year
				and yyinvi_per = ttinvi_per
				and yyinvi_part = ttinvi_part no-error.
			if not avail yyinvi_mstr then do:
				create yyinvi_mstr.
				assign 
				    yyinvi_part_pl = ttinvi_part_pl
				    yyinvi_part = ttinvi_part
				    yyinvi_year = ttinvi_year
				    yyinvi_per = ttinvi_per.
			end. /* if not avail yyinvi_mstr */
			assign
			    yyinvi_std_bom = bomversion    
			    yyinvi_upl_qty = ttinvi_upl_qty
			    yyinvi_buy_qty = ttinvi_buy_qty.
			
		
		end. /* for each ttinvi_mstr */
	end. /* if lupdate */

	empty temp-table ttinvi_mstr.
			
	{mfguitrl.i} /*Replace mfrtrail*/
	{mfgrptrm.i} /*Report-to-Window*/

	{wbrp04.i &frame-spec = a}
end. /* repeat */

/*GUI*/ 
{wbrp04.i &frame-spec = a}
