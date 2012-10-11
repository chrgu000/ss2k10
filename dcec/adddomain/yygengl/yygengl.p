/* yygengl.p - 差异结转                             */
/* Author: James Duan   *DATE:2009-11-21*           */
/* Modify: Henri Zhu    *DATE:2012-08-15*           */

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "20120815"}
{yyglcim.i "new" }

DEFINE VARIABLE iyear		AS INT format "9999".
DEFINE VARIABLE iper		AS INT format "99".

DEFINE VARIABLE v_wo		AS logical format "Update/View"  INITIAL false.
DEFINE VARIABLE v_wo2		AS logical format "Update/View"  INITIAL false.
DEFINE VARIABLE v_lbrmfg	AS logical format "Update/View"  INITIAL false.
DEFINE VARIABLE v_so		AS logical format "Update/View"  INITIAL false.
DEFINE VARIABLE v_other		AS logical format "Update/View"  INITIAL false.
DEFINE VARIABLE v_detail	AS logical format "Yse/No"  INITIAL yes.

def var cerror as char no-undo.
def var v_id     as int.
iyear = year(today).
iper = month(today).

define temp-table tt no-undo
   fields tt_part	like pt_part
   fields tt_prod_line	like pt_prod_line
   fields tt_sojob	like tr_so_job
   fields tt_type	like yyinvo_out_type
   fields tt_qty	like yyinvo_qty
   fields tt_rate_mtl	like yyvarated_mtl_rate
   fields tt_rate_lbr	like yyvarated_lbr_rate
   fields tt_rate_mfg	like yyvarated_mfg_rate
   fields tt_amt	as  decimal format "->>>,>>>,>>9.99"
   fields tt_cr_acct	as char format "x(20)"
   fields tt_dr_acct	as char format "x(20)"
   fields tt_status	as char
index part is primary tt_dr_acct tt_cr_acct.

define temp-table tt2 no-undo
   fields tt2_part	like pt_part
   fields tt2_prod_line	like pt_prod_line
   fields tt2_cc	as char
   fields tt2_amt	as  decimal format "->>>,>>>,>>9.99"
   fields tt2_dr_acct	as char format "x(20)"
   fields tt2_cr_acct1	as char format "x(20)"
   fields tt2_cr_amt1	as  decimal format "->>>,>>>,>>9.99"
   fields tt2_cr_acct2	as char format "x(20)"
   fields tt2_cr_amt2	as  decimal format "->>>,>>>,>>9.99"
index part is primary tt2_dr_acct tt2_cr_acct1 tt2_cr_acct2.

form
   "        "
   tt_part	column-label "零件"
   tt_prod_line	column-label "产品类"
   tt_sojob	column-label "装机产品"
   tt_type	column-label "出库类型"
   tt_qty	column-label "出库数量" format "->>>,>>>,>>>,>>9"
   " "
   tt_rate_mtl	column-label "材料分摊率" format "->>>,>>>,>>>,>>9.99"
   " "
   tt_rate_lbr	column-label "人工分摊率" format "->>>,>>>,>>>,>>9.99"
   " "
   tt_rate_mfg	column-label "费用分摊率" format "->>>,>>>,>>>,>>9.99"
   " "
   tt_amt	column-label "结转金额"  format "->>>,>>>,>>>,>>9.99"
   " "
   tt_cr_acct	column-label "借方"
   tt_dr_acct	column-label "贷方"
   tt_status	column-label "状态"
with frame d width 320 down.

form
   "         "
   tt2_part	column-label "零件"
   tt2_prod_line	column-label "产品类"
   tt2_cc	column-label "成本中心"
   tt2_dr_acct	column-label "贷方"
   tt2_amt	column-label "贷方金额" format "->>>,>>>,>>>,>>9.99"
   " "
   tt2_cr_acct1	column-label "借方"
   tt2_cr_amt1	column-label "借方金额" format "->>>,>>>,>>>,>>9.99"
   " "
   tt2_cr_acct2	column-label "借方"
   tt2_cr_amt2	column-label "借方金额" format "->>>,>>>,>>>,>>9.99"
with frame e width 320 down.

