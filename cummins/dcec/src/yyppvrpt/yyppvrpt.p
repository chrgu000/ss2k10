/* yyppvcal.p - 当期各材料PPV差异率计算              */
/* Author: James Duan *DATE:2009-09-15*              */
/* Author: Henri Zhu  *DATE:2012-08-14*              */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "20120814"}

define variable theyear		like yyinvi_year format "9999".
define variable theyear1	like yyinvi_year format "9999".
define variable theper		like yyinvi_per format "99".
define variable theper1		like yyinvi_per format "99".
define variable line		like pt_prod_line.
define variable line1		like pt_prod_line.
define variable part		like pt_part.
define variable part1		like pt_part.
define variable ppvrate		as decimal format "->>>,>>9.<<".

DEF VAR h-tt AS HANDLE.
DEFINE VAR inp_where     AS CHAR.
DEFINE VAR inp_sortby    AS CHAR.
DEFINE VAR inp_bwstitle  AS CHAR.
DEF    VAR      v_list AS CHAR INITIAL "".

theyear = year(today).
theyear1 = year(today).
theper = month(today).
theper1 = month(today).

define temp-table tttt RCODE-INFORMATION
	fields tttt_year	like yycsvar_mstr.yycsvar_year label "年份"
	fields tttt_per		like yycsvar_mstr.yycsvar_per  label "期间"
	fields tttt_part	like yycsvar_mstr.yycsvar_part label "零件"
	fields tttt_desc	like pt_desc1 label "描述"
	fields tttt_pl		like pt_prod_line label "产品线"
	fields tttt_povar	like yycsvar_variance[13] label "采购价格差异"
	fields tttt_invvar	like yycsvar_variance[15] label "发票价格差异"
	fields tttt_revalue	like yycsvar_variance[20] label "重估差异"
	fields tttt_qty		like yypbd_qty label "采购数量"
	fields tttt_rate	like yyvarated_mtl_rate label "平均ppv价差" 
index main is primary tttt_year tttt_per tttt_part.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
 line		colon 15
 line1		colon 50
 part		colon 15
 part1		colon 50
 theyear	colon 15 label "年"
 theyear1	colon 50 label "至"
 theper		colon 15 label "期间"
 theper1	colon 50 label "至"
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
	if theyear1 = 0 then theyear1 = 9999.
	if theper1 = 0 then theper1 = 12.
	if line1 = "" then line1 = hi_char.
	if part1 = "" then part1 = hi_char. 

	UPDATE 
		line line1
		part part1 
		theyear theyear1 
		theper theper1
	WITH FRAME a.

	if theyear1 = 0 then theyear1 = 9999.
	if theper1 = 0 then theper1 = 12.
	if line1 = "" then line1 = hi_char.
	if part1 = "" then part1 = hi_char.

	for each yycsvar_mstr no-lock where yycsvar_domain = global_domain 
	  and yycsvar_year >= theyear and yycsvar_year <= theyear1
		and yycsvar_per >= theper and yycsvar_per <= theper1
		and yycsvar_part_pl >= line and yycsvar_part_pl <= line1
		and yycsvar_part >= part and yycsvar_part <= part1
		and yycsvar_pm_code = "P" use-index yycsvar_perd_part_p:
		
		find first pt_mstr where pt_domain = global_domain and pt_part = yycsvar_mstr.yycsvar_part no-lock no-error.
		if not avail pt_mstr then next.

		create tttt.
		assign 
		    tttt_year = yycsvar_year
		    tttt_per = yycsvar_per
		    tttt_part = pt_part
		    tttt_desc = pt_desc1 + " " + pt_desc2
		    tttt_pl = pt_prod_line
		    tttt_povar = yycsvar_variance[13]
		    tttt_invvar = yycsvar_variance[14] + yycsvar_variance[15]
		    tttt_revalue = yycsvar_variance[20].

		/* 取本期入库量 */
		find first yyinvi_mstr where yyinvi_domain = global_domain
		  and yyinvi_year = yycsvar_year
			and yyinvi_per = yycsvar_per
			and yyinvi_part = yycsvar_part no-lock no-error.
		if avail yyinvi_mstr then assign tttt_qty = yyinvi_buy_qty.
		else assign tttt_qty = 0.

		if tttt_qty = 0 then 
			assign ppvrate = (yycsvar_variance[13] + yycsvar_variance[14] + yycsvar_variance[15] + yycsvar_variance[20]).
		else 
			assign ppvrate = (yycsvar_variance[13] + yycsvar_variance[14] + yycsvar_variance[15] + yycsvar_variance[20]) / tttt_qty.
		tttt_rate = ppvrate.
		release tttt.

	end. /* for each yycsvar_mstr */	
	h-tt = TEMP-TABLE tttt:HANDLE.
	RUN value(lc(global_user_lang) + "\yy\yytoexcel.p") (INPUT TABLE-HANDLE h-tt, INPUT inp_where, INPUT inp_sortby, INPUT v_list, INPUT inp_bwstitle).        
	empty temp-table tttt.
end. /* repeat */