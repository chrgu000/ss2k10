DEF TEMP-TABLE tt     
    FIELD tt_acc LIKE gltr_acc
    FIELD tt_ac_desc AS CHAR
    FIELD tt_beg_amt LIKE gltr_amt
    FIELD tt_beg_curramt LIKE gltr_amt
    FIELD tt_dr_amt LIKE gltr_amt
    FIELD tt_dr_curramt LIKE gltr_amt
    FIELD tt_cr_amt LIKE gltr_amt
    FIELD tt_cr_curramt LIKE gltr_amt
    FIELD tt_y_dr_amt LIKE gltr_amt
    FIELD tt_y_dr_curramt LIKE gltr_amt
    FIELD tt_y_cr_amt LIKE gltr_amt
    FIELD tt_y_cr_curramt LIKE gltr_amt
    INDEX index1 tt_acc 
    .

DEF TEMP-TABLE tt2 
    FIELD tt2_ref LIKE gltr_ref
    FIELD tt2_line LIKE gltr_line
    FIELD tt2_acc LIKE gltr_acc
    FIELD tt2_dr_amt LIKE gltr_amt
    FIELD tt2_cr_amt LIKE gltr_amt.

EMPTY TEMP-TABLE tt .
FIND FIRST glcd_det WHERE glcd_gl_clsd = NO 
    AND glcd_year = YEAR(effdate) NO-LOCK NO-ERROR.
IF AVAIL glcd_det THEN DO:
   v_effdate = DATE(glcd_per, 1, glcd_year)  .
END.
ELSE v_effdate = effdate .

