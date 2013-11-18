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

/* SS - 090607.1 By: Bill Jiang */

/* SS - 090607.1 - RNB
[090607.1]

1.次优: 期间不计成本报废数量 = <不计成本的库存事务类型主文件维护>
2.优先: IF 期初数量 + 期间增加数量 = 期间报废数量 THEN 期间不计成本报废数量 = 0
3.期间报废数量 = 期间不计成本报废数量 + 期间计算成本报废数量

错误:总账日历没维护,总账日历已结,上期未结,本期已结!

[090607.1]

SS - 090607.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "090607.1"}

define variable per like glc_per.
define variable yr like glc_year.
define variable entity like glcd_entity.

DEFINE VARIABLE date1 AS DATE.
define variable l_yn        like mfc_logical             no-undo.

define variable efdate like tr_effdate.
define variable efdate1 like tr_date.

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

   {gprun.i ""xxpcprhcv.p"" "(
      INPUT entity,
      INPUT yr,
      INPUT per,
      INPUT-OUTPUT efdate,
      INPUT-OUTPUT efdate1
      )"}
   IF RETURN-VALUE = "no" THEN DO:
      UNDO,RETRY.
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

   {xxSoftspeedLic.i "SoftspeedPC.lic" "SoftspeedPC"}

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

   DO TRANSACTION ON STOP UNDO:
      /* 1.次优: 期间不计成本报废数量 = <不计成本的库存事务类型主文件维护> */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxpcwo_mstr EXCLUSIVE-LOCK
         WHERE xxpcwo_domain = GLOBAL_domain
         AND xxpcwo_site = si_site
         AND xxpcwo_year = yr
         AND xxpcwo_per = per
         ,EACH pt_mstr NO-LOCK
         WHERE pt_domain = GLOBAL_domain
         AND pt_part = xxpcwo_part
         :
         IF xxpcwo_qty_rjct = 0 THEN DO:
            ASSIGN
               xxpcwo_qty_rjct0 = 0
               xxpcwo_qty_rjct1 = 0
               .

            NEXT.
         END.

         l_yn = NO.
         FOR EACH xxpctt NO-LOCK
            WHERE xxpctt_domain = GLOBAL_domain
            AND (xxpctt_site = si_site OR xxpctt_site = '')
            AND (xxpctt_start <= TODAY OR xxpctt_start = ?)
            AND (xxpctt_prod_line = pt_prod_line OR xxpctt_prod_line = '')
            AND (xxpctt_type = 'RJCT-WO' OR xxpctt_type = '')
            AND (xxpctt_expire >= TODAY OR xxpctt_expire = ?)
            BY xxpctt_site DESC
            BY xxpctt_prod_line DESC
            BY xxpctt_type DESC
            :
            /* 计算成本 */
            IF xxpctt_cost = 0 THEN DO:
               ASSIGN
                  xxpcwo_qty_rjct0 = 0
                  xxpcwo_qty_rjct1 = xxpcwo_qty_rjct
                  .

               l_yn = YES.
               NEXT.
            END.
            /* 不计成本 */
            ELSE IF xxpctt_cost = 1 THEN DO:
               ASSIGN
                  xxpcwo_qty_rjct0 = xxpcwo_qty_rjct
                  xxpcwo_qty_rjct1 = 0
                  .

               l_yn = YES.
               NEXT.
            END.
         END.
         IF l_yn = NO THEN DO:
            /* 301608 - <不计成本的库存事务类型主文件>记录不存在 */
            {pxmsg.i &MSGNUM=301608 &ERRORLEVEL=3}
            next-prompt per.
            UNDO mainloop, retry.
      
            STOP.
         END.
      END. /* FOR EACH si_mstr NO-LOCK */

      /* 2.优先: IF 期初数量 + 期间增加数量 = 期间报废数量 THEN 期间不计成本报废数量 = 0 */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxpcwo_mstr EXCLUSIVE-LOCK
         WHERE xxpcwo_domain = GLOBAL_domain
         AND xxpcwo_site = si_site
         AND xxpcwo_year = yr
         AND xxpcwo_per = per
         :
         IF xxpcwo_qty_rjct = 0 THEN DO:
            NEXT.
         END.

         IF xxpcwo_qty_beg + xxpcwo_qty_ord = xxpcwo_qty_rjct THEN DO:
            ASSIGN
               xxpcwo_qty_rjct0 = 0
               xxpcwo_qty_rjct1 = xxpcwo_qty_rjct
               .

            NEXT.
         END.
      END. /* FOR EACH si_mstr NO-LOCK */
   END. /* DO TRANSACTION ON STOP UNDO: */

   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   EXPORT DELIMITER ";" 
      "地点"
      "年份"
      "期间"
      "父件"
      "父名"
      "工单"
      "期初"
      "下达"
      "入库"
      "报废"
      "期末"
      "期间不计成本报废数量"
      "期间计算成本报废数量"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpcwo_mstr NO-LOCK
      WHERE xxpcwo_domain = GLOBAL_domain
      AND xxpcwo_site = si_site
      AND xxpcwo_year = yr
      AND xxpcwo_per = per
      ,EACH pt_mstr NO-LOCK
      WHERE pt_domain = GLOBAL_domain
      AND pt_part = xxpcwo_part
      BY xxpcwo_site
      BY xxpcwo_year
      BY xxpcwo_per
      BY xxpcwo_part
      BY xxpcwo_lot
      :
      EXPORT DELIMITER ";"
         xxpcwo_site
         xxpcwo_year
         xxpcwo_per
         xxpcwo_part
         (pt_desc1 + " " + pt_desc2)
         xxpcwo_lot
         xxpcwo_qty_beg
         xxpcwo_qty_ord
         xxpcwo_qty_comp
         xxpcwo_qty_rjct
         xxpcwo_qty_end
         xxpcwo_qty_rjct0
         xxpcwo_qty_rjct1
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
