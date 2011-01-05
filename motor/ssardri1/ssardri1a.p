/* $Revision: 1.6.1.8 $    BY: Bill Jiang    DATE: 08/17/07   ECO: *SS - 20070817.1*  */
/* $Revision: 1.6.1.8 $    BY: Bill Jiang    DATE: 10/20/07   ECO: *SS - 20071020.1*  */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{ssardrrp0101.i}

DEFINE INPUT PARAMETER ar-entity LIKE ar_entity.

DEFINE VARIABLE p-file AS CHARACTER.
DEFINE VARIABLE output-find LIKE mfc_logical.
DEFINE VARIABLE output-nbr LIKE ar_nbr.

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
FOR EACH ttssardrrp0101
   ,EACH ar_mstr EXCLUSIVE-LOCK
   WHERE ar_domain = GLOBAL_domain
   AND ar_nbr = ttssardrrp0101_ar_nbr
   ,EACH ard_det NO-LOCK
   WHERE ard_domain = GLOBAL_domain
   AND ard_nbr = ar_nbr
   BREAK BY ar_nbr
   :
   /*
   EXPORT DELIMITER "~011" ar_batch "-" ar_nbr ar_bill ar_curr ar_type ar_date ar_effdate ar_tax_date "-" ar_sales_amt ar_cr_terms ar_disc_date ar_due_date ar_expt_date ar_po
      ar_slspsn[1] ar_comm_pct[1] ar_slspsn[2] ar_comm_pct[2] ar_slspsn[3] ar_comm_pct[3] ar_slspsn[4] ar_comm_pct[4]
      ar_dun_level ar_acct ar_sub ar_cc ar_entity ar_cust ar_ship ar_contested ar_shipfrom "-" "-" "-" ard_acct ard_sub ard_cc ard_project ard_entity ard_tax_at ard_desc  ard_amt.
   */
   IF FIRST-OF(ar_nbr) THEN DO:
      OUTPUT TO VALUE(p-file).

      PUT UNFORMATTED "-" SKIP.
      PUT UNFORMATTED "-" SKIP.
      PUT UNFORMATTED "-" SKIP.
      EXPORT DELIMITER " " ar_bill.
      PUT UNFORMATTED " """ + ar_curr + """ - " ar_date " " ar_effdate " " ar_tax_date SKIP.

      PUT UNFORMATTED " - " ar_sales_amt " """ ar_cr_terms """ " ar_disc_date " " ar_due_date " " ar_expt_date " """ ar_po """".
      PUT UNFORMATTED " """ ar_slspsn[1] """ " ar_comm_pct[1] " """ ar_slspsn[2] """ " ar_comm_pct[2] " """ ar_slspsn[3] """ " ar_comm_pct[3] " """ ar_slspsn[4] """ " ar_comm_pct[4].
      PUT UNFORMATTED " """  ar_dun_level  """ """  ar_acct  """ """  ar_sub  """ """  ar_cc  """".
      PUT UNFORMATTED " """  ar-entity  """".
      /* SS - 20071020.1 - B */
      /*
      PUT UNFORMATTED " """  ar_cust  """ """  ar_ship  """ "  ar_contested " """  ar_shipfrom  """" SKIP.
      */
      IF ar_shipfrom = "" THEN DO:
         PUT UNFORMATTED " """  ar_cust  """ """  ar_ship  """ "  ar_contested " -" SKIP.
      END.
      ELSE DO:
         PUT UNFORMATTED " """  ar_cust  """ """  ar_ship  """ "  ar_contested " """  ar_shipfrom  """" SKIP.
      END.
      /* SS - 20071020.1 - E */

      FIND FIRST dyd_mstr WHERE dyd_domain = GLOBAL_domain NO-LOCK NO-ERROR.
      IF AVAILABLE dyd_mstr THEN DO:
         PUT UNFORMATTED "-" SKIP.
      END.

      IF ar_curr <> base_curr THEN DO:
         EXPORT DELIMITER " " ar_ex_rate ar_ex_rate2.
      END.

      EXPORT DELIMITER " " ar_nbr.

      PUT UNFORMATTED "-" SKIP.
   END. /* IF FIRST-OF(ar_nbr) THEN DO: */

   IF ard_tax <> "t" AND ard_tax <> "ti" THEN DO:
      EXPORT DELIMITER " " ard_acct ard_sub ard_cc ard_project ar-entity SUBSTRING(ard_tax_at,1,1).
      IF ard_tax_at = "yes" THEN DO:
         EXPORT DELIMITER " " ard_tax_usage ard_taxc.
      END.
      EXPORT DELIMITER " " ard_desc ard_amt.
   END. /* IF ard_tax <> "t" AND ard_tax <> "ti" THEN DO: */

   IF LAST-OF(ar_nbr) THEN DO:
      PUT UNFORMATTED "." SKIP.
      PUT UNFORMATTED "-" SKIP.
      PUT UNFORMATTED "." SKIP.
      PUT UNFORMATTED "." SKIP.

      OUTPUT CLOSE.

      DO TRANSACTION:
         ar_user1 = "1".

         /* 执行CIM数据装入 */
         INPUT FROM VALUE(p-file).
         OUTPUT TO VALUE(p-file + ".cim").
         batchrun = YES.
         {gprun.i ""ssardrm1.p""}
         batchrun = NO.
         INPUT CLOSE.
         OUTPUT CLOSE.

         {gprun.i ""ssardri1b.p"" "(
            INPUT ar_bill,
            INPUT ar_date,
            INPUT ar_nbr,
            OUTPUT output-find,
            OUTPUT output-nbr
            )"}

         IF output-find THEN DO:
            ar_user1 = "3".
            ar_user2 = output-nbr.
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

