/* REVISION: eb2sp4      LAST MODIFIED: 05/24/06   BY: *SS - Micho - 20060524* Micho Yang     */

DEF VAR v_dr_amt AS DECIMAL.
DEF VAR v_cr_amt AS DECIMAL.
DEF VAR v_ac_code AS CHAR.
DEF VAR v_sb_sub AS CHAR.
DEF VAR v_cc_ctr AS CHAR.
DEF VAR v_ac_desc LIKE ac_desc .
DEF VAR v_sb_desc LIKE sb_desc .
DEF VAR v_cc_desc LIKE cc_desc .
DEF VAR v_effdate AS DATE.
DEF VAR v_effdate1 AS DATE .
DEF VAR v_flag AS LOGICAL INIT NO.
DEF VAR v_flag1 AS LOGICAL INIT YES .
DEF VAR v_beg_amt AS DECIMAL.
DEF VAR v_beg_curramt AS DECIMAL.
DEF VAR v_curr_desc AS CHAR.
DEF VAR v_curr_desc1 AS CHAR.
DEF VAR v_username AS CHAR.

DEF TEMP-TABLE tt 
    FIELD tt_acc LIKE gltr_acc
    FIELD tt_ac_desc LIKE ac_desc
    FIELD tt_ref LIKE gltr_ref
    FIELD tt_line LIKE gltr_line
    FIELD tt_sub LIKE gltr_sub
    FIELD tt_sb_desc LIKE sb_desc
    FIELD tt_ctr LIKE gltr_ctr
    FIELD tt_cc_desc LIKE cc_desc 
    FIELD tt_curr LIKE gltr_curr
    FIELD tt_beg_amt AS DECIMAL
    FIELD tt_dr_amt AS DECIMAL
    FIELD tt_cr_amt AS DECIMAL
    FIELD tt_curr_dr_amt AS DECIMAL
    FIELD tt_curr_cr_amt AS DECIMAL
    FIELD tt_y_dr_amt AS DECIMAL
    FIELD tt_y_cr_amt AS DECIMAL
    FIELD tt_y_curr_dr_amt AS DECIMAL
    FIELD tt_y_curr_cr_amt AS DECIMAL
    .

