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

define variable efdate like tr_effdate.
define variable efdate1 like tr_date.

DEFINE TEMP-TABLE tt1
   FIELD tt1_site LIKE tr_site
   FIELD tt1_part LIKE tr_part
   FIELD tt1_type LIKE tr_type
   FIELD tt1_qty LIKE tr_qty_loc
   INDEX index1 tt1_site tt1_part tt1_type
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
   */
   type colon 20    
   type1 colon 50 label {t001.i}
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
         */
         type 
         type1
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
      */
      type 
      type1 
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

   EXPORT DELIMITER ";" 
      "年份"
      "期间"
      "地点代码"
      "地点说明"
      "件号"
      "件名"
      "事务类型"
      "数量"
      "不计成本数量"
      "计算成本数量"
      "标准系统数量"
      "数量差异"
      .

   FOR EACH glc_cal NO-LOCK
      WHERE glc_domain = GLOBAL_domain 
      AND glc_year = yr 
      AND glc_per = per
      :
      efdate = glc_start.
      efdate1 = glc_end.
   
      LEAVE.
   END.

   FOR EACH tt1:
      DELETE tt1.
   END.

   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity >= entity
      AND en_entity <= entity1
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_site >= site
      AND si_site <= site1
      AND si_entity = entity
      ,EACH tr_hist NO-LOCK
      WHERE tr_domain = GLOBAL_domain
      AND tr_effdate >= efdate
      AND tr_effdate <= efdate1
      AND tr_part >= part
      AND tr_part <= part1
      AND tr_type >= TYPE
      AND tr_type <= TYPE1
      AND tr_site = si_site
      AND tr_ship_type = ""
      BREAK
      BY tr_site
      BY tr_part
      BY tr_type
      :
      ACCUMULATE tr_qty_loc (TOTAL BY tr_site BY tr_part BY tr_type).

      IF LAST-OF(tr_type) 
         /*
         AND (ACCUMULATE TOTAL BY tr_type tr_qty_loc) <> 0
         */
         THEN DO:
         CREATE tt1.
         ASSIGN
            tt1_site = tr_site
            tt1_part = tr_part
            tt1_type = tr_type
            tt1_qty = (ACCUMULATE TOTAL BY tr_type tr_qty_loc)
            .
      END. /* IF LAST-OF(tr_type) THEN DO: */
   END.

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
      AND xxpctr_type >= TYPE
      AND xxpctr_type <= TYPE1
      ,EACH pt_mstr NO-LOCK
      WHERE pt_domain = GLOBAL_domain
      AND pt_part = xxpctr_part
      AND pt_part >= part
      AND pt_part <= part1
      ,EACH tt1 NO-LOCK
      WHERE tt1_site = xxpctr_site
      AND tt1_part = xxpctr_part
      AND tt1_type = xxpctr_type
      BY xxpctr_site
      BY xxpctr_part
      :
      EXPORT DELIMITER ";"
         xxpctr_year
         xxpctr_per
         si_site
         si_desc
         pt_part
         (pt_desc1 + " " + pt_desc2)
         xxpctr_type
         xxpctr_qty
         xxpctr_qty0
         xxpctr_qty1
         tt1_qty
         (xxpctr_qty - tt1_qty)
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
