/*xxwobm001.p - create roll-up bom for production item*/

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "120817.1"}

DEFINE VARIABLE v_part1  LIKE pt_part.
DEFINE VARIABLE v_part2  LIKE pt_part.
DEFINE VARIABLE v_site1 LIKE pt_site.
DEFINE VARIABLE v_site2 LIKE pt_site.
DEFINE VARIABLE v_date1  LIKE tr_effdate.
DEFINE VARIABLE v_date2  LIKE tr_effdate.
DEFINE VARIABLE v_woid1 LIKE xxwobmvm_woid.
DEFINE VARIABLE v_woid2 LIKE xxwobmvm_woid.
DEFINE VARIABLE v_line1  LIKE wo_line.
DEFINE VARIABLE v_line2  LIKE wo_line.
DEFINE VARIABLE v_delflag AS LOGICAL.
DEFINE VARIABLE v_bakflag AS LOGICAL.
DEFINE VARIABLE v_bakfile AS CHAR FORMAT "x(20)".

DEFINE STREAM s1.

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
    v_date1 COLON 20
    v_date2 COLON 45 LABEL "至"
    SKIP
    v_line1 COLON 20
    v_line2 COLON 45 LABEL "至"
    SKIP
    v_woid1 COLON 20
    v_woid2 COLON 45 LABEL "至"
    SKIP
    v_delflag  COLON 30 LABEL "删除"
    SKIP
    v_bakflag  COLON 30 LABEL "归档"
    SKIP
    v_bakfile  COLON 30 LABEL "归档文件名"
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
    IF v_line2 = hi_char THEN v_line2 = "".
    IF v_part2 = hi_char THEN v_part2 = "".
    IF v_site2 = hi_char THEN v_site2 = "".
    IF v_date1 = low_date THEN v_date1 = ?.
    IF v_date2 = hi_date THEN v_date2 = ?.
    IF v_woid2 = hi_char THEN v_woid2 = "".

    UPDATE 
        v_part1 v_part2
        v_site1 v_site2
        v_date1 v_date2
        v_line1 v_line2
        v_woid1 v_woid2
        v_delflag
        v_bakflag
        WITH FRAME a.
    IF v_bakflag = YES THEN DO:
        IF v_bakfile = "" THEN ASSIGN
            v_bakfile = "XXWOBMVR" + STRING(YEAR(TODAY),"9999")
            + STRING(MONTH(TODAY),"99")
            + STRING(DAY(TODAY),"99")
            + ".hst".
        UPDATE v_bakfile VALIDATE(v_bakfile <> "", "Please input archive file name...")
            WITH FRAME a.
    END.

    IF v_part2 = "" THEN v_part2 = hi_char.
    IF v_site2 = "" THEN v_site2 = hi_char.
    IF v_date1 = ? THEN v_date1 = low_date.
    IF v_date2 = ? THEN v_date2 = hi_date.
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

    {mfguichk.i } /*Replace mfrpchk*/

    IF v_bakflag = YES THEN DO:
        OUTPUT STREAM s1 TO VALUE(v_bakfile).
    END.

    FOR EACH xxwobmvm_mstr where xxwobmvm_domain = global_domain 
        AND   (xxwobmvm_part >= v_part1 AND xxwobmvm_part <= v_part2)
        AND   (xxwobmvm_site >= v_site1 AND xxwobmvm_site <= v_site2)
        AND   (xxwobmvm_woid >= v_woid1 AND xxwobmvm_woid <= v_woid2)
        AND   (xxwobmvm_date >= v_date1 AND xxwobmvm_date <= v_date2)
        AND   (xxwobmvm_line >= v_line1 AND xxwobmvm_line <= v_line2)
        :
        DISPLAY 
            xxwobmvm_part
            xxwobmvm_site
            xxwobmvm_woid
            xxwobmvm_line
            xxwobmvm_date
            WITH STREAM-IO DOWN WIDTH 132.

        FOR EACH xxwobmvd_det WHERE xxwobmvd_domain = global_domain 
        		 and xxwobmvd_woid = xxwobmvm_woid:
            IF v_bakflag = YES THEN DO:
                EXPORT STREAM s1 "xxwobmvd_det".
                EXPORT STREAM s1 xxwobmvd_det.
            END.
            IF v_delflag = YES THEN do:
                DELETE xxwobmvd_det.
            END.
        END.

        FOR EACH xxwobmvr_det WHERE xxwobmvr_domain = global_domain and 
        			   xxwobmvr_woid = xxwobmvm_woid:
            IF v_bakflag = YES THEN DO:
                EXPORT STREAM s1 "xxwobmvr_det".
                EXPORT STREAM s1 xxwobmvr_det.
            END.
            IF v_delflag = YES THEN do:
                DELETE xxwobmvr_det.
            END.
        END.
        IF v_bakflag = YES THEN DO:
            EXPORT STREAM s1 "xxwobmvm_mstr".
            EXPORT STREAM s1 xxwobmvm_mstr.
        END.
        IF v_delflag = YES THEN do:
            DELETE xxwobmvm_mstr.
        END.
    END.
    IF v_bakflag = YES THEN DO:
        OUTPUT STREAM s1 CLOSE.
    END.
    {mfreset.i}
    {mfgrptrm.i} /*Report-to-Window*/
END.
{wbrp04.i &frame-spec = a}