DEF TEMP-TABLE tt1 
    FIELD tt1_acc LIKE gltr_acc
    FIELD tt1_sub LIKE gltr_sub
    FIELD tt1_ctr LIKE gltr_ctr
    FIELD tt1_amt AS DECIMAL
    FIELD tt1_curramt AS DECIMAL
    INDEX acc_sub tt1_acc tt1_sub tt1_ctr 
    .

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
                                   BREAK BY gltr_acc BY gltr_sub BY gltr_ctr :
          ACCUMULATE gltr_amt ( TOTAL BY gltr_acc BY gltr_sub BY gltr_ctr ) .
          ACCUMULATE gltr_curramt ( TOTAL BY gltr_acc BY gltr_sub BY gltr_ctr ) .
          IF LAST-OF(gltr_ctr) THEN DO:
              CREATE tt1.
              ASSIGN
                  tt1_acc = gltr_acc
                  tt1_sub = gltr_sub
                  tt1_ctr = gltr_ctr
                  tt1_amt = (ACCUMULATE TOTAL BY gltr_ctr gltr_amt)
                  tt1_curramt = (ACCUMULATE TOTAL BY gltr_ctr gltr_curramt)
                  .
          END.     
      END.

      FOR EACH tta6glacstrp02:
         DELETE tta6glacstrp02.
      END.
     
      {gprun.i ""a6glacstrp02.p"" "(
         input entity,
         input entity1,
         INPUT acc ,
         input acc1 ,
         input effdate,
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

      FOR EACH tt :
          DELETE tt.
      END.

      v_dr_amt = 0.
      v_cr_amt = 0.
      FOR EACH tta6glacstrp02 WHERE tta6glacstrp02_ref <> ""
                                AND tta6glacstrp02_sub >= sub 
                                AND tta6glacstrp02_sub <= sub1
                                AND tta6glacstrp02_ctr >= ctr
                                AND tta6glacstrp02_ctr <= ctr1 
                                BREAK BY tta6glacstrp02_acc 
                                      BY tta6glacstrp02_sub
                                      BY tta6glacstrp02_ctr  :

          IF ( ABS(tta6glacstrp02_dr_amt) > 0 AND tta6glacstrp02_dr_amt > 0 ) THEN v_dr_amt = v_dr_amt + ABS(tta6glacstrp02_curramt) .
          IF ( ABS(tta6glacstrp02_dr_amt) > 0 AND tta6glacstrp02_dr_amt < 0 ) THEN v_dr_amt = v_dr_amt + (- ABS(tta6glacstrp02_curramt)) .
          IF ( ABS(tta6glacstrp02_cr_amt) > 0 AND tta6glacstrp02_cr_amt > 0 ) THEN v_cr_amt = v_cr_amt + ABS(tta6glacstrp02_curramt) .
          IF ( ABS(tta6glacstrp02_cr_amt) > 0 AND tta6glacstrp02_cr_amt < 0 ) THEN v_cr_amt = v_cr_amt + (- ABS(tta6glacstrp02_curramt)) .

          ACCUMULATE tta6glacstrp02_dr_amt ( TOTAL BY tta6glacstrp02_acc BY tta6glacstrp02_sub BY tta6glacstrp02_ctr ).
          ACCUMULATE tta6glacstrp02_cr_amt ( TOTAL BY tta6glacstrp02_acc BY tta6glacstrp02_sub BY tta6glacstrp02_ctr ).

          v_ac_desc = "" .
          v_curr_desc = "" .
          v_sb_desc = "" .
          v_cc_desc = "" .
          IF LAST-OF(tta6glacstrp02_ctr) THEN DO:
              FIND FIRST ac_mstr WHERE ac_code = tta6glacstrp02_acc NO-LOCK NO-ERROR.
              IF AVAIL ac_mstr AND ac_code <> "" THEN do:
                  v_ac_desc = ac_desc .
                  v_curr_desc = ac_curr .
              END.
              FIND FIRST sb_mstr WHERE sb_sub = tta6glacstrp02_sub NO-LOCK NO-ERROR.
              IF AVAIL sb_mstr AND sb_sub <> "" THEN DO:
                  v_sb_desc = sb_desc .
              END.
              FIND FIRST cc_mstr WHERE cc_ctr = tta6glacstrp02_ctr NO-LOCK NO-ERROR.
              IF AVAIL cc_mstr AND cc_ctr <> "" THEN DO:
                  v_cc_desc = cc_desc.
              END.

              CREATE tt.
              ASSIGN
                  tt_acc = tta6glacstrp02_acc
                  tt_ac_desc = v_ac_desc
                  tt_ref = tta6glacstrp02_ref
                  tt_line = tta6glacstrp02_line
                  tt_sub = tta6glacstrp02_sub
                  tt_sb_desc = v_sb_desc
                  tt_ctr = tta6glacstrp02_ctr
                  tt_cc_desc = v_cc_desc 
                  tt_curr = v_curr_desc
                  tt_beg_amt = tta6glacstrp02_beg_amt
                  tt_dr_amt = (ACCUMULATE TOTAL BY tta6glacstrp02_ctr  tta6glacstrp02_dr_amt )
                  tt_cr_amt = (ACCUMULATE TOTAL BY tta6glacstrp02_ctr  tta6glacstrp02_cr_amt )
                  tt_curr_dr_amt = v_dr_amt
                  tt_curr_cr_amt = v_cr_amt 
                  .
              v_cr_amt = 0.
              v_dr_amt = 0 .
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
         INPUT acc ,
         input acc1 ,
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
       
      v_dr_amt = 0.
      v_cr_amt = 0.

      FOR EACH tta6glacstrp02 WHERE tta6glacstrp02_sub >= sub 
                                AND tta6glacstrp02_sub <= sub1
                                AND tta6glacstrp02_ctr >= ctr
                                AND tta6glacstrp02_ctr <= ctr1 
                                BREAK BY tta6glacstrp02_acc 
                                      BY tta6glacstrp02_sub
                                      BY tta6glacstrp02_ctr :
          IF ( ABS(tta6glacstrp02_dr_amt) > 0 AND tta6glacstrp02_dr_amt > 0 ) THEN v_dr_amt = v_dr_amt + ABS(tta6glacstrp02_curramt) .
          IF ( ABS(tta6glacstrp02_dr_amt) > 0 AND tta6glacstrp02_dr_amt < 0 ) THEN v_dr_amt = v_dr_amt + (- ABS(tta6glacstrp02_curramt)) .
          IF ( ABS(tta6glacstrp02_cr_amt) > 0 AND tta6glacstrp02_cr_amt > 0 ) THEN v_cr_amt = v_cr_amt + ABS(tta6glacstrp02_curramt) .
          IF ( ABS(tta6glacstrp02_cr_amt) > 0 AND tta6glacstrp02_cr_amt < 0 ) THEN v_cr_amt = v_cr_amt + (- ABS(tta6glacstrp02_curramt)) .

          ACCUMULATE tta6glacstrp02_dr_amt ( TOTAL BY tta6glacstrp02_acc BY tta6glacstrp02_sub BY tta6glacstrp02_ctr  ).
          ACCUMULATE tta6glacstrp02_cr_amt ( TOTAL BY tta6glacstrp02_acc BY tta6glacstrp02_sub BY tta6glacstrp02_ctr  ).
          IF LAST-OF(tta6glacstrp02_ctr) THEN DO:
              FIND FIRST tt WHERE tt_acc = tta6glacstrp02_acc 
                              AND tt_sub = tta6glacstrp02_sub
                              AND tt_ctr = tta6glacstrp02_ctr NO-LOCK NO-ERROR.
              IF AVAIL tt THEN DO:
                  ASSIGN
                      tt_y_dr_amt = (ACCUMULATE TOTAL BY tta6glacstrp02_ctr  tta6glacstrp02_dr_amt )
                      tt_y_cr_amt = (ACCUMULATE TOTAL BY tta6glacstrp02_ctr  tta6glacstrp02_cr_amt )
                      tt_y_curr_dr_amt = v_dr_amt
                      tt_y_curr_cr_amt = v_cr_amt 
                      .
              END.
              v_dr_amt = 0.
              v_cr_amt = 0.
          END.
      END.                                   

      /* 是否只输出有发生额的科目 */
      IF v_occur = NO THEN DO:
         v_ac_code = "" .
         v_ac_desc = "" .
         v_curr_desc = "" .
         v_sb_sub = "" .
         v_sb_desc = "" .
         v_cc_ctr = "" .
         v_cc_desc = "" .
         FOR EACH ASC_mstr WHERE ASC_acc >= acc AND ASC_acc <= acc1 
                            AND ASC_sub >= sub AND ASC_sub <= sub1
                            AND ASC_cc  >= ctr AND ASC_cc  <= ctr1
                            NO-LOCK :
             FIND FIRST tt WHERE tt_acc = ASC_acc 
                             AND tt_sub = ASC_sub
                             AND tt_ctr = ASC_cc NO-LOCK NO-ERROR.
             IF NOT AVAIL tt THEN DO:
                  FIND FIRST ac_mstr WHERE ac_code = asc_acc NO-LOCK NO-ERROR.
                  IF AVAIL ac_mstr AND ac_code <> "" THEN do:
                      v_ac_code = ac_code .
                      v_ac_desc = ac_desc .
                      v_curr_desc = ac_curr .
                  END.
                  FIND FIRST sb_mstr WHERE sb_sub = asc_sub NO-LOCK NO-ERROR.
                  IF AVAIL sb_mstr AND sb_sub <> "" THEN DO:
                      v_sb_sub = sb_sub .
                      v_sb_desc = sb_desc .
                  END.
                  FIND FIRST cc_mstr WHERE cc_ctr = asc_cc NO-LOCK NO-ERROR.
                  IF AVAIL cc_mstr AND cc_ctr <> "" THEN DO:
                      v_cc_ctr = cc_ctr .
                      v_cc_desc = cc_desc.
                  END.

                  CREATE tt .
                  ASSIGN
                      tt_acc = v_ac_code 
                      tt_ac_desc = v_ac_desc 
                      tt_sub = v_sb_sub
                      tt_sb_desc = v_sb_desc
                      tt_ctr = v_cc_ctr
                      tt_cc_desc = v_cc_desc 
                      tt_curr = v_curr_desc 
                      .
                  v_ac_code = "" .
                  v_ac_desc = "" .
                  v_curr_desc = "" .
                  v_sb_sub = "" .
                  v_sb_desc = "" .
                  v_cc_ctr = "" .
                  v_cc_desc = "" .
             END.
         END.
      END.

      /*
      PUT "tt table : " SKIP.
      FOR EACH tt :
          EXPORT DELIMITER ";" tt .
      END.

      PUT SKIP(2) .
      PUT "tt1 table : " SKIP.
      FOR EACH tt1 :
          EXPORT DELIMITER ";" tt1 .
      END.  */

PUT UNFORMATTED "ExecutionFile" ";" "txt2xls2.exe" SKIP.
PUT UNFORMATTED "ExcelFile" ";" "a6glrp02" SKIP.
PUT UNFORMATTED "SaveFile" ";" "明细科目发生额对照表" SKIP.
PUT UNFORMATTED "PrintPreview" ";" "no" SKIP.
PUT UNFORMATTED "ActiveSheet" ";" "1" SKIP.
PUT UNFORMATTED "Format" ";" "no" SKIP.
/*
PUT UNFORMATTED "xlHAlignCenterAcrossSelection" ";" "1" SKIP.
*/
IF v_curr = YES THEN v_curr_desc1 = "原币" .
                ELSE v_curr_desc1 = "本位币" .

FIND FIRST usr_mstr WHERE usr_userid = global_userid NO-LOCK NO-ERROR.
IF AVAIL USr_mstr THEN DO:
       v_username = "由 " + usr_name + " 打印 " .
END.

PUT UNFORMATTED "LeftFooter" ";"  v_username +  "( 日期: " + string(YEAR(TODAY)) + "." + STRING(MONTH(TODAY)) + "." + STRING(DAY(TODAY)) + ", " + "时间: " + string(TIME,"HH:MM:SS") + " )" SKIP .
PUT UNFORMATTED "广州昭和汽车零部件有限公司"  SKIP. 
PUT UNFORMATTED "明细科目发生额对照表" + "(" + v_curr_desc1 + ")" SKIP.
PUT UNFORMATTED STRING(YEAR(effdate)) +  '年'   + STRING(MONTH(effdate) ) + '月' SKIP. 
PUT "  " SKIP.

/*
   PUT UNFORMATTED "TextColumn".
   i = 0.
   REPEAT:
      i = i + 1.
      PUT UNFORMATTED ";" STRING .
      IF i = 10 THEN DO:
         LEAVE.
      END.
   END.
   i = 19.
   REPEAT:
      i = i + 1.
      PUT UNFORMATTED ";" STRING .
      IF i = 23 THEN DO:
         LEAVE.
      END.
   END.
   PUT SKIP.
   */

IF subflag = NO AND ccflag = NO THEN DO:
    IF v_curr = YES THEN DO:
       PUT UNFORMATTED  "帐户" ";" ";" "分帐户" ";"  ";"
                       "成本中心" ";"  ";" "货币" ";"
                       "期初余额(原币)" ";" ";" "期初余额(本币)" ";" ";"
                       "本期发生额(原币)" ";" ";" "本期发生额(本币)" ";" ";"
                       "本年累计发生额(原币)" ";" ";" "本年累计发生额(本币)" ";" ";"
                       "期末余额(原币)" ";" ";" "期末余额(本币)" ";" SKIP.
       
       PUT UNFORMATTED "编号" ";" "名称" ";" "编号" ";" "名称" ";"
                       "编号" ";" "名称" ";" ";"
                       "借方" ";" "贷方" ";" "借方" ";" "贷方" ";" 
                       "借方" ";" "贷方" ";" "借方" ";" "贷方" ";" 
                       "借方" ";" "贷方" ";" "借方" ";" "贷方" ";" 
                       "借方" ";" "贷方" ";" "借方" ";" "贷方" SKIP.
    END.
    ELSE DO:
       PUT UNFORMATTED  "帐户" ";" ";" "分帐户" ";"  ";"
                       "成本中心" ";"  ";" "货币" ";"
                       "期初余额(本币)" ";" ";"
                       "本期发生额(本币)" ";" ";"
                       "本年累计发生额(本币)" ";" ";"
                       "期末余额(本币)" ";" SKIP.
       
       PUT UNFORMATTED "编号" ";" "名称" ";" "编号" ";" "名称" ";"
                       "编号" ";" "名称" ";" ";"
                       "借方" ";" "贷方" ";"  
                       "借方" ";" "贷方" ";"  
                       "借方" ";" "贷方" ";"  
                       "借方" ";" "贷方" SKIP.
    END.
   
   v_beg_amt = 0.
   v_beg_curramt = 0.
   FOR EACH tt :
       /*
       IF tt_acc = '1002082' THEN MESSAGE tt_sub + " - " + tt_ctr VIEW-AS ALERT-BOX.
       */

       FIND FIRST tt1 WHERE tt1_acc = tt_acc AND tt1_sub = tt_sub 
                        AND tt1_ctr = tt_ctr NO-LOCK NO-ERROR.
       IF AVAIL tt1 THEN DO:
           v_beg_amt = tt1_amt .
           v_beg_curramt = tt1_curramt .
       END.
       PUT UNFORMATTED "'" + tt_acc ";" tt_ac_desc ";" "'" + tt_sub ";" tt_sb_desc ";" "'" + tt_ctr ";"
                       tt_cc_desc ";" .
       PUT UNFORMATTED tt_curr ";" .

       IF v_curr = YES THEN DO:
          IF v_beg_curramt >= 0 THEN PUT UNFORMATTED v_beg_curramt ";" ";" .
                                ELSE PUT UNFORMATTED ";" ABS(v_beg_curramt) ";" .
          IF v_beg_amt >= 0 THEN PUT UNFORMATTED v_beg_amt ";" ";" .
                            ELSE PUT UNFORMATTED ";" ABS(v_beg_amt) ";" .
          PUT UNFORMATTED tt_curr_dr_amt ";" tt_curr_cr_amt ";" 
                          tt_dr_amt ";" tt_cr_amt ";"
                          tt_y_curr_dr_amt ";" tt_y_curr_cr_amt ";" 
                          tt_y_dr_amt ";" tt_y_cr_amt ";" 
                          .
          IF v_beg_curramt >= 0 THEN DO:
             IF (v_beg_curramt + tt_curr_dr_amt - tt_curr_cr_amt) >= 0 THEN DO:
                 PUT UNFORMATTED ABS(v_beg_curramt + tt_curr_dr_amt - tt_curr_cr_amt) ";" ";".
             END.
             ELSE DO:
                 PUT UNFORMATTED ";" ABS(v_beg_curramt + tt_curr_dr_amt - tt_curr_cr_amt) ";".
             END.
          END.                       
          ELSE DO:
             IF (v_beg_curramt + tt_curr_dr_amt - tt_curr_cr_amt ) >= 0 THEN DO:
                PUT UNFORMATTED ABS(v_beg_curramt + tt_curr_dr_amt - tt_curr_cr_amt ) ";" ";" .
             END.
             ELSE DO:
                PUT UNFORMATTED ";" ABS(v_beg_curramt + tt_curr_dr_amt - tt_curr_cr_amt ) ";" .
             END.
          END.     

          IF v_beg_amt >= 0 THEN DO:
             IF (v_beg_amt + tt_dr_amt - tt_cr_amt) >= 0 THEN DO:
                 PUT UNFORMATTED (v_beg_amt + tt_dr_amt - tt_cr_amt) ";" SKIP.
             END.
             ELSE DO:
                 PUT UNFORMATTED ";" ABS(v_beg_amt + tt_dr_amt - tt_cr_amt) SKIP.
             END.
          END.     
          ELSE DO:
             IF (v_beg_amt + tt_dr_amt - tt_cr_amt ) >= 0 THEN DO:
                PUT UNFORMATTED ABS(v_beg_amt + tt_dr_amt - tt_cr_amt ) ";" SKIP.
             END.
             ELSE DO:
                PUT UNFORMATTED ";" ABS(v_beg_amt + tt_dr_amt - tt_cr_amt ) SKIP.
             END.
          END.
                   
       END.
       ELSE DO:
          IF v_beg_amt >= 0 THEN PUT UNFORMATTED v_beg_amt ";" ";" .
                                ELSE PUT UNFORMATTED ";" ABS(v_beg_amt) ";" .
          PUT UNFORMATTED tt_dr_amt ";" tt_cr_amt ";" 
                          tt_y_dr_amt ";" tt_y_cr_amt ";" 
                          .
          IF v_beg_amt >= 0 THEN DO:
             IF (v_beg_amt + tt_dr_amt - tt_cr_amt) >= 0 THEN DO:
                 PUT UNFORMATTED (v_beg_amt + tt_dr_amt - tt_cr_amt) ";" SKIP.
             END.
             ELSE DO:
                 PUT UNFORMATTED ";" ABS(v_beg_amt + tt_dr_amt - tt_cr_amt) SKIP.
             END.
          END.     
          ELSE DO:
             IF (v_beg_amt + tt_dr_amt - tt_cr_amt ) >= 0 THEN DO:
                PUT UNFORMATTED ABS(v_beg_amt + tt_dr_amt - tt_cr_amt ) ";" SKIP.
             END.
             ELSE DO:
                PUT UNFORMATTED ";" ABS(v_beg_amt + tt_dr_amt - tt_cr_amt ) SKIP.
             END.
          END.

       END.
       v_beg_amt = 0.
       v_beg_curramt = 0.
   END.
END.

IF subflag = YES AND ccflag = NO THEN DO:
    IF v_curr = YES THEN DO:
       PUT UNFORMATTED  "帐户" ";" ";" 
                       "成本中心" ";"  ";" "货币" ";"
                       "期初余额(原币)" ";" ";" "期初余额(本币)" ";" ";"
                       "本期发生额(原币)" ";" ";" "本期发生额(本币)" ";" ";"
                       "本年累计发生额(原币)" ";" ";"  "本年累计发生额(本币)" ";" ";"
                       "期末余额(原币)" ";" ";" "期末余额(本币)" ";" SKIP.
       
       PUT UNFORMATTED "编号" ";" "名称" ";" 
                       "编号" ";" "名称" ";" ";"
                       "借方" ";" "贷方" ";" "借方" ";" "贷方" ";"
                       "借方" ";" "贷方" ";" "借方" ";" "贷方" ";" 
                       "借方" ";" "贷方" ";" "借方" ";" "贷方" ";" 
                       "借方" ";" "贷方" ";" "借方" ";" "贷方" SKIP.
    END.
    ELSE DO:
       PUT UNFORMATTED  "帐户" ";" ";" 
                       "成本中心" ";"  ";" "货币" ";"
                       "期初余额(本币)" ";" ";"
                       "本期发生额(本币)" ";" ";"
                       "本年累计发生额(本币)" ";" ";"
                       "期末余额(本币)" ";" SKIP.
       
       PUT UNFORMATTED "编号" ";" "名称" ";" 
                       "编号" ";" "名称" ";" ";"
                       "借方" ";" "贷方" ";" 
                       "借方" ";" "贷方" ";" 
                       "借方" ";" "贷方" ";" 
                       "借方" ";" "贷方" SKIP.
    END.

   v_beg_amt = 0.
   v_beg_curramt = 0.
   FOR EACH tt BREAK BY tt_acc BY tt_ctr :
       ACCUMULATE tt_curr_dr_amt ( TOTAL BY tt_acc BY tt_ctr).
       ACCUMULATE tt_curr_cr_amt ( TOTAL BY tt_acc BY tt_ctr).
       ACCUMULATE tt_y_curr_dr_amt ( TOTAL BY tt_acc BY tt_ctr).
       ACCUMULATE tt_y_curr_cr_amt ( TOTAL BY tt_acc BY tt_ctr).
       ACCUMULATE tt_dr_amt ( TOTAL BY tt_acc BY tt_ctr).
       ACCUMULATE tt_cr_amt ( TOTAL BY tt_acc BY tt_ctr).
       ACCUMULATE tt_y_dr_amt ( TOTAL BY tt_acc BY tt_ctr).
       ACCUMULATE tt_y_cr_amt ( TOTAL BY tt_acc BY tt_ctr).
       IF LAST-OF(tt_ctr) THEN DO:
           FOR EACH tt1 WHERE tt1_acc = tt_acc AND tt1_ctr = tt_ctr NO-LOCK :
               v_beg_amt = v_beg_amt + tt1_amt.
               v_beg_curramt = v_beg_curramt + tt1_curramt .
           END.
           PUT UNFORMATTED "'" + tt_acc ";" tt_ac_desc ";" "'" + tt_ctr ";" tt_cc_desc ";" .
           PUT UNFORMATTED tt_curr ";" .
           IF v_curr = YES THEN DO:
               IF v_beg_curramt >= 0 THEN PUT UNFORMATTED v_beg_curramt ";" ";" .
                                     ELSE PUT UNFORMATTED ";" ABS(v_beg_curramt) ";" .
               IF v_beg_amt >= 0 THEN PUT UNFORMATTED v_beg_amt ";" ";" .
                                     ELSE PUT UNFORMATTED ";" ABS(v_beg_amt) ";" .

               PUT UNFORMATTED (ACCUMULATE TOTAL BY tt_ctr tt_curr_dr_amt) ";" (ACCUMULATE TOTAL BY tt_ctr tt_curr_cr_amt) ";" 
                               (ACCUMULATE TOTAL BY tt_ctr tt_dr_amt) ";" (ACCUMULATE TOTAL BY tt_ctr tt_cr_amt) ";" 
                               (ACCUMULATE TOTAL BY tt_ctr tt_y_curr_dr_amt) ";" (ACCUMULATE TOTAL BY tt_ctr tt_y_curr_cr_amt) ";" 
                               (ACCUMULATE TOTAL BY tt_ctr tt_y_dr_amt) ";" (ACCUMULATE TOTAL BY tt_ctr tt_y_cr_amt) ";" .

               IF v_beg_curramt >= 0 THEN DO: 
                  IF (v_beg_curramt + (ACCUMULATE TOTAL BY tt_ctr tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_curr_cr_amt)) >= 0 THEN DO:
                     PUT UNFORMATTED (v_beg_curramt + (ACCUMULATE TOTAL BY tt_ctr tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_curr_cr_amt)) ";" ";" .
                  END.
                  ELSE DO:
                     PUT UNFORMATTED ";" ABS(v_beg_curramt + (ACCUMULATE TOTAL BY tt_ctr tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_curr_cr_amt)) ";" .
                  END.                   
               END.
               ELSE DO: 
                  IF (v_beg_curramt + (ACCUMULATE TOTAL BY tt_ctr tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_curr_cr_amt)) >= 0 THEN DO:
                     PUT UNFORMATTED ABS(v_beg_curramt + (ACCUMULATE TOTAL BY tt_ctr tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_curr_cr_amt)) ";" ";" .
                  END.
                  ELSE DO:
                     PUT UNFORMATTED ";" ABS(v_beg_curramt + (ACCUMULATE TOTAL BY tt_ctr tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_curr_cr_amt)) ";" .
                  END.
               END.

               IF v_beg_amt >= 0 THEN DO: 
                  IF (v_beg_amt + (ACCUMULATE TOTAL BY tt_ctr tt_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_cr_amt)) >= 0 THEN DO:
                     PUT UNFORMATTED (v_beg_amt + (ACCUMULATE TOTAL BY tt_ctr tt_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_cr_amt)) ";" SKIP.
                  END.
                  ELSE DO:
                     PUT UNFORMATTED ";" ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_ctr tt_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_cr_amt)) SKIP.
                  END.                   
               END.
               ELSE DO: 
                  IF (v_beg_amt + (ACCUMULATE TOTAL BY tt_ctr tt_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_cr_amt)) >= 0 THEN DO:
                     PUT UNFORMATTED ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_ctr tt_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_cr_amt)) ";" SKIP.
                  END.
                  ELSE DO:
                     PUT UNFORMATTED ";" ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_ctr tt_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_cr_amt)) SKIP.
                  END.                                                                                                                         
               END.
           END.
           ELSE DO:
               IF v_beg_amt >= 0 THEN PUT UNFORMATTED v_beg_amt ";" ";" .
                                     ELSE PUT UNFORMATTED ";" ABS(v_beg_amt) ";" .
               PUT UNFORMATTED (ACCUMULATE TOTAL BY tt_ctr tt_dr_amt) ";" (ACCUMULATE TOTAL BY tt_ctr tt_cr_amt) ";" 
                               (ACCUMULATE TOTAL BY tt_ctr tt_y_dr_amt) ";" (ACCUMULATE TOTAL BY tt_ctr tt_y_cr_amt) ";" .
               IF v_beg_amt >= 0 THEN DO: 
                  IF (v_beg_amt + (ACCUMULATE TOTAL BY tt_ctr tt_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_cr_amt)) >= 0 THEN DO:
                     PUT UNFORMATTED (v_beg_amt + (ACCUMULATE TOTAL BY tt_ctr tt_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_cr_amt)) ";" SKIP.
                  END.
                  ELSE DO:
                     PUT UNFORMATTED ";" ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_ctr tt_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_cr_amt)) SKIP.
                  END.                   
               END.
               ELSE DO: 
                  IF (v_beg_amt + (ACCUMULATE TOTAL BY tt_ctr tt_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_cr_amt)) >= 0 THEN DO:
                     PUT UNFORMATTED ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_ctr tt_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_cr_amt)) ";" SKIP.
                  END.
                  ELSE DO:
                     PUT UNFORMATTED ";" ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_ctr tt_dr_amt) - (ACCUMULATE TOTAL BY tt_ctr tt_cr_amt)) SKIP.
                  END.                                                                                                                         
               END.
           END.
           v_beg_amt = 0.
           v_beg_curramt = 0.
       END.
   END.
