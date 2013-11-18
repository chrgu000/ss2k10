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

/* SS - 090706.1 By: Bill Jiang */

/* SS - 090706.1 - RNB
[090706.1]

间接费用归集

错误:总账日历没维护,总账日历已结,上期未结,本期已结!

警告:记录已经存在,是否继续?

[090706.1]

SS - 090706.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "090706.1"}

/* 定义 */
{xxiceyp1.i}

DEFINE TEMP-TABLE tt1
   FIELD tt1_fpos LIKE glrd_sums
   FIELD tt1_ac LIKE gltr_acc
   FIELD tt1_sb LIKE gltr_sub
   FIELD tt1_cc LIKE gltr_ctr
   FIELD tt1_cst LIKE gltr_amt
   INDEX tt1_index1 tt1_fpos tt1_ac tt1_sb tt1_cc
   .

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
      ,EACH xxice_mstr NO-LOCK
      WHERE xxice_domain = GLOBAL_domain
      AND xxice_entity = si_site
      AND xxice_year = yr
      AND xxice_per = per
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
      AND mfc_field = "SoftspeedIC_glr_code_ie"
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
      /* 清除已有的数据 */
      FOR EACH xxice_mstr EXCLUSIVE-LOCK
         WHERE xxice_domain = GLOBAL_domain
         AND xxice_entity = entity
         AND xxice_year = yr
         AND xxice_per = per
         :
         DELETE xxice_mstr.
      END.

      /* 写入 */
      EMPTY TEMP-TABLE tt1.
      FOR EACH gltr_hist NO-LOCK
         WHERE gltr_domain = GLOBAL_domain
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
            /*
            CREATE xxice_mstr.
            ASSIGN
               xxice_domain = GLOBAL_domain
               xxice_entity = entity
               xxice_year = yr
               xxice_per = per
               xxice_fpos = glrd_sums
               xxice_ac = gltr_acc
               xxice_sb = gltr_sub
               xxice_cc = gltr_ctr
               xxice_cst = gltr_amt
               .
            */
            CREATE tt1.
            ASSIGN
               tt1_fpos = glrd_sums
               tt1_ac = gltr_acc
               tt1_sb = gltr_sub
               tt1_cc = gltr_ctr
               tt1_cst = gltr_amt
               .
      
            LEAVE.
         END. /* FOR EACH glrd_det NO-LOCK */
      END. /* FOR EACH gltr_hist NO-LOCK */
      FOR EACH tt1
         BREAK 
         BY tt1_fpos
         BY tt1_ac
         BY tt1_sb
         BY tt1_cc
         :
         ACCUMULATE tt1_cst (TOTAL
                             BY tt1_fpos
                             BY tt1_ac
                             BY tt1_sb
                             BY tt1_cc
                             ).
         IF LAST-OF(tt1_cc) THEN DO:
            CREATE xxice_mstr.
            ASSIGN
               xxice_domain = GLOBAL_domain
               xxice_entity = entity
               xxice_year = yr
               xxice_per = per
               xxice_fpos = tt1_fpos
               xxice_ac = tt1_ac
               xxice_sb = tt1_sb
               xxice_cc = tt1_cc
               xxice_cst = (ACCUMULATE TOTAL BY tt1_cc tt1_cst)
               .
         END.
      END.
   END. /* DO TRANSACTION ON STOP UNDO: */

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
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
