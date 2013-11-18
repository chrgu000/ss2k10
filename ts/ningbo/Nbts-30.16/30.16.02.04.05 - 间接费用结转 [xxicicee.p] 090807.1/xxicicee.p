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

间接费用结转

错误:总账日历没维护,总账日历已结,上期未结,本期已结!

警告:记录已经存在,是否继续?

[090807.1]

SS - 090807.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "090807.1"}

/* 定义 */
{xxiceyp1.i}

DEFINE VARIABLE arg1 AS CHARACTER.
DEFINE VARIABLE arg2 AS CHARACTER.

DEFINE VARIABLE continue AS LOGICAL NO-UNDO.

{wbrp01.i}

/* REPORT BLOCK */
mainloop:
repeat:
   {xxiceyp2.i}

   /* 已经创建 */
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH xxice_mstr NO-LOCK
      WHERE xxice_domain = GLOBAL_domain
      AND xxice_entity = entity
      AND xxice_year = yr
      AND xxice_per = per
      AND xxice_element <> 0
      :
      /* 301606 - 记录已经存在.是否继续? */
      {pxmsg.i &MSGNUM=301606 &ERRORLEVEL=2 &CONFIRM=l_yn}

      if not l_yn then do:
         next-prompt per.
         UNDO mainloop, retry.
      end. /* IF NOT l_yn */

      LEAVE.
   END.
   
   /* 控制文件 */
   FIND FIRST mfc_ctrl 
      WHERE mfc_domain = GLOBAL_domain 
      AND mfc_field = "SoftspeedPC_glr_code_ce"
      NO-LOCK NO-ERROR.
   IF NOT AVAILABLE mfc_ctr THEN DO:
      /* Control table error.  Check applicable control tables */
      {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}
      undo, RETRY.
   END.

   {xxSoftspeedLic.i "SoftspeedPC.lic" "SoftspeedPC"}

   continue = YES.
   DO TRANSACTION ON STOP UNDO:
      /* 清除已有的数据 */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxice_mstr EXCLUSIVE-LOCK
         WHERE xxice_domain = GLOBAL_domain
         AND xxice_entity = entity
         AND xxice_year = yr
         AND xxice_per = per
         :
         ASSIGN 
            xxice_element = 0
            .
      END.

      /* 写入 */
      xxicniacloop:
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxice_mstr EXCLUSIVE-LOCK
         WHERE xxice_domain = GLOBAL_domain
         AND xxice_entity = entity
         AND xxice_year = yr
         AND xxice_per = per
         :
         FOR EACH glrd_det NO-LOCK
            WHERE glrd_domain = GLOBAL_domain
            AND glrd_code = mfc_char
            AND glrd_fpos = 0
            AND ((glrd_acct <= xxice_ac OR glrd_acct = "") AND (glrd_acct1 >= xxice_ac OR glrd_acct1 = ""))
            AND ((glrd_sub <= xxice_sb OR glrd_sub = "") AND (glrd_sub1 >= xxice_sb OR glrd_sub1 = ""))
            AND ((glrd_cc <= xxice_cc OR glrd_cc = "") AND (glrd_cc1 >= xxice_cc OR glrd_cc1 = ""))
            USE-INDEX glrd_code
            BY glrd_sub DESC
            BY glrd_acct DESC
            BY glrd_cc DESC
            :
            ASSIGN
               xxice_element = glrd_sums
               .
      
            NEXT xxicniacloop.
         END. /* FOR EACH glrd_det NO-LOCK */

         /* 301609 - 以下间接费用找不到对应的成本要素:格式位置[#],账户[#] */
         arg1 = STRING(xxice_fpos).
         arg2 = (xxice_ac + "-" + xxice_sb + "-" + xxice_cc).
         {pxmsg.i &MSGNUM=301609 &ERRORLEVEL=3 &MSGARG1=arg1 &MSGARG2=arg2}
         continue = NO.
         STOP.
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
      "会计单位"
      "年份"
      "期间"
      "格式位置"
      "账户"
      "分账户"
      "成本中心"
      "金额"
      "成本要素"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH xxice_mstr NO-LOCK
      WHERE xxice_domain = GLOBAL_domain
      AND xxice_entity = entity
      AND xxice_year = yr
      AND xxice_per = per
      BY xxice_entity
      BY xxice_year
      BY xxice_per
      BY xxice_fpos
      BY xxice_ac
      BY xxice_sb
      BY xxice_cc
      :
      EXPORT DELIMITER ";"
         xxice_entity
         xxice_year
         xxice_per
         xxice_fpos
         xxice_ac
         xxice_sb
         xxice_cc
         xxice_cst
         xxice_element
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
