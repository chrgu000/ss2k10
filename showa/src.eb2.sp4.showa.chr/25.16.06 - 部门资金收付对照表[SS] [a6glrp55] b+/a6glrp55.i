/* REVISION: eb2sp4      LAST MODIFIED: 05/24/06   BY: *SS - Micho - 20060524* Micho Yang     */
DEF VAR v_flag AS LOGICAL INIT NO.
DEF VAR v_flag1 AS LOGICAL INIT YES .
DEF VAR v_acct1_desc LIKE CODE_cmmt.
DEF VAR v_cc_desc LIKE cc_desc .
DEF VAR v_acc LIKE gltr_acc .
DEF VAR v_acc1 LIKE gltr_acc .
DEF VAR v_effdate LIKE gltr_eff_dt .
DEF VAR vv_effdate LIKE gltr_eff_dt .
DEF VAR v_effdate1 LIKE gltr_eff_dt .
DEF VAR v_beg_amt LIKE gltr_amt .
DEF VAR v_username AS CHAR.
DEF VAR v_ctr_desc AS CHAR.
DEF VAR v_ctr_desc1 AS CHAR.
DEF VAR v_ac_beg_amt AS DECIMAL.
DEF VAR v_total_dr_amt AS DECIMAL.
DEF VAR v_total_cr_amt AS DECIMAL.
DEF VAR v_dr_amt AS DECIMAL.
DEF VAR v_cr_amt AS DECIMAL.

DEF VAR v_dispctr AS CHAR.
DEF VAR v_dispdate AS CHAR .

DEF TEMP-TABLE tt 
    FIELD tt_ctr LIKE gltr_ctr
    FIELD tt_acct1 LIKE glta_acct1
    FIELD tt_beg_amt LIKE gltr_amt
    FIELD tt_dr_amt LIKE gltr_amt
    FIELD tt_cr_amt LIKE gltr_amt 
    FIELD tt_y_dr_amt LIKE gltr_amt
    FIELD tt_y_cr_amt LIKE gltr_amt 
    INDEX ctr_acct1 tt_ctr tt_acct1 
    .

DEF TEMP-TABLE tt1 
    FIELD tt1_ctr LIKE gltr_ctr 
    FIELD tt1_acct1 LIKE glta_acct1
    FIELD tt1_amt   LIKE gltr_amt 
    INDEX ctr_acct1 tt1_ctr tt1_acct1 
    .


