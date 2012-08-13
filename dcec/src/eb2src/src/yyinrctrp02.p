/* xxinrctrp02.p  - Inventroy Activity Report - Materials Receiving Financial Report                              */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/* V5                 Developped: 05/29/01      BY: Rao Haobin          */
/* V6                 Developped: 10/15/01      BY: Rao Haobin              */
/* RHB 材料入库数量金额报表,使用事务处理当时的标准成本计算 */

{mfdtitle.i } 

define variable pr_detail like mfc_logical label "输出明细到文件'c:\detailrp.txt'" initial no.

/* 针对每一零件的统计变量定义 */
def var qty_rct_po as integer label "采购入库数量".
def var amt_rct_po as decimal format "->>>,>>>,>>9.99" label "采购入库金额" .
def var sum_rct_po as decimal format "->>>,>>>,>>9.99" initial 0 column-label "采购入库!金额合计". 
def var prod_rct_po as decimal format "->>>,>>>,>>9.99" initial 0 column-label "产品类采购!入库金额合计".
def var sum_iss_prv as decimal format "->>>,>>>,>>9.99" initial 0 column-label "采购退货!金额合计".
def var prod_iss_prv as decimal format "->>>,>>>,>>9.99" initial 0 column-label "产品类采购!退货金额合计".
def var sum_rct_unp as decimal format "->>>,>>>,>>9.99" initial 0 column-label "计划外入库!金额合计".
def var prod_rct_unp as decimal format "->>>,>>>,>>9.99" initial 0 column-label "产品类计划外!入库金额合计".
def var sum_rct_wo as decimal format "->>>,>>>,>>9.99" initial 0 column-label "完工入库!金额合计".
def var prod_rct_wo as decimal format "->>>,>>>,>>9.99" initial 0 column-label "产品类完工!入库金额合计".

/* qty_rct_unpxxx 根据销售定制代码定义统计计划外入库明细 */
def var qty_rct_unp as integer.
def var amt_rct_unp as decimal format "->>>,>>>,>>9.99".
def var qty_rct_unp101 as integer.
def var amt_rct_unp101 as decimal format "->>>,>>>,>>9.99".
def var qty_rct_unp102 as integer.
def var amt_rct_unp102 as decimal format "->>>,>>>,>>9.99".
def var qty_rct_unp103 as integer.
def var amt_rct_unp103 as decimal format "->>>,>>>,>>9.99".
def var qty_rct_unp104 as integer.
def var amt_rct_unp104 as decimal format "->>>,>>>,>>9.99".
def var qty_rct_unp105 as integer.
def var amt_rct_unp105 as decimal format "->>>,>>>,>>9.99".
def var qty_rct_unp106 as integer.
def var amt_rct_unp106 as decimal format "->>>,>>>,>>9.99".
def var qty_rct_unp107 as integer.
def var amt_rct_unp107 as decimal format "->>>,>>>,>>9.99".
def var qty_rct_unp199 as integer.
def var amt_rct_unp199 as decimal format "->>>,>>>,>>9.99".

def var qty_rct_wo as integer.
def var amt_rct_wo as decimal format "->>>,>>>,>>9.99".

def var qty_iss_prv as integer.
def var amt_iss_prv as decimal format "->>>,>>>,>>9.99".


def var qty_receive as integer.
def var amt_receive as decimal format "->>>,>>>,>>9.99".

def var lineno as integer.

define variable part like pt_part.
define variable part1 like pt_part.
define variable line like pt_prod_line.
define variable line1 like pt_prod_line.
define variable date like tr_effdate label "起止日期".
define variable date1 like tr_effdate.
define variable keeper like pt_article.
define variable keeper1 like pt_article.
define variable site like pt_site.
define variable site1 like pt_site.
define variable pldesc like pl_desc.

