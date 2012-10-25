&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME c-win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS c-win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.
/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
{mfdeclre.i} /*GUI moved to top.*/      
{gplabel.i} 
/* EXTERNAL LABEL INCLUDE *//* Local Variable Definitions ---                                       */

DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE hTempTable.
DEFINE INPUT PARAMETER inp_key       AS CHARACTER.
DEFINE INPUT PARAMETER inp_where     AS CHARACTER.
DEFINE INPUT PARAMETER inp_sortby    AS CHARACTER.
DEFINE INPUT PARAMETER inp_bwstitle  AS CHARACTER.
DEFINE INPUT PARAMETER inp_prgfld    AS CHARACTER.
DEFINE INPUT PARAMETER inp_prgname   AS CHARACTER.
DEFINE INPUT PARAMETER inp_prglabel  AS CHARACTER.
DEFINE INPUT PARAMETER inp_modfld    AS CHARACTER.
DEFINE INPUT PARAMETER inp_user1     AS CHARACTER.
DEFINE INPUT PARAMETER inp_user2     AS CHARACTER.  /*for count warning*/
DEFINE INPUT PARAMETER inp_user3     AS CHARACTER.  /*for color*/


DEFINE VARIABLE bh AS HANDLE NO-UNDO.
DEFINE VARIABLE bf AS HANDLE NO-UNDO.
DEFINE VARIABLE hq AS HANDLE NO-UNDO.
DEFINE VARIABLE iCounter AS INTEGER NO-UNDO.
DEFINE VARIABLE hBrowse  AS HANDLE NO-UNDO.
DEFINE VARIABLE hbutton1 AS HANDLE NO-UNDO.
DEFINE VARIABLE hbutton2 AS HANDLE NO-UNDO.
DEFINE VARIABLE hbutton3 AS HANDLE NO-UNDO.
DEFINE VARIABLE hbutton4 AS HANDLE NO-UNDO.

/* Browse Column Handle */
DEFINE VARIABLE bcHandle AS HANDLE NO-UNDO.
DEFINE VARIABLE qrString AS CHARACTER FORMAT "x(256)" NO-UNDO.
DEFINE VARIABLE h-col    AS WIDGET-HANDLE.

DEFINE VARIABLE v_label        AS CHAR.
DEFINE VARIABLE v_format       AS CHAR.
DEF    VAR      v_list AS CHAR INITIAL "".
DEFINE VARIABLE v_colorflag AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE v_ascDesc AS CHARACTER NO-UNDO.


DEFINE VARIABLE hwindow1 AS HANDLE.
DEFINE VARIABLE hwindow2 AS HANDLE.


/**/
DEFINE TEMP-TABLE ttx 
    FIELDS ttx_type  AS CHAR
    FIELDS ttx_seq   AS INTEGER
    FIELDS ttx_name  AS CHAR
    FIELDS ttx_ref AS CHAR.


DEFINE VAR   v_genhan_chk AS LOGICAL NO-UNDO.
v_genhan_chk = NO.
RUN xxpro-genhan (OUTPUT v_genhan_chk).   
IF v_genhan_chk = NO THEN LEAVE.

RUN xxpro-initial.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR c-win AS WIDGET-HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 26.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW c-win ASSIGN
         HIDDEN             = YES
         TITLE              = "数据浏览"
         HEIGHT             = 38
         WIDTH              = 148
         MAX-HEIGHT         = 38
         MAX-WIDTH          = 148
         VIRTUAL-HEIGHT     = 38
         VIRTUAL-WIDTH      = 148
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW c-win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(c-win)
THEN c-win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-win c-win
ON END-ERROR OF c-win /* Browse Window */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

ON ENTRY OF C-Win /* <insert window title> */
DO:
  APPLY "WINDOW-RESIZED" TO c-win.
END.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-win c-win
ON WINDOW-CLOSE OF c-win /* Browse Window */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


