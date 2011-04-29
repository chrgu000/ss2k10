/* BY: Bill Jiang DATE: 10/03/06 ECO: 20061003.1 */
/* BY: Bill Jiang DATE: 11/03/06 ECO: 20061103.1 */

/* SS - 20061103.1 - B */
/*
1. "FX"类型的账务单独处理
*/
/* SS - 20061103.1 - E */
                                            
/* SS - 20061003.1 - B */
/* 
1. 重新计算错误的或没有计算过的或所有的记录 
2. 以一个总账参考号为最小的计算单位
3. 按以下顺序分别计算:
   1) 计算指定的包含现金及现金等价物科目的总账参考号:SUCCESS/ERROR
   2) 计算指定的不包含现金及现金等价物的包含损益科目的总账参考号:SUCCESS/ERROR
   3) 计算指定的既不包含现金及现金等价物的也不包含损益科目的总账参考号:SKIP
*/
/* SS - 20061003.1 - E */

/*V8-*/
{mfdeclre.i}

/* EXTERNALIZED LABEL INCLUDE */
{gplabel.i}

DEFINE INPUT PARAMETER begdt LIKE gltr_eff_dt.   
DEFINE INPUT PARAMETER enddt LIKE gltr_eff_dt.
DEFINE INPUT PARAMETER recalculate LIKE mfc_logical.
DEFINE INPUT PARAMETER audit LIKE mfc_logical.

DEFINE VARIABLE cash LIKE mfc_logical.                    
DEFINE VARIABLE ie LIKE mfc_logical.
DEFINE VARIABLE acc LIKE gltr_acc.
DEFINE VARIABLE sub LIKE gltr_sub.
DEFINE VARIABLE ctr LIKE gltr_ctr.
DEFINE VARIABLE i1 LIKE mfc_integer.
DEFINE VARIABLE success_skip LIKE mfc_logical.

/* 重新计算错误的或没有计算过的记录 */
i1 = 0.
success_skip = YES.
FOR EACH gltr_hist NO-LOCK
   WHERE
   /* eB2.1 */ gltr_domain = GLOBAL_domain AND
   gltr_eff_dt >= begdt
   AND gltr_eff_dt <= enddt
   USE-INDEX gltr_eff_dt
   BREAK BY gltr_ref
   :

   IF NOT (gltr_user1 = "SUCCESS" OR gltr_user1 = "SKIP") THEN DO:
      success_skip = NO.
   END.

   IF NOT LAST-OF(gltr_ref) THEN DO:
      NEXT.
   END. /* IF LAST-OF(gltr_ref) THEN DO: */

   IF audit = YES THEN DO:
      i1 = i1 + 1.
      HIDE MESSAGE NO-PAUSE.
      MESSAGE STRING(i1).
   END.

   /* 是否需要重新计算 */
   IF recalculate = NO THEN DO:
      /*
      FIND FIRST usrw_wkfl
         WHERE 
         /* eB2.1 */ usrw_domain = GLOBAL_domain AND
         usrw_key1 = 'GLTR_HIST'
         AND usrw_key2 = gltr_ref + "." + STRING(gltr_rflag) + "." + STRING(gltr_line)
         AND (usrw_key3 = 'SUCCESS' OR usrw_key3 = 'SKIP')
         NO-LOCK
         NO-ERROR
         .
      IF AVAILABLE usrw_wkfl THEN NEXT.
      */
      /*
      IF gltr_user1 = "SUCCESS" OR gltr_user1 = "SKIP" THEN NEXT.
      */
      IF success_skip = YES THEN NEXT.
   END.
   success_skip = YES.

   /* SS - 20061103.1 - B */
   IF gltr_tr_type = "FX" THEN DO:
      {gprun.i ""xxglcfm1f.p"" "(
         INPUT gltr_ref
         )"}

      NEXT.
   END.
   /* SS - 20061103.1 - E */

   /* 判断指定的总账参考号是否包含现金及现金等价物或损益科目 */
   {gprun.i ""xxglcfm1ci.p"" "(
      INPUT gltr_ref,
      OUTPUT cash,
      OUTPUT ie,
      OUTPUT acc,
      OUTPUT sub,
      OUTPUT ctr
      )"}

   /* 计算指定的包含现金及现金等价物科目的总账参考号 */
   IF cash = TRUE THEN DO:
      {gprun.i ""xxglcfm1c.p"" "(
         INPUT gltr_ref,
         INPUT acc,
         INPUT sub,
         INPUT ctr
         )"}

      NEXT.
   END. /* IF cash = TRUE THEN DO: */

   /* 计算指定的不包含现金及现金等价物的包含损益科目的总账参考号 */
   IF ie = TRUE THEN DO:
      {gprun.i ""xxglcfm1i.p"" "(
         INPUT gltr_ref,
         INPUT acc,
         INPUT sub,
         INPUT ctr
         )"}

      NEXT.
   END. /* IF ie = TRUE THEN DO: */

   /* 计算指定的既不包含现金及现金等价物的也不包含损益科目的总账参考号 */
   {gprun.i ""xxglcfm1s.p"" "(
      INPUT gltr_ref
      )"}

   NEXT.

END. /* FOR EACH gltr_hist NO-LOCK */
