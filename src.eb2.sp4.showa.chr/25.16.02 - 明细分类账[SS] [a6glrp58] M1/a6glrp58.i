DEF VAR v_username AS CHAR.
DEF VAR i AS INTEGER .
DEF VAR j AS INTEGER .
DEF VAR jj AS INTEGER .
DEF VAR jjj AS INTEGER .
DEF VAR v_acc_sub AS CHAR.
DEF VAR v_acc_sub_desc AS CHAR.
DEF VAR v_cc AS CHAR.
DEF VAR v_cc_desc AS CHAR.
DEF VAR v_tot_amt AS DECIMAL.
DEF VAR v_tot_curramt AS DECIMAL.
DEF VAR v_beg_amt AS DECIMAL.
DEF VAR v_beg_curramt AS DECIMAL.
DEF VAR printflag AS LOGICAL .

DEF TEMP-TABLE tt
    FIELD tt_ref LIKE glt_re
    FIELD tt_line LIKE glt_line
    FIELD tt_rflag LIKE glt_rflag
    FIELD tt_eff_dt LIKE glt_effdate
    FIELD tt_desc LIKE glt_desc
    FIELD tt_acc LIKE glt_acc
    FIELD tt_sub LIKE glt_sub
    FIELD tt_ctr LIKE glt_cc
    FIELD tt_curr LIKE glt_curr
    FIELD tt_dr_amt LIKE glt_amt
    FIELD tt_cr_amt LIKE glt_amt
    FIELD tt_dr_curramt LIKE glt_curr_amt
    FIELD tt_cr_curramt LIKE glt_curr_amt
    FIELD tt_ex_rate LIKE glt_ex_rate
    FIELD tt_ex_rate2 LIKE glt_ex_rate2
    INDEX ttref tt_ref tt_line tt_rflag
    .

DEF TEMP-TABLE ttbeg
    FIELD ttbeg_acc LIKE gltr_acc
    FIELD ttbeg_sub LIKE gltr_sub
    FIELD ttbeg_ctr LIKE gltr_ctr
    FIELD ttbeg_amt LIKE glt_amt
    FIELD ttbeg_curramt LIKE glt_curr_amt
    INDEX ttbeg ttbeg_acc ttbeg_sub ttbeg_ctr
    .

EMPTY TEMP-TABLE tt.                                           
EMPTY TEMP-TABLE ttbeg.
v_beg_amt = 0.
v_beg_curramt = 0.
FOR EACH gltr_hist NO-LOCK WHERE gltr_acc >= acc
    AND gltr_acc <= acc1
    AND gltr_sub >= sub
    AND gltr_sub <= sub1
    AND gltr_ctr >= ctr
    AND gltr_ctr <= ctr1
    AND gltr_eff_dt <= effdate1
    USE-INDEX gltr_acc_ctr ,
    EACH ac_mstr NO-LOCK WHERE ac_code  = gltr_acc 
    BREAK BY gltr_acc BY gltr_sub BY gltr_ctr BY gltr_eff_dt :
    IF gltr_eff_dt < effdate THEN DO:
        if lookup(ac_type, "A,L") = 0 then do:
            IF gltr_eff_dt >= DATE(1,1,YEAR(effdate)) AND gltr_eff_dt < effdate THEN DO:
               v_beg_amt = v_beg_amt + gltr_amt .
               v_beg_curramt = v_beg_curramt + gltr_curramt .
            END.
        END.
        ELSE DO:
               v_beg_amt = v_beg_amt + gltr_amt .
               v_beg_curramt = v_beg_curramt + gltr_curramt .
        END.
    END. /* IF gltr_eff_dt < effdate THEN DO: */
    ELSE DO:
        CREATE tt .
        ASSIGN
            tt_ref = gltr_ref
            tt_line = gltr_line
            tt_rflag = gltr_rflag
            tt_eff_dt = gltr_eff_dt
            tt_desc = gltr_desc
            tt_acc = gltr_acc
            tt_sub = gltr_sub
            tt_ctr = gltr_ctr
            tt_curr = ac_curr
            tt_ex_rate = gltr_ex_rate
            tt_ex_rate2 = gltr_ex_rate2
            .
        IF (gltr_amt >= 0 AND gltr_correction = FALSE) OR
           (gltr_amt <  0 AND gltr_correction = TRUE ) THEN DO:
            tt_dr_amt = gltr_amt.
            tt_dr_curramt = gltr_curramt.
        END.
        ELSE DO:
            tt_cr_amt = - gltr_amt.
            tt_cr_curramt = - gltr_curramt.
        END.
        /*
        IF gltr_curr = "RMB" THEN DO:
            tt_dr_curramt = tt_dr_amt .
            tt_cr_curramt = tt_cr_amt .
        END.*/
    END.

    /* 取期初原币和本币金额 */
    IF LAST-OF(gltr_ctr) THEN DO:
        CREATE ttbeg.
        ASSIGN
            ttbeg_acc = gltr_acc
            ttbeg_sub = gltr_sub
            ttbeg_ctr = gltr_ctr
            ttbeg_amt = v_beg_amt
            ttbeg_curramt = v_beg_curramt
            .
        /*
        IF gltr_curr = "RMB" THEN DO:
            ttbeg_curramt = ttbeg_amt .
        END.*/
        v_beg_amt = 0.
        v_beg_curramt = 0.
    END.     
