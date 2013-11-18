/* glcriq.p - CUSTOM REPORT ACCOUNT INQUIRY                             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* web convert glcriq.p (converter v1.00) Fri Oct 10 13:57:43 1997 */
/* web tag in glcriq.p (converter v1.00) Mon Oct 06 14:18:17 1997 */
/*F0PN*/ /*K1HN*/ /*                                                    */
/*V8:ConvertMode=Report                                        */
/* REVISION: 4.0      LAST MODIFIED: 03/21/88    BY: JMS                */
/* REVISION: 4.0      LAST MODIFIED: 04/08/88    BY: FLM  *A197*        */
/* REVISION: 5.0      LAST MODIFIED: 05/15/89    by: jms  *B137*        */
/* REVISION: 6.0      LAST MODIFIED: 09/24/90    by: jms  *D034*        */
/*                                   11/20/90    by: jms  *D254*        */
/* REVISION: 7.0      LAST MODIFIED: 02/03/92    by: jms  *F140*        */
/*                                                 (major re-write)     */
/*                                   06/17/92    by: jms  *F661*        */
/* Revision: 7.3        Last edit: 11/19/92             By: jcd *G339* */
/* Revision: 7.3        Last edit: 10/17/94             By: ljm *GN36* */
/* Revision: 8.6        Last edit: 02/17/98      By: *K1HN* Beena Mol   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L1* Mark Brown       */
/* $Revision: 1.8 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/*-Revision end---------------------------------------------------------------*/


/* SS - 090608.1 By: Bill Jiang */

/* SS - 090608.1 - RNB
[090608.1]

修改于以下标准程序:
  - 客户报表账户查询 [glcriq.p]

顺序输出了以下字段:
  - 行
  - 从账户
  - 到账户
  - 从分账户
  - 到分账户
  - 从成本中心
  - 到成本中心
  - 格式位置代码

注意,本程序因程序名而异:
  - xxpcarce.p: 成本要素账户报表
  - xxpcarin.p: 在库品间接成本账户报表
  - xxpcarwo.p: 在制品间接成本账户报表
  - xxpcarie.p: 间接费用账户报表

增加了以下验证:
  - 定制代码[glr_code]: 必须在控制文件中已经定义
  
[090608.1]

SS - 090608.1 - RNE */

/*K1HN*/  /* DISPLAY TITLE */
/*
/*K1HN*/ {mfdtitle.i "2+ "}
*/
/*K1HN*/ {mfdtitle.i "090608.1"}

      define variable code like glr_code.
      define variable desc1 like glr_title.
/*F661*/  define variable acc_end like glrd_acct1.
/*F661*/  define variable sub_end like glrd_sub1.
/*F661*/  define variable cc_end like glrd_cc1.
      define buffer g1 for glrd_det.

/*K1HN*  /* DISPLAY TITLE */
 * {mfdtitle.i "2+ "}*/

      /* DISPLAY SELECTION FORM*/
      form
/*GN36*/  space(1)
      code
      desc1 no-label
         /* SS - 090608.1 - B */
         SKIP
         /* SS - 090608.1 - E */
      with frame a side-labels width 80 attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame a:handle).

      /* SS - 090608.1 - B */
      DEFINE VARIABLE FIELD_mfc LIKE mfc_field.
      
      IF execname = "xxpcarie.p" THEN DO:
         FIELD_mfc = "SoftspeedIC_glr_code_ie".
      END.
      ELSE IF execname = "xxpcarin.p" THEN DO:
         FIELD_mfc = "SoftspeedIC_glr_code_in".
      END.
      ELSE IF execname = "xxpcarwo.p" THEN DO:
         FIELD_mfc = "SoftspeedIC_glr_code_wo".
      END.
      ELSE IF execname = "xxpcarce.p" THEN DO:
         FIELD_mfc = "SoftspeedPC_glr_code_ce".
      END.
      /* SS - 090608.1 - E */

