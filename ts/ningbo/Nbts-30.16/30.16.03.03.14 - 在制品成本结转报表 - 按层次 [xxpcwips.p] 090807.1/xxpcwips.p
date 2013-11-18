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

/* DISPLAY TITLE */
{mfdtitle.i "090807.1"}

define variable per like glc_per.
define variable yr like glc_year.
define variable entity like glcd_entity.
define variable entity1 like glcd_entity.
DEFINE VARIABLE site LIKE si_site.
DEFINE VARIABLE site1 LIKE si_site.
DEFINE VARIABLE part LIKE pt_part.
DEFINE VARIABLE part1 LIKE pt_part.
DEFINE VARIABLE element LIKE sc_element.
DEFINE VARIABLE element1 LIKE sc_element.
DEFINE VARIABLE TYPE LIKE tr_type.
DEFINE VARIABLE type1 LIKE tr_type.

DEFINE VARIABLE date1 AS DATE.

DEFINE BUFFER ptmstr FOR pt_mstr.

DEFINE VARIABLE dec1 AS DECIMAL.

DEFINE TEMP-TABLE ttl
   FIELD ttl_year LIKE xxpcwipc_year
   FIELD ttl_per LIKE xxpcwipc_per
   FIELD ttl_site LIKE si_site
   FIELD ttl_site_desc LIKE si_desc
   FIELD ttl_par LIKE pt_part
   FIELD ttl_par_desc LIKE pt_desc1
   FIELD ttl_lot LIKE xxpcwipc_lot
   FIELD ttl_comp LIKE pt_part
   FIELD ttl_comp_desc LIKE pt_desc1
   FIELD ttl_qty LIKE xxpcwipc_qty
   FIELD ttl_element LIKE CODE_value
   FIELD ttl_element_desc LIKE CODE_desc
   FIELD ttl_cst LIKE xxpcwipc_cst
   FIELD ttl_cst_tot LIKE xxpcwipc_cst_tot
   FIELD ttl_rct_tot LIKE xxpcwipc_cst_rct
   INDEX index1 ttl_year ttl_per ttl_site ttl_par ttl_lot ttl_comp ttl_element
   .

DEFINE TEMP-TABLE ttc
   FIELD ttc_n LIKE xxpcwipc_n
   INDEX ttc_n ttc_n
   .

{glcabmeg.i} /* module closing engine include. */