END. /* FOR EACH gltr_hist */

IF inclpost = YES THEN DO:
    v_beg_amt = 0.
    v_beg_curramt = 0.
    FOR EACH glt_det NO-LOCK WHERE glt_acc >= acc
        AND glt_acc <= acc1
        AND glt_sub >= sub
        AND glt_sub <= sub1
        AND glt_cc >= ctr
        AND glt_cc <= ctr1
        AND glt_effdate <= effdate1
        USE-INDEX glt_index ,
        EACH ac_mstr NO-LOCK WHERE ac_code  = glt_acc 
        BREAK BY glt_acc BY glt_sub BY glt_cc BY glt_effdate :
        IF glt_effdate < effdate THEN DO:
            if lookup(ac_type, "A,L") = 0 then do:
                IF glt_effdate >= DATE(1,1,YEAR(effdate)) AND glt_effdate < effdate THEN DO:
                   v_beg_amt = v_beg_amt + glt_amt .
                   v_beg_curramt = v_beg_curramt + glt_curr_amt .
                END.
            END.
            ELSE DO:
                   v_beg_amt = v_beg_amt + glt_amt .
                   v_beg_curramt = v_beg_curramt + glt_curr_amt .
            END.
        END. /* IF gltr_eff_dt < effdate THEN DO: */
        ELSE DO:
            CREATE tt .
            ASSIGN
                tt_ref = glt_ref
                tt_line = glt_line
                tt_rflag = glt_rflag
                tt_eff_dt = glt_effdate
                tt_desc = glt_desc
                tt_acc = glt_acc
                tt_sub = glt_sub
                tt_ctr = glt_cc
                tt_curr = ac_curr
                tt_ex_rate = glt_ex_rate
                tt_ex_rate2 = glt_ex_rate2
                .
            IF (glt_amt >= 0 AND glt_correction = FALSE) OR
               (glt_amt <  0 AND glt_correction = TRUE ) THEN DO:
                tt_dr_amt = glt_amt.
                tt_dr_curramt = glt_curr_amt.
            END.
            ELSE DO:
                tt_cr_amt = - glt_amt.
                tt_cr_curramt = - glt_curr_amt.
            END.
        END.
        /*
        IF glt_curr = "RMB" THEN DO:
            tt_dr_curramt = tt_dr_amt .
            tt_cr_curramt = tt_cr_amt .
        END.*/
    
        /* 取期初原币和本币金额 */
        IF LAST-OF(glt_cc) THEN DO:
            FIND FIRST ttbeg WHERE ttbeg_acc = glt_acc 
                AND ttbeg_sub = glt_sub
                AND ttbeg_ctr = glt_cc NO-ERROR.
            IF AVAIL ttbeg THEN DO:
                ttbeg_amt = ttbeg_amt + v_beg_amt .
                ttbeg_curramt = ttbeg_curramt + v_beg_curramt.
                /*
                IF glt_curr = "RMB" THEN DO:
                    ttbeg_curramt = ttbeg_amt .
                END. */
            END.
            ELSE DO:
                CREATE ttbeg.
                ASSIGN
                    ttbeg_acc = glt_acc
                    ttbeg_sub = glt_sub
                    ttbeg_ctr = glt_cc
                    ttbeg_amt = v_beg_amt
                    ttbeg_curramt = v_beg_curramt
                    .
                /*
                IF glt_curr = "RMB" THEN DO:
                    ttbeg_curramt = ttbeg_amt .
                END. */
            END.
            v_beg_amt = 0.
            v_beg_curramt = 0.
        END.     
    END. /* FOR EACH glt_det */
