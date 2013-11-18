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

/* SS - 090527.1 By: Bill Jiang */
/* SS - 091014.1 By: Bill Jiang */
/* SS - 091123.1 By: Bill Jiang */

/* SS - 091123.1 - RNB
[091123.1]

在更新库存事务的地点间库存转移成本之前先清除

[091123.1]

SS - 091123.1 - RNE */

/* SS - 091014.1 - RNB
[091014.1]

地点间库存转移增加成本计算
1.仅限库存事务(xxpcprh_ship_type = ""):RCT-TR,ISS-TR

[091014.1]

SS - 091014.1 - RNE */

/* SS - 090527.1 - RNB
[090527.1]

采购收(退货)成本计算
1.仅限库存事务(xxpcprh_ship_type = ""):RCT-PO,ISS-PRV
2.自<采购收(退)货历史记录文件>.[总料]汇总后复制

加工单入库成本计算
1.仅限库存事务(xxpcprh_ship_type = ""):RCT-WO
2.自<在库品成本计算明细文件>.[期间入库总成]汇总后复制

加工单领料成本计算
1.仅限库存事务(xxpcprh_ship_type = ""):ISS-WO
2.<库存事务历史记录文件 - 数量>.[数量] * <在库品成本计算明细文件>.[期间一次加权平均成本]

其他计算成本的事务成本计算
1.仅限库存事务(xxpcprh_ship_type = "")
2.<库存事务历史记录文件 - 数量>.[计算成本数量] * <在库品成本计算明细文件>.[期间一次加权平均成本]

[090527.1]

SS - 090527.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "091123.1"}

define variable per like glc_per.
define variable yr like glc_year.
define variable entity like glcd_entity.

DEFINE VARIABLE date1 AS DATE.
DEFINE VARIABLE find-can AS LOGICAL.
define variable l_yn        like mfc_logical             no-undo.

DEFINE VARIABLE cost_xxpctt LIKE xxpctt_cost.

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

   {gprun.i ""xxpcincpw.p"" "(
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
      ,EACH xxpctrc_hist NO-LOCK
      WHERE xxpctrc_domain = GLOBAL_domain
      AND xxpctrc_site = si_site
      AND xxpctrc_year = yr
      AND xxpctrc_per = per
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
         ,EACH xxpctrc_hist EXCLUSIVE-LOCK
         WHERE xxpctrc_domain = GLOBAL_domain
         AND xxpctrc_site = si_site
         AND xxpctrc_year = yr
         AND xxpctrc_per = per
         :
         DELETE xxpctrc_hist.
      END.

      /* SS - 091014.1 - B */
      /* 地点间库存转移增加成本计算 */
      {xxpctrcnrcttr.i}
      /* SS - 091014.1 - E */

      /* 采购收(退货)成本计算 */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxpcprh_hist NO-LOCK
         WHERE xxpcprh_domain = GLOBAL_domain
         AND xxpcprh_site = si_site
         AND xxpcprh_year = yr
         AND xxpcprh_per = per
         BREAK
         BY xxpcprh_site
         BY xxpcprh_part
         BY xxpcprh_type
         :
         ACCUMULATE xxpcprh_mtl_tot (TOTAL 
                                     BY xxpcprh_site 
                                     BY xxpcprh_part 
                                     BY xxpcprh_type
                                     ).

         IF LAST-OF(xxpcprh_type) 
            AND (ACCUMULATE TOTAL BY xxpcprh_type xxpcprh_mtl_tot) <> 0
            THEN DO:
            FIND FIRST xxpctrc_hist
               WHERE xxpctrc_domain = GLOBAL_domain
               AND xxpctrc_site = si_site
               AND xxpctrc_year = yr
               AND xxpctrc_per = per
               AND xxpctrc_part = xxpcprh_part
               AND xxpctrc_type = xxpcprh_type
               AND xxpctrc_element = 1
               EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE xxpctrc_hist THEN DO:
               CREATE xxpctrc_hist.
               ASSIGN
                  xxpctrc_domain = GLOBAL_domain
                  xxpctrc_site = si_site
                  xxpctrc_year = yr
                  xxpctrc_per = per
                  xxpctrc_part = xxpcprh_part
                  xxpctrc_type = xxpcprh_type
                  xxpctrc_element = 1
                  .
            END.

            ASSIGN
               xxpctrc_cst = (ACCUMULATE TOTAL BY xxpcprh_type xxpcprh_mtl_tot)
               .
         END. /* IF LAST-OF(xxpcprh_type) THEN DO: */
      END.

      /* 加工单入库成本计算 */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxpcinc_det NO-LOCK
         WHERE xxpcinc_domain = GLOBAL_domain
         AND xxpcinc_site = si_site
         AND xxpcinc_year = yr
         AND xxpcinc_per = per
         BREAK
         BY xxpcinc_site
         BY xxpcinc_part
         BY xxpcinc_element
         :
         ACCUMULATE xxpcinc_rct_wo (TOTAL 
                                     BY xxpcinc_site 
                                     BY xxpcinc_part 
                                     BY xxpcinc_element
                                     ).

         IF LAST-OF(xxpcinc_element) 
            AND (ACCUMULATE TOTAL BY xxpcinc_element xxpcinc_rct_wo) <> 0
            THEN DO:
            FIND FIRST xxpctrc_hist
               WHERE xxpctrc_domain = GLOBAL_domain
               AND xxpctrc_site = si_site
               AND xxpctrc_year = yr
               AND xxpctrc_per = per
               AND xxpctrc_part = xxpcinc_part
               AND xxpctrc_type = "RCT-WO"
               AND xxpctrc_element = xxpcinc_element
               EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE xxpctrc_hist THEN DO:
               CREATE xxpctrc_hist.
               ASSIGN
                  xxpctrc_domain = GLOBAL_domain
                  xxpctrc_site = si_site
                  xxpctrc_year = yr
                  xxpctrc_per = per
                  xxpctrc_part = xxpcinc_part
                  xxpctrc_type = "RCT-WO"
                  xxpctrc_element = xxpcinc_element
                  .
            END.

            ASSIGN
               xxpctrc_cst = (ACCUMULATE TOTAL BY xxpcinc_element xxpcinc_rct_wo)
               .
         END. /* IF LAST-OF(xxpcinc_element) THEN DO: */
      END.

      /* 加工单领料成本计算 */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxpcinc_det NO-LOCK
         WHERE xxpcinc_domain = GLOBAL_domain
         AND xxpcinc_site = si_site
         AND xxpcinc_year = yr
         AND xxpcinc_per = per
         ,EACH xxpctr_hist NO-LOCK
         WHERE xxpctr_domain = GLOBAL_domain
         AND xxpctr_site = xxpcinc_site
         AND xxpctr_year = xxpcinc_year
         AND xxpctr_per = xxpcinc_per
         AND xxpctr_part = xxpcinc_part
         AND xxpctr_type = "ISS-WO"
         BREAK
         BY xxpcinc_site
         BY xxpcinc_part
         BY xxpcinc_element
         :
         ACCUMULATE (xxpcinc_cst_tot * xxpctr_qty) (TOTAL 
                                     BY xxpcinc_site 
                                     BY xxpcinc_part 
                                     BY xxpcinc_element
                                     ).

         IF LAST-OF(xxpcinc_element) 
            AND (ACCUMULATE TOTAL BY xxpcinc_element (xxpcinc_cst_tot * xxpctr_qty)) <> 0
            THEN DO:
            FIND FIRST xxpctrc_hist
               WHERE xxpctrc_domain = GLOBAL_domain
               AND xxpctrc_site = si_site
               AND xxpctrc_year = yr
               AND xxpctrc_per = per
               AND xxpctrc_part = xxpcinc_part
               AND xxpctrc_type = xxpctr_type
               AND xxpctrc_element = xxpcinc_element
               EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE xxpctrc_hist THEN DO:
               CREATE xxpctrc_hist.
               ASSIGN
                  xxpctrc_domain = GLOBAL_domain
                  xxpctrc_site = si_site
                  xxpctrc_year = yr
                  xxpctrc_per = per
                  xxpctrc_part = xxpcinc_part
                  xxpctrc_type = xxpctr_type
                  xxpctrc_element = xxpcinc_element
                  .
            END.

            ASSIGN
               xxpctrc_cst = (ACCUMULATE TOTAL BY xxpcinc_element (xxpcinc_cst_tot * xxpctr_qty))
               .
         END. /* IF LAST-OF(xxpcinc_element) THEN DO: */
      END.

      /* SS - 091014.1 - B */
      /* 库存转移成本计算 */
      {xxpctrcntr.i}
      /* SS - 091014.1 - E */

      /* 其他计算成本的事务成本计算 */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxpcinc_det NO-LOCK
         WHERE xxpcinc_domain = GLOBAL_domain
         AND xxpcinc_site = si_site
         AND xxpcinc_year = yr
         AND xxpcinc_per = per
         ,EACH xxpctr_hist NO-LOCK
         WHERE xxpctr_domain = GLOBAL_domain
         AND xxpctr_site = xxpcinc_site
         AND xxpctr_year = xxpcinc_year
         AND xxpctr_per = xxpcinc_per
         AND xxpctr_part = xxpcinc_part
         AND LOOKUP(xxpctr_type, "RCT-PO,ISS-PRV,RCT-WO,ISS-WO", ",") = 0
         /* SS - 091014.1 - B */
         AND LOOKUP(xxpctr_type, "RCT-TR,ISS-TR", ",") = 0
         /* SS - 091014.1 - E */
         AND xxpctr_qty1 <> 0
         BREAK
         BY xxpcinc_site
         BY xxpcinc_part
         BY xxpctr_type
         BY xxpcinc_element
         :
         ACCUMULATE (xxpcinc_cst_tot * xxpctr_qty1) (TOTAL 
                                                    BY xxpcinc_site 
                                                    BY xxpcinc_part 
                                                    BY xxpctr_type
                                                    BY xxpcinc_element
                                                    ).

         IF LAST-OF(xxpcinc_element) 
            AND (ACCUMULATE TOTAL BY xxpcinc_element (xxpcinc_cst_tot * xxpctr_qty1)) <> 0
            THEN DO:
            FIND FIRST xxpctrc_hist
               WHERE xxpctrc_domain = GLOBAL_domain
               AND xxpctrc_site = si_site
               AND xxpctrc_year = yr
               AND xxpctrc_per = per
               AND xxpctrc_part = xxpcinc_part
               AND xxpctrc_type = xxpctr_type
               AND xxpctrc_element = xxpcinc_element
               EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE xxpctrc_hist THEN DO:
               CREATE xxpctrc_hist.
               ASSIGN
                  xxpctrc_domain = GLOBAL_domain
                  xxpctrc_site = si_site
                  xxpctrc_year = yr
                  xxpctrc_per = per
                  xxpctrc_part = xxpcinc_part
                  xxpctrc_type = xxpctr_type
                  xxpctrc_element = xxpcinc_element
                  .
            END.

            ASSIGN
               xxpctrc_cst = (ACCUMULATE TOTAL BY xxpcinc_element (xxpcinc_cst_tot * xxpctr_qty1))
               .
         END. /* IF LAST-OF(xxpcinc_element) THEN DO: */
      END.
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
      "成本要素"
      "成本"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpctrc_hist NO-LOCK
      WHERE xxpctrc_domain = GLOBAL_domain
      AND xxpctrc_site = si_site
      AND xxpctrc_year = yr
      AND xxpctrc_per = per
      ,EACH pt_mstr NO-LOCK
      WHERE pt_domain = GLOBAL_domain
      AND pt_part = xxpctrc_part
      BY xxpctrc_site
      BY xxpctrc_year
      BY xxpctrc_per
      BY xxpctrc_part
      BY xxpctrc_type
      BY xxpctrc_element
      :
      EXPORT DELIMITER ";"
         xxpctrc_site
         xxpctrc_year
         xxpctrc_per
         xxpctrc_part
         (pt_desc1 + " " + pt_desc2)
         xxpctrc_type
         xxpctrc_element
         xxpctrc_cst
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
