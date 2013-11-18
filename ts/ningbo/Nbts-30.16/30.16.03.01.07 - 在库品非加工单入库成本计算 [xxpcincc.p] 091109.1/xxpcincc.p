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

/* SS - 090709.1 By: Bill Jiang */
/* SS - 091015.1 By: Bill Jiang */
/* SS - 091020.1 By: Bill Jiang */
/* SS - 091109.1 By: Bill Jiang */

/* SS - 091109.1 - RNB
[091109.1]

更正了库存转移相关的BUG

[091109.1]

SS - 091109.1 - RNE */

/* SS - 091020.1 - RNB
[091020.1]

增加了是否包括材料成本的选项

[091020.1]

SS - 091020.1 - RNE */

/* SS - 091015.1 - RNB
[091015.1]

             期初成本 + 期间增加成本(含入库,见上面的2和3) + 期间地点间库存转移增加成本
1.期间均成 = ------------------------------------------------------------------------------------
             期初数量 + 收货数量 + 入库数量 + 不计成本的其他增加数量 + 期间地点间库存转移增加数量

[091015.1]

SS - 091015.1 - RNE */

/* SS - 090709.1 - RNB
[090709.1]

              期初成本 + 期间增加成本(不含入库,见上面的2和3)
1.非入库均成 = ---------------------------------------------------
              期初数量 + 收货数量 + 入库数量 + 不计成本的其他增加数量

[090709.1]

SS - 090709.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "091109.1"}

define variable per like glc_per.
define variable yr like glc_year.
define variable entity like glcd_entity.
DEFINE VARIABLE date1 AS DATE.
DEFINE VARIABLE find-can AS LOGICAL.
define variable l_yn        like mfc_logical             no-undo.
DEFINE VARIABLE qty0 AS DECIMAL.

/* SS - 091020.1 - B */
DEFINE VARIABLE include_item_material LIKE mfc_logical INITIAL YES.
/* SS - 091020.1 - E */

{glcabmeg.i} /* module closing engine include. */

/* SELECT FORM */
form
   entity colon 20    
   en_name NO-LABEL
   yr     colon 20    
   per     colon 20    
   skip
   /* SS - 091020.1 - B */
   SKIP (1)
   include_item_material COLON 20
   /* SS - 091020.1 - E */
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
         /* SS - 091020.1 - B */
         include_item_material 
         /* SS - 091020.1 - E */
      with frame a.

   {wbrp06.i &command = update &fields = "  entity yr per
      /* SS - 091020.1 - B */
      include_item_material 
      /* SS - 091020.1 - E */
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
      /* SS - 091020.1 - B */
      AND ((xxpcinc_element <> 1) OR (include_item_material = YES))
      /* SS - 091020.1 - E */
      AND xxpcinc_cst <> 0
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
      /* SS - 091015.1 - B */
      l_yn = YES.
      /* SS - 091015.1 - E */

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
         /* SS - 091020.1 - B */
         AND ((xxpcinc_element <> 1) OR (include_item_material = YES))
         /* SS - 091020.1 - E */
         AND xxpcinc_cst <> 0
         :
         ASSIGN
            xxpcinc_cst = 0
            .
      END.

      /* 更新 */
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
         /* SS - 091020.1 - B */
         AND ((xxpcinc_element <> 1) OR (include_item_material = YES))
         /* SS - 091020.1 - E */
         /* SS - 091020.1 - B
         AND xxpcinc_cst <> 0
         SS - 091020.1 - E */
         BREAK 
         BY xxpcinc_site
         BY xxpcinc_part
         :
         IF FIRST-OF(xxpcinc_part) THEN DO:
            qty0 = 0.

            /* 期初数量 */
            FOR EACH xxpcinb_mstr NO-LOCK
               WHERE xxpcinb_domain = GLOBAL_domain
               AND xxpcinb_site = xxpcinc_site
               AND xxpcinb_year = yr
               AND xxpcinb_per = per
               AND xxpcinb_part = xxpcinc_part
               :
               qty0 = qty0 + xxpcinb_qty.
            END.

            FOR EACH xxpctr_hist NO-LOCK
               WHERE xxpctr_domain = GLOBAL_domain
               AND xxpctr_site = xxpcinc_site
               AND xxpctr_year = yr
               AND xxpctr_per = per
               AND xxpctr_part = xxpcinc_part
               :
               /* 收货数量 */
               IF xxpctr_type = "RCT-PO" OR xxpctr_type = "ISS-PRV" THEN DO:
                  qty0 = qty0 + xxpctr_qty.
               END.
               /* 入库数量 */
               ELSE IF xxpctr_type = "RCT-WO" THEN DO:
                  qty0 = qty0 + xxpctr_qty.
               END.
               /* SS - 091109.1 - B */
               /* 地点间库存转移增加数量 */
               ELSE IF (xxpctr_type = "RCT-TR" OR xxpctr_type = "ISS-TR") AND xxpctr_decfld[1] <> 0 THEN DO:
                  qty0 = qty0 + xxpctr_decfld[1].
               END.
               /* SS - 091015.1 - E */
               /* 不计成本的其他增加数量 */
               ELSE IF xxpctr_qty0 > 0 THEN DO:
                  qty0 = qty0 + xxpctr_qty0.
               END.
            END.
         END.

         IF xxpcinc_beg + xxpcinc_rct = 0 THEN DO:
            ASSIGN
               xxpcinc_cst = 0
               .
            NEXT.
         END.

         IF qty0 = 0 THEN DO:
            /* 301607 - 零件#的数量为0 */
            {pxmsg.i &MSGNUM=301607 &ERRORLEVEL=3 &MSGARG1=xxpcinc_part}

            /* SS - 091015.1 - B */
            l_yn = NO.
            /* SS - 091015.1 - E */
            STOP.
         END.

         ASSIGN
            xxpcinc_cst = (xxpcinc_beg + xxpcinc_rct) / qty0
            .
      END.
   END. /* DO TRANSACTION ON STOP UNDO: */

   /* SS - 091015.1 - B */
   if not l_yn then do:
      next-prompt per.
      UNDO mainloop, retry.
   end. /* IF NOT l_yn */
   /* SS - 091015.1 - E */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {mfquoter.i entity }
      {mfquoter.i yr     }
      {mfquoter.i per     }
      /* SS - 091020.1 - B */
      {mfquoter.i include_item_material      }
      /* SS - 091020.1 - E */
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
      /* SS - 091020.1 - B */
      AND ((xxpcinc_element <> 1) OR (include_item_material = YES))
      /* SS - 091020.1 - E */
      AND xxpcinc_cst <> 0
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
         xxpcinc_cst
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
