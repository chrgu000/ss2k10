/* BY: Micho Yang         DATE: 09/05/06  ECO: *SS - 20060905.1*  */

cash = FALSE.
ie = FALSE.
netprofit = 0.
FOR EACH glt_det
    WHERE glt_entity = entity 
    AND (glt_effdate >= begdt)
    AND (glt_effdate <= enddt)
    AND glt_tr_type = "JL"
    USE-INDEX glt_index
    NO-LOCK
    BREAK BY glt_ref:
    /* 净利润 */
    FIND FIRST ac_mstr WHERE (ac_type = 'I' OR ac_type = 'E') AND ac_code = glt_acct USE-INDEX ac_type NO-LOCK NO-ERROR.
    IF AVAILABLE ac_mstr THEN netprofit = netprofit + glt_amt.
    /* 是否包含现金及现金等价物科目 */
    IF NOT cash THEN DO:
        done = NO.
        FOR EACH glrd_det 
            WHERE glrd_det.glrd_code = '031301'
            AND glrd_det.glrd_fpos = 0
            AND (glrd_det.glrd_acct <= glt_det.glt_acct OR glrd_det.glrd_acct = '')
            AND (glrd_det.glrd_acct1 >= glt_det.glt_acct OR glrd_det.glrd_acct1 = '')
            AND (glrd_det.glrd_sub <= glt_det.glt_sub OR glrd_det.glrd_sub = '')
            AND (glrd_det.glrd_sub1 >= glt_det.glt_sub OR glrd_det.glrd_sub1 = '')
            AND (glrd_det.glrd_cc <= glt_det.glt_cc OR glrd_det.glrd_cc = '')
            AND (glrd_det.glrd_cc1 >= glt_det.glt_cc OR glrd_det.glrd_cc1 = '')
            USE-INDEX glrd_code
            NO-LOCK
            BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
            IF NOT done THEN DO:
                done = YES.
                cash = TRUE.
            END.
        END.
    END.
    /* 是否包含现金及现金等价物科目 */
    /* 是否包含损益科目 */
    IF NOT cash THEN DO:
        IF NOT ie THEN DO:
            FIND FIRST ac_mstr WHERE (ac_type = 'I' OR ac_type = 'E') AND ac_code = glt_det.glt_acct USE-INDEX ac_type NO-LOCK NO-ERROR.
            IF AVAILABLE ac_mstr THEN ie = TRUE.
        END.
    END.
    /* 是否包含损益科目 */
    /* 按总账参考号排序 */
    IF LAST-OF(glt_ref) THEN DO:
        /* 是否包含现金及现金等价物科目 */
        IF cash THEN DO:
            /* 按会计单位排序 */
            FOR EACH gltdet WHERE gltdet.glt_ref = glt_det.glt_ref AND gltdet.glt_entity = glt_det.glt_entity AND gltdet.glt_tr_type = "JL" USE-INDEX glt_ref NO-LOCK:
                done = NO.
                FOR EACH glrd_det 
                    WHERE glrd_det.glrd_code = '031301'
                    AND glrd_det.glrd_fpos = 0
                    AND (glrd_det.glrd_acct <= gltdet.glt_acct OR glrd_det.glrd_acct = '')
                    AND (glrd_det.glrd_acct1 >= gltdet.glt_acct OR glrd_det.glrd_acct1 = '')
                    AND (glrd_det.glrd_sub <= gltdet.glt_sub OR glrd_det.glrd_sub = '')
                    AND (glrd_det.glrd_sub1 >= gltdet.glt_sub OR glrd_det.glrd_sub1 = '')
                    AND (glrd_det.glrd_cc <= gltdet.glt_cc OR glrd_det.glrd_cc = '')
                    AND (glrd_det.glrd_cc1 >= gltdet.glt_cc OR glrd_det.glrd_cc1 = '')
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
                            AND (glrddet.glrd_acct <= gltdet.glt_acct OR glrddet.glrd_acct = '')
                            AND (glrddet.glrd_acct1 >= gltdet.glt_acct OR glrddet.glrd_acct1 = '')
                            AND (glrddet.glrd_sub <= gltdet.glt_sub OR glrddet.glrd_sub = '')
                            AND (glrddet.glrd_sub1 >= gltdet.glt_sub OR glrddet.glrd_sub1 = '')
                            AND (glrddet.glrd_cc <= gltdet.glt_cc OR glrddet.glrd_cc = '')
                            AND (glrddet.glrd_cc1 >= gltdet.glt_cc OR glrddet.glrd_cc1 = '')
                            USE-INDEX glrd_code
                            NO-LOCK
                            BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                            IF NOT done THEN DO:
                                done = YES.
                                /* 对方科目是资产负债表类 */
                                FIND FIRST ac_mstr WHERE ac_code = gltdet.glt_acct AND (ac_type = 'A' OR ac_type = 'L') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    done2 = NO.
                                    FOR EACH glrddet1 
                                        WHERE glrddet1.glrd_code = '0311'
                                        AND glrddet1.glrd_fpos = 0
                                        AND (glrddet1.glrd_acct <= gltdet.glt_acct OR glrddet1.glrd_acct = '')
                                        AND (glrddet1.glrd_acct1 >= gltdet.glt_acct OR glrddet1.glrd_acct1 = '')
                                        AND (glrddet1.glrd_sub <= gltdet.glt_sub OR glrddet1.glrd_sub = '')
                                        AND (glrddet1.glrd_sub1 >= gltdet.glt_sub OR glrddet1.glrd_sub1 = '')
                                        AND (glrddet1.glrd_cc <= gltdet.glt_cc OR glrddet1.glrd_cc = '')
                                        AND (glrddet1.glrd_cc1 >= gltdet.glt_cc OR glrddet1.glrd_cc1 = '')
                                        USE-INDEX glrd_code
                                        NO-LOCK
                                        BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                                        IF NOT done2 THEN DO:
                                            done2 = YES.
                                            /* 030101 - 经营活动产生的现金流入 */
                                            FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                            IF AVAILABLE wt THEN DO:
                                                /* -! */
                                                ASSIGN decivalue = decivalue - gltdet.glt_amt.
                                            END.
                                            ELSE DO:
                                                CREATE wt.
                                                ASSIGN
                                                    fldname = 'Line' + STRING(glrddet.glrd_sums)
                                                    /* -! */
                                                    decivalue = - gltdet.glt_amt.
                                            END.
                                            /* 0311 - 将净利润调节为经营活动现金流量 */
                                            FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet1.glrd_sums) NO-LOCK NO-ERROR.
                                            IF AVAILABLE wt THEN DO:
                                                /* -! */
                                                ASSIGN decivalue = decivalue - gltdet.glt_amt.
                                            END.
                                            ELSE DO:
                                                CREATE wt.
                                                ASSIGN
                                                    fldname = 'Line' + STRING(glrddet1.glrd_sums)
                                                    /* -! */
                                                    decivalue = - gltdet.glt_amt.
                                            END.
                                            LEAVE rept1.
                                        END.
                                    END. /* IF AVAILABLE glrddet1 THEN DO: */
                                    CREATE wt.
                                    ASSIGN 
                                        fldname = 'Error'
                                        /* TODO:使用错误代码 */
                                        charvalue = '没有调整不影响净利润的经营性资产负债的减少或增加:' + gltdet.glt_ref.
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* 对方科目是资产负债表类 */
                                /* 对方科目是利润类 */
                                FIND FIRST ac_mstr WHERE ac_code = gltdet.glt_acct AND (ac_type = 'I' OR ac_type = 'E') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    /* 030101 - 经营活动产生的现金流入 */
                                    FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                    IF AVAILABLE wt THEN DO:
                                        /* -! */
                                        ASSIGN decivalue = decivalue - gltdet.glt_amt.
                                    END.
                                    ELSE DO:
                                        CREATE wt.
                                        ASSIGN
                                            fldname = 'Line' + STRING(glrddet.glrd_sums)
                                            /* -! */
                                            decivalue = - gltdet.glt_amt.
                                    END.
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* 对方科目是利润类 */
                                /* 对方科目异常 */
                                CREATE wt.
                                ASSIGN 
                                    fldname = 'Error'
                                    /* TODO:使用错误代码 */
                                    charvalue = '对方科目异常(不是A,L,I,E中的任何一种):' + gltdet.glt_ref.
                                LEAVE rept1.
                            END.
                        END.
                        /* 030101 - 经营活动产生的现金流入 */


                        /* 030102 - 经营活动产生的现金流出 */
                       done = NO.
                        FOR EACH glrddet 
                            WHERE glrddet.glrd_code = '030102'
                            AND glrddet.glrd_fpos = 0
                            AND (glrddet.glrd_acct <= gltdet.glt_acct OR glrddet.glrd_acct = '')
                            AND (glrddet.glrd_acct1 >= gltdet.glt_acct OR glrddet.glrd_acct1 = '')
                            AND (glrddet.glrd_sub <= gltdet.glt_sub OR glrddet.glrd_sub = '')
                            AND (glrddet.glrd_sub1 >= gltdet.glt_sub OR glrddet.glrd_sub1 = '')
                            AND (glrddet.glrd_cc <= gltdet.glt_cc OR glrddet.glrd_cc = '')
                            AND (glrddet.glrd_cc1 >= gltdet.glt_cc OR glrddet.glrd_cc1 = '')
                            USE-INDEX glrd_code
                            NO-LOCK
                            BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                            IF NOT done THEN DO:
                                done = YES.
                                /* 对方科目是资产负债表类 */
                                FIND FIRST ac_mstr WHERE ac_code = gltdet.glt_acct AND (ac_type = 'A' OR ac_type = 'L') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    done2 = NO.
                                    FOR EACH glrddet1 
                                        WHERE glrddet1.glrd_code = '0311'
                                        AND glrddet1.glrd_fpos = 0
                                        AND (glrddet1.glrd_acct <= gltdet.glt_acct OR glrddet1.glrd_acct = '')
                                        AND (glrddet1.glrd_acct1 >= gltdet.glt_acct OR glrddet1.glrd_acct1 = '')
                                        AND (glrddet1.glrd_sub <= gltdet.glt_sub OR glrddet1.glrd_sub = '')
                                        AND (glrddet1.glrd_sub1 >= gltdet.glt_sub OR glrddet1.glrd_sub1 = '')
                                        AND (glrddet1.glrd_cc <= gltdet.glt_cc OR glrddet1.glrd_cc = '')
                                        AND (glrddet1.glrd_cc1 >= gltdet.glt_cc OR glrddet1.glrd_cc1 = '')
                                        USE-INDEX glrd_code
                                        NO-LOCK
                                        BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                                        IF NOT done2 THEN DO:
                                            done2 = YES.
                                            /* 030102 - 经营活动产生的现金流出 */
                                            FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                            IF AVAILABLE wt THEN DO:
                                                /* +! */
                                                ASSIGN decivalue = decivalue + gltdet.glt_amt.
                                            END.
                                            ELSE DO:
                                                CREATE wt.
                                                ASSIGN
                                                    fldname = 'Line' + STRING(glrddet.glrd_sums)
                                                    /* +! */
                                                    decivalue = + gltdet.glt_amt.
                                            END.
                                            /* 0311 - 将净利润调节为经营活动现金流量 */
                                            FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet1.glrd_sums) NO-LOCK NO-ERROR.
                                            IF AVAILABLE wt THEN DO:
                                                /* +! */
                                                ASSIGN decivalue = decivalue - gltdet.glt_amt.
                                            END.
                                            ELSE DO:
                                                CREATE wt.
                                                ASSIGN
                                                    fldname = 'Line' + STRING(glrddet1.glrd_sums)
                                                    /* +! */
                                                    decivalue = - gltdet.glt_amt.
                                            END.
                                            LEAVE rept1.
                                        END.
                                    END. /* IF AVAILABLE glrddet1 THEN DO: */
                                    CREATE wt.
                                    ASSIGN 
                                        fldname = 'Error'
                                        /* TODO:使用错误代码 */
                                        charvalue = '没有调整不影响净利润的经营性资产负债的减少或增加:' + gltdet.glt_ref.
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* 对方科目是资产负债表类 */
                                /* 对方科目是利润类 */
                                FIND FIRST ac_mstr WHERE ac_code = gltdet.glt_acct AND (ac_type = 'I' OR ac_type = 'E') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    /* 030101 - 经营活动产生的现金流入 */
                                    FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                    IF AVAILABLE wt THEN DO:
                                        /* +! */
                                        ASSIGN decivalue = decivalue + gltdet.glt_amt.
                                    END.
                                    ELSE DO:
                                        CREATE wt.
                                        ASSIGN
                                            fldname = 'Line' + STRING(glrddet.glrd_sums)
                                            /* +! */
                                            decivalue = + gltdet.glt_amt.
                                    END.
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* 对方科目是利润类 */
                                /* 对方科目异常 */
                                CREATE wt.
                                ASSIGN 
                                    fldname = 'Error'
                                    /* TODO:使用错误代码 */
                                    charvalue = '对方科目异常(不是A,L,I,E中的任何一种):' + gltdet.glt_ref.
                                LEAVE rept1.
                            END.
                        END.  /* IF AVAILABLE glrddet THEN DO: */
                        /* 030102 - 经营活动产生的现金流出 */


                        /* 0302(3)01,0304 - 投(筹)资活动产生的现金流入,汇率变动对现金的影响 */
                        done = NO.
                        FOR EACH glrddet 
                            WHERE (glrddet.glrd_code = '030201' OR glrddet.glrd_code = '030301' OR glrddet.glrd_code = '0304')
                            AND glrddet.glrd_fpos = 0
                            AND (glrddet.glrd_acct <= gltdet.glt_acct OR glrddet.glrd_acct = '')
                            AND (glrddet.glrd_acct1 >= gltdet.glt_acct OR glrddet.glrd_acct1 = '')
                            AND (glrddet.glrd_sub <= gltdet.glt_sub OR glrddet.glrd_sub = '')
                            AND (glrddet.glrd_sub1 >= gltdet.glt_sub OR glrddet.glrd_sub1 = '')
                            AND (glrddet.glrd_cc <= gltdet.glt_cc OR glrddet.glrd_cc = '')
                            AND (glrddet.glrd_cc1 >= gltdet.glt_cc OR glrddet.glrd_cc1 = '')
                            USE-INDEX glrd_code
                            NO-LOCK
                            BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                            IF NOT done THEN DO:
                                done = YES.
                                /* 对方科目是资产负债表类 */
                                FIND FIRST ac_mstr WHERE ac_code = gltdet.glt_acct AND (ac_type = 'A' OR ac_type = 'L') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                    IF AVAILABLE wt THEN DO:
                                        /* -! */
                                        ASSIGN decivalue = decivalue - gltdet.glt_amt.
                                    END.
                                    ELSE DO:
                                        CREATE wt.
                                        ASSIGN
                                            fldname = 'Line' + STRING(glrddet.glrd_sums)
                                            /* -! */
                                            decivalue = - gltdet.glt_amt.
                                    END.
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* 对方科目是资产负债表类 */
                                /* 对方科目是利润类 */
                                FIND FIRST ac_mstr WHERE ac_code = gltdet.glt_acct AND (ac_type = 'I' OR ac_type = 'E') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    done2 = NO.
                                    FOR EACH glrddet1 
                                        WHERE glrddet1.glrd_code = '0311'
                                        AND glrddet1.glrd_fpos = 0
                                        AND (glrddet1.glrd_acct <= gltdet.glt_acct OR glrddet1.glrd_acct = '')
                                        AND (glrddet1.glrd_acct1 >= gltdet.glt_acct OR glrddet1.glrd_acct1 = '')
                                        AND (glrddet1.glrd_sub <= gltdet.glt_sub OR glrddet1.glrd_sub = '')
                                        AND (glrddet1.glrd_sub1 >= gltdet.glt_sub OR glrddet1.glrd_sub1 = '')
                                        AND (glrddet1.glrd_cc <= gltdet.glt_cc OR glrddet1.glrd_cc = '')
                                        AND (glrddet1.glrd_cc1 >= gltdet.glt_cc OR glrddet1.glrd_cc1 = '')
                                        USE-INDEX glrd_code
                                        NO-LOCK
                                        BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                                        IF NOT done2 THEN DO:
                                            done2 = YES.
                                            /* 0302(3)01,0304 - 投(筹)资活动产生的现金流入,汇率变动对现金的影响 */
                                            FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                            IF AVAILABLE wt THEN DO:
                                                /* -! */
                                                ASSIGN decivalue = decivalue - gltdet.glt_amt.
                                            END.
                                            ELSE DO:
                                                CREATE wt.
                                                ASSIGN
                                                    fldname = 'Line' + STRING(glrddet.glrd_sums)
                                                    /* -! */
                                                    decivalue = - gltdet.glt_amt.
                                            END.
                                            /* 0311 - 将净利润调节为经营活动现金流量 */
                                            FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet1.glrd_sums) NO-LOCK NO-ERROR.
                                            IF AVAILABLE wt THEN DO:
                                                /* -! */
                                                ASSIGN decivalue = decivalue + gltdet.glt_amt.
                                            END.
                                            ELSE DO:
                                                CREATE wt.
                                                ASSIGN
                                                    fldname = 'Line' + STRING(glrddet.glrd_sums)
                                                    /* -! */
                                                    decivalue = + gltdet.glt_amt.
                                            END.
                                            LEAVE rept1.
                                        END.
                                    END. /* IF AVAILABLE glrddet1 THEN DO: */
                                    CREATE wt.
                                    ASSIGN 
                                        fldname = 'Error'
                                        /* TODO:使用错误代码 */
                                        charvalue = '没有调整非经营活动产生的现金流入的净利润:' + gltdet.glt_ref.
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* 对方科目是利润类 */
                                /* 对方科目异常 */
                                CREATE wt.
                                ASSIGN 
                                    fldname = 'Error'
                                    /* TODO:使用错误代码 */
                                    charvalue = '对方科目异常(不是A,L,I,E中的任何一种):' + gltdet.glt_ref.
                                LEAVE rept1.
                            END.
                        END.
                        /* 0302(3)01,0304 - 投(筹)资活动产生的现金流入,汇率变动对现金的影响 */


                        /* 0302(3)02 - 投(筹)资活动产生的现金流出 */
                        done = NO.
                        FOR EACH glrddet 
                            WHERE (glrddet.glrd_code = '030202' OR glrddet.glrd_code = '030302')
                            AND glrddet.glrd_fpos = 0
                            AND (glrddet.glrd_acct <= gltdet.glt_acct OR glrddet.glrd_acct = '')
                            AND (glrddet.glrd_acct1 >= gltdet.glt_acct OR glrddet.glrd_acct1 = '')
                            AND (glrddet.glrd_sub <= gltdet.glt_sub OR glrddet.glrd_sub = '')
                            AND (glrddet.glrd_sub1 >= gltdet.glt_sub OR glrddet.glrd_sub1 = '')
                            AND (glrddet.glrd_cc <= gltdet.glt_cc OR glrddet.glrd_cc = '')
                            AND (glrddet.glrd_cc1 >= gltdet.glt_cc OR glrddet.glrd_cc1 = '')
                            USE-INDEX glrd_code
                            NO-LOCK
                            BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                            IF NOT done THEN DO:
                                done = YES.
                                /* 对方科目是资产负债表类 */
                                FIND FIRST ac_mstr WHERE ac_code = gltdet.glt_acct AND (ac_type = 'A' OR ac_type = 'L') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                    IF AVAILABLE wt THEN DO:
                                        /* +! */
                                        ASSIGN decivalue = decivalue + gltdet.glt_amt.
                                    END.
                                    ELSE DO:
                                        CREATE wt.
                                        ASSIGN
                                            fldname = 'Line' + STRING(glrddet.glrd_sums)
                                            /* +! */
                                            decivalue = + gltdet.glt_amt.
                                    END.
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* 对方科目是资产负债表类 */
                                /* 对方科目是利润类 */
                                FIND FIRST ac_mstr WHERE ac_code = gltdet.glt_acct AND (ac_type = 'I' OR ac_type = 'E') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    done2 = NO.
                                    FOR EACH glrddet1 
                                        WHERE glrddet1.glrd_code = '0311'
                                        AND glrddet1.glrd_fpos = 0
                                        AND (glrddet1.glrd_acct <= gltdet.glt_acct OR glrddet1.glrd_acct = '')
                                        AND (glrddet1.glrd_acct1 >= gltdet.glt_acct OR glrddet1.glrd_acct1 = '')
                                        AND (glrddet1.glrd_sub <= gltdet.glt_sub OR glrddet1.glrd_sub = '')
                                        AND (glrddet1.glrd_sub1 >= gltdet.glt_sub OR glrddet1.glrd_sub1 = '')
                                        AND (glrddet1.glrd_cc <= gltdet.glt_cc OR glrddet1.glrd_cc = '')
                                        AND (glrddet1.glrd_cc1 >= gltdet.glt_cc OR glrddet1.glrd_cc1 = '')
                                        USE-INDEX glrd_code
                                        NO-LOCK
                                        BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                                        IF NOT done2 THEN DO:
                                            done2 = YES.
                                            /* 0302(3)02 - 投(筹)资活动产生的现金流出 */
                                            FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                            IF AVAILABLE wt THEN DO:
                                                /* +! */
                                                ASSIGN decivalue = decivalue + gltdet.glt_amt.
                                            END.
                                            ELSE DO:
                                                CREATE wt.
                                                ASSIGN
                                                    fldname = 'Line' + STRING(glrddet.glrd_sums)
                                                    /* +! */
                                                    decivalue = + gltdet.glt_amt.
                                            END.
                                            /* 0311 - 将净利润调节为经营活动现金流量 */
                                            FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet1.glrd_sums) NO-LOCK NO-ERROR.
                                            IF AVAILABLE wt THEN DO:
                                                /* +! */
                                                ASSIGN decivalue = decivalue + gltdet.glt_amt.
                                            END.
                                            ELSE DO:
                                                CREATE wt.
                                                ASSIGN
                                                    fldname = 'Line' + STRING(glrddet.glrd_sums)
                                                    /* +! */
                                                    decivalue = + gltdet.glt_amt.
                                            END.
                                            LEAVE rept1.
                                        END.
                                    END. /* IF AVAILABLE glrddet1 THEN DO: */
                                    CREATE wt.
                                    ASSIGN 
                                        fldname = 'Error'
                                        /* TODO:使用错误代码 */
                                        charvalue = '没有调整非经营活动产生的现金流入的净利润:' + gltdet.glt_ref.
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* 对方科目是利润类 */
                                /* 对方科目异常 */
                                CREATE wt.
                                ASSIGN 
                                    fldname = 'Error'
                                    /* TODO:使用错误代码 */
                                    charvalue = '对方科目异常(不是A,L,I,E中的任何一种):' + gltdet.glt_ref.
                                LEAVE rept1.
                            END.
                        END.
                        /* 0302(3)02 - 投(筹)资活动产生的现金流出 */


                        /* 对方科目异常 */
                        CREATE wt.
                        ASSIGN 
                            fldname = 'Error'
                            /* TODO:使用错误代码 */
                            charvalue = '没有定义现金及现金等价物对方科目的主表行次:' + gltdet.glt_ref.
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
                FOR EACH gltdet WHERE gltdet.glt_ref = glt_det.glt_ref AND gltdet.glt_entity = glt_det.glt_entity AND gltdet.glt_tr_type = "JL" USE-INDEX glt_ref NO-LOCK
                    ,EACH ac_mstr WHERE (ac_type = 'A' OR ac_type = 'L') AND ac_code = gltdet.glt_acct USE-INDEX ac_type NO-LOCK:
                    rept2:
                    REPEAT:
                        done = NO.
                        FOR EACH glrddet 
                            WHERE glrddet.glrd_code = '0311'
                            AND glrddet.glrd_fpos = 0
                            AND (glrddet.glrd_acct <= gltdet.glt_acct OR glrddet.glrd_acct = '')
                            AND (glrddet.glrd_acct1 >= gltdet.glt_acct OR glrddet.glrd_acct1 = '')
                            AND (glrddet.glrd_sub <= gltdet.glt_sub OR glrddet.glrd_sub = '')
                            AND (glrddet.glrd_sub1 >= gltdet.glt_sub OR glrddet.glrd_sub1 = '')
                            AND (glrddet.glrd_cc <= gltdet.glt_cc OR glrddet.glrd_cc = '')
                            AND (glrddet.glrd_cc1 >= gltdet.glt_cc OR glrddet.glrd_cc1 = '')
                            USE-INDEX glrd_code
                            NO-LOCK
                            BY glrd_sub DESC BY glrd_acct DESC BY glrd_cc DESC:
                            IF NOT done THEN DO:
                                done = YES.
                                FIND FIRST wt WHERE fldname = 'Line' + STRING(glrddet.glrd_sums) NO-LOCK NO-ERROR.
                                IF AVAILABLE wt THEN DO:
                                    /* -! */
                                    ASSIGN decivalue = decivalue - gltdet.glt_amt.
                                END.
                                ELSE DO:
                                    CREATE wt.
                                    ASSIGN
                                        fldname = 'Line' + STRING(glrddet.glrd_sums)
                                        /* -! */
                                        decivalue = - gltdet.glt_amt.
                                END.
                                LEAVE rept2.
                            END.
                        END.
                        /* 对方科目异常 */
                        CREATE wt.
                        ASSIGN 
                            fldname = 'Error'
                            /* TODO:使用错误代码 */
                            charvalue = '没有定义不包含现金及现金等价物的损益对方科目的附表行次:' + gltdet.glt_ref.
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

