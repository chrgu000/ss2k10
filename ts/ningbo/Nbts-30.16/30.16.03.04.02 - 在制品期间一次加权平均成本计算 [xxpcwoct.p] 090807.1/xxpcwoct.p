/* glcalrp.p - GENERAL LEDGER CALENDAR REPORT                           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9 $                                                     */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 1.0      LAST MODIFIED: 09/18/86   BY: JMS                 */
/*                                   01/29/88   by: jms                 */
/*                                   02/24/88   by: jms                 */
/* REVISION: 4.0      LAST MODIFIED: 02/29/88   BY: WUG  *A175*         */
/* REVISION: 5.0      LAST MODIFIED: 06/22/89   BY: JMS  *B066*         */
/* REVISION: 6.0      LAST MODIFIED: 07/03/90   by: jms  *D034*         */
/* REVISION: 7.0      LAST MODIFIED: 10/04/91   by: jms  *F058*         */
/* REVISION: 7.4      LAST MODIFIED: 07/20/93   by: pcd  *H040*         */
/*                                   09/03/94   by: srk  *FQ80*         */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   BY: ays  *K0TT*         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.7  BY: Katie Hilbert DATE: 08/03/01 ECO: *P01C* */
/* $Revision: 1.9 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 090807.1 By: Bill Jiang */

/* SS - 090807.1 - RNB
[090807.1]
             
             期初成本 + 期间增加成本(含领料,见上面的2,3和6)
1.期间均成 = -----------------------------------------------
             期初数量 + 期间增加数量 - 不计成本的期间报废数量

2.期末成本 = <加工单增减存主文件>.期末数量 * 期间均成

平均成本区别以下两种情况计算:
1) 计算报废成本: 平均成本 = (期初总成 + 期间下达总成) / (期初数量 + 期间下达数量)
2) 不计报废成本:
2.1) 期初数量 + 期间下达数量 = 期间报废数量: 平均成本 = (期初总成 + 期间下达总成) / (期初数量 + 期间下达数量)
2.2) 期初数量 + 期间下达数量 <> 期间报废数量:平均成本 = (期初总成 + 期间下达总成) / (期初数量 + 期间下达数量 - 期间报废数量)
以上两种情况可以统一为: 平均成本 = (期初总成 + 期间下达总成) / (期初数量 + 期间下达数量 - 不计成本的期间报废数量)

如果"期初数量 + 期间下达数量 = 期间报废数量"(即全部报废),则不管如何设置,必须计算报废成本:
如上,一般公式如下:
期初成本 + 下达成本 = 入库成本 + 报废成本 + 期末成本
其中,报废成本仅在以下两种情况下不为零:
1) 计算报废成本,且报废数量不为零
2) 不计算报废成本,但"期初数量 + 期间下达数量 = 期间报废数量"(即全部报废)

[090807.1]

SS - 090807.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "090807.1"}

define variable per like glc_per.
define variable yr like glc_year.
define variable entity like glcd_entity.
DEFINE VARIABLE date1 AS DATE.
DEFINE VARIABLE find-can AS LOGICAL.
define variable l_yn        like mfc_logical             no-undo.
DEFINE VARIABLE qty0 AS DECIMAL.
DEFINE VARIABLE qty1 AS DECIMAL.

DEFINE VARIABLE continue AS LOGICAL NO-UNDO.

{glcabmeg.i} /* module closing engine include. */

/* SELECT FORM */
form
   entity colon 20    
   en_name NO-LABEL
   yr     colon 20    
   per     colon 20    
   skip
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

date1 = DATE(MONTH(TODAY),1,YEAR(TODAY)) - 1.
FIND FIRST glc_cal 
   WHERE glc_domain = GLOBAL_domain
   AND glc_start <= date1
   AND glc_end >= date1
   NO-LOCK NO-ERROR.
IF AVAILABLE glc_cal THEN DO:
   yr = glc_year.
   per = glc_per.
END.

{wbrp01.i}

