/* yyactdetrpt.p - 产成品实际成本明细报表           */
/* Author: James Duan   *DATE:2009-09-21*           */
/*ss2012-8-14 升级*/

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

DEFINE VARIABLE part		LIKE pt_part.

DEFINE VARIABLE iyear		AS INT format "9999".
DEFINE VARIABLE iper		AS INT format "99".

define variable v_version	like yywobmspt_version.
define variable v_site		like yywobmspt_site.
define variable pcqty		like yyinvi_mfg_qty.
DEF VAR h-tt AS HANDLE.
DEFINE VAR inp_where     AS CHAR.
DEFINE VAR inp_sortby    AS CHAR.
DEFINE VAR inp_bwstitle  AS CHAR.
DEF    VAR      v_list AS CHAR INITIAL "".

define temp-table tttt RCODE-INFORMATION
    fields tttt_part		like pt_part			label "零件号"
    fields tttt_comp		like pt_part			label "子零件"
    fields tttt_desc		like pt_desc1			label "零件名称"
    fields tttt_pl		like pt_prod_line		label "产品类"
    fields tttt_stdmtlcost	like yywobmspt_elem_cost	label "物料"
    fields tttt_stdfrtcost	like yywobmspt_elem_cost	label "关税&运费"
    fields tttt_stdsubcost	like yywobmspt_elem_cost	label "转包"
    fields tttt_stdlbrcost	like yywobmspt_elem_cost	label "人工"
    fields tttt_stdmfgcost	like yywobmspt_elem_cost	label "制造费用"
  /*  fields tttt_bomchgvar	like yycsvar_variance[1]	label "1.BOM变更" */
    fields tttt_routchgvar	like yycsvar_variance[1]	label "工单改制"
    fields tttt_mtdchgvar1	like yycsvar_variance[1]	label "方法差异-量差"
    fields tttt_mtdchgvar2	like yycsvar_variance[1]	label "方法差异-价差"
    fields tttt_ptrepvar1	like yycsvar_variance[1]	label "临时替代"
    fields tttt_ptrepvar2	like yycsvar_variance[1]	label "零件替代"
    fields tttt_ratevar		like yycsvar_variance[1]	label "率差"
    fields tttt_mtdchglbr	like yycsvar_variance[1]	label "方法差异-工"
    fields tttt_mtdchgmfg	like yycsvar_variance[1]	label "方法差异-费"
    fields tttt_mtlchglbr	like yycsvar_variance[1]	label "量差-工"
    fields tttt_mtlchgmfg	like yycsvar_variance[1]	label "量差-费"
    fields tttt_othervar	like yycsvar_variance[1]	label "其他"
    fields tttt_ppvvar1		like yycsvar_variance[1]	label "PPV差异"
    fields tttt_ppvvar2		like yycsvar_variance[1]	label "自制半成品材料差异"
    fields tttt_glmtlvar	like yycsvar_variance[1]	label "物料总账差异(非QAD件)"
    fields tttt_lbrvar1		like yycsvar_variance[1]	label "低层人工差异"
    fields tttt_lbrvar2		like yycsvar_variance[1]	label "本层人工差异"
    fields tttt_mfgvar1		like yycsvar_variance[1]	label "低层制造费用差异"
    fields tttt_mfgvar2		like yycsvar_variance[1]	label "本层制造费用差异"
    fields tttt_actmtl		like yycsvar_variance[1]	label "物料实际"
    fields tttt_actlbr		like yycsvar_variance[1]	label "人工实际"
    fields tttt_actmfg		like yycsvar_variance[1]	label "制造实际"
    fields tttt_qty		like yyinvi_mfg_qty		label "数量"
    fields tttt_totalcost	like yycsvar_variance[1]	label "合计(实际成本)"
index part is primary tttt_part tttt_comp.	

define buffer bptmstr for pt_mstr.

