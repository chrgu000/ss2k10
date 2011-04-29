/* BY: Bill Jiang DATE: 10/03/06 ECO: 20061003.1 */

/* 重新计算错误的或没有计算过的记录 */
{gprun.i ""xxglcfm1a.p"" "(
   INPUT begdt,
   INPUT enddt,
   INPUT NO,
   INPUT NO
   )"}

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
   BREAK 
   BY usrw_intfld[2]
   BY usrw_intfld[3]
   :

   ACCUMULATE gltr_amt * usrw_intfld[5] (TOTAL BY usrw_intfld[3]).
   ACCUMULATE gltr_amt * usrw_intfld[4] (TOTAL BY usrw_intfld[2]).

   IF LAST-OF(usrw_intfld[3]) THEN DO:
      CREATE tt1.
      ASSIGN
         tt1_c1 = "Line" + STRING(usrw_intfld[3])
         tt1_d1 = ACCUMULATE TOTAL BY usrw_intfld[3] gltr_amt * usrw_intfld[5]
         .
   END.
   IF LAST-OF(usrw_intfld[2]) THEN DO:
      CREATE tt1.
      ASSIGN
         tt1_c1 = "Line" + STRING(usrw_intfld[2])
         tt1_d1 = ACCUMULATE TOTAL BY usrw_intfld[2] gltr_amt * usrw_intfld[4]
         .
   END.
END. /* FOR EACH gltr_hist NO-LOCK */

/* ERROR */
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
   AND usrw_key3 = "ERROR"
   :

   CREATE tt1.
   ASSIGN
      tt1_c1 = "Error"
      tt1_c2 = usrw_charfld[1] + " - " + usrw_charfld[2] + ": " + usrw_key2
      .
END. /* FOR EACH gltr_hist NO-LOCK */

/* 净利润 */
netprofit = 0.
FOR EACH gltr_hist NO-LOCK
   WHERE 
   /* eB2.1 */ gltr_domain = GLOBAL_domain AND
   gltr_eff_dt >= begdt
   AND gltr_eff_dt <= enddt
   AND gltr_entity = entity 
   USE-INDEX gltr_eff_dt
   ,EACH ac_mstr NO-LOCK
   WHERE
   /* eB2.1 */ ac_domain = GLOBAL_domain AND
   ac_code = gltr_acc 
   AND (ac_type = "I" OR ac_type = "E")
   :

   /* 净利润 */
   netprofit = netprofit + gltr_amt.
END. /* FOR EACH gltr_hist NO-LOCK */
FIND FIRST glrd_det 
   WHERE 
   /* eB2.1 */ glrd_domain = GLOBAL_domain AND
   glrd_code = '031100'
   AND glrd_det.glrd_fpos = 0
   USE-INDEX glrd_code
   NO-LOCK
   NO-ERROR
   .
IF AVAILABLE glrd_det THEN DO:
   CREATE tt1.
   ASSIGN
      tt1_c1= "Line" + STRING(glrd_sums)
      tt1_d1 = - netprofit
      .
END.
ELSE DO:
   CREATE tt1.
   ASSIGN 
      tt1_c1 = "Error"
      tt1_c2 = "C201 - 没有定义净利润的附表行次"
      .
END.

/* 现金及现金等价物期初(末)余额 */
o1 = 0.
o2 = 0.
FOR EACH glrd_det NO-LOCK
   WHERE 
   /* eB2.1 */ glrd_domain = GLOBAL_domain AND
   glrd_code = '031301'
   AND glrd_fpos = 0
   USE-INDEX glrd_code
   BREAK 
   BY glrd_sums
   :

   EMPTY TEMP-TABLE ttxxglabrp0001.

   {gprun.i ""xxglabrp0001.p"" "(
      INPUT entity,
      INPUT entity,
      INPUT glrd_acct,
      INPUT glrd_acct,
      INPUT glrd_sub,
      INPUT glrd_sub,
      INPUT glrd_cc,
      INPUT glrd_cc,
      INPUT begdt,
      INPUT enddt,
      INPUT dc,
      INPUT dc
      )"}

   FIND FIRST ttxxglabrp0001 NO-LOCK NO-ERROR.
   IF AVAILABLE ttxxglabrp0001 THEN DO:
      o1 = o1 + ttxxglabrp0001_et_beg_bal.
      o2 = o2 + ttxxglabrp0001_et_end_bal.
   END.

   IF LAST-OF(glrd_sums) THEN DO:
      CREATE tt1.
      ASSIGN
         tt1_c1 = "Line" + STRING(glrd_sums)
         tt1_d1 = o2
         .
      CREATE tt1.
      ASSIGN
         tt1_c1 = "Line" + STRING(glrd_sums + 10)
         tt1_d1 = o1
         .
      o1 = 0.
      o2 = 0.
   END.
END.
