/*xxwobm001.p - create roll-up bom for production item*/

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

DEFINE VARIABLE v_part  LIKE pt_part.
DEFINE VARIABLE v_site  LIKE pt_site.
DEFINE VARIABLE v_date  LIKE tr_effdate.
DEFINE VARIABLE v_version AS INTEGER.
DEFINE VARIABLE v_results AS CHAR.
DEFINE VARIABLE v_pm_code AS CHAR.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    v_part COLON 20
    SKIP
    v_site COLON 20
    SKIP
    v_date COLON 20
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
    UPDATE 
        v_part VALIDATE(CAN-FIND(FIRST pt_mstr WHERE pt_part = v_part), "请输入零件号")
        v_site VALIDATE(CAN-FIND(FIRST si_mstr WHERE si_site = v_site), "请输入地点")
        v_date 
        WITH FRAME a.
    
    IF v_date = ? THEN v_date = TODAY.
    DISPLAY v_date WITH FRAME a.


    FIND FIRST pt_mstr WHERE pt_part = v_part NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pt_mstr THEN UNDO, NEXT.
    FIND FIRST ptp_det WHERE ptp_part = pt_part AND ptp_site = v_site NO-LOCK NO-ERROR.
    IF AVAILABLE ptp_det THEN v_pm_code = ptp_bom_code.
    ELSE v_pm_code = pt_bom_code.
    {gprun.i ""yywobmfmcpa.p"" "(INPUT v_part, INPUT v_pm_code, INPUT v_site, INPUT v_date)"}
END.
/*{wbrp04.i &frame-spec = a}*/