IF vlevel = 1 THEN DO:
    v_beg_amt = 0.
    v_beg_curramt = 0.
    v_dr_amt = 0.
    v_cr_amt = 0.
    v_dr_curramt = 0.
    v_cr_curramt = 0.
    v_y_dr_amt = 0.
    v_y_cr_amt = 0.
    v_y_dr_curramt = 0.
    v_y_cr_curramt = 0.
    FOR EACH gltr_hist NO-LOCK 
        WHERE gltr_acc >= acc
        AND gltr_acc <= acc1
        AND gltr_eff_dt <= effdate1 
        USE-INDEX gltr_eff_dt ,
        EACH ac_mstr NO-LOCK 
        WHERE ac_code = gltr_acc 
        BREAK BY substring(gltr_acc,1,4) BY gltr_eff_dt :
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
            IF (gltr_amt >= 0 AND gltr_correction = FALSE) OR
               (gltr_amt <  0 AND gltr_correction = TRUE ) THEN DO:
                v_dr_amt = v_dr_amt + gltr_amt .
                v_dr_curramt = v_dr_curramt + gltr_curramt .
            END.
            ELSE DO:
                v_cr_amt = v_cr_amt - gltr_amt.
                v_cr_curramt = v_cr_curramt - gltr_curramt .
            END.
        END.
        IF gltr_eff_dt >= v_effdate THEN DO:
            IF (gltr_amt >= 0 AND gltr_correction = FALSE) OR
               (gltr_amt <  0 AND gltr_correction = TRUE ) THEN DO:
                v_y_dr_amt = v_y_dr_amt + gltr_amt .
                v_y_dr_curramt = v_y_dr_curramt + gltr_curramt .
            END.
            ELSE DO:
                v_y_cr_amt = v_y_cr_amt - gltr_amt.
                v_y_cr_curramt = v_y_cr_curramt - gltr_curramt .
            END.
        END.

        IF LAST-OF(substring(gltr_acc,1,4)) THEN DO:
            v_ac_desc = "".
            FIND FIRST acmstr WHERE substring(acmstr.ac_code,1,4) = SUBSTRING(gltr_acc,1,4) NO-LOCK NO-ERROR.
            IF AVAIL acmstr THEN DO:
                v_ac_desc = ENTRY(1,acmstr.ac_desc,"-" ) .
            END.

            CREATE tt .
            ASSIGN
                tt_acc = substring(gltr_acc,1,4)
                tt_ac_desc = v_ac_desc
                tt_beg_amt = v_beg_amt
                tt_beg_curramt = v_beg_curramt
                tt_dr_amt = v_dr_amt
                tt_dr_curramt = v_dr_curramt
                tt_cr_amt = v_cr_amt
                tt_cr_curramt = v_cr_curramt
                tt_y_dr_amt = v_y_dr_amt
                tt_y_dr_curramt = v_y_dr_curramt
                tt_y_cr_amt = v_y_cr_amt
                tt_y_cr_curramt = v_y_cr_curramt
                .
            v_beg_amt = 0.
            v_beg_curramt = 0.
            v_dr_amt = 0.
            v_cr_amt = 0.
            v_dr_curramt = 0.
            v_cr_curramt = 0.
            v_y_dr_amt = 0.
            v_y_cr_amt = 0.
            v_y_dr_curramt = 0.
            v_y_cr_curramt = 0.
        END.
    END. /* FOR EACH gltr_hist NO-LOCK  */
    IF inclpost = YES THEN DO:
        v_beg_amt = 0.
        v_beg_curramt = 0.
        v_dr_amt = 0.
        v_cr_amt = 0.
        v_dr_curramt = 0.
        v_cr_curramt = 0.
        v_y_dr_amt = 0.
        v_y_cr_amt = 0.
        v_y_dr_curramt = 0.
        v_y_cr_curramt = 0.
        FOR EACH glt_det NO-LOCK 
            WHERE glt_acc >= acc
            AND glt_acc <= acc1
            AND glt_effdate <= effdate1 
            AND glt_tr_type = "JL"
            USE-INDEX glt_index ,
            EACH ac_mstr NO-LOCK 
            WHERE ac_code = glt_acc 
            BREAK BY substring(glt_acc,1,4) BY glt_effdate :
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
                IF (glt_amt >= 0 AND glt_correction = FALSE) OR
                   (glt_amt <  0 AND glt_correction = TRUE ) THEN DO:
                    v_dr_amt = v_dr_amt + glt_amt .
                    v_dr_curramt = v_dr_curramt + glt_curr_amt .
                END.
                ELSE DO:
                    v_cr_amt = v_cr_amt - glt_amt.
                    v_cr_curramt = v_cr_curramt - glt_curr_amt .
                END.
            END.
            IF glt_effdate >= v_effdate THEN DO:
                IF (glt_amt >= 0 AND glt_correction = FALSE) OR
                   (glt_amt <  0 AND glt_correction = TRUE ) THEN DO:
                    v_y_dr_amt = v_y_dr_amt + glt_amt .
                    v_y_dr_curramt = v_y_dr_curramt + glt_curr_amt .
                END.
                ELSE DO:
                    v_y_cr_amt = v_y_cr_amt - glt_amt.
                    v_y_cr_curramt = v_y_cr_curramt - glt_curr_amt .
                END.
            END.
    
            IF LAST-OF(substring(glt_acc,1,4)) THEN DO:
                FIND FIRST tt WHERE tt_acc = SUBSTRING(glt_acc,1,4) NO-ERROR.
                IF AVAIL tt THEN DO:
                    ASSIGN
                        tt_beg_amt = v_beg_amt
                        tt_beg_curramt = v_beg_curramt
                        tt_dr_amt = v_dr_amt
                        tt_dr_curramt = v_dr_curramt
                        tt_cr_amt = v_cr_amt
                        tt_cr_curramt = v_cr_curramt
                        tt_y_dr_amt = v_y_dr_amt
                        tt_y_dr_curramt = v_y_dr_curramt
                        tt_y_cr_amt = v_y_cr_amt
                        tt_y_cr_curramt = v_y_cr_curramt
                        .
                END.
                ELSE DO:
                    v_ac_desc = "".
                    FIND FIRST acmstr WHERE substring(acmstr.ac_code,1,4) = SUBSTRING(glt_acc,1,4) NO-LOCK NO-ERROR.
                    IF AVAIL acmstr THEN DO:
                        v_ac_desc = ENTRY(1,acmstr.ac_desc,"-" ) .
                    END.
                    CREATE tt .
                    ASSIGN
                        tt_acc = substring(glt_acc,1,4)
                        tt_ac_desc = v_ac_desc
                        tt_beg_amt = v_beg_amt
                        tt_beg_curramt = v_beg_curramt
                        tt_dr_amt = v_dr_amt
                        tt_dr_curramt = v_dr_curramt
                        tt_cr_amt = v_cr_amt
                        tt_cr_curramt = v_cr_curramt
                        tt_y_dr_amt = v_y_dr_amt
                        tt_y_dr_curramt = v_y_dr_curramt
                        tt_y_cr_amt = v_y_cr_amt
                        tt_y_cr_curramt = v_y_cr_curramt
                        .
                END.
                v_beg_amt = 0.
                v_beg_curramt = 0.
                v_dr_amt = 0.
                v_cr_amt = 0.
                v_dr_curramt = 0.
                v_cr_curramt = 0.
                v_y_dr_amt = 0.
                v_y_cr_amt = 0.
                v_y_dr_curramt = 0.
                v_y_cr_curramt = 0.
            END.
        END. /* FOR EACH glt_det NO-LOCK  */
    END. /* IF inclpost = YES THEN DO: */
