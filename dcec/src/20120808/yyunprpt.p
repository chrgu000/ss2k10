/* yyunprpt.p - 计划外结转报表                      */
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


DEF VAR h-tt AS HANDLE.
DEFINE VAR inp_where     AS CHAR.
DEFINE VAR inp_sortby    AS CHAR.
DEFINE VAR inp_bwstitle  AS CHAR.
DEF    VAR      v_list AS CHAR INITIAL "".

define temp-table tttt RCODE-INFORMATION
    fields tttt_part		like pt_part			label "零件号"
    fields tttt_desc1		like pt_desc1			label "零件名称"
    fields tttt_desc2		like pt_desc2			label "零件名称"
    fields tttt_pl		like pt_prod_line		label "产品类"
    fields tttt_sojob		like yyinvo_sojob		label "原因代码"
    fields tttt_remark		like yyinvo_reason		label "备注"
    fields tttt_qty		like yyinvo_qty			label "数量"
    fields tttt_amt		like yyvarated_mtl_rate		label "金额"
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

    for each yyinvo_mstr no-lock where yyinvo_part >= part and yyinvo_part <= part1
		and yyinvo_part_pl >= line and yyinvo_part_pl <= line1
		and yyinvo_year = iyear
		and yyinvo_per = iper
		and yyinvo_out_type begins "计划外":   
	create tttt.
        assign
	   tttt_part = yyinvo_part
	   tttt_sojob = yyinvo_sojob
	   tttt_remark = yyinvo_reason
	   tttt_qty = yyinvo_qty.
	for first pt_mstr where pt_part = yyinvo_part no-lock:
		assign tttt_pl = yyinvo_part_pl
		       tttt_desc1 = pt_desc1
		       tttt_desc2 = pt_desc2.
	end.
	for first yyvarated_det where yyvarated_year = iyear
		and yyvarated_per = iper
		and yyvarated_part = yyinvo_part no-lock:
		assign tttt_amt = tttt_qty * (yyvarated_mtl_rate + yyvarated_lbr_rate + yyvarated_mfg_rate).
	end.	
    end. /* for each pt_mstr */

    h-tt = TEMP-TABLE tttt:HANDLE.
    RUN value(lc(global_user_lang) + "\yy\yytoexcel.p") (INPUT TABLE-HANDLE h-tt, INPUT inp_where, INPUT inp_sortby, INPUT v_list, INPUT inp_bwstitle).        
    empty temp-table tttt.
END.

