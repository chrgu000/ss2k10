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

DEF TEMP-TABLE tt 
    FIELD tt_ctr LIKE gltr_ctr
    FIELD tt_acct1 LIKE glta_acct1
    FIELD tt_beg_amt LIKE gltr_amt
    FIELD tt_dr_amt LIKE gltr_amt
    FIELD tt_cr_amt LIKE gltr_amt 
    FIELD tt_y_dr_amt LIKE gltr_amt
    FIELD tt_Y_cr_amt LIKE gltr_amt 
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

      FOR EACH tta6glacstrp02:
         DELETE tta6glacstrp02.
      END.
      
      vv_effdate = DATE(MONTH(effdate),1,YEAR(effdate)) .

      {gprun.i ""a6glacstrp02.p"" "(
         input entity,
         input entity1,
         input v_acc ,
         input v_acc1 ,
         input vv_effdate,
         input effdate1,
         input v_flag,
         input v_flag,
         input v_flag,
         input v_flag1,
         input v_flag1,
         input v_flag,
         input v_flag,
         input v_flag
         )"}

      FOR EACH tt1 :
          DELETE tt1.
      END.

      FOR EACH gltr_hist NO-LOCK WHERE gltr_eff_dt < effdate 
                                   AND gltr_acc >= acc 
                                   AND gltr_acc <= acc1
                                   AND gltr_sub >= sub
                                   AND gltr_sub <= sub1
                                   AND gltr_ctr >= ctr 
                                   AND gltr_ctr <= ctr1 
                           AND (SUBSTRING(gltr_acc,1,4) = '1001' OR
                                SUBSTRING(gltr_acc,1,4) = '1002' OR
                                SUBSTRING(gltr_acc,1,4) = '1009' ) ,
          EACH glta_det NO-LOCK WHERE glta_ref = gltr_ref 
                          AND glta_line = gltr_line 
                          BREAK BY gltr_ctr BY glta_acct1 :
          ACCUMULATE gltr_amt ( TOTAL BY gltr_ctr BY glta_acct1) .
          IF LAST-OF(glta_acct1) THEN DO:
              CREATE tt1.
              ASSIGN
                  tt1_ctr = gltr_ctr 
                  tt1_acct1 = glta_acct1 
                  tt1_amt   = (ACCUMULATE TOTAL BY glta_acct1 gltr_amt )
                  .
          END.

      END.

      /*
      PUT "tt1" SKIP.
      FOR EACH tt1:
          EXPORT DELIMITER ";" tt1 .
      END.
        */

      FOR EACH tt :
          DELETE tt.
      END.

      FOR EACH tta6glacstrp02 WHERE (substring(tta6glacstrp02_acc,1,4) = '1001' 
                                 OR substring(tta6glacstrp02_acc,1,4)  = '1002' 
                                 OR substring(tta6glacstrp02_acc,1,4)  = '1009')
                                AND tta6glacstrp02_sub >= sub 
                                AND tta6glacstrp02_sub <= sub1
                                AND tta6glacstrp02_ctr >= ctr
                                AND tta6glacstrp02_ctr <= ctr1 
                                AND tta6glacstrp02_eff_dt >= effdate 
                                AND tta6glacstrp02_eff_dt <= effdate1
                                AND tta6glacstrp02_ctr <> "" ,
          EACH glta_det WHERE glta_ref = tta6glacstrp02_ref 
                          AND glta_line = tta6glacstrp02_line
                          AND (glta_acct1 >= acct1 AND
                               glta_acct1 <= acct2 )
                               NO-LOCK BREAK BY tta6glacstrp02_ctr 
                                             BY glta_acct1 :
          ACCUMULATE tta6glacstrp02_dr_amt ( TOTAL BY tta6glacstrp02_ctr BY glta_acct1) .
          ACCUMULATE tta6glacstrp02_cr_amt (TOTAL BY tta6glacstrp02_ctr BY glta_acct1) .
          IF LAST-OF(glta_acct1) THEN DO:
             CREATE tt.
             ASSIGN
                 tt_ctr = tta6glacstrp02_ctr
                 tt_acct1 = glta_acct1 
                 tt_dr_amt = (ACCUMULATE TOTAL BY glta_acct1 tta6glacstrp02_dr_amt)
                 tt_cr_amt = (ACCUMULATE TOTAL BY glta_acct1 tta6glacstrp02_cr_amt)
                 .
          END.
      END.

      v_effdate = DATE(1,1,YEAR(effdate)) .
      FIND LAST glcd_det WHERE glcd_gl_clsd = NO NO-LOCK NO-ERROR.
      IF AVAIL glcd_det THEN DO:
                   IF glcd_per < 12 THEN v_effdate1 = DATE(glcd_per + 1 ,1 , glcd_year) - 1 .
                           ELSE v_effdate1 = DATE(1 ,1 , glcd_year + 1) - 1 .
      END.
      ELSE v_effdate1 = effdate1 . 

      FOR EACH tta6glacstrp02:
         DELETE tta6glacstrp02.
      END.
     
      {gprun.i ""a6glacstrp02.p"" "(
         input entity,
         input entity1,
         input v_acc ,
         input v_acc1 ,
         input v_effdate,
         input v_effdate1,
         input v_flag,
         input v_flag,
         input v_flag,
         input v_flag1,
         input v_flag1,
         input v_flag,
         input v_flag,
         input v_flag
         )"}
      /*
      FOR EACH tta6glacstrp02 :
          MESSAGE "c" VIEW-AS ALERT-BOX.
          EXPORT DELIMITER ";" tta6glacstrp02 .
      END.
      */
          
      FOR EACH tta6glacstrp02 WHERE tta6glacstrp02_sub >= sub 
                                 AND tta6glacstrp02_sub <= sub1
                                 AND tta6glacstrp02_ctr >= ctr
                                 AND tta6glacstrp02_ctr <= ctr1
                                 AND (substring(tta6glacstrp02_acc,1,4) = '1001' 
                                 OR substring(tta6glacstrp02_acc,1,4)  = '1002' 
                                 OR substring(tta6glacstrp02_acc,1,4)  = '1009')
                                 AND tta6glacstrp02_ctr <> "" ,
          EACH glta_det WHERE glta_ref = tta6glacstrp02_ref 
                          AND glta_line = tta6glacstrp02_line
                          AND (glta_acct1 >= acct1 AND
                               glta_acct1 <= acct2 )
                               NO-LOCK BREAK BY tta6glacstrp02_ctr 
                                             BY glta_acct1 :
          
          ACCUMULATE tta6glacstrp02_dr_amt ( TOTAL BY tta6glacstrp02_ctr BY glta_acct1) .
          ACCUMULATE tta6glacstrp02_cr_amt (TOTAL BY tta6glacstrp02_ctr BY glta_acct1) .
          IF LAST-OF(glta_acct1) THEN DO:
              
             FIND FIRST tt WHERE tt_ctr = tta6glacstrp02_ctr 
                             AND tt_acct1 = glta_acct1 NO-LOCK NO-ERROR.
             IF AVAIL tt THEN DO:

                 ASSIGN 
                     tt_y_dr_amt = (ACCUMULATE TOTAL BY glta_acct1 tta6glacstrp02_dr_amt)
                     tt_y_cr_amt = (ACCUMULATE TOTAL BY glta_acct1 tta6glacstrp02_cr_amt)
                     .
             END.
          END.
      END.

      /*
      PUT "tt" SKIP.
      FOR EACH tt:
          EXPORT DELIMITER ";" tt .
      END.
        */

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