iyear = year(today).
iper = month(today).


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    part	COLON 20 
    SKIP
    iyear	COLON 20 LABEL "年份"
    iper	COLON 45 LABEL "期间"
    SKIP
    SKIP
    SKIP(.4)  /*GUI*/
    WITH FRAME a SIDE-LABELS WIDTH 80 NO-BOX THREE-D.

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

REPEAT:

    UPDATE 
        part 
        iyear iper 

    WITH FRAME a.
    
/***************************************************
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
********************************************************/

    
    /* 确定计算材料差异期间 */
    find first glc_cal where /*2012-8-14 b*/  glc_cal.glc_domain = global_domain and /*ss2012-8-14 e*/ glc_year = iyear and glc_per = iper 
							no-lock no-error.
		if not avail glc_cal then do:
			find first glc_cal where glc_domain = global_domain and today >= glc_start and today <= glc_end no-lock no-error.
				if not avail glc_cal then do:
					message "总账期间未定义!" view-as alert-box.
				end.
		end.
    
    find first pt_mstr where /*ss2012-8-14 b*/ pt_mstr.pt_domain = global_domain and /*ss 2012-8-14 e*/ pt_mstr.pt_part = part  no-lock no-error.
    if not avail pt_mstr then return.
     
    /* 取当期入库 */
    find first yyinvi_mstr where /*ss2012-8-14 b*/ yyinvi_mstr.yyinvi_domain = global_domain and /*ss2012-8-14 e*/ yyinvi_year = iyear 
				and yyinvi_per = iper
				and yyinvi_part = part no-lock no-error.
    if avail yyinvi_mstr then do:
	if can-find(first code_mstr where /*ss2012-8-14 b*/ code_mstr.code_domain = global_domain and /*ss2012-8-14 e*/
				code_fldname = "sub_line" and code_value = yyinvi_part_pl no-lock)then
		assign pcqty = min(yyinvi_mfg_qty,yyinvi_buy_qty) + yyinvi_upl_qty.
	else
		assign pcqty = yyinvi_mfg_qty + yyinvi_upl_qty + yyinvi_buy_qty.
    end.
    else assign pcqty = 0.

    /* 取标准成本 */
    /*
    find first code_mstr where code_fldname = "so site" and pt_part begins code_value no-lock no-error.
    if avail code_mstr then v_site = code_cmmt.
    else assign v_site = "dcec-c".
    */
    find last tr_hist use-index tr_part_eff where /*ss2012-8-14 b*/ tr_hist.tr_domain = global_domain and /*ss2012-8-14 e*/ tr_part = part
		and tr_effdate >= glc_start
		and tr_effdate <= glc_end
		and tr_type = "RCT-WO" no-lock no-error.
    if avail tr_hist then assign v_site = tr_site.
    else assign v_site = "dcec-c".
    
    find last yywobmspt_mstr where /*ss2012-8-14 e*/ yywobmspt_mstr.yywobmspt_domain = global_domain and /*ss2012-8-14 e*/ yywobmspt_site = v_site 
	and yywobmspt_part = part 
	and ( year(yywobmspt_mod_date) < iyear or 
		(year(yywobmspt_mod_date) = iyear 
		 and month(yywobmspt_mod_date)<= iper))  no-lock no-error.			
    if not avail yywobmspt_mstr then do:
		find last yywobmspt_mstr where /*ss2012-8-14 e*/ yywobmspt_mstr.yywobmspt_domain = global_domain and /*ss2012-8-14 e*/ yywobmspt_site = v_site 
				and yywobmspt_part = part no-lock no-error.
			if not avail yywobmspt_mstr then do:
				find last yywobmspt_mstr where /*ss2012-8-14 e*/ yywobmspt_mstr.yywobmspt_domain = global_domain and /*ss2012-8-14 e*/ yywobmspt_part = part
						 no-lock no-error.
				if not avail yywobmspt_mstr then next.
			end.
		end.
    assign v_version = yywobmspt_version
           v_site = yywobmspt_site.

    for each yywobmspt_mstr no-lock where /*ss2012-8-14 b*/ yywobmspt_mstr.yywobmspt_domain = global_domain and /*ss2012-8-14 e*/ yywobmspt_site = v_site 
	and yywobmspt_part = part 
	and yywobmspt_version = v_version:
		
		find first tttt where tttt_part = "" and tttt_comp = yywobmspt_part no-error.
		if not avail tttt then do:
			create tttt.
			assign 
			    tttt_part = ""
			    tttt_comp = yywobmspt_part 
			    tttt_desc = pt_desc1 + " " + pt_desc2
			    tttt_pl = pt_prod_line.
		end. /* if not avail tttt */
		if yywobmspt_elem = "材料" then assign tttt_stdmtlcost = pcqty * yywobmspt_elem_cost.
		else if yywobmspt_elem = "关税运费" then assign tttt_stdfrtcost = pcqty * yywobmspt_elem_cost.
		else if yywobmspt_elem = "转包" then assign tttt_stdsubcost = pcqty * yywobmspt_elem_cost.
		else if yywobmspt_elem = "直接人工" then assign tttt_stdlbrcost = pcqty * yywobmspt_elem_cost.
		else if yywobmspt_elem = "制造费用" then assign tttt_stdmfgcost = pcqty * yywobmspt_elem_cost.
		assign tttt_qty = pcqty.

    end. /* for each yywobmspt_mstr */
	
    for first yycsvar_mstr no-lock where /*ss2012-8-14 b*/ yycsvar_mstr.yycsvar_domain = global_domain and /*ss2012-8-14 e*/ yycsvar_year = iyear
	and yycsvar_per = iper
	and yycsvar_part = part:

		find first tttt where tttt_part = "" and tttt_comp = yycsvar_part no-error.
		if not avail tttt then do:
			create tttt.
			assign 
			    tttt_part = ""
			    tttt_comp = yycsvar_part 
			    tttt_desc = pt_desc1 + " " + pt_desc2
			    tttt_pl = pt_prod_line.
		end. /* if not avail tttt */
		/*IC-WO BOM变更
		tttt_bomchgvar = yycsvar_variance[1]. */
		/*IC-WO 路线变更*/
		tttt_routchgvar = yycsvar_variance[2].
		/*IC-WO 方法差异量差*/
		tttt_mtdchgvar1 = yycsvar_variance[3].
		/*IC-WO 方法差异价差*/
		tttt_mtdchgvar2 = yycsvar_variance[4].
		/*IC-WO 临时替代*/
		tttt_ptrepvar1 = yycsvar_variance[5].
		/*IC-WO 零件替代*/
		tttt_ptrepvar2 = yycsvar_variance[6].
		/*IC-WO 率差*/
		tttt_ratevar = yycsvar_variance[7].
		/*IC-WO 其他*/
		tttt_othervar = yycsvar_variance[8].
		/*IC-WO 方法差异-工 */
		tttt_mtdchglbr = yycsvar_variance[9].
		/*IC-WO 方法差异-费 */
		tttt_mtdchgmfg = yycsvar_variance[10].
		/*IC-WO 量差-工 */
		tttt_mtlchglbr = yycsvar_variance[11].
		/*IC-WO 量差-费 */
		tttt_mtlchgmfg = yycsvar_variance[12].
		/*产成品PPV差异*/
		tttt_ppvvar1 = yycsvar_variance[13].
		/*自制半成品材料差异*/
		tttt_ppvvar2 = yycsvar_variance[14].
		/*总账差异*/
		tttt_glmtlvar = yycsvar_variance[15].
		/*产成品 - 人工差异*/
		tttt_lbrvar1 = yycsvar_variance[16].
		/*自制半成品 - 人工差异*/
		tttt_lbrvar2 = yycsvar_variance[17].
		/*产成品 - 制造费用差异*/
		tttt_mfgvar1 = yycsvar_variance[18].
		/*自制半成品 - 制造费用差异*/
		tttt_mfgvar2 = yycsvar_variance[19].
    end.

    /* 取实际成本 */
    find first yyactcs_mstr where /*ss2012-8-14 b*/ yyactcs_mstr.yyactcs_domain = global_domain and /*2012-8-14 e*/ yyactcs_year = iyear
	and yyactcs_per = iper
	and yyactcs_part = part no-lock no-error.
    if avail yyactcs_mstr then do:
	find first tttt where tttt_part = "" and tttt_comp = yyactcs_part no-error.
	if not avail tttt then do:
		create tttt.
		assign 
		    tttt_part = ""
		    tttt_comp = yyactcs_part 
		    tttt_desc = pt_desc1 + " " + pt_desc2
		    tttt_pl = pt_prod_line.
	end. /* if not avail tttt */
	assign 
	    tttt_actmtl = yyactcs_act_mtl
	    tttt_actlbr = yyactcs_act_lbr
	    tttt_actmfg = yyactcs_act_mfg
	    tttt_totalcost = tttt_actmtl + tttt_actlbr + tttt_actmfg.
		
    end. /* if avail yyactcs_mstr */ 

    /* 取明细标准成本 */
    for each yywobmsptd_det no-lock where /*ss2012-8-14 b*/ yywobmsptd_det.yywobmsptd_domain = global_domain and /*ss2012-8-14 e*/ yywobmsptd_site = v_site
	and yywobmsptd_part = part 
	and yywobmsptd_version = v_version:
	find first tttt where tttt_part = part and tttt_comp = yywobmsptd_comp no-error.
	if not avail tttt then do:
		find first bptmstr where /*ss2012-8-14 b*/ pt_mstr.pt_domain = global_domain and /*ss-2012-8-14 e*/ bptmstr.pt_part = yywobmsptd_comp 
							no-lock no-error.
		create tttt.
		assign tttt_part = part
		       tttt_comp = yywobmsptd_comp
		       tttt_desc = bptmstr.pt_desc1 + "" + bptmstr.pt_desc2
		       tttt_pl	 = bptmstr.pt_prod_line.
	end.
	if yywobmsptd_elem = "材料" then 
		assign tttt_stdmtlcost = pcqty * yywobmsptd_unit_qty * yywobmsptd_elem_cost.
	else if yywobmsptd_elem = "关税运费" then 
		assign tttt_stdfrtcost = pcqty * yywobmsptd_unit_qty * yywobmsptd_elem_cost.
	else if yywobmsptd_elem = "转包" then 
		assign tttt_stdsubcost = pcqty * yywobmsptd_unit_qty * yywobmsptd_elem_cost.
	else if yywobmsptd_elem = "直接人工" then 
		assign tttt_stdlbrcost = pcqty * yywobmsptd_unit_qty * yywobmsptd_elem_cost.
	else if yywobmsptd_elem = "制造费用" then 
		assign tttt_stdmfgcost = pcqty * yywobmsptd_unit_qty * yywobmsptd_elem_cost.
    end. /* for each yywobmsptd_det */


    /* ICWO 差异 */
    for each yycsvard_det no-lock where /*ss2012-8-14 b*/ yycsvard_det.yycsvard_domain = global_domain and /*ss2012-8-14*/ yycsvard_year = iyear
	and yycsvard_per = iper
	and yycsvard_part = part:
	find first tttt where tttt_part = part and tttt_comp = yycsvard_comp no-error.
	if not avail tttt then do:
		find first bptmstr where /*ss2012-8-14 b*/ pt_mstr.pt_domain = global_domain and /*ss-2012-8-14 e*/ bptmstr.pt_part = yycsvard_comp
							no-lock no-error.
		create tttt.
		assign tttt_part = part
		       tttt_comp = yycsvard_comp
		       tttt_desc = bptmstr.pt_desc1 + "" + bptmstr.pt_desc2
		       tttt_pl	 = bptmstr.pt_prod_line.
	end.
	/*IC-WO BOM变更
	tttt_bomchgvar = yycsvard_variance[1]. */
	/*IC-WO 路线变更*/ 
	tttt_routchgvar = yycsvard_variance[2].
	/*IC-WO 方法差异量差*/ 
	tttt_mtdchgvar1 = yycsvard_variance[3].
	/*IC-WO 方法差异价差*/ 
	tttt_mtdchgvar2 = yycsvard_variance[4].
	/*IC-WO 临时替代*/ 
	tttt_ptrepvar1 = yycsvard_variance[5].
	/*IC-WO 零件替代*/ 
	tttt_ptrepvar2 = yycsvard_variance[6].
	/*IC-WO 率差*/ 
	tttt_ratevar = yycsvard_variance[7].
	/*IC-WO 其他*/ 
	tttt_othervar = yycsvard_variance[8].
	/*IC-WO 方法差异-工 */
	tttt_mtdchglbr = yycsvard_variance[9].
	/*IC-WO 方法差异-费 */
	tttt_mtdchgmfg = yycsvard_variance[10].
	/*IC-WO 量差-工 */
	tttt_mtlchglbr = yycsvard_variance[11].
	/*IC-WO 量差-费 */
	tttt_mtlchgmfg = yycsvard_variance[12].
	/*产成品PPV差异*/ 
	tttt_ppvvar1 = yycsvard_variance[13].
	/*自制半成品材料差异*/ 
	tttt_ppvvar2 = yycsvard_variance[14].
	/*总账差异*/ 
	tttt_glmtlvar = yycsvard_variance[15].
	/*产成品 - 人工差异*/ 
	tttt_lbrvar1 = yycsvard_variance[16].
	/*自制半成品 - 人工差异*/ 
	tttt_lbrvar2 = yycsvard_variance[17].
	/*产成品 - 制造费用差异*/ 
	tttt_mfgvar1 = yycsvard_variance[18].
	/*自制半成品 - 制造费用差异*/ 
	tttt_mfgvar2 = yycsvard_variance[19].
    end. /* for each yycsvard_det */

    /* 取实际成本 */
    for each yyactcsd_det no-lock where /*ss2012-8-14 b*/ yyactcsd_det.yyactcsd_domain = global_domain and /*ss2012-8-14 e*/ yyactcsd_year = iyear
	and yyactcsd_per = iper
	and yyactcsd_part = part:
	
	find first tttt where tttt_part = part and tttt_comp = yyactcsd_comp no-error.
	if not avail tttt then do:
		find first bptmstr where /*ss2012-8-14 b*/ pt_mstr.pt_domain = global_domain and /*ss-2012-8-14 e*/ bptmstr.pt_part = yyactcsd_comp 
							no-lock no-error.
		create tttt.
		assign tttt_part = part
		       tttt_comp = yyactcsd_comp
		       tttt_desc = bptmstr.pt_desc1 + "" + bptmstr.pt_desc2
		       tttt_pl	 = bptmstr.pt_prod_line.
	end.
	assign 
	    tttt_actmtl = yyactcsd_act_mtl
	    tttt_actlbr = yyactcsd_act_lbr
	    tttt_actmfg = yyactcsd_act_mfg
	    tttt_totalcost = tttt_actmtl + tttt_actlbr + tttt_actmfg.
	/* 取实际库存 */
	find first yyinvid_det where /*2012-8-14 b*/ yyinvid_det.yyinvid_domain = global_domain and /*ss2012-8-14 e*/ yyinvid_year = iyear
		and yyinvid_per = iper
		and yyinvid_part = part
		and yyinvid_comp = yyactcsd_comp no-lock no-error.
	if avail yyinvid_det then tttt_qty = yyinvid_qty.

    end. /* if avail yyactcs_mstr */

    

    h-tt = TEMP-TABLE tttt:HANDLE.
    RUN value(lc(global_user_lang) + "\yy\yytoexcel.p") (INPUT TABLE-HANDLE h-tt, INPUT inp_where, INPUT inp_sortby, INPUT v_list, INPUT inp_bwstitle).        
    empty temp-table tttt.

END.

