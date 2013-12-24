/* REVISION: eb21sp3      LAST MODIFIED: 11/07/06   BY: *SS - Micho - 20061107* Micho Yang     */
/* REVISION: eb21sp3      LAST MODIFIED: 12/28/06   BY: *SS - Micho - 20061228* Micho Yang     */
/* REVISION: eb21sp3      LAST MODIFIED: 02/10/07   BY: *SS - 20070211.1* Bill Jiang     */
/* REVISION: eb21sp3      LAST MODIFIED: 02/22/09   BY: *SS - 20090222.1* Micho Yang     */

/* SS - 20090222.1 - B */
/*
是否包括无发生额的科目： no 
*/
/* SS - 20090222.1 - E */

/* SS - 20070211.1 - B */
/*
1. 不允许输出空格,否则会造成数据类型不一致和格式错误
*/
/* SS - 20070211.1 - E */

/* SS - 20070211.1 - B */
DEFINE VARIABLE i1 AS INTEGER.
/* SS - 20070211.1 - E */

DEF VAR v_ac_beg_amt AS DECIMAL.
DEF VAR v_ac_beg_curramt AS DECIMAL.
DEF VAR v_dr_amt AS DECIMAL.
DEF VAR v_cr_amt AS DECIMAL.
DEF VAR v_dr_curr_amt AS DECIMAL.
DEF VAR v_cr_curr_amt AS DECIMAL.
DEF VAR v_ac_desc AS CHAR.
DEF VAR v_curr_desc AS CHAR.
DEF VAR v_sb_desc AS CHAR.
DEF VAR v_cc_desc AS CHAR.
DEF VAR v_effdate AS DATE.
DEF VAR v_effdate1 AS DATE . 
DEF VAR v_flag AS LOGICAL INIT NO.
DEF VAR v_flag1 AS LOGICAL INIT YES .
DEF VAR v_total_dr_amt AS DECIMAL.
DEF VAR v_total_cr_amt AS DECIMAL.
DEF VAR v_total_dr_curr_amt AS DECIMAL.
DEF VAR v_total_cr_curr_amt AS DECIMAL.
DEF VAR v_totaly_dr_amt AS DECIMAL.
DEF VAR v_totaly_cr_amt AS DECIMAL.
DEF VAR v_totaly_dr_curr_amt AS DECIMAL.
DEF VAR v_totaly_cr_curr_amt AS DECIMAL.

DEF VAR v_beg_amt AS DECIMAL.
DEF VAR v_beg_curramt AS DECIMAL.
DEF VAR v_account AS CHAR.
DEF VAR v_account_desc AS CHAR.
DEF VAR v_beg_flag AS LOGICAL.
DEF VAR v_type AS CHAR.
DEF VAR v_ac_type AS CHAR .

DEF TEMP-TABLE tt 
    FIELD tt_acc LIKE gltr_acc
    FIELD tt_ac_desc LIKE ac_desc
    FIELD tt_sub LIKE gltr_sub
    FIELD tt_sb_desc LIKE sb_desc
    FIELD tt_ctr LIKE gltr_ctr
    FIELD tt_cc_desc LIKE cc_desc 
    FIELD tt_curr LIKE gltr_curr
    FIELD tt_beg_amt AS DECIMAL
    FIELD tt_beg_curramt AS DECIMAL
    FIELD tt_dr_amt AS DECIMAL
    FIELD tt_cr_amt AS DECIMAL
    FIELD tt_curr_dr_amt AS DECIMAL
    FIELD tt_curr_cr_amt AS DECIMAL
    FIELD tt_y_dr_amt AS DECIMAL
    FIELD tt_y_cr_amt AS DECIMAL
    FIELD tt_y_curr_dr_amt AS DECIMAL
    FIELD tt_y_curr_cr_amt AS DECIMAL
    INDEX acc_sub_ctr tt_acc tt_sub tt_ctr 
    .

DEF TEMP-TABLE tt2 
    FIELD tt2_by AS CHAR
    FIELD tt2_acc LIKE gltr_acc
    FIELD tt2_ac_desc LIKE ac_desc
    FIELD tt2_sub LIKE gltr_sub
    FIELD tt2_sb_desc LIKE sb_desc
    FIELD tt2_ctr LIKE gltr_ctr
    FIELD tt2_cc_desc LIKE cc_desc 
    FIELD tt2_curr LIKE gltr_curr
    FIELD tt2_beg_amt AS DECIMAL
    FIELD tt2_beg_curramt AS DECIMAL
    FIELD tt2_dr_amt AS DECIMAL
    FIELD tt2_cr_amt AS DECIMAL
    FIELD tt2_curr_dr_amt AS DECIMAL
    FIELD tt2_curr_cr_amt AS DECIMAL
    FIELD tt2_y_dr_amt AS DECIMAL
    FIELD tt2_y_cr_amt AS DECIMAL
    FIELD tt2_y_curr_dr_amt AS DECIMAL
    FIELD tt2_y_curr_cr_amt AS DECIMAL
    INDEX acc_sub_ctr tt2_acc tt2_sub tt2_ctr 
    .

DEF TEMP-TABLE ttb 
    FIELD ttb_by AS CHAR
    FIELD ttb_acc LIKE gltr_acc
    FIELD ttb_ac_desc LIKE ac_desc
    FIELD ttb_sub LIKE gltr_sub
    FIELD ttb_sb_desc LIKE sb_desc
    FIELD ttb_ctr LIKE gltr_ctr
    FIELD ttb_cc_desc LIKE cc_desc 
    FIELD ttb_curr LIKE gltr_curr
    FIELD ttb_beg_amt AS DECIMAL
    FIELD ttb_beg_curramt AS DECIMAL 
    FIELD ttb_dr_amt AS DECIMAL
    FIELD ttb_cr_amt AS DECIMAL
    FIELD ttb_curr_dr_amt AS DECIMAL
    FIELD ttb_curr_cr_amt AS DECIMAL
    FIELD ttb_y_dr_amt AS DECIMAL
    FIELD ttb_y_cr_amt AS DECIMAL
    FIELD ttb_y_curr_dr_amt AS DECIMAL
    FIELD ttb_y_curr_cr_amt AS DECIMAL
    INDEX acc_sub_ctr ttb_acc ttb_sub ttb_ctr 
    .

DEF TEMP-TABLE tt1 
    FIELD tt1_acc     LIKE gltr_acc
    FIELD tt1_sub     LIKE gltr_sub
    FIELD tt1_ctr     LIKE gltr_ctr
    FIELD tt1_amt     AS DECIMAL
    FIELD tt1_curramt AS DECIMAL
    INDEX acc_sub tt1_acc tt1_sub tt1_ctr 
    .

