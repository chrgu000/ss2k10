/*yyppvload.p   发票价格差异导入                                             */
/* Copyright 2009-2010 QAD Inc., Shanghai CHINA.                        */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0    LAST MODIFIED: 08/26/2009     BY: Jame Duan     *GYD*/


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

def var v_part	 like pt_part.
def var v_file   as char format "x(46)".
def var v_txt    as char format "x(80)".
def var v_year   as int  format "9999".
def var v_period as int  format ">9".
def var v_line   as int.
def var v_update as logical init "no".

def temp-table td
    field td_line  like v_line
    field td_part  like pt_part
    field td_var   as deci
    field td_reason as char.
form
  td_line column-label "行数"
  " "
  td_part column-label "零件"
  td_var  column-label "发票价格差异" format "->>>,>>>,>>9.99"
  td_reason column-label "状态"
with frame d width 132 down.

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
F-a-title = "发票价格差异导入".
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

   find first glc_cal where glc_year = v_year and glc_per = v_period no-lock no-error.
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

	input from value(v_file) no-echo.
	repeat:
		v_line = v_line + 1.
		import unformatted v_txt.
		if v_line = 1 then next.
		v_part = trim(entry(1,v_txt,",")).
		find first pt_mstr where pt_part = v_part no-lock no-error.
		find first td where td_part = v_part no-error.
		if not avail td then do:
			create td.
			assign td_line = v_line
			       td_part = v_part.
		end. /* if not avail td  */
		if not avail pt_mstr then do:
			assign td_reason = "零件不存在".
			next.
		end.
		td_var = td_var + (if num-entries(v_txt,",") > 1 then deci(entry(2,v_txt,",")) else 0).

	end. /* repeat */
	input close.
	for each td no-lock:
		if td_reason = "" and v_update then do:
			
			find first yycsvar_mstr where yycsvar_part = td_part
				and yycsvar_year = v_year
				and yycsvar_per = v_period 
				and yycsvar_pm_code = "P" no-error.
			if not avail yycsvar_mstr then do:
				create yycsvar_mstr.
				assign 
				       yycsvar_part = td_part
				       yycsvar_year = v_year
				       yycsvar_per = v_period
				       yycsvar_pm_code = "P".
			end. /* if avail yyinvpbd_det */
			assign td_reason = "成功"
			       yycsvar_variance[14] = td_var.
		end. /* if td_reason = "" */
		disp  
		  td_line  
		  td_part  
		  td_var 
		  td_reason  
		with frame d.
		down with frame d.
		
	end. /* for each td */	
	

   empty temp-table td.

				
    /*GUI*/ 
   {mfguitrl.i} /*Replace mfrtrail*/
   {mfgrptrm.i} /*Report-to-Window*/

  {wbrp04.i &frame-spec = a}

end. /* repeat */

/*GUI*/ 
{wbrp04.i &frame-spec = a}