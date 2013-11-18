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
/* SS - 091106.1 By: Bill Jiang */

/* SS - 091106.1 - RNB
[091106.1]

忽略数量为0的记录

[091106.1]

SS - 091106.1 - RNE */

/* SS - 090808.1 - RNB
[090808.1]

1.限库存(tr_ship_type="")事务类型:ISS-WO
2.计算成本,不可设置
3.未处理过程工单

错误:总账日历没维护,总账日历已结,上期未结,本期已结!

警告:记录已经存在,是否继续?

[090808.1]

SS - 090808.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "091106.1"}

define variable per like glc_per.
define variable yr like glc_year.
define variable entity like glcd_entity.

DEFINE VARIABLE date1 AS DATE.
define variable l_yn        like mfc_logical             no-undo.

define variable efdate like tr_effdate.
define variable efdate1 like tr_date.

DEFINE VARIABLE arg1 AS CHARACTER.
DEFINE VARIABLE arg2 AS CHARACTER.

DEFINE VARIABLE continue AS LOGICAL NO-UNDO.

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

   {gprun.i ""xxpcprhcv.p"" "(
      INPUT entity,
      INPUT yr,
      INPUT per,
      INPUT-OUTPUT efdate,
      INPUT-OUTPUT efdate1
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
      ,EACH xxpcwoi_hist NO-LOCK
      WHERE xxpcwoi_domain = GLOBAL_domain
      AND xxpcwoi_site = si_site
      AND xxpcwoi_year = yr
      AND xxpcwoi_per = per
      :
      /* 301606 - 记录已经存在.是否继续? */
      {pxmsg.i &MSGNUM=301606 &ERRORLEVEL=2 &CONFIRM=l_yn}

      if not l_yn then do:
         next-prompt per.
         UNDO mainloop, retry.
      end. /* IF NOT l_yn */

      LEAVE.
   END.

   {xxSoftspeedLic.i "SoftspeedPC.lic" "SoftspeedPC"}

   continue = YES.
   DO TRANSACTION ON STOP UNDO:
      /* 删除已有的数据 */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxpcwoi_hist EXCLUSIVE-LOCK
         WHERE xxpcwoi_domain = GLOBAL_domain
         AND xxpcwoi_site = si_site
         AND xxpcwoi_year = yr
         AND xxpcwoi_per = per
         :
         DELETE xxpcwoi.
      END.

      /* 写入 */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH tr_hist NO-LOCK
         WHERE tr_domain = GLOBAL_domain
         AND tr_effdate >= efdate
         AND tr_effdate <= efdate1
         AND tr_site = si_site
         AND tr_type = "ISS-WO"
         AND tr_ship_type = ""
         BREAK
         BY tr_site
         BY tr_lot
         BY tr_part
         :
         ACCUMULATE tr_qty_loc (TOTAL
                                BY tr_site
                                BY tr_lot
                                BY tr_part
                                ).
         IF LAST-OF(tr_part) THEN DO:
            /* SS - 091106.1 - B */
            IF (ACCUMULATE TOTAL BY tr_part tr_qty_loc) = 0 THEN DO:
               NEXT.
            END.
            /* SS - 091106.1 - E */

            FIND FIRST wo_mstr
               WHERE wo_domain = GLOBAL_domain
               AND wo_lot = tr_lot
               NO-LOCK NO-ERROR.
            IF NOT AVAILABLE wo_mstr THEN DO:
               /* 301611 - 以下库存事务找不到对应的加工单:事务[#] */
               arg1 = STRING(tr_trnbr).
               {pxmsg.i &MSGNUM=301611 &ERRORLEVEL=3 &MSGARG1=arg1}
               continue = NO.
               STOP.
            END.

            CREATE xxpcwoi_hist.
            ASSIGN
               xxpcwoi_domain = GLOBAL_domain
               xxpcwoi_site = tr_site
               xxpcwoi_year = yr
               xxpcwoi_per = per
               xxpcwoi_par = wo_part
               xxpcwoi_lot = tr_lot
               xxpcwoi_comp = tr_part
               xxpcwoi_qty = (ACCUMULATE TOTAL BY tr_part tr_qty_loc)
               .
         END. /* IF LAST-OF(tr_part) THEN DO: */
      END. /* FOR EACH si_mstr NO-LOCK */
   END. /* DO TRANSACTION ON STOP UNDO: */
   IF continue = NO THEN DO:
      next-prompt per.
      UNDO mainloop, RETRY mainloop.
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

   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   EXPORT DELIMITER ";" 
      "地点"
      "年份"
      "期间"
      "父件"
      "父名"
      "工单"
      "子件"
      "数量"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpcwoi_hist NO-LOCK
      WHERE xxpcwoi_domain = GLOBAL_domain
      AND xxpcwoi_site = si_site
      AND xxpcwoi_year = yr
      AND xxpcwoi_per = per
      ,EACH pt_mstr NO-LOCK
      WHERE pt_domain = GLOBAL_domain
      AND pt_part = xxpcwoi_par
      BY xxpcwoi_site
      BY xxpcwoi_year
      BY xxpcwoi_per
      BY xxpcwoi_par
      BY xxpcwoi_lot
      BY xxpcwoi_comp
      :
      EXPORT DELIMITER ";"
         xxpcwoi_site
         xxpcwoi_year
         xxpcwoi_per
         xxpcwoi_par
         (pt_desc1 + " " + pt_desc2)
         xxpcwoi_lot
         xxpcwoi_comp
         xxpcwoi_qty
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
