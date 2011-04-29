/* BY: Bill Jiang DATE: 10/03/06 ECO: 20061003.1 */

/* 重新计算错误的或没有计算过的记录 */
{gprun.i ""xxglcfm1a.p"" "(
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
 */  .

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
   EXPORT DELIMITER ";" 
      usrw_intfld[2] 
      usrw_charfld[1]
      usrw_charfld[2]
      usrw_charfld[3]
      gltr_acc
      gltr_sub
      gltr_ctr
      gltr_amt * usrw_intfld[4]
      gltr_desc
      gltr_ref
      gltr_line
      .

   IF usrw_intfld[3] < sums OR usrw_intfld[3] > sums1 THEN NEXT.
   IF usrw_intfld[3] <> 0 THEN DO:
      EXPORT DELIMITER ";" 
         usrw_intfld[3] 
         usrw_charfld[1]
         usrw_charfld[2]
         usrw_charfld[3]
         gltr_acc
         gltr_sub
         gltr_ctr
         gltr_amt * usrw_intfld[5]
         gltr_desc
         gltr_ref
         gltr_line
         .
   END.
END. /* FOR EACH gltr_hist NO-LOCK */
