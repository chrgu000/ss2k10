/* yyinacrp04.p  - Inventroy Activity Detail Report                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/* V4   Developped: 05/29/01      BY: Rao Haobin          */
/* v5   developped: 07/02/02      By:kangjian   **only add tr_site=pt_site searching in tr_hist***/
/* 以库房为中心，发到车间的材料算出库，不在库房的有效结余库存之内,本报表用于输出EXCEL文件供财务数据校对 */

/*           Last MOD: 06/30/05          BY: Judy Liu       cj       */

{mfdtitle.i } 
def var qty_iss_so as integer format "->>>>>>>>>>>9".
def var qty_iss_unp as integer format "->>>>>>>>>>>9".
def var qty_iss_tr as integer format "->>>>>>>>>>>9".
def var qty_iss_wo as integer format "->>>>>>>>>>>9".
def var qty_iss_mv as integer format "->>>>>>>>>>>9".
def var qty_tag_cnt as integer format "->>>>>>>>>>>9".
def var qty_rct_po as integer format "->>>>>>>>>>>9".
def var qty_rct_unp as integer format "->>>>>>>>>>>9".
/*Kang Jain*/
def var qty_rct_wo as integer format "->>>>>>>>>>>9".
def var qty_iss_prv as integer format "->>>>>>>>>>>9".


def var qty_iss_so2 as integer format "->>>>>>>>>>>9".
def var qty_iss_unp2 as integer format "->>>>>>>>>>>9".
def var qty_iss_tr2 as integer format "->>>>>>>>>>>9".
def var qty_iss_wo2 as integer format "->>>>>>>>>>>9".
def var qty_iss_mv2 as integer format "->>>>>>>>>>>9".
def var qty_tag_cnt2 as integer format "->>>>>>>>>>>9".
def var qty_rct_po2 as integer format "->>>>>>>>>>>9".
def var qty_rct_unp2 as integer format "->>>>>>>>>>>9".
/*Kang Jain*/
def var qty_rct_wo2 as integer format "->>>>>>>>>>>9".
DEF VAR QTY_ISS_PRV2 AS INTEGER format "->>>>>>>>>>>9".

def var qty as integer format "->>>>>>>>>>>9".
def var qty_issue as integer format "->>>>>>>>>>>9".
def var qty_receive as integer format "->>>>>>>>>>>9".
def var qty_init as integer format "->>>>>>>>>>>9".
def var qty_end as integer format "->>>>>>>>>>>9".
def var qty_issue2 as integer format "->>>>>>>>>>>9".
def var qty_receive2 as integer format "->>>>>>>>>>>9".
def var lineno as integer format "->>>>>>>>>>>9".
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
/*judy 06/30/05*/ DEFINE VARIABLE planer LIKE pt_buyer.
/*judy 06/30/05*/ DEFINE VARIABLE planer1 LIKE pt_buyer.
def var qty_rct_tr  as integer format "->>>>>>>>>>>9".

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
	     keeper1           label {t001.i} colon 49 SKIP 
/*judy 06/30/05*/  planer COLON 18
/*judy 06/30/05*/  planer1 LABEL {t001.i} COLON 49 SKIP
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

/*judy 06/30/05*/   /* SET EXTERNAL LABELS */
/*judy 06/30/05*/   setFrameLabels(frame a:handle).


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
/*judy 06/30/05*/  IF planer1 = hi_char THEN planer1 = "".

 
	     
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
/*judy 06/30/05*/  {mfquoter.i planer    }
/*judy 06/30/05*/  {mfquoter.i planer1   }
	     if  part1 = "" then part1 = hi_char.
	     if  line1 = "" then line1 = hi_char.
	     if  keeper1 = "" then keeper1 = hi_char.
	     if  site1 = "" then site1 = hi_char.
	     if  date = ? then date = low_date.
	     if  date1 = ? then date1 = hi_date.
/*judy 06/30/05*/  IF planer1 = "" THEN planer1 = hi_char.
	     
    /* SELECT PRINTER */
	     
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "printer" 132}
{mfphead.i}
lineno=0.

 for each pt_mstr no-lock where pt_prod_line >= line and pt_prod_line <= line1 
              and pt_part <= part1 and pt_part >= part  /*and pt_article >= keeper 
              and pt_article <= keeper1  and pt_site >= site and pt_site <= site1 */
              use-index pt_prod_part,
         EACH IN_mstr WHERE IN_part = pt_part AND IN_site >= site
                 AND IN_site <= site1 AND
                 (in__qadc01 >= keeper AND  in__qadc01 <= keeper1) NO-LOCK ,
          EACH  ptp_det WHERE ptp_part = pt_part AND ptp_site = IN_site 
             AND ptp_buyer >= planer AND ptp_buyer <= planer1
                 break by pt_prod_line with width 255 no-box:
 
    if first-of (pt_prod_line) then do:
       lineno = lineno + 1.
       if lineno<>1 then page. 
              find pl_mstr where pl_prod_line = pt_prod_line no-lock no-error.
       pldesc = pl_desc.
       display date date1 with frame b.
       display pt_prod_line pldesc no-label with width 132 frame c side-labels STREAM-IO.
       PUT "零件号" AT 1 "零件名称" AT 19 "单位" AT 45 "ABC" AT 49 "默认库位" AT 59 "保管员" AT 69 
           "期初库存" TO 94 "盘盈/盘亏" TO 109 "采购入库" TO 124 "计划外入库" TO 139 "采购退货" TO 154     
           "完工入库" TO 169 "本期入库合计" TO 184 "生产出库" TO 199 "计划外出库" TO 214 
           "销售出库" TO 229 "本期出库合计" TO 244  "移出数量" TO 259   "移入数量"  TO 274   "期末库存"TO 285 SKIP .
    end.
    /*find in_mstr where pt_part=in_part and in_site=pt_site no-lock no-error.
    if not available(in_mstr) then disp " 1.4.16中未维护：" pt_part pt_site.*/