DEF BUFFER ttb FOR tt .
DEF BUFFER ttc FOR tt .

      IF acc = "" OR acc1 = ""  THEN DO:
         v_acc = '1001' .
         v_acc1 = '1009zzzz' .
      END.
      ELSE DO:
         v_acc = acc .
         v_acc1 = acc1 .
      END.
      
      /* 期初余额 */
      EMPTY TEMP-TABLE tt1.
      v_ac_beg_amt = 0.
      FOR EACH gltr_hist NO-LOCK WHERE gltr_eff_dt < effdate 
                                   AND gltr_acc >= v_acc 
                                   AND gltr_acc <= v_acc1
                                   AND gltr_sub >= sub
                                   AND gltr_sub <= sub1
                                   AND gltr_ctr >= ctr 
                                   AND gltr_ctr <= ctr1
                           AND (SUBSTRING(gltr_acc,1,4) = '1001' OR
                                SUBSTRING(gltr_acc,1,4) = '1002' OR
                                SUBSTRING(gltr_acc,1,4) = '1009' ) ,
          EACH glta_det NO-LOCK WHERE glta_ref = gltr_ref 
          AND glta_line = gltr_line ,
          EACH ac_mstr NO-LOCK WHERE ac_code = gltr_acc
                                   BREAK BY gltr_ctr BY glta_acct1 :
          if lookup(ac_type, "A,L") = 0 then do:
            IF gltr_eff_dt >= DATE(1,1,YEAR(effdate)) AND gltr_eff_dt < effdate THEN DO:
               v_ac_beg_amt = v_ac_beg_amt + gltr_amt .
          END.
          END.
          ELSE DO:
               v_ac_beg_amt = v_ac_beg_amt + gltr_amt .
          END.

          IF LAST-OF(glta_acct1)  THEN DO:
              CREATE tt1.
              ASSIGN
                  tt1_ctr = gltr_ctr
                  tt1_acct1 = glta_acct1
                  tt1_amt = v_ac_beg_amt
                  .
              v_ac_beg_amt = 0.
          END.     
      END.

      /*************************** 取得本期发生额 B **************************/
      EMPTY TEMP-TABLE tt.
      v_total_dr_amt = 0.
      v_total_cr_amt = 0.
      FOR EACH gltr_hist NO-LOCK WHERE gltr_entity >= entity 
                         AND gltr_entity <= entity1
                         AND gltr_eff_dt >= effdate
                         AND gltr_eff_dt <= effdate1
                         AND gltr_acc >= v_acc
                         AND gltr_acc <= v_acc1
                         AND (substring(gltr_acc,1,4) = '1001' OR
                             SUBSTRING(gltr_acc,1,4) = '1002' OR
                             SUBSTRING(gltr_acc,1,4) = '1009' ) 
                         AND gltr_sub >= sub
                         AND gltr_sub <= sub1
                         AND gltr_ctr >= ctr
                         AND gltr_ctr <= ctr1
                         AND gltr_ctr <> "" ,
          EACH glta_det NO-LOCK WHERE glta_ref = gltr_ref
          AND glta_line = gltr_line 
          AND glta_acct1 >= acct1
          AND glta_acct1 <= acct2 BREAK BY gltr_ctr BY glta_acct1 :

        v_dr_amt = 0.
        v_cr_amt = 0.
        IF (gltr_amt >= 0 AND gltr_correction = FALSE) OR
           (gltr_amt <  0 AND gltr_correction = TRUE ) THEN DO:
            v_dr_amt = gltr_amt .
            v_cr_amt = 0 .
        END.
        ELSE DO:
            v_cr_amt = - gltr_amt.
            v_dr_amt = 0.
        END.

        v_total_dr_amt = v_total_dr_amt + v_dr_amt .
        v_total_cr_amt = v_total_cr_amt + v_cr_amt .

        IF LAST-OF(glta_acct1) THEN DO:
            CREATE tt.
             ASSIGN
                 tt_ctr = gltr_ctr
                 tt_acct1 = glta_acct1 
                 tt_dr_amt = v_total_dr_amt
                 tt_cr_amt = v_total_cr_amt
                 .

           v_total_dr_amt = 0.
           v_total_cr_amt = 0.
        END. /* IF LAST-OF(gltr_ctr) THEN DO: */
      END.      
      /*************************** 取得本期发生额 E **************************/

      v_effdate = DATE(1,1,YEAR(effdate)) .
      FIND LAST glcd_det WHERE glcd_gl_clsd = NO NO-LOCK NO-ERROR.
      IF AVAIL glcd_det THEN DO:
                   IF glcd_per < 12 THEN v_effdate1 = DATE(glcd_per + 1 ,1 , glcd_year) - 1 .
                           ELSE v_effdate1 = DATE(1 ,1 , glcd_year + 1) - 1 .
      END.
      ELSE v_effdate1 = effdate1 . 
      /*************************** 取得本年累计发生额 B **************************/
      v_total_dr_amt = 0.
      v_total_cr_amt = 0.
      FOR EACH gltr_hist NO-LOCK WHERE gltr_entity >= entity 
                         AND gltr_entity <= entity1
                         AND gltr_eff_dt >= v_effdate
                         AND gltr_eff_dt <= v_effdate1
                         AND gltr_acc >= v_acc
                         AND gltr_acc <= v_acc1
                         AND (substring(gltr_acc,1,4) = '1001' OR
                             SUBSTRING(gltr_acc,1,4) = '1002' OR
                             SUBSTRING(gltr_acc,1,4) = '1009' ) 
                         AND gltr_sub >= sub
                         AND gltr_sub <= sub1
                         AND gltr_ctr >= ctr
                         AND gltr_ctr <= ctr1
                         AND gltr_ctr <> "" ,
          EACH glta_det NO-LOCK WHERE glta_ref = gltr_ref
          AND glta_line = gltr_line 
          AND glta_acct1 >= acct1
          AND glta_acct1 <= acct2 BREAK BY gltr_ctr BY glta_acct1 :

        v_dr_amt = 0.
        v_cr_amt = 0.
        IF (gltr_amt >= 0 AND gltr_correction = FALSE) OR
           (gltr_amt <  0 AND gltr_correction = TRUE ) THEN DO:
            v_dr_amt = gltr_amt .
            v_cr_amt = 0 .
        END.
        ELSE DO:
            v_cr_amt = - gltr_amt.
            v_dr_amt = 0.
        END.

        v_total_dr_amt = v_total_dr_amt + v_dr_amt .
        v_total_cr_amt = v_total_cr_amt + v_cr_amt .

        IF LAST-OF(glta_acct1) THEN DO:
            FIND FIRST tt WHERE tt_ctr = gltr_ctr
                AND tt_acct1 = glta_acct1 NO-LOCK NO-ERROR.
            IF AVAIL tt THEN DO:
                ASSIGN
                    tt_y_dr_amt = v_total_dr_amt 
                    tt_y_cr_amt = v_total_cr_amt
                    .
            END.
            ELSE DO:
                CREATE tt.
                ASSIGN
                 tt_ctr = gltr_ctr
                 tt_acct1 = glta_acct1 
                 tt_dr_amt = v_total_dr_amt
                 tt_cr_amt = v_total_cr_amt
                 .
            END.
           v_total_dr_amt = 0.
           v_total_cr_amt = 0.
        END. /* IF LAST-OF(gltr_ctr) THEN DO: */
      END.      
      /*************************** 取得本年累计发生额 E **************************/

      IF inclpost = YES THEN DO:

          /* 期初余额 */
          v_ac_beg_amt = 0.
          FOR EACH glt_det NO-LOCK WHERE glt_effdate < effdate 
                                       AND glt_acc >= v_acc 
                                       AND glt_acc <= v_acc1
                                       AND glt_sub >= sub
                                       AND glt_sub <= sub1
                                       AND glt_cc >= ctr 
                                       AND glt_cc <= ctr1
                                       AND glt_tr_type = "JL"
                               AND (SUBSTRING(glt_acc,1,4) = '1001' OR
                                    SUBSTRING(glt_acc,1,4) = '1002' OR
                                    SUBSTRING(glt_acc,1,4) = '1009' ) ,
              EACH glta_det NO-LOCK WHERE glta_ref = glt_ref 
              AND glta_line = glt_line ,
              EACH ac_mstr NO-LOCK WHERE ac_code = glt_acc
                                       BREAK BY glt_cc BY glta_acct1 :
              if lookup(ac_type, "A,L") = 0 then do:
                IF glt_effdate >= DATE(1,1,YEAR(effdate)) AND glt_effdate < effdate THEN DO:
                   v_ac_beg_amt = v_ac_beg_amt + glt_amt .
              END.
              END.
              ELSE DO:
                   v_ac_beg_amt = v_ac_beg_amt + glt_amt .
              END.
    
              IF LAST-OF(glta_acct1)  THEN DO:
                  CREATE tt1.
                  ASSIGN
                      tt1_ctr = glt_cc
                      tt1_acct1 = glta_acct1
                      tt1_amt = v_ac_beg_amt
                      .
                  v_ac_beg_amt = 0.
              END.     
          END.
    
          /*************************** 取得本期发生额 B **************************/
          v_total_dr_amt = 0.
          v_total_cr_amt = 0.
          FOR EACH glt_det NO-LOCK WHERE glt_entity >= entity 
                             AND glt_entity <= entity1
                             AND glt_effdate >= effdate
                             AND glt_effdate <= effdate1
                             AND glt_acc >= v_acc 
                             AND glt_acc <= v_acc1
                             AND glt_tr_type = "JL"
                             AND (substring(glt_acc,1,4) = '1001' OR
                                 SUBSTRING(glt_acc,1,4) = '1002' OR
                                 SUBSTRING(glt_acc,1,4) = '1009' ) 
                             AND glt_sub >= sub
                             AND glt_sub <= sub1
                             AND glt_cc >= ctr
                             AND glt_cc <= ctr1
                             AND glt_cc <> "" ,
              EACH glta_det NO-LOCK WHERE glta_ref = glt_ref
              AND glta_line = glt_line 
              AND glta_acct1 >= acct1
              AND glta_acct1 <= acct2 BREAK BY glt_cc BY glta_acct1 :
    
            v_dr_amt = 0.
            v_cr_amt = 0.
            IF (glt_amt >= 0 AND glt_correction = FALSE) OR
               (glt_amt <  0 AND glt_correction = TRUE ) THEN DO:
                v_dr_amt = glt_amt .
                v_cr_amt = 0 .
            END.
            ELSE DO:
                v_cr_amt = - glt_amt.
                v_dr_amt = 0.
            END.
    
            v_total_dr_amt = v_total_dr_amt + v_dr_amt .
            v_total_cr_amt = v_total_cr_amt + v_cr_amt .
    
            IF LAST-OF(glta_acct1) THEN DO:
                CREATE tt.
                 ASSIGN
                     tt_ctr = glt_cc
                     tt_acct1 = glta_acct1 
                     tt_dr_amt = v_total_dr_amt
                     tt_cr_amt = v_total_cr_amt
                     .
    
               v_total_dr_amt = 0.
               v_total_cr_amt = 0.
            END. /* IF LAST-OF(glt_cc) THEN DO: */
          END.      
          /*************************** 取得本期发生额 E **************************/
    
          v_effdate = DATE(1,1,YEAR(effdate)) .
          FIND LAST glcd_det WHERE glcd_gl_clsd = NO NO-LOCK NO-ERROR.
          IF AVAIL glcd_det THEN DO:
                       IF glcd_per < 12 THEN v_effdate1 = DATE(glcd_per + 1 ,1 , glcd_year) - 1 .
                               ELSE v_effdate1 = DATE(1 ,1 , glcd_year + 1) - 1 .
          END.
          ELSE v_effdate1 = effdate1 . 
          /*************************** 取得本年累计发生额 B **************************/
          v_total_dr_amt = 0.
          v_total_cr_amt = 0.
          FOR EACH glt_det NO-LOCK WHERE glt_entity >= entity 
                             AND glt_entity <= entity1
                             AND glt_effdate >= v_effdate
                             AND glt_effdate <= v_effdate1
                             AND glt_acc >= v_acc  
                             AND glt_acc <= v_acc1
                             AND glt_tr_type = "JL"
                             AND (substring(glt_acc,1,4) = '1001' OR
                                 SUBSTRING(glt_acc,1,4) = '1002' OR
                                 SUBSTRING(glt_acc,1,4) = '1009' ) 
                             AND glt_sub >= sub
                             AND glt_sub <= sub1
                             AND glt_cc >= ctr
                             AND glt_cc <= ctr1
                             AND glt_cc <> "" ,
              EACH glta_det NO-LOCK WHERE glta_ref = glt_ref
              AND glta_line = glt_line 
              AND glta_acct1 >= acct1
              AND glta_acct1 <= acct2 BREAK BY glt_cc BY glta_acct1 :
    
            v_dr_amt = 0.
            v_cr_amt = 0.
            IF (glt_amt >= 0 AND glt_correction = FALSE) OR
               (glt_amt <  0 AND glt_correction = TRUE ) THEN DO:
                v_dr_amt = glt_amt .
                v_cr_amt = 0 .
            END.
            ELSE DO:
                v_cr_amt = - glt_amt.
                v_dr_amt = 0.
            END.
    
            v_total_dr_amt = v_total_dr_amt + v_dr_amt .
            v_total_cr_amt = v_total_cr_amt + v_cr_amt .
    
            IF LAST-OF(glta_acct1) THEN DO:
                FIND FIRST tt WHERE tt_ctr = glt_cc
                    AND tt_acct1 = glta_acct1 NO-LOCK NO-ERROR.
                IF AVAIL tt THEN DO:
                    ASSIGN
                        tt_y_dr_amt = v_total_dr_amt 
                        tt_y_cr_amt = v_total_cr_amt
                        .
                END.
                ELSE DO:
                    CREATE tt.
                    ASSIGN
                     tt_ctr = glt_cc
                     tt_acct1 = glta_acct1 
                     tt_dr_amt = v_total_dr_amt
                     tt_cr_amt = v_total_cr_amt
                     .
                END.
               v_total_dr_amt = 0.
               v_total_cr_amt = 0.
            END. /* IF LAST-OF(glt_cc) THEN DO: */
          END.      
          /*************************** 取得本年累计发生额 E **************************/
      END.

      IF v_occur = NO THEN DO:
            FIND FIRST ttc NO-LOCK NO-ERROR.
            IF AVAIL ttc THEN DO:  
               FOR EACH ttb NO-LOCK BREAK BY ttb.tt_ctr :
                    IF LAST-OF(ttb.tt_ctr) THEN DO:
                         FOR EACH CODE_mstr WHERE CODE_fldname = 'glta_acct1' 
                                              AND CODE_value >= acct1 
                                              AND CODE_value <= acct2 
                                              NO-LOCK :
                             FIND FIRST tt WHERE tt.tt_acct1 = CODE_value 
                                             AND tt.tt_ctr = ttb.tt_ctr NO-LOCK NO-ERROR.
                             IF NOT AVAIL tt THEN DO:
                                 CREATE tt .
                                 ASSIGN
                                     tt.tt_ctr = ttb.tt_ctr 
                                     tt.tt_acct1 = CODE_value
                                     tt.tt_beg_amt = 0
                                     tt.tt_dr_amt = 0
                                     tt.tt_cr_amt = 0
                                     tt.tt_y_dr_amt = 0
                                     tt.tt_y_cr_amt = 0
                                     .
                             END.
                         END.
                    END.
                END.
            END.  /* IF AVAIL ttc THEN DO: */
            ELSE DO:
                 FOR EACH cc_mstr NO-LOCK WHERE cc_ctr >= ctr AND cc_ctr <= ctr1 BREAK BY cc_ctr :
                     IF LAST-OF(cc_ctr) THEN DO:
                         FOR EACH CODE_mstr WHERE CODE_fldname = 'glta_acct1' 
                                              AND CODE_value >= acct1 
                                              AND CODE_value <= acct2
                                              NO-LOCK :
                             CREATE tt .
                             ASSIGN 
                                 tt.tt_ctr = cc_ctr 
                                 tt.tt_acct1 = CODE_value
                                 tt.tt_beg_amt = 0
                                 tt.tt_dr_amt = 0
                                 tt.tt_cr_amt = 0
                                 tt.tt_y_dr_amt = 0
                                 tt.tt_y_cr_amt = 0
                                 .
                         END.
                     END.
                 END.
            END.  
      END. /* IF v_occur = NO THEN DO: */

