/* xxinrctrp02.p  - Inventroy Activity Report - Materials Receiving Financial Report                              */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/*                  Developped: 10/21/01      BY: kang jian          */
/*  材料出库数量金额报表,使用事务处理当时的标准成本计算 */
/*  根据xxinrctrp02.p 修改 */
/* V5 caculate the amount of  standart cost adjust 08/08/02 By:kangjian  var:amt_cst */
/* V6 caculate the amount for iss-tr  03/09/02 By:kangjian  var:qty_iss_tr,amt_iss_tr,prod_iss_tr,sum_iss_tr */
/* V7 caculate the amount for iss-tr  03/09/02 By:kangjian  var: 213管理不善报废 214索赔范围的报废 */
/* V7 caculate the amount for iss-tr  26/04/03 By:Zhang weihua  var: 增加其他废品报废*/
{mfdtitle.i "120816.1"} 

define variable pr_detail like mfc_logical label "输出明细到文件'c:\detailrp.txt'" initial no.

/* 针对每一零件的统计变量定义 */
def var qty_iss_so as integer label "销售出库数量".
def var amt_iss_so as decimal format "->>>,>>>,>>9.99" label "销售出库金额".
def var sum_iss_so as decimal format "->>>,>>>,>>9.99" initial 0 label "销售出库金额合计".
def var prod_iss_so as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类销售出库金额合计".
def var sum_iss_unp as decimal format "->>>,>>>,>>9.99" initial 0 label "计划外出库金额合计".
def var prod_iss_unp as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类计划外出库金额合计".

def var sum_iss_tr as decimal format "->>>,>>>,>>9.99" initial 0 label "生产发料金额".
def var prod_iss_tr as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类生产发料合计".

def var sum_iss_wo as decimal format "->>>,>>>,>>9.99" initial 0 label "生产消耗总额".
def var sum_iss_wt as decimal format "->>>,>>>,>>9.99" initial 0 label "委托件金额".
def var sum_iss_pl as decimal format "->>>,>>>,>>9.99" initial 0 label "非委托件金额".
def var prod_iss_wo as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类生产消耗合计".
def var prod_iss_wt as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类委托件金额".
def var prod_iss_pl as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类非委托件金额".
def var prod_issue as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类出库金额合计".
def var prod_iss as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类出库金额合计".
def var prod_iss_201 as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类201金额合计".
def var prod_iss_203 as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类203金额合计".
def var prod_iss_204 as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类204金额合计".
def var prod_iss_205 as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类205金额合计".
def var prod_iss_206 as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类206金额合计".
def var prod_iss_207 as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类207金额合计".
def var prod_iss_208 as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类208金额合计".
def var prod_iss_209 as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类209金额合计".
def var prod_iss_210 as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类210金额合计".
def var prod_iss_211 as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类211金额合计".
def var prod_iss_212 as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类212金额合计".
def var prod_iss_213 as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类213金额合计".
def var prod_iss_214 as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类214金额合计".
def var prod_iss_215 as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类215金额合计".   /*zwh*/
def var prod_iss_299 as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类299金额合计".
def var prod_iss_fas as decimal format "->>>,>>>,>>9.99" initial 0 label "套件销售金额合计".
def var sum_iss_fas as decimal format "->>>,>>>,>>9.99" initial 0 label "套件销售金额合计".
/* qty_iss_unpxxx 根据销售定制代码定义统计计划外入库明细 */
def var qty_iss_unp as integer label "计划外出库合计".
def var amt_iss_unp as decimal format "->>>,>>>,>>9.99" label "金额".
def var qty_iss_unp201 as integer label "盘点调整".
def var amt_iss_unp201 as decimal format "->>>,>>>,>>9.99" label "金额".
def var qty_iss_unp203 as integer label "样品赠送".
def var amt_iss_unp203 as decimal format "->>>,>>>,>>9.99" label "金额".
def var qty_iss_unp204 as integer label "索赔零件报废".
def var amt_iss_unp204 as decimal format "->>>,>>>,>>9.99" label "金额".
def var qty_iss_unp205 as integer label "试验用机发料".
def var amt_iss_unp205 as decimal format "->>>,>>>,>>9.99" label "金额".
def var qty_iss_unp206 as integer label "试验用零件".
def var amt_iss_unp206 as decimal format "->>>,>>>,>>9.99" label "金额".
def var qty_iss_unp207 as integer label "质量三包".
def var amt_iss_unp207 as decimal format "->>>,>>>,>>9.99" label "金额".
def var qty_iss_unp208 as integer label "赠送".
def var amt_iss_unp208 as decimal format "->>>,>>>,>>9.99" label "金额".
def var qty_iss_unp209 as integer label "设备调试".
def var amt_iss_unp209 as decimal format "->>>,>>>,>>9.99" label "金额".
def var qty_iss_unp210 as integer label "制造领用".
def var amt_iss_unp210 as decimal format "->>>,>>>,>>9.99" label "金额".
def var qty_iss_unp211 as integer label "补发销售".
def var amt_iss_unp211 as decimal format "->>>,>>>,>>9.99" label "金额".
def var qty_iss_unp212 as integer label "换零件".
def var amt_iss_unp212 as decimal format "->>>,>>>,>>9.99" label "金额".
def var qty_iss_unp213 as integer label "生产报废-ATPU".
def var amt_iss_unp213 as decimal format "->>>,>>>,>>9.99" label "金额".
def var qty_iss_unp214 as integer label "生产报废-缸体".
def var amt_iss_unp214 as decimal format "->>>,>>>,>>9.99" label "金额".
def var qty_iss_unp215 as integer label "其他废品损失". /*zwh*/
def var amt_iss_unp215 as decimal format "->>>,>>>,>>9.99" label "金额". /*zwh*/
def var qty_iss_unp299 as integer label "其它".
def var amt_iss_unp299 as decimal format "->>>,>>>,>>9.99" label "金额".

