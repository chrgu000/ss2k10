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

/* SS - 090521.1 By: Bill Jiang */
/* SS - 090724.1 By: Bill Jiang */

/* SS - 090724.1 - RNB
[090724.1]

忽略了数量为0的记录

[090724.1]

SS - 090724.1 - RNE */

/* SS - 090521.1 - RNB
[090521.1]

1.库存(tr_ship_type="")事务类型:RCT-WO;计算成本,不可设置
2.非库存(tr_ship_type="M")事务类型:RJCT-WO;计算成本否,可设置

错误:总账日历没维护,总账日历已结,上期未结,本期已结!

警告:记录已经存在,是否继续?

[090521.1]

SS - 090521.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "090724.1"}

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

   /* 已经创建 */
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpcwor_hist NO-LOCK
      WHERE xxpcwor_domain = GLOBAL_domain
      AND xxpcwor_site = si_site
      AND xxpcwor_year = yr
      AND xxpcwor_per = per
      :
      /* 301606 - 记录已经存在.是否继续? */
      {pxmsg.i &MSGNUM=301606 &ERRORLEVEL=2 &CONFIRM=l_yn}

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
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxpcwor_hist EXCLUSIVE-LOCK
         WHERE xxpcwor_domain = GLOBAL_domain
         AND xxpcwor_site = si_site
         AND xxpcwor_year = yr
         AND xxpcwor_per = per
         :
         DELETE xxpcwor_hist.
      END.

      /* 写入 - RCT-WO */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH tr_hist NO-LOCK
         WHERE tr_domain = GLOBAL_domain
         AND tr_effdate >= efdate
         AND tr_effdate <= efdate1
         AND tr_type = "RCT-WO"
         AND tr_site = si_site
         AND tr_ship_type = ""
         BREAK
         BY tr_site
         BY tr_part
         BY tr_lot
         :
         ACCUMULATE tr_qty_loc (TOTAL BY tr_site BY tr_part BY tr_lot).

         IF LAST-OF(tr_lot) 
            /* SS - 090724.1 - B */
            AND (ACCUMULATE TOTAL BY tr_lot tr_qty_loc) <> 0
            /* SS - 090724.1 - E */
            THEN DO:
            FIND FIRST xxpcwor_hist
               WHERE xxpcwor_domain = GLOBAL_domain
               AND xxpcwor_site = si_site
               AND xxpcwor_year = yr
               AND xxpcwor_per = per
               AND xxpcwor_part = tr_part
               AND xxpcwor_lot = tr_lot
               AND xxpcwor_type = tr_type
               EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE xxpcwor_hist THEN DO:
               CREATE xxpcwor_hist.
               ASSIGN
                  xxpcwor_domain = GLOBAL_domain
                  xxpcwor_site = si_site
                  xxpcwor_year = yr
                  xxpcwor_per = per
                  xxpcwor_part = tr_part
                  xxpcwor_lot = tr_lot
                  xxpcwor_type = tr_type
                  .
            END.

            ASSIGN
               xxpcwor_qty = (ACCUMULATE TOTAL BY tr_lot tr_qty_loc)
               .
         END. /* IF LAST-OF(tr_lot) THEN DO: */
      END.

      /* 写入 - RJCT-WO */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH tr_hist NO-LOCK
         WHERE tr_domain = GLOBAL_domain
         AND tr_effdate >= efdate
         AND tr_effdate <= efdate1
         AND tr_type = "RJCT-WO"
         AND tr_site = si_site
         BREAK
         BY tr_site
         BY tr_part
         BY tr_lot
         :
         ACCUMULATE tr_qty_short (TOTAL BY tr_site BY tr_part BY tr_lot).

         IF LAST-OF(tr_lot) 
            /* SS - 090724.1 - B */
            AND (ACCUMULATE TOTAL BY tr_lot tr_qty_short) <> 0
            /* SS - 090724.1 - E */
            THEN DO:
            FIND FIRST xxpcwor_hist
               WHERE xxpcwor_domain = GLOBAL_domain
               AND xxpcwor_site = si_site
               AND xxpcwor_year = yr
               AND xxpcwor_per = per
               AND xxpcwor_part = tr_part
               AND xxpcwor_lot = tr_lot
               AND xxpcwor_type = tr_type
               EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE xxpcwor_hist THEN DO:
               CREATE xxpcwor_hist.
               ASSIGN
                  xxpcwor_domain = GLOBAL_domain
                  xxpcwor_site = si_site
                  xxpcwor_year = yr
                  xxpcwor_per = per
                  xxpcwor_part = tr_part
                  xxpcwor_lot = tr_lot
                  xxpcwor_type = tr_type
                  .
            END.

            ASSIGN
               xxpcwor_qty = (ACCUMULATE TOTAL BY tr_lot tr_qty_short)
               .
         END. /* IF LAST-OF(tr_lot) THEN DO: */
      END.
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
      "类型"
      "数量"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpcwor_hist NO-LOCK
      WHERE xxpcwor_domain = GLOBAL_domain
      AND xxpcwor_site = si_site
      AND xxpcwor_year = yr
      AND xxpcwor_per = per
      ,EACH pt_mstr NO-LOCK
      WHERE pt_domain = GLOBAL_domain
      AND pt_part = xxpcwor_part
      BY xxpcwor_site
      BY xxpcwor_year
      BY xxpcwor_per
      BY xxpcwor_part
      BY xxpcwor_lot
      BY xxpcwor_type
      :
      EXPORT DELIMITER ";"
         xxpcwor_site
         xxpcwor_year
         xxpcwor_per
         xxpcwor_part
         (pt_desc1 + " " + pt_desc2)
         xxpcwor_lot
         xxpcwor_type
         xxpcwor_qty
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
