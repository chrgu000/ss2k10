/* $Revision: 1.6.1.8 $    BY: Bill Jiang    DATE: 08/26/07   ECO: *SS - 20070826.1*  */
/* $Revision: 1.6.1.8 $    BY: Bill Jiang    DATE: 10/20/07   ECO: *SS - 20071020.1*  */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{ssapvorp01.i}

DEFINE INPUT PARAMETER ap-entity LIKE ap_entity.

DEFINE VARIABLE p-file AS CHARACTER.
DEFINE VARIABLE output-find LIKE mfc_logical.
DEFINE VARIABLE output-ref LIKE vo_ref.

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
FOR EACH ttssapvorp01
   ,EACH ap_mstr EXCLUSIVE-LOCK
   WHERE ap_domain = GLOBAL_domain
   AND ap_type = "VO"
   AND ap_ref = ttssapvorp01_vo_ref
   ,EACH vo_mstr NO-LOCK
   WHERE vo_domain = GLOBAL_domain
   AND vo_ref = ap_ref
   ,EACH vod_det NO-LOCK
   WHERE vod_domain = GLOBAL_domain
   AND vod_ref = vo_ref
   AND vod_ln = ttssapvorp01_vod_ln
   ,EACH bk_mstr NO-LOCK
   WHERE bk_domain = GLOBAL_domain
   AND bk_code = ap_bank
   BREAK BY vo_ref
   :
   /*
   EXPORT DELIMITER "~011" ap_batch "-" ap_ref "-" ap_vend ap_effdate vo_tax_date vo_ship
   vo_curr ap_bank vo_invoice ap_date vo_cr_terms vo_disc_date vo_due_date ap_expt_date
   ap_acct ap_sub ap_cc ap_disc_acct ap_disc_sub ap_disc_cc ap_entity ap_rmk vo__qad02 vo_separate vo_type ap_ckfrm
   vo_prepay vo_ndisc_amt
   "-" "-" "-" "-" "-"
   vod_ln vod_acct vod_sub vod_cc vod_project vod_entity vod_taxable vod_desc vod_amt
   "no"
   vo_hold_amt vo_confirmed vo__qad01.
   */
   IF FIRST-OF(vo_ref) THEN DO:
      OUTPUT TO VALUE(p-file).

      PUT UNFORMATTED "-" SKIP.
      PUT UNFORMATTED "-" SKIP.
      PUT UNFORMATTED "-" SKIP.
      PUT UNFORMATTED "." SKIP.

      PUT UNFORMATTED "- """ + ap_vend + """ " ap_effdate " " vo_tax_date " """ vo_ship """" SKIP.

      EXPORT DELIMITER " " vo_ref.

      EXPORT DELIMITER " " vo_curr bk_user1 vo_invoice ap_date vo_cr_terms vo_disc_date vo_due_date ap_expt_date
         ap_acct ap_sub ap_cc ap_disc_acct ap_disc_sub ap_disc_cc ap-entity ap_rmk vo__qad02 vo_separate vo_type ap_ckfrm.

      IF vo_curr <> base_curr THEN DO:
         EXPORT DELIMITER " " ap_ex_rate ap_ex_rate2.
      END.

      EXPORT DELIMITER " " vo_prepay vo_ndisc_amt.

      FIND FIRST dyd_mstr WHERE dyd_domain = GLOBAL_domain NO-LOCK NO-ERROR.
      IF AVAILABLE dyd_mstr THEN DO:
         PUT UNFORMATTED "-" SKIP.
      END.

      /* SS - 20071020.1 - B */
      /*
      PUT UNFORMATTED "-" SKIP.
      */
      /* SS - 20071020.1 - E */

      PUT UNFORMATTED "- - - - -" SKIP.
   END. /* IF FIRST-OF(vo_ref) THEN DO: */

   IF vod_tax <> "t" AND vod_tax <> "ti" THEN DO:
      EXPORT DELIMITER " " vod_ln.
      /* SS - 20071020.1 - B */
      /*
      EXPORT DELIMITER " " vod_acct vod_sub vod_cc vod_project ap-entity vod_taxable.
      */
      FIND FIRST mfc_ctrl WHERE mfc_domain = GLOBAL_domain AND mfc_field = "ssapi_acct" NO-LOCK NO-ERROR.
      IF AVAILABLE mfc_ctrl THEN DO:
         EXPORT DELIMITER " " mfc_char "" "" "" ap-entity vod_taxable.
      END.
      ELSE DO:
         /* 没有发现控制表记录 */
         {pxmsg.i &MSGNUM=291 &ERRORLEVEL=3}
         RETURN.
      END.
      /* SS - 20071020.1 - E */
      IF vod_taxable = YES THEN DO:
         EXPORT DELIMITER " " vod_tax_usage vod_taxc vod_taxable vod_tax_in.
      END.
      /* SS - 20071020.1 - B */
      /*
      EXPORT DELIMITER " " vod_desc.
      */
      PUT UNFORMATTED "-" SKIP.
      /* SS - 20071020.1 - E */
      EXPORT DELIMITER " " vod_amt.
   END. /* IF vod_tax <> "t" AND vod_tax <> "ti" THEN DO: */

   IF LAST-OF(vo_ref) THEN DO:
      PUT UNFORMATTED "." SKIP.
      PUT UNFORMATTED "-" SKIP.
      EXPORT DELIMITER " " vo_hold_amt vo_confirmed vo__qad01.
      PUT UNFORMATTED "." SKIP.
      PUT UNFORMATTED "." SKIP.

      OUTPUT CLOSE.

      DO TRANSACTION:
         ap_user1 = "1".

         /* 执行CIM数据装入 */
         INPUT FROM VALUE(p-file).
         OUTPUT TO VALUE(p-file + ".cim").
         batchrun = YES.
         {gprun.i ""ssapvoma.p""}
         batchrun = NO.
         INPUT CLOSE.
         OUTPUT CLOSE.

         {gprun.i ""ssapvoiab.p"" "(
            INPUT ap_vend,
            INPUT ap_date,
            INPUT ap_ref,
            OUTPUT output-find,
            OUTPUT output-ref
            )"}

         IF output-find THEN DO:
            ap_user1 = "3".
            ap_user2 = output-ref.
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
   END. /* IF LAST-OF(vo_ref) THEN DO: */
END.