END. /* IF vlevel = 1 THEN DO: */
ELSE IF vlevel = 2 THEN DO:
    v1_beg_amt = 0.
    v1_beg_curramt = 0.
    v1_dr_amt = 0.
    v1_cr_amt = 0.
    v1_dr_curramt = 0.
    v1_cr_curramt = 0.
    v1_y_dr_amt = 0.
    v1_y_cr_amt = 0.
    v1_y_dr_curramt = 0.
    v1_y_cr_curramt = 0.
    v2_beg_amt = 0.
    v2_beg_curramt = 0.
    v2_dr_amt = 0.
    v2_cr_amt = 0.
    v2_dr_curramt = 0.
    v2_cr_curramt = 0.
    v2_y_dr_amt = 0.
    v2_y_cr_amt = 0.
    v2_y_dr_curramt = 0.
    v2_y_cr_curramt = 0.
    FOR EACH gltr_hist NO-LOCK 
        WHERE gltr_acc >= acc
        AND gltr_acc <= acc1
        AND gltr_eff_dt <= effdate1 
        USE-INDEX gltr_eff_dt ,
        EACH ac_mstr NO-LOCK 
        WHERE ac_code = gltr_acc 
        BREAK BY substring(gltr_acc,1,4) BY SUBSTRING(gltr_acc,1,6) BY gltr_eff_dt :
        IF gltr_eff_dt < effdate THEN DO:
            if lookup(ac_type, "A,L") = 0 then do:
                IF gltr_eff_dt >= DATE(1,1,YEAR(effdate)) AND gltr_eff_dt < effdate THEN DO:
                   v1_beg_amt = v1_beg_amt + gltr_amt .
                   v1_beg_curramt = v1_beg_curramt + gltr_curramt .
                   v2_beg_amt = v2_beg_amt + gltr_amt .
                   v2_beg_curramt = v2_beg_curramt + gltr_curramt .
                END.
            END.
            ELSE DO:
                   v1_beg_amt = v1_beg_amt + gltr_amt .
                   v1_beg_curramt = v1_beg_curramt + gltr_curramt .
                   v2_beg_amt = v2_beg_amt + gltr_amt .
                   v2_beg_curramt = v2_beg_curramt + gltr_curramt .
            END.
        END. /* IF gltr_eff_dt < effdate THEN DO: */
        ELSE DO:
            IF (gltr_amt >= 0 AND gltr_correction = FALSE) OR
               (gltr_amt <  0 AND gltr_correction = TRUE ) THEN DO:
                v1_dr_amt = v1_dr_amt + gltr_amt .
                v1_dr_curramt = v1_dr_curramt + gltr_curramt .
                v2_dr_amt = v2_dr_amt + gltr_amt .
                v2_dr_curramt = v2_dr_curramt + gltr_curramt .
            END.
            ELSE DO:
                v1_cr_amt = v1_cr_amt - gltr_amt.
                v1_cr_curramt = v1_cr_curramt - gltr_curramt .
                v2_cr_amt = v2_cr_amt - gltr_amt.
                v2_cr_curramt = v2_cr_curramt - gltr_curramt .
            END.
        END.
        IF gltr_eff_dt >= v_effdate THEN DO:
            IF (gltr_amt >= 0 AND gltr_correction = FALSE) OR
               (gltr_amt <  0 AND gltr_correction = TRUE ) THEN DO:
                v1_y_dr_amt = v1_y_dr_amt + gltr_amt .
                v1_y_dr_curramt = v1_y_dr_curramt + gltr_curramt .
                v2_y_dr_amt = v2_y_dr_amt + gltr_amt .
                v2_y_dr_curramt = v2_y_dr_curramt + gltr_curramt .
            END.
            ELSE DO:
                v1_y_cr_amt = v1_y_cr_amt - gltr_amt.
                v1_y_cr_curramt = v1_y_cr_curramt - gltr_curramt .
                v2_y_cr_amt = v2_y_cr_amt - gltr_amt.
                v2_y_cr_curramt = v2_y_cr_curramt - gltr_curramt .
            END.
        END.

        IF LAST-OF(substring(gltr_acc,1,6)) THEN DO:
            IF length(substring(gltr_acc,1,6)) >= 5 AND LENGTH(substring(gltr_acc,1,6)) <= 6 THEN DO:
                v_ac_desc = "".
                FIND FIRST acmstr WHERE substring(acmstr.ac_code,1,6) = SUBSTRING(gltr_acc,1,6) NO-LOCK NO-ERROR.
                IF AVAIL acmstr THEN DO:
                    v_ac_desc = ENTRY(1,acmstr.ac_desc,"-" ) + "-" + ENTRY(2,acmstr.ac_desc,"-") .
                END.
    
                CREATE tt .
                ASSIGN
                    tt_acc = substring(gltr_acc,1,6)
                    tt_ac_desc = v_ac_desc
                    tt_beg_amt = v1_beg_amt
                    tt_beg_curramt = v1_beg_curramt
                    tt_dr_amt = v1_dr_amt
                    tt_dr_curramt = v1_dr_curramt
                    tt_cr_amt = v1_cr_amt
                    tt_cr_curramt = v1_cr_curramt
                    tt_y_dr_amt = v1_y_dr_amt
                    tt_y_dr_curramt = v1_y_dr_curramt
                    tt_y_cr_amt = v1_y_cr_amt
                    tt_y_cr_curramt = v1_y_cr_curramt
                    .
            END.

            v1_beg_amt = 0.
            v1_beg_curramt = 0.
            v1_dr_amt = 0.
            v1_cr_amt = 0.
            v1_dr_curramt = 0.
            v1_cr_curramt = 0.
            v1_y_dr_amt = 0.
            v1_y_cr_amt = 0.
            v1_y_dr_curramt = 0.
            v1_y_cr_curramt = 0.
        END.
        IF LAST-OF(substring(gltr_acc,1,4)) THEN DO:
            v_ac_desc = "".
            FIND FIRST acmstr WHERE substring(acmstr.ac_code,1,4) = SUBSTRING(gltr_acc,1,4) NO-LOCK NO-ERROR.
            IF AVAIL acmstr THEN DO:
                v_ac_desc = ENTRY(1,acmstr.ac_desc,"-" ).
            END.

            CREATE tt .
            ASSIGN
                tt_acc = substring(gltr_acc,1,4)
                tt_ac_desc = v_ac_desc
                tt_beg_amt = v2_beg_amt
                tt_beg_curramt = v2_beg_curramt
                tt_dr_amt = v2_dr_amt
                tt_dr_curramt = v2_dr_curramt
                tt_cr_amt = v2_cr_amt
                tt_cr_curramt = v2_cr_curramt
                tt_y_dr_amt = v2_y_dr_amt
                tt_y_dr_curramt = v2_y_dr_curramt
                tt_y_cr_amt = v2_y_cr_amt
                tt_y_cr_curramt = v2_y_cr_curramt
                .
            v2_beg_amt = 0.
            v2_beg_curramt = 0.
            v2_dr_amt = 0.
            v2_cr_amt = 0.
            v2_dr_curramt = 0.
            v2_cr_curramt = 0.
            v2_y_dr_amt = 0.
            v2_y_cr_amt = 0.
            v2_y_dr_curramt = 0.
            v2_y_cr_curramt = 0.
        END.
    END. /* FOR EACH gltr_hist NO-LOCK  */
    IF inclpost = YES THEN DO:
        v1_beg_amt = 0.
        v1_beg_curramt = 0.
        v1_dr_amt = 0.
        v1_cr_amt = 0.
        v1_dr_curramt = 0.
        v1_cr_curramt = 0.
        v1_y_dr_amt = 0.
        v1_y_cr_amt = 0.
        v1_y_dr_curramt = 0.
        v1_y_cr_curramt = 0.
        v2_beg_amt = 0.
        v2_beg_curramt = 0.
        v2_dr_amt = 0.
        v2_cr_amt = 0.
        v2_dr_curramt = 0.
        v2_cr_curramt = 0.
        v2_y_dr_amt = 0.
        v2_y_cr_amt = 0.
        v2_y_dr_curramt = 0.
        v2_y_cr_curramt = 0.
        FOR EACH glt_det NO-LOCK 
            WHERE glt_acc >= acc
            AND glt_acc <= acc1
            AND glt_effdate <= effdate1 
            AND glt_tr_type = "JL"
            USE-INDEX glt_index ,
            EACH ac_mstr NO-LOCK 
            WHERE ac_code = glt_acc 
            BREAK BY substring(glt_acc,1,4) BY SUBSTRING(glt_acc,1,6) BY glt_effdate :
            IF glt_effdate < effdate THEN DO:
                if lookup(ac_type, "A,L") = 0 then do:
                    IF glt_effdate >= DATE(1,1,YEAR(effdate)) AND glt_effdate < effdate THEN DO:
                       v1_beg_amt = v1_beg_amt + glt_amt .
                       v1_beg_curramt = v1_beg_curramt + glt_curr_amt .
                       v2_beg_amt = v2_beg_amt + glt_amt .
                       v2_beg_curramt = v2_beg_curramt + glt_curr_amt .
                    END.
                END.
                ELSE DO:
                       v1_beg_amt = v1_beg_amt + glt_amt .
                       v1_beg_curramt = v1_beg_curramt + glt_curr_amt .
                       v2_beg_amt = v2_beg_amt + glt_amt .
                       v2_beg_curramt = v2_beg_curramt + glt_curr_amt .
                END.
            END. /* IF gltr_eff_dt < effdate THEN DO: */
            ELSE DO:
                IF (glt_amt >= 0 AND glt_correction = FALSE) OR
                   (glt_amt <  0 AND glt_correction = TRUE ) THEN DO:
                    v1_dr_amt = v1_dr_amt + glt_amt .
                    v1_dr_curramt = v1_dr_curramt + glt_curr_amt .
                    v2_dr_amt = v2_dr_amt + glt_amt .
                    v2_dr_curramt = v2_dr_curramt + glt_curr_amt .
                END.
                ELSE DO:
                    v1_cr_amt = v1_cr_amt - glt_amt.
                    v1_cr_curramt = v1_cr_curramt - glt_curr_amt .
                    v2_cr_amt = v2_cr_amt - glt_amt.
                    v2_cr_curramt = v2_cr_curramt - glt_curr_amt .
                END.
            END.
            IF glt_effdate >= v_effdate THEN DO:
                IF (glt_amt >= 0 AND glt_correction = FALSE) OR
                   (glt_amt <  0 AND glt_correction = TRUE ) THEN DO:
                    v1_y_dr_amt = v1_y_dr_amt + glt_amt .
                    v1_y_dr_curramt = v1_y_dr_curramt + glt_curr_amt .
                    v2_y_dr_amt = v2_y_dr_amt + glt_amt .
                    v2_y_dr_curramt = v2_y_dr_curramt + glt_curr_amt .
                END.
                ELSE DO:
                    v1_y_cr_amt = v1_y_cr_amt - glt_amt.
                    v1_y_cr_curramt = v1_y_cr_curramt - glt_curr_amt .
                    v2_y_cr_amt = v2_y_cr_amt - glt_amt.
                    v2_y_cr_curramt = v2_y_cr_curramt - glt_curr_amt .
                END.
            END.
    
            IF LAST-OF(substring(glt_acc,1,6)) THEN DO:
                IF length(substring(glt_acc,1,6)) >= 5 AND LENGTH(substring(glt_acc,1,6)) <= 6 THEN DO:
                    v_ac_desc = "".
                    FIND FIRST acmstr WHERE substring(acmstr.ac_code,1,6) = SUBSTRING(glt_acc,1,6) NO-LOCK NO-ERROR.
                    IF AVAIL acmstr THEN DO:
                        v_ac_desc = ENTRY(1,acmstr.ac_desc,"-" ) + "-" + ENTRY(2,acmstr.ac_desc,"-") .
                    END.
        
                    CREATE tt .
                    ASSIGN
                        tt_acc = substring(glt_acc,1,6)
                        tt_ac_desc = v_ac_desc
                        tt_beg_amt = v1_beg_amt
                        tt_beg_curramt = v1_beg_curramt
                        tt_dr_amt = v1_dr_amt
                        tt_dr_curramt = v1_dr_curramt
                        tt_cr_amt = v1_cr_amt
                        tt_cr_curramt = v1_cr_curramt
                        tt_y_dr_amt = v1_y_dr_amt
                        tt_y_dr_curramt = v1_y_dr_curramt
                        tt_y_cr_amt = v1_y_cr_amt
                        tt_y_cr_curramt = v1_y_cr_curramt
                        .
                END.

                v1_beg_amt = 0.
                v1_beg_curramt = 0.
                v1_dr_amt = 0.
                v1_cr_amt = 0.
                v1_dr_curramt = 0.
                v1_cr_curramt = 0.
                v1_y_dr_amt = 0.
                v1_y_cr_amt = 0.
                v1_y_dr_curramt = 0.
                v1_y_cr_curramt = 0.
            END.
            IF LAST-OF(substring(glt_acc,1,4)) THEN DO:
                v_ac_desc = "".
                FIND FIRST acmstr WHERE substring(acmstr.ac_code,1,4) = SUBSTRING(glt_acc,1,4) NO-LOCK NO-ERROR.
                IF AVAIL acmstr THEN DO:
                    v_ac_desc = ENTRY(1,acmstr.ac_desc,"-" ).
                END.
    
                CREATE tt .
                ASSIGN
                    tt_acc = substring(glt_acc,1,4)
                    tt_ac_desc = v_ac_desc
                    tt_beg_amt = v2_beg_amt
                    tt_beg_curramt = v2_beg_curramt
                    tt_dr_amt = v2_dr_amt
                    tt_dr_curramt = v2_dr_curramt
                    tt_cr_amt = v2_cr_amt
                    tt_cr_curramt = v2_cr_curramt
                    tt_y_dr_amt = v2_y_dr_amt
                    tt_y_dr_curramt = v2_y_dr_curramt
                    tt_y_cr_amt = v2_y_cr_amt
                    tt_y_cr_curramt = v2_y_cr_curramt
                    .
                v2_beg_amt = 0.
                v2_beg_curramt = 0.
                v2_dr_amt = 0.
                v2_cr_amt = 0.
                v2_dr_curramt = 0.
                v2_cr_curramt = 0.
                v2_y_dr_amt = 0.
                v2_y_cr_amt = 0.
                v2_y_dr_curramt = 0.
                v2_y_cr_curramt = 0.
            END.
        END. /* FOR EACH gltr_hist NO-LOCK  */    
    END. /* IF inclpost = YES THEN DO: */
