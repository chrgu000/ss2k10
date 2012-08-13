/*yyfeeld1.p   �ڳ����쵼��                                             */
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
def var v_period as int  format "99".
def var v_line   as int.
def var v_update as logical init "no".
def var v_ldtype as logical format "Q/V" init yes.   /*Load Type: Q-Quntity ; V-Variance*/

def temp-table td
    field td_line  like v_line
    field td_part  like pt_part
    field td_part_pl like pt_prod_line
    field td_var   as deci
    field td_qty   as int
    field td_reason as char.
form
  td_line column-label "����"
  " "
  td_part column-label "���"
  td_part_pl column-label "��Ʒ��"
  td_qty  column-label "���"
  td_var  column-label "����" format "->>>,>>>,>>9.99"
  td_reason column-label "״̬"
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
     v_year   colon 15 label "���"
     v_period colon 50 label "�ڼ�"
     v_ldtype colon 15 label "�ڳ���������" " Q:�ڳ����; V:�ڳ�����;"
     v_file   colon 15 label "�ļ���"
     v_update colon 15 label "�����Ѵ�������"
 SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = "�ڳ�����/��浼��".
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
   v_year v_period 
   v_ldtype 
   v_file 
   v_update
   with frame a.

   find first glc_cal where glc_year = v_year and glc_per = v_period no-lock no-error.
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

   /* Load�ڳ���� */	
   if v_ldtype  then do:
	input from value(v_file) no-echo.
	repeat:
		v_line = v_line + 1.
		import unformatted v_txt.
		if v_line = 1 then next.

		v_part = trim(entry(1,v_txt,",")).
		find first pt_mstr where pt_part = v_part no-lock no-error.
		create td.
		assign td_line = v_line
		       td_part = v_part
		       td_part_pl = pt_prod_line
		       td_qty = (if num-entries(v_txt,",") > 1 then int(entry(2,v_txt,",")) else 0).
		if not avail pt_mstr then do:
			assign td_reason = "���������".
			next.
		end.
		find first yyinvpbd_det where yyinvpbd_part = pt_part
			and yyinvpbd_year = v_year
			and yyinvpbd_per = v_period no-error.
		if not avail yyinvpbd_det then do:
			create yyinvpbd.
			assign 
			       yyinvpbd_part = pt_part
			       yyinvpbd_part_pl = td_part_pl
			       yyinvpbd_year = v_year
			       yyinvpbd_per = v_period.
		end. /* if avail yyinvpbd_det */
		else if not v_update then do:
			assign td_reason = "��¼�Ѵ���".
			next.       
		end. /* else if not v_update */
		assign td_reason = "�ɹ�"
		       yyinvpbd_qty = td_qty.

	end. /* repeat */
	input close.
	for each td no-lock:
		disp  
		  td_line  
		  td_part  
		  td_part_pl
		  td_qty  
		  td_reason  
		with frame d.
		down with frame d.
	end. /* for each td */	
	
   end. /* if load type = Q */

   /* Load �ڳ����� */
   else  do:   /*��Ʒ�����Ʒ���õ���(��ϸ�������)*/
        input from value(v_file) no-echo.
        repeat:

           v_line = v_line + 1.
           import unformatted v_txt.
	   if v_line = 1 then next.

           v_part = trim(entry(1,v_txt,",")).
           find first pt_mstr where pt_part = trim(entry(1,v_txt,",")) no-lock no-error.
	   create td.
	   assign td_line = v_line
	          td_part = v_part
		  td_part_pl = pt_prod_line
	          td_var = (if num-entries(v_txt,",") > 1 then deci(entry(2,v_txt,",")) else 0).
	   if not avail pt_mstr then do:
		assign td_reason = "���������".
		next.
	   end.
	   find first yyvarpbd_det where yyvarpbd_part = pt_part
		and yyvarpbd_year = v_year
		and yyvarpbd_per = v_period no-error.
	   if not avail yyvarpbd_det then do:
	           /* ��¼�Ѵ��� */
		   create yyvarpbd_det.
		   assign 
			  yyvarpbd_part_pl = td_part_pl
			  yyvarpbd_part = pt_part
			  yyvarpbd_year = v_year
			  yyvarpbd_per  = v_period.
	   end. /* if not avial yyvarpbd_det */
	   else if not v_update then do:
		assign td_reason = "��¼�Ѵ���".
		next.       
	   end. /* else if not v_update */
	   assign td_reason = "�ɹ�".
	          yyvarpbd_mtl_var  = td_var.
        end.  /* repeat */
	input close.
	for each td no-lock:
		disp  
		  td_line 
		  td_part 
		  td_part_pl
		  td_var 
		  td_reason 
		with frame d.
		down with frame d.
	end. /* for each td */	
   end. /* else if load type = V */

   empty temp-table td.

				
   /*GUI*/ 
   {mfguitrl.i}  
   {mfgrptrm.i}  

   {wbrp04.i &frame-spec = a}

end. /* repeat */

/*GUI*/ 
{wbrp04.i &frame-spec = a}