ON WINDOW-RESIZED OF c-win 
DO:
  FRAME DEFAULT-FRAME:WIDTH = c-win:WIDTH NO-ERROR.
  FRAME DEFAULT-FRAME:VIRTUAL-WIDTH-CHARS = c-win:WIDTH NO-ERROR.
  hBrowse:WIDTH = c-win:WIDTH - 0.4 NO-ERROR.
  FRAME DEFAULT-FRAME:HEIGHT= c-win:HEIGHT NO-ERROR.
  FRAME DEFAULT-FRAME:VIRTUAL-HEIGHT-CHARS = c-win:HEIGHT NO-ERROR.
  hBrowse:HEIGHT = c-win:HEIGHT - 1.64 NO-ERROR.
END.

&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK c-win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.



bh = hTempTable:DEFAULT-BUFFER-HANDLE.
RUN value(lc(global_user_lang) + "\yy\yyut2setup.p") (INPUT TABLE-HANDLE hTempTable, INPUT inp_key, INPUT NO, OUTPUT v_list).        
qrString = "FOR EACH " + hTempTable:NAME + " no-lock " + inp_where + " " + inp_sortby.
CREATE QUERY hq.
hq:SET-BUFFERS(bh).
hq:QUERY-PREPARE(qrstring).
hq:QUERY-OPEN.

CREATE BUTTON hbutton1
    ASSIGN X         = 1
           Y         = 1
           WIDTH     = 10
           FRAME     = FRAME DEFAULT-FRAME:handle
           SENSITIVE = TRUE
           LABEL     = IF global_user_lang = "CH" THEN "配置" ELSE "CONFIG"
           FONT      = 21
    TRIGGERS:
        ON CHOOSE
        DO:
            RUN value(lc(global_user_lang) + "\yy\yyut2setup.p") (INPUT TABLE-HANDLE hTempTable, INPUT inp_key, INPUT yes, OUTPUT v_list).      
            DO icounter = 1 TO hbrowse:NUM-COLUMNS:
                bf = hbrowse:GET-BROWSE-COLUMN(icounter).
                IF LOOKUP(STRING(iCounter), v_list) <> 0 THEN DO:
                    bf:VISIBLE = TRUE.
                    FIND FIRST ttx WHERE ttx_type = "mod-field" AND ttx_name = bf:NAME NO-LOCK NO-ERROR.
                    IF AVAILABLE ttx THEN bf:READ-ONLY = FALSE.
                    ELSE bf:READ-ONLY = TRUE.
                END.
                ELSE DO: 
                    bf:VISIBLE = FALSE.
                    bf:READ-ONLY = TRUE.
                END.
            END.
        END.
    END TRIGGERS.


CREATE BUTTON hbutton2
    ASSIGN X         = 120
           Y         = 1
           WIDTH     = 10
           FRAME     = FRAME DEFAULT-FRAME:handle
           SENSITIVE = TRUE
           LABEL     = IF global_user_lang = "CH" THEN "输出到EXCEL" ELSE "EXCEL"
           FONT      = 21
    TRIGGERS:
        ON CHOOSE
        DO:
            IF inp_user2 <> "" THEN DO:
                IF INTEGER(entry(1,inp_user2)) > INTEGER(entry(2,inp_user2)) THEN DO:
                    MESSAGE "你要输出的数据行超过" + entry(2,inp_user2) + ",生成EXCEL文件的时间长,继续吗?"
                    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE v_morelines AS LOGICAL.
                    IF v_morelines = NO THEN LEAVE.
                END.
            END.
            RUN value(lc(global_user_lang) + "\yy\yyut2excel.p") (INPUT TABLE-HANDLE hTempTable, INPUT inp_where, INPUT inp_sortby, INPUT v_list, INPUT inp_bwstitle).        
        END.
    END TRIGGERS.

CREATE BUTTON hbutton3
    ASSIGN X         = 240
           Y         = 1
           WIDTH     = 10
           FRAME     = FRAME DEFAULT-FRAME:handle
           SENSITIVE = TRUE
           LABEL     = IF global_user_lang = "CH" THEN "打印" ELSE "PRINT"
           FONT      = 21
    TRIGGERS:
        ON CHOOSE
        DO:
            RUN value(lc(global_user_lang) + "\yy\yyut2print.p") (INPUT TABLE-HANDLE hTempTable, INPUT inp_where, INPUT inp_sortby, INPUT v_list, INPUT inp_bwstitle).        
        END.
    END TRIGGERS.
