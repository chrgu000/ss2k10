/* SS - 090829.1 By: Bill Jiang */

/* SS - 090829.1 - RNB
[090829.1]

获得当前文档号,同时更新下一个文档号

分别以下三种情况处理:
  1) 年份 + 月份
  2) 年份
  3) 永续

[090829.1]

SS - 090829.1 - RNE */

         /* Year + Per */
         IF ssgltrpm_doc = 1 OR ssgltrpm_doc = 2 THEN DO:
            IF glc_user1 = "" THEN DO:
               glc_user1 = "1".
            END.

            user1_glt = prefix + STRING(DECIMAL(glc_user1),suffix).

            glc_user1 = STRING(DECIMAL(glc_user1) + 1).
         END. /* IF ssgltrpm_doc = 1 OR ssgltrpm_doc = 2 THEN DO: */
         /* Year */
         ELSE IF ssgltrpm_doc = 3 OR ssgltrpm_doc = 4 THEN DO:
            FIND FIRST mfcctrl
               WHERE mfcctrl.mfc_domain = GLOBAL_domain
               AND mfcctrl.mfc_field = "ssgltrpm_doc." + STRING(glc_year)
               EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE mfcctrl THEN DO:
               CREATE mfcctrl.
               ASSIGN
                  mfcctrl.mfc_domain = GLOBAL_domain
                  mfcctrl.mfc_field = "ssgltrpm_doc." + STRING(glc_year)
                  mfcctrl.mfc_type = "I"
                  mfcctrl.mfc_module = mfcctrl.mfc_field
                  mfcctrl.mfc_seq = 10
                  mfcctrl.mfc_integer = 1
                  .
            END.

            user1_glt = prefix + STRING(mfcctrl.mfc_integer,suffix).

            mfcctrl.mfc_integer = mfcctrl.mfc_integer + 1.
         END. /* IF ssgltrpm_doc = 3 OR ssgltrpm_doc = 4 THEN DO: */
         ELSE DO:
            FIND FIRST mfcctrl
               WHERE mfcctrl.mfc_domain = GLOBAL_domain
               AND mfcctrl.mfc_field = "ssgltrpm_doc.next"
               EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE mfcctrl THEN DO:
               CREATE mfcctrl.
               ASSIGN
                  mfcctrl.mfc_domain = GLOBAL_domain
                  mfcctrl.mfc_field = "ssgltrpm_doc.next"
                  mfcctrl.mfc_type = "I"
                  mfcctrl.mfc_module = mfcctrl.mfc_field
                  mfcctrl.mfc_seq = 10
                  mfcctrl.mfc_integer = 1
                  .
            END.

            user1_glt = prefix + STRING(mfcctrl.mfc_integer,suffix).

            mfcctrl.mfc_integer = mfcctrl.mfc_integer + 1.
         END.
