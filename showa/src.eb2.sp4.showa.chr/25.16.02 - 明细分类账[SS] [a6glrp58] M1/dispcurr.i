IF vcurr = YES THEN DO:
    IF subflag = NO AND ctrflag = NO THEN DO:
        j = 0.
        /*
        PUT UNFORMATTED "begin" SKIP.
        FOR EACH tt :
            EXPORT DELIMITER ";" tt .
        END.
        PUT UNFORMATTED "end" SKIP.
         */

        FOR EACH tt BREAK BY tt_acc BY tt_sub BY tt_ctr 
            BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt BY tt_ref BY tt_line :
            IF FIRST-OF(tt_ctr) THEN DO:
                v_acc_sub = "" .
                v_acc_sub_desc = "" .
                FIND FIRST ac_mstr WHERE ac_code = tt_acc NO-LOCK NO-ERROR.
                IF AVAIL ac_mstr AND ac_code <> "" THEN DO:
                    v_acc_sub = ac_code .
                    v_acc_sub_desc = ac_desc .
                END.
                FIND FIRST sb_mstr WHERE sb_sub = tt_sub NO-LOCK NO-ERROR.
                IF AVAIL sb_mstr AND sb_sub <> "" THEN DO:
                    v_acc_sub = v_acc_sub + "-" + sb_sub .
                    v_acc_sub_desc = v_acc_sub_desc + "-" + sb_desc .
                END.
                v_cc = "".
                v_cc_desc = "" .
                FIND FIRST cc_mstr WHERE cc_ctr = tt_ctr NO-LOCK NO-ERROR.
                IF AVAIL cc_mstr AND cc_ctr <> "" THEN DO:
                    v_cc = cc_ctr .
                    v_cc_desc = cc_desc  .
                    v_cc_desc = "[" + v_cc_desc + "]" .
                END.
    
                RUN dispheadcurr.
    
                v_tot_amt = 0.
                v_tot_curramt = 0.
                FIND FIRST ttbeg WHERE ttbeg_acc = tt_acc
                    AND ttbeg_sub = tt_sub
                    AND ttbeg_ctr = tt_ctr NO-LOCK NO-ERROR.
                IF AVAIL ttbeg THEN DO:
                    IF tt_curr <> "RMB" THEN DO:
                        PUT UNFORMATTED ";" ";" ";" "期初余额" ";"  .
                        IF ttbeg_amt > 0 THEN do:
                            PUT UNFORMATTED ";" ";" ";" ";" ";"
                                "借" ";" ttbeg_curramt ";".
                            IF ttbeg_curramt = 0 THEN PUT UNFORMATTED ";" .
                            ELSE PUT UNFORMATTED ttbeg_amt / ttbeg_curramt ";" .
                            PUT UNFORMATTED "借" ";" ttbeg_amt SKIP.  
                        END.
                        ELSE IF ttbeg_amt < 0 THEN DO: 
                            PUT UNFORMATTED ";" ";" ";" ";" ";"
                                "贷" ";" abs(ttbeg_curramt) ";".
                            IF ttbeg_curramt = 0 THEN PUT UNFORMATTED ";" .
                            ELSE PUT UNFORMATTED abs(ttbeg_amt / ttbeg_curramt) ";".
                            PUT UNFORMATTED "贷" ";" abs(ttbeg_amt) SKIP. 
                        END.
                        ELSE DO:
                            PUT UNFORMATTED ";" ";" ";" ";" ";"
                                "平" ";" ";" ";" 
                                "平" ";" SKIP. 
                        END.
                    END.         
                    ELSE DO:
                        PUT UNFORMATTED ";" ";" ";" "期初余额" ";"  .
                        IF ttbeg_amt > 0 THEN do:
                            PUT UNFORMATTED ";" ";" ";" ";" ";"
                                ";" ";" ";"
                                "借" ";" ttbeg_amt SKIP.  
                        END.
                        ELSE IF ttbeg_amt < 0 THEN DO: 
                            PUT UNFORMATTED ";" ";" ";" ";" ";"
                                ";" ";" ";"
                                "贷" ";" abs(ttbeg_amt) SKIP. 
                        END.
                        ELSE DO:
                            PUT UNFORMATTED ";" ";" ";" ";" ";"
                                ";" ";" ";"
                                "平" ";" SKIP. 
                        END.
                    END.        
                    i = i + 1.
                    v_tot_amt = ttbeg_amt .
                    v_tot_curramt = ttbeg_curramt .
                END.
                ELSE DO:
                    IF tt_curr <> "RMB" THEN DO:
                        PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";"
                                        "平" ";" ";" ";" 
                                        "平" ";" SKIP. 
                    END.
                    ELSE DO:
                            PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";"
                                ";" ";" ";"
                                "平" ";" SKIP.
                    END.
                    i = i + 1.
                END.
            END. /* IF FIRST-OF(tt_ctr) THEN DO: */

            /*
            MESSAGE "1 /" + STRING(v_tot_curramt) + "/" + STRING(tt_dr_curramt) + "/" + STRING(tt_cr_curramt) VIEW-AS ALERT-BOX.
              */

            IF tt_eff_dt <> ? THEN DO:
                PUT UNFORMATTED STRING(YEAR(tt_eff_dt)) + "." + 
                                STRING(MONTH(tt_eff_dt)) + "." + 
                                STRING(DAY(tt_eff_dt)) ";" .
            END.
            ELSE PUT UNFORMATTED ";" .
            PUT UNFORMATTED 
                tt_ref ";"
                tt_line ";"
                tt_desc ";"     .

            IF tt_curr <> "RMB" THEN DO:
                IF tt_ex_rate = 0 THEN PUT UNFORMATTED ";"  .
                ELSE PUT UNFORMATTED tt_ex_rate2 / tt_ex_rate ";" .
                PUT UNFORMATTED 
                    tt_dr_curramt ";"
                    tt_dr_amt ";" 
                    tt_cr_curramt ";" 
                    tt_cr_amt ";" .
        
                v_tot_amt = v_tot_amt + tt_dr_amt - tt_cr_amt .
                v_tot_curramt = v_tot_curramt + tt_dr_curramt - tt_cr_curramt .  
                IF v_tot_amt > 0 THEN DO: 
                    PUT UNFORMATTED "借" ";" v_tot_curramt ";" .
                    IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";".
                    ELSE PUT UNFORMATTED v_tot_amt / v_tot_curramt ";" .
                    PUT UNFORMATTED "借" ";" v_tot_amt SKIP. 
                END.
                ELSE IF v_tot_amt < 0 THEN DO: 
                    PUT UNFORMATTED "贷" ";" abs(v_tot_curramt) ";" .
                    IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";" .
                    ELSE PUT UNFORMATTED abs(v_tot_amt / v_tot_curramt) ";" .
                    PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP.
                END.
                ELSE PUT UNFORMATTED "平" ";" ";" ";" "平" ";" SKIP.
                i = i + 1.
            END.
            ELSE DO:
                PUT UNFORMATTED 
                    ";"
                    ";"
                    tt_dr_amt ";" 
                    ";" 
                    tt_cr_amt ";" .
        
                v_tot_amt = v_tot_amt + tt_dr_amt - tt_cr_amt .
                v_tot_curramt = v_tot_curramt + tt_dr_curramt - tt_cr_curramt .  
                IF v_tot_amt > 0 THEN PUT UNFORMATTED ";" ";" ";" "借" ";" v_tot_amt SKIP. 
                ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED ";" ";" ";" "贷" ";" abs(v_tot_amt) SKIP.
                ELSE PUT UNFORMATTED ";" ";" ";" "平" ";" SKIP.
                i = i + 1.
            END.

            /*
            MESSAGE "2 /" + STRING(v_tot_curramt) + "/" + STRING(tt_dr_curramt) + "/" + STRING(tt_cr_curramt) VIEW-AS ALERT-BOX.
              */

            IF i = 37 THEN DO:
                PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
            END. 

            IF i >= 40 THEN DO:
                RUN dispheadcurr.
            END.
    
            ACCUMULATE tt_dr_amt ( TOTAL BY tt_acc BY tt_sub BY tt_ctr BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).
            ACCUMULATE tt_cr_amt ( TOTAL BY tt_acc BY tt_sub BY tt_ctr BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).
            ACCUMULATE tt_dr_curramt ( TOTAL BY tt_acc BY tt_sub BY tt_ctr BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).
            ACCUMULATE tt_cr_curramt ( TOTAL BY tt_acc BY tt_sub BY tt_ctr BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).

            IF LAST-OF(MONTH(tt_eff_dt)) THEN DO:
                IF tt_curr <> "RMB" THEN DO:
                    PUT UNFORMATTED ";" ";" ";" "本月合计" ";" ";"
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_dr_curramt) ";" 
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_dr_amt) ";" 
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_cr_curramt) ";"
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_cr_amt) ";"  .
        
                    IF v_tot_amt > 0 THEN do: 
                        PUT UNFORMATTED "借" ";" v_tot_curramt ";" .
                        IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";" .
                        ELSE PUT UNFORMATTED v_tot_amt / v_tot_curramt ";".
                        PUT UNFORMATTED "借" ";" v_tot_amt SKIP. 
                    END.
                    ELSE IF v_tot_amt < 0 THEN do:
                        PUT UNFORMATTED "贷" ";" abs(v_tot_curramt) ";" .
                        IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";" .
                        ELSE PUT UNFORMATTED abs(v_tot_amt / v_tot_curramt) ";".
                        PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP.
                    END.
                    ELSE PUT UNFORMATTED "平" ";" ";" ";" "平" ";" SKIP.
                END.
                ELSE DO:
                    PUT UNFORMATTED ";" ";" ";" "本月合计" ";" ";"
                        ";" 
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_dr_amt) ";" 
                        ";"
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_cr_amt) ";"  .
        
                    IF v_tot_amt > 0 THEN PUT UNFORMATTED ";" ";" ";" "借" ";" v_tot_amt SKIP. 
                    ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED ";" ";" ";" "贷" ";" abs(v_tot_amt) SKIP.
                    ELSE PUT UNFORMATTED ";" ";" ";" "平" ";" SKIP.
                END.
                i = i + 1.
                IF i = 37 THEN DO:
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                END. 
                IF i >= 40 THEN DO:
                    RUN dispheadcurr.
                END.
            END.
            IF LAST-OF(YEAR(tt_eff_dt)) THEN DO:
                IF tt_curr <> "RMB" THEN DO:
                    PUT UNFORMATTED ";" ";" ";" "本年累计" ";" ";"
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_dr_curramt) ";" 
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_dr_amt) ";" 
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_cr_curramt) ";" 
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_cr_amt) ";" .
        
                    IF v_tot_amt > 0 THEN do:
                        PUT UNFORMATTED "借" ";" v_tot_curramt ";".
                        IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";" .
                        ELSE PUT UNFORMATTED v_tot_amt / v_tot_curramt ";" .
                        PUT UNFORMATTED "借" ";" v_tot_amt SKIP. 
                    END.
                    ELSE IF v_tot_amt < 0 THEN do:
                        PUT UNFORMATTED "贷" ";" abs(v_tot_curramt) ";".
                        IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";".
                        ELSE PUT UNFORMATTED abs(v_tot_amt / v_tot_curramt) ";".
                        PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP.
                    END.
                    ELSE PUT UNFORMATTED "平" ";" ";" ";" "平" ";" SKIP.   
                END.
                ELSE DO:
                    PUT UNFORMATTED ";" ";" ";" "本年累计" ";" ";"
                        ";" 
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_dr_amt) ";" 
                        ";" 
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_cr_amt) ";" .
        
                    IF v_tot_amt > 0 THEN PUT UNFORMATTED ";" ";" ";" "借" ";" v_tot_amt SKIP. 
                    ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED ";" ";" ";" "贷" ";" abs(v_tot_amt) SKIP.
                    ELSE PUT UNFORMATTED ";" ";" ";" "平" ";" SKIP.   
                END.
                i = i + 1.

                jjj = i .
                IF 37 - i > 0 THEN DO:
                    DO jj = 1 TO (37 - jjj) :
                        PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP.
                        i = i + 1.
                    END.           
                END.

                IF i = 37 THEN DO:
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                END.
            END.
        END. /* FOR EACH tt */        
    END. /* IF subflag = NO AND ctrflag = NO THEN DO: */

    IF subflag = NO AND ctrflag = YES THEN DO:
        j = 0.
        FOR EACH tt BREAK BY tt_acc BY tt_sub 
            BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt BY tt_ref BY tt_line :
            IF FIRST-OF(tt_sub) THEN DO:
                v_acc_sub = "" .
                v_acc_sub_desc = "" .
                FIND FIRST ac_mstr WHERE ac_code = tt_acc NO-LOCK NO-ERROR.
                IF AVAIL ac_mstr AND ac_code <> "" THEN DO:
                    v_acc_sub = ac_code .
                    v_acc_sub_desc = ac_desc .
                END.
                FIND FIRST sb_mstr WHERE sb_sub = tt_sub NO-LOCK NO-ERROR.
                IF AVAIL sb_mstr AND sb_sub <> "" THEN DO:
                    v_acc_sub = v_acc_sub + "-" + sb_sub .
                    v_acc_sub_desc = v_acc_sub_desc + "-" + sb_desc .
                END.
                v_cc = "".
                v_cc_desc = "" .
                    
                RUN dispheadcurr.
    
                v_tot_amt = 0.
                v_tot_curramt = 0.
                v_beg_amt = 0.
                v_beg_curramt = 0.
                FOR EACH ttbeg WHERE ttbeg_acc = tt_acc
                    AND ttbeg_sub = tt_sub :
                    v_beg_amt = v_beg_amt + ttbeg_amt.
                    v_beg_curramt = v_beg_curramt + ttbeg_curramt.
                END.
                IF tt_curr <> "RMB" THEN DO:
                    PUT UNFORMATTED ";" ";" ";" "期初余额" ";" ";" .
                    IF v_beg_amt > 0 THEN do:
                        PUT UNFORMATTED ";" ";" ";" ";" 
                            "借" ";" v_beg_curramt ";".
                        IF v_beg_curramt = 0 THEN PUT UNFORMATTED ";" .
                        ELSE PUT UNFORMATTED v_beg_amt / v_beg_curramt ";".
                        PUT UNFORMATTED "借" ";" v_beg_amt SKIP.  
                        i = i + 1.
                    END.
                    ELSE IF v_beg_amt < 0 THEN DO: 
                        PUT UNFORMATTED ";" ";" ";" ";"
                            "贷" ";" abs(v_beg_curramt) ";".
                        IF v_beg_curramt = 0 THEN PUT UNFORMATTED ";" .
                        ELSE PUT UNFORMATTED abs(v_beg_amt / v_beg_curramt) ";" .
                        PUT UNFORMATTED "贷" ";" abs(v_beg_amt) SKIP. 
                        i = i + 1.
                    END.
                    ELSE DO:
                        PUT UNFORMATTED ";" ";" ";" ";" 
                            "平" ";" ";" ";" 
                            "平" ";" SKIP. 
                        i = i + 1.
                    END.
                END.         
                ELSE DO:
                    PUT UNFORMATTED ";" ";" ";" "期初余额" ";" ";"  .
                    IF v_beg_amt > 0 THEN do:
                        PUT UNFORMATTED ";" ";" ";" ";" 
                            ";" ";" ";"
                            "借" ";" v_beg_amt SKIP.  
                        i = i + 1.
                    END.
                    ELSE IF v_beg_amt < 0 THEN DO: 
                        PUT UNFORMATTED ";" ";" ";" ";" 
                            ";" ";" ";"
                            "贷" ";" abs(v_beg_amt) SKIP. 
                        i = i + 1.
                    END.
                    ELSE DO:
                        PUT UNFORMATTED ";" ";" ";" ";" 
                            ";" ";" ";"
                            "平" ";" SKIP. 
                        i = i + 1.
                    END.
                END.        
                v_tot_amt = v_beg_amt .
                v_tot_curramt = v_beg_curramt .
            END. /* IF FIRST-OF(tt_ctr) THEN DO: */
    
            IF tt_eff_dt <> ? THEN DO:
                PUT UNFORMATTED STRING(YEAR(tt_eff_dt)) + "." + 
                                STRING(MONTH(tt_eff_dt)) + "." + 
                                STRING(DAY(tt_eff_dt)) ";" .
            END.
            ELSE PUT UNFORMATTED ";" .
            PUT UNFORMATTED 
                tt_ref ";"
                tt_line ";"
                tt_desc ";"     .

            IF tt_curr <> "RMB" THEN DO:
                IF tt_ex_rate = 0 THEN PUT UNFORMATTED ";" .
                ELSE PUT UNFORMATTED tt_ex_rate2 / tt_ex_rate ";".
                PUT UNFORMATTED 
                    tt_dr_curramt ";"
                    tt_dr_amt ";" 
                    tt_cr_curramt ";" 
                    tt_cr_amt ";" .
        
                v_tot_amt = v_tot_amt + tt_dr_amt - tt_cr_amt .
                v_tot_curramt = v_tot_curramt + tt_dr_curramt - tt_cr_curramt .  
                IF v_tot_amt > 0 THEN do:
                    PUT UNFORMATTED "借" ";" v_tot_curramt ";".
                    IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";" .
                    ELSE PUT UNFORMATTED v_tot_amt / v_tot_curramt ";".
                    PUT UNFORMATTED "借" ";" v_tot_amt SKIP. 
                END.
                ELSE IF v_tot_amt < 0 THEN do:
                    PUT UNFORMATTED "贷" ";" abs(v_tot_curramt) ";".
                    IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";" .
                    ELSE PUT UNFORMATTED abs(v_tot_amt / v_tot_curramt) ";".
                    PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP.
                END.
                ELSE PUT UNFORMATTED "平" ";" ";" ";" "平" ";" SKIP.
                i = i + 1.
            END.
            ELSE DO:
                PUT UNFORMATTED 
                    ";"
                    ";"
                    tt_dr_amt ";" 
                    ";" 
                    tt_cr_amt ";" .
        
                v_tot_amt = v_tot_amt + tt_dr_amt - tt_cr_amt .
                v_tot_curramt = v_tot_curramt + tt_dr_curramt - tt_cr_curramt .  
                IF v_tot_amt > 0 THEN PUT UNFORMATTED ";" ";" ";" "借" ";" v_tot_amt SKIP. 
                ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED ";" ";" ";" "贷" ";" abs(v_tot_amt) SKIP.
                ELSE PUT UNFORMATTED ";" ";" ";" "平" ";" SKIP.
                i = i + 1.
            END.

            IF i = 37 THEN DO:
                PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
            END. 

            IF i >= 40 THEN DO:
                RUN dispheadcurr.
            END.
    
            ACCUMULATE tt_dr_amt ( TOTAL BY tt_acc BY tt_sub BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).
            ACCUMULATE tt_cr_amt ( TOTAL BY tt_acc BY tt_sub BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).
            ACCUMULATE tt_dr_curramt ( TOTAL BY tt_acc BY tt_sub BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).
            ACCUMULATE tt_cr_curramt ( TOTAL BY tt_acc BY tt_sub BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).

            IF LAST-OF(MONTH(tt_eff_dt)) THEN DO:
                IF tt_curr <> "RMB" THEN DO:
                    PUT UNFORMATTED ";" ";" ";" "本月合计" ";" ";"
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_dr_curramt) ";" 
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_dr_amt) ";" 
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_cr_curramt) ";"
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_cr_amt) ";"  .
        
                    IF v_tot_amt > 0 THEN do:
                        PUT UNFORMATTED "借" ";" v_tot_curramt ";".
                        IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";" .
                        ELSE PUT UNFORMATTED v_tot_amt / v_tot_curramt ";".
                        PUT UNFORMATTED "借" ";" v_tot_amt SKIP. 
                    END.
                    ELSE IF v_tot_amt < 0 THEN do:
                        PUT UNFORMATTED "贷" ";" abs(v_tot_curramt) ";".
                        IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";" .
                        ELSE PUT UNFORMATTED abs(v_tot_amt / v_tot_curramt) ";".
                        PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP.
                    END.
                    ELSE PUT UNFORMATTED "平" ";" ";" ";" "平" ";" SKIP.
                END.
                ELSE DO:
                    PUT UNFORMATTED ";" ";" ";" "本月合计" ";" ";"
                        ";" 
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_dr_amt) ";" 
                        ";"
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_cr_amt) ";"  .
        
                    IF v_tot_amt > 0 THEN PUT UNFORMATTED ";" ";" ";" "借" ";" v_tot_amt SKIP. 
                    ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED ";" ";" ";" "贷" ";" abs(v_tot_amt) SKIP.
                    ELSE PUT UNFORMATTED ";" ";" ";" "平" ";" SKIP.
                END.
                i = i + 1.
                IF i = 37 THEN DO:
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                END. 

                IF i >= 40 THEN DO:
                    RUN dispheadcurr.
                END.
            END.
            IF LAST-OF(YEAR(tt_eff_dt)) THEN DO:
                IF tt_curr <> "RMB" THEN DO:
                    PUT UNFORMATTED ";" ";" ";" "本年累计" ";" ";"
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_dr_curramt) ";" 
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_dr_amt) ";" 
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_cr_curramt) ";" 
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_cr_amt) ";" .
        
                    IF v_tot_amt > 0 THEN do:
                        PUT UNFORMATTED "借" ";" v_tot_curramt ";".
                        IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";" .
                        ELSE PUT UNFORMATTED v_tot_amt / v_tot_curramt ";".
                        PUT UNFORMATTED "借" ";" v_tot_amt SKIP. 
                    END.
                    ELSE IF v_tot_amt < 0 THEN do:
                        PUT UNFORMATTED "贷" ";" abs(v_tot_curramt) ";".
                        IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";" .
                        ELSE PUT UNFORMATTED abs(v_tot_amt / v_tot_curramt) ";".
                        PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP.
                    END.
                    ELSE PUT UNFORMATTED "平" ";" ";" ";" "平" ";" SKIP.   
                END.
                ELSE DO:
                    PUT UNFORMATTED ";" ";" ";" "本年累计" ";" ";"
                        ";" 
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_dr_amt) ";" 
                        ";" 
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_cr_amt) ";" .
        
                    IF v_tot_amt > 0 THEN PUT UNFORMATTED ";" ";" ";" "借" ";" v_tot_amt SKIP. 
                    ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED ";" ";" ";" "贷" ";" abs(v_tot_amt) SKIP.
                    ELSE PUT UNFORMATTED ";" ";" ";" "平" ";" SKIP.   
                END.
                i = i + 1.

                jjj = i .
                IF 37 - i > 0 THEN DO:
                    DO jj = 1 TO (37 - jjj) :
                        PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP.
                        i = i + 1.
                    END.           
                END.

                IF i = 37 THEN DO:
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                END. 
            END.
        END. /* FOR EACH tt */        
    END. /* IF subflag = NO AND ctrflag = YES THEN DO: */

    IF subflag = YES AND ctrflag = YES THEN DO:
        j = 0.
        FOR EACH tt BREAK BY tt_acc 
            BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt BY tt_ref BY tt_line :
            IF FIRST-OF(tt_acc) THEN DO:
                v_acc_sub = "" .
                v_acc_sub_desc = "" .
                FIND FIRST ac_mstr WHERE ac_code = tt_acc NO-LOCK NO-ERROR.
                IF AVAIL ac_mstr AND ac_code <> "" THEN DO:
                    v_acc_sub = ac_code .
                    v_acc_sub_desc = ac_desc .
                END.  
                v_cc = "".
                v_cc_desc = "" .
                    
                RUN dispheadcurr.
    
                v_tot_amt = 0.
                v_tot_curramt = 0.
                v_beg_amt = 0.
                v_beg_curramt = 0.
                FOR EACH ttbeg WHERE ttbeg_acc = tt_acc :
                    v_beg_amt = v_beg_amt + ttbeg_amt.
                    v_beg_curramt = v_beg_curramt + ttbeg_curramt.
                END.
                IF tt_curr <> "RMB" THEN DO:
                    PUT UNFORMATTED ";" ";" ";" "期初余额" ";" ";"  .
                    IF v_beg_amt > 0 THEN do:
                        PUT UNFORMATTED ";" ";" ";" ";" 
                            "借" ";" v_beg_curramt ";".
                        IF v_beg_curramt = 0 THEN PUT UNFORMATTED ";" .
                        ELSE PUT UNFORMATTED v_beg_amt / v_beg_curramt ";" .
                        PUT UNFORMATTED "借" ";" v_beg_amt SKIP.  
                        i = i + 1.
                    END.
                    ELSE IF v_beg_amt < 0 THEN DO: 
                        PUT UNFORMATTED ";" ";" ";" ";" 
                            "贷" ";" abs(v_beg_curramt) ";".
                        IF v_beg_curramt = 0 THEN PUT UNFORMATTED ";" .
                        ELSE PUT UNFORMATTED abs(v_beg_amt / v_beg_curramt) ";".
                        PUT UNFORMATTED "贷" ";" abs(v_beg_amt) SKIP. 
                        i = i + 1.
                    END.
                    ELSE DO:
                        PUT UNFORMATTED ";" ";" ";" ";" 
                            "平" ";" ";" ";" 
                            "平" ";" SKIP. 
                        i = i + 1.
                    END.
                END.         
                ELSE DO:
                    PUT UNFORMATTED ";" ";" ";" "期初余额" ";" ";" .
                    IF v_beg_amt > 0 THEN do:
                        PUT UNFORMATTED ";" ";" ";" ";" 
                            ";" ";" ";"
                            "借" ";" v_beg_amt SKIP.  
                        i = i + 1.
                    END.
                    ELSE IF v_beg_amt < 0 THEN DO: 
                        PUT UNFORMATTED ";" ";" ";" ";" 
                            ";" ";" ";"
                            "贷" ";" abs(v_beg_amt) SKIP. 
                        i = i + 1.
                    END.
                    ELSE DO:
                        PUT UNFORMATTED ";" ";" ";" ";" 
                            ";" ";" ";"
                            "平" ";" SKIP. 
                        i = i + 1.
                    END.
                END.        
                v_tot_amt = v_beg_amt .
                v_tot_curramt = v_beg_curramt .
            END. /* IF FIRST-OF(tt_ctr) THEN DO: */
    
            IF tt_eff_dt <> ? THEN DO:
                PUT UNFORMATTED STRING(YEAR(tt_eff_dt)) + "." + 
                                STRING(MONTH(tt_eff_dt)) + "." + 
                                STRING(DAY(tt_eff_dt)) ";" .
            END.
            ELSE PUT UNFORMATTED ";" .
            PUT UNFORMATTED 
                tt_ref ";"
                tt_line ";"
                tt_desc ";"     .

            IF tt_curr <> "RMB" THEN DO:
                IF tt_ex_rate = 0 THEN PUT UNFORMATTED ";" .
                ELSE PUT UNFORMATTED tt_ex_rate2 / tt_ex_rate ";".
                PUT UNFORMATTED
                    tt_dr_curramt ";"
                    tt_dr_amt ";" 
                    tt_cr_curramt ";" 
                    tt_cr_amt ";" .
        
                v_tot_amt = v_tot_amt + tt_dr_amt - tt_cr_amt .
                v_tot_curramt = v_tot_curramt + tt_dr_curramt - tt_cr_curramt .  
                IF v_tot_amt > 0 THEN do:
                    PUT UNFORMATTED "借" ";" v_tot_curramt ";" .
                    IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";" .
                    ELSE PUT UNFORMATTED v_tot_amt / v_tot_curramt ";".
                    PUT UNFORMATTED "借" ";" v_tot_amt SKIP. 
                END.
                ELSE IF v_tot_amt < 0 THEN do:
                    PUT UNFORMATTED "贷" ";" abs(v_tot_curramt) ";".
                    IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";" .
                    ELSE PUT UNFORMATTED abs(v_tot_amt / v_tot_curramt) ";".
                    PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP.
                END.
                ELSE PUT UNFORMATTED "平" ";" ";" ";" "平" ";" SKIP.
                i = i + 1.
            END.
            ELSE DO:
                PUT UNFORMATTED 
                    ";"
                    ";"
                    tt_dr_amt ";" 
                    ";" 
                    tt_cr_amt ";" .
        
                v_tot_amt = v_tot_amt + tt_dr_amt - tt_cr_amt .
                v_tot_curramt = v_tot_curramt + tt_dr_curramt - tt_cr_curramt .  
                IF v_tot_amt > 0 THEN PUT UNFORMATTED ";" ";" ";" "借" ";" v_tot_amt SKIP. 
                ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED ";" ";" ";" "贷" ";" abs(v_tot_amt) SKIP.
                ELSE PUT UNFORMATTED ";" ";" ";" "平" ";" SKIP.
                i = i + 1.
            END.

            IF i = 37 THEN DO:
                PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
            END. 
            IF i >= 40 THEN DO:
                RUN dispheadcurr.
            END.
    
            ACCUMULATE tt_dr_amt ( TOTAL BY tt_acc BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).
            ACCUMULATE tt_cr_amt ( TOTAL BY tt_acc BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).
            ACCUMULATE tt_dr_curramt ( TOTAL BY tt_acc BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).
            ACCUMULATE tt_cr_curramt ( TOTAL BY tt_acc BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).

            IF LAST-OF(MONTH(tt_eff_dt)) THEN DO:
                IF tt_curr <> "RMB" THEN DO:
                    PUT UNFORMATTED ";" ";" ";" "本月合计" ";" ";"
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_dr_curramt) ";" 
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_dr_amt) ";" 
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_cr_curramt) ";"
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_cr_amt) ";"  .
        
                    IF v_tot_amt > 0 THEN do:
                        PUT UNFORMATTED "借" ";" v_tot_curramt ";".
                        IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";" .
                        ELSE PUT UNFORMATTED v_tot_amt / v_tot_curramt ";".
                        PUT UNFORMATTED "借" ";" v_tot_amt SKIP. 
                    END.
                    ELSE IF v_tot_amt < 0 THEN do:
                        PUT UNFORMATTED "贷" ";" abs(v_tot_curramt) ";".
                        IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";" .
                        ELSE PUT UNFORMATTED abs(v_tot_amt / v_tot_curramt) ";".
                        PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP.
                    END.
                    ELSE PUT UNFORMATTED "平" ";" ";" ";" "平" ";" SKIP.
                END.
                ELSE DO:
                    PUT UNFORMATTED ";" ";" ";" "本月合计" ";" ";"
                        ";" 
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_dr_amt) ";" 
                        ";"
                        (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_cr_amt) ";"  .
        
                    IF v_tot_amt > 0 THEN PUT UNFORMATTED ";" ";" ";" "借" ";" v_tot_amt SKIP. 
                    ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED ";" ";" ";" "贷" ";" abs(v_tot_amt) SKIP.
                    ELSE PUT UNFORMATTED ";" ";" ";" "平" ";" SKIP.
                END.
                i = i + 1.
                IF i = 37 THEN DO:
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                END. 
                IF i >= 40 THEN DO:
                    RUN dispheadcurr.
                END.
            END.
            IF LAST-OF(YEAR(tt_eff_dt)) THEN DO:
                IF tt_curr <> "RMB" THEN DO:
                    PUT UNFORMATTED ";" ";" ";" "本年累计" ";" ";"
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_dr_curramt) ";" 
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_dr_amt) ";" 
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_cr_curramt) ";" 
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_cr_amt) ";" .
        
                    IF v_tot_amt > 0 THEN do:
                        PUT UNFORMATTED "借" ";" v_tot_curramt ";".
                        IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";" .
                        ELSE PUT UNFORMATTED v_tot_amt / v_tot_curramt ";".
                        PUT UNFORMATTED "借" ";" v_tot_amt SKIP. 
                    END.
                    ELSE IF v_tot_amt < 0 THEN do:
                        PUT UNFORMATTED "贷" ";" abs(v_tot_curramt) ";".
                        IF v_tot_curramt = 0 THEN PUT UNFORMATTED ";" .
                        ELSE PUT UNFORMATTED abs(v_tot_amt / v_tot_curramt) ";".
                        PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP.
                    END.
                    ELSE PUT UNFORMATTED "平" ";" ";" ";" "平" ";" SKIP.   
                END.
                ELSE DO:
                    PUT UNFORMATTED ";" ";" ";" "本年累计" ";" ";"
                        ";" 
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_dr_amt) ";" 
                        ";" 
                        (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_cr_amt) ";" .
        
                    IF v_tot_amt > 0 THEN PUT UNFORMATTED ";" ";" ";" "借" ";" v_tot_amt SKIP. 
                    ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED ";" ";" ";" "贷" ";" abs(v_tot_amt) SKIP.
                    ELSE PUT UNFORMATTED ";" ";" ";" "平" ";" SKIP.   
                END.
                i = i + 1.

                jjj = i .
                IF 37 - i > 0 THEN DO:
                    DO jj = 1 TO (37 - jjj) :
                        PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP.
                        i = i + 1.
                    END.           
                END.

                IF i = 37 THEN DO:
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                END. 
            END.
        END. /* FOR EACH tt */        
    END. /* IF subflag = YES AND ctrflag = YES THEN DO: */    
END. /* IF vcurr = YES THEN DO: */ 
