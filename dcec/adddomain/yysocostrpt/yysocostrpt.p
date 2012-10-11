/* yyactrpt.p - 产成品实际成本报表                  */
/* Author: James Duan   *DATE:2009-09-21*           */
/* Author: Henri Zhu    *DATE:2012-08-16*           */

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "20120816s"}

DEFINE VARIABLE part		LIKE pt_part.
DEFINE VARIABLE part1		LIKE pt_part.
DEFINE VARIABLE line		LIKE pt_prod_line.
DEFINE VARIABLE line1		LIKE pt_prod_line.

DEFINE VARIABLE iyear		AS INT format "9999".
DEFINE VARIABLE iper		AS INT format "99".

define variable pcqty		like yyinvi_mfg_qty.

define variable nxtyear		as int.
define variable nxtper		as int.
define variable stdmtlcost	like yyactcs_act_mtl.
define variable stdmfgcost	like yyactcs_act_mtl.
define variable stdlbrcost	like yyactcs_act_mtl.
define variable actmtlcost	like yyactcs_act_mtl.
define variable actmfgcost	like yyactcs_act_mtl.
define variable actlbrcost	like yyactcs_act_mtl.
define variable v_version	like yywobmspt_version.
define variable v_site		like yywobmspt_site.
define variable i		as int.
define variable tot_out_qty	as int.

DEFINE VARIABLE h-tt		AS HANDLE.
DEFINE VARIABLE inp_where	AS CHAR.
DEFINE VARIABLE inp_sortby	AS CHAR.
DEFINE VARIABLE inp_bwstitle	AS CHAR.
DEFINE VARIABLE v_list		AS CHAR INITIAL "".

define temp-table tttt RCODE-INFORMATION
    fields tttt_part		like pt_part			label "零件号"
    fields tttt_desc		like pt_desc1			label "零件名称"
    fields tttt_pl		like pt_prod_line		label "产品类"
    fields tttt_pbqty		like yypbd_qty			label "期初数量"
    fields tttt_pbmtl		like yywobmspt_elem_cost	label "期初金额-料"
    fields tttt_pblbr		like yywobmspt_elem_cost	label "期初金额-工"
    fields tttt_pbmfg		like yywobmspt_elem_cost	label "期初金额-费"
    fields tttt_pcqty		like yyinvi_buy_qty		label "本期入库量"
    fields tttt_pcmtl		like yywobmspt_elem_cost	label "本期入库金额-料"
    fields tttt_pclbr		like yywobmspt_elem_cost	label "本期入库金额-工"
    fields tttt_pcmfg		like yywobmspt_elem_cost	label "本期入库金额-费"
    fields tttt_pbvarmtl	like yypbd_mtl_var		label "期初差异金额-料"
    fields tttt_pbvarlbr	like yypbd_lbr_var		label "期初差异金额-工"
    fields tttt_pbvarmfg	like yypbd_mfg_var		label "期初差异金额-费"
    fields tttt_pcvarmtl	like yycsvar_variance[1]	label "本期入库差异金额-料"
    fields tttt_pcvarlbr	like yycsvar_variance[1]	label "本期入库差异金额-工"
    fields tttt_pcvarmfg	like yycsvar_variance[1]	label "本期入库差异金额-费"
    fields tttt_pcsoload	like yycsvar_variance[1]	label "本期手工金额" 
    fields tttt_soqty		like yyinvo_qty			label "销售出库量"
    fields tttt_somtl		like yyactcs_act_mtl		label "销售出库金额-料"
    fields tttt_solbr		like yyactcs_act_lbr		label "销售出库金额-工"
    fields tttt_somfg		like yyactcs_act_mfg		label "销售出库金额-费"
    fields tttt_wocqty		like yyinvo_qty			label "装机出库数量"
    fields tttt_wocmtl		like yyactcs_act_mtl		label "装机出库金额-料"
    fields tttt_woclbr		like yyactcs_act_lbr		label "装机出库金额-工"
    fields tttt_wocmfg		like yyactcs_act_mfg		label "装机出库金额-费"
    fields tttt_woeqty		like yyinvo_qty			label "改制出库数量"
    fields tttt_woemtl		like yyactcs_act_mtl		label "改制出库金额-料"
    fields tttt_woelbr		like yyactcs_act_lbr		label "改制出库金额-工"
    fields tttt_woemfg		like yyactcs_act_mfg		label "改制出库金额-费"
    fields tttt_tgqty		like yyinvo_qty			label "三包出库数量"
    fields tttt_tgmtl		like yyactcs_act_mtl		label "三包出库金额-料"
    fields tttt_tglbr		like yyactcs_act_lbr		label "三包出库金额-工"
    fields tttt_tgmfg		like yyactcs_act_mfg		label "三包出库金额-费"
    fields tttt_testqty		like yyinvo_qty			label "试验出库数量"
    fields tttt_testmtl		like yyactcs_act_mtl		label "试验出库金额-料"
    fields tttt_testlbr		like yyactcs_act_lbr		label "试验出库金额-工"
    fields tttt_testmfg		like yyactcs_act_mfg		label "试验出库金额-费"
    fields tttt_othqty		like yyinvo_qty			label "其他计划外出库数量"
    fields tttt_othmtl		like yyactcs_act_mtl		label "其他计划外出库金额-料"
    fields tttt_othlbr		like yyactcs_act_lbr		label "其他计划外出库金额-工"
    fields tttt_othmfg		like yyactcs_act_mfg		label "其他计划外出库金额-费"
    fields tttt_peqty		like yypbd_qty			label "期末数量"
    fields tttt_pemtl		like yywobmspt_elem_cost	label "期末金额-料"
    fields tttt_pelbr		like yywobmspt_elem_cost	label "期末金额-工"
    fields tttt_pemfg		like yywobmspt_elem_cost	label "期末金额-费"
    fields tttt_pevarmtl	like yypbd_mtl_var		label "期末差异金额-料"
    fields tttt_pevarlbr	like yypbd_lbr_var		label "期末差异金额-工"
    fields tttt_pevarmfg	like yypbd_mfg_var		label "期末差异金额-费"

