/* BY: Bill Jiang DATE: 10/03/06 ECO: 20061003.1 */
/* BY: Bill Jiang DATE: 11/10/07 ECO: 20071110.1 */

/* 重新计算错误的或没有计算过的记录 */
{gprun.i ""a6glcfm1a.p"" "(
   INPUT begdt,
   INPUT enddt,
   INPUT NO,
   INPUT NO
   )"}

/*
EXPORT DELIMITER ";" 
   "科目分组" 
   "现金或损益账户" 
   "分账户" 
   "成本中心"
   "对方账户" 
   "分账户" 
   "成本中心"
   "金额" 
   "摘要" 
   "总账参考号"
   "项"
   .
*/

/* SS - 20071110.1 - B */
/*
EXPORT DELIMITER ";" 
   "科目分组" 
   "科目分组说明" 
   "现金或损益账户" 
   "现金或损益账户说明" 
   "分账户" 
   "分账户说明" 
   "成本中心"
   "成本中心说明"
   "对方账户" 
   "对方账户说明" 
   "分账户" 
   "分账户说明" 
   "成本中心"
   "成本中心说明"
   "金额" 
   "摘要" 
   "总账参考号"
   "项"
   .
*/
DEFINE VARIABLE glrd-desc LIKE glrd_desc.
DEFINE VARIABLE ac-desc1 LIKE ac_desc.
DEFINE VARIABLE sb-desc1 LIKE sb_desc.
DEFINE VARIABLE cc-desc1 LIKE cc_desc.
DEFINE VARIABLE ac-desc2 LIKE ac_desc.
DEFINE VARIABLE sb-desc2 LIKE sb_desc.
DEFINE VARIABLE cc-desc2 LIKE cc_desc.
/* SS - 20071110.1 - E */

/* SUCCESS */
FOR EACH gltr_hist NO-LOCK
   WHERE 
   /* eB2.1 */ gltr_domain = GLOBAL_domain AND
   gltr_eff_dt >= begdt
   AND gltr_eff_dt <= enddt
   AND gltr_entity = entity 
   USE-INDEX gltr_eff_dt
   ,EACH usrw_wkfl NO-LOCK
   WHERE
   /* eB2.1 */ usrw_domain = GLOBAL_domain AND
   usrw_key1 = "GLTR_HIST"
   AND usrw_key2 = gltr_ref + "." + STRING(gltr_rflag) + "." + STRING(gltr_line)
   AND usrw_key3 = "SUCCESS"
   :

   IF usrw_intfld[2] < sums OR usrw_intfld[2] > sums1 THEN NEXT.

   /* SS - 20071110.1 - B */
   /* TODO: */
   FIND FIRST glrd_det WHERE 
      /* eB2.1 */ glrd_domain = GLOBAL_domain AND 
      glrd_fpos = usrw_intfld[2] NO-LOCK NO-ERROR.
   IF AVAILABLE glrd_det THEN DO:
      glrd-desc = glrd_desc.
   END.
   ELSE DO:
      glrd-desc = "".
   END.
   FIND FIRST ac_mstr WHERE 
      /* eB2.1 */ ac_domain = GLOBAL_domain AND 
      ac_code = usrw_charfld[1] NO-LOCK NO-ERROR.
   IF AVAILABLE ac_mstr THEN DO:
      ac-desc1 = ac_desc.
   END.
   ELSE DO:
      ac-desc1 = "".
   END.
   FIND FIRST ac_mstr WHERE 
      /* eB2.1 */ ac_domain = GLOBAL_domain AND 
      ac_code = gltr_acc NO-LOCK NO-ERROR.
   IF AVAILABLE ac_mstr THEN DO:
      ac-desc2 = ac_desc.
   END.
   ELSE DO:
      ac-desc2 = "".
   END.
   FIND FIRST sb_mstr WHERE 
      /* eB2.1 */ sb_domain = GLOBAL_domain AND 
      sb_sub = usrw_charfld[2] NO-LOCK NO-ERROR.
   IF AVAILABLE sb_mstr THEN DO:
      sb-desc1 = sb_desc.
   END.
   ELSE DO:
      sb-desc1 = "".
   END.
   FIND FIRST sb_mstr WHERE 
      /* eB2.1 */ sb_domain = GLOBAL_domain AND 
      sb_sub = gltr_sub NO-LOCK NO-ERROR.
   IF AVAILABLE sb_mstr THEN DO:
      sb-desc2 = sb_desc.
   END.
   ELSE DO:
      sb-desc2 = "".
   END.
   FIND FIRST cc_mstr WHERE 
      /* eB2.1 */ cc_domain = GLOBAL_domain AND 
      cc_ctr = usrw_charfld[3] NO-LOCK NO-ERROR.
   IF AVAILABLE cc_mstr THEN DO:
      cc-desc1 = cc_desc.
   END.
   ELSE DO:
      cc-desc1 = "".
   END.
   FIND FIRST cc_mstr WHERE 
      /* eB2.1 */ cc_domain = GLOBAL_domain AND 
      cc_ctr = gltr_ctr NO-LOCK NO-ERROR.
   IF AVAILABLE cc_mstr THEN DO:
      cc-desc2 = cc_desc.
   END.
   ELSE DO:
      cc-desc2 = "".
   END.
   /* SS - 20071110.1 - E */

   EXPORT DELIMITER ";" 
      STRING(usrw_intfld[2]) + " - " + glrd-desc
      usrw_charfld[1] + " - " + ac-desc1
      usrw_charfld[2] + " - " + sb-desc1
      usrw_charfld[3] + " - " + cc-desc1
      gltr_acc + " - " + ac-desc2
      gltr_sub + " - " + sb-desc2
      gltr_ctr + " - " + cc-desc2
      gltr_amt * usrw_intfld[4]
      gltr_desc
      gltr_ref
      gltr_line
      .

   IF usrw_intfld[3] < sums OR usrw_intfld[3] > sums1 THEN NEXT.
   /* TODO: */
   FIND FIRST glrd_det WHERE 
      /* eB2.1 */ glrd_domain = GLOBAL_domain AND 
      glrd_fpos = usrw_intfld[2] NO-LOCK NO-ERROR.
   IF AVAILABLE glrd_det THEN DO:
      glrd-desc = glrd_desc.
   END.
   ELSE DO:
      glrd-desc = "".
   END.
   IF usrw_intfld[3] <> 0 THEN DO:
      EXPORT DELIMITER ";" 
         STRING(usrw_intfld[3]) + " - " + glrd-desc
         usrw_charfld[1] + " - " + ac-desc1
         usrw_charfld[2] + " - " + sb-desc1
         usrw_charfld[3] + " - " + cc-desc1
         gltr_acc + " - " + ac-desc2
         gltr_sub + " - " + sb-desc2
         gltr_ctr + " - " + cc-desc2
         gltr_amt * usrw_intfld[5]
         gltr_desc
         gltr_ref
         gltr_line
         .
   END.
END. /* FOR EACH gltr_hist NO-LOCK */