form
  ttglt_dr_acct column-label "贷方"
  " "
  ttglt_ctrl_amt column-label "金额" format "->>>,>>>,>>>,>>9.99"
  "      "
  ttglt_cr_acct column-label "借方"
  " "
  ttglt_ctrl_amt1 column-label "金额" format "->>>,>>>,>>>,>>9.99"
  "      "
  ttglt_cr_acct2 column-label "借方"
  " "
  ttglt_ctrl_amt2 column-label "金额" format "->>>,>>>,>>>,>>9.99"
with frame f width 320 down.

function gen_lbrmfg returns logical (input param1 as logical,input param2 as logical,input param3 as date) FORWARD.

function gen_gl_fun returns logical (input param1 as char,input param2 as logical,input param3 as date) FORWARD.

function get_acct returns char (input param1 as char, input param2 as char,input param3 as char,input param4 as char) FORWARD.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    iyear	COLON 20 LABEL "年份"
    iper	COLON 45 LABEL "期间"
    SKIP
    v_wo	COLON 20 LABEL "装机结转"
    SKIP
    v_lbrmfg	COLON 20 LABEL "工费结转"
    SKIP
    v_wo2	COLON 20 LABEL "改制结转"
    SKIP
    v_so	COLON 20 LABEL "销售结转"
    SKIP
    v_other	COLON 20 LABEL "其他结转"
    SKIP
    v_detail	COLON 20 LABEL "显示明细"
    SKIP
    "**创建结转凭证时，输出只能为文件！！！" at 10
    SKIP(.4)  /*GUI*/
    WITH FRAME a SIDE-LABELS WIDTH 80 NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = "结转".
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

    UPDATE 
        iyear iper 
	v_wo
	v_lbrmfg
	v_wo2
	v_so
	v_other
	v_detail
    WITH FRAME a.
    

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

    /* 确定计算材料差异期间 */
    find first glc_cal where glc_domain = global_domain and glc_year = iyear and glc_per = iper no-lock no-error.
    if not avail glc_cal then do:
	find first glc_cal where glc_domain = global_domain and today >= glc_start and today <= glc_end no-lock no-error.
	if not avail glc_cal then do:
		message "财务期间未定义!" view-as alert-box.
	end.
    end.

    /* 创建要结转的记录 */
        gen_gl_fun("装机",v_wo,glc_end).
	gen_lbrmfg(v_lbrmfg,true,glc_end).
	gen_lbrmfg(v_lbrmfg,false,glc_end). 
	gen_gl_fun("改制",v_wo2,glc_end).
	gen_gl_fun("销售",v_so,glc_end).
	gen_gl_fun("计划外",v_other,glc_end). 



    {mfreset.i}
    {mfgrptrm.i} /*Report-to-Window*/
END.
{wbrp04.i &frame-spec = a}