v_dispctr = "".
IF ccflag = YES THEN DO:
    /*
PUT UNFORMATTED "ExecutionFile" ";" "txt2xls2.exe" SKIP.
PUT UNFORMATTED "ExcelFile" ";" "a6glrp0502" SKIP.
PUT UNFORMATTED "SaveFile" ";" "部门资金收付对照表" SKIP.
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
PUT UNFORMATTED "部门资金收付对照表" SKIP.
PUT UNFORMATTED STRING(YEAR(effdate)) +  '年'   + STRING(MONTH(effdate) ) + '月' SKIP. 
*/

v_dispctr = "".
IF ccflag = YES AND (ctr <> "" OR ctr1 <> "") THEN DO:

     FIND FIRST cc_mstr WHERE cc_ctr = ctr NO-LOCK NO-ERROR.
     IF AVAIL cc_mstr THEN v_ctr_desc = cc_desc .

     FIND FIRST cc_mstr WHERE cc_ctr = ctr1 NO-LOCK NO-ERROR.
     IF AVAIL cc_mstr THEN v_ctr_desc1 = cc_desc .

     v_dispctr = "成本中心范围: " + ctr + " - " + v_ctr_desc + " 至 " + ctr1 + " - " + v_ctr_desc1.
     /*
     PUT UNFORMATTED "成本中心范围: " + ctr + " - " + v_ctr_desc + " 至 " + ctr1 + " - " + v_ctr_desc1 SKIP. 
     */