END. /* ELSE IF vlevel = 2 THEN DO: */
ELSE IF vlevel = 3 THEN DO:
    v1_beg_amt = 0.
    v1_dr_amt = 0.
    v1_cr_amt = 0.
    v1_y_dr_amt = 0.
    v1_y_cr_amt = 0.
    v2_beg_amt = 0.
    v2_dr_amt = 0.
    v2_cr_amt = 0.
    v2_y_dr_amt = 0.
    v2_y_cr_amt = 0.
    v3_beg_amt = 0.
    v3_dr_amt = 0.
    v3_cr_amt = 0.
    v3_y_dr_amt = 0.
    v3_y_cr_amt = 0.
    FOR EACH gltr_hist NO-LOCK 
        WHERE gltr_acc >= acc
        AND gltr_acc <= acc1
        AND gltr_eff_dt <= effdate1 
        USE-INDEX gltr_eff_dt ,
        EACH ac_mstr NO-LOCK 
        WHERE ac_code = gltr_acc 
        BREAK BY substring(gltr_acc,1,4) BY SUBSTRING(gltr_acc,1,6) BY gltr_acc BY gltr_eff_dt :
        IF gltr_eff_dt < effdate THEN DO:
            if lookup(ac_type, "A,L") = 0 then do:
                IF gltr_eff_dt >= DATE(1,1,YEAR(effdate)) AND gltr_eff_dt < effdate THEN DO:
                   v1_beg_amt = v1_beg_amt + gltr_amt .
                   v2_beg_amt = v2_beg_amt + gltr_amt .
                   v3_beg_amt = v3_beg_amt + gltr_amt .
                END.
            END.
            ELSE DO:
                   v1_beg_amt = v1_beg_amt + gltr_amt .
                   v2_beg_amt = v2_beg_amt + gltr_amt .
                   v3_beg_amt = v3_beg_amt + gltr_amt .
            END.
        END. /* IF gltr_eff_dt < effdate THEN DO: */
        ELSE DO:
            IF (gltr_amt >= 0 AND gltr_correction = FALSE) OR
               (gltr_amt <  0 AND gltr_correction = TRUE ) THEN DO:
                v1_dr_amt = v1_dr_amt + gltr_amt .
                v2_dr_amt = v2_dr_amt + gltr_amt .
                v3_dr_amt = v3_dr_amt + gltr_amt .
            END.
            ELSE DO:
                v1_cr_amt = v1_cr_amt - gltr_amt.
                v2_cr_amt = v2_cr_amt - gltr_amt.
                v3_cr_amt = v3_cr_amt - gltr_amt.
            END.
        END.
        IF gltr_eff_dt >= v_effdate THEN DO:
            IF (gltr_amt >= 0 AND gltr_correction = FALSE) OR
               (gltr_amt <  0 AND gltr_correction = TRUE ) THEN DO:
                v1_y_dr_amt = v1_y_dr_amt + gltr_amt .
                v2_y_dr_amt = v2_y_dr_amt + gltr_amt .
                v3_y_dr_amt = v3_y_dr_amt + gltr_amt .
            END.
            ELSE DO:
                v1_y_cr_amt = v1_y_cr_amt - gltr_amt.
                v2_y_cr_amt = v2_y_cr_amt - gltr_amt.
                v3_y_cr_amt = v3_y_cr_amt - gltr_amt.
            END.
        END.

        IF LAST-OF(gltr_acc) THEN DO:
            IF LENGTH(gltr_acc) >= 7 AND LENGTH(gltr_acc) <= 8 THEN DO:
                v_ac_desc = "".
                FIND FIRST acmstr WHERE acmstr.ac_code = gltr_acc NO-LOCK NO-ERROR.
                IF AVAIL acmstr THEN DO:
                    v_ac_desc = acmstr.ac_desc .
                END.
    
                CREATE tt .
                ASSIGN
                    tt_acc = gltr_acc
                    tt_ac_desc = v_ac_desc
                    tt_beg_amt = v1_beg_amt
                    tt_dr_amt = v1_dr_amt
                    tt_cr_amt = v1_cr_amt
                    tt_y_dr_amt = v1_y_dr_amt
                    tt_y_cr_amt = v1_y_cr_amt
                    .
            END.

            v1_beg_amt = 0.
            v1_dr_amt = 0.
            v1_cr_amt = 0.
            v1_y_dr_amt = 0.
            v1_y_cr_amt = 0.
        END.                
        
        IF LAST-OF(substring(gltr_acc,1,6)) THEN DO:
            IF length(substring(gltr_acc,1,6)) >= 5 AND length(substring(gltr_acc,1,6)) <= 6 THEN DO:
                v_ac_desc = "".
                FIND FIRST acmstr WHERE substring(acmstr.ac_code,1,6) = SUBSTRING(gltr_acc,1,6) NO-LOCK NO-ERROR.
                IF AVAIL acmstr THEN DO:
                    v_ac_desc = ENTRY(1,acmstr.ac_desc,"-" ) + "-" + ENTRY(2,acmstr.ac_desc,"-") .
                END.
            
                CREATE tt .
                ASSIGN
                    tt_acc = substring(gltr_acc,1,6)
                    tt_ac_desc = v_ac_desc
                    tt_beg_amt = v2_beg_amt
                    tt_dr_amt = v2_dr_amt
                    tt_cr_amt = v2_cr_amt
                    tt_y_dr_amt = v2_y_dr_amt
                    tt_y_cr_amt = v2_y_cr_amt
                    .
            END.

            v2_beg_amt = 0.
            v2_dr_amt = 0.
            v2_cr_amt = 0.
            v2_y_dr_amt = 0.
            v2_y_cr_amt = 0.
        END.

        IF LAST-OF(substring(gltr_acc,1,4)) THEN DO:
            v_ac_desc = "".
            FIND FIRST acmstr WHERE substring(acmstr.ac_code,1,4) = SUBSTRING(gltr_acc,1,4) NO-LOCK NO-ERROR.
            IF AVAIL acmstr THEN DO:
                v_ac_desc = ENTRY(1,acmstr.ac_desc,"-" ).
            END.

            CREATE tt .
            ASSIGN
                tt_acc = substring(gltr_acc,1,4)
                tt_ac_desc = v_ac_desc
                tt_beg_amt = v3_beg_amt
                tt_dr_amt = v3_dr_amt
                tt_cr_amt = v3_cr_amt
                tt_y_dr_amt = v3_y_dr_amt
                tt_y_cr_amt = v3_y_cr_amt
                .
            v3_beg_amt = 0.
            v3_dr_amt = 0.
            v3_cr_amt = 0.
            v3_y_dr_amt = 0.
            v3_y_cr_amt = 0.
        END.
    END. /* FOR EACH gltr_hist NO-LOCK  */
    IF inclpost = YES THEN DO:
        v1_beg_amt = 0.
        v1_beg_curramt = 0.
        v1_dr_amt = 0.
        v1_cr_amt = 0.
        v1_dr_curramt = 0.
        v1_cr_curramt = 0.
        v1_y_dr_amt = 0.
        v1_y_cr_amt = 0.
        v1_y_dr_curramt = 0.
        v1_y_cr_curramt = 0.
        v2_beg_amt = 0.
        v2_beg_curramt = 0.
        v2_dr_amt = 0.
        v2_cr_amt = 0.
        v2_dr_curramt = 0.
        v2_cr_curramt = 0.
        v2_y_dr_amt = 0.
        v2_y_cr_amt = 0.
        v2_y_dr_curramt = 0.
        v2_y_cr_curramt = 0.
        v3_beg_amt = 0.
        v3_beg_curramt = 0.
        v3_dr_amt = 0.
        v3_cr_amt = 0.
        v3_dr_curramt = 0.
        v3_cr_curramt = 0.
        v3_y_dr_amt = 0.
        v3_y_cr_amt = 0.
        v3_y_dr_curramt = 0.
        v3_y_cr_curramt = 0.
        FOR EACH glt_det NO-LOCK 
            WHERE glt_acc >= acc
            AND glt_acc <= acc1
            AND glt_effdate <= effdate1 
            AND glt_tr_type = "JL"
            USE-INDEX glt_index ,
            EACH ac_mstr NO-LOCK 
            WHERE ac_code = glt_acc 
            BREAK BY substring(glt_acc,1,4) BY SUBSTRING(glt_acc,1,6) BY glt_acc BY glt_effdate :
            IF glt_effdate < effdate THEN DO:
                if lookup(ac_type, "A,L") = 0 then do:
                    IF glt_effdate >= DATE(1,1,YEAR(effdate)) AND glt_effdate < effdate THEN DO:
                       v1_beg_amt = v1_beg_amt + glt_amt .
                       v1_beg_curramt = v1_beg_curramt + glt_curr_amt .
                       v2_beg_amt = v2_beg_amt + glt_amt .
                       v2_beg_curramt = v2_beg_curramt + glt_curr_amt .
                       v3_beg_amt = v3_beg_amt + glt_amt .
                       v3_beg_curramt = v3_beg_curramt + glt_curr_amt .
                    END.
                END.
                ELSE DO:
                       v1_beg_amt = v1_beg_amt + glt_amt .
                       v1_beg_curramt = v1_beg_curramt + glt_curr_amt .
                       v2_beg_amt = v2_beg_amt + glt_amt .
                       v2_beg_curramt = v2_beg_curramt + glt_curr_amt .
                       v3_beg_amt = v3_beg_amt + glt_amt .
                       v3_beg_curramt = v3_beg_curramt + glt_curr_amt .
                END.
            END. /* IF gltr_eff_dt < effdate THEN DO: */
            ELSE DO:
                IF (glt_amt >= 0 AND glt_correction = FALSE) OR
                   (glt_amt <  0 AND glt_correction = TRUE ) THEN DO:
                    v1_dr_amt = v1_dr_amt + glt_amt .
                    v1_dr_curramt = v1_dr_curramt + glt_curr_amt .
                    v2_dr_amt = v2_dr_amt + glt_amt .
                    v2_dr_curramt = v2_dr_curramt + glt_curr_amt .
                    v3_dr_amt = v3_dr_amt + glt_amt .
                    v3_dr_curramt = v3_dr_curramt + glt_curr_amt .
                END.
                ELSE DO:
                    v1_cr_amt = v1_cr_amt - glt_amt.
                    v1_cr_curramt = v1_cr_curramt - glt_curr_amt .
                    v2_cr_amt = v2_cr_amt - glt_amt.
                    v2_cr_curramt = v2_cr_curramt - glt_curr_amt .
                    v3_cr_amt = v3_cr_amt - glt_amt.
                    v3_cr_curramt = v3_cr_curramt - glt_curr_amt .
                END.
            END.
            IF glt_effdate >= v_effdate THEN DO:
                IF (glt_amt >= 0 AND glt_correction = FALSE) OR
                   (glt_amt <  0 AND glt_correction = TRUE ) THEN DO:
                    v1_y_dr_amt = v1_y_dr_amt + glt_amt .
                    v1_y_dr_curramt = v1_y_dr_curramt + glt_curr_amt .
                    v2_y_dr_amt = v2_y_dr_amt + glt_amt .
                    v2_y_dr_curramt = v2_y_dr_curramt + glt_curr_amt .
                    v3_y_dr_amt = v3_y_dr_amt + glt_amt .
                    v3_y_dr_curramt = v3_y_dr_curramt + glt_curr_amt .
                END.
                ELSE DO:
                    v1_y_cr_amt = v1_y_cr_amt - glt_amt.
                    v1_y_cr_curramt = v1_y_cr_curramt - glt_curr_amt .
                    v2_y_cr_amt = v2_y_cr_amt - glt_amt.
                    v2_y_cr_curramt = v2_y_cr_curramt - glt_curr_amt .
                    v3_y_cr_amt = v3_y_cr_amt - glt_amt.
                    v3_y_cr_curramt = v3_y_cr_curramt - glt_curr_amt .
                END.
            END.
    
            IF LAST-OF(glt_acc) THEN DO:
                IF LENGTH(glt_acc) >= 7 AND LENGTH(glt_acc) <= 8 THEN DO:
                    v_ac_desc = "".
                    FIND FIRST acmstr WHERE acmstr.ac_code = glt_acc NO-LOCK NO-ERROR.
                    IF AVAIL acmstr THEN DO:
                        v_ac_desc = acmstr.ac_desc .
                    END.
        
                    CREATE tt .
                    ASSIGN
                        tt_acc = glt_acc
                        tt_ac_desc = v_ac_desc
                        tt_beg_amt = v1_beg_amt
                        tt_beg_curramt = v1_beg_curramt
                        tt_dr_amt = v1_dr_amt
                        tt_dr_curramt = v1_dr_curramt
                        tt_cr_amt = v1_cr_amt
                        tt_cr_curramt = v1_cr_curramt
                        tt_y_dr_amt = v1_y_dr_amt
                        tt_y_dr_curramt = v1_y_dr_curramt
                        tt_y_cr_amt = v1_y_cr_amt
                        tt_y_cr_curramt = v1_y_cr_curramt
                        .
                END.

                v1_beg_amt = 0.
                v1_beg_curramt = 0.
                v1_dr_amt = 0.
                v1_cr_amt = 0.
                v1_dr_curramt = 0.
                v1_cr_curramt = 0.
                v1_y_dr_amt = 0.
                v1_y_cr_amt = 0.
                v1_y_dr_curramt = 0.
                v1_y_cr_curramt = 0.
            END.
            IF LAST-OF(substring(glt_acc,1,6)) THEN DO:
                IF LENGTH(substring(glt_acc,1,6)) >= 5 AND LENGTH(substring(glt_acc,1,6)) <= 6 THEN DO:
                    v_ac_desc = "".
                    FIND FIRST acmstr WHERE substring(acmstr.ac_code,1,6) = SUBSTRING(glt_acc,1,6) NO-LOCK NO-ERROR.
                    IF AVAIL acmstr THEN DO:
                        v_ac_desc = ENTRY(1,acmstr.ac_desc,"-" ) + "-" + ENTRY(2,acmstr.ac_desc,"-") .
                    END.
        
                    CREATE tt .
                    ASSIGN
                        tt_acc = substring(glt_acc,1,6)
                        tt_ac_desc = v_ac_desc
                        tt_beg_amt = v2_beg_amt
                        tt_beg_curramt = v2_beg_curramt
                        tt_dr_amt = v2_dr_amt
                        tt_dr_curramt = v2_dr_curramt
                        tt_cr_amt = v2_cr_amt
                        tt_cr_curramt = v2_cr_curramt
                        tt_y_dr_amt = v2_y_dr_amt
                        tt_y_dr_curramt = v2_y_dr_curramt
                        tt_y_cr_amt = v2_y_cr_amt
                        tt_y_cr_curramt = v2_y_cr_curramt
                        .
                END.

                v2_beg_amt = 0.
                v2_beg_curramt = 0.
                v2_dr_amt = 0.
                v2_cr_amt = 0.
                v2_dr_curramt = 0.
                v2_cr_curramt = 0.
                v2_y_dr_amt = 0.
                v2_y_cr_amt = 0.
                v2_y_dr_curramt = 0.
                v2_y_cr_curramt = 0.
            END.
            IF LAST-OF(substring(glt_acc,1,4)) THEN DO:
                v_ac_desc = "".
                FIND FIRST acmstr WHERE substring(acmstr.ac_code,1,4) = SUBSTRING(glt_acc,1,4) NO-LOCK NO-ERROR.
                IF AVAIL acmstr THEN DO:
                    v_ac_desc = ENTRY(1,acmstr.ac_desc,"-" ).
                END.
    
                CREATE tt .
                ASSIGN
                    tt_acc = substring(glt_acc,1,4)
                    tt_ac_desc = v_ac_desc
                    tt_beg_amt = v3_beg_amt
                    tt_beg_curramt = v3_beg_curramt
                    tt_dr_amt = v3_dr_amt
                    tt_dr_curramt = v3_dr_curramt
                    tt_cr_amt = v3_cr_amt
                    tt_cr_curramt = v3_cr_curramt
                    tt_y_dr_amt = v3_y_dr_amt
                    tt_y_dr_curramt = v3_y_dr_curramt
                    tt_y_cr_amt = v3_y_cr_amt
                    tt_y_cr_curramt = v3_y_cr_curramt
                    .
                v3_beg_amt = 0.
                v3_beg_curramt = 0.
                v3_dr_amt = 0.
                v3_cr_amt = 0.
                v3_dr_curramt = 0.
                v3_cr_curramt = 0.
                v3_y_dr_amt = 0.
                v3_y_cr_amt = 0.
                v3_y_dr_curramt = 0.
                v3_y_cr_curramt = 0.
            END.
        END. /* FOR EACH gltr_hist NO-LOCK  */
    END.                                  