/****************************************************************
gen_lbrmfg()                                      人工、费用结转
****************************************************************/
function gen_lbrmfg returns logical (input param1 as logical,input param2 as logical,input param3 as date):
	def var v_desc as char.
	def var v_flag as logical.
	if param2 then v_desc=  "人工费用自动结转". 
	else v_desc= "制造费用自动结转".
	v_id = 0.
	empty temp-table tt2.
	empty temp-table ttglt_mstr.
	empty temp-table ttgltd_det.
	for each yylbrmfg_det no-lock where yylbrmfg_domain = global_domain and yylbrmfg_year = iyear
		and yylbrmfg_per = iper:
		/* and yylbrmfg_lbr_tl <> 0 */
		/* 取分摊金额 */
		create tt2.
		assign 
		   tt2_part = yylbrmfg_part
		   tt2_prod_line = yylbrmfg_prod_line
		   tt2_cc = yylbrmfg_cc
		   tt2_amt = (if param2 then (yylbrmfg_lbr_tl + yylbrmfg_lbr_std) else yylbrmfg_mfg_tl + yylbrmfg_mfg_std )
		   tt2_dr_acct = get_acct("lbrmfg_account",yylbrmfg_prod_line,yylbrmfg_cc,"").
		tt2_cr_acct1 = get_acct("lbrmfg_account",yylbrmfg_prod_line,yylbrmfg_prod_line,"").
		tt2_cr_amt1 = (if param2 then yylbrmfg_lbr_std else yylbrmfg_mfg_std).
		tt2_cr_acct2 = get_acct("wo_account",yylbrmfg_prod_line,yylbrmfg_prod_line,"").
		tt2_cr_amt2 = (if param2 then yylbrmfg_lbr_tl else yylbrmfg_mfg_tl).
		/* 合并 */
		if tt2_dr_acct <> "Account Error." and tt2_cr_acct1 <> "Account Error." 
		and tt2_cr_acct2 <> "Account Error." then do:
			find first ttglt_mstr where ttglt_dr_acct = tt2_dr_acct
				and ttglt_cr_acct = tt2_cr_acct1
				and ttglt_cr_acct2 = tt2_cr_acct2 no-error.
			if not avail ttglt_mstr then do:
				v_id = v_id + 1.
				create ttglt_mstr.
				assign	
				   ttglt_id = v_id
				   ttglt_cr_acct = tt2_cr_acct1
				   ttglt_cr_acct2 = tt2_cr_acct2
				   ttglt_dr_acct = tt2_dr_acct
				   ttglt_eff_date = param3.			
			end. /* if avail ttglt_mstr */
			assign ttglt_ctrl_amt = ttglt_ctrl_amt + tt2_amt
			       ttglt_ctrl_amt1 = ttglt_ctrl_amt1 + tt2_cr_amt1
			       ttglt_ctrl_amt2 = ttglt_ctrl_amt2 + tt2_cr_amt2.
			run create_gldet(input ttglt_id,input ttglt_dr_acct,input v_desc,input - tt2_amt).
			run create_gldet(input ttglt_id,input ttglt_cr_acct,input v_desc,input tt2_cr_amt1).
			run create_gldet(input ttglt_id,input ttglt_cr_acct2,input v_desc,input tt2_cr_amt2).
		end.
	end. /* for each yylbrmfg_det */

	
	if param1 then do:
	    /* CIM ,导入数据 */
	    cerror = "".
	    {gprun.i ""yyglcim.p"" "(output cerror)"}
	end. /* if not v_update */


	/* 显示结转记录 */
	put skip(1).
	put v_desc format "x(100)" skip.
	put "-----------------------------------------------" skip.
	for each ttglt_mstr no-lock:
	        disp 
		  ttglt_dr_acct
		  ttglt_ctrl_amt
		  ttglt_cr_acct
		  ttglt_ctrl_amt1
		  ttglt_cr_acct2 
		  ttglt_ctrl_amt2 
		with frame f stream-io.
		

		if v_detail then do:
			for each tt2 no-lock where tt2_dr_acct = ttglt_dr_acct
				and tt2_cr_acct1 = ttglt_cr_acct
				and tt2_cr_acct2 = ttglt_cr_acct2:
				disp 
				  tt2
				with frame e stream-io.
				down with frame e.
			end. /* for each tt */
		end. /* if v_detail */
		else down with frame f.
		
	end. /* for each ttglt_mstr */
	v_flag = true.
	
	for each tt2 where tt2_dr_acct = "Account Error." or tt2_cr_acct1 = "Account Error." 
		or tt2_cr_acct2 = "Account Error.":
		if v_flag then do:
			put "错误信息" skip.
			if cerror <> "" then put cerror format "x(100)" skip.
			v_flag = false.
		end.

		disp 
		tt2
		with frame e stream-io.
		down with frame e.
	end. /* for each tt */
	empty temp-table tt2.
	empty temp-table ttglt_mstr.
	empty temp-table ttgltd_det.
	return true.
