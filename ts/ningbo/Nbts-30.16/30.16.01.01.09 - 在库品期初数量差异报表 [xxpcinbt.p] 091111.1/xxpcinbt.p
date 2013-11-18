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

/* DISPLAY TITLE */
{mfdtitle.i "091111.1"}



{xxppptrp0701.i "new"}
/*
define variable part   like pt_part      no-undo.
define variable part1  like pt_part      no-undo.
*/
define variable line   like pt_prod_line no-undo.
define variable line1  like pt_prod_line no-undo.
define variable vend   like pt_vend      no-undo.
define variable vend1  like pt_vend      no-undo.
define variable abc    like pt_abc       no-undo.
define variable abc1   like pt_abc       no-undo.
/*
define variable site   like ld_site      no-undo.
define variable site1  like ld_site      no-undo.
*/
define variable loc    like ld_loc       no-undo.
define variable loc1   like ld_loc       no-undo.
define variable part_group        like pt_group     no-undo.
define variable part_group1       like pt_group     no-undo.
define variable part_type         like pt_part_type no-undo.
define variable part_type1        like pt_part_type no-undo.
define variable as_of_date        like tr_effdate no-undo.
define variable neg_qty           like mfc_logical no-undo.
define variable net_qty           like mfc_logical no-undo.
define variable inc_zero_qty      like mfc_logical no-undo.
define variable zero_cost         like mfc_logical no-undo.
define variable customer_consign as character no-undo.
define variable supplier_consign as character no-undo.
define variable l_recalculate like mfc_logical no-undo.



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

DEFINE TEMP-TABLE tt1
   FIELD tt1_site LIKE ld_site
   FIELD tt1_loc LIKE ld_loc
   FIELD tt1_part LIKE ld_part
   FIELD tt1_lot LIKE ld_lot
   FIELD tt1_ref LIKE ld_ref
   FIELD tt1_ld LIKE ld_qty_oh
   FIELD tt1_xxpcinb LIKE ld_qty_oh
   INDEX index1 tt1_site tt1_loc tt1_part tt1_lot tt1_ref
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
   /*
   element colon 20    
   element1 colon 50 label {t001.i}
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
         /*
         element 
         element1
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
      /*
      element 
      element1 
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

   /* QAD */
   FIND FIRST glc_cal 
      WHERE glc_domain = GLOBAL_domain
      AND glc_year = yr
      AND glc_per = per
      NO-LOCK NO-ERROR.
   IF NOT AVAILABLE glc_cal THEN DO:
      /* 无效期间/年份 */
      {pxmsg.i &MSGNUM=3008 &ERRORLEVEL=3}

      UNDO mainloop.
   END.
   AS_of_date = glc_start - 1.

   FOR EACH ttxxppptrp0701:
       DELETE ttxxppptrp0701.
   END.

   neg_qty = YES.
   net_qty = YES.
   inc_zero_qty = NO.
   zero_cost = YES.
   l_recalculate = YES.
   {gprun.i ""xxppptrp0701_xxpcinbt.p"" "(
      INPUT part,
      INPUT part1,
      INPUT LINE,
      INPUT line1,
      INPUT vend,
      INPUT vend1,
      INPUT abc,
      INPUT abc1,
      INPUT site,
      INPUT site1,
      INPUT loc,
      INPUT loc1,
      INPUT part_group,
      INPUT part_group1,
      INPUT part_type,
      INPUT part_type1,

      INPUT AS_of_date,
      INPUT neg_qty,
      INPUT net_qty,
      INPUT inc_zero_qty,
      INPUT zero_cost,
      INPUT customer_consign,
      INPUT supplier_consign,
      INPUT l_recalculate
      )"}

   FOR EACH tt1:
      DELETE tt1.
   END.

   FOR EACH ttxxppptrp0701
      BREAK
      BY ttxxppptrp0701_site
      BY ttxxppptrp0701_part
      :
      ACCUMULATE ttxxppptrp0701_qty (TOTAL
                                     BY ttxxppptrp0701_site
                                     BY ttxxppptrp0701_part
                                     ).
      IF LAST-OF(ttxxppptrp0701_part) THEN DO:
         IF (ACCUMULATE TOTAL BY ttxxppptrp0701_part ttxxppptrp0701_qty) <> 0 THEN DO:
            CREATE tt1.
            ASSIGN
               tt1_site = ttxxppptrp0701_site
               tt1_part = ttxxppptrp0701_part
               tt1_ld = (ACCUMULATE TOTAL BY ttxxppptrp0701_part ttxxppptrp0701_qty)
               .
         END. /* IF (ACCUMULATE TOTAL BY ttxxppptrp0701_part ttxxppptrp0701_qty) <> 0 THEN DO: */
      END. /* IF LAST-OF(ttxxppptrp0701_part) THEN DO: */
   END. /* FOR EACH ttxxppptrp0701 */

   /* PC */
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
      :
      FIND FIRST tt1
         WHERE tt1_site = xxpcinb_site
         AND tt1_part = xxpcinb_part
         EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE tt1 THEN DO:
         CREATE tt1.
         ASSIGN
            tt1_site = xxpcinb_site
            tt1_part = xxpcinb_part
            .
      END.
      ASSIGN
         tt1_xxpcinb = xxpcinb_qty
         .
   END.

   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   EXPORT DELIMITER ";"
      "地点"
      "库位"
      "零件"
      "批序号"
      "参考号"
      "标准系统数量"
      "期间成本数量"
      "数量差异"
      .
   FOR EACH tt1:
      EXPORT DELIMITER ";"
         tt1_site
         tt1_loc
         tt1_part
         tt1_lot
         tt1_ref
         tt1_ld
         tt1_xxpcinb
         (tt1_ld - tt1_xxpcinb)
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