form header
skip(1)
pt_prod_line pldesc "  (续)" 
with stream-io frame a1 page-top side-labels width 132.
view frame a1.


qty=0.
qty_issue=0.
qty_receive=0.
qty_issue2=0.
qty_receive2=0.

qty_iss_so=0.
qty_iss_unp=0.
qty_iss_tr=0.
qty_iss_wo=0.
qty_iss_mv=0.
qty_tag_cnt=0.
qty_rct_po=0.
qty_rct_unp=0.
qty_iss_prv=0.
qty_rct_wo=0.

qty_iss_so2=0.
qty_iss_unp2=0.
qty_iss_tr2=0.
qty_iss_wo2=0.
qty_iss_mv2=0.
qty_tag_cnt2=0.
qty_rct_po2=0.
qty_rct_unp2=0.
qty_rct_wo2=0.
qty_iss_prv2=0.
qty_rct_tr=0.

/*judy 06/30/05*/ /*for each ld_det no-lock where ld_part = pt_part:*/
/*judy 06/30/05*/  for each ld_det no-lock where ld_part = pt_part  AND ld_site = in_site USE-INDEX ld_part_loc:
 qty = qty + ld_qty_oh.
end.

for each tr_hist no-lock where tr_part=pt_part and tr_site=in_site and substring(tr_type,1,3)="ISS" and tr_effdate>=date and tr_effdate<=date1:
if tr_type="ISS-SO" then
qty_iss_so=qty_iss_so + tr_qty_chg.
else if tr_type="ISS-WO" then
qty_iss_wo=qty_iss_wo + tr_qty_chg.
else if tr_type="ISS-UNP" and substring(tr_rmks,1,2)<>"ad" then
qty_iss_unp=qty_iss_unp + tr_qty_chg.
else if tr_type="ISS-TR" /*and substring(tr_nbr,1,2)="PL"*/  then
qty_iss_tr=qty_iss_tr + tr_qty_chg.
/*else  if tr_type="" and substring(tr_nbr,1,2)<>"PL" then
qty_iss_mv=qty_iss_mv + tr_qty_chg. */
end.
qty_issue=absolute(qty_iss_so + qty_iss_unp + qty_iss_wo ).

for each tr_hist no-lock where tr_part=pt_part and tr_site=in_site and substring(tr_type,1,3)="ISS" and tr_effdate>date1:
if tr_type="ISS-SO" then
qty_iss_so2=qty_iss_so2 + tr_qty_chg.
else if tr_type="ISS-WO" then
qty_iss_wo2=qty_iss_wo2 + tr_qty_chg.
else if tr_type="ISS-UNP" and substring(tr_rmks,1,2)<>"ad" then
qty_iss_unp2=qty_iss_unp2 + tr_qty_chg.
else if tr_type="ISS-TR" and substring(tr_nbr,1,2)="PL" then
qty_iss_tr2=qty_iss_tr2 + tr_qty_chg.
else if tr_type="" and substring(tr_nbr,1,2)<>"PL" then
qty_iss_mv2=qty_iss_mv2 + tr_qty_chg.
end.
qty_issue2=absolute(qty_iss_so2 + qty_iss_unp2 + qty_iss_wo2 ).

for each tr_hist no-lock where tr_part=pt_part and tr_site=in_site AND  tr_type="TAG-CNT" and tr_effdate>date1:
qty_tag_cnt2=qty_tag_cnt2 + tr_qty_chg.
end.

for each tr_hist no-lock where tr_part=pt_part and tr_site=in_site AND ( tr_type="TAG-CNT" OR tr_type BEGINS "cyc")  and tr_effdate>=date and tr_effdate<=date1:
qty_tag_cnt=qty_tag_cnt + tr_qty_chg.
end.

for each tr_hist no-lock where tr_part=pt_part and tr_site=in_site and tr_type="RCT-PO" and tr_effdate>=date and tr_effdate<=date1:
qty_rct_po = qty_rct_po + tr_qty_chg.
end.

for each tr_hist no-lock where tr_part=pt_part and tr_site=in_site and tr_type="iss-prv" and tr_effdate>=date and tr_effdate<=date1:
qty_iss_prv = qty_iss_prv + tr_qty_chg.
end.

