/* BY: Micho Yang         DATE: 09/05/06  ECO: *SS - 20060905.1*  */

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
    /* ������ */
    FIND FIRST ac_mstr WHERE (ac_type = 'I' OR ac_type = 'E') AND ac_code = gltr_acc USE-INDEX ac_type NO-LOCK NO-ERROR.
    IF AVAILABLE ac_mstr THEN netprofit = netprofit + gltr_amt.
    /* �Ƿ�����ֽ��ֽ�ȼ����Ŀ */
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
            END.
        END.
    END.
    /* �Ƿ�����ֽ��ֽ�ȼ����Ŀ */
    /* �Ƿ���������Ŀ */
    IF NOT cash THEN DO:
        IF NOT ie THEN DO:
            FIND FIRST ac_mstr WHERE (ac_type = 'I' OR ac_type = 'E') AND ac_code = gltr_hist.gltr_acc USE-INDEX ac_type NO-LOCK NO-ERROR.
            IF AVAILABLE ac_mstr THEN ie = TRUE.
        END.
    END.
    /* �Ƿ���������Ŀ */
    /* �����˲ο������� */
    IF LAST-OF(gltr_ref) THEN DO:
        /* �Ƿ�����ֽ��ֽ�ȼ����Ŀ */
        IF cash THEN DO:
            /* ����Ƶ�λ���� */
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
                /* �����ֽ��ֽ�ȼ���ĶԷ���Ŀ */
                IF NOT done THEN DO:
                    /* ���������� */
                    rept1:
                    REPEAT:
                        /* 030101 - ��Ӫ��������ֽ����� */
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
                                /* �Է���Ŀ���ʲ���ծ���� */
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
                                            /* 030101 - ��Ӫ��������ֽ����� */
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
                                            /* 0311 - �����������Ϊ��Ӫ��ֽ����� */
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
                                            LEAVE rept1.
                                        END.
                                    END. /* IF AVAILABLE glrddet1 THEN DO: */
                                    CREATE wt.
                                    ASSIGN 
                                        fldname = 'Error'
                                        /* TODO:ʹ�ô������ */
                                        charvalue = 'û�е�����Ӱ�쾻����ľ�Ӫ���ʲ���ծ�ļ��ٻ�����:' + gltrhist.gltr_ref.
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* �Է���Ŀ���ʲ���ծ���� */
                                /* �Է���Ŀ�������� */
                                FIND FIRST ac_mstr WHERE ac_code = gltrhist.gltr_acc AND (ac_type = 'I' OR ac_type = 'E') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    /* 030101 - ��Ӫ��������ֽ����� */
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
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* �Է���Ŀ�������� */
                                /* �Է���Ŀ�쳣 */
                                CREATE wt.
                                ASSIGN 
                                    fldname = 'Error'
                                    /* TODO:ʹ�ô������ */
                                    charvalue = '�Է���Ŀ�쳣(����A,L,I,E�е��κ�һ��):' + gltrhist.gltr_ref.
                                LEAVE rept1.
                            END.
                        END.
                        /* 030101 - ��Ӫ��������ֽ����� */


                        /* 030102 - ��Ӫ��������ֽ����� */
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
                                /* �Է���Ŀ���ʲ���ծ���� */
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
                                            /* 030102 - ��Ӫ��������ֽ����� */
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
                                            /* 0311 - �����������Ϊ��Ӫ��ֽ����� */
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
                                            LEAVE rept1.
                                        END.
                                    END. /* IF AVAILABLE glrddet1 THEN DO: */
                                    CREATE wt.
                                    ASSIGN 
                                        fldname = 'Error'
                                        /* TODO:ʹ�ô������ */
                                        charvalue = 'û�е�����Ӱ�쾻����ľ�Ӫ���ʲ���ծ�ļ��ٻ�����:' + gltrhist.gltr_ref.
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* �Է���Ŀ���ʲ���ծ���� */
                                /* �Է���Ŀ�������� */
                                FIND FIRST ac_mstr WHERE ac_code = gltrhist.gltr_acc AND (ac_type = 'I' OR ac_type = 'E') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
                                    /* 030101 - ��Ӫ��������ֽ����� */
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
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* �Է���Ŀ�������� */
                                /* �Է���Ŀ�쳣 */
                                CREATE wt.
                                ASSIGN 
                                    fldname = 'Error'
                                    /* TODO:ʹ�ô������ */
                                    charvalue = '�Է���Ŀ�쳣(����A,L,I,E�е��κ�һ��):' + gltrhist.gltr_ref.
                                LEAVE rept1.
                            END.
                        END.  /* IF AVAILABLE glrddet THEN DO: */
                        /* 030102 - ��Ӫ��������ֽ����� */


                        /* 0302(3)01,0304 - Ͷ(��)�ʻ�������ֽ�����,���ʱ䶯���ֽ��Ӱ�� */
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
                                /* �Է���Ŀ���ʲ���ծ���� */
                                FIND FIRST ac_mstr WHERE ac_code = gltrhist.gltr_acc AND (ac_type = 'A' OR ac_type = 'L') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
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
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* �Է���Ŀ���ʲ���ծ���� */
                                /* �Է���Ŀ�������� */
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
                                            /* 0302(3)01,0304 - Ͷ(��)�ʻ�������ֽ�����,���ʱ䶯���ֽ��Ӱ�� */
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
                                            /* 0311 - �����������Ϊ��Ӫ��ֽ����� */
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
                                            LEAVE rept1.
                                        END.
                                    END. /* IF AVAILABLE glrddet1 THEN DO: */
                                    CREATE wt.
                                    ASSIGN 
                                        fldname = 'Error'
                                        /* TODO:ʹ�ô������ */
                                        charvalue = 'û�е����Ǿ�Ӫ��������ֽ�����ľ�����:' + gltrhist.gltr_ref.
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* �Է���Ŀ�������� */
                                /* �Է���Ŀ�쳣 */
                                CREATE wt.
                                ASSIGN 
                                    fldname = 'Error'
                                    /* TODO:ʹ�ô������ */
                                    charvalue = '�Է���Ŀ�쳣(����A,L,I,E�е��κ�һ��):' + gltrhist.gltr_ref.
                                LEAVE rept1.
                            END.
                        END.
                        /* 0302(3)01,0304 - Ͷ(��)�ʻ�������ֽ�����,���ʱ䶯���ֽ��Ӱ�� */


                        /* 0302(3)02 - Ͷ(��)�ʻ�������ֽ����� */
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
                                /* �Է���Ŀ���ʲ���ծ���� */
                                FIND FIRST ac_mstr WHERE ac_code = gltrhist.gltr_acc AND (ac_type = 'A' OR ac_type = 'L') USE-INDEX ac_code NO-LOCK NO-ERROR.
                                IF AVAILABLE ac_mstr THEN DO:
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
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* �Է���Ŀ���ʲ���ծ���� */
                                /* �Է���Ŀ�������� */
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
                                            /* 0302(3)02 - Ͷ(��)�ʻ�������ֽ����� */
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
                                            /* 0311 - �����������Ϊ��Ӫ��ֽ����� */
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
                                            LEAVE rept1.
                                        END.
                                    END. /* IF AVAILABLE glrddet1 THEN DO: */
                                    CREATE wt.
                                    ASSIGN 
                                        fldname = 'Error'
                                        /* TODO:ʹ�ô������ */
                                        charvalue = 'û�е����Ǿ�Ӫ��������ֽ�����ľ�����:' + gltrhist.gltr_ref.
                                    LEAVE rept1.
                                END. /* IF AVAILABLE ac_mstr THEN DO: */
                                /* �Է���Ŀ�������� */
                                /* �Է���Ŀ�쳣 */
                                CREATE wt.
                                ASSIGN 
                                    fldname = 'Error'
                                    /* TODO:ʹ�ô������ */
                                    charvalue = '�Է���Ŀ�쳣(����A,L,I,E�е��κ�һ��):' + gltrhist.gltr_ref.
                                LEAVE rept1.
                            END.
                        END.
                        /* 0302(3)02 - Ͷ(��)�ʻ�������ֽ����� */


                        /* �Է���Ŀ�쳣 */
                        CREATE wt.
                        ASSIGN 
                            fldname = 'Error'
                            /* TODO:ʹ�ô������ */
                            charvalue = 'û�ж����ֽ��ֽ�ȼ���Է���Ŀ�������д�:' + gltrhist.gltr_ref.
                        LEAVE rept1.
                    END.
                    /* ���������� */
                END.
                /* �����ֽ��ֽ�ȼ���ĶԷ���Ŀ */
            END.
            /* ����Ƶ�λ���� */
        END.
        /* �Ƿ�����ֽ��ֽ�ȼ����Ŀ */



        /* �Ƿ���������Ŀ */
        IF NOT cash THEN DO:
            IF ie THEN DO:
                /* ���Է���Ŀ(��������ֽ��ֽ�ȼ���)���� */
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
                                LEAVE rept2.
                            END.
                        END.
                        /* �Է���Ŀ�쳣 */
                        CREATE wt.
                        ASSIGN 
                            fldname = 'Error'
                            /* TODO:ʹ�ô������ */
                            charvalue = 'û�ж��岻�����ֽ��ֽ�ȼ��������Է���Ŀ�ĸ����д�:' + gltrhist.gltr_ref.
                        LEAVE rept2.
                    END. /* REPEAT: */
                END.
                /* ���Է���Ŀ(��������ֽ��ֽ�ȼ���)���� */
            END.
        END.
        /* �Ƿ���������Ŀ */



        /* �Ȳ������ֽ��ֽ�ȼ����Ŀ,Ҳ�����������Ŀ�����˲ο��Ų������� */
        cash = FALSE.
        ie = FALSE.
    END.
    /* �����˲ο������� */
