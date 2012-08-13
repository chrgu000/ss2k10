/* yyicworpt.p - ICWO产品生产成本报表               */
/* Author: James Duan   *DATE:2009-09-21*           */

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

DEFINE VARIABLE part		LIKE pt_part.

DEFINE VARIABLE iyear		AS INT format "9999".
DEFINE VARIABLE iper		AS INT format "99".

define variable pcqty		like yyinvi_mfg_qty.
define variable v_version	like yywobmspt_version.
define variable v_site		like yywobmspt_site.
DEF VAR h-tt AS HANDLE.
DEFINE VAR inp_where     AS CHAR.
DEFINE VAR inp_sortby    AS CHAR.
DEFINE VAR inp_bwstitle  AS CHAR.
DEFINE VAR v_list	 AS CHAR INITIAL "".
define temp-table tttt	RCODE-INFORMATION
    fields tttt_year		like iyear			label "年份"
    fields tttt_per		like iper			label "期间"
    fields tttt_part		like pt_part			label "产品"
    fields tttt_desc		like pt_desc1			label "描述"
    fields tttt_pl		like pt_prod_line		label "产品类"
/*    fields tttt_bomchgvar	like yycsvar_variance[1]	label "1.BOM变更"  */
    fields tttt_routchgvar	like yycsvar_variance[2]	label "工单改制"
    fields tttt_mtdchgvar1	like yycsvar_variance[3]	label "方法差异-量差"
    fields tttt_mtdchgvar2	like yycsvar_variance[4]	label "方法差异-率差"
    fields tttt_ptrepvar1	like yycsvar_variance[5]	label "临时替代"
    fields tttt_ptrepvar2	like yycsvar_variance[6]	label "零件替代"
    fields tttt_ratevar		like yycsvar_variance[7]	label "率差"
    fields tttt_mtdlbrvar	like yycsvar_variance[9]	label "方法差异-工"
    fields tttt_mtdmfgvar	like yycsvar_variance[10]	label "方法差异-费"
    fields tttt_qlbrvar		like yycsvar_variance[11]	label "量差-工"
    fields tttt_qmfgvar		like yycsvar_variance[12]	label "量差-费"
    fields tttt_othervar	like yycsvar_variance[8]	label "其他".

iyear = year(today).
iper = month(today).
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    part	COLON 20 
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

    UPDATE 
        part 
        iyear iper 

    WITH FRAME a.
   

/********************************************************************
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

***********************************************************************/

    /* 确定计算材料差异期间 */
    find first glc_cal where glc_year = iyear and glc_per = iper no-lock no-error.
    if not avail glc_cal then do:
	find first glc_cal where today >= glc_start and today <= glc_end no-lock no-error.
	if not avail glc_cal then do:
		message "财务期间未定义!" view-as alert-box.
	end.
    end.
	
    for first yycsvar_mstr no-lock where yycsvar_part = part
	and yycsvar_year = iyear
	and yycsvar_per = iper:
	find first pt_mstr where pt_part = part no-lock no-error.
	if not avail pt_mstr then do:
		message "零件不存在：" + pt_part view-as alert-box.
		return.
	end.

	create tttt.
	assign 
	    tttt_year = iyear
	    tttt_per = iper
	    tttt_part = pt_part
	    tttt_desc = pt_desc1 + " " + pt_desc2
	    tttt_pl = pt_prod_line
	    /*IC-WO BOM变更*/
/*	    tttt_bomchgvar = yycsvar_variance[1] */
	    /*IC-WO 路线变更*/
	    tttt_routchgvar = yycsvar_variance[2]
	    /*IC-WO 方法差异量差*/
	    tttt_mtdchgvar1 = yycsvar_variance[3]
	    /*IC-WO 方法差异价差*/
	    tttt_mtdchgvar2 = yycsvar_variance[4]
	    /*IC-WO 临时替代*/
	    tttt_ptrepvar1 = yycsvar_variance[5]
	    /*IC-WO 零件替代*/
	    tttt_ptrepvar2 = yycsvar_variance[6]
	    /*IC-WO 率差*/
	    tttt_ratevar = yycsvar_variance[7]
	    /* 方法差异－工 */
	    tttt_mtdlbrvar = yycsvar_variance[9]
	    /* 方法差异－费 */
	    tttt_mtdmfgvar = yycsvar_variance[10]
	    /* 量差－工 */
	    tttt_qlbrvar = yycsvar_variance[11]
	    /* 量差－费 */
	    tttt_qmfgvar = yycsvar_variance[12]
	    /* IC-WO 其他*/
	    tttt_othervar = yycsvar_variance[8].
	release tttt.	
	/* 差异明细 */
	for each yycsvard_det no-lock where yycsvard_part = yycsvar_part
		and yycsvard_year = yycsvar_year
		and yycsvard_per = yycsvar_per
		by yycsvard_comp:
		find first pt_mstr where pt_part = yycsvard_comp no-lock no-error.

		create tttt.
		assign 
		    tttt_year = yycsvard_year
		    tttt_per = yycsvard_per
		    tttt_part = yycsvard_comp.
		if not avail pt_mstr then do:
			assign tttt_desc = "子零件不存在".
			next.
		end.
		assign 
		    tttt_pl = pt_prod_line
		    tttt_desc = pt_desc1 + " " + pt_desc2.

		assign
		    /*IC-WO BOM变更*/
		/*    tttt_bomchgvar = yycsvard_variance[1] */
		    /*IC-WO 路线变更*/
		    tttt_routchgvar = yycsvard_variance[2]
		    /*IC-WO 方法差异量差*/
		    tttt_mtdchgvar1 = yycsvard_variance[3]
		    /*IC-WO 方法差异价差*/
		    tttt_mtdchgvar2 = yycsvard_variance[4]
		    /*IC-WO 临时替代*/
		    tttt_ptrepvar1 = yycsvard_variance[5]
		    /*IC-WO 零件替代*/
		    tttt_ptrepvar2 = yycsvard_variance[6]
		    /*IC-WO 率差*/
		    tttt_ratevar = yycsvard_variance[7]
		    /* 方法差异－工 */
		    tttt_mtdlbrvar = yycsvard_variance[9]
		    /* 方法差异－费 */
		    tttt_mtdmfgvar = yycsvard_variance[10]
		    /* 量差－工 */
		    tttt_qlbrvar = yycsvard_variance[11]
		    /* 量差－费 */
		    tttt_qmfgvar = yycsvard_variance[12]
		    /* IC-WO 其他*/
		    tttt_othervar = yycsvard_variance[8].
		release tttt.
	end. /* for each yycsvard_det */
	h-tt = TEMP-TABLE tttt:HANDLE.
	RUN value(lc(global_user_lang) + "\yy\yytoexcel.p") (INPUT TABLE-HANDLE h-tt, INPUT inp_where, INPUT inp_sortby, INPUT v_list, INPUT inp_bwstitle).        
	empty temp-table tttt.
    end. /* for first yycsvar_mstr */

END.

