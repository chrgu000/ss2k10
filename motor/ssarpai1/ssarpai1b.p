/* $Revision: 1.6.1.8 $    BY: Bill Jiang    DATE: 08/17/07   ECO: *SS - 20070817.1*  */
/* $Revision: 1.6.1.8 $    BY: Bill Jiang    DATE: 10/20/07   ECO: *SS - 20071020.1*  */
/* $Revision: 1.6.1.8 $    BY: Bill Jiang    DATE: 02/21/08   ECO: *SS - 20080221.1*  */

/* SS - 20080221.1 - B */
/*
1.更正了用本币收取外币的BUG
*/
/* SS - 20080221.1 - E */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{ssarparp02.i}

DEFINE INPUT PARAMETER ar-entity LIKE ar_entity.

DEFINE VARIABLE p-file AS CHARACTER.
DEFINE VARIABLE output-find LIKE mfc_logical.
DEFINE VARIABLE output-check LIKE ar_check.

/* 获得输入参数文件名称 */
{gprun.i ""ssGetTodayTime.p"" "(
   OUTPUT p-file
   )"}
p-file = SUBSTRING(p-file,3,12).
REPEAT:
   p-file = "./TMP" + p-file.
   IF SEARCH(p-file) = ? THEN DO:
      LEAVE.
   END.
   {gprun.i ""ssGetTodayTime.p"" "(
      OUTPUT p-file
      )"}
   p-file = SUBSTRING(p-file,3,12).
END.

