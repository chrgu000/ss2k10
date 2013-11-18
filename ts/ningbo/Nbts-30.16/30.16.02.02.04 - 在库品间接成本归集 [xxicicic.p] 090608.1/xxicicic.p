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

/* SS - 090608.1 By: Bill Jiang */

/* SS - 090608.1 - RNB
[090608.1]

在库品间接成本归集

错误:总账日历没维护,总账日历已结,上期未结,本期已结!

警告:记录已经存在,是否继续?

[090608.1]

SS - 090608.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "090608.1"}

/* 定义 */
{xxiceyp1.i}

{wbrp01.i}

/* REPORT BLOCK */
mainloop:
repeat:
   {xxiceyp2.i}

   /* 已经创建 */
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxici_mstr NO-LOCK
      WHERE xxici_domain = GLOBAL_domain
      AND xxici_site = si_site
      AND xxici_year = yr
      AND xxici_per = per
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
      AND mfc_field = "SoftspeedIC_glr_code_in"
      NO-LOCK NO-ERROR.
   IF NOT AVAILABLE mfc_ctr THEN DO:
      /* Control table error.  Check applicable control tables */
      {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}
      undo, RETRY.
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

   DO TRANSACTION ON STOP UNDO:
      /* 清除已有的数据 */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxici_mstr EXCLUSIVE-LOCK
         WHERE xxici_domain = GLOBAL_domain
         AND xxici_site = si_site
         AND xxici_year = yr
         AND xxici_per = per
         :
         DELETE xxici_mstr.
      END.

      /* 写入 */
      FOR EACH gltr_hist NO-LOCK
         WHERE gltr_domain = GLOBAL_domain
         /* 仅限于库存会计事务 */
         AND gltr_ref >= "IC"
         AND gltr_ref < "ID"
         AND gltr_eff_dt >= efdate
         AND gltr_eff_dt <= efdate1
         AND gltr_entity = entity
         :
         FOR EACH glrd_det NO-LOCK
            WHERE glrd_domain = GLOBAL_domain
            AND glrd_code = mfc_char
            AND glrd_fpos = 0
            AND ((glrd_acct <= gltr_acc OR glrd_acct = "") AND (glrd_acct1 >= gltr_acc OR glrd_acct1 = ""))
            AND ((glrd_sub <= gltr_sub OR glrd_sub = "") AND (glrd_sub1 >= gltr_sub OR glrd_sub1 = ""))
            AND ((glrd_cc <= gltr_ctr OR glrd_cc = "") AND (glrd_cc1 >= gltr_ctr OR glrd_cc1 = ""))
            USE-INDEX glrd_code
            BY glrd_sub DESC
            BY glrd_acct DESC
            BY glrd_cc DESC
            :
            FIND FIRST tr_hist
               WHERE tr_domain = GLOBAL_domain
               AND tr_trnbr = INTEGER(gltr_doc)
               NO-LOCK NO-ERROR.
            /* 库存会计事务异常 */
            IF NOT AVAILABLE tr_hist THEN DO:
               /* Document # # not processed successfully due to errors */
               {pxmsg.i &MSGNUM=2468 &ERRORLEVEL=3 &MSGARG1=gltr_ref &MSGARG2=gltr_doc}
               STOP.
            END.
      
            CREATE xxici_mstr.
            ASSIGN
               xxici_domain = GLOBAL_domain
               xxici_site = tr_site
               xxici_year = yr
               xxici_per = per
               xxici_part = tr_part
               xxici_fpos = glrd_sums
               xxici_ac = gltr_acc
               xxici_sb = gltr_sub
               xxici_cc = gltr_ctr
               xxici_cst = gltr_amt
               .
      
            LEAVE.
         END. /* FOR EACH glrd_det NO-LOCK */
      END. /* FOR EACH gltr_hist NO-LOCK */
   END. /* DO TRANSACTION ON STOP UNDO: */

   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   EXPORT DELIMITER ";" 
      "地点"
      "年份"
      "期间"
      "件号"
      "件名"
      "格式位置"
      "账户"
      "分账户"
      "成本中心"
      "金额"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxici_mstr NO-LOCK
      WHERE xxici_domain = GLOBAL_domain
      AND xxici_site = si_site
      AND xxici_year = yr
      AND xxici_per = per
      ,EACH pt_mstr NO-LOCK
      WHERE pt_domain = GLOBAL_domain
      AND pt_part = xxici_part
      BY xxici_site
      BY xxici_year
      BY xxici_per
      BY xxici_part
      BY xxici_fpos
      BY xxici_ac
      BY xxici_sb
      BY xxici_cc
      :
      EXPORT DELIMITER ";"
         xxici_site
         xxici_year
         xxici_per
         xxici_part
         (pt_desc1 + " " + pt_desc2)
         xxici_fpos
         xxici_ac
         xxici_sb
         xxici_cc
         xxici_cst
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
