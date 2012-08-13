/*xxwobm001.p - create roll-up bom for production item*/

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

DEFINE VARIABLE v_part1  LIKE pt_part.
DEFINE VARIABLE v_part2  LIKE pt_part.
DEFINE VARIABLE v_line1  LIKE pt_prod_line.
DEFINE VARIABLE v_line2  LIKE pt_prod_line.
DEFINE VARIABLE v_group1 LIKE pt_group.
DEFINE VARIABLE v_group2 LIKE pt_group.
DEFINE VARIABLE v_type1  LIKE pt_part_type.
DEFINE VARIABLE v_type2  LIKE pt_part_type.

DEFINE VARIABLE v_site  LIKE pt_site.
DEFINE VARIABLE v_date  LIKE tr_effdate.
DEFINE VARIABLE v_version AS INTEGER.
DEFINE VARIABLE v_results AS CHAR.

DEFINE VARIABLE v_chksub AS LOGICAL INITIAL NO NO-UNDO.

DEFINE NEW SHARED TEMP-TABLE ttx9
    FIELDS ttx9_part LIKE pt_part 
    FIELDS ttx9_site LIKE pt_site
    FIELDS ttx9_bomcode LIKE pt_part
    FIELDS ttx9_chk_bom  AS LOGICAL INITIAL NO
    FIELDS ttx9_chk_cwo  AS LOGICAL INITIAL NO
    FIELDS ttx9_version  AS INTEGER
    FIELDS ttx9_cmmt     AS CHAR FORMAT "X(30)" LABEL "COMMENT"
    INDEX  ttx9_idx1 IS PRIMARY UNIQUE ttx9_part ttx9_site.

DEFINE TEMP-TABLE ttt1 RCODE-INFORMATION
    FIELDS ttt1_part LIKE wo_part
    FIELDS ttt1_desc LIKE pt_desc1
    FIELDS ttt1_woid LIKE wo_lot
    FIELDS ttt1_date1 LIKE wo_rel_date
    FIELDS ttt1_date2 LIKE wo_due_date
    INDEX ttt1_idx1 ttt1_woid
    INDEX ttt1_idx2 ttt1_part.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    v_site COLON 20
    SKIP
    v_part1 COLON 20
    v_part2 COLON 45 LABEL "至"
    SKIP
    v_line1 COLON 20
    v_line2 COLON 45 LABEL "至"
    SKIP
    v_type1 COLON 20
    v_type2 COLON 45 LABEL "至"
    SKIP
    v_group1 COLON 20
    v_group2 COLON 45 LABEL "至"
    SKIP
    v_date COLON 20
    SKIP
    v_chksub COLON 20 LABEL "检查子件"
    SKIP
    SKIP(.4)  /*GUI*/
    WITH FRAME a SIDE-LABELS WIDTH 80 NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
            &THEN " Selection Criteria "
            &ELSE {&SELECTION_CRITERIA}
            &ENDIF .
RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
                 FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
                 RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", 
                 RECT-FRAME-LABEL:FONT).
RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
REPEAT:
    IF v_part2 = hi_char THEN v_part2 = "".
    IF v_line2 = hi_char THEN v_line2 = "".
    IF v_type2 = hi_char THEN v_type2 = "".
    IF v_group2 = hi_char THEN v_group2 = "".

    UPDATE 
        v_site VALIDATE(CAN-FIND(FIRST si_mstr WHERE si_site = v_site), "Please input site data...")
        v_part1 v_part2
        v_line1 v_line2
        v_type1 v_type2
        v_group1 v_group2
        v_date 
        v_chksub
        WITH FRAME a.
    
    IF v_part2 = "" THEN v_part2 = hi_char.
    IF v_line2 = "" THEN v_line2 = hi_char.
    IF v_type2 = "" THEN v_type2 = hi_char.
    IF v_group2 = "" THEN v_group2 = hi_char.
    IF v_date = ? THEN v_date = TODAY.
    DISPLAY v_date WITH FRAME a.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

    /*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

    RUN xxpro-initial.
    RUN xxpro-bud-ttx9.
    RUN xxpro-report.

    {mfreset.i}
    {mfgrptrm.i} /*Report-to-Window*/

END.
{wbrp04.i &frame-spec = a}




/*************************/
PROCEDURE xxpro-initial:
    FOR EACH ttx9:
        DELETE ttx9.
    END.
    FOR EACH ttt1:
        DELETE ttt1.
    END.