/* 净利润 */
/* 已过帐中已经计算了 */
/*
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
  */

o1 = 0.
o2 = 0.
FOR EACH glrd_det
    WHERE glrd_code = '031301'
    AND glrd_fpos = 0
    USE-INDEX glrd_code
    NO-LOCK
    BREAK BY glrd_sums:

    /*
    FOR EACH tta6glabrp:
        DELETE tta6glabrp.
    END.

   {gprun.i ""a6glabrp.p"" "(
       INPUT entity,
       INPUT entity,
       INPUT glrd_acct,
       INPUT glrd_acct,
       INPUT glrd_sub,
       INPUT glrd_sub,
       INPUT glrd_cc,
       INPUT glrd_cc,
       INPUT begdt,
       INPUT enddt,
       INPUT dc,
       INPUT dc
   )"}

   FIND FIRST tta6glabrp NO-LOCK NO-ERROR.
   IF AVAILABLE tta6glabrp THEN DO:
       o1 = o1 + tta6glabrp_et_beg_bal.
       o2 = o2 + tta6glabrp_et_end_bal.
   END.
      */

    v_beg_amt = 0.
    v_end_amt = 0.
    FOR EACH gltdet1 NO-LOCK 
        WHERE gltdet1.glt_entity = entity 
        AND (gltdet1.glt_acct = glrd_acct OR glrd_acct = "")
        AND (gltdet1.glt_sub = glrd_sub OR glrd_sub = "")
        AND (gltdet1.glt_cc = glrd_cc OR glrd_cc = "")
        AND gltdet1.glt_effdate <= enddt 
        AND gltdet1.glt_tr_type = "JL"
        USE-INDEX glt_index,
        EACH ac_mstr NO-LOCK WHERE ac_code = gltdet1.glt_acct :
        IF gltdet1.glt_effdate < begdt THEN DO:
            if lookup(ac_type, "A,L") = 0 then do:
                IF gltdet1.glt_effdate >= DATE(1,1,YEAR(begdt)) AND gltdet1.glt_effdate < begdt THEN DO:
                   v_beg_amt = v_beg_amt + gltdet1.glt_amt .
                END.
            END.
            ELSE DO:
                   v_beg_amt = v_beg_amt + gltdet1.glt_amt .
            END.
        END.
        v_end_amt = v_end_amt + gltdet1.glt_amt .
    END.

    o1 = v_beg_amt.
    o2 = v_end_amt.
    IF LAST-OF(glrd_sums) THEN DO:
        FIND FIRST wt WHERE fldname = 'Line' + STRING(glrd_sums) NO-LOCK NO-ERROR.
        IF AVAIL wt THEN DO:
            decivalue = decivalue + o2 .
        END.
        ELSE DO:
            CREATE wt.
            ASSIGN
                fldname = 'Line' + STRING(glrd_sums)
                /* -! */
                decivalue = o2.
        END. 

        FIND FIRST wt WHERE fldname = 'Line' + STRING(glrd_sums + 10) NO-LOCK NO-ERROR.
        IF AVAIL wt THEN DO:
            decivalue = decivalue + o1 .
        END.
        ELSE DO:
            CREATE wt.
            ASSIGN
                fldname = 'Line' + STRING(glrd_sums + 10)
                /* -! */
                decivalue = o1.
        END.

        o1 = 0.
        o2 = 0.
    END.
