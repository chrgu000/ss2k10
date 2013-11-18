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

/* SS - 091126.1 By: Bill Jiang */

/* SS - 091126.1 - RNB
[091126.1]

顺序包括以下列:
  - 地点
  - 年份
  - 期间
  - 零件
  - 工单
  - 期末数量

请特别留意日期类型的列,其格式通常为"MM/DD/YY"

问号"?"表示空的日期

可用导出的文件做为导入的模板并进行相应的更新

另请参见
  - 加工单事务导入 [xxpcwoi.p]
  
[091126.1]

SS - 091126.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "091126.1"}

define variable per like glc_per.
define variable per1 like glc_per.
define variable yr like glc_year.
define variable yr1 like glc_year.
define variable entity like glcd_entity.
define variable entity1 like glcd_entity.
DEFINE VARIABLE date1 AS DATE.

{glcabmeg.i} /* module closing engine include. */

/* SELECT FORM */
form
   entity colon 20    entity1 colon 40 label {t001.i}
   yr     colon 20    yr1     colon 40  label {t001.i}
   per     colon 20    per1     colon 40  label {t001.i}
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
   yr1 = glc_year.
   per = glc_per.
   per1 = glc_per.
END.

{wbrp01.i}

/* REPORT BLOCK */
mainloop:
repeat:
   if entity1 = hi_char then entity1 = "".

   if c-application-mode <> 'web' then
      update
         entity entity1
         yr yr1
         per per1
      with frame a.

   {wbrp06.i &command = update &fields = "  entity entity1 yr yr1 per per1" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      if entity1 = "" then entity1 = hi_char.

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {mfquoter.i entity }
      {mfquoter.i entity1}
      {mfquoter.i yr     }
      {mfquoter.i yr1    }
      {mfquoter.i per     }
      {mfquoter.i per1    }
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

   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.
      
   EXPORT DELIMITER ";" 
      "地点"
      "年份"
      "期间"
      "零件"
      "工单"
      "数量"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity >= entity
      AND en_entity <= entity1
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpcwo_mstr NO-LOCK
      WHERE xxpcwo_domain = GLOBAL_domain
      AND xxpcwo_site = si_site
      AND xxpcwo_year >= yr
      AND xxpcwo_year <= yr1
      AND xxpcwo_per >= per
      AND xxpcwo_per <= per1
      BY xxpcwo_site
      BY xxpcwo_year
      BY xxpcwo_per
      BY xxpcwo_part
      BY xxpcwo_lot
      :
      EXPORT DELIMITER ";"
         xxpcwo_site
         xxpcwo_year
         xxpcwo_per
         xxpcwo_part
         xxpcwo_lot
         xxpcwo_qty_end
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
