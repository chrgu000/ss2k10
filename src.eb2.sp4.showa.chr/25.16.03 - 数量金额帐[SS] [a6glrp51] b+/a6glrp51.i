/* REVISION: eb2sp4      LAST MODIFIED: 05/24/06   BY: *SS - Micho - 20060524* Micho Yang     */

DEF VAR v_asc AS CHAR.
DEF VAR v_asc_desc AS CHAR.
DEF VAR v_dr_amt AS DECIMAL.
DEF VAR v_cr_amt AS DECIMAL.
DEF VAR v_dr_price AS DECIMAL.
DEF VAR v_cr_price AS DECIMAL.
DEF VAR v_dr_glta_amt AS DECIMAL.
DEF VAR v_cr_glta_amt AS DECIMAL.
DEF VAR v_first_qty AS DECIMAL.
DEF VAR v_first_amt AS DECIMAL.
DEF VAR v_tot_qty AS DECIMAL.
DEF VAR v_tot_amt AS DECIMAL.
DEF VAR v_glta_amt AS DECIMAL.
DEF VAR j AS INTEGER .
DEF VAR v_username AS CHAR.
DEF VAR v_qty AS DECIMAL.

DEF VAR jj AS INTEGER .
DEF VAR ii AS INTEGER .

DEF VAR v_tt2_dr_glta_amt AS DECIMAL.
DEF VAR v_tt2_cr_glta_amt AS DECIMAL.
DEF VAR v_tt2_dr_amt AS DECIMAL.
DEF VAR v_tt2_cr_amt AS DECIMAL.

DEF VAR v_dispdate AS CHAR.
DEF VAR v_beg_amt LIKE gltr_amt.
DEF VAR v_beg_curramt LIKE gltr_amt .

DEF TEMP-TABLE tt1 
    FIELD tt1_acc LIKE gltr_acc
    FIELD tt1_sub LIKE gltr_sub
    FIELD tt1_ctr LIKE gltr_ctr 
    FIELD tt1_amt AS DECIMAL
    FIELD tt1_curramt AS DECIMAL
    FIELD tt1_qty AS DECIMAL
    INDEX INDEX_asc tt1_acc tt1_sub tt1_ctr 
    .

DEF TEMP-TABLE tt
    FIELD tt_asc AS CHAR
    FIELD tt_asc_desc AS CHAR
    FIELD tt_acc AS CHAR
    FIELD tt_sub AS CHAR
    FIELD tt_ctr AS CHAR
    FIELD tt_date AS CHAR FORMAT "x(10)" 
    FIELD tt_ref LIKE gltr_ref
    FIELD tt_line LIKE gltr_line
    FIELD tt_desc LIKE gltr_desc
    FIELD tt_dr_glta_amt LIKE glta_amt 
    FIELD tt_cr_glta_amt LIKE glta_amt
    FIELD tt_dr_amt AS DECIMAL
    FIELD tt_cr_amt AS DECIMAL
    FIELD tt_dr_price AS DECIMAL
    FIELD tt_cr_price AS DECIMAL
    INDEX INDEX_asc tt_acc tt_sub tt_ctr 
    .

DEF TEMP-TABLE tt2
    FIELD tt2_asc AS CHAR
    FIELD tt2_asc_desc AS CHAR
    FIELD tt2_acc AS CHAR
    FIELD tt2_sub AS CHAR
    FIELD tt2_ctr AS CHAR
    FIELD tt2_date AS CHAR FORMAT "x(10)" 
    FIELD tt2_ref LIKE gltr_ref
    FIELD tt2_line LIKE gltr_line
    FIELD tt2_desc LIKE gltr_desc
    FIELD tt2_dr_glta_amt LIKE glta_amt 
    FIELD tt2_cr_glta_amt LIKE glta_amt
    FIELD tt2_dr_amt AS DECIMAL
    FIELD tt2_cr_amt AS DECIMAL
    FIELD tt2_dr_price AS DECIMAL
    FIELD tt2_cr_price AS DECIMAL
    INDEX INDEX_asc tt2_acc tt2_sub tt2_ctr 
    .

