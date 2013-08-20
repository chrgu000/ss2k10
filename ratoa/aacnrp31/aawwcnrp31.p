/* lhcnrp31.p - consignment vend report                                 */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*create by tonylihu   2011-01-12                                        */
/*modify by hong zhang 2011-04-15                                      */

{mfdtitle.i "20121222.1 "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE porcrp_p_6 "Unprinted Receivers Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE porcrp_p_8 "Print Receipt Trailer"
/* MaxLen: Comment: */

&SCOPED-DEFINE porcrp_p_9 "List All Comments"
/* MaxLen: Comment: */
define new shared variable convertmode as character no-undo.
define new shared variable rndmthd like rnd_rnd_mthd.
define new shared variable oldcurr like po_curr.
/* CORRECT INITIAL TAX TYPE TO INDICATE RECEIPT (21) NOT RETURN (25)*/
define new shared variable tax_tr_type     like tx2d_tr_type no-undo
   initial '21'.
define variable site like tr_site.
define variable site1 like tr_site.
define variable vend like prh_vend.
define variable vend1 like prh_vend.
define variable part like prh_part.
define variable part1 like prh_part.
define variable cn_date like prh_rcp_date.
define variable cn_date1 like prh_rcp_date.
DEFINE VAR vm AS CHAR FORMAT "x(22)" .
DEFINE VAR UP_po AS logi .
define var  UP_firPO  as logi .
DEFINE VAR YN AS LOGI .
DEFINE VAR POLINE LIKE POD_LINE .
DEFINE VAR POSITE LIKE PO_SITE .
DEFINE VAR popss AS logi .
define var poqty like pod_qty_ord .
define var thism as logi .
/*张宏改 2011-04-13*/
DEFINE VAR xxyy LIKE xxcn_year.
DEFINE VAR xxmm LIKE xxcn_month.
DEFINE VAR xxmm1 AS CHAR.
DEFINE VAR xxs1 AS CHAR FORMAT 'x(25)'.
DEFINE VAR xxs2 AS CHAR FORMAT 'x(6)'.
DEFINE VAR xxs3 AS CHAR.
DEFINE VAR xxs4 LIKE vd_sort.
DEFINE VAR xxs5 LIKE pt_desc1.
DEFINE VAR xxs6 LIKE ad_addr.
DEFINE VAR xxd1 AS DATE.
DEFINE VAR xxd2 AS DATE.
DEFINE VAR xxd3 AS DATE.
DEFINE VAR xxd4 AS DATE.
DEFINE BUFFER xxcnbuf FOR xxcn_mstr.
DEFINE VAR xxyn AS LOG.
/*张宏改  2011-04-13*/
def stream out1 .
define var ofile1 as char .
DEFINE VAR  in_fld AS CHAR .
DEFINE VAR  out_fld AS CHAR .
define var poid as inte .
define var ponbr like po_nbr .
define var cost1 as dec .
define var xxxcode1 as char format "x(8)" .
define variable xxmysum1 like tr_qty_chg.
define variable xxmysum2 like tr_qty_chg.
define variable xxmysum3 like tr_qty_chg.
define variable xxmysum4 like tr_qty_chg.
define variable xxmysum5 like tr_qty_chg.
define variable xxmysum6 like tr_qty_chg.
define variable mytitlename like dom_name.
find first dom_mstr no-lock where dom_domain = global_domain .
mytitlename = dom_name + "  挂帐表" .


define temp-table xxtempcn_mstr NO-UNDO  /*张宏改 该临时表用于记录待显示的数据 2011-04-13*/
 FIELD xxtempcn_vend   LIKE xxcn_vend
 FIELD xxtempcn_part   LIKE pt_part
 FIELD xxtempcn_qty1   LIKE tr_qty_chg INIT 0 /*期初*/
 FIELD xxtempcn_qty2   LIKE tr_qty_chg INIT 0 /*耗用数*/
 FIELD xxtempcn_perd   AS CHAR                /*耗用周期*/
 FIELD xxtempcn_qty3   LIKE tr_qty_chg INIT 0  /*入库数*/
 FIELD xxtempcn_qty4   LIKE tr_qty_chg INIT 0 /*退货数*/
 FIELD xxtempcn_qty5   LIKE tr_qty_chg INIT 0 /*期末数*/
 FIELD xxtempcn_qty6   LIKE tr_qty_chg INIT 0 /*挂帐数*/
 FIELD xxtempcn_qty7   LIKE xxpc_amt[1] format "->>>>>,>>9.9999" INIT 0 /*单价*/
 FIELD xxtempcn_qty8   LIKE tr_qty_chg INIT 0  /*金额*/
 FIELD xxtempcn_ch3    AS CHAR  /*挂帐方式*/
 FIELD xxtempcn_ch4    AS LOG.  /*价格类型,yes:正式价  no:暂估价或者无价*/

define temp-table mytempcn_mstr NO-UNDO  /*张宏改 该临时表用于记录待显示的数据 2011-04-13*/
 FIELD mytempcn_vend   LIKE xxcn_vend
 FIELD mytempcn_part   LIKE pt_part
 FIELD mytempcn_qty1   LIKE tr_qty_chg INIT 0 /*期初*/
 FIELD mytempcn_qty2   LIKE tr_qty_chg INIT 0 /*耗用数*/
 FIELD mytempcn_perd   AS CHAR                /*耗用周期*/
 FIELD mytempcn_qty3   LIKE tr_qty_chg INIT 0  /*入库数*/
 FIELD mytempcn_qty4   LIKE tr_qty_chg INIT 0 /*退货数*/
 FIELD mytempcn_qty5   LIKE tr_qty_chg INIT 0 /*期末数*/
 FIELD mytempcn_qty6   LIKE tr_qty_chg INIT 0 /*挂帐数*/
 FIELD mytempcn_qty7   LIKE xxpc_amt[1] format "->>>>>,>>9.9999" INIT 0 /*单价*/
 FIELD mytempcn_qty8   LIKE tr_qty_chg INIT 0  /*金额*/
 FIELD mytempcn_ch3    AS CHAR  /*挂帐方式*/
 FIELD mytempcn_ch4    AS LOG.  /*价格类型,yes:正式价  no:暂估价或者无价*/

define var myfilett as char.
myfilett = "/test001.txt".

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.
form
   site           colon 15
   site1          label {t001.i} colon 49
   vend           colon 15
   vend1          label {t001.i} colon 49
   part           colon 15
   part1          label {t001.i} colon 49
   xxyy LABEL '期间年' COLON 15 /*张宏改 加入供用户选择的期间 2011-04-13*/
   xxmm LABEL '期间月' COLON 15

  /* thism  label "只显示本月耗用<>0的" colon 65 */
   skip(1)
  /* cn_date1      label "耗用日(处理3月数据,这里就必须是3月1号后的日期)"  colon 59*/
with frame a attr-space side-labels width 80.

setFrameLabels(frame a:handle).

convertmode = "REPORT".

view frame a.

FORM 
/* xxcn_vend  label "供应商代码" 
 ad_name  LABEL "供应商描述" FORMAT 'x(12)'  */
/* vd_type  label '挂帐方式'  */
 xxcn_part label "物料编码" 
 pt_desc1 label "物料描述" 
/* pt_um label "单位"  */
 xxcn_qty_fir_oh label  "期初数"
/* xxcn_qty_con LABEL '耗用数'*/
 xxcn_qty_inv_fir COLUMN-LABEL "前期    !末挂帐数"
 xxs2 LABEL '耗用周期'
 xxcn_dec5 LABEL '入库数'
 xxcn_dec6 COLUMN-LABEL '退货数'
 xxcn_qty_inv LABEL '期末数'
 xxcn_qty_rcv LABEL '挂帐数'
 xxcn_cost LABEL '单价' 
 xxcn_dec3 LABEL '金额'
 with frame C width 260 NO-BOX STREAM-IO down .  


FORM  header 
SKIP
mytitlename at 50 
SKIP(1)
'本挂帐表共计三联:白联财务部;红联供应商交票时交回财务;黄联供应商次月挂账交回财务' at 2  
'所属日期:' AT 90 xxs1 AT 100
SKIP (1)
 '供应商编码:' AT 2 xxs6 AT 14
 '供应商描述:' AT 24 xxs4  AT 36
SKIP(1)
with PAGE-TOP  no-box width 180 frame t NO-ATTR-SPACE .

assign
   cn_date   = today - 30
   cn_date1  = today .

  site = "11000" .
  site1 = "11000" .
  UP_PO = NO .
repeat:

   if site1 = hi_char then site1 = "".
   if part1 = hi_char then part1 = "".
   if vend1 = hi_char then vend1 = "".
   if xxyy = 0 then xxyy = year(today).
   if xxmm = 0 then xxmm  = MONTH(TODAY).
   update
      site site1 vend vend1 part part1  xxyy xxmm 
   with frame a.
   /*张宏改 2011-04-13*/
   IF  xxmm < 1 OR xxmm > 12   THEN
   DO:
       MESSAGE '输入的期间范围格式有误，请检查.'.
       UNDO,RETRY.
   END.
       

   /*张宏改 2011-04-13*/

   bcdparm = "".
   {mfquoter.i site}
   {mfquoter.i site1}
   {mfquoter.i vend}
   {mfquoter.i vend1}
   {mfquoter.i part}
   {mfquoter.i part1}
   {mfquoter.i xxyy}
   {mfquoter.i xxmm}
   
  
   if site1 = "" then site1 = hi_char.
   if part1 = "" then part1 = hi_char.
   if vend1 = "" then vend1 = hi_char.
   
 {mfselbpr.i "printer" 80}
 
 EMPTY TEMP-TABLE xxtempcn_mstr.
 EMPTY TEMP-TABLE mytempcn_mstr.

 ASSIGN xxd1= hi_date
        xxd2 = hi_date.

 FIND FIRST glc_cal NO-LOCK WHERE glc_domain = GLOBAL_domain and glc_year = xxyy AND glc_per = xxmm  NO-ERROR.

 IF AVAIL glc_cal  THEN
 DO:
     
     ASSIGN xxd1 = glc_start
            xxd2 = glc_end.
 END. /*IF AVAIL glc_cal  THEN*/
 /*检查该会计期间是否关闭,注意润通地点要改*/
 IF xxmm <= 9 THEN
     SET xxmm1 = '00'+ string(xxmm).
 IF xxmm > 9 THEN
     SET xxmm1 = '0' + STRING(xxmm).
     
 FIND FIRST  qad_wkfl WHERE qad_domain = GLOBAL_domain AND qad_key1 = 'Glcd_det' AND SUBSTRING(qad_key2 , 1 ,4) = string(xxyy) AND   SUBSTRING(qad_key2 , 5 ,3) = xxmm1 AND SUBSTRING(qad_key2 , 8 ,4) = '1000' NO-LOCK NO-ERROR.
 IF NOT AVAIL qad_wkfl OR (AVAIL qad_wkfl AND qad_decfld[1] = 1) OR NOT AVAIL glc_cal THEN
 DO:
       
       MESSAGE '该期间:' + STRING(xxyy) + STRING(xxmm) + '应付会计期间已关闭,请检查'.
       {mfreset.i}
       {mfgrptrm.i}
       UNDO,RETRY.
 END. /*IF NOT AVAIL qad_wkfl OR (AVAIL qad_wkfl AND qad_decfld[4] = 1) THEN*/
/*
output to value(myfilett).
put 111 today time skip.
output close.
*/
FOR EACH xxcn_mstr NO-LOCK WHERE xxcn_domain =  global_domain 
                       and   xxcn_vend >= vend AND xxcn_vend <= vend1 
                       AND xxcn_part >= part AND xxcn_part <= part1
                       AND xxcn_year = xxyy  AND xxcn_month = xxmm 
                      /* AND xxcn_po_stat <> "2"  /*只列取末挂帐部分*/*/
                      AND xxcn_site >= site AND xxcn_site <= site1 use-index xxcn_vend_part :

  FIND FIRST vd_mstr NO-LOCK WHERE vd_domain = GLOBAL_domain AND vd_addr = xxcn_mstr.xxcn_vend AND ( vd_type = 'U' OR vd_type = 'I' OR vd_type = 'C')  NO-ERROR.  /*只提取按入库/耗用挂帐的供应商*/
  IF NOT AVAIL vd_mstr THEN
      NEXT.

  CREATE xxtempcn_mstr.
  ASSIGN xxtempcn_vend = xxcn_mstr.xxcn_vend
         xxtempcn_part = xxcn_mstr.xxcn_part
         xxtempcn_perd = string(xxcn_mstr.xxcn_year) + STRING(xxcn_mstr.xxcn_month) /*耗用周期*/
         xxtempcn_qty1 = xxcn_mstr.xxcn_qty_fir_oh
         xxtempcn_qty4 = xxcn_mstr.xxcn_dec6
         xxtempcn_qty6 = xxcn_mstr.xxcn_qty_rcv.
  
  IF xxcn_mstr.xxcn_po_stat = ""  THEN 
      ASSIGN xxtempcn_qty6 = xxcn_mstr.xxcn_qty_rcv.
  ELSE
      ASSIGN xxtempcn_qty6 = 0.

  xxtempcn_qty7 = xxcn_mstr.xxcn_cost.
  ASSIGN xxtempcn_qty3 =  xxcn_mstr.xxcn_dec5   /*入库数*/
         xxtempcn_qty2 = xxcn_mstr.xxcn_qty_con /*耗用数*/
         xxtempcn_ch3 = xxcn_mstr.xxcn_ch3.

  ASSIGN xxtempcn_qty5 = xxcn_mstr.xxcn_dec3 /*xxtempcn_qty1 + xxtempcn_qty3 - xxtempcn_qty4 - xxtempcn_qty2 /*结存=期初+入库-退货-耗用*/*/
         xxtempcn_qty8 = xxtempcn_qty6 * xxtempcn_qty7. /*金额= 单价 * 挂帐数*/
end.  /*for each xxcn_mstr*/
/*
output to value(myfilett) append.
put 222 today time skip.
output close.
*/
/*然后还要再找之前月份的末挂帐的数据*/
for each xxtempcn_mstr:
  /*
  output to value(myfilett) append.
  put 22211 xxtempcn_vend "," xxtempcn_part "," today time skip.
  output close.
  */
  FOR EACH xxcn_mstr NO-LOCK use-index xxcn_vpssym WHERE xxcn_domain = GLOBAL_domain 
                             AND xxcn_vend = xxtempcn_vend AND xxcn_part = xxtempcn_part
                             AND xxcn_po_stat = "" 
                             AND xxcn_site >= site AND xxcn_site <= site1
                             AND (xxcn_year < xxyy or (xxcn_year = xxyy AND xxcn_month < xxmm))
                             :
  

       CREATE mytempcn_mstr.
       ASSIGN mytempcn_vend = xxcn_vend
              mytempcn_part = xxcn_part
              mytempcn_perd = string(xxcn_year) + STRING(xxcn_month) /*耗用周期*/
              mytempcn_qty6 = xxcn_qty_rcv /*挂帐数*/
              mytempcn_qty7 = xxcn_cost.
              mytempcn_qty8 = mytempcn_qty6 * mytempcn_qty7 . /*金额= 单价 * 挂帐数*/
              mytempcn_ch3  = xxcn_ch3. /*挂帐方式*/

       IF mytempcn_ch3 = 'U' THEN /*耗用挂*/
           SET mytempcn_qty2 = xxcn_qty_con  .
       IF mytempcn_ch3 = 'I' THEN /*入库挂*/
           SET mytempcn_qty2 = xxcn_dec5 - xxcn_dec6 .
       IF mytempcn_ch3 = 'C' THEN /*现金挂*/
           SET mytempcn_qty2 = xxcn_dec5 - xxcn_dec6 .
  END. /*FOR EACH xxcnbuf NO-LOCK WHERE */
end.                  
/*        
output to value(myfilett) append.
put 333 today time skip.
output close.
*/
for each mytempcn_mstr:
  create xxtempcn_mstr.     
  xxtempcn_vend = mytempcn_vend  .
  xxtempcn_part = mytempcn_part  .
  xxtempcn_qty1 = mytempcn_qty1  .
  xxtempcn_qty2 = mytempcn_qty2  .
  xxtempcn_perd = mytempcn_perd  .
  xxtempcn_qty3 = mytempcn_qty3  .
  xxtempcn_qty4 = mytempcn_qty4  .
  xxtempcn_qty5 = mytempcn_qty5  .
  xxtempcn_qty6 = mytempcn_qty6  .
  xxtempcn_qty7 = mytempcn_qty7  .
  xxtempcn_qty8 = mytempcn_qty8  .
  xxtempcn_ch3  = mytempcn_ch3   .
  xxtempcn_ch4  = mytempcn_ch4   . 
end.
/*还要找之前月份有末挂帐数据，但是用户选择的当前挂帐期间无挂帐数据*/

 FOR EACH xxcn_mstr use-index xxcn_vend_part NO-LOCK WHERE xxcn_mstr.xxcn_domain =  global_domain 
                       and   xxcn_mstr.xxcn_vend >= vend AND xxcn_mstr.xxcn_vend <= vend1 
                       AND xxcn_mstr.xxcn_part >= part AND xxcn_mstr.xxcn_part <= part1
                       AND (xxcn_mstr.xxcn_year < xxyy OR ( xxcn_mstr.xxcn_year = xxyy AND xxcn_mstr.xxcn_month < xxmm))
                       AND xxcn_mstr.xxcn_po_stat <> "2"  /*只列取末挂帐部分*/
                       AND xxcn_mstr.xxcn_qty_rcv <> 0
                      AND xxcn_mstr.xxcn_site >= site AND xxcn_mstr.xxcn_site <= site1 BREAK BY xxcn_mstr.xxcn_vend BY xxcn_mstr.xxcn_part :
     
     FIND FIRST vd_mstr NO-LOCK USE-INDEX vd_addr WHERE vd_domain = GLOBAL_domain and vd_addr = xxcn_mstr.xxcn_vend AND ( vd_type = 'U' OR vd_type = 'I' OR vd_type = 'C' )  NO-ERROR.  /*只提取按入库/耗用挂帐的供应商*/
     IF NOT AVAIL vd_mstr THEN
         NEXT.

     FIND FIRST xxtempcn_mstr NO-LOCK WHERE xxtempcn_vend = xxcn_mstr.xxcn_vend AND xxtempcn_part = xxcn_mstr.xxcn_part AND xxtempcn_perd = STRING(xxyy) + STRING(xxmm) NO-ERROR.
     IF NOT AVAIL xxtempcn_mstr THEN DO:
         CREATE xxtempcn_mstr.
         ASSIGN xxtempcn_vend = xxcn_mstr.xxcn_vend
                xxtempcn_part = xxcn_mstr.xxcn_part
                xxtempcn_perd = string(xxcn_mstr.xxcn_year) + STRING(xxcn_mstr.xxcn_month) /*耗用周期*/
                xxtempcn_qty6 = xxcn_mstr.xxcn_qty_rcv /*挂帐数*/
                xxtempcn_qty7 = xxcn_mstr.xxcn_cost
                xxtempcn_qty8 = xxtempcn_qty6 * xxtempcn_qty7 /*金额= 单价 * 挂帐数*/
                xxtempcn_ch3 = xxcn_mstr.xxcn_ch3. /*挂帐方式*/
                /*
                xxtempcn_ch4 = xxcn_mstr.xxcn_ch4.     /*暂估价或无价*/
                */
         IF xxtempcn_ch3 = 'U' THEN         /*耗用挂*/
             SET xxtempcn_qty2 = xxcn_mstr.xxcn_qty_con .
         IF xxtempcn_ch3 = 'I' THEN         /*入库挂*/
             SET xxtempcn_qty2 = xxcn_mstr.xxcn_dec5 - xxcn_mstr.xxcn_dec6 .
         IF xxtempcn_ch3 = 'C' THEN         /*现金挂*/
             SET xxtempcn_qty2 = xxcn_mstr.xxcn_dec5 - xxcn_mstr.xxcn_dec6 . 
     END. /*IF NOT AVAIL xxtempcn_mstr THEN*/
 END. /*FOR EACH xxcn_mstr NO-LOCK WHERE xxcn_domain =  global_domain */

   SET xxs1 = STRING(xxd1) + '--' + STRING(xxd2).

   FOR EACH xxtempcn_mstr NO-LOCK BREAK BY xxtempcn_vend BY xxtempcn_part BY xxtempcn_perd DESC:

       ACCUMULATE xxtempcn_qty1 (TOTAL BY xxtempcn_vend).
       ACCUMULATE xxtempcn_qty3 (TOTAL BY xxtempcn_vend).
       ACCUMULATE xxtempcn_qty4 (TOTAL BY xxtempcn_vend).
       ACCUMULATE xxtempcn_qty5 (TOTAL BY xxtempcn_vend).
       ACCUMULATE xxtempcn_qty6 (TOTAL BY xxtempcn_vend).
       ACCUMULATE xxtempcn_qty8 (TOTAL BY xxtempcn_vend).
       IF FIRST-OF (xxtempcn_vend) THEN
       DO:
           ASSIGN xxs6 = xxtempcn_vend.
           FIND FIRST vd_mstr NO-LOCK USE-INDEX vd_addr WHERE vd_domain = GLOBAL_domain and vd_addr = xxtempcn_vend  NO-ERROR.
           IF xxtempcn_ch3 = 'U' THEN
               SET xxs3 = '耗用挂'.
           ELSE if xxtempcn_ch3 = 'I' then 
               SET xxs3 = '入库挂'.
           ELSE if xxtempcn_ch3 = 'C' then 
               SET xxs3 = '现金挂'.
           SET xxs4 = vd_sort.
           VIEW FRAME t.
      END. /* IF FIRST-OF (xxtempcn_vend) THEN*/

       if first-of(xxtempcn_vend) then do:
         xxmysum1 = 0.
         xxmysum2 = 0.
         xxmysum3 = 0.
         xxmysum4 = 0.
         xxmysum5 = 0.
         xxmysum6 = 0.         
       end.
         xxmysum1 = xxmysum1 + xxtempcn_qty1.
         xxmysum2 = xxmysum2 + xxtempcn_qty3.
         xxmysum3 = xxmysum3 + xxtempcn_qty4.
         xxmysum4 = xxmysum4 + xxtempcn_qty5.
         xxmysum5 = xxmysum5 + xxtempcn_qty6.
         xxmysum6 = xxmysum6 + xxtempcn_qty8.
       if first-of(xxtempcn_part) THEN
       DO:
            FIND FIRST pt_mstr NO-LOCK USE-INDEX pt_part WHERE  pt_domain = GLOBAL_domain and pt_part = xxtempcn_part NO-ERROR.
            SET xxs5 = pt_desc1.
       END.
          

 
       	    /*modify by billy 2011-05-23 去掉挂账数为0的，也就是前期无耗用的部分*/
       	    if xxtempcn_qty1 <> 0 or xxtempcn_qty2 <> 0 or xxtempcn_qty3 <> 0 or xxtempcn_qty4 <> 0 or xxtempcn_qty5 <> 0 or xxtempcn_qty6 <> 0 then
       	    	do:  
       	    	 if xxtempcn_perd <> string(xxyy) + string(xxmm) then do:

		            DISP 
		              xxs5 @ pt_desc1 
		              xxtempcn_part @ xxcn_mstr.xxcn_part
		              xxtempcn_qty1 @ xxcn_mstr.xxcn_qty_fir_oh 
		              xxtempcn_qty2 @ xxcn_mstr.xxcn_qty_inv_fir 
		              xxtempcn_qty3 @ xxcn_mstr.xxcn_dec5
		              xxtempcn_qty4 @ xxcn_mstr.xxcn_dec6
		              xxtempcn_qty5 @ xxcn_mstr.xxcn_qty_inv
		              xxtempcn_perd @ xxs2 
		              xxtempcn_qty6 @ xxcn_mstr.xxcn_qty_rcv 
		              xxtempcn_qty7 @ xxcn_mstr.xxcn_cost 
		              xxtempcn_qty8 @ xxcn_mstr.xxcn_dec3 
		            WITH FRAME C.
		            DOWN WITH FRAME C.
		           end. 
		           if xxtempcn_perd = string(xxyy) + string(xxmm) then do:
		            DISP 
		              xxs5 @ pt_desc1 
		              xxtempcn_part @ xxcn_mstr.xxcn_part
		              xxtempcn_qty1 @ xxcn_mstr.xxcn_qty_fir_oh 
		               
		              xxtempcn_qty3 @ xxcn_mstr.xxcn_dec5
		              xxtempcn_qty4 @ xxcn_mstr.xxcn_dec6
		              xxtempcn_qty5 @ xxcn_mstr.xxcn_qty_inv
		              
		              xxtempcn_qty6 @ xxcn_mstr.xxcn_qty_rcv 
		              xxtempcn_qty7 @ xxcn_mstr.xxcn_cost 
		              xxtempcn_qty8 @ xxcn_mstr.xxcn_dec3 
		            WITH FRAME C.
		            DOWN WITH FRAME C.
		           end. 
		          end. /* if xxtempcn_qty1 <> 0 or xxtempcn_qty2 <> 0 or xxtempcn_qty3 <> 0 */
           
       IF LAST-OF( xxtempcn_vend ) THEN
       DO:
          DISP '   合计：' @ xxcn_mstr.xxcn_part 
             xxmysum1  @ xxcn_mstr.xxcn_qty_fir_oh
             xxmysum2  @ xxcn_mstr.xxcn_dec5
             xxmysum3  @ xxcn_mstr.xxcn_dec6
             xxmysum4  @ xxcn_mstr.xxcn_qty_inv
             xxmysum5  @ xxcn_mstr.xxcn_qty_rcv
             xxmysum6  @ xxcn_mstr.xxcn_dec3 WITH FRAME C.
          DOWN WITH FRAME C.
          put skip.
          put "供应商签字:".
          IF NOT LAST( xxtempcn_vend ) THEN
              PAGE.
       END. /*IF LAST-OF( xxtempcn_vend ) THEN*/

       IF   page-size - LINE-COUNTER < 5 THEN 
          PAGE.

   END. /*FOR EACH xxtempcn_mstr NO-LOCK:*/

  {mfreset.i}
  {mfgrptrm.i}

   SET xxyn = NO.
   MESSAGE '是否确认下达该挂帐单?' UPDATE xxyn.
   DO TRANS ON ERROR UNDO,RETRY:
   IF xxyn = YES THEN DO:
        FOR EACH xxtempcn_mstr NO-LOCK WHERE xxtempcn_qty6 <> 0 AND xxtempcn_qty7 <> 0: /*只反写该挂帐数量不为0,且有价格的数据*/
            FIND FIRST xxcn_mstr WHERE xxcn_domain = GLOBAL_domain AND xxcn_vend = xxtempcn_vend AND xxcn_part = xxtempcn_part 
                                   AND xxcn_year = int(SUBSTRING(xxtempcn_perd , 1 , 4)) AND xxcn_month = int(SUBSTRING(xxtempcn_perd , 5 , LENGTH(trim(STRING(xxtempcn_perd))) - 4 ))
                                   AND xxcn_po_stat = "" NO-ERROR.
            IF AVAIL xxcn_mstr THEN
            DO:
          	
                ASSIGN xxcn_po_stat = '2'
                       xxcn_ch1 = trim(string(xxyy)) +  trim(STRING(xxmm))
                       /*
                       xxcn_cost = xxtempcn_qty7
                       xxcn_ch3 = xxtempcn_ch3.  /*挂帐方式*/
                       */
                       xxcn_ch4 = string(xxyy).
                       xxcn_ch5 = string(xxmm,"99").
            END. /*IF AVAIL xxcn_mstr THEN*/
        END. /*FOR EACH xxtempcn_mstr NO-LOCK WHERE xxtempcn_qty6 <> 0:*/
   END. /*IF xxyn = YES THEN*/
   END. /*DO TRANS ON ERROR UNDO,RETRY:*/


END.



