/* REVISION: eb2sp4      LAST MODIFIED: 05/24/06   BY: *SS - Micho - 20060524* Micho Yang     */
DEF TEMP-TABLE tt 
    FIELD tt_ref LIKE gltr_ref
    FIELD tt_line LIKE gltr_line
    FIELD tt_ac_code LIKE ac_code
    FIELD tt_ac_desc LIKE ac_desc
    FIELD tt_cc_ctr  LIKE cc_ctr
    FIELD tt_cc_desc LIKE cc_desc
    FIELD tt_curr    LIKE ac_curr
    FIELD tt_dr_amt     LIKE gltr_amt
    FIELD tt_cr_amt     LIKE gltr_amt
    FIELD tt_dr_curramt LIKE gltr_curramt 
    FIELD tt_cr_curramt LIKE gltr_curramt 
    INDEX CODE_ctr tt_ac_code tt_cc_ctr 
    .

DEF TEMP-TABLE tt1
    FIELD tt1_cc_ctr LIKE cc_ctr
    .

DEF VAR v_amt AS DECIMAL.
DEF VAR v_curr_amt AS DECIMAL .
DEF VAR v_cc_desc LIKE cc_desc.
DEF VAR v_username AS CHAR.

DEF VAR v_gltr_acc AS CHAR.
DEF VAR v_ac_desc AS CHAR.

DEF VAR v_dr_amt AS DECIMAL.
DEF VAR v_cr_amt AS DECIMAL.
DEF VAR v_dr_curramt AS DECIMAL.
DEF VAR v_cr_curramt AS DECIMAL.
DEF VAR v_tot_dr_curramt AS DECIMAL.
DEF VAR v_tot_cr_curramt AS DECIMAL.
DEF VAR v_tot_dr_amt AS DECIMAL.
DEF VAR v_tot_cr_amt AS DECIMAL.

FOR EACH tt :
    DELETE tt .
END.

v_dr_amt = 0.
v_cr_amt = 0.
v_dr_curramt = 0.
v_cr_curramt = 0.
FOR EACH gltr_hist NO-LOCK WHERE gltr_acc >= acc AND gltr_acc <= acc1 
                             AND gltr_sub >= sub AND gltr_sub <= sub1
                             AND gltr_ctr >= ctr AND gltr_ctr <= ctr1 
                             AND (gltr_ctr <> "" )
                             AND gltr_entity >= entity AND gltr_entity <= entity1 
                             AND gltr_eff_dt >= effdate AND gltr_eff_dt <= effdate1
                             ,
    EACH ac_mstr NO-LOCK WHERE ac_code = gltr_acc :
     
    FIND FIRST cc_mstr WHERE cc_ctr = gltr_ctr NO-LOCK NO-ERROR.
    IF AVAIL cc_mstr AND cc_ctr <> "" THEN DO:
        v_cc_desc = cc_desc .
    END.

    IF gltr_acc = "" THEN DO:
        v_gltr_acc = "".
        v_ac_desc = "" .
    END.
    ELSE DO:
        v_gltr_acc = gltr_acc .
        v_ac_desc = ac_desc .
    END.
       
    IF (gltr_amt >= 0 AND gltr_correction = FALSE ) OR 
       (gltr_amt < 0  AND gltr_correction = TRUE  ) THEN DO:
        v_dr_amt = gltr_amt .
        v_cr_amt = 0.
    END.
    ELSE DO:
        v_dr_amt = 0 .
        v_cr_amt = - gltr_amt .
    END.

    IF ( ABS(v_dr_amt) > 0 AND v_dr_amt > 0 ) THEN v_dr_curramt = ABS(gltr_curramt) .
    IF ( ABS(v_dr_amt) > 0 AND v_dr_amt < 0 ) THEN v_dr_curramt = (- ABS(gltr_curramt)) .
    IF ( ABS(v_cr_amt) > 0 AND v_cr_amt > 0 ) THEN v_cr_curramt = ABS(gltr_curramt) .
    IF ( ABS(v_cr_amt) > 0 AND v_cr_amt < 0 ) THEN v_cr_curramt = (- ABS(gltr_curramt)) .

    CREATE tt .
    ASSIGN
        tt_ref = gltr_ref 
        tt_line = gltr_line
        tt_ac_code = v_gltr_acc
        tt_ac_desc = v_ac_desc
        tt_cc_ctr = gltr_ctr 
        tt_cc_desc = v_cc_desc
        tt_curr = ac_curr
        tt_dr_amt = v_dr_amt            /* 本币 */
        tt_cr_amt = v_cr_amt 
        tt_dr_curramt = v_dr_curramt   /* 原币 */
        tt_cr_curramt = v_cr_curramt 
        .
    IF ac_curr = "RMB"  THEN do:
        assign
            tt_dr_curramt = 0   /* 原币 */
            tt_cr_curramt = 0
            .
    END.

    v_dr_amt = 0.
    v_cr_amt = 0.
    v_dr_curramt = 0.
    v_cr_curramt = 0.
    v_cc_desc = "" .
    v_gltr_acc = "".
    v_ac_desc = "" .
