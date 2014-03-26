&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases
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
{xxpcld.i "new"}
/* {src/adm2/widgetprto.i} */

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
&Scoped-define INTERNAL-TABLES xxtmppc

/* Definitions for BROWSE brList                                        */
&Scoped-define FIELDS-IN-QUERY-brList xxpc_list xxpc_part xxpc_curr xxpc_um xxpc_start xxpc_expir xxpc_type xxpc_min_qty xxpc_amt xxpc_chk
&Scoped-define ENABLED-FIELDS-IN-QUERY-brList
&Scoped-define SELF-NAME brList
&Scoped-define QUERY-STRING-brList FOR EACH xxtmppc
&Scoped-define OPEN-QUERY-brList OPEN QUERY {&SELF-NAME} FOR EACH xxtmppc.
&Scoped-define TABLES-IN-QUERY-brList xxtmppc
&Scoped-define FIRST-TABLE-IN-QUERY-brList xxtmppc


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-brList}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brList fiFile btnOpen btnExp btnLoad
&Scoped-Define DISPLAYED-OBJECTS fiFile

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnExp
     LABEL "���"
     SIZE 15 BY 1.14.

DEFINE BUTTON btnLoad
     LABEL "װ��"
     SIZE 15 BY 1.14.

DEFINE BUTTON btnOpen
     LABEL "���..."
     SIZE 15 BY 1.14.

DEFINE VARIABLE fiFile AS CHARACTER FORMAT "X(256)":U
     LABEL "�ļ���"
     VIEW-AS FILL-IN
     SIZE 31 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brList FOR
      xxtmppc SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brList
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brList wWin _FREEFORM
  QUERY brList DISPLAY
      xxpc_list    column-label "�ɹ�/Э��۸񵥺�"
      xxpc_part    column-label "�������"
      xxpc_curr    column-label "����"
      xxpc_um      column-label "������λ"
      xxpc_start   column-label "��ʼ����"
      xxpc_expir   column-label "��������"
      xxpc_type    column-label "����(L/P)"
      xxpc_min_qty column-label "��С��"
      xxpc_amt     column-label "����"
      xxpc_chk     column-label "���"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS NO-TAB-STOP SIZE 103 BY 20.18 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     brList AT ROW 3.59 COL 1.89
     fiFile AT ROW 2.18 COL 7.33 COLON-ALIGNED
     btnOpen AT ROW 2.09 COL 43.56
     btnExp AT ROW 2.09 COL 64.56
     btnLoad AT ROW 2.09 COL 84.89
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 104.67 BY 23.


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
         TITLE              = "�ɹ��۸��װ��"
         HEIGHT             = 23
         WIDTH              = 104.67
         MAX-HEIGHT         = 30.95
         MAX-WIDTH          = 151.11
         VIRTUAL-HEIGHT     = 30.95
         VIRTUAL-WIDTH      = 151.11
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = yes
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME L-To-R,COLUMNS                                            */
/* BROWSE-TAB brList 1 fMain */
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
OPEN QUERY {&SELF-NAME} FOR EACH xxtmppc.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brList */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* �ɹ��۸��װ�� */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* �ɹ��۸��װ�� */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-RESIZED OF wWin /* �ɹ��۸��װ�� */
DO:
      FRAME fMain:WIDTH = wwin:WIDTH NO-ERROR.
      FRAME fMain:VIRTUAL-WIDTH-CHARS = wwin:WIDTH NO-ERROR.
      brlist:WIDTH = wwin:WIDTH - 2 NO-ERROR.
      FRAME fMain:HEIGHT= wwin:HEIGHT NO-ERROR.
      FRAME fMain:VIRTUAL-HEIGHT-CHARS = wwin:HEIGHT NO-ERROR.
      brlist:HEIGHT = wwin:HEIGHT - 3.2 NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnExp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnExp wWin
ON CHOOSE OF btnExp IN FRAME fMain /* ��� */
DO:
  {gprun.i ""xxpcld2.p""}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnLoad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnLoad wWin