DEF TEMP-TABLE tt3 
    FIELD tt3_asc AS CHAR
    FIELD tt3_dr_glta_amt AS DECIMAL
    FIELD tt3_cr_glta_amt AS DECIMAL
    FIELD tt3_dr_amt AS DECIMAL
    FIELD tt3_cr_amt AS DECIMAL
    INDEX INDEX_asc1 tt3_asc 
    .

    EMPTY TEMP-TABLE tt1.    
    v_qty = 0 .
    v_beg_amt = 0.
    v_beg_curramt = 0.
    FOR EACH gltr_hist NO-LOCK WHERE gltr_eff_dt < effdate 
                               AND gltr_acc >= acc 
                               AND gltr_acc <= acc1
                               AND gltr_sub >= sub
                               AND gltr_sub <= sub1
                               AND gltr_ctr >= ctr 
                               AND gltr_ctr <= ctr1 ,
        EACH glta_det NO-LOCK WHERE glta_ref = gltr_ref 
                                AND glta_line = gltr_line,
        EACH ac_mstr NO-LOCK WHERE ac_code = gltr_acc
                                BREAK BY gltr_acc BY gltr_sub BY gltr_ctr :
        if lookup(ac_type, "A,L") = 0 then do:
            IF gltr_eff_dt >= DATE(1,1,YEAR(effdate)) AND gltr_eff_dt < effdate THEN DO:
               v_beg_amt = v_beg_amt + gltr_amt .
               v_beg_curramt = v_beg_curramt + gltr_curramt .
               IF gltr_amt >= 0 THEN v_qty = v_qty + abs(glta_amt) .
                                ELSE v_qty = v_qty - abs(glta_amt) .
            END.
        END.
        ELSE DO:
               v_beg_amt = v_beg_amt + gltr_amt .
               v_beg_curramt = v_beg_curramt + gltr_curramt .
               IF gltr_amt >= 0 THEN v_qty = v_qty + abs(glta_amt) .
                                ELSE v_qty = v_qty - abs(glta_amt) .
        END.

        IF LAST-OF(gltr_ctr) THEN DO:
          CREATE tt1.
          ASSIGN
              tt1_acc = gltr_acc
              tt1_sub = gltr_sub
              tt1_ctr = gltr_ctr
              tt1_amt = v_beg_amt 
              tt1_curramt = v_beg_curramt
              tt1_qty = v_qty 
              .
          v_qty =  0.
          v_beg_amt = 0.
          v_beg_curramt = 0.
        END.     
    END.

    IF inclpost = YES THEN DO:
        v_qty = 0 .
        v_beg_amt = 0.
        v_beg_curramt = 0.
        FOR EACH glt_det NO-LOCK WHERE glt_effdate < effdate 
                                   AND glt_acct >= acc 
                                   AND glt_acct <= acc1
                                   AND glt_sub >= sub
                                   AND glt_sub <= sub1
                                   AND glt_cc >= ctr 
                                   AND glt_cc <= ctr1 ,
            EACH glta_det NO-LOCK WHERE glta_ref = glt_ref 
                                    AND glta_line = glt_line,
            EACH ac_mstr NO-LOCK WHERE ac_code = glt_acct
                                    BREAK BY glt_acct BY glt_sub BY glt_cc :
            if lookup(ac_type, "A,L") = 0 then do:
                IF glt_effdate >= DATE(1,1,YEAR(effdate)) AND glt_effdate < effdate THEN DO:
                   v_beg_amt = v_beg_amt + glt_amt .
                   v_beg_curramt = v_beg_curramt + glt_curr_amt .
                   IF gltr_amt >= 0 THEN v_qty = v_qty + abs(glta_amt) .
                                    ELSE v_qty = v_qty - abs(glta_amt) .
                END.
            END.
            ELSE DO:
                   v_beg_amt = v_beg_amt + glt_amt .
                   v_beg_curramt = v_beg_curramt + glt_curr_amt .
                   IF gltr_amt >= 0 THEN v_qty = v_qty + abs(glta_amt) .
                                    ELSE v_qty = v_qty - abs(glta_amt) .
            END.
    
            IF LAST-OF(glt_cc) THEN DO:
                FIND FIRST tt1 WHERE tt1_acc = glt_acct 
                    AND tt1_sub = glt_sub
                    AND tt1_ctr = glt_cc NO-LOCK NO-ERROR.
                IF AVAIL tt1 THEN DO:
                    ASSIGN
                        tt1_amt = tt1_amt + v_beg_amt
                        tt1_curramt = tt1_curramt + v_beg_curramt 
                        tt1_qty = tt1_qty + v_qty 
                        .
                END.
                ELSE DO:
                    CREATE tt1.
                    ASSIGN
                        tt1_acc = glt_acct
                        tt1_sub = glt_sub
                        tt1_ctr = glt_cc
                        tt1_amt = v_beg_amt 
                        tt1_curramt = v_beg_curramt
                        tt1_qty = v_qty 
                        .
                END.
                v_qty =  0.
                v_beg_amt = 0.
                v_beg_curramt = 0.
            END.     
        END.
    END. /* IF inclpost = YES THEN DO: */


    /*
    PUT UNFORMATTED "tt1" SKIP .
    FOR EACH tt1 :
        EXPORT DELIMITER ";" tt1 .
    END.*/

    EMPTY TEMP-TABLE tt.
    FOR EACH gltr_hist NO-LOCK WHERE gltr_entity >= entity 
                                 AND gltr_entity <= entity1
                                 AND gltr_eff_dt >= effdate
                                 AND gltr_eff_dt <= effdate1
                                 AND gltr_acc >= acc
                                 AND gltr_acc <= acc1
                                 AND gltr_sub >= sub
                                 AND gltr_sub <= sub1
                                 AND gltr_ctr >= ctr
                                 AND gltr_ctr <= ctr1 :
        v_asc = "" .
        v_asc_desc = "" .
        FIND FIRST ac_mstr WHERE ac_code = gltr_acc NO-LOCK NO-ERROR.
        IF AVAIL ac_mstr AND ac_code <> "" THEN DO:
            v_asc = gltr_acc .
            v_asc_desc = ac_desc .
        END.
        FIND FIRST sb_mstr WHERE sb_sub = gltr_sub NO-LOCK NO-ERROR.
        IF AVAIL sb_mstr AND sb_sub <> "" THEN DO:
            v_asc = v_asc + "-" + gltr_sub .
            v_asc_desc = v_asc_desc + "-" + sb_desc .
        END.
        ELSE DO:
            v_asc = v_asc .
            v_asc_desc = v_asc_desc .
        END.
        FIND FIRST cc_mstr WHERE cc_ctr = gltr_ctr NO-LOCK NO-ERROR.
        IF AVAIL cc_mstr AND cc_ctr <> "" THEN DO:
            v_asc = v_asc + "-" + gltr_ctr .
            v_asc_desc = v_asc_desc + "-" + cc_desc .
        END.
        ELSE DO:
            v_asc = v_asc .
            v_asc_desc = v_asc_desc .
        END.

        v_dr_amt = 0.
        v_cr_amt = 0.
        IF (gltr_amt >= 0 AND gltr_correction = FALSE ) OR
           (gltr_amt <  0 AND gltr_correction = TRUE  )
        THEN
            ASSIGN v_dr_amt = gltr_amt 
                   v_cr_amt = 0.
        ELSE
            ASSIGN v_cr_amt = - gltr_amt 
                   v_dr_amt = 0.

        v_glta_amt = 0.
        FIND FIRST glta_det WHERE glta_ref = gltr_ref 
                              AND glta_line = gltr_line NO-LOCK NO-ERROR.
        IF AVAIL glta_det THEN DO:
            v_glta_amt = glta_amt .
        END.

        v_dr_price = 0.
        v_dr_glta_amt = 0.
        v_cr_price = 0.
        v_cr_glta_amt = 0.
        IF v_dr_amt <> 0 THEN DO:
            IF v_glta_amt <> 0 THEN v_dr_price = v_dr_amt / v_glta_amt .
                               ELSE v_dr_price = 0 .
            v_dr_glta_amt = v_glta_amt.
        END.
        IF v_cr_amt <> 0 THEN DO: 
            IF v_glta_amt <> 0 THEN v_cr_price = v_cr_amt / v_glta_amt .
                               ELSE v_cr_price = 0 .
            v_cr_glta_amt = v_glta_amt .
        END.
        
        CREATE tt.
        ASSIGN
            tt_asc = v_asc 
            tt_asc_desc = v_asc_desc 
            tt_acc = gltr_acc
            tt_sub = gltr_sub
            tt_ctr = gltr_ctr
            tt_date = STRING(YEAR(gltr_eff_dt),"9999") + "." + STRING(MONTH(gltr_eff_dt),"99") + "." + STRING(DAY(gltr_eff_dt),"99") 
            tt_ref = gltr_ref 
            tt_line = gltr_line
            tt_desc = gltr_desc 
            tt_dr_glta_amt = abs(v_dr_glta_amt )
            tt_cr_glta_amt = abs(v_cr_glta_amt )
            tt_dr_amt = v_dr_amt
            tt_cr_amt = v_cr_amt
            tt_dr_price = abs(v_dr_price)
            tt_cr_price = abs(v_cr_price)
            .
    END.

    IF inclpost = YES THEN DO:
        FOR EACH glt_det NO-LOCK WHERE glt_entity >= entity 
                                     AND glt_entity <= entity1
                                     AND glt_effdate >= effdate
                                     AND glt_effdate <= effdate1
                                     AND glt_acct >= acc
                                     AND glt_acct <= acc1
                                     AND glt_sub >= sub
                                     AND glt_sub <= sub1
                                     AND glt_cc >= ctr
                                     AND glt_cc <= ctr1
                                     AND glt_tr_type = 'JL' :
            v_asc = "" .
            v_asc_desc = "" .
            FIND FIRST ac_mstr WHERE ac_code = glt_acct NO-LOCK NO-ERROR.
            IF AVAIL ac_mstr AND ac_code <> "" THEN DO:
                v_asc = glt_acct .
                v_asc_desc = ac_desc .
            END.
            FIND FIRST sb_mstr WHERE sb_sub = glt_sub NO-LOCK NO-ERROR.
            IF AVAIL sb_mstr AND sb_sub <> "" THEN DO:
                v_asc = v_asc + "-" + glt_sub .
                v_asc_desc = v_asc_desc + "-" + sb_desc .
            END.
            ELSE DO:
                v_asc = v_asc .
                v_asc_desc = v_asc_desc .
            END.
            FIND FIRST cc_mstr WHERE cc_ctr = glt_cc NO-LOCK NO-ERROR.
            IF AVAIL cc_mstr AND cc_ctr <> "" THEN DO:
                v_asc = v_asc + "-" + glt_cc .
                v_asc_desc = v_asc_desc + "-" + cc_desc .
            END.
            ELSE DO:
                v_asc = v_asc .
                v_asc_desc = v_asc_desc .
            END.
    
            v_dr_amt = 0.
            v_cr_amt = 0.
            IF (glt_amt >= 0 AND glt_correction = FALSE ) OR
               (glt_amt <  0 AND glt_correction = TRUE  )
            THEN
                ASSIGN v_dr_amt = glt_amt 
                       v_cr_amt = 0.
            ELSE
                ASSIGN v_cr_amt = - glt_amt 
                       v_dr_amt = 0.
    
            v_glta_amt = 0.
            FIND FIRST glta_det WHERE glta_ref = glt_ref 
                                  AND glta_line = glt_line NO-LOCK NO-ERROR.
            IF AVAIL glta_det THEN DO:
                v_glta_amt = glta_amt .
            END.
    
            v_dr_price = 0.
            v_dr_glta_amt = 0.
            v_cr_price = 0.
            v_cr_glta_amt = 0.
            IF v_dr_amt <> 0 THEN DO:
                IF v_glta_amt <> 0 THEN v_dr_price = v_dr_amt / v_glta_amt .
                                   ELSE v_dr_price = 0 .
                v_dr_glta_amt = v_glta_amt.
            END.
            IF v_cr_amt <> 0 THEN DO: 
                IF v_glta_amt <> 0 THEN v_cr_price = v_cr_amt / v_glta_amt .
                                   ELSE v_cr_price = 0 .
                v_cr_glta_amt = v_glta_amt .
            END.
            
            CREATE tt.
            ASSIGN
                tt_asc = v_asc 
                tt_asc_desc = v_asc_desc 
                tt_acc = glt_acct
                tt_sub = glt_sub
                tt_ctr = glt_cc
                tt_date = STRING(YEAR(glt_effdate),"9999") + "." + STRING(MONTH(glt_effdate),"99") + "." + STRING(DAY(glt_effdate),"99") 
                tt_ref = glt_ref 
                tt_line = glt_line
                tt_desc = glt_desc 
                tt_dr_glta_amt = abs(v_dr_glta_amt )
                tt_cr_glta_amt = abs(v_cr_glta_amt )
                tt_dr_amt = v_dr_amt
                tt_cr_amt = v_cr_amt
                tt_dr_price = abs(v_dr_price)
                tt_cr_price = abs(v_cr_price)
                .
        END.
    END. /* IF inclpost = YES THEN DO: */

    EMPTY TEMP-TABLE tt2.
    FOR EACH gltr_hist NO-LOCK WHERE gltr_entity >= entity 
                                 AND gltr_entity <= entity1
                                 AND gltr_eff_dt >= date(1,1,year(effdate))
                                 AND gltr_eff_dt < effdate
                                 AND gltr_acc >= acc
                                 AND gltr_acc <= acc1
                                 AND gltr_sub >= sub
                                 AND gltr_sub <= sub1
                                 AND gltr_ctr >= ctr
                                 AND gltr_ctr <= ctr1 :
        v_asc = "" .
        v_asc_desc = "" .
        FIND FIRST ac_mstr WHERE ac_code = gltr_acc NO-LOCK NO-ERROR.
        IF AVAIL ac_mstr AND ac_code <> "" THEN DO:
            v_asc = gltr_acc .
            v_asc_desc = ac_desc .
        END.
        FIND FIRST sb_mstr WHERE sb_sub = gltr_sub NO-LOCK NO-ERROR.
        IF AVAIL sb_mstr AND sb_sub <> "" THEN DO:
            v_asc = v_asc + "-" + gltr_sub .
            v_asc_desc = v_asc_desc + "-" + sb_desc .
        END.
        ELSE DO:
            v_asc = v_asc .
            v_asc_desc = v_asc_desc .
        END.
        FIND FIRST cc_mstr WHERE cc_ctr = gltr_ctr NO-LOCK NO-ERROR.
        IF AVAIL cc_mstr AND cc_ctr <> "" THEN DO:
            v_asc = v_asc + "-" + gltr_ctr .
            v_asc_desc = v_asc_desc + "-" + cc_desc .
        END.
        ELSE DO:
            v_asc = v_asc .
            v_asc_desc = v_asc_desc .
        END.

        v_dr_amt = 0.
        v_cr_amt = 0.
        IF (gltr_amt >= 0 AND gltr_correction = FALSE ) OR
           (gltr_amt <  0 AND gltr_correction = TRUE  )
        THEN
            ASSIGN v_dr_amt = gltr_amt 
                   v_cr_amt = 0.
        ELSE
            ASSIGN v_cr_amt = - gltr_amt 
                   v_dr_amt = 0.

        v_glta_amt = 0.
        FIND FIRST glta_det WHERE glta_ref = gltr_ref 
                              AND glta_line = gltr_line NO-LOCK NO-ERROR.
        IF AVAIL glta_det THEN DO:
            v_glta_amt = glta_amt .
        END.

        v_dr_price = 0.
        v_dr_glta_amt = 0.
        v_cr_price = 0.
        v_cr_glta_amt = 0.
        IF v_dr_amt <> 0 THEN DO:
            IF v_glta_amt <> 0 THEN v_dr_price = v_dr_amt / v_glta_amt .
                               ELSE v_dr_price = 0 .
            v_dr_glta_amt = v_glta_amt.
        END.
        IF v_cr_amt <> 0 THEN DO: 
            IF v_glta_amt <> 0 THEN v_cr_price = v_cr_amt / v_glta_amt .
                               ELSE v_cr_price = 0 .
            v_cr_glta_amt = v_glta_amt .
        END.
        
        CREATE tt2.
        ASSIGN
            tt2_asc = v_asc 
            tt2_asc_desc = v_asc_desc 
            tt2_acc = gltr_acc
            tt2_sub = gltr_sub
            tt2_ctr = gltr_ctr
            tt2_date = STRING(YEAR(gltr_eff_dt),"9999") + "." + STRING(MONTH(gltr_eff_dt),"99") + "." + STRING(DAY(gltr_eff_dt),"99") 
            tt2_ref = gltr_ref 
            tt2_line = gltr_line
            tt2_desc = gltr_desc 
            tt2_dr_glta_amt = abs(v_dr_glta_amt) 
            tt2_cr_glta_amt = abs(v_cr_glta_amt)
            tt2_dr_amt = v_dr_amt
            tt2_cr_amt = v_cr_amt
            tt2_dr_price = abs(v_dr_price)
            tt2_cr_price = abs(v_cr_price)
            .
    END.

    IF inclpost = YES THEN DO:
        FOR EACH glt_det NO-LOCK WHERE glt_entity >= entity 
                                     AND glt_entity <= entity1
                                     AND glt_effdate >= date(1,1,year(effdate))
                                     AND glt_effdate < effdate
                                     AND glt_acct >= acc
                                     AND glt_acct <= acc1
                                     AND glt_sub >= sub
                                     AND glt_sub <= sub1
                                     AND glt_cc >= ctr
                                     AND glt_cc <= ctr1
                                     AND glt_tr_type = 'JL' :
            v_asc = "" .
            v_asc_desc = "" .
            FIND FIRST ac_mstr WHERE ac_code = glt_acct NO-LOCK NO-ERROR.
            IF AVAIL ac_mstr AND ac_code <> "" THEN DO:
                v_asc = glt_acct .
                v_asc_desc = ac_desc .
            END.
            FIND FIRST sb_mstr WHERE sb_sub = glt_sub NO-LOCK NO-ERROR.
            IF AVAIL sb_mstr AND sb_sub <> "" THEN DO:
                v_asc = v_asc + "-" + glt_sub .
                v_asc_desc = v_asc_desc + "-" + sb_desc .
            END.
            ELSE DO:
                v_asc = v_asc .
                v_asc_desc = v_asc_desc .
            END.
            FIND FIRST cc_mstr WHERE cc_ctr = glt_cc NO-LOCK NO-ERROR.
            IF AVAIL cc_mstr AND cc_ctr <> "" THEN DO:
                v_asc = v_asc + "-" + glt_cc .
                v_asc_desc = v_asc_desc + "-" + cc_desc .
            END.
            ELSE DO:
                v_asc = v_asc .
                v_asc_desc = v_asc_desc .
            END.
    
            v_dr_amt = 0.
            v_cr_amt = 0.
            IF (glt_amt >= 0 AND glt_correction = FALSE ) OR
               (glt_amt <  0 AND glt_correction = TRUE  )
            THEN
                ASSIGN v_dr_amt = glt_amt 
                       v_cr_amt = 0.
            ELSE
                ASSIGN v_cr_amt = - glt_amt 
                       v_dr_amt = 0.
    
            v_glta_amt = 0.
            FIND FIRST glta_det WHERE glta_ref = glt_ref 
                                  AND glta_line = glt_line NO-LOCK NO-ERROR.
            IF AVAIL glta_det THEN DO:
                v_glta_amt = glta_amt .
            END.
    
            v_dr_price = 0.
            v_dr_glta_amt = 0.
            v_cr_price = 0.
            v_cr_glta_amt = 0.
            IF v_dr_amt <> 0 THEN DO:
                IF v_glta_amt <> 0 THEN v_dr_price = v_dr_amt / v_glta_amt .
                                   ELSE v_dr_price = 0 .
                v_dr_glta_amt = v_glta_amt.
            END.
            IF v_cr_amt <> 0 THEN DO: 
                IF v_glta_amt <> 0 THEN v_cr_price = v_cr_amt / v_glta_amt .
                                   ELSE v_cr_price = 0 .
                v_cr_glta_amt = v_glta_amt .
            END.
            
            CREATE tt2.
            ASSIGN
                tt2_asc = v_asc 
                tt2_asc_desc = v_asc_desc 
                tt2_acc = glt_acct
                tt2_sub = glt_sub
                tt2_ctr = glt_cc
                tt2_date = STRING(YEAR(glt_effdate),"9999") + "." + STRING(MONTH(glt_effdate),"99") + "." + STRING(DAY(glt_effdate),"99") 
                tt2_ref = glt_ref 
                tt2_line = glt_line
                tt2_desc = glt_desc 
                tt2_dr_glta_amt = abs(v_dr_glta_amt) 
                tt2_cr_glta_amt = abs(v_cr_glta_amt)
                tt2_dr_amt = v_dr_amt
                tt2_cr_amt = v_cr_amt
                tt2_dr_price = abs(v_dr_price)
                tt2_cr_price = abs(v_cr_price)
                .
        END.
    END. /* IF inclpost = YES THEN DO: */

    EMPTY TEMP-TABLE tt3.
    FOR EACH tt2 BREAK BY tt2_asc :
        ACCUMULATE tt2_dr_glta_amt ( TOTAL BY tt2_asc ) .
        ACCUMULATE tt2_cr_glta_amt ( TOTAL BY tt2_asc ) .
        ACCUMULATE tt2_dr_amt      ( TOTAL BY tt2_asc ) .
        ACCUMULATE tt2_cr_amt      ( TOTAL BY tt2_asc ) .

        IF LAST-OF(tt2_asc) THEN DO:
            CREATE tt3 .
            ASSIGN
                tt3_asc = tt2_asc 
                tt3_dr_glta_amt = (ACCUMULATE TOTAL BY tt2_asc tt2_dr_glta_amt )
                tt3_cr_glta_amt = (ACCUMULATE TOTAL BY tt2_asc tt2_cr_glta_amt ) 
                tt3_dr_amt      = (ACCUMULATE TOTAL BY tt2_asc tt2_dr_amt) 
                tt3_cr_amt      = (ACCUMULATE TOTAL BY tt2_asc tt2_cr_amt) 
                .
        END.
    END.

    /* 是否只输出有发生额的科目 */
    IF v_occur = NO THEN DO:
        v_asc = "".
        v_asc_desc = "" .
        FOR EACH ASC_mstr WHERE ASC_acc >= acc AND ASC_acc <= acc1 
                            AND ASC_sub >= sub AND ASC_sub <= sub1
                            AND ASC_cc  >= ctr AND ASC_cc  <= ctr1
                            NO-LOCK :
            FIND FIRST tt WHERE tt_acc = ASC_acc 
                            AND tt_sub = ASC_sub
                            AND tt_ctr = ASC_cc NO-LOCK NO-ERROR.
            IF NOT AVAIL tt THEN DO:
                FIND FIRST ac_mstr WHERE ac_code = asc_acc NO-LOCK NO-ERROR.
                IF AVAIL ac_mstr AND ac_code <> "" THEN DO:
                    v_asc = ac_code .
                    v_asc_desc = ac_desc .
                END.
                FIND FIRST sb_mstr WHERE sb_sub = asc_sub NO-LOCK NO-ERROR.
                IF AVAIL sb_mstr AND sb_sub <> "" THEN DO:
                    v_asc = v_asc + "-" + sb_sub .
                    v_asc_desc = v_asc_desc + "-" + sb_desc .
                END.
                ELSE DO:
                    v_asc = v_asc .
                    v_asc_desc = v_asc_desc .
                END.
                FIND FIRST cc_mstr WHERE cc_ctr = asc_cc NO-LOCK NO-ERROR.
                IF AVAIL cc_mstr AND cc_ctr <> "" THEN DO:
                    v_asc = v_asc + "-" + cc_ctr .
                    v_asc_desc = v_asc_desc + "-" + cc_desc .
                END.
                ELSE DO:
                    v_asc = v_asc .
                    v_asc_desc = v_asc_desc .
                END.

                CREATE tt .
                ASSIGN 
                    tt_asc = v_asc 
                    tt_asc_desc = v_asc_desc
                    tt_acc = ASC_acc 
                    tt_sub = ASC_sub
                    tt_ctr = ASC_cc 
                    tt_ref = ""
                    .
                v_asc = "".
                v_asc_desc = "" .
            END.
        END.
    END.

    /*

    PUT UNFORMATTED "tt" SKIP.
    FOR EACH tt :
        EXPORT DELIMITER ";" tt .
    END. */

    /*
    PUT UNFORMATTED "ExecutionFile" ";" "txt2xls2.exe" SKIP.
    PUT UNFORMATTED "ExcelFile" ";" "a6glrp01" SKIP.
    PUT UNFORMATTED "SaveFile" ";" "数量金额帐" SKIP.
    PUT UNFORMATTED "PrintPreview" ";" "no" SKIP.
    PUT UNFORMATTED "ActiveSheet" ";" "1" SKIP.
    PUT UNFORMATTED "Format" ";" "no" SKIP.
    PUT UNFORMATTED "xlHAlignCenterAcrossSelection" ";" "1" SKIP.

    FIND FIRST usr_mstr WHERE usr_userid = global_userid NO-LOCK NO-ERROR.
    IF AVAIL USr_mstr THEN DO:
       v_username = "由 " + usr_name + " 打印 " .
    END.

    PUT UNFORMATTED "LeftFooter" ";"  v_username +  "( 日期: " + string(YEAR(TODAY)) + "." + STRING(MONTH(TODAY)) + "." + STRING(DAY(TODAY)) + ", " + "时间: " + string(TIME,"HH:MM:SS") + " )" SKIP .
      */
    
    FIND FIRST usr_mstr WHERE usr_userid = global_userid NO-LOCK NO-ERROR.
    IF AVAIL USr_mstr THEN DO:
       v_username = "由 " + usr_name + " 打印 " .
    END.

    PUT UNFORMATTED "#def REPORTPATH=$/财务/BI报表/a6glrp51" SKIP.
    PUT UNFORMATTED "#def :end" SKIP.
    v_dispdate = "期间: 从 " + 
                    STRING(YEAR(effdate),"9999") + "年" + 
                    STRING(MONTH(effdate),"99") + "月" + 
                    STRING(DAY(effdate),"99") + "日" + " 至 " +
                    STRING(YEAR(effdate1),"9999") + "年" + 
                    STRING(MONTH(effdate1),"99") + "月" + 
                    STRING(DAY(effdate1),"99") + "日" .

    /*
    PUT UNFORMATTED "广州昭和汽车零部件有限公司" SKIP.
    PUT UNFORMATTED "数量金额帐" SKIP.
    PUT UNFORMATTED "期间: 从 " + 
                    STRING(YEAR(effdate)) + "." + 
                    STRING(MONTH(effdate)) + "." + 
                    STRING(DAY(effdate)) + " 至 " +
                    STRING(YEAR(effdate1)) + "." + 
                    STRING(MONTH(effdate1)) + "." + 
                    STRING(DAY(effdate1)) SKIP.
    PUT "  " SKIP.
      */

    ii = 0.
    FOR EACH tt NO-LOCK BREAK BY tt_asc BY substring(tt_date,1,4) BY SUBSTRING(tt_date,6,2) BY tt_ref  :
        v_first_qty = 0.
        v_first_amt = 0.
        IF FIRST-OF(tt_asc) THEN DO:
            FIND FIRST tt3 WHERE tt3_asc = tt_asc NO-LOCK NO-ERROR.
            IF AVAIL tt3 THEN DO:
                 v_tt2_dr_glta_amt = tt3_dr_glta_amt .
                 v_tt2_cr_glta_amt = tt3_cr_glta_amt .
                 v_tt2_dr_amt = tt3_dr_amt.
                 v_tt2_cr_amt = tt3_cr_amt .
            END.

            FIND FIRST tt1 WHERE tt1_acc = tt_acc AND tt1_sub = tt_sub
                             AND tt1_ctr = tt_ctr NO-LOCK NO-ERROR.
            IF AVAIL tt1 THEN DO:
                v_first_qty = tt1_qty .
                v_first_amt = tt1_amt .
            END.
            ii = ii + 1.
            i = 0 .
            PUT UNFORMATTED v_dispdate ";" "科目编号: " + tt_asc + "[ " + tt_asc_desc + "]" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" "计量单位: 支" ";" "          第" + STRING(ii) + "页" SKIP.
            i = i + 1.
            PUT UNFORMATTED v_dispdate ";" "日期" ";" "凭证编号" ";" "摘要" ";" "借方" ";" 
                            ";" ";" "贷方" ";" ";" ";" "结存" ";" ";" SKIP.
            i = i + 1.
            PUT UNFORMATTED v_dispdate ";" ";" ";" ";" "数量" ";" "单价" ";" "金额" ";" 
                            "数量" ";" "单价" ";" "金额" ";"
                            "数量" ";" "单价" ";" "金额" SKIP.
            i = i + 1 .
            PUT UNFORMATTED v_dispdate ";" ";" ";" "期初余额" ";" ";" ";" ";" ";" ";" ";" 
                            v_first_qty ";" .
            IF v_first_qty <> 0 THEN DO: 
               PUT UNFORMATTED (v_first_amt / v_first_qty) ";" v_first_amt SKIP .
               i = i + 1.
            END.
            ELSE DO:
               PUT UNFORMATTED 0 ";" v_first_amt SKIP .
               i = i + 1.
            END.                
            v_tot_qty = 0.
            v_tot_amt = 0.
        END.

        PUT UNFORMATTED v_dispdate ";" tt_date ";" tt_ref ";" tt_desc ";" .
        v_tot_qty = v_tot_qty + v_first_qty + tt_dr_glta_amt - tt_cr_glta_amt .
        v_tot_amt = v_tot_amt + v_first_amt + tt_dr_amt - tt_cr_amt .
        v_first_qty = 0.
        v_first_amt = 0.
        PUT UNFORMATTED tt_dr_glta_amt ";" tt_dr_price ";" tt_dr_amt ";" 
                        tt_cr_glta_amt ";" tt_cr_price ";" tt_cr_amt ";"
                        v_tot_qty ";" .
        IF v_tot_qty <> 0 THEN DO: 
           PUT UNFORMATTED ABS(v_tot_amt / v_tot_qty) ";" v_tot_amt SKIP.
           i = i + 1.
           IF i = 33 THEN DO:
                   PUT UNFORMATTED v_dispdate ";" v_username +  "( 日期: " + string(YEAR(TODAY)) + "." + STRING(MONTH(TODAY)) + "." + STRING(DAY(TODAY)) + ", " + "时间: " + string(TIME,"HH:MM:SS") + " )" 
                       ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP.
               i = i + 1.
           END.
           IF i >= 34 THEN DO:
                     ii = ii + 1.
                     i = 0.
                     PUT UNFORMATTED v_dispdate ";" "科目编号: " + tt_asc + "[ " + tt_asc_desc + "]" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" "计量单位: 支:" ";" "          第" + STRING(ii) + "页" SKIP.
                     i = i + 1.
                     PUT UNFORMATTED v_dispdate ";" "日期" ";" "凭证编号" ";" "摘要" ";" "借方" ";" 
                                     ";" ";" "贷方" ";" ";" ";" "结存" ";" ";" SKIP.
                     i = i + 1.
                     PUT UNFORMATTED v_dispdate ";" ";" ";" ";" "数量" ";" "单价" ";" "金额" ";" 
                                     "数量" ";" "单价" ";" "金额" ";"
                                     "数量" ";" "单价" ";" "金额" SKIP.
                     i = i + 1 .
           END.
        END.
        ELSE DO: 
           PUT UNFORMATTED 0 ";" v_tot_amt SKIP.
           i = i + 1.
           IF i = 33 THEN DO:
                   PUT UNFORMATTED v_dispdate ";" v_username +  "( 日期: " + string(YEAR(TODAY)) + "." + STRING(MONTH(TODAY)) + "." + STRING(DAY(TODAY)) + ", " + "时间: " + string(TIME,"HH:MM:SS") + " )"
                      ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP.
               i = i + 1.
           END.
           IF i >= 34 THEN DO:
                     ii = ii + 1.
                     i = 0 .
                     PUT UNFORMATTED v_dispdate ";" "科目编号: " + tt_asc + "[ " + tt_asc_desc + "]" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" "计量单位: 支" ";" "          第" + STRING(ii) + "页" SKIP.
                     i = i + 1.
                     PUT UNFORMATTED v_dispdate ";" "日期" ";" "凭证编号" ";" "摘要" ";" "借方" ";" 
                                     ";" ";" "贷方" ";" ";" ";" "结存" ";" ";" SKIP.
                     i = i + 1.
                     PUT UNFORMATTED v_dispdate ";" ";" ";" ";" "数量" ";" "单价" ";" "金额" ";" 
                                     "数量" ";" "单价" ";" "金额" ";"
                                     "数量" ";" "单价" ";" "金额" SKIP.
                     i = i + 1 .
           END.
        END.
        
        ACCUMULATE tt_dr_glta_amt ( TOTAL BY tt_asc BY substring(tt_date,1,4) BY SUBSTRING(tt_date,6,2) ).
        ACCUMULATE tt_cr_glta_amt ( TOTAL BY tt_asc BY substring(tt_date,1,4) BY SUBSTRING(tt_date,6,2) ).
        ACCUMULATE tt_dr_amt      ( TOTAL BY tt_asc BY substring(tt_date,1,4) BY SUBSTRING(tt_date,6,2) ).
        ACCUMULATE tt_cr_amt      ( TOTAL BY tt_asc BY substring(tt_date,1,4) BY SUBSTRING(tt_date,6,2) ).
        IF LAST-OF( SUBSTRING(tt_date,6,2) ) THEN DO:
            PUT UNFORMATTED v_dispdate ";" ";" ";" "本月合计" ";" .
            IF (ACCUMULATE TOTAL BY SUBSTRING(tt_date,6,2) tt_dr_glta_amt ) <> 0 THEN PUT UNFORMATTED (ACCUMULATE TOTAL BY SUBSTRING(tt_date,6,2) tt_dr_glta_amt ) ";" ";" .
                                                                  ELSE PUT ";" ";" .
            IF (ACCUMULATE TOTAL BY SUBSTRING(tt_date,6,2) tt_dr_amt ) <> 0 THEN PUT UNFORMATTED (ACCUMULATE TOTAL BY SUBSTRING(tt_date,6,2) tt_dr_amt ) ";" .
                                                             ELSE PUT ";" .
            IF (ACCUMULATE TOTAL BY SUBSTRING(tt_date,6,2) tt_cr_glta_amt ) <> 0 THEN PUT UNFORMATTED (ACCUMULATE TOTAL BY SUBSTRING(tt_date,6,2) tt_cr_glta_amt ) ";" ";" .
                                                                  ELSE PUT ";" ";" .
            IF (ACCUMULATE TOTAL BY SUBSTRING(tt_date,6,2) tt_cr_amt ) <> 0 THEN PUT UNFORMATTED (ACCUMULATE TOTAL BY SUBSTRING(tt_date,6,2) tt_cr_amt ) ";"  .
                                                             ELSE PUT ";" .
            PUT UNFORMATTED v_tot_qty ";" .
            IF v_tot_qty <> 0 THEN DO: 
               PUT UNFORMATTED (v_tot_amt / v_tot_qty) ";" v_tot_amt SKIP.
               i = i + 1.
               IF i = 33 THEN DO:
                   PUT UNFORMATTED v_dispdate ";" v_username +  "( 日期: " + string(YEAR(TODAY)) + "." + STRING(MONTH(TODAY)) + "." + STRING(DAY(TODAY)) + ", " + "时间: " + string(TIME,"HH:MM:SS") + " )"
                       ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP.
                   i = i + 1.
               END.
               IF i >= 34 THEN DO:
                     ii = ii + 1.
                     i = 0 .
                     PUT UNFORMATTED v_dispdate ";" "科目编号: " + tt_asc + "[ " + tt_asc_desc + "]" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" "计量单位: 支" ";" "          第" + STRING(ii) + "页" SKIP.
                     i = i + 1.
                     PUT UNFORMATTED v_dispdate ";" "日期" ";" "凭证编号" ";" "摘要" ";" "借方" ";" 
                                     ";" ";" "贷方" ";" ";" ";" "结存" ";" ";" SKIP.
                     i = i + 1.
                     PUT UNFORMATTED v_dispdate ";" ";" ";" ";" "数量" ";" "单价" ";" "金额" ";" 
                                     "数量" ";" "单价" ";" "金额" ";"
                                     "数量" ";" "单价" ";" "金额" SKIP.
                     i = i + 1 .
               END.
            END.
            ELSE do:
               PUT UNFORMATTED 0 ";" v_tot_amt SKIP .
               i = i + 1.
               IF i = 33 THEN DO:
                   PUT UNFORMATTED v_dispdate ";" v_username +  "( 日期: " + string(YEAR(TODAY)) + "." + STRING(MONTH(TODAY)) + "." + STRING(DAY(TODAY)) + ", " + "时间: " + string(TIME,"HH:MM:SS") + " )"
                       ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP.
                   i = i + 1.
               END.
               IF i >= 34 THEN DO:
                     ii = ii + 1.
                     i = 0.
                     PUT UNFORMATTED v_dispdate ";" "科目编号: " + tt_asc + "[ " + tt_asc_desc + "]" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" "计量单位: 支" ";" "          第" + STRING(ii) + "页" SKIP.
                     i = i + 1.
                     PUT UNFORMATTED v_dispdate ";" "日期" ";" "凭证编号" ";" "摘要" ";" "借方" ";" 
                                     ";" ";" "贷方" ";" ";" ";" "结存" ";" ";" SKIP.
                     i = i + 1.
                     PUT UNFORMATTED v_dispdate ";" ";" ";" ";" "数量" ";" "单价" ";" "金额" ";" 
                                     "数量" ";" "单价" ";" "金额" ";"
                                     "数量" ";" "单价" ";" "金额" SKIP.
                     i = i + 1 .
               END.
            END.
        END.

        IF LAST-OF( SUBSTRING(tt_date,1,4) ) THEN DO:  
            PUT UNFORMATTED v_dispdate ";" ";" ";" "本年累计" ";"  .
            IF (ACCUMULATE TOTAL BY SUBSTRING(tt_date,1,4) tt_dr_glta_amt ) <> 0 THEN PUT UNFORMATTED (ACCUMULATE TOTAL BY SUBSTRING(tt_date,1,4) tt_dr_glta_amt ) + v_tt2_dr_glta_amt ";" ";" .
                                                                  ELSE PUT ";" ";"  .
            IF (ACCUMULATE TOTAL BY SUBSTRING(tt_date,1,4) tt_dr_amt ) <> 0 THEN PUT UNFORMATTED (ACCUMULATE TOTAL BY SUBSTRING(tt_date,1,4) tt_dr_amt ) + v_tt2_dr_amt  ";" .
                                                             ELSE PUT ";" .
            IF (ACCUMULATE TOTAL BY SUBSTRING(tt_date,1,4) tt_cr_glta_amt ) <> 0 THEN PUT UNFORMATTED (ACCUMULATE TOTAL BY SUBSTRING(tt_date,1,4) tt_cr_glta_amt ) + v_tt2_cr_glta_amt ";" ";" .
                                                                  ELSE PUT ";" ";" .
            IF (ACCUMULATE TOTAL BY SUBSTRING(tt_date,1,4) tt_cr_amt ) <> 0 THEN PUT UNFORMATTED (ACCUMULATE TOTAL BY SUBSTRING(tt_date,1,4) tt_cr_amt ) + v_tt2_cr_amt ";" .
                                                             ELSE PUT ";" .
            PUT UNFORMATTED v_tot_qty ";" .
            IF v_tot_qty <> 0 THEN DO: 
               PUT UNFORMATTED (v_tot_amt / v_tot_qty) ";" v_tot_amt SKIP. 
               i = i + 1.
                
                jj = i .
                IF 33 - i > 0 THEN DO:
                    DO j = 1 TO ( 33 - jj) :
                        PUT UNFORMATTED v_dispdate ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP.
                        i = i + 1.
                    END.
                END.

               IF i = 33 THEN DO:
                   PUT UNFORMATTED v_dispdate ";" v_username +  "( 日期: " + string(YEAR(TODAY)) + "." + STRING(MONTH(TODAY)) + "." + STRING(DAY(TODAY)) + ", " + "时间: " + string(TIME,"HH:MM:SS") + " )"
                       ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP.
                   i = i + 1.
               END. 
            END.
            ELSE do:
               PUT UNFORMATTED 0 ";" v_tot_amt SKIP.
               i = i + 1.

                jj = i .
                IF 33 - i > 0 THEN DO:
                    DO j = 1 TO ( 33 - jj) :
                        PUT UNFORMATTED v_dispdate ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP.
                        i = i + 1.
                    END.
                END.
    
               IF i = 33 THEN DO:
                   PUT UNFORMATTED v_dispdate ";" v_username +  "( 日期: " + string(YEAR(TODAY)) + "." + STRING(MONTH(TODAY)) + "." + STRING(DAY(TODAY)) + ", " + "时间: " + string(TIME,"HH:MM:SS") + " )"
                       ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP.
                   i = i + 1.
               END.
            END.
        END.
                   
        /*
        IF i = 32 THEN DO:
            PUT UNFORMATTED v_dispdate ";" ";" ";" v_username +  "( 日期: " + string(YEAR(TODAY)) + "." + STRING(MONTH(TODAY)) + "." + STRING(DAY(TODAY)) + ", " + "时间: " + string(TIME,"HH:MM:SS") + " )"
                ";" ";" ";" ";" ";" ";" ";" ";" ";" SKIP.
            i = i + 1.
        END. */
    END.

{a6mfrtrail.i}
                                                                                    
