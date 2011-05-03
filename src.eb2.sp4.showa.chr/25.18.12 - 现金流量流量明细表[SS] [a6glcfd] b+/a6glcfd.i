/* BY: Micho Yang         DATE: 09/08/06  ECO: *SS - 20060908.1*  */
/******************** SS - 20060908.1 - B ********************/
DEF TEMP-TABLE wt1 
   FIELD wt1_acc AS CHAR
   FIELD wt1_acct AS CHAR 
   FIELD wt1_sub AS CHAR
   FIELD wt1_d_acct AS CHAR
   FIELD wt1_d_sub AS CHAR
   FIELD wt1_amt AS DECIMAL
   FIELD wt1_desc AS CHAR
   FIELD wt1_ref AS CHAR
   .
/******************** SS - 20060908.1 - E ********************/


cash = FALSE.
ie = FALSE.
netprofit = 0.
FOR EACH gltr_hist
    WHERE gltr_entity = entity 
    AND (gltr_eff_dt >= begdt)
    AND (gltr_eff_dt <= enddt)
    USE-INDEX gltr_ind1
    NO-LOCK
    BREAK BY gltr_ref:
    /* 净利润 */
    FIND FIRST ac_mstr WHERE (ac_type = 'I' OR ac_type = 'E') AND ac_code = gltr_acc USE-INDEX ac_type NO-LOCK NO-ERROR.
    IF AVAILABLE ac_mstr THEN netprofit = netprofit + gltr_amt.
    /* 是否包含现金及现金等价物科目 */
    IF NOT cash THEN DO:
        done = NO.
        FOR EACH glrd_det 
            WHERE glrd_det.glrd_code = '031301'
            AND glrd_det.glrd_fpos = 0
            AND (glrd_det.glrd_acct <= gltr_hist.gltr_acc OR glrd_det.glrd_acct = '')
            AND (glrd_det.glrd_acct1 >= gltr_hist.gltr_acc OR glrd_det.glrd_acct1 = '')
            AND (glrd_det.glrd_sub <= gltr_hist.gltr_sub OR glrd_det.glrd_sub = '')
            AND (glrd_det.glrd_sub1 >= gltr_hist.gltr_sub OR glrd_det.glrd_sub1 = '')
            AND (glrd_det.glrd_cc <= gltr_hist.gltr_ctr OR glrd_det.glrd_cc = '')
            AND (glrd_det.glrd_cc1 >= gltr_hist.gltr_ctr OR glrd_det.glrd_cc1 = '')
            USE-INDEX glrd_code
            NO-LOCK
            BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
            IF NOT done THEN DO:
                done = YES.
                cash = TRUE.
                acc = gltr_hist.gltr_acc.
                sub = gltr_hist.gltr_sub.
                ctr = gltr_hist.gltr_ctr.
            END.
        END.
    END.
    /* 是否包含现金及现金等价物科目 */
    /* 是否包含损益科目 */
    IF NOT cash THEN DO:
        IF NOT ie THEN DO:
            FIND FIRST ac_mstr WHERE (ac_type = 'I' OR ac_type = 'E') AND ac_code = gltr_hist.gltr_acc USE-INDEX ac_type NO-LOCK NO-ERROR.
            IF AVAILABLE ac_mstr THEN DO :
                ie = TRUE.
                acc = gltr_hist.gltr_acc.
                sub = gltr_hist.gltr_sub.
                ctr = gltr_hist.gltr_ctr.
            END.
        END.
    END.
    /* 是否包含损益科目 */
    /* 按总账参考号排序 */
    IF LAST-OF(gltr_ref) THEN DO:
        /* 是否包含现金及现金等价物科目 */
        IF cash THEN DO:
            /* 按会计单位排序 */
            FOR EACH gltrhist WHERE gltrhist.gltr_ref = gltr_hist.gltr_ref AND gltrhist.gltr_entity = gltr_hist.gltr_entity USE-INDEX gltr_ref NO-LOCK:
                done = NO.
                FOR EACH glrd_det 
                    WHERE glrd_det.glrd_code = '031301'
                    AND glrd_det.glrd_fpos = 0
                    AND (glrd_det.glrd_acct <= gltrhist.gltr_acc OR glrd_det.glrd_acct = '')
                    AND (glrd_det.glrd_acct1 >= gltrhist.gltr_acc OR glrd_det.glrd_acct1 = '')
                    AND (glrd_det.glrd_sub <= gltrhist.gltr_sub OR glrd_det.glrd_sub = '')
                    AND (glrd_det.glrd_sub1 >= gltrhist.gltr_sub OR glrd_det.glrd_sub1 = '')
                    AND (glrd_det.glrd_cc <= gltrhist.gltr_ctr OR glrd_det.glrd_cc = '')
                    AND (glrd_det.glrd_cc1 >= gltrhist.gltr_ctr OR glrd_det.glrd_cc1 = '')
                    USE-INDEX glrd_code
                    NO-LOCK
                    BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                    IF NOT done THEN DO:
                        done = YES.
                    END.
                END.
                /* 处理现金及现金等价物的对方科目 */
                IF NOT done THEN DO:
                    /* 按主表排序 */
                    rept1:
                    REPEAT:
                        /* 030101 - 经营活动产生的现金流入 */
                        done = NO.
                        FOR EACH glrddet 
                            WHERE glrddet.glrd_code = '030101'
                            AND glrddet.glrd_fpos = 0
                            AND (glrddet.glrd_acct <= gltrhist.gltr_acc OR glrddet.glrd_acct = '')
                            AND (glrddet.glrd_acct1 >= gltrhist.gltr_acc OR glrddet.glrd_acct1 = '')
                            AND (glrddet.glrd_sub <= gltrhist.gltr_sub OR glrddet.glrd_sub = '')
                            AND (glrddet.glrd_sub1 >= gltrhist.gltr_sub OR glrddet.glrd_sub1 = '')
                            AND (glrddet.glrd_cc <= gltrhist.gltr_ctr OR glrddet.glrd_cc = '')
                            AND (glrddet.glrd_cc1 >= gltrhist.gltr_ctr OR glrddet.glrd_cc1 = '')
                            USE-INDEX glrd_code
                            NO-LOCK
                            BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                            IF NOT done THEN DO:
                                done = YES.
                                /* 对方科目是资产负债表类 */
                                FIND FIRST ac_mstr WHERE ac_code = gltrhist.gltr_acc AND (ac_type = 'A' OR ac_type = 'L') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    done2 = NO.
                                    FOR EACH glrddet1 
                                        WHERE glrddet1.glrd_code = '0311'
                                        AND glrddet1.glrd_fpos = 0
                                        AND (glrddet1.glrd_acct <= gltrhist.gltr_acc OR glrddet1.glrd_acct = '')
                                        AND (glrddet1.glrd_acct1 >= gltrhist.gltr_acc OR glrddet1.glrd_acct1 = '')
                                        AND (glrddet1.glrd_sub <= gltrhist.gltr_sub OR glrddet1.glrd_sub = '')
                                        AND (glrddet1.glrd_sub1 >= gltrhist.gltr_sub OR glrddet1.glrd_sub1 = '')
                                        AND (glrddet1.glrd_cc <= gltrhist.gltr_ctr OR glrddet1.glrd_cc = '')
                                        AND (glrddet1.glrd_cc1 >= gltrhist.gltr_ctr OR glrddet1.glrd_cc1 = '')
                                        USE-INDEX glrd_code
                                        NO-LOCK
                                        BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                                        IF NOT done2 THEN DO:
                                            done2 = YES.
                                            /* 030101 - 经营活动产生的现金流入 */
                                            /*
                                            FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                            IF AVAILABLE wt THEN DO:
                                                /* -! */
                                                ASSIGN decivalue = decivalue - gltrhist.gltr_amt.
                                            END.
                                            ELSE DO:
                                                CREATE wt.
                                                ASSIGN
                                                    fldname = 'Line' + STRING(glrddet.glrd_sums)
                                                    /* -! */
                                                    decivalue = - gltrhist.gltr_amt.
                                            END.
                                            */
                                            EXPORT DELIMITER ";" glrddet.glrd_sums acc sub gltrhist.gltr_acc gltrhist.gltr_sub (- gltrhist.gltr_amt) gltrhist.gltr_desc gltrhist.gltr_ref.
                                            /* 0311 - 将净利润调节为经营活动现金流量 */
                                            /*
                                            FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet1.glrd_sums) NO-LOCK NO-ERROR.
                                            IF AVAILABLE wt THEN DO:
                                                /* -! */
                                                ASSIGN decivalue = decivalue - gltrhist.gltr_amt.
                                            END.
                                            ELSE DO:
                                                CREATE wt.
                                                ASSIGN
                                                    fldname = 'Line' + STRING(glrddet1.glrd_sums)
                                                    /* -! */
                                                    decivalue = - gltrhist.gltr_amt.
                                            END.
                                            */
                                            EXPORT DELIMITER ";" glrddet1.glrd_sums acc sub gltrhist.gltr_acc gltrhist.gltr_sub (- gltrhist.gltr_amt) gltrhist.gltr_desc gltrhist.gltr_ref.
                                            LEAVE rept1.
                                        END.
                                    END. /* IF AVAILABLE glrddet1 THEN DO: */
                                    /*
                                    CREATE wt.
                                    ASSIGN 
                                        fldname = 'Error'
                                        /* TODO:使用错误代码 */
                                        charvalue = '没有调整不影响净利润的经营性资产负债的减少或增加:' + gltrhist.gltr_ref.
                                    */
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* 对方科目是资产负债表类 */
                                /* 对方科目是利润类 */
                                FIND FIRST ac_mstr WHERE ac_code = gltrhist.gltr_acc AND (ac_type = 'I' OR ac_type = 'E') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    /* 030101 - 经营活动产生的现金流入 */
                                    /*
                                    FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                    IF AVAILABLE wt THEN DO:
                                        /* -! */
                                        ASSIGN decivalue = decivalue - gltrhist.gltr_amt.
                                    END.
                                    ELSE DO:
                                        CREATE wt.
                                        ASSIGN
                                            fldname = 'Line' + STRING(glrddet.glrd_sums)
                                            /* -! */
                                            decivalue = - gltrhist.gltr_amt.
                                    END.
                                    */
                                    EXPORT DELIMITER ";" glrddet.glrd_sums acc sub gltrhist.gltr_acc gltrhist.gltr_sub (- gltrhist.gltr_amt) gltrhist.gltr_desc gltrhist.gltr_ref.
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* 对方科目是利润类 */
                                /* 对方科目异常 */
                                /*
                                CREATE wt.
                                ASSIGN 
                                    fldname = 'Error'
                                    /* TODO:使用错误代码 */
                                    charvalue = '对方科目异常(不是A,L,I,E中的任何一种):' + gltrhist.gltr_ref.
                                */
                                LEAVE rept1.
                            END.
                        END.  /* IF AVAILABLE glrddet THEN DO: */
                        /* 030101 - 经营活动产生的现金流入 */


                        /* 030102 - 经营活动产生的现金流出 */
                        done = NO.
                        FOR EACH glrddet 
                            WHERE glrddet.glrd_code = '030102'
                            AND glrddet.glrd_fpos = 0
                            AND (glrddet.glrd_acct <= gltrhist.gltr_acc OR glrddet.glrd_acct = '')
                            AND (glrddet.glrd_acct1 >= gltrhist.gltr_acc OR glrddet.glrd_acct1 = '')
                            AND (glrddet.glrd_sub <= gltrhist.gltr_sub OR glrddet.glrd_sub = '')
                            AND (glrddet.glrd_sub1 >= gltrhist.gltr_sub OR glrddet.glrd_sub1 = '')
                            AND (glrddet.glrd_cc <= gltrhist.gltr_ctr OR glrddet.glrd_cc = '')
                            AND (glrddet.glrd_cc1 >= gltrhist.gltr_ctr OR glrddet.glrd_cc1 = '')
                            USE-INDEX glrd_code
                            NO-LOCK
                            BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                            IF NOT done THEN DO:
                                done = YES.
                                /* 对方科目是资产负债表类 */
                                FIND FIRST ac_mstr WHERE ac_code = gltrhist.gltr_acc AND (ac_type = 'A' OR ac_type = 'L') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    done2 = NO.
                                    FOR EACH glrddet1 
                                        WHERE glrddet1.glrd_code = '0311'
                                        AND glrddet1.glrd_fpos = 0
                                        AND (glrddet1.glrd_acct <= gltrhist.gltr_acc OR glrddet1.glrd_acct = '')
                                        AND (glrddet1.glrd_acct1 >= gltrhist.gltr_acc OR glrddet1.glrd_acct1 = '')
                                        AND (glrddet1.glrd_sub <= gltrhist.gltr_sub OR glrddet1.glrd_sub = '')
                                        AND (glrddet1.glrd_sub1 >= gltrhist.gltr_sub OR glrddet1.glrd_sub1 = '')
                                        AND (glrddet1.glrd_cc <= gltrhist.gltr_ctr OR glrddet1.glrd_cc = '')
                                        AND (glrddet1.glrd_cc1 >= gltrhist.gltr_ctr OR glrddet1.glrd_cc1 = '')
                                        USE-INDEX glrd_code
                                        NO-LOCK
                                        BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                                        IF NOT done2 THEN DO:
                                            done2 = YES.
                                            /* 030102 - 经营活动产生的现金流出 */
                                            /*
                                            FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                            IF AVAILABLE wt THEN DO:
                                                /* +! */
                                                ASSIGN decivalue = decivalue + gltrhist.gltr_amt.
                                            END.
                                            ELSE DO:
                                                CREATE wt.
                                                ASSIGN
                                                    fldname = 'Line' + STRING(glrddet.glrd_sums)
                                                    /* +! */
                                                    decivalue = + gltrhist.gltr_amt.
                                            END.
                                            */
                                            EXPORT DELIMITER ";" glrddet.glrd_sums acc sub gltrhist.gltr_acc gltrhist.gltr_sub gltrhist.gltr_amt gltrhist.gltr_desc gltrhist.gltr_ref.
                                            /* 0311 - 将净利润调节为经营活动现金流量 */
                                            /*
                                            FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet1.glrd_sums) NO-LOCK NO-ERROR.
                                            IF AVAILABLE wt THEN DO:
                                                /* +! */
                                                ASSIGN decivalue = decivalue - gltrhist.gltr_amt.
                                            END.
                                            ELSE DO:
                                                CREATE wt.
                                                ASSIGN
                                                    fldname = 'Line' + STRING(glrddet1.glrd_sums)
                                                    /* +! */
                                                    decivalue = - gltrhist.gltr_amt.
                                            END.
                                            */
                                            EXPORT DELIMITER ";" glrddet1.glrd_sums acc sub gltrhist.gltr_acc gltrhist.gltr_sub (- gltrhist.gltr_amt) gltrhist.gltr_desc gltrhist.gltr_ref.
                                            LEAVE rept1.
                                        END.
                                    END. /* IF AVAILABLE glrddet1 THEN DO: */
                                    /*
                                    CREATE wt.
                                    ASSIGN 
                                        fldname = 'Error'
                                        /* TODO:使用错误代码 */
                                        charvalue = '没有调整不影响净利润的经营性资产负债的减少或增加:' + gltrhist.gltr_ref.
                                    */
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* 对方科目是资产负债表类 */
                                /* 对方科目是利润类 */
                                FIND FIRST ac_mstr WHERE ac_code = gltrhist.gltr_acc AND (ac_type = 'I' OR ac_type = 'E') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    /* 030101 - 经营活动产生的现金流入 */
                                    /*
                                    FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                    IF AVAILABLE wt THEN DO:
                                        /* +! */
                                        ASSIGN decivalue = decivalue + gltrhist.gltr_amt.
                                    END.
                                    ELSE DO:
                                        CREATE wt.
                                        ASSIGN
                                            fldname = 'Line' + STRING(glrddet.glrd_sums)
                                            /* +! */
                                            decivalue = + gltrhist.gltr_amt.
                                    END.
                                    */
                                    EXPORT DELIMITER ";" glrddet.glrd_sums acc sub gltrhist.gltr_acc gltrhist.gltr_sub gltrhist.gltr_amt gltrhist.gltr_desc gltrhist.gltr_ref.
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* 对方科目是利润类 */
                                /* 对方科目异常 */
                                /*
                                CREATE wt.
                                ASSIGN 
                                    fldname = 'Error'
                                    /* TODO:使用错误代码 */
                                    charvalue = '对方科目异常(不是A,L,I,E中的任何一种):' + gltrhist.gltr_ref.
                                */
                                LEAVE rept1.
                            END.
                        END.  /* IF AVAILABLE glrddet THEN DO: */
                        /* 030102 - 经营活动产生的现金流出 */


                        /* 0302(3)01,0304 - 投(筹)资活动产生的现金流入,汇率变动对现金的影响 */
                        done = NO.
                        FOR EACH glrddet 
                            WHERE (glrddet.glrd_code = '030201' OR glrddet.glrd_code = '030301' OR glrddet.glrd_code = '0304')
                            AND glrddet.glrd_fpos = 0
                            AND (glrddet.glrd_acct <= gltrhist.gltr_acc OR glrddet.glrd_acct = '')
                            AND (glrddet.glrd_acct1 >= gltrhist.gltr_acc OR glrddet.glrd_acct1 = '')
                            AND (glrddet.glrd_sub <= gltrhist.gltr_sub OR glrddet.glrd_sub = '')
                            AND (glrddet.glrd_sub1 >= gltrhist.gltr_sub OR glrddet.glrd_sub1 = '')
                            AND (glrddet.glrd_cc <= gltrhist.gltr_ctr OR glrddet.glrd_cc = '')
                            AND (glrddet.glrd_cc1 >= gltrhist.gltr_ctr OR glrddet.glrd_cc1 = '')
                            USE-INDEX glrd_code
                            NO-LOCK
                            BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                            IF NOT done THEN DO:
                                done = YES.
                                /* 对方科目是资产负债表类 */
                                FIND FIRST ac_mstr WHERE ac_code = gltrhist.gltr_acc AND (ac_type = 'A' OR ac_type = 'L') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    /*
                                    FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                    IF AVAILABLE wt THEN DO:
                                        /* -! */
                                        ASSIGN decivalue = decivalue - gltrhist.gltr_amt.
                                    END.
                                    ELSE DO:
                                        CREATE wt.
                                        ASSIGN
                                            fldname = 'Line' + STRING(glrddet.glrd_sums)
                                            /* -! */
                                            decivalue = - gltrhist.gltr_amt.
                                    END.
                                    */
                                    EXPORT DELIMITER ";" glrddet.glrd_sums acc sub gltrhist.gltr_acc gltrhist.gltr_sub (- gltrhist.gltr_amt) gltrhist.gltr_desc gltrhist.gltr_ref.
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* 对方科目是资产负债表类 */
                                /* 对方科目是利润类 */
                                FIND FIRST ac_mstr WHERE ac_code = gltrhist.gltr_acc AND (ac_type = 'I' OR ac_type = 'E') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    done2 = NO.
                                    FOR EACH glrddet1 
                                        WHERE glrddet1.glrd_code = '0311'
                                        AND glrddet1.glrd_fpos = 0
                                        AND (glrddet1.glrd_acct <= gltrhist.gltr_acc OR glrddet1.glrd_acct = '')
                                        AND (glrddet1.glrd_acct1 >= gltrhist.gltr_acc OR glrddet1.glrd_acct1 = '')
                                        AND (glrddet1.glrd_sub <= gltrhist.gltr_sub OR glrddet1.glrd_sub = '')
                                        AND (glrddet1.glrd_sub1 >= gltrhist.gltr_sub OR glrddet1.glrd_sub1 = '')
                                        AND (glrddet1.glrd_cc <= gltrhist.gltr_ctr OR glrddet1.glrd_cc = '')
                                        AND (glrddet1.glrd_cc1 >= gltrhist.gltr_ctr OR glrddet1.glrd_cc1 = '')
                                        USE-INDEX glrd_code
                                        NO-LOCK
                                        BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                                        IF NOT done2 THEN DO:
                                            done2 = YES.
                                            /* 0302(3)01,0304 - 投(筹)资活动产生的现金流入,汇率变动对现金的影响 */
                                            /*
                                            FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                            IF AVAILABLE wt THEN DO:
                                                /* -! */
                                                ASSIGN decivalue = decivalue - gltrhist.gltr_amt.
                                            END.
                                            ELSE DO:
                                                CREATE wt.
                                                ASSIGN
                                                    fldname = 'Line' + STRING(glrddet.glrd_sums)
                                                    /* -! */
                                                    decivalue = - gltrhist.gltr_amt.
                                            END.
                                            */
                                            EXPORT DELIMITER ";" glrddet.glrd_sums acc sub gltrhist.gltr_acc gltrhist.gltr_sub (- gltrhist.gltr_amt) gltrhist.gltr_desc gltrhist.gltr_ref.
                                            /* 0311 - 将净利润调节为经营活动现金流量 */
                                            /*
                                            FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet1.glrd_sums) NO-LOCK NO-ERROR.
                                            IF AVAILABLE wt THEN DO:
                                                /* -! */
                                                ASSIGN decivalue = decivalue + gltrhist.gltr_amt.
                                            END.
                                            ELSE DO:
                                                CREATE wt.
                                                ASSIGN
                                                    fldname = 'Line' + STRING(glrddet.glrd_sums)
                                                    /* -! */
                                                    decivalue = + gltrhist.gltr_amt.
                                            END.
                                            */
                                            EXPORT DELIMITER ";" glrddet.glrd_sums acc sub gltrhist.gltr_acc gltrhist.gltr_sub gltrhist.gltr_amt gltrhist.gltr_desc gltrhist.gltr_ref.
                                            LEAVE rept1.
                                        END.
                                    END. /* IF AVAILABLE glrddet1 THEN DO: */
                                    /*
                                    CREATE wt.
                                    ASSIGN 
                                        fldname = 'Error'
                                        /* TODO:使用错误代码 */
                                        charvalue = '没有调整非经营活动产生的现金流入的净利润:' + gltrhist.gltr_ref.
                                    */
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* 对方科目是利润类 */
                                /* 对方科目异常 */
                                /*
                                CREATE wt.
                                ASSIGN 
                                    fldname = 'Error'
                                    /* TODO:使用错误代码 */
                                    charvalue = '对方科目异常(不是A,L,I,E中的任何一种):' + gltrhist.gltr_ref.
                                */
                                LEAVE rept1.
                            END.
                        END.
                        /* 0302(3)01,0304 - 投(筹)资活动产生的现金流入,汇率变动对现金的影响 */


                        /* 0302(3)02 - 投(筹)资活动产生的现金流出 */
                        done = NO.
                        FOR EACH glrddet 
                            WHERE (glrddet.glrd_code = '030202' OR glrddet.glrd_code = '030302')
                            AND glrddet.glrd_fpos = 0
                            AND (glrddet.glrd_acct <= gltrhist.gltr_acc OR glrddet.glrd_acct = '')
                            AND (glrddet.glrd_acct1 >= gltrhist.gltr_acc OR glrddet.glrd_acct1 = '')
                            AND (glrddet.glrd_sub <= gltrhist.gltr_sub OR glrddet.glrd_sub = '')
                            AND (glrddet.glrd_sub1 >= gltrhist.gltr_sub OR glrddet.glrd_sub1 = '')
                            AND (glrddet.glrd_cc <= gltrhist.gltr_ctr OR glrddet.glrd_cc = '')
                            AND (glrddet.glrd_cc1 >= gltrhist.gltr_ctr OR glrddet.glrd_cc1 = '')
                            USE-INDEX glrd_code
                            NO-LOCK
                            BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                            IF NOT done THEN DO:
                                done = YES.
                                /* 对方科目是资产负债表类 */
                                FIND FIRST ac_mstr WHERE ac_code = gltrhist.gltr_acc AND (ac_type = 'A' OR ac_type = 'L') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    /*
                                    FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                    IF AVAILABLE wt THEN DO:
                                        /* +! */
                                        ASSIGN decivalue = decivalue + gltrhist.gltr_amt.
                                    END.
                                    ELSE DO:
                                        CREATE wt.
                                        ASSIGN
                                            fldname = 'Line' + STRING(glrddet.glrd_sums)
                                            /* +! */
                                            decivalue = + gltrhist.gltr_amt.
                                    END.
                                    */
                                    EXPORT DELIMITER ";" glrddet.glrd_sums acc sub gltrhist.gltr_acc gltrhist.gltr_sub gltrhist.gltr_amt gltrhist.gltr_desc gltrhist.gltr_ref.
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* 对方科目是资产负债表类 */
                                /* 对方科目是利润类 */
                                FIND FIRST ac_mstr WHERE ac_code = gltrhist.gltr_acc AND (ac_type = 'I' OR ac_type = 'E') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    done2 = NO.
                                    FOR EACH glrddet1 
                                        WHERE glrddet1.glrd_code = '0311'
                                        AND glrddet1.glrd_fpos = 0
                                        AND (glrddet1.glrd_acct <= gltrhist.gltr_acc OR glrddet1.glrd_acct = '')
                                        AND (glrddet1.glrd_acct1 >= gltrhist.gltr_acc OR glrddet1.glrd_acct1 = '')
                                        AND (glrddet1.glrd_sub <= gltrhist.gltr_sub OR glrddet1.glrd_sub = '')
                                        AND (glrddet1.glrd_sub1 >= gltrhist.gltr_sub OR glrddet1.glrd_sub1 = '')
                                        AND (glrddet1.glrd_cc <= gltrhist.gltr_ctr OR glrddet1.glrd_cc = '')
                                        AND (glrddet1.glrd_cc1 >= gltrhist.gltr_ctr OR glrddet1.glrd_cc1 = '')
                                        USE-INDEX glrd_code
                                        NO-LOCK
                                        BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                                        IF NOT done2 THEN DO:
                                            done2 = YES.
                                            /* 0302(3)02 - 投(筹)资活动产生的现金流出 */
                                            /*
                                            FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                            IF AVAILABLE wt THEN DO:
                                                /* +! */
                                                ASSIGN decivalue = decivalue + gltrhist.gltr_amt.
                                            END.
                                            ELSE DO:
                                                CREATE wt.
                                                ASSIGN
                                                    fldname = 'Line' + STRING(glrddet.glrd_sums)
                                                    /* +! */
                                                    decivalue = + gltrhist.gltr_amt.
                                            END.
                                            */
                                            EXPORT DELIMITER ";" glrddet.glrd_sums acc sub gltrhist.gltr_acc gltrhist.gltr_sub gltrhist.gltr_amt gltrhist.gltr_desc gltrhist.gltr_ref.
                                            /* 0311 - 将净利润调节为经营活动现金流量 */
                                            /*
                                            FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet1.glrd_sums) NO-LOCK NO-ERROR.
                                            IF AVAILABLE wt THEN DO:
                                                /* +! */
                                                ASSIGN decivalue = decivalue + gltrhist.gltr_amt.
                                            END.
                                            ELSE DO:
                                                CREATE wt.
                                                ASSIGN
                                                    fldname = 'Line' + STRING(glrddet.glrd_sums)
                                                    /* +! */
                                                    decivalue = + gltrhist.gltr_amt.
                                            END.
                                            */
                                            EXPORT DELIMITER ";" glrddet.glrd_sums acc sub gltrhist.gltr_acc gltrhist.gltr_sub gltrhist.gltr_amt gltrhist.gltr_desc gltrhist.gltr_ref.
                                            LEAVE rept1.
                                        END.
                                    END. /* IF AVAILABLE glrddet1 THEN DO: */
                                    /*
                                    CREATE wt.
                                    ASSIGN 
                                        fldname = 'Error'
                                        /* TODO:使用错误代码 */
                                        charvalue = '没有调整非经营活动产生的现金流入的净利润:' + gltrhist.gltr_ref.
                                    */
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* 对方科目是利润类 */
                                /* 对方科目异常 */
                                /*
                                CREATE wt.
                                ASSIGN 
                                    fldname = 'Error'
                                    /* TODO:使用错误代码 */
                                    charvalue = '对方科目异常(不是A,L,I,E中的任何一种):' + gltrhist.gltr_ref.
                                */
                                LEAVE rept1.
                            END.
                        END.
                        /* 0302(3)02 - 投(筹)资活动产生的现金流出 */


                        /* 对方科目异常 */
                        /*
                        CREATE wt.
                        ASSIGN 
                            fldname = 'Error'
                            /* TODO:使用错误代码 */
                            charvalue = '没有定义现金及现金等价物对方科目的主表行次:' + gltrhist.gltr_ref.
                        */
                        LEAVE rept1.
                    END.
                    /* 按主表排序 */
                END.
                /* 处理现金及现金等价物的对方科目 */
            END.
            /* 按会计单位排序 */
        END.
        /* 是否包含现金及现金等价物科目 */



        /* 是否包含损益科目 */
        IF NOT cash THEN DO:
            IF ie THEN DO:
                /* 按对方科目(非损益非现金及现金等价物)排序 */
                FOR EACH gltrhist WHERE gltrhist.gltr_ref = gltr_hist.gltr_ref AND gltrhist.gltr_entity = gltr_hist.gltr_entity USE-INDEX gltr_ref NO-LOCK
                    ,EACH ac_mstr WHERE (ac_type = 'A' OR ac_type = 'L') AND ac_code = gltrhist.gltr_acc USE-INDEX ac_type NO-LOCK:
                    rept2:
                    REPEAT:
                        done = NO.
                        FOR EACH glrddet 
                            WHERE glrddet.glrd_code = '0311'
                            AND glrddet.glrd_fpos = 0
                            AND (glrddet.glrd_acct <= gltrhist.gltr_acc OR glrddet.glrd_acct = '')
                            AND (glrddet.glrd_acct1 >= gltrhist.gltr_acc OR glrddet.glrd_acct1 = '')
                            AND (glrddet.glrd_sub <= gltrhist.gltr_sub OR glrddet.glrd_sub = '')
                            AND (glrddet.glrd_sub1 >= gltrhist.gltr_sub OR glrddet.glrd_sub1 = '')
                            AND (glrddet.glrd_cc <= gltrhist.gltr_ctr OR glrddet.glrd_cc = '')
                            AND (glrddet.glrd_cc1 >= gltrhist.gltr_ctr OR glrddet.glrd_cc1 = '')
                            USE-INDEX glrd_code
                            NO-LOCK
                            BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                            IF NOT done THEN DO:
                                done = YES.
                                /*
                                FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                IF AVAILABLE wt THEN DO:
                                    /* -! */
                                    ASSIGN decivalue = decivalue - gltrhist.gltr_amt.
                                END.
                                ELSE DO:
                                    CREATE wt.
                                    ASSIGN
                                        fldname = 'Line' + STRING(glrddet.glrd_sums)
                                        /* -! */
                                        decivalue = - gltrhist.gltr_amt.
                                END.
                                */
                                EXPORT DELIMITER ";" glrddet.glrd_sums acc sub gltrhist.gltr_acc gltrhist.gltr_sub (- gltrhist.gltr_amt) gltrhist.gltr_desc gltrhist.gltr_ref.
                                LEAVE rept2.
                            END.
                        END.
                        /* 对方科目异常 */
                        /*
                        CREATE wt.
                        ASSIGN 
                            fldname = 'Error'
                            /* TODO:使用错误代码 */
                            charvalue = '没有定义不包含现金及现金等价物的损益对方科目的附表行次:' + gltrhist.gltr_ref.
                        */
                        LEAVE rept2.
                    END. /* REPEAT: */
                END.
                /* 按对方科目(非损益非现金及现金等价物)排序 */
            END.
        END.
        /* 是否包含损益科目 */



        /* 既不包含现金及现金等价物科目,也不包含损益科目的总账参考号不做处理 */
        cash = FALSE.
        ie = FALSE.
    END.
    /* 按总账参考号排序 */
