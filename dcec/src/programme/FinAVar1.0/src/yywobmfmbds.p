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

DEFINE VARIABLE v_chkcwo AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE v_keepver AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE v_dispdet AS LOGICAL INITIAL NO NO-UNDO.


DEFINE NEW SHARED TEMP-TABLE ttx9
    FIELDS ttx9_part LIKE pt_part 
    FIELDS ttx9_site LIKE pt_site
    FIELDS ttx9_bomcode LIKE pt_part
    FIELDS ttx9_chk_bom  AS LOGICAL INITIAL NO
    FIELDS ttx9_chk_cwo  AS LOGICAL INITIAL NO
    FIELDS ttx9_version  AS INTEGER
    FIELDS ttx9_cmmt     AS CHAR FORMAT "X(30)" LABEL "COMMENT"
    INDEX  ttx9_idx1 IS PRIMARY UNIQUE ttx9_part ttx9_site.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    v_site COLON 30
    SKIP
    v_part1 COLON 30
    SKIP
    v_date COLON 30
    SKIP
    v_chkcwo COLON 30 LABEL "检查是否存在累计加工单"
    SKIP
    v_keepver COLON 30 LABEL "BOM无变化时不更新版本"
    SKIP
    v_dispdet COLON 30 LABEL "显示复制明细"
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
        v_part1 
        v_date WHEN CAN-FIND(FIRST CODE_mstr WHERE CODE_fldname = "yywobmfmbd" AND CODE_value = "DATE")
        v_chkcwo
        v_keepver
        v_dispdet
        WITH FRAME a.
    
    assign
        v_part2 = v_part1
        v_line1 = "" 
        v_line2 = hi_char
        v_type1 = "" 
        v_type2 = hi_char
        v_group1 = "" 
        v_group2 = hi_char.
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

    PUT UNFORMATTED "复制开始:" AT 1 TODAY "-" STRING(TIME,"HH:MM:SS") SKIP.
    RUN xxpro-initial.
    RUN xxpro-bud-ttx9.
    RUN xxpro-process.
    RUN xxpro-report.
    PUT UNFORMATTED "复制结束:" AT 1 TODAY "-" STRING(TIME,"HH:MM:SS") SKIP.

    {mfreset.i}
    {mfgrptrm.i} /*Report-to-Window*/
END.
{wbrp04.i &frame-spec = a}

/*************************/
PROCEDURE xxpro-initial:
    FOR EACH ttx9:
        DELETE ttx9.
    END.
END PROCEDURE.
/*************************/
PROCEDURE xxpro-bud-ttx9:
    DEFINE VARIABLE v_pm_code AS CHAR.
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
        /*RUN D:\projects\dcec-cost\3-src\xxwobmfmbdc.p (INPUT pt_part,INPUT v_site, INPUT v_date).*/
        {gprun.i ""yywobmfmbdc.p"" "(INPUT pt_part,INPUT v_site, INPUT v_date)"}
    END.
    FOR EACH ttx9:
        /*check bom changed or cost changed*/
        IF v_keepver = YES THEN DO:
            {gprun.i ""yywobmfmbdd.p"" "(INPUT ttx9_part, INPUT ttx9_bomcode, INPUT ttx9_site, INPUT v_date, OUTPUT v_results)"}
            IF v_results = "" THEN ttx9_chk_bom = YES.
        END.
        /*check cwo existed*/
        IF v_chkcwo = YES AND ttx9_chk_bom = NO THEN DO:
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
    IF v_dispdet = YES THEN DO:
        PUT UNFORMATTED "复制零件明细" AT 1 FILL("*", 40) SKIP.
        FOR EACH ttx9 WHERE ttx9_chk_cwo = NO AND ttx9_chk_bom = NO:
            FOR EACH xxwobmfm_mstr WHERE xxwobmfm_part = ttx9_part AND xxwobmfm_site = ttx9_site AND xxwobmfm_version = ttx9_version:
                DISP 
                    xxwobmfm_part      label "零件"   
                    xxwobmfm_site      label "地点"   
                    xxwobmfm_version   label "版本"   
                    xxwobmfm_date_eff  label "日期"   
                    xxwobmfm_cost_tot  label "总成本"    
                    xxwobmfm_mtl_tl    LABEL "本层物料"   
                    xxwobmfm_lbr_tl    LABEL "本层人工"  
                    xxwobmfm_bdn_tl    LABEL "本层附加"  
                    xxwobmfm_ovh_tl    LABEL "本层间接"  
                    xxwobmfm_sub_tl    LABEL "本层外包"  
                    xxwobmfm_mtl_ll    LABEL "底层物料"  
                    xxwobmfm_lbr_ll    LABEL "底层人工"  
                    xxwobmfm_bdn_ll    LABEL "底层附加"  
                    xxwobmfm_ovh_ll    LABEL "底层物料"  
                    xxwobmfm_sub_ll    LABEL "底层外包"  
                    with FRAME b WIDTH 200 SIDE-LABELS 5 COLUMN STREAM-IO.
                FOR EACH xxwobmfd_det 
                    WHERE xxwobmfd_par = xxwobmfm_part
                    AND xxwobmfd_site = xxwobmfm_site
                    AND xxwobmfd_version = xxwobmfm_version:
                    DISP 
                        xxwobmfd_comp       column-label "零件"
                        xxwobmfd_op         column-label "工序"
                        xxwobmfd_qty        column-label "用量"
                        xxwobmfd_cost_tot   column-label "总成本"
                        xxwobmfd_mtl_tl     COLUMN-LABEL "本层物料"
                        xxwobmfd_lbr_tl     COLUMN-LABEL "本层人工"
                        xxwobmfd_bdn_tl     COLUMN-LABEL "本层附加"
                        xxwobmfd_ovh_tl     COLUMN-LABEL "本层间接"
                        xxwobmfd_sub_tl     COLUMN-LABEL "本层外包"
                        xxwobmfd_mtl_ll     COLUMN-LABEL "底层物料"
                        xxwobmfd_lbr_ll     COLUMN-LABEL "底层人工"
                        xxwobmfd_bdn_ll     COLUMN-LABEL "底层附加"
                        xxwobmfd_ovh_ll     COLUMN-LABEL "底层物料"
                        xxwobmfd_sub_ll     COLUMN-LABEL "底层外包"
                        WITH FRAME c WIDTH 250 DOWN STREAM-IO.
                END.
            END.
        END.
    END.
END PROCEDURE.