for each tr_hist no-lock where tr_part=pt_part and tr_site=in_site and tr_type ="RCT-UNP" and tr_effdate>=date and tr_effdate<=date1:
qty_rct_unp = qty_rct_unp + tr_qty_chg.
end.

/*Kang Jian*/
for each tr_hist no-lock where tr_part=pt_part and tr_site=in_site and tr_type ="RCT-WO" and tr_effdate>=date and tr_effdate<=date1:
qty_rct_wo = qty_rct_wo + tr_qty_chg.
end.

for each tr_hist no-lock where tr_part=pt_part and tr_site=in_site and tr_type ="rct-tr" and tr_effdate>=date and tr_effdate<=date1:
qty_rct_tr = qty_rct_tr + tr_qty_chg.
end.

qty_receive=qty_rct_po + qty_rct_unp + qty_rct_wo + qty_iss_prv.

for each tr_hist no-lock where tr_part=pt_part and tr_site=in_site and (TR_TYPE="ISS-PRV" OR tr_type="RCT-PO" or tr_type="RCT-UNP" or tr_type="RCT-WO") and tr_effdate>date1:
qty_receive2 = qty_receive2 + tr_qty_chg.
end.

/*judy*/
   qty_end = qty.
   qty_init = qty.
    for each tr_hist  where tr_part = pt_part
                            and tr_effdate > date1 and tr_site = in_site
                            and tr_effdate <> ? 
                            and tr_qty_loc <> 0
                            and tr_ship_type = ""
                         NO-LOCK USE-INDEX tr_part_eff:
                         qty_end = qty_end -  tr_qty_loc.
                      END.
    
    /*qty_end = qty - qty_tag_cnt2 + qty_issue2 - qty_receive2.*/
    
    /*qty_init = qty_end - qty_tag_cnt + qty_issue  - qty_receive.*/
       for each tr_hist where tr_part = pt_part
                            and tr_effdate > DATE - 1 and tr_site = in_site
                            and tr_effdate <> ? and tr_qty_loc <> 0
                            and tr_ship_type = ""
                         NO-LOCK USE-INDEX tr_part_eff:
                         qty_init  = qty_init  - tr_qty_loc.
                      END.
/*judy*/
IF qty_init = 0 AND qty_tag_cnt = 0 AND qty_receive = 0 AND qty_issue = 0 AND qty_end = 0  THEN NEXT.

if page-size - line-counter < 3 then page.

PUT pt_part AT 1 pt_desc2 AT 19 pt_um AT 45 in_abc AT 49 pt_loc AT 59 pt_article format "x(6)" AT 69
    qty_init  format "->>>>>>>>>>>9" TO 94
    qty_tag_cnt format "->>>>>>>>>>>9" TO 109
    qty_rct_po format "->>>>>>>>>>>9" TO 124
    qty_rct_unp format "->>>>>>>>>>>9" TO 139
    absolute(qty_iss_prv) format "->>>>>>>>>>>9" TO 154
    absolute(qty_rct_wo) format "->>>>>>>>>>>9" TO 169
    qty_receive format "->>>>>>>>>>>9" TO 184
    absolute(qty_iss_wo) format "->>>>>>>>>>>9" TO 199
    absolute(qty_iss_unp) format "->>>>>>>>>>>9" TO 214
    absolute(qty_iss_so) format "->>>>>>>>>>>9" TO 229
    qty_issue format "->>>>>>>>>>>9" TO 244
  absolute(qty_iss_tr) format "->>>>>>>>>9"  TO 258
    absolute(qty_rct_tr) format "->>>>>>>>>9"  TO 273 
      qty_end format "->>>>>>>>>>>9" TO 288 /*WITH no-box no-labels FRAME F6 width 340*/ SKIP .
/*disp pt_part pt_desc2 pt_um in_abc label "ABC" pt_loc label "默认库位" pt_article format "x(6)" label "保管员"  qty_init label "期初库存" qty_tag_cnt label "盘盈/盘亏" qty_rct_po label "采购入库" qty_rct_unp label "计划外入库" absolute(qty_iss_prv) format "->>>>>>>>>>>9" label "采购退货"  absolute(qty_rct_wo) format "->>>>>>>>>>>9" label "完工入库" qty_receive 
     label "本期入库合计"  absolute(qty_iss_wo) format "->>>>>>>>>>>9" label "生产出库" absolute(qty_iss_unp) label "计划外出库" absolute(qty_iss_so) format "->>>>>>>>>>>9" label "销售出库" qty_issue label "本期出库合计" qty_end label "期末库存" absolute(qty_iss_tr) format "->>>>>>>>>>>9" label "转移数量" with width 340  STREAM-IO.*/
end.

{mfguitrl.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
/*judy 06/30/05*/ {mfreset.i}
end procedure.



/*judy 06/30/05*/ /*/*GUI*/ {mfguirpb.i &flds=" site site1 line line1 part part1 date date1 keeper keeper1  "} */ /*Drive the Report*/
/*judy 06/30/05*/ /*GUI*/ {mfguirpb.i &flds=" site site1 line line1 part part1 date date1 keeper keeper1 planer planer1"}  /*Drive the Report*/
/*judy 06/30/05*/ /*{mfreset.i}*/