/*
CREATE BUTTON hbutton4
    ASSIGN X         = 360
           Y         = 1
           WIDTH     = 10
           FRAME     = FRAME DEFAULT-FRAME:handle
           SENSITIVE = TRUE
            LABEL     = IF global_user_lang = "CH" THEN "打印" ELSE "PRINT"
           FONT      = 21
    TRIGGERS:
        ON CHOOSE
        DO:
            RUN value(lc(global_user_lang) + "\xx\xxut2print.p") (INPUT TABLE-HANDLE hTempTable, INPUT inp_where, INPUT inp_sortby, INPUT v_list, INPUT inp_bwstitle).        
        END.
    END TRIGGERS.
*/

CREATE BROWSE hBrowse
    ASSIGN X         = 1
           Y         = 25
           WIDTH     = 147
           DOWN      = 33
           QUERY     = hq
           FRAME     = FRAME DEFAULT-FRAME:HANDLE
           READ-ONLY = FALSE
           SENSITIVE = TRUE
           SEPARATORS = TRUE
           ROW-HEIGHT-PIXELS = 16 
           READ-ONLY  = FALSE
           /*COLUMN-RESIZABLE = YES*/
           /*COLUMN-MOVABLE = YES*/
           FONT      = 21
    TRIGGERS:
        ON START-SEARCH DO:
            ASSIGN qrString = ""
                   bcHandle = hBrowse:CURRENT-COLUMN.

            IF v_ascDesc = " DESCENDING " THEN ASSIGN v_ascDesc = "". 
            ELSE ASSIGN v_ascDesc = " DESCENDING ".
            INP_SORTBY = "BY " + BCHANDLE:NAME + v_ascDesc.
            qrString = "FOR EACH " + hTempTable:NAME + " no-lock " + inp_where + " " + inp_sortby.
            hq:QUERY-PREPARE(qrstring).
            hq:QUERY-OPEN.
        END.
        on 'DEFAULT-ACTION':U PERSISTENT RUN xxpro-select. 
        ON 'ROW-LEAVE':U PERSISTENT RUN xxpro-update.
        ON 'ROW-DISPLAY':U PERSISTENT RUN xxpro-rowDisplay /*IN THIS-PROCEDURE*/ .

    END TRIGGERS.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.


DO iCounter = 1 TO bh:NUM-FIELDS:
    bf = bh:BUFFER-FIELD(iCounter).
    hBrowse:ADD-LIKE-COLUMN(bf).
END.
DO icounter = 1 TO hbrowse:NUM-COLUMNS:
    bf = hbrowse:GET-BROWSE-COLUMN(icounter).
    v_label = bf:LABEL.
    bf:LABEL = gettermlabel(v_label,20).
    IF LOOKUP(STRING(iCounter), v_list) <> 0 THEN DO:
        bf:VISIBLE = TRUE.
        FIND FIRST ttx WHERE ttx_type = "mod-field" AND ttx_name = bf:NAME NO-LOCK NO-ERROR.
        IF AVAILABLE ttx THEN bf:READ-ONLY = FALSE.
        ELSE bf:READ-ONLY = TRUE.
    END.
    ELSE DO: 
        bf:VISIBLE = FALSE.
        bf:READ-ONLY = TRUE.
    END.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI c-win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(c-win)
  THEN DELETE WIDGET c-win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI c-win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  VIEW FRAME DEFAULT-FRAME IN WINDOW c-win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW c-win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE xxpro-genhan c-win 
PROCEDURE xxpro-genhan :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAMETER p_outresult AS LOGICAL.
    DEF VAR v_genhanlic AS CHAR EXTENT 6.
    DEF VAR v_genhankey AS CHAR.
    DEF VAR v_genhanflag AS CHAR.
    DEF VAR v_customlic AS CHAR.
    DEF VAR v_genhanchk AS CHAR.

    p_outresult = YES.