END.                

FOR EACH tt NO-LOCK BREAK BY tt_cc_ctr : 
    IF LAST-OF(tt_cc_ctr) THEN DO:
       CREATE tt1 .
       ASSIGN 
          tt1_cc_ctr = tt_cc_ctr .
          .
    END.
END.

v_ac_desc = "" .
v_cc_desc = "" .
IF v_occur = NO THEN DO:
      FOR EACH ASC_mstr NO-LOCK ,
          EACH tt1 WHERE ASC_cc = tt1_cc_ctr BREAK BY ASC_cc BY ASC_acc :
          IF LAST-OF(ASC_acc) THEN DO:
             FIND FIRST tt WHERE tt_cc_ctr = ASC_cc 
                             AND tt_ac_code = ASC_acc NO-LOCK NO-ERROR.
             IF NOT AVAIL tt THEN DO:
                FIND FIRST ac_mstr WHERE ac_code = ASC_acc NO-LOCK NO-ERROR.
                IF AVAIL ac_mstr THEN v_ac_desc = ac_desc .
                FIND FIRST cc_mstr WHERE cc_ctr = ASC_cc NO-LOCK NO-ERROR.
                IF AVAIL cc_mstr THEN v_cc_desc = cc_desc .
      
                CREATE tt .
                ASSIGN
                    tt_ac_code = ASC_acc
                    tt_ac_desc = v_ac_desc
                    tt_cc_ctr = ASC_cc 
                    tt_cc_desc = v_cc_desc  
                    .
                v_ac_desc = "" .
                v_cc_desc = "" .
             END.
          END.  
      END.
END.
/*
PUT "tt" SKIP.
FOR EACH tt: 
   EXPORT DELIMITER ";" tt.
END.
  */

PUT UNFORMATTED "ExecutionFile" ";" "txt2xls2.exe" SKIP.
PUT UNFORMATTED "ExcelFile" ";" "a6glrp06" SKIP.
PUT UNFORMATTED "SaveFile" ";" "辅助帐余额表" SKIP.
PUT UNFORMATTED "PrintPreview" ";" "no" SKIP.
PUT UNFORMATTED "ActiveSheet" ";" "1" SKIP.
PUT UNFORMATTED "Format" ";" "no" SKIP.
/*
PUT UNFORMATTED "xlHAlignCenterAcrossSelection" ";" "1" SKIP.
*/

FIND FIRST usr_mstr WHERE usr_userid = global_userid NO-LOCK NO-ERROR.
IF AVAIL USr_mstr THEN DO:
       v_username = "由 " + usr_name + " 打印 " .
END.

PUT UNFORMATTED "LeftFooter" ";"  v_username +  "( 日期: " + string(YEAR(TODAY)) + "." + STRING(MONTH(TODAY)) + "." + STRING(DAY(TODAY)) + ", " + "时间: " + string(TIME,"HH:MM:SS") + " )" SKIP .
PUT UNFORMATTED "广州昭和汽车零部件有限公司"  SKIP. 
PUT UNFORMATTED "辅助帐余额表" SKIP.
PUT UNFORMATTED STRING(YEAR(effdate)) +  '年'   + STRING(MONTH(effdate) ) + '月' SKIP. 
PUT "  " SKIP.

