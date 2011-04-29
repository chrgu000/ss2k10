/* BY: Bill Jiang DATE: 10/03/06 ECO: 20061103.1 */
/* BY: Bill Jiang DATE: 11/20/07 ECO: 20071120.1 */

/* SS - 20071120.1 - B */
/*
1. 增加了以下输入输出参数:
   dr_cr:0 - 所有生额,1 - 借方发生额,2 - 贷方发生额
*/
/* SS - 20071120.1 - E */

/* SS - 20061103.1 - B */
/*
1. 外币兑换重新估价
*/
/* SS - 20061103.1 - E */

/*V8-*/
{mfdeclre.i}

/* EXTERNALIZED LABEL INCLUDE */
{gplabel.i}

DEFINE INPUT PARAMETER ref LIKE gltr_ref.
DEFINE VARIABLE acc LIKE gltr_acc.
DEFINE VARIABLE sub LIKE gltr_sub.
DEFINE VARIABLE ctr LIKE gltr_ctr.
DEFINE VARIABLE can_find LIKE mfc_logical.
DEFINE VARIABLE sums1 LIKE glrd_sums INITIAL 0.
DEFINE VARIABLE sums2 LIKE glrd_sums INITIAL 0.
DEFINE VARIABLE sums3 LIKE glrd_sums INITIAL 0.
/* SS - 20071120.1 - B */
DEFINE VARIABLE dr_cr LIKE glrd_user1.
/* SS - 20071120.1 - E */

FOR EACH gltr_hist EXCLUSIVE-LOCK
   WHERE 
   /* eB2.1 */ gltr_domain = GLOBAL_domain AND
   gltr_ref = ref 
   USE-INDEX gltr_ref 
   :
   /* 对方科目是资产负债表类 */
   FIND FIRST ac_mstr
      WHERE 
      /* eB2.1 */ ac_domain = GLOBAL_domain AND
      ac_code = gltr_acc 
      AND (ac_type = 'A' OR ac_type = 'L') 
      USE-INDEX ac_code 
      NO-LOCK 
      NO-ERROR
      .
   IF AVAILABLE ac_mstr THEN DO:
      NEXT.
   END.

   /* 汇率变动对现金的影响 */
   {gprun.i ""xxglcfm1glrd.p"" "(
      INPUT '0304',
      INPUT gltr_acc,
      INPUT gltr_sub,
      INPUT gltr_ctr,
      INPUT-OUTPUT can_find,
      INPUT-OUTPUT sums1
      /* SS - 20071120.1 - B */
      ,INPUT-OUTPUT dr_cr
      /* SS - 20071120.1 - E */
      )"}

   /* 调节净利润 */
   {gprun.i ""xxglcfm1glrd.p"" "(
      INPUT '0311',
      INPUT gltr_acc,
      INPUT gltr_sub,
      INPUT gltr_ctr,
      INPUT-OUTPUT can_find,
      INPUT-OUTPUT sums2
      /* SS - 20071120.1 - B */
      ,INPUT-OUTPUT dr_cr
      /* SS - 20071120.1 - E */
      )"}

   ASSIGN
      acc = gltr_acc
      sub = gltr_sub
      ctr = gltr_ctr
      .

   LEAVE.
END.

FOR EACH gltr_hist EXCLUSIVE-LOCK
   WHERE 
   /* eB2.1 */ gltr_domain = GLOBAL_domain AND
   gltr_ref = ref 
   USE-INDEX gltr_ref 
   :

   FIND FIRST usrw_wkfl WHERE 
      /* eB2.1 */ usrw_domain = GLOBAL_domain AND
      usrw_key1 = "GLTR_HIST"
      AND usrw_key2 = gltr_ref + "." + STRING(gltr_rflag) + "." + STRING(gltr_line)
      EXCLUSIVE-LOCK
      NO-ERROR.
   IF NOT AVAILABLE usrw_wkfl THEN DO:
      CREATE usrw_wkfl.
      ASSIGN
         /* eB2.1 */ usrw_domain = GLOBAL_domain
         usrw_key1 = "GLTR_HIST"
         usrw_key2 = gltr_ref + "." + STRING(gltr_rflag) + "." + STRING(gltr_line)
         .
   END.
   ASSIGN
      usrw_datefld[1] = TODAY
      usrw_intfld[1] = TIME
      usrw_key5 = GLOBAL_userid
      usrw_key6 = execname
      .

   IF acc = '' THEN DO:
      ASSIGN
         gltr_user1 = "SKIP"
         usrw_key3 = "SKIP"
         usrw_charfld[1] = "C111"
         usrw_charfld[2] = "FX:调节净利润为0"
         .

      NEXT.
   END.

   IF sums1 = 0 THEN DO:
      ASSIGN
         gltr_user1 = "ERROR"
         usrw_key3 = "ERROR"
         usrw_charfld[1] = "C011"
         usrw_charfld[2] = "FX:没有定义汇率变动对现金的影响的主表行次"
         .

      NEXT.
   END.

   IF sums2 = 0 THEN DO:
      ASSIGN
         gltr_user1 = "ERROR"
         usrw_key3 = "ERROR"
         usrw_charfld[1] = "C012"
         usrw_charfld[2] = "FX:没有定义调节净利润的附表行次"
         .

      NEXT.
   END.

   can_find = FALSE.
   /* 是否包含现金及现金等价物科目 */
   {gprun.i ""xxglcfm1glrd.p"" "(
		INPUT '031301',
      INPUT gltr_acc,
      INPUT gltr_sub,
      INPUT gltr_ctr,
      INPUT-OUTPUT can_find,
      INPUT-OUTPUT sums3
      /* SS - 20071120.1 - B */
      ,INPUT-OUTPUT dr_cr
      /* SS - 20071120.1 - E */
      )"}
   IF can_find = YES THEN DO:
      ASSIGN
         gltr_user1 = "SUCCESS"
         usrw_key3 = "SUCCESS"
         usrw_intfld[2] = sums1
         usrw_intfld[4] = 1
         usrw_charfld[1] = acc
         usrw_charfld[2] = sub
         usrw_charfld[3] = ctr
         .

      NEXT.
   END.

   /* 将净利润调节为经营活动现金流量 */
   IF gltr_acc = acc AND gltr_sub = sub AND gltr_ctr = ctr THEN DO:
      ASSIGN
         gltr_user1 = "SUCCESS"
         usrw_key3 = "SUCCESS"
         usrw_intfld[2] = sums2
         usrw_intfld[4] = 1
         usrw_charfld[1] = acc
         usrw_charfld[2] = sub
         usrw_charfld[3] = ctr
         .

      NEXT.
   END.

   /* FX:非现金及现金等价物和将净利润调节为经营活动现金流量科目 */
   ASSIGN
      gltr_user1 = "SKIP"
      usrw_key3 = "SKIP"
      usrw_charfld[1] = "C112"
      usrw_charfld[2] = "FX:非现金及现金等价物和将净利润调节为经营活动现金流量科目"
      .
   NEXT.
END. /* FOR EACH gltrhist EXCLUSIVE-LOCK */
