DEF TEMP-TABLE tt
    FIELD tt_date AS INTEGER
    FIELD tt_desc AS CHAR
    INDEX index1 tt_date
    .

DEF VAR i AS INTEGER .
DEF VAR v_glta_acct1 AS CHAR.
DEF VAR v_fmpos AS CHAR.

EMPTY TEMP-TABLE tt .
DO i = 1 TO 31 :
    CREATE tt .
    ASSIGN
        tt_date = i  
        tt_desc = "日"
        .
END.

/* 输出到BI */
PUT UNFORMATTED "#def REPORTPATH=$/财务/BI报表/a6glrp60" SKIP.
PUT UNFORMATTED "#def :end" SKIP.

FOR EACH gltr_hist NO-LOCK 
    WHERE (gltr_entity = entity OR entity = "")
    AND gltr_ctr >= ctr AND gltr_ctr <= ctr1
    AND gltr_eff_dt >= effdate AND gltr_eff_dt <= effdate1,
    EACH glta_det NO-LOCK 
    WHERE glta_acct1 >= vacct1 AND glta_acct1 <= vacct2
    AND glta_ref = gltr_ref AND glta_line = gltr_line,
    EACH cc_mstr NO-LOCK 
    WHERE cc_ctr = gltr_ctr 
    BY gltr_eff_dt BY gltr_ref BY gltr_line 
    BY gltr_ctr BY glta_acct :

    v_fmpos = "".
    v_glta_acct1 = "".
    FIND FIRST CODE_mstr WHERE CODE_fldname = 'glta_acct1'
        AND CODE_value = glta_acct1 NO-LOCK NO-ERROR.
    IF AVAIL CODE_mstr THEN do:
        v_glta_acct1 = CODE_cmmt.
        v_fmpos = CODE_user1 .
    END.

    PUT UNFORMATTED 
        string(year(gltr_eff_dt),"9999") + "." + STRING(MONTH(gltr_eff_dt),"99") + "." + STRING(DAY(gltr_eff_dt),"99") ";" 
        gltr_ref ";"
        gltr_line ";"
        gltr_desc ";"
        gltr_ctr ";"
        cc_desc ";"
        v_fmpos ";"
        glta_acct1 ";"
        v_glta_acct1 ";".
    
    FOR EACH tt BY tt_date:
        IF DAY(gltr_eff_dt) = tt_date THEN 
            PUT UNFORMATTED gltr_amt .
        ELSE PUT UNFORMATTED ";" .
    END.
    PUT UNFORMATTED SKIP.
END.

IF inclpost = YES THEN DO:
    FOR EACH glt_det NO-LOCK 
        WHERE (glt_entity = entity OR entity = "")
        AND glt_cc >= ctr AND glt_cc <= ctr1
        AND glt_effdate >= effdate AND glt_effdate <= effdate1
        AND glt_tr_type = "JL" ,
        EACH glta_det NO-LOCK 
        WHERE glta_acct1 >= vacct1 AND glta_acct1 <= vacct2
        AND glta_ref = glt_ref AND glta_line = glt_line,
        EACH cc_mstr NO-LOCK 
        WHERE cc_ctr = glt_cc 
        BY glt_effdate BY glt_ref BY glt_line 
        BY glt_cc BY glta_acct :
    
        v_fmpos = "".
        v_glta_acct1 = "".
        FIND FIRST CODE_mstr WHERE CODE_fldname = 'glta_acct1'
            AND CODE_value = glta_acct1 NO-LOCK NO-ERROR.
        IF AVAIL CODE_mstr THEN do:
            v_glta_acct1 = CODE_cmmt.
            v_fmpos = CODE_user1 .
        END.
    
        PUT UNFORMATTED 
            string(year(glt_effdate),"9999") + "." + STRING(MONTH(glt_effdate),"99") + "." + STRING(DAY(glt_effdate),"99") ";" 
            glt_ref ";"
            glt_line ";"
            glt_desc ";"
            glt_cc ";"
            cc_desc ";"
            v_fmpos ";"
            glta_acct1 ";"
            v_glta_acct1 ";".
        
        FOR EACH tt BY tt_date:
            IF DAY(glt_effdate) = tt_date THEN 
                PUT UNFORMATTED glt_amt .
            ELSE PUT UNFORMATTED ";" .
        END.
        PUT UNFORMATTED SKIP.
    END.
END.