/*K1HN*/ {wbrp01.i}

         repeat:

            /* SS - 090608.1 - B */
            FIND FIRST mfc_ctrl 
               WHERE mfc_domain = GLOBAL_domain 
               AND mfc_field = FIELD_mfc
               NO-LOCK NO-ERROR.
            IF NOT AVAILABLE mfc_ctr THEN DO:
               /* Control table error.  Check applicable control tables */
               {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}
               undo, RETRY.
            END.
            ASSIGN
               CODE = mfc_char
               .
            DISPLAY
               CODE
               WITH FRAME a.
            /* SS - 090608.1 - E */

/*K1HN*/  if c-application-mode <> 'web' then
           update code with frame a editing:

        /* FIND NEXT/PREVIOUS RECORD */
        {mfnp.i glr_mstr code  " glr_mstr.glr_domain = global_domain and
        glr_code "  code glr_code glr_code}

        if recno <> ? then do:
           code = glr_code.
           desc1 = glr_title.
           display code desc1 with frame a.
        end.
         end.

/*K1HN*/ {wbrp06.i &command = update &fields = "  code" &frm = "a"}

/*K1HN*/ if (c-application-mode <> 'web') or
/*K1HN*/ (c-application-mode = 'web' and
/*K1HN*/ (c-web-request begins 'data')) then do:

         /* DISPLAY REPORT DESCRIPTION */
         desc1 = "".
         find glr_mstr  where glr_mstr.glr_domain = global_domain and  glr_code
         = code no-lock no-error.
         if available glr_mstr then desc1 = glr_title.
         display desc1 with frame a.

/*K1HN*/ end.

         /* SS - 090608.1 - B
         /* SELECT PRINTER */
            {mfselprt.i "terminal" 80}

         /* DISPLAY INFORMATION */
         for each glrd_det  where glrd_det.glrd_domain = global_domain and
         glrd_code = code and glrd_fpos = 0
                     no-lock use-index glrd_code
                     with down frame b width 80:
                /* SET EXTERNAL LABELS */
                setFrameLabels(frame b:handle).
                {mfrpchk.i}                     /*G339*/
/*F661*/        acc_end = glrd_acct1.
/*F661*/        if acc_end = hi_char then acc_end = "".
/*F661*/        sub_end = glrd_sub1.
/*F661*/        if sub_end = hi_char then sub_end = "".
/*F661*/        cc_end = glrd_cc1.
/*F661*/        if cc_end = hi_char then cc_end = "".
        display glrd_line
            glrd_acct
/*F661*/                acc_end /*glrd_acct1*/
            glrd_sub
/*F661*/                sub_end /*glrd_sub1*/
            glrd_cc
/*F661*/                cc_end /*glrd_cc1*/
            glrd_sums.
         end.

         /* END OF LIST MESSAGE */
         {mfreset.i}
         {mfmsg.i 8 1}
         SS - 090608.1 - E */

         /* SS - 090608.1 - B */
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
      
         /* DISPLAY INFORMATION */
         EXPORT DELIMITER ";"
            "行"
            "从账户"
            "到账户"
            "从分账户"
            "到分账户"
            "从成本中心"
            "到成本中心"
            "格式位置代码"
            .
         /* DISPLAY INFORMATION */
         for each glrd_det  
            where glrd_det.glrd_domain = global_domain and
            glrd_code = code 
            and glrd_fpos = 0
            no-lock use-index glrd_code
            :
            acc_end = glrd_acct1.
            if acc_end = hi_char then acc_end = "".
            sub_end = glrd_sub1.
            if sub_end = hi_char then sub_end = "".
            cc_end = glrd_cc1.
            if cc_end = hi_char then cc_end = "".
            EXPORT DELIMITER ";"
               glrd_line
               glrd_acct
               acc_end /*glrd_acct1*/
               glrd_sub
               sub_end /*glrd_sub1*/
               glrd_cc
               cc_end /*glrd_cc1*/
               glrd_sums
               .
         end.

         {xxmfrtrail.i}
         /* SS - 090608.1 - E */
      end.

/*K1HN*/ {wbrp04.i &frame-spec = a}
