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

/* SS - 091111.1 By: Bill Jiang */

/* SS - 091111.1 - RNB
[091111.1]

1.仅限库存事务(tr_ship_type = "")

2.<不计成本的库存事务类型主文件>.[成本选项]:0 不计成本,1 计算成本
3.优先级1: 非空优先
4.优先级2: 地点,产品线,事务类型

5.以下事务类型无论如何设置,都将计入"不计成本数量"(实际上都将计算成本):
5.1 RCT-PO/ISS-PRV: 采购收(退)货
5.2 RCT-WO/ISS-WO:  加工单入库(领料)

[091111.1]

SS - 091111.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "091111.1"}

define variable per like glc_per.
define variable yr like glc_year.
define variable entity like glcd_entity.

DEFINE VARIABLE date1 AS DATE.
DEFINE VARIABLE find-can AS LOGICAL.
define variable l_yn        like mfc_logical             no-undo.

define variable efdate like tr_effdate.
define variable efdate1 like tr_date.

DEFINE VARIABLE cost_xxpctt LIKE xxpctt_cost.

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

   {gprun.i ""xxpctrmua.p"" "(
      INPUT entity,
      INPUT yr,
      INPUT per
      )"}
   IF RETURN-VALUE = "no" THEN DO:
      UNDO,RETRY.
   END.

   FOR EACH glc_cal NO-LOCK
      WHERE glc_domain = GLOBAL_domain 
      AND glc_year = yr 
      AND glc_per = per
      :
      efdate = glc_start.
      efdate1 = glc_end.
   
      LEAVE.
   END.

   /* 已经创建 */
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpctr_hist NO-LOCK
      WHERE xxpctr_domain = GLOBAL_domain
      AND xxpctr_site = si_site
      AND xxpctr_year = yr
      AND xxpctr_per = per
      :
      /* Do you want to continue? */
      {pxmsg.i &MSGNUM=6398 &ERRORLEVEL=2 &CONFIRM=l_yn}

      if not l_yn then do:
         next-prompt per.
         UNDO mainloop, retry.
      end. /* IF NOT l_yn */

      LEAVE.
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
      /* 删除已有的数据 */
      /*
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxpctr_hist EXCLUSIVE-LOCK
         WHERE xxpctr_domain = GLOBAL_domain
         AND xxpctr_site = si_site
         AND xxpctr_year = yr
         AND xxpctr_per = per
         :
         DELETE xxpctr_hist.
      END.
      */

      /* 写入 - 数量 */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH tr_hist NO-LOCK
         WHERE tr_domain = GLOBAL_domain
         AND tr_effdate >= efdate
         AND tr_effdate <= efdate1
         AND tr_site = si_site
         AND tr_ship_type = ""
         BREAK
         BY tr_site
         BY tr_part
         BY tr_type
         :
         ACCUMULATE tr_qty_loc (TOTAL BY tr_site BY tr_part BY tr_type).

         IF LAST-OF(tr_type) 
            AND (ACCUMULATE TOTAL BY tr_type tr_qty_loc) <> 0
            THEN DO:
            FIND FIRST xxpctr_hist
               WHERE xxpctr_domain = GLOBAL_domain
               AND xxpctr_site = si_site
               AND xxpctr_year = yr
               AND xxpctr_per = per
               AND xxpctr_part = tr_part
               AND xxpctr_type = tr_type
               EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE xxpctr_hist THEN DO:
               CREATE xxpctr_hist.
               ASSIGN
                  xxpctr_domain = GLOBAL_domain
                  xxpctr_site = si_site
                  xxpctr_year = yr
                  xxpctr_per = per
                  xxpctr_part = tr_part
                  xxpctr_type = tr_type
                  .
            END.

            IF xxpctr_qty <> (ACCUMULATE TOTAL BY tr_type tr_qty_loc) THEN DO:
               ASSIGN
                  xxpctr_decfld[2] = (ACCUMULATE TOTAL BY tr_type tr_qty_loc) - xxpctr_qty
                  xxpctr_qty = (ACCUMULATE TOTAL BY tr_type tr_qty_loc)
                  xxpctr_last_date = TODAY
                  xxpctr_last_time = TIME
                  xxpctr_last_userid = GLOBAL_userid
                  xxpctr_last_program = execname
                  .
            END.
         END. /* IF LAST-OF(tr_type) THEN DO: */
      END.

      /* 不再重建其他数据 */
      /*
      /* 更新 - 不计成本数量和计算成本数量 */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxpctr_hist EXCLUSIVE-LOCK
         WHERE xxpctr_domain = GLOBAL_domain
         AND xxpctr_site = si_site
         AND xxpctr_year = yr
         AND xxpctr_per = per
         AND LOOKUP(xxpctr_type, "RCT-PO,ISS-PRV,RCT-WO,ISS-WO", ",") > 0
         :
         ASSIGN
            xxpctr_qty0 = 0
            xxpctr_qty1 = xxpctr_qty
            .
      END.

      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxpctr_hist EXCLUSIVE-LOCK
         WHERE xxpctr_domain = GLOBAL_domain
         AND xxpctr_site = si_site
         AND xxpctr_year = yr
         AND xxpctr_per = per
         AND LOOKUP(xxpctr_type, "RCT-PO,ISS-PRV,RCT-WO,ISS-WO", ",") = 0
         ,EACH pt_mstr NO-LOCK
         WHERE pt_domain = GLOBAL_domain
         AND pt_part = xxpctr_part
         BREAK 
         BY xxpctr_site
         BY pt_prod_line
         BY xxpctr_type
         :
         IF FIRST-OF(xxpctr_type) THEN DO:
            find-can = NO.
            FOR EACH xxpctt_mstr NO-LOCK
               WHERE xxpctt_domain = GLOBAL_domain
               AND (xxpctt_site = xxpctr_site OR xxpctt_site = "")
               AND (xxpctt_start <= efdate1 OR xxpctt_start = ?)
               AND (xxpctt_prod_line = pt_prod_line OR xxpctt_prod_line = "")
               AND (xxpctt_type = xxpctr_type OR xxpctt_type = "")
               AND (xxpctt_expire >= efdate1 OR xxpctt_expire = ?)
               BY xxpctt_site DESC
               BY xxpctt_prod_line DESC
               BY xxpctt_type DESC
               :
               find-can = YES.
               cost_xxpctt = xxpctt_cost.

               LEAVE.
            END.
            IF find-can = NO THEN DO:
               /* 301608 - <不计成本的库存事务类型主文件>记录不存在 */
               {pxmsg.i &MSGNUM=301608 &ERRORLEVEL=3}

               STOP.
            END.
         END.

         ASSIGN
            xxpctr_qty0 = xxpctr_qty * cost_xxpctt
            xxpctr_qty1 = xxpctr_qty - xxpctr_qty0
            .
      END.
      */
   END. /* DO TRANSACTION ON STOP UNDO: */

   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   EXPORT DELIMITER ";" 
      "地点"
      "年份"
      "期间"
      "件号"
      "件名"
      "类型"
      "数量"
      "不计成本数量"
      "计算成本数量"
      "重建差异"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpctr_hist NO-LOCK
      WHERE xxpctr_domain = GLOBAL_domain
      AND xxpctr_site = si_site
      AND xxpctr_year = yr
      AND xxpctr_per = per
      ,EACH pt_mstr NO-LOCK
      WHERE pt_domain = GLOBAL_domain
      AND pt_part = xxpctr_part
      BY xxpctr_site
      BY xxpctr_year
      BY xxpctr_per
      BY xxpctr_part
      BY xxpctr_type
      :
      IF xxpctr_decfld[2] = 0 THEN DO:
         NEXT.
      END.
      EXPORT DELIMITER ";"
         xxpctr_site
         xxpctr_year
         xxpctr_per
         xxpctr_part
         (pt_desc1 + " " + pt_desc2)
         xxpctr_type
         xxpctr_qty
         xxpctr_qty0
         xxpctr_qty1
         xxpctr_decfld[2]
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