END. /* ELSE IF vlevel = 3 THEN DO: */

/* 输出到BI */
PUT UNFORMATTED "#def REPORTPATH=$/财务/BI报表/a6glrp59" SKIP.
PUT UNFORMATTED "#def :end" SKIP.

/* 输入报表数据 */
/*
PUT UNFORMATTED "总分类帐户" ";" ";" 
    "期初余额" ";" ";" 
    "本期发生额" ";" ";" 
    "本年累计发生额" ";" ";" 
    "期末余额" ";" SKIP.
PUT UNFORMATTED "编号" ";" "名称" ";" 
    "借方" ";" "贷方" ";" 
    "借方" ";" "贷方" ";" 
    "借方" ";" "贷方" ";" 
    "借方" ";" "贷方" SKIP.
  */

v_dispdate = "期间: 从" + STRING(YEAR(effdate),"9999") + "年" + 
            STRING(MONTH(effdate),"99") + "月" + STRING(DAY(effdate),"99") + "日" + 
            " 至 " +
            STRING(YEAR(effdate1),"9999") + "年" + 
            STRING(MONTH(effdate1),"99") + "月" + STRING(DAY(effdate1),"99") + "日".

FOR EACH tt BY tt_acc:
    PUT UNFORMATTED v_dispdate ";" tt_acc ";" tt_ac_desc ";" .
    IF tt_beg_amt >= 0 THEN PUT UNFORMATTED tt_beg_amt ";" ";" .
    ELSE PUT UNFORMATTED ";" ABS(tt_beg_amt) ";" .
    PUT UNFORMATTED tt_dr_amt ";" tt_cr_amt ";" 
        tt_y_dr_amt ";" tt_y_cr_amt ";" .
    IF (tt_beg_amt + tt_dr_amt - tt_cr_amt) >= 0 
    THEN PUT UNFORMATTED (tt_beg_amt + tt_dr_amt - tt_cr_amt) ";" SKIP.
    ELSE PUT UNFORMATTED ";" ABS(tt_beg_amt + tt_dr_amt - tt_cr_amt) SKIP.
END. /* FOR EACH tt BY tt_acc: */