IF ccflag = YES THEN DO:
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
IF ccflag = YES AND (ctr <> "" OR ctr1 <> "") THEN DO:
     FIND FIRST cc_mstr WHERE cc_ctr = ctr NO-LOCK NO-ERROR.
     IF AVAIL cc_mstr THEN v_ctr_desc = cc_desc .

     FIND FIRST cc_mstr WHERE cc_ctr = ctr1 NO-LOCK NO-ERROR.
     IF AVAIL cc_mstr THEN v_ctr_desc1 = cc_desc .

     PUT UNFORMATTED "成本中心范围: " + ctr + " - " + v_ctr_desc + " 至 " + ctr1 + " - " + v_ctr_desc1 SKIP. 
END.
ELSE DO:
     PUT "  " SKIP.
END.

PUT UNFORMATTED "资金项目" ";" ";" "期初余额" ";" ";" 
                "本期发生额" ";" ";" "本年累计发生额" ";" ";" 
                "期末余额" ";"  SKIP.

PUT UNFORMATTED "编号" ";" "名称" ";"
                "借方" ";" "贷方" ";" "借方" ";" "贷方" ";" 
                "借方" ";" "贷方" ";" "借方" ";" "贷方" SKIP.

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

           PUT UNFORMATTED tt.tt_acct1 ";" 
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

        PUT UNFORMATTED tt.tt_ctr ";" v_cc_desc ";" string(tt.tt_acct1) ";" 
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
                                                                                    
