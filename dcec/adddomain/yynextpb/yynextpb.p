/* yyinvo.p - 计算材料、半成品/成品下个期间期初库存和期初差异 */
/*  Author: James Duan *DATE:2009-09-24*                      */
/*ss2012-8-14 升级*/

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

define variable lupdate		like mfc_logical.

define variable theyear		like yypbd_year format "9999".
define variable theper		like yypbd_per format "99".
define variable nxtyear		like yyinvi_year.
define variable nxtper		like yyinvi_per.
define variable v_flag		as   logical.
define variable per_start	like glc_start.
define variable per_end		like glc_end.

DEF VAR h-tt AS HANDLE.
DEFINE VAR inp_where     AS CHAR.
DEFINE VAR inp_sortby    AS CHAR.
DEFINE VAR inp_bwstitle  AS CHAR.
DEF    VAR      v_list AS CHAR INITIAL "".

define variable icount		as int.
define temp-table ttpbd_det RCODE-INFORMATION
	fields ttpbd_part	like yypbd_part		label "零件"
	fields ttpbd_prod_line  like pt_prod_line	label "产品类"
	fields ttpbd_qty_last	like yypbd_qty		label "本期期初库存"
	fields ttpbd_in_last	like yypbd_qty		label "本期入库库存"
	fields ttpbd_mtl_lastb	like yyvarated_mtl_rate label "本期期初材料差异"
	fields ttpbd_lbr_lastb	like yyvarated_lbr_rate	label "本期期初人工差异"
	fields ttpbd_mfg_lastb	like yyvarated_mfg_rate	label "本期期初费用差异"
	fields ttpbd_out_last	like yypbd_qty		label "本期出库"	
	fields ttpbd_cyc_qty	like yyinvi_cyc_qty	label "本期盘点调整"
	fields ttpbd_load_var	like yypbd_mtl_var	label "本期手工差异"
	fields ttpbd_mtl_lastc	like yyvarated_mtl_rate	label "本期材料差异"
	fields ttpbd_lbr_lastc	like yyvarated_lbr_rate	label "本期人工差异"
	fields ttpbd_mfg_lastc	like yyvarated_mfg_rate	label "本期费用差异"
	fields ttpbd_mtl_last	like yyvarated_mtl_rate	label "本期材料差异率"
	fields ttpbd_lbr_last	like yyvarated_lbr_rate	label "本期人工差异率"
	fields ttpbd_mfg_last	like yyvarated_mfg_rate	label "本期费用差异率"
	fields ttpbd_qty	like yypbd_qty		label "下期期初库存"
	fields ttpbd_mtl_var	like yypbd_mtl_var	label "下期期初材料差异"
	fields ttpbd_lbr_var	like yypbd_lbr_var	label "下期期初人工差异"
	fields ttpbd_mfg_var	like yypbd_mfg_var	label "下期期初费用差异"
	fields ttpbd_commt	as char format "x(20)"  label "备注"
index ttpbd_part IS PRIMARY UNIQUE ttpbd_part.

theyear = YEAR(TODAY).
theper = MONTH(TODAY).

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   theyear     colon 15 label "年份"
   theper       colon 50 label "期间"
   lupdate	    colon 15 label "更新"
 SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = "下期期初库存及差异计算".
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