DEF TEMP-TABLE temp 
    FIELD temp_by            AS   CHAR
    FIELD temp_acc           LIKE gltr_acc
    FIELD temp_ac_desc       LIKE ac_desc 
    FIELD temp_sub           LIKE gltr_sub
    FIELD temp_sb_desc       LIKE sb_desc
    FIELD temp_ctr           LIKE gltr_ctr
    FIELD temp_cc_desc       LIKE cc_desc
    FIELD temp_curr          LIKE gltr_curr
    FIELD temp_beg_amt       AS DECIMAL
    FIELD temp_beg_curramt   AS DECIMAL
    FIELD temp_dr_amt        AS DECIMAL 
    FIELD temp_cr_amt        AS DECIMAL
    FIELD temp_curr_dr_amt   AS DECIMAL
    FIELD temp_curr_cr_amt   AS DECIMAL
    FIELD temp_y_dr_amt      AS DECIMAL
    FIELD temp_y_cr_amt      AS DECIMAL
    FIELD temp_y_curr_dr_amt AS DECIMAL
    FIELD temp_y_curr_cr_amt AS DECIMAL
    FIELD temp_type          AS CHAR
    INDEX acc_sub_ctr temp_acc temp_sub temp_ctr
    .
                                                
    FOR EACH tt1 :
        DELETE tt1 .
    END.

    FOR EACH tt :
        DELETE tt .
    END.
    /****************************** 取期初的原币/本币金额 B ****************/
    v_ac_beg_amt = 0.
    v_ac_beg_curramt = 0.
    FOR EACH acd_det NO-LOCK 
       WHERE acd_domain = GLOBAL_domain
       AND acd_acc >= acc 
       AND acd_acc <= acc1
       AND acd_sub >= sub
       AND acd_sub <= sub1
       AND acd_cc >= ctr
       AND acd_cc <= ctr1
       AND STRING(acd_year,"9999") + STRING(acd_per,"99") <
           STRING(YEAR(effdate),"9999") + STRING(MONTH(effdate),"99") 
       USE-INDEX acd_ind2 ,
       EACH ac_mstr NO-LOCK 
       WHERE ac_domain = GLOBAL_domain
       AND ac_code = acd_acc
       BREAK BY acd_acc BY acd_sub BY acd_cc :
       IF LOOKUP(ac_type,"A,L") <> 0 THEN DO:
          v_ac_beg_amt = v_ac_beg_amt + acd_amt .
          v_ac_beg_curramt = v_ac_beg_curramt + acd_curr_amt .
       END.
       ELSE DO:
          IF STRING(acd_year,"9999") + STRING(acd_per,"99") >= 
             STRING(YEAR(effdate),"9999") + STRING(1,"99")  THEN DO:
             v_ac_beg_amt = v_ac_beg_amt + acd_amt .
             v_ac_beg_curramt = v_ac_beg_curramt + acd_curr_amt .
          END.
       END.

       IF LAST-OF(acd_cc) THEN DO:
         CREATE tt1.
         ASSIGN
          tt1_acc     = acd_acc
          tt1_sub     = acd_sub
          tt1_ctr     = acd_cc
          tt1_amt     = v_ac_beg_amt      /* 本币金额 */
          tt1_curramt = v_ac_beg_curramt  /* 原币金额 */
          .
         v_ac_beg_amt = 0.
         v_ac_beg_curramt = 0.
       END.
    END. /* FOR EACH acd_det NO-LOCK  */

    IF DATE(MONTH(effdate),1,YEAR(effdate)) <> effdate THEN DO:
       v_ac_beg_amt = 0.
       v_ac_beg_curramt = 0.
       FOR EACH gltr_hist NO-LOCK WHERE gltr_domain = global_domain
                                    AND gltr_entity >= entity 
                                    AND gltr_entity <= entity1
                                    AND gltr_eff_dt >= DATE(MONTH(effdate),1,YEAR(effdate))
                                    AND gltr_eff_dt < effdate
                                    AND gltr_acc >= acc 
                                    AND gltr_acc <= acc1
                                    AND gltr_sub >= sub
                                    AND gltr_sub <= sub1
                                    AND gltr_ctr >= ctr 
                                    AND gltr_ctr <= ctr1
                                    BREAK BY gltr_acc BY gltr_sub BY gltr_ctr :
            v_ac_beg_amt = v_ac_beg_amt + gltr_amt .
            v_ac_beg_curramt = v_ac_beg_curramt + gltr_curramt .
           
           IF LAST-OF(gltr_ctr) THEN DO:
              FIND FIRST tt1 WHERE tt1_acc = gltr_acc AND tt1_sub = gltr_sub
                 AND tt1_ctr = gltr_ctr NO-ERROR.
              IF NOT AVAIL tt1 THEN DO:
                 CREATE tt1.
                  ASSIGN
                      tt1_acc     = gltr_acc
                      tt1_sub     = gltr_sub
                      tt1_ctr     = gltr_ctr
                      tt1_amt     = v_ac_beg_amt      /* 本币金额 */
                      tt1_curramt = v_ac_beg_curramt  /* 原币金额 */
                      .
              END.
              ELSE DO:
                 ASSIGN
                    tt1_amt = tt1_amt + v_ac_beg_amt 
                    tt1_curramt = tt1_curramt + v_ac_beg_curramt
                    .
              END.
 
              v_ac_beg_amt = 0.
              v_ac_beg_curramt = 0.
           END.     
       END.  
    END. /* IF DATE(MONTH(effdate),1,YEAR(effdate)) <> effdate THEN DO: */                     
    /****************************** 取期初的原币/本币金额 E *****************/

    /*************************** 取得本期 本年累计发生额 B **************************/
       /******************** SS - 20061228.1 - B ********************/
       /*
       FIND FIRST glcd_det WHERE glcd_domain = global_domain AND glcd_gl_clsd = NO AND glcd_year = YEAR(effdate) NO-LOCK NO-ERROR.
       IF AVAIL glcd_det THEN DO:
           v_effdate = DATE(glcd_per, 1, glcd_year)  .
       END.
       ELSE v_effdate = effdate .
       */
       v_effdate = DATE(1,1,YEAR(effdate)) .
       /******************** SS - 20061228.1 - E ********************/

    v_total_dr_amt = 0.
    v_total_cr_amt = 0.
    v_total_dr_curr_amt = 0.
    v_total_cr_curr_amt = 0.
    v_totaly_dr_amt = 0.
    v_totaly_cr_amt = 0.
    v_totaly_dr_curr_amt = 0.
    v_totaly_cr_curr_amt = 0.
    FOR EACH gltr_hist WHERE gltr_domain = GLOBAL_domain
                         AND gltr_entity >= entity 
                         AND gltr_entity <= entity1
                         AND gltr_eff_dt >= v_effdate
                         AND gltr_eff_dt <= effdate1
                         AND gltr_acc >= acc
                         AND gltr_acc <= acc1
                         AND gltr_sub >= sub
                         AND gltr_sub <= sub1
                         AND gltr_ctr >= ctr
                         AND gltr_ctr <= ctr1
                         NO-LOCK BREAK BY gltr_acc BY gltr_sub BY gltr_ctr :
        v_dr_amt = 0.
        v_cr_amt = 0 .
        v_dr_curr_amt = 0.
        v_cr_curr_amt = 0.                  
        IF (gltr_amt >= 0 AND gltr_correction = FALSE) OR
           (gltr_amt <  0 AND gltr_correction = TRUE ) THEN DO:
            v_dr_amt = gltr_amt.
            v_dr_curr_amt = gltr_curramt .
        END.
        ELSE DO:
            v_cr_amt = - gltr_amt.
            v_cr_curr_amt = - gltr_curramt .
        END.

        IF gltr_eff_dt >= effdate THEN DO:
           v_total_dr_amt = v_total_dr_amt + v_dr_amt .
           v_total_cr_amt = v_total_cr_amt + v_cr_amt.
           v_total_dr_curr_amt = v_total_dr_curr_amt + v_dr_curr_amt.
           v_total_cr_curr_amt = v_total_cr_curr_amt + v_cr_curr_amt .
        END.
        v_totaly_dr_amt = v_totaly_dr_amt + v_dr_amt .
        v_totaly_cr_amt = v_totaly_cr_amt + v_cr_amt.
        v_totaly_dr_curr_amt = v_totaly_dr_curr_amt + v_dr_curr_amt.
        v_totaly_cr_curr_amt = v_totaly_cr_curr_amt + v_cr_curr_amt .        


        IF LAST-OF(gltr_ctr) THEN DO:
           CREATE tt.
           ASSIGN
               tt_acc = gltr_acc
               tt_sub = gltr_sub
               tt_ctr = gltr_ctr
               tt_dr_amt = v_total_dr_amt
               tt_cr_amt = v_total_cr_amt
               tt_curr_dr_amt = v_total_dr_curr_amt
               tt_curr_cr_amt = v_total_cr_curr_amt
               tt_y_dr_amt = v_totaly_dr_amt
               tt_y_cr_amt = v_totaly_cr_amt
               tt_y_curr_dr_amt = v_totaly_dr_curr_amt
               tt_y_curr_cr_amt = v_totaly_cr_curr_amt
               .

           v_total_dr_amt = 0.
           v_total_cr_amt = 0.
           v_total_dr_curr_amt = 0.
           v_total_cr_curr_amt = 0.
           v_totaly_dr_amt = 0.
           v_totaly_cr_amt = 0.
           v_totaly_dr_curr_amt = 0.
           v_totaly_cr_curr_amt = 0.
        END.
    END.        
    /*************************** 取得本年累计发生额 E **************************/

    /*************************** 包括未过帐的凭证 B       **************************/
    IF v_post = YES THEN DO:
       v_ac_beg_amt = 0.
       v_ac_beg_curramt = 0.
       FOR EACH glt_det NO-LOCK WHERE glt_domain = global_domain
                                     AND glt_entity >= entity
                                     AND glt_entity <= entity1
                                     AND glt_acc >= acc 
                                     AND glt_acc <= acc1
                                     AND glt_sub >= sub
                                     AND glt_sub <= sub1
                                     AND glt_cc >= ctr 
                                     AND glt_cc <= ctr1 
                                     AND glt_effdate < effdate
                                     USE-INDEX glt_index ,
           EACH ac_mstr NO-LOCK WHERE ac_domain = GLOBAL_domain
                                  AND ac_code = glt_acc 
                                     BREAK BY glt_acc BY glt_sub BY glt_cc :
            if lookup(ac_type, "A,L") = 0 then do:
                IF glt_effdate >= DATE(1,1,YEAR(effdate)) AND glt_effdate < effdate THEN DO:
                   v_ac_beg_amt = v_ac_beg_amt + glt_amt .
                   v_ac_beg_curramt = v_ac_beg_curramt + glt_curr_amt .
                END.
            END.
            ELSE DO:
                   v_ac_beg_amt = v_ac_beg_amt + glt_amt .
                   v_ac_beg_curramt = v_ac_beg_curramt + glt_curr_amt .
            END.
            IF LAST-OF(glt_cc) THEN DO:
                FIND FIRST tt1 WHERE tt1_acc = glt_acc AND tt1_sub = glt_sub AND tt1_ctr = glt_cc NO-LOCK NO-ERROR.
                IF AVAIL tt1 THEN DO:
                   tt1_amt = tt1_amt + v_ac_beg_amt .      /* 本币金额 */
                   tt1_curramt = tt1_curramt + v_ac_beg_curramt .  /* 原币金额 */ 
                END.
                ELSE DO:
                    CREATE tt1.
                    ASSIGN
                        tt1_acc     = glt_acc
                        tt1_sub     = glt_sub
                        tt1_ctr     = glt_cc
                        tt1_amt     = v_ac_beg_amt      /* 本币金额 */
                        tt1_curramt = v_ac_beg_curramt  /* 原币金额 */
                        .
                END.
                v_ac_beg_amt = 0.
                v_ac_beg_curramt = 0.
            END.     
       END.  

       v_total_dr_amt = 0.
       v_total_cr_amt = 0.
       v_total_dr_curr_amt = 0.
       v_total_cr_curr_amt = 0.
       v_totaly_dr_amt = 0.
       v_totaly_cr_amt = 0.
       v_totaly_dr_curr_amt = 0.
       v_totaly_cr_curr_amt = 0.
       FOR EACH glt_det WHERE glt_domain = global_domain 
                          AND glt_entity >= entity 
                          AND glt_entity <= entity1
                          AND glt_acc >= acc
                          AND glt_acc <= acc1
                          AND glt_sub >= sub
                          AND glt_sub <= sub1
                          AND glt_cc >= ctr 
                          AND glt_cc <= ctr1 
                          AND glt_effdate >= v_effdate
                          AND glt_effdate <= effdate1
                          USE-INDEX glt_index
                          NO-LOCK BREAK BY glt_acc BY glt_sub BY glt_cc :
           v_dr_amt = 0.
           v_cr_amt = 0.  
           v_dr_curr_amt = 0 .
           v_cr_curr_amt = 0 .
           if (glt_amt >= 0 AND glt_correction = false) or
              (glt_amt <  0 AND glt_correction = true)
           THEN DO:
                v_dr_amt = glt_amt .
                v_dr_curr_amt = glt_curr_amt.
           END.
           else DO:
                v_cr_amt = - glt_amt.
                v_cr_curr_amt = - glt_curr_amt .
           END.  

           IF glt_effdate >= effdate THEN DO:
              v_total_dr_amt = v_total_dr_amt + v_dr_amt .
              v_total_cr_amt = v_total_cr_amt + v_cr_amt .
              v_total_dr_curr_amt = v_total_dr_curr_amt + v_dr_curr_amt .
              v_total_cr_curr_amt = v_total_cr_curr_amt + v_cr_curr_amt .
           END.
           v_totaly_dr_amt = v_totaly_dr_amt + v_dr_amt .
           v_totaly_cr_amt = v_totaly_cr_amt + v_cr_amt .
           v_totaly_dr_curr_amt = v_totaly_dr_curr_amt + v_dr_curr_amt .
           v_totaly_cr_curr_amt = v_totaly_cr_curr_amt + v_cr_curr_amt .
 
           IF LAST-OF(glt_cc) THEN DO:
               FIND FIRST tt WHERE tt_acc = glt_acc
                               AND tt_sub = glt_sub
                               AND tt_ctr = glt_cc NO-ERROR.
               IF AVAIL tt THEN DO:
                   ASSIGN
                       tt_dr_amt = tt_dr_amt + v_total_dr_amt
                       tt_cr_amt = tt_cr_amt + v_total_cr_amt
                       tt_curr_dr_amt = tt_curr_dr_amt + v_total_dr_curr_amt 
                       tt_curr_cr_amt = tt_curr_cr_amt + v_total_cr_curr_amt
                       tt_y_dr_amt = tt_y_dr_amt + v_totaly_dr_amt
                       tt_y_cr_amt = tt_y_cr_amt + v_totaly_cr_amt
                       tt_y_curr_dr_amt = tt_y_curr_dr_amt + v_totaly_dr_curr_amt
                       tt_y_curr_cr_amt = tt_y_curr_cr_amt + v_totaly_cr_curr_amt 
                       .
               END.
                ELSE DO:
                    CREATE tt .
                    ASSIGN
                           tt_acc = glt_acc
                           tt_sub = glt_sub
                           tt_ctr = glt_cc
                           tt_dr_amt = v_total_dr_amt
                           tt_cr_amt = v_total_cr_amt
                           tt_curr_dr_amt = v_total_dr_curr_amt
                           tt_curr_cr_amt = v_total_cr_curr_amt
                           tt_y_dr_amt = v_totaly_dr_amt
                           tt_y_cr_amt = v_totaly_cr_amt
                           tt_y_curr_dr_amt = v_totaly_dr_curr_amt
                           tt_y_curr_cr_amt = v_totaly_cr_curr_amt
                           .
                END.
               v_total_dr_amt = 0.
               v_total_cr_amt = 0.
               v_total_dr_curr_amt = 0.
               v_total_cr_curr_amt = 0.
               v_totaly_dr_amt = 0.
               v_totaly_cr_amt = 0.
               v_totaly_dr_curr_amt = 0.
               v_totaly_cr_curr_amt = 0.
           END. /* IF LAST-OF(glt_cc) THEN DO: */
       END. /* FOR EACH glt_det */
    END. /* IF v_post = YES THEN DO: */
    /*************************** 包括未过帐的凭证 E       *************************/

    /*************************** 取得期初余额 B           *************************/
    FOR EACH tt :
        FIND FIRST tt1 WHERE tt1_acc = tt_acc AND tt1_sub = tt_sub
                         AND tt1_ctr = tt_ctr NO-LOCK NO-ERROR. .
        IF AVAIL tt1 THEN DO:
            ASSIGN
                tt_beg_amt     = tt1_amt 
                tt_beg_curramt = tt1_curramt
                .
        END.
    END.
    
    FOR EACH tt1 :
        FIND FIRST tt WHERE tt_acc = tt1_acc AND tt_sub = tt1_sub AND tt_ctr = tt1_ctr NO-LOCK NO-ERROR.
        IF NOT AVAIL tt THEN DO:
            CREATE tt .
            ASSIGN
               tt_acc = tt1_acc
               tt_sub = tt1_sub
               tt_ctr = tt1_ctr
               tt_beg_amt = tt1_amt
               tt_beg_curramt = tt1_curramt 
               .
       END.
    END.
    
    IF v_inc_flag = YES THEN DO:
        FOR EACH ASC_mstr WHERE ASC_domain = GLOBAL_domain
                                AND ASC_acc >= acc AND ASC_acc <= acc1 
                                AND ASC_sub >= sub AND ASC_sub <= sub1
                                AND ASC_cc  >= ctr AND ASC_cc  <= ctr1
                                NO-LOCK :
                 FIND FIRST tt WHERE tt_acc = ASC_acc 
                                 AND tt_sub = ASC_sub
                                 AND tt_ctr = ASC_cc NO-LOCK NO-ERROR.
                 IF NOT AVAIL tt THEN DO:
                      CREATE tt .
                      ASSIGN
                          tt_acc = ASC_acc
                          tt_sub = ASC_sub
                          tt_ctr = ASC_cc
                          .
                 END.
        END.
    END.
    /*************************** 取得期初余额 E           *************************/

    /* Add By:  SS - 20061103.1 Begin */
	 PUT UNFORMATTED "#def REPORTPATH=$/Minth/xxglrp01" SKIP.
	 PUT UNFORMATTED "#def :end" SKIP.
    /* Add By:  SS - 20061103.1 End */

    FOR EACH temp :
        DELETE temp.
    END.

    FOR EACH ttb:
        DELETE ttb .
    END.
    
    FOR EACH tt2 :
        DELETE tt2 .
    END.

    FOR EACH tt :
        v_ac_desc = "" .
        v_curr_desc = "" .
        v_sb_desc = "" .
        v_cc_desc = "" .
        v_ac_type = "" .
       FIND FIRST ac_mstr WHERE ac_domain = GLOBAL_domain 
                            AND ac_code = tt_acc NO-LOCK NO-ERROR.
       IF AVAIL ac_mstr AND ac_code <> "" THEN DO:
           v_ac_desc = ac_desc .
           v_curr_desc = ac_curr.
           v_ac_type = ac_type .
       END.

       FIND FIRST sb_mstr WHERE sb_domain = GLOBAL_domain
                            AND sb_sub = tt_sub NO-LOCK NO-ERROR.
       IF AVAIL sb_mstr THEN DO:
           v_sb_desc = sb_desc.
       END.
       FIND FIRST cc_mstr WHERE cc_domain = GLOBAL_domain 
                            AND cc_ctr = tt_ctr NO-LOCK NO-ERROR.
       IF AVAIL cc_mstr THEN DO:
           v_cc_desc = cc_desc .
       END.  

        CREATE tt2 .
        ASSIGN
            tt2_by            = "T"
            tt2_acc           = tt_acc           
            tt2_ac_desc       = v_ac_desc       
            tt2_sub           = tt_sub           
            tt2_sb_desc       = v_sb_desc       
            tt2_ctr           = tt_ctr           
            tt2_cc_desc       = v_cc_desc       
            tt2_curr          = v_curr_desc          
            tt2_beg_amt       = tt_beg_amt       
            tt2_beg_curramt   = tt_beg_curramt   
            tt2_dr_amt        = tt_dr_amt        
            tt2_cr_amt        = tt_cr_amt        
            tt2_curr_dr_amt   = tt_curr_dr_amt   
            tt2_curr_cr_amt   = tt_curr_cr_amt   
            tt2_y_dr_amt      = tt_y_dr_amt      
            tt2_y_cr_amt      = tt_y_cr_amt      
            tt2_y_curr_dr_amt = tt_y_curr_dr_amt 
            tt2_y_curr_cr_amt = tt_y_curr_cr_amt 
            .
    END.

    IF v_ln <> 0 THEN DO:
        FOR EACH tt BREAK BY substring(tt_acc,1,v_ln) :
            ACCUMULATE tt_beg_amt ( TOTAL BY substring(tt_acc,1,v_ln) ) .
            ACCUMULATE tt_dr_amt ( TOTAL BY substring(tt_acc,1,v_ln) ) .
            ACCUMULATE tt_cr_amt ( TOTAL BY substring(tt_acc,1,v_ln) ) .
            ACCUMULATE tt_y_dr_amt ( TOTAL BY substring(tt_acc,1,v_ln) ) .
            ACCUMULATE tt_y_cr_amt ( TOTAL BY substring(tt_acc,1,v_ln) ) .
    
            IF LAST-OF(substring(tt_acc,1,v_ln)) THEN DO:
                CREATE tt2 .
                ASSIGN
                    tt2_by            = "S"
                    tt2_acc           = substring(tt_acc,1,v_ln)         
                    tt2_ac_desc       = STRING(v_ln) 
                    tt2_sub           = ""          
                    tt2_sb_desc       = ""      
                    tt2_ctr           = ""
                    tt2_cc_desc       = ""
                    tt2_curr          = ""
                    tt2_beg_amt       = (ACCUMULATE TOTAL BY substring(tt_acc,1,v_ln) tt_beg_amt       )
                    tt2_dr_amt        = (ACCUMULATE TOTAL BY substring(tt_acc,1,v_ln) tt_dr_amt        )
                    tt2_cr_amt        = (ACCUMULATE TOTAL BY substring(tt_acc,1,v_ln) tt_cr_amt        )
                    tt2_y_dr_amt      = (ACCUMULATE TOTAL BY substring(tt_acc,1,v_ln) tt_y_dr_amt      )
                    tt2_y_cr_amt      = (ACCUMULATE TOTAL BY substring(tt_acc,1,v_ln) tt_y_cr_amt      )
                    .                 
            END.
        END.
    END.

    FOR EACH tt:
        DELETE tt .
    END.

    IF subflag = NO AND ccflag = NO THEN DO:
        FOR EACH tt2 WHERE tt2_by = "T" BREAK BY tt2_acc BY tt2_sub BY tt2_cc :
            FIND FIRST temp WHERE temp_acc = tt2_acc 
                              AND temp_sub = tt2_sub 
                              AND temp_ctr  = tt2_ctr NO-ERROR.
            IF NOT AVAIL temp THEN DO:
                CREATE temp .
                ASSIGN
                    temp_by             = tt2_by
                    temp_acc            = tt2_acc           
                    temp_ac_desc        = tt2_ac_desc                
                    temp_sub            = tt2_sub           
                    temp_sb_desc        = tt2_sb_desc       
                    temp_ctr            = tt2_ctr           
                    temp_cc_desc        = tt2_cc_desc       
                    temp_curr           = tt2_curr   
                    temp_beg_amt        = tt2_beg_amt
                    temp_beg_curramt    = tt2_beg_curramt
                    temp_dr_amt         = tt2_dr_amt        
                    temp_cr_amt         = tt2_cr_amt        
                    temp_curr_dr_amt    = tt2_curr_dr_amt   
                    temp_curr_cr_amt    = tt2_curr_cr_amt   
                    temp_y_dr_amt       = tt2_y_dr_amt      
                    temp_y_cr_amt       = tt2_y_cr_amt      
                    temp_y_curr_dr_amt  = tt2_y_curr_dr_amt 
                    temp_y_curr_cr_amt  = tt2_y_curr_cr_amt 
                    .
            END.
            ELSE DO:
                ASSIGN
                    temp_beg_amt        = temp_beg_amt       + tt2_beg_amt
                    temp_beg_curramt    = temp_beg_curramt   + tt2_beg_curramt
                    temp_dr_amt         = temp_dr_amt        + tt2_dr_amt        
                    temp_cr_amt         = temp_cr_amt        + tt2_cr_amt        
                    temp_curr_dr_amt    = temp_curr_dr_amt   + tt2_curr_dr_amt   
                    temp_curr_cr_amt    = temp_curr_cr_amt   + tt2_curr_cr_amt   
                    temp_y_dr_amt       = temp_y_dr_amt      + tt2_y_dr_amt      
                    temp_y_cr_amt       = temp_y_cr_amt      + tt2_y_cr_amt      
                    temp_y_curr_dr_amt  = temp_y_curr_dr_amt + tt2_y_curr_dr_amt 
                    temp_y_curr_cr_amt  = temp_y_curr_cr_amt + tt2_y_curr_cr_amt 
                    .
            END.

            IF tt2_ctr <> "" THEN DO:
                FIND FIRST temp WHERE temp_acc = tt2_acc 
                                  AND temp_sub = tt2_sub
                                  AND temp_ctr = "" NO-ERROR.
                IF NOT AVAIL temp THEN DO:
                    CREATE temp .
                    ASSIGN
                        temp_by             = tt2_by
                        temp_acc            = tt2_acc           
                        temp_ac_desc        = tt2_ac_desc               
                        temp_sub            = tt2_sub           
                        temp_sb_desc        = tt2_sb_desc       
                        temp_ctr            = ""           
                        temp_cc_desc        = ""
                        temp_curr           = tt2_curr 
                        temp_beg_amt        = tt2_beg_amt
                        temp_beg_curramt    = tt2_beg_curramt
                        temp_dr_amt         = tt2_dr_amt        
                        temp_cr_amt         = tt2_cr_amt        
                        temp_curr_dr_amt    = tt2_curr_dr_amt   
                        temp_curr_cr_amt    = tt2_curr_cr_amt   
                        temp_y_dr_amt       = tt2_y_dr_amt      
                        temp_y_cr_amt       = tt2_y_cr_amt      
                        temp_y_curr_dr_amt  = tt2_y_curr_dr_amt 
                        temp_y_curr_cr_amt  = tt2_y_curr_cr_amt 
                        temp_type           = "X"
                        .
                END.
                ELSE DO:
                    ASSIGN
                        temp_beg_amt        = temp_beg_amt       + tt2_beg_amt
                        temp_beg_curramt    = temp_beg_curramt   + tt2_beg_curramt
                        temp_dr_amt         = temp_dr_amt        + tt2_dr_amt        
                        temp_cr_amt         = temp_cr_amt        + tt2_cr_amt        
                        temp_curr_dr_amt    = temp_curr_dr_amt   + tt2_curr_dr_amt   
                        temp_curr_cr_amt    = temp_curr_cr_amt   + tt2_curr_cr_amt   
                        temp_y_dr_amt       = temp_y_dr_amt      + tt2_y_dr_amt      
                        temp_y_cr_amt       = temp_y_cr_amt      + tt2_y_cr_amt      
                        temp_y_curr_dr_amt  = temp_y_curr_dr_amt + tt2_y_curr_dr_amt 
                        temp_y_curr_cr_amt  = temp_y_curr_cr_amt + tt2_y_curr_cr_amt 
                        .
                END.
            END. /* IF tt2_ctr <> "" THEN DO: */

            IF tt2_sub <> "" THEN DO:
                FIND FIRST temp WHERE temp_acc = tt2_acc
                                  AND temp_sub = ""
                                  AND temp_ctr = "" NO-ERROR.
                IF NOT AVAIL temp THEN DO:
                    CREATE temp .
                    ASSIGN
                        temp_by             = tt2_by
                        temp_acc            = tt2_acc           
                        temp_ac_desc        = tt2_ac_desc               
                        temp_sub            = ""           
                        temp_sb_desc        = ""
                        temp_ctr            = ""           
                        temp_cc_desc        = ""
                        temp_curr           = tt2_curr   
                        temp_beg_amt        = tt2_beg_amt
                        temp_beg_curramt    = tt2_beg_curramt
                        temp_dr_amt         = tt2_dr_amt        
                        temp_cr_amt         = tt2_cr_amt        
                        temp_curr_dr_amt    = tt2_curr_dr_amt   
                        temp_curr_cr_amt    = tt2_curr_cr_amt   
                        temp_y_dr_amt       = tt2_y_dr_amt      
                        temp_y_cr_amt       = tt2_y_cr_amt      
                        temp_y_curr_dr_amt  = tt2_y_curr_dr_amt 
                        temp_y_curr_cr_amt  = tt2_y_curr_cr_amt 
                        temp_type           = "X"
                        .
                END.
                ELSE DO:
                    ASSIGN
                        temp_beg_amt        = temp_beg_amt       + tt2_beg_amt
                        temp_beg_curramt    = temp_beg_curramt   + tt2_beg_curramt
                        temp_dr_amt         = temp_dr_amt        + tt2_dr_amt        
                        temp_cr_amt         = temp_cr_amt        + tt2_cr_amt        
                        temp_curr_dr_amt    = temp_curr_dr_amt   + tt2_curr_dr_amt   
                        temp_curr_cr_amt    = temp_curr_cr_amt   + tt2_curr_cr_amt   
                        temp_y_dr_amt       = temp_y_dr_amt      + tt2_y_dr_amt      
                        temp_y_cr_amt       = temp_y_cr_amt      + tt2_y_cr_amt      
                        temp_y_curr_dr_amt  = temp_y_curr_dr_amt + tt2_y_curr_dr_amt 
                        temp_y_curr_cr_amt  = temp_y_curr_cr_amt + tt2_y_curr_cr_amt 
                        .
                END.
            END. /* IF tt2_sub <> "" THEN DO: */
        END. /* FOR EACH tt */

        IF v_ln <> 0 THEN DO:
            FOR EACH tt2 WHERE tt2_by = "S" :
                    CREATE temp .
                    ASSIGN
                        temp_by             = tt2_by
                        temp_acc            = tt2_acc           
                        temp_ac_desc        = tt2_ac_desc                
                        temp_sub            = tt2_sub           
                        temp_sb_desc        = tt2_sb_desc       
                        temp_ctr            = tt2_ctr           
                        temp_cc_desc        = tt2_cc_desc       
                        temp_curr           = tt2_curr   
                        temp_beg_amt        = tt2_beg_amt
                        temp_beg_curramt    = tt2_beg_curramt
                        temp_dr_amt         = tt2_dr_amt        
                        temp_cr_amt         = tt2_cr_amt        
                        temp_curr_dr_amt    = tt2_curr_dr_amt   
                        temp_curr_cr_amt    = tt2_curr_cr_amt   
                        temp_y_dr_amt       = tt2_y_dr_amt      
                        temp_y_cr_amt       = tt2_y_cr_amt      
                        temp_y_curr_dr_amt  = tt2_y_curr_dr_amt 
                        temp_y_curr_cr_amt  = tt2_y_curr_cr_amt 
                        .
            END.
        END.

        /* 如果不包含无发生额为 no ,则删除这些数据 */
        IF v_inc_flag = NO THEN DO:
           FOR EACH temp WHERE temp_beg_amt = 0 
              AND temp_beg_curramt = 0
              AND temp_dr_amt = 0
              AND temp_cr_amt = 0
              AND temp_curr_dr_amt = 0
              AND temp_curr_cr_amt = 0
              AND temp_y_dr_amt = 0
              AND temp_y_cr_amt = 0
              AND temp_y_curr_dr_amt = 0
              AND temp_y_curr_cr_amt = 0 :
              DELETE temp .
           END.
        END.

        v_account = "" .
        v_account_desc = "" .
        FOR EACH temp BY temp_acc BY temp_sub BY temp_ctr :
            IF temp_acc <> "" THEN v_account = temp_acc .
            IF temp_sub <> "" THEN v_account = v_account + "-" + temp_sub .
            IF temp_ctr <> "" THEN v_account = v_account + "-" + temp_ctr .

            IF temp_ac_desc <> "" THEN v_account_desc = temp_ac_desc .
            IF temp_sb_desc <> "" THEN DO: 
                IF temp_ac_desc <> "" THEN v_account_desc = v_account_desc + "-" + temp_sb_desc .
                                      ELSE v_account_desc = temp_sb_desc .
            END.
            IF temp_cc_desc <> "" THEN v_account_desc = v_account_desc + "-" + temp_cc_desc .

            PUT UNFORMATTED v_account ";" v_account_desc ";" .

            IF temp_beg_amt >= 0 THEN PUT UNFORMATTED temp_beg_amt ";" ";" .
                                 ELSE PUT UNFORMATTED ";" ABS(temp_beg_amt) ";" .
            PUT UNFORMATTED temp_dr_amt ";" temp_cr_amt ";" 
                            temp_y_dr_amt ";" temp_y_cr_amt ";" .
            IF (temp_beg_amt + temp_dr_amt - temp_cr_amt) >= 0
                THEN PUT UNFORMATTED ( temp_beg_amt + temp_dr_amt - temp_cr_amt) ";" ";" .
                ELSE PUT UNFORMATTED ";" ABS( temp_beg_amt + temp_dr_amt - temp_cr_amt) ";" .

            IF NOT (temp_curr = "CNY" OR temp_curr = "")  THEN DO:
                PUT UNFORMATTED temp_curr ";" .
                IF temp_beg_curramt >= 0 THEN PUT UNFORMATTED temp_beg_curramt ";" ";" .
                                         ELSE PUT UNFORMATTED ";" abs(temp_beg_curramt) ";" .
                PUT UNFORMATTED temp_curr_dr_amt ";" temp_curr_cr_amt ";" 
                                temp_y_curr_dr_amt ";" temp_y_curr_cr_amt ";" .
                IF ( temp_beg_curramt + temp_curr_dr_amt - temp_curr_cr_amt) >= 0
                    THEN PUT UNFORMATTED ( temp_beg_curramt + temp_curr_dr_amt - temp_curr_cr_amt) ";" ";" SKIP.
                    ELSE PUT UNFORMATTED ";" ABS( temp_beg_curramt + temp_curr_dr_amt - temp_curr_cr_amt) ";" SKIP .
            END.
            ELSE DO:
               /* SS - 20070211.1 - B */
               /*
               PUT temp_curr ";" " " ";" " " ";" " " ";" " " ";" " " ";" " " ";" " " ";" " " ";"  SKIP. 
               */
               PUT temp_curr.
               DO i1 = 1 TO 9:
                  PUT ";".
               END.
               PUT SKIP.
               /* SS - 20070211.1 - E */
            END.
        END. /* FOR EACH temp : */
    END. /* IF subflag = NO AND ccflag = NO THEN DO: */

    IF subflag = YES AND ccflag = NO THEN DO:
        FOR EACH tt2 WHERE tt2_by = "T" BREAK BY tt2_acc BY tt2_ctr :
            ACCUMULATE tt2_beg_amt       ( TOTAL BY tt2_acc BY tt2_ctr) .
            ACCUMULATE tt2_beg_curramt   ( TOTAL BY tt2_acc BY tt2_ctr) .
            ACCUMULATE tt2_dr_amt        ( TOTAL BY tt2_acc BY tt2_ctr) .
            ACCUMULATE tt2_cr_amt        ( TOTAL BY tt2_acc BY tt2_ctr) .
            ACCUMULATE tt2_curr_dr_amt   ( TOTAL BY tt2_acc BY tt2_ctr) .
            ACCUMULATE tt2_curr_cr_amt   ( TOTAL BY tt2_acc BY tt2_ctr) .
            ACCUMULATE tt2_y_dr_amt      ( TOTAL BY tt2_acc BY tt2_ctr) .
            ACCUMULATE tt2_y_cr_amt      ( TOTAL BY tt2_acc BY tt2_ctr) .
            ACCUMULATE tt2_y_curr_dr_amt ( TOTAL BY tt2_acc BY tt2_ctr) .
            ACCUMULATE tt2_y_curr_cr_amt ( TOTAL BY tt2_acc BY tt2_ctr) .

            IF LAST-OF(tt2_ctr) THEN DO:
               CREATE ttb .
               ASSIGN
                   ttb_by            = tt2_by
                   ttb_acc           = tt2_acc
                   ttb_ac_desc       = tt2_ac_desc 
                   ttb_ctr           = tt2_ctr
                   ttb_cc_desc       = tt2_cc_desc
                   ttb_curr          = tt2_curr
                   ttb_beg_amt       = (ACCUMULATE TOTAL BY tt2_ctr tt2_beg_amt) 
                   ttb_beg_curramt   = (ACCUMULATE TOTAL BY tt2_ctr tt2_beg_curramt) 
                   ttb_dr_amt        = (ACCUMULATE TOTAL BY tt2_ctr tt2_dr_amt) 
                   ttb_cr_amt        = (ACCUMULATE TOTAL BY tt2_ctr tt2_cr_amt) 
                   ttb_curr_dr_amt   = (ACCUMULATE TOTAL BY tt2_ctr tt2_curr_dr_amt) 
                   ttb_curr_cr_amt   = (ACCUMULATE TOTAL BY tt2_ctr tt2_curr_cr_amt) 
                   ttb_y_dr_amt      = (ACCUMULATE TOTAL BY tt2_ctr tt2_y_dr_amt) 
                   ttb_y_cr_amt      = (ACCUMULATE TOTAL BY tt2_ctr tt2_y_cr_amt) 
                   ttb_y_curr_dr_amt = (ACCUMULATE TOTAL BY tt2_ctr tt2_y_curr_dr_amt) 
                   ttb_y_curr_cr_amt = (ACCUMULATE TOTAL BY tt2_ctr tt2_y_curr_cr_amt) 
                   .
            END.    
        END. /* FOR EACH tt BREAK BY tt2_acc BY tt2_ctr : */

        FOR EACH ttb BREAK BY ttb_acc BY ttb_ctr :
            FIND FIRST temp WHERE temp_acc = ttb_acc 
                              AND temp_ctr = ttb_ctr NO-ERROR.
            IF NOT AVAIL temp THEN DO:
                CREATE temp.
                ASSIGN
                    temp_by             = ttb_by
                    temp_acc            = ttb_acc           
                    temp_ac_desc        = ttb_ac_desc                     
                    temp_ctr            = ttb_ctr           
                    temp_cc_desc        = ttb_cc_desc       
                    temp_curr           = ttb_curr 
                    temp_beg_amt        = ttb_beg_amt
                    temp_beg_curramt    = ttb_beg_curramt
                    temp_dr_amt         = ttb_dr_amt        
                    temp_cr_amt         = ttb_cr_amt        
                    temp_curr_dr_amt    = ttb_curr_dr_amt   
                    temp_curr_cr_amt    = ttb_curr_cr_amt   
                    temp_y_dr_amt       = ttb_y_dr_amt      
                    temp_y_cr_amt       = ttb_y_cr_amt      
                    temp_y_curr_dr_amt  = ttb_y_curr_dr_amt 
                    temp_y_curr_cr_amt  = ttb_y_curr_cr_amt 
                    .
            END.
            ELSE DO:
                ASSIGN
                    temp_beg_amt        = temp_beg_amt       + ttb_beg_amt
                    temp_beg_curramt    = temp_beg_curramt   + ttb_beg_curramt
                    temp_dr_amt         = temp_dr_amt        + ttb_dr_amt        
                    temp_cr_amt         = temp_cr_amt        + ttb_cr_amt        
                    temp_curr_dr_amt    = temp_curr_dr_amt   + ttb_curr_dr_amt   
                    temp_curr_cr_amt    = temp_curr_cr_amt   + ttb_curr_cr_amt   
                    temp_y_dr_amt       = temp_y_dr_amt      + ttb_y_dr_amt      
                    temp_y_cr_amt       = temp_y_cr_amt      + ttb_y_cr_amt      
                    temp_y_curr_dr_amt  = temp_y_curr_dr_amt + ttb_y_curr_dr_amt 
                    temp_y_curr_cr_amt  = temp_y_curr_cr_amt + ttb_y_curr_cr_amt 
                    .
            END. 

            IF ttb_ctr <> "" THEN DO:
                FIND FIRST temp WHERE temp_acc = ttb_acc
                                  AND temp_ctr = "" NO-ERROR.
                IF NOT AVAIL temp THEN DO:
                    CREATE temp.
                    ASSIGN
                        temp_by             = ttb_by
                        temp_acc            = ttb_acc           
                        temp_ac_desc        = ttb_ac_desc                     
                        temp_ctr            = ""           
                        temp_cc_desc        = ""
                        temp_curr           = ttb_curr      
                        temp_beg_amt        = ttb_beg_amt
                        temp_beg_curramt    = ttb_beg_curramt
                        temp_dr_amt         = ttb_dr_amt        
                        temp_cr_amt         = ttb_cr_amt        
                        temp_curr_dr_amt    = ttb_curr_dr_amt   
                        temp_curr_cr_amt    = ttb_curr_cr_amt   
                        temp_y_dr_amt       = ttb_y_dr_amt      
                        temp_y_cr_amt       = ttb_y_cr_amt      
                        temp_y_curr_dr_amt  = ttb_y_curr_dr_amt 
                        temp_y_curr_cr_amt  = ttb_y_curr_cr_amt 
                        temp_type           = "X"
                        .
                END.
                ELSE DO:
                    ASSIGN
                        temp_beg_amt        = temp_beg_amt       + ttb_beg_amt
                        temp_beg_curramt    = temp_beg_curramt   + ttb_beg_curramt
                        temp_dr_amt         = temp_dr_amt        + ttb_dr_amt        
                        temp_cr_amt         = temp_cr_amt        + ttb_cr_amt        
                        temp_curr_dr_amt    = temp_curr_dr_amt   + ttb_curr_dr_amt   
                        temp_curr_cr_amt    = temp_curr_cr_amt   + ttb_curr_cr_amt   
                        temp_y_dr_amt       = temp_y_dr_amt      + ttb_y_dr_amt      
                        temp_y_cr_amt       = temp_y_cr_amt      + ttb_y_cr_amt      
                        temp_y_curr_dr_amt  = temp_y_curr_dr_amt + ttb_y_curr_dr_amt 
                        temp_y_curr_cr_amt  = temp_y_curr_cr_amt + ttb_y_curr_cr_amt 
                        .
                END.
            END. /* IF ttb_ctr <> "" THEN DO: */
        END. /* FOR EACH ttb BREAK BY ttb_acc BY ttb_ctr : */ 

        IF v_ln <> 0 THEN DO:
            FOR EACH tt2 WHERE tt2_by = "S" :
                    CREATE temp .
                    ASSIGN
                        temp_by             = tt2_by
                        temp_acc            = tt2_acc           
                        temp_ac_desc        = tt2_ac_desc                
                        temp_sub            = tt2_sub           
                        temp_sb_desc        = tt2_sb_desc       
                        temp_ctr            = tt2_ctr           
                        temp_cc_desc        = tt2_cc_desc       
                        temp_curr           = tt2_curr   
                        temp_beg_amt        = tt2_beg_amt
                        temp_beg_curramt    = tt2_beg_curramt
                        temp_dr_amt         = tt2_dr_amt        
                        temp_cr_amt         = tt2_cr_amt        
                        temp_curr_dr_amt    = tt2_curr_dr_amt   
                        temp_curr_cr_amt    = tt2_curr_cr_amt   
                        temp_y_dr_amt       = tt2_y_dr_amt      
                        temp_y_cr_amt       = tt2_y_cr_amt      
                        temp_y_curr_dr_amt  = tt2_y_curr_dr_amt 
                        temp_y_curr_cr_amt  = tt2_y_curr_cr_amt 
                        .
            END.
        END.

        /* 如果不包含无发生额为 no ,则删除这些数据 */
        IF v_inc_flag = NO THEN DO:
           FOR EACH temp WHERE temp_beg_amt = 0 
              AND temp_beg_curramt = 0
              AND temp_dr_amt = 0
              AND temp_cr_amt = 0
              AND temp_curr_dr_amt = 0
              AND temp_curr_cr_amt = 0
              AND temp_y_dr_amt = 0
              AND temp_y_cr_amt = 0
              AND temp_y_curr_dr_amt = 0
              AND temp_y_curr_cr_amt = 0 :
              DELETE temp .
           END.
        END.

        v_account = "" .
        v_account_desc = "" .
        FOR EACH temp BY temp_acc BY temp_ctr :
            IF temp_acc <> "" THEN v_account = temp_acc .
            IF temp_ctr <> "" THEN v_account = v_account + "-" + temp_ctr .

            IF temp_ac_desc <> "" THEN v_account_desc = temp_ac_desc .
            IF temp_cc_desc <> "" THEN DO: 
                IF temp_ac_desc <> "" THEN v_account_desc = v_account_desc + "-" + temp_cc_desc .
                                      ELSE v_account_desc = temp_cc_desc .
            END.

            PUT UNFORMATTED v_account ";" v_account_desc ";" .

            IF temp_beg_amt >= 0 THEN PUT UNFORMATTED temp_beg_amt ";" ";" .
                                 ELSE PUT UNFORMATTED ";" ABS(temp_beg_amt) ";" .
            PUT UNFORMATTED temp_dr_amt ";" temp_cr_amt ";" 
                            temp_y_dr_amt ";" temp_y_cr_amt ";" .
            IF ( temp_beg_amt + temp_dr_amt - temp_cr_amt) >= 0
                THEN PUT UNFORMATTED ( temp_beg_amt + temp_dr_amt - temp_cr_amt) ";" ";" .
                ELSE PUT UNFORMATTED ";" ABS( temp_beg_amt + temp_dr_amt - temp_cr_amt) ";" .

            IF NOT (temp_curr = "CNY" OR temp_curr = "") THEN DO:
                PUT UNFORMATTED temp_curr ";" .
                IF temp_beg_curramt >= 0 THEN PUT UNFORMATTED temp_beg_curramt ";" ";" .
                                         ELSE PUT UNFORMATTED ";" abs(temp_beg_curramt) ";" .
                PUT UNFORMATTED temp_curr_dr_amt ";" temp_curr_cr_amt ";" 
                                temp_y_curr_dr_amt ";" temp_y_curr_cr_amt ";" .
                IF ( temp_beg_curramt + temp_curr_dr_amt - temp_curr_cr_amt) >= 0
                    THEN PUT UNFORMATTED ( temp_beg_curramt + temp_curr_dr_amt - temp_curr_cr_amt) ";" ";" SKIP.
                    ELSE PUT UNFORMATTED ";" ABS( temp_beg_curramt + temp_curr_dr_amt - temp_curr_cr_amt) ";" SKIP .
            END.
            ELSE DO:
               /* SS - 20070211.1 - B */
               /*
               PUT temp_curr ";" " " ";" " " ";" " " ";" " " ";" " " ";" " " ";" " " ";" " " ";" SKIP. 
               */
               PUT temp_curr.
               DO i1 = 1 TO 9:
                  PUT ";".
               END.
               PUT SKIP.
               /* SS - 20070211.1 - E */
            END.
        END. /* FOR EACH temp : */
    END. /* IF subflag = YES AND ccflag = NO THEN DO: */   


    IF subflag = NO AND ccflag = YES THEN DO:
        FOR EACH tt2 WHERE tt2_by = "T" BREAK BY tt2_acc BY tt2_sub :
            ACCUMULATE tt2_beg_amt       ( TOTAL BY tt2_acc BY tt2_sub) .
            ACCUMULATE tt2_beg_curramt   ( TOTAL BY tt2_acc BY tt2_sub) .
            ACCUMULATE tt2_dr_amt        ( TOTAL BY tt2_acc BY tt2_sub) .
            ACCUMULATE tt2_cr_amt        ( TOTAL BY tt2_acc BY tt2_sub) .
            ACCUMULATE tt2_curr_dr_amt   ( TOTAL BY tt2_acc BY tt2_sub) .
            ACCUMULATE tt2_curr_cr_amt   ( TOTAL BY tt2_acc BY tt2_sub) .
            ACCUMULATE tt2_y_dr_amt      ( TOTAL BY tt2_acc BY tt2_sub) .
            ACCUMULATE tt2_y_cr_amt      ( TOTAL BY tt2_acc BY tt2_sub) .
            ACCUMULATE tt2_y_curr_dr_amt ( TOTAL BY tt2_acc BY tt2_sub) .
            ACCUMULATE tt2_y_curr_cr_amt ( TOTAL BY tt2_acc BY tt2_sub) .

            IF LAST-OF(tt2_sub) THEN DO:
               CREATE ttb .
               ASSIGN
                   ttb_by            = tt2_by
                   ttb_acc           = tt2_acc
                   ttb_ac_desc       = tt2_ac_desc 
                   ttb_sub           = tt2_sub
                   ttb_sb_desc       = tt2_sb_desc
                   ttb_curr          = tt2_curr
                   ttb_beg_amt       = (ACCUMULATE TOTAL BY tt2_sub tt2_beg_amt) 
                   ttb_beg_curramt   = (ACCUMULATE TOTAL BY tt2_sub tt2_beg_curramt) 
                   ttb_dr_amt        = (ACCUMULATE TOTAL BY tt2_sub tt2_dr_amt) 
                   ttb_cr_amt        = (ACCUMULATE TOTAL BY tt2_sub tt2_cr_amt) 
                   ttb_curr_dr_amt   = (ACCUMULATE TOTAL BY tt2_sub tt2_curr_dr_amt) 
                   ttb_curr_cr_amt   = (ACCUMULATE TOTAL BY tt2_sub tt2_curr_cr_amt) 
                   ttb_y_dr_amt      = (ACCUMULATE TOTAL BY tt2_sub tt2_y_dr_amt) 
                   ttb_y_cr_amt      = (ACCUMULATE TOTAL BY tt2_sub tt2_y_cr_amt) 
                   ttb_y_curr_dr_amt = (ACCUMULATE TOTAL BY tt2_sub tt2_y_curr_dr_amt) 
                   ttb_y_curr_cr_amt = (ACCUMULATE TOTAL BY tt2_sub tt2_y_curr_cr_amt) 
                   .
            END.    
        END. /* FOR EACH tt BREAK BY tt2_acc BY tt2_ctr : */

        FOR EACH ttb BREAK BY ttb_acc BY ttb_sub :
            FIND FIRST temp WHERE temp_acc = ttb_acc 
                              AND temp_sub = ttb_sub NO-ERROR.
            IF NOT AVAIL temp THEN DO:
                CREATE temp.
                ASSIGN
                    temp_by             = ttb_by
                    temp_acc            = ttb_acc           
                    temp_ac_desc        = ttb_ac_desc                     
                    temp_sub            = ttb_sub           
                    temp_sb_desc        = ttb_sb_desc      
                    temp_beg_amt        = ttb_beg_amt
                    temp_beg_curramt    = ttb_beg_curramt
                    temp_curr           = ttb_curr          
                    temp_dr_amt         = ttb_dr_amt        
                    temp_cr_amt         = ttb_cr_amt        
                    temp_curr_dr_amt    = ttb_curr_dr_amt   
                    temp_curr_cr_amt    = ttb_curr_cr_amt   
                    temp_y_dr_amt       = ttb_y_dr_amt      
                    temp_y_cr_amt       = ttb_y_cr_amt      
                    temp_y_curr_dr_amt  = ttb_y_curr_dr_amt 
                    temp_y_curr_cr_amt  = ttb_y_curr_cr_amt 
                    .
            END.
            ELSE DO:
                ASSIGN
                    temp_beg_amt        = temp_beg_amt       + ttb_beg_amt
                    temp_beg_curramt    = temp_beg_curramt   + ttb_beg_curramt
                    temp_dr_amt         = temp_dr_amt        + ttb_dr_amt        
                    temp_cr_amt         = temp_cr_amt        + ttb_cr_amt        
                    temp_curr_dr_amt    = temp_curr_dr_amt   + ttb_curr_dr_amt   
                    temp_curr_cr_amt    = temp_curr_cr_amt   + ttb_curr_cr_amt   
                    temp_y_dr_amt       = temp_y_dr_amt      + ttb_y_dr_amt      
                    temp_y_cr_amt       = temp_y_cr_amt      + ttb_y_cr_amt      
                    temp_y_curr_dr_amt  = temp_y_curr_dr_amt + ttb_y_curr_dr_amt 
                    temp_y_curr_cr_amt  = temp_y_curr_cr_amt + ttb_y_curr_cr_amt 
                    .
            END. 

            IF ttb_sub <> "" THEN DO:
                FIND FIRST temp WHERE temp_acc = ttb_acc
                                  AND temp_sub = "" NO-ERROR.
                IF NOT AVAIL temp THEN DO:
                    CREATE temp.
                    ASSIGN
                        temp_by             = ttb_by
                        temp_acc            = ttb_acc           
                        temp_ac_desc        = ttb_ac_desc                     
                        temp_sub            = ""           
                        temp_sb_desc        = ""
                        temp_curr           = ttb_curr  
                        temp_beg_amt        = ttb_beg_amt                             
                        temp_beg_curramt    = ttb_beg_curramt
                        temp_dr_amt         = ttb_dr_amt        
                        temp_cr_amt         = ttb_cr_amt        
                        temp_curr_dr_amt    = ttb_curr_dr_amt   
                        temp_curr_cr_amt    = ttb_curr_cr_amt   
                        temp_y_dr_amt       = ttb_y_dr_amt      
                        temp_y_cr_amt       = ttb_y_cr_amt      
                        temp_y_curr_dr_amt  = ttb_y_curr_dr_amt 
                        temp_y_curr_cr_amt  = ttb_y_curr_cr_amt 
                        temp_type           = "X"
                        .
                END.
                ELSE DO:
                    ASSIGN
                        temp_beg_amt        = temp_beg_amt       + ttb_beg_amt      
                        temp_beg_curramt    = temp_beg_curramt   + ttb_beg_curramt
                        temp_dr_amt         = temp_dr_amt        + ttb_dr_amt        
                        temp_cr_amt         = temp_cr_amt        + ttb_cr_amt        
                        temp_curr_dr_amt    = temp_curr_dr_amt   + ttb_curr_dr_amt   
                        temp_curr_cr_amt    = temp_curr_cr_amt   + ttb_curr_cr_amt   
                        temp_y_dr_amt       = temp_y_dr_amt      + ttb_y_dr_amt      
                        temp_y_cr_amt       = temp_y_cr_amt      + ttb_y_cr_amt      
                        temp_y_curr_dr_amt  = temp_y_curr_dr_amt + ttb_y_curr_dr_amt 
                        temp_y_curr_cr_amt  = temp_y_curr_cr_amt + ttb_y_curr_cr_amt 
                        .
                END.
            END. /* IF ttb_sub <> "" THEN DO: */
        END. /* FOR EACH ttb BREAK BY ttb_acc BY ttb_sub : */  

        IF v_ln <> 0 THEN DO:
            FOR EACH tt2 WHERE tt2_by = "S" :
                    CREATE temp .
                    ASSIGN
                        temp_by             = tt2_by
                        temp_acc            = tt2_acc           
                        temp_ac_desc        = tt2_ac_desc                
                        temp_sub            = tt2_sub           
                        temp_sb_desc        = tt2_sb_desc       
                        temp_ctr            = tt2_ctr           
                        temp_cc_desc        = tt2_cc_desc       
                        temp_curr           = tt2_curr   
                        temp_beg_amt        = tt2_beg_amt
                        temp_beg_curramt    = tt2_beg_curramt
                        temp_dr_amt         = tt2_dr_amt        
                        temp_cr_amt         = tt2_cr_amt        
                        temp_curr_dr_amt    = tt2_curr_dr_amt   
                        temp_curr_cr_amt    = tt2_curr_cr_amt   
                        temp_y_dr_amt       = tt2_y_dr_amt      
                        temp_y_cr_amt       = tt2_y_cr_amt      
                        temp_y_curr_dr_amt  = tt2_y_curr_dr_amt 
                        temp_y_curr_cr_amt  = tt2_y_curr_cr_amt 
                        .
            END.
        END.

        /* 如果不包含无发生额为 no ,则删除这些数据 */
        IF v_inc_flag = NO THEN DO:
           FOR EACH temp WHERE temp_beg_amt = 0 
              AND temp_beg_curramt = 0
              AND temp_dr_amt = 0
              AND temp_cr_amt = 0
              AND temp_curr_dr_amt = 0
              AND temp_curr_cr_amt = 0
              AND temp_y_dr_amt = 0
              AND temp_y_cr_amt = 0
              AND temp_y_curr_dr_amt = 0
              AND temp_y_curr_cr_amt = 0 :
              DELETE temp .
           END.
        END.

        v_account = "" .
        v_account_desc = "" .
        FOR EACH temp BY temp_acc BY temp_sub :
            IF temp_acc <> "" THEN v_account = temp_acc .
            IF temp_sub <> "" THEN v_account = v_account + "-" + temp_sub .

            IF temp_ac_desc <> "" THEN v_account_desc = temp_ac_desc .
            IF temp_sb_desc <> "" THEN do:
                IF temp_ac_desc <> "" THEN v_account_desc = v_account_desc + "-" + temp_sb_desc .
                                      ELSE v_account_desc = temp_sb_desc .
            END.

            PUT UNFORMATTED v_account ";" v_account_desc ";" .

            IF temp_beg_amt >= 0 THEN PUT UNFORMATTED temp_beg_amt ";" ";" .
                                 ELSE PUT UNFORMATTED ";" ABS(temp_beg_amt) ";" .
            PUT UNFORMATTED temp_dr_amt ";" temp_cr_amt ";" 
                            temp_y_dr_amt ";" temp_y_cr_amt ";" .
            IF ( temp_beg_amt + temp_dr_amt - temp_cr_amt) >= 0
                THEN PUT UNFORMATTED ( temp_beg_amt + temp_dr_amt - temp_cr_amt) ";" ";" .
                ELSE PUT UNFORMATTED ";" ABS( temp_beg_amt + temp_dr_amt - temp_cr_amt) ";" .

            IF not(temp_curr = "CNY" OR temp_curr = "") THEN DO:
                PUT UNFORMATTED temp_curr ";" .
                IF temp_beg_curramt >= 0 THEN PUT UNFORMATTED temp_beg_curramt ";" ";" .
                                         ELSE PUT UNFORMATTED ";" abs(temp_beg_curramt) ";" .
                PUT UNFORMATTED temp_curr_dr_amt ";" temp_curr_cr_amt ";" 
                                temp_y_curr_dr_amt ";" temp_y_curr_cr_amt ";" .
                IF (temp_beg_curramt + temp_curr_dr_amt - temp_curr_cr_amt) >= 0
                    THEN PUT UNFORMATTED ( temp_beg_curramt + temp_curr_dr_amt - temp_curr_cr_amt) ";" ";" SKIP.
                    ELSE PUT UNFORMATTED ";" ABS( temp_beg_curramt + temp_curr_dr_amt - temp_curr_cr_amt) ";" SKIP .
            END.
            ELSE DO:
               /* SS - 20070211.1 - B */
               /*
               PUT temp_curr ";" " " ";" " " ";" " " ";" " " ";" " " ";" " " ";" " " ";" " " ";" SKIP. 
               */
               PUT temp_curr.
               DO i1 = 1 TO 9:
                  PUT ";".
               END.
               PUT SKIP.
               /* SS - 20070211.1 - E */
            END.
        END. /* FOR EACH temp : */
    END. /* IF subflag = no AND ccflag = yes THEN DO: */

    IF subflag = YES AND ccflag = YES THEN DO:
        FOR EACH tt2 WHERE tt2_by = "T" BREAK BY tt2_acc :
            ACCUMULATE tt2_beg_amt       ( TOTAL BY tt2_acc ) .
            ACCUMULATE tt2_beg_curramt   ( TOTAL BY tt2_acc ) .
            ACCUMULATE tt2_dr_amt        ( TOTAL BY tt2_acc ) .
            ACCUMULATE tt2_cr_amt        ( TOTAL BY tt2_acc ) .
            ACCUMULATE tt2_curr_dr_amt   ( TOTAL BY tt2_acc ) .
            ACCUMULATE tt2_curr_cr_amt   ( TOTAL BY tt2_acc ) .
            ACCUMULATE tt2_y_dr_amt      ( TOTAL BY tt2_acc ) .
            ACCUMULATE tt2_y_cr_amt      ( TOTAL BY tt2_acc ) .
            ACCUMULATE tt2_y_curr_dr_amt ( TOTAL BY tt2_acc ) .
            ACCUMULATE tt2_y_curr_cr_amt ( TOTAL BY tt2_acc ) .

            IF LAST-OF(tt2_acc) THEN DO:
               CREATE ttb .
               ASSIGN
                   ttb_by            = tt2_by
                   ttb_acc           = tt2_acc
                   ttb_ac_desc       = tt2_ac_desc 
                   ttb_curr          = tt2_curr
                   ttb_beg_amt       = (ACCUMULATE TOTAL BY tt2_acc tt2_beg_amt) 
                   ttb_beg_curramt   = (ACCUMULATE TOTAL BY tt2_acc tt2_beg_curramt) 
                   ttb_dr_amt        = (ACCUMULATE TOTAL BY tt2_acc tt2_dr_amt) 
                   ttb_cr_amt        = (ACCUMULATE TOTAL BY tt2_acc tt2_cr_amt) 
                   ttb_curr_dr_amt   = (ACCUMULATE TOTAL BY tt2_acc tt2_curr_dr_amt) 
                   ttb_curr_cr_amt   = (ACCUMULATE TOTAL BY tt2_acc tt2_curr_cr_amt) 
                   ttb_y_dr_amt      = (ACCUMULATE TOTAL BY tt2_acc tt2_y_dr_amt) 
                   ttb_y_cr_amt      = (ACCUMULATE TOTAL BY tt2_acc tt2_y_cr_amt) 
                   ttb_y_curr_dr_amt = (ACCUMULATE TOTAL BY tt2_acc tt2_y_curr_dr_amt) 
                   ttb_y_curr_cr_amt = (ACCUMULATE TOTAL BY tt2_acc tt2_y_curr_cr_amt) 
                   .
            END.    
        END. /* FOR EACH tt BREAK BY tt2_acc BY tt2_ctr : */

        IF v_ln <> 0 THEN DO:
            FOR EACH tt2 WHERE tt2_by = "S" :
                   CREATE ttb .
                   ASSIGN
                       ttb_by            = tt2_by
                       ttb_acc           = tt2_acc
                       ttb_ac_desc       = tt2_ac_desc 
                       ttb_curr          = tt2_curr
                       ttb_beg_amt       = tt2_beg_amt
                       ttb_beg_curramt   = tt2_beg_curramt
                       ttb_dr_amt        = tt2_dr_amt 
                       ttb_cr_amt        = tt2_cr_amt 
                       ttb_y_dr_amt      = tt2_y_dr_amt 
                       ttb_y_cr_amt      = tt2_y_cr_amt 
                       .
            END.
        END.

        /* 如果不包含无发生额为 no ,则删除这些数据 */
        IF v_inc_flag = NO THEN DO:
           FOR EACH ttb WHERE ttb_beg_amt = 0 
              AND ttb_beg_curramt = 0
              AND ttb_dr_amt = 0
              AND ttb_cr_amt = 0
              AND ttb_curr_dr_amt = 0
              AND ttb_curr_cr_amt = 0
              AND ttb_y_dr_amt = 0
              AND ttb_y_cr_amt = 0
              AND ttb_y_curr_dr_amt = 0
              AND ttb_y_curr_cr_amt = 0 :
              DELETE ttb .
           END.
        END.

        FOR EACH ttb BY ttb_acc :
            PUT UNFORMATTED ttb_acc ";" ttb_ac_desc ";" .

            IF ttb_beg_amt >= 0 THEN PUT UNFORMATTED ttb_beg_amt ";" ";" .
                                ELSE PUT UNFORMATTED ";" abs(ttb_beg_amt) ";" .
            PUT UNFORMATTED ttb_dr_amt ";" ttb_cr_amt ";" 
                            ttb_y_dr_amt ";" ttb_y_cr_amt ";" .
            IF ( ttb_beg_amt + ttb_dr_amt - ttb_cr_amt) >= 0
                THEN PUT UNFORMATTED ( ttb_beg_amt + ttb_dr_amt - ttb_cr_amt) ";" ";" .
                ELSE PUT UNFORMATTED ";" ABS( ttb_beg_amt + ttb_dr_amt - ttb_cr_amt) ";".

            IF not(ttb_curr = "CNY" OR ttb_curr = "") THEN DO:
                PUT UNFORMATTED ttb_curr ";" .
                IF ttb_beg_curramt >= 0 THEN PUT UNFORMATTED ttb_beg_curramt ";" ";" .
                                        ELSE PUT UNFORMATTED ";" ABS(ttb_beg_curramt) ";" .
                PUT UNFORMATTED ttb_curr_dr_amt ";" ttb_curr_cr_amt ";" 
                                ttb_y_curr_dr_amt ";" ttb_y_curr_cr_amt ";" .

                IF ( ttb_beg_curramt + ttb_curr_dr_amt - ttb_curr_cr_amt) >= 0
                    THEN PUT UNFORMATTED ( ttb_beg_curramt + ttb_curr_dr_amt - ttb_curr_cr_amt) ";" ";" SKIP .
                    ELSE PUT UNFORMATTED ";" ABS( ttb_beg_curramt + ttb_curr_dr_amt - ttb_curr_cr_amt) ";" SKIP .
            END.
            ELSE DO:
               /* SS - 20070211.1 - B */
               /*
               PUT ttb_curr ";" " " ";" " " ";" " " ";" " " ";" " " ";" " " ";" " " ";" " " ";" SKIP. 
               */
               PUT ttb_curr.
               DO i1 = 1 TO 9:
                  PUT ";".
               END.
               PUT SKIP.
               /* SS - 20070211.1 - E */
            END.                            
        END. /* FOR EACH ttb : */
    END. /* IF subflag = YES AND ccflag = YES THEN DO: */    
      
    
    PUT UNFORMATTED
        "会计期间: " ";"  STRING(year(effdate),'9999') + "/" + STRING(MONTH(effdate),'99') + "/" + STRING(DAY(effdate),'99') + " -- " + 
                          STRING(year(effdate1),'9999') + "/" + STRING(MONTH(effdate1),'99') + "/" + STRING(DAY(effdate1),'99')  ";" 
        0  ";"   0 ";"   0 ";"   0 ";"   0 ";"   0 ";"   0 ";"   0 ";" 

        0   ";"   0 ";"   0 ";"   0 ";"   0 ";"   0 ";"   0 ";"   0 ";"   0 ";"  SKIP .
    
{xxmfrtrail.i}
                                                                                    