END.

FOR EACH wt1 :
   DELETE wt1 .
END.
/******************** SS - 20060908.1 - B ********************/
/*
FOR EACH gltr_hist NO-LOCK WHERE gltr_entity = entity 
                             AND (gltr_eff_dt >= begdt)
                             AND (gltr_eff_dt <= enddt)
                             USE-INDEX gltr_ind1,
    EACH glta_det NO-LOCK WHERE glta_ref = gltr_ref 
                            AND glta_line = gltr_line
                            BREAK BY glta_acct1 BY gltr_acc BY gltr_sub :
   ACCUMULATE gltr_amt ( TOTAL BY glta_acct1 BY gltr_acc BY gltr_sub ) .
   IF LAST-OF( gltr_sub ) THEN DO:
      CREATE wt1 .
      ASSIGN
         wt1_acc = glta_acct1
         wt1_acct = gltr_acc
         wt1_sub = gltr_sub
         wt1_d_acct = ""
         wt1_d_sub = ""
         wt1_amt = (ACCUMULATE TOTAL BY gltr_sub gltr_amt)
         wt1_desc = gltr_desc 
         wt1_ref = gltr_ref
         .
   END.
END.
FOR EACH wt1 NO-LOCK :
    EXPORT DELIMITER ";" wt1 . 
END.
  */
