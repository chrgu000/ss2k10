/* SS - 080828.1 By: Bill Jiang */
/* SS - 090829.1 By: Bill Jiang */
/* SS - 091116.1 By: Bill Jiang */
/* SS - 100927.1 By: Bill Jiang */

/* SS - 100927.1 - RNB
[100927.1]

如果当前总账参考号不符合编号规则,且小于或等于下一个编号,则忽略之

[100927.1]

SS - 100927.1 - RNE */

/* SS - 091116.1 - RNB
[091116.1]

修正了以下BUG:
  - 重新进入一个总账凭证
  - 先删除所有的项
  - 再增加新项
  - 结果: 跳号

[091116.1]

SS - 091116.1 - RNE */

/* SS - 090829.1 - RNB
[090829.1]

分别以下三种情况获得当前文档号,同时更新下一个文档号:
  1) 年份 + 月份
  2) 年份
  3) 永续
  
此前仅考虑了第一种情况  

[090829.1]

SS - 090829.1 - RNE */

/* SS - 080828.1 - RNB
[080828.1]

按总账参考号更新总账参考号[glt_ref]和总账文档号[glt_user1]

[080828.1]

SS - 080828.1 - RNE */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

DEFINE INPUT PARAMETER ref1_glt LIKE glt_ref.
DEFINE OUTPUT PARAMETER ref3_glt LIKE glt_ref.
/* SS - 091116.1 - B
DEFINE OUTPUT PARAMETER user1_glt LIKE glt_user1.
SS - 091116.1 - E */
/* SS - 091116.1 - B */
DEFINE INPUT-OUTPUT PARAMETER user1_glt LIKE glt_user1.
/* SS - 091116.1 - E */

DEFINE VARIABLE c-label LIKE mfc_label.
DEFINE VARIABLE ssgltrpm_ref LIKE mfc_integer.
DEFINE VARIABLE ssgltrpm_doc LIKE mfc_integer.
DEFINE VARIABLE prefix AS CHARACTER.
DEFINE VARIABLE suffix AS CHARACTER.
DEFINE VARIABLE i1 AS INTEGER.
DEFINE VARIABLE i2 AS INTEGER.
DEFINE VARIABLE i3 AS INTEGER.
DEFINE VARIABLE d1 AS DECIMAL.
DEFINE VARIABLE ref2_glt LIKE glt_ref.
DEFINE VARIABLE ref2_gltr LIKE gltr_ref.
DEFINE VARIABLE effdate_glt LIKE glt_effdate.

/* SS - 090829.1 - B */
DEFINE BUFFER mfcctrl FOR mfc_ctrl.
/* SS - 090829.1 - E */

/* ADD MFC_CTRL FIELD ssgltrpm_ref */
for first mfc_ctrl where mfc_domain = global_domain and mfc_field = "ssgltrpm_ref"
exclusive-lock: end.

if not available mfc_ctrl then do:

   c-label = getTermLabel("GL_REFERENCE", 45).

   create mfc_ctrl.
   assign
      mfc_domain = GLOBAL_domain
      mfc_field   = "ssgltrpm_ref"
      mfc_type    = "C"
      mfc_label   = c-label
      mfc_module  = "ssgltrpm"
      mfc_seq     = 10
      mfc_integer = 1.

end.

ssgltrpm_ref = mfc_integer.

/* ADD MFC_CTRL FIELD ssgltrpm_doc */
for first mfc_ctrl where mfc_domain = global_domain and mfc_field = "ssgltrpm_doc"
exclusive-lock: end.

if not available mfc_ctrl then do:

   c-label = getTermLabel("DOCUMENT_ID", 45).

   create mfc_ctrl.
   assign
      mfc_domain = GLOBAL_domain
      mfc_field   = "ssgltrpm_doc"
      mfc_type    = "C"
      mfc_label   = c-label
      mfc_module  = "ssgltrpm"
      mfc_seq     = 20
      mfc_integer = 1.

end.

ssgltrpm_doc = mfc_integer.