/* 行标题 */  
IF v_curr = YES THEN DO:
   PUT UNFORMATTED "成本中心" ";" ";" "帐户" ";" ";" ";" "原币金额" ";" ";" "本位币金额" ";" SKIP.
   
   PUT UNFORMATTED "编号" ";" "名称" ";" "编号" ";" "名称" ";" "货币" ";" 
                   "借方" ";" "贷方" ";" "借方" ";" "贷方" SKIP.
   
   v_tot_dr_amt = 0.
   v_tot_cr_amt = 0.
   v_tot_dr_curramt = 0.
   v_tot_cr_curramt = 0.
   FOR EACH tt NO-LOCK BREAK BY tt_cc_ctr BY tt_ac_code BY tt_curr  :
       ACCUMULATE tt_dr_amt ( TOTAL BY tt_cc_ctr BY tt_ac_code BY tt_curr) .
       ACCUMULATE tt_cr_amt ( TOTAL BY tt_cc_ctr BY tt_ac_code BY tt_curr) .
       ACCUMULATE tt_dr_curramt ( TOTAL BY tt_cc_ctr  BY tt_ac_code BY tt_curr) .
       ACCUMULATE tt_cr_curramt ( TOTAL BY tt_cc_ctr  BY tt_ac_code BY tt_curr) .
       IF LAST-OF(tt_curr) THEN DO:
           PUT UNFORMATTED tt_cc_ctr ";" tt_cc_desc ";" tt_ac_code ";" tt_ac_desc ";" tt_curr ";" 
                               (ACCUMULATE TOTAL BY tt_curr tt_dr_curramt) ";"
                               (ACCUMULATE TOTAL BY tt_curr tt_cr_curramt) ";"
                               (ACCUMULATE TOTAL BY tt_curr tt_dr_amt) ";"
                               (ACCUMULATE TOTAL BY tt_curr tt_cr_amt) SKIP .
       END.
       v_tot_dr_amt = tt_dr_amt + v_tot_dr_amt .
       v_tot_cr_amt = tt_cr_amt + v_tot_cr_amt .
       v_tot_dr_curramt = tt_dr_curramt + v_tot_dr_curramt.
       v_tot_cr_curramt = tt_cr_curramt + v_tot_cr_curramt. 
   END.
   PUT UNFORMATTED ";" ";" ";" "合计" ";" ";" v_tot_dr_curramt ";" 
                   v_tot_cr_curramt ";" v_tot_dr_amt ";" v_tot_cr_amt SKIP .
END.
ELSE DO:
   PUT UNFORMATTED "成本中心" ";" ";" "帐户" ";" ";" ";" "本位币金额" ";" SKIP.

   PUT UNFORMATTED "编号" ";" "名称" ";" "编号" ";" "名称" ";" "货币" ";" 
                   "借方" ";" "贷方" SKIP.

   v_tot_dr_amt = 0.
   v_tot_cr_amt = 0.
   v_tot_dr_curramt = 0.
   v_tot_cr_curramt = 0.
   FOR EACH tt NO-LOCK BREAK BY tt_cc_ctr  BY tt_ac_code BY tt_curr :
       ACCUMULATE tt_dr_amt ( TOTAL BY tt_cc_ctr  BY tt_ac_code BY tt_curr) .
       ACCUMULATE tt_cr_amt ( TOTAL BY tt_cc_ctr  BY tt_ac_code BY tt_curr) .
       ACCUMULATE tt_dr_curramt ( TOTAL BY tt_cc_ctr  BY tt_ac_code BY tt_curr) .
       ACCUMULATE tt_cr_curramt ( TOTAL BY tt_cc_ctr  BY tt_ac_code BY tt_curr) .
       IF LAST-OF(tt_curr) THEN DO:
           PUT UNFORMATTED tt_cc_ctr ";" tt_cc_desc ";" tt_ac_code ";" tt_ac_desc ";" tt_curr ";" 
                               (ACCUMULATE TOTAL BY tt_curr tt_dr_amt) ";"
                               (ACCUMULATE TOTAL BY tt_curr tt_cr_amt) SKIP .
       END.
       v_tot_dr_amt = tt_dr_amt + v_tot_dr_amt .
       v_tot_cr_amt = tt_cr_amt + v_tot_cr_amt .
       v_tot_dr_curramt = tt_dr_curramt + v_tot_dr_curramt.
       v_tot_cr_curramt = tt_cr_curramt + v_tot_cr_curramt. 
   END.
   PUT UNFORMATTED ";" ";" ";" "合计" ";" ";" v_tot_dr_amt ";" v_tot_cr_amt SKIP .

END.

{a6mfrtrail.i}