/* SELECT FORM */
form
   entity colon 20    
   entity1 colon 50 label {t001.i}
   site colon 20    
   site1 colon 50 label {t001.i}
   part colon 20    
   part1 colon 50 label {t001.i}
   element colon 20    
   element1 colon 50 label {t001.i}
   /*
   type colon 20    
   type1 colon 50 label {t001.i}
   */
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
   if entity1 = hi_char then entity1 = "".
   if site1 = hi_char then site1 = "".
   if part1 = hi_char then part1 = "".
   if element1 = hi_char then element1 = "".
   if type1 = hi_char then type1 = "".

   if c-application-mode <> 'web' THEN DO:
      update
         entity 
         entity1
         site 
         site1
         part 
         part1
         element 
         element1
         /*
         type 
         type1
         */
         yr 
         per
         with frame a
         EDITING:
   
         if frame-field = 'element' then do:
            GLOBAL_addr = 'SoftspeedPC_element'.
         END.
         ELSE if frame-field = 'element1' then do:
            GLOBAL_addr = 'SoftspeedPC_element'.
         END.
         ELSE if frame-field = 'type' then do:
            GLOBAL_addr = 'tr_type'.
         END.
         ELSE if frame-field = 'type1' then do:
            GLOBAL_addr = 'tr_type'.
         END.

         READKEY.
         APPLY LASTKEY.
      END.
   END.

   {wbrp06.i &command = update &fields = "  
      entity 
      entity1 
      site 
      site1 
      part 
      part1 
      element 
      element1 
      /*
      type 
      type1 
      */
      yr per" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      if entity1 = "" then entity1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if part1 = "" then part1 = hi_char.
      if element1 = "" then element1 = hi_char.
      if type1 = "" then type1 = hi_char.

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {mfquoter.i entity }
      {mfquoter.i entity1 }
      {mfquoter.i site }
      {mfquoter.i site1 }
      {mfquoter.i part }
      {mfquoter.i part1 }
      {mfquoter.i element }
      {mfquoter.i element1 }
      {mfquoter.i type }
      {mfquoter.i type1 }
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

   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity >= entity
      AND en_entity <= entity1
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_site >= site
      AND si_site <= site1
      AND si_entity = en_entity
      ,EACH xxpcwipc_det NO-LOCK
      WHERE xxpcwipc_domain = GLOBAL_domain
      AND xxpcwipc_site = si_site
      AND xxpcwipc_year = yr
      AND xxpcwipc_per = per
      ,EACH pt_mstr NO-LOCK
      WHERE pt_mstr.pt_domain = GLOBAL_domain
      AND pt_mstr.pt_part = xxpcwipc_par
      AND pt_mstr.pt_part >= part
      AND pt_mstr.pt_part <= part1
      ,EACH CODE_mstr NO-LOCK
      WHERE CODE_domain = GLOBAL_domain
      AND CODE_fldname = "SoftspeedPC_element"
      AND CODE_value = STRING(xxpcwipc_element)
      AND CODE_value >= element
      AND CODE_value <= element1
      ,EACH ptmstr NO-LOCK
      WHERE ptmstr.pt_domain = GLOBAL_domain
      AND ptmstr.pt_part = xxpcwipc_comp
      /*
      ,EACH xxpcwoi_hist NO-LOCK
      WHERE xxpcwoi_domain = GLOBAL_domain
      AND xxpcwoi_site = xxpcwipc_site
      AND xxpcwoi_year = xxpcwipc_year
      AND xxpcwoi_per = xxpcwipc_per
      AND xxpcwoi_par = xxpcwipc_par
      AND xxpcwoi_lot = xxpcwipc_lot
      AND xxpcwoi_comp = xxpcwipc_comp
      */
      BREAK
      BY xxpcwipc_site
      BY xxpcwipc_par
      BY xxpcwipc_lot
      BY xxpcwipc_comp
      BY xxpcwipc_element
      :
      ACCUMULATE xxpcwipc_cst_tot (TOTAL
                                   BY xxpcwipc_site
                                   BY xxpcwipc_par
                                   BY xxpcwipc_lot
                                   BY xxpcwipc_comp
                                   BY xxpcwipc_element
                                   ).
      ACCUMULATE xxpcwipc_cst_rct (TOTAL
                                   BY xxpcwipc_site
                                   BY xxpcwipc_par
                                   BY xxpcwipc_lot
                                   BY xxpcwipc_comp
                                   BY xxpcwipc_element
                                   ).

      /* 创建行临时表 */
      IF LAST-OF(xxpcwipc_element) THEN DO:
         IF xxpcwipc_qty = 0 THEN DO:
            dec1 = 0.
         END.
         ELSE DO:
            dec1 = ((ACCUMULATE TOTAL BY xxpcwipc_element xxpcwipc_cst_tot) / xxpcwipc_qty).
         END.

         CREATE ttl.
         ASSIGN
            ttl_year = xxpcwipc_year
            ttl_per = xxpcwipc_per
            ttl_site = si_site
            ttl_site_desc = si_desc
            ttl_par = pt_mstr.pt_part
            ttl_par_desc = (pt_mstr.pt_desc1 + " " + pt_mstr.pt_desc2)
            ttl_lot = xxpcwipc_lot
            ttl_comp = ptmstr.pt_part
            ttl_comp_desc = (ptmstr.pt_desc1 + " " + ptmstr.pt_desc2)
            ttl_qty = xxpcwipc_qty
            ttl_element = CODE_value
            ttl_element_desc = CODE_desc
            ttl_cst = dec1
            ttl_cst_tot = (ACCUMULATE TOTAL BY xxpcwipc_element xxpcwipc_cst_tot)
            ttl_rct_tot = (ACCUMULATE TOTAL BY xxpcwipc_element xxpcwipc_cst_rct)
            .
      END. /* IF LAST-OF(xxpcwipc_element) THEN DO: */

      /* 创建列临时表 */
      FIND FIRST ttc
         WHERE ttc_n = xxpcwipc_n
         NO-LOCK NO-ERROR.
      IF NOT AVAILABLE ttc THEN DO:
         CREATE ttc.
         ASSIGN
            ttc_n = xxpcwipc_n
            .
      END.
   END.
   
   /* 输出 - 标题行1 */
   /* 固定列 */
   PUT UNFORMATTED 
      "年"
      ";" "期"
      ";" "地点"
      ";" ""
      ";" "父零件"
      ";" ""
      ";" ""
      ";" "子零件"
      ";" ""
      ";" ""
      ";" "成本要素"
      ";" ""
      ";" "合计"
      ";" ""
      ";" ""
      .
   /* 动态列 */
   FOR EACH ttc NO-LOCK:
      PUT UNFORMATTED
         ";" "第" ttc_n "次"
         ";" ""
         ";" ""
         .
   END.
   PUT SKIP.
   
   /* 输出 - 标题行2 */
   /* 固定列 */
   PUT UNFORMATTED 
      "份"
      ";" "间"
      ";" "代码"
      ";" "说明"
      ";" "代码"
      ";" "说明"
      ";" "加工单"
      ";" "代码"
      ";" "说明"
      ";" "用量"
      ";" "代码"
      ";" "说明"
      ";" "领料均成"
      ";" "领料总成"
      ";" "入库总成"
      .
   /* 动态列 */
   FOR EACH ttc NO-LOCK:
      PUT UNFORMATTED
         ";" "领料均成"
         ";" "领料总成"
         ";" "入库总成"
         .
   END.
   PUT SKIP.

   /* 输出 - 数据行 */
   FOR EACH ttl NO-LOCK:
      /* 固定列 */
      PUT UNFORMATTED 
         ttl_year
         ";" ttl_per
         ";" ttl_site
         ";" ttl_site_desc
         ";" ttl_par
         ";" ttl_par_desc
         ";" ttl_lot
         ";" ttl_comp
         ";" ttl_comp_desc
         ";" ttl_qty
         ";" ttl_element
         ";" ttl_element_desc
         ";" ttl_cst
         ";" ttl_cst_tot
         ";" ttl_rct_tot
         .

      /* 动态列 */
      FOR EACH ttc NO-LOCK:
         FIND FIRST xxpcwipc_det
            WHERE xxpcwipc_domain = GLOBAL_domain
            AND xxpcwipc_site = ttl_site
            AND xxpcwipc_year = ttl_year
            AND xxpcwipc_per = ttl_per
            AND xxpcwipc_par = ttl_par
            AND xxpcwipc_lot = ttl_lot
            AND xxpcwipc_comp = ttl_comp
            AND xxpcwipc_n = ttc_n
            AND xxpcwipc_element = INTEGER(ttl_element)
            NO-LOCK NO-ERROR.
         IF AVAILABLE xxpcwipc_det THEN DO:
            PUT UNFORMATTED
               ";" xxpcwipc_cst
               ";" xxpcwipc_cst_tot
               ";" xxpcwipc_cst_rct
               .
         END.
         ELSE DO:
            PUT UNFORMATTED
               ";" 0
               ";" 0
               ";" 0
               .
         END.
      END.

      PUT SKIP.
   END.

   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