END PROCEDURE.
/*************************/
PROCEDURE xxpro-bud-ttx9:
    DEFINE VARIABLE v_pm_code AS CHAR.
    DEF    VAR      i AS INTEGER.
    DEF    VAR      v_id AS CHAR.
    FOR EACH pt_mstr NO-LOCK 
        WHERE pt_part >= v_part1 AND pt_part <= v_part2
        AND   pt_prod_line >= v_line1 AND pt_prod_line <= v_line2
        AND   pt_part_type >= v_type1 AND pt_prod_line <= v_type2
        AND   pt_group >= v_group1 AND pt_group <= v_group2:

        v_pm_code = "".
        /*check in_mstr*/
        FIND FIRST IN_mstr WHERE IN_part = pt_part AND IN_site = v_site NO-LOCK NO-ERROR.
        IF NOT AVAILABLE IN_mstr THEN NEXT.
        FIND FIRST ptp_det WHERE ptp_part = pt_part AND ptp_site = v_site NO-LOCK NO-ERROR.
        IF AVAILABLE ptp_det THEN v_pm_code = ptp_pm_code.
        ELSE v_pm_code = pt_pm_code.
        IF lookup(v_pm_code, "P,D") > 0 THEN NEXT.
        /*exp bom*/
        IF v_chksub = YES THEN DO:
            {gprun.i ""yywobmfmbdc.p"" "(INPUT pt_part,INPUT v_site, INPUT v_date)"}
        END.
        ELSE DO:
            FIND FIRST ttx9 WHERE ttx9_part = pt_part AND ttx9_site = v_site NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ttx9 THEN DO:
                CREATE ttx9.
                ASSIGN 
                    ttx9_part = pt_part
                    ttx9_site = v_site.
            END.
        END.
    END.
    FOR EACH ttx9:
        /*check copy bom existed*/
        RUN xxpro-chk-bom (INPUT ttx9_part, INPUT ttx9_site, INPUT v_date, OUTPUT ttx9_chk_bom).
        IF ttx9_chk_bom THEN ASSIGN ttx9_cmmt = ttx9_cmmt + (IF ttx9_cmmt = "" THEN "" ELSE ",") + "复制的卷集BOM未找到".
        /*check cwo existed*/
        /*RUN D:\projects\dcec-cost\3-src\xxwobmfmbdb.p (INPUT ttx9_part, INPUT ttx9_bomcode, INPUT ttx9_site, INPUT v_date, OUTPUT v_results).*/
        {gprun.i ""yywobmfmbdb.p"" "(INPUT ttx9_part, INPUT ttx9_bomcode, INPUT ttx9_site, INPUT v_date, OUTPUT v_results)"}
        IF v_results <> "" THEN DO:
            ttx9_chk_cwo = YES.
            ASSIGN ttx9_cmmt = ttx9_cmmt + (IF ttx9_cmmt = "" THEN "" ELSE ",") + "存在未结的累计工单".
            DO i = 1 TO NUM-ENTRIES(v_results):
                v_id = ENTRY(i, v_results).
                FIND FIRST ttt1 WHERE ttt1_woid = v_id NO-ERROR.
                IF NOT AVAILABLE ttt1 THEN DO:
                    CREATE ttt1.
                    ASSIGN ttt1_woid = v_id.
                    FIND FIRST wo_mstr WHERE wo_lot = ttt1_woid NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE wo_mstr THEN NEXT.
                    ASSIGN 
                        ttt1_part = wo_part
                        ttt1_date1 = wo_rel_date
                        ttt1_date2 = wo_due_date.
                /*FIND FIRST pt_mstr WHERE pt_part = ttt1_part NO-LOCK NO-ERROR.
                IF AVAILABLE pt_mstr THEN ASSIGN ttt1_desc = pt_desc1 + pt_desc2.*/
                END.
            END.
        END.
    END.
END.

/*************************/
PROCEDURE xxpro-report:
    DEFINE VARIABLE v_allok AS CHAR.
    DEFINE VARIABLE v_desc  AS CHAR.

    v_allok = "通过检查,未发现要处理的事务.".

    PUT UNFORMATTED "检查结果:" AT 1 SKIP.
    FOR EACH ttx9 WHERE (ttx9_chk_bom = YES OR ttx9_chk_cwo = YES):
        FIND FIRST pt_mstr WHERE pt_part = ttx9_part NO-LOCK NO-ERROR.
        IF AVAILABLE pt_mstr THEN v_desc = pt_desc1 + pt_desc2. ELSE v_desc = "".
        v_allok = "".
        DISP ttx9_part   COLUMN-LABEL "零件号"
             v_desc      COLUMN-LABEL "描述"  FORMAT "x(40)"
             ttx9_site   COLUMN-LABEL "地点"
             ttx9_cmmt   COLUMN-LABEL "结果"  FORMAT "x(40)"
            WITH WIDTH 200 STREAM-IO DOWN.
        FOR EACH ttt1 WHERE ttt1_part = ttx9_part:
            DISP space(18) 
                ttt1_woid   COLUMN-LABEL "累计加工单标号"
                ttt1_date1  COLUMN-LABEL "起始日期"
                ttt1_date2  COLUMN-LABEL "结束日期"
                WITH WIDTH 132 STREAM-IO DOWN.
        END.
    END.
    PUT UNFORMATTED v_allok AT 1 SKIP.

END PROCEDURE.


/*************************/
PROCEDURE xxpro-chk-bom:
    DEFINE INPUT PARAMETER p_part AS CHAR.
    DEFINE INPUT PARAMETER p_site AS CHAR.
    DEFINE INPUT PARAMETER p_date AS DATE.
    DEFINE OUTPUT PARAMETER p_ok  AS LOGICAL.
    p_ok = NO.
    FIND LAST xxwobmfm_mstr 
        WHERE xxwobmfm_part = p_part 
        AND xxwobmfm_site = p_site 
        AND xxwobmfm_date_eff <= p_date 
        USE-INDEX xxwobmfm_idx2
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE xxwobmfm_mstr THEN p_ok = YES.
END PROCEDURE.
