/*output temptable to excel*/

DEFINE INPUT PARAMETER inp_prgvalue       AS CHAR.
DEFINE INPUT PARAMETER inp_prgname        AS CHAR.
DEFINE INPUT PARAMETER inp_prglabel       AS CHAR.

{mfdeclre.i} /*GUI moved to top.*/
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


DEFINE VARIABLE i AS INTEGER.

IF inp_prgname = "" THEN RETURN.

DEF TEMP-TABLE tt2
    FIELDS tt2_label    AS CHARACTER LABEL "Function" FORMAT "x(38)"
    FIELDS tt2_prg      AS CHAR      
    .

FOR EACH tt2:
    DELETE tt2.
END.

DO i = 1 TO NUM-ENTRIES(inp_prgname):
    CREATE tt2.
    ASSIGN tt2_prg   = ENTRY(i, inp_prgname)
           tt2_label = ENTRY(i, inp_prglabel).
END.

IF NUM-ENTRIES(inp_prgname) < 1 THEN RETURN.
ELSE IF NUM-ENTRIES(inp_prgname) = 1 THEN DO:
    FIND FIRST tt2 NO-LOCK NO-ERROR.
    RUN xxpro-run (INPUT tt2_prg).
END.
ELSE DO:
    DEFINE VARIABLE hwindow1 AS HANDLE.
    DEFINE VARIABLE hwindow2 AS HANDLE.

    hwindow2 = CURRENT-WINDOW.
    CREATE WINDOW hwindow1  
        ASSIGN X                  = 200
               Y                  = 250
         HEIGHT             = 7
         WIDTH              = 40
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
         HIDDEN             = NO         
         SENSITIVE          = yes
         TITLE              = IF global_user_lang = "CH" THEN "ÇëÑ¡Ôñ¹¦ÄÜ..." ELSE "Please select the function..."
        .

    CURRENT-WINDOW = hwindow1.

    RUN xxpro-view.

    APPLY "WINDOW-CLOSE" TO hwindow1.
    CURRENT-WINDOW = hwindow2.
    DELETE OBJECT hwindow1.

END.




PROCEDURE xxpro-view:
    DEFINE QUERY q1 FOR tt2 SCROLLING.

    DEFINE BROWSE b1 QUERY q1 
         DISPLAY tt2_label
         WITH 
        6 DOWN 
        WIDTH 40
        SEPARATORS 
        NO-ROW-MARKERS 
        ROW-HEIGHT-PIXELS 15
        FONT 21.

    DEFINE FRAME f-prg
        b1             
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 40 BY 7.



    ON DEFAULT-ACTION OF b1 DO:
        FIND CURRENT tt2.
        RUN xxpro-run (INPUT tt2_prg).
    END.

    OPEN QUERY q1 FOR EACH tt2.

    ENABLE b1 WITH FRAME f-prg.

    WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.

    /*WAIT-FOR CLOSE OF THIS-PROCEDURE.
    HIDE FRAME f-prg NO-PAUSE.
    APPLY "WINDOW-CLOSE" TO hwindow1.
    CURRENT-WINDOW = hwindow2.
    DELETE OBJECT hwindow1.*/
END.

PROCEDURE xxpro-run:
    DEF INPUT PARAMETER p_prg AS CHARACTER.
    IF p_prg = "" THEN LEAVE.
    RUN value(lc(global_user_lang) + "\yy\" + p_prg) (INPUT inp_prgvalue).
END.



