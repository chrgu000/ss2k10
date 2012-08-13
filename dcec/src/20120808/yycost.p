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

theyear = year(today).
theper = month(today).

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
        put "Release date 和 Due date 不在同一个月的工单：" skip.
	for each wo_mstr no-lock where wo_part >= part and wo_part <= part1 
		and((wo_due_date >= glc_start and wo_due_date <= glc_end)
		and (wo_rel_date < glc_start or wo_rel_date > glc_end))
		or ((wo_rel_date >= glc_start and wo_rel_date <= glc_end)
		and (wo_due_date < glc_start or wo_due_date > glc_end)):

		display wo_nbr wo_lot wo_part wo_due_date wo_rel_date with frame d down STREAM-IO .
		down with frame d.
	end.
	put "收货量和工单量不等的工单：" skip.
	define var v_qty like wo_qty_ord label "Qty Received".
	v_qty = 0.
	for each wo_mstr no-lock where wo_part >= part and wo_part <= part1
		and wo_due_date >= glc_start and wo_due_date <= glc_end:
		for each tr_hist no-lock where tr_lot = wo_lot
			and tr_type = "RCT-WO"
			and tr_part = wo_part :
			v_qty = v_qty + tr_qty_loc.
		end.
		if v_qty <> wo_qty_ord then do:
			disp wo_nbr wo_lot wo_part wo_type wo_qty_ord v_qty with frame e down stream-io.
			down with frame e.
		end.
		v_qty = 0.
	end. /* for each wo_mstr */

end. /* repeat */