/*
    FIND FIRST pin_mstr WHERE pin_product = "MFG/PRO" NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pin_mstr THEN LEAVE.

    FIND FIRST usrw_wkfl WHERE usrw_domain = global_domain and usrw_key1 = "ghtools" AND usrw_key2 = "001" NO-LOCK NO-ERROR.
    IF AVAILABLE usrw_wkfl and usrw_user1 <> "" THEN v_genhanflag = usrw_user1.
    ELSE LEAVE.
    FIND FIRST qad_wkfl WHERE qad_domain = global_domain and qad_key1 = "ghtools" AND qad_key2 = "001" NO-LOCK NO-ERROR.
    IF AVAILABLE qad_wkfl AND qad_user1 <> "" THEN v_customlic = qad_user1.
    ELSE LEAVE.

    v_genhanflag  = "Welcome".
    v_genhankey   = "QiSongZou@DeLinJian#Jian$xxut2".
    v_genhanlic[1] = pin_control1 + substring(v_genhankey,1,5).
    v_genhanlic[2] = pin_control2 + substring(v_genhankey,6,5). 
    v_genhanlic[3] = pin_control3 + substring(v_genhankey,11,5).
    v_genhanlic[4] = pin_control4 + substring(v_genhankey,16,5). 
    v_genhanlic[5] = pin_control5 + substring(v_genhankey,21,5). 
    v_genhanlic[6] = pin_control6 + substring(v_genhankey,25,5).

    v_genhanchk   = ENCODE(v_genhanlic[1] + v_genhanlic[2] + 
                           v_genhanlic[3] + v_genhanlic[4] + 
                           v_genhanlic[5] + v_genhanlic[6]) 
                  + substring(ENCODE(v_genhanlic[1] + v_genhanlic[2]),1,8).

    IF v_genhanchk = v_customlic THEN p_outresult = YES.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE xxpro-initial c-win 
PROCEDURE xxpro-initial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR i AS INTEGER.
    FOR EACH ttx:
        DELETE ttx.
    END.
    /*prg-field*/
    IF inp_prgfld <> "" THEN DO:
        DO i = 1 TO NUM-ENTRIES(inp_prgfld):
            CREATE ttx.
            ASSIGN ttx_type = "prg-field"
                   ttx_seq = i
                   ttx_name = ENTRY(i, inp_prgfld).
        END.
    END.
    /*prg-name*/
    IF inp_prgname <> "" THEN DO:
        DO i = 1 TO NUM-ENTRIES(inp_prgname):
            CREATE ttx.
            ASSIGN ttx_type = "prg-name"
                   ttx_seq = i
                   ttx_name = ENTRY(i, inp_prgname).
        END.
    END.
    /*prg-label*/
    IF inp_prglabel <> "" THEN DO:
        DO i = 1 TO NUM-ENTRIES(inp_prgname):
            CREATE ttx.
            ASSIGN ttx_type = "prg-label"
                   ttx_seq = i
                   ttx_name = ENTRY(i, inp_prglabel).
        END.
    END.
    /*mod-field*/
    IF inp_modfld <> "" THEN DO:
        DO i = 1 TO NUM-ENTRIES(inp_modfld):
            CREATE ttx.
            ASSIGN ttx_type = "mod-field"
                   ttx_seq = i
                   ttx_name = ENTRY(i, inp_modfld).
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE xxpro-select c-win 
PROCEDURE xxpro-select :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR v_prgvalue AS CHAR.
    DEFINE VAR v_prgfield AS CHAR.
    DEFINE VARIABLE iNumColumns AS INTEGER NO-UNDO. 
    DEFINE VARIABLE brws-col-hdl AS WIDGET-HANDLE NO-UNDO. 
    DEFINE VARIABLE buff-field-hdl AS WIDGET-HANDLE NO-UNDO. 

    v_prgvalue = "".
    IF inp_prgfld = "" THEN LEAVE.
    IF inp_prgname = "" THEN LEAVE.

    REPEAT iNumColumns = 1 TO hbrowse:NUM-COLUMNS: 
        brws-col-hdl = hbrowse:GET-BROWSE-COLUMN(iNumColumns).
        buff-field-hdl = brws-col-hdl:BUFFER-FIELD. 

        /*brws-col-hdl:SCREEN-VALUE. */
        hq:GET-CURRENT(NO-LOCK). 
        /*brws-col-hdl:BUFFER-FIELD:BUFFER-VALUE*/
        v_prgfield = buff-field-hdl:NAME.
        FIND FIRST ttx WHERE ttx_type = "prg-field" AND ttx_name = v_prgfield NO-ERROR.
        IF AVAILABLE ttx THEN do:
            ASSIGN ttx_ref = buff-field-hdl:BUFFER-VALUE.
        END.
    END.
    v_prgvalue = "".
    FOR EACH ttx WHERE ttx_type = "prg-field" BY ttx_seq:
        v_prgvalue = v_prgvalue + "|" + ttx_ref.
    END.
    IF v_prgvalue <> "" THEN v_prgvalue = SUBSTRING(v_prgvalue,2).
    RUN value(lc(global_user_lang) + "\yy\yyut2subprc.p") (INPUT v_prgvalue, INPUT inp_prgname, INPUT inp_prglabel).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE xxpro-update c-win 
