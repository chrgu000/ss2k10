/* yyactrpt.p - 产成品实际成本报表                  */
/* Author: James Duan   *DATE:2009-09-21*           */

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

DEFINE VARIABLE part		LIKE pt_part.
DEFINE VARIABLE part1		LIKE pt_part.
DEFINE VARIABLE line		LIKE pt_prod_line.
DEFINE VARIABLE line1		LIKE pt_prod_line.
DEFINE VARIABLE iyear		AS INT format "9999".
DEFINE VARIABLE iper		AS INT format "99".

define variable pcqty		like yyinvi_mfg_qty.
define variable v_version	like yywobmspt_version.
define variable v_site		like yywobmspt_site.

DEF VAR h-tt AS HANDLE.
DEFINE VAR inp_where     AS CHAR.
DEFINE VAR inp_sortby    AS CHAR.
DEFINE VAR inp_bwstitle  AS CHAR.
DEF    VAR      v_list AS CHAR INITIAL "".

define temp-table tttt RCODE-INFORMATION
    fields tttt_part		like pt_part			label "零件号"
    fields tttt_desc		like pt_desc1			label "零件名称"
    fields tttt_pl		like pt_prod_line		label "产品类"
    fields tttt_stdmtlcost	like yywobmspt_elem_cost	label "物料"
    fields tttt_stdfrtcost	like yywobmspt_elem_cost	label "关税&运费"
    fields tttt_stdsubcost	like yywobmspt_elem_cost	label "转包"
    fields tttt_stdlbrcost	like yywobmspt_elem_cost	label "人工"
    fields tttt_stdmfgcost	like yywobmspt_elem_cost	label "制造费用"
/*    fields tttt_bomchgvar	like yycsvar_variance[1]	label "1.BOM变更" */
    fields tttt_routchgvar	like yycsvar_variance[1]	label "工单改制"
    fields tttt_mtdchgvar1	like yycsvar_variance[1]	label "方法差异-量差"
    fields tttt_mtdchgvar2	like yycsvar_variance[1]	label "方法差异-价差"
    fields tttt_ptrepvar1	like yycsvar_variance[1]	label "临时替代"
    fields tttt_ptrepvar2	like yycsvar_variance[1]	label "零件替代"
    fields tttt_ratevar		like yycsvar_variance[1]	label "率差"
    fields tttt_othervar	like yycsvar_variance[1]	label "其他"
    fields tttt_ppvvar1		like yycsvar_variance[1]	label "PPV差异"
    fields tttt_ppvvar2		like yycsvar_variance[1]	label "自制半成品材料差异"
    fields tttt_glmtlvar	like yycsvar_variance[1]	label "物料总账差异(非QAD件)"
    fields tttt_lbrvar1		like yycsvar_variance[1]	label "人工差异"
    fields tttt_lbrvar2		like yycsvar_variance[1]	label "人工差异"
    fields tttt_mfgvar1		like yycsvar_variance[1]	label "制造费用差异"
    fields tttt_mfgvar2		like yycsvar_variance[1]	label "制造费用差异"
    fields tttt_actmtl		like yycsvar_variance[1]	label "物料实际"
    fields tttt_actlbr		like yycsvar_variance[1]	label "人工实际"
    fields tttt_actmfg		like yycsvar_variance[1]	label "制造实际"
    fields tttt_totalcost	like yycsvar_variance[1]	label "合计(实际成本)"
index part is primary tttt_part.	

iyear = year(today).
iper = month(today).	


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    part	COLON 20 
    part1	COLON 45 LABEL "至"
    SKIP
    line	COLON 20 
    line1	COLON 45 LABEL "至"
    SKIP
    iyear	COLON 20 LABEL "年份"
    iper	COLON 45 LABEL "期间"
    SKIP
    SKIP
    SKIP(.4)  /*GUI*/
    WITH FRAME a SIDE-LABELS WIDTH 80 NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
            &THEN " Selection Criteria "
            &ELSE {&SELECTION_CRITERIA}
            &ENDIF .
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


REPEAT:
    IF part1 = hi_char THEN part1 = "".  
    IF line1 = hi_char THEN line1 = "".   

    UPDATE 
        part part1
	line line1
        iyear iper 

    WITH FRAME a.
    
    IF part1 = "" THEN part1 = hi_char.
    IF line1 = "" THEN line1 = hi_char.