END.

/* 只输出有发生额的科目 = no */
IF inclflag = NO THEN DO:
    FOR EACH ASC_mstr NO-LOCK WHERE ASC_acc >= acc
        AND ASC_acc <= acc1
        AND ASC_sub >= sub
        AND ASC_sub <= sub1
        AND ASC_cc >= ctr
        AND ASC_cc <= ctr1,
        EACH ac_mstr NO-LOCK WHERE ac_code = ASC_acc :
        FIND FIRST tt WHERE tt_acc = ASC_acc
            AND tt_sub = ASC_sub
            AND tt_ctr = ASC_cc NO-LOCK NO-ERROR.
        IF NOT AVAIL tt THEN DO:
            CREATE tt.
            ASSIGN
                tt_ref = ""
                tt_acc = ASC_acc
                tt_sub = ASC_sub
                tt_ctr = ASC_cc
                tt_curr = ac_curr
                .
        END.     
    END.     
END. /* IF inclflag = NO THEN DO: */

FIND FIRST usr_mstr WHERE usr_userid = global_userid NO-LOCK NO-ERROR.
IF AVAIL USr_mstr THEN DO:
    v_username = "由 " + usr_name + " 打印  " + "( 日期: " + string(YEAR(TODAY)) + "." + STRING(MONTH(TODAY)) + "." + STRING(DAY(TODAY)) + ", " + "时间: " + string(TIME,"HH:MM:SS") + " )" .
END.

/* 输出到BI */
IF vcurr = NO THEN DO:
    PUT UNFORMATTED "#def REPORTPATH=$/财务/BI报表/a6glrp581" SKIP.
END.
ELSE DO:
    PUT UNFORMATTED "#def REPORTPATH=$/财务/BI报表/a6glrp582" SKIP.
END.
PUT UNFORMATTED "#def :end" SKIP.
                    
