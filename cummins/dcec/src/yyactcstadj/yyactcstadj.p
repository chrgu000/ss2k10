/*yyactcstadj.p   ʵ�ʳɱ�����������                                         */
/* Copyright 2009-2010 QAD Inc., Shanghai CHINA.                        */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0    LAST MODIFIED: 08/26/2009     BY: Jame Duan     *GYD*/
/*ss2012-8-15 ����*/

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
    field td_part_pl like pt_prod_line
    field td_part  like pt_part
    field td_var   as deci
    field td_reason as char.
form
  td_line column-label "����"
  " "
  td_part column-label "����Ʒ"
  td_part_pl column-label "��Ʒ��"
  td_var  column-label "������" format "->>>,>>>,>>9.99"
  td_reason column-label "״̬"
with frame d width 132 down.

v_year = year(today).
v_period = month(today).

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
     v_year   colon 15 label "���"
     v_period colon 15 label "�ڼ�"
     v_file   colon 15 label "�ļ���"
     v_update colon 15 label "�����Ѵ��ڼ�¼"
 SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = "ʵ�ʳɱ�����������".
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


	find first glc_cal where /*ss2012-8-15 b*/ glc_cal.glc_domain = global_domain and /*ss2012-8-15 e*/
						glc_year = v_year and glc_per = v_period no-lock no-error.
	if not avail glc_cal then do:
		message "**�����ڼ䲻���ڣ��������������. " view-as alert-box.
		next.
	end.

	if search(v_file) = ? then do:
		message "**�ļ�������. �������������." view-as alert-box.
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
		find first pt_mstr where /*ss2012-8-15 b*/ pt_mstr.pt_domain = global_domain and /*ss2012-8-15 e*/ pt_part = v_part 
					no-lock no-error.
		create td.
		assign td_line = v_line
		       td_part = v_part
		       td_part_pl = pt_prod_line
		       td_var = if num-entries(v_txt,",") > 1 then deci(entry(2,v_txt,",")) else 0.
		if not avail pt_mstr then do:
			assign td_reason = "���������".
			next.
		end.
		find first yyactcs_mstr where /*ss2012-8-15 b*/  yyactcs_mstr.yyactcs_domain = global_domain and /*ss2012-8-15 e*/ yyactcs_part = v_part 
			and yyactcs_year = v_year
			and yyactcs_per = v_period no-error.
		if not avail yyactcs_mstr then do:
			create yyactcs_mstr.
			assign yyactcs_part = pt_part
				yyactcs_part_pl = pt_prod_line
				yyactcs_year = v_year
				yyactcs_per = v_period.
		end. /* if not avail yyactcs_mstr */
		else if not v_update then do:
			next. 
		end.
		assign yyactcs_act_adj = td_var.
		td_reason = "�ɹ�".


	end. /* repeat */
	input close.
	for each td no-lock:
		disp  
		  td_line  
		  td_part_pl
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