END.

IF subflag = NO AND ccflag = YES THEN DO:
   IF v_curr = YES THEN DO:
       PUT UNFORMATTED  "帐户" ";" ";" "分帐户" ";" ";"
                        "货币" ";"
                          "期初余额(原币)" ";" ";" "期初余额(本币)" ";" ";"
                          "本期发生额(原币)" ";" ";" "本期发生额(本币)" ";" ";"
                          "本年累计发生额(原币)" ";" ";"  "本年累计发生额(本币)" ";" ";"
                          "期末余额(原币)" ";" ";" "期末余额(本币)" ";" SKIP.
       
       PUT UNFORMATTED "编号" ";" "名称" ";" "编号" ";" "名称" ";" ";"
                          "借方" ";" "贷方" ";" "借方" ";" "贷方" ";"
                          "借方" ";" "贷方" ";" "借方" ";" "贷方" ";" 
                          "借方" ";" "贷方" ";" "借方" ";" "贷方" ";" 
                          "借方" ";" "贷方" ";" "借方" ";" "贷方" SKIP.
   END.
   ELSE DO:
       PUT UNFORMATTED  "帐户" ";" ";" "分帐户" ";" ";"
                        "货币" ";"
                          "期初余额(本币)" ";" ";"
                          "本期发生额(本币)" ";" ";"
                          "本年累计发生额(本币)" ";" ";"
                          "期末余额(本币)" ";" SKIP.
       
       PUT UNFORMATTED "编号" ";" "名称" ";" "编号" ";" "名称" ";" ";"
                          "借方" ";" "贷方" ";" 
                          "借方" ";" "贷方" ";" 
                          "借方" ";" "贷方" ";" 
                          "借方" ";" "贷方" SKIP.
   END.

   v_beg_amt = 0.
   v_beg_curramt = 0.
   FOR EACH tt BREAK BY tt_acc BY tt_sub :
       ACCUMULATE tt_curr_dr_amt ( TOTAL BY tt_acc BY tt_sub).
       ACCUMULATE tt_curr_cr_amt ( TOTAL BY tt_acc BY tt_sub).
       ACCUMULATE tt_y_curr_dr_amt ( TOTAL BY tt_acc BY tt_sub).
       ACCUMULATE tt_y_curr_cr_amt ( TOTAL BY tt_acc BY tt_sub).
       ACCUMULATE tt_dr_amt ( TOTAL BY tt_acc BY tt_sub).
       ACCUMULATE tt_cr_amt ( TOTAL BY tt_acc BY tt_sub).
       ACCUMULATE tt_y_dr_amt ( TOTAL BY tt_acc BY tt_sub).
       ACCUMULATE tt_y_cr_amt ( TOTAL BY tt_acc BY tt_sub).
       IF LAST-OF(tt_sub) THEN DO:
           FOR EACH tt1 WHERE tt1_acc = tt_acc AND tt1_sub = tt_sub NO-LOCK :
               v_beg_amt = v_beg_amt + tt1_amt.
               v_beg_curramt = v_beg_curramt + tt1_curramt .
           END.
           PUT UNFORMATTED "'" + tt_acc ";" tt_ac_desc ";" "'" + tt_sub ";" tt_sb_desc ";" .
           PUT UNFORMATTED tt_curr ";" .

           IF v_curr = YES THEN DO:
               IF v_beg_curramt >= 0 THEN PUT UNFORMATTED v_beg_curramt ";" ";" .
                                     ELSE PUT UNFORMATTED ";" ABS(v_beg_curramt) ";" .
               IF v_beg_amt >= 0 THEN PUT UNFORMATTED v_beg_amt ";" ";" .
                                     ELSE PUT UNFORMATTED ";" ABS(v_beg_amt) ";" .

               PUT UNFORMATTED (ACCUMULATE TOTAL BY tt_sub tt_curr_dr_amt) ";" (ACCUMULATE TOTAL BY tt_sub tt_curr_cr_amt) ";" 
                               (ACCUMULATE TOTAL BY tt_sub tt_dr_amt) ";" (ACCUMULATE TOTAL BY tt_sub tt_cr_amt) ";" 
                               (ACCUMULATE TOTAL BY tt_sub tt_y_curr_dr_amt) ";" (ACCUMULATE TOTAL BY tt_sub tt_y_curr_cr_amt) ";" 
                               (ACCUMULATE TOTAL BY tt_sub tt_y_dr_amt) ";" (ACCUMULATE TOTAL BY tt_sub tt_y_cr_amt) ";" .
               IF v_beg_curramt >= 0 THEN DO: 
                  IF (v_beg_curramt + (ACCUMULATE TOTAL BY tt_sub tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_curr_cr_amt)) >= 0 THEN DO:
                     PUT UNFORMATTED (v_beg_curramt + (ACCUMULATE TOTAL BY tt_sub tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_curr_cr_amt)) ";" ";".
                  END.
                  ELSE DO:
                     PUT UNFORMATTED ";" ABS(v_beg_curramt + (ACCUMULATE TOTAL BY tt_sub tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_curr_cr_amt)) ";".
                  END.                   
               END.
               ELSE DO: 
                  IF (v_beg_curramt + (ACCUMULATE TOTAL BY tt_sub tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_curr_cr_amt)) >= 0 THEN DO:
                     PUT UNFORMATTED ABS(v_beg_curramt + (ACCUMULATE TOTAL BY tt_sub tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_curr_cr_amt)) ";" ";" .
                  END.
                  ELSE DO:
                     PUT UNFORMATTED ";" ABS(v_beg_curramt + (ACCUMULATE TOTAL BY tt_sub tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_curr_cr_amt)) ";" .
                  END.
                  
               END.
               IF v_beg_amt >= 0 THEN DO: 
                  IF (v_beg_amt + (ACCUMULATE TOTAL BY tt_sub tt_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_cr_amt)) >= 0 THEN DO:
                     PUT UNFORMATTED (v_beg_amt + (ACCUMULATE TOTAL BY tt_sub tt_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_cr_amt)) ";" SKIP.
                  END.
                  ELSE DO:
                     PUT UNFORMATTED ";" ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_sub tt_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_cr_amt)) SKIP.
                  END.
               END.
               ELSE DO:
                  IF (v_beg_amt + (ACCUMULATE TOTAL BY tt_sub tt_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_cr_amt)) >= 0 THEN DO:
                     PUT UNFORMATTED ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_sub tt_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_cr_amt)) ";" SKIP.
                  END.
                  ELSE DO:
                     PUT UNFORMATTED ";" ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_sub tt_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_cr_amt)) SKIP.
                  END.
               END.
                  

           END.
           ELSE DO:
               IF v_beg_amt >= 0 THEN PUT UNFORMATTED v_beg_amt ";" ";" .
                                     ELSE PUT UNFORMATTED ";" ABS(v_beg_amt) ";" .
               PUT UNFORMATTED (ACCUMULATE TOTAL BY tt_sub tt_dr_amt) ";" (ACCUMULATE TOTAL BY tt_sub tt_cr_amt) ";" 
                               (ACCUMULATE TOTAL BY tt_sub tt_y_dr_amt) ";" (ACCUMULATE TOTAL BY tt_sub tt_y_cr_amt) ";" .
               IF v_beg_amt >= 0 THEN DO: 
                  IF (v_beg_amt + (ACCUMULATE TOTAL BY tt_sub tt_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_cr_amt)) >= 0 THEN DO:
                     PUT UNFORMATTED (v_beg_amt + (ACCUMULATE TOTAL BY tt_sub tt_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_cr_amt)) ";" SKIP.
                  END.
                  ELSE DO:
                     PUT UNFORMATTED ";" ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_sub tt_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_cr_amt)) SKIP.
                  END.
               END.
               ELSE DO:
                  IF (v_beg_amt + (ACCUMULATE TOTAL BY tt_sub tt_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_cr_amt)) >= 0 THEN DO:
                     PUT UNFORMATTED ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_sub tt_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_cr_amt)) ";" SKIP.
                  END.
                  ELSE DO:
                     PUT UNFORMATTED ";" ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_sub tt_dr_amt) - (ACCUMULATE TOTAL BY tt_sub tt_cr_amt)) SKIP.
                  END.
               END.
           END.
           v_beg_amt = 0.
           v_beg_curramt = 0.
       END.
   END.
