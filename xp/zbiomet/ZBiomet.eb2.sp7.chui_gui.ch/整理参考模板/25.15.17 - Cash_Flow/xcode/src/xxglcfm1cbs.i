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
1. 参数说明:
{1} - glrd_code:
   030101 - 经营活动产生的现金流入
   030102 - 经营活动产生的现金流出
{2} - usrw_intfld[4]
{3} - usrw_intfld[5]
2. 调整现金及现金等价物对方科目的不影响净利润的经营性资产负债的减少或增加
3. 以一个总账参考号为最小的计算单位
4. 包含了以下常量:
	0311 - 将净利润调节为经营活动现金流量
*/
/* SS - 20060929.1 - E */

can_find = FALSE.
{gprun.i ""xxglcfm1glrd.p"" "(
   INPUT {1},
   INPUT gltr_acc,
   INPUT gltr_sub,
   INPUT gltr_ctr,
   INPUT-OUTPUT can_find,
   INPUT-OUTPUT sums1
   /* SS - 20071120.1 - B */
   ,INPUT-OUTPUT dr_cr
   /* SS - 20071120.1 - E */
   )"}
IF can_find = TRUE 
   /* SS - 20071120.1 - B */
   AND (
   (((gltr_amt >= 0 AND gltr_correction = NO) OR (gltr_amt <= 0 AND gltr_correction = YES)) AND dr_cr = "1")
   OR
   (((gltr_amt <= 0 AND gltr_correction = NO) OR (gltr_amt >= 0 AND gltr_correction = YES)) AND dr_cr = "2")
   OR 
   (dr_cr <> "1" AND dr_cr <> "2")
   )
   /* SS - 20071120.1 - E */
   THEN DO:
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
      /* 调节净利润 */
      can_find = FALSE.
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
      IF can_find = TRUE THEN DO:
         ASSIGN
            gltr_user1 = "SUCCESS"
            usrw_key3 = "SUCCESS"
            usrw_intfld[2] = sums1
            /* 0311 - 将净利润调节为经营活动现金流量 */
            usrw_intfld[3] = sums2
            usrw_intfld[4] = {2}
            usrw_intfld[5] = {3}
            usrw_charfld[1] = acc
            usrw_charfld[2] = sub
            usrw_charfld[3] = ctr
            .
      END. /* IF can_find = TRUE THEN DO: */
      ELSE DO:
         ASSIGN
            gltr_user1 = "ERROR"
            usrw_key3 = "ERROR"
            usrw_charfld[1] = "C001"
            usrw_charfld[2] = "没有调整现金及现金等价物对方科目的不影响净利润的经营性资产负债的减少或增加"
            .
      END.

      NEXT.
   END. /* IF AVAILABLE ac_mstr THEN DO: */
   /* 对方科目是资产负债表类 */


   /* 对方科目是利润类 */
   FIND FIRST ac_mstr
      WHERE 
      /* eB2.1 */ ac_domain = GLOBAL_domain AND
      ac_code = gltr_acc 
      AND (ac_type = 'I' OR ac_type = 'E') 
      USE-INDEX ac_code 
      NO-LOCK 
      NO-ERROR
      .
   IF AVAILABLE ac_mstr THEN DO:
      ASSIGN
         gltr_user1 = "SUCCESS"
         usrw_key3 = "SUCCESS"
         usrw_intfld[2] = sums1
         usrw_intfld[4] = {2}
         usrw_charfld[1] = acc
         usrw_charfld[2] = sub
         usrw_charfld[3] = ctr
         .

      NEXT.
   END.
   /* 对方科目是利润类 */

   ASSIGN
      gltr_user1 = "ERROR"
      usrw_key3 = "ERROR"
      usrw_charfld[1] = "C002"
      usrw_charfld[2] = "对方科目异常(不是A,L,I,E中的任何一种)"
      .

   NEXT.
END. /* IF can_find = TRUE THEN DO: */