index part is primary tttt_part.	

iyear = year(today).
iper = month(today).	


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    part	COLON 20 
    part1	COLON 45 LABEL "至"
    SKIP
    line	COLON 20 
    line1	COLON 45 LABEL "至"
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
    IF part1 = hi_char THEN part1 = "".
    IF line1 = hi_char THEN line1 = "".   

    UPDATE 
        part part1
	line line1
        iyear iper 

    WITH FRAME a.
    
    IF part1 = "" THEN part1 = hi_char.
    IF line1 = "" THEN line1 = hi_char.

    /* 确定计算材料差异期间 */
    find first glc_cal where glc_domain = global_domain and glc_year = iyear and glc_per = iper no-lock no-error.
    if not avail glc_cal then do:
	message "财务期间未定义!" view-as alert-box.
	next.
    end.
/***********************************************************************
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
*************************************************************************/
    

    for each pt_mstr no-lock where pt_domain = global_domain and pt_part >= part and pt_part <= part1
		and pt_prod_line >= line and pt_prod_line <= line1:

	find first tttt where tttt_part = pt_part no-error.
	if not avail tttt then do:
		create tttt.
		assign 
		   tttt_part = pt_part
		   tttt_desc = pt_desc1 + " " + pt_desc2
		   tttt_pl = pt_prod_line.
	end. /* if not avail tttt */
	/* 取标准成本 */
	/*
	find first code_mstr where code_fldname = "so site" and pt_part begins code_value no-lock no-error.
	if avail code_mstr then v_site = code_cmmt.
	else assign v_site = "dcec-c".	
	*/
	find last tr_hist use-index tr_part_eff where tr_domain = global_domain 
	  and tr_part = pt_part
		and tr_effdate >= glc_start
		and tr_effdate <= glc_end
		and tr_type = "RCT-WO" no-lock no-error.
	if avail tr_hist then assign v_site = tr_site.
	else assign v_site = "dcec-c".	

	find last yywobmspt_mstr where yywobmspt_domain = global_domain 
	  and yywobmspt_site = v_site
		and yywobmspt_part = pt_part 
		and ( year(yywobmspt_mod_date) < iyear or 
			(year(yywobmspt_mod_date) = iyear 
			 and month(yywobmspt_mod_date)<= iper))  no-lock no-error.
	if not avail yywobmspt_mstr then do:
		find last yywobmspt_mstr where  yywobmspt_domain = global_domain 
	    and yywobmspt_site = v_site 
			and yywobmspt_part = pt_part no-lock no-error.
		if not avail yywobmspt_mstr then do:
			find last yywobmspt_mstr where  yywobmspt_domain = global_domain 
	         and yywobmspt_part = pt_part no-lock no-error.	
			/* if not avail yywobmspt_mstr then next.  */
		end.
	end.	
	assign 
	   stdmtlcost = 0
	   stdlbrcost = 0
	   stdmfgcost = 0
	   v_version = -1.
	if avail yywobmspt_mstr then 
		assign 
		   v_version = yywobmspt_version
		   v_site = yywobmspt_site.
	else do:
		find first sct_det where sct_domain = global_domain and sct_part = pt_part no-lock no-error.
		if avail sct_det then 
			assign stdmtlcost = sct_mtl_tl + sct_mtl_ll
			       stdlbrcost = sct_lbr_tl + sct_lbr_ll
			       stdmfgcost = sct_bdn_tl + sct_bdn_tl.
	end.
	   
	
	for each yywobmspt_mstr no-lock where yywobmspt_domain = global_domain 
	    and yywobmspt_site = v_site
			and yywobmspt_part = pt_part 
			and yywobmspt_version = v_version :
		if yywobmspt_elem = "材料" or yywobmspt_elem = "关税运费" or yywobmspt_elem = "转包" then 
			assign stdmtlcost = stdmtlcost + yywobmspt_elem_cost.

		if yywobmspt_elem = "直接人工" then 
			assign stdlbrcost = stdlbrcost + yywobmspt_elem_cost.

		if yywobmspt_elem = "制造费用" then 
			assign stdmfgcost = stdmfgcost + yywobmspt_elem_cost. 
	end. /* for each yywobmspt_mstr */

	/* 取期初数量、差异 */
	find first yypbd_det where yypbd_domain = global_domain 
	  and yypbd_year = iyear
		and yypbd_per = iper 
		and yypbd_part = pt_part no-lock no-error.
	if avail yypbd_det then 
		assign 
		   tttt_pbqty = yypbd_qty
		   tttt_pbmtl = tttt_pbqty * stdmtlcost
		   tttt_pblbr = tttt_pbqty * stdlbrcost
		   tttt_pbmfg = tttt_pbqty * stdmfgcost
		   tttt_pbvarmtl = yypbd_mtl_var
		   tttt_pbvarlbr = yypbd_lbr_var
		   tttt_pbvarmfg = yypbd_mfg_var.

	/* 取当期入库数量 */
	find first yyinvi_mstr where yyinvi_domain = global_domain 
	  and yyinvi_year = iyear
		and yyinvi_per = iper 
		and yyinvi_part = pt_part no-lock no-error.
	if avail yyinvi_mstr then do: 
		if can-find(first code_mstr where code_domain = global_domain and code_fldname = "sub_line" and code_value = yyinvi_part_pl no-lock)then
		assign tttt_pcqty = min(yyinvi_mfg_qty, yyinvi_buy_qty) + yyinvi_upl_qty.
		else assign tttt_pcqty = yyinvi_mfg_qty + yyinvi_upl_qty + yyinvi_buy_qty.
		assign 
	           tttt_pcmtl = tttt_pcqty * stdmtlcost
		   tttt_pclbr = tttt_pcqty * stdlbrcost
		   tttt_pcmfg = tttt_pcqty * stdmfgcost.
	end.
	/* 取本期差异金额*/
	find first yycsvar_mstr where yycsvar_domain = global_domain 
	  and yycsvar_year = iyear
		and yycsvar_per = iper 
		and yycsvar_part = pt_part no-lock no-error.
	if avail yycsvar_mstr then do:
		do i = 1 to 15 :
			tttt_pcvarmtl = tttt_pcvarmtl + yycsvar_variance[i].
		end.
		tttt_pcvarmtl = tttt_pcvarmtl + yycsvar_variance[20].
		tttt_pcvarlbr = +  yycsvar_variance[16] +  yycsvar_variance[17].
		tttt_pcvarmfg = +  yycsvar_variance[18] +  yycsvar_variance[19].
		tttt_pcsoload = yycsvar_variance[23]. /*导入so*/
	end. /* if avail yycsvar_mstr */

	/* 取分摊率 */
	find first yyvarated_det where yyvarated_domain = global_domain 
	    and yyvarated_year = iyear
			and yyvarated_per = iper
			and yyvarated_part = pt_part no-lock no-error.
	if not avail yyvarated_det then do:
		assign tttt_desc = tttt_desc + " ##料差率未计算".
		next.
	end.

	/* 取实际成本 */
	assign
	   actmtlcost = (stdmtlcost + yyvarated_mtl_rate)
	   actlbrcost = (stdlbrcost + yyvarated_lbr_rate)
	   actmfgcost = (stdmfgcost + yyvarated_mfg_rate).

	/* 取出库 */
	assign tot_out_qty = 0.
	for each yyinvo_mstr no-lock where yyinvo_domain = global_domain 
	  and yyinvo_year = iyear
		and yyinvo_per = iper
		and yyinvo_part = pt_part 
		use-index yyinvo_perd_part:
		if yyinvo_out_type = "销售" then 
			assign tttt_soqty = tttt_soqty + yyinvo_qty.
		else if yyinvo_out_type = "装机" then
			assign tttt_wocqty = tttt_wocqty + yyinvo_qty.
		else if yyinvo_out_type = "改制" then 
			assign tttt_woeqty = tttt_woeqty + yyinvo_qty.
		else if yyinvo_out_type = "计划外三包" then
			assign tttt_tgqty = tttt_tgqty + yyinvo_qty.
		else if yyinvo_out_type = "计划外试验" then
			assign tttt_testqty = tttt_testqty + yyinvo_qty.
		else if yyinvo_out_type = "计划外其他" then
			assign tttt_othqty = tttt_othqty + yyinvo_qty.
		tot_out_qty = tot_out_qty + yyinvo_qty.
	end. /* for each yyinvo_mstr */
	assign
	    tttt_somtl = tttt_soqty * actmtlcost
	    tttt_solbr = tttt_soqty * actlbrcost
	    tttt_somfg = tttt_soqty * actmfgcost
	    tttt_wocmtl = tttt_wocqty * actmtlcost
	    tttt_woclbr = tttt_wocqty * actlbrcost
	    tttt_wocmfg = tttt_wocqty * actmfgcost
	    tttt_woemtl = tttt_woeqty * actmtlcost
	    tttt_woelbr = tttt_woeqty * actlbrcost
	    tttt_woemfg = tttt_woeqty * actmfgcost
	    tttt_tgmtl = tttt_tgqty * actmtlcost
	    tttt_tglbr = tttt_tgqty * actlbrcost
	    tttt_tgmfg = tttt_tgqty * actmfgcost
	    tttt_testmtl = tttt_testqty * actmtlcost
	    tttt_testlbr = tttt_testqty * actlbrcost
	    tttt_testmfg = tttt_testqty * actmfgcost
	    tttt_othmtl = tttt_othqty * actmtlcost
	    tttt_othlbr = tttt_othqty * actlbrcost
	    tttt_othmfg = tttt_othqty * actmfgcost.

	/* 计算期末数量 */
	nxtper = (if iper = 12 then 1 else (iper + 1)).
	nxtyear = (if iper = 12 then iyear + 1 else iyear).
	/* 下期期初库存 */
	find first yypbd_det where yypbd_domain = global_domain 
	  and yypbd_year = nxtyear
		and yypbd_per = nxtper
		and yypbd_part = pt_part no-error.
	if not avail yypbd_det then do:
		create yypbd_det.
		assign 
		    yypbd_domain = global_domain 
		    yypbd_part = pt_part
		    yypbd_year = nxtyear
		    yypbd_per = nxtper
		    yypbd_part_pl = pt_prod_line 
	            yypbd_qty = tttt_pbqty + tttt_pcqty - tot_out_qty
		    yypbd_mtl_var = yypbd_qty * yyvarated_mtl_rate
		    yypbd_lbr_var = yypbd_qty * yyvarated_lbr_rate
		    yypbd_mfg_var = yypbd_qty * yyvarated_mfg_rate.
	end. /* if not avail yypbd_det */
	assign
	   tttt_peqty = yypbd_qty
	   tttt_pemtl = tttt_peqty * actmtlcost
	   tttt_pelbr = tttt_peqty * actlbrcost
	   tttt_pemfg = tttt_peqty * actmfgcost
	   tttt_pevarmtl = yypbd_mtl_var
	   tttt_pevarlbr = yypbd_lbr_var
	   tttt_pevarmfg = yypbd_mfg_var.


    end. /* for each pt_mstr */

    h-tt = TEMP-TABLE tttt:HANDLE.
    RUN value(lc(global_user_lang) + "\yy\yytoexcel.p") (INPUT TABLE-HANDLE h-tt, INPUT inp_where, INPUT inp_sortby, INPUT v_list, INPUT inp_bwstitle).        
    empty temp-table tttt.
END.