/* REPORT BLOCK */
mainloop:
repeat:
   if c-application-mode <> 'web' then
      update
         entity 
         yr 
         per
      with frame a.

   {wbrp06.i &command = update &fields = "  entity yr per" &frm = "a"}
      
   FIND FIRST en_mstr 
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      NO-LOCK NO-ERROR.
   IF AVAILABLE en_mstr THEN DO:
      DISPLAY
         en_name
         WITH FRAME a.
   END.
   ELSE DO:
      DISPLAY
         "" @ en_name
         WITH FRAME a.
   END.

   {xxSoftspeedLic.i "SoftspeedPC.lic" "SoftspeedPC"}

   {gprun.i ""xxpcincpv.p"" "(
      INPUT entity,
      INPUT yr,
      INPUT per
      )"}
   IF RETURN-VALUE = "no" THEN DO:
      UNDO,RETRY.
   END.

   /* 已经创建 */
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpcwoc_det NO-LOCK
      WHERE xxpcwoc_domain = GLOBAL_domain
      AND xxpcwoc_site = si_site
      AND xxpcwoc_year = yr
      AND xxpcwoc_per = per
      AND (xxpcwoc_cst_tot <> 0 OR xxpcwoc_end <> 0)
      :
      /* 301606 - 记录已经存在.是否继续? */
      {pxmsg.i &MSGNUM=301606 &ERRORLEVEL=2 &CONFIRM=l_yn}

      if not l_yn then do:
         next-prompt per.
         UNDO mainloop, retry.
      end. /* IF NOT l_yn */

      LEAVE.
   END.

   continue = YES.
   DO TRANSACTION ON STOP UNDO:
      /* 清除 */
      FOR EACH en_mstr NO-LOCK
         WHERE en_domain = GLOBAL_domain
         AND en_entity = entity
         ,EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = en_entity
         ,EACH xxpcwoc_det exclusive-LOCK
         WHERE xxpcwoc_domain = GLOBAL_domain
         AND xxpcwoc_site = si_site
         AND xxpcwoc_year = yr
         AND xxpcwoc_per = per
         :
         ASSIGN
            xxpcwoc_cst_tot = 0
            xxpcwoc_end = 0
            .
      END.

      /* 更新 */
      FOR EACH en_mstr NO-LOCK
         WHERE en_domain = GLOBAL_domain
         AND en_entity = entity
         ,EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = en_entity
         ,EACH xxpcwoc_det exclusive-LOCK
         WHERE xxpcwoc_domain = GLOBAL_domain
         AND xxpcwoc_site = si_site
         AND xxpcwoc_year = yr
         AND xxpcwoc_per = per
         BREAK 
         BY xxpcwoc_site
         BY xxpcwoc_part
         BY xxpcwoc_lot
         :
         IF FIRST-OF(xxpcwoc_lot) THEN DO:
            qty0 = 0.
            qty1 = 0.

            FOR EACH xxpcwo_mstr NO-LOCK
               WHERE xxpcwo_domain = GLOBAL_domain
               AND xxpcwo_site = xxpcwoc_site
               AND xxpcwo_year = yr
               AND xxpcwo_per = per
               AND xxpcwo_part = xxpcwoc_part
               AND xxpcwo_lot = xxpcwoc_lot
               :
               qty0 = qty0 + xxpcwo_qty_beg + xxpcwo_qty_ord - xxpcwo_qty_rjct0.
               qty1 = qty1 + xxpcwo_qty_end.
            END.
         END.

         IF (xxpcwoc_beg + xxpcwoc_rct + xxpcwoc_rct_wo) = 0 THEN DO:
            ASSIGN
               xxpcwoc_cst_tot = 0
               xxpcwoc_end = xxpcwoc_cst_tot * qty1
               .
         END.
         ELSE DO:
            IF qty0 = 0 THEN DO:
               /*
               /* 301610 - 期初数量+期间增加数量-期间不计成本报废数量=0:零件[#],加工单[#] */
               {pxmsg.i &MSGNUM=301610 &ERRORLEVEL=3 &MSGARG1=xxpcwoc_part &MSGARG2=xxpcwoc_lot}

               continue = NO.
               STOP.
               */

               ASSIGN
                  xxpcwoc_cst_tot = 0
                  xxpcwoc_end = xxpcwoc_cst_tot * qty1
                  .
               NEXT.
            END.

            ASSIGN
               xxpcwoc_cst_tot = (xxpcwoc_beg + xxpcwoc_rct + xxpcwoc_rct_wo) / qty0
               xxpcwoc_end = xxpcwoc_cst_tot * qty1
               .
         END.
      END. /* FOR EACH en_mstr NO-LOCK */
   END. /* DO TRANSACTION ON STOP UNDO: */
   IF continue = NO THEN DO:
      next-prompt per.
      UNDO mainloop, RETRY mainloop.
   END.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {mfquoter.i entity }
      {mfquoter.i yr     }
      {mfquoter.i per     }
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   EXPORT DELIMITER ";" 
      "地点"
      "年份"
      "期间"
      "零件"
      "工单"
      "成本要素"
      "期间一次加权平均成本"
      "期末总成"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpcwoc_det NO-LOCK
      WHERE xxpcwoc_domain = GLOBAL_domain
      AND xxpcwoc_site = si_site
      AND xxpcwoc_year = yr
      AND xxpcwoc_per = per
      BY xxpcwoc_site
      BY xxpcwoc_year
      BY xxpcwoc_per
      BY xxpcwoc_part
      BY xxpcwoc_lot
      BY xxpcwoc_element
      :
      EXPORT DELIMITER ";"
         xxpcwoc_site
         xxpcwoc_year
         xxpcwoc_per
         xxpcwoc_part
         xxpcwoc_lot
         xxpcwoc_element
         xxpcwoc_cst_tot
         xxpcwoc_end
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
