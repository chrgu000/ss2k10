/*xxwobm001.p - create roll-up bom for production item*/

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

DEFINE VARIABLE v_woid1  LIKE wo_lot.
DEFINE VARIABLE v_woid2  LIKE wo_lot.
DEFINE VARIABLE v_part1  LIKE pt_part.
DEFINE VARIABLE v_part2  LIKE pt_part.
DEFINE VARIABLE v_site1  LIKE pt_site.
DEFINE VARIABLE v_site2  LIKE pt_site.
DEFINE VARIABLE v_date1  LIKE wo_due_date.
DEFINE VARIABLE v_date2  LIKE wo_due_date.
DEFINE VARIABLE v_line1  LIKE wo_line.
DEFINE VARIABLE v_line2  LIKE wo_line.
DEFINE VARIABLE v_rebud  AS LOGICAL initial YES.
DEFINE VARIABLE v_results AS CHAR.
DEFINE VARIABLE v_ok      AS LOGICAL.

DEFINE TEMP-TABLE ttt1
    FIELDS ttt1_woid LIKE wo_lot
    FIELDS ttt1_part LIKE wo_part
    FIELDS ttt1_desc LIKE pt_desc1
    FIELDS ttt1_rel_date LIKE wo_rel_date
    FIELDS ttt1_due_date LIKE wo_due_date
    FIELDS ttt1_cmmt AS CHAR FORMAT "x(30)" LABEL "状态"
    .

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    v_part1 COLON 20 
    v_part2 COLON 45 LABEL "至"
    SKIP
    v_site1 COLON 20
    v_site2 COLON 45 LABEL "至"
    SKIP
    v_woid1 COLON 20
    v_woid2 COLON 45 LABEL "至"
    SKIP
    v_date1 COLON 20
    v_date2 COLON 45 LABEL "至"
    SKIP
    v_line1 COLON 20
    v_line2 COLON 45 LABEL "至"
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
    IF v_site1 = hi_char THEN v_site2 = "".
    IF v_woid1 = hi_char THEN v_woid1 = "".
    IF v_line2 = hi_char THEN v_line2 = "".
    IF v_date1 = low_date THEN v_date1 = ?.
    IF v_date2 = hi_date THEN v_date2 = ?.


    UPDATE 
        v_part1 v_part2
        v_site1 v_site2
        v_woid1 v_woid2
        v_date1 v_date2 
        v_line1 v_line2 
        WITH FRAME a.
    
    IF v_date1 = ? THEN v_date1 = low_date.
    IF v_date2 = ? THEN v_date2 = hi_date.
    IF v_part2 = "" THEN v_part2 = hi_char.
    IF v_site2 = "" THEN v_site2 = hi_char.
    IF v_woid2 = "" THEN v_woid2 = hi_char.
    IF v_line2 = "" THEN v_line2 = hi_char.


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

    FOR EACH ttt1:
        DELETE ttt1.
    END.
    FOR EACH wo_mstr NO-LOCK
        WHERE wo_type = "C"
        /*AND   wo_status = "C"*/
        AND  (wo_part >= v_part1 AND wo_part <= v_part2)
        AND  (wo_site >= v_site1 AND wo_site <= v_site2)
        AND  (wo_lot >= v_woid1 AND wo_lot <= v_woid2)
        AND  ((wo_due_date >= v_date1 AND wo_due_date <= v_date2) OR wo_due_date = ?)
        AND  (wo_line >= v_line1 AND wo_line <= v_line2):
        
        IF wo_status <> "C" THEN DO:
            CREATE ttt1.
            ASSIGN 
                ttt1_woid = wo_lot
                ttt1_part = wo_part
                ttt1_rel_date = wo_rel_date
                ttt1_due_date = wo_due_date
                ttt1_cmmt = "工单未结".
        END.
        ELSE DO:
            FIND FIRST xxwobmvm_mstr WHERE xxwobmvm_woid = wo_lot NO-LOCK NO-ERROR.
            IF NOT AVAILABLE xxwobmvm_mstr THEN DO:
                CREATE ttt1.
                ASSIGN 
                    ttt1_woid = wo_lot
                    ttt1_part = wo_part
                    ttt1_rel_date = wo_rel_date
                    ttt1_due_date = wo_due_date
                    ttt1_cmmt = "未计算差异".
            END.
        END.
    END.
    
    FOR EACH ttt1 WITH FRAME b STREAM-IO DOWN WIDTH 132:
        /* SET EXTERNAL LABELS */
        setFrameLabels(frame b:handle).
        DISP ttt1.
    END.
    


    {mfreset.i}
    {mfgrptrm.i} /*Report-to-Window*/
END.
{wbrp04.i &frame-spec = a}