/* 生成输入文件内容 */
FOR EACH ttssarparp02
   ,EACH bk_mstr NO-LOCK
   WHERE bk_domain = GLOBAL_domain
   AND bk_code = ttssarparp02_ar_bank
   BREAK BY ttssarparp02_ar_bill
   BY ttssarparp02_ar_check
   :
   IF FIRST-OF(ttssarparp02_ar_check) THEN DO:
      OUTPUT TO VALUE(p-file).

      PUT UNFORMATTED "-" SKIP.
      PUT UNFORMATTED "-" SKIP.
      PUT UNFORMATTED "-" SKIP.
      EXPORT DELIMITER " " ttssarparp02_ar_bill.
      EXPORT DELIMITER " " ttssarparp02_ar_curr.

      PUT UNFORMATTED " - " ttssarparp02_ar_date " " ttssarparp02_ar_effdate.
      FIND FIRST dyd_mstr WHERE dyd_domain = GLOBAL_domain NO-LOCK NO-ERROR.
      IF AVAILABLE dyd_mstr THEN DO:
         FIND ar_mstr WHERE ar_domain = GLOBAL_domain AND ar_nbr = STRING(ttssarparp02_ar_bill,"x(8)") + ttssarparp02_ar_check NO-LOCK.
         PUT UNFORMATTED " """ ar_dy_code """".
      END.
      PUT UNFORMATTED " """ bk_user1 """ """ ttssarparp02_ar_po """" SKIP.

      EXPORT DELIMITER " " ttssarparp02_ar_acct ttssarparp02_ar_sub ttssarparp02_ar_cc ttssarparp02_ar_disc_acct ttssarparp02_ar_disc_sub ttssarparp02_ar_disc_cc ar-entity.

      IF ttssarparp02_ar_curr <> base_curr THEN DO:
         FIND ar_mstr WHERE ar_domain = GLOBAL_domain AND ar_nbr = STRING(ttssarparp02_ar_bill,"x(8)") + ttssarparp02_ar_check NO-LOCK.
         EXPORT DELIMITER " " ar_ex_rate ar_ex_rate2.
      END.

      EXPORT DELIMITER " " NO ttssarparp02_ar_check.
   END. /* IF FIRST-OF(ttssarparp02_ar_check) THEN DO: */

   IF ttssarparp02_ard_type = "U" THEN DO:
      PUT UNFORMATTED "-" SKIP.
      EXPORT DELIMITER " " ttssarparp02_ard_type.
      EXPORT DELIMITER " " ttssarparp02_ard_ref.
      EXPORT DELIMITER " " ttssarparp02_ard_acct ttssarparp02_ard_sub ttssarparp02_ard_cc.
      EXPORT DELIMITER " " ar-entity.
      PUT UNFORMATTED "-" SKIP.
      EXPORT DELIMITER " " ttssarparp02_ard_amt ttssarparp02_ard_disc.
   END.
   ELSE IF ttssarparp02_ard_type = "N" THEN DO:
      PUT UNFORMATTED "-" SKIP.
      EXPORT DELIMITER " " ttssarparp02_ard_type.
      EXPORT DELIMITER " " ttssarparp02_ard_ref.
      EXPORT DELIMITER " " ttssarparp02_ard_acct ttssarparp02_ard_sub ttssarparp02_ard_cc.
      EXPORT DELIMITER " " ar-entity.
      PUT UNFORMATTED "-" SKIP.
      EXPORT DELIMITER " " ttssarparp02_ard_amt.
   END.
   ELSE DO:
      FIND ar_mstr WHERE ar_domain = GLOBAL_domain AND ar_nbr = ttssarparp02_ard_ref NO-LOCK NO-ERROR.
      IF AVAILABLE ar_mstr THEN DO:
         EXPORT DELIMITER " " ar_user2.
      END.
      ELSE DO:
         OUTPUT CLOSE.
         OS-DELETE VALUE(p-file).
         NEXT.
      END.

      PUT UNFORMATTED "-" SKIP.
      EXPORT DELIMITER " " ttssarparp02_ard_amt ttssarparp02_ard_disc.

      /* SS - 20080221.1 - B */
      IF ttssarparp02_ar_curr <> ar_curr THEN DO: 
         EXPORT DELIMITER " " ttssarparp02_ard_cur_amt.
      END.
      /* SS - 20080221.1 - E */
   END.

   IF LAST-OF(ttssarparp02_ar_check) THEN DO:
      PUT UNFORMATTED "." SKIP.
      PUT UNFORMATTED "." SKIP.
      PUT UNFORMATTED "." SKIP.
      PUT UNFORMATTED "." SKIP.

      OUTPUT CLOSE.
        
      DO TRANSACTION:
         FIND ar_mstr WHERE ar_domain = GLOBAL_domain AND ar_nbr = STRING(ttssarparp02_ar_bill,"x(8)") + ttssarparp02_ar_check EXCLUSIVE-LOCK.
         ar_user1 = "1".

         /* 执行CIM数据装入 */
         INPUT FROM VALUE(p-file).
         OUTPUT TO VALUE(p-file + ".cim").
         batchrun = YES.
         {gprun.i ""ssarpam1.p""}
         batchrun = NO.
         INPUT CLOSE.
         OUTPUT CLOSE.

         {gprun.i ""ssarpai1c.p"" "(
            INPUT ar_bill,
            INPUT ar_date,
            INPUT ar_check,
            OUTPUT output-find,
            OUTPUT output-check
            )"}

         IF output-find THEN DO:
            ar_user1 = "3".
            ar_user2 = output-check.
         END.
         ELSE DO:
            ar_user1 = "2".
         END.
      END.

      /* 删除输入和输出临时文件 */
      /* SS - 20071020.1 - B */
      /*
      OS-DELETE VALUE(p-file).
      OS-DELETE VALUE(p-file + ".cim").
      */
      FIND FIRST mfc_ctrl WHERE mfc_domain = GLOBAL_domain AND mfc_field = "ssari_tmp" NO-LOCK NO-ERROR.
      IF AVAILABLE mfc_ctrl THEN DO:
         IF mfc_logical = NO THEN DO:
            OS-DELETE VALUE(p-file).
            OS-DELETE VALUE(p-file + ".cim").
         END.
      END.
      ELSE DO:
         /* 没有发现控制表记录 */
         {pxmsg.i &MSGNUM=291 &ERRORLEVEL=3}
         RETURN.
      END.
      /* SS - 20071020.1 - E */
   END. /* IF LAST-OF(ar_nbr) THEN DO: */
END.