def var qty_iss_tr as integer label "生产发料合计".
def var amt_iss_tr as decimal format "->>>,>>>,>>9.99" label "金额".


def var qty_iss_wo as integer label "生产消耗合计".
def var amt_iss_wo as decimal format "->>>,>>>,>>9.99" label "金额".
def var qty_iss_wt as integer label "委托领用".
def var amt_iss_wt as decimal format "->>>,>>>,>>9.99" label "金额".
def var qty_iss_pl as integer label "生产消耗".
def var amt_iss_pl as decimal format "->>>,>>>,>>9.99" label "金额".

def var qty_iss_fas as integer label "套件销售".
def var amt_iss_fas as decimal format "->>>,>>>,>>9.99" label "金额".

def var amt_cst as decimal format "->>>,>>>,>>9.99" label "成本调整金额".
def var prod_cst as decimal format "->>>,>>>,>>>,>>9.99" initial 0 label "成本调整金额".
def var sum_cst as decimal format "->>>,>>>,>>>,>>9.99" initial 0 label "成本调整金额".

def var qty_issue as integer.
def var amt_issue as decimal format "->>>,>>>,>>9.99".

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

sum_iss_unp = 0.
sum_iss_so = 0.
for each pt_mstr no-lock where pt_domain = global_domain 
		 and pt_prod_line >= line and pt_prod_line <= line1 
		 and pt_part <= part1 and pt_part >= part 
		 and pt_article >= keeper and pt_article <= keeper1
	 and pt_site >= site and pt_site <= site1
	 ,each in_mstr no-lock where in_domain = global_domain 
	 	 and in_part = pt_part and in_site >=site and in_site <=site1
	  break by pt_prod_line by pt_part:
    if first-of (pt_prod_line) then do:
         lineno = lineno + 1.
         if lineno<>1 then page.
         find pl_mstr where pl_domain = global_domain 
          and pl_prod_line = pt_prod_line no-lock no-error.
         assign pldesc = "".
         if available pl_mstr then do:
         		pldesc = pl_desc.
         end.
         if pr_detail = no then do:
            display date date1 with frame b.
            display pt_prod_line pldesc no-label with width 132 frame c side-labels STREAM-IO.
         end.
         else do:
            output to "c:\detailrp.txt" append.
           display date date1 with frame b.
            display pt_prod_line pldesc no-label with width 132 frame c side-labels STREAM-IO.         
              put "零件号" at 1
	     ";零件名称" at 19 ";本期销售" at 50 	";金额" at 64 	";计划外合计" at 69 ";金额" at 89
	      ";盘点调整" at 96 ";金额" at 114  ";样品赠送" at 120 ";金额" at 139 ";索赔零件报废" at 145
	      ";金额" at 164 ";试验用机发料" at 170 ";金额" at 189 ";试验用零件" at 195 ";金额" at 215
	     ";质量三包" at 220 ";金额" at 239 ";赠送" at 250 ";金额" at 264 ";设备调试" at 270 ";金额" at 289
	      ";制造领用" at 295 ";金额" at 314  ";补发销售" at 319 ";金额" at 339 ";换零件" at 348 ";金额" at 364
	       ";生产报废-ATPU" at 370 ";金额" at 389    ";生产报废-缸体" at 394 ";金额" at 414   
     /*zwh*/   ";其它废品损失" at 419  ";金额" at 439  ";其它计划外" at 446  ";金额" at 464 
	       ";生产消耗合计" at 475 ";金额"  at 489 
	       ";委托件消耗"  at 496 ";金额" at 514 ";非委托件消耗" at 520 ";金额" at 535
	       ";生产发料" at 555 ";金额" at 570 
	      ";套件销售" at 590 ";金额" at 605 ";本期合计" at 625 ";金额" at 645 ";成本调整额" at 665 skip.
            output close.
         end.
    end.


