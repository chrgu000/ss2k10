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

/* SS - 090807.1 - RNB
[090807.1]

1.在库品成本结转
1)子件用量 = <加工单领料历史记录文件>.数量
2)子件总成 = 子件用量 * <在库品成本计算明细文件(1)>.期间均成
3)子件入库成本 = 子件总成 * <加工单增减存主文件>.期间入库比例

2.在制品成本结转
             ∑期初和期间非领料总成 * 期间入库比例
4)子件单成 = ------------------------------------------------------
             期初数量 + 收货数量 + 入库数量 + 不计成本的其他增加数量

3.在库(制)品入库成本结转
             上次入库成本
1)子件单成 = ------------------------------------------------------
             期初数量 + 收货数量 + 入库数量 + 不计成本的其他增加数量
2)子件用量 = <加工单领料历史记录文件>.数量
3)子件总成 = 子件用量 * 子件单成
4)子件入库成本 = 子件总成 * <加工单增减存主文件>.期间入库比例
5)直到上次入库成本小于设置的容差

[090807.1]

SS - 090807.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "090807.1"}

{xxpcwipc.i "new"}

define variable per like glc_per.
define variable yr like glc_year.
define variable entity like glcd_entity.
DEFINE VARIABLE date1 AS DATE.
DEFINE VARIABLE find-can AS LOGICAL.
define variable l_yn        like mfc_logical             no-undo.
DEFINE VARIABLE qty0 AS DECIMAL.

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
      ,EACH xxpcwipc_det NO-LOCK
      WHERE xxpcwipc_domain = GLOBAL_domain
      AND xxpcwipc_site = si_site
      AND xxpcwipc_year = yr
      AND xxpcwipc_per = per
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
         ,EACH xxpcwipc_det EXCLUSIVE-LOCK
         WHERE xxpcwipc_domain = GLOBAL_domain
         AND xxpcwipc_site = si_site
         AND xxpcwipc_year = yr
         AND xxpcwipc_per = per
         :
         DELETE xxpcwipc_det.
      END.

      /* 更新 */
      /* 0.期初数量 + 收货数量 + 入库数量 + 不计成本的其他增加数量 */
      {gprun.i ""xxpcwipcq.p"" "(
         INPUT entity,
         INPUT yr,
         INPUT per
         )"}

      /* 1.在库品成本结转 */
      {gprun.i ""xxpcwipc1.p"" "(
         INPUT entity,
         INPUT yr,
         INPUT per
         )"}

      /* 2.在制品成本结转 */
      {gprun.i ""xxpcwipc2.p"" "(
         INPUT entity,
         INPUT yr,
         INPUT per
         )"}

      /* 3.在库(制)品入库成本结转 */
      {gprun.i ""xxpcwipc3.p"" "(
         INPUT entity,
         INPUT yr,
         INPUT per
         )"}

      /* N.上次入库成本结转 */
      {gprun.i ""xxpcwipcn.p"" "(
         INPUT entity,
         INPUT yr,
         INPUT per,
         INPUT 4
         )"}
   END. /* DO TRANSACTION ON STOP UNDO: */

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
      "工单"
      "子件"
      "次数"
      "成本要素"
      "数量"
      "单成"
      "领料总成"
      "入库总成"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpcwipc_det NO-LOCK
      WHERE xxpcwipc_domain = GLOBAL_domain
      AND xxpcwipc_site = si_site
      AND xxpcwipc_year = yr
      AND xxpcwipc_per = per
      BY xxpcwipc_site
      BY xxpcwipc_year
      BY xxpcwipc_per
      BY xxpcwipc_par
      BY xxpcwipc_lot
      BY xxpcwipc_comp
      BY xxpcwipc_n
      BY xxpcwipc_element
      :
      EXPORT DELIMITER ";"
         xxpcwipc_site
         xxpcwipc_year
         xxpcwipc_per
         xxpcwipc_par
         xxpcwipc_lot
         xxpcwipc_comp
         xxpcwipc_n
         xxpcwipc_element
         xxpcwipc_qty
         xxpcwipc_cst
         xxpcwipc_cst_tot
         xxpcwipc_cst_rct
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