IF vcurr = NO THEN DO:
    IF subflag = NO AND ctrflag = NO THEN DO:
        j = 0.
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
                    v_cc_desc = cc_desc .
                    v_cc_desc = "[" + v_cc_desc + "]" .
                END.
    
                RUN disphead.
    
                v_tot_amt = 0.
                FIND FIRST ttbeg WHERE ttbeg_acc = tt_acc
                    AND ttbeg_sub = tt_sub
                    AND ttbeg_ctr = tt_ctr NO-LOCK NO-ERROR.
                IF AVAIL ttbeg THEN DO:
                    PUT UNFORMATTED ";" ";" ";" "期初余额" ";" .
                    IF ttbeg_amt > 0 THEN do:
                        PUT UNFORMATTED ";" ";" "借" ";" ttbeg_amt SKIP.  
                        i = i + 1.
                    END.
                    ELSE IF ttbeg_amt < 0 THEN DO: 
                        PUT UNFORMATTED ";" ";" "贷" ";" abs(ttbeg_amt) SKIP. 
                        i = i + 1.
                    END.
                    ELSE DO:
                        PUT UNFORMATTED ";" ";" "平" ";" SKIP. 
                        i = i + 1.
                    END.
                    v_tot_amt = ttbeg_amt .
                END.
                ELSE DO:
                    PUT UNFORMATTED ";" ";" ";" "期初余额" ";" 
                        ";" ";" "平" ";" SKIP.
                    i = i + 1.
                END.
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
                tt_desc ";"
                tt_dr_amt ";"
                tt_cr_amt ";" .
    
            v_tot_amt = v_tot_amt + tt_dr_amt - tt_cr_amt .
            IF v_tot_amt > 0 THEN PUT UNFORMATTED "借" ";" abs(v_tot_amt) SKIP. 
            ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP. 
            ELSE PUT UNFORMATTED "平" ";" v_tot_amt SKIP.
            i = i + 1.
    
            IF i = 37 THEN DO:
                PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" SKIP. i = i + 1.
            END. 

            IF i >= 40 THEN DO:
                RUN disphead.
            END.
    
            ACCUMULATE tt_dr_amt ( TOTAL BY tt_acc BY tt_sub BY tt_ctr BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).
            ACCUMULATE tt_cr_amt ( TOTAL BY tt_acc BY tt_sub BY tt_ctr BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).
    
            IF LAST-OF(MONTH(tt_eff_dt)) THEN DO:
                PUT UNFORMATTED ";" ";" ";" "本月合计" ";" 
                    (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_dr_amt) ";" 
                    (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_cr_amt) ";" .
    
                IF v_tot_amt > 0 THEN PUT UNFORMATTED "借" ";" abs(v_tot_amt) SKIP. 
                ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP. 
                ELSE PUT UNFORMATTED "平" ";" v_tot_amt SKIP.
                i = i + 1.
                IF i = 37 THEN DO:
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" SKIP. i = i + 1.
                END. 
                IF i >= 40 THEN DO:
                    RUN disphead.
                END.
            END.
            IF LAST-OF(YEAR(tt_eff_dt)) THEN DO:
                PUT UNFORMATTED ";" ";" ";" "本年累计" ";" 
                    (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_dr_amt) ";" 
                    (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_cr_amt) ";" .
    
                IF v_tot_amt > 0 THEN PUT UNFORMATTED "借" ";" abs(v_tot_amt) SKIP. 
                ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP. 
                ELSE PUT UNFORMATTED "平" ";" v_tot_amt SKIP.
                i = i + 1.

                jjj = i .
                IF 37 - i > 0 THEN DO:
                    DO jj = 1 TO (37 - jjj) :
                        PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP.
                        i = i + 1.
                    END.           
                END.

                IF i = 37 THEN DO:
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" SKIP. i = i + 1.
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
    
                RUN disphead.
    
                v_tot_amt = 0.
                v_beg_amt = 0.
                FOR EACH ttbeg WHERE ttbeg_acc = tt_acc
                    AND ttbeg_sub = tt_sub : 
                    v_beg_amt = v_beg_amt + ttbeg_amt .
                END.
    
                PUT UNFORMATTED ";" ";" ";" "期初余额" ";" .
                IF v_beg_amt > 0 THEN do:
                    PUT UNFORMATTED ";" ";" "借" ";" v_beg_amt SKIP.  
                    i = i + 1.
                END.
                ELSE IF v_beg_amt < 0 THEN DO: 
                    PUT UNFORMATTED ";" ";" "贷" ";" abs(v_beg_amt) SKIP. 
                    i = i + 1.
                END.
                ELSE DO:
                    PUT UNFORMATTED ";" ";" "平" ";" SKIP. 
                    i = i + 1.
                END.
                v_tot_amt = v_beg_amt .
            END. /* IF FIRST-OF(tt_sub) THEN DO: */
    
            IF tt_eff_dt <> ? THEN DO:
            PUT UNFORMATTED STRING(YEAR(tt_eff_dt)) + "." + 
                            STRING(MONTH(tt_eff_dt)) + "." + 
                            STRING(DAY(tt_eff_dt)) ";" .
            END.
            ELSE PUT UNFORMATTED ";" .
            PUT UNFORMATTED 
                tt_ref ";"
                tt_line ";"
                tt_desc ";"
                tt_dr_amt ";"
                tt_cr_amt ";" .
    
            v_tot_amt = v_tot_amt + tt_dr_amt - tt_cr_amt .
            IF v_tot_amt > 0 THEN PUT UNFORMATTED "借" ";" abs(v_tot_amt) SKIP. 
            ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP. 
            ELSE PUT UNFORMATTED "平" ";" v_tot_amt SKIP.
            i = i + 1.
    
            IF i = 37 THEN DO:
                PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" SKIP. i = i + 1.
            END. 

            IF i >= 40 THEN DO:
                RUN disphead.
            END.
    
            ACCUMULATE tt_dr_amt ( TOTAL BY tt_acc BY tt_sub BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).
            ACCUMULATE tt_cr_amt ( TOTAL BY tt_acc BY tt_sub BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).
    
            IF LAST-OF(MONTH(tt_eff_dt)) THEN DO:
                PUT UNFORMATTED ";" ";" ";" "本月合计" ";" 
                    (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_dr_amt) ";" 
                    (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_cr_amt) ";" .
    
                IF v_tot_amt > 0 THEN PUT UNFORMATTED "借" ";" abs(v_tot_amt) SKIP. 
                ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP. 
                ELSE PUT UNFORMATTED "平" ";" v_tot_amt SKIP.
                i = i + 1.

                IF i = 37 THEN DO:
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" SKIP. i = i + 1.
                END. 

                IF i >= 40 THEN DO:
                    RUN disphead.
                END.
            END.
            IF LAST-OF(YEAR(tt_eff_dt)) THEN DO:
                PUT UNFORMATTED ";" ";" ";" "本年累计" ";" 
                    (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_dr_amt) ";" 
                    (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_cr_amt) ";" .
    
                IF v_tot_amt > 0 THEN PUT UNFORMATTED "借" ";" abs(v_tot_amt) SKIP. 
                ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP. 
                ELSE PUT UNFORMATTED "平" ";" v_tot_amt SKIP.
                i = i + 1. 

                jjj = i .
                IF 37 - i > 0 THEN DO:
                    DO jj = 1 TO (37 - jjj) :
                        PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP.
                        i = i + 1.
                    END.           
                END.

                IF i = 37 THEN DO:
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" SKIP. i = i + 1.
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
    
                RUN disphead.
    
                v_tot_amt = 0.
                v_beg_amt = 0.
                FOR EACH ttbeg WHERE ttbeg_acc = tt_acc : 
                    v_beg_amt = v_beg_amt + ttbeg_amt .
                END.
    
                PUT UNFORMATTED ";" ";" ";" "期初余额" ";" .
                IF v_beg_amt > 0 THEN do:
                    PUT UNFORMATTED ";" ";" "借" ";" v_beg_amt SKIP.  
                    i = i + 1.
                END.
                ELSE IF v_beg_amt < 0 THEN DO: 
                    PUT UNFORMATTED ";" ";" "贷" ";" abs(v_beg_amt) SKIP. 
                    i = i + 1.
                END.
                ELSE DO:
                    PUT UNFORMATTED ";" ";" "平" ";" SKIP. 
                    i = i + 1.
                END.
                v_tot_amt = v_beg_amt .
            END. /* IF FIRST-OF(tt_sub) THEN DO: */
    
            IF tt_eff_dt <> ? THEN DO:
            PUT UNFORMATTED STRING(YEAR(tt_eff_dt)) + "." + 
                            STRING(MONTH(tt_eff_dt)) + "." + 
                            STRING(DAY(tt_eff_dt)) ";" .
            END.
            ELSE PUT UNFORMATTED ";" .
            PUT UNFORMATTED 
                tt_ref ";"
                tt_line ";"
                tt_desc ";"
                tt_dr_amt ";"
                tt_cr_amt ";" .
    
            v_tot_amt = v_tot_amt + tt_dr_amt - tt_cr_amt .
            IF v_tot_amt > 0 THEN PUT UNFORMATTED "借" ";" abs(v_tot_amt) SKIP. 
            ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP. 
            ELSE PUT UNFORMATTED "平" ";" v_tot_amt SKIP.
            i = i + 1.
    
            IF i = 37 THEN DO:
                PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" SKIP. i = i + 1.
            END.

            IF i >= 40 THEN DO:
                RUN disphead.
            END.
    
            ACCUMULATE tt_dr_amt ( TOTAL BY tt_acc BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).
            ACCUMULATE tt_cr_amt ( TOTAL BY tt_acc BY YEAR(tt_eff_dt) BY MONTH(tt_eff_dt) BY tt_eff_dt ).
    
            IF LAST-OF(MONTH(tt_eff_dt)) THEN DO:
                PUT UNFORMATTED ";" ";" ";" "本月合计" ";" 
                    (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_dr_amt) ";" 
                    (ACCUMULATE TOTAL BY MONTH(tt_eff_dt) tt_cr_amt) ";" .
    
                IF v_tot_amt > 0 THEN PUT UNFORMATTED "借" ";" abs(v_tot_amt) SKIP. 
                ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP. 
                ELSE PUT UNFORMATTED "平" ";" v_tot_amt SKIP.
                i = i + 1.
                IF i = 37 THEN DO:
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" SKIP. i = i + 1.
                END.
                IF i >= 40 THEN DO:
                    RUN disphead.
                END.
            END.
            IF LAST-OF(YEAR(tt_eff_dt)) THEN DO:
                PUT UNFORMATTED ";" ";" ";" "本年累计" ";" 
                    (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_dr_amt) ";" 
                    (ACCUMULATE TOTAL BY YEAR(tt_eff_dt) tt_cr_amt) ";" .
    
                IF v_tot_amt > 0 THEN PUT UNFORMATTED "借" ";" abs(v_tot_amt) SKIP. 
                ELSE IF v_tot_amt < 0 THEN PUT UNFORMATTED "贷" ";" abs(v_tot_amt) SKIP. 
                ELSE PUT UNFORMATTED "平" ";" v_tot_amt SKIP.
                i = i + 1.

                jjj = i .
                IF 37 - i > 0 THEN DO:
                    DO jj = 1 TO (37 - jjj) :
                        PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP.
                        i = i + 1.
                    END.           
                END.

                IF i = 37 THEN DO:
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
                    PUT UNFORMATTED ";" ";" ";" v_username ";" ";" ";" ";" SKIP. i = i + 1.
                END.
            END.
        END. /* FOR EACH tt */ 
    END. /* IF subflag = YES AND ctrflag = YES THEN DO: */