form header
skip(1)
pt_prod_line pldesc "  (续)" 
with stream-io frame a1 page-top side-labels width 132.
view frame a1.

/* 对汇总数量统计变量清零 */
qty_issue=0.

qty_iss_so=0.

qty_iss_unp=0.
qty_iss_unp201=0.
qty_iss_unp203=0.
qty_iss_unp204=0.
qty_iss_unp205=0.
qty_iss_unp206=0.
qty_iss_unp207=0.
qty_iss_unp208=0.
qty_iss_unp209=0.
qty_iss_unp210=0.
qty_iss_unp211=0.
qty_iss_unp212=0.
qty_iss_unp213=0.
qty_iss_unp214=0.
qty_iss_unp215=0. /*zwh*/
qty_iss_unp299=0.


qty_iss_wo=0.
qty_iss_pl=0.
qty_iss_wt=0.
qty_iss_fas=0.
amt_iss_fas=0.
qty_iss_tr=0.
amt_iss_tr=0.

/* 对汇总金额变量清零 */
amt_issue=0.

amt_iss_so=0.

amt_iss_unp=0.
amt_iss_unp201=0.
amt_iss_unp203=0.
amt_iss_unp204=0.
amt_iss_unp205=0.
amt_iss_unp206=0.
amt_iss_unp207=0.
amt_iss_unp208=0.
amt_iss_unp209=0.
amt_iss_unp210=0.
amt_iss_unp211=0.
amt_iss_unp212=0.
amt_iss_unp213=0.
amt_iss_unp214=0.
amt_iss_unp215=0. /*zwh*/
amt_iss_unp299=0.

amt_iss_wo=0.
amt_iss_pl=0.
amt_iss_wt=0.
amt_cst=0.


/* 统计套件销售出库情况 */
for each tr_hist no-lock where tr_domain = global_domain 
		 and tr_part=pt_part and tr_type="iss-fas" 
		 and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	qty_iss_fas = qty_iss_fas - tr_qty_loc.
	amt_iss_fas = amt_iss_fas - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
end. 

prod_iss_fas = prod_iss_fas + amt_iss_fas.
sum_iss_fas = sum_iss_fas + amt_iss_fas. 

/* 统计销售出库情况 */
for each tr_hist no-lock where tr_domain = global_domain 
		 and tr_part=pt_part and (tr_type="iss-so" and tr_ship_type<>"m") 
		 and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	qty_iss_so = qty_iss_so - tr_qty_loc.
	amt_iss_so = amt_iss_so - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
