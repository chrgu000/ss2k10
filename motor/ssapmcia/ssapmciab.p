/* $Revision: 1.6.1.8 $    BY: Bill Jiang    DATE: 08/26/07   ECO: *SS - 20070826.1*  */
/* $Revision: 1.6.1.8 $    BY: Bill Jiang    DATE: 10/20/07   ECO: *SS - 20071020.1*  */
/* $Revision: 1.6.1.8 $    BY: Bill Jiang    DATE: 02/21/08   ECO: *SS - 20080221.1*  */
/* $Revision: 1.6.1.8 $    BY: Bill Jiang    DATE: 03/09/08   ECO: *SS - 20080309.1*  */

/* SS - 20080309.1 - B */
/*
1. 解决了以下BUG:
   1) 银行为基本货币
   2) 支付的凭证为非基本货币
*/
/* SS - 20080309.1 - E */

/* SS - 20080221.1 - B */
/*
1. 解决了不区别货币的BUG
2.更正了用本币支付外币的BUG
3.处理了"N"类型的BUG
*/
/* SS - 20080221.1 - E */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{ssapckrp01.i}

DEFINE INPUT PARAMETER ap-entity LIKE ap_entity.

DEFINE VARIABLE p-file AS CHARACTER.
DEFINE VARIABLE output-find LIKE mfc_logical.
DEFINE VARIABLE output-nbr LIKE ck_nbr.

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
FOR EACH ttssapckrp01
   ,EACH bk_mstr NO-LOCK
   WHERE bk_domain = GLOBAL_domain
   AND bk_code = ttssapckrp01_ck_bank
   BREAK BY ttssapckrp01_ck_ref
   :
   IF FIRST-OF(ttssapckrp01_ck_ref) THEN DO:
      OUTPUT TO VALUE(p-file).

      PUT UNFORMATTED "-" SKIP.
      PUT UNFORMATTED "-" SKIP.

      EXPORT DELIMITER " " bk_user1.

      PUT UNFORMATTED "-" SKIP.

      /* SS - 20080221.1 - B */
      /*
      PUT UNFORMATTED "- """ ttssapckrp01_ap_curr """ """ ttssapckrp01_ap_vend """ " ttssapckrp01_ap_date " " ttssapckrp01_ap_effdate.
      */
      IF ttssapckrp01_ap_curr <> base_curr 
         /* SS - 20080309.1 - B */
         AND bk_curr <> base_curr
         /* SS - 20080309.1 - E */
         THEN DO:
         PUT UNFORMATTED "- """ ttssapckrp01_ap_vend """ " ttssapckrp01_ap_date " " ttssapckrp01_ap_effdate.
      END.
      ELSE DO:
         PUT UNFORMATTED "- """ ttssapckrp01_ap_curr """ """ ttssapckrp01_ap_vend """ " ttssapckrp01_ap_date " " ttssapckrp01_ap_effdate.
      END.
      /* SS - 20080221.1 - E */
      FIND FIRST dyd_mstr WHERE dyd_domain = GLOBAL_domain NO-LOCK NO-ERROR.
      IF AVAILABLE dyd_mstr THEN DO:
         FIND ap_mstr WHERE ap_domain = GLOBAL_domain AND ap_type = "CK" AND ap_ref = ttssapckrp01_ck_ref NO-LOCK.
         PUT UNFORMATTED " """ ap_dy_code """".
      END.
      PUT SKIP.

      EXPORT DELIMITER " " ttssapckrp01_ap_disc_acct ttssapckrp01_ap_disc_sub ttssapckrp01_ap_disc_cc ttssapckrp01_ap_rmk.

      IF ttssapckrp01_ap_curr <> base_curr THEN DO:
         EXPORT DELIMITER " " ttssapckrp01_ap_ex_rate ttssapckrp01_ap_ex_rate2.
      END.

      EXPORT DELIMITER " " ttssapckrp01_ck_nbr.
   END. /* IF FIRST-OF(ttssapckrp01_ck_ref) THEN DO: */

   IF ttssapckrp01_ckd_type = "N" THEN DO:
      PUT UNFORMATTED "-" SKIP.
      /* SS - 20080221.1 - B */
      /*
      EXPORT DELIMITER " " ttssapckrp01_ckd_acct.
      EXPORT DELIMITER " " ttssapckrp01_ckd_sub.
      EXPORT DELIMITER " " ttssapckrp01_ckd_cc.
      */
      EXPORT DELIMITER " " ttssapckrp01_ckd_acct ttssapckrp01_ckd_sub ttssapckrp01_ckd_cc.
      /* SS - 20080221.1 - E */
      PUT UNFORMATTED "-" SKIP.
      EXPORT DELIMITER " " ttssapckrp01_ckd_amt ttssapckrp01_ckd_disc.
   END.
   ELSE DO:
      FIND ap_mstr WHERE ap_domain = GLOBAL_domain AND ap_type = "VO" AND ap_ref = ttssapckrp01_ckd_voucher NO-LOCK NO-ERROR.
      IF AVAILABLE ap_mstr THEN DO:
         EXPORT DELIMITER " " ap_user2.
      END.
      ELSE DO:
         OUTPUT CLOSE.
         OS-DELETE VALUE(p-file).
         NEXT.
      END.

      PUT UNFORMATTED "-" SKIP.
      EXPORT DELIMITER " " ttssapckrp01_ckd_amt ttssapckrp01_ckd_disc.

      /* SS - 20080221.1 - B */
      IF ttssapckrp01_ap_curr <> base_curr THEN DO:
         IF bk_curr <> ap_curr THEN DO:
            PUT UNFORMATTED "-" SKIP.
         END.
      END.
      ELSE DO:
         IF ttssapckrp01_ap_curr <> ap_curr THEN DO:
            PUT UNFORMATTED "-" SKIP.
         END.
      END.
      /* SS - 20080221.1 - E */
   END.

   IF LAST-OF(ttssapckrp01_ck_ref) THEN DO:
      PUT UNFORMATTED "." SKIP.
      PUT UNFORMATTED "." SKIP.
      PUT UNFORMATTED "." SKIP.

      OUTPUT CLOSE.
        
      DO TRANSACTION:
         FIND ap_mstr WHERE ap_domain = GLOBAL_domain AND ap_type = "CK" AND ap_ref = ttssapckrp01_ck_ref EXCLUSIVE-LOCK.
         ap_user1 = "1".

         /* 执行CIM数据装入 */
         INPUT FROM VALUE(p-file).
         OUTPUT TO VALUE(p-file + ".cim").
         batchrun = YES.
         {gprun.i ""ssapmcma.p""}
         batchrun = NO.
         INPUT CLOSE.
         OUTPUT CLOSE.

         {gprun.i ""ssapmciac.p"" "(
            INPUT ap_vend,
            INPUT ap_date,
            INPUT STRING(ttssapckrp01_ck_nbr),
            OUTPUT output-find,
            OUTPUT output-nbr
            )"}

         IF output-find THEN DO:
            ap_user1 = "3".
            ap_user2 = STRING(output-nbr).
         END.
         ELSE DO:
            ap_user1 = "2".
         END.
      END.

      /* 删除输入和输出临时文件 */
      /* SS - 20071020.1 - B */
      /*
      OS-DELETE VALUE(p-file).
      OS-DELETE VALUE(p-file + ".cim").
      */
      FIND FIRST mfc_ctrl WHERE mfc_domain = GLOBAL_domain AND mfc_field = "ssapi_tmp" NO-LOCK NO-ERROR.
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
   END. /* IF LAST-OF(ttssapckrp01_ck_ref) THEN DO: */
END.