END.
/*
ELSE DO:
     PUT "  " SKIP.
END.
  */

/*
PUT UNFORMATTED "资金项目" ";" ";" "期初余额" ";" ";" 
                "本期发生额" ";" ";" "本年累计发生额" ";" ";" 
                "期末余额" ";"  SKIP.

PUT UNFORMATTED "编号" ";" "名称" ";"
                "借方" ";" "贷方" ";" "借方" ";" "贷方" ";" 
                "借方" ";" "贷方" ";" "借方" ";" "贷方" SKIP.
  */

/* 输出到BI */
PUT UNFORMATTED "#def REPORTPATH=$/财务/BI报表/a6glrp551" SKIP.
PUT UNFORMATTED "#def :end" SKIP.

v_dispdate = "期间: 从" + STRING(YEAR(effdate),"9999") + "年" + 
            STRING(MONTH(effdate),"99") + "月" + STRING(DAY(effdate),"99") + "日" + 
            " 至 " +
            STRING(YEAR(effdate1),"9999") + "年" + 
            STRING(MONTH(effdate1),"99") + "月" + STRING(DAY(effdate1),"99") + "日".

   FOR EACH tt BREAK BY tt.tt_acct1 :
       ACCUMULATE tt.tt_dr_amt ( TOTAL BY tt.tt_acct1) .
       ACCUMULATE tt.tt_cr_amt ( TOTAL BY tt.tt_acct1) .
       ACCUMULATE tt.tt_y_dr_amt ( TOTAL BY tt.tt_acct1) .
       ACCUMULATE tt.tt_y_cr_amt ( TOTAL BY tt.tt_acct1) .
       IF LAST-OF(tt.tt_acct1) THEN DO:
           v_beg_amt = 0.
           FOR EACH tt1 WHERE tt1_acct1 = tt.tt_acct1 :
               v_beg_amt = v_beg_amt + tt1_amt .
           END.

           FIND FIRST CODE_mstr WHERE CODE_fldname = 'glta_acct1' 
                                  AND CODE_value = tt.tt_acct1 NO-LOCK NO-ERROR.
           IF AVAIL CODE_mstr THEN DO:
               v_acct1_desc = CODE_cmmt.
           END.
           ELSE v_acct1_desc = tt.tt_acct1 .

           PUT UNFORMATTED v_dispdate ";" v_dispctr ";" tt.tt_acct1 ";" 
                        v_acct1_desc ";" .
           IF v_beg_amt >= 0 THEN PUT UNFORMATTED v_beg_amt ";" ";" .
                             ELSE PUT UNFORMATTED ";" abs(v_beg_amt) ";" .
           PUT UNFORMATTED (ACCUMULATE TOTAL BY tt.tt_acct1 tt.tt_dr_amt ) ";"
                           (ACCUMULATE TOTAL BY tt.tt_acct1 tt.tt_cr_amt ) ";" 
                           (ACCUMULATE TOTAL BY tt.tt_acct1 tt.tt_y_dr_amt ) ";"
                           (ACCUMULATE TOTAL BY tt.tt_acct1 tt.tt_y_cr_amt ) ";" .

           IF v_beg_amt >= 0 THEN DO:
              IF (v_beg_amt + (ACCUMULATE TOTAL BY tt.tt_acct1 tt.tt_dr_amt ) - (ACCUMULATE TOTAL BY tt.tt_acct1 tt.tt_cr_amt )) >= 0 THEN DO:
                 PUT UNFORMATTED abs(v_beg_amt + (ACCUMULATE TOTAL BY tt.tt_acct1 tt.tt_dr_amt ) - (ACCUMULATE TOTAL BY tt.tt_acct1 tt.tt_cr_amt )) ";" SKIP .
              END.
              ELSE DO:
                 PUT UNFORMATTED ";" abs(v_beg_amt + (ACCUMULATE TOTAL BY tt.tt_acct1 tt.tt_dr_amt ) - (ACCUMULATE TOTAL BY tt.tt_acct1 tt.tt_cr_amt )) SKIP .
              END.
           END.
           ELSE DO: 
              IF (v_beg_amt + (ACCUMULATE TOTAL BY tt.tt_acct1 tt.tt_dr_amt ) - (ACCUMULATE TOTAL BY tt.tt_acct1 tt.tt_cr_amt )) >= 0 THEN DO:
                 PUT UNFORMATTED abs(v_beg_amt + (ACCUMULATE TOTAL BY tt.tt_acct1 tt.tt_dr_amt ) - (ACCUMULATE TOTAL BY tt.tt_acct1 tt.tt_cr_amt )) ";" SKIP .
              END.
              ELSE DO:
                 PUT UNFORMATTED ";" abs(v_beg_amt + (ACCUMULATE TOTAL BY tt.tt_acct1 tt.tt_dr_amt ) - (ACCUMULATE TOTAL BY tt.tt_acct1 tt.tt_cr_amt )) SKIP .
              END.
           END.
       END.
   END.