end.

prod_iss_so = prod_iss_so + amt_iss_so .
sum_iss_so = sum_iss_so + amt_iss_so .


/* 统计第一阶段计划外入库 */
for each tr_hist where tr_domain = global_domain 
		 and tr_part=pt_part and tr_type ="iss-UNP" 
		 and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	if	tr_so_job = "201" then do:
		qty_iss_unp201 = qty_iss_unp201 - tr_qty_loc.
		amt_iss_unp201 = amt_iss_unp201 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "203" then do:
		qty_iss_unp203 = qty_iss_unp203 - tr_qty_loc.
		amt_iss_unp203 = amt_iss_unp203 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "204" then do:
		qty_iss_unp204 = qty_iss_unp204 - tr_qty_loc.
		amt_iss_unp204 = amt_iss_unp204 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "205" then do:
		qty_iss_unp205 = qty_iss_unp205 - tr_qty_loc.
		amt_iss_unp205 = amt_iss_unp205 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "206" then do:
		qty_iss_unp206 = qty_iss_unp206 - tr_qty_loc.
		amt_iss_unp206 = amt_iss_unp206 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "207" then do:
		qty_iss_unp207 = qty_iss_unp207 - tr_qty_loc.
		amt_iss_unp207 = amt_iss_unp207 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "208" then do:
		qty_iss_unp208 = qty_iss_unp208 - tr_qty_loc.
		amt_iss_unp208 = amt_iss_unp208 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "209" then do:
		qty_iss_unp209 = qty_iss_unp209 - tr_qty_loc.
		amt_iss_unp209 = amt_iss_unp209 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "210" then do:
		qty_iss_unp210 = qty_iss_unp210 - tr_qty_loc.
		amt_iss_unp210 = amt_iss_unp210 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "211" then do:
		qty_iss_unp211 = qty_iss_unp211 - tr_qty_loc.
		amt_iss_unp211 = amt_iss_unp211 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "212" then do:
		qty_iss_unp212 = qty_iss_unp212 - tr_qty_loc.
		amt_iss_unp212 = amt_iss_unp212 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
	else if tr_so_job = "213" then do:
		qty_iss_unp213 = qty_iss_unp213 - tr_qty_loc.
		amt_iss_unp213 = amt_iss_unp213 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
       else if tr_so_job = "214" then do:
		qty_iss_unp214 = qty_iss_unp214 - tr_qty_loc.
		amt_iss_unp214 = amt_iss_unp214 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
/*add unplan reject issue  --zwh*/     
       else if tr_so_job = "215" then do:
		qty_iss_unp215 = qty_iss_unp215 - tr_qty_loc.
		amt_iss_unp215 = amt_iss_unp215 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
/* --zwh*/		
	else do:
		qty_iss_unp299 = qty_iss_unp299 - tr_qty_loc.
		amt_iss_unp299 = amt_iss_unp299 - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
		end.