/* 多用户 */
FOR EACH mfc_ctrl EXCLUSIVE-LOCK
   WHERE mfc_domain = GLOBAL_domain
   AND mfc_field = "ssgltrpm_ref"
   :
   /* 编辑旧的账务 */
   FIND FIRST glt_det WHERE glt_domain = GLOBAL_domain AND glt_ref = ref1_glt AND glt_user1 <> "" NO-LOCK NO-ERROR.
   IF AVAILABLE glt_det THEN DO:
      user1_glt = glt_user1.
      FOR EACH glt_det EXCLUSIVE-LOCK
         WHERE glt_domain = GLOBAL_domain
         AND glt_ref = ref1_glt
         AND glt_user1 = ""
         :
         glt_user1 = user1_glt.
      END.
      RETURN.
   END.
   /* SS - 091116.1 - B */
   ELSE DO:
      IF user1_glt <> "" THEN DO:
         FOR EACH glt_det EXCLUSIVE-LOCK
            WHERE glt_domain = GLOBAL_domain
            AND glt_ref = ref1_glt
            AND glt_user1 = ""
            :
            glt_user1 = user1_glt.
         END.
         RETURN.
      END. /* IF user1_glt <> "" THEN DO: */
   END. /* ELSE DO: */
   /* SS - 091116.1 - E */

   /* 增加新的账务 */
   FIND FIRST glt_det WHERE glt_domain = GLOBAL_domain AND glt_ref = ref1_glt AND glt_user1 = "" NO-LOCK NO-ERROR.
   IF NOT AVAILABLE glt_det THEN DO:
      RETURN.
   END.

   effdate_glt = glt_effdate.

   /* 参考号 */
   /* 999999999999 */
   prefix = "".
   i1 = LENGTH(glt_ref).
   DO i2 = 1 TO i1 BY 1:
      i3 = ASC(SUBSTRING(glt_ref,i2,1)).
      IF i3 >= 48 AND i3 <= 57 THEN DO:
         LEAVE.
      END.

      prefix = prefix + SUBSTRING(glt_ref,i2,1).
   END.

   /* YYYYMMDD9999 */
   IF ssgltrpm_ref = 1 THEN DO:
      prefix = prefix 
         + STRING(YEAR(glt_effdate)) 
         + STRING(MONTH(glt_effdate),"99")
         + STRING(DAY(glt_effdate),"99")
         .
   END.

   /* YYMMDD999999 */
   ELSE IF ssgltrpm_ref = 2 THEN DO:
      prefix = prefix 
         + SUBSTRING(STRING(YEAR(glt_effdate)),3,2)
         + STRING(MONTH(glt_effdate),"99")
         + STRING(DAY(glt_effdate),"99")
         .
   END.

   /* YYYYMM999999 */
   ELSE IF ssgltrpm_ref = 3 THEN DO:
      prefix = prefix 
         + STRING(YEAR(glt_effdate)) 
         + STRING(MONTH(glt_effdate),"99")
         .
   END.

   /* YYMM99999999 */
   ELSE IF ssgltrpm_ref = 4 THEN DO:
      prefix = prefix 
         + SUBSTRING(STRING(YEAR(glt_effdate)),3,2)
         + STRING(MONTH(glt_effdate),"99")
         .
   END.

   /* YYYY99999999 */
   ELSE IF ssgltrpm_ref = 5 THEN DO:
      prefix = prefix 
         + STRING(YEAR(glt_effdate)) 
         .
   END.

   /* YY9999999999 */
   ELSE IF ssgltrpm_ref = 6 THEN DO:
      prefix = prefix 
         + SUBSTRING(STRING(YEAR(glt_effdate)),3,2)
         .
   END.

   suffix = FILL("9",14 - LENGTH(prefix)).

   FIND LAST glt_det WHERE glt_domain = GLOBAL_domain AND glt_ref BEGINS prefix 
      /* 仅限于系统自动生成的记录 */
      AND glt_user1 <> "" 
      NO-LOCK NO-ERROR.
   IF AVAILABLE glt_det THEN DO:
      ref2_glt = glt_ref.
   END.
   ELSE DO:
      ref2_glt = "".
   END.

   FIND LAST gltr_hist WHERE gltr_domain = GLOBAL_domain AND gltr_ref BEGINS prefix NO-LOCK NO-ERROR.
   IF AVAILABLE gltr_hist THEN DO:
      ref2_gltr = gltr_ref.
   END.
   ELSE DO:
      ref2_gltr = "".
   END.

   IF ref2_glt = "" AND ref2_gltr = "" THEN DO:
      d1 = 1.
   END.
   ELSE DO:
      d1 = DECIMAL(SUBSTRING(MAX(ref2_glt, ref2_gltr), LENGTH(prefix) + 1, LENGTH(suffix))) + 1.
   END.
   ref3_glt = prefix + STRING(d1,suffix).

   /* SS - 100927.1 - B */
   IF DECIMAL(SUBSTRING(ref1_glt, LENGTH(prefix) + 1, LENGTH(suffix))) <= d1 THEN DO:
      IF SUBSTRING(ref1_glt, 1, LENGTH(prefix)) = prefix THEN DO:
         ref3_glt = ref1_glt.
      END.
   END.
   /* SS - 100927.1 - E */

   /* 文档号 */
   DO TRANSACTION:
      FOR FIRST glc_cal EXCLUSIVE-LOCK
         WHERE glc_domain = GLOBAL_domain
         AND glc_start <= effdate_glt
         AND glc_end >= effdate_glt
         :

         /* 99999999999999 */
         prefix = "".

         /* YYYYPP99999999 */
         IF ssgltrpm_doc = 1 THEN DO:
            prefix = prefix 
               + STRING(glc_year) 
               + STRING(glc_per,"99")
               .
         END.

         /* YYPP9999999999 */
         ELSE IF ssgltrpm_doc = 2 THEN DO:
            prefix = prefix 
               + SUBSTRING(STRING(glc_year),3,2)
               + STRING(glc_per,"99")
               .
         END.

         /* YYYY9999999999 */
         ELSE IF ssgltrpm_doc = 3 THEN DO:
            prefix = prefix 
               + STRING(glc_year) 
               .
         END.

         /* YY9999999999 */
         ELSE IF ssgltrpm_doc = 4 THEN DO:
            prefix = prefix 
               + SUBSTRING(STRING(glc_year),3,2)
               .
         END.

         suffix = FILL("9",14 - LENGTH(prefix)).

         /* SS - 090829.1 - B
         IF glc_user1 = "" THEN DO:
            glc_user1 = "1".
         END.

         user1_glt = prefix + STRING(DECIMAL(glc_user1),suffix).

         glc_user1 = STRING(DECIMAL(glc_user1) + 1).
         SS - 090829.1 - E */
         
         /* SS - 090829.1 - B */
         {ssgltrref03.i}
         /* SS - 090829.1 - E */

         FOR EACH glt_det EXCLUSIVE-LOCK
            WHERE glt_domain = GLOBAL_domain
            AND glt_ref = ref1_glt
            :
            ASSIGN
               glt_ref = ref3_glt
               glt_user1 = user1_glt
               .
         END.
      END. /* FOR FIRST glc_cal EXCLUSIVE-LOCK */
   END. /* DO TRANSACTION: */

END.