END.
ELSE DO:
    /*
PUT UNFORMATTED "ExecutionFile" ";" "txt2xls2.exe" SKIP.
PUT UNFORMATTED "ExcelFile" ";" "a6glrp0501" SKIP.
PUT UNFORMATTED "SaveFile" ";" "部门资金收付对照表" SKIP.
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
PUT UNFORMATTED "部门资金收付对照表" SKIP.
PUT UNFORMATTED STRING(YEAR(effdate)) +  '年'   + STRING(MONTH(effdate) ) + '月' SKIP. 
PUT "  " SKIP.
      
PUT UNFORMATTED "成本中心" ";" ";" "资金项目" ";" ";" "期初余额" ";" ";" 
                "本期发生额" ";" ";" "本年累计发生额" ";" ";" 
                "期末余额" ";"  SKIP.

PUT UNFORMATTED "编号" ";" "名称" ";" "编号" ";" "名称" ";"
                "借方" ";" "贷方" ";" "借方" ";" "贷方" ";" 
                "借方" ";" "贷方" ";" "借方" ";" "贷方" SKIP.
      */

/* 输出到BI */
PUT UNFORMATTED "#def REPORTPATH=$/财务/BI报表/a6glrp552" SKIP.
PUT UNFORMATTED "#def :end" SKIP.