end.
qty_iss_unp = (qty_iss_unp201 + qty_iss_unp203 + qty_iss_unp204 + qty_iss_unp205 + qty_iss_unp206 + qty_iss_unp207 + qty_iss_unp208 + qty_iss_unp209 + qty_iss_unp210 + qty_iss_unp211 + qty_iss_unp212 + qty_iss_unp213 + qty_iss_unp214 + qty_iss_unp215 + qty_iss_unp299).
amt_iss_unp = (amt_iss_unp201 + amt_iss_unp203 + amt_iss_unp204 + amt_iss_unp205 + amt_iss_unp206 + amt_iss_unp207 + amt_iss_unp208 + amt_iss_unp209 + amt_iss_unp210 + amt_iss_unp211 + amt_iss_unp212 + amt_iss_unp213 + amt_iss_unp214 + amt_iss_unp215 + amt_iss_unp299).
prod_iss_unp = prod_iss_unp + amt_iss_unp.
sum_iss_unp = sum_iss_unp + amt_iss_unp.
prod_iss_201 = prod_iss_201 + amt_iss_unp201.
prod_iss_203 = prod_iss_203 + amt_iss_unp203.
prod_iss_204 = prod_iss_204 + amt_iss_unp204.
prod_iss_205 = prod_iss_205 + amt_iss_unp205.
prod_iss_206 = prod_iss_206 + amt_iss_unp206.
prod_iss_207 = prod_iss_207 + amt_iss_unp207.
prod_iss_208 = prod_iss_208 + amt_iss_unp208.
prod_iss_209 = prod_iss_209 + amt_iss_unp209.
prod_iss_210 = prod_iss_210 + amt_iss_unp210.
prod_iss_211 = prod_iss_211 + amt_iss_unp211.
prod_iss_212 = prod_iss_212 + amt_iss_unp212.
prod_iss_213 = prod_iss_213 + amt_iss_unp213.
prod_iss_214 = prod_iss_214 + amt_iss_unp214.
prod_iss_215 =prod_iss_215 + amt_iss_unp215. /*zwh*/
prod_iss_299 = prod_iss_299 + amt_iss_unp299.
prod_iss = prod_iss + prod_iss_unp + prod_iss_so .
/* 统计第一阶段生产消耗出库 */
for each tr_hist where tr_domain = global_domain 
		 and tr_part=pt_part and tr_type ="iss-wo" 
		 and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	qty_iss_wo = qty_iss_wo - tr_qty_loc.
	amt_iss_wo = amt_iss_wo - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
	if substring(tr_nbr,1,1)="S" then do:
          qty_iss_wt = qty_iss_wt - tr_qty_loc.
	   amt_iss_wt = amt_iss_wt - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
	end.
	else do:
          qty_iss_pl = qty_iss_pl - tr_qty_loc.
	   amt_iss_pl = amt_iss_pl - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
	end.
end.
prod_iss_wo = prod_iss_wo + amt_iss_wo.
sum_iss_wo = sum_iss_wo + amt_iss_wo.
prod_iss_wt=prod_iss_wt + amt_iss_wt.
sum_iss_wt = sum_iss_wt + amt_iss_wt.
prod_iss_pl=prod_iss_pl + amt_iss_pl.
sum_iss_pl = sum_iss_pl + amt_iss_pl.



/* 统计第一阶段生产发料出库 */
for each tr_hist where tr_domain = global_domain 
	   and tr_part=pt_part and tr_type ="iss-tr" 
	   and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	qty_iss_tr = qty_iss_tr - tr_qty_loc.
	amt_iss_tr = amt_iss_tr - round (tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).
end.
prod_iss_tr = prod_iss_tr + amt_iss_tr.
sum_iss_tr = sum_iss_tr + amt_iss_tr.


/*标准成本调整*/
for each tr_hist where tr_domain = global_domain 
		 and tr_part=pt_part and tr_type ="cst-adj" 
		 and tr_effdate>=date and tr_effdate<=date1 and tr_site=in_site:
	amt_cst = amt_cst + tr_price * tr_loc_begin.
end.
prod_cst=prod_cst + amt_cst.
sum_cst=sum_cst + amt_cst.


/* 汇总第一阶段入库数据 */
qty_issue = qty_iss_so + qty_iss_unp + qty_iss_wo + qty_iss_fas .
amt_issue = amt_iss_so + amt_iss_unp + amt_iss_wo + amt_iss_fas.
prod_issue = prod_issue + amt_issue.


if page-size - line-counter < 3 then page.

