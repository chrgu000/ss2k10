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

/* SS - 090706.1 By: Bill Jiang */

/* SS - 090706.1 - RNB
[090706.1]

1.自<在制品成本结转明细文件>汇总后复制
2.领料成本 = ∑子件N次成本之和

[090706.1]

SS - 090706.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "090706.1"}

define variable per like glc_per.
define variable yr like glc_year.
define variable entity like glcd_entity.
DEFINE VARIABLE date1 AS DATE.
DEFINE VARIABLE find-can AS LOGICAL.
define variable l_yn        like mfc_logical             no-undo.

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
      AND xxpcwoc_rct_wo <> 0
      :
      /* 301606 - 记录已经存在.是否继续? */
      {pxmsg.i &MSGNUM=301606 &ERRORLEVEL=2 &CONFIRM=l_yn}

      if not l_yn then do:
         next-prompt per.
         UNDO mainloop, retry.
      end. /* IF NOT l_yn */

      LEAVE.
   END.

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
            xxpcwoc_rct_wo = 0
            .
      END.

      /* 更新或创建 - 间接成本分配主文件 */
      FOR EACH en_mstr NO-LOCK
         WHERE en_domain = GLOBAL_domain
         AND en_entity = entity
         ,EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = en_entity
         ,EACH xxpcwipc_det NO-LOCK
         WHERE xxpcwipc_domain = GLOBAL_domain
         AND xxpcwipc_site = si_site
         AND xxpcwipc_year = yr
         AND xxpcwipc_per = per
         BREAK 
         BY xxpcwipc_site
         BY xxpcwipc_par
         BY xxpcwipc_lot
         BY xxpcwipc_element
         :
         ACCUMULATE xxpcwipc_cst_tot (TOTAL
                                      BY xxpcwipc_site
                                      BY xxpcwipc_par
                                      BY xxpcwipc_lot
                                      BY xxpcwipc_element
                                      ).

         IF NOT LAST-OF(xxpcwipc_element) THEN DO:
            NEXT.
         END.

         IF (ACCUMULATE TOTAL BY xxpcwipc_element xxpcwipc_cst_tot) = 0 THEN DO:
            NEXT.
         END.

         FIND FIRST xxpcwoc_det
            WHERE xxpcwoc_det.xxpcwoc_domain = xxpcwipc_domain
            AND xxpcwoc_det.xxpcwoc_site = xxpcwipc_site
            AND xxpcwoc_det.xxpcwoc_year = xxpcwipc_year
            AND xxpcwoc_det.xxpcwoc_per = xxpcwipc_per
            AND xxpcwoc_det.xxpcwoc_part = xxpcwipc_par
            AND xxpcwoc_det.xxpcwoc_lot = xxpcwipc_lot
            AND xxpcwoc_det.xxpcwoc_element = xxpcwipc_element
            EXCLUSIVE-LOCK NO-ERROR.
         IF NOT AVAILABLE xxpcwoc_det THEN DO:
            CREATE xxpcwoc_det.
            ASSIGN
               xxpcwoc_det.xxpcwoc_domain = xxpcwipc_domain
               xxpcwoc_det.xxpcwoc_site = xxpcwipc_site
               xxpcwoc_det.xxpcwoc_year = xxpcwipc_year
               xxpcwoc_det.xxpcwoc_per = xxpcwipc_per
               xxpcwoc_det.xxpcwoc_part = xxpcwipc_par
               xxpcwoc_det.xxpcwoc_lot = xxpcwipc_lot
               xxpcwoc_det.xxpcwoc_element = xxpcwipc_element
               .
         END.
         ASSIGN
            xxpcwoc_det.xxpcwoc_rct_wo = xxpcwoc_rct_wo + (ACCUMULATE TOTAL BY xxpcwipc_element xxpcwipc_cst_tot)
            .
      END.
   END. /* DO TRANSACTION ON STOP UNDO: */

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
      "金额"
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
         xxpcwoc_rct_wo
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
