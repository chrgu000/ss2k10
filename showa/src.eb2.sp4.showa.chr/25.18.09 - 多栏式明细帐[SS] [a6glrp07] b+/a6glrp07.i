DEF TEMP-TABLE tt 
    FIELD tt_ac_code  LIKE ac_code
    FIELD tt_ac_desc  LIKE ac_desc
    FIELD tt_drcr     LIKE xxac_drcr
    FIELD tt_name     LIKE xxac_name
    FIELD tt_name_desc     LIKE xxac_name_desc
    FIELD tt_ref      LIKE gltr_ref
    FIELD tt_line     AS CHAR 
    FIELD tt_ref_desc LIKE gltr_desc
    FIELD tt_amt      AS   DECIMAL
    FIELD tt_eff_dt   LIKE gltr_eff_dt
    FIELD tt_gltr__qadc01 LIKE gltr__qadc01
    INDEX refline tt_ref tt_line
    .                 

DEF TEMP-TABLE tt1 
    FIELD tt1_ac_code  LIKE ac_code
    FIELD tt1_ac_desc  LIKE ac_desc
    FIELD tt1_drcr     LIKE xxac_drcr
    FIELD tt1_name     LIKE xxac_name
    FIELD tt1_name_desc     LIKE xxac_name_desc
    FIELD tt1_ref      LIKE gltr_ref
    FIELD tt1_line     AS CHAR
    FIELD tt1_ref_desc LIKE gltr_desc
    FIELD tt1_amt      AS   DECIMAL
    FIELD tt1_eff_dt   LIKE gltr_eff_dt
    FIELD tt1_gltr__qadc01 LIKE gltr__qadc01
    INDEX refline tt1_ref tt1_line
    . 

DEF TEMP-TABLE tt3
    FIELD tt3_amt AS DECIMAL
   .
DEF TEMP-TABLE tt33
    FIELD tt33_amt AS DECIMAL
   .

/* 存放表头资料 */
DEF TEMP-TABLE tt4
    FIELD tt4_drcr LIKE xxac_drcr
    FIELD tt4_name LIKE xxac_name
    FIELD tt4_name_desc LIKE xxac_name_desc
    .

DEF VAR v_dr_flag AS LOGICAL.
DEF VAR v_cr_flag AS LOGICAL .
DEF VAR v_xxac_drcr LIKE xxac_drcr.
DEF VAR v_xxac_name LIKE xxac_name .
DEF VAR v_xxac_name_desc LIKE xxac_name_desc .
DEF VAR v_code_desc AS CHAR.
DEF VAR v_amt AS DECIMAL.
DEF VAR v_amt1 AS DECIMAL.
DEF VAR v_tot_amt1 AS DECIMAL .
DEF VAR v_amt1a AS DECIMAL.
DEF VAR v_tot_amt1a AS DECIMAL .
DEF VAR v_tot_amt2 AS DECIMAL .
DEF BUFFER ttc FOR tt .
DEF BUFFER tt1b FOR tt1 .
DEF VAR v_username AS CHAR.

FOR EACH tt :
    DELETE tt .
END.

FOR EACH tt1 :
    DELETE tt1 .
END.

v_code_desc = "" .
v_xxac_drcr = "" .
v_xxac_name = "" .
v_xxac_name_desc = "" .
FOR EACH gltr_hist NO-LOCK WHERE gltr_sub >= sub AND gltr_sub <= sub1
                             AND gltr_ctr >= ctr AND gltr_ctr <= ctr1 
                             AND gltr_entity >= entity AND gltr_entity <= entity1 
                             AND gltr_eff_dt >= effdate AND gltr_eff_dt <= effdate1 :

    FIND FIRST xxac_det WHERE xxac_code = acc
                          AND (gltr_acc >= xxac_acctfrom OR xxac_acctfrom = "" )
                          AND (gltr_acc <= xxac_acctto OR xxac_acctto = "")
                          AND (gltr_sub >= xxac_subfrom OR xxac_subfrom = "")
                          AND (gltr_sub <= xxac_subto OR xxac_subto = "") NO-LOCK NO-ERROR.
    IF AVAIL xxac_det THEN DO:
        v_xxac_drcr = xxac_drcr .
        v_xxac_name = xxac_name .
        v_xxac_name_desc = xxac_name_desc .

        v_code_desc = xxac_code_desc .

        CREATE tt .
        ASSIGN
            tt_ac_code = acc
            tt_ac_desc = v_code_desc
            tt_drcr = v_xxac_drcr
            tt_name = v_xxac_name              
            tt_name_desc = v_xxac_name_desc
            tt_ref  = gltr_ref
            tt_line = string(int(gltr_line))
            tt_ref_desc = gltr_desc
            tt_amt = gltr_amt
            tt_eff_dt = gltr_eff_dt 
            tt_gltr__qadc01 = gltr__qadc01
            .
        v_xxac_drcr = "" .
        v_xxac_name = "" .
        v_xxac_name_desc = "" .
    END.
