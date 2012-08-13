/* yybomrpt.p - 查询零件最新bom镜像                 */
/* Author: James Duan   *DATE:2010-03-01*           */

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
define variable v_site		like yywobmspt_site.
define variable vb_version	like yywobmspt_version.
define variable vb_date as char.
define variable vc_version	like yywobmspt_version.
define variable vc_date as char.

form
  pt_part	column-label "零件"
  pt_prod_line  column-label "产品线"
  vb_version column-label "DCEC-B镜像版本"
  vb_date column-label "DCEC-B镜像时间" format "x(10)"
  vc_version column-label "DCEC-C镜像版本"
  vc_date column-label "DCEC-C镜像时间" format "x(10)"
with frame d width 320 down.
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    skip
    part	COLON 20 
    part1	COLON 45 LABEL "至"
    SKIP
    line	COLON 20 
    line1	COLON 45 LABEL "至"
    SKIP
    SKIP
    SKIP(.4)  /*GUI*/
    WITH FRAME a SIDE-LABELS WIDTH 80 NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
            &THEN "最新镜像版本查询"
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

{wbrp01.i}
REPEAT:
    IF part1 = hi_char THEN part1 = "".  
    IF line1 = hi_char THEN line1 = "".   

    UPDATE
        part part1
	line line1

    WITH FRAME a.
    
    IF part1 = "" THEN part1 = hi_char.
    IF line1 = "" THEN line1 = hi_char.

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
    
    /* 确定计算材料差异期间 */

    for each pt_mstr no-lock where pt_part >= part and pt_part <= part1
		and pt_prod_line >= line and pt_prod_line <= line1:   

	if pt_prod_line begins "1" then next. 
		
	find last yywobmspt_mstr where yywobmspt_site = 'dcec-b'
		and yywobmspt_part = pt_part no-lock no-error.
	if avail yywobmspt_mstr then do:
		assign
		   vb_version = yywobmspt_version
		   vb_date = string(yywobmspt_mod_date).
	end.
	else do:
		assign
		   vb_version = 0
		   vb_date = "".		
	end.
	find last yywobmspt_mstr where yywobmspt_site = 'dcec-c'
		and yywobmspt_part = pt_part no-lock no-error.
	if avail yywobmspt_mstr then do:
		assign
		   vc_version = yywobmspt_version
		   vc_date = string(yywobmspt_mod_date).
	end.
	else do:
		assign
		   vc_version = 0
		   vc_date = "".		
	end.
	display
	   pt_part
	   pt_prod_line
	   vb_version
	   vb_date
	   vc_version
	   vc_date
	with frame d.
	down with frame d.
     end.  /* for each pt_mstr */
	{mfguitrl.i} /*Replace mfrtrail*/
	{mfgrptrm.i} /*Report-to-Window*/

	{wbrp04.i &frame-spec = a}
end. /* repeat */

/*GUI*/ 
{wbrp04.i &frame-spec = a}
