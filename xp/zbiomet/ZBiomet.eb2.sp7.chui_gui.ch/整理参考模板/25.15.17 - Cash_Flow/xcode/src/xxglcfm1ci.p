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
1. 判断指定的总账参考号是否包含现金及现金等价物或损益科目
2. 以一个总账参考号为最小的计算单位
3.	现金及现金等价物科目优先
4. 包含了以下常量:
	031301 - 现金及现金等价物格式位置
*/
/* SS - 20060929.1 - E */

/*V8-*/
{mfdeclre.i}

/* EXTERNALIZED LABEL INCLUDE */
{gplabel.i}

DEFINE INPUT PARAMETER ref LIKE gltr_ref.
DEFINE OUTPUT PARAMETER cash LIKE mfc_logical INITIAL FALSE.
DEFINE OUTPUT PARAMETER ie LIKE mfc_logical INITIAL FALSE.
DEFINE OUTPUT PARAMETER acc LIKE gltr_acc.
DEFINE OUTPUT PARAMETER sub LIKE gltr_sub.
DEFINE OUTPUT PARAMETER ctr LIKE gltr_ctr.
DEFINE VARIABLE sums LIKE glrd_sums.
/* SS - 20071120.1 - B */
DEFINE VARIABLE dr_cr LIKE glrd_user1.
/* SS - 20071120.1 - E */

/* cash */
FOR EACH gltr_hist NO-LOCK
   WHERE 
   /* eB2.1 */ gltr_domain = GLOBAL_domain AND 
   gltr_ref = ref
   USE-INDEX gltr_ref
   :

   /* 是否包含现金及现金等价物科目 */
   {gprun.i ""xxglcfm1glrd.p"" "(
		INPUT '031301',
      INPUT gltr_acc,
      INPUT gltr_sub,
      INPUT gltr_ctr,
      INPUT-OUTPUT cash,
      INPUT-OUTPUT sums
      /* SS - 20071120.1 - B */
      ,INPUT-OUTPUT dr_cr
      /* SS - 20071120.1 - E */
      )"}

   IF cash = TRUE THEN DO:
      acc = gltr_hist.gltr_acc.
      sub = gltr_hist.gltr_sub.
      ctr = gltr_hist.gltr_ctr.
      RETURN.
   END.
   /* 是否包含现金及现金等价物科目 */
END.

/* ie */
FOR EACH gltr_hist NO-LOCK
   WHERE 
   /* eB2.1 */ gltr_domain = GLOBAL_domain AND 
   gltr_ref = ref
   USE-INDEX gltr_ref
   :

   /* 是否包含损益科目 */
   FOR EACH ac_mstr NO-LOCK
      WHERE
      /* eB2.1 */ ac_domain = GLOBAL_domain AND
      ac_code = gltr_hist.gltr_acc 
      AND (ac_type = "I" OR ac_type = "E")
      USE-INDEX ac_code
      :
      ie = TRUE.
      acc = gltr_hist.gltr_acc.
      sub = gltr_hist.gltr_sub.
      ctr = gltr_hist.gltr_ctr.
      RETURN.
   END.
   /* 是否包含损益科目 */
END.
