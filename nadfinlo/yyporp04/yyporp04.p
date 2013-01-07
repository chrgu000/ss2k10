/* yyporp04.p - 设备组费用分类报表                                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* REVISION: eb2sp4     Create By: Micho Yang        ECO: NAD - 20110428.1    */


/* NAD - 20110428.1 - B */
/*
1. 统计每月设备维修类别明细.
2. 默认单价取含税单价
3. 默认只统计已收货采购单数量
*/
/* NAD - 20110428.1 - E */


/*ss - 131007.1                                                   *ECO:*1317* 
 * fix bug   ** The month of a date must be from 1 to 12. (80)  
**/


{mfdtitle.i "130107.1"}

define variable site   like po_site.
define variable site1  like po_site.
define variable rtype  like op_part.
define variable rtype1 like op_part.
define variable mon1 as integer format ">9".
define variable yr1 like cph_year.
define variable eff    as date.
define variable eff1   as date.
define variable disp_taxin as logical initial YES label "含税".
define variable disp_trin  as logical initial NO label "是否包括未收货数量".
define variable disp_rmks  as logical INITIAL YES.
define variable base_rpt   like po_curr no-undo.
define variable req_id   like po_req_id INIT "REP" LABEL "申请部门" .

DEFINE VARIABLE v_month as deci format "->>>>>>>>9" EXTENT 12.
DEFINE VARIABLE v_month1 as deci format "->>>>>>>>9" EXTENT 12.
DEFINE VARIABLE v_flag AS CHAR.
DEFINE VARIABLE v_qty LIKE pod_qty_rcvd.
DEFINE VARIABLE base_cost LIKE pod_pur_cost.
DEFINE VARIABLE v_name AS CHAR.
DEFINE VARIABLE v_month_tot AS DECIMAL FORMAT "->>>>>>>>9".
DEFINE VARIABLE v_month1_tot AS DECIMAL FORMAT "->>>>>>>>9".
DEFINE VARIABLE i AS INTEGER .

define variable mc-error-number like msg_nbr no-undo.
{gprunpdf.i "mcpl" "p"}

