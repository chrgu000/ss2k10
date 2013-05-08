&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases
          qaddb            PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin
/*------------------------------------------------------------------------

  File:

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{mfdeclre.i}
ASSIGN execname = "xxpodiq.p".
{src/adm2/widgetprto.i}
DEFINE VARIABLE vkey1 AS CHARACTER INITIAL "Trace_pod__chr01".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME brList

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES usrw_wkfl

/* Definitions for BROWSE brList                                        */
&Scoped-define FIELDS-IN-QUERY-brList usrw_key3 usrw_key4 usrw_key5 usrw_key6 usrw_charfld[1] usrw_charfld[2] usrw_charfld[3] usrw_charfld[5] usrw_charfld[6] usrw_charfld[7] usrw_charfld[8] usrw_datefld[2] usrw_charfld[10] usrw_datefld[1] string(usrw_intfld[1],"hh:mm:ss") usrw_charfld[4] usrw_charfld[15]
&Scoped-define ENABLED-FIELDS-IN-QUERY-brList
&Scoped-define SELF-NAME brList
&Scoped-define QUERY-STRING-brList FOR EACH usrw_wkfl NO-LOCK WHERE usrw_domain = GLOBAL_domain AND usrw_key1 = vkey1 BY usrw_datefld[1] DESC BY usrw_intfld[1] DESC
&Scoped-define OPEN-QUERY-brList OPEN QUERY {&SELF-NAME} FOR EACH usrw_wkfl NO-LOCK WHERE usrw_domain = GLOBAL_domain AND usrw_key1 = vkey1 BY usrw_datefld[1] DESC BY usrw_intfld[1] DESC.
&Scoped-define TABLES-IN-QUERY-brList usrw_wkfl
&Scoped-define FIRST-TABLE-IN-QUERY-brList usrw_wkfl


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-brList}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS finbr fiLine btnQuery brList
&Scoped-Define DISPLAYED-OBJECTS finbr fiLine

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnQuery
     LABEL "查询"
     SIZE 15 BY 1.14.

DEFINE VARIABLE fiLine AS CHARACTER FORMAT "X(4)":U
     LABEL "项次"
     VIEW-AS FILL-IN
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE finbr AS CHARACTER FORMAT "X(8)":U
     LABEL "采购单号"
     VIEW-AS FILL-IN
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brList FOR
      usrw_wkfl SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brList wWin _FREEFORM
  QUERY brList DISPLAY
      usrw_key3                          column-label "采购单" format "x(8)"
        usrw_key4                          column-label "项次" format "x(4)"
        usrw_key5                          column-label "料号" FORMAT "x(18)"
        usrw_key6                          column-label "地点"
        usrw_charfld[1]                    column-label "改为" format "x(4)"
        usrw_charfld[2]                    column-label "改前" format "x(4)"
        usrw_charfld[3]                    column-label "执行程序" FORMAT "x(14)"
        usrw_charfld[5]                    column-label "OS用户"
        usrw_charfld[6]                    column-label "用户ID"
        usrw_charfld[7]                    column-label "终端名称" FORMAT "x(14)"
        usrw_charfld[8]                    column-label "界面"  FORMAT "x(8)"
        usrw_datefld[2]                    column-label "开始日期"
        usrw_charfld[10]                   column-label "监控程序" FORMAT "x(14)"
        usrw_datefld[1]                    column-label "修改日期"
        string(usrw_intfld[1],"hh:mm:ss")  column-label "修改时间"
        usrw_charfld[4]                    column-label "临时用户"
        usrw_charfld[15]                   column-label "程序调用" FORMAT "x(600)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 98 BY 20.18 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     finbr AT ROW 1.82 COL 11 COLON-ALIGNED WIDGET-ID 2
     fiLine AT ROW 1.82 COL 37 COLON-ALIGNED WIDGET-ID 4
     btnQuery AT ROW 1.82 COL 61 WIDGET-ID 6
     brList AT ROW 3.18 COL 1 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 98.11 BY 22.73 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "xxpodiq.p(pod__chr01变更记录)"
         HEIGHT             = 22.73
         WIDTH              = 98.11
         MAX-HEIGHT         = 28.82
         MAX-WIDTH          = 146.22
         VIRTUAL-HEIGHT     = 28.82
         VIRTUAL-WIDTH      = 146.22
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin
/* ************************* Included-Libraries *********************** */


FIND FIRST mnd_det NO-LOCK WHERE mnd_exec = execname NO-ERROR.
IF AVAILABLE mnd_det THEN DO:
   FIND FIRST mnt_det NO-LOCK WHERE mnt_nbr = mnd_nbr AND mnt_select = mnd_select
          AND mnt_lang = GLOBAL_user_lang NO-ERROR.
   IF AVAILABLE mnt_det THEN DO:
       wwin:TITLE = mnt_label + "(" + mnt_nbr + "." + STRING(mnt_select)
                  + "-" + execname + ")".
   END.