/***********************************************************************
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
*************************************************************************/
    
    /* 确定计算材料差异期间 */
    find first glc_cal where glc_year = iyear and glc_per = iper no-lock no-error.
    if not avail glc_cal then do:
	message "财务期间未定义!" view-as alert-box.
	next.
    end.

    for each pt_mstr no-lock where pt_part >= part and pt_part <= part1
		and pt_prod_line >= line and pt_prod_line <= line1:   

	 if pt_prod_line begins "1" then next. 
	
	/* 取当期入库数量 */
	find first yyinvi_mstr where yyinvi_part = pt_part
		and yyinvi_year = iyear
		and yyinvi_per = iper no-lock no-error.
	if avail yyinvi_mstr then assign pcqty = yyinvi_mfg_qty + yyinvi_upl_qty + yyinvi_buy_qty.
	
	/* 取标准成本 */
	find last yywobmspt_mstr where yywobmspt_part = pt_part 
		and year(yywobmspt_mod_date) <= iyear
		and month(yywobmspt_mod_date)<= iper  no-lock no-error.
	if not avail yywobmspt_mstr then next.
	assign v_version = yywobmspt_version
		v_site = yywobmspt_site.

	for each yywobmspt_mstr no-lock where yywobmspt_site = v_site
		and yywobmspt_part = pt_part 
		and yywobmspt_version = v_version:
		
		find first tttt where tttt_part = yywobmspt_part no-error.
		if not avail tttt then do:
			create tttt.
			assign 
			    tttt_part = yywobmspt_part
			    tttt_desc = pt_desc1 + " " + pt_desc2
			    tttt_pl = pt_prod_line.
		end. /* if not avail tttt */
		if yywobmspt_elem = "材料" then assign tttt_stdmtlcost = pcqty * yywobmspt_elem_cost.
		else if yywobmspt_elem = "关税运费" then assign tttt_stdfrtcost = pcqty * yywobmspt_elem_cost.
		else if yywobmspt_elem = "转包" then assign tttt_stdsubcost = pcqty * yywobmspt_elem_cost.
		else if yywobmspt_elem = "直接人工" then assign tttt_stdlbrcost = pcqty * yywobmspt_elem_cost.
		else if yywobmspt_elem = "制造费用" then assign tttt_stdmfgcost = pcqty * yywobmspt_elem_cost.

	end. /* for each yywobmspt_mstr */
	
	for first yycsvar_mstr no-lock where yycsvar_part = pt_part
		and yycsvar_year = iyear
		and yycsvar_per = iper:

		find first tttt where tttt_part = yycsvar_part no-error.
		if not avail tttt then do:
			create tttt.
			assign 
			    tttt_part = yycsvar_part
			    tttt_desc = pt_desc1 + " " + pt_desc2
			    tttt_pl = pt_prod_line.
		end. /* if not avail tttt */
		/*IC-WO BOM变更
		tttt_bomchgvar = yycsvar_variance[1]. */
		/*IC-WO 路线变更*/
		tttt_routchgvar = yycsvar_variance[2].
		/*IC-WO 方法差异量差*/
		tttt_mtdchgvar1 = yycsvar_variance[3].
		/*IC-WO 方法差异价差*/
		tttt_mtdchgvar2 = yycsvar_variance[4].
		/*IC-WO 临时替代*/
		tttt_ptrepvar1 = yycsvar_variance[5].
		/*IC-WO 零件替代*/
		tttt_ptrepvar2 = yycsvar_variance[6].
		/*IC-WO 率差*/
		tttt_ratevar = yycsvar_variance[7].
		/*IC-WO 其他*/
		tttt_othervar = yycsvar_variance[8].
		/*产成品PPV差异*/
		tttt_ppvvar1 = yycsvar_variance[13].
		/*自制半成品材料差异*/
		tttt_ppvvar2 = yycsvar_variance[14].
		/*总账差异*/
		tttt_glmtlvar = yycsvar_variance[15].
		/*产成品 - 人工差异*/
		tttt_lbrvar1 = yycsvar_variance[16].
		/*自制半成品 - 人工差异*/
		tttt_lbrvar2 = yycsvar_variance[17].
		/*产成品 - 制造费用差异*/
		tttt_mfgvar1 = yycsvar_variance[18].
		/*自制半成品 - 制造费用差异*/
		tttt_mfgvar2 = yycsvar_variance[19].
	end.

	/* 取实际成本 */
	find first yyactcs_mstr where yyactcs_part = pt_part
		and yyactcs_year = iyear
		and yyactcs_per = iper no-lock no-error.
	if avail yyactcs_mstr then do:
		find first tttt where tttt_part = yyactcs_part no-error.
		if not avail tttt then do:
			create tttt.
			assign 
			    tttt_part = yyactcs_part
			    tttt_desc = pt_desc1 + " " + pt_desc2
			    tttt_pl = pt_prod_line.
		end. /* if not avail tttt */
		assign 
		    tttt_actmtl = yyactcs_act_mtl
		    tttt_actlbr = yyactcs_act_lbr
		    tttt_actmfg = yyactcs_act_mfg
		    tttt_totalcost = tttt_actmtl + tttt_actlbr + tttt_actmfg.
			
	end. /* if avail yyactcs_mstr */ 

    end. /* for each pt_mstr */

    h-tt = TEMP-TABLE tttt:HANDLE.
    RUN value(lc(global_user_lang) + "\yy\yytoexcel.p") (INPUT TABLE-HANDLE h-tt, INPUT inp_where, INPUT inp_sortby, INPUT v_list, INPUT inp_bwstitle).        
    empty temp-table tttt.
END.