END.


/* 新增glta_det 中的glta_acct1 */
/* SS - 20060905.1 - B */
FOR EACH glt_det NO-LOCK WHERE glt_entity = entity 
                             AND (glt_effdate >= begdt)
                             AND (glt_effdate <= enddt)
                             AND glt_tr_type = "JL"
                             USE-INDEX glt_index,
    EACH glta_det NO-LOCK WHERE glta_ref = glt_ref 
                            AND glta_line = glt_line
                            BREAK BY substring(glta_acct1,1,2) :
   ACCUMULATE glt_amt ( TOTAL BY substring(glta_acct1,1,2) ) .
   IF LAST-OF( substring(glta_acct1,1,2) ) THEN DO:
      FIND FIRST wt WHERE fldname = substring(glta_acct1,1,2) NO-LOCK NO-ERROR.
      IF AVAIL wt THEN DO:
          IF substring(glta_acct1,1,2) >= "01" 
             AND substring(glta_acct1,1,2) <= "10" THEN
             ASSIGN decivalue = decivalue - (ACCUMULATE TOTAL BY substring(glta_acct1,1,2) glt_amt)
                    .
          ELSE 
             ASSIGN decivalue = decivalue + (ACCUMULATE TOTAL BY substring(glta_acct1,1,2) glt_amt)
                    .
      END.
      ELSE DO:
          CREATE wt .
          ASSIGN
             fldname = substring(glta_acct1,1,2)
             .
          IF substring(glta_acct1,1,2) >= "01" 
             AND substring(glta_acct1,1,2) <= "10" THEN
             ASSIGN decivalue = - (ACCUMULATE TOTAL BY substring(glta_acct1,1,2) glt_amt)
                    .
          ELSE 
             ASSIGN decivalue = (ACCUMULATE TOTAL BY substring(glta_acct1,1,2) glt_amt)
                    .
      END.
   END.
END.
/* SS - 20060905.1 - E */