END. /* IF vcurr = NO THEN DO: */

/* 显示原币格式 */
{dispcurr.i}

PROCEDURE disphead:          
    i = 0.
    j = j + 1.
    PUT UNFORMATTED ";" ";" ";" "广州昭和汽车零部件有限公司" ";"
        ";" ";" ";" SKIP. i = i + 1.
    PUT UNFORMATTED ";" ";" ";" "明细分类帐" ";" 
        ";" ";" ";"  SKIP. i = i + 1.
    PUT UNFORMATTED ";" ";" ";" STRING(YEAR(effdate),"9999") + "年" + 
            STRING(MONTH(effdate),"99") + "月" + STRING(DAY(effdate),"99") + "日" + 
            " 至 " +
            STRING(YEAR(effdate1),"9999") + "年" + 
            STRING(MONTH(effdate1),"99") + "月" + STRING(DAY(effdate1),"99") + "日" ";"
        ";" ";" ";" SKIP. i = i + 1.
    PUT UNFORMATTED "科目编号:" ";" v_acc_sub ";" ";" "[" + v_acc_sub_desc + "]" ";" 
        ";" ";" ";" "第" + STRING(j) + "页" SKIP.  i = i + 1.
    PUT UNFORMATTED "成本中心编号:" ";" v_cc ";" ";" v_cc_desc ";"
        ";" ";" ";" SKIP. i = i + 1. 
    PUT UNFORMATTED "记帐日期" ";" "凭证编号" ";" "项次" ";"
        "摘要" ";" ";" ";" "金额" ";"  SKIP. i = i + 1.
    PUT UNFORMATTED ";" ";" ";" ";" "借方" ";" 
        "贷方" ";" ";" "余额" SKIP. i = i + 1.
