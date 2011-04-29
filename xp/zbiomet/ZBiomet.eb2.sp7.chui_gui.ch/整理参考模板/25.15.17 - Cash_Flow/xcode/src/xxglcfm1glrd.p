/* BY: Bill Jiang DATE: 09/29/06 ECO: 20060929.1 */
/* BY: Bill Jiang DATE: 11/20/07 ECO: 20071120.1 */
/* BY: Bill Jiang DATE: 11/21/07 ECO: 20071121.1 */

/* SS - 20071121.1 - B */
/*
1. 更新了BUG
*/
/* SS - 20071121.1 - E */
   
/* SS - 20071120.1 - B */
/*
1. 增加了以下输入输出参数:
   dr_cr:0 - 所有生额,1 - 借方发生额,2 - 贷方发生额
*/
/* SS - 20071120.1 - E */

/* SS - 20060929.1 - B */
/*
1. 判断指定的账户,分账户和成本中心的组合是否具有指定类型的格式位置
2. 按以下优先顺序进行判断:
   分账户
   账户
   成本中心
*/
/* SS - 20060929.1 - E */

/*V8-*/
{mfdeclre.i}

/* EXTERNALIZED LABEL INCLUDE */
{gplabel.i}

DEFINE INPUT PARAMETER CODE LIKE glrd_code.
DEFINE INPUT PARAMETER acc LIKE gltr_acc.
DEFINE INPUT PARAMETER sub LIKE gltr_sub.
DEFINE INPUT PARAMETER ctr LIKE gltr_ctr.
DEFINE INPUT-OUTPUT PARAMETER can_find LIKE mfc_logical INITIAL FALSE.
DEFINE INPUT-OUTPUT PARAMETER sums LIKE glrd_sums.
/* SS - 20071120.1 - B */
DEFINE INPUT-OUTPUT PARAMETER dr_cr LIKE glrd_user1.
/* SS - 20071120.1 - E */

FOR EACH glrd_det NO-LOCK
   WHERE 
   /* eB2.1 */ glrd_domain = GLOBAL_domain AND 
   glrd_code = code
   AND glrd_fpos = 0
   AND (glrd_acct <= acc OR glrd_acct = '')
   AND (glrd_acct1 >= acc OR glrd_acct1 = '')
   AND (glrd_sub <= sub OR glrd_sub = '')
   AND (glrd_sub1 >= sub OR glrd_sub1 = '')
   AND (glrd_cc <= ctr OR glrd_cc = '')
   AND (glrd_cc1 >= ctr OR glrd_cc1 = '')
   USE-INDEX glrd_code
   BY glrd_sub DESC 
   BY glrd_acct DESC 
   BY glrd_cc DESC
   :
   can_find = TRUE.
   sums = glrd_sums.

   /* SS - 20071121.1 - B */
   /*
   /* SS - 20071120.1 - B */
   dr_cr = glrd_user1.
   /* SS - 20071120.1 - E */
   RETURN.
   */
   LEAVE.
   /* SS - 20071121.1 - E */
END.

/* SS - 20071121.1 - B */
FOR EACH glrd_det NO-LOCK
   WHERE 
   /* eB2.1 */ glrd_domain = GLOBAL_domain AND 
   glrd_code = code
   AND glrd_fpos = sums
   USE-INDEX glrd_code
   BY glrd_line
   :
   dr_cr = glrd_user1.
   LEAVE.
END.
/* SS - 20071121.1 - E */
