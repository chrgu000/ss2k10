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

/* SS - 090523.1 By: Bill Jiang */

/* SS - 090523.1 - RNB
[090523.1]

顺序包括以下列:
  - 会计单位
  - 年份
  - 期间
  - 零件
  - 工单
  - 分配比例
  - 数量
  - 基础参数
  - 乘参数1
  - 乘参数2
  - 乘参数3
  - 除参数1
  - 除参数2
  - 除参数3
  - 单量
  - 总量
  - 量比
  - 成本

[090523.1]

SS - 090523.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "090523.1"}

define variable per like glc_per.
define variable yr like glc_year.
define variable entity like glcd_entity.
DEFINE VARIABLE fpos LIKE glrd_fpos.
DEFINE VARIABLE date1 AS DATE.

{glcabmeg.i} /* module closing engine include. */

/* SELECT FORM */
form
   entity colon 20    
   en_name NO-LABEL
   yr     colon 20    
   per     colon 20    
   fpos colon 20    
   glrd_desc NO-LABEL
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
      fpos
      with frame a.

   {wbrp06.i &command = update &fields = "  entity yr per fpos" &frm = "a"}
      
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
      
   FIND FIRST mfc_ctrl
      WHERE mfc_domain = GLOBAL_domain
      AND mfc_field = "SoftspeedIC_glr_code_ie"
      NO-LOCK NO-ERROR.
   IF NOT AVAILABLE mfc_ctrl THEN DO:
      /* 301602 - 没有设置间接成本分配控制文件 [xxicpm01.p] */
      {pxmsg.i &MSGNUM=301602 &ERRORLEVEL=3}
      next-prompt fpos.
      UNDO, retry.
   END.
   FIND FIRST glrd_det
      WHERE glrd_domain = GLOBAL_domain
      AND glrd_code = mfc_char
      AND glrd_fpos = fpos
      AND glrd_line = 0
      NO-LOCK NO-ERROR.
   IF AVAILABLE glrd_det THEN DO:
      DISPLAY
         glrd_desc
         WITH FRAME a.
   END.
   ELSE DO:
      DISPLAY
         "" @ glrd_desc
         WITH FRAME a.
      /* Invalid format position */
      {pxmsg.i &MSGNUM=3012 &ERRORLEVEL=3}
      next-prompt fpos.
      UNDO, retry.
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
      "会计单位"
      "年份"
      "期间"
      "零件"
      "工单"
      "分配比例"
      "数量"
      "基础参数"
      "乘参数1"
      "乘参数2"
      "乘参数3"
      "除参数1"
      "除参数2"
      "除参数3"
      "单量"
      "总量"
      "量比"
      "成本"
      .
   FOR EACH xxicald_det NO-LOCK
      WHERE xxicald_domain = GLOBAL_domain
      AND xxicald_entity = entity
      AND xxicald_year = yr
      AND xxicald_per = per
      AND xxicald_fpos = fpos
      USE-INDEX xxicald_eypple
      :
      FOR EACH xxicar_det NO-LOCK
         WHERE xxicar_domain = GLOBAL_domain
         AND xxicar_entity = entity
         AND xxicar_year = yr
         AND xxicar_per = per
         AND xxicar_part = xxicald_part
         AND (xxicar_lot = xxicald_lot OR xxicar_lot = "")
         AND xxicar_ar = xxicald_ar
         BY xxicar_lot DESC
         :
         EXPORT DELIMITER ";"
            xxicald_entity
            xxicald_year
            xxicald_per
            xxicald_part
            xxicald_lot
            xxicald_ar
            xxicar_qty
            xxicar_bp
            xxicar_mp1
            xxicar_mp2
            xxicar_mp3
            xxicar_dp1
            xxicar_dp2
            xxicar_dp3
            xxicar_usage
            xxicar_usage_tot
            xxicald_usage_pct
            xxicald_cst
            .
         LEAVE.
      END.
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
