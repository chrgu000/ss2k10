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

1.自<采购收(退)货历史记录文件>复制
2.限库存(tr_ship_type="")事务类型:RCT-PO,ISS-PRV
3.element = 1

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

DEFINE BUFFER xxpcinc_det FOR xxpcinc_det.

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
      ,EACH xxpcinc_det NO-LOCK
      WHERE xxpcinc_domain = GLOBAL_domain
      AND xxpcinc_site = si_site
      AND xxpcinc_year = yr
      AND xxpcinc_per = per
      AND xxpcinc_element = 1
      AND xxpcinc_rct <> 0
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
         ,EACH xxpcinc_det EXCLUSIVE-LOCK
         WHERE xxpcinc_domain = GLOBAL_domain
         AND xxpcinc_site = si_site
         AND xxpcinc_year = yr
         AND xxpcinc_per = per
         AND xxpcinc_element = 1
         :
         ASSIGN
            xxpcinc_rct = 0
            .
      END.

      /* 更新或创建 */
      FOR EACH en_mstr NO-LOCK
         WHERE en_domain = GLOBAL_domain
         AND en_entity = entity
         ,EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = en_entity
         ,EACH xxpcprh_hist NO-LOCK
         WHERE xxpcprh_domain = GLOBAL_domain
         AND xxpcprh_site = si_site
         AND xxpcprh_year = yr
         AND xxpcprh_per = per
         BREAK 
         BY xxpcprh_part
         :
         ACCUMULATE xxpcprh_mtl_tot (TOTAL
                                     BY xxpcprh_part
                                     ).

         IF NOT LAST-OF(xxpcprh_part) THEN DO:
            NEXT.
         END.

         IF (ACCUMULATE TOTAL BY xxpcprh_part xxpcprh_mtl_tot) = 0 THEN DO:
            NEXT.
         END.

         FIND FIRST xxpcinc_det
            WHERE xxpcinc_det.xxpcinc_domain = xxpcprh_domain
            AND xxpcinc_det.xxpcinc_site = xxpcprh_site
            AND xxpcinc_det.xxpcinc_year = xxpcprh_year
            AND xxpcinc_det.xxpcinc_per = xxpcprh_per
            AND xxpcinc_det.xxpcinc_part = xxpcprh_part
            AND xxpcinc_det.xxpcinc_element = 1
            EXCLUSIVE-LOCK NO-ERROR.
         IF NOT AVAILABLE xxpcinc_det THEN DO:
            CREATE xxpcinc_det.
            ASSIGN
               xxpcinc_det.xxpcinc_domain = xxpcprh_domain
               xxpcinc_det.xxpcinc_site = xxpcprh_site
               xxpcinc_det.xxpcinc_year = xxpcprh_year
               xxpcinc_det.xxpcinc_per = xxpcprh_per
               xxpcinc_det.xxpcinc_part = xxpcprh_part
               xxpcinc_det.xxpcinc_element = 1
               .
         END.
         ASSIGN
            xxpcinc_det.xxpcinc_rct = (ACCUMULATE TOTAL BY xxpcprh_part xxpcprh_mtl_tot)
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
      "成本要素"
      "金额"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpcinc_det NO-LOCK
      WHERE xxpcinc_domain = GLOBAL_domain
      AND xxpcinc_site = si_site
      AND xxpcinc_year = yr
      AND xxpcinc_per = per
      BY xxpcinc_site
      BY xxpcinc_year
      BY xxpcinc_per
      BY xxpcinc_part
      :
      EXPORT DELIMITER ";"
         xxpcinc_site
         xxpcinc_year
         xxpcinc_per
         xxpcinc_part
         xxpcinc_element
         xxpcinc_rct
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
