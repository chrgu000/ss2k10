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

/* SS - 090827.1 By: Bill Jiang */

/* SS - 090827.1 - RNB
[090827.1]

1.发放原则为否(pt_iss_pol = no)
2.加工单物料清单 * 入库数量(RCT-WO)
3.异常记录及其标识: IF ISS-UNP = 0 THEN QTY_ISS = 0

错误:总账日历没维护,总账日历已结,上期未结,本期已结!

警告:记录已经存在,是否继续?

[090827.1]

SS - 090827.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "090827.1"}

define variable per like glc_per.
define variable yr like glc_year.
define variable entity like glcd_entity.

DEFINE VARIABLE date1 AS DATE.
define variable l_yn        like mfc_logical             no-undo.

define variable part like tr_part.
define variable part1 like tr_part.
define variable nbr like tr_nbr.
define variable nbr1 like tr_nbr.
define variable so_job like tr_so_job.
define variable so_job1 like tr_so_job.
define variable lot like tr_lot.
define variable lot1 like tr_lot.
define variable loc like tr_loc.
define variable loc1 like tr_loc.
define variable efdate like tr_effdate.
define variable efdate1 like tr_date.
define variable glref  like trgl_gl_ref.
define variable glref1 like trgl_gl_ref.
/*
define variable entity like en_entity.
*/
define variable entity1 like en_entity.
define variable acct like glt_acct.
define variable acct1 like glt_acct.
define variable sub like glt_sub.
define variable sub1 like glt_sub.
define variable cc like glt_cc.
define variable cc1 like glt_cc.
define variable proj like glt_project.
define variable proj1 like glt_project.
define variable trdate like tr_date.
define variable trdate1 like tr_date.
define variable trtype like tr_type.

ASSIGN
   glref = "IC"
   glref1 = "ID"
   trtype = "ISS-WO"
   .

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
      ,EACH xxpcwod_hist NO-LOCK
      WHERE xxpcwod_domain = GLOBAL_domain
      AND xxpcwod_site = si_site
      AND xxpcwod_year = yr
      AND xxpcwod_per = per
      :
      /* 301606 - 记录已经存在.是否继续? */
      {pxmsg.i &MSGNUM=301606 &ERRORLEVEL=2 &CONFIRM=l_yn}

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

   DO TRANSACTION ON STOP UNDO:
      /* 删除已有的数据 */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxpcwod_hist EXCLUSIVE-LOCK
         WHERE xxpcwod_domain = GLOBAL_domain
         AND xxpcwod_site = si_site
         AND xxpcwod_year = yr
         AND xxpcwod_per = per
         :
         DELETE xxpcwod_hist.
      END.

      /* 写入 */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH wo_mstr NO-LOCK
         WHERE wo_domain = GLOBAL_domain
         AND wo_site = si_site
         ,EACH wod_det NO-LOCK
         WHERE wod_domain = GLOBAL_domain
         AND wod_lot = wo_lot
         ,EACH pt_mstr NO-LOCK
         WHERE pt_domain = GLOBAL_domain
         AND pt_part = wod_part
         AND pt_iss_pol = NO
         ,EACH xxpcwor_hist NO-LOCK
         WHERE xxpcwor_domain = GLOBAL_domain
         AND xxpcwor_site = si_site
         AND xxpcwor_year = yr
         AND xxpcwor_per = per
         AND xxpcwor_part = wo_part
         AND xxpcwor_lot = wo_lot
         AND xxpcwor_type = "RCT-WO"
         AND xxpcwor_qty <> 0
         BREAK
         BY wo_site
         BY wo_part
         BY wo_lot
         BY wod_part
         :
         ACCUMULATE wod_bom_qty (TOTAL 
                                     BY wo_site
                                     BY wo_part
                                     BY wo_lot
                                     BY wod_part
                                     ).

         IF LAST-OF(wod_part) THEN DO:
            FIND FIRST xxpcwod_hist
               WHERE xxpcwod_domain = GLOBAL_domain
               AND xxpcwod_site = si_site
               AND xxpcwod_year = yr
               AND xxpcwod_per = per
               AND xxpcwod_par = wo_part
               AND xxpcwod_lot = wo_lot
               AND xxpcwod_comp = wod_part
               EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE xxpcwod_hist THEN DO:
               CREATE xxpcwod_hist.
               ASSIGN
                  xxpcwod_domain = GLOBAL_domain
                  xxpcwod_site = si_site
                  xxpcwod_year = yr
                  xxpcwod_per = per
                  xxpcwod_par = wo_part
                  xxpcwod_lot = wo_lot
                  xxpcwod_comp = wod_part
                  .
            END.

            ASSIGN
               xxpcwod_qty = (ACCUMULATE TOTAL BY wod_part wod_bom_qty)
               xxpcwod_cst = wod_bom_amt
               xxpcwod_qty_tot = xxpcwod_qty * xxpcwor_qty
               xxpcwod_cst_tot = xxpcwod_qty_tot * xxpcwod_cst
               .
         END. /* IF LAST-OF(wod_part) THEN DO: */
      END. /* FOR EACH si_mstr NO-LOCK */
   END. /* DO TRANSACTION ON STOP UNDO: */

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
      "标准单量"
      "标准单成"
      "标准总量"
      "标准总成"
      "领料总量"
      "领料总成"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpcwod_hist NO-LOCK
      WHERE xxpcwod_domain = GLOBAL_domain
      AND xxpcwod_site = si_site
      AND xxpcwod_year = yr
      AND xxpcwod_per = per
      ,EACH pt_mstr NO-LOCK
      WHERE pt_domain = GLOBAL_domain
      AND pt_part = xxpcwod_par
      BY xxpcwod_site
      BY xxpcwod_year
      BY xxpcwod_per
      BY xxpcwod_par
      BY xxpcwod_lot
      BY xxpcwod_comp
      :
      EXPORT DELIMITER ";"
         xxpcwod_site
         xxpcwod_year
         xxpcwod_per
         xxpcwod_par
         (pt_desc1 + " " + pt_desc2)
         xxpcwod_lot
         xxpcwod_comp
         xxpcwod_qty
         xxpcwod_cst
         xxpcwod_qty_tot
         xxpcwod_cst_tot
         xxpcwod_qty_iss
         xxpcwod_cst_iss
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