/* 显示输出 */
 if not (qty_iss_so =0 and  qty_iss_unp = 0  and qty_iss_wo = 0 and amt_cst=0 ) then do:
 if pr_detail = yes then do:
	output to "c:\detailrp.txt" append.
 	put pt_part ";"
 	pt_desc2 ";"
 	qty_iss_so ";"
 	amt_iss_so ";"
 	qty_iss_unp ";"
 	amt_iss_unp ";"
 	qty_iss_unp201 ";"
 	amt_iss_unp201 ";"
 	qty_iss_unp203 ";"
 	amt_iss_unp203 ";"
 	qty_iss_unp204 ";"
 	amt_iss_unp204 ";"
 	qty_iss_unp205 ";"
 	amt_iss_unp205 ";"
 	qty_iss_unp206 ";"
 	amt_iss_unp206 ";"
 	qty_iss_unp207 ";"
 	amt_iss_unp207 ";"
 	qty_iss_unp208 ";"
 	amt_iss_unp208 ";"
 	qty_iss_unp209 ";"
 	amt_iss_unp209 ";"
 	qty_iss_unp210 ";"
 	amt_iss_unp210 ";"
 	qty_iss_unp211 ";"
 	amt_iss_unp211 ";"
 	qty_iss_unp212 ";"
 	amt_iss_unp212 ";"
 	qty_iss_unp213 ";"
 	amt_iss_unp213 ";"
 	qty_iss_unp214 ";"
 	amt_iss_unp214 ";"
 	qty_iss_unp215 ";"  /*zwh*/
 	amt_iss_unp215 ";"  /*zwh*/
 	qty_iss_unp299 ";"
 	amt_iss_unp299 ";"
 	qty_iss_wo ";"
 	amt_iss_wo ";"
 	qty_iss_wt ";"
 	amt_iss_wt ";"
 	qty_iss_pl ";"
 	amt_iss_pl ";"
 	qty_iss_tr ";"
 	amt_iss_tr ";"
 	qty_iss_fas ";"
 	amt_iss_fas ";"
       qty_issue  ";"
       amt_issue  ";"
       amt_cst
  	skip.
 	output close.
 end. 
 else 
 disp pt_part column-label "零件号" ";" pt_desc2 column-label ";零件名称" ";" pt_um column-label ";单位" ";"
 qty_iss_so column-label ";本期销售" ";" amt_iss_so column-label ";金额" ";"
 qty_iss_fas column-label ";套件销售" ";" amt_iss_fas column-label ";金额" ";"
 qty_iss_unp column-label ";计划外出库合计" ";" amt_iss_unp column-label ";金额"  ";"
 qty_iss_wo column-label ";生产消耗合计" ";" amt_iss_wo column-label ";金额" ";"
 qty_iss_wt column-label ";委托件消耗" ";" amt_iss_wt column-label ";金额" ";"
 qty_iss_pl column-label ";非委托件消耗" ";" amt_iss_pl column-label ";金额" ";"
 qty_iss_tr column-label ";生产发料" ";" amt_iss_tr column-label ";金额" ";"
 qty_issue column-label ";本期出库合计" ";" amt_issue column-label ";出库金额" ";" amt_cst column-label ";成本调整额"
 with width 350  STREAM-IO .
 end.
 if last-of(pt_prod_line) then do:
   if pr_detail = yes then do:
       output to "c:\detailrp.txt" append.
       put "产品类合计:" at 1       
	";本期销售金额" at 57 	";计划外总额" at 83 ";盘点调整金额" at 107	
	";样品赠送金额" at 132 ";索赔零件报废金额" at 157 ";试验用机发金额" at 181 ";试验用零件金额" at 204
	";质量三包金额" at 231 ";赠送金额" at 260 ";设备调试金额" at 281 ";制造领用金额" at 306
	";补发销售金额" at 331 ";换零件金额" at 358 ";生产报废-ATPU" at 379 ";生产报废-缸体" at 406
        ";其它废品损失" at 431  ";其它计外额金额" at 456
        ";生产消耗总金额" at 481 
	";委托件消耗" at 506  ";非委托件消耗" at 531	
	";生产发料金额" at 556
	";套件销售金额" at 581
	";本期出库总额" at 606  ";成本调整额" at 631 skip.
       put pt_prod_line at 1 ";" 
       prod_iss_so  at 53 ";" prod_iss_unp at 78  ";"
	prod_iss_201 at 103	 ";"
	prod_iss_203 at 128   ";" 
	prod_iss_204 at 153   ";" 
	prod_iss_205 at 178  ";"
	prod_iss_206 at 203  ";"
	prod_iss_207 at 228  ";"
	prod_iss_208 at 253  ";"
	prod_iss_209 at 278  ";"
	prod_iss_210 at 303  ";"
	prod_iss_211 at 328  ";"
	prod_iss_212 at 353  ";"
	prod_iss_213 at 378  ";"
	prod_iss_214 at 403  ";"
	prod_iss_215 at 428  ";"                   /*zwh*/
	prod_iss_299 at 453  ";"
	prod_iss_wo at 478  ";"
	prod_iss_wt at 503  ";"
	prod_iss_pl at 528  ";"
	prod_iss_tr at 553 ";"
	prod_iss_fas at 578  ";"
	prod_issue at 593 ";"
	prod_cst at 618 skip.
       output close.
   end.
   else do:
       display "产品类合计:" with frame z2.
       display prod_iss_so  column-label "销售出库金额" ";" prod_iss_fas column-label ";套件销售金额" ";"
        prod_iss_unp column-label ";计划外出库金额" ";" prod_iss_wo column-label ";生产消耗合计金额" ";" 
        prod_iss_wt column-label ";委托件消耗" ";"  prod_iss_pl column-label ";非委托件消耗" ";" 
        prod_iss_tr column-label ";生产发料金额" ";"
        prod_issue column-label ";出库总计金额" ";" prod_cst column-label ";成本调整额" with width 320 frame z  STREAM-IO .
   end.
   prod_issue=0.
   prod_iss_so=0.
   prod_iss_fas=0.
   prod_iss_unp = 0.
   prod_iss_wo = 0.
   prod_iss_wt=0.
   prod_iss_pl=0.
   prod_iss_tr=0.
   prod_iss = 0.
   prod_iss_201 = 0.
   prod_iss_203 = 0.
   prod_iss_204 = 0.
   prod_iss_205 = 0.
   prod_iss_206 = 0.
   prod_iss_207 = 0.
   prod_iss_208 = 0.
   prod_iss_209 = 0.
   prod_iss_210 = 0.
   prod_iss_211 = 0.
   prod_iss_213 = 0.
   prod_iss_214 = 0.
   prod_iss_215 = 0. /*zwh*/
   prod_iss_212 = 0.
   prod_iss_299 = 0.
   prod_cst=0.   
 end.
