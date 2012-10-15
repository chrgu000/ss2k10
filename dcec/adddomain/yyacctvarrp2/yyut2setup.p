/*output temptable to excel*/

DEFINE INPUT PARAMETER TABLE-HANDLE hTempTable.
DEFINE INPUT PARAMETER  inp_key   AS CHAR.
DEFINE INPUT PARAMETER  inp_cfg   AS LOGICAL.
DEFINE OUTPUT PARAMETER inp_list  AS CHAR.
DEFINE VARIABLE bh AS HANDLE NO-UNDO.
DEFINE VARIABLE bf AS HANDLE NO-UNDO.
DEFINE VARIABLE hq AS HANDLE NO-UNDO.
DEFINE VARIABLE iCounter AS INTEGER NO-UNDO.

{mfdeclre.i} /*GUI moved to top.*/
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

DEFINE VARIABLE hwindow1 AS HANDLE.
DEFINE VARIABLE hwindow2 AS HANDLE.

hwindow2 = CURRENT-WINDOW.
CREATE WINDOW hwindow1  
    ASSIGN 
         HIDDEN             = NO
         TITLE              = IF global_user_lang = "CH" THEN "≈‰÷√" ELSE "Config"
         HEIGHT             = 20
         WIDTH              = 45
         MAX-HEIGHT         = 33.82
         MAX-WIDTH          = 116.36
         VIRTUAL-HEIGHT     = 33.82
         VIRTUAL-WIDTH      = 116.36
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
CURRENT-WINDOW = hwindow1.


inp_list = "".

IF hTempTable = ? THEN RETURN.

bh = hTempTable:DEFAULT-BUFFER-HANDLE.

DEF TEMP-TABLE tt2
    FIELDS tt2_seq      AS INTEGER  LABEL "Sequence"
    FIELDS tt2_label    AS CHARACTER LABEL "Field Name" FORMAT "x(30)"
    FIELDS tt2_name     AS CHAR      
    FIELDS tt2_selected AS LOGICAL   LABEL "Display"    
    INDEX tt2_idx1 tt2_seq.

FOR EACH tt2:
    DELETE tt2.
END.


DO iCounter = 1 TO bh:NUM-FIELDS:
    bf = bh:BUFFER-FIELD(iCounter).
    CREATE tt2.
    ASSIGN 
        tt2_seq = icounter
        tt2_label = string(bf:LABEL)
        tt2_name  = STRING(bf:NAME)
        tt2_select = YES.
END.
FIND FIRST usrw_wkfl WHERE usrw_key1 = "xxut2"  AND usrw_key2 = inp_key NO-LOCK NO-ERROR.
IF AVAILABLE usrw_wkfl AND usrw_charfld[1] <> "" THEN DO:
    FOR EACH tt2:
        IF LOOKUP(STRING(tt2_seq), usrw_charfld[1]) = 0 THEN tt2_select = NO.
    END.
END.

    DEFINE VARIABLE wh AS WIDGET-HANDLE.
    DEFINE VARIABLE toggle1 AS LOGICAL LABEL "Display " VIEW-AS TOGGLE-BOX.
    DEFINE QUERY q1 FOR tt2 SCROLLING.
    DEFINE BUTTON b-save LABEL "Save".

    DEFINE BROWSE b1 QUERY q1 
         DISPLAY /*tt2_seq */
                 tt2_label
                 tt2_selected
         ENABLE tt2_selected
         WITH 
        14 DOWN 
        WIDTH 40 
        SEPARATORS 
        /*NO-ROW-MARKERS */
        ROW-HEIGHT-PIXELS 16
        FONT 21.

    DEFINE FRAME f-a
        b-save
        SKIP
        b1             
        toggle1 AT ROW 2 COLUMN 2  
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 42 BY 20.

IF inp_cfg = YES THEN RUN xxpro-cfg.

RUN xxpro-get (OUTPUT inp_list).

APPLY "WINDOW-CLOSE" TO hwindow1.
CURRENT-WINDOW = hwindow2.
DELETE OBJECT hwindow1.



PROCEDURE xxpro-cfg:
    ON SCROLL-NOTIFY OF b1 IN FRAME f-a
    DO:                               
        RUN TOGGLE-PLACEMENT.
    END.

    ON ENTRY OF tt2_selected IN BROWSE b1
    DO:
        RUN toggle-placement.
    END.

    ON LEAVE OF tt2_selected IN BROWSE b1
    DO:                               
        toggle1:VISIBLE IN FRAME f-a = FALSE.
    END.

    ON VALUE-CHANGED OF toggle1 IN FRAME f-a
    DO:
        toggle1:VISIBLE IN FRAME f-a = FALSE.
        IF toggle1:CHECKED THEN tt2_SELECTED:SCREEN-VALUE IN BROWSE b1 = "YES".
        ELSE tt2_SELECTED:SCREEN-VALUE IN BROWSE b1 = "NO". 
        APPLY "ENTRY" TO tt2_selected IN BROWSE b1.
    END.

    ON CHOOSE OF b-save
    DO:
        RUN xxpro-update.
    END.

    OPEN QUERY q1 FOR EACH tt2.

    ASSIGN toggle1:HIDDEN IN FRAME f-a = TRUE
           toggle1:SENSITIVE IN FRAME f-a = TRUE.

    ENABLE b-save b1 WITH FRAME f-a.

    WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.
END PROCEDURE.

PROCEDURE toggle-placement:
  ASSIGN WH = tt2_selected:HANDLE IN BROWSE b1.
  IF wh:X < 0 THEN toggle1:VISIBLE IN FRAME f-a = FALSE.
    ELSE toggle1:X IN FRAME f-a = wh:X + b1:X. 
  IF wh:Y < 0 THEN toggle1:VISIBLE IN FRAME f-a = FALSE.
    ELSE toggle1:Y IN FRAME f-a = wh:Y + b1:Y.
  IF tt2_selected:SCREEN-VALUE = "" THEN toggle1:CHECKED = FALSE.
    ELSE toggle1:SCREEN-VALUE = tt2_selected:SCREEN-VALUE.
  IF wh:X >= 0 and wh:Y >= 0 THEN toggle1:VISIBLE IN FRAME f-a = TRUE.
END PROCEDURE.

PROCEDURE xxpro-update:
    DEF VAR p-list1 AS CHAR.
    p-list1 = "".
    FOR EACH tt2 WHERE tt2_select = YES:
        p-list1 = p-list1 + "," + STRING(tt2_seq).
    END.
    IF p-list1 <> "" THEN p-list1 = SUBSTRING(p-list1,2).
    FIND FIRST usrw_wkfl WHERE usrw_key1 = "xxut2" AND usrw_key2 = inp_key NO-ERROR.
    IF NOT AVAILABLE usrw_wkfl THEN DO:
        CREATE usrw_wkfl.
        ASSIGN usrw_key1 = "xxut2" 
               usrw_key2 = inp_key.
    END.
    ASSIGN usrw_charfld[1] = p-list1.
    RELEASE usrw_wkfl.
END PROCEDURE.

PROCEDURE xxpro-get:
    DEF OUTPUT PARAMETER p-list1 AS CHAR.
    p-list1 = "".
    FOR EACH tt2 WHERE tt2_select = YES:
        p-list1 = p-list1 + "," + STRING(tt2_seq).
    END.
    IF p-list1 <> "" THEN p-list1 = SUBSTRING(p-list1,2).
END PROCEDURE.