END.

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* BROWSE-TAB brList btnQuery fMain */
ASSIGN
       brList:COLUMN-RESIZABLE IN FRAME fMain       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brList
/* Query rebuild information for BROWSE brList
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH usrw_wkfl NO-LOCK WHERE usrw_domain = GLOBAL_domain AND usrw_key1 = vkey1 BY usrw_datefld[1] DESC BY usrw_intfld[1] DESC.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brList */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* xxpodiq.p(pod__chr01变更记录) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* xxpodiq.p(pod__chr01变更记录) */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-RESIZED OF wWin /* xxpodiq.p(pod__chr01变更记录) */
DO:
      FRAME fMain:WIDTH = wwin:WIDTH NO-ERROR.
      FRAME fMain:VIRTUAL-WIDTH-CHARS = wwin:WIDTH NO-ERROR.
      brlist:WIDTH = wwin:WIDTH - .4 NO-ERROR.
      FRAME fMain:HEIGHT= wwin:HEIGHT NO-ERROR.
      FRAME fMain:VIRTUAL-HEIGHT-CHARS = wwin:HEIGHT NO-ERROR.
      brlist:HEIGHT = wwin:HEIGHT - 2.4 NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brList
&Scoped-define SELF-NAME brList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brList wWin
ON LEFT-MOUSE-CLICK OF brList IN FRAME fMain
DO:
    DEFINE VARIABLE ibrowse       AS INTEGER NO-UNDO.
  DEFINE VARIABLE method-return AS LOGICAL NO-UNDO.
  DEFINE VARIABLE v AS CHARACTER.
  OPEN QUERY querybrowse1 FOR EACH usrw_wkfl no-lock.
  DO ibrowse = 1 TO  brList:NUM-SELECTED-ROWS IN FRAME fmain :
      method-return = brList:FETCH-SELECTED-ROW(ibrowse).
     ASSIGN finbr:SCREEN-VALUE IN FRAME fmain = usrw_key3.
     ASSIGN finbr.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brList wWin
ON LEFT-MOUSE-DBLCLICK OF brList IN FRAME fMain
DO:
  DEFINE VARIABLE ibrowse       AS INTEGER NO-UNDO.
  DEFINE VARIABLE method-return AS LOGICAL NO-UNDO.
  DEFINE VARIABLE v AS CHARACTER.
  OPEN QUERY querybrowse1 FOR EACH usrw_wkfl no-lock.
  DO ibrowse = 1 TO  brList:NUM-SELECTED-ROWS IN FRAME fmain :
      method-return = brList:FETCH-SELECTED-ROW(ibrowse).
     ASSIGN v = usrw_charfld[15].
     MESSAGE "" REPLACE(v,";",CHR(10)) VIEW-AS ALERT-BOX INFORMATION TITLE "程序调用" .
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnQuery
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnQuery wWin
ON CHOOSE OF btnQuery IN FRAME fMain /* 查询 */
DO:
      DEFINE VARIABLE strSQL AS CHARACTER NO-UNDO.
      DEFINE VARIABLE hQuery AS WIDGET-HANDLE.
      DEFINE VARIABLE i AS INTEGER.
      DEFINE VARIABLE err AS LOGICAL.
      ASSIGN finbr.
      ASSIGN filine.
      hQuery = brList:QUERY.
      strSQL = 'for each usrw_wkfl no-lock where usrw_domain = "' + GLOBAL_domain + '" and usrw_key1 = "' + vkey1 + '" ' .
      IF finbr <> "" THEN DO:
          ASSIGN strSQL = strSQL + 'and usrw_key3 = "' + finbr + '" '.
      END.
      IF filine <> "" THEN DO:
          ASSIGN err  = NO.
           DO i = 1 to length(trim(filine)).
              If index("0987654321", substring(trim(filine),i,1)) = 0 then do:
                 MESSAGE "项次只能填入数字" VIEW-AS ALERT-BOX ERROR.
                 ASSIGN err = YES.
                 ASSIGN filine:SCREEN-VALUE = "".
                 ASSIGN filine.
                 LEAVE.
              end.
           end.
           IF err = NO THEN
          ASSIGN strSQL = strSQL + ' and (integer(trim(usrw_key4) ) = ' + trim(fiLine) + ' or ' + trim(filine) + ' = "") '.
      END.
      ASSIGN strSQL = strSQL + ' by usrw_datefld[1] descending by usrw_intfld[1] descending.'.
      hQuery:QUERY-PREPARE(strSQL) NO-ERROR.
      hQuery:QUERY-OPEN NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

session:SET-WAIT-STAT("").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY finbr fiLine
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE finbr fiLine btnQuery brList
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys
            its contents and itself.
    Notes:
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

