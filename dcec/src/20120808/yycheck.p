/* yyppvcal.p - 当期各材料PPV差异率计算              */
/* Author: James Duan *DATE:2009-09-15*              */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

define variable theyear		like yyinvi_year format "9999".
define variable theper		like yyinvi_per format "99".
define variable part		like pt_part.
define variable part1		like pt_part.
DEFINE VARIABLE v_pmcode	LIKE pt_pm_code.

theyear = year(today).
theper = month(today).

define temp-table tttt
	fields tttt_part like wo_part
	fields tttt_comp like wod_part
	fields tttt_variance as decimal extent 4.
index tttt_idx is primary wo_part wod_part.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
 part		colon 15
 part1		colon 50
 theyear	colon 15 label "年"
 theper		colon 15 label "期间"
 SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN
   &IF (DEFINED(SELECTION_CRITERIA) = 0)
   &THEN " Selection Criteria "
   &ELSE {&SELECTION_CRITERIA}
   &ENDIF 
&ELSE 
   getTermLabel("SELECTION_CRITERIA", 25).
&ENDIF.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

REPEAT:
	if part1 = "" then part1 = hi_char. 

	UPDATE 
		part part1 
		theyear
		theper
	WITH FRAME a.

	find first glc_cal where glc_year = theyear and glc_per = theper no-lock no-error.
	if not avail glc_cal then do:
		find first glc_cal where today >= glc_start and today <= glc_end no-lock no-error.
		if not avail glc_cal then do:
			message "财务期间未定义!" view-as alert-box.
		end.
	end. /* find first */

	if part1 = "" then part1 = hi_char.
        put "低层分摊有误的的产成品、半成品：" skip.
	for each wo_mstr no-lock where wo_status = "C"
		and  ( wo_type = "C" or wo_type = "E")
		and  (wo_part >= part and wo_part <= part1)
		and  (wo_due_date >= glc_start and wo_due_date <= glc_end):
		
		wod_loop:
		for each wod_det no-lock where wod_lot = wo_lot
			and wod_qty_iss <> 0:
			find first pt_mstr where pt_part = wod_part no-lock no-error.
			if not avail pt_mstr then next wod_loop.
			/* 不重复计算自己改制自己 */
			if wo_type = "E" and wo_part = wod_part then next.

			find first yycsvar_mstr where yycsvar_year = theyear
				and yycsvar_per = theper 
				and yycsvar_part = wod_part no-lock no-error.
			if not avail yycsvar_mstr then next.

			find first ptp_det where ptp_part = pt_part and ptp_site = wod_site no-lock no-error.
			if avail ptp_det then assign v_pmcode = ptp_pm_code.
			else assign v_pmcode = pt_pm_code.
			find first yyvarated_det where yyvarated_year = theyear
				and yyvarated_per = theper
				and yyvarated_part = wod_part no-lock no-error.

			find first tttt where tttt_part = wo_part
					and tttt_comp = wod_part no-error.
			if not avail tttt then do:
				create tttt.
				assign tttt_part = wo_part
				       tttt_comp = wod_part.
			end.
			if v_pmcode = "P" then 
				assign tttt_variance[1] = yycsvard_variance[1] + wod_qty_iss * yyvarated_mtl_rate
			/* 自制半成品材料差异 */
			else if v_pmcode = "M" then 
				assign tttt_variance[2] = tttt_variance[2] + wod_qty_iss * yyvarated_mtl_rate.
			tttt_variance[3] = tttt_variance[3] + wod_qty_iss * yyvarated_lbr_rate.
			tttt_variance[4] = tttt_variance[4] + wod_qty_iss * yyvarated_mfg_rate.	
		end. /* for each wod_det */
	end. /* for each wo_mstr */


	for each tttt no-lock ：
		find first yycsvard_det where yycsvard_year = theyear
			and yycsvard_per = theper
			and yycsvard_part = tttt_part
			and yycsvard_comp = tttt_comp no-lock no-error.
		if not avail yycsvard_det then do:
			if tttt_variance[1] <> yycsvard_variance[13] then 
				put yycsvard_part yycsvard_comp "产成品PPV差异分摊错误" skip.
			if tttt_variance[2] <> yycsvard_variance[14] then 
				put yycsvard_part yycsvard_comp "自制半成品材料差异分摊错误" skip.
			if tttt_variance[3] <> yycsvard_variance[16] then 
				put yycsvard_part yycsvard_comp "人工差异分摊错误" skip.
			if tttt_variance[4] <> yycsvard_variance[18] then 
				put yycsvard_part yycsvard_comp "制造费用差异分摊错误" skip.
		end. /* if not avail yycsvard_det */
	end.
	empty temp-table tttt.

end. /* repeat */