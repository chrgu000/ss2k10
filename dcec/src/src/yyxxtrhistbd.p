/*xxwobm001.p - create roll-up bom for production item*/

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

DEFINE VARIABLE v_date1 LIKE tr_date.
DEFINE VARIABLE v_date2 LIKE tr_date.
DEFINE VARIABLE i       AS INTEGER.
DEFINE VARIABLE j       AS INTEGER.
DEFINE VARIABLE v_beg   AS CHAR FORMAT "x(20)".
DEFINE VARIABLE v_end   AS CHAR FORMAT "x(20)".



/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    "本功能用于同步辅助事务明细数据." AT 4 SKIP
    "注意:仅须对差异分析初始化前的累计加工单事务明细进行同步." AT 4 SKIP
    "     注意日期范围的选择." AT 4 SKIP
    v_date1 COLON 20 LABEL "操作日期"
    v_date2 COLON 45 LABEL "至"
    SKIP
    i LABEL "处理记录数" COLON 20 
    j LABEL "跳过记录数" COLON 45 
    v_beg  LABEL "开始" COLON 20
    v_end  LABEL "结束" COLON 45 
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
    i = 0.
    j = 0.
    v_beg = "".
    v_end = "".
    IF v_date1 = ? THEN v_date1 = TODAY - 1.
    IF v_date2 = ? THEN v_date2 = TODAY - 1.

    UPDATE 
        v_date1 v_date2 
        WITH FRAME a.
    
    IF v_date1 = ? THEN v_date1 = TODAY - 1.
    IF v_date2 = ? THEN v_date2 = TODAY - 1.
    v_beg = STRING(TODAY) + "-" + STRING(TIME,"HH:MM:SS").


    DISPLAY
        v_date1 v_date2 i j v_beg v_end
        WITH FRAME a.

    FOR EACH tr_hist 
        FIELDS (tr_trnbr tr_part tr_site tr_effdate tr_type tr_lot tr_nbr tr_date) 
        NO-LOCK
        WHERE (tr_date >= v_date1 AND tr_date <= v_date2)
        AND   (tr_hist.tr_type = "ISS-WO" or tr_hist.tr_type = "RCT-WO")
        and   (tr_hist.tr_lot <> "") 
        and   (tr_hist.tr_nbr = "")
        USE-INDEX tr_date_trn:

        if (tr_hist.tr_type = "ISS-WO" or tr_hist.tr_type = "RCT-WO") and (tr_hist.tr_lot <> "") and (tr_hist.tr_nbr = "") then do:
            find first xxtr_hist where xxtr_trnbr = tr_hist.tr_trnbr use-index xxtr_idx0 no-lock no-error.
            if not available xxtr_hist then do:
                i = i + 1.
                create xxtr_hist.
                assign xxtr_trnbr = tr_hist.tr_trnbr.
                assign xxtr_part = tr_hist.tr_part
                       xxtr_site = tr_hist.tr_site
                       xxtr_type = tr_hist.tr_type
                        xxtr_key1 = tr_hist.tr_lot.
                release xxtr_hist.  
                DISP i WITH FRAME a.
            end.
            ELSE DO: 
                j = j + 1.
                DISP j WITH FRAME a.
            END.
        end.            
    END.
    v_end = STRING(TODAY) + "-" + STRING(TIME,"HH:MM:SS").
    DISPLAY v_end WITH FRAME a.
END.