END.

/* 取得本年累计 */
v_xxac_drcr = "" .
v_xxac_name = "" .
v_xxac_name_desc = "" .
FOR EACH gltr_hist NO-LOCK WHERE gltr_sub >= sub AND gltr_sub <= sub1
                             AND gltr_ctr >= ctr AND gltr_ctr <= ctr1 
                             AND gltr_entity >= entity AND gltr_entity <= entity1 
                             AND gltr_eff_dt >= date(1,1,year(effdate)) AND gltr_eff_dt <= effdate1
                             :

    FIND FIRST xxac_det WHERE xxac_code = acc
                          AND (gltr_acc >= xxac_acctfrom OR xxac_acctfrom = "" )
                          AND (gltr_acc <= xxac_acctto OR xxac_acctto = "")
                          AND (gltr_sub >= xxac_subfrom OR xxac_subfrom = "")
                          AND (gltr_sub <= xxac_subto OR xxac_subto = "") NO-LOCK NO-ERROR.
    IF AVAIL xxac_det THEN DO:
        v_xxac_drcr = xxac_drcr .
        v_xxac_name = xxac_name .
        v_xxac_name_desc = xxac_name_desc .
        v_code_desc = xxac_code_desc .

        CREATE tt1 .
        ASSIGN
            tt1_ac_code = acc
            tt1_ac_desc = v_code_desc
            tt1_drcr = v_xxac_drcr
            tt1_name = v_xxac_name
            tt1_name_desc = v_xxac_name_desc
            tt1_ref  = gltr_ref
            tt1_line = string(int(gltr_line))
            tt1_ref_desc = gltr_desc
            tt1_amt = gltr_amt
            tt1_eff_dt = gltr_eff_dt 
            tt1_gltr__qadc01 = gltr__qadc01
            .
        v_xxac_drcr = "" .
        v_xxac_name = "" .
        v_xxac_name_desc = "" .
    END.
END.
                          
/* 取得表头资料 */
FOR EACH tt4 :
    DELETE tt4 .
END.
FOR EACH xxac_det NO-LOCK WHERE xxac_code = acc BREAK BY xxac_drcr BY xxac_name :
    IF LAST-OF(xxac_name) THEN DO:
       CREATE tt4 .
       ASSIGN
           tt4_drcr = xxac_drcr
           tt4_name = xxac_name 
           tt4_name_desc = xxac_name_desc
           .
    END.
END.

/* 取得期初余额 */
v_amt = 0.
FOR EACH gltr_hist NO-LOCK WHERE gltr_eff_dt < effdate  :
    FIND FIRST xxac_det WHERE xxac_code = acc
                          AND (gltr_acc >= xxac_acctfrom OR xxac_acctfrom = "" )
                          AND (gltr_acc <= xxac_acctto OR xxac_acctto = "")
                          AND (gltr_sub >= xxac_subfrom OR xxac_subfrom = "")
                          AND (gltr_sub >= xxac_subto OR xxac_subto = "") NO-LOCK NO-ERROR.
    IF AVAIL xxac_det THEN DO:
       v_amt = gltr_amt + v_amt .
    END.
END.