form         
skip(1)
     date           label "起始日期  "   at 48
     date1          label "终止日期  " at 48
     skip(1) 
     with no-box side-labels width 180 frame b.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

 FORM /*GUI*/ 
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
	     site           colon 18
	     site1          label {t001.i} colon 49
	     line           colon 18
	     line1          label {t001.i} colon 49
	     part           colon 18
	     part1          label {t001.i} colon 49 skip
             date            colon 18
             date1           label {t001.i} colon 49 skip
	     keeper            label "保管员" colon 18
	     keeper1           label {t001.i} colon 49 skip
	     pr_detail		colon 50
  skip
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.


 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 选择条件 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


/*judy 05/08/05*/ /* SET EXTERNAL LABELS */
/*judy 05/08/05*/  setFrameLabels(frame a:handle).

/*K0ZX*/ {wbrp01.i}

	  /* REPORT BLOCK */

	  
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

	     if part1 = hi_char then part1 = "".
             if line1 = hi_char then line1 = "".
	     if keeper1 = hi_char then keeper1 = "".
	     if site1 = hi_char then site1 = "".
	     if date = low_date then date = ?.
	     if date1 = hi_date then date1 = ?.

	     
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


	     bcdparm = "".

	     {mfquoter.i part   }
	     {mfquoter.i part1   }
	     {mfquoter.i date   }
	     {mfquoter.i date1   }
	     {mfquoter.i keeper   }
	     {mfquoter.i keeper1   }
	     {mfquoter.i site   }
	     {mfquoter.i site1   }
	     {mfquoter.i line   }
	     {mfquoter.i line1   }
	     {mfquoter.i pr_detail   }
	     	     
	     if  part1 = "" then part1 = hi_char.
	     if  line1 = "" then line1 = hi_char.
	     if  keeper1 = "" then keeper1 = hi_char.
	     if  site1 = "" then site1 = hi_char.
	     if  date = ? then date = low_date.
	     if  date1 = ? then date1 = hi_date.
	     /* SELECT PRINTER */
	     
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "printer" 132}
{mfphead.i}
lineno=0.
if pr_detail = yes then do:
output to "c:\detailrp.txt".
put "零件号" at 1
	"零件名称" at 19
	"本期采购" at 50
	"金额" at 60
	"本期采购退货" at 69
	"金额" at 84
	"本期完工入库" at 93
	"金额" at 108
	"盘点调整" at 120
	"金额" at 135
	"材料借用" at 145
	"金额" at 160
	"样品赠送" at 170
	"金额" at 185
	"非计划采购" at 195
	"金额" at 210
	"拆装入库" at 220
	"金额" at 235
	"零件替换" at 245
	"金额" at 260
	"手工帐转入" at 270
	"金额" at 290
	"其它计划外入库" at 295
	"金额" at 315
	skip.
output close.
end.

for each pt_mstr no-lock where pt_prod_line >= line and pt_prod_line <= line1 and pt_part <= part1 and pt_part >= part and pt_article >= keeper and pt_article <= keeper1
	 and pt_site >= site and pt_site <= site1
	 ,each in_mstr no-lock where in_part = pt_part and in_site >=site and in_site <=site1
	  break by pt_prod_line by pt_part:
    if first-of (pt_prod_line) then do:
         lineno = lineno + 1.
       if lineno<>1 then page.
              find pl_mstr where pl_prod_line = pt_prod_line no-lock no-error.
       pldesc = pl_desc.
if pr_detail = no then do:
       display date date1 with frame b STREAM-IO.
       display pt_prod_line pldesc no-label with width 132 frame c side-labels STREAM-IO.
    end.
    else do:
    output to "c:\detailrp.txt" append.
    display date date1 with frame b STREAM-IO.
    display pt_prod_line pldesc no-label with width 132 frame c side-labels STREAM-IO.
    output close.
    end.
    end.


form header
skip(1)
pt_prod_line pldesc "  (续)" 
with stream-io frame a1 page-top side-labels width 132.
view frame a1.

/* 对汇总数量统计变量清零 */
qty_receive=0.

qty_rct_po=0.