PROCEDURE xxpro-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iNumColumns AS INTEGER NO-UNDO. 
    DEFINE VARIABLE brws-col-hdl AS WIDGET-HANDLE NO-UNDO. 
    DEFINE VARIABLE buff-field-hdl AS WIDGET-HANDLE NO-UNDO. 

    IF inp_modfld = "" THEN LEAVE.

    IF hbrowse:CURRENT-ROW-MODIFIED 
    THEN DO: 
        REPEAT iNumColumns = 1 TO hbrowse:NUM-COLUMNS: 
            brws-col-hdl = hbrowse:GET-BROWSE-COLUMN(iNumColumns).
            buff-field-hdl = brws-col-hdl:BUFFER-FIELD. 
            FIND FIRST ttx WHERE ttx_type = "mod-field" AND ttx_name = buff-field-hdl:NAME NO-LOCK NO-ERROR.
            IF AVAILABLE ttx THEN DO:
                IF brws-col-hdl:MODIFIED
                THEN DO:
                    DO TRANSACTION:
                        hq:GET-CURRENT(EXCLUSIVE-LOCK).
                        IF buff-field-hdl NE ? THEN buff-field-hdl:BUFFER-VALUE = brws-col-hdl:SCREEN-VALUE.
                        /*RETURN NOT ERROR-STATUS:ERROR.*/
                        bh:BUFFER-RELEASE().
                        hBrowse:REFRESH().
                    END.
                END.
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE xxpro-rowDisplay c-win 
PROCEDURE xxpro-rowDisplay :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*    DEFINE VARIABLE iNumColumns AS INTEGER NO-UNDO. 
    DEFINE VARIABLE iBGColor AS INTEGER NO-UNDO.
    DEFINE VARIABLE iFGColor AS INTEGER NO-UNDO.
    DEFINE VARIABLE brws-col-hdl AS WIDGET-HANDLE NO-UNDO. 
    IF inp_user3 = "" THEN LEAVE.

    IF v_colorflag THEN
    ASSIGN
      iBGColor = 8  /* Set the background color grey */
      iFGColor = 0  /* and foreground color black */
    .
    ELSE
    ASSIGN
      iBGColor = 15 /* else background color white */
      iFGColor = 0  /* and foreground color black */
    .

    REPEAT iNumColumns = 1 TO hbrowse:NUM-COLUMNS: 
        brws-col-hdl = hbrowse:GET-BROWSE-COLUMN(iNumColumns).

        IF VALID-HANDLE(brws-col-hdl) THEN
        DO:
            brws-col-hdl:BGCOLOR = iBGColor. /* Set the cell's background color */
            brws-col-hdl:FGCOLOR = iFGColor. /* and it's foreground color */
        END.
    END.
    v_colorflag = NOT v_colorflag. /* Set the toggle opposite */
*/    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

