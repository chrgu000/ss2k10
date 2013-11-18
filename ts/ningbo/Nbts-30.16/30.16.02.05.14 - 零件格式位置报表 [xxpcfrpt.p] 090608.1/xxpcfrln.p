/* glcrfmiq.p - CUSTOM REPORT FORMAT INQUIRY                            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* web convert glcrfmiq.p (converter v1.00) Fri Oct 10 13:57:43 1997 */
/* web tag in glcrfmiq.p (converter v1.00) Mon Oct 06 14:18:17 1997 */
/*F0PN*/ /*K1HM*/ /*                                                    */
/*V8:ConvertMode=Report                                        */
/* REVISION: 7.0      LAST MODIFIED: 02/03/92    by: jms  *F140*        */
/* Revision: 7.3        Last edit: 11/19/92             By: jcd *G339* */
/* Revision: 7.3        Last edit: 10/17/94             By: ljm *GN36* */
/* Revision: 8.6        Last edit: 02/17/98      By: *K1HM* Beena Mol  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L1* Mark Brown       */
/* $Revision: 1.9 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/*-Revision end---------------------------------------------------------------*/

/* SS - 090608.1 By: Bill Jiang */

/* SS - 090608.1 - RNB
[090608.1]

修改于以下标准程序:
  - 客户报表格式查询 [glcrfmiq.p]

顺序输出了以下字段:
  - 格式位置代码
  - 格式位置说明

注意,本程序因程序名而异:
  - xxpcfrce.p: 成本要素格式位置报表
  - xxpcfrin.p: 在库品间接成本格式位置报表
  - xxpcfrwo.p: 在制品间接成本格式位置报表
  - xxpcfrpt.p: 零件分配范围格式位置报表
  - xxpcfrpl.p: 产品线分配范围格式位置报表
  - xxpcfrcc.p: 适用于标准加工单的在制品成本中心分配范围格式位置报表
  - xxpcfrln.p: 适用于累计加工单的生产线分配范围格式位置报表

增加了以下验证:
  - 定制代码[glr_code]: 必须在控制文件中已经定义
  
[090608.1]

SS - 090608.1 - RNE */

/*K1HM*/  /* DISPLAY TITLE */
/*
/*K1HM*/ {mfdtitle.i "2+ "}
*/
/*K1HM*/ {mfdtitle.i "090608.1"}

      define variable code like glr_code.

      /* SS - 090608.1 - B
      DEFINE VARIABLE cmmt_code LIKE CODE_cmmt.
      SS - 090608.1 - E */
      
      /* SS - 090608.1 - B */
      DEFINE VARIABLE FIELD_mfc LIKE mfc_field.
      
      IF execname = "xxpcfrpt.p" THEN DO:
         FIELD_mfc = "SoftspeedIC_to_pt".
      END.
      ELSE IF execname = "xxpcfrpl.p" THEN DO:
         FIELD_mfc = "SoftspeedIC_to_pl".
      END.
      ELSE IF execname = "xxpcfrcc.p" THEN DO:
         FIELD_mfc = "SoftspeedIC_to_cc".
      END.
      ELSE IF execname = "xxpcfrln.p" THEN DO:
         FIELD_mfc = "SoftspeedIC_to_ln".
      END.
      ELSE IF execname = "xxpcfrin.p" THEN DO:
         FIELD_mfc = "SoftspeedIC_glr_code_in".
      END.
      ELSE IF execname = "xxpcfrwo.p" THEN DO:
         FIELD_mfc = "SoftspeedIC_glr_code_wo".
      END.
      ELSE IF execname = "xxpcfrce.p" THEN DO:
         FIELD_mfc = "SoftspeedPC_glr_code_ce".
      END.
      /* SS - 090608.1 - E */

/*K1HM*  /* DISPLAY TITLE */
 * {mfdtitle.i "2+ "} */

      /* DISPLAY SELECTION FORM*/
      form
/*GN36*/  space(1)
      code
      glr_title no-label
         /* SS - 090608.1 - B */
         SKIP
         /* SS - 090608.1 - E */
      with frame a side-labels width 80 attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame a:handle).

/*K1HM*/ {wbrp01.i}

      mainloop:
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

/*K1HM*/  if c-application-mode <> 'web' then
           update code with frame a editing:

        /* FIND NEXT/PREVIOUS RECORD */
        {mfnp.i glr_mstr code  " glr_mstr.glr_domain = global_domain and
        glr_code "  code glr_code glr_code}

        if recno <> ? then do:
           code = glr_code.
           display code glr_title with frame a.
        end.
         end.

/*K1HM*/ {wbrp06.i &command = update &fields = "  code" &frm = "a"}

/*K1HM*/ if (c-application-mode <> 'web') or
/*K1HM*/ (c-application-mode = 'web' and
/*K1HM*/ (c-web-request begins 'data')) then do:

         /* DISPLAY REPORT DESCRIPTION */
         find glr_mstr  where glr_mstr.glr_domain = global_domain and  glr_code
         = code no-lock no-error.
         if available glr_mstr then display glr_title with frame a.
         else do:
/*K1HM*     disp "" @ glr_title with frame a. */
/*K1HM*/    display "" @ glr_title with frame a.
            {mfmsg.i 3047 3} /* INVALID CUSTOM REPORT CODE */
/*K1HM*/    if c-application-mode = 'web' then return.
        undo mainloop.
         end.

/*K1HM*/ end.

         /* SS - 090608.1 - B
         /* SELECT PRINTER */
            {mfselprt.i "terminal" 80}

         /* DISPLAY INFORMATION */
         for each glrd_det  where glrd_det.glrd_domain = global_domain and
         glrd_code = code and glrd_fpos <> 0
                     no-lock use-index glrd_code
                     with down frame b width 80:
                /* SET EXTERNAL LABELS */
                setFrameLabels(frame b:handle).
                {mfrpchk.i}                     /*G339*/
        display glrd_fpos
            glrd_sums
            glrd_dr_cr
            glrd_page
            glrd_header
            glrd_total
            glrd_skip
            glrd_underln.
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
            "格式位置代码"
            "格式位置说明"
            /*
            "分配比例代码"
            "分配比例说明"
            */
            .
         for each glrd_det  
            where glrd_det.glrd_domain = global_domain and
            glrd_code = code 
            and glrd_fpos <> 0
            no-lock use-index glrd_code
            :
            /*
            FIND FIRST CODE_mstr
               WHERE CODE_domain = GLOBAL_domain
               AND CODE_fldname = "SoftspeedIC_AR"
               AND CODE_value = glrd_user1
               NO-LOCK NO-ERROR.
            IF AVAILABLE CODE_mstr THEN DO:
               cmmt_code = CODE_cmmt.
            END.
            ELSE DO:
               cmmt_code = "".
            END.
            */
            EXPORT DELIMITER ";"
               glrd_fpos
               glrd_desc
               /*
               glrd_user1
               cmmt_code
               */
               .
         end.

         {xxmfrtrail.i}
         /* SS - 090608.1 - E */
      end.

/*K1HM*/ {wbrp04.i &frame-spec = a}