{wbrp01.i}
repeat :
	update 
	  theyear
	  theper
	  lupdate
	with frame a.

	find first glc_cal where /*ss2012-8-14 b*/ glc_cal.glc_domain = global_domain and /*ss2012-8-14 e*/
							glc_year = theyear and glc_per = theper no-lock no-error.

	if available glc_cal then do:
		per_start = glc_start.
		per_end = glc_end.
	end.
	else do:
		message "财务期间未定义!" view-as alert-box.
		next.
	end.

	theyear = glc_year.
	theper = glc_per.
	/* 取本期期初库存 */
	for each yypbd_det no-lock where /*ss2012-8-14*/ yypbd_det.yypbd_domain = global_domain and /*ss2012-8-14 e*/ 
			 yypbd_year = theyear and yypbd_per = theper:
		find first ttpbd_det where ttpbd_part = yypbd_part  no-error.
		if not avail ttpbd_det then do:
			create ttpbd_det.
			assign
			    ttpbd_part = yypbd_part
			    ttpbd_prod_line = yypbd_part_pl.
		end. /* if not avail ttpbd_det */
		assign ttpbd_qty = yypbd_qty
		       ttpbd_qty_last = yypbd_qty	
		       ttpbd_mtl_var = yypbd_mtl_var
		       ttpbd_lbr_var = yypbd_lbr_var
		       ttpbd_mfg_var = yypbd_mfg_var
		       ttpbd_mtl_lastb = yypbd_mtl_var
		       ttpbd_lbr_lastb = yypbd_lbr_var
		       ttpbd_mfg_lastb = yypbd_mfg_var.
	end. /* for each yypbd_det */

	/* 取本期入库库存 */
	for each yyinvi_mstr no-lock where /*ss2012-8-14 b*/ yyinvi_mstr.yyinvi_domain = global_domain and /*ss2012-8-14 e*/ yyinvi_year = theyear
		and yyinvi_per = theper:
		find first ttpbd_det where ttpbd_part = yyinvi_part  no-error.
		if not avail ttpbd_det then do:
			create ttpbd_det.
			assign
			    ttpbd_part = yyinvi_part
			    ttpbd_prod_line = yyinvi_part_pl.
		end. /* if not avail ttpbd_det */
		if can-find(first code_mstr where /*ss2012-8-14 */ code_mstr.code_domain = global_domain and /*ss2012-8-14 e*/
					code_fldname = "sub_line" and code_value = yyinvi_part_pl no-lock) then
		assign ttpbd_qty = ttpbd_qty + min(yyinvi_mfg_qty,yyinvi_buy_qty) + yyinvi_upl_qty +  yyinvi_cyc_qty
		       ttpbd_in_last = ttpbd_in_last +  min(yyinvi_mfg_qty,yyinvi_buy_qty) + yyinvi_upl_qty
		       ttpbd_cyc_qty = yyinvi_cyc_qty.
		else
		assign ttpbd_qty = ttpbd_qty + yyinvi_mfg_qty + yyinvi_upl_qty + yyinvi_buy_qty + yyinvi_cyc_qty
		       ttpbd_in_last = ttpbd_in_last +  yyinvi_mfg_qty + yyinvi_upl_qty + yyinvi_buy_qty
		       ttpbd_cyc_qty = yyinvi_cyc_qty.
	end. /* for each yyinvi_mstr */

	/*取本期出库库存*/
	for each yyinvo_mstr no-lock where /*ss2012-8-14 */ yyinvo_mstr.yyinvo_domain = global_domain and /*ss2012-8-14 e*/ yyinvo_year = theyear
		and yyinvo_per = theper:
		find first ttpbd_det where ttpbd_part = yyinvo_part	no-error.
		if not avail ttpbd_det then do:
			create ttpbd_det.
			assign
			    ttpbd_part = yyinvo_part
			    ttpbd_prod_line = yyinvo_part_pl.
		end. /* if not avail ttpbd_det */
		assign ttpbd_qty = ttpbd_qty - yyinvo_qty
		       ttpbd_out_last = ttpbd_out_last + yyinvo_qty.
	end. /* for each yyinvo_mstr */

	/*取本期差异*/
	for each yycsvar_mstr no-lock where /*ss2012-8-14 b*/ yycsvar_mstr.yycsvar_domain = global_domain and /*ss2012-8-14 e*/ yycsvar_year = theyear
		and yycsvar_per = theper:
		find first ttpbd_det where ttpbd_part = yycsvar_part  no-error.
		if not avail ttpbd_det then do:
			create ttpbd_det.
			assign
			    ttpbd_part = yycsvar_part
			    ttpbd_prod_line = yycsvar_part_pl.
		end. /* if not avail ttpbd_det */		
	end. /* for each */
	
	/* 计算下个期间 */
	nxtper = (if theper = 12 then 1 else (theper + 1)).
	nxtyear = (if theper = 12 then theyear + 1 else theyear).

	/* 显示下期期初库存和差异 */
	for each ttpbd_det :
		v_flag = false.
		/* 取期初差异 */
		if ttpbd_mtl_var <> 0 or ttpbd_lbr_var <> 0 or ttpbd_mfg_var <> 0 then v_flag = true.	
		/* 本期差异 */

		find first yycsvar_mstr where /*ss2012-8-14 */ yycsvar_mstr.yycsvar_domain = global_domain and /*ss2012-8-14 e*/ yycsvar_year = theyear
			and yycsvar_per = theper
			and yycsvar_part = ttpbd_part no-lock no-error.
		if avail yycsvar_mstr then do:
			v_flag = true.
			/* ic-wo , ppv, 总账,重估 */
			do icount = 1 to 15 :
				assign ttpbd_mtl_var = ttpbd_mtl_var + yycsvar_variance[icount]
				       ttpbd_mtl_lastc = ttpbd_mtl_lastc + yycsvar_variance[icount].
			end.
			assign
			ttpbd_mtl_var = ttpbd_mtl_var + yycsvar_variance[20]
			ttpbd_mtl_lastc = ttpbd_mtl_lastc + yycsvar_variance[20]
			ttpbd_lbr_var = ttpbd_lbr_var + yycsvar_variance[16] + yycsvar_variance[17]
			ttpbd_lbr_lastc = ttpbd_lbr_lastc + yycsvar_variance[16] + yycsvar_variance[17]
			ttpbd_mfg_var = ttpbd_mfg_var + yycsvar_variance[18] + yycsvar_variance[19]
			ttpbd_mfg_lastc = ttpbd_mfg_lastc + yycsvar_variance[18] + yycsvar_variance[19].
		end. /* if avail yycsvar_mstr */
		/* 取出本期材料料差 */
		find first yyvarated_det where /*ss2012-8-14 */ yyvarated_det.yyvarated_domain = global_domain and /*2012-8-14 e*/ yyvarated_year = theyear
			and yyvarated_per = theper
			and yyvarated_part = ttpbd_part no-lock no-error.
		if not v_flag then 
			assign ttpbd_commt = "无差异".
		else if v_flag and not avail yyvarated_det then 
			assign ttpbd_commt = "本期料差未计算". 
		else if avail yyvarated_det then do:
			/* 带走差异 */
			assign 
			       ttpbd_mtl_var = ttpbd_mtl_var - ttpbd_out_last * yyvarated_mtl_rate
			       ttpbd_lbr_var = ttpbd_lbr_var - ttpbd_out_last * yyvarated_lbr_rate
			       ttpbd_mfg_var = ttpbd_mfg_var - ttpbd_out_last * yyvarated_mfg_rate
			       ttpbd_mtl_last = yyvarated_mtl_rate
			       ttpbd_lbr_last = yyvarated_lbr_rate
			       ttpbd_mfg_last = yyvarated_mfg_rate.
		end. /* else if avail yyvarated_det */

		if ttpbd_prod_line >= "1100" and ttpbd_prod_line <= "12ZZ" then do:
			for first yycsvar_mstr where /*ss2012-8-14 */ yycsvar_mstr.yycsvar_domain = global_domain and /*ss2012-8-14 */ yycsvar_year = theyear
				and yycsvar_per = theper
				and yycsvar_part = ttpbd_part no-lock:
				ttpbd_mtl_var = ttpbd_mtl_var - yycsvar_variance[23].
				ttpbd_load_var = yycsvar_variance[23].
			end.
		end. /* if ttpbd_prod_line >= "1100" and ttpbd_prod_line <= "12ZZ" */
		
	end.

	if lupdate then do:

		for each yypbd_det where /*ss2012-8-14 b*/ yypbd_det.yypbd_domain = global_domain and /*ss2012-8-14 */ yypbd_year = nxtyear
			and yypbd_per = nxtper 
			and yypbd_part = ttpbd_part:
			delete yypbd_det.
		end.
		
		for each ttpbd_det no-lock where ttpbd_commt <> "本期料差未计算":
			find first pt_mstr where pt_part = ttpbd_part no-lock no-error.
			if not avail pt_mstr then next.
						
			/* 下期期初库存,差异 */
			find first yypbd_det where /*ss2012-8-14 b*/ yypbd_det.yypbd_domain = global_domain and /*ss2012-8-14 */ yypbd_year = nxtyear
				and yypbd_per = nxtper 
				and yypbd_part = ttpbd_part no-error.
			if not avail yypbd_det then do:
				create yypbd_det.
				assign 
				    yypbd_part = ttpbd_part
				    yypbd_year = nxtyear
				    yypbd_per = nxtper.
			end. /* if not avail yypbd_det */
			assign 
			    yypbd_part_pl = pt_prod_line 
			    yypbd_qty = ttpbd_qty
			    yypbd_mtl_var = ttpbd_mtl_var
			    yypbd_lbr_var = ttpbd_lbr_var
			    yypbd_mfg_var = ttpbd_mfg_var.
		end. /*for each ttpbd_det */
		
	end. /* if lupdate */
	h-tt = TEMP-TABLE ttpbd_det:HANDLE.
	RUN value(lc(global_user_lang) + "\yy\yytoexcel.p") (INPUT TABLE-HANDLE h-tt, INPUT inp_where, INPUT inp_sortby, INPUT v_list, INPUT inp_bwstitle).        
	
	empty temp-table ttpbd_det.

end. /* repeat */

/*GUI*/ 
{wbrp04.i &frame-spec = a}

