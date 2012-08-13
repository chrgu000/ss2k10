/*yyinvo.p - 当期材料出库，半成品/成品计划外出库计算*/
/*		         只算ISS-WO、ISS-SO和ISS-UNP*/
/*  Author: James Duan *DATE:2009-09-20*            */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

define variable lupdate		like mfc_logical.

define variable theyear		like yyinvi_year format "9999".
define variable theper		like yyinvi_per format "99".

define variable per_start	like glc_start.
define variable per_end		like glc_end.

define variable v_type		like yyinvo_out_type.
define variable v_reason	like yyinvo_reason.
define temp-table ttinvo_mstr
	fields ttinvo_part	like yyinvo_part
	fields ttinvo_part_pl	like yyinvo_part_pl
	fields ttinvo_year	like yyinvo_year
	fields ttinvo_per	like yyinvo_per
	fields ttinvo_out_type	like yyinvo_out_type
	fields ttinvo_qty	like yyinvo_qty
	fields ttinvo_reason	like yyinvo_reason
	fields ttinvo_sojob	like yyinvo_sojob
index ttinvo_part IS PRIMARY ttinvo_year ttinvo_per ttinvo_out_type ttinvo_part.

form
  ttinvo_part  column-label "零件"
  ttinvo_part_pl  column-label "产品线"
  ttinvo_year  column-label "年份"
  ttinvo_per  column-label "期间"
  ttinvo_out_type  column-label "出库类型"
  ttinvo_sojob column-label "客户单/工作"
  ttinvo_qty  column-label "数量"
with frame d width 320 down.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

theyear = year(today).
theper = month(today).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   theyear     colon 15 label "年份"
   theper      colon 15 label "期间"
   lupdate     colon 15 label "更新"
 SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = "当期材料、半成品/成品出库计算".
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
		(tr_type = "ISS-WO" or tr_type = "ISS-SO" or tr_type = "ISS-UNP") and 
		tr_effdate >= per_start and
		tr_effdate <= per_end 
		use-index tr_type:
		assign 
		   v_reason = ""
		   v_type = "".
		if tr_type = "ISS-WO" then do:
			find first wo_mstr where wo_lot = tr_lot no-lock no-error.
			if avail wo_mstr then do:
				if wo_type = "E" then v_type = "改制".
				else if wo_type = "C" then v_type = "装机".
				v_reason = wo_part.
			end.
							
		end. /* if tr_type = "ISS-WO" */
		if tr_type = "ISS-SO" then do:
			v_type = "销售".
			find first so_mstr where so_nbr = tr_nbr no-lock no-error.
			if avail so_mstr then assign v_reason = so_cust.
			else do:
				find first ih_hist where ih_nbr = tr_nbr no-lock no-error.
				if avail ih_hist then assign v_reason = ih_cust.
			end.
		end. /* if tr_type = "ISS-SO" */
		
		if tr_type = "ISS-UNP" then do:
			if lookup(tr_so_job,"207,207B") > 0  then v_type = "计划外三包".
			else if lookup(tr_so_job,"205,206,218,229,251") > 0 then v_type = "计划外试验".
			else  v_type = "计划外其他".
			v_reason = tr_rmks.
		end. /* if tr_type = "ISS-UNP" */

		find first ttinvo_mstr where ttinvo_year = theyear 
			and ttinvo_per = theper 
			and ttinvo_out_type = v_type 
			and ttinvo_part = tr_part 
			and ttinvo_reason = v_reason 
			and ttinvo_sojob = tr_so_job no-error.

		if not available ttinvo_mstr then do:
			create ttinvo_mstr.
			assign 
				 ttinvo_part = tr_part
				 ttinvo_year = theyear
				 ttinvo_per  = theper
				 ttinvo_part_pl = tr_prod_line
				 ttinvo_out_type = v_type
				 ttinvo_reason = v_reason
				 ttinvo_sojob = tr_so_job.
			
		end. /* if not available ttinvo_mstr */
		assign ttinvo_qty = ttinvo_qty - tr_qty_loc.

		

	end.

	for each ttinvo_mstr no-lock:
		display 
		  ttinvo_part  
		  ttinvo_part_pl  
		  ttinvo_year  
		  ttinvo_per  
		  ttinvo_out_type
		  ttinvo_sojob
		  ttinvo_qty   
		with frame d.
		down with frame d.
	end.

	if lupdate then do:

		for each ttinvo_mstr no-lock:
			find first yyinvo_mstr where yyinvo_year = ttinvo_year
				and yyinvo_per = ttinvo_per
				and yyinvo_out_type = ttinvo_out_type 
				and yyinvo_part = ttinvo_part 
				and yyinvo_sojob = ttinvo_sojob
				and yyinvo_reason = ttinvo_reason no-error.
			if not avail yyinvo_mstr then do:
				create yyinvo_mstr.
				assign 
				    yyinvo_part = ttinvo_part
				    yyinvo_year = ttinvo_year
				    yyinvo_per = ttinvo_per
				    yyinvo_out_type = ttinvo_out_type
				    yyinvo_sojob = ttinvo_sojob
				    yyinvo_reason = ttinvo_reason.
			end. /* if not avail yyinvo_mstr */
			assign
			    yyinvo_part_pl = ttinvo_part_pl
			    yyinvo_qty = ttinvo_qty.
		end. /*for each ttinvo_mstr */
	end. /* if lupdate */

	for each ttinvo_mstr:
		delete ttinvo_mstr.
	end.

			
	{mfguitrl.i} /*Replace mfrtrail*/
	{mfgrptrm.i} /*Report-to-Window*/

	{wbrp04.i &frame-spec = a}
end. /* repeat */

/*GUI*/ 
{wbrp04.i &frame-spec = a}