v_dispdate = "期间: 从" + STRING(YEAR(effdate),"9999") + "年" + 
            STRING(MONTH(effdate),"99") + "月" + STRING(DAY(effdate),"99") + "日" + 
            " 至 " +
            STRING(YEAR(effdate1),"9999") + "年" + 
            STRING(MONTH(effdate1),"99") + "月" + STRING(DAY(effdate1),"99") + "日".

    v_beg_amt = 0 .
    FOR EACH tt  :
        FIND FIRST tt1 WHERE tt1_ctr = tt.tt_ctr
                         AND tt1_acct1 = tt.tt_acct1  NO-LOCK NO-ERROR.
        IF AVAIL tt1 THEN ASSIGN v_beg_amt = tt1_amt .
                     ELSE ASSIGN  v_beg_amt = 0 .
        FIND FIRST cc_mstr WHERE cc_ctr = tt.tt_ctr NO-LOCK NO-ERROR.
        IF AVAIL cc_mstr THEN v_cc_desc = cc_desc .
        FIND FIRST CODE_mstr WHERE CODE_fldname = 'glta_acct1' 
                               AND CODE_value = tt.tt_acct1 NO-LOCK NO-ERROR.
        IF AVAIL CODE_mstr THEN DO:
            v_acct1_desc = CODE_cmmt.
        END.
        ELSE v_acct1_desc = tt.tt_acct1 .

        PUT UNFORMATTED v_dispdate ";" tt.tt_ctr ";" v_cc_desc ";" string(tt.tt_acct1) ";" 
                        v_acct1_desc ";" .
        IF v_beg_amt >= 0 THEN PUT UNFORMATTED v_beg_amt ";" ";" .
                          ELSE PUT UNFORMATTED ";" abs(v_beg_amt) ";" .
        PUT UNFORMATTED tt.tt_dr_amt ";" tt.tt_cr_amt ";" 
                        tt.tt_y_dr_amt ";" tt.tt_y_cr_amt ";" .

        IF v_beg_amt >= 0 THEN DO:
           IF (v_beg_amt + tt.tt_dr_amt - tt.tt_cr_amt) >= 0 THEN DO:
              PUT UNFORMATTED v_beg_amt + tt.tt_dr_amt - tt.tt_cr_amt ";" SKIP .
           END.
           ELSE DO:
              PUT UNFORMATTED ";" abs(v_beg_amt + tt.tt_dr_amt - tt.tt_cr_amt)  SKIP .
           END.
        END.
        ELSE DO:
           IF (v_beg_amt + tt.tt_dr_amt - tt.tt_cr_amt) >= 0 THEN DO:
              PUT UNFORMATTED abs(v_beg_amt + tt.tt_dr_amt - tt.tt_cr_amt) ";" SKIP .
           END.
           ELSE DO:
              PUT UNFORMATTED ";" abs(v_beg_amt + tt.tt_dr_amt - tt.tt_cr_amt) SKIP .
           END.
        END.
            
    END.
END.

{a6mfrtrail.i}
                                                                                    
