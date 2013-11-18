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
/* SS - 091014.1 By: Bill Jiang */
/* SS - 091015.1 By: Bill Jiang */

/* SS - 091015.1 - RNB
[091015.1]

在更新库存事务的地点间库存转移数量之前先清除

[091015.1]

SS - 091015.1 - RNE */

/* SS - 091014.1 - RNB
[091014.1]

将RCT-TR视同RCT-PO处理

[091014.1]

SS - 091014.1 - RNE */

/* SS - 090706.1 - RNB
[090706.1]

1.自结转后的<在库品间接成本归集主文件>复制

[090706.1]

SS - 090706.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "091015.1"}

define variable per like glc_per.
define variable yr like glc_year.
define variable entity like glcd_entity.
DEFINE VARIABLE date1 AS DATE.
DEFINE VARIABLE find-can AS LOGICAL.
define variable l_yn        like mfc_logical             no-undo.

/* SS - 091014.1 - B */
DEFINE VARIABLE incl-move LIKE mfc_logical.
DEFINE VARIABLE FROM_site LIKE tr_ref_site.

define variable efdate like tr_effdate.
define variable efdate1 like tr_date.

DEFINE TEMP-TABLE ttpt
   FIELD ttpt_site LIKE tr_site
   FIELD ttpt_part LIKE tr_part
   FIELD ttpt_type LIKE tr_type
   FIELD ttpt_qty_loc LIKE tr_qty_loc
   INDEX index1 ttpt_site ttpt_part ttpt_type
   .

DEFINE TEMP-TABLE ttpte
   FIELD ttpte_site LIKE tr_site
   FIELD ttpte_part LIKE tr_part
   FIELD ttpte_type LIKE tr_type
   FIELD ttpte_element LIKE xxpcinc_element
   FIELD ttpte_cst_tot LIKE xxpcinc_cst_tot
   INDEX index1 ttpte_site ttpte_part ttpte_type ttpte_element
   .

/* SS - 091014.1 - E */

{glcabmeg.i} /* module closing engine include. */