PUT UNFORMATTED "ExecutionFile" ";" "txt2xls2.exe" SKIP.
PUT UNFORMATTED "ExcelFile" ";" "a6glrp07" SKIP.
PUT UNFORMATTED "SaveFile" ";" v_code_desc + "(多栏式明细帐)" SKIP.
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
PUT UNFORMATTED v_code_desc + "(多栏式明细帐)" SKIP.
PUT UNFORMATTED STRING(YEAR(effdate)) +  '年'   + STRING(MONTH(effdate),'99') + '月' + " -- " + STRING(MONTH(effdate1),'99') + '月' SKIP. 
PUT "  " SKIP.

/* 行标题1 */
PUT UNFORMATTED "日期" ";" "总帐参考号" ";" "摘要" ";" .
FOR EACH tt4 NO-LOCK BREAK BY tt4_drcr DESCENDING BY tt4_name :
    IF FIRST-OF(tt4_drcr) THEN DO:
       PUT UNFORMATTED tt4_drcr ";" .
    END.
    IF LAST-OF(tt4_name) THEN DO:
       PUT UNFORMATTED ";" .
    END.
END.
PUT UNFORMATTED "余额" ";" SKIP.

PUT UNFORMATTED ";" ";" ";" .
FOR EACH tt4 NO-LOCK BREAK BY tt4_drcr DESCENDING BY tt4_name :
    IF FIRST-OF(tt4_drcr) THEN DO:
       PUT UNFORMATTED "合计" ";" .
    END.
    IF LAST-OF(tt4_name) THEN DO:
       PUT UNFORMATTED tt4_name_desc ";" .
    END.
END.
PUT UNFORMATTED ";" ";" SKIP.

PUT UNFORMATTED ";" ";" "期  初  余  额 " ";"  .
FOR EACH tt4 NO-LOCK BREAK BY tt4_drcr DESCENDING BY tt4_name :
    IF FIRST-OF(tt4_drcr) THEN DO:
       PUT UNFORMATTED ";" .
    END.
    IF LAST-OF(tt4_name) THEN DO:
       PUT UNFORMATTED ";" .
    END.
END.
IF v_amt = 0 THEN DO:
   PUT UNFORMATTED  "平" ";"  SKIP.
END.
ELSE IF v_amt > 0 THEN DO:
   PUT UNFORMATTED  "借" ";" string(abs(v_amt)) SKIP.
END.
ELSE DO:
   PUT UNFORMATTED  "贷" ";" string(abs(v_amt)) SKIP.
END.