end function.
/****************************************************************
gen_gl_fun()                    领料、装机、销售、其他计划外结转
****************************************************************/
function gen_gl_fun returns logical (input param1 as char,input param2 as logical,input param3 as date):
    def var v_flag as logical.
    v_id = 0.
	empty temp-table tt2.
	empty temp-table ttglt_mstr.
	empty temp-table ttgltd_det.
    for each yyinvo_mstr no-lock where yyinvo_domain = global_domain and yyinvo_year = iyear
	and yyinvo_per = iper 
	and yyinvo_out_type begins param1 :
	
	find first yyvarated_det where yyvarated_domain = global_domain and yyvarated_year = iyear
		and yyvarated_per = iper
		and yyvarated_part = yyinvo_part no-lock no-error.
	if not avail yyvarated_det then do:
		if can-find(yycsvar_mstr where yycsvar_domain = global_domain and yycsvar_year = iyear and yycsvar_per = iper 
		   and yycsvar_part = yyinvo_part) then do:
			create tt.
			assign 
			   tt_part = yyinvo_part
			   tt_prod_line = yyinvo_part_pl
			   tt_type = yyinvo_out_type
			   tt_sojob = yyinvo_reason
			   tt_status = "分摊率未计算".
		end. /* if can-find(yycsvar_mstr */
		else next. /* 无差异 */
	end.
	else do:
		/* 取分摊金额 */
		create tt.
		assign 
		   tt_part = yyinvo_part
		   tt_prod_line = yyinvo_part_pl
		   tt_type = yyinvo_out_type
		   tt_sojob = yyinvo_reason
		   tt_qty = yyinvo_qty
		   tt_rate_mtl = yyvarated_mtl_rate
		   tt_rate_lbr = yyvarated_lbr_rate
		   tt_rate_mfg = yyvarated_mfg_rate
		   tt_amt = yyinvo_qty * (yyvarated_mtl_rate + yyvarated_lbr_rate + yyvarated_mfg_rate).
	end.
	tt_dr_acct = get_acct("wo_account",yyinvo_part_pl,yyinvo_part_pl,""). 

	if param1 = "装机" or param1 = "改制" then do:
		find first pt_mstr where pt_domain = global_domain and pt_part = yyinvo_reason no-lock no-error.
		if not avail pt_mstr then do:
			assign tt_status = "装机产品不存在".
			next.
		end.
		tt_cr_acct = get_acct("wo_account",pt_prod_line,pt_prod_line,"").
	end.
	else if param1 = "销售" then  
		tt_cr_acct = get_acct("so_account",yyinvo_part_pl,yyinvo_reason,"").
	else if param1 = "计划外" then
		tt_cr_acct = get_acct("unp_account",yyinvo_sojob,yyinvo_reason,yyinvo_part_pl).

	if tt_cr_acct <> "Account Error." and tt_dr_acct <> "Account Error." 
		and tt_status = "" then do:
		find first ttglt_mstr where ttglt_dr_acct = tt_dr_acct
			and ttglt_cr_acct = tt_cr_acct no-error.
		if not avail ttglt_mstr then do:
			v_id = v_id + 1.
			create ttglt_mstr.
			assign	
			   ttglt_id = v_id
			   ttglt_dr_acct = tt_dr_acct
			   ttglt_cr_acct = tt_cr_acct
			   ttglt_eff_date = param3.
			   
		end. /* if not avail ttglt_mstr */
		assign ttglt_ctrl_amt = ttglt_ctrl_amt + tt_amt.
		run create_gldet(input ttglt_id,input tt_dr_acct,input ("自动结转" + param1),input - tt_amt).
		run create_gldet(input ttglt_id,input tt_cr_acct,input ("自动结转" + param1),input tt_amt).
		
	end. /* tt_cr_acct <> "Account Error." ... */
    end. /* for each yyinvo_mstr */

   if param2 then do:
    /* CIM ,导入数据 */
    cerror = "".
    {gprun.i ""yyglcim.p"" "(output cerror)"}
   end. /* if not v_update */
    
    /* 显示结转记录 */
    put param1 skip.
    put "-----------------------------------------------" skip.
    for each ttglt_mstr no-lock:
	put "贷方            借方                金额" skip.
	put ttglt_dr_acct "      " ttglt_cr_acct	ttglt_ctrl_amt format "->>>,>>>,>>>,>>9.99"  skip(2).
	if v_detail then do:
		for each tt no-lock where tt_dr_acct = ttglt_dr_acct
			and tt_cr_acct = ttglt_cr_acct:
			disp 
			  tt
			with frame d stream-io.
			down with frame d.
		end. /* for each tt */
	end. /* if v_detail */
    end. /* for each ttglt_mstr */
    v_flag = true.
    for each tt where tt_cr_acct = "Account Error." or tt_dr_acct = "Account Error." 
	or tt_status <> "":
		if v_flag then do:
			put "错误信息" skip.
			if cerror <> "" then put cerror format "x(100)" skip.
			v_flag = false.
		end.		
		disp 
		tt
		with frame d stream-io.
		down with frame d.
    end. /* for each tt */

    empty temp-table tt.
    empty temp-table ttglt_mstr.
    empty temp-table ttgltd_det.
    return true.
end function.