end.

  if pr_detail = yes then do:
       output to "c:\detailrp.txt" append.
       display "期间合计:" with frame y4 .
       disp sum_iss_so column-label "销售出库金额" ";" sum_iss_fas column-label ";套件销售金额" ";" 
        sum_iss_unp column-label ";计划外出库金额" ";" sum_iss_wo column-label ";生产消耗合计" ";" 
         sum_iss_wt column-label ";委托件消耗" ";" sum_iss_pl column-label ";非委托件消耗" ";"
         sum_iss_tr column-label ";生产发料金额" ";"
         sum_cst column-label ";成本调整额"
         with width 320 frame y1  STREAM-IO .
       output close.
   end.
   else do:
       display "期间合计:" with frame y2 .
       disp sum_iss_so column-label "销售出库金额" ";" sum_iss_fas column-label ";套件销售金额" ";"
        sum_iss_unp column-label ";计划外出库金额" ";" sum_iss_wo column-label ";生产消耗合计" ";"
          sum_iss_wt column-label ";委托件消耗" ";" sum_iss_pl column-label ";非委托件消耗" ";"
          sum_iss_tr column-label ";生产发料金额" ";" sum_cst column-label ";成本调整额"
         with width 320 frame y  STREAM-IO .
   end.
 
/*judy 05/08/19*/   
   sum_iss_tr = 0.
   sum_iss_so = 0.
   sum_iss_fas = 0.
   sum_iss_unp = 0.
   sum_iss_wo = 0.
   sum_iss_wt = 0.
   sum_iss_pl = 0.
   sum_cst = 0. 
/*judy 05/08/19*/ 

{mfguitrl.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
 
end procedure.



/*GUI*/ {mfguirpb.i &flds=" site site1 line line1 part part1 date date1 keeper keeper1  pr_detail "} /*Drive the Report*/



