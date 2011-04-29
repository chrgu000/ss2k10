/* BY: Bill Jiang DATE: 09/29/06 ECO: 20060929.1 */
/* BY: Bill Jiang DATE: 11/20/07 ECO: 20071120.1 */

/* SS - 20071120.1 - B */
/*
1. 增加了以下输入输出参数:
   dr_cr:0 - 所有生额,1 - 借方发生额,2 - 贷方发生额
*/
/* SS - 20071120.1 - E */

/* SS - 20060929.1 - B */
/*
1. 计算指定的包含现金及现金等价物科目的总账参考号
2. 以一个总账参考号为最小的计算单位
3. 包含了以下常量:
	031301 - 现金及现金等价物格式位置
*/
/* SS - 20060929.1 - E */

/*V8-*/
{mfdeclre.i}

/* EXTERNALIZED LABEL INCLUDE */
{gplabel.i}

DEFINE INPUT PARAMETER ref LIKE gltr_ref.
DEFINE INPUT PARAMETER acc LIKE gltr_acc.
DEFINE INPUT PARAMETER sub LIKE gltr_sub.
DEFINE INPUT PARAMETER ctr LIKE gltr_ctr.
DEFINE VARIABLE can_find LIKE mfc_logical.
DEFINE VARIABLE sums1 LIKE glrd_sums.
DEFINE VARIABLE sums2 LIKE glrd_sums.
/* SS - 20071120.1 - B */
DEFINE VARIABLE dr_cr LIKE glrd_user1.
/* SS - 20071120.1 - E */

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

   /* 现金及现金等价物科目 */
   IF gltr_acc = acc AND gltr_sub = sub AND gltr_ctr = ctr THEN DO:
      ASSIGN
         gltr_user1 = "SKIP"
         usrw_key3 = "SKIP"
         usrw_charfld[1] = "C102"
         usrw_charfld[2] = "现金及现金等价物科目"
         .
      NEXT.
   END.

   can_find = FALSE.
   {gprun.i ""xxglcfm1glrd.p"" "(
      INPUT '031301',
      INPUT gltr_acc,
      INPUT gltr_sub,
      INPUT gltr_ctr,
      INPUT-OUTPUT can_find,
      INPUT-OUTPUT sums1
      /* SS - 20071120.1 - B */
      ,INPUT-OUTPUT dr_cr
      /* SS - 20071120.1 - E */
      )"}
   IF can_find = TRUE THEN DO:
      ASSIGN
         gltr_user1 = "SKIP"
         usrw_key3 = "SKIP"
         usrw_charfld[1] = "C102"
         usrw_charfld[2] = "现金及现金等价物科目"
         .
      NEXT.
   END.
   /* 现金及现金等价物科目 */

   /* 调整现金及现金等价物对方科目的不影响净利润的经营性资产负债的减少或增加 */
   /* 030101 - 经营活动产生的现金流入 */
   {xxglcfm1cbs.i '030101' -1 -1}
   /* 030101 - 经营活动产生的现金流入 */

   /* 030102 - 经营活动产生的现金流出 */
   {xxglcfm1cbs.i '030102' 1 -1}
   /* 030102 - 经营活动产生的现金流出 */

   /* 调整现金及现金等价物对方科目的影响净利润的非经营活动的现金流量 */
   /* 030201 - 投资活动产生的现金流入 */
   {xxglcfm1cis.i '030201' -1 1}
   /* 030201 - 投资活动产生的现金流入 */

   /* 030301 - 筹资活动产生的现金流入 */
   {xxglcfm1cis.i '030301' -1 1}
   /* 030301 - 筹资活动产生的现金流入 */

   /* 0304 - 汇率变动对现金的影响 */
   {xxglcfm1cis.i '0304' -1 1}
   /* 0304 - 汇率变动对现金的影响 */

   /* 030202 - 投资活动产生的现金流出 */
   {xxglcfm1cis.i '030202' 1 1}
   /* 030202 - 投资活动产生的现金流出 */

   /* 030302 - 筹资活动产生的现金流出 */
   {xxglcfm1cis.i '030302' 1 1}
   /* 030302 - 筹资活动产生的现金流出 */

   ASSIGN
      gltr_user1 = "ERROR"
      usrw_key3 = "ERROR"
      usrw_charfld[1] = "C005"
      usrw_charfld[2] = "没有定义现金及现金等价物对方科目的主表行次"
      .

   NEXT.
END. /* FOR EACH gltrhist EXCLUSIVE-LOCK */
