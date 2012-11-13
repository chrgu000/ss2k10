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

/* SS - 090808.1 By: Bill Jiang */
/* SS - 100309.1 By: Bill Jiang */
/* SS - 110808.1 By: Kaine Zhang */

/* SS - 100309.1 - RNB
[100309.1]

增加了以下输出:产品线代码,产品线说明,库存账户

[100309.1]

SS - 100309.1 - RNE */

/* DISPLAY TITLE */
/* SS - 110808.1 - B
{mfdtitle.i "100309.1"}
SS - 110808.1 - E */

/* SS - 110808.1 - B */
{mfdeclre.i}
{gplabel.i}

define input parameter sEntityA as character no-undo.
define input parameter sEntityB as character no-undo.
define input parameter sSiteA as character no-undo.
define input parameter sSiteB as character no-undo.
define input parameter sPartA as character no-undo.
define input parameter sPartB as character no-undo.
define input parameter sElementA as character no-undo.
define input parameter sElementB as character no-undo.
define input parameter iYear as integer no-undo.
define input parameter iMonth as integer no-undo.

{xxfoocost1.i "shared"}
/* SS - 110808.1 - E */

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
DEFINE VARIABLE find-can AS LOGICAL.

DEFINE BUFFER enmstr FOR en_mstr.
DEFINE BUFFER simstr FOR si_mstr.

DEFINE VARIABLE c1 AS CHARACTER.
DEFINE VARIABLE dec1 AS DECIMAL EXTENT 2.
DEFINE VARIABLE dec2 AS DECIMAL EXTENT 2.

DEFINE VARIABLE yrper AS CHARACTER.

DEFINE TEMP-TABLE ttp1
   FIELD ttp1_part AS CHARACTER
   FIELD ttp1_qty AS DECIMAL
   FIELD ttp1_cst AS DECIMAL
   INDEX ttp1_part ttp1_part
   .

DEFINE TEMP-TABLE ttp2
   FIELD ttp2_part AS CHARACTER
   FIELD ttp2_qty AS DECIMAL
   FIELD ttp2_cst AS DECIMAL
   INDEX ttp2_part ttp2_part
   .

DEFINE TEMP-TABLE ttt1
   FIELD ttt1_part AS CHARACTER
   FIELD ttt1_type AS CHARACTER
   FIELD ttt1_ri AS CHARACTER
   FIELD ttt1_qty AS DECIMAL
   FIELD ttt1_cst AS DECIMAL
   INDEX ttt1_part_type_ri ttt1_part ttt1_type ttt1_ri
   INDEX ttt1_type_ri ttt1_type ttt1_ri
   .

DEFINE TEMP-TABLE ttt2
   FIELD ttt2_part AS CHARACTER
   FIELD ttt2_type AS CHARACTER
   FIELD ttt2_ri AS CHARACTER
   FIELD ttt2_qty AS DECIMAL
   FIELD ttt2_cst AS DECIMAL
   INDEX ttt2_part_type_ri ttt2_part ttt2_type ttt2_ri
   INDEX ttt2_type_ri ttt2_type ttt2_ri
   INDEX ttt2_ri ttt2_ri
   INDEX ttt2_type ttt2_type
   .

{glcabmeg.i} /* module closing engine include. */

/* SS - 110808.1 - B
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
SS - 110808.1 - E */

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

/* SS - 110808.1 - B
{wbrp01.i}
SS - 110808.1 - E */