form
   site                colon 15
   site1               label {t001.i} colon 49 
   rtype               colon 15
   rtype1              label {t001.i} colon 49 
   skip (1)

   req_id              COLON 35
   mon1                colon 35 label "结束周期"
         validate (mon1 <= 12,getTermLabel("INVALID_MONTH",25)) skip
   yr1                 colon 35 label "截止财政年度" skip
   
   disp_trin           colon 35 SKIP 
   disp_taxin          colon 35 skip
   base_rpt            COLON 35 SKIP
   disp_rmks           colon 35 skip (1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
{wbrp01.i}

form header
   getTermLabel("项目类别",20)    format "x(20)"  at 1 
   getTermLabel("1月",10)        format "x(10)" at 31 
   getTermLabel("2月",10)        format "x(10)" at 42 
   getTermLabel("3月",10)        format "x(10)" at 53
   getTermLabel("4月",10)        format "x(10)" at 64 
   getTermLabel("5月",10)        format "x(10)" at 75 
   getTermLabel("6月",10)        format "x(10)" at 86
   getTermLabel("7月",10)        format "x(10)" at 97
   getTermLabel("8月",10)        format "x(10)" at 108
   getTermLabel("9月",10)        format "x(10)" at 119
   getTermLabel("10月",10)       format "x(10)" at 129
   getTermLabel("11月",10)       format "x(10)" at 140
   getTermLabel("12月",10)       format "x(4)"  at 151 
   getTermLabel("全年合计",8)    format "x(8)"  at 158 skip   
   "--------------------"   at 1  
   "----------" at 24 
   "----------" at 35 
   "----------" at 46 
   "----------" at 57 
   "----------" at 68 
   "----------" at 79 
   "----------" at 90 
   "----------" at 101
   "----------" at 112
   "----------" at 123
   "----------" at 134
   "----------" at 145
   "----------" at 156
with frame phead1 page-top width 300.

IF MONTH(TODAY) = 1 THEN DO:
   mon1 = 12.
   yr1 = YEAR(TODAY) - 1.
END.
ELSE DO:
   mon1 = MONTH(TODAY) - 1 .
   yr1 = YEAR(TODAY).
END.

repeat:
   if site1  = hi_char then  site1  = "".
   if rtype1 = hi_char then  rtype1 = "".
   
   update 
      site site1 rtype rtype1 req_id mon1 yr1 disp_trin disp_taxin base_rpt disp_rmks 
   with frame a.
   {wbrp06.i &command = update &fields = "site site1 rtype rtype1 req_id mon1 yr1 
      disp_trin disp_taxin base_rpt disp_rmks" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i site       }
      {mfquoter.i site1      }
      {mfquoter.i rtype      }
      {mfquoter.i rtype1     }

      {mfquoter.i req_id     }
      {mfquoter.i mon1  }
      {mfquoter.i yr1  }
      {mfquoter.i disp_trin  }
      {mfquoter.i disp_taxin }
      {mfquoter.i base_rpt   }
      {mfquoter.i disp_rmks  }
           
      if site1  = "" THEN site1 = hi_char.
      if rtype1  = "" then rtype1 = hi_char.

   end.

   /* SELECT PRINTER */
   {mfselbpr.i "printer" 132}
   {mfphead.i} 

   VIEW FRAME phead1.

   eff = DATE(1,1,yr1).
   IF mon1 = 12 THEN DO:
      eff1 = DATE(1,1,yr1 + 1) - 1.
   END.
/*1317*/  ELSE DO:
   		eff1 = DATE(mon1 + 1,1,yr1) - 1.
/*1317*/  END.
   v_month1 = 0.
   v_month1_tot = 0.
   FOR EACH po_mstr NO-LOCK 
      WHERE po_ord_date >= eff
      AND po_ord_date <= eff1
      AND (po_curr = base_rpt OR base_rpt = "")
      AND po_type <> "B"  
      AND (po_req_id = req_id OR req_id = "") ,
      EACH pod_det NO-LOCK
      WHERE pod_nbr = po_nbr
      AND NOT pod_sched
      AND pod_so_job <> ""
      AND LENGTH(pod_so_job) = 2
      AND pod_site >= site
      AND pod_site <= site1
      AND pod_so_job >= rtype
      AND pod_so_job <= rtype1
      BREAK BY pod_so_job BY MONTH(po_ord_date) 
      WITH FRAME b:

      IF FIRST-OF(pod_so_job) THEN do:
         v_month = 0. 
         v_month_tot = 0.
         IF SUBSTRING(pod_so_job,1,1) = "1" THEN v_flag = "1".

         IF v_flag <> SUBSTRING(pod_so_job,1,1) AND v_flag = "1" THEN DO:
            v_flag = SUBSTRING(pod_so_job,1,1).

            put fill("_",165) format "x(165)" at 1 skip.
            put "吹塑小计"  format  "x(22)".
            put v_month1[1] at  24.
            put v_month1[2] at  35.
            put v_month1[3] at  46.
            put v_month1[4] at  57.
            put v_month1[5] at  68.
            put v_month1[6] at  79.
            put v_month1[7] at  90.
            put v_month1[8] at  101.
            put v_month1[9] at  112.
            put v_month1[10] at 123.
            put v_month1[11] at 134.
            put v_month1[12] at 145.
            put v_month1_tot at 156 skip(1).
         END.
      END.

      v_qty = 0.
      IF disp_trin = NO THEN v_qty = pod_qty_rcvd.
      ELSE v_qty = pod_qty_ord.

      base_cost = pod_pur_cost.
      if base_curr <> po_curr and base_rpt = "" then do:
         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input po_curr,
              input base_curr,
              input po_ex_rate,
              input po_ex_rate2,
              input base_cost,
              input false, /* DO NOT ROUND */
              output base_cost,
              output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {mfmsg.i mc-error-number 2}
         end.
      end.

      if disp_taxin = yes then do:
         if pod_taxable = yes and pod_tax_in = no then do:
            base_cost = base_cost * (if (pod_taxc = "IN" or pod_taxc = "OU") then 1.0 else ( 1.0 + integer(pod_taxc) / 100)).
         end.  /*if pod_taxable = yes and*/
      end. /*if disp_taxin = yes*/  

      v_month[MONTH(po_ord_date)] = v_month[MONTH(po_ord_date)] + v_qty * base_cost.

      IF LAST-OF(pod_so_job) THEN DO:
         CASE pod_so_job:
            WHEN "11" THEN
            v_name =  "11:主设备正常维修费:". 
            WHEN "12" THEN
            v_name =  "12:主设备非正常维修费:". 
            WHEN "13" THEN
            v_name =  "13:附加设备正常维修费:". 
            WHEN "14" THEN
            v_name =  "14:附加设备非正常维修费:". 
            WHEN "15" THEN
            v_name =  "15:设备外发维修费:". 
            WHEN "20" THEN
            v_name =  "20:非生产设备维修费:". 
            WHEN "30" THEN
            v_name =  "30:设备及厂房安装费:". 
            WHEN "40" THEN
            v_name =  "40:设备技术改良费:". 
            WHEN "50" THEN
            v_name =  "50:办公用品及劳保品费:". 
            WHEN "60" THEN
            v_name =  "60:保养费用:". 
            WHEN "70" THEN
            v_name = "70:购买设备费用:". 
         END CASE.  

         DO i = 1 TO 12:
            v_month_tot = v_month_tot + v_month[i] .

            v_month1[i] = v_month1[i] + v_month[i] .
            v_month1_tot = v_month1_tot + v_month[i] .
         END.

         display
            v_name format  "x(22)"
            v_month[1] at  24
            v_month[2] at  35
            v_month[3] at  46
            v_month[4] at  57
            v_month[5] at  68
            v_month[6] at  79
            v_month[7] at  90
            v_month[8] at  101
            v_month[9] at  112
            v_month[10] at 123
            v_month[11] at 134
            v_month[12] at 145
            v_month_tot  at 156
         with frame b no-label no-box width 300.
      END.

      IF LAST(pod_so_job) THEN DO:
         put fill("_",165) format "x(165)" at 1 skip.
         put "报表合计"  format  "x(22)".
         put v_month1[1] at  24.
         put v_month1[2] at  35.
         put v_month1[3] at  46.
         put v_month1[4] at  57.
         put v_month1[5] at  68.
         put v_month1[6] at  79.
         put v_month1[7] at  90.
         put v_month1[8] at  101.
         put v_month1[9] at  112.
         put v_month1[10] at 123.
         put v_month1[11] at 134.
         put v_month1[12] at 145.
         put v_month1_tot at 156 skip(1).

         put "1、正常维修项目-指配件因使用日久，达到设计寿命而磨损需更换的项目。" at 1 skip.
         put "2、非正常维修项目-指配件未达设计寿命而损坏的项目。" at 1 skip.
         put "3、报表金额一律为本位币计算。" at 1 skip.
      END.
       
      {mfrpchk.i}
   END. /* FOR EACH po_mstr NO-LOCK  */

   if disp_rmks then do:
      put skip(1).
      put "报表主要栏位计算公式或说明:" at 1 skip.
      put "1:报表类型字段取自5.7维护的(客户单/工作);" at 5 skip.
      put "2:代码为2位纯数字编码;" at 5 skip.
      put "3:10代表吹塑设备，按明细分为11,12,13,14,15;" at 5 skip.
      put "4:20,30.40.50.60.70分别代表不同的维修类别;" at 5 skip.
      put "5:每笔费用 = 采购单单价 * 采购单数量" at 5 skip.
      /*put "7:每月金额是已收货的含税金额(人民币)." at 5 skip.*/
   end.  /*if disp_rmks*/

   /* REPORT TRAILER */
   {mfrtrail.i}
end.
{wbrp04.i &frame-spec = a}