qty_rct_unp=0.
qty_rct_unp101=0.
qty_rct_unp102=0.
qty_rct_unp103=0.
qty_rct_unp104=0.
qty_rct_unp105=0.
qty_rct_unp106=0.
qty_rct_unp107=0.
qty_rct_unp199=0.

qty_iss_prv=0.
qty_rct_wo=0.

/* 对汇总金额变量清零 */
amt_receive=0.

amt_rct_po=0.

amt_rct_unp=0.
amt_rct_unp101=0.
amt_rct_unp102=0.
amt_rct_unp103=0.
amt_rct_unp104=0.
amt_rct_unp105=0.
amt_rct_unp106=0.
amt_rct_unp107=0.
amt_rct_unp199=0.

amt_iss_prv=0.
amt_rct_wo=0.

/* 统计入库情况 */
for each tr_hist no-lock where tr_part=pt_part and tr_type="RCT-PO" and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	qty_rct_po = qty_rct_po + tr_qty_loc.
	amt_rct_po = amt_rct_po + round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
end.

prod_rct_po = prod_rct_po + amt_rct_po.
sum_rct_po = sum_rct_po + amt_rct_po.

/*统计第一阶段采购退货 */
for each tr_hist no-lock where tr_part=pt_part and tr_type="ISS-PRV" and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	qty_iss_prv = qty_iss_prv + tr_qty_loc.
	amt_iss_prv = amt_iss_prv + round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
end.
prod_iss_prv = prod_iss_prv + amt_iss_prv.
sum_iss_prv = sum_iss_prv + amt_iss_prv.


/* 统计第一阶段计划外入库 */
for each tr_hist where tr_part=pt_part and tr_type ="RCT-UNP" and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	if	tr_so_job = "101" then do:
		qty_rct_unp101 = qty_rct_unp101 + tr_qty_loc.
		amt_rct_unp101 = amt_rct_unp101 + round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "102" then do:
		qty_rct_unp102 = qty_rct_unp102 + tr_qty_loc.
		amt_rct_unp102 = amt_rct_unp102 + round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "103" then do:
		qty_rct_unp103 = qty_rct_unp103 + tr_qty_loc.
		amt_rct_unp103 = amt_rct_unp103 + round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "104" then do:
		qty_rct_unp104 = qty_rct_unp104 + tr_qty_loc.
		amt_rct_unp104 = amt_rct_unp104 + round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "105" then do:
		qty_rct_unp105 = qty_rct_unp105 + tr_qty_loc.
		amt_rct_unp105 = amt_rct_unp105 + round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "106" then do:
		qty_rct_unp106 = qty_rct_unp106 + tr_qty_loc.
		amt_rct_unp106 = amt_rct_unp106 + round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "107" then do:
		qty_rct_unp106 = qty_rct_unp106 + tr_qty_loc.
		amt_rct_unp107 = amt_rct_unp107 + round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else do:
		qty_rct_unp199 = qty_rct_unp199 + tr_qty_loc.
		amt_rct_unp199 = amt_rct_unp199 + round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
end.
qty_rct_unp = qty_rct_unp101 + qty_rct_unp102 + qty_rct_unp103 + qty_rct_unp104 + qty_rct_unp105 + qty_rct_unp106 + qty_rct_unp107 + qty_rct_unp199.
amt_rct_unp = amt_rct_unp101 + amt_rct_unp102 + amt_rct_unp103 + amt_rct_unp104 + amt_rct_unp105 + amt_rct_unp106 + amt_rct_unp107 + amt_rct_unp199.
prod_rct_unp = prod_rct_unp + amt_rct_unp.
sum_rct_unp = sum_rct_unp + amt_rct_unp.

/* 统计第一阶段完工入库 */
for each tr_hist where tr_part=pt_part and tr_type ="RCT-WO" and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	qty_rct_wo = qty_rct_wo + tr_qty_loc.
	amt_rct_wo = amt_rct_wo + round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
end.
prod_rct_wo = prod_rct_wo + amt_rct_wo.
sum_rct_wo = sum_rct_wo + amt_rct_wo.