/* REPORT BLOCK */
/* SS - 110808.1 - B
mainloop:
repeat:
SS - 110808.1 - E */
/* SS - 110808.1 - B */
mainloop:
do on error undo, return:
/* SS - 110808.1 - E */
   if entity1 = hi_char then entity1 = "".
   if site1 = hi_char then site1 = "".
   if part1 = hi_char then part1 = "".
   if element1 = hi_char then element1 = "".
   if type1 = hi_char then type1 = "".

   /* SS - 110808.1 - B
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
   SS - 110808.1 - E */


    /* SS - 110808.1 - B */
    assign
        entity      = sEntityA
        entity1     = sEntityB
        site        = sSiteA
        site1       = sSiteB
        part        = sPartA
        part1       = sPartB
        element     = sElementA
        element1    = sElementB
        yr          = iYear
        per         = iMonth
        .
    
    if entity1 = "" then entity1 = hi_char.
    if site1 = "" then site1 = hi_char.
    if part1 = "" then part1 = hi_char.
    if element1 = "" then element1 = hi_char.
    if type1 = "" then type1 = hi_char.
    /* SS - 110808.1 - E */

   /* 创建期初 */
   EMPTY TEMP-TABLE ttp1.
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity >= entity
      AND en_entity <= entity1
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_site >= site
      AND si_site <= site1
      AND si_entity = en_entity
      ,EACH xxpcinb_mstr NO-LOCK
      WHERE xxpcinb_domain = GLOBAL_domain
      AND xxpcinb_site = si_site
      AND xxpcinb_year = yr
      AND xxpcinb_per = per
      ,EACH pt_mstr NO-LOCK
      WHERE pt_domain = GLOBAL_domain
      AND pt_part = xxpcinb_part
      AND pt_part >= part
      AND pt_part <= part1
      BREAK
      BY xxpcinb_part
      :
      ACCUMULATE xxpcinb_qty (TOTAL BY xxpcinb_part).

      IF LAST-OF(xxpcinb_part) THEN DO:
         IF (ACCUMULATE TOTAL BY xxpcinb_part xxpcinb_qty) <> 0 THEN DO:
            CREATE ttp1.
            ASSIGN
               ttp1_part = xxpcinb_part
               ttp1_qty = (ACCUMULATE TOTAL BY xxpcinb_part xxpcinb_qty)
               .
         END.
      END. /* IF LAST-OF(xxpcinb_part) THEN DO: */
   END.
   {xxpctrczb.i}

   /* 创建事务 */
   EMPTY TEMP-TABLE ttt1.
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity >= entity
      AND en_entity <= entity1
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_site >= site
      AND si_site <= site1
      AND si_entity = en_entity
      ,EACH xxpctr_hist NO-LOCK
      WHERE xxpctr_domain = GLOBAL_domain
      AND xxpctr_site = si_site
      AND xxpctr_year = yr
      AND xxpctr_per = per
      ,EACH pt_mstr NO-LOCK
      WHERE pt_domain = GLOBAL_domain
      AND pt_part = xxpctr_part
      AND pt_part >= part
      AND pt_part <= part1
      BREAK
      BY xxpctr_part
      BY xxpctr_type
      :
      ACCUMULATE xxpctr_qty (TOTAL
         BY xxpctr_part
         BY xxpctr_type
         ).

      IF LAST-OF(xxpctr_type) THEN DO:
         FIND FIRST ttp1
            WHERE ttp1_part = xxpctr_part
            NO-LOCK NO-ERROR.
         IF NOT AVAILABLE ttp1 THEN DO:
            CREATE ttp1.
            ASSIGN
               ttp1_part = xxpctr_part
               .
         END.

         CREATE ttt1.
         ASSIGN
            ttt1_part = xxpctr_part
            ttt1_type = xxpctr_type
            ttt1_ri = "R"
            ttt1_qty = (ACCUMULATE TOTAL BY xxpctr_type xxpctr_qty)
            .
         {xxpctrcza.i}
         IF (ACCUMULATE TOTAL BY xxpctr_type xxpctr_qty) > 0 THEN DO:
            ASSIGN
               ttt1_ri = "R"
               .
         END. /* IF (ACCUMULATE TOTAL BY xxpctr_type xxpctr_qty) > 0 THEN DO: */
         ELSE IF (ACCUMULATE TOTAL BY xxpctr_type xxpctr_qty) < 0 THEN DO:
            ASSIGN
               ttt1_ri = "I"
               .
         END. /* IF (ACCUMULATE TOTAL BY xxpctr_type xxpctr_qty) > 0 THEN DO: */
      END. /* IF LAST-OF(xxpctr_type) THEN DO: */
   END.

   /* 创建零件列表及其期初 */
   EMPTY TEMP-TABLE ttp2.
   FOR EACH ttp1 
      BREAK 
      BY ttp1_part
      :
      ACCUMULATE ttp1_qty (TOTAL
                            BY ttp1_part
                            ).
      ACCUMULATE ttp1_cst (TOTAL
                            BY ttp1_part
                            ).
      IF LAST-OF(ttp1_part) THEN DO:
         CREATE ttp2.
         ASSIGN
            ttp2_part = ttp1_part
            ttp2_qty = (ACCUMULATE TOTAL BY ttp1_part ttp1_qty)
            ttp2_cst = (ACCUMULATE TOTAL BY ttp1_part ttp1_cst)
            .
      END.
   END.

   /* 创建事务列表 */
   EMPTY TEMP-TABLE ttt2.
   FOR EACH ttt1
      BREAK
      BY ttt1_type
      BY ttt1_ri
      :
      IF LAST-OF(ttt1_ri) THEN DO:
         CREATE ttt2.
         ASSIGN
            ttt2_type = ttt1_type
            ttt2_ri = ttt1_ri
            .
      END.
   END.

   yrper = STRING(yr) + ";" + STRING(per).

   /* SS - 110808.1 - B
   /* 标题行1 */
   PUT UNFORMATTED yrper ";" "件;件;产品线;;库存;期初;;;增加合计;;".
   FOR EACH ttt2 WHERE ttt2_ri = "R" BY ttt2_type:
      PUT UNFORMATTED ";" ttt2_type ";" "" ";" "".
   END.
   PUT UNFORMATTED ";减少合计;;".
   FOR EACH ttt2 WHERE ttt2_ri = "I" BY ttt2_type:
      PUT UNFORMATTED ";" ttt2_type ";" "" ";" "".
   END.
   PUT UNFORMATTED ";期末;;".
   PUT SKIP.

   /* 标题行2 */
   PUT UNFORMATTED yrper ";" ";;;;;;;;;;".
   FOR EACH ttt2 WHERE ttt2_ri = "R" BY ttt2_type:
      PUT UNFORMATTED ";" ";" "" ";" "".
   END.
   PUT UNFORMATTED ";;;".
   FOR EACH ttt2 WHERE ttt2_ri = "I" BY ttt2_type:
      PUT UNFORMATTED ";" ";" "" ";" "".
   END.
   PUT UNFORMATTED ";;;".
   PUT SKIP.

   /* 标题行3 */
   PUT UNFORMATTED yrper ";" "号;名;代码;说明;账户;数量;均成;总成;数量;均成;总成".
   FOR EACH ttt2 WHERE ttt2_ri = "R" BY ttt2_type:
      PUT UNFORMATTED ";数量;均成;总成".
   END.
   PUT UNFORMATTED ";数量;均成;总成".
   FOR EACH ttt2 WHERE ttt2_ri = "I" BY ttt2_type:
      PUT UNFORMATTED ";数量;均成;总成".
   END.
   PUT UNFORMATTED ";数量;均成;总成".
   PUT SKIP.
   SS - 110808.1 - E */

   /* 数据行 */
   FOR EACH ttp2
      ,EACH pt_mstr NO-LOCK
      WHERE pt_domain = GLOBAL_domain
      AND pt_part = ttp2_part
      /* SS - 100309.1 - B */
      ,EACH pl_mstr NO-LOCK
      WHERE pl_domain = GLOBAL_domain
      AND pl_prod_line = pt_prod_line
      /* SS - 100309.1 - E */
      BY ttp2_part:
      
      /* SS - 110808.1 - B
      /* 件号,件名,产品线代码,产品线说明,库存账户,期初 */
      IF ttp2_qty = 0 THEN DO:
         PUT UNFORMATTED yrper ";" pt_part ";" pt_desc1 + " " + pt_desc2 ";" pl_prod_line ";" pl_desc ";" pl_inv_acct ";" ttp2_qty ";" 0 ";" ttp2_cst.
      END.
      ELSE DO:
         PUT UNFORMATTED yrper ";" pt_part ";" pt_desc1 + " " + pt_desc2 ";" pl_prod_line ";" pl_desc ";" pl_inv_acct ";" ttp2_qty ";" (ttp2_cst / ttp2_qty) ";" ttp2_cst.
      END.
      SS - 110808.1 - E */

      /* 增加 */
      c1 = "".
      dec1[1] = 0.
      dec1[2] = 0.
      FOR EACH ttt2 WHERE ttt2_ri = "R" BY ttt2_type:
         FIND FIRST ttt1 WHERE ttt1_part = ttp2_part AND ttt1_type = ttt2_type AND ttt1_ri = "R" NO-LOCK NO-ERROR.
         IF AVAILABLE ttt1 THEN DO:
            IF ttt1_qty = 0 THEN DO:
               c1 = c1 + ";" + STRING(ttt1_qty) + ";" + STRING(0) + ";" + STRING(ttt1_cst).
            END.
            ELSE DO:
               c1 = c1 + ";" + STRING(ttt1_qty) + ";" + STRING(ttt1_cst / ttt1_qty) + ";" + STRING(ttt1_cst).
            END.
            dec1[1] = dec1[1] + ttt1_qty.
            dec1[2] = dec1[2] + ttt1_cst.
         END.
         ELSE DO:
            c1 = c1 + ";" + STRING(0) + ";" + STRING(0) + ";" + STRING(0).
         END.
      END.
      dec2[1] = dec1[1].
      dec2[2] = dec1[2].
      IF dec1[1] = 0 THEN DO:
         c1 = ";" + STRING(dec1[1]) + ";" + STRING(0) + ";" + STRING(dec1[2]) + c1.
      END.
      ELSE DO:
         c1 = ";" + STRING(dec1[1]) + ";" + STRING(dec1[2] / dec1[1]) + ";" + STRING(dec1[2]) + c1.
      END.
      /* SS - 110808.1 - B
      PUT UNFORMATTED c1.
      SS - 110808.1 - E */

      /* 减少 */
      c1 = "".
      dec1[1] = 0.
      dec1[2] = 0.
      FOR EACH ttt2 WHERE ttt2_ri = "I" BY ttt2_type:
         FIND FIRST ttt1 WHERE ttt1_part = ttp2_part AND ttt1_type = ttt2_type AND ttt1_ri = "I" NO-LOCK NO-ERROR.
         IF AVAILABLE ttt1 THEN DO:
            IF ttt1_qty = 0 THEN DO:
               c1 = c1 + ";" + STRING(ttt1_qty) + ";" + STRING(0) + ";" + STRING(ttt1_cst).
            END.
            ELSE DO:
               c1 = c1 + ";" + STRING(ttt1_qty) + ";" + STRING(ttt1_cst / ttt1_qty) + ";" + STRING(ttt1_cst).
            END.
            dec1[1] = dec1[1] + ttt1_qty.
            dec1[2] = dec1[2] + ttt1_cst.
         END.
         ELSE DO:
            c1 = c1 + ";" + STRING(0) + ";" + STRING(0) + ";" + STRING(0).
         END.
      END.
      IF dec1[1] = 0 THEN DO:
         c1 = ";" + STRING(dec1[1]) + ";" + STRING(0) + ";" + STRING(dec1[2]) + c1.
      END.
      ELSE DO:
         c1 = ";" + STRING(dec1[1]) + ";" + STRING(dec1[2] / dec1[1]) + ";" + STRING(dec1[2]) + c1.
      END.
      /* SS - 110808.1 - B
      PUT UNFORMATTED c1.
      SS - 110808.1 - E */

      /* SS - 110808.1 - B
      /* 期末 */
      IF (ttp2_qty + dec2[1] + dec1[1]) = 0 THEN DO:
         PUT UNFORMATTED ";" STRING(ttp2_qty + dec2[1] + dec1[1]) ";" STRING(0) ";" STRING(ttp2_cst + dec2[2] + dec1[2]).
      END.
      ELSE DO:
         PUT UNFORMATTED ";" STRING(ttp2_qty + dec2[1] + dec1[1]) ";" STRING((ttp2_cst + dec2[2] + dec1[2]) / (ttp2_qty + dec2[1] + dec1[1])) ";" STRING(ttp2_cst + dec2[2] + dec1[2]).
      END.

      PUT SKIP.
      SS - 110808.1 - E */
      
      
        /* SS - 110808.1 - B */
        create tfoo1_tmp.
        assign
            tfoo1_part = pt_part
            tfoo1_cost =
                if (ttp2_qty + dec2[1] + dec1[1]) = 0 then
                    0
                else 
                    (ttp2_cst + dec2[2] + dec1[2]) / (ttp2_qty + dec2[1] + dec1[1])
            .
        /* SS - 110808.1 - E */
   END. /* FOR EACH ttp2 BY ttp2_part: */
   
   /* SS - 110808.1 - B
   {xxmfrtrail.i}
   SS - 110808.1 - E */

end.

/* SS - 110808.1 - B
{wbrp04.i &frame-spec = a}
SS - 110808.1 - E */