END.
IF subflag = YES AND ccflag = YES THEN DO:
   IF v_curr = YES THEN DO:
       PUT UNFORMATTED  "帐户" ";" ";" 
                        "货币" ";"
                        "期初余额(原币)" ";" ";" "期初余额(本币)" ";" ";"
                             "本期发生额(原币)" ";" ";" "本期发生额(本币)" ";" ";"
                             "本年累计发生额(原币)" ";" ";"  "本年累计发生额(本币)" ";" ";"
                             "期末余额(原币)" ";" ";" "期末余额(本币)" ";" SKIP.
       
       PUT UNFORMATTED "编号" ";" "名称" ";" ";"                   
                       "借方" ";" "贷方" ";" "借方" ";" "贷方" ";" 
                       "借方" ";" "贷方" ";" "借方" ";" "贷方" ";"    
                       "借方" ";" "贷方" ";" "借方" ";" "贷方" ";" 
                       "借方" ";" "贷方" ";" "借方" ";" "贷方" SKIP.
   END.
   ELSE DO:
      PUT UNFORMATTED  "帐户" ";" ";" 
               "货币" ";"
               "期初余额(本币)" ";" ";"
               "本期发生额(本币)" ";" ";"
               "本年累计发生额(本币)" ";" ";"
               "期末余额(本币)" ";" SKIP.
      
      PUT UNFORMATTED "编号" ";" "名称" ";" ";"                   
              "借方" ";" "贷方" ";" 
              "借方" ";" "贷方" ";" 
              "借方" ";" "贷方" ";" 
              "借方" ";" "贷方" SKIP.
   END.

   v_beg_amt = 0.
   v_beg_curramt = 0.
   FOR EACH tt BREAK BY tt_acc  :
       ACCUMULATE tt_curr_dr_amt ( TOTAL BY tt_acc ).
       ACCUMULATE tt_curr_cr_amt ( TOTAL BY tt_acc ).
       ACCUMULATE tt_y_curr_dr_amt ( TOTAL BY tt_acc ).
       ACCUMULATE tt_y_curr_cr_amt ( TOTAL BY tt_acc ).
       ACCUMULATE tt_dr_amt ( TOTAL BY tt_acc ).
       ACCUMULATE tt_cr_amt ( TOTAL BY tt_acc ).
       ACCUMULATE tt_y_dr_amt ( TOTAL BY tt_acc ).
       ACCUMULATE tt_y_cr_amt ( TOTAL BY tt_acc ).
       IF LAST-OF(tt_acc) THEN DO:
           FOR EACH tt1 WHERE tt1_acc = tt_acc NO-LOCK :
               v_beg_amt = v_beg_amt + tt1_amt.
               v_beg_curramt = v_beg_curramt + tt1_curramt .
           END.
           PUT UNFORMATTED "'" + tt_acc ";" tt_ac_desc ";"  .
           PUT UNFORMATTED tt_curr ";" .

           IF v_curr = YES THEN DO:
               IF v_beg_curramt >= 0 THEN PUT UNFORMATTED v_beg_curramt ";" ";" .
                                     ELSE PUT UNFORMATTED ";" ABS(v_beg_curramt) ";" .
               IF v_beg_amt >= 0 THEN PUT UNFORMATTED v_beg_amt ";" ";" .
                                     ELSE PUT UNFORMATTED ";" ABS(v_beg_amt) ";" .

               PUT UNFORMATTED (ACCUMULATE TOTAL BY tt_acc tt_curr_dr_amt) ";" (ACCUMULATE TOTAL BY tt_acc tt_curr_cr_amt) ";" 
                               (ACCUMULATE TOTAL BY tt_acc tt_dr_amt) ";" (ACCUMULATE TOTAL BY tt_acc tt_cr_amt) ";" 
                               (ACCUMULATE TOTAL BY tt_acc tt_y_curr_dr_amt) ";" (ACCUMULATE TOTAL BY tt_acc tt_y_curr_cr_amt) ";" 
                               (ACCUMULATE TOTAL BY tt_acc tt_y_dr_amt) ";" (ACCUMULATE TOTAL BY tt_acc tt_y_cr_amt) ";" .

               IF v_beg_curramt >= 0 THEN DO: 
                  IF (v_beg_curramt + (ACCUMULATE TOTAL BY tt_acc tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_curr_cr_amt)) >= 0 THEN DO:
                     PUT UNFORMATTED (v_beg_curramt + (ACCUMULATE TOTAL BY tt_acc tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_curr_cr_amt)) ";" ";".
                  END.
                  ELSE DO:
                     PUT UNFORMATTED ";" ABS(v_beg_curramt + (ACCUMULATE TOTAL BY tt_acc tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_curr_cr_amt)) ";".
                  END.
               END.
               ELSE DO: 
                  IF (v_beg_curramt + (ACCUMULATE TOTAL BY tt_acc tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_curr_cr_amt)) >= 0 THEN DO:
                     PUT UNFORMATTED ABS(v_beg_curramt + (ACCUMULATE TOTAL BY tt_acc tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_curr_cr_amt)) ";" ";" .
                  END.
                  ELSE DO:
                     PUT UNFORMATTED ";" ABS(v_beg_curramt + (ACCUMULATE TOTAL BY tt_acc tt_curr_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_curr_cr_amt)) ";" .
                  END.                                                                                                                                      
               END.

               IF v_beg_amt >= 0 THEN DO: 
                  IF (v_beg_amt + (ACCUMULATE TOTAL BY tt_acc tt_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_cr_amt)) >= 0 THEN DO:
                      PUT UNFORMATTED (v_beg_amt + (ACCUMULATE TOTAL BY tt_acc tt_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_cr_amt)) ";" SKIP.
                  END.
                  ELSE DO:
                      PUT UNFORMATTED ";" ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_acc tt_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_cr_amt)) SKIP.
                  END.                                                                                                                  
               END.
               ELSE DO: 
                  IF (v_beg_amt + (ACCUMULATE TOTAL BY tt_acc tt_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_cr_amt)) >= 0 THEN DO:
                     PUT UNFORMATTED ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_acc tt_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_cr_amt)) ";" SKIP.
                  END.
                  ELSE DO:
                     PUT UNFORMATTED ";" ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_acc tt_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_cr_amt)) SKIP.
                  END.               
               END.

           END.
           ELSE DO:
               IF v_beg_amt >= 0 THEN PUT UNFORMATTED v_beg_amt ";" ";" .
                                     ELSE PUT UNFORMATTED ";" ABS(v_beg_amt) ";" .
               PUT UNFORMATTED (ACCUMULATE TOTAL BY tt_acc tt_dr_amt) ";" (ACCUMULATE TOTAL BY tt_acc tt_cr_amt) ";" 
                               (ACCUMULATE TOTAL BY tt_acc tt_y_dr_amt) ";" (ACCUMULATE TOTAL BY tt_acc tt_y_cr_amt) ";" .
               IF v_beg_amt >= 0 THEN DO: 
                  IF (v_beg_amt + (ACCUMULATE TOTAL BY tt_acc tt_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_cr_amt)) >= 0 THEN DO:
                      PUT UNFORMATTED (v_beg_amt + (ACCUMULATE TOTAL BY tt_acc tt_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_cr_amt)) ";" SKIP.
                  END.
                  ELSE DO:
                      PUT UNFORMATTED ";" ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_acc tt_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_cr_amt)) SKIP.
                  END.                                                                                                                  
               END.
               ELSE DO: 
                  IF (v_beg_amt + (ACCUMULATE TOTAL BY tt_acc tt_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_cr_amt)) >= 0 THEN DO:
                     PUT UNFORMATTED ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_acc tt_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_cr_amt)) ";" SKIP.
                  END.
                  ELSE DO:
                     PUT UNFORMATTED ";" ABS(v_beg_amt + (ACCUMULATE TOTAL BY tt_acc tt_dr_amt) - (ACCUMULATE TOTAL BY tt_acc tt_cr_amt)) SKIP.
                  END.               
               END.
           END.
           v_beg_amt = 0.
           v_beg_curramt = 0.
       END.
   END.
END.

{a6mfrtrail.i}
                                                                                    