ON CHOOSE OF btnLoad IN FRAME fMain /* װ�� */
DO:
  SESSION:SET-WAIT-STATE("GENERAL").
  if not can-find(first xxtmppc) then do:
     message "����Ҫװ������ϣ���ȷ������" view-as alert-box error title "���ϴ���".
  end.
  find first xxtmppc no-lock where xxpc_chk <> "" no-error.
  if available xxtmppc then do:
       message "���ϼ�鷢�ִ�����ȷ������" view-as alert-box error title "���ϴ���".
  end.
  {gprun.i ""xxpcld3.p""}
  OPEN QUERY brList FOR EACH xxtmppc.
  brlist:REFRESH() NO-ERROR.
  SESSION:SET-WAIT-STAT("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnOpen wWin
ON CHOOSE OF btnOpen IN FRAME fMain /* ���... */
DO:
  DEFINE VARIABLE vfile AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE selet AS LOGICAL INITIAL TRUE.
  SYSTEM-DIALOG GET-FILE vfile
            TITLE      "��ѡ�����ļ�..."
            FILTERS    "Excel�ļ�(*.xls)" "*.xls"
            MUST-EXIST
        USE-FILENAME
        UPDATE selet.
    ASSIGN fiFile:SCREEN-VALUE = vfile.
    ASSIGN fifile.
    SESSION:SET-WAIT-STAT("GENERAL").
    if search(fifile) <> ? then do:
       if selet then do:
          {gprun.i ""xxpcld1.p""}
          OPEN QUERY brList FOR EACH xxtmppc.
          if can-find(first xxtmppc) then brlist:REFRESH() NO-ERROR.
       end.
    end.
    SESSION:SET-WAIT-STAT("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFile wWin
ON RETURN OF fiFile IN FRAME fMain /* �ļ��� */
DO:
   ASSIGN fiFile.
   IF SEARCH(fiFile) = ? THEN DO:
       APPLY "choose" TO btnopen.
   END.
  SESSION:SET-WAIT-STAT("GENERAL").
  assign fifile.
  if search(fifile) <> ? then do:
  for each xxtmppc exclusive-lock: delete xxtmppc. end.
     {gprun.i ""xxpcld0.p"" "(input fiFile)" }
     {gprun.i ""xxpcld1.p""}
      wkfllook:
      do transaction on stop undo wkfllook,leave wkfllook:
          FIND FIRST usrw_wkfl EXCLUSIVE-LOCK WHERE usrw_domain = GLOBAL_domain AND usrw_key1 = GLOBAL_userid
                 AND usrw_key2 = execname NO-ERROR.
          IF NOT AVAILABLE usrw_wkfl THEN DO:
              CREATE usrw_wkfl. usrw_domain = GLOBAL_domain.
              ASSIGN usrw_key1 = GLOBAL_userid
                     usrw_key2 = execname.
          END.
          ASSIGN usrw_key3 = fifile WHEN usrw_key3 <> fifile no-error.
          release usrw_wkfl.
      END.
   end.
   OPEN QUERY brList FOR EACH xxtmppc.
   brlist:REFRESH() NO-ERROR.
   SESSION:SET-WAIT-STAT("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brList
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
SESSION:SET-WAIT-STATE("").
ASSIGN execname = "xxpcld.p".
FIND FIRST usrw_wkfl NO-LOCK WHERE usrw_domain = GLOBAL_domain AND usrw_key1 = GLOBAL_userid
              AND usrw_key2 = execname NO-ERROR.
IF AVAILABLE usrw_wkfl THEN DO:
    fifile:SCREEN-VALUE = usrw_key3 .
    ASSIGN fifile.
END.

wwin:TITLE = execname.
FIND FIRST mnd_det NO-LOCK WHERE mnd_exec = execname NO-ERROR.
IF AVAILABLE mnd_det THEN DO:
    FIND FIRST mnt_det NO-LOCK WHERE mnt_select = mnd_select AND mnt_nbr = mnd_nbr AND mnt_lang = GLOBAL_user_lang NO-ERROR.
    IF AVAILABLE mnt_det THEN DO:
        ASSIGN wwin:TITLE = mnt_nbr + "." + trim(STRING(mnt_select)) + "-" + mnt_label + "(" + execname + ")".
    END.
END.

{src/adm2/windowmn.i}

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
  DISPLAY fiFile
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE brList fiFile btnOpen btnExp btnLoad
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
  RETURN  NO-APPLY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