FOR EACH gltr_hist NO-LOCK WHERE gltr_entity = entity 
                             AND (gltr_eff_dt >= begdt)
                             AND (gltr_eff_dt <= enddt)
                             USE-INDEX gltr_ind1,
    EACH glta_det NO-LOCK WHERE glta_ref = gltr_ref 
                            AND glta_line = gltr_line :
      CREATE wt1 .
      ASSIGN
         wt1_acc = glta_acct1
         wt1_acct = gltr_acc
         wt1_sub = gltr_sub
         wt1_d_acct = ""
         wt1_d_sub = ""
         wt1_amt = gltr_amt
         wt1_desc = gltr_desc 
         wt1_ref = gltr_ref
         .
END.
FOR EACH wt1 NO-LOCK :
    EXPORT DELIMITER ";" wt1 . 
END.
/******************** SS - 20060908.1 - E ********************/

/* a6glcfd - b */
/*
/* 净利润 */
FIND FIRST glrd_det 
    WHERE glrd_det.glrd_code = '031100'
    AND glrd_det.glrd_fpos = 0
    USE-INDEX glrd_code
    NO-LOCK
    NO-ERROR.
IF AVAILABLE glrd_det THEN DO:
    CREATE wt.
    ASSIGN
        fldname = 'Line' + STRING(glrd_sums)
        /* -! */
        decivalue = - netprofit.
END.
ELSE DO:
    CREATE wt.
    ASSIGN 
        fldname = 'Error'
        /* TODO:使用错误代码 */
        charvalue = '没有定义净利润的附表行次'.
END.

o1 = 0.
o2 = 0.
FOR EACH glrd_det
    WHERE glrd_code = '031301'
    AND glrd_fpos = 0
    USE-INDEX glrd_code
    NO-LOCK
    BREAK BY glrd_sums:
    {gprun.i ""a6glabrp.p"" "(input-output o1, input-output o2, input begdt, input enddt, input glrd_acct, input glrd_acct, input glrd_sub, input glrd_sub, input glrd_cc, input glrd_cc, input entity, input entity)"}
        IF LAST-OF(glrd_sums) THEN DO:
            CREATE wt.
            ASSIGN
                fldname = 'Line' + STRING(glrd_sums)
                /* -! */
                decivalue = o2.
            CREATE wt.
            ASSIGN
                fldname = 'Line' + STRING(glrd_sums + 10)
                /* -! */
                decivalue = o1.
            o1 = 0.
            o2 = 0.
        END.
END.
*/
/* a6glcfd - e */