/* 行和行合计 */
v_tot_amt2 = 0. 
FOR EACH ttc NO-LOCK BREAK BY YEAR(ttc.tt_eff_dt) BY MONTH(ttc.tt_eff_dt) 
                           BY ttc.tt_eff_dt BY ttc.tt_ref BY ttc.tt_line :
    IF LAST-OF(ttc.tt_line) THEN DO:
       PUT UNFORMATTED string(year(ttc.tt_eff_dt)) + "." + STRING(MONTH(ttc.tt_eff_dt),"99") + "." + STRING(DAY(ttc.tt_eff_dt),"99") ";" ttc.tt_ref ";" ttc.tt_ref_desc ";"  .
       v_tot_amt1 = 0.         
       v_tot_amt1a = 0.
       FOR EACH tt3 :
           DELETE tt3 .
       END.

       FOR EACH tt33 :
           DELETE tt33 .
       END.

       v_dr_flag = NO.
       v_cr_flag = NO.
       FOR EACH tt4 NO-LOCK BREAK BY tt4_drcr DESCENDING BY tt4_name :
           IF tt4_drcr = "借方" OR caps(tt4_drcr) = "DR" THEN DO:
              IF LAST-OF(tt4_name) THEN DO:
                 v_amt1 = 0.
                 FOR EACH tt NO-LOCK WHERE tt.tt_eff_dt = ttc.tt_eff_dt AND tt.tt_ref = ttc.tt_ref AND tt.tt_line = ttc.tt_line
                                       AND tt.tt_name = tt4.tt4_name AND tt.tt_drcr = tt4.tt4_drcr :
                     v_amt1 = v_amt1 + tt.tt_amt .
                 END.
                 v_tot_amt1 = v_tot_amt1 + v_amt1 .
                 CREATE tt3 .
                 ASSIGN
                    tt3_amt = v_amt1 .
              END.
              v_dr_flag = YES .
           END.
           IF tt4_drcr = "贷方" OR caps(tt4_drcr) = "CR" THEN DO:
              IF LAST-OF(tt4_name) THEN DO:
                 v_amt1a = 0.
                 FOR EACH tt NO-LOCK WHERE tt.tt_eff_dt = ttc.tt_eff_dt AND tt.tt_ref = ttc.tt_ref AND tt.tt_line = ttc.tt_line
                                       AND tt.tt_name = tt4.tt4_name AND tt.tt_drcr = tt4.tt4_drcr :
                     v_amt1a = v_amt1a + tt.tt_amt .
                 END.
                 v_tot_amt1a = v_tot_amt1a + v_amt1a .
                 CREATE tt33 .
                 ASSIGN
                    tt33_amt = - v_amt1a .
              END.
              v_cr_flag = YES .
           END.
       END.
       v_tot_amt2 = v_amt + v_tot_amt2 + v_tot_amt1 + v_tot_amt1a .
       v_amt = 0.
       IF v_dr_flag = YES THEN PUT UNFORMATTED v_tot_amt1 ";" .
       FOR EACH tt3 :
           PUT UNFORMATTED tt3_amt ";" .
       END.
       IF v_cr_flag = YES THEN PUT UNFORMATTED - v_tot_amt1a ";" .
       FOR EACH tt33 :
           PUT UNFORMATTED tt33_amt ";" .
       END.

       IF v_tot_amt2 > 0 THEN PUT UNFORMATTED "借 " ";"      STRING(abs(v_tot_amt2)) SKIP.
       ELSE IF v_tot_amt2 = 0 THEN PUT UNFORMATTED "平 " ";" SKIP.
                              ELSE PUT UNFORMATTED "贷 " ";" STRING(abs(v_tot_amt2)) SKIP.
       
    END. /* IF LAST-OF(ttc.tt_line) THEN DO: */
    
    /************************************************ 本月合计 ********************************************/
    IF LAST-OF(MONTH(ttc.tt_eff_dt)) THEN DO:
            /* 列和总合计 */
            PUT UNFORMATTED ";" ";" "本 月 合 计" ";" .
            v_tot_amt1 = 0 .
            v_tot_amt1a = 0 .
            FOR EACH tt3: 
                DELETE tt3 .
            END.
            FOR EACH tt33 :
                DELETE tt33 .
            END.
            v_dr_flag = NO .
            v_cr_flag = NO .
            FOR EACH tt4 NO-LOCK BREAK BY tt4_drcr DESCENDING BY tt4_name :
              IF tt4_drcr = "借方" OR caps(tt4_drcr) = "DR" THEN DO:
                 IF LAST-OF(tt4_name) THEN DO:
                    v_amt1 = 0.
                    FOR EACH tt NO-LOCK WHERE month(tt.tt_eff_dt) = MONTH(ttc.tt_eff_dt) AND tt.tt_gltr__qadc01 = "N" AND tt.tt_name = tt4.tt4_name AND tt.tt_drcr = tt4.tt4_drcr :
                        v_amt1 = v_amt1 + tt.tt_amt .
                    END.
                    v_tot_amt1 = v_tot_amt1 + v_amt1 .
                    CREATE tt3 .
                    ASSIGN
                       tt3_amt = v_amt1 .
                 END.
                 v_dr_flag = YES.
              END.
              IF tt4_drcr = "贷方" OR caps(tt4_drcr) = "CR" THEN DO:
                 IF LAST-OF(tt4_name) THEN DO:
                    v_amt1a = 0.
                    FOR EACH tt NO-LOCK WHERE month(tt.tt_eff_dt) = MONTH(ttc.tt_eff_dt) AND tt.tt_gltr__qadc01 = "N" AND tt.tt_name = tt4.tt4_name AND tt.tt_drcr = tt4.tt4_drcr :
                        v_amt1a = v_amt1a + tt.tt_amt .
                    END.
                    v_tot_amt1a = v_tot_amt1a + v_amt1a .
                    CREATE tt33 .
                    ASSIGN
                       tt33_amt = - v_amt1a .
                 END.
                 v_cr_flag = YES .
              END.
            END.
            IF v_dr_flag = YES THEN PUT UNFORMATTED v_tot_amt1 ";" .
            FOR EACH tt3 :
              PUT UNFORMATTED tt3_amt ";" .
            END.
            IF v_cr_flag = YES THEN PUT UNFORMATTED - v_tot_amt1a ";" .
            FOR EACH tt33 :
              PUT UNFORMATTED tt33_amt ";" .
            END.
            
            IF v_tot_amt2 > 0 THEN PUT UNFORMATTED "借 " ";"      STRING(abs(v_tot_amt2)) SKIP.
            ELSE IF v_tot_amt2 = 0 THEN PUT UNFORMATTED "平 " ";" SKIP.
                                 ELSE PUT UNFORMATTED "贷 " ";" STRING(abs(v_tot_amt2)) SKIP.
            PUT SKIP.
    END.
    /************************************************ 本月合计 ********************************************/

    /************************************************ 本年累计 ********************************************/
    IF LAST-OF(MONTH(ttc.tt_eff_dt)) THEN DO:
            PUT UNFORMATTED ";" ";" "本 年 累 计" ";".
            v_tot_amt1 = 0 .
            v_tot_amt1a = 0 .
            FOR EACH tt3: 
                DELETE tt3 .
            END.
            FOR EACH tt33 :
                DELETE tt33 .
            END.
            v_dr_flag = NO.
            v_cr_flag = NO.
            FOR EACH tt4 NO-LOCK BREAK BY tt4_drcr DESCENDING BY tt4_name :
              IF tt4_drcr = "借方" OR caps(tt4_drcr) = "DR" THEN DO:
                 IF LAST-OF(tt4_name) THEN DO:
                    v_amt1 = 0.
                    FOR EACH tt1 NO-LOCK WHERE YEAR(tt1.tt1_eff_dt) = YEAR(ttc.tt_eff_dt) 
                                           AND MONTH(tt1.tt1_eff_dt) <= MONTH(ttc.tt_eff_dt)
                                           AND tt1.tt1_gltr__qadc01 = "N" AND tt1.tt1_name = tt4.tt4_name AND tt1.tt1_drcr = tt4.tt4_drcr :
                        v_amt1 = v_amt1 + tt1.tt1_amt .
                    END.
                    v_tot_amt1 = v_tot_amt1 + v_amt1 .
                    CREATE tt3 .
                    ASSIGN
                       tt3_amt = v_amt1 .
                 END.
                 v_dr_flag = YES .
              END.
              IF tt4_drcr = "贷方" OR caps(tt4_drcr) = "CR" THEN DO:
                 IF LAST-OF(tt4_name) THEN DO:
                    v_amt1a = 0.
                    FOR EACH tt1 NO-LOCK WHERE YEAR(tt1.tt1_eff_dt) = YEAR(ttc.tt_eff_dt) 
                                           AND MONTH(tt1.tt1_eff_dt) <= MONTH(ttc.tt_eff_dt)
                                           AND tt1.tt1_gltr__qadc01 = "N" AND tt1.tt1_name = tt4.tt4_name AND tt1.tt1_drcr = tt4.tt4_drcr :
                        v_amt1a = v_amt1a + tt1.tt1_amt .
                    END.
                    v_tot_amt1a = v_tot_amt1a + v_amt1a .
                    CREATE tt33 .
                    ASSIGN
                       tt33_amt = - v_amt1a .
                 END.             
                 v_cr_flag = YES .
              END.
            END.
            IF v_dr_flag = YES THEN PUT UNFORMATTED v_tot_amt1 ";" .
            FOR EACH tt3 :
              PUT UNFORMATTED tt3_amt ";" .
            END.
            IF v_cr_flag = YES THEN PUT UNFORMATTED - v_tot_amt1a ";" .
            FOR EACH tt33 :
              PUT UNFORMATTED tt33_amt ";" .
            END.
    
            IF v_tot_amt2 > 0 THEN PUT UNFORMATTED "借 " ";"      STRING(abs(v_tot_amt2)) SKIP.
            ELSE IF v_tot_amt2 = 0 THEN PUT UNFORMATTED "平 " ";" SKIP.
                                 ELSE PUT UNFORMATTED "贷 " ";" STRING(abs(v_tot_amt2)) SKIP.
    END.
    /************************************************ 本年累计 ********************************************/

END.

{a6mfrtrail.i}
