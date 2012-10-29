/*yyMESload.p   导入替代关系                                             */
/*last modified: 08/26/2009 BY: James Duan    *GYD1                      */
/*last modified: 08/16/2012 BY: Henri Zhu                                */



/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
/*
{mfdtitle.i "2+ "}*/
{mfdtitle.i "20120816"}

def var v_year	 as int format "9999".
def var v_per	 as int format "99".
def var v_file   as char format "x(46)".
def var v_line	 as int.
def var v_txt    as char format "x(80)".
define temp-table ttalt_det
	fields ttalt_year like v_year
	fields ttalt_per  like v_per
	fields ttalt_part like yypts_part
	fields ttalt_comp like yypts_comp
	fields ttalt_sub_comp like yypts_sub_comp
	fields ttalt_status as char format "x(30)"
index ttalt_idx IS PRIMARY  ttalt_part ttalt_comp ttalt_sub_comp.

form
   ttalt_year column-label "年份"
   ttalt_per  column-label "期间"
   ttalt_part column-label "父零件"
   ttalt_comp column-label "子零件"
   ttalt_sub_comp column-label "替代件"
   ttalt_status	column-label "状态"
with frame d width 132 down.

v_year = year(today).
v_per = month(today).

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
     v_year   colon 15 label "年份"
     v_per    colon 15 label "期间"
     v_file   colon 15 label "文件"
 SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

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

{wbrp01.i}
REPEAT:

	update 
	v_year v_per
	v_file 
	with frame a.

   find first glc_cal where glc_domain = global_domain and glc_year = v_year and glc_per = v_per no-lock no-error.
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
	
	v_line = 0.
	empty temp-table ttalt_det.
	input from value(v_file) no-echo.
	repeat:
		v_line = v_line + 1.
		import unformatted v_txt.
		
		if v_line = 1 then next.
		if num-entries(v_txt,",") < 3 then do:
			put "第：" v_line "行数据不足" skip.
			next.
		end.
		create ttalt_det.
		assign
		    ttalt_year = v_year
		    ttalt_per = v_per
		    ttalt_part = trim(entry(1,v_txt,","))
		    ttalt_comp = trim(entry(2,v_txt,","))
		    ttalt_sub_comp = trim(entry(3,v_txt,",")).	
		
	end. /* repeat */
	input close.
	for each yypts_det where yypts_domain = global_domain and yypts_year = v_year and yypts_per = v_per:
		delete yypts_det.
	end.
	for each ttalt_det :
	
		find first yypts_det where yypts_domain = global_domain and yypts_year = v_year and yypts_per = v_per
			and yypts_part = ttalt_part 
			and yypts_comp = ttalt_comp 
			and yypts_sub_comp = ttalt_sub_comp no-error.
		if not avail yypts_det then do:
			create yypts_det.
			assign 
			   yypts_domain = global_domain
			   yypts_year = ttalt_year
			   yypts_per = ttalt_per
			   yypts_part = ttalt_part
			   yypts_comp = ttalt_comp
			   yypts_sub_comp = ttalt_sub_comp.	
			ttalt_status = "成功".       
		end. /* if not avail yypts_det */
		else assign ttalt_status = "信息已存在".

		display
		    ttalt_year
		    ttalt_per
		    ttalt_part  
		    ttalt_comp  
		    ttalt_sub_comp  
		    ttalt_status
		with frame d STREAM-IO.
		down with frame d.
	end. /* for each ttalt_det */
	
	empty temp-table ttalt_det.
				
	/*GUI*/ 
	{mfguitrl.i}  
	{mfgrptrm.i}  

	{wbrp04.i &frame-spec = a}
end. /* repeat */

/*GUI*/ 
{wbrp04.i &frame-spec = a}
