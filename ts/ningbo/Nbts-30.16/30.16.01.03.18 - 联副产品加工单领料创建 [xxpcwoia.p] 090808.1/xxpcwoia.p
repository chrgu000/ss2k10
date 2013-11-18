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

/* SS - 090808.1 - RNB
[090808.1]

1.限库存(tr_ship_type="")事务类型:ISS-WO
2.计算成本,不可设置
3.仅处理过程工单

错误:总账日历没维护,总账日历已结,上期未结,本期已结!

[090808.1]

SS - 090808.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "090808.1"}

define variable per like glc_per.
define variable yr like glc_year.
define variable entity like glcd_entity.
DEFINE VARIABLE allow_zero AS LOGICAL.

DEFINE VARIABLE date1 AS DATE.
define variable l_yn        like mfc_logical             no-undo.
DEFINE VARIABLE method_xxpcacm LIKE xxpcacm_method.
DEFINE VARIABLE pct_alloc AS DECIMAL.

define variable efdate like tr_effdate.
define variable efdate1 like tr_date.

DEFINE VARIABLE continue AS LOGICAL NO-UNDO.

DEFINE BUFFER womstr FOR wo_mstr.

define NEW shared workfile alloc_wkfl no-undo
   field alloc_wonbr as character
   field alloc_recid as recid
   field alloc_numer as decimal
   field alloc_pct   as decimal.

DEFINE NEW SHARED TEMP-TABLE tt1
   field tt1_site LIKE xxpcwoi_site
   field tt1_year LIKE xxpcwoi_year
   field tt1_per LIKE xxpcwoi_per
   field tt1_par LIKE xxpcwoi_par
   field tt1_lot LIKE xxpcwoi_lot
   field tt1_comp LIKE xxpcwoi_comp
   field tt1_qty LIKE xxpcwoi_qty
   .

DEFINE TEMP-TABLE tt2
   FIELD tt2_lot LIKE xxpcwoi_lot
   .

{glcabmeg.i} /* module closing engine include. */

/* SELECT FORM */
form
   entity colon 20    
   en_name NO-LABEL
   yr     colon 20    
   per     colon 20    
   SKIP(1)
   allow_zero COLON 20
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
allow_zero = NO.

{wbrp01.i}

/* REPORT BLOCK */
mainloop:
repeat:
   if c-application-mode <> 'web' then
      update
         entity 
         yr 
         per
         allow_zero
      with frame a.

   {wbrp06.i &command = update &fields = "  entity yr per allow_zero" &frm = "a"}
      
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
   l_yn = NO.
   FOR EACH tt1:
      DELETE tt1.
   END.
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
      ,EACH wo_mstr NO-LOCK
      WHERE wo_mstr.wo_domain = GLOBAL_domain
      AND wo_mstr.wo_lot = xxpcwoi_lot
      AND wo_mstr.wo_joint_type = "5"
      :
      l_yn = YES.
      CREATE tt1.
      ASSIGN
         tt1_site = xxpcwoi_site
         tt1_year = xxpcwoi_year
         tt1_per = xxpcwoi_per
         tt1_par = xxpcwoi_par
         tt1_lot = xxpcwoi_lot
         tt1_comp = xxpcwoi_comp
         tt1_qty = xxpcwoi_qty
         .
   END.

   FOR EACH tt2:
      DELETE tt2.
   END.
   FOR EACH tt1
      BREAK BY tt1_lot
      :
      IF LAST-OF(tt1_lot) THEN DO:
         CREATE tt2.
         ASSIGN
            tt2_lot = tt1_lot
            .
      END.
   END.

   IF l_yn = NO THEN DO:
      /* Do you want to continue? */
      {pxmsg.i &MSGNUM=6398 &ERRORLEVEL=2 &CONFIRM=l_yn}

      if not l_yn then do:
         next-prompt per.
         UNDO mainloop, retry.
      end. /* IF NOT l_yn */
   END.

   {xxSoftspeedLic.i "SoftspeedPC.lic" "SoftspeedPC"}

   continue = YES.
   DO TRANSACTION ON STOP UNDO:
      FOR EACH tt2 NO-LOCK
         ,EACH wo_mstr NO-LOCK
         WHERE wo_mstr.wo_domain = GLOBAL_domain
         AND wo_mstr.wo_lot = tt2_lot
         AND wo_mstr.wo_joint_type = "5"
         ,EACH pt_mstr NO-LOCK
         WHERE pt_domain = GLOBAL_domain
         AND pt_part = wo_mstr.wo_part
         BREAK 
         BY wo_mstr.wo_lot
         :
         IF LAST-OF(wo_mstr.wo_lot) THEN DO:
            method_xxpcacm = "xxpcal01.p".
            FOR EACH xxpcacm_mstr NO-LOCK
               WHERE xxpcacm_domain = GLOBAL_domain
               AND (xxpcacm_site = wo_mstr.wo_site OR xxpcacm_site = "")
               AND (xxpcacm_prod_line = pt_prod_line OR xxpcacm_prod_line = "")
               AND (xxpcacm_part = wo_mstr.wo_part OR xxpcacm_part = "")
               BY xxpcacm_site DESC
               BY xxpcacm_part DESC
               BY xxpcacm_prod_line DESC
               :
               method_xxpcacm = xxpcacm_method.
            END.
            {gprun.i method_xxpcacm "(
               INPUT RECID(wo_mstr)
               )"}

            pct_alloc = 0.
            FOR EACH alloc_wkfl:
               IF alloc_pct = 0 AND allow_zero = NO THEN DO:
                  FIND FIRST womstr
                     WHERE RECID(womstr) = alloc_recid
                     NO-LOCK NO-ERROR.
                  IF NOT AVAILABLE womstr THEN DO:
                     continue = NO.
                     STOP.
                  END.

                  /* 301613 - 分配比例等于0:加工单[#],零件[#].是否继续? */
                  {pxmsg.i &MSGNUM=301613 &ERRORLEVEL=2 &MSGARG1=womstr.wo_lot &MSGARG2=womstr.wo_part &CONFIRM=l_yn}
                  if not l_yn then do:
                     continue = NO.
                     STOP.
                  end. /* IF NOT l_yn */
               END. /* IF alloc_pct = 0 THEN DO: */
               pct_alloc = pct_alloc + alloc_pct.
            END.
            IF pct_alloc <> 1 THEN DO:
               /* 301612 - 分配比例合计不等于1:加工单[#] */
               {pxmsg.i &MSGNUM=301612 &ERRORLEVEL=3 &MSGARG1=wo_mstr.wo_lot}
               continue = NO.
               STOP.
            END.

            {gprun.i ""xxpcwoiaa.p"" "(
               INPUT tt2_lot
               )"}
         END.
      END.
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
      {mfquoter.i allow_zero     }
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
      "联副工单"
      "子件"
      "数量"
      "过程工单"
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
      /* 联副产品 */
      AND xxpcwoi_base_id <> ""
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
         xxpcwoi_base_id
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