END.

/* ������ */
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
        /* TODO:ʹ�ô������ */
        charvalue = 'û�ж��徻����ĸ����д�'.
END.

o1 = 0.
o2 = 0.
FOR EACH glrd_det
    WHERE glrd_code = '031301'
    AND glrd_fpos = 0
    USE-INDEX glrd_code
    NO-LOCK
    BREAK BY glrd_sums:

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


/* ����glta_det �е�glta_acct1 */
/* SS - 20060905.1 - B */
FOR EACH gltr_hist NO-LOCK WHERE gltr_entity = entity 
                             AND (gltr_eff_dt >= begdt)
                             AND (gltr_eff_dt <= enddt)
                             USE-INDEX gltr_ind1,
    EACH glta_det NO-LOCK WHERE glta_ref = gltr_ref 
                            AND glta_line = gltr_line
                            BREAK BY substring(glta_acct1,1,2) :
   ACCUMULATE gltr_amt ( TOTAL BY substring(glta_acct1,1,2) ) .
   IF LAST-OF( substring(glta_acct1,1,2) ) THEN DO:
      CREATE wt .
      ASSIGN
         fldname = substring(glta_acct1,1,2)
         .
      IF substring(glta_acct1,1,2) >= "01" 
         AND substring(glta_acct1,1,2) <= "10" THEN
         ASSIGN decivalue = - (ACCUMULATE TOTAL BY substring(glta_acct1,1,2) gltr_amt)
                .
      ELSE 
         ASSIGN decivalue = (ACCUMULATE TOTAL BY substring(glta_acct1,1,2) gltr_amt)
                .

   END.
END.
/* SS - 20060905.1 - E */