/* SELECT FORM */
form
   entity colon 20    
   en_name NO-LABEL
   yr     colon 20    
   per     colon 20    
   skip
   /* SS - 091014.1 - B */
   SKIP (1)
   incl-move COLON 20
   FROM_site COLON 20
   /* SS - 091014.1 - E */
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
         /* SS - 091014.1 - B */
         incl-move
         from_site
         /* SS - 091014.1 - E */
      with frame a.

   {wbrp06.i &command = update &fields = "  entity yr per
      /* SS - 091014.1 - B */
      incl-move
      from_site
      /* SS - 091014.1 - E */
      " &frm = "a"}
      
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

   /* SS - 091014.1 - B */
   IF incl-move = YES THEN DO:
      FIND FIRST si_mstr
         WHERE si_domain = GLOBAL_domain
         AND si_site = from_site
         NO-LOCK NO-ERROR.
      IF NOT AVAILABLE si_mstr THEN DO:
         next-prompt from_site.
         UNDO mainloop, retry.
      END.
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
   /* SS - 091014.1 - E */

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
      AND xxpcinc_element <> 1
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
         AND xxpcinc_element <> 1
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
         ,EACH xxici_mstr NO-LOCK
         WHERE xxici_domain = GLOBAL_domain
         AND xxici_site = si_site
         AND xxici_year = yr
         AND xxici_per = per
         BREAK 
         BY xxici_element
         BY xxici_part
         :
         ACCUMULATE xxici_cst (TOTAL
                                   BY xxici_element
                                   BY xxici_part
                                   ).

         IF NOT LAST-OF(xxici_part) THEN DO:
            NEXT.
         END.

         IF (ACCUMULATE TOTAL BY xxici_part xxici_cst) = 0 THEN DO:
            NEXT.
         END.

         FIND FIRST xxpcinc_det
            WHERE xxpcinc_det.xxpcinc_domain = xxici_domain
            AND xxpcinc_det.xxpcinc_site = xxici_site
            AND xxpcinc_det.xxpcinc_year = xxici_year
            AND xxpcinc_det.xxpcinc_per = xxici_per
            AND xxpcinc_det.xxpcinc_part = xxici_part
            AND xxpcinc_det.xxpcinc_element = xxici_element
            EXCLUSIVE-LOCK NO-ERROR.
         IF NOT AVAILABLE xxpcinc_det THEN DO:
            CREATE xxpcinc_det.
            ASSIGN
               xxpcinc_det.xxpcinc_domain = xxici_domain
               xxpcinc_det.xxpcinc_site = xxici_site
               xxpcinc_det.xxpcinc_year = xxici_year
               xxpcinc_det.xxpcinc_per = xxici_per
               xxpcinc_det.xxpcinc_part = xxici_part
               xxpcinc_det.xxpcinc_element = xxici_element
               .
         END.
         ASSIGN
            xxpcinc_det.xxpcinc_rct = (ACCUMULATE TOTAL BY xxici_part xxici_cst)
            .
      END. /* FOR EACH en_mstr NO-LOCK */

      /* SS - 091014.1 - B */
      IF incl-move = YES THEN DO:
         /* 创建库存转移临时表 - 数量 */
         FOR EACH ttpt:
            DELETE ttpt.
         END.
         FOR EACH en_mstr NO-LOCK
            WHERE en_domain = GLOBAL_domain
            AND en_entity = entity
            ,EACH si_mstr NO-LOCK
            WHERE si_domain = GLOBAL_domain
            AND si_entity = en_entity
            ,EACH tr_hist NO-LOCK
            WHERE tr_domain = GLOBAL_domain
            AND tr_effdate >= efdate
            AND tr_effdate <= efdate1
            AND tr_site = si_site
            AND tr_ship_type = ""
            AND (tr_type = "RCT-TR" OR tr_type = "ISS-TR")
            AND tr_site <> tr_ref_site
            AND tr_ref_site = FROM_site
            AND tr_qty_loc > 0
            BREAK
            BY tr_site
            BY tr_part
            BY tr_type
            :
            ACCUMULATE tr_qty_loc (TOTAL BY tr_site BY tr_part BY tr_type).

            IF LAST-OF(tr_type) 
               AND (ACCUMULATE TOTAL BY tr_type tr_qty_loc) <> 0
               THEN DO:
               CREATE ttpt.
               ASSIGN
                  ttpt_site = tr_site
                  ttpt_part = tr_part
                  ttpt_type = tr_type
                  ttpt_qty_loc = (ACCUMULATE TOTAL BY tr_type tr_qty_loc)
                  .
            END. /* IF LAST-OF(tr_type) THEN DO: */
         END.

         /* 创建库存转移临时表 - 成本 */
         FOR EACH ttpte:
            DELETE ttpte.
         END.
         /* SS - 091015.1 - B */
         FOR EACH si_mstr NO-LOCK
            WHERE si_domain = GLOBAL_domain
            AND si_entity = entity
            ,EACH xxpctr_hist EXCLUSIVE-LOCK
            WHERE xxpctr_domain = GLOBAL_domain
            AND xxpctr_site = si_site
            AND xxpctr_year = yr
            AND xxpctr_per = per
            :
            ASSIGN
               xxpctr_decfld[1] = 0
               .
         END.
         /* SS - 091015.1 - E */
         FOR EACH ttpt:
            FIND FIRST xxpctr_hist
               WHERE xxpctr_domain = GLOBAL_domain
               AND xxpctr_site = ttpt_site
               AND xxpctr_year = yr
               AND xxpctr_per = per
               AND xxpctr_part = ttpt_part
               AND xxpctr_type = ttpt_type
               EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE xxpctr_hist THEN DO:
               /* 发现错误，处理中断 */
               {pxmsg.i &MSGNUM=2031 &ERRORLEVEL=3}
               
               STOP.
            END.
            ASSIGN
               xxpctr_decfld[1] = ttpt_qty_loc
               .

            FOR EACH xxpcinc_det NO-LOCK
               WHERE xxpcinc_domain = GLOBAL_domain
               AND xxpcinc_site = from_site
               AND xxpcinc_year = yr
               AND xxpcinc_per = per
               AND xxpcinc_part = ttpt_part
               :
               CREATE ttpte.
               ASSIGN
                  ttpte_site = ttpt_site
                  ttpte_part = ttpt_part
                  ttpte_type = ttpt_type
                  ttpte_element = xxpcinc_element
                  ttpte_cst_tot = ttpt_qty_loc * xxpcinc_cst_tot
                  .
            END.
         END.

         /* 更新或创建 - 库存转移 */
         FOR EACH ttpte
            BREAK
            BY ttpte_site
            BY ttpte_part
            BY ttpte_element
            :
            ACCUMULATE ttpte_cst_tot (TOTAL BY ttpte_site BY ttpte_part BY ttpte_element).

            IF LAST-OF(ttpte_element) THEN DO:
               FIND FIRST xxpcinc_det
                  WHERE xxpcinc_det.xxpcinc_domain = global_domain
                  AND xxpcinc_det.xxpcinc_site = ttpte_site
                  AND xxpcinc_det.xxpcinc_year = yr
                  AND xxpcinc_det.xxpcinc_per = per
                  AND xxpcinc_det.xxpcinc_part = ttpte_part
                  AND xxpcinc_det.xxpcinc_element = ttpte_element
                  EXCLUSIVE-LOCK NO-ERROR.
               IF NOT AVAILABLE xxpcinc_det THEN DO:
                  CREATE xxpcinc_det.
                  ASSIGN
                     xxpcinc_det.xxpcinc_domain = global_domain
                     xxpcinc_det.xxpcinc_site = ttpte_site
                     xxpcinc_det.xxpcinc_year = yr
                     xxpcinc_det.xxpcinc_per = per
                     xxpcinc_det.xxpcinc_part = ttpte_part
                     xxpcinc_det.xxpcinc_element = ttpte_element
                     .
               END.
               ASSIGN
                  xxpcinc_det.xxpcinc_rct = xxpcinc_det.xxpcinc_rct + (ACCUMULATE TOTAL BY ttpte_element ttpte_cst_tot)
                  .
            END.
         END.
      END. /* IF incl-move = YES THEN DO: */
      /* SS - 091014.1 - E */
   END. /* DO TRANSACTION ON STOP UNDO: */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {mfquoter.i entity }
      {mfquoter.i yr     }
      {mfquoter.i per     }
      /* SS - 091014.1 - B */
      {mfquoter.i incl-move     }
      {mfquoter.i FROM_site     }
      /* SS - 091014.1 - E */
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
      BY xxpcinc_element
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