function get_acct returns char (input param1 as char, input param2 as char,input param3 as char,input param4 as char):
	define variable vflag as logical.
	if param1 = "wo_account" or param1 = "lbrmfg_account" then do:
		find first code_mstr where code_domain = global_domain and code_fldname	= param1 and param2 = code_value no-lock no-error.
		if not avail code_mstr then do:
			find first code_mstr where code_domain = global_domain and code_fldname	= param1 and param2 begins code_value no-lock no-error.
		end.
		if avail code_mstr then do:
			if num-entries(code_cmmt,"-") > 2 then 
				return (entry(1,code_cmmt,"-") + "-" + entry(2,code_cmmt,"-") + "-" + param3).
			else
				return code_cmmt.
		end.
		else return "Account Error.".
	end.
	else if param1 = "so_account" then do:
		vflag = false.
		for each code_mstr no-lock where code_domain = global_domain and code_fldname = "so_export" :
			if param3 = code_value then do:
				vflag = true.
				next.
			end.
		end. /* for each code_mstr */
		if vflag then do:
			find first code_mstr where code_domain = global_domain and code_fldname	= param1 and param2 = code_value no-lock no-error.
			if not avail code_mstr then do:
				find first code_mstr where code_domain = global_domain and code_fldname	= param1 and param2 begins code_value no-lock no-error.
			end.
		end.
		else do:
			find first code_mstr where code_domain = global_domain and code_fldname	= param1 and ("D" + param2) = code_value no-lock no-error.
			if not avail code_mstr then do:
				find first code_mstr where code_domain = global_domain and code_fldname	= param1 and ("D" + param2) begins code_value no-lock no-error.
			end.

		end.
		if avail code_mstr then do:
			if num-entries(code_cmmt,"-") > 2 then 
				return (entry(1,code_cmmt,"-") + "-" + entry(2,code_cmmt,"-") + "-" + param2).
			else
				return code_cmmt.
		end.
		else return "Account Error.".
	end.
	else if param1 = "unp_account" then do:
		/* 6B or 7B */
		find first code_mstr where code_domain = global_domain and code_fldname	= "so_job1" and code_value = param2 no-lock no-error.
		if avail code_mstr then do:
			if num-entries(code_cmmt,"-") > 2 then 
				return 	(entry(1,code_cmmt,"-") + "-" + entry(2,code_cmmt,"-") + entry(3,code_cmmt,"-") + "-" + param3).
			else if num-entries(code_cmmt,"-") > 1 then
				return 	(entry(1,code_cmmt,"-") + "-" + entry(2,code_cmmt,"-") + "--" + param3).
			else return (entry(1,code_cmmt,"-") + "---" + param3).
		end.
		else do:
			find first code_mstr where code_domain = global_domain and code_fldname	= "so_job1" and code_value = "other" no-lock no-error.
			if avail code_mstr then return code_cmmt.
			else return "Account Error.".
		end.
	end.

end function.

procedure create_gldet:
	define input parameter p_id as int.
	define input parameter p_acct as char.
	define input parameter p_desc as char.
	define input parameter p_amt  as deci.
	
	find first ttgltd_det where ttgltd_id = p_id
	       and ttgltd_acct = entry(1,p_acct,"-")
	       and ttgltd_sub =(if num-entries(p_acct,"-") > 1 then entry(2,p_acct,"-") else "")
	       and ttgltd_cc = (if num-entries(p_acct,"-") > 2 then entry(3,p_acct,"-") else "")
	       and ttgltd_project = (if num-entries(p_acct,"-") > 3 then entry(4,p_acct,"-") else "") no-error.
	if not avail ttgltd_det then do:
		create ttgltd_det.
		assign 
		   ttgltd_id = p_id
		   ttgltd_acct = entry(1,p_acct,"-")
		   ttgltd_sub =(if num-entries(p_acct,"-") > 1 then entry(2,p_acct,"-") else "")
		   ttgltd_cc = (if num-entries(p_acct,"-") > 2 then entry(3,p_acct,"-") else "")
		   ttgltd_project = (if num-entries(p_acct,"-") > 3 then entry(4,p_acct,"-") else "")
		   ttgltd_desc = p_desc.
	end. /* if not avail ttgltd_det */
	assign ttgltd_amt = ttgltd_amt + p_amt.
	release ttgltd_det.
end procedure.