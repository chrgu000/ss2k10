{mfdeclre.i}


DEFINE INPUT  PARAMETER inp-part    AS CHAR.
DEFINE INPUT  PARAMETER inp-site    AS CHAR.
DEFINE INPUT  PARAMETER inp-costset AS CHAR.
DEFINE INPUT  PARAMETER inp-date    AS DATE.



DEFINE VARIABLE v_part  LIKE pt_part.
DEFINE VARIABLE v_site  LIKE pt_site.
DEFINE VARIABLE v_date  LIKE tr_effdate.
DEFINE VARIABLE v_version AS INTEGER.
DEFINE VARIABLE v_results AS CHAR.
DEFINE VARIABLE v_costset AS CHARACTER.

DEFINE NEW SHARED TEMP-TABLE ttx9
    FIELDS ttx9_part LIKE pt_part
    FIELDS ttx9_site LIKE pt_site
    FIELDS ttx9_bomcode LIKE pt_part
    FIELDS ttx9_chk_bom  AS LOGICAL INITIAL NO
    FIELDS ttx9_chk_cwo  AS LOGICAL INITIAL NO
    FIELDS ttx9_version  AS INTEGER
    FIELDS ttx9_cmmt     AS CHAR FORMAT "X(30)" LABEL "COMMENT"
    INDEX  ttx9_idx1 IS PRIMARY UNIQUE ttx9_part ttx9_site.


ASSIGN 
    v_part = inp-part
    v_site = inp-site
    v_date = inp-date.
    IF v_date = ? THEN v_date = TODAY.
    

    FIND FIRST IN_mstr WHERE in_domain = global_domain and IN_part = v_part AND IN_site = v_site NO-LOCK NO-ERROR.
    IF NOT AVAILABLE IN_mstr THEN LEAVE.
    IF AVAILABLE IN_mstr THEN DO:
        v_costset = IN_gl_set.
        IF v_costset = "" THEN v_costset = "standard".
        IF v_costset = inp-costset THEN DO:
            PUT UNFORMATTED "复制开始:" AT 1 TODAY "-" STRING(TIME,"HH:MM:SS") SKIP.
            RUN xxpro-initial.
            RUN xxpro-bud-ttx9.
            RUN xxpro-process.
            RUN xxpro-report.
            PUT UNFORMATTED "复制结束:" AT 1 TODAY "-" STRING(TIME,"HH:MM:SS") SKIP.
        END.
        ELSE DO:
            MESSAGE "成本集不是该地点的总帐成本集,卷集BOM不做复制." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.        
        END.
    END.

/*************************/
PROCEDURE xxpro-initial:
    FOR EACH ttx9:
        DELETE ttx9.
    END.
END PROCEDURE.
/*************************/
PROCEDURE xxpro-bud-ttx9:
    DEFINE VARIABLE v_pm_code AS CHAR.
    FOR EACH pt_mstr NO-LOCK WHERE pt_domain = global_domain and pt_part = v_part:

        v_pm_code = "".
        /*check in_mstr*/
        FIND FIRST IN_mstr WHERE in_domain = global_domain and IN_part = pt_part AND IN_site = v_site NO-LOCK NO-ERROR.
        IF NOT AVAILABLE IN_mstr THEN NEXT.
        FIND FIRST ptp_det WHERE ptp_domain = global_domain and ptp_part = pt_part AND ptp_site = v_site NO-LOCK NO-ERROR.
        IF AVAILABLE ptp_det THEN v_pm_code = ptp_pm_code.
        ELSE v_pm_code = pt_pm_code.
        IF lookup(v_pm_code, "P,D") > 0 THEN NEXT.
        /*RUN D:\projects\dcec-cost\3-src\xxwobmfmbdc.p (INPUT pt_part,INPUT v_site, INPUT v_date).*/
        {gprun.i ""yywobmfmbdc.p"" "(INPUT pt_part,INPUT v_site, INPUT v_date)"}
    END.
    FOR EACH ttx9:
        /*check bom changed or cost changed*/
        {gprun.i ""yywobmfmbdd.p"" "(INPUT ttx9_part, INPUT ttx9_bomcode, INPUT ttx9_site, INPUT v_date, OUTPUT v_results)"}
        IF v_results = "" THEN ttx9_chk_bom = YES.
        /*check cwo existed*/
        IF ttx9_chk_bom = NO THEN DO:
            {gprun.i ""yywobmfmbdb.p"" "(INPUT ttx9_part, INPUT ttx9_bomcode, INPUT ttx9_site, INPUT v_date, OUTPUT v_results)"}
            IF v_results <> "" THEN ttx9_chk_cwo = YES.
        END.
    END.

END PROCEDURE.
/*************************/
PROCEDURE xxpro-process:
    FOR EACH ttx9 WHERE ttx9_chk_cwo = NO AND ttx9_chk_bom = NO:
        /*build*/
        {gprun.i ""yywobmfmbda.p"" "(INPUT ttx9_part, INPUT ttx9_bomcode, INPUT ttx9_site, INPUT v_date, OUTPUT ttx9_version)"}
    END.
END PROCEDURE.

/*************************/
PROCEDURE xxpro-report:
    PUT UNFORMATTED "未复制零件清单" AT 1 FILL("*", 40) SKIP.
    FOR EACH ttx9 WHERE ttx9_chk_cwo = YES OR ttx9_chk_bom = YES:
        IF ttx9_chk_cwo = YES THEN ttx9_cmmt = ttx9_cmmt + "存在未结的累计加工单! 不能复制! ".
        IF ttx9_chk_bom = YES THEN ttx9_cmmt = ttx9_cmmt + "BOM未作任何修改! 无需复制! ".
        DISPLAY ttx9_part ttx9_site ttx9_cmmt WITH FRAME d STREAM-IO DOWN.
    END.
    PUT UNFORMATTED "复制零件清单" AT 1 FILL("*", 40) SKIP.
    FOR EACH ttx9 WHERE ttx9_chk_cwo = NO AND ttx9_chk_bom = NO:
        DISPLAY ttx9_part ttx9_site ttx9_version WITH FRAME e STREAM-IO DOWN.
    END.
    PUT UNFORMATTED "复制零件明细" AT 1 FILL("*", 40) SKIP.
    FOR EACH ttx9 WHERE ttx9_chk_cwo = NO AND ttx9_chk_bom = NO:
            FOR EACH xxwobmfm_mstr WHERE xxwobmfm_domain = global_domain and
            				 xxwobmfm_part = ttx9_part AND xxwobmfm_site = ttx9_site AND 
            				 xxwobmfm_version = ttx9_version:
                DISP 
                    xxwobmfm_part
                    xxwobmfm_site
                    xxwobmfm_version
                    xxwobmfm_date_eff
                    xxwobmfm_cost_tot
                    with FRAME b WIDTH 132 SIDE-LABELS 2 COLUMN STREAM-IO.
                FOR EACH xxwobmfd_det 
                    WHERE xxwobmfd_domain = global_domain 
                    AND xxwobmfd_par = xxwobmfm_part
                    AND xxwobmfd_site = xxwobmfm_site
                    AND xxwobmfd_version = xxwobmfm_version:
                    DISP 
                        xxwobmfd_comp
                        xxwobmfd_op
                        xxwobmfd_qty
                        xxwobmfd_cost_tot
                        WITH FRAME c WIDTH 132 DOWN STREAM-IO.
                END.
            END.
    END.
END PROCEDURE.