/* 汇总第一阶段入库数据 */
qty_receive = qty_rct_po + qty_rct_unp + qty_rct_wo + qty_iss_prv.
amt_receive = amt_rct_po + amt_rct_unp + amt_rct_wo + amt_iss_prv.


if page-size - line-counter < 3 then page.

/* 显示输出 */
 if not (qty_rct_po =0 and qty_iss_prv = 0 and qty_rct_unp = 0 and qty_rct_wo = 0 ) then do:
 if pr_detail = yes then do:
	output to "c:\detailrp.txt" append.
 	put pt_part
 	pt_desc2
 	qty_rct_po
 	amt_rct_po
 	qty_iss_prv
 	amt_iss_prv
 	qty_rct_wo
 	amt_rct_wo
 	qty_rct_unp101
 	amt_rct_unp101
 	qty_rct_unp102
 	amt_rct_unp102
 	qty_rct_unp103
 	amt_rct_unp103
 	qty_rct_unp104
 	amt_rct_unp104
 	qty_rct_unp105
 	amt_rct_unp105
 	qty_rct_unp106
 	amt_rct_unp106
 	qty_rct_unp107
 	amt_rct_unp107
 	qty_rct_unp199
 	amt_rct_unp199 skip.
 	output close.
 	end.
/* disp pt_part pt_desc2 pt_um 
 qty_rct_po column-label "本期采购" amt_rct_po column-label "金额" 
 qty_iss_prv column-label "本期采购退货" amt_iss_prv column-label "金额"
 qty_rct_wo column-label "本期完工入库" amt_rct_wo column-label "金额"
 qty_rct_unp101 column-label "盘点调整" amt_rct_unp101 column-label "金额"
 qty_rct_unp102 column-label "材料借用" amt_rct_unp102 column-label "金额"
 qty_rct_unp103 column-label "样品赠送" amt_rct_unp103 column-label "金额"
 qty_rct_unp104 column-label "非计划采购" amt_rct_unp104 column-label "金额"
 qty_rct_unp105 column-label "拆装入库" amt_rct_unp105 column-label "金额"
 qty_rct_unp106 column-label "零件替换" amt_rct_unp106 column-label "金额"
 qty_rct_unp107 column-label "手工帐转入" amt_rct_unp107 column-label "金额"
 qty_rct_unp199 column-label "其它计划外入库" amt_rct_unp column-label "金额"
 qty_receive column-label "本期入库合计" amt_receive column-label "入库金额"
 with width 180  STREAM-IO.
*/ else
 disp pt_part pt_desc2 pt_um 
 qty_rct_po column-label "本期采购" amt_rct_po column-label "金额" 
 qty_iss_prv column-label "本期采购退货" amt_iss_prv column-label "金额"
 qty_rct_wo column-label "本期完工入库" amt_rct_wo column-label "金额"
 qty_rct_unp column-label "计划外入库合计" amt_rct_unp column-label "金额"
 qty_receive column-label "本期入库合计" amt_receive column-label "入库金额"
 with WIDTH 320  STREAM-IO.
 end.
if last-of(pt_prod_line) then do:
       display prod_rct_po prod_iss_prv prod_rct_unp prod_rct_wo with width 320 frame z STREAM-IO.
       prod_rct_po=0.
       prod_iss_prv=0.
       prod_rct_unp = 0.
       prod_rct_wo =0.
	end.
end.

disp sum_rct_po column-label "采购入库合计" sum_iss_prv column-label "采购退货合计" sum_rct_unp column-label "计划外入库合计" 
    sum_rct_wo column-label "完工入库合计" with frame Y STREAM-IO WIDTH 320.
sum_rct_po =0.
sum_iss_prv = 0.
sum_rct_unp = 0.
sum_rct_wo = 0.

{mfguitrl.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
 
end procedure.

/*K0ZX*/ {wbrp04.i &frame-spec = a} 

/*GUI*/ {mfguirpb.i &flds=" site site1 line line1 part part1 date date1 keeper keeper1  pr_detail "} /*Drive the Report*/