END PROCEDURE.

PROCEDURE dispheadcurr:          
    i = 0.
    j = j + 1.
    PUT UNFORMATTED ";" ";" ";" ";" ";" "广州昭和汽车零部件有限公司" ";" 
        ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
    PUT UNFORMATTED ";" ";" ";" ";" ";" "明细分类帐" ";"  
        ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
    PUT UNFORMATTED ";" ";" ";" ";" ";" STRING(YEAR(effdate),"9999") + "年" + 
            STRING(MONTH(effdate),"99") + "月" + STRING(DAY(effdate),"99") + "日" + 
            " 至 " +
            STRING(YEAR(effdate1),"9999") + "年" + 
            STRING(MONTH(effdate1),"99") + "月" + STRING(DAY(effdate1),"99") + "日"  ";" 
        ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1.
    PUT UNFORMATTED "科目编号:" ";" v_acc_sub ";" ";" "[" + v_acc_sub_desc + "]  " + "本位币: RMB" ";" 
        ";" ";" ";" ";" ";" ";" ";" ";" ";" "第" + STRING(j) + "页" SKIP.  i = i + 1.
    PUT UNFORMATTED "成本中心编号:" ";" v_cc ";" ";" v_cc_desc ";"
        ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP. i = i + 1. 
    PUT UNFORMATTED "记帐日期" ";" "凭证编号" ";" "项次" ";"
        "摘要" ";" "汇率" ";" "借方" ";" ";" "贷方" ";" ";" ";" ";" "余额" ";" ";"  SKIP. i = i + 1.
    PUT UNFORMATTED ";" ";" ";" ";" ";" "原币" ";" "本位币" ";" 
        "原币" ";" "本位币" ";" "原币" ";" ";" "汇率" ";" "本位币" ";"  SKIP. i = i + 1.
END PROCEDURE.
